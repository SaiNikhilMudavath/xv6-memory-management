
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc f0 54 11 80       	mov    $0x801154f0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 a0 30 10 80       	mov    $0x801030a0,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 a5 10 80       	mov    $0x8010a554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 40 72 10 80       	push   $0x80107240
80100051:	68 20 a5 10 80       	push   $0x8010a520
80100056:	e8 35 44 00 00       	call   80104490 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c ec 10 80       	mov    $0x8010ec1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec6c
8010006a:	ec 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec70
80100074:	ec 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 47 72 10 80       	push   $0x80107247
80100097:	50                   	push   %eax
80100098:	e8 c3 42 00 00       	call   80104360 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 e9 10 80    	cmp    $0x8010e9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave
801000c2:	c3                   	ret
801000c3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801000ca:	00 
801000cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 a5 10 80       	push   $0x8010a520
801000e4:	e8 97 45 00 00       	call   80104680 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 ec 10 80    	mov    0x8010ec70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c ec 10 80    	mov    0x8010ec6c,%ebx
80100126:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 a5 10 80       	push   $0x8010a520
80100162:	e8 b9 44 00 00       	call   80104620 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 2e 42 00 00       	call   801043a0 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 af 21 00 00       	call   80102340 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 4e 72 10 80       	push   $0x8010724e
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 7d 42 00 00       	call   80104440 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave
  iderw(b);
801001d4:	e9 67 21 00 00       	jmp    80102340 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 5f 72 10 80       	push   $0x8010725f
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801001ed:	00 
801001ee:	66 90                	xchg   %ax,%ax

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 3c 42 00 00       	call   80104440 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 63                	je     8010026e <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 ec 41 00 00       	call   80104400 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010021b:	e8 60 44 00 00       	call   80104680 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2c                	jne    8010025c <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 53 54             	mov    0x54(%ebx),%edx
80100233:	8b 43 50             	mov    0x50(%ebx),%eax
80100236:	89 42 50             	mov    %eax,0x50(%edx)
    b->prev->next = b->next;
80100239:	8b 53 54             	mov    0x54(%ebx),%edx
8010023c:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
8010023f:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
    b->prev = &bcache.head;
80100244:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024b:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
8010024e:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
80100253:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100256:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  }
  
  release(&bcache.lock);
8010025c:	c7 45 08 20 a5 10 80 	movl   $0x8010a520,0x8(%ebp)
}
80100263:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100266:	5b                   	pop    %ebx
80100267:	5e                   	pop    %esi
80100268:	5d                   	pop    %ebp
  release(&bcache.lock);
80100269:	e9 b2 43 00 00       	jmp    80104620 <release>
    panic("brelse");
8010026e:	83 ec 0c             	sub    $0xc,%esp
80100271:	68 66 72 10 80       	push   $0x80107266
80100276:	e8 05 01 00 00       	call   80100380 <panic>
8010027b:	66 90                	xchg   %ax,%ax
8010027d:	66 90                	xchg   %ax,%ax
8010027f:	90                   	nop

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 57 16 00 00       	call   801018f0 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 40 ef 10 80 	movl   $0x8010ef40,(%esp)
801002a0:	e8 db 43 00 00       	call   80104680 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 20 ef 10 80       	mov    0x8010ef20,%eax
801002b5:	39 05 24 ef 10 80    	cmp    %eax,0x8010ef24
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 40 ef 10 80       	push   $0x8010ef40
801002c8:	68 20 ef 10 80       	push   $0x8010ef20
801002cd:	e8 2e 3e 00 00       	call   80104100 <sleep>
    while(input.r == input.w){
801002d2:	a1 20 ef 10 80       	mov    0x8010ef20,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 24 ef 10 80    	cmp    0x8010ef24,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 59 37 00 00       	call   80103a40 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 40 ef 10 80       	push   $0x8010ef40
801002f6:	e8 25 43 00 00       	call   80104620 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 0c 15 00 00       	call   80101810 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 20 ef 10 80    	mov    %edx,0x8010ef20
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a a0 ee 10 80 	movsbl -0x7fef1160(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 40 ef 10 80       	push   $0x8010ef40
8010034c:	e8 cf 42 00 00       	call   80104620 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 b6 14 00 00       	call   80101810 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 20 ef 10 80       	mov    %eax,0x8010ef20
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010037b:	00 
8010037c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli
  cons.locking = 0;
80100389:	c7 05 74 ef 10 80 00 	movl   $0x0,0x8010ef74
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 a2 25 00 00       	call   80102940 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 6d 72 10 80       	push   $0x8010726d
801003a7:	e8 04 03 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 fb 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 38 77 10 80 	movl   $0x80107738,(%esp)
801003bc:	e8 ef 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 e3 40 00 00       	call   801044b0 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 81 72 10 80       	push   $0x80107281
801003dd:	e8 ce 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 78 ef 10 80 01 	movl   $0x1,0x8010ef78
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801003fc:	00 
801003fd:	8d 76 00             	lea    0x0(%esi),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
80100409:	3d 00 01 00 00       	cmp    $0x100,%eax
8010040e:	0f 84 cc 00 00 00    	je     801004e0 <consputc.part.0+0xe0>
    uartputc(c);
80100414:	83 ec 0c             	sub    $0xc,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100417:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010041c:	89 c3                	mov    %eax,%ebx
8010041e:	50                   	push   %eax
8010041f:	e8 6c 59 00 00       	call   80105d90 <uartputc>
80100424:	b8 0e 00 00 00       	mov    $0xe,%eax
80100429:	89 fa                	mov    %edi,%edx
8010042b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042c:	be d5 03 00 00       	mov    $0x3d5,%esi
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100434:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100437:	89 fa                	mov    %edi,%edx
80100439:	b8 0f 00 00 00       	mov    $0xf,%eax
8010043e:	c1 e1 08             	shl    $0x8,%ecx
80100441:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100442:	89 f2                	mov    %esi,%edx
80100444:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100445:	0f b6 c0             	movzbl %al,%eax
  if(c == '\n')
80100448:	83 c4 10             	add    $0x10,%esp
  pos |= inb(CRTPORT+1);
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	75 76                	jne    801004c8 <consputc.part.0+0xc8>
    pos += 80 - pos%80;
80100452:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80100457:	f7 e2                	mul    %edx
80100459:	c1 ea 06             	shr    $0x6,%edx
8010045c:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010045f:	c1 e0 04             	shl    $0x4,%eax
80100462:	8d 70 50             	lea    0x50(%eax),%esi
  if(pos < 0 || pos > 25*80)
80100465:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
8010046b:	0f 8f 2f 01 00 00    	jg     801005a0 <consputc.part.0+0x1a0>
  if((pos/80) >= 24){  // Scroll up.
80100471:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100477:	0f 8f c3 00 00 00    	jg     80100540 <consputc.part.0+0x140>
  outb(CRTPORT+1, pos>>8);
8010047d:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
8010047f:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100486:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100489:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010048c:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100491:	b8 0e 00 00 00       	mov    $0xe,%eax
80100496:	89 da                	mov    %ebx,%edx
80100498:	ee                   	out    %al,(%dx)
80100499:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010049e:	89 f8                	mov    %edi,%eax
801004a0:	89 ca                	mov    %ecx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b8 0f 00 00 00       	mov    $0xf,%eax
801004a8:	89 da                	mov    %ebx,%edx
801004aa:	ee                   	out    %al,(%dx)
801004ab:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004af:	89 ca                	mov    %ecx,%edx
801004b1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004b2:	b8 20 07 00 00       	mov    $0x720,%eax
801004b7:	66 89 06             	mov    %ax,(%esi)
}
801004ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004bd:	5b                   	pop    %ebx
801004be:	5e                   	pop    %esi
801004bf:	5f                   	pop    %edi
801004c0:	5d                   	pop    %ebp
801004c1:	c3                   	ret
801004c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
801004c8:	0f b6 db             	movzbl %bl,%ebx
801004cb:	8d 70 01             	lea    0x1(%eax),%esi
801004ce:	80 cf 07             	or     $0x7,%bh
801004d1:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
801004d8:	80 
801004d9:	eb 8a                	jmp    80100465 <consputc.part.0+0x65>
801004db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e0:	83 ec 0c             	sub    $0xc,%esp
801004e3:	be d4 03 00 00       	mov    $0x3d4,%esi
801004e8:	6a 08                	push   $0x8
801004ea:	e8 a1 58 00 00       	call   80105d90 <uartputc>
801004ef:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f6:	e8 95 58 00 00       	call   80105d90 <uartputc>
801004fb:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100502:	e8 89 58 00 00       	call   80105d90 <uartputc>
80100507:	b8 0e 00 00 00       	mov    $0xe,%eax
8010050c:	89 f2                	mov    %esi,%edx
8010050e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010050f:	bb d5 03 00 00       	mov    $0x3d5,%ebx
80100514:	89 da                	mov    %ebx,%edx
80100516:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100517:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010051a:	89 f2                	mov    %esi,%edx
8010051c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100521:	c1 e1 08             	shl    $0x8,%ecx
80100524:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100525:	89 da                	mov    %ebx,%edx
80100527:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100528:	0f b6 f0             	movzbl %al,%esi
    if(pos > 0) --pos;
8010052b:	83 c4 10             	add    $0x10,%esp
8010052e:	09 ce                	or     %ecx,%esi
80100530:	74 5e                	je     80100590 <consputc.part.0+0x190>
80100532:	83 ee 01             	sub    $0x1,%esi
80100535:	e9 2b ff ff ff       	jmp    80100465 <consputc.part.0+0x65>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 aa 42 00 00       	call   80104810 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 05 42 00 00       	call   80104780 <memset>
  outb(CRTPORT+1, pos);
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 06 ff ff ff       	jmp    8010048c <consputc.part.0+0x8c>
80100586:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010058d:	00 
8010058e:	66 90                	xchg   %ax,%ax
80100590:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
80100594:	be 00 80 0b 80       	mov    $0x800b8000,%esi
80100599:	31 ff                	xor    %edi,%edi
8010059b:	e9 ec fe ff ff       	jmp    8010048c <consputc.part.0+0x8c>
    panic("pos under/overflow");
801005a0:	83 ec 0c             	sub    $0xc,%esp
801005a3:	68 85 72 10 80       	push   $0x80107285
801005a8:	e8 d3 fd ff ff       	call   80100380 <panic>
801005ad:	8d 76 00             	lea    0x0(%esi),%esi

801005b0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005b0:	55                   	push   %ebp
801005b1:	89 e5                	mov    %esp,%ebp
801005b3:	57                   	push   %edi
801005b4:	56                   	push   %esi
801005b5:	53                   	push   %ebx
801005b6:	83 ec 18             	sub    $0x18,%esp
801005b9:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005bc:	ff 75 08             	push   0x8(%ebp)
801005bf:	e8 2c 13 00 00       	call   801018f0 <iunlock>
  acquire(&cons.lock);
801005c4:	c7 04 24 40 ef 10 80 	movl   $0x8010ef40,(%esp)
801005cb:	e8 b0 40 00 00       	call   80104680 <acquire>
  for(i = 0; i < n; i++)
801005d0:	83 c4 10             	add    $0x10,%esp
801005d3:	85 f6                	test   %esi,%esi
801005d5:	7e 25                	jle    801005fc <consolewrite+0x4c>
801005d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005da:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005dd:	8b 15 78 ef 10 80    	mov    0x8010ef78,%edx
    consputc(buf[i] & 0xff);
801005e3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005e6:	85 d2                	test   %edx,%edx
801005e8:	74 06                	je     801005f0 <consolewrite+0x40>
  asm volatile("cli");
801005ea:	fa                   	cli
    for(;;)
801005eb:	eb fe                	jmp    801005eb <consolewrite+0x3b>
801005ed:	8d 76 00             	lea    0x0(%esi),%esi
801005f0:	e8 0b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005f5:	83 c3 01             	add    $0x1,%ebx
801005f8:	39 fb                	cmp    %edi,%ebx
801005fa:	75 e1                	jne    801005dd <consolewrite+0x2d>
  release(&cons.lock);
801005fc:	83 ec 0c             	sub    $0xc,%esp
801005ff:	68 40 ef 10 80       	push   $0x8010ef40
80100604:	e8 17 40 00 00       	call   80104620 <release>
  ilock(ip);
80100609:	58                   	pop    %eax
8010060a:	ff 75 08             	push   0x8(%ebp)
8010060d:	e8 fe 11 00 00       	call   80101810 <ilock>

  return n;
}
80100612:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100615:	89 f0                	mov    %esi,%eax
80100617:	5b                   	pop    %ebx
80100618:	5e                   	pop    %esi
80100619:	5f                   	pop    %edi
8010061a:	5d                   	pop    %ebp
8010061b:	c3                   	ret
8010061c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100620 <printint>:
{
80100620:	55                   	push   %ebp
80100621:	89 e5                	mov    %esp,%ebp
80100623:	57                   	push   %edi
80100624:	56                   	push   %esi
80100625:	53                   	push   %ebx
80100626:	89 d3                	mov    %edx,%ebx
80100628:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010062b:	85 c0                	test   %eax,%eax
8010062d:	79 05                	jns    80100634 <printint+0x14>
8010062f:	83 e1 01             	and    $0x1,%ecx
80100632:	75 64                	jne    80100698 <printint+0x78>
    x = xx;
80100634:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
8010063b:	89 c1                	mov    %eax,%ecx
  i = 0;
8010063d:	31 f6                	xor    %esi,%esi
8010063f:	90                   	nop
    buf[i++] = digits[x % base];
80100640:	89 c8                	mov    %ecx,%eax
80100642:	31 d2                	xor    %edx,%edx
80100644:	89 f7                	mov    %esi,%edi
80100646:	f7 f3                	div    %ebx
80100648:	8d 76 01             	lea    0x1(%esi),%esi
8010064b:	0f b6 92 8c 77 10 80 	movzbl -0x7fef8874(%edx),%edx
80100652:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
80100656:	89 ca                	mov    %ecx,%edx
80100658:	89 c1                	mov    %eax,%ecx
8010065a:	39 da                	cmp    %ebx,%edx
8010065c:	73 e2                	jae    80100640 <printint+0x20>
  if(sign)
8010065e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
80100661:	85 c9                	test   %ecx,%ecx
80100663:	74 07                	je     8010066c <printint+0x4c>
    buf[i++] = '-';
80100665:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
  while(--i >= 0)
8010066a:	89 f7                	mov    %esi,%edi
8010066c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
8010066f:	01 df                	add    %ebx,%edi
  if(panicked){
80100671:	8b 15 78 ef 10 80    	mov    0x8010ef78,%edx
    consputc(buf[i]);
80100677:	0f be 07             	movsbl (%edi),%eax
  if(panicked){
8010067a:	85 d2                	test   %edx,%edx
8010067c:	74 0a                	je     80100688 <printint+0x68>
8010067e:	fa                   	cli
    for(;;)
8010067f:	eb fe                	jmp    8010067f <printint+0x5f>
80100681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100688:	e8 73 fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
8010068d:	8d 47 ff             	lea    -0x1(%edi),%eax
80100690:	39 df                	cmp    %ebx,%edi
80100692:	74 11                	je     801006a5 <printint+0x85>
80100694:	89 c7                	mov    %eax,%edi
80100696:	eb d9                	jmp    80100671 <printint+0x51>
    x = -xx;
80100698:	f7 d8                	neg    %eax
  if(sign && (sign = xx < 0))
8010069a:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
    x = -xx;
801006a1:	89 c1                	mov    %eax,%ecx
801006a3:	eb 98                	jmp    8010063d <printint+0x1d>
}
801006a5:	83 c4 2c             	add    $0x2c,%esp
801006a8:	5b                   	pop    %ebx
801006a9:	5e                   	pop    %esi
801006aa:	5f                   	pop    %edi
801006ab:	5d                   	pop    %ebp
801006ac:	c3                   	ret
801006ad:	8d 76 00             	lea    0x0(%esi),%esi

801006b0 <cprintf>:
{
801006b0:	55                   	push   %ebp
801006b1:	89 e5                	mov    %esp,%ebp
801006b3:	57                   	push   %edi
801006b4:	56                   	push   %esi
801006b5:	53                   	push   %ebx
801006b6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006b9:	8b 3d 74 ef 10 80    	mov    0x8010ef74,%edi
  if (fmt == 0)
801006bf:	8b 75 08             	mov    0x8(%ebp),%esi
  if(locking)
801006c2:	85 ff                	test   %edi,%edi
801006c4:	0f 85 06 01 00 00    	jne    801007d0 <cprintf+0x120>
  if (fmt == 0)
801006ca:	85 f6                	test   %esi,%esi
801006cc:	0f 84 b7 01 00 00    	je     80100889 <cprintf+0x1d9>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006d2:	0f b6 06             	movzbl (%esi),%eax
801006d5:	85 c0                	test   %eax,%eax
801006d7:	74 5f                	je     80100738 <cprintf+0x88>
  argp = (uint*)(void*)(&fmt + 1);
801006d9:	8d 55 0c             	lea    0xc(%ebp),%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006dc:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801006df:	31 db                	xor    %ebx,%ebx
801006e1:	89 d7                	mov    %edx,%edi
    if(c != '%'){
801006e3:	83 f8 25             	cmp    $0x25,%eax
801006e6:	75 58                	jne    80100740 <cprintf+0x90>
    c = fmt[++i] & 0xff;
801006e8:	83 c3 01             	add    $0x1,%ebx
801006eb:	0f b6 0c 1e          	movzbl (%esi,%ebx,1),%ecx
    if(c == 0)
801006ef:	85 c9                	test   %ecx,%ecx
801006f1:	74 3a                	je     8010072d <cprintf+0x7d>
    switch(c){
801006f3:	83 f9 70             	cmp    $0x70,%ecx
801006f6:	0f 84 b4 00 00 00    	je     801007b0 <cprintf+0x100>
801006fc:	7f 72                	jg     80100770 <cprintf+0xc0>
801006fe:	83 f9 25             	cmp    $0x25,%ecx
80100701:	74 4d                	je     80100750 <cprintf+0xa0>
80100703:	83 f9 64             	cmp    $0x64,%ecx
80100706:	75 76                	jne    8010077e <cprintf+0xce>
      printint(*argp++, 10, 1);
80100708:	8d 47 04             	lea    0x4(%edi),%eax
8010070b:	b9 01 00 00 00       	mov    $0x1,%ecx
80100710:	ba 0a 00 00 00       	mov    $0xa,%edx
80100715:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100718:	8b 07                	mov    (%edi),%eax
8010071a:	e8 01 ff ff ff       	call   80100620 <printint>
8010071f:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100722:	83 c3 01             	add    $0x1,%ebx
80100725:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	75 b6                	jne    801006e3 <cprintf+0x33>
8010072d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  if(locking)
80100730:	85 ff                	test   %edi,%edi
80100732:	0f 85 bb 00 00 00    	jne    801007f3 <cprintf+0x143>
}
80100738:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010073b:	5b                   	pop    %ebx
8010073c:	5e                   	pop    %esi
8010073d:	5f                   	pop    %edi
8010073e:	5d                   	pop    %ebp
8010073f:	c3                   	ret
  if(panicked){
80100740:	8b 0d 78 ef 10 80    	mov    0x8010ef78,%ecx
80100746:	85 c9                	test   %ecx,%ecx
80100748:	74 19                	je     80100763 <cprintf+0xb3>
8010074a:	fa                   	cli
    for(;;)
8010074b:	eb fe                	jmp    8010074b <cprintf+0x9b>
8010074d:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
80100750:	8b 0d 78 ef 10 80    	mov    0x8010ef78,%ecx
80100756:	85 c9                	test   %ecx,%ecx
80100758:	0f 85 f2 00 00 00    	jne    80100850 <cprintf+0x1a0>
8010075e:	b8 25 00 00 00       	mov    $0x25,%eax
80100763:	e8 98 fc ff ff       	call   80100400 <consputc.part.0>
      break;
80100768:	eb b8                	jmp    80100722 <cprintf+0x72>
8010076a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    switch(c){
80100770:	83 f9 73             	cmp    $0x73,%ecx
80100773:	0f 84 8f 00 00 00    	je     80100808 <cprintf+0x158>
80100779:	83 f9 78             	cmp    $0x78,%ecx
8010077c:	74 32                	je     801007b0 <cprintf+0x100>
  if(panicked){
8010077e:	8b 15 78 ef 10 80    	mov    0x8010ef78,%edx
80100784:	85 d2                	test   %edx,%edx
80100786:	0f 85 b8 00 00 00    	jne    80100844 <cprintf+0x194>
8010078c:	b8 25 00 00 00       	mov    $0x25,%eax
80100791:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100794:	e8 67 fc ff ff       	call   80100400 <consputc.part.0>
80100799:	a1 78 ef 10 80       	mov    0x8010ef78,%eax
8010079e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801007a1:	85 c0                	test   %eax,%eax
801007a3:	0f 84 cd 00 00 00    	je     80100876 <cprintf+0x1c6>
801007a9:	fa                   	cli
    for(;;)
801007aa:	eb fe                	jmp    801007aa <cprintf+0xfa>
801007ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      printint(*argp++, 16, 0);
801007b0:	8d 47 04             	lea    0x4(%edi),%eax
801007b3:	31 c9                	xor    %ecx,%ecx
801007b5:	ba 10 00 00 00       	mov    $0x10,%edx
801007ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
801007bd:	8b 07                	mov    (%edi),%eax
801007bf:	e8 5c fe ff ff       	call   80100620 <printint>
801007c4:	8b 7d e0             	mov    -0x20(%ebp),%edi
      break;
801007c7:	e9 56 ff ff ff       	jmp    80100722 <cprintf+0x72>
801007cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007d0:	83 ec 0c             	sub    $0xc,%esp
801007d3:	68 40 ef 10 80       	push   $0x8010ef40
801007d8:	e8 a3 3e 00 00       	call   80104680 <acquire>
  if (fmt == 0)
801007dd:	83 c4 10             	add    $0x10,%esp
801007e0:	85 f6                	test   %esi,%esi
801007e2:	0f 84 a1 00 00 00    	je     80100889 <cprintf+0x1d9>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007e8:	0f b6 06             	movzbl (%esi),%eax
801007eb:	85 c0                	test   %eax,%eax
801007ed:	0f 85 e6 fe ff ff    	jne    801006d9 <cprintf+0x29>
    release(&cons.lock);
801007f3:	83 ec 0c             	sub    $0xc,%esp
801007f6:	68 40 ef 10 80       	push   $0x8010ef40
801007fb:	e8 20 3e 00 00       	call   80104620 <release>
80100800:	83 c4 10             	add    $0x10,%esp
80100803:	e9 30 ff ff ff       	jmp    80100738 <cprintf+0x88>
      if((s = (char*)*argp++) == 0)
80100808:	8b 17                	mov    (%edi),%edx
8010080a:	8d 47 04             	lea    0x4(%edi),%eax
8010080d:	85 d2                	test   %edx,%edx
8010080f:	74 27                	je     80100838 <cprintf+0x188>
      for(; *s; s++)
80100811:	0f b6 0a             	movzbl (%edx),%ecx
      if((s = (char*)*argp++) == 0)
80100814:	89 d7                	mov    %edx,%edi
      for(; *s; s++)
80100816:	84 c9                	test   %cl,%cl
80100818:	74 68                	je     80100882 <cprintf+0x1d2>
8010081a:	89 5d e0             	mov    %ebx,-0x20(%ebp)
8010081d:	89 fb                	mov    %edi,%ebx
8010081f:	89 f7                	mov    %esi,%edi
80100821:	89 c6                	mov    %eax,%esi
80100823:	0f be c1             	movsbl %cl,%eax
  if(panicked){
80100826:	8b 15 78 ef 10 80    	mov    0x8010ef78,%edx
8010082c:	85 d2                	test   %edx,%edx
8010082e:	74 28                	je     80100858 <cprintf+0x1a8>
80100830:	fa                   	cli
    for(;;)
80100831:	eb fe                	jmp    80100831 <cprintf+0x181>
80100833:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100838:	b9 28 00 00 00       	mov    $0x28,%ecx
        s = "(null)";
8010083d:	bf 98 72 10 80       	mov    $0x80107298,%edi
80100842:	eb d6                	jmp    8010081a <cprintf+0x16a>
80100844:	fa                   	cli
    for(;;)
80100845:	eb fe                	jmp    80100845 <cprintf+0x195>
80100847:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010084e:	00 
8010084f:	90                   	nop
80100850:	fa                   	cli
80100851:	eb fe                	jmp    80100851 <cprintf+0x1a1>
80100853:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100858:	e8 a3 fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
8010085d:	0f be 43 01          	movsbl 0x1(%ebx),%eax
80100861:	83 c3 01             	add    $0x1,%ebx
80100864:	84 c0                	test   %al,%al
80100866:	75 be                	jne    80100826 <cprintf+0x176>
      if((s = (char*)*argp++) == 0)
80100868:	89 f0                	mov    %esi,%eax
8010086a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
8010086d:	89 fe                	mov    %edi,%esi
8010086f:	89 c7                	mov    %eax,%edi
80100871:	e9 ac fe ff ff       	jmp    80100722 <cprintf+0x72>
80100876:	89 c8                	mov    %ecx,%eax
80100878:	e8 83 fb ff ff       	call   80100400 <consputc.part.0>
      break;
8010087d:	e9 a0 fe ff ff       	jmp    80100722 <cprintf+0x72>
      if((s = (char*)*argp++) == 0)
80100882:	89 c7                	mov    %eax,%edi
80100884:	e9 99 fe ff ff       	jmp    80100722 <cprintf+0x72>
    panic("null fmt");
80100889:	83 ec 0c             	sub    $0xc,%esp
8010088c:	68 9f 72 10 80       	push   $0x8010729f
80100891:	e8 ea fa ff ff       	call   80100380 <panic>
80100896:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010089d:	00 
8010089e:	66 90                	xchg   %ax,%ax

801008a0 <consoleintr>:
{
801008a0:	55                   	push   %ebp
801008a1:	89 e5                	mov    %esp,%ebp
801008a3:	57                   	push   %edi
  int c, doprocdump = 0;
801008a4:	31 ff                	xor    %edi,%edi
{
801008a6:	56                   	push   %esi
801008a7:	53                   	push   %ebx
801008a8:	83 ec 18             	sub    $0x18,%esp
801008ab:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&cons.lock);
801008ae:	68 40 ef 10 80       	push   $0x8010ef40
801008b3:	e8 c8 3d 00 00       	call   80104680 <acquire>
  while((c = getc()) >= 0){
801008b8:	83 c4 10             	add    $0x10,%esp
801008bb:	ff d6                	call   *%esi
801008bd:	89 c3                	mov    %eax,%ebx
801008bf:	85 c0                	test   %eax,%eax
801008c1:	78 2f                	js     801008f2 <consoleintr+0x52>
    switch(c){
801008c3:	83 fb 10             	cmp    $0x10,%ebx
801008c6:	0f 84 44 01 00 00    	je     80100a10 <consoleintr+0x170>
801008cc:	7f 52                	jg     80100920 <consoleintr+0x80>
801008ce:	83 fb 08             	cmp    $0x8,%ebx
801008d1:	0f 84 11 01 00 00    	je     801009e8 <consoleintr+0x148>
801008d7:	83 fb 09             	cmp    $0x9,%ebx
801008da:	0f 85 3a 01 00 00    	jne    80100a1a <consoleintr+0x17a>
      check_cntrl_i=1;
801008e0:	c7 05 80 ee 10 80 01 	movl   $0x1,0x8010ee80
801008e7:	00 00 00 
  while((c = getc()) >= 0){
801008ea:	ff d6                	call   *%esi
801008ec:	89 c3                	mov    %eax,%ebx
801008ee:	85 c0                	test   %eax,%eax
801008f0:	79 d1                	jns    801008c3 <consoleintr+0x23>
  release(&cons.lock);
801008f2:	83 ec 0c             	sub    $0xc,%esp
801008f5:	68 40 ef 10 80       	push   $0x8010ef40
801008fa:	e8 21 3d 00 00       	call   80104620 <release>
  if(check_cntrl_i)
801008ff:	a1 80 ee 10 80       	mov    0x8010ee80,%eax
80100904:	83 c4 10             	add    $0x10,%esp
80100907:	85 c0                	test   %eax,%eax
80100909:	0f 85 9d 01 00 00    	jne    80100aac <consoleintr+0x20c>
  if(doprocdump) {
8010090f:	85 ff                	test   %edi,%edi
80100911:	0f 85 89 01 00 00    	jne    80100aa0 <consoleintr+0x200>
}
80100917:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010091a:	5b                   	pop    %ebx
8010091b:	5e                   	pop    %esi
8010091c:	5f                   	pop    %edi
8010091d:	5d                   	pop    %ebp
8010091e:	c3                   	ret
8010091f:	90                   	nop
    switch(c){
80100920:	83 fb 15             	cmp    $0x15,%ebx
80100923:	0f 84 81 00 00 00    	je     801009aa <consoleintr+0x10a>
80100929:	83 fb 7f             	cmp    $0x7f,%ebx
8010092c:	0f 84 b6 00 00 00    	je     801009e8 <consoleintr+0x148>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100932:	a1 28 ef 10 80       	mov    0x8010ef28,%eax
80100937:	89 c2                	mov    %eax,%edx
80100939:	2b 15 20 ef 10 80    	sub    0x8010ef20,%edx
8010093f:	83 fa 7f             	cmp    $0x7f,%edx
80100942:	0f 87 73 ff ff ff    	ja     801008bb <consoleintr+0x1b>
  if(panicked){
80100948:	8b 0d 78 ef 10 80    	mov    0x8010ef78,%ecx
        input.buf[input.e++ % INPUT_BUF] = c;
8010094e:	8d 50 01             	lea    0x1(%eax),%edx
80100951:	83 e0 7f             	and    $0x7f,%eax
80100954:	89 15 28 ef 10 80    	mov    %edx,0x8010ef28
8010095a:	88 98 a0 ee 10 80    	mov    %bl,-0x7fef1160(%eax)
  if(panicked){
80100960:	85 c9                	test   %ecx,%ecx
80100962:	0f 85 2e 01 00 00    	jne    80100a96 <consoleintr+0x1f6>
80100968:	89 d8                	mov    %ebx,%eax
8010096a:	e8 91 fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
8010096f:	83 fb 0a             	cmp    $0xa,%ebx
80100972:	0f 84 f0 00 00 00    	je     80100a68 <consoleintr+0x1c8>
80100978:	83 fb 04             	cmp    $0x4,%ebx
8010097b:	0f 84 e7 00 00 00    	je     80100a68 <consoleintr+0x1c8>
80100981:	a1 20 ef 10 80       	mov    0x8010ef20,%eax
80100986:	83 e8 80             	sub    $0xffffff80,%eax
80100989:	39 05 28 ef 10 80    	cmp    %eax,0x8010ef28
8010098f:	0f 85 26 ff ff ff    	jne    801008bb <consoleintr+0x1b>
80100995:	e9 d3 00 00 00       	jmp    80100a6d <consoleintr+0x1cd>
8010099a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801009a0:	b8 00 01 00 00       	mov    $0x100,%eax
801009a5:	e8 56 fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
801009aa:	a1 28 ef 10 80       	mov    0x8010ef28,%eax
801009af:	3b 05 24 ef 10 80    	cmp    0x8010ef24,%eax
801009b5:	0f 84 00 ff ff ff    	je     801008bb <consoleintr+0x1b>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801009bb:	83 e8 01             	sub    $0x1,%eax
801009be:	89 c2                	mov    %eax,%edx
801009c0:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
801009c3:	80 ba a0 ee 10 80 0a 	cmpb   $0xa,-0x7fef1160(%edx)
801009ca:	0f 84 eb fe ff ff    	je     801008bb <consoleintr+0x1b>
  if(panicked){
801009d0:	8b 0d 78 ef 10 80    	mov    0x8010ef78,%ecx
        input.e--;
801009d6:	a3 28 ef 10 80       	mov    %eax,0x8010ef28
  if(panicked){
801009db:	85 c9                	test   %ecx,%ecx
801009dd:	74 c1                	je     801009a0 <consoleintr+0x100>
801009df:	fa                   	cli
    for(;;)
801009e0:	eb fe                	jmp    801009e0 <consoleintr+0x140>
801009e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(input.e != input.w){
801009e8:	a1 28 ef 10 80       	mov    0x8010ef28,%eax
801009ed:	3b 05 24 ef 10 80    	cmp    0x8010ef24,%eax
801009f3:	0f 84 c2 fe ff ff    	je     801008bb <consoleintr+0x1b>
  if(panicked){
801009f9:	8b 15 78 ef 10 80    	mov    0x8010ef78,%edx
        input.e--;
801009ff:	83 e8 01             	sub    $0x1,%eax
80100a02:	a3 28 ef 10 80       	mov    %eax,0x8010ef28
  if(panicked){
80100a07:	85 d2                	test   %edx,%edx
80100a09:	74 7c                	je     80100a87 <consoleintr+0x1e7>
80100a0b:	fa                   	cli
    for(;;)
80100a0c:	eb fe                	jmp    80100a0c <consoleintr+0x16c>
80100a0e:	66 90                	xchg   %ax,%ax
    switch(c){
80100a10:	bf 01 00 00 00       	mov    $0x1,%edi
80100a15:	e9 a1 fe ff ff       	jmp    801008bb <consoleintr+0x1b>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100a1a:	85 db                	test   %ebx,%ebx
80100a1c:	0f 84 99 fe ff ff    	je     801008bb <consoleintr+0x1b>
80100a22:	a1 28 ef 10 80       	mov    0x8010ef28,%eax
80100a27:	89 c2                	mov    %eax,%edx
80100a29:	2b 15 20 ef 10 80    	sub    0x8010ef20,%edx
80100a2f:	83 fa 7f             	cmp    $0x7f,%edx
80100a32:	0f 87 83 fe ff ff    	ja     801008bb <consoleintr+0x1b>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a38:	8d 50 01             	lea    0x1(%eax),%edx
  if(panicked){
80100a3b:	8b 0d 78 ef 10 80    	mov    0x8010ef78,%ecx
        input.buf[input.e++ % INPUT_BUF] = c;
80100a41:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
80100a44:	83 fb 0d             	cmp    $0xd,%ebx
80100a47:	0f 85 07 ff ff ff    	jne    80100954 <consoleintr+0xb4>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a4d:	89 15 28 ef 10 80    	mov    %edx,0x8010ef28
80100a53:	c6 80 a0 ee 10 80 0a 	movb   $0xa,-0x7fef1160(%eax)
  if(panicked){
80100a5a:	85 c9                	test   %ecx,%ecx
80100a5c:	75 38                	jne    80100a96 <consoleintr+0x1f6>
80100a5e:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a63:	e8 98 f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a68:	a1 28 ef 10 80       	mov    0x8010ef28,%eax
          wakeup(&input.r);
80100a6d:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a70:	a3 24 ef 10 80       	mov    %eax,0x8010ef24
          wakeup(&input.r);
80100a75:	68 20 ef 10 80       	push   $0x8010ef20
80100a7a:	e8 41 37 00 00       	call   801041c0 <wakeup>
80100a7f:	83 c4 10             	add    $0x10,%esp
80100a82:	e9 34 fe ff ff       	jmp    801008bb <consoleintr+0x1b>
80100a87:	b8 00 01 00 00       	mov    $0x100,%eax
80100a8c:	e8 6f f9 ff ff       	call   80100400 <consputc.part.0>
80100a91:	e9 25 fe ff ff       	jmp    801008bb <consoleintr+0x1b>
80100a96:	fa                   	cli
    for(;;)
80100a97:	eb fe                	jmp    80100a97 <consoleintr+0x1f7>
80100a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80100aa0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100aa3:	5b                   	pop    %ebx
80100aa4:	5e                   	pop    %esi
80100aa5:	5f                   	pop    %edi
80100aa6:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100aa7:	e9 f4 37 00 00       	jmp    801042a0 <procdump>
    cprintf("Ctrl+I is detected by xv6\n");
80100aac:	83 ec 0c             	sub    $0xc,%esp
80100aaf:	68 a8 72 10 80       	push   $0x801072a8
80100ab4:	e8 f7 fb ff ff       	call   801006b0 <cprintf>
    print_mem_layout();
80100ab9:	e8 72 2e 00 00       	call   80103930 <print_mem_layout>
    check_cntrl_i=0;
80100abe:	83 c4 10             	add    $0x10,%esp
80100ac1:	c7 05 80 ee 10 80 00 	movl   $0x0,0x8010ee80
80100ac8:	00 00 00 
80100acb:	e9 3f fe ff ff       	jmp    8010090f <consoleintr+0x6f>

80100ad0 <consoleinit>:

void
consoleinit(void)
{
80100ad0:	55                   	push   %ebp
80100ad1:	89 e5                	mov    %esp,%ebp
80100ad3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100ad6:	68 c3 72 10 80       	push   $0x801072c3
80100adb:	68 40 ef 10 80       	push   $0x8010ef40
80100ae0:	e8 ab 39 00 00       	call   80104490 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100ae5:	58                   	pop    %eax
80100ae6:	5a                   	pop    %edx
80100ae7:	6a 00                	push   $0x0
80100ae9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100aeb:	c7 05 2c f9 10 80 b0 	movl   $0x801005b0,0x8010f92c
80100af2:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100af5:	c7 05 28 f9 10 80 80 	movl   $0x80100280,0x8010f928
80100afc:	02 10 80 
  cons.locking = 1;
80100aff:	c7 05 74 ef 10 80 01 	movl   $0x1,0x8010ef74
80100b06:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100b09:	e8 c2 19 00 00       	call   801024d0 <ioapicenable>
}
80100b0e:	83 c4 10             	add    $0x10,%esp
80100b11:	c9                   	leave
80100b12:	c3                   	ret
80100b13:	66 90                	xchg   %ax,%ax
80100b15:	66 90                	xchg   %ax,%ax
80100b17:	66 90                	xchg   %ax,%ax
80100b19:	66 90                	xchg   %ax,%ax
80100b1b:	66 90                	xchg   %ax,%ax
80100b1d:	66 90                	xchg   %ax,%ax
80100b1f:	90                   	nop

80100b20 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b20:	55                   	push   %ebp
80100b21:	89 e5                	mov    %esp,%ebp
80100b23:	57                   	push   %edi
80100b24:	56                   	push   %esi
80100b25:	53                   	push   %ebx
80100b26:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100b2c:	e8 0f 2f 00 00       	call   80103a40 <myproc>
80100b31:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100b37:	e8 74 22 00 00       	call   80102db0 <begin_op>

  if((ip = namei(path)) == 0){
80100b3c:	83 ec 0c             	sub    $0xc,%esp
80100b3f:	ff 75 08             	push   0x8(%ebp)
80100b42:	e8 a9 15 00 00       	call   801020f0 <namei>
80100b47:	83 c4 10             	add    $0x10,%esp
80100b4a:	85 c0                	test   %eax,%eax
80100b4c:	0f 84 30 03 00 00    	je     80100e82 <exec+0x362>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100b52:	83 ec 0c             	sub    $0xc,%esp
80100b55:	89 c7                	mov    %eax,%edi
80100b57:	50                   	push   %eax
80100b58:	e8 b3 0c 00 00       	call   80101810 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100b5d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100b63:	6a 34                	push   $0x34
80100b65:	6a 00                	push   $0x0
80100b67:	50                   	push   %eax
80100b68:	57                   	push   %edi
80100b69:	e8 b2 0f 00 00       	call   80101b20 <readi>
80100b6e:	83 c4 20             	add    $0x20,%esp
80100b71:	83 f8 34             	cmp    $0x34,%eax
80100b74:	0f 85 01 01 00 00    	jne    80100c7b <exec+0x15b>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100b7a:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b81:	45 4c 46 
80100b84:	0f 85 f1 00 00 00    	jne    80100c7b <exec+0x15b>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100b8a:	e8 71 63 00 00       	call   80106f00 <setupkvm>
80100b8f:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b95:	85 c0                	test   %eax,%eax
80100b97:	0f 84 de 00 00 00    	je     80100c7b <exec+0x15b>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b9d:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100ba4:	00 
80100ba5:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100bab:	0f 84 a1 02 00 00    	je     80100e52 <exec+0x332>
  sz = 0;
80100bb1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100bb8:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bbb:	31 db                	xor    %ebx,%ebx
80100bbd:	e9 8c 00 00 00       	jmp    80100c4e <exec+0x12e>
80100bc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100bc8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100bcf:	75 6c                	jne    80100c3d <exec+0x11d>
      continue;
    if(ph.memsz < ph.filesz)
80100bd1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100bd7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100bdd:	0f 82 87 00 00 00    	jb     80100c6a <exec+0x14a>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100be3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100be9:	72 7f                	jb     80100c6a <exec+0x14a>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100beb:	83 ec 04             	sub    $0x4,%esp
80100bee:	50                   	push   %eax
80100bef:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100bf5:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100bfb:	e8 30 61 00 00       	call   80106d30 <allocuvm>
80100c00:	83 c4 10             	add    $0x10,%esp
80100c03:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100c09:	85 c0                	test   %eax,%eax
80100c0b:	74 5d                	je     80100c6a <exec+0x14a>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100c0d:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100c13:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100c18:	75 50                	jne    80100c6a <exec+0x14a>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c1a:	83 ec 0c             	sub    $0xc,%esp
80100c1d:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100c23:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100c29:	57                   	push   %edi
80100c2a:	50                   	push   %eax
80100c2b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c31:	e8 2a 60 00 00       	call   80106c60 <loaduvm>
80100c36:	83 c4 20             	add    $0x20,%esp
80100c39:	85 c0                	test   %eax,%eax
80100c3b:	78 2d                	js     80100c6a <exec+0x14a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c3d:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100c44:	83 c3 01             	add    $0x1,%ebx
80100c47:	83 c6 20             	add    $0x20,%esi
80100c4a:	39 d8                	cmp    %ebx,%eax
80100c4c:	7e 52                	jle    80100ca0 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c4e:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100c54:	6a 20                	push   $0x20
80100c56:	56                   	push   %esi
80100c57:	50                   	push   %eax
80100c58:	57                   	push   %edi
80100c59:	e8 c2 0e 00 00       	call   80101b20 <readi>
80100c5e:	83 c4 10             	add    $0x10,%esp
80100c61:	83 f8 20             	cmp    $0x20,%eax
80100c64:	0f 84 5e ff ff ff    	je     80100bc8 <exec+0xa8>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100c6a:	83 ec 0c             	sub    $0xc,%esp
80100c6d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c73:	e8 08 62 00 00       	call   80106e80 <freevm>
  if(ip){
80100c78:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80100c7b:	83 ec 0c             	sub    $0xc,%esp
80100c7e:	57                   	push   %edi
80100c7f:	e8 1c 0e 00 00       	call   80101aa0 <iunlockput>
    end_op();
80100c84:	e8 97 21 00 00       	call   80102e20 <end_op>
80100c89:	83 c4 10             	add    $0x10,%esp
    return -1;
80100c8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return -1;
}
80100c91:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100c94:	5b                   	pop    %ebx
80100c95:	5e                   	pop    %esi
80100c96:	5f                   	pop    %edi
80100c97:	5d                   	pop    %ebp
80100c98:	c3                   	ret
80100c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  sz = PGROUNDUP(sz);
80100ca0:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100ca6:	81 c6 ff 0f 00 00    	add    $0xfff,%esi
80100cac:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100cb2:	8d 9e 00 20 00 00    	lea    0x2000(%esi),%ebx
  iunlockput(ip);
80100cb8:	83 ec 0c             	sub    $0xc,%esp
80100cbb:	57                   	push   %edi
80100cbc:	e8 df 0d 00 00       	call   80101aa0 <iunlockput>
  end_op();
80100cc1:	e8 5a 21 00 00       	call   80102e20 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100cc6:	83 c4 0c             	add    $0xc,%esp
80100cc9:	53                   	push   %ebx
80100cca:	56                   	push   %esi
80100ccb:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100cd1:	56                   	push   %esi
80100cd2:	e8 59 60 00 00       	call   80106d30 <allocuvm>
80100cd7:	83 c4 10             	add    $0x10,%esp
80100cda:	89 c7                	mov    %eax,%edi
80100cdc:	85 c0                	test   %eax,%eax
80100cde:	0f 84 86 00 00 00    	je     80100d6a <exec+0x24a>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100ce4:	83 ec 08             	sub    $0x8,%esp
80100ce7:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  sp = sz;
80100ced:	89 fb                	mov    %edi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cef:	50                   	push   %eax
80100cf0:	56                   	push   %esi
  for(argc = 0; argv[argc]; argc++) {
80100cf1:	31 f6                	xor    %esi,%esi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cf3:	e8 a8 62 00 00       	call   80106fa0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100cf8:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cfb:	83 c4 10             	add    $0x10,%esp
80100cfe:	8b 10                	mov    (%eax),%edx
80100d00:	85 d2                	test   %edx,%edx
80100d02:	0f 84 56 01 00 00    	je     80100e5e <exec+0x33e>
80100d08:	89 bd f0 fe ff ff    	mov    %edi,-0x110(%ebp)
80100d0e:	8b 7d 0c             	mov    0xc(%ebp),%edi
80100d11:	eb 23                	jmp    80100d36 <exec+0x216>
80100d13:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100d18:	8d 46 01             	lea    0x1(%esi),%eax
    ustack[3+argc] = sp;
80100d1b:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
80100d22:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
  for(argc = 0; argv[argc]; argc++) {
80100d28:	8b 14 87             	mov    (%edi,%eax,4),%edx
80100d2b:	85 d2                	test   %edx,%edx
80100d2d:	74 51                	je     80100d80 <exec+0x260>
    if(argc >= MAXARG)
80100d2f:	83 f8 20             	cmp    $0x20,%eax
80100d32:	74 36                	je     80100d6a <exec+0x24a>
80100d34:	89 c6                	mov    %eax,%esi
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d36:	83 ec 0c             	sub    $0xc,%esp
80100d39:	52                   	push   %edx
80100d3a:	e8 31 3c 00 00       	call   80104970 <strlen>
80100d3f:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d41:	58                   	pop    %eax
80100d42:	ff 34 b7             	push   (%edi,%esi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d45:	83 eb 01             	sub    $0x1,%ebx
80100d48:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d4b:	e8 20 3c 00 00       	call   80104970 <strlen>
80100d50:	83 c0 01             	add    $0x1,%eax
80100d53:	50                   	push   %eax
80100d54:	ff 34 b7             	push   (%edi,%esi,4)
80100d57:	53                   	push   %ebx
80100d58:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d5e:	e8 0d 64 00 00       	call   80107170 <copyout>
80100d63:	83 c4 20             	add    $0x20,%esp
80100d66:	85 c0                	test   %eax,%eax
80100d68:	79 ae                	jns    80100d18 <exec+0x1f8>
    freevm(pgdir);
80100d6a:	83 ec 0c             	sub    $0xc,%esp
80100d6d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d73:	e8 08 61 00 00       	call   80106e80 <freevm>
80100d78:	83 c4 10             	add    $0x10,%esp
80100d7b:	e9 0c ff ff ff       	jmp    80100c8c <exec+0x16c>
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d80:	8d 14 b5 08 00 00 00 	lea    0x8(,%esi,4),%edx
  ustack[3+argc] = 0;
80100d87:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100d8d:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100d93:	8d 46 04             	lea    0x4(%esi),%eax
  sp -= (3+argc+1) * 4;
80100d96:	8d 72 0c             	lea    0xc(%edx),%esi
  ustack[3+argc] = 0;
80100d99:	c7 84 85 58 ff ff ff 	movl   $0x0,-0xa8(%ebp,%eax,4)
80100da0:	00 00 00 00 
  ustack[1] = argc;
80100da4:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  ustack[0] = 0xffffffff;  // fake return PC
80100daa:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100db1:	ff ff ff 
  ustack[1] = argc;
80100db4:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100dba:	89 d8                	mov    %ebx,%eax
  sp -= (3+argc+1) * 4;
80100dbc:	29 f3                	sub    %esi,%ebx
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100dbe:	29 d0                	sub    %edx,%eax
80100dc0:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100dc6:	56                   	push   %esi
80100dc7:	51                   	push   %ecx
80100dc8:	53                   	push   %ebx
80100dc9:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100dcf:	e8 9c 63 00 00       	call   80107170 <copyout>
80100dd4:	83 c4 10             	add    $0x10,%esp
80100dd7:	85 c0                	test   %eax,%eax
80100dd9:	78 8f                	js     80100d6a <exec+0x24a>
  for(last=s=path; *s; s++)
80100ddb:	8b 45 08             	mov    0x8(%ebp),%eax
80100dde:	8b 55 08             	mov    0x8(%ebp),%edx
80100de1:	0f b6 00             	movzbl (%eax),%eax
80100de4:	84 c0                	test   %al,%al
80100de6:	74 17                	je     80100dff <exec+0x2df>
80100de8:	89 d1                	mov    %edx,%ecx
80100dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      last = s+1;
80100df0:	83 c1 01             	add    $0x1,%ecx
80100df3:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100df5:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100df8:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100dfb:	84 c0                	test   %al,%al
80100dfd:	75 f1                	jne    80100df0 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100dff:	83 ec 04             	sub    $0x4,%esp
80100e02:	6a 10                	push   $0x10
80100e04:	52                   	push   %edx
80100e05:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
80100e0b:	8d 46 6c             	lea    0x6c(%esi),%eax
80100e0e:	50                   	push   %eax
80100e0f:	e8 1c 3b 00 00       	call   80104930 <safestrcpy>
  curproc->pgdir = pgdir;
80100e14:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100e1a:	89 f0                	mov    %esi,%eax
80100e1c:	8b 76 04             	mov    0x4(%esi),%esi
  curproc->sz = sz;
80100e1f:	89 38                	mov    %edi,(%eax)
  curproc->pgdir = pgdir;
80100e21:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100e24:	89 c1                	mov    %eax,%ecx
80100e26:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100e2c:	8b 40 18             	mov    0x18(%eax),%eax
80100e2f:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100e32:	8b 41 18             	mov    0x18(%ecx),%eax
80100e35:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100e38:	89 0c 24             	mov    %ecx,(%esp)
80100e3b:	e8 90 5c 00 00       	call   80106ad0 <switchuvm>
  freevm(oldpgdir);
80100e40:	89 34 24             	mov    %esi,(%esp)
80100e43:	e8 38 60 00 00       	call   80106e80 <freevm>
  return 0;
80100e48:	83 c4 10             	add    $0x10,%esp
80100e4b:	31 c0                	xor    %eax,%eax
80100e4d:	e9 3f fe ff ff       	jmp    80100c91 <exec+0x171>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e52:	bb 00 20 00 00       	mov    $0x2000,%ebx
80100e57:	31 f6                	xor    %esi,%esi
80100e59:	e9 5a fe ff ff       	jmp    80100cb8 <exec+0x198>
  for(argc = 0; argv[argc]; argc++) {
80100e5e:	be 10 00 00 00       	mov    $0x10,%esi
80100e63:	ba 04 00 00 00       	mov    $0x4,%edx
80100e68:	b8 03 00 00 00       	mov    $0x3,%eax
80100e6d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100e74:	00 00 00 
80100e77:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100e7d:	e9 17 ff ff ff       	jmp    80100d99 <exec+0x279>
    end_op();
80100e82:	e8 99 1f 00 00       	call   80102e20 <end_op>
    cprintf("exec: fail\n");
80100e87:	83 ec 0c             	sub    $0xc,%esp
80100e8a:	68 cb 72 10 80       	push   $0x801072cb
80100e8f:	e8 1c f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100e94:	83 c4 10             	add    $0x10,%esp
80100e97:	e9 f0 fd ff ff       	jmp    80100c8c <exec+0x16c>
80100e9c:	66 90                	xchg   %ax,%ax
80100e9e:	66 90                	xchg   %ax,%ax

80100ea0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100ea0:	55                   	push   %ebp
80100ea1:	89 e5                	mov    %esp,%ebp
80100ea3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100ea6:	68 d7 72 10 80       	push   $0x801072d7
80100eab:	68 80 ef 10 80       	push   $0x8010ef80
80100eb0:	e8 db 35 00 00       	call   80104490 <initlock>
}
80100eb5:	83 c4 10             	add    $0x10,%esp
80100eb8:	c9                   	leave
80100eb9:	c3                   	ret
80100eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100ec0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100ec0:	55                   	push   %ebp
80100ec1:	89 e5                	mov    %esp,%ebp
80100ec3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ec4:	bb b4 ef 10 80       	mov    $0x8010efb4,%ebx
{
80100ec9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100ecc:	68 80 ef 10 80       	push   $0x8010ef80
80100ed1:	e8 aa 37 00 00       	call   80104680 <acquire>
80100ed6:	83 c4 10             	add    $0x10,%esp
80100ed9:	eb 10                	jmp    80100eeb <filealloc+0x2b>
80100edb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ee0:	83 c3 18             	add    $0x18,%ebx
80100ee3:	81 fb 14 f9 10 80    	cmp    $0x8010f914,%ebx
80100ee9:	74 25                	je     80100f10 <filealloc+0x50>
    if(f->ref == 0){
80100eeb:	8b 43 04             	mov    0x4(%ebx),%eax
80100eee:	85 c0                	test   %eax,%eax
80100ef0:	75 ee                	jne    80100ee0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100ef2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100ef5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100efc:	68 80 ef 10 80       	push   $0x8010ef80
80100f01:	e8 1a 37 00 00       	call   80104620 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100f06:	89 d8                	mov    %ebx,%eax
      return f;
80100f08:	83 c4 10             	add    $0x10,%esp
}
80100f0b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f0e:	c9                   	leave
80100f0f:	c3                   	ret
  release(&ftable.lock);
80100f10:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100f13:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100f15:	68 80 ef 10 80       	push   $0x8010ef80
80100f1a:	e8 01 37 00 00       	call   80104620 <release>
}
80100f1f:	89 d8                	mov    %ebx,%eax
  return 0;
80100f21:	83 c4 10             	add    $0x10,%esp
}
80100f24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f27:	c9                   	leave
80100f28:	c3                   	ret
80100f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100f30 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100f30:	55                   	push   %ebp
80100f31:	89 e5                	mov    %esp,%ebp
80100f33:	53                   	push   %ebx
80100f34:	83 ec 10             	sub    $0x10,%esp
80100f37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100f3a:	68 80 ef 10 80       	push   $0x8010ef80
80100f3f:	e8 3c 37 00 00       	call   80104680 <acquire>
  if(f->ref < 1)
80100f44:	8b 43 04             	mov    0x4(%ebx),%eax
80100f47:	83 c4 10             	add    $0x10,%esp
80100f4a:	85 c0                	test   %eax,%eax
80100f4c:	7e 1a                	jle    80100f68 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100f4e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100f51:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100f54:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100f57:	68 80 ef 10 80       	push   $0x8010ef80
80100f5c:	e8 bf 36 00 00       	call   80104620 <release>
  return f;
}
80100f61:	89 d8                	mov    %ebx,%eax
80100f63:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f66:	c9                   	leave
80100f67:	c3                   	ret
    panic("filedup");
80100f68:	83 ec 0c             	sub    $0xc,%esp
80100f6b:	68 de 72 10 80       	push   $0x801072de
80100f70:	e8 0b f4 ff ff       	call   80100380 <panic>
80100f75:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100f7c:	00 
80100f7d:	8d 76 00             	lea    0x0(%esi),%esi

80100f80 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f80:	55                   	push   %ebp
80100f81:	89 e5                	mov    %esp,%ebp
80100f83:	57                   	push   %edi
80100f84:	56                   	push   %esi
80100f85:	53                   	push   %ebx
80100f86:	83 ec 28             	sub    $0x28,%esp
80100f89:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f8c:	68 80 ef 10 80       	push   $0x8010ef80
80100f91:	e8 ea 36 00 00       	call   80104680 <acquire>
  if(f->ref < 1)
80100f96:	8b 53 04             	mov    0x4(%ebx),%edx
80100f99:	83 c4 10             	add    $0x10,%esp
80100f9c:	85 d2                	test   %edx,%edx
80100f9e:	0f 8e a5 00 00 00    	jle    80101049 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100fa4:	83 ea 01             	sub    $0x1,%edx
80100fa7:	89 53 04             	mov    %edx,0x4(%ebx)
80100faa:	75 44                	jne    80100ff0 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100fac:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100fb0:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100fb3:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100fb5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100fbb:	8b 73 0c             	mov    0xc(%ebx),%esi
80100fbe:	88 45 e7             	mov    %al,-0x19(%ebp)
80100fc1:	8b 43 10             	mov    0x10(%ebx),%eax
80100fc4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100fc7:	68 80 ef 10 80       	push   $0x8010ef80
80100fcc:	e8 4f 36 00 00       	call   80104620 <release>

  if(ff.type == FD_PIPE)
80100fd1:	83 c4 10             	add    $0x10,%esp
80100fd4:	83 ff 01             	cmp    $0x1,%edi
80100fd7:	74 57                	je     80101030 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100fd9:	83 ff 02             	cmp    $0x2,%edi
80100fdc:	74 2a                	je     80101008 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100fde:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fe1:	5b                   	pop    %ebx
80100fe2:	5e                   	pop    %esi
80100fe3:	5f                   	pop    %edi
80100fe4:	5d                   	pop    %ebp
80100fe5:	c3                   	ret
80100fe6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100fed:	00 
80100fee:	66 90                	xchg   %ax,%ax
    release(&ftable.lock);
80100ff0:	c7 45 08 80 ef 10 80 	movl   $0x8010ef80,0x8(%ebp)
}
80100ff7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ffa:	5b                   	pop    %ebx
80100ffb:	5e                   	pop    %esi
80100ffc:	5f                   	pop    %edi
80100ffd:	5d                   	pop    %ebp
    release(&ftable.lock);
80100ffe:	e9 1d 36 00 00       	jmp    80104620 <release>
80101003:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    begin_op();
80101008:	e8 a3 1d 00 00       	call   80102db0 <begin_op>
    iput(ff.ip);
8010100d:	83 ec 0c             	sub    $0xc,%esp
80101010:	ff 75 e0             	push   -0x20(%ebp)
80101013:	e8 28 09 00 00       	call   80101940 <iput>
    end_op();
80101018:	83 c4 10             	add    $0x10,%esp
}
8010101b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010101e:	5b                   	pop    %ebx
8010101f:	5e                   	pop    %esi
80101020:	5f                   	pop    %edi
80101021:	5d                   	pop    %ebp
    end_op();
80101022:	e9 f9 1d 00 00       	jmp    80102e20 <end_op>
80101027:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010102e:	00 
8010102f:	90                   	nop
    pipeclose(ff.pipe, ff.writable);
80101030:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80101034:	83 ec 08             	sub    $0x8,%esp
80101037:	53                   	push   %ebx
80101038:	56                   	push   %esi
80101039:	e8 32 25 00 00       	call   80103570 <pipeclose>
8010103e:	83 c4 10             	add    $0x10,%esp
}
80101041:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101044:	5b                   	pop    %ebx
80101045:	5e                   	pop    %esi
80101046:	5f                   	pop    %edi
80101047:	5d                   	pop    %ebp
80101048:	c3                   	ret
    panic("fileclose");
80101049:	83 ec 0c             	sub    $0xc,%esp
8010104c:	68 e6 72 10 80       	push   $0x801072e6
80101051:	e8 2a f3 ff ff       	call   80100380 <panic>
80101056:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010105d:	00 
8010105e:	66 90                	xchg   %ax,%ax

80101060 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101060:	55                   	push   %ebp
80101061:	89 e5                	mov    %esp,%ebp
80101063:	53                   	push   %ebx
80101064:	83 ec 04             	sub    $0x4,%esp
80101067:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010106a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010106d:	75 31                	jne    801010a0 <filestat+0x40>
    ilock(f->ip);
8010106f:	83 ec 0c             	sub    $0xc,%esp
80101072:	ff 73 10             	push   0x10(%ebx)
80101075:	e8 96 07 00 00       	call   80101810 <ilock>
    stati(f->ip, st);
8010107a:	58                   	pop    %eax
8010107b:	5a                   	pop    %edx
8010107c:	ff 75 0c             	push   0xc(%ebp)
8010107f:	ff 73 10             	push   0x10(%ebx)
80101082:	e8 69 0a 00 00       	call   80101af0 <stati>
    iunlock(f->ip);
80101087:	59                   	pop    %ecx
80101088:	ff 73 10             	push   0x10(%ebx)
8010108b:	e8 60 08 00 00       	call   801018f0 <iunlock>
    return 0;
  }
  return -1;
}
80101090:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101093:	83 c4 10             	add    $0x10,%esp
80101096:	31 c0                	xor    %eax,%eax
}
80101098:	c9                   	leave
80101099:	c3                   	ret
8010109a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801010a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801010a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801010a8:	c9                   	leave
801010a9:	c3                   	ret
801010aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801010b0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801010b0:	55                   	push   %ebp
801010b1:	89 e5                	mov    %esp,%ebp
801010b3:	57                   	push   %edi
801010b4:	56                   	push   %esi
801010b5:	53                   	push   %ebx
801010b6:	83 ec 0c             	sub    $0xc,%esp
801010b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010bc:	8b 75 0c             	mov    0xc(%ebp),%esi
801010bf:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
801010c2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
801010c6:	74 60                	je     80101128 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
801010c8:	8b 03                	mov    (%ebx),%eax
801010ca:	83 f8 01             	cmp    $0x1,%eax
801010cd:	74 41                	je     80101110 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010cf:	83 f8 02             	cmp    $0x2,%eax
801010d2:	75 5b                	jne    8010112f <fileread+0x7f>
    ilock(f->ip);
801010d4:	83 ec 0c             	sub    $0xc,%esp
801010d7:	ff 73 10             	push   0x10(%ebx)
801010da:	e8 31 07 00 00       	call   80101810 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801010df:	57                   	push   %edi
801010e0:	ff 73 14             	push   0x14(%ebx)
801010e3:	56                   	push   %esi
801010e4:	ff 73 10             	push   0x10(%ebx)
801010e7:	e8 34 0a 00 00       	call   80101b20 <readi>
801010ec:	83 c4 20             	add    $0x20,%esp
801010ef:	89 c6                	mov    %eax,%esi
801010f1:	85 c0                	test   %eax,%eax
801010f3:	7e 03                	jle    801010f8 <fileread+0x48>
      f->off += r;
801010f5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801010f8:	83 ec 0c             	sub    $0xc,%esp
801010fb:	ff 73 10             	push   0x10(%ebx)
801010fe:	e8 ed 07 00 00       	call   801018f0 <iunlock>
    return r;
80101103:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101106:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101109:	89 f0                	mov    %esi,%eax
8010110b:	5b                   	pop    %ebx
8010110c:	5e                   	pop    %esi
8010110d:	5f                   	pop    %edi
8010110e:	5d                   	pop    %ebp
8010110f:	c3                   	ret
    return piperead(f->pipe, addr, n);
80101110:	8b 43 0c             	mov    0xc(%ebx),%eax
80101113:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101116:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101119:	5b                   	pop    %ebx
8010111a:	5e                   	pop    %esi
8010111b:	5f                   	pop    %edi
8010111c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010111d:	e9 0e 26 00 00       	jmp    80103730 <piperead>
80101122:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101128:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010112d:	eb d7                	jmp    80101106 <fileread+0x56>
  panic("fileread");
8010112f:	83 ec 0c             	sub    $0xc,%esp
80101132:	68 f0 72 10 80       	push   $0x801072f0
80101137:	e8 44 f2 ff ff       	call   80100380 <panic>
8010113c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101140 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101140:	55                   	push   %ebp
80101141:	89 e5                	mov    %esp,%ebp
80101143:	57                   	push   %edi
80101144:	56                   	push   %esi
80101145:	53                   	push   %ebx
80101146:	83 ec 1c             	sub    $0x1c,%esp
80101149:	8b 45 0c             	mov    0xc(%ebp),%eax
8010114c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010114f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101152:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101155:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
80101159:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010115c:	0f 84 bb 00 00 00    	je     8010121d <filewrite+0xdd>
    return -1;
  if(f->type == FD_PIPE)
80101162:	8b 03                	mov    (%ebx),%eax
80101164:	83 f8 01             	cmp    $0x1,%eax
80101167:	0f 84 bf 00 00 00    	je     8010122c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010116d:	83 f8 02             	cmp    $0x2,%eax
80101170:	0f 85 c8 00 00 00    	jne    8010123e <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101176:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101179:	31 f6                	xor    %esi,%esi
    while(i < n){
8010117b:	85 c0                	test   %eax,%eax
8010117d:	7f 30                	jg     801011af <filewrite+0x6f>
8010117f:	e9 94 00 00 00       	jmp    80101218 <filewrite+0xd8>
80101184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101188:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010118b:	83 ec 0c             	sub    $0xc,%esp
        f->off += r;
8010118e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101191:	ff 73 10             	push   0x10(%ebx)
80101194:	e8 57 07 00 00       	call   801018f0 <iunlock>
      end_op();
80101199:	e8 82 1c 00 00       	call   80102e20 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010119e:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011a1:	83 c4 10             	add    $0x10,%esp
801011a4:	39 c7                	cmp    %eax,%edi
801011a6:	75 5c                	jne    80101204 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
801011a8:	01 fe                	add    %edi,%esi
    while(i < n){
801011aa:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
801011ad:	7e 69                	jle    80101218 <filewrite+0xd8>
      int n1 = n - i;
801011af:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      if(n1 > max)
801011b2:	b8 00 06 00 00       	mov    $0x600,%eax
      int n1 = n - i;
801011b7:	29 f7                	sub    %esi,%edi
      if(n1 > max)
801011b9:	39 c7                	cmp    %eax,%edi
801011bb:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
801011be:	e8 ed 1b 00 00       	call   80102db0 <begin_op>
      ilock(f->ip);
801011c3:	83 ec 0c             	sub    $0xc,%esp
801011c6:	ff 73 10             	push   0x10(%ebx)
801011c9:	e8 42 06 00 00       	call   80101810 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801011ce:	57                   	push   %edi
801011cf:	ff 73 14             	push   0x14(%ebx)
801011d2:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011d5:	01 f0                	add    %esi,%eax
801011d7:	50                   	push   %eax
801011d8:	ff 73 10             	push   0x10(%ebx)
801011db:	e8 40 0a 00 00       	call   80101c20 <writei>
801011e0:	83 c4 20             	add    $0x20,%esp
801011e3:	85 c0                	test   %eax,%eax
801011e5:	7f a1                	jg     80101188 <filewrite+0x48>
801011e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801011ea:	83 ec 0c             	sub    $0xc,%esp
801011ed:	ff 73 10             	push   0x10(%ebx)
801011f0:	e8 fb 06 00 00       	call   801018f0 <iunlock>
      end_op();
801011f5:	e8 26 1c 00 00       	call   80102e20 <end_op>
      if(r < 0)
801011fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011fd:	83 c4 10             	add    $0x10,%esp
80101200:	85 c0                	test   %eax,%eax
80101202:	75 14                	jne    80101218 <filewrite+0xd8>
        panic("short filewrite");
80101204:	83 ec 0c             	sub    $0xc,%esp
80101207:	68 f9 72 10 80       	push   $0x801072f9
8010120c:	e8 6f f1 ff ff       	call   80100380 <panic>
80101211:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101218:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010121b:	74 05                	je     80101222 <filewrite+0xe2>
8010121d:	be ff ff ff ff       	mov    $0xffffffff,%esi
  }
  panic("filewrite");
}
80101222:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101225:	89 f0                	mov    %esi,%eax
80101227:	5b                   	pop    %ebx
80101228:	5e                   	pop    %esi
80101229:	5f                   	pop    %edi
8010122a:	5d                   	pop    %ebp
8010122b:	c3                   	ret
    return pipewrite(f->pipe, addr, n);
8010122c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010122f:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101232:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101235:	5b                   	pop    %ebx
80101236:	5e                   	pop    %esi
80101237:	5f                   	pop    %edi
80101238:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101239:	e9 d2 23 00 00       	jmp    80103610 <pipewrite>
  panic("filewrite");
8010123e:	83 ec 0c             	sub    $0xc,%esp
80101241:	68 ff 72 10 80       	push   $0x801072ff
80101246:	e8 35 f1 ff ff       	call   80100380 <panic>
8010124b:	66 90                	xchg   %ax,%ax
8010124d:	66 90                	xchg   %ax,%ax
8010124f:	90                   	nop

80101250 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101250:	55                   	push   %ebp
80101251:	89 e5                	mov    %esp,%ebp
80101253:	57                   	push   %edi
80101254:	56                   	push   %esi
80101255:	53                   	push   %ebx
80101256:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101259:	8b 0d d4 15 11 80    	mov    0x801115d4,%ecx
{
8010125f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101262:	85 c9                	test   %ecx,%ecx
80101264:	0f 84 8c 00 00 00    	je     801012f6 <balloc+0xa6>
8010126a:	31 ff                	xor    %edi,%edi
    bp = bread(dev, BBLOCK(b, sb));
8010126c:	89 f8                	mov    %edi,%eax
8010126e:	83 ec 08             	sub    $0x8,%esp
80101271:	89 fe                	mov    %edi,%esi
80101273:	c1 f8 0c             	sar    $0xc,%eax
80101276:	03 05 ec 15 11 80    	add    0x801115ec,%eax
8010127c:	50                   	push   %eax
8010127d:	ff 75 dc             	push   -0x24(%ebp)
80101280:	e8 4b ee ff ff       	call   801000d0 <bread>
80101285:	83 c4 10             	add    $0x10,%esp
80101288:	89 7d d8             	mov    %edi,-0x28(%ebp)
8010128b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010128e:	a1 d4 15 11 80       	mov    0x801115d4,%eax
80101293:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101296:	31 c0                	xor    %eax,%eax
80101298:	eb 32                	jmp    801012cc <balloc+0x7c>
8010129a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801012a0:	89 c1                	mov    %eax,%ecx
801012a2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      m = 1 << (bi % 8);
801012aa:	83 e1 07             	and    $0x7,%ecx
801012ad:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012af:	89 c1                	mov    %eax,%ecx
801012b1:	c1 f9 03             	sar    $0x3,%ecx
801012b4:	0f b6 7c 0f 5c       	movzbl 0x5c(%edi,%ecx,1),%edi
801012b9:	89 fa                	mov    %edi,%edx
801012bb:	85 df                	test   %ebx,%edi
801012bd:	74 49                	je     80101308 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012bf:	83 c0 01             	add    $0x1,%eax
801012c2:	83 c6 01             	add    $0x1,%esi
801012c5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012ca:	74 07                	je     801012d3 <balloc+0x83>
801012cc:	8b 55 e0             	mov    -0x20(%ebp),%edx
801012cf:	39 d6                	cmp    %edx,%esi
801012d1:	72 cd                	jb     801012a0 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801012d3:	8b 7d d8             	mov    -0x28(%ebp),%edi
801012d6:	83 ec 0c             	sub    $0xc,%esp
801012d9:	ff 75 e4             	push   -0x1c(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801012dc:	81 c7 00 10 00 00    	add    $0x1000,%edi
    brelse(bp);
801012e2:	e8 09 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012e7:	83 c4 10             	add    $0x10,%esp
801012ea:	3b 3d d4 15 11 80    	cmp    0x801115d4,%edi
801012f0:	0f 82 76 ff ff ff    	jb     8010126c <balloc+0x1c>
  }
  panic("balloc: out of blocks");
801012f6:	83 ec 0c             	sub    $0xc,%esp
801012f9:	68 09 73 10 80       	push   $0x80107309
801012fe:	e8 7d f0 ff ff       	call   80100380 <panic>
80101303:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
80101308:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
8010130b:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
8010130e:	09 da                	or     %ebx,%edx
80101310:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
80101314:	57                   	push   %edi
80101315:	e8 76 1c 00 00       	call   80102f90 <log_write>
        brelse(bp);
8010131a:	89 3c 24             	mov    %edi,(%esp)
8010131d:	e8 ce ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
80101322:	58                   	pop    %eax
80101323:	5a                   	pop    %edx
80101324:	56                   	push   %esi
80101325:	ff 75 dc             	push   -0x24(%ebp)
80101328:	e8 a3 ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
8010132d:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101330:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101332:	8d 40 5c             	lea    0x5c(%eax),%eax
80101335:	68 00 02 00 00       	push   $0x200
8010133a:	6a 00                	push   $0x0
8010133c:	50                   	push   %eax
8010133d:	e8 3e 34 00 00       	call   80104780 <memset>
  log_write(bp);
80101342:	89 1c 24             	mov    %ebx,(%esp)
80101345:	e8 46 1c 00 00       	call   80102f90 <log_write>
  brelse(bp);
8010134a:	89 1c 24             	mov    %ebx,(%esp)
8010134d:	e8 9e ee ff ff       	call   801001f0 <brelse>
}
80101352:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101355:	89 f0                	mov    %esi,%eax
80101357:	5b                   	pop    %ebx
80101358:	5e                   	pop    %esi
80101359:	5f                   	pop    %edi
8010135a:	5d                   	pop    %ebp
8010135b:	c3                   	ret
8010135c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101360 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101360:	55                   	push   %ebp
80101361:	89 e5                	mov    %esp,%ebp
80101363:	57                   	push   %edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101364:	31 ff                	xor    %edi,%edi
{
80101366:	56                   	push   %esi
80101367:	89 c6                	mov    %eax,%esi
80101369:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010136a:	bb b4 f9 10 80       	mov    $0x8010f9b4,%ebx
{
8010136f:	83 ec 28             	sub    $0x28,%esp
80101372:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101375:	68 80 f9 10 80       	push   $0x8010f980
8010137a:	e8 01 33 00 00       	call   80104680 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010137f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101382:	83 c4 10             	add    $0x10,%esp
80101385:	eb 1b                	jmp    801013a2 <iget+0x42>
80101387:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010138e:	00 
8010138f:	90                   	nop
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101390:	39 33                	cmp    %esi,(%ebx)
80101392:	74 6c                	je     80101400 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101394:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010139a:	81 fb d4 15 11 80    	cmp    $0x801115d4,%ebx
801013a0:	74 26                	je     801013c8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013a2:	8b 43 08             	mov    0x8(%ebx),%eax
801013a5:	85 c0                	test   %eax,%eax
801013a7:	7f e7                	jg     80101390 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801013a9:	85 ff                	test   %edi,%edi
801013ab:	75 e7                	jne    80101394 <iget+0x34>
801013ad:	85 c0                	test   %eax,%eax
801013af:	75 76                	jne    80101427 <iget+0xc7>
      empty = ip;
801013b1:	89 df                	mov    %ebx,%edi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013b3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013b9:	81 fb d4 15 11 80    	cmp    $0x801115d4,%ebx
801013bf:	75 e1                	jne    801013a2 <iget+0x42>
801013c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013c8:	85 ff                	test   %edi,%edi
801013ca:	74 79                	je     80101445 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013cc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013cf:	89 37                	mov    %esi,(%edi)
  ip->inum = inum;
801013d1:	89 57 04             	mov    %edx,0x4(%edi)
  ip->ref = 1;
801013d4:	c7 47 08 01 00 00 00 	movl   $0x1,0x8(%edi)
  ip->valid = 0;
801013db:	c7 47 4c 00 00 00 00 	movl   $0x0,0x4c(%edi)
  release(&icache.lock);
801013e2:	68 80 f9 10 80       	push   $0x8010f980
801013e7:	e8 34 32 00 00       	call   80104620 <release>

  return ip;
801013ec:	83 c4 10             	add    $0x10,%esp
}
801013ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013f2:	89 f8                	mov    %edi,%eax
801013f4:	5b                   	pop    %ebx
801013f5:	5e                   	pop    %esi
801013f6:	5f                   	pop    %edi
801013f7:	5d                   	pop    %ebp
801013f8:	c3                   	ret
801013f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101400:	39 53 04             	cmp    %edx,0x4(%ebx)
80101403:	75 8f                	jne    80101394 <iget+0x34>
      ip->ref++;
80101405:	83 c0 01             	add    $0x1,%eax
      release(&icache.lock);
80101408:	83 ec 0c             	sub    $0xc,%esp
      return ip;
8010140b:	89 df                	mov    %ebx,%edi
      ip->ref++;
8010140d:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101410:	68 80 f9 10 80       	push   $0x8010f980
80101415:	e8 06 32 00 00       	call   80104620 <release>
      return ip;
8010141a:	83 c4 10             	add    $0x10,%esp
}
8010141d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101420:	89 f8                	mov    %edi,%eax
80101422:	5b                   	pop    %ebx
80101423:	5e                   	pop    %esi
80101424:	5f                   	pop    %edi
80101425:	5d                   	pop    %ebp
80101426:	c3                   	ret
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101427:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010142d:	81 fb d4 15 11 80    	cmp    $0x801115d4,%ebx
80101433:	74 10                	je     80101445 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101435:	8b 43 08             	mov    0x8(%ebx),%eax
80101438:	85 c0                	test   %eax,%eax
8010143a:	0f 8f 50 ff ff ff    	jg     80101390 <iget+0x30>
80101440:	e9 68 ff ff ff       	jmp    801013ad <iget+0x4d>
    panic("iget: no inodes");
80101445:	83 ec 0c             	sub    $0xc,%esp
80101448:	68 1f 73 10 80       	push   $0x8010731f
8010144d:	e8 2e ef ff ff       	call   80100380 <panic>
80101452:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101459:	00 
8010145a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101460 <bfree>:
{
80101460:	55                   	push   %ebp
80101461:	89 c1                	mov    %eax,%ecx
  bp = bread(dev, BBLOCK(b, sb));
80101463:	89 d0                	mov    %edx,%eax
80101465:	c1 e8 0c             	shr    $0xc,%eax
{
80101468:	89 e5                	mov    %esp,%ebp
8010146a:	56                   	push   %esi
8010146b:	53                   	push   %ebx
  bp = bread(dev, BBLOCK(b, sb));
8010146c:	03 05 ec 15 11 80    	add    0x801115ec,%eax
{
80101472:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101474:	83 ec 08             	sub    $0x8,%esp
80101477:	50                   	push   %eax
80101478:	51                   	push   %ecx
80101479:	e8 52 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010147e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101480:	c1 fb 03             	sar    $0x3,%ebx
80101483:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101486:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101488:	83 e1 07             	and    $0x7,%ecx
8010148b:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101490:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101496:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101498:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010149d:	85 c1                	test   %eax,%ecx
8010149f:	74 23                	je     801014c4 <bfree+0x64>
  bp->data[bi/8] &= ~m;
801014a1:	f7 d0                	not    %eax
  log_write(bp);
801014a3:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
801014a6:	21 c8                	and    %ecx,%eax
801014a8:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
801014ac:	56                   	push   %esi
801014ad:	e8 de 1a 00 00       	call   80102f90 <log_write>
  brelse(bp);
801014b2:	89 34 24             	mov    %esi,(%esp)
801014b5:	e8 36 ed ff ff       	call   801001f0 <brelse>
}
801014ba:	83 c4 10             	add    $0x10,%esp
801014bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801014c0:	5b                   	pop    %ebx
801014c1:	5e                   	pop    %esi
801014c2:	5d                   	pop    %ebp
801014c3:	c3                   	ret
    panic("freeing free block");
801014c4:	83 ec 0c             	sub    $0xc,%esp
801014c7:	68 2f 73 10 80       	push   $0x8010732f
801014cc:	e8 af ee ff ff       	call   80100380 <panic>
801014d1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801014d8:	00 
801014d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801014e0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801014e0:	55                   	push   %ebp
801014e1:	89 e5                	mov    %esp,%ebp
801014e3:	57                   	push   %edi
801014e4:	56                   	push   %esi
801014e5:	89 c6                	mov    %eax,%esi
801014e7:	53                   	push   %ebx
801014e8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801014eb:	83 fa 0b             	cmp    $0xb,%edx
801014ee:	0f 86 8c 00 00 00    	jbe    80101580 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801014f4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801014f7:	83 fb 7f             	cmp    $0x7f,%ebx
801014fa:	0f 87 a2 00 00 00    	ja     801015a2 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101500:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101506:	85 c0                	test   %eax,%eax
80101508:	74 5e                	je     80101568 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010150a:	83 ec 08             	sub    $0x8,%esp
8010150d:	50                   	push   %eax
8010150e:	ff 36                	push   (%esi)
80101510:	e8 bb eb ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101515:	83 c4 10             	add    $0x10,%esp
80101518:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010151c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010151e:	8b 3b                	mov    (%ebx),%edi
80101520:	85 ff                	test   %edi,%edi
80101522:	74 1c                	je     80101540 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101524:	83 ec 0c             	sub    $0xc,%esp
80101527:	52                   	push   %edx
80101528:	e8 c3 ec ff ff       	call   801001f0 <brelse>
8010152d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101530:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101533:	89 f8                	mov    %edi,%eax
80101535:	5b                   	pop    %ebx
80101536:	5e                   	pop    %esi
80101537:	5f                   	pop    %edi
80101538:	5d                   	pop    %ebp
80101539:	c3                   	ret
8010153a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101540:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
80101543:	8b 06                	mov    (%esi),%eax
80101545:	e8 06 fd ff ff       	call   80101250 <balloc>
      log_write(bp);
8010154a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010154d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101550:	89 03                	mov    %eax,(%ebx)
80101552:	89 c7                	mov    %eax,%edi
      log_write(bp);
80101554:	52                   	push   %edx
80101555:	e8 36 1a 00 00       	call   80102f90 <log_write>
8010155a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010155d:	83 c4 10             	add    $0x10,%esp
80101560:	eb c2                	jmp    80101524 <bmap+0x44>
80101562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101568:	8b 06                	mov    (%esi),%eax
8010156a:	e8 e1 fc ff ff       	call   80101250 <balloc>
8010156f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101575:	eb 93                	jmp    8010150a <bmap+0x2a>
80101577:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010157e:	00 
8010157f:	90                   	nop
    if((addr = ip->addrs[bn]) == 0)
80101580:	8d 5a 14             	lea    0x14(%edx),%ebx
80101583:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101587:	85 ff                	test   %edi,%edi
80101589:	75 a5                	jne    80101530 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010158b:	8b 00                	mov    (%eax),%eax
8010158d:	e8 be fc ff ff       	call   80101250 <balloc>
80101592:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101596:	89 c7                	mov    %eax,%edi
}
80101598:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010159b:	5b                   	pop    %ebx
8010159c:	89 f8                	mov    %edi,%eax
8010159e:	5e                   	pop    %esi
8010159f:	5f                   	pop    %edi
801015a0:	5d                   	pop    %ebp
801015a1:	c3                   	ret
  panic("bmap: out of range");
801015a2:	83 ec 0c             	sub    $0xc,%esp
801015a5:	68 42 73 10 80       	push   $0x80107342
801015aa:	e8 d1 ed ff ff       	call   80100380 <panic>
801015af:	90                   	nop

801015b0 <readsb>:
{
801015b0:	55                   	push   %ebp
801015b1:	89 e5                	mov    %esp,%ebp
801015b3:	56                   	push   %esi
801015b4:	53                   	push   %ebx
801015b5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801015b8:	83 ec 08             	sub    $0x8,%esp
801015bb:	6a 01                	push   $0x1
801015bd:	ff 75 08             	push   0x8(%ebp)
801015c0:	e8 0b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015c5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015c8:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015ca:	8d 40 5c             	lea    0x5c(%eax),%eax
801015cd:	6a 1c                	push   $0x1c
801015cf:	50                   	push   %eax
801015d0:	56                   	push   %esi
801015d1:	e8 3a 32 00 00       	call   80104810 <memmove>
  brelse(bp);
801015d6:	83 c4 10             	add    $0x10,%esp
801015d9:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801015dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015df:	5b                   	pop    %ebx
801015e0:	5e                   	pop    %esi
801015e1:	5d                   	pop    %ebp
  brelse(bp);
801015e2:	e9 09 ec ff ff       	jmp    801001f0 <brelse>
801015e7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801015ee:	00 
801015ef:	90                   	nop

801015f0 <iinit>:
{
801015f0:	55                   	push   %ebp
801015f1:	89 e5                	mov    %esp,%ebp
801015f3:	53                   	push   %ebx
801015f4:	bb c0 f9 10 80       	mov    $0x8010f9c0,%ebx
801015f9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801015fc:	68 55 73 10 80       	push   $0x80107355
80101601:	68 80 f9 10 80       	push   $0x8010f980
80101606:	e8 85 2e 00 00       	call   80104490 <initlock>
  for(i = 0; i < NINODE; i++) {
8010160b:	83 c4 10             	add    $0x10,%esp
8010160e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101610:	83 ec 08             	sub    $0x8,%esp
80101613:	68 5c 73 10 80       	push   $0x8010735c
80101618:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101619:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010161f:	e8 3c 2d 00 00       	call   80104360 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101624:	83 c4 10             	add    $0x10,%esp
80101627:	81 fb e0 15 11 80    	cmp    $0x801115e0,%ebx
8010162d:	75 e1                	jne    80101610 <iinit+0x20>
  bp = bread(dev, 1);
8010162f:	83 ec 08             	sub    $0x8,%esp
80101632:	6a 01                	push   $0x1
80101634:	ff 75 08             	push   0x8(%ebp)
80101637:	e8 94 ea ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
8010163c:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010163f:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101641:	8d 40 5c             	lea    0x5c(%eax),%eax
80101644:	6a 1c                	push   $0x1c
80101646:	50                   	push   %eax
80101647:	68 d4 15 11 80       	push   $0x801115d4
8010164c:	e8 bf 31 00 00       	call   80104810 <memmove>
  brelse(bp);
80101651:	89 1c 24             	mov    %ebx,(%esp)
80101654:	e8 97 eb ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101659:	ff 35 ec 15 11 80    	push   0x801115ec
8010165f:	ff 35 e8 15 11 80    	push   0x801115e8
80101665:	ff 35 e4 15 11 80    	push   0x801115e4
8010166b:	ff 35 e0 15 11 80    	push   0x801115e0
80101671:	ff 35 dc 15 11 80    	push   0x801115dc
80101677:	ff 35 d8 15 11 80    	push   0x801115d8
8010167d:	ff 35 d4 15 11 80    	push   0x801115d4
80101683:	68 a0 77 10 80       	push   $0x801077a0
80101688:	e8 23 f0 ff ff       	call   801006b0 <cprintf>
}
8010168d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101690:	83 c4 30             	add    $0x30,%esp
80101693:	c9                   	leave
80101694:	c3                   	ret
80101695:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010169c:	00 
8010169d:	8d 76 00             	lea    0x0(%esi),%esi

801016a0 <ialloc>:
{
801016a0:	55                   	push   %ebp
801016a1:	89 e5                	mov    %esp,%ebp
801016a3:	57                   	push   %edi
801016a4:	56                   	push   %esi
801016a5:	53                   	push   %ebx
801016a6:	83 ec 1c             	sub    $0x1c,%esp
801016a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
801016ac:	83 3d dc 15 11 80 01 	cmpl   $0x1,0x801115dc
{
801016b3:	8b 75 08             	mov    0x8(%ebp),%esi
801016b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801016b9:	0f 86 91 00 00 00    	jbe    80101750 <ialloc+0xb0>
801016bf:	bf 01 00 00 00       	mov    $0x1,%edi
801016c4:	eb 21                	jmp    801016e7 <ialloc+0x47>
801016c6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801016cd:	00 
801016ce:	66 90                	xchg   %ax,%ax
    brelse(bp);
801016d0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801016d3:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
801016d6:	53                   	push   %ebx
801016d7:	e8 14 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801016dc:	83 c4 10             	add    $0x10,%esp
801016df:	3b 3d dc 15 11 80    	cmp    0x801115dc,%edi
801016e5:	73 69                	jae    80101750 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801016e7:	89 f8                	mov    %edi,%eax
801016e9:	83 ec 08             	sub    $0x8,%esp
801016ec:	c1 e8 03             	shr    $0x3,%eax
801016ef:	03 05 e8 15 11 80    	add    0x801115e8,%eax
801016f5:	50                   	push   %eax
801016f6:	56                   	push   %esi
801016f7:	e8 d4 e9 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
801016fc:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
801016ff:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101701:	89 f8                	mov    %edi,%eax
80101703:	83 e0 07             	and    $0x7,%eax
80101706:	c1 e0 06             	shl    $0x6,%eax
80101709:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010170d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101711:	75 bd                	jne    801016d0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101713:	83 ec 04             	sub    $0x4,%esp
80101716:	6a 40                	push   $0x40
80101718:	6a 00                	push   $0x0
8010171a:	51                   	push   %ecx
8010171b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010171e:	e8 5d 30 00 00       	call   80104780 <memset>
      dip->type = type;
80101723:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101727:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010172a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010172d:	89 1c 24             	mov    %ebx,(%esp)
80101730:	e8 5b 18 00 00       	call   80102f90 <log_write>
      brelse(bp);
80101735:	89 1c 24             	mov    %ebx,(%esp)
80101738:	e8 b3 ea ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010173d:	83 c4 10             	add    $0x10,%esp
}
80101740:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101743:	89 fa                	mov    %edi,%edx
}
80101745:	5b                   	pop    %ebx
      return iget(dev, inum);
80101746:	89 f0                	mov    %esi,%eax
}
80101748:	5e                   	pop    %esi
80101749:	5f                   	pop    %edi
8010174a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010174b:	e9 10 fc ff ff       	jmp    80101360 <iget>
  panic("ialloc: no inodes");
80101750:	83 ec 0c             	sub    $0xc,%esp
80101753:	68 62 73 10 80       	push   $0x80107362
80101758:	e8 23 ec ff ff       	call   80100380 <panic>
8010175d:	8d 76 00             	lea    0x0(%esi),%esi

80101760 <iupdate>:
{
80101760:	55                   	push   %ebp
80101761:	89 e5                	mov    %esp,%ebp
80101763:	56                   	push   %esi
80101764:	53                   	push   %ebx
80101765:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101768:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010176b:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010176e:	83 ec 08             	sub    $0x8,%esp
80101771:	c1 e8 03             	shr    $0x3,%eax
80101774:	03 05 e8 15 11 80    	add    0x801115e8,%eax
8010177a:	50                   	push   %eax
8010177b:	ff 73 a4             	push   -0x5c(%ebx)
8010177e:	e8 4d e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101783:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101787:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010178a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010178c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010178f:	83 e0 07             	and    $0x7,%eax
80101792:	c1 e0 06             	shl    $0x6,%eax
80101795:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101799:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010179c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017a0:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801017a3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801017a7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801017ab:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801017af:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801017b3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801017b7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801017ba:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017bd:	6a 34                	push   $0x34
801017bf:	53                   	push   %ebx
801017c0:	50                   	push   %eax
801017c1:	e8 4a 30 00 00       	call   80104810 <memmove>
  log_write(bp);
801017c6:	89 34 24             	mov    %esi,(%esp)
801017c9:	e8 c2 17 00 00       	call   80102f90 <log_write>
  brelse(bp);
801017ce:	83 c4 10             	add    $0x10,%esp
801017d1:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017d7:	5b                   	pop    %ebx
801017d8:	5e                   	pop    %esi
801017d9:	5d                   	pop    %ebp
  brelse(bp);
801017da:	e9 11 ea ff ff       	jmp    801001f0 <brelse>
801017df:	90                   	nop

801017e0 <idup>:
{
801017e0:	55                   	push   %ebp
801017e1:	89 e5                	mov    %esp,%ebp
801017e3:	53                   	push   %ebx
801017e4:	83 ec 10             	sub    $0x10,%esp
801017e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801017ea:	68 80 f9 10 80       	push   $0x8010f980
801017ef:	e8 8c 2e 00 00       	call   80104680 <acquire>
  ip->ref++;
801017f4:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017f8:	c7 04 24 80 f9 10 80 	movl   $0x8010f980,(%esp)
801017ff:	e8 1c 2e 00 00       	call   80104620 <release>
}
80101804:	89 d8                	mov    %ebx,%eax
80101806:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101809:	c9                   	leave
8010180a:	c3                   	ret
8010180b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101810 <ilock>:
{
80101810:	55                   	push   %ebp
80101811:	89 e5                	mov    %esp,%ebp
80101813:	56                   	push   %esi
80101814:	53                   	push   %ebx
80101815:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101818:	85 db                	test   %ebx,%ebx
8010181a:	0f 84 b7 00 00 00    	je     801018d7 <ilock+0xc7>
80101820:	8b 53 08             	mov    0x8(%ebx),%edx
80101823:	85 d2                	test   %edx,%edx
80101825:	0f 8e ac 00 00 00    	jle    801018d7 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010182b:	83 ec 0c             	sub    $0xc,%esp
8010182e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101831:	50                   	push   %eax
80101832:	e8 69 2b 00 00       	call   801043a0 <acquiresleep>
  if(ip->valid == 0){
80101837:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010183a:	83 c4 10             	add    $0x10,%esp
8010183d:	85 c0                	test   %eax,%eax
8010183f:	74 0f                	je     80101850 <ilock+0x40>
}
80101841:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101844:	5b                   	pop    %ebx
80101845:	5e                   	pop    %esi
80101846:	5d                   	pop    %ebp
80101847:	c3                   	ret
80101848:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010184f:	00 
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101850:	8b 43 04             	mov    0x4(%ebx),%eax
80101853:	83 ec 08             	sub    $0x8,%esp
80101856:	c1 e8 03             	shr    $0x3,%eax
80101859:	03 05 e8 15 11 80    	add    0x801115e8,%eax
8010185f:	50                   	push   %eax
80101860:	ff 33                	push   (%ebx)
80101862:	e8 69 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101867:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010186a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010186c:	8b 43 04             	mov    0x4(%ebx),%eax
8010186f:	83 e0 07             	and    $0x7,%eax
80101872:	c1 e0 06             	shl    $0x6,%eax
80101875:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101879:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010187c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010187f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101883:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101887:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010188b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010188f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101893:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101897:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010189b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010189e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801018a1:	6a 34                	push   $0x34
801018a3:	50                   	push   %eax
801018a4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801018a7:	50                   	push   %eax
801018a8:	e8 63 2f 00 00       	call   80104810 <memmove>
    brelse(bp);
801018ad:	89 34 24             	mov    %esi,(%esp)
801018b0:	e8 3b e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
801018b5:	83 c4 10             	add    $0x10,%esp
801018b8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
801018bd:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801018c4:	0f 85 77 ff ff ff    	jne    80101841 <ilock+0x31>
      panic("ilock: no type");
801018ca:	83 ec 0c             	sub    $0xc,%esp
801018cd:	68 7a 73 10 80       	push   $0x8010737a
801018d2:	e8 a9 ea ff ff       	call   80100380 <panic>
    panic("ilock");
801018d7:	83 ec 0c             	sub    $0xc,%esp
801018da:	68 74 73 10 80       	push   $0x80107374
801018df:	e8 9c ea ff ff       	call   80100380 <panic>
801018e4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801018eb:	00 
801018ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018f0 <iunlock>:
{
801018f0:	55                   	push   %ebp
801018f1:	89 e5                	mov    %esp,%ebp
801018f3:	56                   	push   %esi
801018f4:	53                   	push   %ebx
801018f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801018f8:	85 db                	test   %ebx,%ebx
801018fa:	74 28                	je     80101924 <iunlock+0x34>
801018fc:	83 ec 0c             	sub    $0xc,%esp
801018ff:	8d 73 0c             	lea    0xc(%ebx),%esi
80101902:	56                   	push   %esi
80101903:	e8 38 2b 00 00       	call   80104440 <holdingsleep>
80101908:	83 c4 10             	add    $0x10,%esp
8010190b:	85 c0                	test   %eax,%eax
8010190d:	74 15                	je     80101924 <iunlock+0x34>
8010190f:	8b 43 08             	mov    0x8(%ebx),%eax
80101912:	85 c0                	test   %eax,%eax
80101914:	7e 0e                	jle    80101924 <iunlock+0x34>
  releasesleep(&ip->lock);
80101916:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101919:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010191c:	5b                   	pop    %ebx
8010191d:	5e                   	pop    %esi
8010191e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010191f:	e9 dc 2a 00 00       	jmp    80104400 <releasesleep>
    panic("iunlock");
80101924:	83 ec 0c             	sub    $0xc,%esp
80101927:	68 89 73 10 80       	push   $0x80107389
8010192c:	e8 4f ea ff ff       	call   80100380 <panic>
80101931:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101938:	00 
80101939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101940 <iput>:
{
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	57                   	push   %edi
80101944:	56                   	push   %esi
80101945:	53                   	push   %ebx
80101946:	83 ec 28             	sub    $0x28,%esp
80101949:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010194c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010194f:	57                   	push   %edi
80101950:	e8 4b 2a 00 00       	call   801043a0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101955:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101958:	83 c4 10             	add    $0x10,%esp
8010195b:	85 d2                	test   %edx,%edx
8010195d:	74 07                	je     80101966 <iput+0x26>
8010195f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101964:	74 32                	je     80101998 <iput+0x58>
  releasesleep(&ip->lock);
80101966:	83 ec 0c             	sub    $0xc,%esp
80101969:	57                   	push   %edi
8010196a:	e8 91 2a 00 00       	call   80104400 <releasesleep>
  acquire(&icache.lock);
8010196f:	c7 04 24 80 f9 10 80 	movl   $0x8010f980,(%esp)
80101976:	e8 05 2d 00 00       	call   80104680 <acquire>
  ip->ref--;
8010197b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010197f:	83 c4 10             	add    $0x10,%esp
80101982:	c7 45 08 80 f9 10 80 	movl   $0x8010f980,0x8(%ebp)
}
80101989:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010198c:	5b                   	pop    %ebx
8010198d:	5e                   	pop    %esi
8010198e:	5f                   	pop    %edi
8010198f:	5d                   	pop    %ebp
  release(&icache.lock);
80101990:	e9 8b 2c 00 00       	jmp    80104620 <release>
80101995:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101998:	83 ec 0c             	sub    $0xc,%esp
8010199b:	68 80 f9 10 80       	push   $0x8010f980
801019a0:	e8 db 2c 00 00       	call   80104680 <acquire>
    int r = ip->ref;
801019a5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
801019a8:	c7 04 24 80 f9 10 80 	movl   $0x8010f980,(%esp)
801019af:	e8 6c 2c 00 00       	call   80104620 <release>
    if(r == 1){
801019b4:	83 c4 10             	add    $0x10,%esp
801019b7:	83 fe 01             	cmp    $0x1,%esi
801019ba:	75 aa                	jne    80101966 <iput+0x26>
801019bc:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
801019c2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801019c5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801019c8:	89 df                	mov    %ebx,%edi
801019ca:	89 cb                	mov    %ecx,%ebx
801019cc:	eb 09                	jmp    801019d7 <iput+0x97>
801019ce:	66 90                	xchg   %ax,%ax
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801019d0:	83 c6 04             	add    $0x4,%esi
801019d3:	39 de                	cmp    %ebx,%esi
801019d5:	74 19                	je     801019f0 <iput+0xb0>
    if(ip->addrs[i]){
801019d7:	8b 16                	mov    (%esi),%edx
801019d9:	85 d2                	test   %edx,%edx
801019db:	74 f3                	je     801019d0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
801019dd:	8b 07                	mov    (%edi),%eax
801019df:	e8 7c fa ff ff       	call   80101460 <bfree>
      ip->addrs[i] = 0;
801019e4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801019ea:	eb e4                	jmp    801019d0 <iput+0x90>
801019ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
801019f0:	89 fb                	mov    %edi,%ebx
801019f2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019f5:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801019fb:	85 c0                	test   %eax,%eax
801019fd:	75 2d                	jne    80101a2c <iput+0xec>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
801019ff:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101a02:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101a09:	53                   	push   %ebx
80101a0a:	e8 51 fd ff ff       	call   80101760 <iupdate>
      ip->type = 0;
80101a0f:	31 c0                	xor    %eax,%eax
80101a11:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101a15:	89 1c 24             	mov    %ebx,(%esp)
80101a18:	e8 43 fd ff ff       	call   80101760 <iupdate>
      ip->valid = 0;
80101a1d:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101a24:	83 c4 10             	add    $0x10,%esp
80101a27:	e9 3a ff ff ff       	jmp    80101966 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101a2c:	83 ec 08             	sub    $0x8,%esp
80101a2f:	50                   	push   %eax
80101a30:	ff 33                	push   (%ebx)
80101a32:	e8 99 e6 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
80101a37:	83 c4 10             	add    $0x10,%esp
80101a3a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101a3d:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101a43:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101a46:	8d 70 5c             	lea    0x5c(%eax),%esi
80101a49:	89 cf                	mov    %ecx,%edi
80101a4b:	eb 0a                	jmp    80101a57 <iput+0x117>
80101a4d:	8d 76 00             	lea    0x0(%esi),%esi
80101a50:	83 c6 04             	add    $0x4,%esi
80101a53:	39 fe                	cmp    %edi,%esi
80101a55:	74 0f                	je     80101a66 <iput+0x126>
      if(a[j])
80101a57:	8b 16                	mov    (%esi),%edx
80101a59:	85 d2                	test   %edx,%edx
80101a5b:	74 f3                	je     80101a50 <iput+0x110>
        bfree(ip->dev, a[j]);
80101a5d:	8b 03                	mov    (%ebx),%eax
80101a5f:	e8 fc f9 ff ff       	call   80101460 <bfree>
80101a64:	eb ea                	jmp    80101a50 <iput+0x110>
    brelse(bp);
80101a66:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101a69:	83 ec 0c             	sub    $0xc,%esp
80101a6c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a6f:	50                   	push   %eax
80101a70:	e8 7b e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a75:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101a7b:	8b 03                	mov    (%ebx),%eax
80101a7d:	e8 de f9 ff ff       	call   80101460 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a82:	83 c4 10             	add    $0x10,%esp
80101a85:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a8c:	00 00 00 
80101a8f:	e9 6b ff ff ff       	jmp    801019ff <iput+0xbf>
80101a94:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101a9b:	00 
80101a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101aa0 <iunlockput>:
{
80101aa0:	55                   	push   %ebp
80101aa1:	89 e5                	mov    %esp,%ebp
80101aa3:	56                   	push   %esi
80101aa4:	53                   	push   %ebx
80101aa5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101aa8:	85 db                	test   %ebx,%ebx
80101aaa:	74 34                	je     80101ae0 <iunlockput+0x40>
80101aac:	83 ec 0c             	sub    $0xc,%esp
80101aaf:	8d 73 0c             	lea    0xc(%ebx),%esi
80101ab2:	56                   	push   %esi
80101ab3:	e8 88 29 00 00       	call   80104440 <holdingsleep>
80101ab8:	83 c4 10             	add    $0x10,%esp
80101abb:	85 c0                	test   %eax,%eax
80101abd:	74 21                	je     80101ae0 <iunlockput+0x40>
80101abf:	8b 43 08             	mov    0x8(%ebx),%eax
80101ac2:	85 c0                	test   %eax,%eax
80101ac4:	7e 1a                	jle    80101ae0 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101ac6:	83 ec 0c             	sub    $0xc,%esp
80101ac9:	56                   	push   %esi
80101aca:	e8 31 29 00 00       	call   80104400 <releasesleep>
  iput(ip);
80101acf:	83 c4 10             	add    $0x10,%esp
80101ad2:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101ad5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101ad8:	5b                   	pop    %ebx
80101ad9:	5e                   	pop    %esi
80101ada:	5d                   	pop    %ebp
  iput(ip);
80101adb:	e9 60 fe ff ff       	jmp    80101940 <iput>
    panic("iunlock");
80101ae0:	83 ec 0c             	sub    $0xc,%esp
80101ae3:	68 89 73 10 80       	push   $0x80107389
80101ae8:	e8 93 e8 ff ff       	call   80100380 <panic>
80101aed:	8d 76 00             	lea    0x0(%esi),%esi

80101af0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101af0:	55                   	push   %ebp
80101af1:	89 e5                	mov    %esp,%ebp
80101af3:	8b 55 08             	mov    0x8(%ebp),%edx
80101af6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101af9:	8b 0a                	mov    (%edx),%ecx
80101afb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101afe:	8b 4a 04             	mov    0x4(%edx),%ecx
80101b01:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101b04:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101b08:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101b0b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101b0f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101b13:	8b 52 58             	mov    0x58(%edx),%edx
80101b16:	89 50 10             	mov    %edx,0x10(%eax)
}
80101b19:	5d                   	pop    %ebp
80101b1a:	c3                   	ret
80101b1b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101b20 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101b20:	55                   	push   %ebp
80101b21:	89 e5                	mov    %esp,%ebp
80101b23:	57                   	push   %edi
80101b24:	56                   	push   %esi
80101b25:	53                   	push   %ebx
80101b26:	83 ec 1c             	sub    $0x1c,%esp
80101b29:	8b 75 08             	mov    0x8(%ebp),%esi
80101b2c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101b2f:	8b 7d 10             	mov    0x10(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b32:	66 83 7e 50 03       	cmpw   $0x3,0x50(%esi)
{
80101b37:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101b3a:	89 75 d8             	mov    %esi,-0x28(%ebp)
80101b3d:	8b 45 14             	mov    0x14(%ebp),%eax
  if(ip->type == T_DEV){
80101b40:	0f 84 aa 00 00 00    	je     80101bf0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101b46:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101b49:	8b 56 58             	mov    0x58(%esi),%edx
80101b4c:	39 fa                	cmp    %edi,%edx
80101b4e:	0f 82 bd 00 00 00    	jb     80101c11 <readi+0xf1>
80101b54:	89 f9                	mov    %edi,%ecx
80101b56:	31 db                	xor    %ebx,%ebx
80101b58:	01 c1                	add    %eax,%ecx
80101b5a:	0f 92 c3             	setb   %bl
80101b5d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80101b60:	0f 82 ab 00 00 00    	jb     80101c11 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101b66:	89 d3                	mov    %edx,%ebx
80101b68:	29 fb                	sub    %edi,%ebx
80101b6a:	39 ca                	cmp    %ecx,%edx
80101b6c:	0f 42 c3             	cmovb  %ebx,%eax

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b6f:	85 c0                	test   %eax,%eax
80101b71:	74 73                	je     80101be6 <readi+0xc6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101b73:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101b76:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101b79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b80:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b83:	89 fa                	mov    %edi,%edx
80101b85:	c1 ea 09             	shr    $0x9,%edx
80101b88:	89 d8                	mov    %ebx,%eax
80101b8a:	e8 51 f9 ff ff       	call   801014e0 <bmap>
80101b8f:	83 ec 08             	sub    $0x8,%esp
80101b92:	50                   	push   %eax
80101b93:	ff 33                	push   (%ebx)
80101b95:	e8 36 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b9a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b9d:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ba2:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101ba4:	89 f8                	mov    %edi,%eax
80101ba6:	25 ff 01 00 00       	and    $0x1ff,%eax
80101bab:	29 f3                	sub    %esi,%ebx
80101bad:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101baf:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101bb3:	39 d9                	cmp    %ebx,%ecx
80101bb5:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101bb8:	83 c4 0c             	add    $0xc,%esp
80101bbb:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bbc:	01 de                	add    %ebx,%esi
80101bbe:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101bc0:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101bc3:	50                   	push   %eax
80101bc4:	ff 75 e0             	push   -0x20(%ebp)
80101bc7:	e8 44 2c 00 00       	call   80104810 <memmove>
    brelse(bp);
80101bcc:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101bcf:	89 14 24             	mov    %edx,(%esp)
80101bd2:	e8 19 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bd7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101bda:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101bdd:	83 c4 10             	add    $0x10,%esp
80101be0:	39 de                	cmp    %ebx,%esi
80101be2:	72 9c                	jb     80101b80 <readi+0x60>
80101be4:	89 d8                	mov    %ebx,%eax
  }
  return n;
}
80101be6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101be9:	5b                   	pop    %ebx
80101bea:	5e                   	pop    %esi
80101beb:	5f                   	pop    %edi
80101bec:	5d                   	pop    %ebp
80101bed:	c3                   	ret
80101bee:	66 90                	xchg   %ax,%ax
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101bf0:	0f bf 56 52          	movswl 0x52(%esi),%edx
80101bf4:	66 83 fa 09          	cmp    $0x9,%dx
80101bf8:	77 17                	ja     80101c11 <readi+0xf1>
80101bfa:	8b 14 d5 20 f9 10 80 	mov    -0x7fef06e0(,%edx,8),%edx
80101c01:	85 d2                	test   %edx,%edx
80101c03:	74 0c                	je     80101c11 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101c05:	89 45 10             	mov    %eax,0x10(%ebp)
}
80101c08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c0b:	5b                   	pop    %ebx
80101c0c:	5e                   	pop    %esi
80101c0d:	5f                   	pop    %edi
80101c0e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101c0f:	ff e2                	jmp    *%edx
      return -1;
80101c11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c16:	eb ce                	jmp    80101be6 <readi+0xc6>
80101c18:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101c1f:	00 

80101c20 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101c20:	55                   	push   %ebp
80101c21:	89 e5                	mov    %esp,%ebp
80101c23:	57                   	push   %edi
80101c24:	56                   	push   %esi
80101c25:	53                   	push   %ebx
80101c26:	83 ec 1c             	sub    $0x1c,%esp
80101c29:	8b 45 08             	mov    0x8(%ebp),%eax
80101c2c:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101c2f:	8b 75 14             	mov    0x14(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101c32:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101c37:	89 7d dc             	mov    %edi,-0x24(%ebp)
80101c3a:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101c3d:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(ip->type == T_DEV){
80101c40:	0f 84 ba 00 00 00    	je     80101d00 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101c46:	39 78 58             	cmp    %edi,0x58(%eax)
80101c49:	0f 82 ea 00 00 00    	jb     80101d39 <writei+0x119>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101c4f:	8b 75 e0             	mov    -0x20(%ebp),%esi
80101c52:	89 f2                	mov    %esi,%edx
80101c54:	01 fa                	add    %edi,%edx
80101c56:	0f 82 dd 00 00 00    	jb     80101d39 <writei+0x119>
80101c5c:	81 fa 00 18 01 00    	cmp    $0x11800,%edx
80101c62:	0f 87 d1 00 00 00    	ja     80101d39 <writei+0x119>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c68:	85 f6                	test   %esi,%esi
80101c6a:	0f 84 85 00 00 00    	je     80101cf5 <writei+0xd5>
80101c70:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101c77:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c80:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101c83:	89 fa                	mov    %edi,%edx
80101c85:	c1 ea 09             	shr    $0x9,%edx
80101c88:	89 f0                	mov    %esi,%eax
80101c8a:	e8 51 f8 ff ff       	call   801014e0 <bmap>
80101c8f:	83 ec 08             	sub    $0x8,%esp
80101c92:	50                   	push   %eax
80101c93:	ff 36                	push   (%esi)
80101c95:	e8 36 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c9a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101c9d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101ca0:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ca5:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ca7:	89 f8                	mov    %edi,%eax
80101ca9:	25 ff 01 00 00       	and    $0x1ff,%eax
80101cae:	29 d3                	sub    %edx,%ebx
80101cb0:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101cb2:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101cb6:	39 d9                	cmp    %ebx,%ecx
80101cb8:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101cbb:	83 c4 0c             	add    $0xc,%esp
80101cbe:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101cbf:	01 df                	add    %ebx,%edi
    memmove(bp->data + off%BSIZE, src, m);
80101cc1:	ff 75 dc             	push   -0x24(%ebp)
80101cc4:	50                   	push   %eax
80101cc5:	e8 46 2b 00 00       	call   80104810 <memmove>
    log_write(bp);
80101cca:	89 34 24             	mov    %esi,(%esp)
80101ccd:	e8 be 12 00 00       	call   80102f90 <log_write>
    brelse(bp);
80101cd2:	89 34 24             	mov    %esi,(%esp)
80101cd5:	e8 16 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101cda:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101cdd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101ce0:	83 c4 10             	add    $0x10,%esp
80101ce3:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101ce6:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101ce9:	39 d8                	cmp    %ebx,%eax
80101ceb:	72 93                	jb     80101c80 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101ced:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101cf0:	39 78 58             	cmp    %edi,0x58(%eax)
80101cf3:	72 33                	jb     80101d28 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101cf5:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101cf8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cfb:	5b                   	pop    %ebx
80101cfc:	5e                   	pop    %esi
80101cfd:	5f                   	pop    %edi
80101cfe:	5d                   	pop    %ebp
80101cff:	c3                   	ret
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101d00:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101d04:	66 83 f8 09          	cmp    $0x9,%ax
80101d08:	77 2f                	ja     80101d39 <writei+0x119>
80101d0a:	8b 04 c5 24 f9 10 80 	mov    -0x7fef06dc(,%eax,8),%eax
80101d11:	85 c0                	test   %eax,%eax
80101d13:	74 24                	je     80101d39 <writei+0x119>
    return devsw[ip->major].write(ip, src, n);
80101d15:	89 75 10             	mov    %esi,0x10(%ebp)
}
80101d18:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d1b:	5b                   	pop    %ebx
80101d1c:	5e                   	pop    %esi
80101d1d:	5f                   	pop    %edi
80101d1e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101d1f:	ff e0                	jmp    *%eax
80101d21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iupdate(ip);
80101d28:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101d2b:	89 78 58             	mov    %edi,0x58(%eax)
    iupdate(ip);
80101d2e:	50                   	push   %eax
80101d2f:	e8 2c fa ff ff       	call   80101760 <iupdate>
80101d34:	83 c4 10             	add    $0x10,%esp
80101d37:	eb bc                	jmp    80101cf5 <writei+0xd5>
      return -1;
80101d39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d3e:	eb b8                	jmp    80101cf8 <writei+0xd8>

80101d40 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101d40:	55                   	push   %ebp
80101d41:	89 e5                	mov    %esp,%ebp
80101d43:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101d46:	6a 0e                	push   $0xe
80101d48:	ff 75 0c             	push   0xc(%ebp)
80101d4b:	ff 75 08             	push   0x8(%ebp)
80101d4e:	e8 2d 2b 00 00       	call   80104880 <strncmp>
}
80101d53:	c9                   	leave
80101d54:	c3                   	ret
80101d55:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101d5c:	00 
80101d5d:	8d 76 00             	lea    0x0(%esi),%esi

80101d60 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101d60:	55                   	push   %ebp
80101d61:	89 e5                	mov    %esp,%ebp
80101d63:	57                   	push   %edi
80101d64:	56                   	push   %esi
80101d65:	53                   	push   %ebx
80101d66:	83 ec 1c             	sub    $0x1c,%esp
80101d69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101d6c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d71:	0f 85 85 00 00 00    	jne    80101dfc <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d77:	8b 53 58             	mov    0x58(%ebx),%edx
80101d7a:	31 ff                	xor    %edi,%edi
80101d7c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d7f:	85 d2                	test   %edx,%edx
80101d81:	74 3e                	je     80101dc1 <dirlookup+0x61>
80101d83:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d88:	6a 10                	push   $0x10
80101d8a:	57                   	push   %edi
80101d8b:	56                   	push   %esi
80101d8c:	53                   	push   %ebx
80101d8d:	e8 8e fd ff ff       	call   80101b20 <readi>
80101d92:	83 c4 10             	add    $0x10,%esp
80101d95:	83 f8 10             	cmp    $0x10,%eax
80101d98:	75 55                	jne    80101def <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d9a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d9f:	74 18                	je     80101db9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101da1:	83 ec 04             	sub    $0x4,%esp
80101da4:	8d 45 da             	lea    -0x26(%ebp),%eax
80101da7:	6a 0e                	push   $0xe
80101da9:	50                   	push   %eax
80101daa:	ff 75 0c             	push   0xc(%ebp)
80101dad:	e8 ce 2a 00 00       	call   80104880 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101db2:	83 c4 10             	add    $0x10,%esp
80101db5:	85 c0                	test   %eax,%eax
80101db7:	74 17                	je     80101dd0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101db9:	83 c7 10             	add    $0x10,%edi
80101dbc:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101dbf:	72 c7                	jb     80101d88 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101dc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101dc4:	31 c0                	xor    %eax,%eax
}
80101dc6:	5b                   	pop    %ebx
80101dc7:	5e                   	pop    %esi
80101dc8:	5f                   	pop    %edi
80101dc9:	5d                   	pop    %ebp
80101dca:	c3                   	ret
80101dcb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(poff)
80101dd0:	8b 45 10             	mov    0x10(%ebp),%eax
80101dd3:	85 c0                	test   %eax,%eax
80101dd5:	74 05                	je     80101ddc <dirlookup+0x7c>
        *poff = off;
80101dd7:	8b 45 10             	mov    0x10(%ebp),%eax
80101dda:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101ddc:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101de0:	8b 03                	mov    (%ebx),%eax
80101de2:	e8 79 f5 ff ff       	call   80101360 <iget>
}
80101de7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dea:	5b                   	pop    %ebx
80101deb:	5e                   	pop    %esi
80101dec:	5f                   	pop    %edi
80101ded:	5d                   	pop    %ebp
80101dee:	c3                   	ret
      panic("dirlookup read");
80101def:	83 ec 0c             	sub    $0xc,%esp
80101df2:	68 a3 73 10 80       	push   $0x801073a3
80101df7:	e8 84 e5 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101dfc:	83 ec 0c             	sub    $0xc,%esp
80101dff:	68 91 73 10 80       	push   $0x80107391
80101e04:	e8 77 e5 ff ff       	call   80100380 <panic>
80101e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101e10 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101e10:	55                   	push   %ebp
80101e11:	89 e5                	mov    %esp,%ebp
80101e13:	57                   	push   %edi
80101e14:	56                   	push   %esi
80101e15:	53                   	push   %ebx
80101e16:	89 c3                	mov    %eax,%ebx
80101e18:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101e1b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101e1e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101e21:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101e24:	0f 84 9e 01 00 00    	je     80101fc8 <namex+0x1b8>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101e2a:	e8 11 1c 00 00       	call   80103a40 <myproc>
  acquire(&icache.lock);
80101e2f:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101e32:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101e35:	68 80 f9 10 80       	push   $0x8010f980
80101e3a:	e8 41 28 00 00       	call   80104680 <acquire>
  ip->ref++;
80101e3f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101e43:	c7 04 24 80 f9 10 80 	movl   $0x8010f980,(%esp)
80101e4a:	e8 d1 27 00 00       	call   80104620 <release>
80101e4f:	83 c4 10             	add    $0x10,%esp
80101e52:	eb 07                	jmp    80101e5b <namex+0x4b>
80101e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e58:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e5b:	0f b6 03             	movzbl (%ebx),%eax
80101e5e:	3c 2f                	cmp    $0x2f,%al
80101e60:	74 f6                	je     80101e58 <namex+0x48>
  if(*path == 0)
80101e62:	84 c0                	test   %al,%al
80101e64:	0f 84 06 01 00 00    	je     80101f70 <namex+0x160>
  while(*path != '/' && *path != 0)
80101e6a:	0f b6 03             	movzbl (%ebx),%eax
80101e6d:	84 c0                	test   %al,%al
80101e6f:	0f 84 10 01 00 00    	je     80101f85 <namex+0x175>
80101e75:	89 df                	mov    %ebx,%edi
80101e77:	3c 2f                	cmp    $0x2f,%al
80101e79:	0f 84 06 01 00 00    	je     80101f85 <namex+0x175>
80101e7f:	90                   	nop
80101e80:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e84:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e87:	3c 2f                	cmp    $0x2f,%al
80101e89:	74 04                	je     80101e8f <namex+0x7f>
80101e8b:	84 c0                	test   %al,%al
80101e8d:	75 f1                	jne    80101e80 <namex+0x70>
  len = path - s;
80101e8f:	89 f8                	mov    %edi,%eax
80101e91:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101e93:	83 f8 0d             	cmp    $0xd,%eax
80101e96:	0f 8e ac 00 00 00    	jle    80101f48 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101e9c:	83 ec 04             	sub    $0x4,%esp
80101e9f:	6a 0e                	push   $0xe
80101ea1:	53                   	push   %ebx
80101ea2:	89 fb                	mov    %edi,%ebx
80101ea4:	ff 75 e4             	push   -0x1c(%ebp)
80101ea7:	e8 64 29 00 00       	call   80104810 <memmove>
80101eac:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101eaf:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101eb2:	75 0c                	jne    80101ec0 <namex+0xb0>
80101eb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101eb8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ebb:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101ebe:	74 f8                	je     80101eb8 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101ec0:	83 ec 0c             	sub    $0xc,%esp
80101ec3:	56                   	push   %esi
80101ec4:	e8 47 f9 ff ff       	call   80101810 <ilock>
    if(ip->type != T_DIR){
80101ec9:	83 c4 10             	add    $0x10,%esp
80101ecc:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101ed1:	0f 85 b7 00 00 00    	jne    80101f8e <namex+0x17e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101ed7:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101eda:	85 c0                	test   %eax,%eax
80101edc:	74 09                	je     80101ee7 <namex+0xd7>
80101ede:	80 3b 00             	cmpb   $0x0,(%ebx)
80101ee1:	0f 84 f7 00 00 00    	je     80101fde <namex+0x1ce>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101ee7:	83 ec 04             	sub    $0x4,%esp
80101eea:	6a 00                	push   $0x0
80101eec:	ff 75 e4             	push   -0x1c(%ebp)
80101eef:	56                   	push   %esi
80101ef0:	e8 6b fe ff ff       	call   80101d60 <dirlookup>
80101ef5:	83 c4 10             	add    $0x10,%esp
80101ef8:	89 c7                	mov    %eax,%edi
80101efa:	85 c0                	test   %eax,%eax
80101efc:	0f 84 8c 00 00 00    	je     80101f8e <namex+0x17e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f02:	83 ec 0c             	sub    $0xc,%esp
80101f05:	8d 4e 0c             	lea    0xc(%esi),%ecx
80101f08:	51                   	push   %ecx
80101f09:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101f0c:	e8 2f 25 00 00       	call   80104440 <holdingsleep>
80101f11:	83 c4 10             	add    $0x10,%esp
80101f14:	85 c0                	test   %eax,%eax
80101f16:	0f 84 02 01 00 00    	je     8010201e <namex+0x20e>
80101f1c:	8b 56 08             	mov    0x8(%esi),%edx
80101f1f:	85 d2                	test   %edx,%edx
80101f21:	0f 8e f7 00 00 00    	jle    8010201e <namex+0x20e>
  releasesleep(&ip->lock);
80101f27:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101f2a:	83 ec 0c             	sub    $0xc,%esp
80101f2d:	51                   	push   %ecx
80101f2e:	e8 cd 24 00 00       	call   80104400 <releasesleep>
  iput(ip);
80101f33:	89 34 24             	mov    %esi,(%esp)
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101f36:	89 fe                	mov    %edi,%esi
  iput(ip);
80101f38:	e8 03 fa ff ff       	call   80101940 <iput>
80101f3d:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101f40:	e9 16 ff ff ff       	jmp    80101e5b <namex+0x4b>
80101f45:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101f48:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f4b:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
    memmove(name, s, len);
80101f4e:	83 ec 04             	sub    $0x4,%esp
80101f51:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101f54:	50                   	push   %eax
80101f55:	53                   	push   %ebx
    name[len] = 0;
80101f56:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101f58:	ff 75 e4             	push   -0x1c(%ebp)
80101f5b:	e8 b0 28 00 00       	call   80104810 <memmove>
    name[len] = 0;
80101f60:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101f63:	83 c4 10             	add    $0x10,%esp
80101f66:	c6 01 00             	movb   $0x0,(%ecx)
80101f69:	e9 41 ff ff ff       	jmp    80101eaf <namex+0x9f>
80101f6e:	66 90                	xchg   %ax,%ax
  }
  if(nameiparent){
80101f70:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f73:	85 c0                	test   %eax,%eax
80101f75:	0f 85 93 00 00 00    	jne    8010200e <namex+0x1fe>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f7e:	89 f0                	mov    %esi,%eax
80101f80:	5b                   	pop    %ebx
80101f81:	5e                   	pop    %esi
80101f82:	5f                   	pop    %edi
80101f83:	5d                   	pop    %ebp
80101f84:	c3                   	ret
  while(*path != '/' && *path != 0)
80101f85:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101f88:	89 df                	mov    %ebx,%edi
80101f8a:	31 c0                	xor    %eax,%eax
80101f8c:	eb c0                	jmp    80101f4e <namex+0x13e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f8e:	83 ec 0c             	sub    $0xc,%esp
80101f91:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101f94:	53                   	push   %ebx
80101f95:	e8 a6 24 00 00       	call   80104440 <holdingsleep>
80101f9a:	83 c4 10             	add    $0x10,%esp
80101f9d:	85 c0                	test   %eax,%eax
80101f9f:	74 7d                	je     8010201e <namex+0x20e>
80101fa1:	8b 4e 08             	mov    0x8(%esi),%ecx
80101fa4:	85 c9                	test   %ecx,%ecx
80101fa6:	7e 76                	jle    8010201e <namex+0x20e>
  releasesleep(&ip->lock);
80101fa8:	83 ec 0c             	sub    $0xc,%esp
80101fab:	53                   	push   %ebx
80101fac:	e8 4f 24 00 00       	call   80104400 <releasesleep>
  iput(ip);
80101fb1:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101fb4:	31 f6                	xor    %esi,%esi
  iput(ip);
80101fb6:	e8 85 f9 ff ff       	call   80101940 <iput>
      return 0;
80101fbb:	83 c4 10             	add    $0x10,%esp
}
80101fbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fc1:	89 f0                	mov    %esi,%eax
80101fc3:	5b                   	pop    %ebx
80101fc4:	5e                   	pop    %esi
80101fc5:	5f                   	pop    %edi
80101fc6:	5d                   	pop    %ebp
80101fc7:	c3                   	ret
    ip = iget(ROOTDEV, ROOTINO);
80101fc8:	ba 01 00 00 00       	mov    $0x1,%edx
80101fcd:	b8 01 00 00 00       	mov    $0x1,%eax
80101fd2:	e8 89 f3 ff ff       	call   80101360 <iget>
80101fd7:	89 c6                	mov    %eax,%esi
80101fd9:	e9 7d fe ff ff       	jmp    80101e5b <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101fde:	83 ec 0c             	sub    $0xc,%esp
80101fe1:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101fe4:	53                   	push   %ebx
80101fe5:	e8 56 24 00 00       	call   80104440 <holdingsleep>
80101fea:	83 c4 10             	add    $0x10,%esp
80101fed:	85 c0                	test   %eax,%eax
80101fef:	74 2d                	je     8010201e <namex+0x20e>
80101ff1:	8b 7e 08             	mov    0x8(%esi),%edi
80101ff4:	85 ff                	test   %edi,%edi
80101ff6:	7e 26                	jle    8010201e <namex+0x20e>
  releasesleep(&ip->lock);
80101ff8:	83 ec 0c             	sub    $0xc,%esp
80101ffb:	53                   	push   %ebx
80101ffc:	e8 ff 23 00 00       	call   80104400 <releasesleep>
}
80102001:	83 c4 10             	add    $0x10,%esp
}
80102004:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102007:	89 f0                	mov    %esi,%eax
80102009:	5b                   	pop    %ebx
8010200a:	5e                   	pop    %esi
8010200b:	5f                   	pop    %edi
8010200c:	5d                   	pop    %ebp
8010200d:	c3                   	ret
    iput(ip);
8010200e:	83 ec 0c             	sub    $0xc,%esp
80102011:	56                   	push   %esi
      return 0;
80102012:	31 f6                	xor    %esi,%esi
    iput(ip);
80102014:	e8 27 f9 ff ff       	call   80101940 <iput>
    return 0;
80102019:	83 c4 10             	add    $0x10,%esp
8010201c:	eb a0                	jmp    80101fbe <namex+0x1ae>
    panic("iunlock");
8010201e:	83 ec 0c             	sub    $0xc,%esp
80102021:	68 89 73 10 80       	push   $0x80107389
80102026:	e8 55 e3 ff ff       	call   80100380 <panic>
8010202b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102030 <dirlink>:
{
80102030:	55                   	push   %ebp
80102031:	89 e5                	mov    %esp,%ebp
80102033:	57                   	push   %edi
80102034:	56                   	push   %esi
80102035:	53                   	push   %ebx
80102036:	83 ec 20             	sub    $0x20,%esp
80102039:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010203c:	6a 00                	push   $0x0
8010203e:	ff 75 0c             	push   0xc(%ebp)
80102041:	53                   	push   %ebx
80102042:	e8 19 fd ff ff       	call   80101d60 <dirlookup>
80102047:	83 c4 10             	add    $0x10,%esp
8010204a:	85 c0                	test   %eax,%eax
8010204c:	75 67                	jne    801020b5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010204e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102051:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102054:	85 ff                	test   %edi,%edi
80102056:	74 29                	je     80102081 <dirlink+0x51>
80102058:	31 ff                	xor    %edi,%edi
8010205a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010205d:	eb 09                	jmp    80102068 <dirlink+0x38>
8010205f:	90                   	nop
80102060:	83 c7 10             	add    $0x10,%edi
80102063:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102066:	73 19                	jae    80102081 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102068:	6a 10                	push   $0x10
8010206a:	57                   	push   %edi
8010206b:	56                   	push   %esi
8010206c:	53                   	push   %ebx
8010206d:	e8 ae fa ff ff       	call   80101b20 <readi>
80102072:	83 c4 10             	add    $0x10,%esp
80102075:	83 f8 10             	cmp    $0x10,%eax
80102078:	75 4e                	jne    801020c8 <dirlink+0x98>
    if(de.inum == 0)
8010207a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010207f:	75 df                	jne    80102060 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102081:	83 ec 04             	sub    $0x4,%esp
80102084:	8d 45 da             	lea    -0x26(%ebp),%eax
80102087:	6a 0e                	push   $0xe
80102089:	ff 75 0c             	push   0xc(%ebp)
8010208c:	50                   	push   %eax
8010208d:	e8 3e 28 00 00       	call   801048d0 <strncpy>
  de.inum = inum;
80102092:	8b 45 10             	mov    0x10(%ebp),%eax
80102095:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102099:	6a 10                	push   $0x10
8010209b:	57                   	push   %edi
8010209c:	56                   	push   %esi
8010209d:	53                   	push   %ebx
8010209e:	e8 7d fb ff ff       	call   80101c20 <writei>
801020a3:	83 c4 20             	add    $0x20,%esp
801020a6:	83 f8 10             	cmp    $0x10,%eax
801020a9:	75 2a                	jne    801020d5 <dirlink+0xa5>
  return 0;
801020ab:	31 c0                	xor    %eax,%eax
}
801020ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020b0:	5b                   	pop    %ebx
801020b1:	5e                   	pop    %esi
801020b2:	5f                   	pop    %edi
801020b3:	5d                   	pop    %ebp
801020b4:	c3                   	ret
    iput(ip);
801020b5:	83 ec 0c             	sub    $0xc,%esp
801020b8:	50                   	push   %eax
801020b9:	e8 82 f8 ff ff       	call   80101940 <iput>
    return -1;
801020be:	83 c4 10             	add    $0x10,%esp
801020c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020c6:	eb e5                	jmp    801020ad <dirlink+0x7d>
      panic("dirlink read");
801020c8:	83 ec 0c             	sub    $0xc,%esp
801020cb:	68 b2 73 10 80       	push   $0x801073b2
801020d0:	e8 ab e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
801020d5:	83 ec 0c             	sub    $0xc,%esp
801020d8:	68 3c 76 10 80       	push   $0x8010763c
801020dd:	e8 9e e2 ff ff       	call   80100380 <panic>
801020e2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801020e9:	00 
801020ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801020f0 <namei>:

struct inode*
namei(char *path)
{
801020f0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801020f1:	31 d2                	xor    %edx,%edx
{
801020f3:	89 e5                	mov    %esp,%ebp
801020f5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801020f8:	8b 45 08             	mov    0x8(%ebp),%eax
801020fb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801020fe:	e8 0d fd ff ff       	call   80101e10 <namex>
}
80102103:	c9                   	leave
80102104:	c3                   	ret
80102105:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010210c:	00 
8010210d:	8d 76 00             	lea    0x0(%esi),%esi

80102110 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102110:	55                   	push   %ebp
  return namex(path, 1, name);
80102111:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102116:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102118:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010211b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010211e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010211f:	e9 ec fc ff ff       	jmp    80101e10 <namex>
80102124:	66 90                	xchg   %ax,%ax
80102126:	66 90                	xchg   %ax,%ax
80102128:	66 90                	xchg   %ax,%ax
8010212a:	66 90                	xchg   %ax,%ax
8010212c:	66 90                	xchg   %ax,%ax
8010212e:	66 90                	xchg   %ax,%ax

80102130 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102130:	55                   	push   %ebp
80102131:	89 e5                	mov    %esp,%ebp
80102133:	57                   	push   %edi
80102134:	56                   	push   %esi
80102135:	53                   	push   %ebx
80102136:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102139:	85 c0                	test   %eax,%eax
8010213b:	0f 84 b4 00 00 00    	je     801021f5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102141:	8b 70 08             	mov    0x8(%eax),%esi
80102144:	89 c3                	mov    %eax,%ebx
80102146:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010214c:	0f 87 96 00 00 00    	ja     801021e8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102152:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102157:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010215e:	00 
8010215f:	90                   	nop
80102160:	89 ca                	mov    %ecx,%edx
80102162:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102163:	83 e0 c0             	and    $0xffffffc0,%eax
80102166:	3c 40                	cmp    $0x40,%al
80102168:	75 f6                	jne    80102160 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010216a:	31 ff                	xor    %edi,%edi
8010216c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102171:	89 f8                	mov    %edi,%eax
80102173:	ee                   	out    %al,(%dx)
80102174:	b8 01 00 00 00       	mov    $0x1,%eax
80102179:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010217e:	ee                   	out    %al,(%dx)
8010217f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102184:	89 f0                	mov    %esi,%eax
80102186:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102187:	89 f0                	mov    %esi,%eax
80102189:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010218e:	c1 f8 08             	sar    $0x8,%eax
80102191:	ee                   	out    %al,(%dx)
80102192:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102197:	89 f8                	mov    %edi,%eax
80102199:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010219a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010219e:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021a3:	c1 e0 04             	shl    $0x4,%eax
801021a6:	83 e0 10             	and    $0x10,%eax
801021a9:	83 c8 e0             	or     $0xffffffe0,%eax
801021ac:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801021ad:	f6 03 04             	testb  $0x4,(%ebx)
801021b0:	75 16                	jne    801021c8 <idestart+0x98>
801021b2:	b8 20 00 00 00       	mov    $0x20,%eax
801021b7:	89 ca                	mov    %ecx,%edx
801021b9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801021ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021bd:	5b                   	pop    %ebx
801021be:	5e                   	pop    %esi
801021bf:	5f                   	pop    %edi
801021c0:	5d                   	pop    %ebp
801021c1:	c3                   	ret
801021c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801021c8:	b8 30 00 00 00       	mov    $0x30,%eax
801021cd:	89 ca                	mov    %ecx,%edx
801021cf:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801021d0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801021d5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801021d8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801021dd:	fc                   	cld
801021de:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801021e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021e3:	5b                   	pop    %ebx
801021e4:	5e                   	pop    %esi
801021e5:	5f                   	pop    %edi
801021e6:	5d                   	pop    %ebp
801021e7:	c3                   	ret
    panic("incorrect blockno");
801021e8:	83 ec 0c             	sub    $0xc,%esp
801021eb:	68 c8 73 10 80       	push   $0x801073c8
801021f0:	e8 8b e1 ff ff       	call   80100380 <panic>
    panic("idestart");
801021f5:	83 ec 0c             	sub    $0xc,%esp
801021f8:	68 bf 73 10 80       	push   $0x801073bf
801021fd:	e8 7e e1 ff ff       	call   80100380 <panic>
80102202:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102209:	00 
8010220a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102210 <ideinit>:
{
80102210:	55                   	push   %ebp
80102211:	89 e5                	mov    %esp,%ebp
80102213:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102216:	68 da 73 10 80       	push   $0x801073da
8010221b:	68 20 16 11 80       	push   $0x80111620
80102220:	e8 6b 22 00 00       	call   80104490 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102225:	58                   	pop    %eax
80102226:	a1 a4 17 11 80       	mov    0x801117a4,%eax
8010222b:	5a                   	pop    %edx
8010222c:	83 e8 01             	sub    $0x1,%eax
8010222f:	50                   	push   %eax
80102230:	6a 0e                	push   $0xe
80102232:	e8 99 02 00 00       	call   801024d0 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102237:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010223a:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
8010223f:	90                   	nop
80102240:	89 ca                	mov    %ecx,%edx
80102242:	ec                   	in     (%dx),%al
80102243:	83 e0 c0             	and    $0xffffffc0,%eax
80102246:	3c 40                	cmp    $0x40,%al
80102248:	75 f6                	jne    80102240 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010224a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010224f:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102254:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102255:	89 ca                	mov    %ecx,%edx
80102257:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102258:	84 c0                	test   %al,%al
8010225a:	75 1e                	jne    8010227a <ideinit+0x6a>
8010225c:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
80102261:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102266:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010226d:	00 
8010226e:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
80102270:	83 e9 01             	sub    $0x1,%ecx
80102273:	74 0f                	je     80102284 <ideinit+0x74>
80102275:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102276:	84 c0                	test   %al,%al
80102278:	74 f6                	je     80102270 <ideinit+0x60>
      havedisk1 = 1;
8010227a:	c7 05 00 16 11 80 01 	movl   $0x1,0x80111600
80102281:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102284:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102289:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010228e:	ee                   	out    %al,(%dx)
}
8010228f:	c9                   	leave
80102290:	c3                   	ret
80102291:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102298:	00 
80102299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801022a0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801022a0:	55                   	push   %ebp
801022a1:	89 e5                	mov    %esp,%ebp
801022a3:	57                   	push   %edi
801022a4:	56                   	push   %esi
801022a5:	53                   	push   %ebx
801022a6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801022a9:	68 20 16 11 80       	push   $0x80111620
801022ae:	e8 cd 23 00 00       	call   80104680 <acquire>

  if((b = idequeue) == 0){
801022b3:	8b 1d 04 16 11 80    	mov    0x80111604,%ebx
801022b9:	83 c4 10             	add    $0x10,%esp
801022bc:	85 db                	test   %ebx,%ebx
801022be:	74 63                	je     80102323 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801022c0:	8b 43 58             	mov    0x58(%ebx),%eax
801022c3:	a3 04 16 11 80       	mov    %eax,0x80111604

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801022c8:	8b 33                	mov    (%ebx),%esi
801022ca:	f7 c6 04 00 00 00    	test   $0x4,%esi
801022d0:	75 2f                	jne    80102301 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022d2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022d7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801022de:	00 
801022df:	90                   	nop
801022e0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022e1:	89 c1                	mov    %eax,%ecx
801022e3:	83 e1 c0             	and    $0xffffffc0,%ecx
801022e6:	80 f9 40             	cmp    $0x40,%cl
801022e9:	75 f5                	jne    801022e0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801022eb:	a8 21                	test   $0x21,%al
801022ed:	75 12                	jne    80102301 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
801022ef:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801022f2:	b9 80 00 00 00       	mov    $0x80,%ecx
801022f7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801022fc:	fc                   	cld
801022fd:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801022ff:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80102301:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102304:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102307:	83 ce 02             	or     $0x2,%esi
8010230a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010230c:	53                   	push   %ebx
8010230d:	e8 ae 1e 00 00       	call   801041c0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102312:	a1 04 16 11 80       	mov    0x80111604,%eax
80102317:	83 c4 10             	add    $0x10,%esp
8010231a:	85 c0                	test   %eax,%eax
8010231c:	74 05                	je     80102323 <ideintr+0x83>
    idestart(idequeue);
8010231e:	e8 0d fe ff ff       	call   80102130 <idestart>
    release(&idelock);
80102323:	83 ec 0c             	sub    $0xc,%esp
80102326:	68 20 16 11 80       	push   $0x80111620
8010232b:	e8 f0 22 00 00       	call   80104620 <release>

  release(&idelock);
}
80102330:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102333:	5b                   	pop    %ebx
80102334:	5e                   	pop    %esi
80102335:	5f                   	pop    %edi
80102336:	5d                   	pop    %ebp
80102337:	c3                   	ret
80102338:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010233f:	00 

80102340 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102340:	55                   	push   %ebp
80102341:	89 e5                	mov    %esp,%ebp
80102343:	53                   	push   %ebx
80102344:	83 ec 10             	sub    $0x10,%esp
80102347:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010234a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010234d:	50                   	push   %eax
8010234e:	e8 ed 20 00 00       	call   80104440 <holdingsleep>
80102353:	83 c4 10             	add    $0x10,%esp
80102356:	85 c0                	test   %eax,%eax
80102358:	0f 84 c3 00 00 00    	je     80102421 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010235e:	8b 03                	mov    (%ebx),%eax
80102360:	83 e0 06             	and    $0x6,%eax
80102363:	83 f8 02             	cmp    $0x2,%eax
80102366:	0f 84 a8 00 00 00    	je     80102414 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010236c:	8b 53 04             	mov    0x4(%ebx),%edx
8010236f:	85 d2                	test   %edx,%edx
80102371:	74 0d                	je     80102380 <iderw+0x40>
80102373:	a1 00 16 11 80       	mov    0x80111600,%eax
80102378:	85 c0                	test   %eax,%eax
8010237a:	0f 84 87 00 00 00    	je     80102407 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102380:	83 ec 0c             	sub    $0xc,%esp
80102383:	68 20 16 11 80       	push   $0x80111620
80102388:	e8 f3 22 00 00       	call   80104680 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010238d:	a1 04 16 11 80       	mov    0x80111604,%eax
  b->qnext = 0;
80102392:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102399:	83 c4 10             	add    $0x10,%esp
8010239c:	85 c0                	test   %eax,%eax
8010239e:	74 60                	je     80102400 <iderw+0xc0>
801023a0:	89 c2                	mov    %eax,%edx
801023a2:	8b 40 58             	mov    0x58(%eax),%eax
801023a5:	85 c0                	test   %eax,%eax
801023a7:	75 f7                	jne    801023a0 <iderw+0x60>
801023a9:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801023ac:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801023ae:	39 1d 04 16 11 80    	cmp    %ebx,0x80111604
801023b4:	74 3a                	je     801023f0 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801023b6:	8b 03                	mov    (%ebx),%eax
801023b8:	83 e0 06             	and    $0x6,%eax
801023bb:	83 f8 02             	cmp    $0x2,%eax
801023be:	74 1b                	je     801023db <iderw+0x9b>
    sleep(b, &idelock);
801023c0:	83 ec 08             	sub    $0x8,%esp
801023c3:	68 20 16 11 80       	push   $0x80111620
801023c8:	53                   	push   %ebx
801023c9:	e8 32 1d 00 00       	call   80104100 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801023ce:	8b 03                	mov    (%ebx),%eax
801023d0:	83 c4 10             	add    $0x10,%esp
801023d3:	83 e0 06             	and    $0x6,%eax
801023d6:	83 f8 02             	cmp    $0x2,%eax
801023d9:	75 e5                	jne    801023c0 <iderw+0x80>
  }


  release(&idelock);
801023db:	c7 45 08 20 16 11 80 	movl   $0x80111620,0x8(%ebp)
}
801023e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023e5:	c9                   	leave
  release(&idelock);
801023e6:	e9 35 22 00 00       	jmp    80104620 <release>
801023eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    idestart(b);
801023f0:	89 d8                	mov    %ebx,%eax
801023f2:	e8 39 fd ff ff       	call   80102130 <idestart>
801023f7:	eb bd                	jmp    801023b6 <iderw+0x76>
801023f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102400:	ba 04 16 11 80       	mov    $0x80111604,%edx
80102405:	eb a5                	jmp    801023ac <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80102407:	83 ec 0c             	sub    $0xc,%esp
8010240a:	68 09 74 10 80       	push   $0x80107409
8010240f:	e8 6c df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
80102414:	83 ec 0c             	sub    $0xc,%esp
80102417:	68 f4 73 10 80       	push   $0x801073f4
8010241c:	e8 5f df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
80102421:	83 ec 0c             	sub    $0xc,%esp
80102424:	68 de 73 10 80       	push   $0x801073de
80102429:	e8 52 df ff ff       	call   80100380 <panic>
8010242e:	66 90                	xchg   %ax,%ax

80102430 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102430:	55                   	push   %ebp
80102431:	89 e5                	mov    %esp,%ebp
80102433:	56                   	push   %esi
80102434:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102435:	c7 05 54 16 11 80 00 	movl   $0xfec00000,0x80111654
8010243c:	00 c0 fe 
  ioapic->reg = reg;
8010243f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102446:	00 00 00 
  return ioapic->data;
80102449:	8b 15 54 16 11 80    	mov    0x80111654,%edx
8010244f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102452:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102458:	8b 1d 54 16 11 80    	mov    0x80111654,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010245e:	0f b6 15 a0 17 11 80 	movzbl 0x801117a0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102465:	c1 ee 10             	shr    $0x10,%esi
80102468:	89 f0                	mov    %esi,%eax
8010246a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010246d:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
80102470:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102473:	39 c2                	cmp    %eax,%edx
80102475:	74 16                	je     8010248d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102477:	83 ec 0c             	sub    $0xc,%esp
8010247a:	68 f4 77 10 80       	push   $0x801077f4
8010247f:	e8 2c e2 ff ff       	call   801006b0 <cprintf>
  ioapic->reg = reg;
80102484:	8b 1d 54 16 11 80    	mov    0x80111654,%ebx
8010248a:	83 c4 10             	add    $0x10,%esp
{
8010248d:	ba 10 00 00 00       	mov    $0x10,%edx
80102492:	31 c0                	xor    %eax,%eax
80102494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapic->reg = reg;
80102498:	89 13                	mov    %edx,(%ebx)
8010249a:	8d 48 20             	lea    0x20(%eax),%ecx
  ioapic->data = data;
8010249d:	8b 1d 54 16 11 80    	mov    0x80111654,%ebx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801024a3:	83 c0 01             	add    $0x1,%eax
801024a6:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  ioapic->data = data;
801024ac:	89 4b 10             	mov    %ecx,0x10(%ebx)
  ioapic->reg = reg;
801024af:	8d 4a 01             	lea    0x1(%edx),%ecx
  for(i = 0; i <= maxintr; i++){
801024b2:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
801024b5:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
801024b7:	8b 1d 54 16 11 80    	mov    0x80111654,%ebx
801024bd:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  for(i = 0; i <= maxintr; i++){
801024c4:	39 c6                	cmp    %eax,%esi
801024c6:	7d d0                	jge    80102498 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801024c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024cb:	5b                   	pop    %ebx
801024cc:	5e                   	pop    %esi
801024cd:	5d                   	pop    %ebp
801024ce:	c3                   	ret
801024cf:	90                   	nop

801024d0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801024d0:	55                   	push   %ebp
  ioapic->reg = reg;
801024d1:	8b 0d 54 16 11 80    	mov    0x80111654,%ecx
{
801024d7:	89 e5                	mov    %esp,%ebp
801024d9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801024dc:	8d 50 20             	lea    0x20(%eax),%edx
801024df:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801024e3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024e5:	8b 0d 54 16 11 80    	mov    0x80111654,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024eb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801024ee:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024f4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024f6:	a1 54 16 11 80       	mov    0x80111654,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024fb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024fe:	89 50 10             	mov    %edx,0x10(%eax)
}
80102501:	5d                   	pop    %ebp
80102502:	c3                   	ret
80102503:	66 90                	xchg   %ax,%ax
80102505:	66 90                	xchg   %ax,%ax
80102507:	66 90                	xchg   %ax,%ax
80102509:	66 90                	xchg   %ax,%ax
8010250b:	66 90                	xchg   %ax,%ax
8010250d:	66 90                	xchg   %ax,%ax
8010250f:	90                   	nop

80102510 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102510:	55                   	push   %ebp
80102511:	89 e5                	mov    %esp,%ebp
80102513:	53                   	push   %ebx
80102514:	83 ec 04             	sub    $0x4,%esp
80102517:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010251a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102520:	75 76                	jne    80102598 <kfree+0x88>
80102522:	81 fb f0 54 11 80    	cmp    $0x801154f0,%ebx
80102528:	72 6e                	jb     80102598 <kfree+0x88>
8010252a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102530:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102535:	77 61                	ja     80102598 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102537:	83 ec 04             	sub    $0x4,%esp
8010253a:	68 00 10 00 00       	push   $0x1000
8010253f:	6a 01                	push   $0x1
80102541:	53                   	push   %ebx
80102542:	e8 39 22 00 00       	call   80104780 <memset>

  if(kmem.use_lock)
80102547:	8b 15 94 16 11 80    	mov    0x80111694,%edx
8010254d:	83 c4 10             	add    $0x10,%esp
80102550:	85 d2                	test   %edx,%edx
80102552:	75 1c                	jne    80102570 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102554:	a1 98 16 11 80       	mov    0x80111698,%eax
80102559:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010255b:	a1 94 16 11 80       	mov    0x80111694,%eax
  kmem.freelist = r;
80102560:	89 1d 98 16 11 80    	mov    %ebx,0x80111698
  if(kmem.use_lock)
80102566:	85 c0                	test   %eax,%eax
80102568:	75 1e                	jne    80102588 <kfree+0x78>
    release(&kmem.lock);
}
8010256a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010256d:	c9                   	leave
8010256e:	c3                   	ret
8010256f:	90                   	nop
    acquire(&kmem.lock);
80102570:	83 ec 0c             	sub    $0xc,%esp
80102573:	68 60 16 11 80       	push   $0x80111660
80102578:	e8 03 21 00 00       	call   80104680 <acquire>
8010257d:	83 c4 10             	add    $0x10,%esp
80102580:	eb d2                	jmp    80102554 <kfree+0x44>
80102582:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102588:	c7 45 08 60 16 11 80 	movl   $0x80111660,0x8(%ebp)
}
8010258f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102592:	c9                   	leave
    release(&kmem.lock);
80102593:	e9 88 20 00 00       	jmp    80104620 <release>
    panic("kfree");
80102598:	83 ec 0c             	sub    $0xc,%esp
8010259b:	68 27 74 10 80       	push   $0x80107427
801025a0:	e8 db dd ff ff       	call   80100380 <panic>
801025a5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801025ac:	00 
801025ad:	8d 76 00             	lea    0x0(%esi),%esi

801025b0 <freerange>:
{
801025b0:	55                   	push   %ebp
801025b1:	89 e5                	mov    %esp,%ebp
801025b3:	56                   	push   %esi
801025b4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025b5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025b8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801025bb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025c1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025cd:	39 de                	cmp    %ebx,%esi
801025cf:	72 23                	jb     801025f4 <freerange+0x44>
801025d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025d8:	83 ec 0c             	sub    $0xc,%esp
801025db:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025e1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025e7:	50                   	push   %eax
801025e8:	e8 23 ff ff ff       	call   80102510 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025ed:	83 c4 10             	add    $0x10,%esp
801025f0:	39 de                	cmp    %ebx,%esi
801025f2:	73 e4                	jae    801025d8 <freerange+0x28>
}
801025f4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025f7:	5b                   	pop    %ebx
801025f8:	5e                   	pop    %esi
801025f9:	5d                   	pop    %ebp
801025fa:	c3                   	ret
801025fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102600 <kinit2>:
{
80102600:	55                   	push   %ebp
80102601:	89 e5                	mov    %esp,%ebp
80102603:	56                   	push   %esi
80102604:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102605:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102608:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010260b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102611:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102617:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010261d:	39 de                	cmp    %ebx,%esi
8010261f:	72 23                	jb     80102644 <kinit2+0x44>
80102621:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102628:	83 ec 0c             	sub    $0xc,%esp
8010262b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102631:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102637:	50                   	push   %eax
80102638:	e8 d3 fe ff ff       	call   80102510 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010263d:	83 c4 10             	add    $0x10,%esp
80102640:	39 de                	cmp    %ebx,%esi
80102642:	73 e4                	jae    80102628 <kinit2+0x28>
  kmem.use_lock = 1;
80102644:	c7 05 94 16 11 80 01 	movl   $0x1,0x80111694
8010264b:	00 00 00 
}
8010264e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102651:	5b                   	pop    %ebx
80102652:	5e                   	pop    %esi
80102653:	5d                   	pop    %ebp
80102654:	c3                   	ret
80102655:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010265c:	00 
8010265d:	8d 76 00             	lea    0x0(%esi),%esi

80102660 <kinit1>:
{
80102660:	55                   	push   %ebp
80102661:	89 e5                	mov    %esp,%ebp
80102663:	56                   	push   %esi
80102664:	53                   	push   %ebx
80102665:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102668:	83 ec 08             	sub    $0x8,%esp
8010266b:	68 2d 74 10 80       	push   $0x8010742d
80102670:	68 60 16 11 80       	push   $0x80111660
80102675:	e8 16 1e 00 00       	call   80104490 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010267a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010267d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102680:	c7 05 94 16 11 80 00 	movl   $0x0,0x80111694
80102687:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010268a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102690:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102696:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010269c:	39 de                	cmp    %ebx,%esi
8010269e:	72 1c                	jb     801026bc <kinit1+0x5c>
    kfree(p);
801026a0:	83 ec 0c             	sub    $0xc,%esp
801026a3:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026a9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801026af:	50                   	push   %eax
801026b0:	e8 5b fe ff ff       	call   80102510 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026b5:	83 c4 10             	add    $0x10,%esp
801026b8:	39 de                	cmp    %ebx,%esi
801026ba:	73 e4                	jae    801026a0 <kinit1+0x40>
}
801026bc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026bf:	5b                   	pop    %ebx
801026c0:	5e                   	pop    %esi
801026c1:	5d                   	pop    %ebp
801026c2:	c3                   	ret
801026c3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801026ca:	00 
801026cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801026d0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801026d0:	55                   	push   %ebp
801026d1:	89 e5                	mov    %esp,%ebp
801026d3:	53                   	push   %ebx
801026d4:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
801026d7:	a1 94 16 11 80       	mov    0x80111694,%eax
801026dc:	85 c0                	test   %eax,%eax
801026de:	75 20                	jne    80102700 <kalloc+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
801026e0:	8b 1d 98 16 11 80    	mov    0x80111698,%ebx
  if(r)
801026e6:	85 db                	test   %ebx,%ebx
801026e8:	74 07                	je     801026f1 <kalloc+0x21>
    kmem.freelist = r->next;
801026ea:	8b 03                	mov    (%ebx),%eax
801026ec:	a3 98 16 11 80       	mov    %eax,0x80111698
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
801026f1:	89 d8                	mov    %ebx,%eax
801026f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801026f6:	c9                   	leave
801026f7:	c3                   	ret
801026f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801026ff:	00 
    acquire(&kmem.lock);
80102700:	83 ec 0c             	sub    $0xc,%esp
80102703:	68 60 16 11 80       	push   $0x80111660
80102708:	e8 73 1f 00 00       	call   80104680 <acquire>
  r = kmem.freelist;
8010270d:	8b 1d 98 16 11 80    	mov    0x80111698,%ebx
  if(kmem.use_lock)
80102713:	a1 94 16 11 80       	mov    0x80111694,%eax
  if(r)
80102718:	83 c4 10             	add    $0x10,%esp
8010271b:	85 db                	test   %ebx,%ebx
8010271d:	74 08                	je     80102727 <kalloc+0x57>
    kmem.freelist = r->next;
8010271f:	8b 13                	mov    (%ebx),%edx
80102721:	89 15 98 16 11 80    	mov    %edx,0x80111698
  if(kmem.use_lock)
80102727:	85 c0                	test   %eax,%eax
80102729:	74 c6                	je     801026f1 <kalloc+0x21>
    release(&kmem.lock);
8010272b:	83 ec 0c             	sub    $0xc,%esp
8010272e:	68 60 16 11 80       	push   $0x80111660
80102733:	e8 e8 1e 00 00       	call   80104620 <release>
}
80102738:	89 d8                	mov    %ebx,%eax
    release(&kmem.lock);
8010273a:	83 c4 10             	add    $0x10,%esp
}
8010273d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102740:	c9                   	leave
80102741:	c3                   	ret
80102742:	66 90                	xchg   %ax,%ax
80102744:	66 90                	xchg   %ax,%ax
80102746:	66 90                	xchg   %ax,%ax
80102748:	66 90                	xchg   %ax,%ax
8010274a:	66 90                	xchg   %ax,%ax
8010274c:	66 90                	xchg   %ax,%ax
8010274e:	66 90                	xchg   %ax,%ax

80102750 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102750:	ba 64 00 00 00       	mov    $0x64,%edx
80102755:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102756:	a8 01                	test   $0x1,%al
80102758:	0f 84 c2 00 00 00    	je     80102820 <kbdgetc+0xd0>
{
8010275e:	55                   	push   %ebp
8010275f:	ba 60 00 00 00       	mov    $0x60,%edx
80102764:	89 e5                	mov    %esp,%ebp
80102766:	53                   	push   %ebx
80102767:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102768:	8b 1d 9c 16 11 80    	mov    0x8011169c,%ebx
  data = inb(KBDATAP);
8010276e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102771:	3c e0                	cmp    $0xe0,%al
80102773:	74 5b                	je     801027d0 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102775:	89 da                	mov    %ebx,%edx
80102777:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010277a:	84 c0                	test   %al,%al
8010277c:	78 62                	js     801027e0 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010277e:	85 d2                	test   %edx,%edx
80102780:	74 09                	je     8010278b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102782:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102785:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102788:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010278b:	0f b6 91 60 7a 10 80 	movzbl -0x7fef85a0(%ecx),%edx
  shift ^= togglecode[data];
80102792:	0f b6 81 60 79 10 80 	movzbl -0x7fef86a0(%ecx),%eax
  shift |= shiftcode[data];
80102799:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010279b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010279d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010279f:	89 15 9c 16 11 80    	mov    %edx,0x8011169c
  c = charcode[shift & (CTL | SHIFT)][data];
801027a5:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801027a8:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801027ab:	8b 04 85 40 79 10 80 	mov    -0x7fef86c0(,%eax,4),%eax
801027b2:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
801027b6:	74 0b                	je     801027c3 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
801027b8:	8d 50 9f             	lea    -0x61(%eax),%edx
801027bb:	83 fa 19             	cmp    $0x19,%edx
801027be:	77 48                	ja     80102808 <kbdgetc+0xb8>
      c += 'A' - 'a';
801027c0:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801027c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027c6:	c9                   	leave
801027c7:	c3                   	ret
801027c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801027cf:	00 
    shift |= E0ESC;
801027d0:	83 cb 40             	or     $0x40,%ebx
    return 0;
801027d3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801027d5:	89 1d 9c 16 11 80    	mov    %ebx,0x8011169c
}
801027db:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027de:	c9                   	leave
801027df:	c3                   	ret
    data = (shift & E0ESC ? data : data & 0x7F);
801027e0:	83 e0 7f             	and    $0x7f,%eax
801027e3:	85 d2                	test   %edx,%edx
801027e5:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
801027e8:	0f b6 81 60 7a 10 80 	movzbl -0x7fef85a0(%ecx),%eax
801027ef:	83 c8 40             	or     $0x40,%eax
801027f2:	0f b6 c0             	movzbl %al,%eax
801027f5:	f7 d0                	not    %eax
801027f7:	21 d8                	and    %ebx,%eax
801027f9:	a3 9c 16 11 80       	mov    %eax,0x8011169c
    return 0;
801027fe:	31 c0                	xor    %eax,%eax
80102800:	eb d9                	jmp    801027db <kbdgetc+0x8b>
80102802:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102808:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010280b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010280e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102811:	c9                   	leave
      c += 'a' - 'A';
80102812:	83 f9 1a             	cmp    $0x1a,%ecx
80102815:	0f 42 c2             	cmovb  %edx,%eax
}
80102818:	c3                   	ret
80102819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80102820:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102825:	c3                   	ret
80102826:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010282d:	00 
8010282e:	66 90                	xchg   %ax,%ax

80102830 <kbdintr>:

void
kbdintr(void)
{
80102830:	55                   	push   %ebp
80102831:	89 e5                	mov    %esp,%ebp
80102833:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102836:	68 50 27 10 80       	push   $0x80102750
8010283b:	e8 60 e0 ff ff       	call   801008a0 <consoleintr>
}
80102840:	83 c4 10             	add    $0x10,%esp
80102843:	c9                   	leave
80102844:	c3                   	ret
80102845:	66 90                	xchg   %ax,%ax
80102847:	66 90                	xchg   %ax,%ax
80102849:	66 90                	xchg   %ax,%ax
8010284b:	66 90                	xchg   %ax,%ax
8010284d:	66 90                	xchg   %ax,%ax
8010284f:	90                   	nop

80102850 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102850:	a1 a0 16 11 80       	mov    0x801116a0,%eax
80102855:	85 c0                	test   %eax,%eax
80102857:	0f 84 c3 00 00 00    	je     80102920 <lapicinit+0xd0>
  lapic[index] = value;
8010285d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102864:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102867:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010286a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102871:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102874:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102877:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010287e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102881:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102884:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010288b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010288e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102891:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102898:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010289b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010289e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801028a5:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028a8:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801028ab:	8b 50 30             	mov    0x30(%eax),%edx
801028ae:	81 e2 00 00 fc 00    	and    $0xfc0000,%edx
801028b4:	75 72                	jne    80102928 <lapicinit+0xd8>
  lapic[index] = value;
801028b6:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801028bd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028c0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028c3:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801028ca:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028cd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028d0:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801028d7:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028da:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028dd:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801028e4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028e7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028ea:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801028f1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028f4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028f7:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801028fe:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102901:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102908:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010290e:	80 e6 10             	and    $0x10,%dh
80102911:	75 f5                	jne    80102908 <lapicinit+0xb8>
  lapic[index] = value;
80102913:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010291a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010291d:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102920:	c3                   	ret
80102921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102928:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
8010292f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102932:	8b 50 20             	mov    0x20(%eax),%edx
}
80102935:	e9 7c ff ff ff       	jmp    801028b6 <lapicinit+0x66>
8010293a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102940 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102940:	a1 a0 16 11 80       	mov    0x801116a0,%eax
80102945:	85 c0                	test   %eax,%eax
80102947:	74 07                	je     80102950 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102949:	8b 40 20             	mov    0x20(%eax),%eax
8010294c:	c1 e8 18             	shr    $0x18,%eax
8010294f:	c3                   	ret
    return 0;
80102950:	31 c0                	xor    %eax,%eax
}
80102952:	c3                   	ret
80102953:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010295a:	00 
8010295b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102960 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102960:	a1 a0 16 11 80       	mov    0x801116a0,%eax
80102965:	85 c0                	test   %eax,%eax
80102967:	74 0d                	je     80102976 <lapiceoi+0x16>
  lapic[index] = value;
80102969:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102970:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102973:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102976:	c3                   	ret
80102977:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010297e:	00 
8010297f:	90                   	nop

80102980 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102980:	c3                   	ret
80102981:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102988:	00 
80102989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102990 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102990:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102991:	b8 0f 00 00 00       	mov    $0xf,%eax
80102996:	ba 70 00 00 00       	mov    $0x70,%edx
8010299b:	89 e5                	mov    %esp,%ebp
8010299d:	53                   	push   %ebx
8010299e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801029a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801029a4:	ee                   	out    %al,(%dx)
801029a5:	b8 0a 00 00 00       	mov    $0xa,%eax
801029aa:	ba 71 00 00 00       	mov    $0x71,%edx
801029af:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801029b0:	31 c0                	xor    %eax,%eax
  lapic[index] = value;
801029b2:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801029b5:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801029bb:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801029bd:	c1 e9 0c             	shr    $0xc,%ecx
  lapic[index] = value;
801029c0:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
801029c2:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
801029c5:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801029c8:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801029ce:	a1 a0 16 11 80       	mov    0x801116a0,%eax
801029d3:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029d9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029dc:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801029e3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029e6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029e9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801029f0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029f3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029f6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029fc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029ff:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a05:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a08:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a0e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a11:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a17:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102a1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a1d:	c9                   	leave
80102a1e:	c3                   	ret
80102a1f:	90                   	nop

80102a20 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102a20:	55                   	push   %ebp
80102a21:	b8 0b 00 00 00       	mov    $0xb,%eax
80102a26:	ba 70 00 00 00       	mov    $0x70,%edx
80102a2b:	89 e5                	mov    %esp,%ebp
80102a2d:	57                   	push   %edi
80102a2e:	56                   	push   %esi
80102a2f:	53                   	push   %ebx
80102a30:	83 ec 4c             	sub    $0x4c,%esp
80102a33:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a34:	ba 71 00 00 00       	mov    $0x71,%edx
80102a39:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102a3a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a3d:	bf 70 00 00 00       	mov    $0x70,%edi
80102a42:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102a45:	8d 76 00             	lea    0x0(%esi),%esi
80102a48:	31 c0                	xor    %eax,%eax
80102a4a:	89 fa                	mov    %edi,%edx
80102a4c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a4d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a52:	89 ca                	mov    %ecx,%edx
80102a54:	ec                   	in     (%dx),%al
80102a55:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a58:	89 fa                	mov    %edi,%edx
80102a5a:	b8 02 00 00 00       	mov    $0x2,%eax
80102a5f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a60:	89 ca                	mov    %ecx,%edx
80102a62:	ec                   	in     (%dx),%al
80102a63:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a66:	89 fa                	mov    %edi,%edx
80102a68:	b8 04 00 00 00       	mov    $0x4,%eax
80102a6d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a6e:	89 ca                	mov    %ecx,%edx
80102a70:	ec                   	in     (%dx),%al
80102a71:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a74:	89 fa                	mov    %edi,%edx
80102a76:	b8 07 00 00 00       	mov    $0x7,%eax
80102a7b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a7c:	89 ca                	mov    %ecx,%edx
80102a7e:	ec                   	in     (%dx),%al
80102a7f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a82:	89 fa                	mov    %edi,%edx
80102a84:	b8 08 00 00 00       	mov    $0x8,%eax
80102a89:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a8a:	89 ca                	mov    %ecx,%edx
80102a8c:	ec                   	in     (%dx),%al
80102a8d:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a8f:	89 fa                	mov    %edi,%edx
80102a91:	b8 09 00 00 00       	mov    $0x9,%eax
80102a96:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a97:	89 ca                	mov    %ecx,%edx
80102a99:	ec                   	in     (%dx),%al
80102a9a:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a9d:	89 fa                	mov    %edi,%edx
80102a9f:	b8 0a 00 00 00       	mov    $0xa,%eax
80102aa4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aa5:	89 ca                	mov    %ecx,%edx
80102aa7:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102aa8:	84 c0                	test   %al,%al
80102aaa:	78 9c                	js     80102a48 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102aac:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102ab0:	89 f2                	mov    %esi,%edx
80102ab2:	89 5d cc             	mov    %ebx,-0x34(%ebp)
80102ab5:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab8:	89 fa                	mov    %edi,%edx
80102aba:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102abd:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102ac1:	89 75 c8             	mov    %esi,-0x38(%ebp)
80102ac4:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102ac7:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102acb:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102ace:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102ad2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102ad5:	31 c0                	xor    %eax,%eax
80102ad7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ad8:	89 ca                	mov    %ecx,%edx
80102ada:	ec                   	in     (%dx),%al
80102adb:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ade:	89 fa                	mov    %edi,%edx
80102ae0:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102ae3:	b8 02 00 00 00       	mov    $0x2,%eax
80102ae8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ae9:	89 ca                	mov    %ecx,%edx
80102aeb:	ec                   	in     (%dx),%al
80102aec:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aef:	89 fa                	mov    %edi,%edx
80102af1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102af4:	b8 04 00 00 00       	mov    $0x4,%eax
80102af9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102afa:	89 ca                	mov    %ecx,%edx
80102afc:	ec                   	in     (%dx),%al
80102afd:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b00:	89 fa                	mov    %edi,%edx
80102b02:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102b05:	b8 07 00 00 00       	mov    $0x7,%eax
80102b0a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b0b:	89 ca                	mov    %ecx,%edx
80102b0d:	ec                   	in     (%dx),%al
80102b0e:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b11:	89 fa                	mov    %edi,%edx
80102b13:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102b16:	b8 08 00 00 00       	mov    $0x8,%eax
80102b1b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b1c:	89 ca                	mov    %ecx,%edx
80102b1e:	ec                   	in     (%dx),%al
80102b1f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b22:	89 fa                	mov    %edi,%edx
80102b24:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102b27:	b8 09 00 00 00       	mov    $0x9,%eax
80102b2c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b2d:	89 ca                	mov    %ecx,%edx
80102b2f:	ec                   	in     (%dx),%al
80102b30:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b33:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102b36:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b39:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102b3c:	6a 18                	push   $0x18
80102b3e:	50                   	push   %eax
80102b3f:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102b42:	50                   	push   %eax
80102b43:	e8 78 1c 00 00       	call   801047c0 <memcmp>
80102b48:	83 c4 10             	add    $0x10,%esp
80102b4b:	85 c0                	test   %eax,%eax
80102b4d:	0f 85 f5 fe ff ff    	jne    80102a48 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102b53:	0f b6 75 b3          	movzbl -0x4d(%ebp),%esi
80102b57:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102b5a:	89 f0                	mov    %esi,%eax
80102b5c:	84 c0                	test   %al,%al
80102b5e:	75 78                	jne    80102bd8 <cmostime+0x1b8>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b60:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b63:	89 c2                	mov    %eax,%edx
80102b65:	83 e0 0f             	and    $0xf,%eax
80102b68:	c1 ea 04             	shr    $0x4,%edx
80102b6b:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b6e:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b71:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b74:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b77:	89 c2                	mov    %eax,%edx
80102b79:	83 e0 0f             	and    $0xf,%eax
80102b7c:	c1 ea 04             	shr    $0x4,%edx
80102b7f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b82:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b85:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b88:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b8b:	89 c2                	mov    %eax,%edx
80102b8d:	83 e0 0f             	and    $0xf,%eax
80102b90:	c1 ea 04             	shr    $0x4,%edx
80102b93:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b96:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b99:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b9c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b9f:	89 c2                	mov    %eax,%edx
80102ba1:	83 e0 0f             	and    $0xf,%eax
80102ba4:	c1 ea 04             	shr    $0x4,%edx
80102ba7:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102baa:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bad:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102bb0:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102bb3:	89 c2                	mov    %eax,%edx
80102bb5:	83 e0 0f             	and    $0xf,%eax
80102bb8:	c1 ea 04             	shr    $0x4,%edx
80102bbb:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bbe:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bc1:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102bc4:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102bc7:	89 c2                	mov    %eax,%edx
80102bc9:	83 e0 0f             	and    $0xf,%eax
80102bcc:	c1 ea 04             	shr    $0x4,%edx
80102bcf:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bd2:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bd5:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102bd8:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102bdb:	89 03                	mov    %eax,(%ebx)
80102bdd:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102be0:	89 43 04             	mov    %eax,0x4(%ebx)
80102be3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102be6:	89 43 08             	mov    %eax,0x8(%ebx)
80102be9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102bec:	89 43 0c             	mov    %eax,0xc(%ebx)
80102bef:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102bf2:	89 43 10             	mov    %eax,0x10(%ebx)
80102bf5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102bf8:	89 43 14             	mov    %eax,0x14(%ebx)
  r->year += 2000;
80102bfb:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
80102c02:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c05:	5b                   	pop    %ebx
80102c06:	5e                   	pop    %esi
80102c07:	5f                   	pop    %edi
80102c08:	5d                   	pop    %ebp
80102c09:	c3                   	ret
80102c0a:	66 90                	xchg   %ax,%ax
80102c0c:	66 90                	xchg   %ax,%ax
80102c0e:	66 90                	xchg   %ax,%ax

80102c10 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c10:	8b 0d 08 17 11 80    	mov    0x80111708,%ecx
80102c16:	85 c9                	test   %ecx,%ecx
80102c18:	0f 8e 8a 00 00 00    	jle    80102ca8 <install_trans+0x98>
{
80102c1e:	55                   	push   %ebp
80102c1f:	89 e5                	mov    %esp,%ebp
80102c21:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102c22:	31 ff                	xor    %edi,%edi
{
80102c24:	56                   	push   %esi
80102c25:	53                   	push   %ebx
80102c26:	83 ec 0c             	sub    $0xc,%esp
80102c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102c30:	a1 f4 16 11 80       	mov    0x801116f4,%eax
80102c35:	83 ec 08             	sub    $0x8,%esp
80102c38:	01 f8                	add    %edi,%eax
80102c3a:	83 c0 01             	add    $0x1,%eax
80102c3d:	50                   	push   %eax
80102c3e:	ff 35 04 17 11 80    	push   0x80111704
80102c44:	e8 87 d4 ff ff       	call   801000d0 <bread>
80102c49:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c4b:	58                   	pop    %eax
80102c4c:	5a                   	pop    %edx
80102c4d:	ff 34 bd 0c 17 11 80 	push   -0x7feee8f4(,%edi,4)
80102c54:	ff 35 04 17 11 80    	push   0x80111704
  for (tail = 0; tail < log.lh.n; tail++) {
80102c5a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c5d:	e8 6e d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c62:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c65:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c67:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c6a:	68 00 02 00 00       	push   $0x200
80102c6f:	50                   	push   %eax
80102c70:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c73:	50                   	push   %eax
80102c74:	e8 97 1b 00 00       	call   80104810 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c79:	89 1c 24             	mov    %ebx,(%esp)
80102c7c:	e8 2f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c81:	89 34 24             	mov    %esi,(%esp)
80102c84:	e8 67 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c89:	89 1c 24             	mov    %ebx,(%esp)
80102c8c:	e8 5f d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c91:	83 c4 10             	add    $0x10,%esp
80102c94:	39 3d 08 17 11 80    	cmp    %edi,0x80111708
80102c9a:	7f 94                	jg     80102c30 <install_trans+0x20>
  }
}
80102c9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c9f:	5b                   	pop    %ebx
80102ca0:	5e                   	pop    %esi
80102ca1:	5f                   	pop    %edi
80102ca2:	5d                   	pop    %ebp
80102ca3:	c3                   	ret
80102ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ca8:	c3                   	ret
80102ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102cb0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102cb0:	55                   	push   %ebp
80102cb1:	89 e5                	mov    %esp,%ebp
80102cb3:	53                   	push   %ebx
80102cb4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102cb7:	ff 35 f4 16 11 80    	push   0x801116f4
80102cbd:	ff 35 04 17 11 80    	push   0x80111704
80102cc3:	e8 08 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102cc8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102ccb:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102ccd:	a1 08 17 11 80       	mov    0x80111708,%eax
80102cd2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102cd5:	85 c0                	test   %eax,%eax
80102cd7:	7e 19                	jle    80102cf2 <write_head+0x42>
80102cd9:	31 d2                	xor    %edx,%edx
80102cdb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102ce0:	8b 0c 95 0c 17 11 80 	mov    -0x7feee8f4(,%edx,4),%ecx
80102ce7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102ceb:	83 c2 01             	add    $0x1,%edx
80102cee:	39 d0                	cmp    %edx,%eax
80102cf0:	75 ee                	jne    80102ce0 <write_head+0x30>
  }
  bwrite(buf);
80102cf2:	83 ec 0c             	sub    $0xc,%esp
80102cf5:	53                   	push   %ebx
80102cf6:	e8 b5 d4 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102cfb:	89 1c 24             	mov    %ebx,(%esp)
80102cfe:	e8 ed d4 ff ff       	call   801001f0 <brelse>
}
80102d03:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d06:	83 c4 10             	add    $0x10,%esp
80102d09:	c9                   	leave
80102d0a:	c3                   	ret
80102d0b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102d10 <initlog>:
{
80102d10:	55                   	push   %ebp
80102d11:	89 e5                	mov    %esp,%ebp
80102d13:	53                   	push   %ebx
80102d14:	83 ec 2c             	sub    $0x2c,%esp
80102d17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102d1a:	68 32 74 10 80       	push   $0x80107432
80102d1f:	68 c0 16 11 80       	push   $0x801116c0
80102d24:	e8 67 17 00 00       	call   80104490 <initlock>
  readsb(dev, &sb);
80102d29:	58                   	pop    %eax
80102d2a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102d2d:	5a                   	pop    %edx
80102d2e:	50                   	push   %eax
80102d2f:	53                   	push   %ebx
80102d30:	e8 7b e8 ff ff       	call   801015b0 <readsb>
  log.start = sb.logstart;
80102d35:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102d38:	59                   	pop    %ecx
  log.dev = dev;
80102d39:	89 1d 04 17 11 80    	mov    %ebx,0x80111704
  log.size = sb.nlog;
80102d3f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102d42:	a3 f4 16 11 80       	mov    %eax,0x801116f4
  log.size = sb.nlog;
80102d47:	89 15 f8 16 11 80    	mov    %edx,0x801116f8
  struct buf *buf = bread(log.dev, log.start);
80102d4d:	5a                   	pop    %edx
80102d4e:	50                   	push   %eax
80102d4f:	53                   	push   %ebx
80102d50:	e8 7b d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d55:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d58:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102d5b:	89 1d 08 17 11 80    	mov    %ebx,0x80111708
  for (i = 0; i < log.lh.n; i++) {
80102d61:	85 db                	test   %ebx,%ebx
80102d63:	7e 1d                	jle    80102d82 <initlog+0x72>
80102d65:	31 d2                	xor    %edx,%edx
80102d67:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102d6e:	00 
80102d6f:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102d70:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102d74:	89 0c 95 0c 17 11 80 	mov    %ecx,-0x7feee8f4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d7b:	83 c2 01             	add    $0x1,%edx
80102d7e:	39 d3                	cmp    %edx,%ebx
80102d80:	75 ee                	jne    80102d70 <initlog+0x60>
  brelse(buf);
80102d82:	83 ec 0c             	sub    $0xc,%esp
80102d85:	50                   	push   %eax
80102d86:	e8 65 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d8b:	e8 80 fe ff ff       	call   80102c10 <install_trans>
  log.lh.n = 0;
80102d90:	c7 05 08 17 11 80 00 	movl   $0x0,0x80111708
80102d97:	00 00 00 
  write_head(); // clear the log
80102d9a:	e8 11 ff ff ff       	call   80102cb0 <write_head>
}
80102d9f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102da2:	83 c4 10             	add    $0x10,%esp
80102da5:	c9                   	leave
80102da6:	c3                   	ret
80102da7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102dae:	00 
80102daf:	90                   	nop

80102db0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102db0:	55                   	push   %ebp
80102db1:	89 e5                	mov    %esp,%ebp
80102db3:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102db6:	68 c0 16 11 80       	push   $0x801116c0
80102dbb:	e8 c0 18 00 00       	call   80104680 <acquire>
80102dc0:	83 c4 10             	add    $0x10,%esp
80102dc3:	eb 18                	jmp    80102ddd <begin_op+0x2d>
80102dc5:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102dc8:	83 ec 08             	sub    $0x8,%esp
80102dcb:	68 c0 16 11 80       	push   $0x801116c0
80102dd0:	68 c0 16 11 80       	push   $0x801116c0
80102dd5:	e8 26 13 00 00       	call   80104100 <sleep>
80102dda:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102ddd:	a1 00 17 11 80       	mov    0x80111700,%eax
80102de2:	85 c0                	test   %eax,%eax
80102de4:	75 e2                	jne    80102dc8 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102de6:	a1 fc 16 11 80       	mov    0x801116fc,%eax
80102deb:	8b 15 08 17 11 80    	mov    0x80111708,%edx
80102df1:	83 c0 01             	add    $0x1,%eax
80102df4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102df7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102dfa:	83 fa 1e             	cmp    $0x1e,%edx
80102dfd:	7f c9                	jg     80102dc8 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102dff:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102e02:	a3 fc 16 11 80       	mov    %eax,0x801116fc
      release(&log.lock);
80102e07:	68 c0 16 11 80       	push   $0x801116c0
80102e0c:	e8 0f 18 00 00       	call   80104620 <release>
      break;
    }
  }
}
80102e11:	83 c4 10             	add    $0x10,%esp
80102e14:	c9                   	leave
80102e15:	c3                   	ret
80102e16:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102e1d:	00 
80102e1e:	66 90                	xchg   %ax,%ax

80102e20 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102e20:	55                   	push   %ebp
80102e21:	89 e5                	mov    %esp,%ebp
80102e23:	57                   	push   %edi
80102e24:	56                   	push   %esi
80102e25:	53                   	push   %ebx
80102e26:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102e29:	68 c0 16 11 80       	push   $0x801116c0
80102e2e:	e8 4d 18 00 00       	call   80104680 <acquire>
  log.outstanding -= 1;
80102e33:	a1 fc 16 11 80       	mov    0x801116fc,%eax
  if(log.committing)
80102e38:	8b 35 00 17 11 80    	mov    0x80111700,%esi
80102e3e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102e41:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102e44:	89 1d fc 16 11 80    	mov    %ebx,0x801116fc
  if(log.committing)
80102e4a:	85 f6                	test   %esi,%esi
80102e4c:	0f 85 22 01 00 00    	jne    80102f74 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e52:	85 db                	test   %ebx,%ebx
80102e54:	0f 85 f6 00 00 00    	jne    80102f50 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e5a:	c7 05 00 17 11 80 01 	movl   $0x1,0x80111700
80102e61:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e64:	83 ec 0c             	sub    $0xc,%esp
80102e67:	68 c0 16 11 80       	push   $0x801116c0
80102e6c:	e8 af 17 00 00       	call   80104620 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e71:	8b 0d 08 17 11 80    	mov    0x80111708,%ecx
80102e77:	83 c4 10             	add    $0x10,%esp
80102e7a:	85 c9                	test   %ecx,%ecx
80102e7c:	7f 42                	jg     80102ec0 <end_op+0xa0>
    acquire(&log.lock);
80102e7e:	83 ec 0c             	sub    $0xc,%esp
80102e81:	68 c0 16 11 80       	push   $0x801116c0
80102e86:	e8 f5 17 00 00       	call   80104680 <acquire>
    log.committing = 0;
80102e8b:	c7 05 00 17 11 80 00 	movl   $0x0,0x80111700
80102e92:	00 00 00 
    wakeup(&log);
80102e95:	c7 04 24 c0 16 11 80 	movl   $0x801116c0,(%esp)
80102e9c:	e8 1f 13 00 00       	call   801041c0 <wakeup>
    release(&log.lock);
80102ea1:	c7 04 24 c0 16 11 80 	movl   $0x801116c0,(%esp)
80102ea8:	e8 73 17 00 00       	call   80104620 <release>
80102ead:	83 c4 10             	add    $0x10,%esp
}
80102eb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102eb3:	5b                   	pop    %ebx
80102eb4:	5e                   	pop    %esi
80102eb5:	5f                   	pop    %edi
80102eb6:	5d                   	pop    %ebp
80102eb7:	c3                   	ret
80102eb8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102ebf:	00 
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102ec0:	a1 f4 16 11 80       	mov    0x801116f4,%eax
80102ec5:	83 ec 08             	sub    $0x8,%esp
80102ec8:	01 d8                	add    %ebx,%eax
80102eca:	83 c0 01             	add    $0x1,%eax
80102ecd:	50                   	push   %eax
80102ece:	ff 35 04 17 11 80    	push   0x80111704
80102ed4:	e8 f7 d1 ff ff       	call   801000d0 <bread>
80102ed9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102edb:	58                   	pop    %eax
80102edc:	5a                   	pop    %edx
80102edd:	ff 34 9d 0c 17 11 80 	push   -0x7feee8f4(,%ebx,4)
80102ee4:	ff 35 04 17 11 80    	push   0x80111704
  for (tail = 0; tail < log.lh.n; tail++) {
80102eea:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102eed:	e8 de d1 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102ef2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ef5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ef7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102efa:	68 00 02 00 00       	push   $0x200
80102eff:	50                   	push   %eax
80102f00:	8d 46 5c             	lea    0x5c(%esi),%eax
80102f03:	50                   	push   %eax
80102f04:	e8 07 19 00 00       	call   80104810 <memmove>
    bwrite(to);  // write the log
80102f09:	89 34 24             	mov    %esi,(%esp)
80102f0c:	e8 9f d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102f11:	89 3c 24             	mov    %edi,(%esp)
80102f14:	e8 d7 d2 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102f19:	89 34 24             	mov    %esi,(%esp)
80102f1c:	e8 cf d2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102f21:	83 c4 10             	add    $0x10,%esp
80102f24:	3b 1d 08 17 11 80    	cmp    0x80111708,%ebx
80102f2a:	7c 94                	jl     80102ec0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102f2c:	e8 7f fd ff ff       	call   80102cb0 <write_head>
    install_trans(); // Now install writes to home locations
80102f31:	e8 da fc ff ff       	call   80102c10 <install_trans>
    log.lh.n = 0;
80102f36:	c7 05 08 17 11 80 00 	movl   $0x0,0x80111708
80102f3d:	00 00 00 
    write_head();    // Erase the transaction from the log
80102f40:	e8 6b fd ff ff       	call   80102cb0 <write_head>
80102f45:	e9 34 ff ff ff       	jmp    80102e7e <end_op+0x5e>
80102f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f50:	83 ec 0c             	sub    $0xc,%esp
80102f53:	68 c0 16 11 80       	push   $0x801116c0
80102f58:	e8 63 12 00 00       	call   801041c0 <wakeup>
  release(&log.lock);
80102f5d:	c7 04 24 c0 16 11 80 	movl   $0x801116c0,(%esp)
80102f64:	e8 b7 16 00 00       	call   80104620 <release>
80102f69:	83 c4 10             	add    $0x10,%esp
}
80102f6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f6f:	5b                   	pop    %ebx
80102f70:	5e                   	pop    %esi
80102f71:	5f                   	pop    %edi
80102f72:	5d                   	pop    %ebp
80102f73:	c3                   	ret
    panic("log.committing");
80102f74:	83 ec 0c             	sub    $0xc,%esp
80102f77:	68 36 74 10 80       	push   $0x80107436
80102f7c:	e8 ff d3 ff ff       	call   80100380 <panic>
80102f81:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102f88:	00 
80102f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102f90 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f90:	55                   	push   %ebp
80102f91:	89 e5                	mov    %esp,%ebp
80102f93:	53                   	push   %ebx
80102f94:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f97:	8b 15 08 17 11 80    	mov    0x80111708,%edx
{
80102f9d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102fa0:	83 fa 1d             	cmp    $0x1d,%edx
80102fa3:	7f 7d                	jg     80103022 <log_write+0x92>
80102fa5:	a1 f8 16 11 80       	mov    0x801116f8,%eax
80102faa:	83 e8 01             	sub    $0x1,%eax
80102fad:	39 c2                	cmp    %eax,%edx
80102faf:	7d 71                	jge    80103022 <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102fb1:	a1 fc 16 11 80       	mov    0x801116fc,%eax
80102fb6:	85 c0                	test   %eax,%eax
80102fb8:	7e 75                	jle    8010302f <log_write+0x9f>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102fba:	83 ec 0c             	sub    $0xc,%esp
80102fbd:	68 c0 16 11 80       	push   $0x801116c0
80102fc2:	e8 b9 16 00 00       	call   80104680 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fc7:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102fca:	83 c4 10             	add    $0x10,%esp
80102fcd:	31 c0                	xor    %eax,%eax
80102fcf:	8b 15 08 17 11 80    	mov    0x80111708,%edx
80102fd5:	85 d2                	test   %edx,%edx
80102fd7:	7f 0e                	jg     80102fe7 <log_write+0x57>
80102fd9:	eb 15                	jmp    80102ff0 <log_write+0x60>
80102fdb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80102fe0:	83 c0 01             	add    $0x1,%eax
80102fe3:	39 c2                	cmp    %eax,%edx
80102fe5:	74 29                	je     80103010 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fe7:	39 0c 85 0c 17 11 80 	cmp    %ecx,-0x7feee8f4(,%eax,4)
80102fee:	75 f0                	jne    80102fe0 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80102ff0:	89 0c 85 0c 17 11 80 	mov    %ecx,-0x7feee8f4(,%eax,4)
  if (i == log.lh.n)
80102ff7:	39 c2                	cmp    %eax,%edx
80102ff9:	74 1c                	je     80103017 <log_write+0x87>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102ffb:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102ffe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80103001:	c7 45 08 c0 16 11 80 	movl   $0x801116c0,0x8(%ebp)
}
80103008:	c9                   	leave
  release(&log.lock);
80103009:	e9 12 16 00 00       	jmp    80104620 <release>
8010300e:	66 90                	xchg   %ax,%ax
  log.lh.block[i] = b->blockno;
80103010:	89 0c 95 0c 17 11 80 	mov    %ecx,-0x7feee8f4(,%edx,4)
    log.lh.n++;
80103017:	83 c2 01             	add    $0x1,%edx
8010301a:	89 15 08 17 11 80    	mov    %edx,0x80111708
80103020:	eb d9                	jmp    80102ffb <log_write+0x6b>
    panic("too big a transaction");
80103022:	83 ec 0c             	sub    $0xc,%esp
80103025:	68 45 74 10 80       	push   $0x80107445
8010302a:	e8 51 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
8010302f:	83 ec 0c             	sub    $0xc,%esp
80103032:	68 5b 74 10 80       	push   $0x8010745b
80103037:	e8 44 d3 ff ff       	call   80100380 <panic>
8010303c:	66 90                	xchg   %ax,%ax
8010303e:	66 90                	xchg   %ax,%ax

80103040 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103040:	55                   	push   %ebp
80103041:	89 e5                	mov    %esp,%ebp
80103043:	53                   	push   %ebx
80103044:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103047:	e8 d4 09 00 00       	call   80103a20 <cpuid>
8010304c:	89 c3                	mov    %eax,%ebx
8010304e:	e8 cd 09 00 00       	call   80103a20 <cpuid>
80103053:	83 ec 04             	sub    $0x4,%esp
80103056:	53                   	push   %ebx
80103057:	50                   	push   %eax
80103058:	68 76 74 10 80       	push   $0x80107476
8010305d:	e8 4e d6 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103062:	e8 59 29 00 00       	call   801059c0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103067:	e8 54 09 00 00       	call   801039c0 <mycpu>
8010306c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010306e:	b8 01 00 00 00       	mov    $0x1,%eax
80103073:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010307a:	e8 71 0c 00 00       	call   80103cf0 <scheduler>
8010307f:	90                   	nop

80103080 <mpenter>:
{
80103080:	55                   	push   %ebp
80103081:	89 e5                	mov    %esp,%ebp
80103083:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103086:	e8 35 3a 00 00       	call   80106ac0 <switchkvm>
  seginit();
8010308b:	e8 a0 39 00 00       	call   80106a30 <seginit>
  lapicinit();
80103090:	e8 bb f7 ff ff       	call   80102850 <lapicinit>
  mpmain();
80103095:	e8 a6 ff ff ff       	call   80103040 <mpmain>
8010309a:	66 90                	xchg   %ax,%ax
8010309c:	66 90                	xchg   %ax,%ax
8010309e:	66 90                	xchg   %ax,%ax

801030a0 <main>:
{
801030a0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801030a4:	83 e4 f0             	and    $0xfffffff0,%esp
801030a7:	ff 71 fc             	push   -0x4(%ecx)
801030aa:	55                   	push   %ebp
801030ab:	89 e5                	mov    %esp,%ebp
801030ad:	53                   	push   %ebx
801030ae:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801030af:	83 ec 08             	sub    $0x8,%esp
801030b2:	68 00 00 40 80       	push   $0x80400000
801030b7:	68 f0 54 11 80       	push   $0x801154f0
801030bc:	e8 9f f5 ff ff       	call   80102660 <kinit1>
  kvmalloc();      // kernel page table
801030c1:	e8 ba 3e 00 00       	call   80106f80 <kvmalloc>
  mpinit();        // detect other processors
801030c6:	e8 85 01 00 00       	call   80103250 <mpinit>
  lapicinit();     // interrupt controller
801030cb:	e8 80 f7 ff ff       	call   80102850 <lapicinit>
  seginit();       // segment descriptors
801030d0:	e8 5b 39 00 00       	call   80106a30 <seginit>
  picinit();       // disable pic
801030d5:	e8 86 03 00 00       	call   80103460 <picinit>
  ioapicinit();    // another interrupt controller
801030da:	e8 51 f3 ff ff       	call   80102430 <ioapicinit>
  consoleinit();   // console hardware
801030df:	e8 ec d9 ff ff       	call   80100ad0 <consoleinit>
  uartinit();      // serial port
801030e4:	e8 b7 2b 00 00       	call   80105ca0 <uartinit>
  pinit();         // process table
801030e9:	e8 b2 08 00 00       	call   801039a0 <pinit>
  tvinit();        // trap vectors
801030ee:	e8 4d 28 00 00       	call   80105940 <tvinit>
  binit();         // buffer cache
801030f3:	e8 48 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030f8:	e8 a3 dd ff ff       	call   80100ea0 <fileinit>
  ideinit();       // disk 
801030fd:	e8 0e f1 ff ff       	call   80102210 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103102:	83 c4 0c             	add    $0xc,%esp
80103105:	68 8a 00 00 00       	push   $0x8a
8010310a:	68 8c a4 10 80       	push   $0x8010a48c
8010310f:	68 00 70 00 80       	push   $0x80007000
80103114:	e8 f7 16 00 00       	call   80104810 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103119:	83 c4 10             	add    $0x10,%esp
8010311c:	69 05 a4 17 11 80 b0 	imul   $0xb0,0x801117a4,%eax
80103123:	00 00 00 
80103126:	05 c0 17 11 80       	add    $0x801117c0,%eax
8010312b:	3d c0 17 11 80       	cmp    $0x801117c0,%eax
80103130:	76 7e                	jbe    801031b0 <main+0x110>
80103132:	bb c0 17 11 80       	mov    $0x801117c0,%ebx
80103137:	eb 20                	jmp    80103159 <main+0xb9>
80103139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103140:	69 05 a4 17 11 80 b0 	imul   $0xb0,0x801117a4,%eax
80103147:	00 00 00 
8010314a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103150:	05 c0 17 11 80       	add    $0x801117c0,%eax
80103155:	39 c3                	cmp    %eax,%ebx
80103157:	73 57                	jae    801031b0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103159:	e8 62 08 00 00       	call   801039c0 <mycpu>
8010315e:	39 c3                	cmp    %eax,%ebx
80103160:	74 de                	je     80103140 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103162:	e8 69 f5 ff ff       	call   801026d0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103167:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010316a:	c7 05 f8 6f 00 80 80 	movl   $0x80103080,0x80006ff8
80103171:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103174:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
8010317b:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010317e:	05 00 10 00 00       	add    $0x1000,%eax
80103183:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103188:	0f b6 03             	movzbl (%ebx),%eax
8010318b:	68 00 70 00 00       	push   $0x7000
80103190:	50                   	push   %eax
80103191:	e8 fa f7 ff ff       	call   80102990 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103196:	83 c4 10             	add    $0x10,%esp
80103199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031a0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801031a6:	85 c0                	test   %eax,%eax
801031a8:	74 f6                	je     801031a0 <main+0x100>
801031aa:	eb 94                	jmp    80103140 <main+0xa0>
801031ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801031b0:	83 ec 08             	sub    $0x8,%esp
801031b3:	68 00 00 00 8e       	push   $0x8e000000
801031b8:	68 00 00 40 80       	push   $0x80400000
801031bd:	e8 3e f4 ff ff       	call   80102600 <kinit2>
  userinit();      // first user process
801031c2:	e8 a9 08 00 00       	call   80103a70 <userinit>
  mpmain();        // finish this processor's setup
801031c7:	e8 74 fe ff ff       	call   80103040 <mpmain>
801031cc:	66 90                	xchg   %ax,%ax
801031ce:	66 90                	xchg   %ax,%ax

801031d0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801031d0:	55                   	push   %ebp
801031d1:	89 e5                	mov    %esp,%ebp
801031d3:	57                   	push   %edi
801031d4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801031d5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801031db:	53                   	push   %ebx
  e = addr+len;
801031dc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801031df:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801031e2:	39 de                	cmp    %ebx,%esi
801031e4:	72 10                	jb     801031f6 <mpsearch1+0x26>
801031e6:	eb 50                	jmp    80103238 <mpsearch1+0x68>
801031e8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801031ef:	00 
801031f0:	89 fe                	mov    %edi,%esi
801031f2:	39 df                	cmp    %ebx,%edi
801031f4:	73 42                	jae    80103238 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031f6:	83 ec 04             	sub    $0x4,%esp
801031f9:	8d 7e 10             	lea    0x10(%esi),%edi
801031fc:	6a 04                	push   $0x4
801031fe:	68 8a 74 10 80       	push   $0x8010748a
80103203:	56                   	push   %esi
80103204:	e8 b7 15 00 00       	call   801047c0 <memcmp>
80103209:	83 c4 10             	add    $0x10,%esp
8010320c:	85 c0                	test   %eax,%eax
8010320e:	75 e0                	jne    801031f0 <mpsearch1+0x20>
80103210:	89 f2                	mov    %esi,%edx
80103212:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103218:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
8010321b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010321e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103220:	39 fa                	cmp    %edi,%edx
80103222:	75 f4                	jne    80103218 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103224:	84 c0                	test   %al,%al
80103226:	75 c8                	jne    801031f0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103228:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010322b:	89 f0                	mov    %esi,%eax
8010322d:	5b                   	pop    %ebx
8010322e:	5e                   	pop    %esi
8010322f:	5f                   	pop    %edi
80103230:	5d                   	pop    %ebp
80103231:	c3                   	ret
80103232:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103238:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010323b:	31 f6                	xor    %esi,%esi
}
8010323d:	5b                   	pop    %ebx
8010323e:	89 f0                	mov    %esi,%eax
80103240:	5e                   	pop    %esi
80103241:	5f                   	pop    %edi
80103242:	5d                   	pop    %ebp
80103243:	c3                   	ret
80103244:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010324b:	00 
8010324c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103250 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103250:	55                   	push   %ebp
80103251:	89 e5                	mov    %esp,%ebp
80103253:	57                   	push   %edi
80103254:	56                   	push   %esi
80103255:	53                   	push   %ebx
80103256:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103259:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103260:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103267:	c1 e0 08             	shl    $0x8,%eax
8010326a:	09 d0                	or     %edx,%eax
8010326c:	c1 e0 04             	shl    $0x4,%eax
8010326f:	75 1b                	jne    8010328c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103271:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103278:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010327f:	c1 e0 08             	shl    $0x8,%eax
80103282:	09 d0                	or     %edx,%eax
80103284:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103287:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010328c:	ba 00 04 00 00       	mov    $0x400,%edx
80103291:	e8 3a ff ff ff       	call   801031d0 <mpsearch1>
80103296:	89 c3                	mov    %eax,%ebx
80103298:	85 c0                	test   %eax,%eax
8010329a:	0f 84 58 01 00 00    	je     801033f8 <mpinit+0x1a8>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801032a0:	8b 73 04             	mov    0x4(%ebx),%esi
801032a3:	85 f6                	test   %esi,%esi
801032a5:	0f 84 3d 01 00 00    	je     801033e8 <mpinit+0x198>
  if(memcmp(conf, "PCMP", 4) != 0)
801032ab:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801032ae:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801032b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801032b7:	6a 04                	push   $0x4
801032b9:	68 8f 74 10 80       	push   $0x8010748f
801032be:	50                   	push   %eax
801032bf:	e8 fc 14 00 00       	call   801047c0 <memcmp>
801032c4:	83 c4 10             	add    $0x10,%esp
801032c7:	85 c0                	test   %eax,%eax
801032c9:	0f 85 19 01 00 00    	jne    801033e8 <mpinit+0x198>
  if(conf->version != 1 && conf->version != 4)
801032cf:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801032d6:	3c 01                	cmp    $0x1,%al
801032d8:	74 08                	je     801032e2 <mpinit+0x92>
801032da:	3c 04                	cmp    $0x4,%al
801032dc:	0f 85 06 01 00 00    	jne    801033e8 <mpinit+0x198>
  if(sum((uchar*)conf, conf->length) != 0)
801032e2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801032e9:	66 85 d2             	test   %dx,%dx
801032ec:	74 22                	je     80103310 <mpinit+0xc0>
801032ee:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801032f1:	89 f0                	mov    %esi,%eax
  sum = 0;
801032f3:	31 d2                	xor    %edx,%edx
801032f5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801032f8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801032ff:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103302:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103304:	39 f8                	cmp    %edi,%eax
80103306:	75 f0                	jne    801032f8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103308:	84 d2                	test   %dl,%dl
8010330a:	0f 85 d8 00 00 00    	jne    801033e8 <mpinit+0x198>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103310:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103316:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103319:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  lapic = (uint*)conf->lapicaddr;
8010331c:	a3 a0 16 11 80       	mov    %eax,0x801116a0
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103321:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103328:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
8010332e:	01 d7                	add    %edx,%edi
80103330:	89 fa                	mov    %edi,%edx
  ismp = 1;
80103332:	bf 01 00 00 00       	mov    $0x1,%edi
80103337:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010333e:	00 
8010333f:	90                   	nop
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103340:	39 d0                	cmp    %edx,%eax
80103342:	73 19                	jae    8010335d <mpinit+0x10d>
    switch(*p){
80103344:	0f b6 08             	movzbl (%eax),%ecx
80103347:	80 f9 02             	cmp    $0x2,%cl
8010334a:	0f 84 80 00 00 00    	je     801033d0 <mpinit+0x180>
80103350:	77 6e                	ja     801033c0 <mpinit+0x170>
80103352:	84 c9                	test   %cl,%cl
80103354:	74 3a                	je     80103390 <mpinit+0x140>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103356:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103359:	39 d0                	cmp    %edx,%eax
8010335b:	72 e7                	jb     80103344 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010335d:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103360:	85 ff                	test   %edi,%edi
80103362:	0f 84 dd 00 00 00    	je     80103445 <mpinit+0x1f5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103368:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
8010336c:	74 15                	je     80103383 <mpinit+0x133>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010336e:	b8 70 00 00 00       	mov    $0x70,%eax
80103373:	ba 22 00 00 00       	mov    $0x22,%edx
80103378:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103379:	ba 23 00 00 00       	mov    $0x23,%edx
8010337e:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010337f:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103382:	ee                   	out    %al,(%dx)
  }
}
80103383:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103386:	5b                   	pop    %ebx
80103387:	5e                   	pop    %esi
80103388:	5f                   	pop    %edi
80103389:	5d                   	pop    %ebp
8010338a:	c3                   	ret
8010338b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(ncpu < NCPU) {
80103390:	8b 0d a4 17 11 80    	mov    0x801117a4,%ecx
80103396:	83 f9 07             	cmp    $0x7,%ecx
80103399:	7f 19                	jg     801033b4 <mpinit+0x164>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010339b:	69 f1 b0 00 00 00    	imul   $0xb0,%ecx,%esi
801033a1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
801033a5:	83 c1 01             	add    $0x1,%ecx
801033a8:	89 0d a4 17 11 80    	mov    %ecx,0x801117a4
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033ae:	88 9e c0 17 11 80    	mov    %bl,-0x7feee840(%esi)
      p += sizeof(struct mpproc);
801033b4:	83 c0 14             	add    $0x14,%eax
      continue;
801033b7:	eb 87                	jmp    80103340 <mpinit+0xf0>
801033b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(*p){
801033c0:	83 e9 03             	sub    $0x3,%ecx
801033c3:	80 f9 01             	cmp    $0x1,%cl
801033c6:	76 8e                	jbe    80103356 <mpinit+0x106>
801033c8:	31 ff                	xor    %edi,%edi
801033ca:	e9 71 ff ff ff       	jmp    80103340 <mpinit+0xf0>
801033cf:	90                   	nop
      ioapicid = ioapic->apicno;
801033d0:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801033d4:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801033d7:	88 0d a0 17 11 80    	mov    %cl,0x801117a0
      continue;
801033dd:	e9 5e ff ff ff       	jmp    80103340 <mpinit+0xf0>
801033e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
801033e8:	83 ec 0c             	sub    $0xc,%esp
801033eb:	68 94 74 10 80       	push   $0x80107494
801033f0:	e8 8b cf ff ff       	call   80100380 <panic>
801033f5:	8d 76 00             	lea    0x0(%esi),%esi
{
801033f8:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801033fd:	eb 0b                	jmp    8010340a <mpinit+0x1ba>
801033ff:	90                   	nop
  for(p = addr; p < e; p += sizeof(struct mp))
80103400:	89 f3                	mov    %esi,%ebx
80103402:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103408:	74 de                	je     801033e8 <mpinit+0x198>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010340a:	83 ec 04             	sub    $0x4,%esp
8010340d:	8d 73 10             	lea    0x10(%ebx),%esi
80103410:	6a 04                	push   $0x4
80103412:	68 8a 74 10 80       	push   $0x8010748a
80103417:	53                   	push   %ebx
80103418:	e8 a3 13 00 00       	call   801047c0 <memcmp>
8010341d:	83 c4 10             	add    $0x10,%esp
80103420:	85 c0                	test   %eax,%eax
80103422:	75 dc                	jne    80103400 <mpinit+0x1b0>
80103424:	89 da                	mov    %ebx,%edx
80103426:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010342d:	00 
8010342e:	66 90                	xchg   %ax,%ax
    sum += addr[i];
80103430:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103433:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103436:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103438:	39 d6                	cmp    %edx,%esi
8010343a:	75 f4                	jne    80103430 <mpinit+0x1e0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010343c:	84 c0                	test   %al,%al
8010343e:	75 c0                	jne    80103400 <mpinit+0x1b0>
80103440:	e9 5b fe ff ff       	jmp    801032a0 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103445:	83 ec 0c             	sub    $0xc,%esp
80103448:	68 28 78 10 80       	push   $0x80107828
8010344d:	e8 2e cf ff ff       	call   80100380 <panic>
80103452:	66 90                	xchg   %ax,%ax
80103454:	66 90                	xchg   %ax,%ax
80103456:	66 90                	xchg   %ax,%ax
80103458:	66 90                	xchg   %ax,%ax
8010345a:	66 90                	xchg   %ax,%ax
8010345c:	66 90                	xchg   %ax,%ax
8010345e:	66 90                	xchg   %ax,%ax

80103460 <picinit>:
80103460:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103465:	ba 21 00 00 00       	mov    $0x21,%edx
8010346a:	ee                   	out    %al,(%dx)
8010346b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103470:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103471:	c3                   	ret
80103472:	66 90                	xchg   %ax,%ax
80103474:	66 90                	xchg   %ax,%ax
80103476:	66 90                	xchg   %ax,%ax
80103478:	66 90                	xchg   %ax,%ax
8010347a:	66 90                	xchg   %ax,%ax
8010347c:	66 90                	xchg   %ax,%ax
8010347e:	66 90                	xchg   %ax,%ax

80103480 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103480:	55                   	push   %ebp
80103481:	89 e5                	mov    %esp,%ebp
80103483:	57                   	push   %edi
80103484:	56                   	push   %esi
80103485:	53                   	push   %ebx
80103486:	83 ec 0c             	sub    $0xc,%esp
80103489:	8b 75 08             	mov    0x8(%ebp),%esi
8010348c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010348f:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
80103495:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010349b:	e8 20 da ff ff       	call   80100ec0 <filealloc>
801034a0:	89 06                	mov    %eax,(%esi)
801034a2:	85 c0                	test   %eax,%eax
801034a4:	0f 84 a5 00 00 00    	je     8010354f <pipealloc+0xcf>
801034aa:	e8 11 da ff ff       	call   80100ec0 <filealloc>
801034af:	89 07                	mov    %eax,(%edi)
801034b1:	85 c0                	test   %eax,%eax
801034b3:	0f 84 84 00 00 00    	je     8010353d <pipealloc+0xbd>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801034b9:	e8 12 f2 ff ff       	call   801026d0 <kalloc>
801034be:	89 c3                	mov    %eax,%ebx
801034c0:	85 c0                	test   %eax,%eax
801034c2:	0f 84 a0 00 00 00    	je     80103568 <pipealloc+0xe8>
    goto bad;
  p->readopen = 1;
801034c8:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801034cf:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801034d2:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
801034d5:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801034dc:	00 00 00 
  p->nwrite = 0;
801034df:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801034e6:	00 00 00 
  p->nread = 0;
801034e9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801034f0:	00 00 00 
  initlock(&p->lock, "pipe");
801034f3:	68 ac 74 10 80       	push   $0x801074ac
801034f8:	50                   	push   %eax
801034f9:	e8 92 0f 00 00       	call   80104490 <initlock>
  (*f0)->type = FD_PIPE;
801034fe:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103500:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103503:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103509:	8b 06                	mov    (%esi),%eax
8010350b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010350f:	8b 06                	mov    (%esi),%eax
80103511:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103515:	8b 06                	mov    (%esi),%eax
80103517:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010351a:	8b 07                	mov    (%edi),%eax
8010351c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103522:	8b 07                	mov    (%edi),%eax
80103524:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103528:	8b 07                	mov    (%edi),%eax
8010352a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010352e:	8b 07                	mov    (%edi),%eax
80103530:	89 58 0c             	mov    %ebx,0xc(%eax)
  return 0;
80103533:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103535:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103538:	5b                   	pop    %ebx
80103539:	5e                   	pop    %esi
8010353a:	5f                   	pop    %edi
8010353b:	5d                   	pop    %ebp
8010353c:	c3                   	ret
  if(*f0)
8010353d:	8b 06                	mov    (%esi),%eax
8010353f:	85 c0                	test   %eax,%eax
80103541:	74 1e                	je     80103561 <pipealloc+0xe1>
    fileclose(*f0);
80103543:	83 ec 0c             	sub    $0xc,%esp
80103546:	50                   	push   %eax
80103547:	e8 34 da ff ff       	call   80100f80 <fileclose>
8010354c:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010354f:	8b 07                	mov    (%edi),%eax
80103551:	85 c0                	test   %eax,%eax
80103553:	74 0c                	je     80103561 <pipealloc+0xe1>
    fileclose(*f1);
80103555:	83 ec 0c             	sub    $0xc,%esp
80103558:	50                   	push   %eax
80103559:	e8 22 da ff ff       	call   80100f80 <fileclose>
8010355e:	83 c4 10             	add    $0x10,%esp
  return -1;
80103561:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103566:	eb cd                	jmp    80103535 <pipealloc+0xb5>
  if(*f0)
80103568:	8b 06                	mov    (%esi),%eax
8010356a:	85 c0                	test   %eax,%eax
8010356c:	75 d5                	jne    80103543 <pipealloc+0xc3>
8010356e:	eb df                	jmp    8010354f <pipealloc+0xcf>

80103570 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103570:	55                   	push   %ebp
80103571:	89 e5                	mov    %esp,%ebp
80103573:	56                   	push   %esi
80103574:	53                   	push   %ebx
80103575:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103578:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010357b:	83 ec 0c             	sub    $0xc,%esp
8010357e:	53                   	push   %ebx
8010357f:	e8 fc 10 00 00       	call   80104680 <acquire>
  if(writable){
80103584:	83 c4 10             	add    $0x10,%esp
80103587:	85 f6                	test   %esi,%esi
80103589:	74 65                	je     801035f0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010358b:	83 ec 0c             	sub    $0xc,%esp
8010358e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103594:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010359b:	00 00 00 
    wakeup(&p->nread);
8010359e:	50                   	push   %eax
8010359f:	e8 1c 0c 00 00       	call   801041c0 <wakeup>
801035a4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801035a7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801035ad:	85 d2                	test   %edx,%edx
801035af:	75 0a                	jne    801035bb <pipeclose+0x4b>
801035b1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801035b7:	85 c0                	test   %eax,%eax
801035b9:	74 15                	je     801035d0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801035bb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801035be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035c1:	5b                   	pop    %ebx
801035c2:	5e                   	pop    %esi
801035c3:	5d                   	pop    %ebp
    release(&p->lock);
801035c4:	e9 57 10 00 00       	jmp    80104620 <release>
801035c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801035d0:	83 ec 0c             	sub    $0xc,%esp
801035d3:	53                   	push   %ebx
801035d4:	e8 47 10 00 00       	call   80104620 <release>
    kfree((char*)p);
801035d9:	83 c4 10             	add    $0x10,%esp
801035dc:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801035df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035e2:	5b                   	pop    %ebx
801035e3:	5e                   	pop    %esi
801035e4:	5d                   	pop    %ebp
    kfree((char*)p);
801035e5:	e9 26 ef ff ff       	jmp    80102510 <kfree>
801035ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801035f0:	83 ec 0c             	sub    $0xc,%esp
801035f3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801035f9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103600:	00 00 00 
    wakeup(&p->nwrite);
80103603:	50                   	push   %eax
80103604:	e8 b7 0b 00 00       	call   801041c0 <wakeup>
80103609:	83 c4 10             	add    $0x10,%esp
8010360c:	eb 99                	jmp    801035a7 <pipeclose+0x37>
8010360e:	66 90                	xchg   %ax,%ax

80103610 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103610:	55                   	push   %ebp
80103611:	89 e5                	mov    %esp,%ebp
80103613:	57                   	push   %edi
80103614:	56                   	push   %esi
80103615:	53                   	push   %ebx
80103616:	83 ec 28             	sub    $0x28,%esp
80103619:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010361c:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
8010361f:	53                   	push   %ebx
80103620:	e8 5b 10 00 00       	call   80104680 <acquire>
  for(i = 0; i < n; i++){
80103625:	83 c4 10             	add    $0x10,%esp
80103628:	85 ff                	test   %edi,%edi
8010362a:	0f 8e ce 00 00 00    	jle    801036fe <pipewrite+0xee>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103630:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103636:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103639:	89 7d 10             	mov    %edi,0x10(%ebp)
8010363c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010363f:	8d 34 39             	lea    (%ecx,%edi,1),%esi
80103642:	89 75 e0             	mov    %esi,-0x20(%ebp)
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103645:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010364b:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103651:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103657:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
8010365d:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
80103660:	0f 85 b6 00 00 00    	jne    8010371c <pipewrite+0x10c>
80103666:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103669:	eb 3b                	jmp    801036a6 <pipewrite+0x96>
8010366b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103670:	e8 cb 03 00 00       	call   80103a40 <myproc>
80103675:	8b 48 24             	mov    0x24(%eax),%ecx
80103678:	85 c9                	test   %ecx,%ecx
8010367a:	75 34                	jne    801036b0 <pipewrite+0xa0>
      wakeup(&p->nread);
8010367c:	83 ec 0c             	sub    $0xc,%esp
8010367f:	56                   	push   %esi
80103680:	e8 3b 0b 00 00       	call   801041c0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103685:	58                   	pop    %eax
80103686:	5a                   	pop    %edx
80103687:	53                   	push   %ebx
80103688:	57                   	push   %edi
80103689:	e8 72 0a 00 00       	call   80104100 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010368e:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103694:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010369a:	83 c4 10             	add    $0x10,%esp
8010369d:	05 00 02 00 00       	add    $0x200,%eax
801036a2:	39 c2                	cmp    %eax,%edx
801036a4:	75 2a                	jne    801036d0 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
801036a6:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801036ac:	85 c0                	test   %eax,%eax
801036ae:	75 c0                	jne    80103670 <pipewrite+0x60>
        release(&p->lock);
801036b0:	83 ec 0c             	sub    $0xc,%esp
801036b3:	53                   	push   %ebx
801036b4:	e8 67 0f 00 00       	call   80104620 <release>
        return -1;
801036b9:	83 c4 10             	add    $0x10,%esp
801036bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801036c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036c4:	5b                   	pop    %ebx
801036c5:	5e                   	pop    %esi
801036c6:	5f                   	pop    %edi
801036c7:	5d                   	pop    %ebp
801036c8:	c3                   	ret
801036c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036d0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036d3:	8d 42 01             	lea    0x1(%edx),%eax
801036d6:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  for(i = 0; i < n; i++){
801036dc:	83 c1 01             	add    $0x1,%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036df:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801036e5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801036e8:	0f b6 41 ff          	movzbl -0x1(%ecx),%eax
801036ec:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801036f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801036f3:	39 c1                	cmp    %eax,%ecx
801036f5:	0f 85 50 ff ff ff    	jne    8010364b <pipewrite+0x3b>
801036fb:	8b 7d 10             	mov    0x10(%ebp),%edi
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801036fe:	83 ec 0c             	sub    $0xc,%esp
80103701:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103707:	50                   	push   %eax
80103708:	e8 b3 0a 00 00       	call   801041c0 <wakeup>
  release(&p->lock);
8010370d:	89 1c 24             	mov    %ebx,(%esp)
80103710:	e8 0b 0f 00 00       	call   80104620 <release>
  return n;
80103715:	83 c4 10             	add    $0x10,%esp
80103718:	89 f8                	mov    %edi,%eax
8010371a:	eb a5                	jmp    801036c1 <pipewrite+0xb1>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010371c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010371f:	eb b2                	jmp    801036d3 <pipewrite+0xc3>
80103721:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103728:	00 
80103729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103730 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103730:	55                   	push   %ebp
80103731:	89 e5                	mov    %esp,%ebp
80103733:	57                   	push   %edi
80103734:	56                   	push   %esi
80103735:	53                   	push   %ebx
80103736:	83 ec 18             	sub    $0x18,%esp
80103739:	8b 75 08             	mov    0x8(%ebp),%esi
8010373c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010373f:	56                   	push   %esi
80103740:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103746:	e8 35 0f 00 00       	call   80104680 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010374b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103751:	83 c4 10             	add    $0x10,%esp
80103754:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010375a:	74 2f                	je     8010378b <piperead+0x5b>
8010375c:	eb 37                	jmp    80103795 <piperead+0x65>
8010375e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103760:	e8 db 02 00 00       	call   80103a40 <myproc>
80103765:	8b 40 24             	mov    0x24(%eax),%eax
80103768:	85 c0                	test   %eax,%eax
8010376a:	0f 85 80 00 00 00    	jne    801037f0 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103770:	83 ec 08             	sub    $0x8,%esp
80103773:	56                   	push   %esi
80103774:	53                   	push   %ebx
80103775:	e8 86 09 00 00       	call   80104100 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010377a:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103780:	83 c4 10             	add    $0x10,%esp
80103783:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103789:	75 0a                	jne    80103795 <piperead+0x65>
8010378b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103791:	85 d2                	test   %edx,%edx
80103793:	75 cb                	jne    80103760 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103795:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103798:	31 db                	xor    %ebx,%ebx
8010379a:	85 c9                	test   %ecx,%ecx
8010379c:	7f 26                	jg     801037c4 <piperead+0x94>
8010379e:	eb 2c                	jmp    801037cc <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801037a0:	8d 48 01             	lea    0x1(%eax),%ecx
801037a3:	25 ff 01 00 00       	and    $0x1ff,%eax
801037a8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
801037ae:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
801037b3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801037b6:	83 c3 01             	add    $0x1,%ebx
801037b9:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801037bc:	74 0e                	je     801037cc <piperead+0x9c>
801037be:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
    if(p->nread == p->nwrite)
801037c4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801037ca:	75 d4                	jne    801037a0 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801037cc:	83 ec 0c             	sub    $0xc,%esp
801037cf:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801037d5:	50                   	push   %eax
801037d6:	e8 e5 09 00 00       	call   801041c0 <wakeup>
  release(&p->lock);
801037db:	89 34 24             	mov    %esi,(%esp)
801037de:	e8 3d 0e 00 00       	call   80104620 <release>
  return i;
801037e3:	83 c4 10             	add    $0x10,%esp
}
801037e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037e9:	89 d8                	mov    %ebx,%eax
801037eb:	5b                   	pop    %ebx
801037ec:	5e                   	pop    %esi
801037ed:	5f                   	pop    %edi
801037ee:	5d                   	pop    %ebp
801037ef:	c3                   	ret
      release(&p->lock);
801037f0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801037f3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801037f8:	56                   	push   %esi
801037f9:	e8 22 0e 00 00       	call   80104620 <release>
      return -1;
801037fe:	83 c4 10             	add    $0x10,%esp
}
80103801:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103804:	89 d8                	mov    %ebx,%eax
80103806:	5b                   	pop    %ebx
80103807:	5e                   	pop    %esi
80103808:	5f                   	pop    %edi
80103809:	5d                   	pop    %ebp
8010380a:	c3                   	ret
8010380b:	66 90                	xchg   %ax,%ax
8010380d:	66 90                	xchg   %ax,%ax
8010380f:	90                   	nop

80103810 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103810:	55                   	push   %ebp
80103811:	89 e5                	mov    %esp,%ebp
80103813:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103814:	bb 74 1d 11 80       	mov    $0x80111d74,%ebx
{
80103819:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010381c:	68 40 1d 11 80       	push   $0x80111d40
80103821:	e8 5a 0e 00 00       	call   80104680 <acquire>
80103826:	83 c4 10             	add    $0x10,%esp
80103829:	eb 10                	jmp    8010383b <allocproc+0x2b>
8010382b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103830:	83 c3 7c             	add    $0x7c,%ebx
80103833:	81 fb 74 3c 11 80    	cmp    $0x80113c74,%ebx
80103839:	74 75                	je     801038b0 <allocproc+0xa0>
    if(p->state == UNUSED)
8010383b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010383e:	85 c0                	test   %eax,%eax
80103840:	75 ee                	jne    80103830 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103842:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
80103847:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010384a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103851:	89 43 10             	mov    %eax,0x10(%ebx)
80103854:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80103857:	68 40 1d 11 80       	push   $0x80111d40
  p->pid = nextpid++;
8010385c:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
80103862:	e8 b9 0d 00 00       	call   80104620 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103867:	e8 64 ee ff ff       	call   801026d0 <kalloc>
8010386c:	83 c4 10             	add    $0x10,%esp
8010386f:	89 43 08             	mov    %eax,0x8(%ebx)
80103872:	85 c0                	test   %eax,%eax
80103874:	74 53                	je     801038c9 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103876:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010387c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010387f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103884:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103887:	c7 40 14 32 59 10 80 	movl   $0x80105932,0x14(%eax)
  p->context = (struct context*)sp;
8010388e:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103891:	6a 14                	push   $0x14
80103893:	6a 00                	push   $0x0
80103895:	50                   	push   %eax
80103896:	e8 e5 0e 00 00       	call   80104780 <memset>
  p->context->eip = (uint)forkret;
8010389b:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010389e:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801038a1:	c7 40 10 e0 38 10 80 	movl   $0x801038e0,0x10(%eax)
}
801038a8:	89 d8                	mov    %ebx,%eax
801038aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038ad:	c9                   	leave
801038ae:	c3                   	ret
801038af:	90                   	nop
  release(&ptable.lock);
801038b0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801038b3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801038b5:	68 40 1d 11 80       	push   $0x80111d40
801038ba:	e8 61 0d 00 00       	call   80104620 <release>
  return 0;
801038bf:	83 c4 10             	add    $0x10,%esp
}
801038c2:	89 d8                	mov    %ebx,%eax
801038c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038c7:	c9                   	leave
801038c8:	c3                   	ret
    p->state = UNUSED;
801038c9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  return 0;
801038d0:	31 db                	xor    %ebx,%ebx
801038d2:	eb ee                	jmp    801038c2 <allocproc+0xb2>
801038d4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801038db:	00 
801038dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801038e0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801038e0:	55                   	push   %ebp
801038e1:	89 e5                	mov    %esp,%ebp
801038e3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801038e6:	68 40 1d 11 80       	push   $0x80111d40
801038eb:	e8 30 0d 00 00       	call   80104620 <release>

  if (first) {
801038f0:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801038f5:	83 c4 10             	add    $0x10,%esp
801038f8:	85 c0                	test   %eax,%eax
801038fa:	75 04                	jne    80103900 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801038fc:	c9                   	leave
801038fd:	c3                   	ret
801038fe:	66 90                	xchg   %ax,%ax
    first = 0;
80103900:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103907:	00 00 00 
    iinit(ROOTDEV);
8010390a:	83 ec 0c             	sub    $0xc,%esp
8010390d:	6a 01                	push   $0x1
8010390f:	e8 dc dc ff ff       	call   801015f0 <iinit>
    initlog(ROOTDEV);
80103914:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010391b:	e8 f0 f3 ff ff       	call   80102d10 <initlog>
}
80103920:	83 c4 10             	add    $0x10,%esp
80103923:	c9                   	leave
80103924:	c3                   	ret
80103925:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010392c:	00 
8010392d:	8d 76 00             	lea    0x0(%esi),%esi

80103930 <print_mem_layout>:
void print_mem_layout() {
80103930:	55                   	push   %ebp
80103931:	89 e5                	mov    %esp,%ebp
80103933:	53                   	push   %ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103934:	bb 74 1d 11 80       	mov    $0x80111d74,%ebx
void print_mem_layout() {
80103939:	83 ec 10             	sub    $0x10,%esp
  cprintf("Printing Memory Layout\n");
8010393c:	68 b1 74 10 80       	push   $0x801074b1
80103941:	e8 6a cd ff ff       	call   801006b0 <cprintf>
  cprintf("PID\tNUM_PAGES\n");
80103946:	c7 04 24 c9 74 10 80 	movl   $0x801074c9,(%esp)
8010394d:	e8 5e cd ff ff       	call   801006b0 <cprintf>
80103952:	83 c4 10             	add    $0x10,%esp
80103955:	8d 76 00             	lea    0x0(%esi),%esi
    if(p->state == RUNNING || p->state == RUNNABLE || p->state == SLEEPING) {
80103958:	8b 43 0c             	mov    0xc(%ebx),%eax
8010395b:	83 e8 02             	sub    $0x2,%eax
8010395e:	83 f8 02             	cmp    $0x2,%eax
80103961:	77 2b                	ja     8010398e <print_mem_layout+0x5e>
      if(p->pid >= 1) {
80103963:	8b 53 10             	mov    0x10(%ebx),%edx
80103966:	85 d2                	test   %edx,%edx
80103968:	7e 24                	jle    8010398e <print_mem_layout+0x5e>
        int num_pages = p->sz / PGSIZE;
8010396a:	8b 03                	mov    (%ebx),%eax
8010396c:	89 c1                	mov    %eax,%ecx
        if(p->sz % PGSIZE)
8010396e:	25 ff 0f 00 00       	and    $0xfff,%eax
        int num_pages = p->sz / PGSIZE;
80103973:	c1 e9 0c             	shr    $0xc,%ecx
          num_pages++;  // If not perfectly divisible, count extra page
80103976:	83 f8 01             	cmp    $0x1,%eax
80103979:	83 d9 ff             	sbb    $0xffffffff,%ecx
        cprintf("%d\t%d\n", p->pid, num_pages);
8010397c:	83 ec 04             	sub    $0x4,%esp
8010397f:	51                   	push   %ecx
80103980:	52                   	push   %edx
80103981:	68 d8 74 10 80       	push   $0x801074d8
80103986:	e8 25 cd ff ff       	call   801006b0 <cprintf>
8010398b:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010398e:	83 c3 7c             	add    $0x7c,%ebx
80103991:	81 fb 74 3c 11 80    	cmp    $0x80113c74,%ebx
80103997:	75 bf                	jne    80103958 <print_mem_layout+0x28>
}
80103999:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010399c:	c9                   	leave
8010399d:	c3                   	ret
8010399e:	66 90                	xchg   %ax,%ax

801039a0 <pinit>:
{
801039a0:	55                   	push   %ebp
801039a1:	89 e5                	mov    %esp,%ebp
801039a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801039a6:	68 df 74 10 80       	push   $0x801074df
801039ab:	68 40 1d 11 80       	push   $0x80111d40
801039b0:	e8 db 0a 00 00       	call   80104490 <initlock>
}
801039b5:	83 c4 10             	add    $0x10,%esp
801039b8:	c9                   	leave
801039b9:	c3                   	ret
801039ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801039c0 <mycpu>:
{
801039c0:	55                   	push   %ebp
801039c1:	89 e5                	mov    %esp,%ebp
801039c3:	56                   	push   %esi
801039c4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801039c5:	9c                   	pushf
801039c6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801039c7:	f6 c4 02             	test   $0x2,%ah
801039ca:	75 46                	jne    80103a12 <mycpu+0x52>
  apicid = lapicid();
801039cc:	e8 6f ef ff ff       	call   80102940 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801039d1:	8b 35 a4 17 11 80    	mov    0x801117a4,%esi
801039d7:	85 f6                	test   %esi,%esi
801039d9:	7e 2a                	jle    80103a05 <mycpu+0x45>
801039db:	31 d2                	xor    %edx,%edx
801039dd:	eb 08                	jmp    801039e7 <mycpu+0x27>
801039df:	90                   	nop
801039e0:	83 c2 01             	add    $0x1,%edx
801039e3:	39 f2                	cmp    %esi,%edx
801039e5:	74 1e                	je     80103a05 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
801039e7:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
801039ed:	0f b6 99 c0 17 11 80 	movzbl -0x7feee840(%ecx),%ebx
801039f4:	39 c3                	cmp    %eax,%ebx
801039f6:	75 e8                	jne    801039e0 <mycpu+0x20>
}
801039f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
801039fb:	8d 81 c0 17 11 80    	lea    -0x7feee840(%ecx),%eax
}
80103a01:	5b                   	pop    %ebx
80103a02:	5e                   	pop    %esi
80103a03:	5d                   	pop    %ebp
80103a04:	c3                   	ret
  panic("unknown apicid\n");
80103a05:	83 ec 0c             	sub    $0xc,%esp
80103a08:	68 e6 74 10 80       	push   $0x801074e6
80103a0d:	e8 6e c9 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103a12:	83 ec 0c             	sub    $0xc,%esp
80103a15:	68 48 78 10 80       	push   $0x80107848
80103a1a:	e8 61 c9 ff ff       	call   80100380 <panic>
80103a1f:	90                   	nop

80103a20 <cpuid>:
cpuid() {
80103a20:	55                   	push   %ebp
80103a21:	89 e5                	mov    %esp,%ebp
80103a23:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103a26:	e8 95 ff ff ff       	call   801039c0 <mycpu>
}
80103a2b:	c9                   	leave
  return mycpu()-cpus;
80103a2c:	2d c0 17 11 80       	sub    $0x801117c0,%eax
80103a31:	c1 f8 04             	sar    $0x4,%eax
80103a34:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103a3a:	c3                   	ret
80103a3b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103a40 <myproc>:
myproc(void) {
80103a40:	55                   	push   %ebp
80103a41:	89 e5                	mov    %esp,%ebp
80103a43:	53                   	push   %ebx
80103a44:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103a47:	e8 e4 0a 00 00       	call   80104530 <pushcli>
  c = mycpu();
80103a4c:	e8 6f ff ff ff       	call   801039c0 <mycpu>
  p = c->proc;
80103a51:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a57:	e8 24 0b 00 00       	call   80104580 <popcli>
}
80103a5c:	89 d8                	mov    %ebx,%eax
80103a5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a61:	c9                   	leave
80103a62:	c3                   	ret
80103a63:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103a6a:	00 
80103a6b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103a70 <userinit>:
{
80103a70:	55                   	push   %ebp
80103a71:	89 e5                	mov    %esp,%ebp
80103a73:	53                   	push   %ebx
80103a74:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103a77:	e8 94 fd ff ff       	call   80103810 <allocproc>
80103a7c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103a7e:	a3 74 3c 11 80       	mov    %eax,0x80113c74
  if((p->pgdir = setupkvm()) == 0)
80103a83:	e8 78 34 00 00       	call   80106f00 <setupkvm>
80103a88:	89 43 04             	mov    %eax,0x4(%ebx)
80103a8b:	85 c0                	test   %eax,%eax
80103a8d:	0f 84 bd 00 00 00    	je     80103b50 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103a93:	83 ec 04             	sub    $0x4,%esp
80103a96:	68 2c 00 00 00       	push   $0x2c
80103a9b:	68 60 a4 10 80       	push   $0x8010a460
80103aa0:	50                   	push   %eax
80103aa1:	e8 3a 31 00 00       	call   80106be0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103aa6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103aa9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103aaf:	6a 4c                	push   $0x4c
80103ab1:	6a 00                	push   $0x0
80103ab3:	ff 73 18             	push   0x18(%ebx)
80103ab6:	e8 c5 0c 00 00       	call   80104780 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103abb:	8b 43 18             	mov    0x18(%ebx),%eax
80103abe:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103ac3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103ac6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103acb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103acf:	8b 43 18             	mov    0x18(%ebx),%eax
80103ad2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103ad6:	8b 43 18             	mov    0x18(%ebx),%eax
80103ad9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103add:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103ae1:	8b 43 18             	mov    0x18(%ebx),%eax
80103ae4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103ae8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103aec:	8b 43 18             	mov    0x18(%ebx),%eax
80103aef:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103af6:	8b 43 18             	mov    0x18(%ebx),%eax
80103af9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103b00:	8b 43 18             	mov    0x18(%ebx),%eax
80103b03:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b0a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103b0d:	6a 10                	push   $0x10
80103b0f:	68 0f 75 10 80       	push   $0x8010750f
80103b14:	50                   	push   %eax
80103b15:	e8 16 0e 00 00       	call   80104930 <safestrcpy>
  p->cwd = namei("/");
80103b1a:	c7 04 24 18 75 10 80 	movl   $0x80107518,(%esp)
80103b21:	e8 ca e5 ff ff       	call   801020f0 <namei>
80103b26:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103b29:	c7 04 24 40 1d 11 80 	movl   $0x80111d40,(%esp)
80103b30:	e8 4b 0b 00 00       	call   80104680 <acquire>
  p->state = RUNNABLE;
80103b35:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103b3c:	c7 04 24 40 1d 11 80 	movl   $0x80111d40,(%esp)
80103b43:	e8 d8 0a 00 00       	call   80104620 <release>
}
80103b48:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b4b:	83 c4 10             	add    $0x10,%esp
80103b4e:	c9                   	leave
80103b4f:	c3                   	ret
    panic("userinit: out of memory?");
80103b50:	83 ec 0c             	sub    $0xc,%esp
80103b53:	68 f6 74 10 80       	push   $0x801074f6
80103b58:	e8 23 c8 ff ff       	call   80100380 <panic>
80103b5d:	8d 76 00             	lea    0x0(%esi),%esi

80103b60 <growproc>:
{
80103b60:	55                   	push   %ebp
80103b61:	89 e5                	mov    %esp,%ebp
80103b63:	56                   	push   %esi
80103b64:	53                   	push   %ebx
80103b65:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103b68:	e8 c3 09 00 00       	call   80104530 <pushcli>
  c = mycpu();
80103b6d:	e8 4e fe ff ff       	call   801039c0 <mycpu>
  p = c->proc;
80103b72:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b78:	e8 03 0a 00 00       	call   80104580 <popcli>
  sz = curproc->sz;
80103b7d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103b7f:	85 f6                	test   %esi,%esi
80103b81:	7f 1d                	jg     80103ba0 <growproc+0x40>
  } else if(n < 0){
80103b83:	75 3b                	jne    80103bc0 <growproc+0x60>
  switchuvm(curproc);
80103b85:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103b88:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103b8a:	53                   	push   %ebx
80103b8b:	e8 40 2f 00 00       	call   80106ad0 <switchuvm>
  return 0;
80103b90:	83 c4 10             	add    $0x10,%esp
80103b93:	31 c0                	xor    %eax,%eax
}
80103b95:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b98:	5b                   	pop    %ebx
80103b99:	5e                   	pop    %esi
80103b9a:	5d                   	pop    %ebp
80103b9b:	c3                   	ret
80103b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ba0:	83 ec 04             	sub    $0x4,%esp
80103ba3:	01 c6                	add    %eax,%esi
80103ba5:	56                   	push   %esi
80103ba6:	50                   	push   %eax
80103ba7:	ff 73 04             	push   0x4(%ebx)
80103baa:	e8 81 31 00 00       	call   80106d30 <allocuvm>
80103baf:	83 c4 10             	add    $0x10,%esp
80103bb2:	85 c0                	test   %eax,%eax
80103bb4:	75 cf                	jne    80103b85 <growproc+0x25>
      return -1;
80103bb6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103bbb:	eb d8                	jmp    80103b95 <growproc+0x35>
80103bbd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103bc0:	83 ec 04             	sub    $0x4,%esp
80103bc3:	01 c6                	add    %eax,%esi
80103bc5:	56                   	push   %esi
80103bc6:	50                   	push   %eax
80103bc7:	ff 73 04             	push   0x4(%ebx)
80103bca:	e8 81 32 00 00       	call   80106e50 <deallocuvm>
80103bcf:	83 c4 10             	add    $0x10,%esp
80103bd2:	85 c0                	test   %eax,%eax
80103bd4:	75 af                	jne    80103b85 <growproc+0x25>
80103bd6:	eb de                	jmp    80103bb6 <growproc+0x56>
80103bd8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103bdf:	00 

80103be0 <fork>:
{
80103be0:	55                   	push   %ebp
80103be1:	89 e5                	mov    %esp,%ebp
80103be3:	57                   	push   %edi
80103be4:	56                   	push   %esi
80103be5:	53                   	push   %ebx
80103be6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103be9:	e8 42 09 00 00       	call   80104530 <pushcli>
  c = mycpu();
80103bee:	e8 cd fd ff ff       	call   801039c0 <mycpu>
  p = c->proc;
80103bf3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103bf9:	e8 82 09 00 00       	call   80104580 <popcli>
  if((np = allocproc()) == 0){
80103bfe:	e8 0d fc ff ff       	call   80103810 <allocproc>
80103c03:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103c06:	85 c0                	test   %eax,%eax
80103c08:	0f 84 d6 00 00 00    	je     80103ce4 <fork+0x104>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103c0e:	83 ec 08             	sub    $0x8,%esp
80103c11:	ff 33                	push   (%ebx)
80103c13:	89 c7                	mov    %eax,%edi
80103c15:	ff 73 04             	push   0x4(%ebx)
80103c18:	e8 d3 33 00 00       	call   80106ff0 <copyuvm>
80103c1d:	83 c4 10             	add    $0x10,%esp
80103c20:	89 47 04             	mov    %eax,0x4(%edi)
80103c23:	85 c0                	test   %eax,%eax
80103c25:	0f 84 9a 00 00 00    	je     80103cc5 <fork+0xe5>
  np->sz = curproc->sz;
80103c2b:	8b 03                	mov    (%ebx),%eax
80103c2d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103c30:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103c32:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103c35:	89 c8                	mov    %ecx,%eax
80103c37:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103c3a:	b9 13 00 00 00       	mov    $0x13,%ecx
80103c3f:	8b 73 18             	mov    0x18(%ebx),%esi
80103c42:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103c44:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103c46:	8b 40 18             	mov    0x18(%eax),%eax
80103c49:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103c50:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103c54:	85 c0                	test   %eax,%eax
80103c56:	74 13                	je     80103c6b <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103c58:	83 ec 0c             	sub    $0xc,%esp
80103c5b:	50                   	push   %eax
80103c5c:	e8 cf d2 ff ff       	call   80100f30 <filedup>
80103c61:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103c64:	83 c4 10             	add    $0x10,%esp
80103c67:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103c6b:	83 c6 01             	add    $0x1,%esi
80103c6e:	83 fe 10             	cmp    $0x10,%esi
80103c71:	75 dd                	jne    80103c50 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103c73:	83 ec 0c             	sub    $0xc,%esp
80103c76:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c79:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103c7c:	e8 5f db ff ff       	call   801017e0 <idup>
80103c81:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c84:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103c87:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103c8a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103c8d:	6a 10                	push   $0x10
80103c8f:	53                   	push   %ebx
80103c90:	50                   	push   %eax
80103c91:	e8 9a 0c 00 00       	call   80104930 <safestrcpy>
  pid = np->pid;
80103c96:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103c99:	c7 04 24 40 1d 11 80 	movl   $0x80111d40,(%esp)
80103ca0:	e8 db 09 00 00       	call   80104680 <acquire>
  np->state = RUNNABLE;
80103ca5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103cac:	c7 04 24 40 1d 11 80 	movl   $0x80111d40,(%esp)
80103cb3:	e8 68 09 00 00       	call   80104620 <release>
  return pid;
80103cb8:	83 c4 10             	add    $0x10,%esp
}
80103cbb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103cbe:	89 d8                	mov    %ebx,%eax
80103cc0:	5b                   	pop    %ebx
80103cc1:	5e                   	pop    %esi
80103cc2:	5f                   	pop    %edi
80103cc3:	5d                   	pop    %ebp
80103cc4:	c3                   	ret
    kfree(np->kstack);
80103cc5:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103cc8:	83 ec 0c             	sub    $0xc,%esp
80103ccb:	ff 73 08             	push   0x8(%ebx)
80103cce:	e8 3d e8 ff ff       	call   80102510 <kfree>
    np->kstack = 0;
80103cd3:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103cda:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103cdd:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103ce4:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103ce9:	eb d0                	jmp    80103cbb <fork+0xdb>
80103ceb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103cf0 <scheduler>:
{
80103cf0:	55                   	push   %ebp
80103cf1:	89 e5                	mov    %esp,%ebp
80103cf3:	57                   	push   %edi
80103cf4:	56                   	push   %esi
80103cf5:	53                   	push   %ebx
80103cf6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103cf9:	e8 c2 fc ff ff       	call   801039c0 <mycpu>
  c->proc = 0;
80103cfe:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103d05:	00 00 00 
  struct cpu *c = mycpu();
80103d08:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103d0a:	8d 78 04             	lea    0x4(%eax),%edi
80103d0d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103d10:	fb                   	sti
    acquire(&ptable.lock);
80103d11:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d14:	bb 74 1d 11 80       	mov    $0x80111d74,%ebx
    acquire(&ptable.lock);
80103d19:	68 40 1d 11 80       	push   $0x80111d40
80103d1e:	e8 5d 09 00 00       	call   80104680 <acquire>
80103d23:	83 c4 10             	add    $0x10,%esp
80103d26:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103d2d:	00 
80103d2e:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80103d30:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103d34:	75 33                	jne    80103d69 <scheduler+0x79>
      switchuvm(p);
80103d36:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103d39:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103d3f:	53                   	push   %ebx
80103d40:	e8 8b 2d 00 00       	call   80106ad0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103d45:	58                   	pop    %eax
80103d46:	5a                   	pop    %edx
80103d47:	ff 73 1c             	push   0x1c(%ebx)
80103d4a:	57                   	push   %edi
      p->state = RUNNING;
80103d4b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103d52:	e8 34 0c 00 00       	call   8010498b <swtch>
      switchkvm();
80103d57:	e8 64 2d 00 00       	call   80106ac0 <switchkvm>
      c->proc = 0;
80103d5c:	83 c4 10             	add    $0x10,%esp
80103d5f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103d66:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d69:	83 c3 7c             	add    $0x7c,%ebx
80103d6c:	81 fb 74 3c 11 80    	cmp    $0x80113c74,%ebx
80103d72:	75 bc                	jne    80103d30 <scheduler+0x40>
    release(&ptable.lock);
80103d74:	83 ec 0c             	sub    $0xc,%esp
80103d77:	68 40 1d 11 80       	push   $0x80111d40
80103d7c:	e8 9f 08 00 00       	call   80104620 <release>
    sti();
80103d81:	83 c4 10             	add    $0x10,%esp
80103d84:	eb 8a                	jmp    80103d10 <scheduler+0x20>
80103d86:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103d8d:	00 
80103d8e:	66 90                	xchg   %ax,%ax

80103d90 <sched>:
{
80103d90:	55                   	push   %ebp
80103d91:	89 e5                	mov    %esp,%ebp
80103d93:	56                   	push   %esi
80103d94:	53                   	push   %ebx
  pushcli();
80103d95:	e8 96 07 00 00       	call   80104530 <pushcli>
  c = mycpu();
80103d9a:	e8 21 fc ff ff       	call   801039c0 <mycpu>
  p = c->proc;
80103d9f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103da5:	e8 d6 07 00 00       	call   80104580 <popcli>
  if(!holding(&ptable.lock))
80103daa:	83 ec 0c             	sub    $0xc,%esp
80103dad:	68 40 1d 11 80       	push   $0x80111d40
80103db2:	e8 29 08 00 00       	call   801045e0 <holding>
80103db7:	83 c4 10             	add    $0x10,%esp
80103dba:	85 c0                	test   %eax,%eax
80103dbc:	74 4f                	je     80103e0d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103dbe:	e8 fd fb ff ff       	call   801039c0 <mycpu>
80103dc3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103dca:	75 68                	jne    80103e34 <sched+0xa4>
  if(p->state == RUNNING)
80103dcc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103dd0:	74 55                	je     80103e27 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103dd2:	9c                   	pushf
80103dd3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103dd4:	f6 c4 02             	test   $0x2,%ah
80103dd7:	75 41                	jne    80103e1a <sched+0x8a>
  intena = mycpu()->intena;
80103dd9:	e8 e2 fb ff ff       	call   801039c0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103dde:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103de1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103de7:	e8 d4 fb ff ff       	call   801039c0 <mycpu>
80103dec:	83 ec 08             	sub    $0x8,%esp
80103def:	ff 70 04             	push   0x4(%eax)
80103df2:	53                   	push   %ebx
80103df3:	e8 93 0b 00 00       	call   8010498b <swtch>
  mycpu()->intena = intena;
80103df8:	e8 c3 fb ff ff       	call   801039c0 <mycpu>
}
80103dfd:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103e00:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103e06:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e09:	5b                   	pop    %ebx
80103e0a:	5e                   	pop    %esi
80103e0b:	5d                   	pop    %ebp
80103e0c:	c3                   	ret
    panic("sched ptable.lock");
80103e0d:	83 ec 0c             	sub    $0xc,%esp
80103e10:	68 1a 75 10 80       	push   $0x8010751a
80103e15:	e8 66 c5 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103e1a:	83 ec 0c             	sub    $0xc,%esp
80103e1d:	68 46 75 10 80       	push   $0x80107546
80103e22:	e8 59 c5 ff ff       	call   80100380 <panic>
    panic("sched running");
80103e27:	83 ec 0c             	sub    $0xc,%esp
80103e2a:	68 38 75 10 80       	push   $0x80107538
80103e2f:	e8 4c c5 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103e34:	83 ec 0c             	sub    $0xc,%esp
80103e37:	68 2c 75 10 80       	push   $0x8010752c
80103e3c:	e8 3f c5 ff ff       	call   80100380 <panic>
80103e41:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103e48:	00 
80103e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103e50 <exit>:
{
80103e50:	55                   	push   %ebp
80103e51:	89 e5                	mov    %esp,%ebp
80103e53:	57                   	push   %edi
80103e54:	56                   	push   %esi
80103e55:	53                   	push   %ebx
80103e56:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103e59:	e8 e2 fb ff ff       	call   80103a40 <myproc>
  if(curproc == initproc)
80103e5e:	39 05 74 3c 11 80    	cmp    %eax,0x80113c74
80103e64:	0f 84 fd 00 00 00    	je     80103f67 <exit+0x117>
80103e6a:	89 c3                	mov    %eax,%ebx
80103e6c:	8d 70 28             	lea    0x28(%eax),%esi
80103e6f:	8d 78 68             	lea    0x68(%eax),%edi
80103e72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103e78:	8b 06                	mov    (%esi),%eax
80103e7a:	85 c0                	test   %eax,%eax
80103e7c:	74 12                	je     80103e90 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80103e7e:	83 ec 0c             	sub    $0xc,%esp
80103e81:	50                   	push   %eax
80103e82:	e8 f9 d0 ff ff       	call   80100f80 <fileclose>
      curproc->ofile[fd] = 0;
80103e87:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103e8d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103e90:	83 c6 04             	add    $0x4,%esi
80103e93:	39 f7                	cmp    %esi,%edi
80103e95:	75 e1                	jne    80103e78 <exit+0x28>
  begin_op();
80103e97:	e8 14 ef ff ff       	call   80102db0 <begin_op>
  iput(curproc->cwd);
80103e9c:	83 ec 0c             	sub    $0xc,%esp
80103e9f:	ff 73 68             	push   0x68(%ebx)
80103ea2:	e8 99 da ff ff       	call   80101940 <iput>
  end_op();
80103ea7:	e8 74 ef ff ff       	call   80102e20 <end_op>
  curproc->cwd = 0;
80103eac:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103eb3:	c7 04 24 40 1d 11 80 	movl   $0x80111d40,(%esp)
80103eba:	e8 c1 07 00 00       	call   80104680 <acquire>
  wakeup1(curproc->parent);
80103ebf:	8b 53 14             	mov    0x14(%ebx),%edx
80103ec2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ec5:	b8 74 1d 11 80       	mov    $0x80111d74,%eax
80103eca:	eb 0e                	jmp    80103eda <exit+0x8a>
80103ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ed0:	83 c0 7c             	add    $0x7c,%eax
80103ed3:	3d 74 3c 11 80       	cmp    $0x80113c74,%eax
80103ed8:	74 1c                	je     80103ef6 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
80103eda:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103ede:	75 f0                	jne    80103ed0 <exit+0x80>
80103ee0:	3b 50 20             	cmp    0x20(%eax),%edx
80103ee3:	75 eb                	jne    80103ed0 <exit+0x80>
      p->state = RUNNABLE;
80103ee5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103eec:	83 c0 7c             	add    $0x7c,%eax
80103eef:	3d 74 3c 11 80       	cmp    $0x80113c74,%eax
80103ef4:	75 e4                	jne    80103eda <exit+0x8a>
      p->parent = initproc;
80103ef6:	8b 0d 74 3c 11 80    	mov    0x80113c74,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103efc:	ba 74 1d 11 80       	mov    $0x80111d74,%edx
80103f01:	eb 10                	jmp    80103f13 <exit+0xc3>
80103f03:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103f08:	83 c2 7c             	add    $0x7c,%edx
80103f0b:	81 fa 74 3c 11 80    	cmp    $0x80113c74,%edx
80103f11:	74 3b                	je     80103f4e <exit+0xfe>
    if(p->parent == curproc){
80103f13:	39 5a 14             	cmp    %ebx,0x14(%edx)
80103f16:	75 f0                	jne    80103f08 <exit+0xb8>
      if(p->state == ZOMBIE)
80103f18:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103f1c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103f1f:	75 e7                	jne    80103f08 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f21:	b8 74 1d 11 80       	mov    $0x80111d74,%eax
80103f26:	eb 12                	jmp    80103f3a <exit+0xea>
80103f28:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103f2f:	00 
80103f30:	83 c0 7c             	add    $0x7c,%eax
80103f33:	3d 74 3c 11 80       	cmp    $0x80113c74,%eax
80103f38:	74 ce                	je     80103f08 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
80103f3a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103f3e:	75 f0                	jne    80103f30 <exit+0xe0>
80103f40:	3b 48 20             	cmp    0x20(%eax),%ecx
80103f43:	75 eb                	jne    80103f30 <exit+0xe0>
      p->state = RUNNABLE;
80103f45:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103f4c:	eb e2                	jmp    80103f30 <exit+0xe0>
  curproc->state = ZOMBIE;
80103f4e:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103f55:	e8 36 fe ff ff       	call   80103d90 <sched>
  panic("zombie exit");
80103f5a:	83 ec 0c             	sub    $0xc,%esp
80103f5d:	68 67 75 10 80       	push   $0x80107567
80103f62:	e8 19 c4 ff ff       	call   80100380 <panic>
    panic("init exiting");
80103f67:	83 ec 0c             	sub    $0xc,%esp
80103f6a:	68 5a 75 10 80       	push   $0x8010755a
80103f6f:	e8 0c c4 ff ff       	call   80100380 <panic>
80103f74:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103f7b:	00 
80103f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103f80 <wait>:
{
80103f80:	55                   	push   %ebp
80103f81:	89 e5                	mov    %esp,%ebp
80103f83:	56                   	push   %esi
80103f84:	53                   	push   %ebx
  pushcli();
80103f85:	e8 a6 05 00 00       	call   80104530 <pushcli>
  c = mycpu();
80103f8a:	e8 31 fa ff ff       	call   801039c0 <mycpu>
  p = c->proc;
80103f8f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103f95:	e8 e6 05 00 00       	call   80104580 <popcli>
  acquire(&ptable.lock);
80103f9a:	83 ec 0c             	sub    $0xc,%esp
80103f9d:	68 40 1d 11 80       	push   $0x80111d40
80103fa2:	e8 d9 06 00 00       	call   80104680 <acquire>
80103fa7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103faa:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fac:	bb 74 1d 11 80       	mov    $0x80111d74,%ebx
80103fb1:	eb 10                	jmp    80103fc3 <wait+0x43>
80103fb3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103fb8:	83 c3 7c             	add    $0x7c,%ebx
80103fbb:	81 fb 74 3c 11 80    	cmp    $0x80113c74,%ebx
80103fc1:	74 1b                	je     80103fde <wait+0x5e>
      if(p->parent != curproc)
80103fc3:	39 73 14             	cmp    %esi,0x14(%ebx)
80103fc6:	75 f0                	jne    80103fb8 <wait+0x38>
      if(p->state == ZOMBIE){
80103fc8:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103fcc:	74 62                	je     80104030 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fce:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80103fd1:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fd6:	81 fb 74 3c 11 80    	cmp    $0x80113c74,%ebx
80103fdc:	75 e5                	jne    80103fc3 <wait+0x43>
    if(!havekids || curproc->killed){
80103fde:	85 c0                	test   %eax,%eax
80103fe0:	0f 84 a0 00 00 00    	je     80104086 <wait+0x106>
80103fe6:	8b 46 24             	mov    0x24(%esi),%eax
80103fe9:	85 c0                	test   %eax,%eax
80103feb:	0f 85 95 00 00 00    	jne    80104086 <wait+0x106>
  pushcli();
80103ff1:	e8 3a 05 00 00       	call   80104530 <pushcli>
  c = mycpu();
80103ff6:	e8 c5 f9 ff ff       	call   801039c0 <mycpu>
  p = c->proc;
80103ffb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104001:	e8 7a 05 00 00       	call   80104580 <popcli>
  if(p == 0)
80104006:	85 db                	test   %ebx,%ebx
80104008:	0f 84 8f 00 00 00    	je     8010409d <wait+0x11d>
  p->chan = chan;
8010400e:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80104011:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104018:	e8 73 fd ff ff       	call   80103d90 <sched>
  p->chan = 0;
8010401d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104024:	eb 84                	jmp    80103faa <wait+0x2a>
80104026:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010402d:	00 
8010402e:	66 90                	xchg   %ax,%ax
        kfree(p->kstack);
80104030:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104033:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104036:	ff 73 08             	push   0x8(%ebx)
80104039:	e8 d2 e4 ff ff       	call   80102510 <kfree>
        p->kstack = 0;
8010403e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104045:	5a                   	pop    %edx
80104046:	ff 73 04             	push   0x4(%ebx)
80104049:	e8 32 2e 00 00       	call   80106e80 <freevm>
        p->pid = 0;
8010404e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104055:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010405c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104060:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104067:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010406e:	c7 04 24 40 1d 11 80 	movl   $0x80111d40,(%esp)
80104075:	e8 a6 05 00 00       	call   80104620 <release>
        return pid;
8010407a:	83 c4 10             	add    $0x10,%esp
}
8010407d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104080:	89 f0                	mov    %esi,%eax
80104082:	5b                   	pop    %ebx
80104083:	5e                   	pop    %esi
80104084:	5d                   	pop    %ebp
80104085:	c3                   	ret
      release(&ptable.lock);
80104086:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104089:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010408e:	68 40 1d 11 80       	push   $0x80111d40
80104093:	e8 88 05 00 00       	call   80104620 <release>
      return -1;
80104098:	83 c4 10             	add    $0x10,%esp
8010409b:	eb e0                	jmp    8010407d <wait+0xfd>
    panic("sleep");
8010409d:	83 ec 0c             	sub    $0xc,%esp
801040a0:	68 73 75 10 80       	push   $0x80107573
801040a5:	e8 d6 c2 ff ff       	call   80100380 <panic>
801040aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801040b0 <yield>:
{
801040b0:	55                   	push   %ebp
801040b1:	89 e5                	mov    %esp,%ebp
801040b3:	53                   	push   %ebx
801040b4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801040b7:	68 40 1d 11 80       	push   $0x80111d40
801040bc:	e8 bf 05 00 00       	call   80104680 <acquire>
  pushcli();
801040c1:	e8 6a 04 00 00       	call   80104530 <pushcli>
  c = mycpu();
801040c6:	e8 f5 f8 ff ff       	call   801039c0 <mycpu>
  p = c->proc;
801040cb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040d1:	e8 aa 04 00 00       	call   80104580 <popcli>
  myproc()->state = RUNNABLE;
801040d6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801040dd:	e8 ae fc ff ff       	call   80103d90 <sched>
  release(&ptable.lock);
801040e2:	c7 04 24 40 1d 11 80 	movl   $0x80111d40,(%esp)
801040e9:	e8 32 05 00 00       	call   80104620 <release>
}
801040ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040f1:	83 c4 10             	add    $0x10,%esp
801040f4:	c9                   	leave
801040f5:	c3                   	ret
801040f6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801040fd:	00 
801040fe:	66 90                	xchg   %ax,%ax

80104100 <sleep>:
{
80104100:	55                   	push   %ebp
80104101:	89 e5                	mov    %esp,%ebp
80104103:	57                   	push   %edi
80104104:	56                   	push   %esi
80104105:	53                   	push   %ebx
80104106:	83 ec 0c             	sub    $0xc,%esp
80104109:	8b 7d 08             	mov    0x8(%ebp),%edi
8010410c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010410f:	e8 1c 04 00 00       	call   80104530 <pushcli>
  c = mycpu();
80104114:	e8 a7 f8 ff ff       	call   801039c0 <mycpu>
  p = c->proc;
80104119:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010411f:	e8 5c 04 00 00       	call   80104580 <popcli>
  if(p == 0)
80104124:	85 db                	test   %ebx,%ebx
80104126:	0f 84 87 00 00 00    	je     801041b3 <sleep+0xb3>
  if(lk == 0)
8010412c:	85 f6                	test   %esi,%esi
8010412e:	74 76                	je     801041a6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104130:	81 fe 40 1d 11 80    	cmp    $0x80111d40,%esi
80104136:	74 50                	je     80104188 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104138:	83 ec 0c             	sub    $0xc,%esp
8010413b:	68 40 1d 11 80       	push   $0x80111d40
80104140:	e8 3b 05 00 00       	call   80104680 <acquire>
    release(lk);
80104145:	89 34 24             	mov    %esi,(%esp)
80104148:	e8 d3 04 00 00       	call   80104620 <release>
  p->chan = chan;
8010414d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104150:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104157:	e8 34 fc ff ff       	call   80103d90 <sched>
  p->chan = 0;
8010415c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104163:	c7 04 24 40 1d 11 80 	movl   $0x80111d40,(%esp)
8010416a:	e8 b1 04 00 00       	call   80104620 <release>
    acquire(lk);
8010416f:	83 c4 10             	add    $0x10,%esp
80104172:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104175:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104178:	5b                   	pop    %ebx
80104179:	5e                   	pop    %esi
8010417a:	5f                   	pop    %edi
8010417b:	5d                   	pop    %ebp
    acquire(lk);
8010417c:	e9 ff 04 00 00       	jmp    80104680 <acquire>
80104181:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104188:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010418b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104192:	e8 f9 fb ff ff       	call   80103d90 <sched>
  p->chan = 0;
80104197:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010419e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041a1:	5b                   	pop    %ebx
801041a2:	5e                   	pop    %esi
801041a3:	5f                   	pop    %edi
801041a4:	5d                   	pop    %ebp
801041a5:	c3                   	ret
    panic("sleep without lk");
801041a6:	83 ec 0c             	sub    $0xc,%esp
801041a9:	68 79 75 10 80       	push   $0x80107579
801041ae:	e8 cd c1 ff ff       	call   80100380 <panic>
    panic("sleep");
801041b3:	83 ec 0c             	sub    $0xc,%esp
801041b6:	68 73 75 10 80       	push   $0x80107573
801041bb:	e8 c0 c1 ff ff       	call   80100380 <panic>

801041c0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801041c0:	55                   	push   %ebp
801041c1:	89 e5                	mov    %esp,%ebp
801041c3:	53                   	push   %ebx
801041c4:	83 ec 10             	sub    $0x10,%esp
801041c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801041ca:	68 40 1d 11 80       	push   $0x80111d40
801041cf:	e8 ac 04 00 00       	call   80104680 <acquire>
801041d4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041d7:	b8 74 1d 11 80       	mov    $0x80111d74,%eax
801041dc:	eb 0c                	jmp    801041ea <wakeup+0x2a>
801041de:	66 90                	xchg   %ax,%ax
801041e0:	83 c0 7c             	add    $0x7c,%eax
801041e3:	3d 74 3c 11 80       	cmp    $0x80113c74,%eax
801041e8:	74 1c                	je     80104206 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
801041ea:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801041ee:	75 f0                	jne    801041e0 <wakeup+0x20>
801041f0:	3b 58 20             	cmp    0x20(%eax),%ebx
801041f3:	75 eb                	jne    801041e0 <wakeup+0x20>
      p->state = RUNNABLE;
801041f5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041fc:	83 c0 7c             	add    $0x7c,%eax
801041ff:	3d 74 3c 11 80       	cmp    $0x80113c74,%eax
80104204:	75 e4                	jne    801041ea <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104206:	c7 45 08 40 1d 11 80 	movl   $0x80111d40,0x8(%ebp)
}
8010420d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104210:	c9                   	leave
  release(&ptable.lock);
80104211:	e9 0a 04 00 00       	jmp    80104620 <release>
80104216:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010421d:	00 
8010421e:	66 90                	xchg   %ax,%ax

80104220 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104220:	55                   	push   %ebp
80104221:	89 e5                	mov    %esp,%ebp
80104223:	53                   	push   %ebx
80104224:	83 ec 10             	sub    $0x10,%esp
80104227:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010422a:	68 40 1d 11 80       	push   $0x80111d40
8010422f:	e8 4c 04 00 00       	call   80104680 <acquire>
80104234:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104237:	b8 74 1d 11 80       	mov    $0x80111d74,%eax
8010423c:	eb 0c                	jmp    8010424a <kill+0x2a>
8010423e:	66 90                	xchg   %ax,%ax
80104240:	83 c0 7c             	add    $0x7c,%eax
80104243:	3d 74 3c 11 80       	cmp    $0x80113c74,%eax
80104248:	74 36                	je     80104280 <kill+0x60>
    if(p->pid == pid){
8010424a:	39 58 10             	cmp    %ebx,0x10(%eax)
8010424d:	75 f1                	jne    80104240 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010424f:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104253:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010425a:	75 07                	jne    80104263 <kill+0x43>
        p->state = RUNNABLE;
8010425c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104263:	83 ec 0c             	sub    $0xc,%esp
80104266:	68 40 1d 11 80       	push   $0x80111d40
8010426b:	e8 b0 03 00 00       	call   80104620 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104270:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104273:	83 c4 10             	add    $0x10,%esp
80104276:	31 c0                	xor    %eax,%eax
}
80104278:	c9                   	leave
80104279:	c3                   	ret
8010427a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104280:	83 ec 0c             	sub    $0xc,%esp
80104283:	68 40 1d 11 80       	push   $0x80111d40
80104288:	e8 93 03 00 00       	call   80104620 <release>
}
8010428d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104290:	83 c4 10             	add    $0x10,%esp
80104293:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104298:	c9                   	leave
80104299:	c3                   	ret
8010429a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801042a0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801042a0:	55                   	push   %ebp
801042a1:	89 e5                	mov    %esp,%ebp
801042a3:	57                   	push   %edi
801042a4:	56                   	push   %esi
801042a5:	8d 75 e8             	lea    -0x18(%ebp),%esi
801042a8:	53                   	push   %ebx
801042a9:	bb e0 1d 11 80       	mov    $0x80111de0,%ebx
801042ae:	83 ec 3c             	sub    $0x3c,%esp
801042b1:	eb 24                	jmp    801042d7 <procdump+0x37>
801042b3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801042b8:	83 ec 0c             	sub    $0xc,%esp
801042bb:	68 38 77 10 80       	push   $0x80107738
801042c0:	e8 eb c3 ff ff       	call   801006b0 <cprintf>
801042c5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042c8:	83 c3 7c             	add    $0x7c,%ebx
801042cb:	81 fb e0 3c 11 80    	cmp    $0x80113ce0,%ebx
801042d1:	0f 84 81 00 00 00    	je     80104358 <procdump+0xb8>
    if(p->state == UNUSED)
801042d7:	8b 43 a0             	mov    -0x60(%ebx),%eax
801042da:	85 c0                	test   %eax,%eax
801042dc:	74 ea                	je     801042c8 <procdump+0x28>
      state = "???";
801042de:	ba 8a 75 10 80       	mov    $0x8010758a,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801042e3:	83 f8 05             	cmp    $0x5,%eax
801042e6:	77 11                	ja     801042f9 <procdump+0x59>
801042e8:	8b 14 85 60 7b 10 80 	mov    -0x7fef84a0(,%eax,4),%edx
      state = "???";
801042ef:	b8 8a 75 10 80       	mov    $0x8010758a,%eax
801042f4:	85 d2                	test   %edx,%edx
801042f6:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801042f9:	53                   	push   %ebx
801042fa:	52                   	push   %edx
801042fb:	ff 73 a4             	push   -0x5c(%ebx)
801042fe:	68 8e 75 10 80       	push   $0x8010758e
80104303:	e8 a8 c3 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
80104308:	83 c4 10             	add    $0x10,%esp
8010430b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010430f:	75 a7                	jne    801042b8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104311:	83 ec 08             	sub    $0x8,%esp
80104314:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104317:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010431a:	50                   	push   %eax
8010431b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010431e:	8b 40 0c             	mov    0xc(%eax),%eax
80104321:	83 c0 08             	add    $0x8,%eax
80104324:	50                   	push   %eax
80104325:	e8 86 01 00 00       	call   801044b0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
8010432a:	83 c4 10             	add    $0x10,%esp
8010432d:	8d 76 00             	lea    0x0(%esi),%esi
80104330:	8b 17                	mov    (%edi),%edx
80104332:	85 d2                	test   %edx,%edx
80104334:	74 82                	je     801042b8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104336:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104339:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010433c:	52                   	push   %edx
8010433d:	68 81 72 10 80       	push   $0x80107281
80104342:	e8 69 c3 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104347:	83 c4 10             	add    $0x10,%esp
8010434a:	39 f7                	cmp    %esi,%edi
8010434c:	75 e2                	jne    80104330 <procdump+0x90>
8010434e:	e9 65 ff ff ff       	jmp    801042b8 <procdump+0x18>
80104353:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  }
}
80104358:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010435b:	5b                   	pop    %ebx
8010435c:	5e                   	pop    %esi
8010435d:	5f                   	pop    %edi
8010435e:	5d                   	pop    %ebp
8010435f:	c3                   	ret

80104360 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104360:	55                   	push   %ebp
80104361:	89 e5                	mov    %esp,%ebp
80104363:	53                   	push   %ebx
80104364:	83 ec 0c             	sub    $0xc,%esp
80104367:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010436a:	68 c1 75 10 80       	push   $0x801075c1
8010436f:	8d 43 04             	lea    0x4(%ebx),%eax
80104372:	50                   	push   %eax
80104373:	e8 18 01 00 00       	call   80104490 <initlock>
  lk->name = name;
80104378:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010437b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104381:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104384:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010438b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010438e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104391:	c9                   	leave
80104392:	c3                   	ret
80104393:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010439a:	00 
8010439b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801043a0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	56                   	push   %esi
801043a4:	53                   	push   %ebx
801043a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801043a8:	8d 73 04             	lea    0x4(%ebx),%esi
801043ab:	83 ec 0c             	sub    $0xc,%esp
801043ae:	56                   	push   %esi
801043af:	e8 cc 02 00 00       	call   80104680 <acquire>
  while (lk->locked) {
801043b4:	8b 13                	mov    (%ebx),%edx
801043b6:	83 c4 10             	add    $0x10,%esp
801043b9:	85 d2                	test   %edx,%edx
801043bb:	74 16                	je     801043d3 <acquiresleep+0x33>
801043bd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801043c0:	83 ec 08             	sub    $0x8,%esp
801043c3:	56                   	push   %esi
801043c4:	53                   	push   %ebx
801043c5:	e8 36 fd ff ff       	call   80104100 <sleep>
  while (lk->locked) {
801043ca:	8b 03                	mov    (%ebx),%eax
801043cc:	83 c4 10             	add    $0x10,%esp
801043cf:	85 c0                	test   %eax,%eax
801043d1:	75 ed                	jne    801043c0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801043d3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801043d9:	e8 62 f6 ff ff       	call   80103a40 <myproc>
801043de:	8b 40 10             	mov    0x10(%eax),%eax
801043e1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801043e4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801043e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801043ea:	5b                   	pop    %ebx
801043eb:	5e                   	pop    %esi
801043ec:	5d                   	pop    %ebp
  release(&lk->lk);
801043ed:	e9 2e 02 00 00       	jmp    80104620 <release>
801043f2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801043f9:	00 
801043fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104400 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp
80104403:	56                   	push   %esi
80104404:	53                   	push   %ebx
80104405:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104408:	8d 73 04             	lea    0x4(%ebx),%esi
8010440b:	83 ec 0c             	sub    $0xc,%esp
8010440e:	56                   	push   %esi
8010440f:	e8 6c 02 00 00       	call   80104680 <acquire>
  lk->locked = 0;
80104414:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010441a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104421:	89 1c 24             	mov    %ebx,(%esp)
80104424:	e8 97 fd ff ff       	call   801041c0 <wakeup>
  release(&lk->lk);
80104429:	83 c4 10             	add    $0x10,%esp
8010442c:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010442f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104432:	5b                   	pop    %ebx
80104433:	5e                   	pop    %esi
80104434:	5d                   	pop    %ebp
  release(&lk->lk);
80104435:	e9 e6 01 00 00       	jmp    80104620 <release>
8010443a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104440 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104440:	55                   	push   %ebp
80104441:	89 e5                	mov    %esp,%ebp
80104443:	57                   	push   %edi
80104444:	31 ff                	xor    %edi,%edi
80104446:	56                   	push   %esi
80104447:	53                   	push   %ebx
80104448:	83 ec 18             	sub    $0x18,%esp
8010444b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010444e:	8d 73 04             	lea    0x4(%ebx),%esi
80104451:	56                   	push   %esi
80104452:	e8 29 02 00 00       	call   80104680 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104457:	8b 03                	mov    (%ebx),%eax
80104459:	83 c4 10             	add    $0x10,%esp
8010445c:	85 c0                	test   %eax,%eax
8010445e:	75 18                	jne    80104478 <holdingsleep+0x38>
  release(&lk->lk);
80104460:	83 ec 0c             	sub    $0xc,%esp
80104463:	56                   	push   %esi
80104464:	e8 b7 01 00 00       	call   80104620 <release>
  return r;
}
80104469:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010446c:	89 f8                	mov    %edi,%eax
8010446e:	5b                   	pop    %ebx
8010446f:	5e                   	pop    %esi
80104470:	5f                   	pop    %edi
80104471:	5d                   	pop    %ebp
80104472:	c3                   	ret
80104473:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  r = lk->locked && (lk->pid == myproc()->pid);
80104478:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010447b:	e8 c0 f5 ff ff       	call   80103a40 <myproc>
80104480:	39 58 10             	cmp    %ebx,0x10(%eax)
80104483:	0f 94 c0             	sete   %al
80104486:	0f b6 c0             	movzbl %al,%eax
80104489:	89 c7                	mov    %eax,%edi
8010448b:	eb d3                	jmp    80104460 <holdingsleep+0x20>
8010448d:	66 90                	xchg   %ax,%ax
8010448f:	90                   	nop

80104490 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104490:	55                   	push   %ebp
80104491:	89 e5                	mov    %esp,%ebp
80104493:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104496:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104499:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010449f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801044a2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801044a9:	5d                   	pop    %ebp
801044aa:	c3                   	ret
801044ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801044b0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801044b0:	55                   	push   %ebp
801044b1:	89 e5                	mov    %esp,%ebp
801044b3:	53                   	push   %ebx
801044b4:	8b 45 08             	mov    0x8(%ebp),%eax
801044b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801044ba:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801044bd:	05 f8 ff ff 7f       	add    $0x7ffffff8,%eax
801044c2:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
  for(i = 0; i < 10; i++){
801044c7:	b8 00 00 00 00       	mov    $0x0,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801044cc:	76 10                	jbe    801044de <getcallerpcs+0x2e>
801044ce:	eb 28                	jmp    801044f8 <getcallerpcs+0x48>
801044d0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801044d6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801044dc:	77 1a                	ja     801044f8 <getcallerpcs+0x48>
      break;
    pcs[i] = ebp[1];     // saved %eip
801044de:	8b 5a 04             	mov    0x4(%edx),%ebx
801044e1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
801044e4:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
801044e7:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801044e9:	83 f8 0a             	cmp    $0xa,%eax
801044ec:	75 e2                	jne    801044d0 <getcallerpcs+0x20>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801044ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044f1:	c9                   	leave
801044f2:	c3                   	ret
801044f3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801044f8:	8d 04 81             	lea    (%ecx,%eax,4),%eax
801044fb:	83 c1 28             	add    $0x28,%ecx
801044fe:	89 ca                	mov    %ecx,%edx
80104500:	29 c2                	sub    %eax,%edx
80104502:	83 e2 04             	and    $0x4,%edx
80104505:	74 11                	je     80104518 <getcallerpcs+0x68>
    pcs[i] = 0;
80104507:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
8010450d:	83 c0 04             	add    $0x4,%eax
80104510:	39 c1                	cmp    %eax,%ecx
80104512:	74 da                	je     801044ee <getcallerpcs+0x3e>
80104514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
80104518:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
8010451e:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80104521:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80104528:	39 c1                	cmp    %eax,%ecx
8010452a:	75 ec                	jne    80104518 <getcallerpcs+0x68>
8010452c:	eb c0                	jmp    801044ee <getcallerpcs+0x3e>
8010452e:	66 90                	xchg   %ax,%ax

80104530 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104530:	55                   	push   %ebp
80104531:	89 e5                	mov    %esp,%ebp
80104533:	53                   	push   %ebx
80104534:	83 ec 04             	sub    $0x4,%esp
80104537:	9c                   	pushf
80104538:	5b                   	pop    %ebx
  asm volatile("cli");
80104539:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010453a:	e8 81 f4 ff ff       	call   801039c0 <mycpu>
8010453f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104545:	85 c0                	test   %eax,%eax
80104547:	74 17                	je     80104560 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104549:	e8 72 f4 ff ff       	call   801039c0 <mycpu>
8010454e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104555:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104558:	c9                   	leave
80104559:	c3                   	ret
8010455a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104560:	e8 5b f4 ff ff       	call   801039c0 <mycpu>
80104565:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010456b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104571:	eb d6                	jmp    80104549 <pushcli+0x19>
80104573:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010457a:	00 
8010457b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104580 <popcli>:

void
popcli(void)
{
80104580:	55                   	push   %ebp
80104581:	89 e5                	mov    %esp,%ebp
80104583:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104586:	9c                   	pushf
80104587:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104588:	f6 c4 02             	test   $0x2,%ah
8010458b:	75 35                	jne    801045c2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010458d:	e8 2e f4 ff ff       	call   801039c0 <mycpu>
80104592:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104599:	78 34                	js     801045cf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010459b:	e8 20 f4 ff ff       	call   801039c0 <mycpu>
801045a0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801045a6:	85 d2                	test   %edx,%edx
801045a8:	74 06                	je     801045b0 <popcli+0x30>
    sti();
}
801045aa:	c9                   	leave
801045ab:	c3                   	ret
801045ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801045b0:	e8 0b f4 ff ff       	call   801039c0 <mycpu>
801045b5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801045bb:	85 c0                	test   %eax,%eax
801045bd:	74 eb                	je     801045aa <popcli+0x2a>
  asm volatile("sti");
801045bf:	fb                   	sti
}
801045c0:	c9                   	leave
801045c1:	c3                   	ret
    panic("popcli - interruptible");
801045c2:	83 ec 0c             	sub    $0xc,%esp
801045c5:	68 cc 75 10 80       	push   $0x801075cc
801045ca:	e8 b1 bd ff ff       	call   80100380 <panic>
    panic("popcli");
801045cf:	83 ec 0c             	sub    $0xc,%esp
801045d2:	68 e3 75 10 80       	push   $0x801075e3
801045d7:	e8 a4 bd ff ff       	call   80100380 <panic>
801045dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801045e0 <holding>:
{
801045e0:	55                   	push   %ebp
801045e1:	89 e5                	mov    %esp,%ebp
801045e3:	56                   	push   %esi
801045e4:	53                   	push   %ebx
801045e5:	8b 75 08             	mov    0x8(%ebp),%esi
801045e8:	31 db                	xor    %ebx,%ebx
  pushcli();
801045ea:	e8 41 ff ff ff       	call   80104530 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801045ef:	8b 06                	mov    (%esi),%eax
801045f1:	85 c0                	test   %eax,%eax
801045f3:	75 0b                	jne    80104600 <holding+0x20>
  popcli();
801045f5:	e8 86 ff ff ff       	call   80104580 <popcli>
}
801045fa:	89 d8                	mov    %ebx,%eax
801045fc:	5b                   	pop    %ebx
801045fd:	5e                   	pop    %esi
801045fe:	5d                   	pop    %ebp
801045ff:	c3                   	ret
  r = lock->locked && lock->cpu == mycpu();
80104600:	8b 5e 08             	mov    0x8(%esi),%ebx
80104603:	e8 b8 f3 ff ff       	call   801039c0 <mycpu>
80104608:	39 c3                	cmp    %eax,%ebx
8010460a:	0f 94 c3             	sete   %bl
  popcli();
8010460d:	e8 6e ff ff ff       	call   80104580 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104612:	0f b6 db             	movzbl %bl,%ebx
}
80104615:	89 d8                	mov    %ebx,%eax
80104617:	5b                   	pop    %ebx
80104618:	5e                   	pop    %esi
80104619:	5d                   	pop    %ebp
8010461a:	c3                   	ret
8010461b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104620 <release>:
{
80104620:	55                   	push   %ebp
80104621:	89 e5                	mov    %esp,%ebp
80104623:	56                   	push   %esi
80104624:	53                   	push   %ebx
80104625:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104628:	e8 03 ff ff ff       	call   80104530 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010462d:	8b 03                	mov    (%ebx),%eax
8010462f:	85 c0                	test   %eax,%eax
80104631:	75 15                	jne    80104648 <release+0x28>
  popcli();
80104633:	e8 48 ff ff ff       	call   80104580 <popcli>
    panic("release");
80104638:	83 ec 0c             	sub    $0xc,%esp
8010463b:	68 ea 75 10 80       	push   $0x801075ea
80104640:	e8 3b bd ff ff       	call   80100380 <panic>
80104645:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104648:	8b 73 08             	mov    0x8(%ebx),%esi
8010464b:	e8 70 f3 ff ff       	call   801039c0 <mycpu>
80104650:	39 c6                	cmp    %eax,%esi
80104652:	75 df                	jne    80104633 <release+0x13>
  popcli();
80104654:	e8 27 ff ff ff       	call   80104580 <popcli>
  lk->pcs[0] = 0;
80104659:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104660:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104667:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010466c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104672:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104675:	5b                   	pop    %ebx
80104676:	5e                   	pop    %esi
80104677:	5d                   	pop    %ebp
  popcli();
80104678:	e9 03 ff ff ff       	jmp    80104580 <popcli>
8010467d:	8d 76 00             	lea    0x0(%esi),%esi

80104680 <acquire>:
{
80104680:	55                   	push   %ebp
80104681:	89 e5                	mov    %esp,%ebp
80104683:	53                   	push   %ebx
80104684:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104687:	e8 a4 fe ff ff       	call   80104530 <pushcli>
  if(holding(lk))
8010468c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010468f:	e8 9c fe ff ff       	call   80104530 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104694:	8b 03                	mov    (%ebx),%eax
80104696:	85 c0                	test   %eax,%eax
80104698:	0f 85 b2 00 00 00    	jne    80104750 <acquire+0xd0>
  popcli();
8010469e:	e8 dd fe ff ff       	call   80104580 <popcli>
  asm volatile("lock; xchgl %0, %1" :
801046a3:	b9 01 00 00 00       	mov    $0x1,%ecx
801046a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801046af:	00 
  while(xchg(&lk->locked, 1) != 0)
801046b0:	8b 55 08             	mov    0x8(%ebp),%edx
801046b3:	89 c8                	mov    %ecx,%eax
801046b5:	f0 87 02             	lock xchg %eax,(%edx)
801046b8:	85 c0                	test   %eax,%eax
801046ba:	75 f4                	jne    801046b0 <acquire+0x30>
  __sync_synchronize();
801046bc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801046c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801046c4:	e8 f7 f2 ff ff       	call   801039c0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801046c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for(i = 0; i < 10; i++){
801046cc:	31 d2                	xor    %edx,%edx
  lk->cpu = mycpu();
801046ce:	89 43 08             	mov    %eax,0x8(%ebx)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801046d1:	8d 85 00 00 00 80    	lea    -0x80000000(%ebp),%eax
801046d7:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
801046dc:	77 32                	ja     80104710 <acquire+0x90>
  ebp = (uint*)v - 2;
801046de:	89 e8                	mov    %ebp,%eax
801046e0:	eb 14                	jmp    801046f6 <acquire+0x76>
801046e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801046e8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801046ee:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801046f4:	77 1a                	ja     80104710 <acquire+0x90>
    pcs[i] = ebp[1];     // saved %eip
801046f6:	8b 58 04             	mov    0x4(%eax),%ebx
801046f9:	89 5c 91 0c          	mov    %ebx,0xc(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801046fd:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104700:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104702:	83 fa 0a             	cmp    $0xa,%edx
80104705:	75 e1                	jne    801046e8 <acquire+0x68>
}
80104707:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010470a:	c9                   	leave
8010470b:	c3                   	ret
8010470c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104710:	8d 44 91 0c          	lea    0xc(%ecx,%edx,4),%eax
80104714:	83 c1 34             	add    $0x34,%ecx
80104717:	89 ca                	mov    %ecx,%edx
80104719:	29 c2                	sub    %eax,%edx
8010471b:	83 e2 04             	and    $0x4,%edx
8010471e:	74 10                	je     80104730 <acquire+0xb0>
    pcs[i] = 0;
80104720:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104726:	83 c0 04             	add    $0x4,%eax
80104729:	39 c1                	cmp    %eax,%ecx
8010472b:	74 da                	je     80104707 <acquire+0x87>
8010472d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104730:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104736:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80104739:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80104740:	39 c1                	cmp    %eax,%ecx
80104742:	75 ec                	jne    80104730 <acquire+0xb0>
80104744:	eb c1                	jmp    80104707 <acquire+0x87>
80104746:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010474d:	00 
8010474e:	66 90                	xchg   %ax,%ax
  r = lock->locked && lock->cpu == mycpu();
80104750:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104753:	e8 68 f2 ff ff       	call   801039c0 <mycpu>
80104758:	39 c3                	cmp    %eax,%ebx
8010475a:	0f 85 3e ff ff ff    	jne    8010469e <acquire+0x1e>
  popcli();
80104760:	e8 1b fe ff ff       	call   80104580 <popcli>
    panic("acquire");
80104765:	83 ec 0c             	sub    $0xc,%esp
80104768:	68 f2 75 10 80       	push   $0x801075f2
8010476d:	e8 0e bc ff ff       	call   80100380 <panic>
80104772:	66 90                	xchg   %ax,%ax
80104774:	66 90                	xchg   %ax,%ax
80104776:	66 90                	xchg   %ax,%ax
80104778:	66 90                	xchg   %ax,%ax
8010477a:	66 90                	xchg   %ax,%ax
8010477c:	66 90                	xchg   %ax,%ax
8010477e:	66 90                	xchg   %ax,%ax

80104780 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
80104783:	57                   	push   %edi
80104784:	8b 55 08             	mov    0x8(%ebp),%edx
80104787:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010478a:	89 d0                	mov    %edx,%eax
8010478c:	09 c8                	or     %ecx,%eax
8010478e:	a8 03                	test   $0x3,%al
80104790:	75 1e                	jne    801047b0 <memset+0x30>
    c &= 0xFF;
80104792:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104796:	c1 e9 02             	shr    $0x2,%ecx
  asm volatile("cld; rep stosl" :
80104799:	89 d7                	mov    %edx,%edi
8010479b:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
801047a1:	fc                   	cld
801047a2:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801047a4:	8b 7d fc             	mov    -0x4(%ebp),%edi
801047a7:	89 d0                	mov    %edx,%eax
801047a9:	c9                   	leave
801047aa:	c3                   	ret
801047ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
801047b0:	8b 45 0c             	mov    0xc(%ebp),%eax
801047b3:	89 d7                	mov    %edx,%edi
801047b5:	fc                   	cld
801047b6:	f3 aa                	rep stos %al,%es:(%edi)
801047b8:	8b 7d fc             	mov    -0x4(%ebp),%edi
801047bb:	89 d0                	mov    %edx,%eax
801047bd:	c9                   	leave
801047be:	c3                   	ret
801047bf:	90                   	nop

801047c0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801047c0:	55                   	push   %ebp
801047c1:	89 e5                	mov    %esp,%ebp
801047c3:	56                   	push   %esi
801047c4:	8b 75 10             	mov    0x10(%ebp),%esi
801047c7:	8b 45 08             	mov    0x8(%ebp),%eax
801047ca:	53                   	push   %ebx
801047cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801047ce:	85 f6                	test   %esi,%esi
801047d0:	74 2e                	je     80104800 <memcmp+0x40>
801047d2:	01 c6                	add    %eax,%esi
801047d4:	eb 14                	jmp    801047ea <memcmp+0x2a>
801047d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801047dd:	00 
801047de:	66 90                	xchg   %ax,%ax
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
801047e0:	83 c0 01             	add    $0x1,%eax
801047e3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801047e6:	39 f0                	cmp    %esi,%eax
801047e8:	74 16                	je     80104800 <memcmp+0x40>
    if(*s1 != *s2)
801047ea:	0f b6 08             	movzbl (%eax),%ecx
801047ed:	0f b6 1a             	movzbl (%edx),%ebx
801047f0:	38 d9                	cmp    %bl,%cl
801047f2:	74 ec                	je     801047e0 <memcmp+0x20>
      return *s1 - *s2;
801047f4:	0f b6 c1             	movzbl %cl,%eax
801047f7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801047f9:	5b                   	pop    %ebx
801047fa:	5e                   	pop    %esi
801047fb:	5d                   	pop    %ebp
801047fc:	c3                   	ret
801047fd:	8d 76 00             	lea    0x0(%esi),%esi
80104800:	5b                   	pop    %ebx
  return 0;
80104801:	31 c0                	xor    %eax,%eax
}
80104803:	5e                   	pop    %esi
80104804:	5d                   	pop    %ebp
80104805:	c3                   	ret
80104806:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010480d:	00 
8010480e:	66 90                	xchg   %ax,%ax

80104810 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104810:	55                   	push   %ebp
80104811:	89 e5                	mov    %esp,%ebp
80104813:	57                   	push   %edi
80104814:	8b 55 08             	mov    0x8(%ebp),%edx
80104817:	8b 45 10             	mov    0x10(%ebp),%eax
8010481a:	56                   	push   %esi
8010481b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010481e:	39 d6                	cmp    %edx,%esi
80104820:	73 26                	jae    80104848 <memmove+0x38>
80104822:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80104825:	39 ca                	cmp    %ecx,%edx
80104827:	73 1f                	jae    80104848 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104829:	85 c0                	test   %eax,%eax
8010482b:	74 0f                	je     8010483c <memmove+0x2c>
8010482d:	83 e8 01             	sub    $0x1,%eax
      *--d = *--s;
80104830:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104834:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104837:	83 e8 01             	sub    $0x1,%eax
8010483a:	73 f4                	jae    80104830 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010483c:	5e                   	pop    %esi
8010483d:	89 d0                	mov    %edx,%eax
8010483f:	5f                   	pop    %edi
80104840:	5d                   	pop    %ebp
80104841:	c3                   	ret
80104842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104848:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
8010484b:	89 d7                	mov    %edx,%edi
8010484d:	85 c0                	test   %eax,%eax
8010484f:	74 eb                	je     8010483c <memmove+0x2c>
80104851:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104858:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104859:	39 ce                	cmp    %ecx,%esi
8010485b:	75 fb                	jne    80104858 <memmove+0x48>
}
8010485d:	5e                   	pop    %esi
8010485e:	89 d0                	mov    %edx,%eax
80104860:	5f                   	pop    %edi
80104861:	5d                   	pop    %ebp
80104862:	c3                   	ret
80104863:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010486a:	00 
8010486b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104870 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104870:	eb 9e                	jmp    80104810 <memmove>
80104872:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104879:	00 
8010487a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104880 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104880:	55                   	push   %ebp
80104881:	89 e5                	mov    %esp,%ebp
80104883:	53                   	push   %ebx
80104884:	8b 55 10             	mov    0x10(%ebp),%edx
80104887:	8b 45 08             	mov    0x8(%ebp),%eax
8010488a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(n > 0 && *p && *p == *q)
8010488d:	85 d2                	test   %edx,%edx
8010488f:	75 16                	jne    801048a7 <strncmp+0x27>
80104891:	eb 2d                	jmp    801048c0 <strncmp+0x40>
80104893:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104898:	3a 19                	cmp    (%ecx),%bl
8010489a:	75 12                	jne    801048ae <strncmp+0x2e>
    n--, p++, q++;
8010489c:	83 c0 01             	add    $0x1,%eax
8010489f:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801048a2:	83 ea 01             	sub    $0x1,%edx
801048a5:	74 19                	je     801048c0 <strncmp+0x40>
801048a7:	0f b6 18             	movzbl (%eax),%ebx
801048aa:	84 db                	test   %bl,%bl
801048ac:	75 ea                	jne    80104898 <strncmp+0x18>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801048ae:	0f b6 00             	movzbl (%eax),%eax
801048b1:	0f b6 11             	movzbl (%ecx),%edx
}
801048b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801048b7:	c9                   	leave
  return (uchar)*p - (uchar)*q;
801048b8:	29 d0                	sub    %edx,%eax
}
801048ba:	c3                   	ret
801048bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801048c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
801048c3:	31 c0                	xor    %eax,%eax
}
801048c5:	c9                   	leave
801048c6:	c3                   	ret
801048c7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801048ce:	00 
801048cf:	90                   	nop

801048d0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801048d0:	55                   	push   %ebp
801048d1:	89 e5                	mov    %esp,%ebp
801048d3:	57                   	push   %edi
801048d4:	56                   	push   %esi
801048d5:	8b 75 08             	mov    0x8(%ebp),%esi
801048d8:	53                   	push   %ebx
801048d9:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801048dc:	89 f0                	mov    %esi,%eax
801048de:	eb 15                	jmp    801048f5 <strncpy+0x25>
801048e0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801048e4:	8b 7d 0c             	mov    0xc(%ebp),%edi
801048e7:	83 c0 01             	add    $0x1,%eax
801048ea:	0f b6 4f ff          	movzbl -0x1(%edi),%ecx
801048ee:	88 48 ff             	mov    %cl,-0x1(%eax)
801048f1:	84 c9                	test   %cl,%cl
801048f3:	74 13                	je     80104908 <strncpy+0x38>
801048f5:	89 d3                	mov    %edx,%ebx
801048f7:	83 ea 01             	sub    $0x1,%edx
801048fa:	85 db                	test   %ebx,%ebx
801048fc:	7f e2                	jg     801048e0 <strncpy+0x10>
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}
801048fe:	5b                   	pop    %ebx
801048ff:	89 f0                	mov    %esi,%eax
80104901:	5e                   	pop    %esi
80104902:	5f                   	pop    %edi
80104903:	5d                   	pop    %ebp
80104904:	c3                   	ret
80104905:	8d 76 00             	lea    0x0(%esi),%esi
  while(n-- > 0)
80104908:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
8010490b:	83 e9 01             	sub    $0x1,%ecx
8010490e:	85 d2                	test   %edx,%edx
80104910:	74 ec                	je     801048fe <strncpy+0x2e>
80104912:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *s++ = 0;
80104918:	83 c0 01             	add    $0x1,%eax
8010491b:	89 ca                	mov    %ecx,%edx
8010491d:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
  while(n-- > 0)
80104921:	29 c2                	sub    %eax,%edx
80104923:	85 d2                	test   %edx,%edx
80104925:	7f f1                	jg     80104918 <strncpy+0x48>
}
80104927:	5b                   	pop    %ebx
80104928:	89 f0                	mov    %esi,%eax
8010492a:	5e                   	pop    %esi
8010492b:	5f                   	pop    %edi
8010492c:	5d                   	pop    %ebp
8010492d:	c3                   	ret
8010492e:	66 90                	xchg   %ax,%ax

80104930 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104930:	55                   	push   %ebp
80104931:	89 e5                	mov    %esp,%ebp
80104933:	56                   	push   %esi
80104934:	8b 55 10             	mov    0x10(%ebp),%edx
80104937:	8b 75 08             	mov    0x8(%ebp),%esi
8010493a:	53                   	push   %ebx
8010493b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
8010493e:	85 d2                	test   %edx,%edx
80104940:	7e 25                	jle    80104967 <safestrcpy+0x37>
80104942:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104946:	89 f2                	mov    %esi,%edx
80104948:	eb 16                	jmp    80104960 <safestrcpy+0x30>
8010494a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104950:	0f b6 08             	movzbl (%eax),%ecx
80104953:	83 c0 01             	add    $0x1,%eax
80104956:	83 c2 01             	add    $0x1,%edx
80104959:	88 4a ff             	mov    %cl,-0x1(%edx)
8010495c:	84 c9                	test   %cl,%cl
8010495e:	74 04                	je     80104964 <safestrcpy+0x34>
80104960:	39 d8                	cmp    %ebx,%eax
80104962:	75 ec                	jne    80104950 <safestrcpy+0x20>
    ;
  *s = 0;
80104964:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104967:	89 f0                	mov    %esi,%eax
80104969:	5b                   	pop    %ebx
8010496a:	5e                   	pop    %esi
8010496b:	5d                   	pop    %ebp
8010496c:	c3                   	ret
8010496d:	8d 76 00             	lea    0x0(%esi),%esi

80104970 <strlen>:

int
strlen(const char *s)
{
80104970:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104971:	31 c0                	xor    %eax,%eax
{
80104973:	89 e5                	mov    %esp,%ebp
80104975:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104978:	80 3a 00             	cmpb   $0x0,(%edx)
8010497b:	74 0c                	je     80104989 <strlen+0x19>
8010497d:	8d 76 00             	lea    0x0(%esi),%esi
80104980:	83 c0 01             	add    $0x1,%eax
80104983:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104987:	75 f7                	jne    80104980 <strlen+0x10>
    ;
  return n;
}
80104989:	5d                   	pop    %ebp
8010498a:	c3                   	ret

8010498b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010498b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010498f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104993:	55                   	push   %ebp
  pushl %ebx
80104994:	53                   	push   %ebx
  pushl %esi
80104995:	56                   	push   %esi
  pushl %edi
80104996:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104997:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104999:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010499b:	5f                   	pop    %edi
  popl %esi
8010499c:	5e                   	pop    %esi
  popl %ebx
8010499d:	5b                   	pop    %ebx
  popl %ebp
8010499e:	5d                   	pop    %ebp
  ret
8010499f:	c3                   	ret

801049a0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801049a0:	55                   	push   %ebp
801049a1:	89 e5                	mov    %esp,%ebp
801049a3:	53                   	push   %ebx
801049a4:	83 ec 04             	sub    $0x4,%esp
801049a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801049aa:	e8 91 f0 ff ff       	call   80103a40 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801049af:	8b 00                	mov    (%eax),%eax
801049b1:	39 c3                	cmp    %eax,%ebx
801049b3:	73 1b                	jae    801049d0 <fetchint+0x30>
801049b5:	8d 53 04             	lea    0x4(%ebx),%edx
801049b8:	39 d0                	cmp    %edx,%eax
801049ba:	72 14                	jb     801049d0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801049bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801049bf:	8b 13                	mov    (%ebx),%edx
801049c1:	89 10                	mov    %edx,(%eax)
  return 0;
801049c3:	31 c0                	xor    %eax,%eax
}
801049c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049c8:	c9                   	leave
801049c9:	c3                   	ret
801049ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801049d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049d5:	eb ee                	jmp    801049c5 <fetchint+0x25>
801049d7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801049de:	00 
801049df:	90                   	nop

801049e0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801049e0:	55                   	push   %ebp
801049e1:	89 e5                	mov    %esp,%ebp
801049e3:	53                   	push   %ebx
801049e4:	83 ec 04             	sub    $0x4,%esp
801049e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801049ea:	e8 51 f0 ff ff       	call   80103a40 <myproc>

  if(addr >= curproc->sz)
801049ef:	3b 18                	cmp    (%eax),%ebx
801049f1:	73 2d                	jae    80104a20 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
801049f3:	8b 55 0c             	mov    0xc(%ebp),%edx
801049f6:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801049f8:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801049fa:	39 d3                	cmp    %edx,%ebx
801049fc:	73 22                	jae    80104a20 <fetchstr+0x40>
801049fe:	89 d8                	mov    %ebx,%eax
80104a00:	eb 0d                	jmp    80104a0f <fetchstr+0x2f>
80104a02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a08:	83 c0 01             	add    $0x1,%eax
80104a0b:	39 d0                	cmp    %edx,%eax
80104a0d:	73 11                	jae    80104a20 <fetchstr+0x40>
    if(*s == 0)
80104a0f:	80 38 00             	cmpb   $0x0,(%eax)
80104a12:	75 f4                	jne    80104a08 <fetchstr+0x28>
      return s - *pp;
80104a14:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104a16:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a19:	c9                   	leave
80104a1a:	c3                   	ret
80104a1b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104a20:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104a23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a28:	c9                   	leave
80104a29:	c3                   	ret
80104a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104a30 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104a30:	55                   	push   %ebp
80104a31:	89 e5                	mov    %esp,%ebp
80104a33:	56                   	push   %esi
80104a34:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a35:	e8 06 f0 ff ff       	call   80103a40 <myproc>
80104a3a:	8b 55 08             	mov    0x8(%ebp),%edx
80104a3d:	8b 40 18             	mov    0x18(%eax),%eax
80104a40:	8b 40 44             	mov    0x44(%eax),%eax
80104a43:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104a46:	e8 f5 ef ff ff       	call   80103a40 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a4b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104a4e:	8b 00                	mov    (%eax),%eax
80104a50:	39 c6                	cmp    %eax,%esi
80104a52:	73 1c                	jae    80104a70 <argint+0x40>
80104a54:	8d 53 08             	lea    0x8(%ebx),%edx
80104a57:	39 d0                	cmp    %edx,%eax
80104a59:	72 15                	jb     80104a70 <argint+0x40>
  *ip = *(int*)(addr);
80104a5b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a5e:	8b 53 04             	mov    0x4(%ebx),%edx
80104a61:	89 10                	mov    %edx,(%eax)
  return 0;
80104a63:	31 c0                	xor    %eax,%eax
}
80104a65:	5b                   	pop    %ebx
80104a66:	5e                   	pop    %esi
80104a67:	5d                   	pop    %ebp
80104a68:	c3                   	ret
80104a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104a70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a75:	eb ee                	jmp    80104a65 <argint+0x35>
80104a77:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104a7e:	00 
80104a7f:	90                   	nop

80104a80 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104a80:	55                   	push   %ebp
80104a81:	89 e5                	mov    %esp,%ebp
80104a83:	57                   	push   %edi
80104a84:	56                   	push   %esi
80104a85:	53                   	push   %ebx
80104a86:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104a89:	e8 b2 ef ff ff       	call   80103a40 <myproc>
80104a8e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104a90:	e8 ab ef ff ff       	call   80103a40 <myproc>
80104a95:	8b 55 08             	mov    0x8(%ebp),%edx
80104a98:	8b 40 18             	mov    0x18(%eax),%eax
80104a9b:	8b 40 44             	mov    0x44(%eax),%eax
80104a9e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104aa1:	e8 9a ef ff ff       	call   80103a40 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104aa6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104aa9:	8b 00                	mov    (%eax),%eax
80104aab:	39 c7                	cmp    %eax,%edi
80104aad:	73 31                	jae    80104ae0 <argptr+0x60>
80104aaf:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104ab2:	39 c8                	cmp    %ecx,%eax
80104ab4:	72 2a                	jb     80104ae0 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104ab6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104ab9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104abc:	85 d2                	test   %edx,%edx
80104abe:	78 20                	js     80104ae0 <argptr+0x60>
80104ac0:	8b 16                	mov    (%esi),%edx
80104ac2:	39 d0                	cmp    %edx,%eax
80104ac4:	73 1a                	jae    80104ae0 <argptr+0x60>
80104ac6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104ac9:	01 c3                	add    %eax,%ebx
80104acb:	39 da                	cmp    %ebx,%edx
80104acd:	72 11                	jb     80104ae0 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104acf:	8b 55 0c             	mov    0xc(%ebp),%edx
80104ad2:	89 02                	mov    %eax,(%edx)
  return 0;
80104ad4:	31 c0                	xor    %eax,%eax
}
80104ad6:	83 c4 0c             	add    $0xc,%esp
80104ad9:	5b                   	pop    %ebx
80104ada:	5e                   	pop    %esi
80104adb:	5f                   	pop    %edi
80104adc:	5d                   	pop    %ebp
80104add:	c3                   	ret
80104ade:	66 90                	xchg   %ax,%ax
    return -1;
80104ae0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ae5:	eb ef                	jmp    80104ad6 <argptr+0x56>
80104ae7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104aee:	00 
80104aef:	90                   	nop

80104af0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104af0:	55                   	push   %ebp
80104af1:	89 e5                	mov    %esp,%ebp
80104af3:	56                   	push   %esi
80104af4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104af5:	e8 46 ef ff ff       	call   80103a40 <myproc>
80104afa:	8b 55 08             	mov    0x8(%ebp),%edx
80104afd:	8b 40 18             	mov    0x18(%eax),%eax
80104b00:	8b 40 44             	mov    0x44(%eax),%eax
80104b03:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104b06:	e8 35 ef ff ff       	call   80103a40 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b0b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b0e:	8b 00                	mov    (%eax),%eax
80104b10:	39 c6                	cmp    %eax,%esi
80104b12:	73 44                	jae    80104b58 <argstr+0x68>
80104b14:	8d 53 08             	lea    0x8(%ebx),%edx
80104b17:	39 d0                	cmp    %edx,%eax
80104b19:	72 3d                	jb     80104b58 <argstr+0x68>
  *ip = *(int*)(addr);
80104b1b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104b1e:	e8 1d ef ff ff       	call   80103a40 <myproc>
  if(addr >= curproc->sz)
80104b23:	3b 18                	cmp    (%eax),%ebx
80104b25:	73 31                	jae    80104b58 <argstr+0x68>
  *pp = (char*)addr;
80104b27:	8b 55 0c             	mov    0xc(%ebp),%edx
80104b2a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104b2c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104b2e:	39 d3                	cmp    %edx,%ebx
80104b30:	73 26                	jae    80104b58 <argstr+0x68>
80104b32:	89 d8                	mov    %ebx,%eax
80104b34:	eb 11                	jmp    80104b47 <argstr+0x57>
80104b36:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b3d:	00 
80104b3e:	66 90                	xchg   %ax,%ax
80104b40:	83 c0 01             	add    $0x1,%eax
80104b43:	39 d0                	cmp    %edx,%eax
80104b45:	73 11                	jae    80104b58 <argstr+0x68>
    if(*s == 0)
80104b47:	80 38 00             	cmpb   $0x0,(%eax)
80104b4a:	75 f4                	jne    80104b40 <argstr+0x50>
      return s - *pp;
80104b4c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104b4e:	5b                   	pop    %ebx
80104b4f:	5e                   	pop    %esi
80104b50:	5d                   	pop    %ebp
80104b51:	c3                   	ret
80104b52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b58:	5b                   	pop    %ebx
    return -1;
80104b59:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b5e:	5e                   	pop    %esi
80104b5f:	5d                   	pop    %ebp
80104b60:	c3                   	ret
80104b61:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b68:	00 
80104b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104b70 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80104b70:	55                   	push   %ebp
80104b71:	89 e5                	mov    %esp,%ebp
80104b73:	53                   	push   %ebx
80104b74:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104b77:	e8 c4 ee ff ff       	call   80103a40 <myproc>
80104b7c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104b7e:	8b 40 18             	mov    0x18(%eax),%eax
80104b81:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104b84:	8d 50 ff             	lea    -0x1(%eax),%edx
80104b87:	83 fa 14             	cmp    $0x14,%edx
80104b8a:	77 24                	ja     80104bb0 <syscall+0x40>
80104b8c:	8b 14 85 80 7b 10 80 	mov    -0x7fef8480(,%eax,4),%edx
80104b93:	85 d2                	test   %edx,%edx
80104b95:	74 19                	je     80104bb0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104b97:	ff d2                	call   *%edx
80104b99:	89 c2                	mov    %eax,%edx
80104b9b:	8b 43 18             	mov    0x18(%ebx),%eax
80104b9e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104ba1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ba4:	c9                   	leave
80104ba5:	c3                   	ret
80104ba6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104bad:	00 
80104bae:	66 90                	xchg   %ax,%ax
    cprintf("%d %s: unknown sys call %d\n",
80104bb0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104bb1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104bb4:	50                   	push   %eax
80104bb5:	ff 73 10             	push   0x10(%ebx)
80104bb8:	68 fa 75 10 80       	push   $0x801075fa
80104bbd:	e8 ee ba ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80104bc2:	8b 43 18             	mov    0x18(%ebx),%eax
80104bc5:	83 c4 10             	add    $0x10,%esp
80104bc8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104bcf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bd2:	c9                   	leave
80104bd3:	c3                   	ret
80104bd4:	66 90                	xchg   %ax,%ax
80104bd6:	66 90                	xchg   %ax,%ax
80104bd8:	66 90                	xchg   %ax,%ax
80104bda:	66 90                	xchg   %ax,%ax
80104bdc:	66 90                	xchg   %ax,%ax
80104bde:	66 90                	xchg   %ax,%ax

80104be0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104be0:	55                   	push   %ebp
80104be1:	89 e5                	mov    %esp,%ebp
80104be3:	57                   	push   %edi
80104be4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104be5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104be8:	53                   	push   %ebx
80104be9:	83 ec 34             	sub    $0x34,%esp
80104bec:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104bef:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104bf2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104bf5:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104bf8:	57                   	push   %edi
80104bf9:	50                   	push   %eax
80104bfa:	e8 11 d5 ff ff       	call   80102110 <nameiparent>
80104bff:	83 c4 10             	add    $0x10,%esp
80104c02:	85 c0                	test   %eax,%eax
80104c04:	74 5e                	je     80104c64 <create+0x84>
    return 0;
  ilock(dp);
80104c06:	83 ec 0c             	sub    $0xc,%esp
80104c09:	89 c3                	mov    %eax,%ebx
80104c0b:	50                   	push   %eax
80104c0c:	e8 ff cb ff ff       	call   80101810 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104c11:	83 c4 0c             	add    $0xc,%esp
80104c14:	6a 00                	push   $0x0
80104c16:	57                   	push   %edi
80104c17:	53                   	push   %ebx
80104c18:	e8 43 d1 ff ff       	call   80101d60 <dirlookup>
80104c1d:	83 c4 10             	add    $0x10,%esp
80104c20:	89 c6                	mov    %eax,%esi
80104c22:	85 c0                	test   %eax,%eax
80104c24:	74 4a                	je     80104c70 <create+0x90>
    iunlockput(dp);
80104c26:	83 ec 0c             	sub    $0xc,%esp
80104c29:	53                   	push   %ebx
80104c2a:	e8 71 ce ff ff       	call   80101aa0 <iunlockput>
    ilock(ip);
80104c2f:	89 34 24             	mov    %esi,(%esp)
80104c32:	e8 d9 cb ff ff       	call   80101810 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104c37:	83 c4 10             	add    $0x10,%esp
80104c3a:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104c3f:	75 17                	jne    80104c58 <create+0x78>
80104c41:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104c46:	75 10                	jne    80104c58 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104c48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104c4b:	89 f0                	mov    %esi,%eax
80104c4d:	5b                   	pop    %ebx
80104c4e:	5e                   	pop    %esi
80104c4f:	5f                   	pop    %edi
80104c50:	5d                   	pop    %ebp
80104c51:	c3                   	ret
80104c52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80104c58:	83 ec 0c             	sub    $0xc,%esp
80104c5b:	56                   	push   %esi
80104c5c:	e8 3f ce ff ff       	call   80101aa0 <iunlockput>
    return 0;
80104c61:	83 c4 10             	add    $0x10,%esp
}
80104c64:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104c67:	31 f6                	xor    %esi,%esi
}
80104c69:	5b                   	pop    %ebx
80104c6a:	89 f0                	mov    %esi,%eax
80104c6c:	5e                   	pop    %esi
80104c6d:	5f                   	pop    %edi
80104c6e:	5d                   	pop    %ebp
80104c6f:	c3                   	ret
  if((ip = ialloc(dp->dev, type)) == 0)
80104c70:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104c74:	83 ec 08             	sub    $0x8,%esp
80104c77:	50                   	push   %eax
80104c78:	ff 33                	push   (%ebx)
80104c7a:	e8 21 ca ff ff       	call   801016a0 <ialloc>
80104c7f:	83 c4 10             	add    $0x10,%esp
80104c82:	89 c6                	mov    %eax,%esi
80104c84:	85 c0                	test   %eax,%eax
80104c86:	0f 84 bc 00 00 00    	je     80104d48 <create+0x168>
  ilock(ip);
80104c8c:	83 ec 0c             	sub    $0xc,%esp
80104c8f:	50                   	push   %eax
80104c90:	e8 7b cb ff ff       	call   80101810 <ilock>
  ip->major = major;
80104c95:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104c99:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104c9d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104ca1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104ca5:	b8 01 00 00 00       	mov    $0x1,%eax
80104caa:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104cae:	89 34 24             	mov    %esi,(%esp)
80104cb1:	e8 aa ca ff ff       	call   80101760 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104cb6:	83 c4 10             	add    $0x10,%esp
80104cb9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104cbe:	74 30                	je     80104cf0 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
80104cc0:	83 ec 04             	sub    $0x4,%esp
80104cc3:	ff 76 04             	push   0x4(%esi)
80104cc6:	57                   	push   %edi
80104cc7:	53                   	push   %ebx
80104cc8:	e8 63 d3 ff ff       	call   80102030 <dirlink>
80104ccd:	83 c4 10             	add    $0x10,%esp
80104cd0:	85 c0                	test   %eax,%eax
80104cd2:	78 67                	js     80104d3b <create+0x15b>
  iunlockput(dp);
80104cd4:	83 ec 0c             	sub    $0xc,%esp
80104cd7:	53                   	push   %ebx
80104cd8:	e8 c3 cd ff ff       	call   80101aa0 <iunlockput>
  return ip;
80104cdd:	83 c4 10             	add    $0x10,%esp
}
80104ce0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ce3:	89 f0                	mov    %esi,%eax
80104ce5:	5b                   	pop    %ebx
80104ce6:	5e                   	pop    %esi
80104ce7:	5f                   	pop    %edi
80104ce8:	5d                   	pop    %ebp
80104ce9:	c3                   	ret
80104cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104cf0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104cf3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104cf8:	53                   	push   %ebx
80104cf9:	e8 62 ca ff ff       	call   80101760 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104cfe:	83 c4 0c             	add    $0xc,%esp
80104d01:	ff 76 04             	push   0x4(%esi)
80104d04:	68 32 76 10 80       	push   $0x80107632
80104d09:	56                   	push   %esi
80104d0a:	e8 21 d3 ff ff       	call   80102030 <dirlink>
80104d0f:	83 c4 10             	add    $0x10,%esp
80104d12:	85 c0                	test   %eax,%eax
80104d14:	78 18                	js     80104d2e <create+0x14e>
80104d16:	83 ec 04             	sub    $0x4,%esp
80104d19:	ff 73 04             	push   0x4(%ebx)
80104d1c:	68 31 76 10 80       	push   $0x80107631
80104d21:	56                   	push   %esi
80104d22:	e8 09 d3 ff ff       	call   80102030 <dirlink>
80104d27:	83 c4 10             	add    $0x10,%esp
80104d2a:	85 c0                	test   %eax,%eax
80104d2c:	79 92                	jns    80104cc0 <create+0xe0>
      panic("create dots");
80104d2e:	83 ec 0c             	sub    $0xc,%esp
80104d31:	68 25 76 10 80       	push   $0x80107625
80104d36:	e8 45 b6 ff ff       	call   80100380 <panic>
    panic("create: dirlink");
80104d3b:	83 ec 0c             	sub    $0xc,%esp
80104d3e:	68 34 76 10 80       	push   $0x80107634
80104d43:	e8 38 b6 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104d48:	83 ec 0c             	sub    $0xc,%esp
80104d4b:	68 16 76 10 80       	push   $0x80107616
80104d50:	e8 2b b6 ff ff       	call   80100380 <panic>
80104d55:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104d5c:	00 
80104d5d:	8d 76 00             	lea    0x0(%esi),%esi

80104d60 <sys_dup>:
{
80104d60:	55                   	push   %ebp
80104d61:	89 e5                	mov    %esp,%ebp
80104d63:	56                   	push   %esi
80104d64:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104d65:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104d68:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104d6b:	50                   	push   %eax
80104d6c:	6a 00                	push   $0x0
80104d6e:	e8 bd fc ff ff       	call   80104a30 <argint>
80104d73:	83 c4 10             	add    $0x10,%esp
80104d76:	85 c0                	test   %eax,%eax
80104d78:	78 36                	js     80104db0 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104d7a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104d7e:	77 30                	ja     80104db0 <sys_dup+0x50>
80104d80:	e8 bb ec ff ff       	call   80103a40 <myproc>
80104d85:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d88:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104d8c:	85 f6                	test   %esi,%esi
80104d8e:	74 20                	je     80104db0 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104d90:	e8 ab ec ff ff       	call   80103a40 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104d95:	31 db                	xor    %ebx,%ebx
80104d97:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104d9e:	00 
80104d9f:	90                   	nop
    if(curproc->ofile[fd] == 0){
80104da0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104da4:	85 d2                	test   %edx,%edx
80104da6:	74 18                	je     80104dc0 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104da8:	83 c3 01             	add    $0x1,%ebx
80104dab:	83 fb 10             	cmp    $0x10,%ebx
80104dae:	75 f0                	jne    80104da0 <sys_dup+0x40>
}
80104db0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104db3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104db8:	89 d8                	mov    %ebx,%eax
80104dba:	5b                   	pop    %ebx
80104dbb:	5e                   	pop    %esi
80104dbc:	5d                   	pop    %ebp
80104dbd:	c3                   	ret
80104dbe:	66 90                	xchg   %ax,%ax
  filedup(f);
80104dc0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104dc3:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104dc7:	56                   	push   %esi
80104dc8:	e8 63 c1 ff ff       	call   80100f30 <filedup>
  return fd;
80104dcd:	83 c4 10             	add    $0x10,%esp
}
80104dd0:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104dd3:	89 d8                	mov    %ebx,%eax
80104dd5:	5b                   	pop    %ebx
80104dd6:	5e                   	pop    %esi
80104dd7:	5d                   	pop    %ebp
80104dd8:	c3                   	ret
80104dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104de0 <sys_read>:
{
80104de0:	55                   	push   %ebp
80104de1:	89 e5                	mov    %esp,%ebp
80104de3:	56                   	push   %esi
80104de4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104de5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104de8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104deb:	53                   	push   %ebx
80104dec:	6a 00                	push   $0x0
80104dee:	e8 3d fc ff ff       	call   80104a30 <argint>
80104df3:	83 c4 10             	add    $0x10,%esp
80104df6:	85 c0                	test   %eax,%eax
80104df8:	78 5e                	js     80104e58 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104dfa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104dfe:	77 58                	ja     80104e58 <sys_read+0x78>
80104e00:	e8 3b ec ff ff       	call   80103a40 <myproc>
80104e05:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e08:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104e0c:	85 f6                	test   %esi,%esi
80104e0e:	74 48                	je     80104e58 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e10:	83 ec 08             	sub    $0x8,%esp
80104e13:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e16:	50                   	push   %eax
80104e17:	6a 02                	push   $0x2
80104e19:	e8 12 fc ff ff       	call   80104a30 <argint>
80104e1e:	83 c4 10             	add    $0x10,%esp
80104e21:	85 c0                	test   %eax,%eax
80104e23:	78 33                	js     80104e58 <sys_read+0x78>
80104e25:	83 ec 04             	sub    $0x4,%esp
80104e28:	ff 75 f0             	push   -0x10(%ebp)
80104e2b:	53                   	push   %ebx
80104e2c:	6a 01                	push   $0x1
80104e2e:	e8 4d fc ff ff       	call   80104a80 <argptr>
80104e33:	83 c4 10             	add    $0x10,%esp
80104e36:	85 c0                	test   %eax,%eax
80104e38:	78 1e                	js     80104e58 <sys_read+0x78>
  return fileread(f, p, n);
80104e3a:	83 ec 04             	sub    $0x4,%esp
80104e3d:	ff 75 f0             	push   -0x10(%ebp)
80104e40:	ff 75 f4             	push   -0xc(%ebp)
80104e43:	56                   	push   %esi
80104e44:	e8 67 c2 ff ff       	call   801010b0 <fileread>
80104e49:	83 c4 10             	add    $0x10,%esp
}
80104e4c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e4f:	5b                   	pop    %ebx
80104e50:	5e                   	pop    %esi
80104e51:	5d                   	pop    %ebp
80104e52:	c3                   	ret
80104e53:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80104e58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e5d:	eb ed                	jmp    80104e4c <sys_read+0x6c>
80104e5f:	90                   	nop

80104e60 <sys_write>:
{
80104e60:	55                   	push   %ebp
80104e61:	89 e5                	mov    %esp,%ebp
80104e63:	56                   	push   %esi
80104e64:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104e65:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104e68:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e6b:	53                   	push   %ebx
80104e6c:	6a 00                	push   $0x0
80104e6e:	e8 bd fb ff ff       	call   80104a30 <argint>
80104e73:	83 c4 10             	add    $0x10,%esp
80104e76:	85 c0                	test   %eax,%eax
80104e78:	78 5e                	js     80104ed8 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e7a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e7e:	77 58                	ja     80104ed8 <sys_write+0x78>
80104e80:	e8 bb eb ff ff       	call   80103a40 <myproc>
80104e85:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e88:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104e8c:	85 f6                	test   %esi,%esi
80104e8e:	74 48                	je     80104ed8 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e90:	83 ec 08             	sub    $0x8,%esp
80104e93:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e96:	50                   	push   %eax
80104e97:	6a 02                	push   $0x2
80104e99:	e8 92 fb ff ff       	call   80104a30 <argint>
80104e9e:	83 c4 10             	add    $0x10,%esp
80104ea1:	85 c0                	test   %eax,%eax
80104ea3:	78 33                	js     80104ed8 <sys_write+0x78>
80104ea5:	83 ec 04             	sub    $0x4,%esp
80104ea8:	ff 75 f0             	push   -0x10(%ebp)
80104eab:	53                   	push   %ebx
80104eac:	6a 01                	push   $0x1
80104eae:	e8 cd fb ff ff       	call   80104a80 <argptr>
80104eb3:	83 c4 10             	add    $0x10,%esp
80104eb6:	85 c0                	test   %eax,%eax
80104eb8:	78 1e                	js     80104ed8 <sys_write+0x78>
  return filewrite(f, p, n);
80104eba:	83 ec 04             	sub    $0x4,%esp
80104ebd:	ff 75 f0             	push   -0x10(%ebp)
80104ec0:	ff 75 f4             	push   -0xc(%ebp)
80104ec3:	56                   	push   %esi
80104ec4:	e8 77 c2 ff ff       	call   80101140 <filewrite>
80104ec9:	83 c4 10             	add    $0x10,%esp
}
80104ecc:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ecf:	5b                   	pop    %ebx
80104ed0:	5e                   	pop    %esi
80104ed1:	5d                   	pop    %ebp
80104ed2:	c3                   	ret
80104ed3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80104ed8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104edd:	eb ed                	jmp    80104ecc <sys_write+0x6c>
80104edf:	90                   	nop

80104ee0 <sys_close>:
{
80104ee0:	55                   	push   %ebp
80104ee1:	89 e5                	mov    %esp,%ebp
80104ee3:	56                   	push   %esi
80104ee4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104ee5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104ee8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104eeb:	50                   	push   %eax
80104eec:	6a 00                	push   $0x0
80104eee:	e8 3d fb ff ff       	call   80104a30 <argint>
80104ef3:	83 c4 10             	add    $0x10,%esp
80104ef6:	85 c0                	test   %eax,%eax
80104ef8:	78 3e                	js     80104f38 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104efa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104efe:	77 38                	ja     80104f38 <sys_close+0x58>
80104f00:	e8 3b eb ff ff       	call   80103a40 <myproc>
80104f05:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f08:	8d 5a 08             	lea    0x8(%edx),%ebx
80104f0b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
80104f0f:	85 f6                	test   %esi,%esi
80104f11:	74 25                	je     80104f38 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80104f13:	e8 28 eb ff ff       	call   80103a40 <myproc>
  fileclose(f);
80104f18:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104f1b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80104f22:	00 
  fileclose(f);
80104f23:	56                   	push   %esi
80104f24:	e8 57 c0 ff ff       	call   80100f80 <fileclose>
  return 0;
80104f29:	83 c4 10             	add    $0x10,%esp
80104f2c:	31 c0                	xor    %eax,%eax
}
80104f2e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f31:	5b                   	pop    %ebx
80104f32:	5e                   	pop    %esi
80104f33:	5d                   	pop    %ebp
80104f34:	c3                   	ret
80104f35:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104f38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f3d:	eb ef                	jmp    80104f2e <sys_close+0x4e>
80104f3f:	90                   	nop

80104f40 <sys_fstat>:
{
80104f40:	55                   	push   %ebp
80104f41:	89 e5                	mov    %esp,%ebp
80104f43:	56                   	push   %esi
80104f44:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f45:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104f48:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f4b:	53                   	push   %ebx
80104f4c:	6a 00                	push   $0x0
80104f4e:	e8 dd fa ff ff       	call   80104a30 <argint>
80104f53:	83 c4 10             	add    $0x10,%esp
80104f56:	85 c0                	test   %eax,%eax
80104f58:	78 46                	js     80104fa0 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f5a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f5e:	77 40                	ja     80104fa0 <sys_fstat+0x60>
80104f60:	e8 db ea ff ff       	call   80103a40 <myproc>
80104f65:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f68:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104f6c:	85 f6                	test   %esi,%esi
80104f6e:	74 30                	je     80104fa0 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104f70:	83 ec 04             	sub    $0x4,%esp
80104f73:	6a 14                	push   $0x14
80104f75:	53                   	push   %ebx
80104f76:	6a 01                	push   $0x1
80104f78:	e8 03 fb ff ff       	call   80104a80 <argptr>
80104f7d:	83 c4 10             	add    $0x10,%esp
80104f80:	85 c0                	test   %eax,%eax
80104f82:	78 1c                	js     80104fa0 <sys_fstat+0x60>
  return filestat(f, st);
80104f84:	83 ec 08             	sub    $0x8,%esp
80104f87:	ff 75 f4             	push   -0xc(%ebp)
80104f8a:	56                   	push   %esi
80104f8b:	e8 d0 c0 ff ff       	call   80101060 <filestat>
80104f90:	83 c4 10             	add    $0x10,%esp
}
80104f93:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f96:	5b                   	pop    %ebx
80104f97:	5e                   	pop    %esi
80104f98:	5d                   	pop    %ebp
80104f99:	c3                   	ret
80104f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104fa0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fa5:	eb ec                	jmp    80104f93 <sys_fstat+0x53>
80104fa7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104fae:	00 
80104faf:	90                   	nop

80104fb0 <sys_link>:
{
80104fb0:	55                   	push   %ebp
80104fb1:	89 e5                	mov    %esp,%ebp
80104fb3:	57                   	push   %edi
80104fb4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104fb5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104fb8:	53                   	push   %ebx
80104fb9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104fbc:	50                   	push   %eax
80104fbd:	6a 00                	push   $0x0
80104fbf:	e8 2c fb ff ff       	call   80104af0 <argstr>
80104fc4:	83 c4 10             	add    $0x10,%esp
80104fc7:	85 c0                	test   %eax,%eax
80104fc9:	0f 88 fb 00 00 00    	js     801050ca <sys_link+0x11a>
80104fcf:	83 ec 08             	sub    $0x8,%esp
80104fd2:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104fd5:	50                   	push   %eax
80104fd6:	6a 01                	push   $0x1
80104fd8:	e8 13 fb ff ff       	call   80104af0 <argstr>
80104fdd:	83 c4 10             	add    $0x10,%esp
80104fe0:	85 c0                	test   %eax,%eax
80104fe2:	0f 88 e2 00 00 00    	js     801050ca <sys_link+0x11a>
  begin_op();
80104fe8:	e8 c3 dd ff ff       	call   80102db0 <begin_op>
  if((ip = namei(old)) == 0){
80104fed:	83 ec 0c             	sub    $0xc,%esp
80104ff0:	ff 75 d4             	push   -0x2c(%ebp)
80104ff3:	e8 f8 d0 ff ff       	call   801020f0 <namei>
80104ff8:	83 c4 10             	add    $0x10,%esp
80104ffb:	89 c3                	mov    %eax,%ebx
80104ffd:	85 c0                	test   %eax,%eax
80104fff:	0f 84 df 00 00 00    	je     801050e4 <sys_link+0x134>
  ilock(ip);
80105005:	83 ec 0c             	sub    $0xc,%esp
80105008:	50                   	push   %eax
80105009:	e8 02 c8 ff ff       	call   80101810 <ilock>
  if(ip->type == T_DIR){
8010500e:	83 c4 10             	add    $0x10,%esp
80105011:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105016:	0f 84 b5 00 00 00    	je     801050d1 <sys_link+0x121>
  iupdate(ip);
8010501c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010501f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105024:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105027:	53                   	push   %ebx
80105028:	e8 33 c7 ff ff       	call   80101760 <iupdate>
  iunlock(ip);
8010502d:	89 1c 24             	mov    %ebx,(%esp)
80105030:	e8 bb c8 ff ff       	call   801018f0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105035:	58                   	pop    %eax
80105036:	5a                   	pop    %edx
80105037:	57                   	push   %edi
80105038:	ff 75 d0             	push   -0x30(%ebp)
8010503b:	e8 d0 d0 ff ff       	call   80102110 <nameiparent>
80105040:	83 c4 10             	add    $0x10,%esp
80105043:	89 c6                	mov    %eax,%esi
80105045:	85 c0                	test   %eax,%eax
80105047:	74 5b                	je     801050a4 <sys_link+0xf4>
  ilock(dp);
80105049:	83 ec 0c             	sub    $0xc,%esp
8010504c:	50                   	push   %eax
8010504d:	e8 be c7 ff ff       	call   80101810 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105052:	8b 03                	mov    (%ebx),%eax
80105054:	83 c4 10             	add    $0x10,%esp
80105057:	39 06                	cmp    %eax,(%esi)
80105059:	75 3d                	jne    80105098 <sys_link+0xe8>
8010505b:	83 ec 04             	sub    $0x4,%esp
8010505e:	ff 73 04             	push   0x4(%ebx)
80105061:	57                   	push   %edi
80105062:	56                   	push   %esi
80105063:	e8 c8 cf ff ff       	call   80102030 <dirlink>
80105068:	83 c4 10             	add    $0x10,%esp
8010506b:	85 c0                	test   %eax,%eax
8010506d:	78 29                	js     80105098 <sys_link+0xe8>
  iunlockput(dp);
8010506f:	83 ec 0c             	sub    $0xc,%esp
80105072:	56                   	push   %esi
80105073:	e8 28 ca ff ff       	call   80101aa0 <iunlockput>
  iput(ip);
80105078:	89 1c 24             	mov    %ebx,(%esp)
8010507b:	e8 c0 c8 ff ff       	call   80101940 <iput>
  end_op();
80105080:	e8 9b dd ff ff       	call   80102e20 <end_op>
  return 0;
80105085:	83 c4 10             	add    $0x10,%esp
80105088:	31 c0                	xor    %eax,%eax
}
8010508a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010508d:	5b                   	pop    %ebx
8010508e:	5e                   	pop    %esi
8010508f:	5f                   	pop    %edi
80105090:	5d                   	pop    %ebp
80105091:	c3                   	ret
80105092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105098:	83 ec 0c             	sub    $0xc,%esp
8010509b:	56                   	push   %esi
8010509c:	e8 ff c9 ff ff       	call   80101aa0 <iunlockput>
    goto bad;
801050a1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801050a4:	83 ec 0c             	sub    $0xc,%esp
801050a7:	53                   	push   %ebx
801050a8:	e8 63 c7 ff ff       	call   80101810 <ilock>
  ip->nlink--;
801050ad:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801050b2:	89 1c 24             	mov    %ebx,(%esp)
801050b5:	e8 a6 c6 ff ff       	call   80101760 <iupdate>
  iunlockput(ip);
801050ba:	89 1c 24             	mov    %ebx,(%esp)
801050bd:	e8 de c9 ff ff       	call   80101aa0 <iunlockput>
  end_op();
801050c2:	e8 59 dd ff ff       	call   80102e20 <end_op>
  return -1;
801050c7:	83 c4 10             	add    $0x10,%esp
    return -1;
801050ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050cf:	eb b9                	jmp    8010508a <sys_link+0xda>
    iunlockput(ip);
801050d1:	83 ec 0c             	sub    $0xc,%esp
801050d4:	53                   	push   %ebx
801050d5:	e8 c6 c9 ff ff       	call   80101aa0 <iunlockput>
    end_op();
801050da:	e8 41 dd ff ff       	call   80102e20 <end_op>
    return -1;
801050df:	83 c4 10             	add    $0x10,%esp
801050e2:	eb e6                	jmp    801050ca <sys_link+0x11a>
    end_op();
801050e4:	e8 37 dd ff ff       	call   80102e20 <end_op>
    return -1;
801050e9:	eb df                	jmp    801050ca <sys_link+0x11a>
801050eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801050f0 <sys_unlink>:
{
801050f0:	55                   	push   %ebp
801050f1:	89 e5                	mov    %esp,%ebp
801050f3:	57                   	push   %edi
801050f4:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801050f5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801050f8:	53                   	push   %ebx
801050f9:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801050fc:	50                   	push   %eax
801050fd:	6a 00                	push   $0x0
801050ff:	e8 ec f9 ff ff       	call   80104af0 <argstr>
80105104:	83 c4 10             	add    $0x10,%esp
80105107:	85 c0                	test   %eax,%eax
80105109:	0f 88 54 01 00 00    	js     80105263 <sys_unlink+0x173>
  begin_op();
8010510f:	e8 9c dc ff ff       	call   80102db0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105114:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105117:	83 ec 08             	sub    $0x8,%esp
8010511a:	53                   	push   %ebx
8010511b:	ff 75 c0             	push   -0x40(%ebp)
8010511e:	e8 ed cf ff ff       	call   80102110 <nameiparent>
80105123:	83 c4 10             	add    $0x10,%esp
80105126:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105129:	85 c0                	test   %eax,%eax
8010512b:	0f 84 58 01 00 00    	je     80105289 <sys_unlink+0x199>
  ilock(dp);
80105131:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105134:	83 ec 0c             	sub    $0xc,%esp
80105137:	57                   	push   %edi
80105138:	e8 d3 c6 ff ff       	call   80101810 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010513d:	58                   	pop    %eax
8010513e:	5a                   	pop    %edx
8010513f:	68 32 76 10 80       	push   $0x80107632
80105144:	53                   	push   %ebx
80105145:	e8 f6 cb ff ff       	call   80101d40 <namecmp>
8010514a:	83 c4 10             	add    $0x10,%esp
8010514d:	85 c0                	test   %eax,%eax
8010514f:	0f 84 fb 00 00 00    	je     80105250 <sys_unlink+0x160>
80105155:	83 ec 08             	sub    $0x8,%esp
80105158:	68 31 76 10 80       	push   $0x80107631
8010515d:	53                   	push   %ebx
8010515e:	e8 dd cb ff ff       	call   80101d40 <namecmp>
80105163:	83 c4 10             	add    $0x10,%esp
80105166:	85 c0                	test   %eax,%eax
80105168:	0f 84 e2 00 00 00    	je     80105250 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010516e:	83 ec 04             	sub    $0x4,%esp
80105171:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105174:	50                   	push   %eax
80105175:	53                   	push   %ebx
80105176:	57                   	push   %edi
80105177:	e8 e4 cb ff ff       	call   80101d60 <dirlookup>
8010517c:	83 c4 10             	add    $0x10,%esp
8010517f:	89 c3                	mov    %eax,%ebx
80105181:	85 c0                	test   %eax,%eax
80105183:	0f 84 c7 00 00 00    	je     80105250 <sys_unlink+0x160>
  ilock(ip);
80105189:	83 ec 0c             	sub    $0xc,%esp
8010518c:	50                   	push   %eax
8010518d:	e8 7e c6 ff ff       	call   80101810 <ilock>
  if(ip->nlink < 1)
80105192:	83 c4 10             	add    $0x10,%esp
80105195:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010519a:	0f 8e 0a 01 00 00    	jle    801052aa <sys_unlink+0x1ba>
  if(ip->type == T_DIR && !isdirempty(ip)){
801051a0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801051a5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801051a8:	74 66                	je     80105210 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801051aa:	83 ec 04             	sub    $0x4,%esp
801051ad:	6a 10                	push   $0x10
801051af:	6a 00                	push   $0x0
801051b1:	57                   	push   %edi
801051b2:	e8 c9 f5 ff ff       	call   80104780 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801051b7:	6a 10                	push   $0x10
801051b9:	ff 75 c4             	push   -0x3c(%ebp)
801051bc:	57                   	push   %edi
801051bd:	ff 75 b4             	push   -0x4c(%ebp)
801051c0:	e8 5b ca ff ff       	call   80101c20 <writei>
801051c5:	83 c4 20             	add    $0x20,%esp
801051c8:	83 f8 10             	cmp    $0x10,%eax
801051cb:	0f 85 cc 00 00 00    	jne    8010529d <sys_unlink+0x1ad>
  if(ip->type == T_DIR){
801051d1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801051d6:	0f 84 94 00 00 00    	je     80105270 <sys_unlink+0x180>
  iunlockput(dp);
801051dc:	83 ec 0c             	sub    $0xc,%esp
801051df:	ff 75 b4             	push   -0x4c(%ebp)
801051e2:	e8 b9 c8 ff ff       	call   80101aa0 <iunlockput>
  ip->nlink--;
801051e7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801051ec:	89 1c 24             	mov    %ebx,(%esp)
801051ef:	e8 6c c5 ff ff       	call   80101760 <iupdate>
  iunlockput(ip);
801051f4:	89 1c 24             	mov    %ebx,(%esp)
801051f7:	e8 a4 c8 ff ff       	call   80101aa0 <iunlockput>
  end_op();
801051fc:	e8 1f dc ff ff       	call   80102e20 <end_op>
  return 0;
80105201:	83 c4 10             	add    $0x10,%esp
80105204:	31 c0                	xor    %eax,%eax
}
80105206:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105209:	5b                   	pop    %ebx
8010520a:	5e                   	pop    %esi
8010520b:	5f                   	pop    %edi
8010520c:	5d                   	pop    %ebp
8010520d:	c3                   	ret
8010520e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105210:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105214:	76 94                	jbe    801051aa <sys_unlink+0xba>
80105216:	be 20 00 00 00       	mov    $0x20,%esi
8010521b:	eb 0b                	jmp    80105228 <sys_unlink+0x138>
8010521d:	8d 76 00             	lea    0x0(%esi),%esi
80105220:	83 c6 10             	add    $0x10,%esi
80105223:	3b 73 58             	cmp    0x58(%ebx),%esi
80105226:	73 82                	jae    801051aa <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105228:	6a 10                	push   $0x10
8010522a:	56                   	push   %esi
8010522b:	57                   	push   %edi
8010522c:	53                   	push   %ebx
8010522d:	e8 ee c8 ff ff       	call   80101b20 <readi>
80105232:	83 c4 10             	add    $0x10,%esp
80105235:	83 f8 10             	cmp    $0x10,%eax
80105238:	75 56                	jne    80105290 <sys_unlink+0x1a0>
    if(de.inum != 0)
8010523a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010523f:	74 df                	je     80105220 <sys_unlink+0x130>
    iunlockput(ip);
80105241:	83 ec 0c             	sub    $0xc,%esp
80105244:	53                   	push   %ebx
80105245:	e8 56 c8 ff ff       	call   80101aa0 <iunlockput>
    goto bad;
8010524a:	83 c4 10             	add    $0x10,%esp
8010524d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105250:	83 ec 0c             	sub    $0xc,%esp
80105253:	ff 75 b4             	push   -0x4c(%ebp)
80105256:	e8 45 c8 ff ff       	call   80101aa0 <iunlockput>
  end_op();
8010525b:	e8 c0 db ff ff       	call   80102e20 <end_op>
  return -1;
80105260:	83 c4 10             	add    $0x10,%esp
    return -1;
80105263:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105268:	eb 9c                	jmp    80105206 <sys_unlink+0x116>
8010526a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105270:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105273:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105276:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010527b:	50                   	push   %eax
8010527c:	e8 df c4 ff ff       	call   80101760 <iupdate>
80105281:	83 c4 10             	add    $0x10,%esp
80105284:	e9 53 ff ff ff       	jmp    801051dc <sys_unlink+0xec>
    end_op();
80105289:	e8 92 db ff ff       	call   80102e20 <end_op>
    return -1;
8010528e:	eb d3                	jmp    80105263 <sys_unlink+0x173>
      panic("isdirempty: readi");
80105290:	83 ec 0c             	sub    $0xc,%esp
80105293:	68 56 76 10 80       	push   $0x80107656
80105298:	e8 e3 b0 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010529d:	83 ec 0c             	sub    $0xc,%esp
801052a0:	68 68 76 10 80       	push   $0x80107668
801052a5:	e8 d6 b0 ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
801052aa:	83 ec 0c             	sub    $0xc,%esp
801052ad:	68 44 76 10 80       	push   $0x80107644
801052b2:	e8 c9 b0 ff ff       	call   80100380 <panic>
801052b7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801052be:	00 
801052bf:	90                   	nop

801052c0 <sys_open>:

int
sys_open(void)
{
801052c0:	55                   	push   %ebp
801052c1:	89 e5                	mov    %esp,%ebp
801052c3:	57                   	push   %edi
801052c4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801052c5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801052c8:	53                   	push   %ebx
801052c9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801052cc:	50                   	push   %eax
801052cd:	6a 00                	push   $0x0
801052cf:	e8 1c f8 ff ff       	call   80104af0 <argstr>
801052d4:	83 c4 10             	add    $0x10,%esp
801052d7:	85 c0                	test   %eax,%eax
801052d9:	0f 88 8e 00 00 00    	js     8010536d <sys_open+0xad>
801052df:	83 ec 08             	sub    $0x8,%esp
801052e2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801052e5:	50                   	push   %eax
801052e6:	6a 01                	push   $0x1
801052e8:	e8 43 f7 ff ff       	call   80104a30 <argint>
801052ed:	83 c4 10             	add    $0x10,%esp
801052f0:	85 c0                	test   %eax,%eax
801052f2:	78 79                	js     8010536d <sys_open+0xad>
    return -1;

  begin_op();
801052f4:	e8 b7 da ff ff       	call   80102db0 <begin_op>

  if(omode & O_CREATE){
801052f9:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801052fd:	75 79                	jne    80105378 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801052ff:	83 ec 0c             	sub    $0xc,%esp
80105302:	ff 75 e0             	push   -0x20(%ebp)
80105305:	e8 e6 cd ff ff       	call   801020f0 <namei>
8010530a:	83 c4 10             	add    $0x10,%esp
8010530d:	89 c6                	mov    %eax,%esi
8010530f:	85 c0                	test   %eax,%eax
80105311:	0f 84 7e 00 00 00    	je     80105395 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105317:	83 ec 0c             	sub    $0xc,%esp
8010531a:	50                   	push   %eax
8010531b:	e8 f0 c4 ff ff       	call   80101810 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105320:	83 c4 10             	add    $0x10,%esp
80105323:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105328:	0f 84 ba 00 00 00    	je     801053e8 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010532e:	e8 8d bb ff ff       	call   80100ec0 <filealloc>
80105333:	89 c7                	mov    %eax,%edi
80105335:	85 c0                	test   %eax,%eax
80105337:	74 23                	je     8010535c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105339:	e8 02 e7 ff ff       	call   80103a40 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010533e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105340:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105344:	85 d2                	test   %edx,%edx
80105346:	74 58                	je     801053a0 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
80105348:	83 c3 01             	add    $0x1,%ebx
8010534b:	83 fb 10             	cmp    $0x10,%ebx
8010534e:	75 f0                	jne    80105340 <sys_open+0x80>
    if(f)
      fileclose(f);
80105350:	83 ec 0c             	sub    $0xc,%esp
80105353:	57                   	push   %edi
80105354:	e8 27 bc ff ff       	call   80100f80 <fileclose>
80105359:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010535c:	83 ec 0c             	sub    $0xc,%esp
8010535f:	56                   	push   %esi
80105360:	e8 3b c7 ff ff       	call   80101aa0 <iunlockput>
    end_op();
80105365:	e8 b6 da ff ff       	call   80102e20 <end_op>
    return -1;
8010536a:	83 c4 10             	add    $0x10,%esp
    return -1;
8010536d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105372:	eb 65                	jmp    801053d9 <sys_open+0x119>
80105374:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105378:	83 ec 0c             	sub    $0xc,%esp
8010537b:	31 c9                	xor    %ecx,%ecx
8010537d:	ba 02 00 00 00       	mov    $0x2,%edx
80105382:	6a 00                	push   $0x0
80105384:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105387:	e8 54 f8 ff ff       	call   80104be0 <create>
    if(ip == 0){
8010538c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010538f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105391:	85 c0                	test   %eax,%eax
80105393:	75 99                	jne    8010532e <sys_open+0x6e>
      end_op();
80105395:	e8 86 da ff ff       	call   80102e20 <end_op>
      return -1;
8010539a:	eb d1                	jmp    8010536d <sys_open+0xad>
8010539c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801053a0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801053a3:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801053a7:	56                   	push   %esi
801053a8:	e8 43 c5 ff ff       	call   801018f0 <iunlock>
  end_op();
801053ad:	e8 6e da ff ff       	call   80102e20 <end_op>

  f->type = FD_INODE;
801053b2:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801053b8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801053bb:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801053be:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801053c1:	89 d0                	mov    %edx,%eax
  f->off = 0;
801053c3:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801053ca:	f7 d0                	not    %eax
801053cc:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801053cf:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801053d2:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801053d5:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801053d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053dc:	89 d8                	mov    %ebx,%eax
801053de:	5b                   	pop    %ebx
801053df:	5e                   	pop    %esi
801053e0:	5f                   	pop    %edi
801053e1:	5d                   	pop    %ebp
801053e2:	c3                   	ret
801053e3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
801053e8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801053eb:	85 c9                	test   %ecx,%ecx
801053ed:	0f 84 3b ff ff ff    	je     8010532e <sys_open+0x6e>
801053f3:	e9 64 ff ff ff       	jmp    8010535c <sys_open+0x9c>
801053f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801053ff:	00 

80105400 <sys_mkdir>:

int
sys_mkdir(void)
{
80105400:	55                   	push   %ebp
80105401:	89 e5                	mov    %esp,%ebp
80105403:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105406:	e8 a5 d9 ff ff       	call   80102db0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010540b:	83 ec 08             	sub    $0x8,%esp
8010540e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105411:	50                   	push   %eax
80105412:	6a 00                	push   $0x0
80105414:	e8 d7 f6 ff ff       	call   80104af0 <argstr>
80105419:	83 c4 10             	add    $0x10,%esp
8010541c:	85 c0                	test   %eax,%eax
8010541e:	78 30                	js     80105450 <sys_mkdir+0x50>
80105420:	83 ec 0c             	sub    $0xc,%esp
80105423:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105426:	31 c9                	xor    %ecx,%ecx
80105428:	ba 01 00 00 00       	mov    $0x1,%edx
8010542d:	6a 00                	push   $0x0
8010542f:	e8 ac f7 ff ff       	call   80104be0 <create>
80105434:	83 c4 10             	add    $0x10,%esp
80105437:	85 c0                	test   %eax,%eax
80105439:	74 15                	je     80105450 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010543b:	83 ec 0c             	sub    $0xc,%esp
8010543e:	50                   	push   %eax
8010543f:	e8 5c c6 ff ff       	call   80101aa0 <iunlockput>
  end_op();
80105444:	e8 d7 d9 ff ff       	call   80102e20 <end_op>
  return 0;
80105449:	83 c4 10             	add    $0x10,%esp
8010544c:	31 c0                	xor    %eax,%eax
}
8010544e:	c9                   	leave
8010544f:	c3                   	ret
    end_op();
80105450:	e8 cb d9 ff ff       	call   80102e20 <end_op>
    return -1;
80105455:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010545a:	c9                   	leave
8010545b:	c3                   	ret
8010545c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105460 <sys_mknod>:

int
sys_mknod(void)
{
80105460:	55                   	push   %ebp
80105461:	89 e5                	mov    %esp,%ebp
80105463:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105466:	e8 45 d9 ff ff       	call   80102db0 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010546b:	83 ec 08             	sub    $0x8,%esp
8010546e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105471:	50                   	push   %eax
80105472:	6a 00                	push   $0x0
80105474:	e8 77 f6 ff ff       	call   80104af0 <argstr>
80105479:	83 c4 10             	add    $0x10,%esp
8010547c:	85 c0                	test   %eax,%eax
8010547e:	78 60                	js     801054e0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105480:	83 ec 08             	sub    $0x8,%esp
80105483:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105486:	50                   	push   %eax
80105487:	6a 01                	push   $0x1
80105489:	e8 a2 f5 ff ff       	call   80104a30 <argint>
  if((argstr(0, &path)) < 0 ||
8010548e:	83 c4 10             	add    $0x10,%esp
80105491:	85 c0                	test   %eax,%eax
80105493:	78 4b                	js     801054e0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105495:	83 ec 08             	sub    $0x8,%esp
80105498:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010549b:	50                   	push   %eax
8010549c:	6a 02                	push   $0x2
8010549e:	e8 8d f5 ff ff       	call   80104a30 <argint>
     argint(1, &major) < 0 ||
801054a3:	83 c4 10             	add    $0x10,%esp
801054a6:	85 c0                	test   %eax,%eax
801054a8:	78 36                	js     801054e0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801054aa:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801054ae:	83 ec 0c             	sub    $0xc,%esp
801054b1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801054b5:	ba 03 00 00 00       	mov    $0x3,%edx
801054ba:	50                   	push   %eax
801054bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801054be:	e8 1d f7 ff ff       	call   80104be0 <create>
     argint(2, &minor) < 0 ||
801054c3:	83 c4 10             	add    $0x10,%esp
801054c6:	85 c0                	test   %eax,%eax
801054c8:	74 16                	je     801054e0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801054ca:	83 ec 0c             	sub    $0xc,%esp
801054cd:	50                   	push   %eax
801054ce:	e8 cd c5 ff ff       	call   80101aa0 <iunlockput>
  end_op();
801054d3:	e8 48 d9 ff ff       	call   80102e20 <end_op>
  return 0;
801054d8:	83 c4 10             	add    $0x10,%esp
801054db:	31 c0                	xor    %eax,%eax
}
801054dd:	c9                   	leave
801054de:	c3                   	ret
801054df:	90                   	nop
    end_op();
801054e0:	e8 3b d9 ff ff       	call   80102e20 <end_op>
    return -1;
801054e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054ea:	c9                   	leave
801054eb:	c3                   	ret
801054ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801054f0 <sys_chdir>:

int
sys_chdir(void)
{
801054f0:	55                   	push   %ebp
801054f1:	89 e5                	mov    %esp,%ebp
801054f3:	56                   	push   %esi
801054f4:	53                   	push   %ebx
801054f5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801054f8:	e8 43 e5 ff ff       	call   80103a40 <myproc>
801054fd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801054ff:	e8 ac d8 ff ff       	call   80102db0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105504:	83 ec 08             	sub    $0x8,%esp
80105507:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010550a:	50                   	push   %eax
8010550b:	6a 00                	push   $0x0
8010550d:	e8 de f5 ff ff       	call   80104af0 <argstr>
80105512:	83 c4 10             	add    $0x10,%esp
80105515:	85 c0                	test   %eax,%eax
80105517:	78 77                	js     80105590 <sys_chdir+0xa0>
80105519:	83 ec 0c             	sub    $0xc,%esp
8010551c:	ff 75 f4             	push   -0xc(%ebp)
8010551f:	e8 cc cb ff ff       	call   801020f0 <namei>
80105524:	83 c4 10             	add    $0x10,%esp
80105527:	89 c3                	mov    %eax,%ebx
80105529:	85 c0                	test   %eax,%eax
8010552b:	74 63                	je     80105590 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010552d:	83 ec 0c             	sub    $0xc,%esp
80105530:	50                   	push   %eax
80105531:	e8 da c2 ff ff       	call   80101810 <ilock>
  if(ip->type != T_DIR){
80105536:	83 c4 10             	add    $0x10,%esp
80105539:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010553e:	75 30                	jne    80105570 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105540:	83 ec 0c             	sub    $0xc,%esp
80105543:	53                   	push   %ebx
80105544:	e8 a7 c3 ff ff       	call   801018f0 <iunlock>
  iput(curproc->cwd);
80105549:	58                   	pop    %eax
8010554a:	ff 76 68             	push   0x68(%esi)
8010554d:	e8 ee c3 ff ff       	call   80101940 <iput>
  end_op();
80105552:	e8 c9 d8 ff ff       	call   80102e20 <end_op>
  curproc->cwd = ip;
80105557:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010555a:	83 c4 10             	add    $0x10,%esp
8010555d:	31 c0                	xor    %eax,%eax
}
8010555f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105562:	5b                   	pop    %ebx
80105563:	5e                   	pop    %esi
80105564:	5d                   	pop    %ebp
80105565:	c3                   	ret
80105566:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010556d:	00 
8010556e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105570:	83 ec 0c             	sub    $0xc,%esp
80105573:	53                   	push   %ebx
80105574:	e8 27 c5 ff ff       	call   80101aa0 <iunlockput>
    end_op();
80105579:	e8 a2 d8 ff ff       	call   80102e20 <end_op>
    return -1;
8010557e:	83 c4 10             	add    $0x10,%esp
    return -1;
80105581:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105586:	eb d7                	jmp    8010555f <sys_chdir+0x6f>
80105588:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010558f:	00 
    end_op();
80105590:	e8 8b d8 ff ff       	call   80102e20 <end_op>
    return -1;
80105595:	eb ea                	jmp    80105581 <sys_chdir+0x91>
80105597:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010559e:	00 
8010559f:	90                   	nop

801055a0 <sys_exec>:

int
sys_exec(void)
{
801055a0:	55                   	push   %ebp
801055a1:	89 e5                	mov    %esp,%ebp
801055a3:	57                   	push   %edi
801055a4:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801055a5:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801055ab:	53                   	push   %ebx
801055ac:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801055b2:	50                   	push   %eax
801055b3:	6a 00                	push   $0x0
801055b5:	e8 36 f5 ff ff       	call   80104af0 <argstr>
801055ba:	83 c4 10             	add    $0x10,%esp
801055bd:	85 c0                	test   %eax,%eax
801055bf:	0f 88 87 00 00 00    	js     8010564c <sys_exec+0xac>
801055c5:	83 ec 08             	sub    $0x8,%esp
801055c8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801055ce:	50                   	push   %eax
801055cf:	6a 01                	push   $0x1
801055d1:	e8 5a f4 ff ff       	call   80104a30 <argint>
801055d6:	83 c4 10             	add    $0x10,%esp
801055d9:	85 c0                	test   %eax,%eax
801055db:	78 6f                	js     8010564c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801055dd:	83 ec 04             	sub    $0x4,%esp
801055e0:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
801055e6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801055e8:	68 80 00 00 00       	push   $0x80
801055ed:	6a 00                	push   $0x0
801055ef:	56                   	push   %esi
801055f0:	e8 8b f1 ff ff       	call   80104780 <memset>
801055f5:	83 c4 10             	add    $0x10,%esp
801055f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801055ff:	00 
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105600:	83 ec 08             	sub    $0x8,%esp
80105603:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105609:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105610:	50                   	push   %eax
80105611:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105617:	01 f8                	add    %edi,%eax
80105619:	50                   	push   %eax
8010561a:	e8 81 f3 ff ff       	call   801049a0 <fetchint>
8010561f:	83 c4 10             	add    $0x10,%esp
80105622:	85 c0                	test   %eax,%eax
80105624:	78 26                	js     8010564c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105626:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010562c:	85 c0                	test   %eax,%eax
8010562e:	74 30                	je     80105660 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105630:	83 ec 08             	sub    $0x8,%esp
80105633:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105636:	52                   	push   %edx
80105637:	50                   	push   %eax
80105638:	e8 a3 f3 ff ff       	call   801049e0 <fetchstr>
8010563d:	83 c4 10             	add    $0x10,%esp
80105640:	85 c0                	test   %eax,%eax
80105642:	78 08                	js     8010564c <sys_exec+0xac>
  for(i=0;; i++){
80105644:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105647:	83 fb 20             	cmp    $0x20,%ebx
8010564a:	75 b4                	jne    80105600 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010564c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010564f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105654:	5b                   	pop    %ebx
80105655:	5e                   	pop    %esi
80105656:	5f                   	pop    %edi
80105657:	5d                   	pop    %ebp
80105658:	c3                   	ret
80105659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105660:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105667:	00 00 00 00 
  return exec(path, argv);
8010566b:	83 ec 08             	sub    $0x8,%esp
8010566e:	56                   	push   %esi
8010566f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105675:	e8 a6 b4 ff ff       	call   80100b20 <exec>
8010567a:	83 c4 10             	add    $0x10,%esp
}
8010567d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105680:	5b                   	pop    %ebx
80105681:	5e                   	pop    %esi
80105682:	5f                   	pop    %edi
80105683:	5d                   	pop    %ebp
80105684:	c3                   	ret
80105685:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010568c:	00 
8010568d:	8d 76 00             	lea    0x0(%esi),%esi

80105690 <sys_pipe>:

int
sys_pipe(void)
{
80105690:	55                   	push   %ebp
80105691:	89 e5                	mov    %esp,%ebp
80105693:	57                   	push   %edi
80105694:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105695:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105698:	53                   	push   %ebx
80105699:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010569c:	6a 08                	push   $0x8
8010569e:	50                   	push   %eax
8010569f:	6a 00                	push   $0x0
801056a1:	e8 da f3 ff ff       	call   80104a80 <argptr>
801056a6:	83 c4 10             	add    $0x10,%esp
801056a9:	85 c0                	test   %eax,%eax
801056ab:	0f 88 8b 00 00 00    	js     8010573c <sys_pipe+0xac>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801056b1:	83 ec 08             	sub    $0x8,%esp
801056b4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801056b7:	50                   	push   %eax
801056b8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801056bb:	50                   	push   %eax
801056bc:	e8 bf dd ff ff       	call   80103480 <pipealloc>
801056c1:	83 c4 10             	add    $0x10,%esp
801056c4:	85 c0                	test   %eax,%eax
801056c6:	78 74                	js     8010573c <sys_pipe+0xac>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801056c8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801056cb:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801056cd:	e8 6e e3 ff ff       	call   80103a40 <myproc>
    if(curproc->ofile[fd] == 0){
801056d2:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801056d6:	85 f6                	test   %esi,%esi
801056d8:	74 16                	je     801056f0 <sys_pipe+0x60>
801056da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
801056e0:	83 c3 01             	add    $0x1,%ebx
801056e3:	83 fb 10             	cmp    $0x10,%ebx
801056e6:	74 3d                	je     80105725 <sys_pipe+0x95>
    if(curproc->ofile[fd] == 0){
801056e8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801056ec:	85 f6                	test   %esi,%esi
801056ee:	75 f0                	jne    801056e0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
801056f0:	8d 73 08             	lea    0x8(%ebx),%esi
801056f3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801056f7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801056fa:	e8 41 e3 ff ff       	call   80103a40 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801056ff:	31 d2                	xor    %edx,%edx
80105701:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105708:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010570c:	85 c9                	test   %ecx,%ecx
8010570e:	74 38                	je     80105748 <sys_pipe+0xb8>
  for(fd = 0; fd < NOFILE; fd++){
80105710:	83 c2 01             	add    $0x1,%edx
80105713:	83 fa 10             	cmp    $0x10,%edx
80105716:	75 f0                	jne    80105708 <sys_pipe+0x78>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105718:	e8 23 e3 ff ff       	call   80103a40 <myproc>
8010571d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105724:	00 
    fileclose(rf);
80105725:	83 ec 0c             	sub    $0xc,%esp
80105728:	ff 75 e0             	push   -0x20(%ebp)
8010572b:	e8 50 b8 ff ff       	call   80100f80 <fileclose>
    fileclose(wf);
80105730:	58                   	pop    %eax
80105731:	ff 75 e4             	push   -0x1c(%ebp)
80105734:	e8 47 b8 ff ff       	call   80100f80 <fileclose>
    return -1;
80105739:	83 c4 10             	add    $0x10,%esp
    return -1;
8010573c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105741:	eb 16                	jmp    80105759 <sys_pipe+0xc9>
80105743:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
80105748:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
8010574c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010574f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105751:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105754:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105757:	31 c0                	xor    %eax,%eax
}
80105759:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010575c:	5b                   	pop    %ebx
8010575d:	5e                   	pop    %esi
8010575e:	5f                   	pop    %edi
8010575f:	5d                   	pop    %ebp
80105760:	c3                   	ret
80105761:	66 90                	xchg   %ax,%ax
80105763:	66 90                	xchg   %ax,%ax
80105765:	66 90                	xchg   %ax,%ax
80105767:	66 90                	xchg   %ax,%ax
80105769:	66 90                	xchg   %ax,%ax
8010576b:	66 90                	xchg   %ax,%ax
8010576d:	66 90                	xchg   %ax,%ax
8010576f:	90                   	nop

80105770 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105770:	e9 6b e4 ff ff       	jmp    80103be0 <fork>
80105775:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010577c:	00 
8010577d:	8d 76 00             	lea    0x0(%esi),%esi

80105780 <sys_exit>:
}

int
sys_exit(void)
{
80105780:	55                   	push   %ebp
80105781:	89 e5                	mov    %esp,%ebp
80105783:	83 ec 08             	sub    $0x8,%esp
  exit();
80105786:	e8 c5 e6 ff ff       	call   80103e50 <exit>
  return 0;  // not reached
}
8010578b:	31 c0                	xor    %eax,%eax
8010578d:	c9                   	leave
8010578e:	c3                   	ret
8010578f:	90                   	nop

80105790 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105790:	e9 eb e7 ff ff       	jmp    80103f80 <wait>
80105795:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010579c:	00 
8010579d:	8d 76 00             	lea    0x0(%esi),%esi

801057a0 <sys_kill>:
}

int
sys_kill(void)
{
801057a0:	55                   	push   %ebp
801057a1:	89 e5                	mov    %esp,%ebp
801057a3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801057a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057a9:	50                   	push   %eax
801057aa:	6a 00                	push   $0x0
801057ac:	e8 7f f2 ff ff       	call   80104a30 <argint>
801057b1:	83 c4 10             	add    $0x10,%esp
801057b4:	85 c0                	test   %eax,%eax
801057b6:	78 18                	js     801057d0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801057b8:	83 ec 0c             	sub    $0xc,%esp
801057bb:	ff 75 f4             	push   -0xc(%ebp)
801057be:	e8 5d ea ff ff       	call   80104220 <kill>
801057c3:	83 c4 10             	add    $0x10,%esp
}
801057c6:	c9                   	leave
801057c7:	c3                   	ret
801057c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801057cf:	00 
801057d0:	c9                   	leave
    return -1;
801057d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057d6:	c3                   	ret
801057d7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801057de:	00 
801057df:	90                   	nop

801057e0 <sys_getpid>:

int
sys_getpid(void)
{
801057e0:	55                   	push   %ebp
801057e1:	89 e5                	mov    %esp,%ebp
801057e3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801057e6:	e8 55 e2 ff ff       	call   80103a40 <myproc>
801057eb:	8b 40 10             	mov    0x10(%eax),%eax
}
801057ee:	c9                   	leave
801057ef:	c3                   	ret

801057f0 <sys_sbrk>:

int
sys_sbrk(void)
{
801057f0:	55                   	push   %ebp
801057f1:	89 e5                	mov    %esp,%ebp
801057f3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801057f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801057f7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801057fa:	50                   	push   %eax
801057fb:	6a 00                	push   $0x0
801057fd:	e8 2e f2 ff ff       	call   80104a30 <argint>
80105802:	83 c4 10             	add    $0x10,%esp
80105805:	85 c0                	test   %eax,%eax
80105807:	78 27                	js     80105830 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105809:	e8 32 e2 ff ff       	call   80103a40 <myproc>
  if(growproc(n) < 0)
8010580e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105811:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105813:	ff 75 f4             	push   -0xc(%ebp)
80105816:	e8 45 e3 ff ff       	call   80103b60 <growproc>
8010581b:	83 c4 10             	add    $0x10,%esp
8010581e:	85 c0                	test   %eax,%eax
80105820:	78 0e                	js     80105830 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105822:	89 d8                	mov    %ebx,%eax
80105824:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105827:	c9                   	leave
80105828:	c3                   	ret
80105829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105830:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105835:	eb eb                	jmp    80105822 <sys_sbrk+0x32>
80105837:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010583e:	00 
8010583f:	90                   	nop

80105840 <sys_sleep>:

int
sys_sleep(void)
{
80105840:	55                   	push   %ebp
80105841:	89 e5                	mov    %esp,%ebp
80105843:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105844:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105847:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010584a:	50                   	push   %eax
8010584b:	6a 00                	push   $0x0
8010584d:	e8 de f1 ff ff       	call   80104a30 <argint>
80105852:	83 c4 10             	add    $0x10,%esp
80105855:	85 c0                	test   %eax,%eax
80105857:	78 64                	js     801058bd <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
80105859:	83 ec 0c             	sub    $0xc,%esp
8010585c:	68 a0 3c 11 80       	push   $0x80113ca0
80105861:	e8 1a ee ff ff       	call   80104680 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105866:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105869:	8b 1d 80 3c 11 80    	mov    0x80113c80,%ebx
  while(ticks - ticks0 < n){
8010586f:	83 c4 10             	add    $0x10,%esp
80105872:	85 d2                	test   %edx,%edx
80105874:	75 2b                	jne    801058a1 <sys_sleep+0x61>
80105876:	eb 58                	jmp    801058d0 <sys_sleep+0x90>
80105878:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010587f:	00 
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105880:	83 ec 08             	sub    $0x8,%esp
80105883:	68 a0 3c 11 80       	push   $0x80113ca0
80105888:	68 80 3c 11 80       	push   $0x80113c80
8010588d:	e8 6e e8 ff ff       	call   80104100 <sleep>
  while(ticks - ticks0 < n){
80105892:	a1 80 3c 11 80       	mov    0x80113c80,%eax
80105897:	83 c4 10             	add    $0x10,%esp
8010589a:	29 d8                	sub    %ebx,%eax
8010589c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010589f:	73 2f                	jae    801058d0 <sys_sleep+0x90>
    if(myproc()->killed){
801058a1:	e8 9a e1 ff ff       	call   80103a40 <myproc>
801058a6:	8b 40 24             	mov    0x24(%eax),%eax
801058a9:	85 c0                	test   %eax,%eax
801058ab:	74 d3                	je     80105880 <sys_sleep+0x40>
      release(&tickslock);
801058ad:	83 ec 0c             	sub    $0xc,%esp
801058b0:	68 a0 3c 11 80       	push   $0x80113ca0
801058b5:	e8 66 ed ff ff       	call   80104620 <release>
      return -1;
801058ba:	83 c4 10             	add    $0x10,%esp
  }
  release(&tickslock);
  return 0;
}
801058bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
801058c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058c5:	c9                   	leave
801058c6:	c3                   	ret
801058c7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801058ce:	00 
801058cf:	90                   	nop
  release(&tickslock);
801058d0:	83 ec 0c             	sub    $0xc,%esp
801058d3:	68 a0 3c 11 80       	push   $0x80113ca0
801058d8:	e8 43 ed ff ff       	call   80104620 <release>
}
801058dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return 0;
801058e0:	83 c4 10             	add    $0x10,%esp
801058e3:	31 c0                	xor    %eax,%eax
}
801058e5:	c9                   	leave
801058e6:	c3                   	ret
801058e7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801058ee:	00 
801058ef:	90                   	nop

801058f0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801058f0:	55                   	push   %ebp
801058f1:	89 e5                	mov    %esp,%ebp
801058f3:	53                   	push   %ebx
801058f4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801058f7:	68 a0 3c 11 80       	push   $0x80113ca0
801058fc:	e8 7f ed ff ff       	call   80104680 <acquire>
  xticks = ticks;
80105901:	8b 1d 80 3c 11 80    	mov    0x80113c80,%ebx
  release(&tickslock);
80105907:	c7 04 24 a0 3c 11 80 	movl   $0x80113ca0,(%esp)
8010590e:	e8 0d ed ff ff       	call   80104620 <release>
  return xticks;
}
80105913:	89 d8                	mov    %ebx,%eax
80105915:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105918:	c9                   	leave
80105919:	c3                   	ret

8010591a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010591a:	1e                   	push   %ds
  pushl %es
8010591b:	06                   	push   %es
  pushl %fs
8010591c:	0f a0                	push   %fs
  pushl %gs
8010591e:	0f a8                	push   %gs
  pushal
80105920:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105921:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105925:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105927:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105929:	54                   	push   %esp
  call trap
8010592a:	e8 c1 00 00 00       	call   801059f0 <trap>
  addl $4, %esp
8010592f:	83 c4 04             	add    $0x4,%esp

80105932 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105932:	61                   	popa
  popl %gs
80105933:	0f a9                	pop    %gs
  popl %fs
80105935:	0f a1                	pop    %fs
  popl %es
80105937:	07                   	pop    %es
  popl %ds
80105938:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105939:	83 c4 08             	add    $0x8,%esp
  iret
8010593c:	cf                   	iret
8010593d:	66 90                	xchg   %ax,%ax
8010593f:	90                   	nop

80105940 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105940:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105941:	31 c0                	xor    %eax,%eax
{
80105943:	89 e5                	mov    %esp,%ebp
80105945:	83 ec 08             	sub    $0x8,%esp
80105948:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010594f:	00 
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105950:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105957:	c7 04 c5 e2 3c 11 80 	movl   $0x8e000008,-0x7feec31e(,%eax,8)
8010595e:	08 00 00 8e 
80105962:	66 89 14 c5 e0 3c 11 	mov    %dx,-0x7feec320(,%eax,8)
80105969:	80 
8010596a:	c1 ea 10             	shr    $0x10,%edx
8010596d:	66 89 14 c5 e6 3c 11 	mov    %dx,-0x7feec31a(,%eax,8)
80105974:	80 
  for(i = 0; i < 256; i++)
80105975:	83 c0 01             	add    $0x1,%eax
80105978:	3d 00 01 00 00       	cmp    $0x100,%eax
8010597d:	75 d1                	jne    80105950 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010597f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105982:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80105987:	c7 05 e2 3e 11 80 08 	movl   $0xef000008,0x80113ee2
8010598e:	00 00 ef 
  initlock(&tickslock, "time");
80105991:	68 77 76 10 80       	push   $0x80107677
80105996:	68 a0 3c 11 80       	push   $0x80113ca0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010599b:	66 a3 e0 3e 11 80    	mov    %ax,0x80113ee0
801059a1:	c1 e8 10             	shr    $0x10,%eax
801059a4:	66 a3 e6 3e 11 80    	mov    %ax,0x80113ee6
  initlock(&tickslock, "time");
801059aa:	e8 e1 ea ff ff       	call   80104490 <initlock>
}
801059af:	83 c4 10             	add    $0x10,%esp
801059b2:	c9                   	leave
801059b3:	c3                   	ret
801059b4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801059bb:	00 
801059bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059c0 <idtinit>:

void
idtinit(void)
{
801059c0:	55                   	push   %ebp
  pd[0] = size-1;
801059c1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801059c6:	89 e5                	mov    %esp,%ebp
801059c8:	83 ec 10             	sub    $0x10,%esp
801059cb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801059cf:	b8 e0 3c 11 80       	mov    $0x80113ce0,%eax
801059d4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801059d8:	c1 e8 10             	shr    $0x10,%eax
801059db:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801059df:	8d 45 fa             	lea    -0x6(%ebp),%eax
801059e2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801059e5:	c9                   	leave
801059e6:	c3                   	ret
801059e7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801059ee:	00 
801059ef:	90                   	nop

801059f0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801059f0:	55                   	push   %ebp
801059f1:	89 e5                	mov    %esp,%ebp
801059f3:	57                   	push   %edi
801059f4:	56                   	push   %esi
801059f5:	53                   	push   %ebx
801059f6:	83 ec 1c             	sub    $0x1c,%esp
801059f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
801059fc:	8b 43 30             	mov    0x30(%ebx),%eax
801059ff:	83 f8 40             	cmp    $0x40,%eax
80105a02:	0f 84 58 01 00 00    	je     80105b60 <trap+0x170>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105a08:	83 e8 20             	sub    $0x20,%eax
80105a0b:	83 f8 1f             	cmp    $0x1f,%eax
80105a0e:	0f 87 7c 00 00 00    	ja     80105a90 <trap+0xa0>
80105a14:	ff 24 85 d8 7b 10 80 	jmp    *-0x7fef8428(,%eax,4)
80105a1b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105a20:	e8 7b c8 ff ff       	call   801022a0 <ideintr>
    lapiceoi();
80105a25:	e8 36 cf ff ff       	call   80102960 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a2a:	e8 11 e0 ff ff       	call   80103a40 <myproc>
80105a2f:	85 c0                	test   %eax,%eax
80105a31:	74 1a                	je     80105a4d <trap+0x5d>
80105a33:	e8 08 e0 ff ff       	call   80103a40 <myproc>
80105a38:	8b 50 24             	mov    0x24(%eax),%edx
80105a3b:	85 d2                	test   %edx,%edx
80105a3d:	74 0e                	je     80105a4d <trap+0x5d>
80105a3f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105a43:	f7 d0                	not    %eax
80105a45:	a8 03                	test   $0x3,%al
80105a47:	0f 84 db 01 00 00    	je     80105c28 <trap+0x238>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105a4d:	e8 ee df ff ff       	call   80103a40 <myproc>
80105a52:	85 c0                	test   %eax,%eax
80105a54:	74 0f                	je     80105a65 <trap+0x75>
80105a56:	e8 e5 df ff ff       	call   80103a40 <myproc>
80105a5b:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105a5f:	0f 84 ab 00 00 00    	je     80105b10 <trap+0x120>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a65:	e8 d6 df ff ff       	call   80103a40 <myproc>
80105a6a:	85 c0                	test   %eax,%eax
80105a6c:	74 1a                	je     80105a88 <trap+0x98>
80105a6e:	e8 cd df ff ff       	call   80103a40 <myproc>
80105a73:	8b 40 24             	mov    0x24(%eax),%eax
80105a76:	85 c0                	test   %eax,%eax
80105a78:	74 0e                	je     80105a88 <trap+0x98>
80105a7a:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105a7e:	f7 d0                	not    %eax
80105a80:	a8 03                	test   $0x3,%al
80105a82:	0f 84 05 01 00 00    	je     80105b8d <trap+0x19d>
    exit();
}
80105a88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a8b:	5b                   	pop    %ebx
80105a8c:	5e                   	pop    %esi
80105a8d:	5f                   	pop    %edi
80105a8e:	5d                   	pop    %ebp
80105a8f:	c3                   	ret
    if(myproc() == 0 || (tf->cs&3) == 0){
80105a90:	e8 ab df ff ff       	call   80103a40 <myproc>
80105a95:	8b 7b 38             	mov    0x38(%ebx),%edi
80105a98:	85 c0                	test   %eax,%eax
80105a9a:	0f 84 a2 01 00 00    	je     80105c42 <trap+0x252>
80105aa0:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105aa4:	0f 84 98 01 00 00    	je     80105c42 <trap+0x252>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105aaa:	0f 20 d1             	mov    %cr2,%ecx
80105aad:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ab0:	e8 6b df ff ff       	call   80103a20 <cpuid>
80105ab5:	8b 73 30             	mov    0x30(%ebx),%esi
80105ab8:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105abb:	8b 43 34             	mov    0x34(%ebx),%eax
80105abe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105ac1:	e8 7a df ff ff       	call   80103a40 <myproc>
80105ac6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105ac9:	e8 72 df ff ff       	call   80103a40 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ace:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105ad1:	51                   	push   %ecx
80105ad2:	57                   	push   %edi
80105ad3:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105ad6:	52                   	push   %edx
80105ad7:	ff 75 e4             	push   -0x1c(%ebp)
80105ada:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105adb:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105ade:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105ae1:	56                   	push   %esi
80105ae2:	ff 70 10             	push   0x10(%eax)
80105ae5:	68 c8 78 10 80       	push   $0x801078c8
80105aea:	e8 c1 ab ff ff       	call   801006b0 <cprintf>
    myproc()->killed = 1;
80105aef:	83 c4 20             	add    $0x20,%esp
80105af2:	e8 49 df ff ff       	call   80103a40 <myproc>
80105af7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105afe:	e8 3d df ff ff       	call   80103a40 <myproc>
80105b03:	85 c0                	test   %eax,%eax
80105b05:	0f 85 28 ff ff ff    	jne    80105a33 <trap+0x43>
80105b0b:	e9 3d ff ff ff       	jmp    80105a4d <trap+0x5d>
  if(myproc() && myproc()->state == RUNNING &&
80105b10:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105b14:	0f 85 4b ff ff ff    	jne    80105a65 <trap+0x75>
    yield();
80105b1a:	e8 91 e5 ff ff       	call   801040b0 <yield>
80105b1f:	e9 41 ff ff ff       	jmp    80105a65 <trap+0x75>
80105b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105b28:	8b 7b 38             	mov    0x38(%ebx),%edi
80105b2b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105b2f:	e8 ec de ff ff       	call   80103a20 <cpuid>
80105b34:	57                   	push   %edi
80105b35:	56                   	push   %esi
80105b36:	50                   	push   %eax
80105b37:	68 70 78 10 80       	push   $0x80107870
80105b3c:	e8 6f ab ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80105b41:	e8 1a ce ff ff       	call   80102960 <lapiceoi>
    break;
80105b46:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b49:	e8 f2 de ff ff       	call   80103a40 <myproc>
80105b4e:	85 c0                	test   %eax,%eax
80105b50:	0f 85 dd fe ff ff    	jne    80105a33 <trap+0x43>
80105b56:	e9 f2 fe ff ff       	jmp    80105a4d <trap+0x5d>
80105b5b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105b60:	e8 db de ff ff       	call   80103a40 <myproc>
80105b65:	8b 70 24             	mov    0x24(%eax),%esi
80105b68:	85 f6                	test   %esi,%esi
80105b6a:	0f 85 c8 00 00 00    	jne    80105c38 <trap+0x248>
    myproc()->tf = tf;
80105b70:	e8 cb de ff ff       	call   80103a40 <myproc>
80105b75:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105b78:	e8 f3 ef ff ff       	call   80104b70 <syscall>
    if(myproc()->killed)
80105b7d:	e8 be de ff ff       	call   80103a40 <myproc>
80105b82:	8b 48 24             	mov    0x24(%eax),%ecx
80105b85:	85 c9                	test   %ecx,%ecx
80105b87:	0f 84 fb fe ff ff    	je     80105a88 <trap+0x98>
}
80105b8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b90:	5b                   	pop    %ebx
80105b91:	5e                   	pop    %esi
80105b92:	5f                   	pop    %edi
80105b93:	5d                   	pop    %ebp
      exit();
80105b94:	e9 b7 e2 ff ff       	jmp    80103e50 <exit>
80105b99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105ba0:	e8 4b 02 00 00       	call   80105df0 <uartintr>
    lapiceoi();
80105ba5:	e8 b6 cd ff ff       	call   80102960 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105baa:	e8 91 de ff ff       	call   80103a40 <myproc>
80105baf:	85 c0                	test   %eax,%eax
80105bb1:	0f 85 7c fe ff ff    	jne    80105a33 <trap+0x43>
80105bb7:	e9 91 fe ff ff       	jmp    80105a4d <trap+0x5d>
80105bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105bc0:	e8 6b cc ff ff       	call   80102830 <kbdintr>
    lapiceoi();
80105bc5:	e8 96 cd ff ff       	call   80102960 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105bca:	e8 71 de ff ff       	call   80103a40 <myproc>
80105bcf:	85 c0                	test   %eax,%eax
80105bd1:	0f 85 5c fe ff ff    	jne    80105a33 <trap+0x43>
80105bd7:	e9 71 fe ff ff       	jmp    80105a4d <trap+0x5d>
80105bdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105be0:	e8 3b de ff ff       	call   80103a20 <cpuid>
80105be5:	85 c0                	test   %eax,%eax
80105be7:	0f 85 38 fe ff ff    	jne    80105a25 <trap+0x35>
      acquire(&tickslock);
80105bed:	83 ec 0c             	sub    $0xc,%esp
80105bf0:	68 a0 3c 11 80       	push   $0x80113ca0
80105bf5:	e8 86 ea ff ff       	call   80104680 <acquire>
      ticks++;
80105bfa:	83 05 80 3c 11 80 01 	addl   $0x1,0x80113c80
      wakeup(&ticks);
80105c01:	c7 04 24 80 3c 11 80 	movl   $0x80113c80,(%esp)
80105c08:	e8 b3 e5 ff ff       	call   801041c0 <wakeup>
      release(&tickslock);
80105c0d:	c7 04 24 a0 3c 11 80 	movl   $0x80113ca0,(%esp)
80105c14:	e8 07 ea ff ff       	call   80104620 <release>
80105c19:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105c1c:	e9 04 fe ff ff       	jmp    80105a25 <trap+0x35>
80105c21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80105c28:	e8 23 e2 ff ff       	call   80103e50 <exit>
80105c2d:	e9 1b fe ff ff       	jmp    80105a4d <trap+0x5d>
80105c32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105c38:	e8 13 e2 ff ff       	call   80103e50 <exit>
80105c3d:	e9 2e ff ff ff       	jmp    80105b70 <trap+0x180>
80105c42:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105c45:	e8 d6 dd ff ff       	call   80103a20 <cpuid>
80105c4a:	83 ec 0c             	sub    $0xc,%esp
80105c4d:	56                   	push   %esi
80105c4e:	57                   	push   %edi
80105c4f:	50                   	push   %eax
80105c50:	ff 73 30             	push   0x30(%ebx)
80105c53:	68 94 78 10 80       	push   $0x80107894
80105c58:	e8 53 aa ff ff       	call   801006b0 <cprintf>
      panic("trap");
80105c5d:	83 c4 14             	add    $0x14,%esp
80105c60:	68 7c 76 10 80       	push   $0x8010767c
80105c65:	e8 16 a7 ff ff       	call   80100380 <panic>
80105c6a:	66 90                	xchg   %ax,%ax
80105c6c:	66 90                	xchg   %ax,%ax
80105c6e:	66 90                	xchg   %ax,%ax

80105c70 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105c70:	a1 e0 44 11 80       	mov    0x801144e0,%eax
80105c75:	85 c0                	test   %eax,%eax
80105c77:	74 17                	je     80105c90 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105c79:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105c7e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105c7f:	a8 01                	test   $0x1,%al
80105c81:	74 0d                	je     80105c90 <uartgetc+0x20>
80105c83:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105c88:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105c89:	0f b6 c0             	movzbl %al,%eax
80105c8c:	c3                   	ret
80105c8d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105c90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c95:	c3                   	ret
80105c96:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105c9d:	00 
80105c9e:	66 90                	xchg   %ax,%ax

80105ca0 <uartinit>:
{
80105ca0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105ca1:	31 c9                	xor    %ecx,%ecx
80105ca3:	89 c8                	mov    %ecx,%eax
80105ca5:	89 e5                	mov    %esp,%ebp
80105ca7:	57                   	push   %edi
80105ca8:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105cad:	56                   	push   %esi
80105cae:	89 fa                	mov    %edi,%edx
80105cb0:	53                   	push   %ebx
80105cb1:	83 ec 1c             	sub    $0x1c,%esp
80105cb4:	ee                   	out    %al,(%dx)
80105cb5:	be fb 03 00 00       	mov    $0x3fb,%esi
80105cba:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105cbf:	89 f2                	mov    %esi,%edx
80105cc1:	ee                   	out    %al,(%dx)
80105cc2:	b8 0c 00 00 00       	mov    $0xc,%eax
80105cc7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ccc:	ee                   	out    %al,(%dx)
80105ccd:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105cd2:	89 c8                	mov    %ecx,%eax
80105cd4:	89 da                	mov    %ebx,%edx
80105cd6:	ee                   	out    %al,(%dx)
80105cd7:	b8 03 00 00 00       	mov    $0x3,%eax
80105cdc:	89 f2                	mov    %esi,%edx
80105cde:	ee                   	out    %al,(%dx)
80105cdf:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105ce4:	89 c8                	mov    %ecx,%eax
80105ce6:	ee                   	out    %al,(%dx)
80105ce7:	b8 01 00 00 00       	mov    $0x1,%eax
80105cec:	89 da                	mov    %ebx,%edx
80105cee:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105cef:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105cf4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105cf5:	3c ff                	cmp    $0xff,%al
80105cf7:	0f 84 7c 00 00 00    	je     80105d79 <uartinit+0xd9>
  uart = 1;
80105cfd:	c7 05 e0 44 11 80 01 	movl   $0x1,0x801144e0
80105d04:	00 00 00 
80105d07:	89 fa                	mov    %edi,%edx
80105d09:	ec                   	in     (%dx),%al
80105d0a:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d0f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105d10:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105d13:	bf 81 76 10 80       	mov    $0x80107681,%edi
80105d18:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80105d1d:	6a 00                	push   $0x0
80105d1f:	6a 04                	push   $0x4
80105d21:	e8 aa c7 ff ff       	call   801024d0 <ioapicenable>
80105d26:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105d29:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
80105d2d:	8d 76 00             	lea    0x0(%esi),%esi
  if(!uart)
80105d30:	a1 e0 44 11 80       	mov    0x801144e0,%eax
80105d35:	85 c0                	test   %eax,%eax
80105d37:	74 32                	je     80105d6b <uartinit+0xcb>
80105d39:	89 f2                	mov    %esi,%edx
80105d3b:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105d3c:	a8 20                	test   $0x20,%al
80105d3e:	75 21                	jne    80105d61 <uartinit+0xc1>
80105d40:	bb 80 00 00 00       	mov    $0x80,%ebx
80105d45:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
80105d48:	83 ec 0c             	sub    $0xc,%esp
80105d4b:	6a 0a                	push   $0xa
80105d4d:	e8 2e cc ff ff       	call   80102980 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105d52:	83 c4 10             	add    $0x10,%esp
80105d55:	83 eb 01             	sub    $0x1,%ebx
80105d58:	74 07                	je     80105d61 <uartinit+0xc1>
80105d5a:	89 f2                	mov    %esi,%edx
80105d5c:	ec                   	in     (%dx),%al
80105d5d:	a8 20                	test   $0x20,%al
80105d5f:	74 e7                	je     80105d48 <uartinit+0xa8>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105d61:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105d66:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80105d6a:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80105d6b:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80105d6f:	83 c7 01             	add    $0x1,%edi
80105d72:	88 45 e7             	mov    %al,-0x19(%ebp)
80105d75:	84 c0                	test   %al,%al
80105d77:	75 b7                	jne    80105d30 <uartinit+0x90>
}
80105d79:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d7c:	5b                   	pop    %ebx
80105d7d:	5e                   	pop    %esi
80105d7e:	5f                   	pop    %edi
80105d7f:	5d                   	pop    %ebp
80105d80:	c3                   	ret
80105d81:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105d88:	00 
80105d89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105d90 <uartputc>:
  if(!uart)
80105d90:	a1 e0 44 11 80       	mov    0x801144e0,%eax
80105d95:	85 c0                	test   %eax,%eax
80105d97:	74 4f                	je     80105de8 <uartputc+0x58>
{
80105d99:	55                   	push   %ebp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105d9a:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105d9f:	89 e5                	mov    %esp,%ebp
80105da1:	56                   	push   %esi
80105da2:	53                   	push   %ebx
80105da3:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105da4:	a8 20                	test   $0x20,%al
80105da6:	75 29                	jne    80105dd1 <uartputc+0x41>
80105da8:	bb 80 00 00 00       	mov    $0x80,%ebx
80105dad:	be fd 03 00 00       	mov    $0x3fd,%esi
80105db2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80105db8:	83 ec 0c             	sub    $0xc,%esp
80105dbb:	6a 0a                	push   $0xa
80105dbd:	e8 be cb ff ff       	call   80102980 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105dc2:	83 c4 10             	add    $0x10,%esp
80105dc5:	83 eb 01             	sub    $0x1,%ebx
80105dc8:	74 07                	je     80105dd1 <uartputc+0x41>
80105dca:	89 f2                	mov    %esi,%edx
80105dcc:	ec                   	in     (%dx),%al
80105dcd:	a8 20                	test   $0x20,%al
80105dcf:	74 e7                	je     80105db8 <uartputc+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105dd1:	8b 45 08             	mov    0x8(%ebp),%eax
80105dd4:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105dd9:	ee                   	out    %al,(%dx)
}
80105dda:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105ddd:	5b                   	pop    %ebx
80105dde:	5e                   	pop    %esi
80105ddf:	5d                   	pop    %ebp
80105de0:	c3                   	ret
80105de1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105de8:	c3                   	ret
80105de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105df0 <uartintr>:

void
uartintr(void)
{
80105df0:	55                   	push   %ebp
80105df1:	89 e5                	mov    %esp,%ebp
80105df3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105df6:	68 70 5c 10 80       	push   $0x80105c70
80105dfb:	e8 a0 aa ff ff       	call   801008a0 <consoleintr>
}
80105e00:	83 c4 10             	add    $0x10,%esp
80105e03:	c9                   	leave
80105e04:	c3                   	ret

80105e05 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105e05:	6a 00                	push   $0x0
  pushl $0
80105e07:	6a 00                	push   $0x0
  jmp alltraps
80105e09:	e9 0c fb ff ff       	jmp    8010591a <alltraps>

80105e0e <vector1>:
.globl vector1
vector1:
  pushl $0
80105e0e:	6a 00                	push   $0x0
  pushl $1
80105e10:	6a 01                	push   $0x1
  jmp alltraps
80105e12:	e9 03 fb ff ff       	jmp    8010591a <alltraps>

80105e17 <vector2>:
.globl vector2
vector2:
  pushl $0
80105e17:	6a 00                	push   $0x0
  pushl $2
80105e19:	6a 02                	push   $0x2
  jmp alltraps
80105e1b:	e9 fa fa ff ff       	jmp    8010591a <alltraps>

80105e20 <vector3>:
.globl vector3
vector3:
  pushl $0
80105e20:	6a 00                	push   $0x0
  pushl $3
80105e22:	6a 03                	push   $0x3
  jmp alltraps
80105e24:	e9 f1 fa ff ff       	jmp    8010591a <alltraps>

80105e29 <vector4>:
.globl vector4
vector4:
  pushl $0
80105e29:	6a 00                	push   $0x0
  pushl $4
80105e2b:	6a 04                	push   $0x4
  jmp alltraps
80105e2d:	e9 e8 fa ff ff       	jmp    8010591a <alltraps>

80105e32 <vector5>:
.globl vector5
vector5:
  pushl $0
80105e32:	6a 00                	push   $0x0
  pushl $5
80105e34:	6a 05                	push   $0x5
  jmp alltraps
80105e36:	e9 df fa ff ff       	jmp    8010591a <alltraps>

80105e3b <vector6>:
.globl vector6
vector6:
  pushl $0
80105e3b:	6a 00                	push   $0x0
  pushl $6
80105e3d:	6a 06                	push   $0x6
  jmp alltraps
80105e3f:	e9 d6 fa ff ff       	jmp    8010591a <alltraps>

80105e44 <vector7>:
.globl vector7
vector7:
  pushl $0
80105e44:	6a 00                	push   $0x0
  pushl $7
80105e46:	6a 07                	push   $0x7
  jmp alltraps
80105e48:	e9 cd fa ff ff       	jmp    8010591a <alltraps>

80105e4d <vector8>:
.globl vector8
vector8:
  pushl $8
80105e4d:	6a 08                	push   $0x8
  jmp alltraps
80105e4f:	e9 c6 fa ff ff       	jmp    8010591a <alltraps>

80105e54 <vector9>:
.globl vector9
vector9:
  pushl $0
80105e54:	6a 00                	push   $0x0
  pushl $9
80105e56:	6a 09                	push   $0x9
  jmp alltraps
80105e58:	e9 bd fa ff ff       	jmp    8010591a <alltraps>

80105e5d <vector10>:
.globl vector10
vector10:
  pushl $10
80105e5d:	6a 0a                	push   $0xa
  jmp alltraps
80105e5f:	e9 b6 fa ff ff       	jmp    8010591a <alltraps>

80105e64 <vector11>:
.globl vector11
vector11:
  pushl $11
80105e64:	6a 0b                	push   $0xb
  jmp alltraps
80105e66:	e9 af fa ff ff       	jmp    8010591a <alltraps>

80105e6b <vector12>:
.globl vector12
vector12:
  pushl $12
80105e6b:	6a 0c                	push   $0xc
  jmp alltraps
80105e6d:	e9 a8 fa ff ff       	jmp    8010591a <alltraps>

80105e72 <vector13>:
.globl vector13
vector13:
  pushl $13
80105e72:	6a 0d                	push   $0xd
  jmp alltraps
80105e74:	e9 a1 fa ff ff       	jmp    8010591a <alltraps>

80105e79 <vector14>:
.globl vector14
vector14:
  pushl $14
80105e79:	6a 0e                	push   $0xe
  jmp alltraps
80105e7b:	e9 9a fa ff ff       	jmp    8010591a <alltraps>

80105e80 <vector15>:
.globl vector15
vector15:
  pushl $0
80105e80:	6a 00                	push   $0x0
  pushl $15
80105e82:	6a 0f                	push   $0xf
  jmp alltraps
80105e84:	e9 91 fa ff ff       	jmp    8010591a <alltraps>

80105e89 <vector16>:
.globl vector16
vector16:
  pushl $0
80105e89:	6a 00                	push   $0x0
  pushl $16
80105e8b:	6a 10                	push   $0x10
  jmp alltraps
80105e8d:	e9 88 fa ff ff       	jmp    8010591a <alltraps>

80105e92 <vector17>:
.globl vector17
vector17:
  pushl $17
80105e92:	6a 11                	push   $0x11
  jmp alltraps
80105e94:	e9 81 fa ff ff       	jmp    8010591a <alltraps>

80105e99 <vector18>:
.globl vector18
vector18:
  pushl $0
80105e99:	6a 00                	push   $0x0
  pushl $18
80105e9b:	6a 12                	push   $0x12
  jmp alltraps
80105e9d:	e9 78 fa ff ff       	jmp    8010591a <alltraps>

80105ea2 <vector19>:
.globl vector19
vector19:
  pushl $0
80105ea2:	6a 00                	push   $0x0
  pushl $19
80105ea4:	6a 13                	push   $0x13
  jmp alltraps
80105ea6:	e9 6f fa ff ff       	jmp    8010591a <alltraps>

80105eab <vector20>:
.globl vector20
vector20:
  pushl $0
80105eab:	6a 00                	push   $0x0
  pushl $20
80105ead:	6a 14                	push   $0x14
  jmp alltraps
80105eaf:	e9 66 fa ff ff       	jmp    8010591a <alltraps>

80105eb4 <vector21>:
.globl vector21
vector21:
  pushl $0
80105eb4:	6a 00                	push   $0x0
  pushl $21
80105eb6:	6a 15                	push   $0x15
  jmp alltraps
80105eb8:	e9 5d fa ff ff       	jmp    8010591a <alltraps>

80105ebd <vector22>:
.globl vector22
vector22:
  pushl $0
80105ebd:	6a 00                	push   $0x0
  pushl $22
80105ebf:	6a 16                	push   $0x16
  jmp alltraps
80105ec1:	e9 54 fa ff ff       	jmp    8010591a <alltraps>

80105ec6 <vector23>:
.globl vector23
vector23:
  pushl $0
80105ec6:	6a 00                	push   $0x0
  pushl $23
80105ec8:	6a 17                	push   $0x17
  jmp alltraps
80105eca:	e9 4b fa ff ff       	jmp    8010591a <alltraps>

80105ecf <vector24>:
.globl vector24
vector24:
  pushl $0
80105ecf:	6a 00                	push   $0x0
  pushl $24
80105ed1:	6a 18                	push   $0x18
  jmp alltraps
80105ed3:	e9 42 fa ff ff       	jmp    8010591a <alltraps>

80105ed8 <vector25>:
.globl vector25
vector25:
  pushl $0
80105ed8:	6a 00                	push   $0x0
  pushl $25
80105eda:	6a 19                	push   $0x19
  jmp alltraps
80105edc:	e9 39 fa ff ff       	jmp    8010591a <alltraps>

80105ee1 <vector26>:
.globl vector26
vector26:
  pushl $0
80105ee1:	6a 00                	push   $0x0
  pushl $26
80105ee3:	6a 1a                	push   $0x1a
  jmp alltraps
80105ee5:	e9 30 fa ff ff       	jmp    8010591a <alltraps>

80105eea <vector27>:
.globl vector27
vector27:
  pushl $0
80105eea:	6a 00                	push   $0x0
  pushl $27
80105eec:	6a 1b                	push   $0x1b
  jmp alltraps
80105eee:	e9 27 fa ff ff       	jmp    8010591a <alltraps>

80105ef3 <vector28>:
.globl vector28
vector28:
  pushl $0
80105ef3:	6a 00                	push   $0x0
  pushl $28
80105ef5:	6a 1c                	push   $0x1c
  jmp alltraps
80105ef7:	e9 1e fa ff ff       	jmp    8010591a <alltraps>

80105efc <vector29>:
.globl vector29
vector29:
  pushl $0
80105efc:	6a 00                	push   $0x0
  pushl $29
80105efe:	6a 1d                	push   $0x1d
  jmp alltraps
80105f00:	e9 15 fa ff ff       	jmp    8010591a <alltraps>

80105f05 <vector30>:
.globl vector30
vector30:
  pushl $0
80105f05:	6a 00                	push   $0x0
  pushl $30
80105f07:	6a 1e                	push   $0x1e
  jmp alltraps
80105f09:	e9 0c fa ff ff       	jmp    8010591a <alltraps>

80105f0e <vector31>:
.globl vector31
vector31:
  pushl $0
80105f0e:	6a 00                	push   $0x0
  pushl $31
80105f10:	6a 1f                	push   $0x1f
  jmp alltraps
80105f12:	e9 03 fa ff ff       	jmp    8010591a <alltraps>

80105f17 <vector32>:
.globl vector32
vector32:
  pushl $0
80105f17:	6a 00                	push   $0x0
  pushl $32
80105f19:	6a 20                	push   $0x20
  jmp alltraps
80105f1b:	e9 fa f9 ff ff       	jmp    8010591a <alltraps>

80105f20 <vector33>:
.globl vector33
vector33:
  pushl $0
80105f20:	6a 00                	push   $0x0
  pushl $33
80105f22:	6a 21                	push   $0x21
  jmp alltraps
80105f24:	e9 f1 f9 ff ff       	jmp    8010591a <alltraps>

80105f29 <vector34>:
.globl vector34
vector34:
  pushl $0
80105f29:	6a 00                	push   $0x0
  pushl $34
80105f2b:	6a 22                	push   $0x22
  jmp alltraps
80105f2d:	e9 e8 f9 ff ff       	jmp    8010591a <alltraps>

80105f32 <vector35>:
.globl vector35
vector35:
  pushl $0
80105f32:	6a 00                	push   $0x0
  pushl $35
80105f34:	6a 23                	push   $0x23
  jmp alltraps
80105f36:	e9 df f9 ff ff       	jmp    8010591a <alltraps>

80105f3b <vector36>:
.globl vector36
vector36:
  pushl $0
80105f3b:	6a 00                	push   $0x0
  pushl $36
80105f3d:	6a 24                	push   $0x24
  jmp alltraps
80105f3f:	e9 d6 f9 ff ff       	jmp    8010591a <alltraps>

80105f44 <vector37>:
.globl vector37
vector37:
  pushl $0
80105f44:	6a 00                	push   $0x0
  pushl $37
80105f46:	6a 25                	push   $0x25
  jmp alltraps
80105f48:	e9 cd f9 ff ff       	jmp    8010591a <alltraps>

80105f4d <vector38>:
.globl vector38
vector38:
  pushl $0
80105f4d:	6a 00                	push   $0x0
  pushl $38
80105f4f:	6a 26                	push   $0x26
  jmp alltraps
80105f51:	e9 c4 f9 ff ff       	jmp    8010591a <alltraps>

80105f56 <vector39>:
.globl vector39
vector39:
  pushl $0
80105f56:	6a 00                	push   $0x0
  pushl $39
80105f58:	6a 27                	push   $0x27
  jmp alltraps
80105f5a:	e9 bb f9 ff ff       	jmp    8010591a <alltraps>

80105f5f <vector40>:
.globl vector40
vector40:
  pushl $0
80105f5f:	6a 00                	push   $0x0
  pushl $40
80105f61:	6a 28                	push   $0x28
  jmp alltraps
80105f63:	e9 b2 f9 ff ff       	jmp    8010591a <alltraps>

80105f68 <vector41>:
.globl vector41
vector41:
  pushl $0
80105f68:	6a 00                	push   $0x0
  pushl $41
80105f6a:	6a 29                	push   $0x29
  jmp alltraps
80105f6c:	e9 a9 f9 ff ff       	jmp    8010591a <alltraps>

80105f71 <vector42>:
.globl vector42
vector42:
  pushl $0
80105f71:	6a 00                	push   $0x0
  pushl $42
80105f73:	6a 2a                	push   $0x2a
  jmp alltraps
80105f75:	e9 a0 f9 ff ff       	jmp    8010591a <alltraps>

80105f7a <vector43>:
.globl vector43
vector43:
  pushl $0
80105f7a:	6a 00                	push   $0x0
  pushl $43
80105f7c:	6a 2b                	push   $0x2b
  jmp alltraps
80105f7e:	e9 97 f9 ff ff       	jmp    8010591a <alltraps>

80105f83 <vector44>:
.globl vector44
vector44:
  pushl $0
80105f83:	6a 00                	push   $0x0
  pushl $44
80105f85:	6a 2c                	push   $0x2c
  jmp alltraps
80105f87:	e9 8e f9 ff ff       	jmp    8010591a <alltraps>

80105f8c <vector45>:
.globl vector45
vector45:
  pushl $0
80105f8c:	6a 00                	push   $0x0
  pushl $45
80105f8e:	6a 2d                	push   $0x2d
  jmp alltraps
80105f90:	e9 85 f9 ff ff       	jmp    8010591a <alltraps>

80105f95 <vector46>:
.globl vector46
vector46:
  pushl $0
80105f95:	6a 00                	push   $0x0
  pushl $46
80105f97:	6a 2e                	push   $0x2e
  jmp alltraps
80105f99:	e9 7c f9 ff ff       	jmp    8010591a <alltraps>

80105f9e <vector47>:
.globl vector47
vector47:
  pushl $0
80105f9e:	6a 00                	push   $0x0
  pushl $47
80105fa0:	6a 2f                	push   $0x2f
  jmp alltraps
80105fa2:	e9 73 f9 ff ff       	jmp    8010591a <alltraps>

80105fa7 <vector48>:
.globl vector48
vector48:
  pushl $0
80105fa7:	6a 00                	push   $0x0
  pushl $48
80105fa9:	6a 30                	push   $0x30
  jmp alltraps
80105fab:	e9 6a f9 ff ff       	jmp    8010591a <alltraps>

80105fb0 <vector49>:
.globl vector49
vector49:
  pushl $0
80105fb0:	6a 00                	push   $0x0
  pushl $49
80105fb2:	6a 31                	push   $0x31
  jmp alltraps
80105fb4:	e9 61 f9 ff ff       	jmp    8010591a <alltraps>

80105fb9 <vector50>:
.globl vector50
vector50:
  pushl $0
80105fb9:	6a 00                	push   $0x0
  pushl $50
80105fbb:	6a 32                	push   $0x32
  jmp alltraps
80105fbd:	e9 58 f9 ff ff       	jmp    8010591a <alltraps>

80105fc2 <vector51>:
.globl vector51
vector51:
  pushl $0
80105fc2:	6a 00                	push   $0x0
  pushl $51
80105fc4:	6a 33                	push   $0x33
  jmp alltraps
80105fc6:	e9 4f f9 ff ff       	jmp    8010591a <alltraps>

80105fcb <vector52>:
.globl vector52
vector52:
  pushl $0
80105fcb:	6a 00                	push   $0x0
  pushl $52
80105fcd:	6a 34                	push   $0x34
  jmp alltraps
80105fcf:	e9 46 f9 ff ff       	jmp    8010591a <alltraps>

80105fd4 <vector53>:
.globl vector53
vector53:
  pushl $0
80105fd4:	6a 00                	push   $0x0
  pushl $53
80105fd6:	6a 35                	push   $0x35
  jmp alltraps
80105fd8:	e9 3d f9 ff ff       	jmp    8010591a <alltraps>

80105fdd <vector54>:
.globl vector54
vector54:
  pushl $0
80105fdd:	6a 00                	push   $0x0
  pushl $54
80105fdf:	6a 36                	push   $0x36
  jmp alltraps
80105fe1:	e9 34 f9 ff ff       	jmp    8010591a <alltraps>

80105fe6 <vector55>:
.globl vector55
vector55:
  pushl $0
80105fe6:	6a 00                	push   $0x0
  pushl $55
80105fe8:	6a 37                	push   $0x37
  jmp alltraps
80105fea:	e9 2b f9 ff ff       	jmp    8010591a <alltraps>

80105fef <vector56>:
.globl vector56
vector56:
  pushl $0
80105fef:	6a 00                	push   $0x0
  pushl $56
80105ff1:	6a 38                	push   $0x38
  jmp alltraps
80105ff3:	e9 22 f9 ff ff       	jmp    8010591a <alltraps>

80105ff8 <vector57>:
.globl vector57
vector57:
  pushl $0
80105ff8:	6a 00                	push   $0x0
  pushl $57
80105ffa:	6a 39                	push   $0x39
  jmp alltraps
80105ffc:	e9 19 f9 ff ff       	jmp    8010591a <alltraps>

80106001 <vector58>:
.globl vector58
vector58:
  pushl $0
80106001:	6a 00                	push   $0x0
  pushl $58
80106003:	6a 3a                	push   $0x3a
  jmp alltraps
80106005:	e9 10 f9 ff ff       	jmp    8010591a <alltraps>

8010600a <vector59>:
.globl vector59
vector59:
  pushl $0
8010600a:	6a 00                	push   $0x0
  pushl $59
8010600c:	6a 3b                	push   $0x3b
  jmp alltraps
8010600e:	e9 07 f9 ff ff       	jmp    8010591a <alltraps>

80106013 <vector60>:
.globl vector60
vector60:
  pushl $0
80106013:	6a 00                	push   $0x0
  pushl $60
80106015:	6a 3c                	push   $0x3c
  jmp alltraps
80106017:	e9 fe f8 ff ff       	jmp    8010591a <alltraps>

8010601c <vector61>:
.globl vector61
vector61:
  pushl $0
8010601c:	6a 00                	push   $0x0
  pushl $61
8010601e:	6a 3d                	push   $0x3d
  jmp alltraps
80106020:	e9 f5 f8 ff ff       	jmp    8010591a <alltraps>

80106025 <vector62>:
.globl vector62
vector62:
  pushl $0
80106025:	6a 00                	push   $0x0
  pushl $62
80106027:	6a 3e                	push   $0x3e
  jmp alltraps
80106029:	e9 ec f8 ff ff       	jmp    8010591a <alltraps>

8010602e <vector63>:
.globl vector63
vector63:
  pushl $0
8010602e:	6a 00                	push   $0x0
  pushl $63
80106030:	6a 3f                	push   $0x3f
  jmp alltraps
80106032:	e9 e3 f8 ff ff       	jmp    8010591a <alltraps>

80106037 <vector64>:
.globl vector64
vector64:
  pushl $0
80106037:	6a 00                	push   $0x0
  pushl $64
80106039:	6a 40                	push   $0x40
  jmp alltraps
8010603b:	e9 da f8 ff ff       	jmp    8010591a <alltraps>

80106040 <vector65>:
.globl vector65
vector65:
  pushl $0
80106040:	6a 00                	push   $0x0
  pushl $65
80106042:	6a 41                	push   $0x41
  jmp alltraps
80106044:	e9 d1 f8 ff ff       	jmp    8010591a <alltraps>

80106049 <vector66>:
.globl vector66
vector66:
  pushl $0
80106049:	6a 00                	push   $0x0
  pushl $66
8010604b:	6a 42                	push   $0x42
  jmp alltraps
8010604d:	e9 c8 f8 ff ff       	jmp    8010591a <alltraps>

80106052 <vector67>:
.globl vector67
vector67:
  pushl $0
80106052:	6a 00                	push   $0x0
  pushl $67
80106054:	6a 43                	push   $0x43
  jmp alltraps
80106056:	e9 bf f8 ff ff       	jmp    8010591a <alltraps>

8010605b <vector68>:
.globl vector68
vector68:
  pushl $0
8010605b:	6a 00                	push   $0x0
  pushl $68
8010605d:	6a 44                	push   $0x44
  jmp alltraps
8010605f:	e9 b6 f8 ff ff       	jmp    8010591a <alltraps>

80106064 <vector69>:
.globl vector69
vector69:
  pushl $0
80106064:	6a 00                	push   $0x0
  pushl $69
80106066:	6a 45                	push   $0x45
  jmp alltraps
80106068:	e9 ad f8 ff ff       	jmp    8010591a <alltraps>

8010606d <vector70>:
.globl vector70
vector70:
  pushl $0
8010606d:	6a 00                	push   $0x0
  pushl $70
8010606f:	6a 46                	push   $0x46
  jmp alltraps
80106071:	e9 a4 f8 ff ff       	jmp    8010591a <alltraps>

80106076 <vector71>:
.globl vector71
vector71:
  pushl $0
80106076:	6a 00                	push   $0x0
  pushl $71
80106078:	6a 47                	push   $0x47
  jmp alltraps
8010607a:	e9 9b f8 ff ff       	jmp    8010591a <alltraps>

8010607f <vector72>:
.globl vector72
vector72:
  pushl $0
8010607f:	6a 00                	push   $0x0
  pushl $72
80106081:	6a 48                	push   $0x48
  jmp alltraps
80106083:	e9 92 f8 ff ff       	jmp    8010591a <alltraps>

80106088 <vector73>:
.globl vector73
vector73:
  pushl $0
80106088:	6a 00                	push   $0x0
  pushl $73
8010608a:	6a 49                	push   $0x49
  jmp alltraps
8010608c:	e9 89 f8 ff ff       	jmp    8010591a <alltraps>

80106091 <vector74>:
.globl vector74
vector74:
  pushl $0
80106091:	6a 00                	push   $0x0
  pushl $74
80106093:	6a 4a                	push   $0x4a
  jmp alltraps
80106095:	e9 80 f8 ff ff       	jmp    8010591a <alltraps>

8010609a <vector75>:
.globl vector75
vector75:
  pushl $0
8010609a:	6a 00                	push   $0x0
  pushl $75
8010609c:	6a 4b                	push   $0x4b
  jmp alltraps
8010609e:	e9 77 f8 ff ff       	jmp    8010591a <alltraps>

801060a3 <vector76>:
.globl vector76
vector76:
  pushl $0
801060a3:	6a 00                	push   $0x0
  pushl $76
801060a5:	6a 4c                	push   $0x4c
  jmp alltraps
801060a7:	e9 6e f8 ff ff       	jmp    8010591a <alltraps>

801060ac <vector77>:
.globl vector77
vector77:
  pushl $0
801060ac:	6a 00                	push   $0x0
  pushl $77
801060ae:	6a 4d                	push   $0x4d
  jmp alltraps
801060b0:	e9 65 f8 ff ff       	jmp    8010591a <alltraps>

801060b5 <vector78>:
.globl vector78
vector78:
  pushl $0
801060b5:	6a 00                	push   $0x0
  pushl $78
801060b7:	6a 4e                	push   $0x4e
  jmp alltraps
801060b9:	e9 5c f8 ff ff       	jmp    8010591a <alltraps>

801060be <vector79>:
.globl vector79
vector79:
  pushl $0
801060be:	6a 00                	push   $0x0
  pushl $79
801060c0:	6a 4f                	push   $0x4f
  jmp alltraps
801060c2:	e9 53 f8 ff ff       	jmp    8010591a <alltraps>

801060c7 <vector80>:
.globl vector80
vector80:
  pushl $0
801060c7:	6a 00                	push   $0x0
  pushl $80
801060c9:	6a 50                	push   $0x50
  jmp alltraps
801060cb:	e9 4a f8 ff ff       	jmp    8010591a <alltraps>

801060d0 <vector81>:
.globl vector81
vector81:
  pushl $0
801060d0:	6a 00                	push   $0x0
  pushl $81
801060d2:	6a 51                	push   $0x51
  jmp alltraps
801060d4:	e9 41 f8 ff ff       	jmp    8010591a <alltraps>

801060d9 <vector82>:
.globl vector82
vector82:
  pushl $0
801060d9:	6a 00                	push   $0x0
  pushl $82
801060db:	6a 52                	push   $0x52
  jmp alltraps
801060dd:	e9 38 f8 ff ff       	jmp    8010591a <alltraps>

801060e2 <vector83>:
.globl vector83
vector83:
  pushl $0
801060e2:	6a 00                	push   $0x0
  pushl $83
801060e4:	6a 53                	push   $0x53
  jmp alltraps
801060e6:	e9 2f f8 ff ff       	jmp    8010591a <alltraps>

801060eb <vector84>:
.globl vector84
vector84:
  pushl $0
801060eb:	6a 00                	push   $0x0
  pushl $84
801060ed:	6a 54                	push   $0x54
  jmp alltraps
801060ef:	e9 26 f8 ff ff       	jmp    8010591a <alltraps>

801060f4 <vector85>:
.globl vector85
vector85:
  pushl $0
801060f4:	6a 00                	push   $0x0
  pushl $85
801060f6:	6a 55                	push   $0x55
  jmp alltraps
801060f8:	e9 1d f8 ff ff       	jmp    8010591a <alltraps>

801060fd <vector86>:
.globl vector86
vector86:
  pushl $0
801060fd:	6a 00                	push   $0x0
  pushl $86
801060ff:	6a 56                	push   $0x56
  jmp alltraps
80106101:	e9 14 f8 ff ff       	jmp    8010591a <alltraps>

80106106 <vector87>:
.globl vector87
vector87:
  pushl $0
80106106:	6a 00                	push   $0x0
  pushl $87
80106108:	6a 57                	push   $0x57
  jmp alltraps
8010610a:	e9 0b f8 ff ff       	jmp    8010591a <alltraps>

8010610f <vector88>:
.globl vector88
vector88:
  pushl $0
8010610f:	6a 00                	push   $0x0
  pushl $88
80106111:	6a 58                	push   $0x58
  jmp alltraps
80106113:	e9 02 f8 ff ff       	jmp    8010591a <alltraps>

80106118 <vector89>:
.globl vector89
vector89:
  pushl $0
80106118:	6a 00                	push   $0x0
  pushl $89
8010611a:	6a 59                	push   $0x59
  jmp alltraps
8010611c:	e9 f9 f7 ff ff       	jmp    8010591a <alltraps>

80106121 <vector90>:
.globl vector90
vector90:
  pushl $0
80106121:	6a 00                	push   $0x0
  pushl $90
80106123:	6a 5a                	push   $0x5a
  jmp alltraps
80106125:	e9 f0 f7 ff ff       	jmp    8010591a <alltraps>

8010612a <vector91>:
.globl vector91
vector91:
  pushl $0
8010612a:	6a 00                	push   $0x0
  pushl $91
8010612c:	6a 5b                	push   $0x5b
  jmp alltraps
8010612e:	e9 e7 f7 ff ff       	jmp    8010591a <alltraps>

80106133 <vector92>:
.globl vector92
vector92:
  pushl $0
80106133:	6a 00                	push   $0x0
  pushl $92
80106135:	6a 5c                	push   $0x5c
  jmp alltraps
80106137:	e9 de f7 ff ff       	jmp    8010591a <alltraps>

8010613c <vector93>:
.globl vector93
vector93:
  pushl $0
8010613c:	6a 00                	push   $0x0
  pushl $93
8010613e:	6a 5d                	push   $0x5d
  jmp alltraps
80106140:	e9 d5 f7 ff ff       	jmp    8010591a <alltraps>

80106145 <vector94>:
.globl vector94
vector94:
  pushl $0
80106145:	6a 00                	push   $0x0
  pushl $94
80106147:	6a 5e                	push   $0x5e
  jmp alltraps
80106149:	e9 cc f7 ff ff       	jmp    8010591a <alltraps>

8010614e <vector95>:
.globl vector95
vector95:
  pushl $0
8010614e:	6a 00                	push   $0x0
  pushl $95
80106150:	6a 5f                	push   $0x5f
  jmp alltraps
80106152:	e9 c3 f7 ff ff       	jmp    8010591a <alltraps>

80106157 <vector96>:
.globl vector96
vector96:
  pushl $0
80106157:	6a 00                	push   $0x0
  pushl $96
80106159:	6a 60                	push   $0x60
  jmp alltraps
8010615b:	e9 ba f7 ff ff       	jmp    8010591a <alltraps>

80106160 <vector97>:
.globl vector97
vector97:
  pushl $0
80106160:	6a 00                	push   $0x0
  pushl $97
80106162:	6a 61                	push   $0x61
  jmp alltraps
80106164:	e9 b1 f7 ff ff       	jmp    8010591a <alltraps>

80106169 <vector98>:
.globl vector98
vector98:
  pushl $0
80106169:	6a 00                	push   $0x0
  pushl $98
8010616b:	6a 62                	push   $0x62
  jmp alltraps
8010616d:	e9 a8 f7 ff ff       	jmp    8010591a <alltraps>

80106172 <vector99>:
.globl vector99
vector99:
  pushl $0
80106172:	6a 00                	push   $0x0
  pushl $99
80106174:	6a 63                	push   $0x63
  jmp alltraps
80106176:	e9 9f f7 ff ff       	jmp    8010591a <alltraps>

8010617b <vector100>:
.globl vector100
vector100:
  pushl $0
8010617b:	6a 00                	push   $0x0
  pushl $100
8010617d:	6a 64                	push   $0x64
  jmp alltraps
8010617f:	e9 96 f7 ff ff       	jmp    8010591a <alltraps>

80106184 <vector101>:
.globl vector101
vector101:
  pushl $0
80106184:	6a 00                	push   $0x0
  pushl $101
80106186:	6a 65                	push   $0x65
  jmp alltraps
80106188:	e9 8d f7 ff ff       	jmp    8010591a <alltraps>

8010618d <vector102>:
.globl vector102
vector102:
  pushl $0
8010618d:	6a 00                	push   $0x0
  pushl $102
8010618f:	6a 66                	push   $0x66
  jmp alltraps
80106191:	e9 84 f7 ff ff       	jmp    8010591a <alltraps>

80106196 <vector103>:
.globl vector103
vector103:
  pushl $0
80106196:	6a 00                	push   $0x0
  pushl $103
80106198:	6a 67                	push   $0x67
  jmp alltraps
8010619a:	e9 7b f7 ff ff       	jmp    8010591a <alltraps>

8010619f <vector104>:
.globl vector104
vector104:
  pushl $0
8010619f:	6a 00                	push   $0x0
  pushl $104
801061a1:	6a 68                	push   $0x68
  jmp alltraps
801061a3:	e9 72 f7 ff ff       	jmp    8010591a <alltraps>

801061a8 <vector105>:
.globl vector105
vector105:
  pushl $0
801061a8:	6a 00                	push   $0x0
  pushl $105
801061aa:	6a 69                	push   $0x69
  jmp alltraps
801061ac:	e9 69 f7 ff ff       	jmp    8010591a <alltraps>

801061b1 <vector106>:
.globl vector106
vector106:
  pushl $0
801061b1:	6a 00                	push   $0x0
  pushl $106
801061b3:	6a 6a                	push   $0x6a
  jmp alltraps
801061b5:	e9 60 f7 ff ff       	jmp    8010591a <alltraps>

801061ba <vector107>:
.globl vector107
vector107:
  pushl $0
801061ba:	6a 00                	push   $0x0
  pushl $107
801061bc:	6a 6b                	push   $0x6b
  jmp alltraps
801061be:	e9 57 f7 ff ff       	jmp    8010591a <alltraps>

801061c3 <vector108>:
.globl vector108
vector108:
  pushl $0
801061c3:	6a 00                	push   $0x0
  pushl $108
801061c5:	6a 6c                	push   $0x6c
  jmp alltraps
801061c7:	e9 4e f7 ff ff       	jmp    8010591a <alltraps>

801061cc <vector109>:
.globl vector109
vector109:
  pushl $0
801061cc:	6a 00                	push   $0x0
  pushl $109
801061ce:	6a 6d                	push   $0x6d
  jmp alltraps
801061d0:	e9 45 f7 ff ff       	jmp    8010591a <alltraps>

801061d5 <vector110>:
.globl vector110
vector110:
  pushl $0
801061d5:	6a 00                	push   $0x0
  pushl $110
801061d7:	6a 6e                	push   $0x6e
  jmp alltraps
801061d9:	e9 3c f7 ff ff       	jmp    8010591a <alltraps>

801061de <vector111>:
.globl vector111
vector111:
  pushl $0
801061de:	6a 00                	push   $0x0
  pushl $111
801061e0:	6a 6f                	push   $0x6f
  jmp alltraps
801061e2:	e9 33 f7 ff ff       	jmp    8010591a <alltraps>

801061e7 <vector112>:
.globl vector112
vector112:
  pushl $0
801061e7:	6a 00                	push   $0x0
  pushl $112
801061e9:	6a 70                	push   $0x70
  jmp alltraps
801061eb:	e9 2a f7 ff ff       	jmp    8010591a <alltraps>

801061f0 <vector113>:
.globl vector113
vector113:
  pushl $0
801061f0:	6a 00                	push   $0x0
  pushl $113
801061f2:	6a 71                	push   $0x71
  jmp alltraps
801061f4:	e9 21 f7 ff ff       	jmp    8010591a <alltraps>

801061f9 <vector114>:
.globl vector114
vector114:
  pushl $0
801061f9:	6a 00                	push   $0x0
  pushl $114
801061fb:	6a 72                	push   $0x72
  jmp alltraps
801061fd:	e9 18 f7 ff ff       	jmp    8010591a <alltraps>

80106202 <vector115>:
.globl vector115
vector115:
  pushl $0
80106202:	6a 00                	push   $0x0
  pushl $115
80106204:	6a 73                	push   $0x73
  jmp alltraps
80106206:	e9 0f f7 ff ff       	jmp    8010591a <alltraps>

8010620b <vector116>:
.globl vector116
vector116:
  pushl $0
8010620b:	6a 00                	push   $0x0
  pushl $116
8010620d:	6a 74                	push   $0x74
  jmp alltraps
8010620f:	e9 06 f7 ff ff       	jmp    8010591a <alltraps>

80106214 <vector117>:
.globl vector117
vector117:
  pushl $0
80106214:	6a 00                	push   $0x0
  pushl $117
80106216:	6a 75                	push   $0x75
  jmp alltraps
80106218:	e9 fd f6 ff ff       	jmp    8010591a <alltraps>

8010621d <vector118>:
.globl vector118
vector118:
  pushl $0
8010621d:	6a 00                	push   $0x0
  pushl $118
8010621f:	6a 76                	push   $0x76
  jmp alltraps
80106221:	e9 f4 f6 ff ff       	jmp    8010591a <alltraps>

80106226 <vector119>:
.globl vector119
vector119:
  pushl $0
80106226:	6a 00                	push   $0x0
  pushl $119
80106228:	6a 77                	push   $0x77
  jmp alltraps
8010622a:	e9 eb f6 ff ff       	jmp    8010591a <alltraps>

8010622f <vector120>:
.globl vector120
vector120:
  pushl $0
8010622f:	6a 00                	push   $0x0
  pushl $120
80106231:	6a 78                	push   $0x78
  jmp alltraps
80106233:	e9 e2 f6 ff ff       	jmp    8010591a <alltraps>

80106238 <vector121>:
.globl vector121
vector121:
  pushl $0
80106238:	6a 00                	push   $0x0
  pushl $121
8010623a:	6a 79                	push   $0x79
  jmp alltraps
8010623c:	e9 d9 f6 ff ff       	jmp    8010591a <alltraps>

80106241 <vector122>:
.globl vector122
vector122:
  pushl $0
80106241:	6a 00                	push   $0x0
  pushl $122
80106243:	6a 7a                	push   $0x7a
  jmp alltraps
80106245:	e9 d0 f6 ff ff       	jmp    8010591a <alltraps>

8010624a <vector123>:
.globl vector123
vector123:
  pushl $0
8010624a:	6a 00                	push   $0x0
  pushl $123
8010624c:	6a 7b                	push   $0x7b
  jmp alltraps
8010624e:	e9 c7 f6 ff ff       	jmp    8010591a <alltraps>

80106253 <vector124>:
.globl vector124
vector124:
  pushl $0
80106253:	6a 00                	push   $0x0
  pushl $124
80106255:	6a 7c                	push   $0x7c
  jmp alltraps
80106257:	e9 be f6 ff ff       	jmp    8010591a <alltraps>

8010625c <vector125>:
.globl vector125
vector125:
  pushl $0
8010625c:	6a 00                	push   $0x0
  pushl $125
8010625e:	6a 7d                	push   $0x7d
  jmp alltraps
80106260:	e9 b5 f6 ff ff       	jmp    8010591a <alltraps>

80106265 <vector126>:
.globl vector126
vector126:
  pushl $0
80106265:	6a 00                	push   $0x0
  pushl $126
80106267:	6a 7e                	push   $0x7e
  jmp alltraps
80106269:	e9 ac f6 ff ff       	jmp    8010591a <alltraps>

8010626e <vector127>:
.globl vector127
vector127:
  pushl $0
8010626e:	6a 00                	push   $0x0
  pushl $127
80106270:	6a 7f                	push   $0x7f
  jmp alltraps
80106272:	e9 a3 f6 ff ff       	jmp    8010591a <alltraps>

80106277 <vector128>:
.globl vector128
vector128:
  pushl $0
80106277:	6a 00                	push   $0x0
  pushl $128
80106279:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010627e:	e9 97 f6 ff ff       	jmp    8010591a <alltraps>

80106283 <vector129>:
.globl vector129
vector129:
  pushl $0
80106283:	6a 00                	push   $0x0
  pushl $129
80106285:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010628a:	e9 8b f6 ff ff       	jmp    8010591a <alltraps>

8010628f <vector130>:
.globl vector130
vector130:
  pushl $0
8010628f:	6a 00                	push   $0x0
  pushl $130
80106291:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106296:	e9 7f f6 ff ff       	jmp    8010591a <alltraps>

8010629b <vector131>:
.globl vector131
vector131:
  pushl $0
8010629b:	6a 00                	push   $0x0
  pushl $131
8010629d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801062a2:	e9 73 f6 ff ff       	jmp    8010591a <alltraps>

801062a7 <vector132>:
.globl vector132
vector132:
  pushl $0
801062a7:	6a 00                	push   $0x0
  pushl $132
801062a9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801062ae:	e9 67 f6 ff ff       	jmp    8010591a <alltraps>

801062b3 <vector133>:
.globl vector133
vector133:
  pushl $0
801062b3:	6a 00                	push   $0x0
  pushl $133
801062b5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801062ba:	e9 5b f6 ff ff       	jmp    8010591a <alltraps>

801062bf <vector134>:
.globl vector134
vector134:
  pushl $0
801062bf:	6a 00                	push   $0x0
  pushl $134
801062c1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801062c6:	e9 4f f6 ff ff       	jmp    8010591a <alltraps>

801062cb <vector135>:
.globl vector135
vector135:
  pushl $0
801062cb:	6a 00                	push   $0x0
  pushl $135
801062cd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801062d2:	e9 43 f6 ff ff       	jmp    8010591a <alltraps>

801062d7 <vector136>:
.globl vector136
vector136:
  pushl $0
801062d7:	6a 00                	push   $0x0
  pushl $136
801062d9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801062de:	e9 37 f6 ff ff       	jmp    8010591a <alltraps>

801062e3 <vector137>:
.globl vector137
vector137:
  pushl $0
801062e3:	6a 00                	push   $0x0
  pushl $137
801062e5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801062ea:	e9 2b f6 ff ff       	jmp    8010591a <alltraps>

801062ef <vector138>:
.globl vector138
vector138:
  pushl $0
801062ef:	6a 00                	push   $0x0
  pushl $138
801062f1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801062f6:	e9 1f f6 ff ff       	jmp    8010591a <alltraps>

801062fb <vector139>:
.globl vector139
vector139:
  pushl $0
801062fb:	6a 00                	push   $0x0
  pushl $139
801062fd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106302:	e9 13 f6 ff ff       	jmp    8010591a <alltraps>

80106307 <vector140>:
.globl vector140
vector140:
  pushl $0
80106307:	6a 00                	push   $0x0
  pushl $140
80106309:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010630e:	e9 07 f6 ff ff       	jmp    8010591a <alltraps>

80106313 <vector141>:
.globl vector141
vector141:
  pushl $0
80106313:	6a 00                	push   $0x0
  pushl $141
80106315:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010631a:	e9 fb f5 ff ff       	jmp    8010591a <alltraps>

8010631f <vector142>:
.globl vector142
vector142:
  pushl $0
8010631f:	6a 00                	push   $0x0
  pushl $142
80106321:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106326:	e9 ef f5 ff ff       	jmp    8010591a <alltraps>

8010632b <vector143>:
.globl vector143
vector143:
  pushl $0
8010632b:	6a 00                	push   $0x0
  pushl $143
8010632d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106332:	e9 e3 f5 ff ff       	jmp    8010591a <alltraps>

80106337 <vector144>:
.globl vector144
vector144:
  pushl $0
80106337:	6a 00                	push   $0x0
  pushl $144
80106339:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010633e:	e9 d7 f5 ff ff       	jmp    8010591a <alltraps>

80106343 <vector145>:
.globl vector145
vector145:
  pushl $0
80106343:	6a 00                	push   $0x0
  pushl $145
80106345:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010634a:	e9 cb f5 ff ff       	jmp    8010591a <alltraps>

8010634f <vector146>:
.globl vector146
vector146:
  pushl $0
8010634f:	6a 00                	push   $0x0
  pushl $146
80106351:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106356:	e9 bf f5 ff ff       	jmp    8010591a <alltraps>

8010635b <vector147>:
.globl vector147
vector147:
  pushl $0
8010635b:	6a 00                	push   $0x0
  pushl $147
8010635d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106362:	e9 b3 f5 ff ff       	jmp    8010591a <alltraps>

80106367 <vector148>:
.globl vector148
vector148:
  pushl $0
80106367:	6a 00                	push   $0x0
  pushl $148
80106369:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010636e:	e9 a7 f5 ff ff       	jmp    8010591a <alltraps>

80106373 <vector149>:
.globl vector149
vector149:
  pushl $0
80106373:	6a 00                	push   $0x0
  pushl $149
80106375:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010637a:	e9 9b f5 ff ff       	jmp    8010591a <alltraps>

8010637f <vector150>:
.globl vector150
vector150:
  pushl $0
8010637f:	6a 00                	push   $0x0
  pushl $150
80106381:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106386:	e9 8f f5 ff ff       	jmp    8010591a <alltraps>

8010638b <vector151>:
.globl vector151
vector151:
  pushl $0
8010638b:	6a 00                	push   $0x0
  pushl $151
8010638d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106392:	e9 83 f5 ff ff       	jmp    8010591a <alltraps>

80106397 <vector152>:
.globl vector152
vector152:
  pushl $0
80106397:	6a 00                	push   $0x0
  pushl $152
80106399:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010639e:	e9 77 f5 ff ff       	jmp    8010591a <alltraps>

801063a3 <vector153>:
.globl vector153
vector153:
  pushl $0
801063a3:	6a 00                	push   $0x0
  pushl $153
801063a5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801063aa:	e9 6b f5 ff ff       	jmp    8010591a <alltraps>

801063af <vector154>:
.globl vector154
vector154:
  pushl $0
801063af:	6a 00                	push   $0x0
  pushl $154
801063b1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801063b6:	e9 5f f5 ff ff       	jmp    8010591a <alltraps>

801063bb <vector155>:
.globl vector155
vector155:
  pushl $0
801063bb:	6a 00                	push   $0x0
  pushl $155
801063bd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801063c2:	e9 53 f5 ff ff       	jmp    8010591a <alltraps>

801063c7 <vector156>:
.globl vector156
vector156:
  pushl $0
801063c7:	6a 00                	push   $0x0
  pushl $156
801063c9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801063ce:	e9 47 f5 ff ff       	jmp    8010591a <alltraps>

801063d3 <vector157>:
.globl vector157
vector157:
  pushl $0
801063d3:	6a 00                	push   $0x0
  pushl $157
801063d5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801063da:	e9 3b f5 ff ff       	jmp    8010591a <alltraps>

801063df <vector158>:
.globl vector158
vector158:
  pushl $0
801063df:	6a 00                	push   $0x0
  pushl $158
801063e1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801063e6:	e9 2f f5 ff ff       	jmp    8010591a <alltraps>

801063eb <vector159>:
.globl vector159
vector159:
  pushl $0
801063eb:	6a 00                	push   $0x0
  pushl $159
801063ed:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801063f2:	e9 23 f5 ff ff       	jmp    8010591a <alltraps>

801063f7 <vector160>:
.globl vector160
vector160:
  pushl $0
801063f7:	6a 00                	push   $0x0
  pushl $160
801063f9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801063fe:	e9 17 f5 ff ff       	jmp    8010591a <alltraps>

80106403 <vector161>:
.globl vector161
vector161:
  pushl $0
80106403:	6a 00                	push   $0x0
  pushl $161
80106405:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010640a:	e9 0b f5 ff ff       	jmp    8010591a <alltraps>

8010640f <vector162>:
.globl vector162
vector162:
  pushl $0
8010640f:	6a 00                	push   $0x0
  pushl $162
80106411:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106416:	e9 ff f4 ff ff       	jmp    8010591a <alltraps>

8010641b <vector163>:
.globl vector163
vector163:
  pushl $0
8010641b:	6a 00                	push   $0x0
  pushl $163
8010641d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106422:	e9 f3 f4 ff ff       	jmp    8010591a <alltraps>

80106427 <vector164>:
.globl vector164
vector164:
  pushl $0
80106427:	6a 00                	push   $0x0
  pushl $164
80106429:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010642e:	e9 e7 f4 ff ff       	jmp    8010591a <alltraps>

80106433 <vector165>:
.globl vector165
vector165:
  pushl $0
80106433:	6a 00                	push   $0x0
  pushl $165
80106435:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010643a:	e9 db f4 ff ff       	jmp    8010591a <alltraps>

8010643f <vector166>:
.globl vector166
vector166:
  pushl $0
8010643f:	6a 00                	push   $0x0
  pushl $166
80106441:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106446:	e9 cf f4 ff ff       	jmp    8010591a <alltraps>

8010644b <vector167>:
.globl vector167
vector167:
  pushl $0
8010644b:	6a 00                	push   $0x0
  pushl $167
8010644d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106452:	e9 c3 f4 ff ff       	jmp    8010591a <alltraps>

80106457 <vector168>:
.globl vector168
vector168:
  pushl $0
80106457:	6a 00                	push   $0x0
  pushl $168
80106459:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010645e:	e9 b7 f4 ff ff       	jmp    8010591a <alltraps>

80106463 <vector169>:
.globl vector169
vector169:
  pushl $0
80106463:	6a 00                	push   $0x0
  pushl $169
80106465:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010646a:	e9 ab f4 ff ff       	jmp    8010591a <alltraps>

8010646f <vector170>:
.globl vector170
vector170:
  pushl $0
8010646f:	6a 00                	push   $0x0
  pushl $170
80106471:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106476:	e9 9f f4 ff ff       	jmp    8010591a <alltraps>

8010647b <vector171>:
.globl vector171
vector171:
  pushl $0
8010647b:	6a 00                	push   $0x0
  pushl $171
8010647d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106482:	e9 93 f4 ff ff       	jmp    8010591a <alltraps>

80106487 <vector172>:
.globl vector172
vector172:
  pushl $0
80106487:	6a 00                	push   $0x0
  pushl $172
80106489:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010648e:	e9 87 f4 ff ff       	jmp    8010591a <alltraps>

80106493 <vector173>:
.globl vector173
vector173:
  pushl $0
80106493:	6a 00                	push   $0x0
  pushl $173
80106495:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010649a:	e9 7b f4 ff ff       	jmp    8010591a <alltraps>

8010649f <vector174>:
.globl vector174
vector174:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $174
801064a1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801064a6:	e9 6f f4 ff ff       	jmp    8010591a <alltraps>

801064ab <vector175>:
.globl vector175
vector175:
  pushl $0
801064ab:	6a 00                	push   $0x0
  pushl $175
801064ad:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801064b2:	e9 63 f4 ff ff       	jmp    8010591a <alltraps>

801064b7 <vector176>:
.globl vector176
vector176:
  pushl $0
801064b7:	6a 00                	push   $0x0
  pushl $176
801064b9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801064be:	e9 57 f4 ff ff       	jmp    8010591a <alltraps>

801064c3 <vector177>:
.globl vector177
vector177:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $177
801064c5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801064ca:	e9 4b f4 ff ff       	jmp    8010591a <alltraps>

801064cf <vector178>:
.globl vector178
vector178:
  pushl $0
801064cf:	6a 00                	push   $0x0
  pushl $178
801064d1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801064d6:	e9 3f f4 ff ff       	jmp    8010591a <alltraps>

801064db <vector179>:
.globl vector179
vector179:
  pushl $0
801064db:	6a 00                	push   $0x0
  pushl $179
801064dd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801064e2:	e9 33 f4 ff ff       	jmp    8010591a <alltraps>

801064e7 <vector180>:
.globl vector180
vector180:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $180
801064e9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801064ee:	e9 27 f4 ff ff       	jmp    8010591a <alltraps>

801064f3 <vector181>:
.globl vector181
vector181:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $181
801064f5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801064fa:	e9 1b f4 ff ff       	jmp    8010591a <alltraps>

801064ff <vector182>:
.globl vector182
vector182:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $182
80106501:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106506:	e9 0f f4 ff ff       	jmp    8010591a <alltraps>

8010650b <vector183>:
.globl vector183
vector183:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $183
8010650d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106512:	e9 03 f4 ff ff       	jmp    8010591a <alltraps>

80106517 <vector184>:
.globl vector184
vector184:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $184
80106519:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010651e:	e9 f7 f3 ff ff       	jmp    8010591a <alltraps>

80106523 <vector185>:
.globl vector185
vector185:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $185
80106525:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010652a:	e9 eb f3 ff ff       	jmp    8010591a <alltraps>

8010652f <vector186>:
.globl vector186
vector186:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $186
80106531:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106536:	e9 df f3 ff ff       	jmp    8010591a <alltraps>

8010653b <vector187>:
.globl vector187
vector187:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $187
8010653d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106542:	e9 d3 f3 ff ff       	jmp    8010591a <alltraps>

80106547 <vector188>:
.globl vector188
vector188:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $188
80106549:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010654e:	e9 c7 f3 ff ff       	jmp    8010591a <alltraps>

80106553 <vector189>:
.globl vector189
vector189:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $189
80106555:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010655a:	e9 bb f3 ff ff       	jmp    8010591a <alltraps>

8010655f <vector190>:
.globl vector190
vector190:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $190
80106561:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106566:	e9 af f3 ff ff       	jmp    8010591a <alltraps>

8010656b <vector191>:
.globl vector191
vector191:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $191
8010656d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106572:	e9 a3 f3 ff ff       	jmp    8010591a <alltraps>

80106577 <vector192>:
.globl vector192
vector192:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $192
80106579:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010657e:	e9 97 f3 ff ff       	jmp    8010591a <alltraps>

80106583 <vector193>:
.globl vector193
vector193:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $193
80106585:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010658a:	e9 8b f3 ff ff       	jmp    8010591a <alltraps>

8010658f <vector194>:
.globl vector194
vector194:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $194
80106591:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106596:	e9 7f f3 ff ff       	jmp    8010591a <alltraps>

8010659b <vector195>:
.globl vector195
vector195:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $195
8010659d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801065a2:	e9 73 f3 ff ff       	jmp    8010591a <alltraps>

801065a7 <vector196>:
.globl vector196
vector196:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $196
801065a9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801065ae:	e9 67 f3 ff ff       	jmp    8010591a <alltraps>

801065b3 <vector197>:
.globl vector197
vector197:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $197
801065b5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801065ba:	e9 5b f3 ff ff       	jmp    8010591a <alltraps>

801065bf <vector198>:
.globl vector198
vector198:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $198
801065c1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801065c6:	e9 4f f3 ff ff       	jmp    8010591a <alltraps>

801065cb <vector199>:
.globl vector199
vector199:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $199
801065cd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801065d2:	e9 43 f3 ff ff       	jmp    8010591a <alltraps>

801065d7 <vector200>:
.globl vector200
vector200:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $200
801065d9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801065de:	e9 37 f3 ff ff       	jmp    8010591a <alltraps>

801065e3 <vector201>:
.globl vector201
vector201:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $201
801065e5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801065ea:	e9 2b f3 ff ff       	jmp    8010591a <alltraps>

801065ef <vector202>:
.globl vector202
vector202:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $202
801065f1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801065f6:	e9 1f f3 ff ff       	jmp    8010591a <alltraps>

801065fb <vector203>:
.globl vector203
vector203:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $203
801065fd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106602:	e9 13 f3 ff ff       	jmp    8010591a <alltraps>

80106607 <vector204>:
.globl vector204
vector204:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $204
80106609:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010660e:	e9 07 f3 ff ff       	jmp    8010591a <alltraps>

80106613 <vector205>:
.globl vector205
vector205:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $205
80106615:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010661a:	e9 fb f2 ff ff       	jmp    8010591a <alltraps>

8010661f <vector206>:
.globl vector206
vector206:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $206
80106621:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106626:	e9 ef f2 ff ff       	jmp    8010591a <alltraps>

8010662b <vector207>:
.globl vector207
vector207:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $207
8010662d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106632:	e9 e3 f2 ff ff       	jmp    8010591a <alltraps>

80106637 <vector208>:
.globl vector208
vector208:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $208
80106639:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010663e:	e9 d7 f2 ff ff       	jmp    8010591a <alltraps>

80106643 <vector209>:
.globl vector209
vector209:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $209
80106645:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010664a:	e9 cb f2 ff ff       	jmp    8010591a <alltraps>

8010664f <vector210>:
.globl vector210
vector210:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $210
80106651:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106656:	e9 bf f2 ff ff       	jmp    8010591a <alltraps>

8010665b <vector211>:
.globl vector211
vector211:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $211
8010665d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106662:	e9 b3 f2 ff ff       	jmp    8010591a <alltraps>

80106667 <vector212>:
.globl vector212
vector212:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $212
80106669:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010666e:	e9 a7 f2 ff ff       	jmp    8010591a <alltraps>

80106673 <vector213>:
.globl vector213
vector213:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $213
80106675:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010667a:	e9 9b f2 ff ff       	jmp    8010591a <alltraps>

8010667f <vector214>:
.globl vector214
vector214:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $214
80106681:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106686:	e9 8f f2 ff ff       	jmp    8010591a <alltraps>

8010668b <vector215>:
.globl vector215
vector215:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $215
8010668d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106692:	e9 83 f2 ff ff       	jmp    8010591a <alltraps>

80106697 <vector216>:
.globl vector216
vector216:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $216
80106699:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010669e:	e9 77 f2 ff ff       	jmp    8010591a <alltraps>

801066a3 <vector217>:
.globl vector217
vector217:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $217
801066a5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801066aa:	e9 6b f2 ff ff       	jmp    8010591a <alltraps>

801066af <vector218>:
.globl vector218
vector218:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $218
801066b1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801066b6:	e9 5f f2 ff ff       	jmp    8010591a <alltraps>

801066bb <vector219>:
.globl vector219
vector219:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $219
801066bd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801066c2:	e9 53 f2 ff ff       	jmp    8010591a <alltraps>

801066c7 <vector220>:
.globl vector220
vector220:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $220
801066c9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801066ce:	e9 47 f2 ff ff       	jmp    8010591a <alltraps>

801066d3 <vector221>:
.globl vector221
vector221:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $221
801066d5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801066da:	e9 3b f2 ff ff       	jmp    8010591a <alltraps>

801066df <vector222>:
.globl vector222
vector222:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $222
801066e1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801066e6:	e9 2f f2 ff ff       	jmp    8010591a <alltraps>

801066eb <vector223>:
.globl vector223
vector223:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $223
801066ed:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801066f2:	e9 23 f2 ff ff       	jmp    8010591a <alltraps>

801066f7 <vector224>:
.globl vector224
vector224:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $224
801066f9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801066fe:	e9 17 f2 ff ff       	jmp    8010591a <alltraps>

80106703 <vector225>:
.globl vector225
vector225:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $225
80106705:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010670a:	e9 0b f2 ff ff       	jmp    8010591a <alltraps>

8010670f <vector226>:
.globl vector226
vector226:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $226
80106711:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106716:	e9 ff f1 ff ff       	jmp    8010591a <alltraps>

8010671b <vector227>:
.globl vector227
vector227:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $227
8010671d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106722:	e9 f3 f1 ff ff       	jmp    8010591a <alltraps>

80106727 <vector228>:
.globl vector228
vector228:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $228
80106729:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010672e:	e9 e7 f1 ff ff       	jmp    8010591a <alltraps>

80106733 <vector229>:
.globl vector229
vector229:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $229
80106735:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010673a:	e9 db f1 ff ff       	jmp    8010591a <alltraps>

8010673f <vector230>:
.globl vector230
vector230:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $230
80106741:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106746:	e9 cf f1 ff ff       	jmp    8010591a <alltraps>

8010674b <vector231>:
.globl vector231
vector231:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $231
8010674d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106752:	e9 c3 f1 ff ff       	jmp    8010591a <alltraps>

80106757 <vector232>:
.globl vector232
vector232:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $232
80106759:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010675e:	e9 b7 f1 ff ff       	jmp    8010591a <alltraps>

80106763 <vector233>:
.globl vector233
vector233:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $233
80106765:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010676a:	e9 ab f1 ff ff       	jmp    8010591a <alltraps>

8010676f <vector234>:
.globl vector234
vector234:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $234
80106771:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106776:	e9 9f f1 ff ff       	jmp    8010591a <alltraps>

8010677b <vector235>:
.globl vector235
vector235:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $235
8010677d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106782:	e9 93 f1 ff ff       	jmp    8010591a <alltraps>

80106787 <vector236>:
.globl vector236
vector236:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $236
80106789:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010678e:	e9 87 f1 ff ff       	jmp    8010591a <alltraps>

80106793 <vector237>:
.globl vector237
vector237:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $237
80106795:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010679a:	e9 7b f1 ff ff       	jmp    8010591a <alltraps>

8010679f <vector238>:
.globl vector238
vector238:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $238
801067a1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801067a6:	e9 6f f1 ff ff       	jmp    8010591a <alltraps>

801067ab <vector239>:
.globl vector239
vector239:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $239
801067ad:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801067b2:	e9 63 f1 ff ff       	jmp    8010591a <alltraps>

801067b7 <vector240>:
.globl vector240
vector240:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $240
801067b9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801067be:	e9 57 f1 ff ff       	jmp    8010591a <alltraps>

801067c3 <vector241>:
.globl vector241
vector241:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $241
801067c5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801067ca:	e9 4b f1 ff ff       	jmp    8010591a <alltraps>

801067cf <vector242>:
.globl vector242
vector242:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $242
801067d1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801067d6:	e9 3f f1 ff ff       	jmp    8010591a <alltraps>

801067db <vector243>:
.globl vector243
vector243:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $243
801067dd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801067e2:	e9 33 f1 ff ff       	jmp    8010591a <alltraps>

801067e7 <vector244>:
.globl vector244
vector244:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $244
801067e9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801067ee:	e9 27 f1 ff ff       	jmp    8010591a <alltraps>

801067f3 <vector245>:
.globl vector245
vector245:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $245
801067f5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801067fa:	e9 1b f1 ff ff       	jmp    8010591a <alltraps>

801067ff <vector246>:
.globl vector246
vector246:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $246
80106801:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106806:	e9 0f f1 ff ff       	jmp    8010591a <alltraps>

8010680b <vector247>:
.globl vector247
vector247:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $247
8010680d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106812:	e9 03 f1 ff ff       	jmp    8010591a <alltraps>

80106817 <vector248>:
.globl vector248
vector248:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $248
80106819:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010681e:	e9 f7 f0 ff ff       	jmp    8010591a <alltraps>

80106823 <vector249>:
.globl vector249
vector249:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $249
80106825:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010682a:	e9 eb f0 ff ff       	jmp    8010591a <alltraps>

8010682f <vector250>:
.globl vector250
vector250:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $250
80106831:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106836:	e9 df f0 ff ff       	jmp    8010591a <alltraps>

8010683b <vector251>:
.globl vector251
vector251:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $251
8010683d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106842:	e9 d3 f0 ff ff       	jmp    8010591a <alltraps>

80106847 <vector252>:
.globl vector252
vector252:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $252
80106849:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010684e:	e9 c7 f0 ff ff       	jmp    8010591a <alltraps>

80106853 <vector253>:
.globl vector253
vector253:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $253
80106855:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010685a:	e9 bb f0 ff ff       	jmp    8010591a <alltraps>

8010685f <vector254>:
.globl vector254
vector254:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $254
80106861:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106866:	e9 af f0 ff ff       	jmp    8010591a <alltraps>

8010686b <vector255>:
.globl vector255
vector255:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $255
8010686d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106872:	e9 a3 f0 ff ff       	jmp    8010591a <alltraps>
80106877:	66 90                	xchg   %ax,%ax
80106879:	66 90                	xchg   %ax,%ax
8010687b:	66 90                	xchg   %ax,%ax
8010687d:	66 90                	xchg   %ax,%ax
8010687f:	90                   	nop

80106880 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106880:	55                   	push   %ebp
80106881:	89 e5                	mov    %esp,%ebp
80106883:	57                   	push   %edi
80106884:	56                   	push   %esi
80106885:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106886:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
8010688c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106892:	83 ec 1c             	sub    $0x1c,%esp
  for(; a  < oldsz; a += PGSIZE){
80106895:	39 d3                	cmp    %edx,%ebx
80106897:	73 56                	jae    801068ef <deallocuvm.part.0+0x6f>
80106899:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010689c:	89 c6                	mov    %eax,%esi
8010689e:	89 d7                	mov    %edx,%edi
801068a0:	eb 12                	jmp    801068b4 <deallocuvm.part.0+0x34>
801068a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801068a8:	83 c2 01             	add    $0x1,%edx
801068ab:	89 d3                	mov    %edx,%ebx
801068ad:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
801068b0:	39 fb                	cmp    %edi,%ebx
801068b2:	73 38                	jae    801068ec <deallocuvm.part.0+0x6c>
  pde = &pgdir[PDX(va)];
801068b4:	89 da                	mov    %ebx,%edx
801068b6:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
801068b9:	8b 04 96             	mov    (%esi,%edx,4),%eax
801068bc:	a8 01                	test   $0x1,%al
801068be:	74 e8                	je     801068a8 <deallocuvm.part.0+0x28>
  return &pgtab[PTX(va)];
801068c0:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801068c2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801068c7:	c1 e9 0a             	shr    $0xa,%ecx
801068ca:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
801068d0:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
    if(!pte)
801068d7:	85 c0                	test   %eax,%eax
801068d9:	74 cd                	je     801068a8 <deallocuvm.part.0+0x28>
    else if((*pte & PTE_P) != 0){
801068db:	8b 10                	mov    (%eax),%edx
801068dd:	f6 c2 01             	test   $0x1,%dl
801068e0:	75 1e                	jne    80106900 <deallocuvm.part.0+0x80>
  for(; a  < oldsz; a += PGSIZE){
801068e2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801068e8:	39 fb                	cmp    %edi,%ebx
801068ea:	72 c8                	jb     801068b4 <deallocuvm.part.0+0x34>
801068ec:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
801068ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
801068f2:	89 c8                	mov    %ecx,%eax
801068f4:	5b                   	pop    %ebx
801068f5:	5e                   	pop    %esi
801068f6:	5f                   	pop    %edi
801068f7:	5d                   	pop    %ebp
801068f8:	c3                   	ret
801068f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(pa == 0)
80106900:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106906:	74 26                	je     8010692e <deallocuvm.part.0+0xae>
      kfree(v);
80106908:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010690b:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106911:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106914:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
8010691a:	52                   	push   %edx
8010691b:	e8 f0 bb ff ff       	call   80102510 <kfree>
      *pte = 0;
80106920:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  for(; a  < oldsz; a += PGSIZE){
80106923:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80106926:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
8010692c:	eb 82                	jmp    801068b0 <deallocuvm.part.0+0x30>
        panic("kfree");
8010692e:	83 ec 0c             	sub    $0xc,%esp
80106931:	68 27 74 10 80       	push   $0x80107427
80106936:	e8 45 9a ff ff       	call   80100380 <panic>
8010693b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106940 <mappages>:
{
80106940:	55                   	push   %ebp
80106941:	89 e5                	mov    %esp,%ebp
80106943:	57                   	push   %edi
80106944:	56                   	push   %esi
80106945:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106946:	89 d3                	mov    %edx,%ebx
80106948:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
8010694e:	83 ec 1c             	sub    $0x1c,%esp
80106951:	89 45 e0             	mov    %eax,-0x20(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106954:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106958:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010695d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106960:	8b 45 08             	mov    0x8(%ebp),%eax
80106963:	29 d8                	sub    %ebx,%eax
80106965:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106968:	eb 3f                	jmp    801069a9 <mappages+0x69>
8010696a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106970:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106972:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106977:	c1 ea 0a             	shr    $0xa,%edx
8010697a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106980:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106987:	85 c0                	test   %eax,%eax
80106989:	74 75                	je     80106a00 <mappages+0xc0>
    if(*pte & PTE_P)
8010698b:	f6 00 01             	testb  $0x1,(%eax)
8010698e:	0f 85 86 00 00 00    	jne    80106a1a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106994:	0b 75 0c             	or     0xc(%ebp),%esi
80106997:	83 ce 01             	or     $0x1,%esi
8010699a:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010699c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010699f:	39 c3                	cmp    %eax,%ebx
801069a1:	74 6d                	je     80106a10 <mappages+0xd0>
    a += PGSIZE;
801069a3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
801069a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pde = &pgdir[PDX(va)];
801069ac:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801069af:	8d 34 03             	lea    (%ebx,%eax,1),%esi
801069b2:	89 d8                	mov    %ebx,%eax
801069b4:	c1 e8 16             	shr    $0x16,%eax
801069b7:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
801069ba:	8b 07                	mov    (%edi),%eax
801069bc:	a8 01                	test   $0x1,%al
801069be:	75 b0                	jne    80106970 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801069c0:	e8 0b bd ff ff       	call   801026d0 <kalloc>
801069c5:	85 c0                	test   %eax,%eax
801069c7:	74 37                	je     80106a00 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
801069c9:	83 ec 04             	sub    $0x4,%esp
801069cc:	68 00 10 00 00       	push   $0x1000
801069d1:	6a 00                	push   $0x0
801069d3:	50                   	push   %eax
801069d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
801069d7:	e8 a4 dd ff ff       	call   80104780 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801069dc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
801069df:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801069e2:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
801069e8:	83 c8 07             	or     $0x7,%eax
801069eb:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
801069ed:	89 d8                	mov    %ebx,%eax
801069ef:	c1 e8 0a             	shr    $0xa,%eax
801069f2:	25 fc 0f 00 00       	and    $0xffc,%eax
801069f7:	01 d0                	add    %edx,%eax
801069f9:	eb 90                	jmp    8010698b <mappages+0x4b>
801069fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
}
80106a00:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106a03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106a08:	5b                   	pop    %ebx
80106a09:	5e                   	pop    %esi
80106a0a:	5f                   	pop    %edi
80106a0b:	5d                   	pop    %ebp
80106a0c:	c3                   	ret
80106a0d:	8d 76 00             	lea    0x0(%esi),%esi
80106a10:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106a13:	31 c0                	xor    %eax,%eax
}
80106a15:	5b                   	pop    %ebx
80106a16:	5e                   	pop    %esi
80106a17:	5f                   	pop    %edi
80106a18:	5d                   	pop    %ebp
80106a19:	c3                   	ret
      panic("remap");
80106a1a:	83 ec 0c             	sub    $0xc,%esp
80106a1d:	68 89 76 10 80       	push   $0x80107689
80106a22:	e8 59 99 ff ff       	call   80100380 <panic>
80106a27:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106a2e:	00 
80106a2f:	90                   	nop

80106a30 <seginit>:
{
80106a30:	55                   	push   %ebp
80106a31:	89 e5                	mov    %esp,%ebp
80106a33:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106a36:	e8 e5 cf ff ff       	call   80103a20 <cpuid>
  pd[0] = size-1;
80106a3b:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106a40:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106a46:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
80106a4a:	c7 80 38 18 11 80 ff 	movl   $0xffff,-0x7feee7c8(%eax)
80106a51:	ff 00 00 
80106a54:	c7 80 3c 18 11 80 00 	movl   $0xcf9a00,-0x7feee7c4(%eax)
80106a5b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106a5e:	c7 80 40 18 11 80 ff 	movl   $0xffff,-0x7feee7c0(%eax)
80106a65:	ff 00 00 
80106a68:	c7 80 44 18 11 80 00 	movl   $0xcf9200,-0x7feee7bc(%eax)
80106a6f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106a72:	c7 80 48 18 11 80 ff 	movl   $0xffff,-0x7feee7b8(%eax)
80106a79:	ff 00 00 
80106a7c:	c7 80 4c 18 11 80 00 	movl   $0xcffa00,-0x7feee7b4(%eax)
80106a83:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106a86:	c7 80 50 18 11 80 ff 	movl   $0xffff,-0x7feee7b0(%eax)
80106a8d:	ff 00 00 
80106a90:	c7 80 54 18 11 80 00 	movl   $0xcff200,-0x7feee7ac(%eax)
80106a97:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106a9a:	05 30 18 11 80       	add    $0x80111830,%eax
  pd[1] = (uint)p;
80106a9f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106aa3:	c1 e8 10             	shr    $0x10,%eax
80106aa6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106aaa:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106aad:	0f 01 10             	lgdtl  (%eax)
}
80106ab0:	c9                   	leave
80106ab1:	c3                   	ret
80106ab2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106ab9:	00 
80106aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106ac0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106ac0:	a1 e4 44 11 80       	mov    0x801144e4,%eax
80106ac5:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106aca:	0f 22 d8             	mov    %eax,%cr3
}
80106acd:	c3                   	ret
80106ace:	66 90                	xchg   %ax,%ax

80106ad0 <switchuvm>:
{
80106ad0:	55                   	push   %ebp
80106ad1:	89 e5                	mov    %esp,%ebp
80106ad3:	57                   	push   %edi
80106ad4:	56                   	push   %esi
80106ad5:	53                   	push   %ebx
80106ad6:	83 ec 1c             	sub    $0x1c,%esp
80106ad9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106adc:	85 f6                	test   %esi,%esi
80106ade:	0f 84 cb 00 00 00    	je     80106baf <switchuvm+0xdf>
  if(p->kstack == 0)
80106ae4:	8b 46 08             	mov    0x8(%esi),%eax
80106ae7:	85 c0                	test   %eax,%eax
80106ae9:	0f 84 da 00 00 00    	je     80106bc9 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106aef:	8b 46 04             	mov    0x4(%esi),%eax
80106af2:	85 c0                	test   %eax,%eax
80106af4:	0f 84 c2 00 00 00    	je     80106bbc <switchuvm+0xec>
  pushcli();
80106afa:	e8 31 da ff ff       	call   80104530 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106aff:	e8 bc ce ff ff       	call   801039c0 <mycpu>
80106b04:	89 c3                	mov    %eax,%ebx
80106b06:	e8 b5 ce ff ff       	call   801039c0 <mycpu>
80106b0b:	89 c7                	mov    %eax,%edi
80106b0d:	e8 ae ce ff ff       	call   801039c0 <mycpu>
80106b12:	83 c7 08             	add    $0x8,%edi
80106b15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106b18:	e8 a3 ce ff ff       	call   801039c0 <mycpu>
80106b1d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106b20:	ba 67 00 00 00       	mov    $0x67,%edx
80106b25:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106b2c:	83 c0 08             	add    $0x8,%eax
80106b2f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106b36:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106b3b:	83 c1 08             	add    $0x8,%ecx
80106b3e:	c1 e8 18             	shr    $0x18,%eax
80106b41:	c1 e9 10             	shr    $0x10,%ecx
80106b44:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106b4a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106b50:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106b55:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106b5c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106b61:	e8 5a ce ff ff       	call   801039c0 <mycpu>
80106b66:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106b6d:	e8 4e ce ff ff       	call   801039c0 <mycpu>
80106b72:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106b76:	8b 5e 08             	mov    0x8(%esi),%ebx
80106b79:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106b7f:	e8 3c ce ff ff       	call   801039c0 <mycpu>
80106b84:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106b87:	e8 34 ce ff ff       	call   801039c0 <mycpu>
80106b8c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106b90:	b8 28 00 00 00       	mov    $0x28,%eax
80106b95:	0f 00 d8             	ltr    %eax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106b98:	8b 46 04             	mov    0x4(%esi),%eax
80106b9b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106ba0:	0f 22 d8             	mov    %eax,%cr3
}
80106ba3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ba6:	5b                   	pop    %ebx
80106ba7:	5e                   	pop    %esi
80106ba8:	5f                   	pop    %edi
80106ba9:	5d                   	pop    %ebp
  popcli();
80106baa:	e9 d1 d9 ff ff       	jmp    80104580 <popcli>
    panic("switchuvm: no process");
80106baf:	83 ec 0c             	sub    $0xc,%esp
80106bb2:	68 8f 76 10 80       	push   $0x8010768f
80106bb7:	e8 c4 97 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106bbc:	83 ec 0c             	sub    $0xc,%esp
80106bbf:	68 ba 76 10 80       	push   $0x801076ba
80106bc4:	e8 b7 97 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106bc9:	83 ec 0c             	sub    $0xc,%esp
80106bcc:	68 a5 76 10 80       	push   $0x801076a5
80106bd1:	e8 aa 97 ff ff       	call   80100380 <panic>
80106bd6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106bdd:	00 
80106bde:	66 90                	xchg   %ax,%ax

80106be0 <inituvm>:
{
80106be0:	55                   	push   %ebp
80106be1:	89 e5                	mov    %esp,%ebp
80106be3:	57                   	push   %edi
80106be4:	56                   	push   %esi
80106be5:	53                   	push   %ebx
80106be6:	83 ec 1c             	sub    $0x1c,%esp
80106be9:	8b 45 08             	mov    0x8(%ebp),%eax
80106bec:	8b 75 10             	mov    0x10(%ebp),%esi
80106bef:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106bf2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106bf5:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106bfb:	77 49                	ja     80106c46 <inituvm+0x66>
  mem = kalloc();
80106bfd:	e8 ce ba ff ff       	call   801026d0 <kalloc>
  memset(mem, 0, PGSIZE);
80106c02:	83 ec 04             	sub    $0x4,%esp
80106c05:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106c0a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106c0c:	6a 00                	push   $0x0
80106c0e:	50                   	push   %eax
80106c0f:	e8 6c db ff ff       	call   80104780 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106c14:	58                   	pop    %eax
80106c15:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106c1b:	5a                   	pop    %edx
80106c1c:	6a 06                	push   $0x6
80106c1e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106c23:	31 d2                	xor    %edx,%edx
80106c25:	50                   	push   %eax
80106c26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c29:	e8 12 fd ff ff       	call   80106940 <mappages>
  memmove(mem, init, sz);
80106c2e:	83 c4 10             	add    $0x10,%esp
80106c31:	89 75 10             	mov    %esi,0x10(%ebp)
80106c34:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106c37:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106c3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106c3d:	5b                   	pop    %ebx
80106c3e:	5e                   	pop    %esi
80106c3f:	5f                   	pop    %edi
80106c40:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106c41:	e9 ca db ff ff       	jmp    80104810 <memmove>
    panic("inituvm: more than a page");
80106c46:	83 ec 0c             	sub    $0xc,%esp
80106c49:	68 ce 76 10 80       	push   $0x801076ce
80106c4e:	e8 2d 97 ff ff       	call   80100380 <panic>
80106c53:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106c5a:	00 
80106c5b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106c60 <loaduvm>:
{
80106c60:	55                   	push   %ebp
80106c61:	89 e5                	mov    %esp,%ebp
80106c63:	57                   	push   %edi
80106c64:	56                   	push   %esi
80106c65:	53                   	push   %ebx
80106c66:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106c69:	8b 75 0c             	mov    0xc(%ebp),%esi
{
80106c6c:	8b 7d 18             	mov    0x18(%ebp),%edi
  if((uint) addr % PGSIZE != 0)
80106c6f:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80106c75:	0f 85 a2 00 00 00    	jne    80106d1d <loaduvm+0xbd>
  for(i = 0; i < sz; i += PGSIZE){
80106c7b:	85 ff                	test   %edi,%edi
80106c7d:	74 7d                	je     80106cfc <loaduvm+0x9c>
80106c7f:	90                   	nop
  pde = &pgdir[PDX(va)];
80106c80:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80106c83:	8b 55 08             	mov    0x8(%ebp),%edx
80106c86:	01 f0                	add    %esi,%eax
  pde = &pgdir[PDX(va)];
80106c88:	89 c1                	mov    %eax,%ecx
80106c8a:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80106c8d:	8b 0c 8a             	mov    (%edx,%ecx,4),%ecx
80106c90:	f6 c1 01             	test   $0x1,%cl
80106c93:	75 13                	jne    80106ca8 <loaduvm+0x48>
      panic("loaduvm: address should exist");
80106c95:	83 ec 0c             	sub    $0xc,%esp
80106c98:	68 e8 76 10 80       	push   $0x801076e8
80106c9d:	e8 de 96 ff ff       	call   80100380 <panic>
80106ca2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106ca8:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106cab:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106cb1:	25 fc 0f 00 00       	and    $0xffc,%eax
80106cb6:	8d 8c 01 00 00 00 80 	lea    -0x80000000(%ecx,%eax,1),%ecx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106cbd:	85 c9                	test   %ecx,%ecx
80106cbf:	74 d4                	je     80106c95 <loaduvm+0x35>
    if(sz - i < PGSIZE)
80106cc1:	89 fb                	mov    %edi,%ebx
80106cc3:	b8 00 10 00 00       	mov    $0x1000,%eax
80106cc8:	29 f3                	sub    %esi,%ebx
80106cca:	39 c3                	cmp    %eax,%ebx
80106ccc:	0f 47 d8             	cmova  %eax,%ebx
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106ccf:	53                   	push   %ebx
80106cd0:	8b 45 14             	mov    0x14(%ebp),%eax
80106cd3:	01 f0                	add    %esi,%eax
80106cd5:	50                   	push   %eax
    pa = PTE_ADDR(*pte);
80106cd6:	8b 01                	mov    (%ecx),%eax
80106cd8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106cdd:	05 00 00 00 80       	add    $0x80000000,%eax
80106ce2:	50                   	push   %eax
80106ce3:	ff 75 10             	push   0x10(%ebp)
80106ce6:	e8 35 ae ff ff       	call   80101b20 <readi>
80106ceb:	83 c4 10             	add    $0x10,%esp
80106cee:	39 d8                	cmp    %ebx,%eax
80106cf0:	75 1e                	jne    80106d10 <loaduvm+0xb0>
  for(i = 0; i < sz; i += PGSIZE){
80106cf2:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106cf8:	39 fe                	cmp    %edi,%esi
80106cfa:	72 84                	jb     80106c80 <loaduvm+0x20>
}
80106cfc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106cff:	31 c0                	xor    %eax,%eax
}
80106d01:	5b                   	pop    %ebx
80106d02:	5e                   	pop    %esi
80106d03:	5f                   	pop    %edi
80106d04:	5d                   	pop    %ebp
80106d05:	c3                   	ret
80106d06:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106d0d:	00 
80106d0e:	66 90                	xchg   %ax,%ax
80106d10:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106d13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106d18:	5b                   	pop    %ebx
80106d19:	5e                   	pop    %esi
80106d1a:	5f                   	pop    %edi
80106d1b:	5d                   	pop    %ebp
80106d1c:	c3                   	ret
    panic("loaduvm: addr must be page aligned");
80106d1d:	83 ec 0c             	sub    $0xc,%esp
80106d20:	68 0c 79 10 80       	push   $0x8010790c
80106d25:	e8 56 96 ff ff       	call   80100380 <panic>
80106d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106d30 <allocuvm>:
{
80106d30:	55                   	push   %ebp
80106d31:	89 e5                	mov    %esp,%ebp
80106d33:	57                   	push   %edi
80106d34:	56                   	push   %esi
80106d35:	53                   	push   %ebx
80106d36:	83 ec 1c             	sub    $0x1c,%esp
80106d39:	8b 75 10             	mov    0x10(%ebp),%esi
  if(newsz >= KERNBASE)
80106d3c:	85 f6                	test   %esi,%esi
80106d3e:	0f 88 98 00 00 00    	js     80106ddc <allocuvm+0xac>
80106d44:	89 f2                	mov    %esi,%edx
  if(newsz < oldsz)
80106d46:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106d49:	0f 82 a1 00 00 00    	jb     80106df0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106d4f:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d52:	05 ff 0f 00 00       	add    $0xfff,%eax
80106d57:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d5c:	89 c7                	mov    %eax,%edi
  for(; a < newsz; a += PGSIZE){
80106d5e:	39 f0                	cmp    %esi,%eax
80106d60:	0f 83 8d 00 00 00    	jae    80106df3 <allocuvm+0xc3>
80106d66:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80106d69:	eb 44                	jmp    80106daf <allocuvm+0x7f>
80106d6b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80106d70:	83 ec 04             	sub    $0x4,%esp
80106d73:	68 00 10 00 00       	push   $0x1000
80106d78:	6a 00                	push   $0x0
80106d7a:	50                   	push   %eax
80106d7b:	e8 00 da ff ff       	call   80104780 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106d80:	58                   	pop    %eax
80106d81:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106d87:	5a                   	pop    %edx
80106d88:	6a 06                	push   $0x6
80106d8a:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106d8f:	89 fa                	mov    %edi,%edx
80106d91:	50                   	push   %eax
80106d92:	8b 45 08             	mov    0x8(%ebp),%eax
80106d95:	e8 a6 fb ff ff       	call   80106940 <mappages>
80106d9a:	83 c4 10             	add    $0x10,%esp
80106d9d:	85 c0                	test   %eax,%eax
80106d9f:	78 5f                	js     80106e00 <allocuvm+0xd0>
  for(; a < newsz; a += PGSIZE){
80106da1:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106da7:	39 f7                	cmp    %esi,%edi
80106da9:	0f 83 89 00 00 00    	jae    80106e38 <allocuvm+0x108>
    mem = kalloc();
80106daf:	e8 1c b9 ff ff       	call   801026d0 <kalloc>
80106db4:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106db6:	85 c0                	test   %eax,%eax
80106db8:	75 b6                	jne    80106d70 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106dba:	83 ec 0c             	sub    $0xc,%esp
80106dbd:	68 06 77 10 80       	push   $0x80107706
80106dc2:	e8 e9 98 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106dc7:	83 c4 10             	add    $0x10,%esp
80106dca:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106dcd:	74 0d                	je     80106ddc <allocuvm+0xac>
80106dcf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106dd2:	8b 45 08             	mov    0x8(%ebp),%eax
80106dd5:	89 f2                	mov    %esi,%edx
80106dd7:	e8 a4 fa ff ff       	call   80106880 <deallocuvm.part.0>
    return 0;
80106ddc:	31 d2                	xor    %edx,%edx
}
80106dde:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106de1:	89 d0                	mov    %edx,%eax
80106de3:	5b                   	pop    %ebx
80106de4:	5e                   	pop    %esi
80106de5:	5f                   	pop    %edi
80106de6:	5d                   	pop    %ebp
80106de7:	c3                   	ret
80106de8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106def:	00 
    return oldsz;
80106df0:	8b 55 0c             	mov    0xc(%ebp),%edx
}
80106df3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106df6:	89 d0                	mov    %edx,%eax
80106df8:	5b                   	pop    %ebx
80106df9:	5e                   	pop    %esi
80106dfa:	5f                   	pop    %edi
80106dfb:	5d                   	pop    %ebp
80106dfc:	c3                   	ret
80106dfd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106e00:	83 ec 0c             	sub    $0xc,%esp
80106e03:	68 1e 77 10 80       	push   $0x8010771e
80106e08:	e8 a3 98 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80106e0d:	83 c4 10             	add    $0x10,%esp
80106e10:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106e13:	74 0d                	je     80106e22 <allocuvm+0xf2>
80106e15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106e18:	8b 45 08             	mov    0x8(%ebp),%eax
80106e1b:	89 f2                	mov    %esi,%edx
80106e1d:	e8 5e fa ff ff       	call   80106880 <deallocuvm.part.0>
      kfree(mem);
80106e22:	83 ec 0c             	sub    $0xc,%esp
80106e25:	53                   	push   %ebx
80106e26:	e8 e5 b6 ff ff       	call   80102510 <kfree>
      return 0;
80106e2b:	83 c4 10             	add    $0x10,%esp
    return 0;
80106e2e:	31 d2                	xor    %edx,%edx
80106e30:	eb ac                	jmp    80106dde <allocuvm+0xae>
80106e32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106e38:	8b 55 e4             	mov    -0x1c(%ebp),%edx
}
80106e3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e3e:	5b                   	pop    %ebx
80106e3f:	5e                   	pop    %esi
80106e40:	89 d0                	mov    %edx,%eax
80106e42:	5f                   	pop    %edi
80106e43:	5d                   	pop    %ebp
80106e44:	c3                   	ret
80106e45:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106e4c:	00 
80106e4d:	8d 76 00             	lea    0x0(%esi),%esi

80106e50 <deallocuvm>:
{
80106e50:	55                   	push   %ebp
80106e51:	89 e5                	mov    %esp,%ebp
80106e53:	8b 55 0c             	mov    0xc(%ebp),%edx
80106e56:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106e59:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106e5c:	39 d1                	cmp    %edx,%ecx
80106e5e:	73 10                	jae    80106e70 <deallocuvm+0x20>
}
80106e60:	5d                   	pop    %ebp
80106e61:	e9 1a fa ff ff       	jmp    80106880 <deallocuvm.part.0>
80106e66:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106e6d:	00 
80106e6e:	66 90                	xchg   %ax,%ax
80106e70:	89 d0                	mov    %edx,%eax
80106e72:	5d                   	pop    %ebp
80106e73:	c3                   	ret
80106e74:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106e7b:	00 
80106e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106e80 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106e80:	55                   	push   %ebp
80106e81:	89 e5                	mov    %esp,%ebp
80106e83:	57                   	push   %edi
80106e84:	56                   	push   %esi
80106e85:	53                   	push   %ebx
80106e86:	83 ec 0c             	sub    $0xc,%esp
80106e89:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106e8c:	85 f6                	test   %esi,%esi
80106e8e:	74 59                	je     80106ee9 <freevm+0x69>
  if(newsz >= oldsz)
80106e90:	31 c9                	xor    %ecx,%ecx
80106e92:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106e97:	89 f0                	mov    %esi,%eax
80106e99:	89 f3                	mov    %esi,%ebx
80106e9b:	e8 e0 f9 ff ff       	call   80106880 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106ea0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106ea6:	eb 0f                	jmp    80106eb7 <freevm+0x37>
80106ea8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106eaf:	00 
80106eb0:	83 c3 04             	add    $0x4,%ebx
80106eb3:	39 fb                	cmp    %edi,%ebx
80106eb5:	74 23                	je     80106eda <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106eb7:	8b 03                	mov    (%ebx),%eax
80106eb9:	a8 01                	test   $0x1,%al
80106ebb:	74 f3                	je     80106eb0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106ebd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80106ec2:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106ec5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106ec8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106ecd:	50                   	push   %eax
80106ece:	e8 3d b6 ff ff       	call   80102510 <kfree>
80106ed3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80106ed6:	39 fb                	cmp    %edi,%ebx
80106ed8:	75 dd                	jne    80106eb7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
80106eda:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106edd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ee0:	5b                   	pop    %ebx
80106ee1:	5e                   	pop    %esi
80106ee2:	5f                   	pop    %edi
80106ee3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106ee4:	e9 27 b6 ff ff       	jmp    80102510 <kfree>
    panic("freevm: no pgdir");
80106ee9:	83 ec 0c             	sub    $0xc,%esp
80106eec:	68 3a 77 10 80       	push   $0x8010773a
80106ef1:	e8 8a 94 ff ff       	call   80100380 <panic>
80106ef6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106efd:	00 
80106efe:	66 90                	xchg   %ax,%ax

80106f00 <setupkvm>:
{
80106f00:	55                   	push   %ebp
80106f01:	89 e5                	mov    %esp,%ebp
80106f03:	56                   	push   %esi
80106f04:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106f05:	e8 c6 b7 ff ff       	call   801026d0 <kalloc>
80106f0a:	85 c0                	test   %eax,%eax
80106f0c:	74 5e                	je     80106f6c <setupkvm+0x6c>
  memset(pgdir, 0, PGSIZE);
80106f0e:	83 ec 04             	sub    $0x4,%esp
80106f11:	89 c6                	mov    %eax,%esi
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106f13:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106f18:	68 00 10 00 00       	push   $0x1000
80106f1d:	6a 00                	push   $0x0
80106f1f:	50                   	push   %eax
80106f20:	e8 5b d8 ff ff       	call   80104780 <memset>
80106f25:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80106f28:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106f2b:	83 ec 08             	sub    $0x8,%esp
80106f2e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106f31:	8b 13                	mov    (%ebx),%edx
80106f33:	ff 73 0c             	push   0xc(%ebx)
80106f36:	50                   	push   %eax
80106f37:	29 c1                	sub    %eax,%ecx
80106f39:	89 f0                	mov    %esi,%eax
80106f3b:	e8 00 fa ff ff       	call   80106940 <mappages>
80106f40:	83 c4 10             	add    $0x10,%esp
80106f43:	85 c0                	test   %eax,%eax
80106f45:	78 19                	js     80106f60 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106f47:	83 c3 10             	add    $0x10,%ebx
80106f4a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106f50:	75 d6                	jne    80106f28 <setupkvm+0x28>
}
80106f52:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106f55:	89 f0                	mov    %esi,%eax
80106f57:	5b                   	pop    %ebx
80106f58:	5e                   	pop    %esi
80106f59:	5d                   	pop    %ebp
80106f5a:	c3                   	ret
80106f5b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80106f60:	83 ec 0c             	sub    $0xc,%esp
80106f63:	56                   	push   %esi
80106f64:	e8 17 ff ff ff       	call   80106e80 <freevm>
      return 0;
80106f69:	83 c4 10             	add    $0x10,%esp
}
80106f6c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
80106f6f:	31 f6                	xor    %esi,%esi
}
80106f71:	89 f0                	mov    %esi,%eax
80106f73:	5b                   	pop    %ebx
80106f74:	5e                   	pop    %esi
80106f75:	5d                   	pop    %ebp
80106f76:	c3                   	ret
80106f77:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106f7e:	00 
80106f7f:	90                   	nop

80106f80 <kvmalloc>:
{
80106f80:	55                   	push   %ebp
80106f81:	89 e5                	mov    %esp,%ebp
80106f83:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106f86:	e8 75 ff ff ff       	call   80106f00 <setupkvm>
80106f8b:	a3 e4 44 11 80       	mov    %eax,0x801144e4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106f90:	05 00 00 00 80       	add    $0x80000000,%eax
80106f95:	0f 22 d8             	mov    %eax,%cr3
}
80106f98:	c9                   	leave
80106f99:	c3                   	ret
80106f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106fa0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106fa0:	55                   	push   %ebp
80106fa1:	89 e5                	mov    %esp,%ebp
80106fa3:	83 ec 08             	sub    $0x8,%esp
80106fa6:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80106fa9:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80106fac:	89 c1                	mov    %eax,%ecx
80106fae:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80106fb1:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80106fb4:	f6 c2 01             	test   $0x1,%dl
80106fb7:	75 17                	jne    80106fd0 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80106fb9:	83 ec 0c             	sub    $0xc,%esp
80106fbc:	68 4b 77 10 80       	push   $0x8010774b
80106fc1:	e8 ba 93 ff ff       	call   80100380 <panic>
80106fc6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106fcd:	00 
80106fce:	66 90                	xchg   %ax,%ax
  return &pgtab[PTX(va)];
80106fd0:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106fd3:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80106fd9:	25 fc 0f 00 00       	and    $0xffc,%eax
80106fde:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80106fe5:	85 c0                	test   %eax,%eax
80106fe7:	74 d0                	je     80106fb9 <clearpteu+0x19>
  *pte &= ~PTE_U;
80106fe9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106fec:	c9                   	leave
80106fed:	c3                   	ret
80106fee:	66 90                	xchg   %ax,%ax

80106ff0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106ff0:	55                   	push   %ebp
80106ff1:	89 e5                	mov    %esp,%ebp
80106ff3:	57                   	push   %edi
80106ff4:	56                   	push   %esi
80106ff5:	53                   	push   %ebx
80106ff6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106ff9:	e8 02 ff ff ff       	call   80106f00 <setupkvm>
80106ffe:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107001:	85 c0                	test   %eax,%eax
80107003:	0f 84 e9 00 00 00    	je     801070f2 <copyuvm+0x102>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107009:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010700c:	85 c9                	test   %ecx,%ecx
8010700e:	0f 84 b2 00 00 00    	je     801070c6 <copyuvm+0xd6>
80107014:	31 f6                	xor    %esi,%esi
80107016:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010701d:	00 
8010701e:	66 90                	xchg   %ax,%ax
  if(*pde & PTE_P){
80107020:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107023:	89 f0                	mov    %esi,%eax
80107025:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107028:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010702b:	a8 01                	test   $0x1,%al
8010702d:	75 11                	jne    80107040 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010702f:	83 ec 0c             	sub    $0xc,%esp
80107032:	68 55 77 10 80       	push   $0x80107755
80107037:	e8 44 93 ff ff       	call   80100380 <panic>
8010703c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107040:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107042:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107047:	c1 ea 0a             	shr    $0xa,%edx
8010704a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107050:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107057:	85 c0                	test   %eax,%eax
80107059:	74 d4                	je     8010702f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010705b:	8b 00                	mov    (%eax),%eax
8010705d:	a8 01                	test   $0x1,%al
8010705f:	0f 84 9f 00 00 00    	je     80107104 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107065:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107067:	25 ff 0f 00 00       	and    $0xfff,%eax
8010706c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010706f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107075:	e8 56 b6 ff ff       	call   801026d0 <kalloc>
8010707a:	89 c3                	mov    %eax,%ebx
8010707c:	85 c0                	test   %eax,%eax
8010707e:	74 64                	je     801070e4 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107080:	83 ec 04             	sub    $0x4,%esp
80107083:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107089:	68 00 10 00 00       	push   $0x1000
8010708e:	57                   	push   %edi
8010708f:	50                   	push   %eax
80107090:	e8 7b d7 ff ff       	call   80104810 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107095:	58                   	pop    %eax
80107096:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010709c:	5a                   	pop    %edx
8010709d:	ff 75 e4             	push   -0x1c(%ebp)
801070a0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801070a5:	89 f2                	mov    %esi,%edx
801070a7:	50                   	push   %eax
801070a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801070ab:	e8 90 f8 ff ff       	call   80106940 <mappages>
801070b0:	83 c4 10             	add    $0x10,%esp
801070b3:	85 c0                	test   %eax,%eax
801070b5:	78 21                	js     801070d8 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
801070b7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801070bd:	3b 75 0c             	cmp    0xc(%ebp),%esi
801070c0:	0f 82 5a ff ff ff    	jb     80107020 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
801070c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801070c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070cc:	5b                   	pop    %ebx
801070cd:	5e                   	pop    %esi
801070ce:	5f                   	pop    %edi
801070cf:	5d                   	pop    %ebp
801070d0:	c3                   	ret
801070d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801070d8:	83 ec 0c             	sub    $0xc,%esp
801070db:	53                   	push   %ebx
801070dc:	e8 2f b4 ff ff       	call   80102510 <kfree>
      goto bad;
801070e1:	83 c4 10             	add    $0x10,%esp
  freevm(d);
801070e4:	83 ec 0c             	sub    $0xc,%esp
801070e7:	ff 75 e0             	push   -0x20(%ebp)
801070ea:	e8 91 fd ff ff       	call   80106e80 <freevm>
  return 0;
801070ef:	83 c4 10             	add    $0x10,%esp
    return 0;
801070f2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
801070f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801070fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070ff:	5b                   	pop    %ebx
80107100:	5e                   	pop    %esi
80107101:	5f                   	pop    %edi
80107102:	5d                   	pop    %ebp
80107103:	c3                   	ret
      panic("copyuvm: page not present");
80107104:	83 ec 0c             	sub    $0xc,%esp
80107107:	68 6f 77 10 80       	push   $0x8010776f
8010710c:	e8 6f 92 ff ff       	call   80100380 <panic>
80107111:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107118:	00 
80107119:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107120 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107120:	55                   	push   %ebp
80107121:	89 e5                	mov    %esp,%ebp
80107123:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107126:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107129:	89 c1                	mov    %eax,%ecx
8010712b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010712e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107131:	f6 c2 01             	test   $0x1,%dl
80107134:	0f 84 f8 00 00 00    	je     80107232 <uva2ka.cold>
  return &pgtab[PTX(va)];
8010713a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010713d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107143:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107144:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107149:	8b 94 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107150:	89 d0                	mov    %edx,%eax
80107152:	f7 d2                	not    %edx
80107154:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107159:	05 00 00 00 80       	add    $0x80000000,%eax
8010715e:	83 e2 05             	and    $0x5,%edx
80107161:	ba 00 00 00 00       	mov    $0x0,%edx
80107166:	0f 45 c2             	cmovne %edx,%eax
}
80107169:	c3                   	ret
8010716a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107170 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107170:	55                   	push   %ebp
80107171:	89 e5                	mov    %esp,%ebp
80107173:	57                   	push   %edi
80107174:	56                   	push   %esi
80107175:	53                   	push   %ebx
80107176:	83 ec 0c             	sub    $0xc,%esp
80107179:	8b 75 14             	mov    0x14(%ebp),%esi
8010717c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010717f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107182:	85 f6                	test   %esi,%esi
80107184:	75 51                	jne    801071d7 <copyout+0x67>
80107186:	e9 9d 00 00 00       	jmp    80107228 <copyout+0xb8>
8010718b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  return (char*)P2V(PTE_ADDR(*pte));
80107190:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107196:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010719c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
801071a2:	74 74                	je     80107218 <copyout+0xa8>
      return -1;
    n = PGSIZE - (va - va0);
801071a4:	89 fb                	mov    %edi,%ebx
801071a6:	29 c3                	sub    %eax,%ebx
801071a8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
801071ae:	39 f3                	cmp    %esi,%ebx
801071b0:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801071b3:	29 f8                	sub    %edi,%eax
801071b5:	83 ec 04             	sub    $0x4,%esp
801071b8:	01 c1                	add    %eax,%ecx
801071ba:	53                   	push   %ebx
801071bb:	52                   	push   %edx
801071bc:	89 55 10             	mov    %edx,0x10(%ebp)
801071bf:	51                   	push   %ecx
801071c0:	e8 4b d6 ff ff       	call   80104810 <memmove>
    len -= n;
    buf += n;
801071c5:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
801071c8:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
801071ce:	83 c4 10             	add    $0x10,%esp
    buf += n;
801071d1:	01 da                	add    %ebx,%edx
  while(len > 0){
801071d3:	29 de                	sub    %ebx,%esi
801071d5:	74 51                	je     80107228 <copyout+0xb8>
  if(*pde & PTE_P){
801071d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
801071da:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801071dc:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
801071de:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801071e1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
801071e7:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
801071ea:	f6 c1 01             	test   $0x1,%cl
801071ed:	0f 84 46 00 00 00    	je     80107239 <copyout.cold>
  return &pgtab[PTX(va)];
801071f3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801071f5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801071fb:	c1 eb 0c             	shr    $0xc,%ebx
801071fe:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107204:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010720b:	89 d9                	mov    %ebx,%ecx
8010720d:	f7 d1                	not    %ecx
8010720f:	83 e1 05             	and    $0x5,%ecx
80107212:	0f 84 78 ff ff ff    	je     80107190 <copyout+0x20>
  }
  return 0;
}
80107218:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010721b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107220:	5b                   	pop    %ebx
80107221:	5e                   	pop    %esi
80107222:	5f                   	pop    %edi
80107223:	5d                   	pop    %ebp
80107224:	c3                   	ret
80107225:	8d 76 00             	lea    0x0(%esi),%esi
80107228:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010722b:	31 c0                	xor    %eax,%eax
}
8010722d:	5b                   	pop    %ebx
8010722e:	5e                   	pop    %esi
8010722f:	5f                   	pop    %edi
80107230:	5d                   	pop    %ebp
80107231:	c3                   	ret

80107232 <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80107232:	a1 00 00 00 00       	mov    0x0,%eax
80107237:	0f 0b                	ud2

80107239 <copyout.cold>:
80107239:	a1 00 00 00 00       	mov    0x0,%eax
8010723e:	0f 0b                	ud2
