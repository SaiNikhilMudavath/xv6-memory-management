#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "fs.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "buf.h"
#include "x86.h"

#define NSWAP 800
#define FIRST_SWAP_BLOCK 2
#define BLOCKSPERSLOT 8
#define get_block_for_slot(s) (FIRST_SWAP_BLOCK+(s)*BLOCKSPERSLOT)

int alpha=ALPHA; //25
int beta=BETA; //10
int th=100;
int npg=4;
#define SWAP_LIMIT 100
#define min(a,b) a<b ? a:b

struct swappage_t
{
    int page_perm;
    int is_free;
    int pid;
};
struct swappage_t swap_table[NSWAP];
extern struct proc* choose_victim(void);

void init_swap_table()
{
    for(int i=0;i<NSWAP;i++)
    {
        swap_table[i].is_free=1;
        swap_table[i].page_perm=0;
    }
}

int alloc_swap_slot(int pi)
{
    for(int i=0;i<NSWAP;i++)
    {
        if(swap_table[i].is_free==1)
        {
            swap_table[i].is_free=0;
            swap_table[i].pid=pi;
            return i;
        }
    }
    return -1;
}
void free_swap_slot(int slot)
{
    if(slot>-1 && slot<NSWAP)
    {
        swap_table[slot].is_free=1;
        swap_table[slot].page_perm=0;
    }
}

extern int get_free_pages(void);

extern pte_t* proxytowalkpgdir(pde_t*, const void *, int);
int handle_page_swap(void)
{
    // cprintf("entered page swap\n");
    struct proc* p=choose_victim();
    if(!p || p->pid==1) return -1;

    // cprintf("found victim proc with pid %d\n",p->pid);
    pte_t *pte;
    uint va;
    int slot=-1;

    for(va=0;va<p->sz;va+=PGSIZE)
    {
        pte=proxytowalkpgdir(p->pgdir,(void*)va,0);
        if(!pte) continue;
        if((*pte & PTE_P) && !(*pte & PTE_A))
        {
            // cprintf("found a page to swap\n");
            slot=alloc_swap_slot(p->pid);
            if(slot==-1) panic("no free swap slot");

            int b0=get_block_for_slot(slot);
            char* pa=P2V(PTE_ADDR(*pte)); //pa now points to 4KB page in kernel memory
            begin_op();
            for(int i=0;i<BLOCKSPERSLOT;i++)
            {
                struct buf* b=bread(ROOTDEV,b0+i);
                memmove(b->data,pa+i*512,512); //you move 512 bytes starting from pa_i*512
                // cprintf("before log write\n");
                log_write(b);
                brelse(b);
            }
            end_op();
            swap_table[slot].page_perm=(*pte) & (PTE_U|PTE_W);
            //storing the physical address so when page 
            //fault happens then we can use this 
            //and bring the page back to memory.
            *pte = (slot << 12) | swap_table[slot].page_perm; 
            *pte &= ~(PTE_P | PTE_A);
            p->rss--;
            lcr3(V2P(p->pgdir));
            kfree(pa);
            // cprintf("successfully moved to disk\n");
            return 0;
        }
        if((*pte & PTE_P) && (*pte & PTE_A) && ((va/PGSIZE) % 1)==0) *pte &= ~PTE_A;
        // *pte &= ~PTE_A;
    }
    // uint pages_to_unset=(p->sz/PGSIZE)/10;
    // int c=0;
    // for(va=0;va<p->sz && c<pages_to_unset;va+=PGSIZE,c++)
    // {
    //     pte=proxytowalkpgdir(p->pgdir,(void*)va,0);
    //     if(!pte) continue;
    //     if((*pte & PTE_P) && (*pte & PTE_A)) *pte &= ~PTE_A;
    // }

    // for(va=0;va<p->sz;va+=PGSIZE)
    // {
    //     pte=proxytowalkpgdir(p->pgdir,(void*)va,0);
    //     if(!pte) continue;
    //     
    // }

}

void handle_low_mem(void)
{
    int freepg=get_free_pages();
    if(freepg<=th)
    {
        cprintf("Current Threshold = %d, Swapping %d pages\n",th,npg);
        for(int i=0;i<npg;i++)
        {
            int x=handle_page_swap();
            if(x==-1)
            {
                cprintf("breaking ");
                break;
            }
        }
        // cprintf("num free pages is\n");
        th-=(th*beta)/100;
        npg+=(npg*alpha)/100;
        if(npg>=SWAP_LIMIT) npg=SWAP_LIMIT;
    }
    cprintf("free pages after is %d\n",get_free_pages());
}

void handle_page_fault(struct trapframe* tf)
{
    // cprintf("handling page fault\n");
    uint va=rcr2();
    pde_t* pgdir=myproc()->pgdir;
    pde_t* pte=proxytowalkpgdir(pgdir,(void*)va,0);
    if(!pte || (*pte & PTE_P)) panic("page fault on non swapped page");

    int slot=PTE_SLOT(*pte);
    // handle_low_mem();
    char* mem=kalloc();
    if(mem == 0)
    {   
        cprintf("inside mem == 0 in swap\n");
        handle_low_mem();
        mem=kalloc();
        if(mem==0) panic("kalloc failed in swap-in");
    }

    myproc()->rss++;
    int b0=get_block_for_slot(slot);
    for(int i=0;i<BLOCKSPERSLOT;i++)
    {
        struct buf* b=bread(ROOTDEV,b0+i);
        memmove(mem+i*512,b->data,512);
        brelse(b);
    }
    *pte=V2P(mem)|swap_table[slot].page_perm|PTE_P;
    free_swap_slot(slot);
}

int clear_disk_of_proc(int pi)
{
    for(int i=0;i<NSWAP;i++)
    {
        if(swap_table[i].pid==pi)
        {
            swap_table[i].is_free=1;
            swap_table[i].page_perm=0;
            swap_table[i].pid=0;
        }
    }
    return 0;
}