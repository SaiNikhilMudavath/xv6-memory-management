
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
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
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
80100028:	bc c0 8b 11 80       	mov    $0x80118bc0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 f0 30 10 80       	mov    $0x801030f0,%eax
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
80100044:	bb 74 b5 10 80       	mov    $0x8010b574,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 40 79 10 80       	push   $0x80107940
80100051:	68 40 b5 10 80       	push   $0x8010b540
80100056:	e8 35 45 00 00       	call   80104590 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 3c fc 10 80       	mov    $0x8010fc3c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 8c fc 10 80 3c 	movl   $0x8010fc3c,0x8010fc8c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 90 fc 10 80 3c 	movl   $0x8010fc3c,0x8010fc90
80100074:	fc 10 80 
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
8010008b:	c7 43 50 3c fc 10 80 	movl   $0x8010fc3c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 47 79 10 80       	push   $0x80107947
80100097:	50                   	push   %eax
80100098:	e8 c3 43 00 00       	call   80104460 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 90 fc 10 80       	mov    0x8010fc90,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 90 fc 10 80    	mov    %ebx,0x8010fc90
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb e0 f9 10 80    	cmp    $0x8010f9e0,%ebx
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
801000df:	68 40 b5 10 80       	push   $0x8010b540
801000e4:	e8 97 46 00 00       	call   80104780 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 90 fc 10 80    	mov    0x8010fc90,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 3c fc 10 80    	cmp    $0x8010fc3c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 3c fc 10 80    	cmp    $0x8010fc3c,%ebx
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
80100120:	8b 1d 8c fc 10 80    	mov    0x8010fc8c,%ebx
80100126:	81 fb 3c fc 10 80    	cmp    $0x8010fc3c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 3c fc 10 80    	cmp    $0x8010fc3c,%ebx
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
8010015d:	68 40 b5 10 80       	push   $0x8010b540
80100162:	e8 b9 45 00 00       	call   80104720 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 2e 43 00 00       	call   801044a0 <acquiresleep>
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
8010018c:	e8 bf 21 00 00       	call   80102350 <iderw>
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
801001a1:	68 4e 79 10 80       	push   $0x8010794e
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
801001be:	e8 7d 43 00 00       	call   80104540 <holdingsleep>
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
801001d4:	e9 77 21 00 00       	jmp    80102350 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 5f 79 10 80       	push   $0x8010795f
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
801001ff:	e8 3c 43 00 00       	call   80104540 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 63                	je     8010026e <brelse+0x7e>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 ec 42 00 00       	call   80104500 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 40 b5 10 80 	movl   $0x8010b540,(%esp)
8010021b:	e8 60 45 00 00       	call   80104780 <acquire>
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
8010023f:	a1 90 fc 10 80       	mov    0x8010fc90,%eax
    b->prev = &bcache.head;
80100244:	c7 43 50 3c fc 10 80 	movl   $0x8010fc3c,0x50(%ebx)
    b->next = bcache.head.next;
8010024b:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
8010024e:	a1 90 fc 10 80       	mov    0x8010fc90,%eax
80100253:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100256:	89 1d 90 fc 10 80    	mov    %ebx,0x8010fc90
  }
  
  release(&bcache.lock);
8010025c:	c7 45 08 40 b5 10 80 	movl   $0x8010b540,0x8(%ebp)
}
80100263:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100266:	5b                   	pop    %ebx
80100267:	5e                   	pop    %esi
80100268:	5d                   	pop    %ebp
  release(&bcache.lock);
80100269:	e9 b2 44 00 00       	jmp    80104720 <release>
    panic("brelse");
8010026e:	83 ec 0c             	sub    $0xc,%esp
80100271:	68 66 79 10 80       	push   $0x80107966
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
80100294:	e8 67 16 00 00       	call   80101900 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 60 ff 10 80 	movl   $0x8010ff60,(%esp)
801002a0:	e8 db 44 00 00       	call   80104780 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 40 ff 10 80       	mov    0x8010ff40,%eax
801002b5:	39 05 44 ff 10 80    	cmp    %eax,0x8010ff44
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
801002c3:	68 60 ff 10 80       	push   $0x8010ff60
801002c8:	68 40 ff 10 80       	push   $0x8010ff40
801002cd:	e8 ae 3e 00 00       	call   80104180 <sleep>
    while(input.r == input.w){
801002d2:	a1 40 ff 10 80       	mov    0x8010ff40,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 44 ff 10 80    	cmp    0x8010ff44,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 c9 37 00 00       	call   80103ab0 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 60 ff 10 80       	push   $0x8010ff60
801002f6:	e8 25 44 00 00       	call   80104720 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 1c 15 00 00       	call   80101820 <ilock>
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
8010031b:	89 15 40 ff 10 80    	mov    %edx,0x8010ff40
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a c0 fe 10 80 	movsbl -0x7fef0140(%edx),%ecx
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
80100347:	68 60 ff 10 80       	push   $0x8010ff60
8010034c:	e8 cf 43 00 00       	call   80104720 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 c6 14 00 00       	call   80101820 <ilock>
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
8010036d:	a3 40 ff 10 80       	mov    %eax,0x8010ff40
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
80100389:	c7 05 94 ff 10 80 00 	movl   $0x0,0x8010ff94
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 f2 25 00 00       	call   80102990 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 6d 79 10 80       	push   $0x8010796d
801003a7:	e8 04 03 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 fb 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 19 7e 10 80 	movl   $0x80107e19,(%esp)
801003bc:	e8 ef 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 e3 41 00 00       	call   801045b0 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 81 79 10 80       	push   $0x80107981
801003dd:	e8 ce 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 98 ff 10 80 01 	movl   $0x1,0x8010ff98
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
8010041f:	e8 8c 5a 00 00       	call   80105eb0 <uartputc>
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
801004ea:	e8 c1 59 00 00       	call   80105eb0 <uartputc>
801004ef:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f6:	e8 b5 59 00 00       	call   80105eb0 <uartputc>
801004fb:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100502:	e8 a9 59 00 00       	call   80105eb0 <uartputc>
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
80100561:	e8 aa 43 00 00       	call   80104910 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 05 43 00 00       	call   80104880 <memset>
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
801005a3:	68 85 79 10 80       	push   $0x80107985
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
801005bf:	e8 3c 13 00 00       	call   80101900 <iunlock>
  acquire(&cons.lock);
801005c4:	c7 04 24 60 ff 10 80 	movl   $0x8010ff60,(%esp)
801005cb:	e8 b0 41 00 00       	call   80104780 <acquire>
  for(i = 0; i < n; i++)
801005d0:	83 c4 10             	add    $0x10,%esp
801005d3:	85 f6                	test   %esi,%esi
801005d5:	7e 25                	jle    801005fc <consolewrite+0x4c>
801005d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005da:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005dd:	8b 15 98 ff 10 80    	mov    0x8010ff98,%edx
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
801005ff:	68 60 ff 10 80       	push   $0x8010ff60
80100604:	e8 17 41 00 00       	call   80104720 <release>
  ilock(ip);
80100609:	58                   	pop    %eax
8010060a:	ff 75 08             	push   0x8(%ebp)
8010060d:	e8 0e 12 00 00       	call   80101820 <ilock>

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
8010064b:	0f b6 92 d0 7e 10 80 	movzbl -0x7fef8130(%edx),%edx
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
80100671:	8b 15 98 ff 10 80    	mov    0x8010ff98,%edx
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
801006b9:	8b 3d 94 ff 10 80    	mov    0x8010ff94,%edi
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
80100740:	8b 0d 98 ff 10 80    	mov    0x8010ff98,%ecx
80100746:	85 c9                	test   %ecx,%ecx
80100748:	74 19                	je     80100763 <cprintf+0xb3>
8010074a:	fa                   	cli
    for(;;)
8010074b:	eb fe                	jmp    8010074b <cprintf+0x9b>
8010074d:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
80100750:	8b 0d 98 ff 10 80    	mov    0x8010ff98,%ecx
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
8010077e:	8b 15 98 ff 10 80    	mov    0x8010ff98,%edx
80100784:	85 d2                	test   %edx,%edx
80100786:	0f 85 b8 00 00 00    	jne    80100844 <cprintf+0x194>
8010078c:	b8 25 00 00 00       	mov    $0x25,%eax
80100791:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100794:	e8 67 fc ff ff       	call   80100400 <consputc.part.0>
80100799:	a1 98 ff 10 80       	mov    0x8010ff98,%eax
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
801007d3:	68 60 ff 10 80       	push   $0x8010ff60
801007d8:	e8 a3 3f 00 00       	call   80104780 <acquire>
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
801007f6:	68 60 ff 10 80       	push   $0x8010ff60
801007fb:	e8 20 3f 00 00       	call   80104720 <release>
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
80100826:	8b 15 98 ff 10 80    	mov    0x8010ff98,%edx
8010082c:	85 d2                	test   %edx,%edx
8010082e:	74 28                	je     80100858 <cprintf+0x1a8>
80100830:	fa                   	cli
    for(;;)
80100831:	eb fe                	jmp    80100831 <cprintf+0x181>
80100833:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80100838:	b9 28 00 00 00       	mov    $0x28,%ecx
        s = "(null)";
8010083d:	bf 98 79 10 80       	mov    $0x80107998,%edi
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
8010088c:	68 9f 79 10 80       	push   $0x8010799f
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
801008ae:	68 60 ff 10 80       	push   $0x8010ff60
801008b3:	e8 c8 3e 00 00       	call   80104780 <acquire>
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
801008e0:	c7 05 a0 fe 10 80 01 	movl   $0x1,0x8010fea0
801008e7:	00 00 00 
  while((c = getc()) >= 0){
801008ea:	ff d6                	call   *%esi
801008ec:	89 c3                	mov    %eax,%ebx
801008ee:	85 c0                	test   %eax,%eax
801008f0:	79 d1                	jns    801008c3 <consoleintr+0x23>
  release(&cons.lock);
801008f2:	83 ec 0c             	sub    $0xc,%esp
801008f5:	68 60 ff 10 80       	push   $0x8010ff60
801008fa:	e8 21 3e 00 00       	call   80104720 <release>
  if(check_cntrl_i)
801008ff:	a1 a0 fe 10 80       	mov    0x8010fea0,%eax
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
80100932:	a1 48 ff 10 80       	mov    0x8010ff48,%eax
80100937:	89 c2                	mov    %eax,%edx
80100939:	2b 15 40 ff 10 80    	sub    0x8010ff40,%edx
8010093f:	83 fa 7f             	cmp    $0x7f,%edx
80100942:	0f 87 73 ff ff ff    	ja     801008bb <consoleintr+0x1b>
  if(panicked){
80100948:	8b 0d 98 ff 10 80    	mov    0x8010ff98,%ecx
        input.buf[input.e++ % INPUT_BUF] = c;
8010094e:	8d 50 01             	lea    0x1(%eax),%edx
80100951:	83 e0 7f             	and    $0x7f,%eax
80100954:	89 15 48 ff 10 80    	mov    %edx,0x8010ff48
8010095a:	88 98 c0 fe 10 80    	mov    %bl,-0x7fef0140(%eax)
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
80100981:	a1 40 ff 10 80       	mov    0x8010ff40,%eax
80100986:	83 e8 80             	sub    $0xffffff80,%eax
80100989:	39 05 48 ff 10 80    	cmp    %eax,0x8010ff48
8010098f:	0f 85 26 ff ff ff    	jne    801008bb <consoleintr+0x1b>
80100995:	e9 d3 00 00 00       	jmp    80100a6d <consoleintr+0x1cd>
8010099a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801009a0:	b8 00 01 00 00       	mov    $0x100,%eax
801009a5:	e8 56 fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
801009aa:	a1 48 ff 10 80       	mov    0x8010ff48,%eax
801009af:	3b 05 44 ff 10 80    	cmp    0x8010ff44,%eax
801009b5:	0f 84 00 ff ff ff    	je     801008bb <consoleintr+0x1b>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801009bb:	83 e8 01             	sub    $0x1,%eax
801009be:	89 c2                	mov    %eax,%edx
801009c0:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
801009c3:	80 ba c0 fe 10 80 0a 	cmpb   $0xa,-0x7fef0140(%edx)
801009ca:	0f 84 eb fe ff ff    	je     801008bb <consoleintr+0x1b>
  if(panicked){
801009d0:	8b 0d 98 ff 10 80    	mov    0x8010ff98,%ecx
        input.e--;
801009d6:	a3 48 ff 10 80       	mov    %eax,0x8010ff48
  if(panicked){
801009db:	85 c9                	test   %ecx,%ecx
801009dd:	74 c1                	je     801009a0 <consoleintr+0x100>
801009df:	fa                   	cli
    for(;;)
801009e0:	eb fe                	jmp    801009e0 <consoleintr+0x140>
801009e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(input.e != input.w){
801009e8:	a1 48 ff 10 80       	mov    0x8010ff48,%eax
801009ed:	3b 05 44 ff 10 80    	cmp    0x8010ff44,%eax
801009f3:	0f 84 c2 fe ff ff    	je     801008bb <consoleintr+0x1b>
  if(panicked){
801009f9:	8b 15 98 ff 10 80    	mov    0x8010ff98,%edx
        input.e--;
801009ff:	83 e8 01             	sub    $0x1,%eax
80100a02:	a3 48 ff 10 80       	mov    %eax,0x8010ff48
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
80100a22:	a1 48 ff 10 80       	mov    0x8010ff48,%eax
80100a27:	89 c2                	mov    %eax,%edx
80100a29:	2b 15 40 ff 10 80    	sub    0x8010ff40,%edx
80100a2f:	83 fa 7f             	cmp    $0x7f,%edx
80100a32:	0f 87 83 fe ff ff    	ja     801008bb <consoleintr+0x1b>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a38:	8d 50 01             	lea    0x1(%eax),%edx
  if(panicked){
80100a3b:	8b 0d 98 ff 10 80    	mov    0x8010ff98,%ecx
        input.buf[input.e++ % INPUT_BUF] = c;
80100a41:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
80100a44:	83 fb 0d             	cmp    $0xd,%ebx
80100a47:	0f 85 07 ff ff ff    	jne    80100954 <consoleintr+0xb4>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a4d:	89 15 48 ff 10 80    	mov    %edx,0x8010ff48
80100a53:	c6 80 c0 fe 10 80 0a 	movb   $0xa,-0x7fef0140(%eax)
  if(panicked){
80100a5a:	85 c9                	test   %ecx,%ecx
80100a5c:	75 38                	jne    80100a96 <consoleintr+0x1f6>
80100a5e:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a63:	e8 98 f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a68:	a1 48 ff 10 80       	mov    0x8010ff48,%eax
          wakeup(&input.r);
80100a6d:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a70:	a3 44 ff 10 80       	mov    %eax,0x8010ff44
          wakeup(&input.r);
80100a75:	68 40 ff 10 80       	push   $0x8010ff40
80100a7a:	e8 c1 37 00 00       	call   80104240 <wakeup>
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
80100aa7:	e9 74 38 00 00       	jmp    80104320 <procdump>
    cprintf("Ctrl+I is detected by xv6\n");
80100aac:	83 ec 0c             	sub    $0xc,%esp
80100aaf:	68 a8 79 10 80       	push   $0x801079a8
80100ab4:	e8 f7 fb ff ff       	call   801006b0 <cprintf>
    print_mem_layout();
80100ab9:	e8 d2 2e 00 00       	call   80103990 <print_mem_layout>
    check_cntrl_i=0;
80100abe:	83 c4 10             	add    $0x10,%esp
80100ac1:	c7 05 a0 fe 10 80 00 	movl   $0x0,0x8010fea0
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
80100ad6:	68 c3 79 10 80       	push   $0x801079c3
80100adb:	68 60 ff 10 80       	push   $0x8010ff60
80100ae0:	e8 ab 3a 00 00       	call   80104590 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100ae5:	58                   	pop    %eax
80100ae6:	5a                   	pop    %edx
80100ae7:	6a 00                	push   $0x0
80100ae9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100aeb:	c7 05 4c 09 11 80 b0 	movl   $0x801005b0,0x8011094c
80100af2:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100af5:	c7 05 48 09 11 80 80 	movl   $0x80100280,0x80110948
80100afc:	02 10 80 
  cons.locking = 1;
80100aff:	c7 05 94 ff 10 80 01 	movl   $0x1,0x8010ff94
80100b06:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100b09:	e8 d2 19 00 00       	call   801024e0 <ioapicenable>
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
#include "elf.h"

extern int count_mem_pages(struct proc*);
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
80100b2c:	e8 7f 2f 00 00       	call   80103ab0 <myproc>
80100b31:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100b37:	e8 c4 22 00 00       	call   80102e00 <begin_op>

  if((ip = namei(path)) == 0){
80100b3c:	83 ec 0c             	sub    $0xc,%esp
80100b3f:	ff 75 08             	push   0x8(%ebp)
80100b42:	e8 b9 15 00 00       	call   80102100 <namei>
80100b47:	83 c4 10             	add    $0x10,%esp
80100b4a:	85 c0                	test   %eax,%eax
80100b4c:	0f 84 3b 03 00 00    	je     80100e8d <exec+0x36d>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100b52:	83 ec 0c             	sub    $0xc,%esp
80100b55:	89 c7                	mov    %eax,%edi
80100b57:	50                   	push   %eax
80100b58:	e8 c3 0c 00 00       	call   80101820 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100b5d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100b63:	6a 34                	push   $0x34
80100b65:	6a 00                	push   $0x0
80100b67:	50                   	push   %eax
80100b68:	57                   	push   %edi
80100b69:	e8 c2 0f 00 00       	call   80101b30 <readi>
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
80100b8a:	e8 a1 65 00 00       	call   80107130 <setupkvm>
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
80100bab:	0f 84 ac 02 00 00    	je     80100e5d <exec+0x33d>
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
80100bfb:	e8 60 63 00 00       	call   80106f60 <allocuvm>
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
80100c31:	e8 5a 62 00 00       	call   80106e90 <loaduvm>
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
80100c59:	e8 d2 0e 00 00       	call   80101b30 <readi>
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
80100c73:	e8 38 64 00 00       	call   801070b0 <freevm>
  if(ip){
80100c78:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80100c7b:	83 ec 0c             	sub    $0xc,%esp
80100c7e:	57                   	push   %edi
80100c7f:	e8 2c 0e 00 00       	call   80101ab0 <iunlockput>
    end_op();
80100c84:	e8 e7 21 00 00       	call   80102e70 <end_op>
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
80100cbc:	e8 ef 0d 00 00       	call   80101ab0 <iunlockput>
  end_op();
80100cc1:	e8 aa 21 00 00       	call   80102e70 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100cc6:	83 c4 0c             	add    $0xc,%esp
80100cc9:	53                   	push   %ebx
80100cca:	56                   	push   %esi
80100ccb:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100cd1:	56                   	push   %esi
80100cd2:	e8 89 62 00 00       	call   80106f60 <allocuvm>
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
80100cf3:	e8 d8 64 00 00       	call   801071d0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100cf8:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cfb:	83 c4 10             	add    $0x10,%esp
80100cfe:	8b 10                	mov    (%eax),%edx
80100d00:	85 d2                	test   %edx,%edx
80100d02:	0f 84 61 01 00 00    	je     80100e69 <exec+0x349>
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
80100d3a:	e8 31 3d 00 00       	call   80104a70 <strlen>
80100d3f:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d41:	58                   	pop    %eax
80100d42:	ff 34 b7             	push   (%edi,%esi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d45:	83 eb 01             	sub    $0x1,%ebx
80100d48:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d4b:	e8 20 3d 00 00       	call   80104a70 <strlen>
80100d50:	83 c0 01             	add    $0x1,%eax
80100d53:	50                   	push   %eax
80100d54:	ff 34 b7             	push   (%edi,%esi,4)
80100d57:	53                   	push   %ebx
80100d58:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d5e:	e8 3d 66 00 00       	call   801073a0 <copyout>
80100d63:	83 c4 20             	add    $0x20,%esp
80100d66:	85 c0                	test   %eax,%eax
80100d68:	79 ae                	jns    80100d18 <exec+0x1f8>
    freevm(pgdir);
80100d6a:	83 ec 0c             	sub    $0xc,%esp
80100d6d:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d73:	e8 38 63 00 00       	call   801070b0 <freevm>
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
80100dcf:	e8 cc 65 00 00       	call   801073a0 <copyout>
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
80100e0f:	e8 1c 3c 00 00       	call   80104a30 <safestrcpy>
  curproc->pgdir = pgdir;
80100e14:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100e1a:	89 f0                	mov    %esi,%eax
80100e1c:	8b 76 04             	mov    0x4(%esi),%esi
  curproc->sz = sz;
80100e1f:	89 38                	mov    %edi,(%eax)
  curproc->tf->eip = elf.entry;  // main
80100e21:	89 c7                	mov    %eax,%edi
  curproc->pgdir = pgdir;
80100e23:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100e26:	8b 40 18             	mov    0x18(%eax),%eax
80100e29:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100e2f:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100e32:	8b 47 18             	mov    0x18(%edi),%eax
80100e35:	89 58 44             	mov    %ebx,0x44(%eax)
  int x=count_mem_pages(curproc);
80100e38:	89 3c 24             	mov    %edi,(%esp)
80100e3b:	e8 a0 5d 00 00       	call   80106be0 <count_mem_pages>
  curproc->rss=x;
80100e40:	89 47 7c             	mov    %eax,0x7c(%edi)
  switchuvm(curproc);
80100e43:	89 3c 24             	mov    %edi,(%esp)
80100e46:	e8 b5 5e 00 00       	call   80106d00 <switchuvm>
  freevm(oldpgdir);
80100e4b:	89 34 24             	mov    %esi,(%esp)
80100e4e:	e8 5d 62 00 00       	call   801070b0 <freevm>
  return 0;
80100e53:	83 c4 10             	add    $0x10,%esp
80100e56:	31 c0                	xor    %eax,%eax
80100e58:	e9 34 fe ff ff       	jmp    80100c91 <exec+0x171>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e5d:	bb 00 20 00 00       	mov    $0x2000,%ebx
80100e62:	31 f6                	xor    %esi,%esi
80100e64:	e9 4f fe ff ff       	jmp    80100cb8 <exec+0x198>
  for(argc = 0; argv[argc]; argc++) {
80100e69:	be 10 00 00 00       	mov    $0x10,%esi
80100e6e:	ba 04 00 00 00       	mov    $0x4,%edx
80100e73:	b8 03 00 00 00       	mov    $0x3,%eax
80100e78:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100e7f:	00 00 00 
80100e82:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100e88:	e9 0c ff ff ff       	jmp    80100d99 <exec+0x279>
    end_op();
80100e8d:	e8 de 1f 00 00       	call   80102e70 <end_op>
    cprintf("exec: fail\n");
80100e92:	83 ec 0c             	sub    $0xc,%esp
80100e95:	68 cb 79 10 80       	push   $0x801079cb
80100e9a:	e8 11 f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100e9f:	83 c4 10             	add    $0x10,%esp
80100ea2:	e9 e5 fd ff ff       	jmp    80100c8c <exec+0x16c>
80100ea7:	66 90                	xchg   %ax,%ax
80100ea9:	66 90                	xchg   %ax,%ax
80100eab:	66 90                	xchg   %ax,%ax
80100ead:	66 90                	xchg   %ax,%ax
80100eaf:	90                   	nop

80100eb0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100eb0:	55                   	push   %ebp
80100eb1:	89 e5                	mov    %esp,%ebp
80100eb3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100eb6:	68 d7 79 10 80       	push   $0x801079d7
80100ebb:	68 a0 ff 10 80       	push   $0x8010ffa0
80100ec0:	e8 cb 36 00 00       	call   80104590 <initlock>
}
80100ec5:	83 c4 10             	add    $0x10,%esp
80100ec8:	c9                   	leave
80100ec9:	c3                   	ret
80100eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100ed0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100ed0:	55                   	push   %ebp
80100ed1:	89 e5                	mov    %esp,%ebp
80100ed3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ed4:	bb d4 ff 10 80       	mov    $0x8010ffd4,%ebx
{
80100ed9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100edc:	68 a0 ff 10 80       	push   $0x8010ffa0
80100ee1:	e8 9a 38 00 00       	call   80104780 <acquire>
80100ee6:	83 c4 10             	add    $0x10,%esp
80100ee9:	eb 10                	jmp    80100efb <filealloc+0x2b>
80100eeb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ef0:	83 c3 18             	add    $0x18,%ebx
80100ef3:	81 fb 34 09 11 80    	cmp    $0x80110934,%ebx
80100ef9:	74 25                	je     80100f20 <filealloc+0x50>
    if(f->ref == 0){
80100efb:	8b 43 04             	mov    0x4(%ebx),%eax
80100efe:	85 c0                	test   %eax,%eax
80100f00:	75 ee                	jne    80100ef0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100f02:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100f05:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100f0c:	68 a0 ff 10 80       	push   $0x8010ffa0
80100f11:	e8 0a 38 00 00       	call   80104720 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100f16:	89 d8                	mov    %ebx,%eax
      return f;
80100f18:	83 c4 10             	add    $0x10,%esp
}
80100f1b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f1e:	c9                   	leave
80100f1f:	c3                   	ret
  release(&ftable.lock);
80100f20:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100f23:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100f25:	68 a0 ff 10 80       	push   $0x8010ffa0
80100f2a:	e8 f1 37 00 00       	call   80104720 <release>
}
80100f2f:	89 d8                	mov    %ebx,%eax
  return 0;
80100f31:	83 c4 10             	add    $0x10,%esp
}
80100f34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f37:	c9                   	leave
80100f38:	c3                   	ret
80100f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100f40 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100f40:	55                   	push   %ebp
80100f41:	89 e5                	mov    %esp,%ebp
80100f43:	53                   	push   %ebx
80100f44:	83 ec 10             	sub    $0x10,%esp
80100f47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100f4a:	68 a0 ff 10 80       	push   $0x8010ffa0
80100f4f:	e8 2c 38 00 00       	call   80104780 <acquire>
  if(f->ref < 1)
80100f54:	8b 43 04             	mov    0x4(%ebx),%eax
80100f57:	83 c4 10             	add    $0x10,%esp
80100f5a:	85 c0                	test   %eax,%eax
80100f5c:	7e 1a                	jle    80100f78 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100f5e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100f61:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100f64:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100f67:	68 a0 ff 10 80       	push   $0x8010ffa0
80100f6c:	e8 af 37 00 00       	call   80104720 <release>
  return f;
}
80100f71:	89 d8                	mov    %ebx,%eax
80100f73:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f76:	c9                   	leave
80100f77:	c3                   	ret
    panic("filedup");
80100f78:	83 ec 0c             	sub    $0xc,%esp
80100f7b:	68 de 79 10 80       	push   $0x801079de
80100f80:	e8 fb f3 ff ff       	call   80100380 <panic>
80100f85:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100f8c:	00 
80100f8d:	8d 76 00             	lea    0x0(%esi),%esi

80100f90 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f90:	55                   	push   %ebp
80100f91:	89 e5                	mov    %esp,%ebp
80100f93:	57                   	push   %edi
80100f94:	56                   	push   %esi
80100f95:	53                   	push   %ebx
80100f96:	83 ec 28             	sub    $0x28,%esp
80100f99:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f9c:	68 a0 ff 10 80       	push   $0x8010ffa0
80100fa1:	e8 da 37 00 00       	call   80104780 <acquire>
  if(f->ref < 1)
80100fa6:	8b 53 04             	mov    0x4(%ebx),%edx
80100fa9:	83 c4 10             	add    $0x10,%esp
80100fac:	85 d2                	test   %edx,%edx
80100fae:	0f 8e a5 00 00 00    	jle    80101059 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100fb4:	83 ea 01             	sub    $0x1,%edx
80100fb7:	89 53 04             	mov    %edx,0x4(%ebx)
80100fba:	75 44                	jne    80101000 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100fbc:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100fc0:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100fc3:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100fc5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100fcb:	8b 73 0c             	mov    0xc(%ebx),%esi
80100fce:	88 45 e7             	mov    %al,-0x19(%ebp)
80100fd1:	8b 43 10             	mov    0x10(%ebx),%eax
80100fd4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100fd7:	68 a0 ff 10 80       	push   $0x8010ffa0
80100fdc:	e8 3f 37 00 00       	call   80104720 <release>

  if(ff.type == FD_PIPE)
80100fe1:	83 c4 10             	add    $0x10,%esp
80100fe4:	83 ff 01             	cmp    $0x1,%edi
80100fe7:	74 57                	je     80101040 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100fe9:	83 ff 02             	cmp    $0x2,%edi
80100fec:	74 2a                	je     80101018 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100fee:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ff1:	5b                   	pop    %ebx
80100ff2:	5e                   	pop    %esi
80100ff3:	5f                   	pop    %edi
80100ff4:	5d                   	pop    %ebp
80100ff5:	c3                   	ret
80100ff6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80100ffd:	00 
80100ffe:	66 90                	xchg   %ax,%ax
    release(&ftable.lock);
80101000:	c7 45 08 a0 ff 10 80 	movl   $0x8010ffa0,0x8(%ebp)
}
80101007:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010100a:	5b                   	pop    %ebx
8010100b:	5e                   	pop    %esi
8010100c:	5f                   	pop    %edi
8010100d:	5d                   	pop    %ebp
    release(&ftable.lock);
8010100e:	e9 0d 37 00 00       	jmp    80104720 <release>
80101013:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    begin_op();
80101018:	e8 e3 1d 00 00       	call   80102e00 <begin_op>
    iput(ff.ip);
8010101d:	83 ec 0c             	sub    $0xc,%esp
80101020:	ff 75 e0             	push   -0x20(%ebp)
80101023:	e8 28 09 00 00       	call   80101950 <iput>
    end_op();
80101028:	83 c4 10             	add    $0x10,%esp
}
8010102b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010102e:	5b                   	pop    %ebx
8010102f:	5e                   	pop    %esi
80101030:	5f                   	pop    %edi
80101031:	5d                   	pop    %ebp
    end_op();
80101032:	e9 39 1e 00 00       	jmp    80102e70 <end_op>
80101037:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010103e:	00 
8010103f:	90                   	nop
    pipeclose(ff.pipe, ff.writable);
80101040:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80101044:	83 ec 08             	sub    $0x8,%esp
80101047:	53                   	push   %ebx
80101048:	56                   	push   %esi
80101049:	e8 72 25 00 00       	call   801035c0 <pipeclose>
8010104e:	83 c4 10             	add    $0x10,%esp
}
80101051:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101054:	5b                   	pop    %ebx
80101055:	5e                   	pop    %esi
80101056:	5f                   	pop    %edi
80101057:	5d                   	pop    %ebp
80101058:	c3                   	ret
    panic("fileclose");
80101059:	83 ec 0c             	sub    $0xc,%esp
8010105c:	68 e6 79 10 80       	push   $0x801079e6
80101061:	e8 1a f3 ff ff       	call   80100380 <panic>
80101066:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010106d:	00 
8010106e:	66 90                	xchg   %ax,%ax

80101070 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101070:	55                   	push   %ebp
80101071:	89 e5                	mov    %esp,%ebp
80101073:	53                   	push   %ebx
80101074:	83 ec 04             	sub    $0x4,%esp
80101077:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010107a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010107d:	75 31                	jne    801010b0 <filestat+0x40>
    ilock(f->ip);
8010107f:	83 ec 0c             	sub    $0xc,%esp
80101082:	ff 73 10             	push   0x10(%ebx)
80101085:	e8 96 07 00 00       	call   80101820 <ilock>
    stati(f->ip, st);
8010108a:	58                   	pop    %eax
8010108b:	5a                   	pop    %edx
8010108c:	ff 75 0c             	push   0xc(%ebp)
8010108f:	ff 73 10             	push   0x10(%ebx)
80101092:	e8 69 0a 00 00       	call   80101b00 <stati>
    iunlock(f->ip);
80101097:	59                   	pop    %ecx
80101098:	ff 73 10             	push   0x10(%ebx)
8010109b:	e8 60 08 00 00       	call   80101900 <iunlock>
    return 0;
  }
  return -1;
}
801010a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
801010a3:	83 c4 10             	add    $0x10,%esp
801010a6:	31 c0                	xor    %eax,%eax
}
801010a8:	c9                   	leave
801010a9:	c3                   	ret
801010aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801010b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801010b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801010b8:	c9                   	leave
801010b9:	c3                   	ret
801010ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801010c0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801010c0:	55                   	push   %ebp
801010c1:	89 e5                	mov    %esp,%ebp
801010c3:	57                   	push   %edi
801010c4:	56                   	push   %esi
801010c5:	53                   	push   %ebx
801010c6:	83 ec 0c             	sub    $0xc,%esp
801010c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010cc:	8b 75 0c             	mov    0xc(%ebp),%esi
801010cf:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
801010d2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
801010d6:	74 60                	je     80101138 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
801010d8:	8b 03                	mov    (%ebx),%eax
801010da:	83 f8 01             	cmp    $0x1,%eax
801010dd:	74 41                	je     80101120 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010df:	83 f8 02             	cmp    $0x2,%eax
801010e2:	75 5b                	jne    8010113f <fileread+0x7f>
    ilock(f->ip);
801010e4:	83 ec 0c             	sub    $0xc,%esp
801010e7:	ff 73 10             	push   0x10(%ebx)
801010ea:	e8 31 07 00 00       	call   80101820 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801010ef:	57                   	push   %edi
801010f0:	ff 73 14             	push   0x14(%ebx)
801010f3:	56                   	push   %esi
801010f4:	ff 73 10             	push   0x10(%ebx)
801010f7:	e8 34 0a 00 00       	call   80101b30 <readi>
801010fc:	83 c4 20             	add    $0x20,%esp
801010ff:	89 c6                	mov    %eax,%esi
80101101:	85 c0                	test   %eax,%eax
80101103:	7e 03                	jle    80101108 <fileread+0x48>
      f->off += r;
80101105:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101108:	83 ec 0c             	sub    $0xc,%esp
8010110b:	ff 73 10             	push   0x10(%ebx)
8010110e:	e8 ed 07 00 00       	call   80101900 <iunlock>
    return r;
80101113:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101116:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101119:	89 f0                	mov    %esi,%eax
8010111b:	5b                   	pop    %ebx
8010111c:	5e                   	pop    %esi
8010111d:	5f                   	pop    %edi
8010111e:	5d                   	pop    %ebp
8010111f:	c3                   	ret
    return piperead(f->pipe, addr, n);
80101120:	8b 43 0c             	mov    0xc(%ebx),%eax
80101123:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101126:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101129:	5b                   	pop    %ebx
8010112a:	5e                   	pop    %esi
8010112b:	5f                   	pop    %edi
8010112c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010112d:	e9 4e 26 00 00       	jmp    80103780 <piperead>
80101132:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101138:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010113d:	eb d7                	jmp    80101116 <fileread+0x56>
  panic("fileread");
8010113f:	83 ec 0c             	sub    $0xc,%esp
80101142:	68 f0 79 10 80       	push   $0x801079f0
80101147:	e8 34 f2 ff ff       	call   80100380 <panic>
8010114c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101150 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101150:	55                   	push   %ebp
80101151:	89 e5                	mov    %esp,%ebp
80101153:	57                   	push   %edi
80101154:	56                   	push   %esi
80101155:	53                   	push   %ebx
80101156:	83 ec 1c             	sub    $0x1c,%esp
80101159:	8b 45 0c             	mov    0xc(%ebp),%eax
8010115c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010115f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101162:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101165:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
80101169:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010116c:	0f 84 bb 00 00 00    	je     8010122d <filewrite+0xdd>
    return -1;
  if(f->type == FD_PIPE)
80101172:	8b 03                	mov    (%ebx),%eax
80101174:	83 f8 01             	cmp    $0x1,%eax
80101177:	0f 84 bf 00 00 00    	je     8010123c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010117d:	83 f8 02             	cmp    $0x2,%eax
80101180:	0f 85 c8 00 00 00    	jne    8010124e <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101186:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101189:	31 f6                	xor    %esi,%esi
    while(i < n){
8010118b:	85 c0                	test   %eax,%eax
8010118d:	7f 30                	jg     801011bf <filewrite+0x6f>
8010118f:	e9 94 00 00 00       	jmp    80101228 <filewrite+0xd8>
80101194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101198:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010119b:	83 ec 0c             	sub    $0xc,%esp
        f->off += r;
8010119e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801011a1:	ff 73 10             	push   0x10(%ebx)
801011a4:	e8 57 07 00 00       	call   80101900 <iunlock>
      end_op();
801011a9:	e8 c2 1c 00 00       	call   80102e70 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801011ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011b1:	83 c4 10             	add    $0x10,%esp
801011b4:	39 c7                	cmp    %eax,%edi
801011b6:	75 5c                	jne    80101214 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
801011b8:	01 fe                	add    %edi,%esi
    while(i < n){
801011ba:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
801011bd:	7e 69                	jle    80101228 <filewrite+0xd8>
      int n1 = n - i;
801011bf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      if(n1 > max)
801011c2:	b8 00 06 00 00       	mov    $0x600,%eax
      int n1 = n - i;
801011c7:	29 f7                	sub    %esi,%edi
      if(n1 > max)
801011c9:	39 c7                	cmp    %eax,%edi
801011cb:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
801011ce:	e8 2d 1c 00 00       	call   80102e00 <begin_op>
      ilock(f->ip);
801011d3:	83 ec 0c             	sub    $0xc,%esp
801011d6:	ff 73 10             	push   0x10(%ebx)
801011d9:	e8 42 06 00 00       	call   80101820 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801011de:	57                   	push   %edi
801011df:	ff 73 14             	push   0x14(%ebx)
801011e2:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011e5:	01 f0                	add    %esi,%eax
801011e7:	50                   	push   %eax
801011e8:	ff 73 10             	push   0x10(%ebx)
801011eb:	e8 40 0a 00 00       	call   80101c30 <writei>
801011f0:	83 c4 20             	add    $0x20,%esp
801011f3:	85 c0                	test   %eax,%eax
801011f5:	7f a1                	jg     80101198 <filewrite+0x48>
801011f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801011fa:	83 ec 0c             	sub    $0xc,%esp
801011fd:	ff 73 10             	push   0x10(%ebx)
80101200:	e8 fb 06 00 00       	call   80101900 <iunlock>
      end_op();
80101205:	e8 66 1c 00 00       	call   80102e70 <end_op>
      if(r < 0)
8010120a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010120d:	83 c4 10             	add    $0x10,%esp
80101210:	85 c0                	test   %eax,%eax
80101212:	75 14                	jne    80101228 <filewrite+0xd8>
        panic("short filewrite");
80101214:	83 ec 0c             	sub    $0xc,%esp
80101217:	68 f9 79 10 80       	push   $0x801079f9
8010121c:	e8 5f f1 ff ff       	call   80100380 <panic>
80101221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101228:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
8010122b:	74 05                	je     80101232 <filewrite+0xe2>
8010122d:	be ff ff ff ff       	mov    $0xffffffff,%esi
  }
  panic("filewrite");
}
80101232:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101235:	89 f0                	mov    %esi,%eax
80101237:	5b                   	pop    %ebx
80101238:	5e                   	pop    %esi
80101239:	5f                   	pop    %edi
8010123a:	5d                   	pop    %ebp
8010123b:	c3                   	ret
    return pipewrite(f->pipe, addr, n);
8010123c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010123f:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101242:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101245:	5b                   	pop    %ebx
80101246:	5e                   	pop    %esi
80101247:	5f                   	pop    %edi
80101248:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101249:	e9 12 24 00 00       	jmp    80103660 <pipewrite>
  panic("filewrite");
8010124e:	83 ec 0c             	sub    $0xc,%esp
80101251:	68 ff 79 10 80       	push   $0x801079ff
80101256:	e8 25 f1 ff ff       	call   80100380 <panic>
8010125b:	66 90                	xchg   %ax,%ax
8010125d:	66 90                	xchg   %ax,%ax
8010125f:	90                   	nop

80101260 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101260:	55                   	push   %ebp
80101261:	89 e5                	mov    %esp,%ebp
80101263:	57                   	push   %edi
80101264:	56                   	push   %esi
80101265:	53                   	push   %ebx
80101266:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101269:	8b 0d 00 26 11 80    	mov    0x80112600,%ecx
{
8010126f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101272:	85 c9                	test   %ecx,%ecx
80101274:	0f 84 8c 00 00 00    	je     80101306 <balloc+0xa6>
8010127a:	31 ff                	xor    %edi,%edi
    bp = bread(dev, BBLOCK(b, sb));
8010127c:	89 f8                	mov    %edi,%eax
8010127e:	83 ec 08             	sub    $0x8,%esp
80101281:	89 fe                	mov    %edi,%esi
80101283:	c1 f8 0c             	sar    $0xc,%eax
80101286:	03 05 18 26 11 80    	add    0x80112618,%eax
8010128c:	50                   	push   %eax
8010128d:	ff 75 dc             	push   -0x24(%ebp)
80101290:	e8 3b ee ff ff       	call   801000d0 <bread>
80101295:	83 c4 10             	add    $0x10,%esp
80101298:	89 7d d8             	mov    %edi,-0x28(%ebp)
8010129b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010129e:	a1 00 26 11 80       	mov    0x80112600,%eax
801012a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
801012a6:	31 c0                	xor    %eax,%eax
801012a8:	eb 32                	jmp    801012dc <balloc+0x7c>
801012aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801012b0:	89 c1                	mov    %eax,%ecx
801012b2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012b7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
      m = 1 << (bi % 8);
801012ba:	83 e1 07             	and    $0x7,%ecx
801012bd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012bf:	89 c1                	mov    %eax,%ecx
801012c1:	c1 f9 03             	sar    $0x3,%ecx
801012c4:	0f b6 7c 0f 5c       	movzbl 0x5c(%edi,%ecx,1),%edi
801012c9:	89 fa                	mov    %edi,%edx
801012cb:	85 df                	test   %ebx,%edi
801012cd:	74 49                	je     80101318 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012cf:	83 c0 01             	add    $0x1,%eax
801012d2:	83 c6 01             	add    $0x1,%esi
801012d5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012da:	74 07                	je     801012e3 <balloc+0x83>
801012dc:	8b 55 e0             	mov    -0x20(%ebp),%edx
801012df:	39 d6                	cmp    %edx,%esi
801012e1:	72 cd                	jb     801012b0 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801012e3:	8b 7d d8             	mov    -0x28(%ebp),%edi
801012e6:	83 ec 0c             	sub    $0xc,%esp
801012e9:	ff 75 e4             	push   -0x1c(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801012ec:	81 c7 00 10 00 00    	add    $0x1000,%edi
    brelse(bp);
801012f2:	e8 f9 ee ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012f7:	83 c4 10             	add    $0x10,%esp
801012fa:	3b 3d 00 26 11 80    	cmp    0x80112600,%edi
80101300:	0f 82 76 ff ff ff    	jb     8010127c <balloc+0x1c>
  }
  panic("balloc: out of blocks");
80101306:	83 ec 0c             	sub    $0xc,%esp
80101309:	68 09 7a 10 80       	push   $0x80107a09
8010130e:	e8 6d f0 ff ff       	call   80100380 <panic>
80101313:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
80101318:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
8010131b:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
8010131e:	09 da                	or     %ebx,%edx
80101320:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
80101324:	57                   	push   %edi
80101325:	e8 b6 1c 00 00       	call   80102fe0 <log_write>
        brelse(bp);
8010132a:	89 3c 24             	mov    %edi,(%esp)
8010132d:	e8 be ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
80101332:	58                   	pop    %eax
80101333:	5a                   	pop    %edx
80101334:	56                   	push   %esi
80101335:	ff 75 dc             	push   -0x24(%ebp)
80101338:	e8 93 ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
8010133d:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101340:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101342:	8d 40 5c             	lea    0x5c(%eax),%eax
80101345:	68 00 02 00 00       	push   $0x200
8010134a:	6a 00                	push   $0x0
8010134c:	50                   	push   %eax
8010134d:	e8 2e 35 00 00       	call   80104880 <memset>
  log_write(bp);
80101352:	89 1c 24             	mov    %ebx,(%esp)
80101355:	e8 86 1c 00 00       	call   80102fe0 <log_write>
  brelse(bp);
8010135a:	89 1c 24             	mov    %ebx,(%esp)
8010135d:	e8 8e ee ff ff       	call   801001f0 <brelse>
}
80101362:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101365:	89 f0                	mov    %esi,%eax
80101367:	5b                   	pop    %ebx
80101368:	5e                   	pop    %esi
80101369:	5f                   	pop    %edi
8010136a:	5d                   	pop    %ebp
8010136b:	c3                   	ret
8010136c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101370 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101370:	55                   	push   %ebp
80101371:	89 e5                	mov    %esp,%ebp
80101373:	57                   	push   %edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101374:	31 ff                	xor    %edi,%edi
{
80101376:	56                   	push   %esi
80101377:	89 c6                	mov    %eax,%esi
80101379:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010137a:	bb d4 09 11 80       	mov    $0x801109d4,%ebx
{
8010137f:	83 ec 28             	sub    $0x28,%esp
80101382:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101385:	68 a0 09 11 80       	push   $0x801109a0
8010138a:	e8 f1 33 00 00       	call   80104780 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010138f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101392:	83 c4 10             	add    $0x10,%esp
80101395:	eb 1b                	jmp    801013b2 <iget+0x42>
80101397:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010139e:	00 
8010139f:	90                   	nop
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013a0:	39 33                	cmp    %esi,(%ebx)
801013a2:	74 6c                	je     80101410 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013a4:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013aa:	81 fb f4 25 11 80    	cmp    $0x801125f4,%ebx
801013b0:	74 26                	je     801013d8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013b2:	8b 43 08             	mov    0x8(%ebx),%eax
801013b5:	85 c0                	test   %eax,%eax
801013b7:	7f e7                	jg     801013a0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801013b9:	85 ff                	test   %edi,%edi
801013bb:	75 e7                	jne    801013a4 <iget+0x34>
801013bd:	85 c0                	test   %eax,%eax
801013bf:	75 76                	jne    80101437 <iget+0xc7>
      empty = ip;
801013c1:	89 df                	mov    %ebx,%edi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013c3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013c9:	81 fb f4 25 11 80    	cmp    $0x801125f4,%ebx
801013cf:	75 e1                	jne    801013b2 <iget+0x42>
801013d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013d8:	85 ff                	test   %edi,%edi
801013da:	74 79                	je     80101455 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013dc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013df:	89 37                	mov    %esi,(%edi)
  ip->inum = inum;
801013e1:	89 57 04             	mov    %edx,0x4(%edi)
  ip->ref = 1;
801013e4:	c7 47 08 01 00 00 00 	movl   $0x1,0x8(%edi)
  ip->valid = 0;
801013eb:	c7 47 4c 00 00 00 00 	movl   $0x0,0x4c(%edi)
  release(&icache.lock);
801013f2:	68 a0 09 11 80       	push   $0x801109a0
801013f7:	e8 24 33 00 00       	call   80104720 <release>

  return ip;
801013fc:	83 c4 10             	add    $0x10,%esp
}
801013ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101402:	89 f8                	mov    %edi,%eax
80101404:	5b                   	pop    %ebx
80101405:	5e                   	pop    %esi
80101406:	5f                   	pop    %edi
80101407:	5d                   	pop    %ebp
80101408:	c3                   	ret
80101409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101410:	39 53 04             	cmp    %edx,0x4(%ebx)
80101413:	75 8f                	jne    801013a4 <iget+0x34>
      ip->ref++;
80101415:	83 c0 01             	add    $0x1,%eax
      release(&icache.lock);
80101418:	83 ec 0c             	sub    $0xc,%esp
      return ip;
8010141b:	89 df                	mov    %ebx,%edi
      ip->ref++;
8010141d:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101420:	68 a0 09 11 80       	push   $0x801109a0
80101425:	e8 f6 32 00 00       	call   80104720 <release>
      return ip;
8010142a:	83 c4 10             	add    $0x10,%esp
}
8010142d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101430:	89 f8                	mov    %edi,%eax
80101432:	5b                   	pop    %ebx
80101433:	5e                   	pop    %esi
80101434:	5f                   	pop    %edi
80101435:	5d                   	pop    %ebp
80101436:	c3                   	ret
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101437:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010143d:	81 fb f4 25 11 80    	cmp    $0x801125f4,%ebx
80101443:	74 10                	je     80101455 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101445:	8b 43 08             	mov    0x8(%ebx),%eax
80101448:	85 c0                	test   %eax,%eax
8010144a:	0f 8f 50 ff ff ff    	jg     801013a0 <iget+0x30>
80101450:	e9 68 ff ff ff       	jmp    801013bd <iget+0x4d>
    panic("iget: no inodes");
80101455:	83 ec 0c             	sub    $0xc,%esp
80101458:	68 1f 7a 10 80       	push   $0x80107a1f
8010145d:	e8 1e ef ff ff       	call   80100380 <panic>
80101462:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101469:	00 
8010146a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101470 <bfree>:
{
80101470:	55                   	push   %ebp
80101471:	89 c1                	mov    %eax,%ecx
  bp = bread(dev, BBLOCK(b, sb));
80101473:	89 d0                	mov    %edx,%eax
80101475:	c1 e8 0c             	shr    $0xc,%eax
{
80101478:	89 e5                	mov    %esp,%ebp
8010147a:	56                   	push   %esi
8010147b:	53                   	push   %ebx
  bp = bread(dev, BBLOCK(b, sb));
8010147c:	03 05 18 26 11 80    	add    0x80112618,%eax
{
80101482:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101484:	83 ec 08             	sub    $0x8,%esp
80101487:	50                   	push   %eax
80101488:	51                   	push   %ecx
80101489:	e8 42 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010148e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101490:	c1 fb 03             	sar    $0x3,%ebx
80101493:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101496:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101498:	83 e1 07             	and    $0x7,%ecx
8010149b:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
801014a0:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
801014a6:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
801014a8:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
801014ad:	85 c1                	test   %eax,%ecx
801014af:	74 23                	je     801014d4 <bfree+0x64>
  bp->data[bi/8] &= ~m;
801014b1:	f7 d0                	not    %eax
  log_write(bp);
801014b3:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
801014b6:	21 c8                	and    %ecx,%eax
801014b8:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
801014bc:	56                   	push   %esi
801014bd:	e8 1e 1b 00 00       	call   80102fe0 <log_write>
  brelse(bp);
801014c2:	89 34 24             	mov    %esi,(%esp)
801014c5:	e8 26 ed ff ff       	call   801001f0 <brelse>
}
801014ca:	83 c4 10             	add    $0x10,%esp
801014cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801014d0:	5b                   	pop    %ebx
801014d1:	5e                   	pop    %esi
801014d2:	5d                   	pop    %ebp
801014d3:	c3                   	ret
    panic("freeing free block");
801014d4:	83 ec 0c             	sub    $0xc,%esp
801014d7:	68 2f 7a 10 80       	push   $0x80107a2f
801014dc:	e8 9f ee ff ff       	call   80100380 <panic>
801014e1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801014e8:	00 
801014e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801014f0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801014f0:	55                   	push   %ebp
801014f1:	89 e5                	mov    %esp,%ebp
801014f3:	57                   	push   %edi
801014f4:	56                   	push   %esi
801014f5:	89 c6                	mov    %eax,%esi
801014f7:	53                   	push   %ebx
801014f8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801014fb:	83 fa 0b             	cmp    $0xb,%edx
801014fe:	0f 86 8c 00 00 00    	jbe    80101590 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101504:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101507:	83 fb 7f             	cmp    $0x7f,%ebx
8010150a:	0f 87 a2 00 00 00    	ja     801015b2 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101510:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101516:	85 c0                	test   %eax,%eax
80101518:	74 5e                	je     80101578 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010151a:	83 ec 08             	sub    $0x8,%esp
8010151d:	50                   	push   %eax
8010151e:	ff 36                	push   (%esi)
80101520:	e8 ab eb ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101525:	83 c4 10             	add    $0x10,%esp
80101528:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010152c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010152e:	8b 3b                	mov    (%ebx),%edi
80101530:	85 ff                	test   %edi,%edi
80101532:	74 1c                	je     80101550 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101534:	83 ec 0c             	sub    $0xc,%esp
80101537:	52                   	push   %edx
80101538:	e8 b3 ec ff ff       	call   801001f0 <brelse>
8010153d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101540:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101543:	89 f8                	mov    %edi,%eax
80101545:	5b                   	pop    %ebx
80101546:	5e                   	pop    %esi
80101547:	5f                   	pop    %edi
80101548:	5d                   	pop    %ebp
80101549:	c3                   	ret
8010154a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101550:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
80101553:	8b 06                	mov    (%esi),%eax
80101555:	e8 06 fd ff ff       	call   80101260 <balloc>
      log_write(bp);
8010155a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010155d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101560:	89 03                	mov    %eax,(%ebx)
80101562:	89 c7                	mov    %eax,%edi
      log_write(bp);
80101564:	52                   	push   %edx
80101565:	e8 76 1a 00 00       	call   80102fe0 <log_write>
8010156a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010156d:	83 c4 10             	add    $0x10,%esp
80101570:	eb c2                	jmp    80101534 <bmap+0x44>
80101572:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101578:	8b 06                	mov    (%esi),%eax
8010157a:	e8 e1 fc ff ff       	call   80101260 <balloc>
8010157f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101585:	eb 93                	jmp    8010151a <bmap+0x2a>
80101587:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010158e:	00 
8010158f:	90                   	nop
    if((addr = ip->addrs[bn]) == 0)
80101590:	8d 5a 14             	lea    0x14(%edx),%ebx
80101593:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101597:	85 ff                	test   %edi,%edi
80101599:	75 a5                	jne    80101540 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010159b:	8b 00                	mov    (%eax),%eax
8010159d:	e8 be fc ff ff       	call   80101260 <balloc>
801015a2:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
801015a6:	89 c7                	mov    %eax,%edi
}
801015a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015ab:	5b                   	pop    %ebx
801015ac:	89 f8                	mov    %edi,%eax
801015ae:	5e                   	pop    %esi
801015af:	5f                   	pop    %edi
801015b0:	5d                   	pop    %ebp
801015b1:	c3                   	ret
  panic("bmap: out of range");
801015b2:	83 ec 0c             	sub    $0xc,%esp
801015b5:	68 42 7a 10 80       	push   $0x80107a42
801015ba:	e8 c1 ed ff ff       	call   80100380 <panic>
801015bf:	90                   	nop

801015c0 <readsb>:
{
801015c0:	55                   	push   %ebp
801015c1:	89 e5                	mov    %esp,%ebp
801015c3:	56                   	push   %esi
801015c4:	53                   	push   %ebx
801015c5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801015c8:	83 ec 08             	sub    $0x8,%esp
801015cb:	6a 01                	push   $0x1
801015cd:	ff 75 08             	push   0x8(%ebp)
801015d0:	e8 fb ea ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015d5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015d8:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015da:	8d 40 5c             	lea    0x5c(%eax),%eax
801015dd:	6a 24                	push   $0x24
801015df:	50                   	push   %eax
801015e0:	56                   	push   %esi
801015e1:	e8 2a 33 00 00       	call   80104910 <memmove>
  brelse(bp);
801015e6:	83 c4 10             	add    $0x10,%esp
801015e9:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801015ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015ef:	5b                   	pop    %ebx
801015f0:	5e                   	pop    %esi
801015f1:	5d                   	pop    %ebp
  brelse(bp);
801015f2:	e9 f9 eb ff ff       	jmp    801001f0 <brelse>
801015f7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801015fe:	00 
801015ff:	90                   	nop

80101600 <iinit>:
{
80101600:	55                   	push   %ebp
80101601:	89 e5                	mov    %esp,%ebp
80101603:	53                   	push   %ebx
80101604:	bb e0 09 11 80       	mov    $0x801109e0,%ebx
80101609:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010160c:	68 55 7a 10 80       	push   $0x80107a55
80101611:	68 a0 09 11 80       	push   $0x801109a0
80101616:	e8 75 2f 00 00       	call   80104590 <initlock>
  for(i = 0; i < NINODE; i++) {
8010161b:	83 c4 10             	add    $0x10,%esp
8010161e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101620:	83 ec 08             	sub    $0x8,%esp
80101623:	68 5c 7a 10 80       	push   $0x80107a5c
80101628:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101629:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010162f:	e8 2c 2e 00 00       	call   80104460 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101634:	83 c4 10             	add    $0x10,%esp
80101637:	81 fb 00 26 11 80    	cmp    $0x80112600,%ebx
8010163d:	75 e1                	jne    80101620 <iinit+0x20>
  bp = bread(dev, 1);
8010163f:	83 ec 08             	sub    $0x8,%esp
80101642:	6a 01                	push   $0x1
80101644:	ff 75 08             	push   0x8(%ebp)
80101647:	e8 84 ea ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
8010164c:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010164f:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101651:	8d 40 5c             	lea    0x5c(%eax),%eax
80101654:	6a 24                	push   $0x24
80101656:	50                   	push   %eax
80101657:	68 00 26 11 80       	push   $0x80112600
8010165c:	e8 af 32 00 00       	call   80104910 <memmove>
  brelse(bp);
80101661:	89 1c 24             	mov    %ebx,(%esp)
80101664:	e8 87 eb ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101669:	ff 35 18 26 11 80    	push   0x80112618
8010166f:	ff 35 14 26 11 80    	push   0x80112614
80101675:	ff 35 10 26 11 80    	push   0x80112610
8010167b:	ff 35 0c 26 11 80    	push   0x8011260c
80101681:	ff 35 08 26 11 80    	push   0x80112608
80101687:	ff 35 04 26 11 80    	push   0x80112604
8010168d:	ff 35 00 26 11 80    	push   0x80112600
80101693:	68 e4 7e 10 80       	push   $0x80107ee4
80101698:	e8 13 f0 ff ff       	call   801006b0 <cprintf>
}
8010169d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801016a0:	83 c4 30             	add    $0x30,%esp
801016a3:	c9                   	leave
801016a4:	c3                   	ret
801016a5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801016ac:	00 
801016ad:	8d 76 00             	lea    0x0(%esi),%esi

801016b0 <ialloc>:
{
801016b0:	55                   	push   %ebp
801016b1:	89 e5                	mov    %esp,%ebp
801016b3:	57                   	push   %edi
801016b4:	56                   	push   %esi
801016b5:	53                   	push   %ebx
801016b6:	83 ec 1c             	sub    $0x1c,%esp
801016b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
801016bc:	83 3d 08 26 11 80 01 	cmpl   $0x1,0x80112608
{
801016c3:	8b 75 08             	mov    0x8(%ebp),%esi
801016c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801016c9:	0f 86 91 00 00 00    	jbe    80101760 <ialloc+0xb0>
801016cf:	bf 01 00 00 00       	mov    $0x1,%edi
801016d4:	eb 21                	jmp    801016f7 <ialloc+0x47>
801016d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801016dd:	00 
801016de:	66 90                	xchg   %ax,%ax
    brelse(bp);
801016e0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801016e3:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
801016e6:	53                   	push   %ebx
801016e7:	e8 04 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801016ec:	83 c4 10             	add    $0x10,%esp
801016ef:	3b 3d 08 26 11 80    	cmp    0x80112608,%edi
801016f5:	73 69                	jae    80101760 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
801016f7:	89 f8                	mov    %edi,%eax
801016f9:	83 ec 08             	sub    $0x8,%esp
801016fc:	c1 e8 03             	shr    $0x3,%eax
801016ff:	03 05 14 26 11 80    	add    0x80112614,%eax
80101705:	50                   	push   %eax
80101706:	56                   	push   %esi
80101707:	e8 c4 e9 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010170c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010170f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101711:	89 f8                	mov    %edi,%eax
80101713:	83 e0 07             	and    $0x7,%eax
80101716:	c1 e0 06             	shl    $0x6,%eax
80101719:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010171d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101721:	75 bd                	jne    801016e0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101723:	83 ec 04             	sub    $0x4,%esp
80101726:	6a 40                	push   $0x40
80101728:	6a 00                	push   $0x0
8010172a:	51                   	push   %ecx
8010172b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
8010172e:	e8 4d 31 00 00       	call   80104880 <memset>
      dip->type = type;
80101733:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101737:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010173a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010173d:	89 1c 24             	mov    %ebx,(%esp)
80101740:	e8 9b 18 00 00       	call   80102fe0 <log_write>
      brelse(bp);
80101745:	89 1c 24             	mov    %ebx,(%esp)
80101748:	e8 a3 ea ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010174d:	83 c4 10             	add    $0x10,%esp
}
80101750:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101753:	89 fa                	mov    %edi,%edx
}
80101755:	5b                   	pop    %ebx
      return iget(dev, inum);
80101756:	89 f0                	mov    %esi,%eax
}
80101758:	5e                   	pop    %esi
80101759:	5f                   	pop    %edi
8010175a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010175b:	e9 10 fc ff ff       	jmp    80101370 <iget>
  panic("ialloc: no inodes");
80101760:	83 ec 0c             	sub    $0xc,%esp
80101763:	68 62 7a 10 80       	push   $0x80107a62
80101768:	e8 13 ec ff ff       	call   80100380 <panic>
8010176d:	8d 76 00             	lea    0x0(%esi),%esi

80101770 <iupdate>:
{
80101770:	55                   	push   %ebp
80101771:	89 e5                	mov    %esp,%ebp
80101773:	56                   	push   %esi
80101774:	53                   	push   %ebx
80101775:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101778:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010177b:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010177e:	83 ec 08             	sub    $0x8,%esp
80101781:	c1 e8 03             	shr    $0x3,%eax
80101784:	03 05 14 26 11 80    	add    0x80112614,%eax
8010178a:	50                   	push   %eax
8010178b:	ff 73 a4             	push   -0x5c(%ebx)
8010178e:	e8 3d e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101793:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101797:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010179a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010179c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010179f:	83 e0 07             	and    $0x7,%eax
801017a2:	c1 e0 06             	shl    $0x6,%eax
801017a5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801017a9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801017ac:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017b0:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801017b3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801017b7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801017bb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801017bf:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801017c3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801017c7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801017ca:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017cd:	6a 34                	push   $0x34
801017cf:	53                   	push   %ebx
801017d0:	50                   	push   %eax
801017d1:	e8 3a 31 00 00       	call   80104910 <memmove>
  log_write(bp);
801017d6:	89 34 24             	mov    %esi,(%esp)
801017d9:	e8 02 18 00 00       	call   80102fe0 <log_write>
  brelse(bp);
801017de:	83 c4 10             	add    $0x10,%esp
801017e1:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017e4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017e7:	5b                   	pop    %ebx
801017e8:	5e                   	pop    %esi
801017e9:	5d                   	pop    %ebp
  brelse(bp);
801017ea:	e9 01 ea ff ff       	jmp    801001f0 <brelse>
801017ef:	90                   	nop

801017f0 <idup>:
{
801017f0:	55                   	push   %ebp
801017f1:	89 e5                	mov    %esp,%ebp
801017f3:	53                   	push   %ebx
801017f4:	83 ec 10             	sub    $0x10,%esp
801017f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801017fa:	68 a0 09 11 80       	push   $0x801109a0
801017ff:	e8 7c 2f 00 00       	call   80104780 <acquire>
  ip->ref++;
80101804:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101808:	c7 04 24 a0 09 11 80 	movl   $0x801109a0,(%esp)
8010180f:	e8 0c 2f 00 00       	call   80104720 <release>
}
80101814:	89 d8                	mov    %ebx,%eax
80101816:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101819:	c9                   	leave
8010181a:	c3                   	ret
8010181b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101820 <ilock>:
{
80101820:	55                   	push   %ebp
80101821:	89 e5                	mov    %esp,%ebp
80101823:	56                   	push   %esi
80101824:	53                   	push   %ebx
80101825:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101828:	85 db                	test   %ebx,%ebx
8010182a:	0f 84 b7 00 00 00    	je     801018e7 <ilock+0xc7>
80101830:	8b 53 08             	mov    0x8(%ebx),%edx
80101833:	85 d2                	test   %edx,%edx
80101835:	0f 8e ac 00 00 00    	jle    801018e7 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010183b:	83 ec 0c             	sub    $0xc,%esp
8010183e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101841:	50                   	push   %eax
80101842:	e8 59 2c 00 00       	call   801044a0 <acquiresleep>
  if(ip->valid == 0){
80101847:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010184a:	83 c4 10             	add    $0x10,%esp
8010184d:	85 c0                	test   %eax,%eax
8010184f:	74 0f                	je     80101860 <ilock+0x40>
}
80101851:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101854:	5b                   	pop    %ebx
80101855:	5e                   	pop    %esi
80101856:	5d                   	pop    %ebp
80101857:	c3                   	ret
80101858:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010185f:	00 
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101860:	8b 43 04             	mov    0x4(%ebx),%eax
80101863:	83 ec 08             	sub    $0x8,%esp
80101866:	c1 e8 03             	shr    $0x3,%eax
80101869:	03 05 14 26 11 80    	add    0x80112614,%eax
8010186f:	50                   	push   %eax
80101870:	ff 33                	push   (%ebx)
80101872:	e8 59 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101877:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010187a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010187c:	8b 43 04             	mov    0x4(%ebx),%eax
8010187f:	83 e0 07             	and    $0x7,%eax
80101882:	c1 e0 06             	shl    $0x6,%eax
80101885:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101889:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010188c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010188f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101893:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101897:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010189b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010189f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801018a3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801018a7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801018ab:	8b 50 fc             	mov    -0x4(%eax),%edx
801018ae:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801018b1:	6a 34                	push   $0x34
801018b3:	50                   	push   %eax
801018b4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801018b7:	50                   	push   %eax
801018b8:	e8 53 30 00 00       	call   80104910 <memmove>
    brelse(bp);
801018bd:	89 34 24             	mov    %esi,(%esp)
801018c0:	e8 2b e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
801018c5:	83 c4 10             	add    $0x10,%esp
801018c8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
801018cd:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801018d4:	0f 85 77 ff ff ff    	jne    80101851 <ilock+0x31>
      panic("ilock: no type");
801018da:	83 ec 0c             	sub    $0xc,%esp
801018dd:	68 7a 7a 10 80       	push   $0x80107a7a
801018e2:	e8 99 ea ff ff       	call   80100380 <panic>
    panic("ilock");
801018e7:	83 ec 0c             	sub    $0xc,%esp
801018ea:	68 74 7a 10 80       	push   $0x80107a74
801018ef:	e8 8c ea ff ff       	call   80100380 <panic>
801018f4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801018fb:	00 
801018fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101900 <iunlock>:
{
80101900:	55                   	push   %ebp
80101901:	89 e5                	mov    %esp,%ebp
80101903:	56                   	push   %esi
80101904:	53                   	push   %ebx
80101905:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101908:	85 db                	test   %ebx,%ebx
8010190a:	74 28                	je     80101934 <iunlock+0x34>
8010190c:	83 ec 0c             	sub    $0xc,%esp
8010190f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101912:	56                   	push   %esi
80101913:	e8 28 2c 00 00       	call   80104540 <holdingsleep>
80101918:	83 c4 10             	add    $0x10,%esp
8010191b:	85 c0                	test   %eax,%eax
8010191d:	74 15                	je     80101934 <iunlock+0x34>
8010191f:	8b 43 08             	mov    0x8(%ebx),%eax
80101922:	85 c0                	test   %eax,%eax
80101924:	7e 0e                	jle    80101934 <iunlock+0x34>
  releasesleep(&ip->lock);
80101926:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101929:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010192c:	5b                   	pop    %ebx
8010192d:	5e                   	pop    %esi
8010192e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010192f:	e9 cc 2b 00 00       	jmp    80104500 <releasesleep>
    panic("iunlock");
80101934:	83 ec 0c             	sub    $0xc,%esp
80101937:	68 89 7a 10 80       	push   $0x80107a89
8010193c:	e8 3f ea ff ff       	call   80100380 <panic>
80101941:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101948:	00 
80101949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101950 <iput>:
{
80101950:	55                   	push   %ebp
80101951:	89 e5                	mov    %esp,%ebp
80101953:	57                   	push   %edi
80101954:	56                   	push   %esi
80101955:	53                   	push   %ebx
80101956:	83 ec 28             	sub    $0x28,%esp
80101959:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010195c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010195f:	57                   	push   %edi
80101960:	e8 3b 2b 00 00       	call   801044a0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101965:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101968:	83 c4 10             	add    $0x10,%esp
8010196b:	85 d2                	test   %edx,%edx
8010196d:	74 07                	je     80101976 <iput+0x26>
8010196f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101974:	74 32                	je     801019a8 <iput+0x58>
  releasesleep(&ip->lock);
80101976:	83 ec 0c             	sub    $0xc,%esp
80101979:	57                   	push   %edi
8010197a:	e8 81 2b 00 00       	call   80104500 <releasesleep>
  acquire(&icache.lock);
8010197f:	c7 04 24 a0 09 11 80 	movl   $0x801109a0,(%esp)
80101986:	e8 f5 2d 00 00       	call   80104780 <acquire>
  ip->ref--;
8010198b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010198f:	83 c4 10             	add    $0x10,%esp
80101992:	c7 45 08 a0 09 11 80 	movl   $0x801109a0,0x8(%ebp)
}
80101999:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010199c:	5b                   	pop    %ebx
8010199d:	5e                   	pop    %esi
8010199e:	5f                   	pop    %edi
8010199f:	5d                   	pop    %ebp
  release(&icache.lock);
801019a0:	e9 7b 2d 00 00       	jmp    80104720 <release>
801019a5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
801019a8:	83 ec 0c             	sub    $0xc,%esp
801019ab:	68 a0 09 11 80       	push   $0x801109a0
801019b0:	e8 cb 2d 00 00       	call   80104780 <acquire>
    int r = ip->ref;
801019b5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
801019b8:	c7 04 24 a0 09 11 80 	movl   $0x801109a0,(%esp)
801019bf:	e8 5c 2d 00 00       	call   80104720 <release>
    if(r == 1){
801019c4:	83 c4 10             	add    $0x10,%esp
801019c7:	83 fe 01             	cmp    $0x1,%esi
801019ca:	75 aa                	jne    80101976 <iput+0x26>
801019cc:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
801019d2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801019d5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801019d8:	89 df                	mov    %ebx,%edi
801019da:	89 cb                	mov    %ecx,%ebx
801019dc:	eb 09                	jmp    801019e7 <iput+0x97>
801019de:	66 90                	xchg   %ax,%ax
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801019e0:	83 c6 04             	add    $0x4,%esi
801019e3:	39 de                	cmp    %ebx,%esi
801019e5:	74 19                	je     80101a00 <iput+0xb0>
    if(ip->addrs[i]){
801019e7:	8b 16                	mov    (%esi),%edx
801019e9:	85 d2                	test   %edx,%edx
801019eb:	74 f3                	je     801019e0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
801019ed:	8b 07                	mov    (%edi),%eax
801019ef:	e8 7c fa ff ff       	call   80101470 <bfree>
      ip->addrs[i] = 0;
801019f4:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801019fa:	eb e4                	jmp    801019e0 <iput+0x90>
801019fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101a00:	89 fb                	mov    %edi,%ebx
80101a02:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a05:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101a0b:	85 c0                	test   %eax,%eax
80101a0d:	75 2d                	jne    80101a3c <iput+0xec>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101a0f:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101a12:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101a19:	53                   	push   %ebx
80101a1a:	e8 51 fd ff ff       	call   80101770 <iupdate>
      ip->type = 0;
80101a1f:	31 c0                	xor    %eax,%eax
80101a21:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101a25:	89 1c 24             	mov    %ebx,(%esp)
80101a28:	e8 43 fd ff ff       	call   80101770 <iupdate>
      ip->valid = 0;
80101a2d:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101a34:	83 c4 10             	add    $0x10,%esp
80101a37:	e9 3a ff ff ff       	jmp    80101976 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101a3c:	83 ec 08             	sub    $0x8,%esp
80101a3f:	50                   	push   %eax
80101a40:	ff 33                	push   (%ebx)
80101a42:	e8 89 e6 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
80101a47:	83 c4 10             	add    $0x10,%esp
80101a4a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101a4d:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101a53:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101a56:	8d 70 5c             	lea    0x5c(%eax),%esi
80101a59:	89 cf                	mov    %ecx,%edi
80101a5b:	eb 0a                	jmp    80101a67 <iput+0x117>
80101a5d:	8d 76 00             	lea    0x0(%esi),%esi
80101a60:	83 c6 04             	add    $0x4,%esi
80101a63:	39 fe                	cmp    %edi,%esi
80101a65:	74 0f                	je     80101a76 <iput+0x126>
      if(a[j])
80101a67:	8b 16                	mov    (%esi),%edx
80101a69:	85 d2                	test   %edx,%edx
80101a6b:	74 f3                	je     80101a60 <iput+0x110>
        bfree(ip->dev, a[j]);
80101a6d:	8b 03                	mov    (%ebx),%eax
80101a6f:	e8 fc f9 ff ff       	call   80101470 <bfree>
80101a74:	eb ea                	jmp    80101a60 <iput+0x110>
    brelse(bp);
80101a76:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101a79:	83 ec 0c             	sub    $0xc,%esp
80101a7c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a7f:	50                   	push   %eax
80101a80:	e8 6b e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a85:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101a8b:	8b 03                	mov    (%ebx),%eax
80101a8d:	e8 de f9 ff ff       	call   80101470 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a92:	83 c4 10             	add    $0x10,%esp
80101a95:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a9c:	00 00 00 
80101a9f:	e9 6b ff ff ff       	jmp    80101a0f <iput+0xbf>
80101aa4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101aab:	00 
80101aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ab0 <iunlockput>:
{
80101ab0:	55                   	push   %ebp
80101ab1:	89 e5                	mov    %esp,%ebp
80101ab3:	56                   	push   %esi
80101ab4:	53                   	push   %ebx
80101ab5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101ab8:	85 db                	test   %ebx,%ebx
80101aba:	74 34                	je     80101af0 <iunlockput+0x40>
80101abc:	83 ec 0c             	sub    $0xc,%esp
80101abf:	8d 73 0c             	lea    0xc(%ebx),%esi
80101ac2:	56                   	push   %esi
80101ac3:	e8 78 2a 00 00       	call   80104540 <holdingsleep>
80101ac8:	83 c4 10             	add    $0x10,%esp
80101acb:	85 c0                	test   %eax,%eax
80101acd:	74 21                	je     80101af0 <iunlockput+0x40>
80101acf:	8b 43 08             	mov    0x8(%ebx),%eax
80101ad2:	85 c0                	test   %eax,%eax
80101ad4:	7e 1a                	jle    80101af0 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101ad6:	83 ec 0c             	sub    $0xc,%esp
80101ad9:	56                   	push   %esi
80101ada:	e8 21 2a 00 00       	call   80104500 <releasesleep>
  iput(ip);
80101adf:	83 c4 10             	add    $0x10,%esp
80101ae2:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101ae5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101ae8:	5b                   	pop    %ebx
80101ae9:	5e                   	pop    %esi
80101aea:	5d                   	pop    %ebp
  iput(ip);
80101aeb:	e9 60 fe ff ff       	jmp    80101950 <iput>
    panic("iunlock");
80101af0:	83 ec 0c             	sub    $0xc,%esp
80101af3:	68 89 7a 10 80       	push   $0x80107a89
80101af8:	e8 83 e8 ff ff       	call   80100380 <panic>
80101afd:	8d 76 00             	lea    0x0(%esi),%esi

80101b00 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101b00:	55                   	push   %ebp
80101b01:	89 e5                	mov    %esp,%ebp
80101b03:	8b 55 08             	mov    0x8(%ebp),%edx
80101b06:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101b09:	8b 0a                	mov    (%edx),%ecx
80101b0b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101b0e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101b11:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101b14:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101b18:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101b1b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101b1f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101b23:	8b 52 58             	mov    0x58(%edx),%edx
80101b26:	89 50 10             	mov    %edx,0x10(%eax)
}
80101b29:	5d                   	pop    %ebp
80101b2a:	c3                   	ret
80101b2b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80101b30 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101b30:	55                   	push   %ebp
80101b31:	89 e5                	mov    %esp,%ebp
80101b33:	57                   	push   %edi
80101b34:	56                   	push   %esi
80101b35:	53                   	push   %ebx
80101b36:	83 ec 1c             	sub    $0x1c,%esp
80101b39:	8b 75 08             	mov    0x8(%ebp),%esi
80101b3c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101b3f:	8b 7d 10             	mov    0x10(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b42:	66 83 7e 50 03       	cmpw   $0x3,0x50(%esi)
{
80101b47:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101b4a:	89 75 d8             	mov    %esi,-0x28(%ebp)
80101b4d:	8b 45 14             	mov    0x14(%ebp),%eax
  if(ip->type == T_DEV){
80101b50:	0f 84 aa 00 00 00    	je     80101c00 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101b56:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101b59:	8b 56 58             	mov    0x58(%esi),%edx
80101b5c:	39 fa                	cmp    %edi,%edx
80101b5e:	0f 82 bd 00 00 00    	jb     80101c21 <readi+0xf1>
80101b64:	89 f9                	mov    %edi,%ecx
80101b66:	31 db                	xor    %ebx,%ebx
80101b68:	01 c1                	add    %eax,%ecx
80101b6a:	0f 92 c3             	setb   %bl
80101b6d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80101b70:	0f 82 ab 00 00 00    	jb     80101c21 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101b76:	89 d3                	mov    %edx,%ebx
80101b78:	29 fb                	sub    %edi,%ebx
80101b7a:	39 ca                	cmp    %ecx,%edx
80101b7c:	0f 42 c3             	cmovb  %ebx,%eax

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b7f:	85 c0                	test   %eax,%eax
80101b81:	74 73                	je     80101bf6 <readi+0xc6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101b83:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101b86:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101b89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b90:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b93:	89 fa                	mov    %edi,%edx
80101b95:	c1 ea 09             	shr    $0x9,%edx
80101b98:	89 d8                	mov    %ebx,%eax
80101b9a:	e8 51 f9 ff ff       	call   801014f0 <bmap>
80101b9f:	83 ec 08             	sub    $0x8,%esp
80101ba2:	50                   	push   %eax
80101ba3:	ff 33                	push   (%ebx)
80101ba5:	e8 26 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101baa:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101bad:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bb2:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101bb4:	89 f8                	mov    %edi,%eax
80101bb6:	25 ff 01 00 00       	and    $0x1ff,%eax
80101bbb:	29 f3                	sub    %esi,%ebx
80101bbd:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101bbf:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101bc3:	39 d9                	cmp    %ebx,%ecx
80101bc5:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101bc8:	83 c4 0c             	add    $0xc,%esp
80101bcb:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bcc:	01 de                	add    %ebx,%esi
80101bce:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101bd0:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101bd3:	50                   	push   %eax
80101bd4:	ff 75 e0             	push   -0x20(%ebp)
80101bd7:	e8 34 2d 00 00       	call   80104910 <memmove>
    brelse(bp);
80101bdc:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101bdf:	89 14 24             	mov    %edx,(%esp)
80101be2:	e8 09 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101be7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101bea:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101bed:	83 c4 10             	add    $0x10,%esp
80101bf0:	39 de                	cmp    %ebx,%esi
80101bf2:	72 9c                	jb     80101b90 <readi+0x60>
80101bf4:	89 d8                	mov    %ebx,%eax
  }
  return n;
}
80101bf6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bf9:	5b                   	pop    %ebx
80101bfa:	5e                   	pop    %esi
80101bfb:	5f                   	pop    %edi
80101bfc:	5d                   	pop    %ebp
80101bfd:	c3                   	ret
80101bfe:	66 90                	xchg   %ax,%ax
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101c00:	0f bf 56 52          	movswl 0x52(%esi),%edx
80101c04:	66 83 fa 09          	cmp    $0x9,%dx
80101c08:	77 17                	ja     80101c21 <readi+0xf1>
80101c0a:	8b 14 d5 40 09 11 80 	mov    -0x7feef6c0(,%edx,8),%edx
80101c11:	85 d2                	test   %edx,%edx
80101c13:	74 0c                	je     80101c21 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101c15:	89 45 10             	mov    %eax,0x10(%ebp)
}
80101c18:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c1b:	5b                   	pop    %ebx
80101c1c:	5e                   	pop    %esi
80101c1d:	5f                   	pop    %edi
80101c1e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101c1f:	ff e2                	jmp    *%edx
      return -1;
80101c21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c26:	eb ce                	jmp    80101bf6 <readi+0xc6>
80101c28:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101c2f:	00 

80101c30 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101c30:	55                   	push   %ebp
80101c31:	89 e5                	mov    %esp,%ebp
80101c33:	57                   	push   %edi
80101c34:	56                   	push   %esi
80101c35:	53                   	push   %ebx
80101c36:	83 ec 1c             	sub    $0x1c,%esp
80101c39:	8b 45 08             	mov    0x8(%ebp),%eax
80101c3c:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101c3f:	8b 75 14             	mov    0x14(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101c42:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101c47:	89 7d dc             	mov    %edi,-0x24(%ebp)
80101c4a:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101c4d:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(ip->type == T_DEV){
80101c50:	0f 84 ba 00 00 00    	je     80101d10 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101c56:	39 78 58             	cmp    %edi,0x58(%eax)
80101c59:	0f 82 ea 00 00 00    	jb     80101d49 <writei+0x119>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101c5f:	8b 75 e0             	mov    -0x20(%ebp),%esi
80101c62:	89 f2                	mov    %esi,%edx
80101c64:	01 fa                	add    %edi,%edx
80101c66:	0f 82 dd 00 00 00    	jb     80101d49 <writei+0x119>
80101c6c:	81 fa 00 18 01 00    	cmp    $0x11800,%edx
80101c72:	0f 87 d1 00 00 00    	ja     80101d49 <writei+0x119>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c78:	85 f6                	test   %esi,%esi
80101c7a:	0f 84 85 00 00 00    	je     80101d05 <writei+0xd5>
80101c80:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101c87:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c90:	8b 75 d8             	mov    -0x28(%ebp),%esi
80101c93:	89 fa                	mov    %edi,%edx
80101c95:	c1 ea 09             	shr    $0x9,%edx
80101c98:	89 f0                	mov    %esi,%eax
80101c9a:	e8 51 f8 ff ff       	call   801014f0 <bmap>
80101c9f:	83 ec 08             	sub    $0x8,%esp
80101ca2:	50                   	push   %eax
80101ca3:	ff 36                	push   (%esi)
80101ca5:	e8 26 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101caa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101cad:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101cb0:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101cb5:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
80101cb7:	89 f8                	mov    %edi,%eax
80101cb9:	25 ff 01 00 00       	and    $0x1ff,%eax
80101cbe:	29 d3                	sub    %edx,%ebx
80101cc0:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101cc2:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101cc6:	39 d9                	cmp    %ebx,%ecx
80101cc8:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101ccb:	83 c4 0c             	add    $0xc,%esp
80101cce:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ccf:	01 df                	add    %ebx,%edi
    memmove(bp->data + off%BSIZE, src, m);
80101cd1:	ff 75 dc             	push   -0x24(%ebp)
80101cd4:	50                   	push   %eax
80101cd5:	e8 36 2c 00 00       	call   80104910 <memmove>
    log_write(bp);
80101cda:	89 34 24             	mov    %esi,(%esp)
80101cdd:	e8 fe 12 00 00       	call   80102fe0 <log_write>
    brelse(bp);
80101ce2:	89 34 24             	mov    %esi,(%esp)
80101ce5:	e8 06 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101cea:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101ced:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101cf0:	83 c4 10             	add    $0x10,%esp
80101cf3:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101cf6:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101cf9:	39 d8                	cmp    %ebx,%eax
80101cfb:	72 93                	jb     80101c90 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101cfd:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101d00:	39 78 58             	cmp    %edi,0x58(%eax)
80101d03:	72 33                	jb     80101d38 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101d05:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101d08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d0b:	5b                   	pop    %ebx
80101d0c:	5e                   	pop    %esi
80101d0d:	5f                   	pop    %edi
80101d0e:	5d                   	pop    %ebp
80101d0f:	c3                   	ret
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101d10:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101d14:	66 83 f8 09          	cmp    $0x9,%ax
80101d18:	77 2f                	ja     80101d49 <writei+0x119>
80101d1a:	8b 04 c5 44 09 11 80 	mov    -0x7feef6bc(,%eax,8),%eax
80101d21:	85 c0                	test   %eax,%eax
80101d23:	74 24                	je     80101d49 <writei+0x119>
    return devsw[ip->major].write(ip, src, n);
80101d25:	89 75 10             	mov    %esi,0x10(%ebp)
}
80101d28:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d2b:	5b                   	pop    %ebx
80101d2c:	5e                   	pop    %esi
80101d2d:	5f                   	pop    %edi
80101d2e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101d2f:	ff e0                	jmp    *%eax
80101d31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    iupdate(ip);
80101d38:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101d3b:	89 78 58             	mov    %edi,0x58(%eax)
    iupdate(ip);
80101d3e:	50                   	push   %eax
80101d3f:	e8 2c fa ff ff       	call   80101770 <iupdate>
80101d44:	83 c4 10             	add    $0x10,%esp
80101d47:	eb bc                	jmp    80101d05 <writei+0xd5>
      return -1;
80101d49:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d4e:	eb b8                	jmp    80101d08 <writei+0xd8>

80101d50 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101d50:	55                   	push   %ebp
80101d51:	89 e5                	mov    %esp,%ebp
80101d53:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101d56:	6a 0e                	push   $0xe
80101d58:	ff 75 0c             	push   0xc(%ebp)
80101d5b:	ff 75 08             	push   0x8(%ebp)
80101d5e:	e8 1d 2c 00 00       	call   80104980 <strncmp>
}
80101d63:	c9                   	leave
80101d64:	c3                   	ret
80101d65:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80101d6c:	00 
80101d6d:	8d 76 00             	lea    0x0(%esi),%esi

80101d70 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101d70:	55                   	push   %ebp
80101d71:	89 e5                	mov    %esp,%ebp
80101d73:	57                   	push   %edi
80101d74:	56                   	push   %esi
80101d75:	53                   	push   %ebx
80101d76:	83 ec 1c             	sub    $0x1c,%esp
80101d79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101d7c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d81:	0f 85 85 00 00 00    	jne    80101e0c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d87:	8b 53 58             	mov    0x58(%ebx),%edx
80101d8a:	31 ff                	xor    %edi,%edi
80101d8c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d8f:	85 d2                	test   %edx,%edx
80101d91:	74 3e                	je     80101dd1 <dirlookup+0x61>
80101d93:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d98:	6a 10                	push   $0x10
80101d9a:	57                   	push   %edi
80101d9b:	56                   	push   %esi
80101d9c:	53                   	push   %ebx
80101d9d:	e8 8e fd ff ff       	call   80101b30 <readi>
80101da2:	83 c4 10             	add    $0x10,%esp
80101da5:	83 f8 10             	cmp    $0x10,%eax
80101da8:	75 55                	jne    80101dff <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101daa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101daf:	74 18                	je     80101dc9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101db1:	83 ec 04             	sub    $0x4,%esp
80101db4:	8d 45 da             	lea    -0x26(%ebp),%eax
80101db7:	6a 0e                	push   $0xe
80101db9:	50                   	push   %eax
80101dba:	ff 75 0c             	push   0xc(%ebp)
80101dbd:	e8 be 2b 00 00       	call   80104980 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101dc2:	83 c4 10             	add    $0x10,%esp
80101dc5:	85 c0                	test   %eax,%eax
80101dc7:	74 17                	je     80101de0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101dc9:	83 c7 10             	add    $0x10,%edi
80101dcc:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101dcf:	72 c7                	jb     80101d98 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101dd1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101dd4:	31 c0                	xor    %eax,%eax
}
80101dd6:	5b                   	pop    %ebx
80101dd7:	5e                   	pop    %esi
80101dd8:	5f                   	pop    %edi
80101dd9:	5d                   	pop    %ebp
80101dda:	c3                   	ret
80101ddb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(poff)
80101de0:	8b 45 10             	mov    0x10(%ebp),%eax
80101de3:	85 c0                	test   %eax,%eax
80101de5:	74 05                	je     80101dec <dirlookup+0x7c>
        *poff = off;
80101de7:	8b 45 10             	mov    0x10(%ebp),%eax
80101dea:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101dec:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101df0:	8b 03                	mov    (%ebx),%eax
80101df2:	e8 79 f5 ff ff       	call   80101370 <iget>
}
80101df7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dfa:	5b                   	pop    %ebx
80101dfb:	5e                   	pop    %esi
80101dfc:	5f                   	pop    %edi
80101dfd:	5d                   	pop    %ebp
80101dfe:	c3                   	ret
      panic("dirlookup read");
80101dff:	83 ec 0c             	sub    $0xc,%esp
80101e02:	68 a3 7a 10 80       	push   $0x80107aa3
80101e07:	e8 74 e5 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101e0c:	83 ec 0c             	sub    $0xc,%esp
80101e0f:	68 91 7a 10 80       	push   $0x80107a91
80101e14:	e8 67 e5 ff ff       	call   80100380 <panic>
80101e19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101e20 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101e20:	55                   	push   %ebp
80101e21:	89 e5                	mov    %esp,%ebp
80101e23:	57                   	push   %edi
80101e24:	56                   	push   %esi
80101e25:	53                   	push   %ebx
80101e26:	89 c3                	mov    %eax,%ebx
80101e28:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101e2b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101e2e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101e31:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101e34:	0f 84 9e 01 00 00    	je     80101fd8 <namex+0x1b8>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101e3a:	e8 71 1c 00 00       	call   80103ab0 <myproc>
  acquire(&icache.lock);
80101e3f:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101e42:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101e45:	68 a0 09 11 80       	push   $0x801109a0
80101e4a:	e8 31 29 00 00       	call   80104780 <acquire>
  ip->ref++;
80101e4f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101e53:	c7 04 24 a0 09 11 80 	movl   $0x801109a0,(%esp)
80101e5a:	e8 c1 28 00 00       	call   80104720 <release>
80101e5f:	83 c4 10             	add    $0x10,%esp
80101e62:	eb 07                	jmp    80101e6b <namex+0x4b>
80101e64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e68:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e6b:	0f b6 03             	movzbl (%ebx),%eax
80101e6e:	3c 2f                	cmp    $0x2f,%al
80101e70:	74 f6                	je     80101e68 <namex+0x48>
  if(*path == 0)
80101e72:	84 c0                	test   %al,%al
80101e74:	0f 84 06 01 00 00    	je     80101f80 <namex+0x160>
  while(*path != '/' && *path != 0)
80101e7a:	0f b6 03             	movzbl (%ebx),%eax
80101e7d:	84 c0                	test   %al,%al
80101e7f:	0f 84 10 01 00 00    	je     80101f95 <namex+0x175>
80101e85:	89 df                	mov    %ebx,%edi
80101e87:	3c 2f                	cmp    $0x2f,%al
80101e89:	0f 84 06 01 00 00    	je     80101f95 <namex+0x175>
80101e8f:	90                   	nop
80101e90:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101e94:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101e97:	3c 2f                	cmp    $0x2f,%al
80101e99:	74 04                	je     80101e9f <namex+0x7f>
80101e9b:	84 c0                	test   %al,%al
80101e9d:	75 f1                	jne    80101e90 <namex+0x70>
  len = path - s;
80101e9f:	89 f8                	mov    %edi,%eax
80101ea1:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101ea3:	83 f8 0d             	cmp    $0xd,%eax
80101ea6:	0f 8e ac 00 00 00    	jle    80101f58 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101eac:	83 ec 04             	sub    $0x4,%esp
80101eaf:	6a 0e                	push   $0xe
80101eb1:	53                   	push   %ebx
80101eb2:	89 fb                	mov    %edi,%ebx
80101eb4:	ff 75 e4             	push   -0x1c(%ebp)
80101eb7:	e8 54 2a 00 00       	call   80104910 <memmove>
80101ebc:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101ebf:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101ec2:	75 0c                	jne    80101ed0 <namex+0xb0>
80101ec4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101ec8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ecb:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101ece:	74 f8                	je     80101ec8 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101ed0:	83 ec 0c             	sub    $0xc,%esp
80101ed3:	56                   	push   %esi
80101ed4:	e8 47 f9 ff ff       	call   80101820 <ilock>
    if(ip->type != T_DIR){
80101ed9:	83 c4 10             	add    $0x10,%esp
80101edc:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101ee1:	0f 85 b7 00 00 00    	jne    80101f9e <namex+0x17e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101ee7:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101eea:	85 c0                	test   %eax,%eax
80101eec:	74 09                	je     80101ef7 <namex+0xd7>
80101eee:	80 3b 00             	cmpb   $0x0,(%ebx)
80101ef1:	0f 84 f7 00 00 00    	je     80101fee <namex+0x1ce>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101ef7:	83 ec 04             	sub    $0x4,%esp
80101efa:	6a 00                	push   $0x0
80101efc:	ff 75 e4             	push   -0x1c(%ebp)
80101eff:	56                   	push   %esi
80101f00:	e8 6b fe ff ff       	call   80101d70 <dirlookup>
80101f05:	83 c4 10             	add    $0x10,%esp
80101f08:	89 c7                	mov    %eax,%edi
80101f0a:	85 c0                	test   %eax,%eax
80101f0c:	0f 84 8c 00 00 00    	je     80101f9e <namex+0x17e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f12:	83 ec 0c             	sub    $0xc,%esp
80101f15:	8d 4e 0c             	lea    0xc(%esi),%ecx
80101f18:	51                   	push   %ecx
80101f19:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101f1c:	e8 1f 26 00 00       	call   80104540 <holdingsleep>
80101f21:	83 c4 10             	add    $0x10,%esp
80101f24:	85 c0                	test   %eax,%eax
80101f26:	0f 84 02 01 00 00    	je     8010202e <namex+0x20e>
80101f2c:	8b 56 08             	mov    0x8(%esi),%edx
80101f2f:	85 d2                	test   %edx,%edx
80101f31:	0f 8e f7 00 00 00    	jle    8010202e <namex+0x20e>
  releasesleep(&ip->lock);
80101f37:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101f3a:	83 ec 0c             	sub    $0xc,%esp
80101f3d:	51                   	push   %ecx
80101f3e:	e8 bd 25 00 00       	call   80104500 <releasesleep>
  iput(ip);
80101f43:	89 34 24             	mov    %esi,(%esp)
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101f46:	89 fe                	mov    %edi,%esi
  iput(ip);
80101f48:	e8 03 fa ff ff       	call   80101950 <iput>
80101f4d:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101f50:	e9 16 ff ff ff       	jmp    80101e6b <namex+0x4b>
80101f55:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101f58:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101f5b:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
    memmove(name, s, len);
80101f5e:	83 ec 04             	sub    $0x4,%esp
80101f61:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101f64:	50                   	push   %eax
80101f65:	53                   	push   %ebx
    name[len] = 0;
80101f66:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101f68:	ff 75 e4             	push   -0x1c(%ebp)
80101f6b:	e8 a0 29 00 00       	call   80104910 <memmove>
    name[len] = 0;
80101f70:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101f73:	83 c4 10             	add    $0x10,%esp
80101f76:	c6 01 00             	movb   $0x0,(%ecx)
80101f79:	e9 41 ff ff ff       	jmp    80101ebf <namex+0x9f>
80101f7e:	66 90                	xchg   %ax,%ax
  }
  if(nameiparent){
80101f80:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f83:	85 c0                	test   %eax,%eax
80101f85:	0f 85 93 00 00 00    	jne    8010201e <namex+0x1fe>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f8e:	89 f0                	mov    %esi,%eax
80101f90:	5b                   	pop    %ebx
80101f91:	5e                   	pop    %esi
80101f92:	5f                   	pop    %edi
80101f93:	5d                   	pop    %ebp
80101f94:	c3                   	ret
  while(*path != '/' && *path != 0)
80101f95:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101f98:	89 df                	mov    %ebx,%edi
80101f9a:	31 c0                	xor    %eax,%eax
80101f9c:	eb c0                	jmp    80101f5e <namex+0x13e>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f9e:	83 ec 0c             	sub    $0xc,%esp
80101fa1:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101fa4:	53                   	push   %ebx
80101fa5:	e8 96 25 00 00       	call   80104540 <holdingsleep>
80101faa:	83 c4 10             	add    $0x10,%esp
80101fad:	85 c0                	test   %eax,%eax
80101faf:	74 7d                	je     8010202e <namex+0x20e>
80101fb1:	8b 4e 08             	mov    0x8(%esi),%ecx
80101fb4:	85 c9                	test   %ecx,%ecx
80101fb6:	7e 76                	jle    8010202e <namex+0x20e>
  releasesleep(&ip->lock);
80101fb8:	83 ec 0c             	sub    $0xc,%esp
80101fbb:	53                   	push   %ebx
80101fbc:	e8 3f 25 00 00       	call   80104500 <releasesleep>
  iput(ip);
80101fc1:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101fc4:	31 f6                	xor    %esi,%esi
  iput(ip);
80101fc6:	e8 85 f9 ff ff       	call   80101950 <iput>
      return 0;
80101fcb:	83 c4 10             	add    $0x10,%esp
}
80101fce:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fd1:	89 f0                	mov    %esi,%eax
80101fd3:	5b                   	pop    %ebx
80101fd4:	5e                   	pop    %esi
80101fd5:	5f                   	pop    %edi
80101fd6:	5d                   	pop    %ebp
80101fd7:	c3                   	ret
    ip = iget(ROOTDEV, ROOTINO);
80101fd8:	ba 01 00 00 00       	mov    $0x1,%edx
80101fdd:	b8 01 00 00 00       	mov    $0x1,%eax
80101fe2:	e8 89 f3 ff ff       	call   80101370 <iget>
80101fe7:	89 c6                	mov    %eax,%esi
80101fe9:	e9 7d fe ff ff       	jmp    80101e6b <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101fee:	83 ec 0c             	sub    $0xc,%esp
80101ff1:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101ff4:	53                   	push   %ebx
80101ff5:	e8 46 25 00 00       	call   80104540 <holdingsleep>
80101ffa:	83 c4 10             	add    $0x10,%esp
80101ffd:	85 c0                	test   %eax,%eax
80101fff:	74 2d                	je     8010202e <namex+0x20e>
80102001:	8b 7e 08             	mov    0x8(%esi),%edi
80102004:	85 ff                	test   %edi,%edi
80102006:	7e 26                	jle    8010202e <namex+0x20e>
  releasesleep(&ip->lock);
80102008:	83 ec 0c             	sub    $0xc,%esp
8010200b:	53                   	push   %ebx
8010200c:	e8 ef 24 00 00       	call   80104500 <releasesleep>
}
80102011:	83 c4 10             	add    $0x10,%esp
}
80102014:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102017:	89 f0                	mov    %esi,%eax
80102019:	5b                   	pop    %ebx
8010201a:	5e                   	pop    %esi
8010201b:	5f                   	pop    %edi
8010201c:	5d                   	pop    %ebp
8010201d:	c3                   	ret
    iput(ip);
8010201e:	83 ec 0c             	sub    $0xc,%esp
80102021:	56                   	push   %esi
      return 0;
80102022:	31 f6                	xor    %esi,%esi
    iput(ip);
80102024:	e8 27 f9 ff ff       	call   80101950 <iput>
    return 0;
80102029:	83 c4 10             	add    $0x10,%esp
8010202c:	eb a0                	jmp    80101fce <namex+0x1ae>
    panic("iunlock");
8010202e:	83 ec 0c             	sub    $0xc,%esp
80102031:	68 89 7a 10 80       	push   $0x80107a89
80102036:	e8 45 e3 ff ff       	call   80100380 <panic>
8010203b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102040 <dirlink>:
{
80102040:	55                   	push   %ebp
80102041:	89 e5                	mov    %esp,%ebp
80102043:	57                   	push   %edi
80102044:	56                   	push   %esi
80102045:	53                   	push   %ebx
80102046:	83 ec 20             	sub    $0x20,%esp
80102049:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010204c:	6a 00                	push   $0x0
8010204e:	ff 75 0c             	push   0xc(%ebp)
80102051:	53                   	push   %ebx
80102052:	e8 19 fd ff ff       	call   80101d70 <dirlookup>
80102057:	83 c4 10             	add    $0x10,%esp
8010205a:	85 c0                	test   %eax,%eax
8010205c:	75 67                	jne    801020c5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010205e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102061:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102064:	85 ff                	test   %edi,%edi
80102066:	74 29                	je     80102091 <dirlink+0x51>
80102068:	31 ff                	xor    %edi,%edi
8010206a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010206d:	eb 09                	jmp    80102078 <dirlink+0x38>
8010206f:	90                   	nop
80102070:	83 c7 10             	add    $0x10,%edi
80102073:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102076:	73 19                	jae    80102091 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102078:	6a 10                	push   $0x10
8010207a:	57                   	push   %edi
8010207b:	56                   	push   %esi
8010207c:	53                   	push   %ebx
8010207d:	e8 ae fa ff ff       	call   80101b30 <readi>
80102082:	83 c4 10             	add    $0x10,%esp
80102085:	83 f8 10             	cmp    $0x10,%eax
80102088:	75 4e                	jne    801020d8 <dirlink+0x98>
    if(de.inum == 0)
8010208a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010208f:	75 df                	jne    80102070 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102091:	83 ec 04             	sub    $0x4,%esp
80102094:	8d 45 da             	lea    -0x26(%ebp),%eax
80102097:	6a 0e                	push   $0xe
80102099:	ff 75 0c             	push   0xc(%ebp)
8010209c:	50                   	push   %eax
8010209d:	e8 2e 29 00 00       	call   801049d0 <strncpy>
  de.inum = inum;
801020a2:	8b 45 10             	mov    0x10(%ebp),%eax
801020a5:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020a9:	6a 10                	push   $0x10
801020ab:	57                   	push   %edi
801020ac:	56                   	push   %esi
801020ad:	53                   	push   %ebx
801020ae:	e8 7d fb ff ff       	call   80101c30 <writei>
801020b3:	83 c4 20             	add    $0x20,%esp
801020b6:	83 f8 10             	cmp    $0x10,%eax
801020b9:	75 2a                	jne    801020e5 <dirlink+0xa5>
  return 0;
801020bb:	31 c0                	xor    %eax,%eax
}
801020bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020c0:	5b                   	pop    %ebx
801020c1:	5e                   	pop    %esi
801020c2:	5f                   	pop    %edi
801020c3:	5d                   	pop    %ebp
801020c4:	c3                   	ret
    iput(ip);
801020c5:	83 ec 0c             	sub    $0xc,%esp
801020c8:	50                   	push   %eax
801020c9:	e8 82 f8 ff ff       	call   80101950 <iput>
    return -1;
801020ce:	83 c4 10             	add    $0x10,%esp
801020d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020d6:	eb e5                	jmp    801020bd <dirlink+0x7d>
      panic("dirlink read");
801020d8:	83 ec 0c             	sub    $0xc,%esp
801020db:	68 b2 7a 10 80       	push   $0x80107ab2
801020e0:	e8 9b e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
801020e5:	83 ec 0c             	sub    $0xc,%esp
801020e8:	68 24 7d 10 80       	push   $0x80107d24
801020ed:	e8 8e e2 ff ff       	call   80100380 <panic>
801020f2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801020f9:	00 
801020fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102100 <namei>:

struct inode*
namei(char *path)
{
80102100:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102101:	31 d2                	xor    %edx,%edx
{
80102103:	89 e5                	mov    %esp,%ebp
80102105:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102108:	8b 45 08             	mov    0x8(%ebp),%eax
8010210b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010210e:	e8 0d fd ff ff       	call   80101e20 <namex>
}
80102113:	c9                   	leave
80102114:	c3                   	ret
80102115:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010211c:	00 
8010211d:	8d 76 00             	lea    0x0(%esi),%esi

80102120 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102120:	55                   	push   %ebp
  return namex(path, 1, name);
80102121:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102126:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102128:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010212b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010212e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010212f:	e9 ec fc ff ff       	jmp    80101e20 <namex>
80102134:	66 90                	xchg   %ax,%ax
80102136:	66 90                	xchg   %ax,%ax
80102138:	66 90                	xchg   %ax,%ax
8010213a:	66 90                	xchg   %ax,%ax
8010213c:	66 90                	xchg   %ax,%ax
8010213e:	66 90                	xchg   %ax,%ax

80102140 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102140:	55                   	push   %ebp
80102141:	89 e5                	mov    %esp,%ebp
80102143:	57                   	push   %edi
80102144:	56                   	push   %esi
80102145:	53                   	push   %ebx
80102146:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102149:	85 c0                	test   %eax,%eax
8010214b:	0f 84 b4 00 00 00    	je     80102205 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102151:	8b 70 08             	mov    0x8(%eax),%esi
80102154:	89 c3                	mov    %eax,%ebx
80102156:	81 fe e7 1c 00 00    	cmp    $0x1ce7,%esi
8010215c:	0f 87 96 00 00 00    	ja     801021f8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102162:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102167:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010216e:	00 
8010216f:	90                   	nop
80102170:	89 ca                	mov    %ecx,%edx
80102172:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102173:	83 e0 c0             	and    $0xffffffc0,%eax
80102176:	3c 40                	cmp    $0x40,%al
80102178:	75 f6                	jne    80102170 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010217a:	31 ff                	xor    %edi,%edi
8010217c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102181:	89 f8                	mov    %edi,%eax
80102183:	ee                   	out    %al,(%dx)
80102184:	b8 01 00 00 00       	mov    $0x1,%eax
80102189:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010218e:	ee                   	out    %al,(%dx)
8010218f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102194:	89 f0                	mov    %esi,%eax
80102196:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102197:	89 f0                	mov    %esi,%eax
80102199:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010219e:	c1 f8 08             	sar    $0x8,%eax
801021a1:	ee                   	out    %al,(%dx)
801021a2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801021a7:	89 f8                	mov    %edi,%eax
801021a9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801021aa:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801021ae:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021b3:	c1 e0 04             	shl    $0x4,%eax
801021b6:	83 e0 10             	and    $0x10,%eax
801021b9:	83 c8 e0             	or     $0xffffffe0,%eax
801021bc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801021bd:	f6 03 04             	testb  $0x4,(%ebx)
801021c0:	75 16                	jne    801021d8 <idestart+0x98>
801021c2:	b8 20 00 00 00       	mov    $0x20,%eax
801021c7:	89 ca                	mov    %ecx,%edx
801021c9:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
801021ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021cd:	5b                   	pop    %ebx
801021ce:	5e                   	pop    %esi
801021cf:	5f                   	pop    %edi
801021d0:	5d                   	pop    %ebp
801021d1:	c3                   	ret
801021d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801021d8:	b8 30 00 00 00       	mov    $0x30,%eax
801021dd:	89 ca                	mov    %ecx,%edx
801021df:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
801021e0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
801021e5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801021e8:	ba f0 01 00 00       	mov    $0x1f0,%edx
801021ed:	fc                   	cld
801021ee:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801021f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021f3:	5b                   	pop    %ebx
801021f4:	5e                   	pop    %esi
801021f5:	5f                   	pop    %edi
801021f6:	5d                   	pop    %ebp
801021f7:	c3                   	ret
    panic("incorrect blockno");
801021f8:	83 ec 0c             	sub    $0xc,%esp
801021fb:	68 c8 7a 10 80       	push   $0x80107ac8
80102200:	e8 7b e1 ff ff       	call   80100380 <panic>
    panic("idestart");
80102205:	83 ec 0c             	sub    $0xc,%esp
80102208:	68 bf 7a 10 80       	push   $0x80107abf
8010220d:	e8 6e e1 ff ff       	call   80100380 <panic>
80102212:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102219:	00 
8010221a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102220 <ideinit>:
{
80102220:	55                   	push   %ebp
80102221:	89 e5                	mov    %esp,%ebp
80102223:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102226:	68 da 7a 10 80       	push   $0x80107ada
8010222b:	68 60 26 11 80       	push   $0x80112660
80102230:	e8 5b 23 00 00       	call   80104590 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102235:	58                   	pop    %eax
80102236:	a1 e4 27 11 80       	mov    0x801127e4,%eax
8010223b:	5a                   	pop    %edx
8010223c:	83 e8 01             	sub    $0x1,%eax
8010223f:	50                   	push   %eax
80102240:	6a 0e                	push   $0xe
80102242:	e8 99 02 00 00       	call   801024e0 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102247:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010224a:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
8010224f:	90                   	nop
80102250:	89 ca                	mov    %ecx,%edx
80102252:	ec                   	in     (%dx),%al
80102253:	83 e0 c0             	and    $0xffffffc0,%eax
80102256:	3c 40                	cmp    $0x40,%al
80102258:	75 f6                	jne    80102250 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010225a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010225f:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102264:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102265:	89 ca                	mov    %ecx,%edx
80102267:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102268:	84 c0                	test   %al,%al
8010226a:	75 1e                	jne    8010228a <ideinit+0x6a>
8010226c:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
80102271:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102276:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010227d:	00 
8010227e:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
80102280:	83 e9 01             	sub    $0x1,%ecx
80102283:	74 0f                	je     80102294 <ideinit+0x74>
80102285:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102286:	84 c0                	test   %al,%al
80102288:	74 f6                	je     80102280 <ideinit+0x60>
      havedisk1 = 1;
8010228a:	c7 05 40 26 11 80 01 	movl   $0x1,0x80112640
80102291:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102294:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102299:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010229e:	ee                   	out    %al,(%dx)
}
8010229f:	c9                   	leave
801022a0:	c3                   	ret
801022a1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801022a8:	00 
801022a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801022b0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801022b0:	55                   	push   %ebp
801022b1:	89 e5                	mov    %esp,%ebp
801022b3:	57                   	push   %edi
801022b4:	56                   	push   %esi
801022b5:	53                   	push   %ebx
801022b6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801022b9:	68 60 26 11 80       	push   $0x80112660
801022be:	e8 bd 24 00 00       	call   80104780 <acquire>

  if((b = idequeue) == 0){
801022c3:	8b 1d 44 26 11 80    	mov    0x80112644,%ebx
801022c9:	83 c4 10             	add    $0x10,%esp
801022cc:	85 db                	test   %ebx,%ebx
801022ce:	74 63                	je     80102333 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801022d0:	8b 43 58             	mov    0x58(%ebx),%eax
801022d3:	a3 44 26 11 80       	mov    %eax,0x80112644

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801022d8:	8b 33                	mov    (%ebx),%esi
801022da:	f7 c6 04 00 00 00    	test   $0x4,%esi
801022e0:	75 2f                	jne    80102311 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022e2:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022e7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801022ee:	00 
801022ef:	90                   	nop
801022f0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022f1:	89 c1                	mov    %eax,%ecx
801022f3:	83 e1 c0             	and    $0xffffffc0,%ecx
801022f6:	80 f9 40             	cmp    $0x40,%cl
801022f9:	75 f5                	jne    801022f0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801022fb:	a8 21                	test   $0x21,%al
801022fd:	75 12                	jne    80102311 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
801022ff:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102302:	b9 80 00 00 00       	mov    $0x80,%ecx
80102307:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010230c:	fc                   	cld
8010230d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010230f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80102311:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102314:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102317:	83 ce 02             	or     $0x2,%esi
8010231a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010231c:	53                   	push   %ebx
8010231d:	e8 1e 1f 00 00       	call   80104240 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102322:	a1 44 26 11 80       	mov    0x80112644,%eax
80102327:	83 c4 10             	add    $0x10,%esp
8010232a:	85 c0                	test   %eax,%eax
8010232c:	74 05                	je     80102333 <ideintr+0x83>
    idestart(idequeue);
8010232e:	e8 0d fe ff ff       	call   80102140 <idestart>
    release(&idelock);
80102333:	83 ec 0c             	sub    $0xc,%esp
80102336:	68 60 26 11 80       	push   $0x80112660
8010233b:	e8 e0 23 00 00       	call   80104720 <release>

  release(&idelock);
}
80102340:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102343:	5b                   	pop    %ebx
80102344:	5e                   	pop    %esi
80102345:	5f                   	pop    %edi
80102346:	5d                   	pop    %ebp
80102347:	c3                   	ret
80102348:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010234f:	00 

80102350 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102350:	55                   	push   %ebp
80102351:	89 e5                	mov    %esp,%ebp
80102353:	53                   	push   %ebx
80102354:	83 ec 10             	sub    $0x10,%esp
80102357:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010235a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010235d:	50                   	push   %eax
8010235e:	e8 dd 21 00 00       	call   80104540 <holdingsleep>
80102363:	83 c4 10             	add    $0x10,%esp
80102366:	85 c0                	test   %eax,%eax
80102368:	0f 84 c3 00 00 00    	je     80102431 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010236e:	8b 03                	mov    (%ebx),%eax
80102370:	83 e0 06             	and    $0x6,%eax
80102373:	83 f8 02             	cmp    $0x2,%eax
80102376:	0f 84 a8 00 00 00    	je     80102424 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010237c:	8b 53 04             	mov    0x4(%ebx),%edx
8010237f:	85 d2                	test   %edx,%edx
80102381:	74 0d                	je     80102390 <iderw+0x40>
80102383:	a1 40 26 11 80       	mov    0x80112640,%eax
80102388:	85 c0                	test   %eax,%eax
8010238a:	0f 84 87 00 00 00    	je     80102417 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102390:	83 ec 0c             	sub    $0xc,%esp
80102393:	68 60 26 11 80       	push   $0x80112660
80102398:	e8 e3 23 00 00       	call   80104780 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010239d:	a1 44 26 11 80       	mov    0x80112644,%eax
  b->qnext = 0;
801023a2:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023a9:	83 c4 10             	add    $0x10,%esp
801023ac:	85 c0                	test   %eax,%eax
801023ae:	74 60                	je     80102410 <iderw+0xc0>
801023b0:	89 c2                	mov    %eax,%edx
801023b2:	8b 40 58             	mov    0x58(%eax),%eax
801023b5:	85 c0                	test   %eax,%eax
801023b7:	75 f7                	jne    801023b0 <iderw+0x60>
801023b9:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801023bc:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801023be:	39 1d 44 26 11 80    	cmp    %ebx,0x80112644
801023c4:	74 3a                	je     80102400 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801023c6:	8b 03                	mov    (%ebx),%eax
801023c8:	83 e0 06             	and    $0x6,%eax
801023cb:	83 f8 02             	cmp    $0x2,%eax
801023ce:	74 1b                	je     801023eb <iderw+0x9b>
    sleep(b, &idelock);
801023d0:	83 ec 08             	sub    $0x8,%esp
801023d3:	68 60 26 11 80       	push   $0x80112660
801023d8:	53                   	push   %ebx
801023d9:	e8 a2 1d 00 00       	call   80104180 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801023de:	8b 03                	mov    (%ebx),%eax
801023e0:	83 c4 10             	add    $0x10,%esp
801023e3:	83 e0 06             	and    $0x6,%eax
801023e6:	83 f8 02             	cmp    $0x2,%eax
801023e9:	75 e5                	jne    801023d0 <iderw+0x80>
  }


  release(&idelock);
801023eb:	c7 45 08 60 26 11 80 	movl   $0x80112660,0x8(%ebp)
}
801023f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801023f5:	c9                   	leave
  release(&idelock);
801023f6:	e9 25 23 00 00       	jmp    80104720 <release>
801023fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    idestart(b);
80102400:	89 d8                	mov    %ebx,%eax
80102402:	e8 39 fd ff ff       	call   80102140 <idestart>
80102407:	eb bd                	jmp    801023c6 <iderw+0x76>
80102409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102410:	ba 44 26 11 80       	mov    $0x80112644,%edx
80102415:	eb a5                	jmp    801023bc <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80102417:	83 ec 0c             	sub    $0xc,%esp
8010241a:	68 09 7b 10 80       	push   $0x80107b09
8010241f:	e8 5c df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
80102424:	83 ec 0c             	sub    $0xc,%esp
80102427:	68 f4 7a 10 80       	push   $0x80107af4
8010242c:	e8 4f df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
80102431:	83 ec 0c             	sub    $0xc,%esp
80102434:	68 de 7a 10 80       	push   $0x80107ade
80102439:	e8 42 df ff ff       	call   80100380 <panic>
8010243e:	66 90                	xchg   %ax,%ax

80102440 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102440:	55                   	push   %ebp
80102441:	89 e5                	mov    %esp,%ebp
80102443:	56                   	push   %esi
80102444:	53                   	push   %ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102445:	c7 05 94 26 11 80 00 	movl   $0xfec00000,0x80112694
8010244c:	00 c0 fe 
  ioapic->reg = reg;
8010244f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102456:	00 00 00 
  return ioapic->data;
80102459:	8b 15 94 26 11 80    	mov    0x80112694,%edx
8010245f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102462:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102468:	8b 1d 94 26 11 80    	mov    0x80112694,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010246e:	0f b6 15 e0 27 11 80 	movzbl 0x801127e0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102475:	c1 ee 10             	shr    $0x10,%esi
80102478:	89 f0                	mov    %esi,%eax
8010247a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010247d:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
80102480:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102483:	39 c2                	cmp    %eax,%edx
80102485:	74 16                	je     8010249d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102487:	83 ec 0c             	sub    $0xc,%esp
8010248a:	68 38 7f 10 80       	push   $0x80107f38
8010248f:	e8 1c e2 ff ff       	call   801006b0 <cprintf>
  ioapic->reg = reg;
80102494:	8b 1d 94 26 11 80    	mov    0x80112694,%ebx
8010249a:	83 c4 10             	add    $0x10,%esp
{
8010249d:	ba 10 00 00 00       	mov    $0x10,%edx
801024a2:	31 c0                	xor    %eax,%eax
801024a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapic->reg = reg;
801024a8:	89 13                	mov    %edx,(%ebx)
801024aa:	8d 48 20             	lea    0x20(%eax),%ecx
  ioapic->data = data;
801024ad:	8b 1d 94 26 11 80    	mov    0x80112694,%ebx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801024b3:	83 c0 01             	add    $0x1,%eax
801024b6:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  ioapic->data = data;
801024bc:	89 4b 10             	mov    %ecx,0x10(%ebx)
  ioapic->reg = reg;
801024bf:	8d 4a 01             	lea    0x1(%edx),%ecx
  for(i = 0; i <= maxintr; i++){
801024c2:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
801024c5:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
801024c7:	8b 1d 94 26 11 80    	mov    0x80112694,%ebx
801024cd:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  for(i = 0; i <= maxintr; i++){
801024d4:	39 c6                	cmp    %eax,%esi
801024d6:	7d d0                	jge    801024a8 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801024d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
801024db:	5b                   	pop    %ebx
801024dc:	5e                   	pop    %esi
801024dd:	5d                   	pop    %ebp
801024de:	c3                   	ret
801024df:	90                   	nop

801024e0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801024e0:	55                   	push   %ebp
  ioapic->reg = reg;
801024e1:	8b 0d 94 26 11 80    	mov    0x80112694,%ecx
{
801024e7:	89 e5                	mov    %esp,%ebp
801024e9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801024ec:	8d 50 20             	lea    0x20(%eax),%edx
801024ef:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801024f3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024f5:	8b 0d 94 26 11 80    	mov    0x80112694,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024fb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801024fe:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102501:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102504:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102506:	a1 94 26 11 80       	mov    0x80112694,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010250b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010250e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102511:	5d                   	pop    %ebp
80102512:	c3                   	ret
80102513:	66 90                	xchg   %ax,%ax
80102515:	66 90                	xchg   %ax,%ax
80102517:	66 90                	xchg   %ax,%ax
80102519:	66 90                	xchg   %ax,%ax
8010251b:	66 90                	xchg   %ax,%ax
8010251d:	66 90                	xchg   %ax,%ax
8010251f:	90                   	nop

80102520 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102520:	55                   	push   %ebp
80102521:	89 e5                	mov    %esp,%ebp
80102523:	53                   	push   %ebx
80102524:	83 ec 04             	sub    $0x4,%esp
80102527:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010252a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102530:	75 76                	jne    801025a8 <kfree+0x88>
80102532:	81 fb c0 8b 11 80    	cmp    $0x80118bc0,%ebx
80102538:	72 6e                	jb     801025a8 <kfree+0x88>
8010253a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102540:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
80102545:	77 61                	ja     801025a8 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102547:	83 ec 04             	sub    $0x4,%esp
8010254a:	68 00 10 00 00       	push   $0x1000
8010254f:	6a 01                	push   $0x1
80102551:	53                   	push   %ebx
80102552:	e8 29 23 00 00       	call   80104880 <memset>

  if(kmem.use_lock)
80102557:	8b 15 d4 26 11 80    	mov    0x801126d4,%edx
8010255d:	83 c4 10             	add    $0x10,%esp
80102560:	85 d2                	test   %edx,%edx
80102562:	75 1c                	jne    80102580 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102564:	a1 d8 26 11 80       	mov    0x801126d8,%eax
80102569:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010256b:	a1 d4 26 11 80       	mov    0x801126d4,%eax
  kmem.freelist = r;
80102570:	89 1d d8 26 11 80    	mov    %ebx,0x801126d8
  if(kmem.use_lock)
80102576:	85 c0                	test   %eax,%eax
80102578:	75 1e                	jne    80102598 <kfree+0x78>
    release(&kmem.lock);
}
8010257a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010257d:	c9                   	leave
8010257e:	c3                   	ret
8010257f:	90                   	nop
    acquire(&kmem.lock);
80102580:	83 ec 0c             	sub    $0xc,%esp
80102583:	68 a0 26 11 80       	push   $0x801126a0
80102588:	e8 f3 21 00 00       	call   80104780 <acquire>
8010258d:	83 c4 10             	add    $0x10,%esp
80102590:	eb d2                	jmp    80102564 <kfree+0x44>
80102592:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102598:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
8010259f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025a2:	c9                   	leave
    release(&kmem.lock);
801025a3:	e9 78 21 00 00       	jmp    80104720 <release>
    panic("kfree");
801025a8:	83 ec 0c             	sub    $0xc,%esp
801025ab:	68 27 7b 10 80       	push   $0x80107b27
801025b0:	e8 cb dd ff ff       	call   80100380 <panic>
801025b5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801025bc:	00 
801025bd:	8d 76 00             	lea    0x0(%esi),%esi

801025c0 <freerange>:
{
801025c0:	55                   	push   %ebp
801025c1:	89 e5                	mov    %esp,%ebp
801025c3:	56                   	push   %esi
801025c4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801025c5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801025c8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801025cb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025d1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025d7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025dd:	39 de                	cmp    %ebx,%esi
801025df:	72 23                	jb     80102604 <freerange+0x44>
801025e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025e8:	83 ec 0c             	sub    $0xc,%esp
801025eb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025f1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025f7:	50                   	push   %eax
801025f8:	e8 23 ff ff ff       	call   80102520 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025fd:	83 c4 10             	add    $0x10,%esp
80102600:	39 de                	cmp    %ebx,%esi
80102602:	73 e4                	jae    801025e8 <freerange+0x28>
}
80102604:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102607:	5b                   	pop    %ebx
80102608:	5e                   	pop    %esi
80102609:	5d                   	pop    %ebp
8010260a:	c3                   	ret
8010260b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102610 <kinit2>:
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	56                   	push   %esi
80102614:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102615:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102618:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010261b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102621:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102627:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010262d:	39 de                	cmp    %ebx,%esi
8010262f:	72 23                	jb     80102654 <kinit2+0x44>
80102631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102638:	83 ec 0c             	sub    $0xc,%esp
8010263b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102641:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102647:	50                   	push   %eax
80102648:	e8 d3 fe ff ff       	call   80102520 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010264d:	83 c4 10             	add    $0x10,%esp
80102650:	39 de                	cmp    %ebx,%esi
80102652:	73 e4                	jae    80102638 <kinit2+0x28>
  kmem.use_lock = 1;
80102654:	c7 05 d4 26 11 80 01 	movl   $0x1,0x801126d4
8010265b:	00 00 00 
}
8010265e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102661:	5b                   	pop    %ebx
80102662:	5e                   	pop    %esi
80102663:	5d                   	pop    %ebp
80102664:	c3                   	ret
80102665:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010266c:	00 
8010266d:	8d 76 00             	lea    0x0(%esi),%esi

80102670 <kinit1>:
{
80102670:	55                   	push   %ebp
80102671:	89 e5                	mov    %esp,%ebp
80102673:	56                   	push   %esi
80102674:	53                   	push   %ebx
80102675:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102678:	83 ec 08             	sub    $0x8,%esp
8010267b:	68 2d 7b 10 80       	push   $0x80107b2d
80102680:	68 a0 26 11 80       	push   $0x801126a0
80102685:	e8 06 1f 00 00       	call   80104590 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010268a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010268d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102690:	c7 05 d4 26 11 80 00 	movl   $0x0,0x801126d4
80102697:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010269a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801026a0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026a6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801026ac:	39 de                	cmp    %ebx,%esi
801026ae:	72 1c                	jb     801026cc <kinit1+0x5c>
    kfree(p);
801026b0:	83 ec 0c             	sub    $0xc,%esp
801026b3:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026b9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801026bf:	50                   	push   %eax
801026c0:	e8 5b fe ff ff       	call   80102520 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026c5:	83 c4 10             	add    $0x10,%esp
801026c8:	39 de                	cmp    %ebx,%esi
801026ca:	73 e4                	jae    801026b0 <kinit1+0x40>
}
801026cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026cf:	5b                   	pop    %ebx
801026d0:	5e                   	pop    %esi
801026d1:	5d                   	pop    %ebp
801026d2:	c3                   	ret
801026d3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801026da:	00 
801026db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801026e0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801026e0:	55                   	push   %ebp
801026e1:	89 e5                	mov    %esp,%ebp
801026e3:	53                   	push   %ebx
801026e4:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
801026e7:	a1 d4 26 11 80       	mov    0x801126d4,%eax
801026ec:	85 c0                	test   %eax,%eax
801026ee:	75 20                	jne    80102710 <kalloc+0x30>
    acquire(&kmem.lock);
  r = kmem.freelist;
801026f0:	8b 1d d8 26 11 80    	mov    0x801126d8,%ebx
  if(r)
801026f6:	85 db                	test   %ebx,%ebx
801026f8:	74 07                	je     80102701 <kalloc+0x21>
    kmem.freelist = r->next;
801026fa:	8b 03                	mov    (%ebx),%eax
801026fc:	a3 d8 26 11 80       	mov    %eax,0x801126d8
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102701:	89 d8                	mov    %ebx,%eax
80102703:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102706:	c9                   	leave
80102707:	c3                   	ret
80102708:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010270f:	00 
    acquire(&kmem.lock);
80102710:	83 ec 0c             	sub    $0xc,%esp
80102713:	68 a0 26 11 80       	push   $0x801126a0
80102718:	e8 63 20 00 00       	call   80104780 <acquire>
  r = kmem.freelist;
8010271d:	8b 1d d8 26 11 80    	mov    0x801126d8,%ebx
  if(kmem.use_lock)
80102723:	a1 d4 26 11 80       	mov    0x801126d4,%eax
  if(r)
80102728:	83 c4 10             	add    $0x10,%esp
8010272b:	85 db                	test   %ebx,%ebx
8010272d:	74 08                	je     80102737 <kalloc+0x57>
    kmem.freelist = r->next;
8010272f:	8b 13                	mov    (%ebx),%edx
80102731:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
  if(kmem.use_lock)
80102737:	85 c0                	test   %eax,%eax
80102739:	74 c6                	je     80102701 <kalloc+0x21>
    release(&kmem.lock);
8010273b:	83 ec 0c             	sub    $0xc,%esp
8010273e:	68 a0 26 11 80       	push   $0x801126a0
80102743:	e8 d8 1f 00 00       	call   80104720 <release>
}
80102748:	89 d8                	mov    %ebx,%eax
    release(&kmem.lock);
8010274a:	83 c4 10             	add    $0x10,%esp
}
8010274d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102750:	c9                   	leave
80102751:	c3                   	ret
80102752:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102759:	00 
8010275a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102760 <get_free_pages>:
//     release(&kmem.lock);
//     return temp;
// }

int get_free_pages(void)
{
80102760:	55                   	push   %ebp
80102761:	89 e5                	mov    %esp,%ebp
80102763:	53                   	push   %ebx
    int temp=0;
80102764:	31 db                	xor    %ebx,%ebx
{
80102766:	83 ec 10             	sub    $0x10,%esp
    struct run* r;

    acquire(&kmem.lock);
80102769:	68 a0 26 11 80       	push   $0x801126a0
8010276e:	e8 0d 20 00 00       	call   80104780 <acquire>
    r=kmem.freelist;
80102773:	a1 d8 26 11 80       	mov    0x801126d8,%eax
    while(r)
80102778:	83 c4 10             	add    $0x10,%esp
8010277b:	85 c0                	test   %eax,%eax
8010277d:	74 0a                	je     80102789 <get_free_pages+0x29>
8010277f:	90                   	nop
    {
      temp++;r=r->next;
80102780:	8b 00                	mov    (%eax),%eax
80102782:	83 c3 01             	add    $0x1,%ebx
    while(r)
80102785:	85 c0                	test   %eax,%eax
80102787:	75 f7                	jne    80102780 <get_free_pages+0x20>
    }
    release(&kmem.lock);
80102789:	83 ec 0c             	sub    $0xc,%esp
8010278c:	68 a0 26 11 80       	push   $0x801126a0
80102791:	e8 8a 1f 00 00       	call   80104720 <release>
    return temp;
}
80102796:	89 d8                	mov    %ebx,%eax
80102798:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010279b:	c9                   	leave
8010279c:	c3                   	ret
8010279d:	66 90                	xchg   %ax,%ax
8010279f:	90                   	nop

801027a0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027a0:	ba 64 00 00 00       	mov    $0x64,%edx
801027a5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801027a6:	a8 01                	test   $0x1,%al
801027a8:	0f 84 c2 00 00 00    	je     80102870 <kbdgetc+0xd0>
{
801027ae:	55                   	push   %ebp
801027af:	ba 60 00 00 00       	mov    $0x60,%edx
801027b4:	89 e5                	mov    %esp,%ebp
801027b6:	53                   	push   %ebx
801027b7:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801027b8:	8b 1d dc 26 11 80    	mov    0x801126dc,%ebx
  data = inb(KBDATAP);
801027be:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
801027c1:	3c e0                	cmp    $0xe0,%al
801027c3:	74 5b                	je     80102820 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801027c5:	89 da                	mov    %ebx,%edx
801027c7:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
801027ca:	84 c0                	test   %al,%al
801027cc:	78 62                	js     80102830 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801027ce:	85 d2                	test   %edx,%edx
801027d0:	74 09                	je     801027db <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801027d2:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801027d5:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801027d8:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
801027db:	0f b6 91 e0 81 10 80 	movzbl -0x7fef7e20(%ecx),%edx
  shift ^= togglecode[data];
801027e2:	0f b6 81 e0 80 10 80 	movzbl -0x7fef7f20(%ecx),%eax
  shift |= shiftcode[data];
801027e9:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
801027eb:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801027ed:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
801027ef:	89 15 dc 26 11 80    	mov    %edx,0x801126dc
  c = charcode[shift & (CTL | SHIFT)][data];
801027f5:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801027f8:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801027fb:	8b 04 85 c0 80 10 80 	mov    -0x7fef7f40(,%eax,4),%eax
80102802:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102806:	74 0b                	je     80102813 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102808:	8d 50 9f             	lea    -0x61(%eax),%edx
8010280b:	83 fa 19             	cmp    $0x19,%edx
8010280e:	77 48                	ja     80102858 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102810:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102813:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102816:	c9                   	leave
80102817:	c3                   	ret
80102818:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010281f:	00 
    shift |= E0ESC;
80102820:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102823:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102825:	89 1d dc 26 11 80    	mov    %ebx,0x801126dc
}
8010282b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010282e:	c9                   	leave
8010282f:	c3                   	ret
    data = (shift & E0ESC ? data : data & 0x7F);
80102830:	83 e0 7f             	and    $0x7f,%eax
80102833:	85 d2                	test   %edx,%edx
80102835:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102838:	0f b6 81 e0 81 10 80 	movzbl -0x7fef7e20(%ecx),%eax
8010283f:	83 c8 40             	or     $0x40,%eax
80102842:	0f b6 c0             	movzbl %al,%eax
80102845:	f7 d0                	not    %eax
80102847:	21 d8                	and    %ebx,%eax
80102849:	a3 dc 26 11 80       	mov    %eax,0x801126dc
    return 0;
8010284e:	31 c0                	xor    %eax,%eax
80102850:	eb d9                	jmp    8010282b <kbdgetc+0x8b>
80102852:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102858:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010285b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010285e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102861:	c9                   	leave
      c += 'a' - 'A';
80102862:	83 f9 1a             	cmp    $0x1a,%ecx
80102865:	0f 42 c2             	cmovb  %edx,%eax
}
80102868:	c3                   	ret
80102869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80102870:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102875:	c3                   	ret
80102876:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010287d:	00 
8010287e:	66 90                	xchg   %ax,%ax

80102880 <kbdintr>:

void
kbdintr(void)
{
80102880:	55                   	push   %ebp
80102881:	89 e5                	mov    %esp,%ebp
80102883:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102886:	68 a0 27 10 80       	push   $0x801027a0
8010288b:	e8 10 e0 ff ff       	call   801008a0 <consoleintr>
}
80102890:	83 c4 10             	add    $0x10,%esp
80102893:	c9                   	leave
80102894:	c3                   	ret
80102895:	66 90                	xchg   %ax,%ax
80102897:	66 90                	xchg   %ax,%ax
80102899:	66 90                	xchg   %ax,%ax
8010289b:	66 90                	xchg   %ax,%ax
8010289d:	66 90                	xchg   %ax,%ax
8010289f:	90                   	nop

801028a0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801028a0:	a1 e0 26 11 80       	mov    0x801126e0,%eax
801028a5:	85 c0                	test   %eax,%eax
801028a7:	0f 84 c3 00 00 00    	je     80102970 <lapicinit+0xd0>
  lapic[index] = value;
801028ad:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801028b4:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028b7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028ba:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801028c1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028c4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028c7:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801028ce:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801028d1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028d4:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801028db:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801028de:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028e1:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801028e8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028eb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028ee:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801028f5:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028f8:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801028fb:	8b 50 30             	mov    0x30(%eax),%edx
801028fe:	81 e2 00 00 fc 00    	and    $0xfc0000,%edx
80102904:	75 72                	jne    80102978 <lapicinit+0xd8>
  lapic[index] = value;
80102906:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
8010290d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102910:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102913:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010291a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010291d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102920:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102927:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010292a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010292d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102934:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102937:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010293a:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102941:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102944:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102947:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
8010294e:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102951:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102954:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102958:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010295e:	80 e6 10             	and    $0x10,%dh
80102961:	75 f5                	jne    80102958 <lapicinit+0xb8>
  lapic[index] = value;
80102963:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010296a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010296d:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102970:	c3                   	ret
80102971:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102978:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
8010297f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102982:	8b 50 20             	mov    0x20(%eax),%edx
}
80102985:	e9 7c ff ff ff       	jmp    80102906 <lapicinit+0x66>
8010298a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102990 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102990:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102995:	85 c0                	test   %eax,%eax
80102997:	74 07                	je     801029a0 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102999:	8b 40 20             	mov    0x20(%eax),%eax
8010299c:	c1 e8 18             	shr    $0x18,%eax
8010299f:	c3                   	ret
    return 0;
801029a0:	31 c0                	xor    %eax,%eax
}
801029a2:	c3                   	ret
801029a3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801029aa:	00 
801029ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801029b0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801029b0:	a1 e0 26 11 80       	mov    0x801126e0,%eax
801029b5:	85 c0                	test   %eax,%eax
801029b7:	74 0d                	je     801029c6 <lapiceoi+0x16>
  lapic[index] = value;
801029b9:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801029c0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029c3:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801029c6:	c3                   	ret
801029c7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801029ce:	00 
801029cf:	90                   	nop

801029d0 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
801029d0:	c3                   	ret
801029d1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801029d8:	00 
801029d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801029e0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801029e0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029e1:	b8 0f 00 00 00       	mov    $0xf,%eax
801029e6:	ba 70 00 00 00       	mov    $0x70,%edx
801029eb:	89 e5                	mov    %esp,%ebp
801029ed:	53                   	push   %ebx
801029ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801029f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801029f4:	ee                   	out    %al,(%dx)
801029f5:	b8 0a 00 00 00       	mov    $0xa,%eax
801029fa:	ba 71 00 00 00       	mov    $0x71,%edx
801029ff:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102a00:	31 c0                	xor    %eax,%eax
  lapic[index] = value;
80102a02:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102a05:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102a0b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a0d:	c1 e9 0c             	shr    $0xc,%ecx
  lapic[index] = value;
80102a10:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102a12:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a15:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102a18:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102a1e:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102a23:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a29:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a2c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102a33:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a36:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a39:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102a40:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a43:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a46:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a4c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a4f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a55:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a58:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a5e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a61:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a67:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102a6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a6d:	c9                   	leave
80102a6e:	c3                   	ret
80102a6f:	90                   	nop

80102a70 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102a70:	55                   	push   %ebp
80102a71:	b8 0b 00 00 00       	mov    $0xb,%eax
80102a76:	ba 70 00 00 00       	mov    $0x70,%edx
80102a7b:	89 e5                	mov    %esp,%ebp
80102a7d:	57                   	push   %edi
80102a7e:	56                   	push   %esi
80102a7f:	53                   	push   %ebx
80102a80:	83 ec 4c             	sub    $0x4c,%esp
80102a83:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a84:	ba 71 00 00 00       	mov    $0x71,%edx
80102a89:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102a8a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a8d:	bf 70 00 00 00       	mov    $0x70,%edi
80102a92:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102a95:	8d 76 00             	lea    0x0(%esi),%esi
80102a98:	31 c0                	xor    %eax,%eax
80102a9a:	89 fa                	mov    %edi,%edx
80102a9c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a9d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102aa2:	89 ca                	mov    %ecx,%edx
80102aa4:	ec                   	in     (%dx),%al
80102aa5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aa8:	89 fa                	mov    %edi,%edx
80102aaa:	b8 02 00 00 00       	mov    $0x2,%eax
80102aaf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ab0:	89 ca                	mov    %ecx,%edx
80102ab2:	ec                   	in     (%dx),%al
80102ab3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab6:	89 fa                	mov    %edi,%edx
80102ab8:	b8 04 00 00 00       	mov    $0x4,%eax
80102abd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102abe:	89 ca                	mov    %ecx,%edx
80102ac0:	ec                   	in     (%dx),%al
80102ac1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ac4:	89 fa                	mov    %edi,%edx
80102ac6:	b8 07 00 00 00       	mov    $0x7,%eax
80102acb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102acc:	89 ca                	mov    %ecx,%edx
80102ace:	ec                   	in     (%dx),%al
80102acf:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ad2:	89 fa                	mov    %edi,%edx
80102ad4:	b8 08 00 00 00       	mov    $0x8,%eax
80102ad9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ada:	89 ca                	mov    %ecx,%edx
80102adc:	ec                   	in     (%dx),%al
80102add:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102adf:	89 fa                	mov    %edi,%edx
80102ae1:	b8 09 00 00 00       	mov    $0x9,%eax
80102ae6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ae7:	89 ca                	mov    %ecx,%edx
80102ae9:	ec                   	in     (%dx),%al
80102aea:	0f b6 d8             	movzbl %al,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aed:	89 fa                	mov    %edi,%edx
80102aef:	b8 0a 00 00 00       	mov    $0xa,%eax
80102af4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102af5:	89 ca                	mov    %ecx,%edx
80102af7:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102af8:	84 c0                	test   %al,%al
80102afa:	78 9c                	js     80102a98 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102afc:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102b00:	89 f2                	mov    %esi,%edx
80102b02:	89 5d cc             	mov    %ebx,-0x34(%ebp)
80102b05:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b08:	89 fa                	mov    %edi,%edx
80102b0a:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102b0d:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102b11:	89 75 c8             	mov    %esi,-0x38(%ebp)
80102b14:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102b17:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102b1b:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102b1e:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102b22:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102b25:	31 c0                	xor    %eax,%eax
80102b27:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b28:	89 ca                	mov    %ecx,%edx
80102b2a:	ec                   	in     (%dx),%al
80102b2b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b2e:	89 fa                	mov    %edi,%edx
80102b30:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102b33:	b8 02 00 00 00       	mov    $0x2,%eax
80102b38:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b39:	89 ca                	mov    %ecx,%edx
80102b3b:	ec                   	in     (%dx),%al
80102b3c:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b3f:	89 fa                	mov    %edi,%edx
80102b41:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102b44:	b8 04 00 00 00       	mov    $0x4,%eax
80102b49:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b4a:	89 ca                	mov    %ecx,%edx
80102b4c:	ec                   	in     (%dx),%al
80102b4d:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b50:	89 fa                	mov    %edi,%edx
80102b52:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102b55:	b8 07 00 00 00       	mov    $0x7,%eax
80102b5a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b5b:	89 ca                	mov    %ecx,%edx
80102b5d:	ec                   	in     (%dx),%al
80102b5e:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b61:	89 fa                	mov    %edi,%edx
80102b63:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102b66:	b8 08 00 00 00       	mov    $0x8,%eax
80102b6b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b6c:	89 ca                	mov    %ecx,%edx
80102b6e:	ec                   	in     (%dx),%al
80102b6f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b72:	89 fa                	mov    %edi,%edx
80102b74:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102b77:	b8 09 00 00 00       	mov    $0x9,%eax
80102b7c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b7d:	89 ca                	mov    %ecx,%edx
80102b7f:	ec                   	in     (%dx),%al
80102b80:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b83:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102b86:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b89:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102b8c:	6a 18                	push   $0x18
80102b8e:	50                   	push   %eax
80102b8f:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102b92:	50                   	push   %eax
80102b93:	e8 28 1d 00 00       	call   801048c0 <memcmp>
80102b98:	83 c4 10             	add    $0x10,%esp
80102b9b:	85 c0                	test   %eax,%eax
80102b9d:	0f 85 f5 fe ff ff    	jne    80102a98 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102ba3:	0f b6 75 b3          	movzbl -0x4d(%ebp),%esi
80102ba7:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102baa:	89 f0                	mov    %esi,%eax
80102bac:	84 c0                	test   %al,%al
80102bae:	75 78                	jne    80102c28 <cmostime+0x1b8>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102bb0:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102bb3:	89 c2                	mov    %eax,%edx
80102bb5:	83 e0 0f             	and    $0xf,%eax
80102bb8:	c1 ea 04             	shr    $0x4,%edx
80102bbb:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bbe:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bc1:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102bc4:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102bc7:	89 c2                	mov    %eax,%edx
80102bc9:	83 e0 0f             	and    $0xf,%eax
80102bcc:	c1 ea 04             	shr    $0x4,%edx
80102bcf:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bd2:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bd5:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102bd8:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102bdb:	89 c2                	mov    %eax,%edx
80102bdd:	83 e0 0f             	and    $0xf,%eax
80102be0:	c1 ea 04             	shr    $0x4,%edx
80102be3:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102be6:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102be9:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102bec:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102bef:	89 c2                	mov    %eax,%edx
80102bf1:	83 e0 0f             	and    $0xf,%eax
80102bf4:	c1 ea 04             	shr    $0x4,%edx
80102bf7:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bfa:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bfd:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102c00:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102c03:	89 c2                	mov    %eax,%edx
80102c05:	83 e0 0f             	and    $0xf,%eax
80102c08:	c1 ea 04             	shr    $0x4,%edx
80102c0b:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c0e:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c11:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102c14:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102c17:	89 c2                	mov    %eax,%edx
80102c19:	83 e0 0f             	and    $0xf,%eax
80102c1c:	c1 ea 04             	shr    $0x4,%edx
80102c1f:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c22:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c25:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102c28:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102c2b:	89 03                	mov    %eax,(%ebx)
80102c2d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102c30:	89 43 04             	mov    %eax,0x4(%ebx)
80102c33:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102c36:	89 43 08             	mov    %eax,0x8(%ebx)
80102c39:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102c3c:	89 43 0c             	mov    %eax,0xc(%ebx)
80102c3f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102c42:	89 43 10             	mov    %eax,0x10(%ebx)
80102c45:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102c48:	89 43 14             	mov    %eax,0x14(%ebx)
  r->year += 2000;
80102c4b:	81 43 14 d0 07 00 00 	addl   $0x7d0,0x14(%ebx)
}
80102c52:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c55:	5b                   	pop    %ebx
80102c56:	5e                   	pop    %esi
80102c57:	5f                   	pop    %edi
80102c58:	5d                   	pop    %ebp
80102c59:	c3                   	ret
80102c5a:	66 90                	xchg   %ax,%ax
80102c5c:	66 90                	xchg   %ax,%ax
80102c5e:	66 90                	xchg   %ax,%ax

80102c60 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c60:	8b 0d 48 27 11 80    	mov    0x80112748,%ecx
80102c66:	85 c9                	test   %ecx,%ecx
80102c68:	0f 8e 8a 00 00 00    	jle    80102cf8 <install_trans+0x98>
{
80102c6e:	55                   	push   %ebp
80102c6f:	89 e5                	mov    %esp,%ebp
80102c71:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102c72:	31 ff                	xor    %edi,%edi
{
80102c74:	56                   	push   %esi
80102c75:	53                   	push   %ebx
80102c76:	83 ec 0c             	sub    $0xc,%esp
80102c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102c80:	a1 34 27 11 80       	mov    0x80112734,%eax
80102c85:	83 ec 08             	sub    $0x8,%esp
80102c88:	01 f8                	add    %edi,%eax
80102c8a:	83 c0 01             	add    $0x1,%eax
80102c8d:	50                   	push   %eax
80102c8e:	ff 35 44 27 11 80    	push   0x80112744
80102c94:	e8 37 d4 ff ff       	call   801000d0 <bread>
80102c99:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c9b:	58                   	pop    %eax
80102c9c:	5a                   	pop    %edx
80102c9d:	ff 34 bd 4c 27 11 80 	push   -0x7feed8b4(,%edi,4)
80102ca4:	ff 35 44 27 11 80    	push   0x80112744
  for (tail = 0; tail < log.lh.n; tail++) {
80102caa:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102cad:	e8 1e d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102cb2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102cb5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102cb7:	8d 46 5c             	lea    0x5c(%esi),%eax
80102cba:	68 00 02 00 00       	push   $0x200
80102cbf:	50                   	push   %eax
80102cc0:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102cc3:	50                   	push   %eax
80102cc4:	e8 47 1c 00 00       	call   80104910 <memmove>
    bwrite(dbuf);  // write dst to disk
80102cc9:	89 1c 24             	mov    %ebx,(%esp)
80102ccc:	e8 df d4 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102cd1:	89 34 24             	mov    %esi,(%esp)
80102cd4:	e8 17 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102cd9:	89 1c 24             	mov    %ebx,(%esp)
80102cdc:	e8 0f d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ce1:	83 c4 10             	add    $0x10,%esp
80102ce4:	39 3d 48 27 11 80    	cmp    %edi,0x80112748
80102cea:	7f 94                	jg     80102c80 <install_trans+0x20>
  }
}
80102cec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102cef:	5b                   	pop    %ebx
80102cf0:	5e                   	pop    %esi
80102cf1:	5f                   	pop    %edi
80102cf2:	5d                   	pop    %ebp
80102cf3:	c3                   	ret
80102cf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cf8:	c3                   	ret
80102cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102d00 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102d00:	55                   	push   %ebp
80102d01:	89 e5                	mov    %esp,%ebp
80102d03:	53                   	push   %ebx
80102d04:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102d07:	ff 35 34 27 11 80    	push   0x80112734
80102d0d:	ff 35 44 27 11 80    	push   0x80112744
80102d13:	e8 b8 d3 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102d18:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102d1b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102d1d:	a1 48 27 11 80       	mov    0x80112748,%eax
80102d22:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102d25:	85 c0                	test   %eax,%eax
80102d27:	7e 19                	jle    80102d42 <write_head+0x42>
80102d29:	31 d2                	xor    %edx,%edx
80102d2b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102d30:	8b 0c 95 4c 27 11 80 	mov    -0x7feed8b4(,%edx,4),%ecx
80102d37:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d3b:	83 c2 01             	add    $0x1,%edx
80102d3e:	39 d0                	cmp    %edx,%eax
80102d40:	75 ee                	jne    80102d30 <write_head+0x30>
  }
  bwrite(buf);
80102d42:	83 ec 0c             	sub    $0xc,%esp
80102d45:	53                   	push   %ebx
80102d46:	e8 65 d4 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102d4b:	89 1c 24             	mov    %ebx,(%esp)
80102d4e:	e8 9d d4 ff ff       	call   801001f0 <brelse>
}
80102d53:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d56:	83 c4 10             	add    $0x10,%esp
80102d59:	c9                   	leave
80102d5a:	c3                   	ret
80102d5b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80102d60 <initlog>:
{
80102d60:	55                   	push   %ebp
80102d61:	89 e5                	mov    %esp,%ebp
80102d63:	53                   	push   %ebx
80102d64:	83 ec 3c             	sub    $0x3c,%esp
80102d67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102d6a:	68 32 7b 10 80       	push   $0x80107b32
80102d6f:	68 00 27 11 80       	push   $0x80112700
80102d74:	e8 17 18 00 00       	call   80104590 <initlock>
  readsb(dev, &sb);
80102d79:	58                   	pop    %eax
80102d7a:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80102d7d:	5a                   	pop    %edx
80102d7e:	50                   	push   %eax
80102d7f:	53                   	push   %ebx
80102d80:	e8 3b e8 ff ff       	call   801015c0 <readsb>
  log.start = sb.logstart;
80102d85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102d88:	59                   	pop    %ecx
  log.dev = dev;
80102d89:	89 1d 44 27 11 80    	mov    %ebx,0x80112744
  log.size = sb.nlog;
80102d8f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  log.start = sb.logstart;
80102d92:	a3 34 27 11 80       	mov    %eax,0x80112734
  log.size = sb.nlog;
80102d97:	89 15 38 27 11 80    	mov    %edx,0x80112738
  struct buf *buf = bread(log.dev, log.start);
80102d9d:	5a                   	pop    %edx
80102d9e:	50                   	push   %eax
80102d9f:	53                   	push   %ebx
80102da0:	e8 2b d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102da5:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102da8:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102dab:	89 1d 48 27 11 80    	mov    %ebx,0x80112748
  for (i = 0; i < log.lh.n; i++) {
80102db1:	85 db                	test   %ebx,%ebx
80102db3:	7e 1d                	jle    80102dd2 <initlog+0x72>
80102db5:	31 d2                	xor    %edx,%edx
80102db7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102dbe:	00 
80102dbf:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102dc0:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102dc4:	89 0c 95 4c 27 11 80 	mov    %ecx,-0x7feed8b4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102dcb:	83 c2 01             	add    $0x1,%edx
80102dce:	39 d3                	cmp    %edx,%ebx
80102dd0:	75 ee                	jne    80102dc0 <initlog+0x60>
  brelse(buf);
80102dd2:	83 ec 0c             	sub    $0xc,%esp
80102dd5:	50                   	push   %eax
80102dd6:	e8 15 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102ddb:	e8 80 fe ff ff       	call   80102c60 <install_trans>
  log.lh.n = 0;
80102de0:	c7 05 48 27 11 80 00 	movl   $0x0,0x80112748
80102de7:	00 00 00 
  write_head(); // clear the log
80102dea:	e8 11 ff ff ff       	call   80102d00 <write_head>
}
80102def:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102df2:	83 c4 10             	add    $0x10,%esp
80102df5:	c9                   	leave
80102df6:	c3                   	ret
80102df7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102dfe:	00 
80102dff:	90                   	nop

80102e00 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102e00:	55                   	push   %ebp
80102e01:	89 e5                	mov    %esp,%ebp
80102e03:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102e06:	68 00 27 11 80       	push   $0x80112700
80102e0b:	e8 70 19 00 00       	call   80104780 <acquire>
80102e10:	83 c4 10             	add    $0x10,%esp
80102e13:	eb 18                	jmp    80102e2d <begin_op+0x2d>
80102e15:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102e18:	83 ec 08             	sub    $0x8,%esp
80102e1b:	68 00 27 11 80       	push   $0x80112700
80102e20:	68 00 27 11 80       	push   $0x80112700
80102e25:	e8 56 13 00 00       	call   80104180 <sleep>
80102e2a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102e2d:	a1 40 27 11 80       	mov    0x80112740,%eax
80102e32:	85 c0                	test   %eax,%eax
80102e34:	75 e2                	jne    80102e18 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102e36:	a1 3c 27 11 80       	mov    0x8011273c,%eax
80102e3b:	8b 15 48 27 11 80    	mov    0x80112748,%edx
80102e41:	83 c0 01             	add    $0x1,%eax
80102e44:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102e47:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102e4a:	83 fa 1e             	cmp    $0x1e,%edx
80102e4d:	7f c9                	jg     80102e18 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102e4f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102e52:	a3 3c 27 11 80       	mov    %eax,0x8011273c
      release(&log.lock);
80102e57:	68 00 27 11 80       	push   $0x80112700
80102e5c:	e8 bf 18 00 00       	call   80104720 <release>
      break;
    }
  }
}
80102e61:	83 c4 10             	add    $0x10,%esp
80102e64:	c9                   	leave
80102e65:	c3                   	ret
80102e66:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102e6d:	00 
80102e6e:	66 90                	xchg   %ax,%ax

80102e70 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102e70:	55                   	push   %ebp
80102e71:	89 e5                	mov    %esp,%ebp
80102e73:	57                   	push   %edi
80102e74:	56                   	push   %esi
80102e75:	53                   	push   %ebx
80102e76:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102e79:	68 00 27 11 80       	push   $0x80112700
80102e7e:	e8 fd 18 00 00       	call   80104780 <acquire>
  log.outstanding -= 1;
80102e83:	a1 3c 27 11 80       	mov    0x8011273c,%eax
  if(log.committing)
80102e88:	8b 35 40 27 11 80    	mov    0x80112740,%esi
80102e8e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102e91:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102e94:	89 1d 3c 27 11 80    	mov    %ebx,0x8011273c
  if(log.committing)
80102e9a:	85 f6                	test   %esi,%esi
80102e9c:	0f 85 22 01 00 00    	jne    80102fc4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102ea2:	85 db                	test   %ebx,%ebx
80102ea4:	0f 85 f6 00 00 00    	jne    80102fa0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102eaa:	c7 05 40 27 11 80 01 	movl   $0x1,0x80112740
80102eb1:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102eb4:	83 ec 0c             	sub    $0xc,%esp
80102eb7:	68 00 27 11 80       	push   $0x80112700
80102ebc:	e8 5f 18 00 00       	call   80104720 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102ec1:	8b 0d 48 27 11 80    	mov    0x80112748,%ecx
80102ec7:	83 c4 10             	add    $0x10,%esp
80102eca:	85 c9                	test   %ecx,%ecx
80102ecc:	7f 42                	jg     80102f10 <end_op+0xa0>
    acquire(&log.lock);
80102ece:	83 ec 0c             	sub    $0xc,%esp
80102ed1:	68 00 27 11 80       	push   $0x80112700
80102ed6:	e8 a5 18 00 00       	call   80104780 <acquire>
    log.committing = 0;
80102edb:	c7 05 40 27 11 80 00 	movl   $0x0,0x80112740
80102ee2:	00 00 00 
    wakeup(&log);
80102ee5:	c7 04 24 00 27 11 80 	movl   $0x80112700,(%esp)
80102eec:	e8 4f 13 00 00       	call   80104240 <wakeup>
    release(&log.lock);
80102ef1:	c7 04 24 00 27 11 80 	movl   $0x80112700,(%esp)
80102ef8:	e8 23 18 00 00       	call   80104720 <release>
80102efd:	83 c4 10             	add    $0x10,%esp
}
80102f00:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f03:	5b                   	pop    %ebx
80102f04:	5e                   	pop    %esi
80102f05:	5f                   	pop    %edi
80102f06:	5d                   	pop    %ebp
80102f07:	c3                   	ret
80102f08:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102f0f:	00 
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102f10:	a1 34 27 11 80       	mov    0x80112734,%eax
80102f15:	83 ec 08             	sub    $0x8,%esp
80102f18:	01 d8                	add    %ebx,%eax
80102f1a:	83 c0 01             	add    $0x1,%eax
80102f1d:	50                   	push   %eax
80102f1e:	ff 35 44 27 11 80    	push   0x80112744
80102f24:	e8 a7 d1 ff ff       	call   801000d0 <bread>
80102f29:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f2b:	58                   	pop    %eax
80102f2c:	5a                   	pop    %edx
80102f2d:	ff 34 9d 4c 27 11 80 	push   -0x7feed8b4(,%ebx,4)
80102f34:	ff 35 44 27 11 80    	push   0x80112744
  for (tail = 0; tail < log.lh.n; tail++) {
80102f3a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f3d:	e8 8e d1 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102f42:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f45:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102f47:	8d 40 5c             	lea    0x5c(%eax),%eax
80102f4a:	68 00 02 00 00       	push   $0x200
80102f4f:	50                   	push   %eax
80102f50:	8d 46 5c             	lea    0x5c(%esi),%eax
80102f53:	50                   	push   %eax
80102f54:	e8 b7 19 00 00       	call   80104910 <memmove>
    bwrite(to);  // write the log
80102f59:	89 34 24             	mov    %esi,(%esp)
80102f5c:	e8 4f d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102f61:	89 3c 24             	mov    %edi,(%esp)
80102f64:	e8 87 d2 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102f69:	89 34 24             	mov    %esi,(%esp)
80102f6c:	e8 7f d2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102f71:	83 c4 10             	add    $0x10,%esp
80102f74:	3b 1d 48 27 11 80    	cmp    0x80112748,%ebx
80102f7a:	7c 94                	jl     80102f10 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102f7c:	e8 7f fd ff ff       	call   80102d00 <write_head>
    install_trans(); // Now install writes to home locations
80102f81:	e8 da fc ff ff       	call   80102c60 <install_trans>
    log.lh.n = 0;
80102f86:	c7 05 48 27 11 80 00 	movl   $0x0,0x80112748
80102f8d:	00 00 00 
    write_head();    // Erase the transaction from the log
80102f90:	e8 6b fd ff ff       	call   80102d00 <write_head>
80102f95:	e9 34 ff ff ff       	jmp    80102ece <end_op+0x5e>
80102f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102fa0:	83 ec 0c             	sub    $0xc,%esp
80102fa3:	68 00 27 11 80       	push   $0x80112700
80102fa8:	e8 93 12 00 00       	call   80104240 <wakeup>
  release(&log.lock);
80102fad:	c7 04 24 00 27 11 80 	movl   $0x80112700,(%esp)
80102fb4:	e8 67 17 00 00       	call   80104720 <release>
80102fb9:	83 c4 10             	add    $0x10,%esp
}
80102fbc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102fbf:	5b                   	pop    %ebx
80102fc0:	5e                   	pop    %esi
80102fc1:	5f                   	pop    %edi
80102fc2:	5d                   	pop    %ebp
80102fc3:	c3                   	ret
    panic("log.committing");
80102fc4:	83 ec 0c             	sub    $0xc,%esp
80102fc7:	68 36 7b 10 80       	push   $0x80107b36
80102fcc:	e8 af d3 ff ff       	call   80100380 <panic>
80102fd1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80102fd8:	00 
80102fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102fe0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102fe0:	55                   	push   %ebp
80102fe1:	89 e5                	mov    %esp,%ebp
80102fe3:	53                   	push   %ebx
80102fe4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102fe7:	8b 15 48 27 11 80    	mov    0x80112748,%edx
{
80102fed:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102ff0:	83 fa 1d             	cmp    $0x1d,%edx
80102ff3:	7f 7d                	jg     80103072 <log_write+0x92>
80102ff5:	a1 38 27 11 80       	mov    0x80112738,%eax
80102ffa:	83 e8 01             	sub    $0x1,%eax
80102ffd:	39 c2                	cmp    %eax,%edx
80102fff:	7d 71                	jge    80103072 <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103001:	a1 3c 27 11 80       	mov    0x8011273c,%eax
80103006:	85 c0                	test   %eax,%eax
80103008:	7e 75                	jle    8010307f <log_write+0x9f>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010300a:	83 ec 0c             	sub    $0xc,%esp
8010300d:	68 00 27 11 80       	push   $0x80112700
80103012:	e8 69 17 00 00       	call   80104780 <acquire>
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103017:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
8010301a:	83 c4 10             	add    $0x10,%esp
8010301d:	31 c0                	xor    %eax,%eax
8010301f:	8b 15 48 27 11 80    	mov    0x80112748,%edx
80103025:	85 d2                	test   %edx,%edx
80103027:	7f 0e                	jg     80103037 <log_write+0x57>
80103029:	eb 15                	jmp    80103040 <log_write+0x60>
8010302b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103030:	83 c0 01             	add    $0x1,%eax
80103033:	39 c2                	cmp    %eax,%edx
80103035:	74 29                	je     80103060 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103037:	39 0c 85 4c 27 11 80 	cmp    %ecx,-0x7feed8b4(,%eax,4)
8010303e:	75 f0                	jne    80103030 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80103040:	89 0c 85 4c 27 11 80 	mov    %ecx,-0x7feed8b4(,%eax,4)
  if (i == log.lh.n)
80103047:	39 c2                	cmp    %eax,%edx
80103049:	74 1c                	je     80103067 <log_write+0x87>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
8010304b:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010304e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80103051:	c7 45 08 00 27 11 80 	movl   $0x80112700,0x8(%ebp)
}
80103058:	c9                   	leave
  release(&log.lock);
80103059:	e9 c2 16 00 00       	jmp    80104720 <release>
8010305e:	66 90                	xchg   %ax,%ax
  log.lh.block[i] = b->blockno;
80103060:	89 0c 95 4c 27 11 80 	mov    %ecx,-0x7feed8b4(,%edx,4)
    log.lh.n++;
80103067:	83 c2 01             	add    $0x1,%edx
8010306a:	89 15 48 27 11 80    	mov    %edx,0x80112748
80103070:	eb d9                	jmp    8010304b <log_write+0x6b>
    panic("too big a transaction");
80103072:	83 ec 0c             	sub    $0xc,%esp
80103075:	68 45 7b 10 80       	push   $0x80107b45
8010307a:	e8 01 d3 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
8010307f:	83 ec 0c             	sub    $0xc,%esp
80103082:	68 5b 7b 10 80       	push   $0x80107b5b
80103087:	e8 f4 d2 ff ff       	call   80100380 <panic>
8010308c:	66 90                	xchg   %ax,%ax
8010308e:	66 90                	xchg   %ax,%ax

80103090 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103090:	55                   	push   %ebp
80103091:	89 e5                	mov    %esp,%ebp
80103093:	53                   	push   %ebx
80103094:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103097:	e8 f4 09 00 00       	call   80103a90 <cpuid>
8010309c:	89 c3                	mov    %eax,%ebx
8010309e:	e8 ed 09 00 00       	call   80103a90 <cpuid>
801030a3:	83 ec 04             	sub    $0x4,%esp
801030a6:	53                   	push   %ebx
801030a7:	50                   	push   %eax
801030a8:	68 76 7b 10 80       	push   $0x80107b76
801030ad:	e8 fe d5 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
801030b2:	e8 09 2a 00 00       	call   80105ac0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801030b7:	e8 74 09 00 00       	call   80103a30 <mycpu>
801030bc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801030be:	b8 01 00 00 00       	mov    $0x1,%eax
801030c3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801030ca:	e8 a1 0c 00 00       	call   80103d70 <scheduler>
801030cf:	90                   	nop

801030d0 <mpenter>:
{
801030d0:	55                   	push   %ebp
801030d1:	89 e5                	mov    %esp,%ebp
801030d3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801030d6:	e8 15 3c 00 00       	call   80106cf0 <switchkvm>
  seginit();
801030db:	e8 70 3a 00 00       	call   80106b50 <seginit>
  lapicinit();
801030e0:	e8 bb f7 ff ff       	call   801028a0 <lapicinit>
  mpmain();
801030e5:	e8 a6 ff ff ff       	call   80103090 <mpmain>
801030ea:	66 90                	xchg   %ax,%ax
801030ec:	66 90                	xchg   %ax,%ax
801030ee:	66 90                	xchg   %ax,%ax

801030f0 <main>:
{
801030f0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801030f4:	83 e4 f0             	and    $0xfffffff0,%esp
801030f7:	ff 71 fc             	push   -0x4(%ecx)
801030fa:	55                   	push   %ebp
801030fb:	89 e5                	mov    %esp,%ebp
801030fd:	53                   	push   %ebx
801030fe:	51                   	push   %ecx
  init_swap_table();
801030ff:	e8 6c 43 00 00       	call   80107470 <init_swap_table>
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103104:	83 ec 08             	sub    $0x8,%esp
80103107:	68 00 00 40 80       	push   $0x80400000
8010310c:	68 c0 8b 11 80       	push   $0x80118bc0
80103111:	e8 5a f5 ff ff       	call   80102670 <kinit1>
  kvmalloc();      // kernel page table
80103116:	e8 95 40 00 00       	call   801071b0 <kvmalloc>
  mpinit();        // detect other processors
8010311b:	e8 80 01 00 00       	call   801032a0 <mpinit>
  lapicinit();     // interrupt controller
80103120:	e8 7b f7 ff ff       	call   801028a0 <lapicinit>
  seginit();       // segment descriptors
80103125:	e8 26 3a 00 00       	call   80106b50 <seginit>
  picinit();       // disable pic
8010312a:	e8 81 03 00 00       	call   801034b0 <picinit>
  ioapicinit();    // another interrupt controller
8010312f:	e8 0c f3 ff ff       	call   80102440 <ioapicinit>
  consoleinit();   // console hardware
80103134:	e8 97 d9 ff ff       	call   80100ad0 <consoleinit>
  uartinit();      // serial port
80103139:	e8 82 2c 00 00       	call   80105dc0 <uartinit>
  pinit();         // process table
8010313e:	e8 cd 08 00 00       	call   80103a10 <pinit>
  tvinit();        // trap vectors
80103143:	e8 f8 28 00 00       	call   80105a40 <tvinit>
  binit();         // buffer cache
80103148:	e8 f3 ce ff ff       	call   80100040 <binit>
  fileinit();      // file table
8010314d:	e8 5e dd ff ff       	call   80100eb0 <fileinit>
  ideinit();       // disk 
80103152:	e8 c9 f0 ff ff       	call   80102220 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103157:	83 c4 0c             	add    $0xc,%esp
8010315a:	68 8a 00 00 00       	push   $0x8a
8010315f:	68 9c b4 10 80       	push   $0x8010b49c
80103164:	68 00 70 00 80       	push   $0x80007000
80103169:	e8 a2 17 00 00       	call   80104910 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010316e:	83 c4 10             	add    $0x10,%esp
80103171:	69 05 e4 27 11 80 b0 	imul   $0xb0,0x801127e4,%eax
80103178:	00 00 00 
8010317b:	05 00 28 11 80       	add    $0x80112800,%eax
80103180:	3d 00 28 11 80       	cmp    $0x80112800,%eax
80103185:	76 79                	jbe    80103200 <main+0x110>
80103187:	bb 00 28 11 80       	mov    $0x80112800,%ebx
8010318c:	eb 1b                	jmp    801031a9 <main+0xb9>
8010318e:	66 90                	xchg   %ax,%ax
80103190:	69 05 e4 27 11 80 b0 	imul   $0xb0,0x801127e4,%eax
80103197:	00 00 00 
8010319a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801031a0:	05 00 28 11 80       	add    $0x80112800,%eax
801031a5:	39 c3                	cmp    %eax,%ebx
801031a7:	73 57                	jae    80103200 <main+0x110>
    if(c == mycpu())  // We've started already.
801031a9:	e8 82 08 00 00       	call   80103a30 <mycpu>
801031ae:	39 c3                	cmp    %eax,%ebx
801031b0:	74 de                	je     80103190 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801031b2:	e8 29 f5 ff ff       	call   801026e0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801031b7:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
801031ba:	c7 05 f8 6f 00 80 d0 	movl   $0x801030d0,0x80006ff8
801031c1:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801031c4:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
801031cb:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801031ce:	05 00 10 00 00       	add    $0x1000,%eax
801031d3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801031d8:	0f b6 03             	movzbl (%ebx),%eax
801031db:	68 00 70 00 00       	push   $0x7000
801031e0:	50                   	push   %eax
801031e1:	e8 fa f7 ff ff       	call   801029e0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801031e6:	83 c4 10             	add    $0x10,%esp
801031e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031f0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801031f6:	85 c0                	test   %eax,%eax
801031f8:	74 f6                	je     801031f0 <main+0x100>
801031fa:	eb 94                	jmp    80103190 <main+0xa0>
801031fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103200:	83 ec 08             	sub    $0x8,%esp
80103203:	68 00 00 40 80       	push   $0x80400000
80103208:	68 00 00 40 80       	push   $0x80400000
8010320d:	e8 fe f3 ff ff       	call   80102610 <kinit2>
  userinit();      // first user process
80103212:	e8 c9 08 00 00       	call   80103ae0 <userinit>
  mpmain();        // finish this processor's setup
80103217:	e8 74 fe ff ff       	call   80103090 <mpmain>
8010321c:	66 90                	xchg   %ax,%ax
8010321e:	66 90                	xchg   %ax,%ax

80103220 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103220:	55                   	push   %ebp
80103221:	89 e5                	mov    %esp,%ebp
80103223:	57                   	push   %edi
80103224:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103225:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010322b:	53                   	push   %ebx
  e = addr+len;
8010322c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010322f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103232:	39 de                	cmp    %ebx,%esi
80103234:	72 10                	jb     80103246 <mpsearch1+0x26>
80103236:	eb 50                	jmp    80103288 <mpsearch1+0x68>
80103238:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010323f:	00 
80103240:	89 fe                	mov    %edi,%esi
80103242:	39 df                	cmp    %ebx,%edi
80103244:	73 42                	jae    80103288 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103246:	83 ec 04             	sub    $0x4,%esp
80103249:	8d 7e 10             	lea    0x10(%esi),%edi
8010324c:	6a 04                	push   $0x4
8010324e:	68 8a 7b 10 80       	push   $0x80107b8a
80103253:	56                   	push   %esi
80103254:	e8 67 16 00 00       	call   801048c0 <memcmp>
80103259:	83 c4 10             	add    $0x10,%esp
8010325c:	85 c0                	test   %eax,%eax
8010325e:	75 e0                	jne    80103240 <mpsearch1+0x20>
80103260:	89 f2                	mov    %esi,%edx
80103262:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103268:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
8010326b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010326e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103270:	39 fa                	cmp    %edi,%edx
80103272:	75 f4                	jne    80103268 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103274:	84 c0                	test   %al,%al
80103276:	75 c8                	jne    80103240 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103278:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010327b:	89 f0                	mov    %esi,%eax
8010327d:	5b                   	pop    %ebx
8010327e:	5e                   	pop    %esi
8010327f:	5f                   	pop    %edi
80103280:	5d                   	pop    %ebp
80103281:	c3                   	ret
80103282:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103288:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010328b:	31 f6                	xor    %esi,%esi
}
8010328d:	5b                   	pop    %ebx
8010328e:	89 f0                	mov    %esi,%eax
80103290:	5e                   	pop    %esi
80103291:	5f                   	pop    %edi
80103292:	5d                   	pop    %ebp
80103293:	c3                   	ret
80103294:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010329b:	00 
8010329c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801032a0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801032a0:	55                   	push   %ebp
801032a1:	89 e5                	mov    %esp,%ebp
801032a3:	57                   	push   %edi
801032a4:	56                   	push   %esi
801032a5:	53                   	push   %ebx
801032a6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801032a9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801032b0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801032b7:	c1 e0 08             	shl    $0x8,%eax
801032ba:	09 d0                	or     %edx,%eax
801032bc:	c1 e0 04             	shl    $0x4,%eax
801032bf:	75 1b                	jne    801032dc <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801032c1:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801032c8:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801032cf:	c1 e0 08             	shl    $0x8,%eax
801032d2:	09 d0                	or     %edx,%eax
801032d4:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801032d7:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801032dc:	ba 00 04 00 00       	mov    $0x400,%edx
801032e1:	e8 3a ff ff ff       	call   80103220 <mpsearch1>
801032e6:	89 c3                	mov    %eax,%ebx
801032e8:	85 c0                	test   %eax,%eax
801032ea:	0f 84 58 01 00 00    	je     80103448 <mpinit+0x1a8>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801032f0:	8b 73 04             	mov    0x4(%ebx),%esi
801032f3:	85 f6                	test   %esi,%esi
801032f5:	0f 84 3d 01 00 00    	je     80103438 <mpinit+0x198>
  if(memcmp(conf, "PCMP", 4) != 0)
801032fb:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801032fe:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80103304:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103307:	6a 04                	push   $0x4
80103309:	68 8f 7b 10 80       	push   $0x80107b8f
8010330e:	50                   	push   %eax
8010330f:	e8 ac 15 00 00       	call   801048c0 <memcmp>
80103314:	83 c4 10             	add    $0x10,%esp
80103317:	85 c0                	test   %eax,%eax
80103319:	0f 85 19 01 00 00    	jne    80103438 <mpinit+0x198>
  if(conf->version != 1 && conf->version != 4)
8010331f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103326:	3c 01                	cmp    $0x1,%al
80103328:	74 08                	je     80103332 <mpinit+0x92>
8010332a:	3c 04                	cmp    $0x4,%al
8010332c:	0f 85 06 01 00 00    	jne    80103438 <mpinit+0x198>
  if(sum((uchar*)conf, conf->length) != 0)
80103332:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80103339:	66 85 d2             	test   %dx,%dx
8010333c:	74 22                	je     80103360 <mpinit+0xc0>
8010333e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103341:	89 f0                	mov    %esi,%eax
  sum = 0;
80103343:	31 d2                	xor    %edx,%edx
80103345:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103348:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
8010334f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103352:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103354:	39 f8                	cmp    %edi,%eax
80103356:	75 f0                	jne    80103348 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103358:	84 d2                	test   %dl,%dl
8010335a:	0f 85 d8 00 00 00    	jne    80103438 <mpinit+0x198>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103360:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103366:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103369:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  lapic = (uint*)conf->lapicaddr;
8010336c:	a3 e0 26 11 80       	mov    %eax,0x801126e0
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103371:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103378:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
8010337e:	01 d7                	add    %edx,%edi
80103380:	89 fa                	mov    %edi,%edx
  ismp = 1;
80103382:	bf 01 00 00 00       	mov    $0x1,%edi
80103387:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010338e:	00 
8010338f:	90                   	nop
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103390:	39 d0                	cmp    %edx,%eax
80103392:	73 19                	jae    801033ad <mpinit+0x10d>
    switch(*p){
80103394:	0f b6 08             	movzbl (%eax),%ecx
80103397:	80 f9 02             	cmp    $0x2,%cl
8010339a:	0f 84 80 00 00 00    	je     80103420 <mpinit+0x180>
801033a0:	77 6e                	ja     80103410 <mpinit+0x170>
801033a2:	84 c9                	test   %cl,%cl
801033a4:	74 3a                	je     801033e0 <mpinit+0x140>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801033a6:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801033a9:	39 d0                	cmp    %edx,%eax
801033ab:	72 e7                	jb     80103394 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801033ad:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801033b0:	85 ff                	test   %edi,%edi
801033b2:	0f 84 dd 00 00 00    	je     80103495 <mpinit+0x1f5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801033b8:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
801033bc:	74 15                	je     801033d3 <mpinit+0x133>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801033be:	b8 70 00 00 00       	mov    $0x70,%eax
801033c3:	ba 22 00 00 00       	mov    $0x22,%edx
801033c8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801033c9:	ba 23 00 00 00       	mov    $0x23,%edx
801033ce:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801033cf:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801033d2:	ee                   	out    %al,(%dx)
  }
}
801033d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033d6:	5b                   	pop    %ebx
801033d7:	5e                   	pop    %esi
801033d8:	5f                   	pop    %edi
801033d9:	5d                   	pop    %ebp
801033da:	c3                   	ret
801033db:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(ncpu < NCPU) {
801033e0:	8b 0d e4 27 11 80    	mov    0x801127e4,%ecx
801033e6:	83 f9 07             	cmp    $0x7,%ecx
801033e9:	7f 19                	jg     80103404 <mpinit+0x164>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033eb:	69 f1 b0 00 00 00    	imul   $0xb0,%ecx,%esi
801033f1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
801033f5:	83 c1 01             	add    $0x1,%ecx
801033f8:	89 0d e4 27 11 80    	mov    %ecx,0x801127e4
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033fe:	88 9e 00 28 11 80    	mov    %bl,-0x7feed800(%esi)
      p += sizeof(struct mpproc);
80103404:	83 c0 14             	add    $0x14,%eax
      continue;
80103407:	eb 87                	jmp    80103390 <mpinit+0xf0>
80103409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(*p){
80103410:	83 e9 03             	sub    $0x3,%ecx
80103413:	80 f9 01             	cmp    $0x1,%cl
80103416:	76 8e                	jbe    801033a6 <mpinit+0x106>
80103418:	31 ff                	xor    %edi,%edi
8010341a:	e9 71 ff ff ff       	jmp    80103390 <mpinit+0xf0>
8010341f:	90                   	nop
      ioapicid = ioapic->apicno;
80103420:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103424:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103427:	88 0d e0 27 11 80    	mov    %cl,0x801127e0
      continue;
8010342d:	e9 5e ff ff ff       	jmp    80103390 <mpinit+0xf0>
80103432:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103438:	83 ec 0c             	sub    $0xc,%esp
8010343b:	68 94 7b 10 80       	push   $0x80107b94
80103440:	e8 3b cf ff ff       	call   80100380 <panic>
80103445:	8d 76 00             	lea    0x0(%esi),%esi
{
80103448:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
8010344d:	eb 0b                	jmp    8010345a <mpinit+0x1ba>
8010344f:	90                   	nop
  for(p = addr; p < e; p += sizeof(struct mp))
80103450:	89 f3                	mov    %esi,%ebx
80103452:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103458:	74 de                	je     80103438 <mpinit+0x198>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010345a:	83 ec 04             	sub    $0x4,%esp
8010345d:	8d 73 10             	lea    0x10(%ebx),%esi
80103460:	6a 04                	push   $0x4
80103462:	68 8a 7b 10 80       	push   $0x80107b8a
80103467:	53                   	push   %ebx
80103468:	e8 53 14 00 00       	call   801048c0 <memcmp>
8010346d:	83 c4 10             	add    $0x10,%esp
80103470:	85 c0                	test   %eax,%eax
80103472:	75 dc                	jne    80103450 <mpinit+0x1b0>
80103474:	89 da                	mov    %ebx,%edx
80103476:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010347d:	00 
8010347e:	66 90                	xchg   %ax,%ax
    sum += addr[i];
80103480:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103483:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103486:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103488:	39 d6                	cmp    %edx,%esi
8010348a:	75 f4                	jne    80103480 <mpinit+0x1e0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010348c:	84 c0                	test   %al,%al
8010348e:	75 c0                	jne    80103450 <mpinit+0x1b0>
80103490:	e9 5b fe ff ff       	jmp    801032f0 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103495:	83 ec 0c             	sub    $0xc,%esp
80103498:	68 6c 7f 10 80       	push   $0x80107f6c
8010349d:	e8 de ce ff ff       	call   80100380 <panic>
801034a2:	66 90                	xchg   %ax,%ax
801034a4:	66 90                	xchg   %ax,%ax
801034a6:	66 90                	xchg   %ax,%ax
801034a8:	66 90                	xchg   %ax,%ax
801034aa:	66 90                	xchg   %ax,%ax
801034ac:	66 90                	xchg   %ax,%ax
801034ae:	66 90                	xchg   %ax,%ax

801034b0 <picinit>:
801034b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801034b5:	ba 21 00 00 00       	mov    $0x21,%edx
801034ba:	ee                   	out    %al,(%dx)
801034bb:	ba a1 00 00 00       	mov    $0xa1,%edx
801034c0:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801034c1:	c3                   	ret
801034c2:	66 90                	xchg   %ax,%ax
801034c4:	66 90                	xchg   %ax,%ax
801034c6:	66 90                	xchg   %ax,%ax
801034c8:	66 90                	xchg   %ax,%ax
801034ca:	66 90                	xchg   %ax,%ax
801034cc:	66 90                	xchg   %ax,%ax
801034ce:	66 90                	xchg   %ax,%ax

801034d0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801034d0:	55                   	push   %ebp
801034d1:	89 e5                	mov    %esp,%ebp
801034d3:	57                   	push   %edi
801034d4:	56                   	push   %esi
801034d5:	53                   	push   %ebx
801034d6:	83 ec 0c             	sub    $0xc,%esp
801034d9:	8b 75 08             	mov    0x8(%ebp),%esi
801034dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801034df:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
801034e5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801034eb:	e8 e0 d9 ff ff       	call   80100ed0 <filealloc>
801034f0:	89 06                	mov    %eax,(%esi)
801034f2:	85 c0                	test   %eax,%eax
801034f4:	0f 84 a5 00 00 00    	je     8010359f <pipealloc+0xcf>
801034fa:	e8 d1 d9 ff ff       	call   80100ed0 <filealloc>
801034ff:	89 07                	mov    %eax,(%edi)
80103501:	85 c0                	test   %eax,%eax
80103503:	0f 84 84 00 00 00    	je     8010358d <pipealloc+0xbd>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103509:	e8 d2 f1 ff ff       	call   801026e0 <kalloc>
8010350e:	89 c3                	mov    %eax,%ebx
80103510:	85 c0                	test   %eax,%eax
80103512:	0f 84 a0 00 00 00    	je     801035b8 <pipealloc+0xe8>
    goto bad;
  p->readopen = 1;
80103518:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010351f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103522:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103525:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010352c:	00 00 00 
  p->nwrite = 0;
8010352f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103536:	00 00 00 
  p->nread = 0;
80103539:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103540:	00 00 00 
  initlock(&p->lock, "pipe");
80103543:	68 ac 7b 10 80       	push   $0x80107bac
80103548:	50                   	push   %eax
80103549:	e8 42 10 00 00       	call   80104590 <initlock>
  (*f0)->type = FD_PIPE;
8010354e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103550:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103553:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103559:	8b 06                	mov    (%esi),%eax
8010355b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010355f:	8b 06                	mov    (%esi),%eax
80103561:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103565:	8b 06                	mov    (%esi),%eax
80103567:	89 58 0c             	mov    %ebx,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010356a:	8b 07                	mov    (%edi),%eax
8010356c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103572:	8b 07                	mov    (%edi),%eax
80103574:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103578:	8b 07                	mov    (%edi),%eax
8010357a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010357e:	8b 07                	mov    (%edi),%eax
80103580:	89 58 0c             	mov    %ebx,0xc(%eax)
  return 0;
80103583:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103585:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103588:	5b                   	pop    %ebx
80103589:	5e                   	pop    %esi
8010358a:	5f                   	pop    %edi
8010358b:	5d                   	pop    %ebp
8010358c:	c3                   	ret
  if(*f0)
8010358d:	8b 06                	mov    (%esi),%eax
8010358f:	85 c0                	test   %eax,%eax
80103591:	74 1e                	je     801035b1 <pipealloc+0xe1>
    fileclose(*f0);
80103593:	83 ec 0c             	sub    $0xc,%esp
80103596:	50                   	push   %eax
80103597:	e8 f4 d9 ff ff       	call   80100f90 <fileclose>
8010359c:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010359f:	8b 07                	mov    (%edi),%eax
801035a1:	85 c0                	test   %eax,%eax
801035a3:	74 0c                	je     801035b1 <pipealloc+0xe1>
    fileclose(*f1);
801035a5:	83 ec 0c             	sub    $0xc,%esp
801035a8:	50                   	push   %eax
801035a9:	e8 e2 d9 ff ff       	call   80100f90 <fileclose>
801035ae:	83 c4 10             	add    $0x10,%esp
  return -1;
801035b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801035b6:	eb cd                	jmp    80103585 <pipealloc+0xb5>
  if(*f0)
801035b8:	8b 06                	mov    (%esi),%eax
801035ba:	85 c0                	test   %eax,%eax
801035bc:	75 d5                	jne    80103593 <pipealloc+0xc3>
801035be:	eb df                	jmp    8010359f <pipealloc+0xcf>

801035c0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801035c0:	55                   	push   %ebp
801035c1:	89 e5                	mov    %esp,%ebp
801035c3:	56                   	push   %esi
801035c4:	53                   	push   %ebx
801035c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801035c8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801035cb:	83 ec 0c             	sub    $0xc,%esp
801035ce:	53                   	push   %ebx
801035cf:	e8 ac 11 00 00       	call   80104780 <acquire>
  if(writable){
801035d4:	83 c4 10             	add    $0x10,%esp
801035d7:	85 f6                	test   %esi,%esi
801035d9:	74 65                	je     80103640 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
801035db:	83 ec 0c             	sub    $0xc,%esp
801035de:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
801035e4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801035eb:	00 00 00 
    wakeup(&p->nread);
801035ee:	50                   	push   %eax
801035ef:	e8 4c 0c 00 00       	call   80104240 <wakeup>
801035f4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801035f7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801035fd:	85 d2                	test   %edx,%edx
801035ff:	75 0a                	jne    8010360b <pipeclose+0x4b>
80103601:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103607:	85 c0                	test   %eax,%eax
80103609:	74 15                	je     80103620 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010360b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010360e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103611:	5b                   	pop    %ebx
80103612:	5e                   	pop    %esi
80103613:	5d                   	pop    %ebp
    release(&p->lock);
80103614:	e9 07 11 00 00       	jmp    80104720 <release>
80103619:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103620:	83 ec 0c             	sub    $0xc,%esp
80103623:	53                   	push   %ebx
80103624:	e8 f7 10 00 00       	call   80104720 <release>
    kfree((char*)p);
80103629:	83 c4 10             	add    $0x10,%esp
8010362c:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010362f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103632:	5b                   	pop    %ebx
80103633:	5e                   	pop    %esi
80103634:	5d                   	pop    %ebp
    kfree((char*)p);
80103635:	e9 e6 ee ff ff       	jmp    80102520 <kfree>
8010363a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103640:	83 ec 0c             	sub    $0xc,%esp
80103643:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103649:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103650:	00 00 00 
    wakeup(&p->nwrite);
80103653:	50                   	push   %eax
80103654:	e8 e7 0b 00 00       	call   80104240 <wakeup>
80103659:	83 c4 10             	add    $0x10,%esp
8010365c:	eb 99                	jmp    801035f7 <pipeclose+0x37>
8010365e:	66 90                	xchg   %ax,%ax

80103660 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103660:	55                   	push   %ebp
80103661:	89 e5                	mov    %esp,%ebp
80103663:	57                   	push   %edi
80103664:	56                   	push   %esi
80103665:	53                   	push   %ebx
80103666:	83 ec 28             	sub    $0x28,%esp
80103669:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010366c:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
8010366f:	53                   	push   %ebx
80103670:	e8 0b 11 00 00       	call   80104780 <acquire>
  for(i = 0; i < n; i++){
80103675:	83 c4 10             	add    $0x10,%esp
80103678:	85 ff                	test   %edi,%edi
8010367a:	0f 8e ce 00 00 00    	jle    8010374e <pipewrite+0xee>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103680:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103686:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103689:	89 7d 10             	mov    %edi,0x10(%ebp)
8010368c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010368f:	8d 34 39             	lea    (%ecx,%edi,1),%esi
80103692:	89 75 e0             	mov    %esi,-0x20(%ebp)
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103695:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010369b:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801036a1:	8d bb 38 02 00 00    	lea    0x238(%ebx),%edi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036a7:	8d 90 00 02 00 00    	lea    0x200(%eax),%edx
801036ad:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
801036b0:	0f 85 b6 00 00 00    	jne    8010376c <pipewrite+0x10c>
801036b6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801036b9:	eb 3b                	jmp    801036f6 <pipewrite+0x96>
801036bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
801036c0:	e8 eb 03 00 00       	call   80103ab0 <myproc>
801036c5:	8b 48 24             	mov    0x24(%eax),%ecx
801036c8:	85 c9                	test   %ecx,%ecx
801036ca:	75 34                	jne    80103700 <pipewrite+0xa0>
      wakeup(&p->nread);
801036cc:	83 ec 0c             	sub    $0xc,%esp
801036cf:	56                   	push   %esi
801036d0:	e8 6b 0b 00 00       	call   80104240 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801036d5:	58                   	pop    %eax
801036d6:	5a                   	pop    %edx
801036d7:	53                   	push   %ebx
801036d8:	57                   	push   %edi
801036d9:	e8 a2 0a 00 00       	call   80104180 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036de:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801036e4:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801036ea:	83 c4 10             	add    $0x10,%esp
801036ed:	05 00 02 00 00       	add    $0x200,%eax
801036f2:	39 c2                	cmp    %eax,%edx
801036f4:	75 2a                	jne    80103720 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
801036f6:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801036fc:	85 c0                	test   %eax,%eax
801036fe:	75 c0                	jne    801036c0 <pipewrite+0x60>
        release(&p->lock);
80103700:	83 ec 0c             	sub    $0xc,%esp
80103703:	53                   	push   %ebx
80103704:	e8 17 10 00 00       	call   80104720 <release>
        return -1;
80103709:	83 c4 10             	add    $0x10,%esp
8010370c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103711:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103714:	5b                   	pop    %ebx
80103715:	5e                   	pop    %esi
80103716:	5f                   	pop    %edi
80103717:	5d                   	pop    %ebp
80103718:	c3                   	ret
80103719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103720:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103723:	8d 42 01             	lea    0x1(%edx),%eax
80103726:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
  for(i = 0; i < n; i++){
8010372c:	83 c1 01             	add    $0x1,%ecx
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010372f:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103735:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103738:	0f b6 41 ff          	movzbl -0x1(%ecx),%eax
8010373c:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103740:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103743:	39 c1                	cmp    %eax,%ecx
80103745:	0f 85 50 ff ff ff    	jne    8010369b <pipewrite+0x3b>
8010374b:	8b 7d 10             	mov    0x10(%ebp),%edi
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
8010374e:	83 ec 0c             	sub    $0xc,%esp
80103751:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103757:	50                   	push   %eax
80103758:	e8 e3 0a 00 00       	call   80104240 <wakeup>
  release(&p->lock);
8010375d:	89 1c 24             	mov    %ebx,(%esp)
80103760:	e8 bb 0f 00 00       	call   80104720 <release>
  return n;
80103765:	83 c4 10             	add    $0x10,%esp
80103768:	89 f8                	mov    %edi,%eax
8010376a:	eb a5                	jmp    80103711 <pipewrite+0xb1>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010376c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010376f:	eb b2                	jmp    80103723 <pipewrite+0xc3>
80103771:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103778:	00 
80103779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103780 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103780:	55                   	push   %ebp
80103781:	89 e5                	mov    %esp,%ebp
80103783:	57                   	push   %edi
80103784:	56                   	push   %esi
80103785:	53                   	push   %ebx
80103786:	83 ec 18             	sub    $0x18,%esp
80103789:	8b 75 08             	mov    0x8(%ebp),%esi
8010378c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010378f:	56                   	push   %esi
80103790:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103796:	e8 e5 0f 00 00       	call   80104780 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010379b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801037a1:	83 c4 10             	add    $0x10,%esp
801037a4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801037aa:	74 2f                	je     801037db <piperead+0x5b>
801037ac:	eb 37                	jmp    801037e5 <piperead+0x65>
801037ae:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
801037b0:	e8 fb 02 00 00       	call   80103ab0 <myproc>
801037b5:	8b 40 24             	mov    0x24(%eax),%eax
801037b8:	85 c0                	test   %eax,%eax
801037ba:	0f 85 80 00 00 00    	jne    80103840 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801037c0:	83 ec 08             	sub    $0x8,%esp
801037c3:	56                   	push   %esi
801037c4:	53                   	push   %ebx
801037c5:	e8 b6 09 00 00       	call   80104180 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801037ca:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801037d0:	83 c4 10             	add    $0x10,%esp
801037d3:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801037d9:	75 0a                	jne    801037e5 <piperead+0x65>
801037db:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
801037e1:	85 d2                	test   %edx,%edx
801037e3:	75 cb                	jne    801037b0 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801037e5:	8b 4d 10             	mov    0x10(%ebp),%ecx
801037e8:	31 db                	xor    %ebx,%ebx
801037ea:	85 c9                	test   %ecx,%ecx
801037ec:	7f 26                	jg     80103814 <piperead+0x94>
801037ee:	eb 2c                	jmp    8010381c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801037f0:	8d 48 01             	lea    0x1(%eax),%ecx
801037f3:	25 ff 01 00 00       	and    $0x1ff,%eax
801037f8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
801037fe:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103803:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103806:	83 c3 01             	add    $0x1,%ebx
80103809:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010380c:	74 0e                	je     8010381c <piperead+0x9c>
8010380e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
    if(p->nread == p->nwrite)
80103814:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010381a:	75 d4                	jne    801037f0 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010381c:	83 ec 0c             	sub    $0xc,%esp
8010381f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103825:	50                   	push   %eax
80103826:	e8 15 0a 00 00       	call   80104240 <wakeup>
  release(&p->lock);
8010382b:	89 34 24             	mov    %esi,(%esp)
8010382e:	e8 ed 0e 00 00       	call   80104720 <release>
  return i;
80103833:	83 c4 10             	add    $0x10,%esp
}
80103836:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103839:	89 d8                	mov    %ebx,%eax
8010383b:	5b                   	pop    %ebx
8010383c:	5e                   	pop    %esi
8010383d:	5f                   	pop    %edi
8010383e:	5d                   	pop    %ebp
8010383f:	c3                   	ret
      release(&p->lock);
80103840:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103843:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103848:	56                   	push   %esi
80103849:	e8 d2 0e 00 00       	call   80104720 <release>
      return -1;
8010384e:	83 c4 10             	add    $0x10,%esp
}
80103851:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103854:	89 d8                	mov    %ebx,%eax
80103856:	5b                   	pop    %ebx
80103857:	5e                   	pop    %esi
80103858:	5f                   	pop    %edi
80103859:	5d                   	pop    %ebp
8010385a:	c3                   	ret
8010385b:	66 90                	xchg   %ax,%ax
8010385d:	66 90                	xchg   %ax,%ax
8010385f:	90                   	nop

80103860 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103860:	55                   	push   %ebp
80103861:	89 e5                	mov    %esp,%ebp
80103863:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103864:	bb b4 2d 11 80       	mov    $0x80112db4,%ebx
{
80103869:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010386c:	68 80 2d 11 80       	push   $0x80112d80
80103871:	e8 0a 0f 00 00       	call   80104780 <acquire>
80103876:	83 c4 10             	add    $0x10,%esp
80103879:	eb 14                	jmp    8010388f <allocproc+0x2f>
8010387b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103880:	83 eb 80             	sub    $0xffffff80,%ebx
80103883:	81 fb b4 4d 11 80    	cmp    $0x80114db4,%ebx
80103889:	0f 84 81 00 00 00    	je     80103910 <allocproc+0xb0>
    if(p->state == UNUSED)
8010388f:	8b 43 0c             	mov    0xc(%ebx),%eax
80103892:	85 c0                	test   %eax,%eax
80103894:	75 ea                	jne    80103880 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103896:	a1 04 b0 10 80       	mov    0x8010b004,%eax
  p->rss=0;

  release(&ptable.lock);
8010389b:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010389e:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->rss=0;
801038a5:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
  p->pid = nextpid++;
801038ac:	89 43 10             	mov    %eax,0x10(%ebx)
801038af:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
801038b2:	68 80 2d 11 80       	push   $0x80112d80
  p->pid = nextpid++;
801038b7:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
801038bd:	e8 5e 0e 00 00       	call   80104720 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801038c2:	e8 19 ee ff ff       	call   801026e0 <kalloc>
801038c7:	83 c4 10             	add    $0x10,%esp
801038ca:	89 43 08             	mov    %eax,0x8(%ebx)
801038cd:	85 c0                	test   %eax,%eax
801038cf:	74 58                	je     80103929 <allocproc+0xc9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801038d1:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801038d7:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801038da:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801038df:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801038e2:	c7 40 14 32 5a 10 80 	movl   $0x80105a32,0x14(%eax)
  p->context = (struct context*)sp;
801038e9:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801038ec:	6a 14                	push   $0x14
801038ee:	6a 00                	push   $0x0
801038f0:	50                   	push   %eax
801038f1:	e8 8a 0f 00 00       	call   80104880 <memset>
  p->context->eip = (uint)forkret;
801038f6:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
801038f9:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801038fc:	c7 40 10 40 39 10 80 	movl   $0x80103940,0x10(%eax)
}
80103903:	89 d8                	mov    %ebx,%eax
80103905:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103908:	c9                   	leave
80103909:	c3                   	ret
8010390a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103910:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103913:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103915:	68 80 2d 11 80       	push   $0x80112d80
8010391a:	e8 01 0e 00 00       	call   80104720 <release>
  return 0;
8010391f:	83 c4 10             	add    $0x10,%esp
}
80103922:	89 d8                	mov    %ebx,%eax
80103924:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103927:	c9                   	leave
80103928:	c3                   	ret
    p->state = UNUSED;
80103929:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  return 0;
80103930:	31 db                	xor    %ebx,%ebx
80103932:	eb ee                	jmp    80103922 <allocproc+0xc2>
80103934:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010393b:	00 
8010393c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103940 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103940:	55                   	push   %ebp
80103941:	89 e5                	mov    %esp,%ebp
80103943:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103946:	68 80 2d 11 80       	push   $0x80112d80
8010394b:	e8 d0 0d 00 00       	call   80104720 <release>

  if (first) {
80103950:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103955:	83 c4 10             	add    $0x10,%esp
80103958:	85 c0                	test   %eax,%eax
8010395a:	75 04                	jne    80103960 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010395c:	c9                   	leave
8010395d:	c3                   	ret
8010395e:	66 90                	xchg   %ax,%ax
    first = 0;
80103960:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103967:	00 00 00 
    iinit(ROOTDEV);
8010396a:	83 ec 0c             	sub    $0xc,%esp
8010396d:	6a 01                	push   $0x1
8010396f:	e8 8c dc ff ff       	call   80101600 <iinit>
    initlog(ROOTDEV);
80103974:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010397b:	e8 e0 f3 ff ff       	call   80102d60 <initlog>
}
80103980:	83 c4 10             	add    $0x10,%esp
80103983:	c9                   	leave
80103984:	c3                   	ret
80103985:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010398c:	00 
8010398d:	8d 76 00             	lea    0x0(%esi),%esi

80103990 <print_mem_layout>:
void print_mem_layout() {
80103990:	55                   	push   %ebp
80103991:	89 e5                	mov    %esp,%ebp
80103993:	53                   	push   %ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103994:	bb b4 2d 11 80       	mov    $0x80112db4,%ebx
void print_mem_layout() {
80103999:	83 ec 10             	sub    $0x10,%esp
  cprintf("PID NUM_PAGES\n");
8010399c:	68 b1 7b 10 80       	push   $0x80107bb1
801039a1:	e8 0a cd ff ff       	call   801006b0 <cprintf>
  acquire(&ptable.lock);
801039a6:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
801039ad:	e8 ce 0d 00 00       	call   80104780 <acquire>
801039b2:	83 c4 10             	add    $0x10,%esp
801039b5:	8d 76 00             	lea    0x0(%esi),%esi
    if(p->state == RUNNING || p->state == RUNNABLE || p->state == SLEEPING) {
801039b8:	8b 43 0c             	mov    0xc(%ebx),%eax
801039bb:	83 e8 02             	sub    $0x2,%eax
801039be:	83 f8 02             	cmp    $0x2,%eax
801039c1:	77 24                	ja     801039e7 <print_mem_layout+0x57>
      if(p->pid >= 1) {
801039c3:	8b 43 10             	mov    0x10(%ebx),%eax
801039c6:	85 c0                	test   %eax,%eax
801039c8:	7e 1d                	jle    801039e7 <print_mem_layout+0x57>
        int num_pages = count_mem_pages(p);
801039ca:	83 ec 0c             	sub    $0xc,%esp
801039cd:	53                   	push   %ebx
801039ce:	e8 0d 32 00 00       	call   80106be0 <count_mem_pages>
        cprintf("%d %d\n", p->pid, num_pages);
801039d3:	83 c4 0c             	add    $0xc,%esp
801039d6:	50                   	push   %eax
801039d7:	ff 73 10             	push   0x10(%ebx)
801039da:	68 c0 7b 10 80       	push   $0x80107bc0
801039df:	e8 cc cc ff ff       	call   801006b0 <cprintf>
801039e4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801039e7:	83 eb 80             	sub    $0xffffff80,%ebx
801039ea:	81 fb b4 4d 11 80    	cmp    $0x80114db4,%ebx
801039f0:	75 c6                	jne    801039b8 <print_mem_layout+0x28>
  release(&ptable.lock);
801039f2:	83 ec 0c             	sub    $0xc,%esp
801039f5:	68 80 2d 11 80       	push   $0x80112d80
801039fa:	e8 21 0d 00 00       	call   80104720 <release>
}
801039ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a02:	83 c4 10             	add    $0x10,%esp
80103a05:	c9                   	leave
80103a06:	c3                   	ret
80103a07:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103a0e:	00 
80103a0f:	90                   	nop

80103a10 <pinit>:
{
80103a10:	55                   	push   %ebp
80103a11:	89 e5                	mov    %esp,%ebp
80103a13:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103a16:	68 c7 7b 10 80       	push   $0x80107bc7
80103a1b:	68 80 2d 11 80       	push   $0x80112d80
80103a20:	e8 6b 0b 00 00       	call   80104590 <initlock>
}
80103a25:	83 c4 10             	add    $0x10,%esp
80103a28:	c9                   	leave
80103a29:	c3                   	ret
80103a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a30 <mycpu>:
{
80103a30:	55                   	push   %ebp
80103a31:	89 e5                	mov    %esp,%ebp
80103a33:	56                   	push   %esi
80103a34:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103a35:	9c                   	pushf
80103a36:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103a37:	f6 c4 02             	test   $0x2,%ah
80103a3a:	75 46                	jne    80103a82 <mycpu+0x52>
  apicid = lapicid();
80103a3c:	e8 4f ef ff ff       	call   80102990 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103a41:	8b 35 e4 27 11 80    	mov    0x801127e4,%esi
80103a47:	85 f6                	test   %esi,%esi
80103a49:	7e 2a                	jle    80103a75 <mycpu+0x45>
80103a4b:	31 d2                	xor    %edx,%edx
80103a4d:	eb 08                	jmp    80103a57 <mycpu+0x27>
80103a4f:	90                   	nop
80103a50:	83 c2 01             	add    $0x1,%edx
80103a53:	39 f2                	cmp    %esi,%edx
80103a55:	74 1e                	je     80103a75 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103a57:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103a5d:	0f b6 99 00 28 11 80 	movzbl -0x7feed800(%ecx),%ebx
80103a64:	39 c3                	cmp    %eax,%ebx
80103a66:	75 e8                	jne    80103a50 <mycpu+0x20>
}
80103a68:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103a6b:	8d 81 00 28 11 80    	lea    -0x7feed800(%ecx),%eax
}
80103a71:	5b                   	pop    %ebx
80103a72:	5e                   	pop    %esi
80103a73:	5d                   	pop    %ebp
80103a74:	c3                   	ret
  panic("unknown apicid\n");
80103a75:	83 ec 0c             	sub    $0xc,%esp
80103a78:	68 ce 7b 10 80       	push   $0x80107bce
80103a7d:	e8 fe c8 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103a82:	83 ec 0c             	sub    $0xc,%esp
80103a85:	68 8c 7f 10 80       	push   $0x80107f8c
80103a8a:	e8 f1 c8 ff ff       	call   80100380 <panic>
80103a8f:	90                   	nop

80103a90 <cpuid>:
cpuid() {
80103a90:	55                   	push   %ebp
80103a91:	89 e5                	mov    %esp,%ebp
80103a93:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103a96:	e8 95 ff ff ff       	call   80103a30 <mycpu>
}
80103a9b:	c9                   	leave
  return mycpu()-cpus;
80103a9c:	2d 00 28 11 80       	sub    $0x80112800,%eax
80103aa1:	c1 f8 04             	sar    $0x4,%eax
80103aa4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103aaa:	c3                   	ret
80103aab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103ab0 <myproc>:
myproc(void) {
80103ab0:	55                   	push   %ebp
80103ab1:	89 e5                	mov    %esp,%ebp
80103ab3:	53                   	push   %ebx
80103ab4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103ab7:	e8 74 0b 00 00       	call   80104630 <pushcli>
  c = mycpu();
80103abc:	e8 6f ff ff ff       	call   80103a30 <mycpu>
  p = c->proc;
80103ac1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ac7:	e8 b4 0b 00 00       	call   80104680 <popcli>
}
80103acc:	89 d8                	mov    %ebx,%eax
80103ace:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ad1:	c9                   	leave
80103ad2:	c3                   	ret
80103ad3:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103ada:	00 
80103adb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103ae0 <userinit>:
{
80103ae0:	55                   	push   %ebp
80103ae1:	89 e5                	mov    %esp,%ebp
80103ae3:	53                   	push   %ebx
80103ae4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103ae7:	e8 74 fd ff ff       	call   80103860 <allocproc>
80103aec:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103aee:	a3 b4 4d 11 80       	mov    %eax,0x80114db4
  if((p->pgdir = setupkvm()) == 0)
80103af3:	e8 38 36 00 00       	call   80107130 <setupkvm>
80103af8:	89 43 04             	mov    %eax,0x4(%ebx)
80103afb:	85 c0                	test   %eax,%eax
80103afd:	0f 84 bd 00 00 00    	je     80103bc0 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103b03:	83 ec 04             	sub    $0x4,%esp
80103b06:	68 2c 00 00 00       	push   $0x2c
80103b0b:	68 70 b4 10 80       	push   $0x8010b470
80103b10:	50                   	push   %eax
80103b11:	e8 fa 32 00 00       	call   80106e10 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103b16:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103b19:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103b1f:	6a 4c                	push   $0x4c
80103b21:	6a 00                	push   $0x0
80103b23:	ff 73 18             	push   0x18(%ebx)
80103b26:	e8 55 0d 00 00       	call   80104880 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b2b:	8b 43 18             	mov    0x18(%ebx),%eax
80103b2e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b33:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b36:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103b3b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103b3f:	8b 43 18             	mov    0x18(%ebx),%eax
80103b42:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103b46:	8b 43 18             	mov    0x18(%ebx),%eax
80103b49:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b4d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103b51:	8b 43 18             	mov    0x18(%ebx),%eax
80103b54:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103b58:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103b5c:	8b 43 18             	mov    0x18(%ebx),%eax
80103b5f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103b66:	8b 43 18             	mov    0x18(%ebx),%eax
80103b69:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103b70:	8b 43 18             	mov    0x18(%ebx),%eax
80103b73:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103b7a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103b7d:	6a 10                	push   $0x10
80103b7f:	68 f7 7b 10 80       	push   $0x80107bf7
80103b84:	50                   	push   %eax
80103b85:	e8 a6 0e 00 00       	call   80104a30 <safestrcpy>
  p->cwd = namei("/");
80103b8a:	c7 04 24 00 7c 10 80 	movl   $0x80107c00,(%esp)
80103b91:	e8 6a e5 ff ff       	call   80102100 <namei>
80103b96:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103b99:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
80103ba0:	e8 db 0b 00 00       	call   80104780 <acquire>
  p->state = RUNNABLE;
80103ba5:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103bac:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
80103bb3:	e8 68 0b 00 00       	call   80104720 <release>
}
80103bb8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103bbb:	83 c4 10             	add    $0x10,%esp
80103bbe:	c9                   	leave
80103bbf:	c3                   	ret
    panic("userinit: out of memory?");
80103bc0:	83 ec 0c             	sub    $0xc,%esp
80103bc3:	68 de 7b 10 80       	push   $0x80107bde
80103bc8:	e8 b3 c7 ff ff       	call   80100380 <panic>
80103bcd:	8d 76 00             	lea    0x0(%esi),%esi

80103bd0 <growproc>:
{
80103bd0:	55                   	push   %ebp
80103bd1:	89 e5                	mov    %esp,%ebp
80103bd3:	56                   	push   %esi
80103bd4:	53                   	push   %ebx
80103bd5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103bd8:	e8 53 0a 00 00       	call   80104630 <pushcli>
  c = mycpu();
80103bdd:	e8 4e fe ff ff       	call   80103a30 <mycpu>
  p = c->proc;
80103be2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103be8:	e8 93 0a 00 00       	call   80104680 <popcli>
  sz = curproc->sz;
80103bed:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103bef:	85 f6                	test   %esi,%esi
80103bf1:	7f 1d                	jg     80103c10 <growproc+0x40>
  } else if(n < 0){
80103bf3:	75 3b                	jne    80103c30 <growproc+0x60>
  switchuvm(curproc);
80103bf5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103bf8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103bfa:	53                   	push   %ebx
80103bfb:	e8 00 31 00 00       	call   80106d00 <switchuvm>
  return 0;
80103c00:	83 c4 10             	add    $0x10,%esp
80103c03:	31 c0                	xor    %eax,%eax
}
80103c05:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103c08:	5b                   	pop    %ebx
80103c09:	5e                   	pop    %esi
80103c0a:	5d                   	pop    %ebp
80103c0b:	c3                   	ret
80103c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c10:	83 ec 04             	sub    $0x4,%esp
80103c13:	01 c6                	add    %eax,%esi
80103c15:	56                   	push   %esi
80103c16:	50                   	push   %eax
80103c17:	ff 73 04             	push   0x4(%ebx)
80103c1a:	e8 41 33 00 00       	call   80106f60 <allocuvm>
80103c1f:	83 c4 10             	add    $0x10,%esp
80103c22:	85 c0                	test   %eax,%eax
80103c24:	75 cf                	jne    80103bf5 <growproc+0x25>
      return -1;
80103c26:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103c2b:	eb d8                	jmp    80103c05 <growproc+0x35>
80103c2d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c30:	83 ec 04             	sub    $0x4,%esp
80103c33:	01 c6                	add    %eax,%esi
80103c35:	56                   	push   %esi
80103c36:	50                   	push   %eax
80103c37:	ff 73 04             	push   0x4(%ebx)
80103c3a:	e8 41 34 00 00       	call   80107080 <deallocuvm>
80103c3f:	83 c4 10             	add    $0x10,%esp
80103c42:	85 c0                	test   %eax,%eax
80103c44:	75 af                	jne    80103bf5 <growproc+0x25>
80103c46:	eb de                	jmp    80103c26 <growproc+0x56>
80103c48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103c4f:	00 

80103c50 <fork>:
{
80103c50:	55                   	push   %ebp
80103c51:	89 e5                	mov    %esp,%ebp
80103c53:	57                   	push   %edi
80103c54:	56                   	push   %esi
80103c55:	53                   	push   %ebx
80103c56:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103c59:	e8 d2 09 00 00       	call   80104630 <pushcli>
  c = mycpu();
80103c5e:	e8 cd fd ff ff       	call   80103a30 <mycpu>
  p = c->proc;
80103c63:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c69:	e8 12 0a 00 00       	call   80104680 <popcli>
  if((np = allocproc()) == 0){
80103c6e:	e8 ed fb ff ff       	call   80103860 <allocproc>
80103c73:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103c76:	85 c0                	test   %eax,%eax
80103c78:	0f 84 e6 00 00 00    	je     80103d64 <fork+0x114>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103c7e:	83 ec 08             	sub    $0x8,%esp
80103c81:	ff 33                	push   (%ebx)
80103c83:	89 c7                	mov    %eax,%edi
80103c85:	ff 73 04             	push   0x4(%ebx)
80103c88:	e8 93 35 00 00       	call   80107220 <copyuvm>
80103c8d:	83 c4 10             	add    $0x10,%esp
80103c90:	89 47 04             	mov    %eax,0x4(%edi)
80103c93:	85 c0                	test   %eax,%eax
80103c95:	0f 84 aa 00 00 00    	je     80103d45 <fork+0xf5>
  np->sz = curproc->sz;
80103c9b:	8b 03                	mov    (%ebx),%eax
80103c9d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103ca0:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80103ca2:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80103ca5:	89 59 14             	mov    %ebx,0x14(%ecx)
  np->rss=curproc->rss;
80103ca8:	8b 43 7c             	mov    0x7c(%ebx),%eax
80103cab:	89 41 7c             	mov    %eax,0x7c(%ecx)
  *np->tf = *curproc->tf;
80103cae:	89 c8                	mov    %ecx,%eax
80103cb0:	8b 73 18             	mov    0x18(%ebx),%esi
80103cb3:	b9 13 00 00 00       	mov    $0x13,%ecx
80103cb8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103cba:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103cbc:	8b 40 18             	mov    0x18(%eax),%eax
80103cbf:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103cc6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103ccd:	00 
80103cce:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[i])
80103cd0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103cd4:	85 c0                	test   %eax,%eax
80103cd6:	74 13                	je     80103ceb <fork+0x9b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103cd8:	83 ec 0c             	sub    $0xc,%esp
80103cdb:	50                   	push   %eax
80103cdc:	e8 5f d2 ff ff       	call   80100f40 <filedup>
80103ce1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103ce4:	83 c4 10             	add    $0x10,%esp
80103ce7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103ceb:	83 c6 01             	add    $0x1,%esi
80103cee:	83 fe 10             	cmp    $0x10,%esi
80103cf1:	75 dd                	jne    80103cd0 <fork+0x80>
  np->cwd = idup(curproc->cwd);
80103cf3:	83 ec 0c             	sub    $0xc,%esp
80103cf6:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103cf9:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103cfc:	e8 ef da ff ff       	call   801017f0 <idup>
80103d01:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d04:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103d07:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d0a:	8d 47 6c             	lea    0x6c(%edi),%eax
80103d0d:	6a 10                	push   $0x10
80103d0f:	53                   	push   %ebx
80103d10:	50                   	push   %eax
80103d11:	e8 1a 0d 00 00       	call   80104a30 <safestrcpy>
  pid = np->pid;
80103d16:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103d19:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
80103d20:	e8 5b 0a 00 00       	call   80104780 <acquire>
  np->state = RUNNABLE;
80103d25:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103d2c:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
80103d33:	e8 e8 09 00 00       	call   80104720 <release>
  return pid;
80103d38:	83 c4 10             	add    $0x10,%esp
}
80103d3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d3e:	89 d8                	mov    %ebx,%eax
80103d40:	5b                   	pop    %ebx
80103d41:	5e                   	pop    %esi
80103d42:	5f                   	pop    %edi
80103d43:	5d                   	pop    %ebp
80103d44:	c3                   	ret
    kfree(np->kstack);
80103d45:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103d48:	83 ec 0c             	sub    $0xc,%esp
80103d4b:	ff 73 08             	push   0x8(%ebx)
80103d4e:	e8 cd e7 ff ff       	call   80102520 <kfree>
    np->kstack = 0;
80103d53:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103d5a:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103d5d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103d64:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103d69:	eb d0                	jmp    80103d3b <fork+0xeb>
80103d6b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80103d70 <scheduler>:
{
80103d70:	55                   	push   %ebp
80103d71:	89 e5                	mov    %esp,%ebp
80103d73:	57                   	push   %edi
80103d74:	56                   	push   %esi
80103d75:	53                   	push   %ebx
80103d76:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103d79:	e8 b2 fc ff ff       	call   80103a30 <mycpu>
  c->proc = 0;
80103d7e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103d85:	00 00 00 
  struct cpu *c = mycpu();
80103d88:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103d8a:	8d 78 04             	lea    0x4(%eax),%edi
80103d8d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103d90:	fb                   	sti
    acquire(&ptable.lock);
80103d91:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d94:	bb b4 2d 11 80       	mov    $0x80112db4,%ebx
    acquire(&ptable.lock);
80103d99:	68 80 2d 11 80       	push   $0x80112d80
80103d9e:	e8 dd 09 00 00       	call   80104780 <acquire>
80103da3:	83 c4 10             	add    $0x10,%esp
80103da6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103dad:	00 
80103dae:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80103db0:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103db4:	75 33                	jne    80103de9 <scheduler+0x79>
      switchuvm(p);
80103db6:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103db9:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103dbf:	53                   	push   %ebx
80103dc0:	e8 3b 2f 00 00       	call   80106d00 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103dc5:	58                   	pop    %eax
80103dc6:	5a                   	pop    %edx
80103dc7:	ff 73 1c             	push   0x1c(%ebx)
80103dca:	57                   	push   %edi
      p->state = RUNNING;
80103dcb:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103dd2:	e8 b4 0c 00 00       	call   80104a8b <swtch>
      switchkvm();
80103dd7:	e8 14 2f 00 00       	call   80106cf0 <switchkvm>
      c->proc = 0;
80103ddc:	83 c4 10             	add    $0x10,%esp
80103ddf:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103de6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103de9:	83 eb 80             	sub    $0xffffff80,%ebx
80103dec:	81 fb b4 4d 11 80    	cmp    $0x80114db4,%ebx
80103df2:	75 bc                	jne    80103db0 <scheduler+0x40>
    release(&ptable.lock);
80103df4:	83 ec 0c             	sub    $0xc,%esp
80103df7:	68 80 2d 11 80       	push   $0x80112d80
80103dfc:	e8 1f 09 00 00       	call   80104720 <release>
    sti();
80103e01:	83 c4 10             	add    $0x10,%esp
80103e04:	eb 8a                	jmp    80103d90 <scheduler+0x20>
80103e06:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103e0d:	00 
80103e0e:	66 90                	xchg   %ax,%ax

80103e10 <sched>:
{
80103e10:	55                   	push   %ebp
80103e11:	89 e5                	mov    %esp,%ebp
80103e13:	56                   	push   %esi
80103e14:	53                   	push   %ebx
  pushcli();
80103e15:	e8 16 08 00 00       	call   80104630 <pushcli>
  c = mycpu();
80103e1a:	e8 11 fc ff ff       	call   80103a30 <mycpu>
  p = c->proc;
80103e1f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e25:	e8 56 08 00 00       	call   80104680 <popcli>
  if(!holding(&ptable.lock))
80103e2a:	83 ec 0c             	sub    $0xc,%esp
80103e2d:	68 80 2d 11 80       	push   $0x80112d80
80103e32:	e8 a9 08 00 00       	call   801046e0 <holding>
80103e37:	83 c4 10             	add    $0x10,%esp
80103e3a:	85 c0                	test   %eax,%eax
80103e3c:	74 4f                	je     80103e8d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103e3e:	e8 ed fb ff ff       	call   80103a30 <mycpu>
80103e43:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103e4a:	75 68                	jne    80103eb4 <sched+0xa4>
  if(p->state == RUNNING)
80103e4c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103e50:	74 55                	je     80103ea7 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103e52:	9c                   	pushf
80103e53:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103e54:	f6 c4 02             	test   $0x2,%ah
80103e57:	75 41                	jne    80103e9a <sched+0x8a>
  intena = mycpu()->intena;
80103e59:	e8 d2 fb ff ff       	call   80103a30 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103e5e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103e61:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103e67:	e8 c4 fb ff ff       	call   80103a30 <mycpu>
80103e6c:	83 ec 08             	sub    $0x8,%esp
80103e6f:	ff 70 04             	push   0x4(%eax)
80103e72:	53                   	push   %ebx
80103e73:	e8 13 0c 00 00       	call   80104a8b <swtch>
  mycpu()->intena = intena;
80103e78:	e8 b3 fb ff ff       	call   80103a30 <mycpu>
}
80103e7d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103e80:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103e86:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103e89:	5b                   	pop    %ebx
80103e8a:	5e                   	pop    %esi
80103e8b:	5d                   	pop    %ebp
80103e8c:	c3                   	ret
    panic("sched ptable.lock");
80103e8d:	83 ec 0c             	sub    $0xc,%esp
80103e90:	68 02 7c 10 80       	push   $0x80107c02
80103e95:	e8 e6 c4 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
80103e9a:	83 ec 0c             	sub    $0xc,%esp
80103e9d:	68 2e 7c 10 80       	push   $0x80107c2e
80103ea2:	e8 d9 c4 ff ff       	call   80100380 <panic>
    panic("sched running");
80103ea7:	83 ec 0c             	sub    $0xc,%esp
80103eaa:	68 20 7c 10 80       	push   $0x80107c20
80103eaf:	e8 cc c4 ff ff       	call   80100380 <panic>
    panic("sched locks");
80103eb4:	83 ec 0c             	sub    $0xc,%esp
80103eb7:	68 14 7c 10 80       	push   $0x80107c14
80103ebc:	e8 bf c4 ff ff       	call   80100380 <panic>
80103ec1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103ec8:	00 
80103ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ed0 <exit>:
{
80103ed0:	55                   	push   %ebp
80103ed1:	89 e5                	mov    %esp,%ebp
80103ed3:	57                   	push   %edi
80103ed4:	56                   	push   %esi
80103ed5:	53                   	push   %ebx
80103ed6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80103ed9:	e8 d2 fb ff ff       	call   80103ab0 <myproc>
  if(curproc == initproc)
80103ede:	39 05 b4 4d 11 80    	cmp    %eax,0x80114db4
80103ee4:	0f 84 07 01 00 00    	je     80103ff1 <exit+0x121>
80103eea:	89 c3                	mov    %eax,%ebx
80103eec:	8d 70 28             	lea    0x28(%eax),%esi
80103eef:	8d 78 68             	lea    0x68(%eax),%edi
80103ef2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103ef8:	8b 06                	mov    (%esi),%eax
80103efa:	85 c0                	test   %eax,%eax
80103efc:	74 12                	je     80103f10 <exit+0x40>
      fileclose(curproc->ofile[fd]);
80103efe:	83 ec 0c             	sub    $0xc,%esp
80103f01:	50                   	push   %eax
80103f02:	e8 89 d0 ff ff       	call   80100f90 <fileclose>
      curproc->ofile[fd] = 0;
80103f07:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103f0d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80103f10:	83 c6 04             	add    $0x4,%esi
80103f13:	39 f7                	cmp    %esi,%edi
80103f15:	75 e1                	jne    80103ef8 <exit+0x28>
  begin_op();
80103f17:	e8 e4 ee ff ff       	call   80102e00 <begin_op>
  iput(curproc->cwd);
80103f1c:	83 ec 0c             	sub    $0xc,%esp
80103f1f:	ff 73 68             	push   0x68(%ebx)
80103f22:	e8 29 da ff ff       	call   80101950 <iput>
  end_op();
80103f27:	e8 44 ef ff ff       	call   80102e70 <end_op>
  curproc->cwd = 0;
80103f2c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103f33:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
80103f3a:	e8 41 08 00 00       	call   80104780 <acquire>
  wakeup1(curproc->parent);
80103f3f:	8b 53 14             	mov    0x14(%ebx),%edx
80103f42:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f45:	b8 b4 2d 11 80       	mov    $0x80112db4,%eax
80103f4a:	eb 0e                	jmp    80103f5a <exit+0x8a>
80103f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103f50:	83 e8 80             	sub    $0xffffff80,%eax
80103f53:	3d b4 4d 11 80       	cmp    $0x80114db4,%eax
80103f58:	74 1c                	je     80103f76 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
80103f5a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103f5e:	75 f0                	jne    80103f50 <exit+0x80>
80103f60:	3b 50 20             	cmp    0x20(%eax),%edx
80103f63:	75 eb                	jne    80103f50 <exit+0x80>
      p->state = RUNNABLE;
80103f65:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f6c:	83 e8 80             	sub    $0xffffff80,%eax
80103f6f:	3d b4 4d 11 80       	cmp    $0x80114db4,%eax
80103f74:	75 e4                	jne    80103f5a <exit+0x8a>
      p->parent = initproc;
80103f76:	8b 0d b4 4d 11 80    	mov    0x80114db4,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f7c:	ba b4 2d 11 80       	mov    $0x80112db4,%edx
80103f81:	eb 10                	jmp    80103f93 <exit+0xc3>
80103f83:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80103f88:	83 ea 80             	sub    $0xffffff80,%edx
80103f8b:	81 fa b4 4d 11 80    	cmp    $0x80114db4,%edx
80103f91:	74 3b                	je     80103fce <exit+0xfe>
    if(p->parent == curproc){
80103f93:	39 5a 14             	cmp    %ebx,0x14(%edx)
80103f96:	75 f0                	jne    80103f88 <exit+0xb8>
      if(p->state == ZOMBIE)
80103f98:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80103f9c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
80103f9f:	75 e7                	jne    80103f88 <exit+0xb8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fa1:	b8 b4 2d 11 80       	mov    $0x80112db4,%eax
80103fa6:	eb 12                	jmp    80103fba <exit+0xea>
80103fa8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80103faf:	00 
80103fb0:	83 e8 80             	sub    $0xffffff80,%eax
80103fb3:	3d b4 4d 11 80       	cmp    $0x80114db4,%eax
80103fb8:	74 ce                	je     80103f88 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
80103fba:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103fbe:	75 f0                	jne    80103fb0 <exit+0xe0>
80103fc0:	3b 48 20             	cmp    0x20(%eax),%ecx
80103fc3:	75 eb                	jne    80103fb0 <exit+0xe0>
      p->state = RUNNABLE;
80103fc5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103fcc:	eb e2                	jmp    80103fb0 <exit+0xe0>
  clear_disk_of_proc(curproc->pid);
80103fce:	83 ec 0c             	sub    $0xc,%esp
  curproc->state = ZOMBIE;
80103fd1:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  clear_disk_of_proc(curproc->pid);
80103fd8:	ff 73 10             	push   0x10(%ebx)
80103fdb:	e8 10 39 00 00       	call   801078f0 <clear_disk_of_proc>
  sched();
80103fe0:	e8 2b fe ff ff       	call   80103e10 <sched>
  panic("zombie exit");
80103fe5:	c7 04 24 4f 7c 10 80 	movl   $0x80107c4f,(%esp)
80103fec:	e8 8f c3 ff ff       	call   80100380 <panic>
    panic("init exiting");
80103ff1:	83 ec 0c             	sub    $0xc,%esp
80103ff4:	68 42 7c 10 80       	push   $0x80107c42
80103ff9:	e8 82 c3 ff ff       	call   80100380 <panic>
80103ffe:	66 90                	xchg   %ax,%ax

80104000 <wait>:
{
80104000:	55                   	push   %ebp
80104001:	89 e5                	mov    %esp,%ebp
80104003:	56                   	push   %esi
80104004:	53                   	push   %ebx
  pushcli();
80104005:	e8 26 06 00 00       	call   80104630 <pushcli>
  c = mycpu();
8010400a:	e8 21 fa ff ff       	call   80103a30 <mycpu>
  p = c->proc;
8010400f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104015:	e8 66 06 00 00       	call   80104680 <popcli>
  acquire(&ptable.lock);
8010401a:	83 ec 0c             	sub    $0xc,%esp
8010401d:	68 80 2d 11 80       	push   $0x80112d80
80104022:	e8 59 07 00 00       	call   80104780 <acquire>
80104027:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010402a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010402c:	bb b4 2d 11 80       	mov    $0x80112db4,%ebx
80104031:	eb 10                	jmp    80104043 <wait+0x43>
80104033:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104038:	83 eb 80             	sub    $0xffffff80,%ebx
8010403b:	81 fb b4 4d 11 80    	cmp    $0x80114db4,%ebx
80104041:	74 1b                	je     8010405e <wait+0x5e>
      if(p->parent != curproc)
80104043:	39 73 14             	cmp    %esi,0x14(%ebx)
80104046:	75 f0                	jne    80104038 <wait+0x38>
      if(p->state == ZOMBIE){
80104048:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010404c:	74 62                	je     801040b0 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010404e:	83 eb 80             	sub    $0xffffff80,%ebx
      havekids = 1;
80104051:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104056:	81 fb b4 4d 11 80    	cmp    $0x80114db4,%ebx
8010405c:	75 e5                	jne    80104043 <wait+0x43>
    if(!havekids || curproc->killed){
8010405e:	85 c0                	test   %eax,%eax
80104060:	0f 84 a0 00 00 00    	je     80104106 <wait+0x106>
80104066:	8b 46 24             	mov    0x24(%esi),%eax
80104069:	85 c0                	test   %eax,%eax
8010406b:	0f 85 95 00 00 00    	jne    80104106 <wait+0x106>
  pushcli();
80104071:	e8 ba 05 00 00       	call   80104630 <pushcli>
  c = mycpu();
80104076:	e8 b5 f9 ff ff       	call   80103a30 <mycpu>
  p = c->proc;
8010407b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104081:	e8 fa 05 00 00       	call   80104680 <popcli>
  if(p == 0)
80104086:	85 db                	test   %ebx,%ebx
80104088:	0f 84 8f 00 00 00    	je     8010411d <wait+0x11d>
  p->chan = chan;
8010408e:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80104091:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104098:	e8 73 fd ff ff       	call   80103e10 <sched>
  p->chan = 0;
8010409d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801040a4:	eb 84                	jmp    8010402a <wait+0x2a>
801040a6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801040ad:	00 
801040ae:	66 90                	xchg   %ax,%ax
        kfree(p->kstack);
801040b0:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
801040b3:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801040b6:	ff 73 08             	push   0x8(%ebx)
801040b9:	e8 62 e4 ff ff       	call   80102520 <kfree>
        p->kstack = 0;
801040be:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801040c5:	5a                   	pop    %edx
801040c6:	ff 73 04             	push   0x4(%ebx)
801040c9:	e8 e2 2f 00 00       	call   801070b0 <freevm>
        p->pid = 0;
801040ce:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801040d5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801040dc:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801040e0:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801040e7:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801040ee:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
801040f5:	e8 26 06 00 00       	call   80104720 <release>
        return pid;
801040fa:	83 c4 10             	add    $0x10,%esp
}
801040fd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104100:	89 f0                	mov    %esi,%eax
80104102:	5b                   	pop    %ebx
80104103:	5e                   	pop    %esi
80104104:	5d                   	pop    %ebp
80104105:	c3                   	ret
      release(&ptable.lock);
80104106:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104109:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010410e:	68 80 2d 11 80       	push   $0x80112d80
80104113:	e8 08 06 00 00       	call   80104720 <release>
      return -1;
80104118:	83 c4 10             	add    $0x10,%esp
8010411b:	eb e0                	jmp    801040fd <wait+0xfd>
    panic("sleep");
8010411d:	83 ec 0c             	sub    $0xc,%esp
80104120:	68 5b 7c 10 80       	push   $0x80107c5b
80104125:	e8 56 c2 ff ff       	call   80100380 <panic>
8010412a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104130 <yield>:
{
80104130:	55                   	push   %ebp
80104131:	89 e5                	mov    %esp,%ebp
80104133:	53                   	push   %ebx
80104134:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104137:	68 80 2d 11 80       	push   $0x80112d80
8010413c:	e8 3f 06 00 00       	call   80104780 <acquire>
  pushcli();
80104141:	e8 ea 04 00 00       	call   80104630 <pushcli>
  c = mycpu();
80104146:	e8 e5 f8 ff ff       	call   80103a30 <mycpu>
  p = c->proc;
8010414b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104151:	e8 2a 05 00 00       	call   80104680 <popcli>
  myproc()->state = RUNNABLE;
80104156:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010415d:	e8 ae fc ff ff       	call   80103e10 <sched>
  release(&ptable.lock);
80104162:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
80104169:	e8 b2 05 00 00       	call   80104720 <release>
}
8010416e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104171:	83 c4 10             	add    $0x10,%esp
80104174:	c9                   	leave
80104175:	c3                   	ret
80104176:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010417d:	00 
8010417e:	66 90                	xchg   %ax,%ax

80104180 <sleep>:
{
80104180:	55                   	push   %ebp
80104181:	89 e5                	mov    %esp,%ebp
80104183:	57                   	push   %edi
80104184:	56                   	push   %esi
80104185:	53                   	push   %ebx
80104186:	83 ec 0c             	sub    $0xc,%esp
80104189:	8b 7d 08             	mov    0x8(%ebp),%edi
8010418c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010418f:	e8 9c 04 00 00       	call   80104630 <pushcli>
  c = mycpu();
80104194:	e8 97 f8 ff ff       	call   80103a30 <mycpu>
  p = c->proc;
80104199:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010419f:	e8 dc 04 00 00       	call   80104680 <popcli>
  if(p == 0)
801041a4:	85 db                	test   %ebx,%ebx
801041a6:	0f 84 87 00 00 00    	je     80104233 <sleep+0xb3>
  if(lk == 0)
801041ac:	85 f6                	test   %esi,%esi
801041ae:	74 76                	je     80104226 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801041b0:	81 fe 80 2d 11 80    	cmp    $0x80112d80,%esi
801041b6:	74 50                	je     80104208 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801041b8:	83 ec 0c             	sub    $0xc,%esp
801041bb:	68 80 2d 11 80       	push   $0x80112d80
801041c0:	e8 bb 05 00 00       	call   80104780 <acquire>
    release(lk);
801041c5:	89 34 24             	mov    %esi,(%esp)
801041c8:	e8 53 05 00 00       	call   80104720 <release>
  p->chan = chan;
801041cd:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801041d0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801041d7:	e8 34 fc ff ff       	call   80103e10 <sched>
  p->chan = 0;
801041dc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801041e3:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
801041ea:	e8 31 05 00 00       	call   80104720 <release>
    acquire(lk);
801041ef:	83 c4 10             	add    $0x10,%esp
801041f2:	89 75 08             	mov    %esi,0x8(%ebp)
}
801041f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041f8:	5b                   	pop    %ebx
801041f9:	5e                   	pop    %esi
801041fa:	5f                   	pop    %edi
801041fb:	5d                   	pop    %ebp
    acquire(lk);
801041fc:	e9 7f 05 00 00       	jmp    80104780 <acquire>
80104201:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104208:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010420b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104212:	e8 f9 fb ff ff       	call   80103e10 <sched>
  p->chan = 0;
80104217:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010421e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104221:	5b                   	pop    %ebx
80104222:	5e                   	pop    %esi
80104223:	5f                   	pop    %edi
80104224:	5d                   	pop    %ebp
80104225:	c3                   	ret
    panic("sleep without lk");
80104226:	83 ec 0c             	sub    $0xc,%esp
80104229:	68 61 7c 10 80       	push   $0x80107c61
8010422e:	e8 4d c1 ff ff       	call   80100380 <panic>
    panic("sleep");
80104233:	83 ec 0c             	sub    $0xc,%esp
80104236:	68 5b 7c 10 80       	push   $0x80107c5b
8010423b:	e8 40 c1 ff ff       	call   80100380 <panic>

80104240 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104240:	55                   	push   %ebp
80104241:	89 e5                	mov    %esp,%ebp
80104243:	53                   	push   %ebx
80104244:	83 ec 10             	sub    $0x10,%esp
80104247:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010424a:	68 80 2d 11 80       	push   $0x80112d80
8010424f:	e8 2c 05 00 00       	call   80104780 <acquire>
80104254:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104257:	b8 b4 2d 11 80       	mov    $0x80112db4,%eax
8010425c:	eb 0c                	jmp    8010426a <wakeup+0x2a>
8010425e:	66 90                	xchg   %ax,%ax
80104260:	83 e8 80             	sub    $0xffffff80,%eax
80104263:	3d b4 4d 11 80       	cmp    $0x80114db4,%eax
80104268:	74 1c                	je     80104286 <wakeup+0x46>
    if(p->state == SLEEPING && p->chan == chan)
8010426a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010426e:	75 f0                	jne    80104260 <wakeup+0x20>
80104270:	3b 58 20             	cmp    0x20(%eax),%ebx
80104273:	75 eb                	jne    80104260 <wakeup+0x20>
      p->state = RUNNABLE;
80104275:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010427c:	83 e8 80             	sub    $0xffffff80,%eax
8010427f:	3d b4 4d 11 80       	cmp    $0x80114db4,%eax
80104284:	75 e4                	jne    8010426a <wakeup+0x2a>
  wakeup1(chan);
  release(&ptable.lock);
80104286:	c7 45 08 80 2d 11 80 	movl   $0x80112d80,0x8(%ebp)
}
8010428d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104290:	c9                   	leave
  release(&ptable.lock);
80104291:	e9 8a 04 00 00       	jmp    80104720 <release>
80104296:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010429d:	00 
8010429e:	66 90                	xchg   %ax,%ax

801042a0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801042a0:	55                   	push   %ebp
801042a1:	89 e5                	mov    %esp,%ebp
801042a3:	53                   	push   %ebx
801042a4:	83 ec 10             	sub    $0x10,%esp
801042a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801042aa:	68 80 2d 11 80       	push   $0x80112d80
801042af:	e8 cc 04 00 00       	call   80104780 <acquire>
801042b4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042b7:	b8 b4 2d 11 80       	mov    $0x80112db4,%eax
801042bc:	eb 0c                	jmp    801042ca <kill+0x2a>
801042be:	66 90                	xchg   %ax,%ax
801042c0:	83 e8 80             	sub    $0xffffff80,%eax
801042c3:	3d b4 4d 11 80       	cmp    $0x80114db4,%eax
801042c8:	74 36                	je     80104300 <kill+0x60>
    if(p->pid == pid){
801042ca:	39 58 10             	cmp    %ebx,0x10(%eax)
801042cd:	75 f1                	jne    801042c0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801042cf:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801042d3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801042da:	75 07                	jne    801042e3 <kill+0x43>
        p->state = RUNNABLE;
801042dc:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801042e3:	83 ec 0c             	sub    $0xc,%esp
801042e6:	68 80 2d 11 80       	push   $0x80112d80
801042eb:	e8 30 04 00 00       	call   80104720 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801042f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801042f3:	83 c4 10             	add    $0x10,%esp
801042f6:	31 c0                	xor    %eax,%eax
}
801042f8:	c9                   	leave
801042f9:	c3                   	ret
801042fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104300:	83 ec 0c             	sub    $0xc,%esp
80104303:	68 80 2d 11 80       	push   $0x80112d80
80104308:	e8 13 04 00 00       	call   80104720 <release>
}
8010430d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104310:	83 c4 10             	add    $0x10,%esp
80104313:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104318:	c9                   	leave
80104319:	c3                   	ret
8010431a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104320 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104320:	55                   	push   %ebp
80104321:	89 e5                	mov    %esp,%ebp
80104323:	57                   	push   %edi
80104324:	56                   	push   %esi
80104325:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104328:	53                   	push   %ebx
80104329:	bb 20 2e 11 80       	mov    $0x80112e20,%ebx
8010432e:	83 ec 3c             	sub    $0x3c,%esp
80104331:	eb 24                	jmp    80104357 <procdump+0x37>
80104333:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104338:	83 ec 0c             	sub    $0xc,%esp
8010433b:	68 19 7e 10 80       	push   $0x80107e19
80104340:	e8 6b c3 ff ff       	call   801006b0 <cprintf>
80104345:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104348:	83 eb 80             	sub    $0xffffff80,%ebx
8010434b:	81 fb 20 4e 11 80    	cmp    $0x80114e20,%ebx
80104351:	0f 84 81 00 00 00    	je     801043d8 <procdump+0xb8>
    if(p->state == UNUSED)
80104357:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010435a:	85 c0                	test   %eax,%eax
8010435c:	74 ea                	je     80104348 <procdump+0x28>
      state = "???";
8010435e:	ba 72 7c 10 80       	mov    $0x80107c72,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104363:	83 f8 05             	cmp    $0x5,%eax
80104366:	77 11                	ja     80104379 <procdump+0x59>
80104368:	8b 14 85 e0 82 10 80 	mov    -0x7fef7d20(,%eax,4),%edx
      state = "???";
8010436f:	b8 72 7c 10 80       	mov    $0x80107c72,%eax
80104374:	85 d2                	test   %edx,%edx
80104376:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104379:	53                   	push   %ebx
8010437a:	52                   	push   %edx
8010437b:	ff 73 a4             	push   -0x5c(%ebx)
8010437e:	68 76 7c 10 80       	push   $0x80107c76
80104383:	e8 28 c3 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
80104388:	83 c4 10             	add    $0x10,%esp
8010438b:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010438f:	75 a7                	jne    80104338 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104391:	83 ec 08             	sub    $0x8,%esp
80104394:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104397:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010439a:	50                   	push   %eax
8010439b:	8b 43 b0             	mov    -0x50(%ebx),%eax
8010439e:	8b 40 0c             	mov    0xc(%eax),%eax
801043a1:	83 c0 08             	add    $0x8,%eax
801043a4:	50                   	push   %eax
801043a5:	e8 06 02 00 00       	call   801045b0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801043aa:	83 c4 10             	add    $0x10,%esp
801043ad:	8d 76 00             	lea    0x0(%esi),%esi
801043b0:	8b 17                	mov    (%edi),%edx
801043b2:	85 d2                	test   %edx,%edx
801043b4:	74 82                	je     80104338 <procdump+0x18>
        cprintf(" %p", pc[i]);
801043b6:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801043b9:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
801043bc:	52                   	push   %edx
801043bd:	68 81 79 10 80       	push   $0x80107981
801043c2:	e8 e9 c2 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801043c7:	83 c4 10             	add    $0x10,%esp
801043ca:	39 f7                	cmp    %esi,%edi
801043cc:	75 e2                	jne    801043b0 <procdump+0x90>
801043ce:	e9 65 ff ff ff       	jmp    80104338 <procdump+0x18>
801043d3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  }
}
801043d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043db:	5b                   	pop    %ebx
801043dc:	5e                   	pop    %esi
801043dd:	5f                   	pop    %edi
801043de:	5d                   	pop    %ebp
801043df:	c3                   	ret

801043e0 <choose_victim>:

struct proc* choose_victim()
{
801043e0:	55                   	push   %ebp
801043e1:	89 e5                	mov    %esp,%ebp
801043e3:	53                   	push   %ebx
  struct proc* temp=0;
801043e4:	31 db                	xor    %ebx,%ebx
{
801043e6:	83 ec 10             	sub    $0x10,%esp
  struct proc* p;
  acquire(&ptable.lock);
801043e9:	68 80 2d 11 80       	push   $0x80112d80
801043ee:	e8 8d 03 00 00       	call   80104780 <acquire>
801043f3:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801043f6:	b8 b4 2d 11 80       	mov    $0x80112db4,%eax
801043fb:	eb 1d                	jmp    8010441a <choose_victim+0x3a>
801043fd:	8d 76 00             	lea    0x0(%esi),%esi
    if(p->state!=RUNNING && p->state!=SLEEPING) continue;
    if(!temp) temp=p;
    else if(temp->rss<p->rss || (temp->rss==p->rss && p->pid<temp->pid)) temp=p;
80104400:	75 0e                	jne    80104410 <choose_victim+0x30>
    if(!temp) temp=p;
80104402:	8b 4b 10             	mov    0x10(%ebx),%ecx
80104405:	39 48 10             	cmp    %ecx,0x10(%eax)
80104408:	0f 4c d8             	cmovl  %eax,%ebx
8010440b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104410:	83 e8 80             	sub    $0xffffff80,%eax
80104413:	3d b4 4d 11 80       	cmp    $0x80114db4,%eax
80104418:	74 23                	je     8010443d <choose_victim+0x5d>
    if(p->state!=RUNNING && p->state!=SLEEPING) continue;
8010441a:	8b 48 0c             	mov    0xc(%eax),%ecx
8010441d:	8d 51 fe             	lea    -0x2(%ecx),%edx
80104420:	83 e2 fd             	and    $0xfffffffd,%edx
80104423:	75 eb                	jne    80104410 <choose_victim+0x30>
    if(!temp) temp=p;
80104425:	85 db                	test   %ebx,%ebx
80104427:	74 08                	je     80104431 <choose_victim+0x51>
    else if(temp->rss<p->rss || (temp->rss==p->rss && p->pid<temp->pid)) temp=p;
80104429:	8b 50 7c             	mov    0x7c(%eax),%edx
8010442c:	39 53 7c             	cmp    %edx,0x7c(%ebx)
8010442f:	7d cf                	jge    80104400 <choose_victim+0x20>
    if(!temp) temp=p;
80104431:	89 c3                	mov    %eax,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104433:	83 e8 80             	sub    $0xffffff80,%eax
80104436:	3d b4 4d 11 80       	cmp    $0x80114db4,%eax
8010443b:	75 dd                	jne    8010441a <choose_victim+0x3a>
  }
  release(&ptable.lock);
8010443d:	83 ec 0c             	sub    $0xc,%esp
80104440:	68 80 2d 11 80       	push   $0x80112d80
80104445:	e8 d6 02 00 00       	call   80104720 <release>
  return temp;
8010444a:	89 d8                	mov    %ebx,%eax
8010444c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010444f:	c9                   	leave
80104450:	c3                   	ret
80104451:	66 90                	xchg   %ax,%ax
80104453:	66 90                	xchg   %ax,%ax
80104455:	66 90                	xchg   %ax,%ax
80104457:	66 90                	xchg   %ax,%ax
80104459:	66 90                	xchg   %ax,%ax
8010445b:	66 90                	xchg   %ax,%ax
8010445d:	66 90                	xchg   %ax,%ax
8010445f:	90                   	nop

80104460 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104460:	55                   	push   %ebp
80104461:	89 e5                	mov    %esp,%ebp
80104463:	53                   	push   %ebx
80104464:	83 ec 0c             	sub    $0xc,%esp
80104467:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010446a:	68 a9 7c 10 80       	push   $0x80107ca9
8010446f:	8d 43 04             	lea    0x4(%ebx),%eax
80104472:	50                   	push   %eax
80104473:	e8 18 01 00 00       	call   80104590 <initlock>
  lk->name = name;
80104478:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010447b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104481:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104484:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010448b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010448e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104491:	c9                   	leave
80104492:	c3                   	ret
80104493:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010449a:	00 
8010449b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801044a0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
801044a0:	55                   	push   %ebp
801044a1:	89 e5                	mov    %esp,%ebp
801044a3:	56                   	push   %esi
801044a4:	53                   	push   %ebx
801044a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801044a8:	8d 73 04             	lea    0x4(%ebx),%esi
801044ab:	83 ec 0c             	sub    $0xc,%esp
801044ae:	56                   	push   %esi
801044af:	e8 cc 02 00 00       	call   80104780 <acquire>
  while (lk->locked) {
801044b4:	8b 13                	mov    (%ebx),%edx
801044b6:	83 c4 10             	add    $0x10,%esp
801044b9:	85 d2                	test   %edx,%edx
801044bb:	74 16                	je     801044d3 <acquiresleep+0x33>
801044bd:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801044c0:	83 ec 08             	sub    $0x8,%esp
801044c3:	56                   	push   %esi
801044c4:	53                   	push   %ebx
801044c5:	e8 b6 fc ff ff       	call   80104180 <sleep>
  while (lk->locked) {
801044ca:	8b 03                	mov    (%ebx),%eax
801044cc:	83 c4 10             	add    $0x10,%esp
801044cf:	85 c0                	test   %eax,%eax
801044d1:	75 ed                	jne    801044c0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801044d3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801044d9:	e8 d2 f5 ff ff       	call   80103ab0 <myproc>
801044de:	8b 40 10             	mov    0x10(%eax),%eax
801044e1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801044e4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801044e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044ea:	5b                   	pop    %ebx
801044eb:	5e                   	pop    %esi
801044ec:	5d                   	pop    %ebp
  release(&lk->lk);
801044ed:	e9 2e 02 00 00       	jmp    80104720 <release>
801044f2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801044f9:	00 
801044fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104500 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104500:	55                   	push   %ebp
80104501:	89 e5                	mov    %esp,%ebp
80104503:	56                   	push   %esi
80104504:	53                   	push   %ebx
80104505:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104508:	8d 73 04             	lea    0x4(%ebx),%esi
8010450b:	83 ec 0c             	sub    $0xc,%esp
8010450e:	56                   	push   %esi
8010450f:	e8 6c 02 00 00       	call   80104780 <acquire>
  lk->locked = 0;
80104514:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010451a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104521:	89 1c 24             	mov    %ebx,(%esp)
80104524:	e8 17 fd ff ff       	call   80104240 <wakeup>
  release(&lk->lk);
80104529:	83 c4 10             	add    $0x10,%esp
8010452c:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010452f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104532:	5b                   	pop    %ebx
80104533:	5e                   	pop    %esi
80104534:	5d                   	pop    %ebp
  release(&lk->lk);
80104535:	e9 e6 01 00 00       	jmp    80104720 <release>
8010453a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104540 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104540:	55                   	push   %ebp
80104541:	89 e5                	mov    %esp,%ebp
80104543:	57                   	push   %edi
80104544:	31 ff                	xor    %edi,%edi
80104546:	56                   	push   %esi
80104547:	53                   	push   %ebx
80104548:	83 ec 18             	sub    $0x18,%esp
8010454b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010454e:	8d 73 04             	lea    0x4(%ebx),%esi
80104551:	56                   	push   %esi
80104552:	e8 29 02 00 00       	call   80104780 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104557:	8b 03                	mov    (%ebx),%eax
80104559:	83 c4 10             	add    $0x10,%esp
8010455c:	85 c0                	test   %eax,%eax
8010455e:	75 18                	jne    80104578 <holdingsleep+0x38>
  release(&lk->lk);
80104560:	83 ec 0c             	sub    $0xc,%esp
80104563:	56                   	push   %esi
80104564:	e8 b7 01 00 00       	call   80104720 <release>
  return r;
}
80104569:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010456c:	89 f8                	mov    %edi,%eax
8010456e:	5b                   	pop    %ebx
8010456f:	5e                   	pop    %esi
80104570:	5f                   	pop    %edi
80104571:	5d                   	pop    %ebp
80104572:	c3                   	ret
80104573:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  r = lk->locked && (lk->pid == myproc()->pid);
80104578:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010457b:	e8 30 f5 ff ff       	call   80103ab0 <myproc>
80104580:	39 58 10             	cmp    %ebx,0x10(%eax)
80104583:	0f 94 c0             	sete   %al
80104586:	0f b6 c0             	movzbl %al,%eax
80104589:	89 c7                	mov    %eax,%edi
8010458b:	eb d3                	jmp    80104560 <holdingsleep+0x20>
8010458d:	66 90                	xchg   %ax,%ax
8010458f:	90                   	nop

80104590 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104596:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104599:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010459f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
801045a2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801045a9:	5d                   	pop    %ebp
801045aa:	c3                   	ret
801045ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801045b0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801045b0:	55                   	push   %ebp
801045b1:	89 e5                	mov    %esp,%ebp
801045b3:	53                   	push   %ebx
801045b4:	8b 45 08             	mov    0x8(%ebp),%eax
801045b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801045ba:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801045bd:	05 f8 ff ff 7f       	add    $0x7ffffff8,%eax
801045c2:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
  for(i = 0; i < 10; i++){
801045c7:	b8 00 00 00 00       	mov    $0x0,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801045cc:	76 10                	jbe    801045de <getcallerpcs+0x2e>
801045ce:	eb 28                	jmp    801045f8 <getcallerpcs+0x48>
801045d0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801045d6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801045dc:	77 1a                	ja     801045f8 <getcallerpcs+0x48>
      break;
    pcs[i] = ebp[1];     // saved %eip
801045de:	8b 5a 04             	mov    0x4(%edx),%ebx
801045e1:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
801045e4:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
801045e7:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
801045e9:	83 f8 0a             	cmp    $0xa,%eax
801045ec:	75 e2                	jne    801045d0 <getcallerpcs+0x20>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801045ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045f1:	c9                   	leave
801045f2:	c3                   	ret
801045f3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801045f8:	8d 04 81             	lea    (%ecx,%eax,4),%eax
801045fb:	83 c1 28             	add    $0x28,%ecx
801045fe:	89 ca                	mov    %ecx,%edx
80104600:	29 c2                	sub    %eax,%edx
80104602:	83 e2 04             	and    $0x4,%edx
80104605:	74 11                	je     80104618 <getcallerpcs+0x68>
    pcs[i] = 0;
80104607:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
8010460d:	83 c0 04             	add    $0x4,%eax
80104610:	39 c1                	cmp    %eax,%ecx
80104612:	74 da                	je     801045ee <getcallerpcs+0x3e>
80104614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
80104618:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
8010461e:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80104621:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80104628:	39 c1                	cmp    %eax,%ecx
8010462a:	75 ec                	jne    80104618 <getcallerpcs+0x68>
8010462c:	eb c0                	jmp    801045ee <getcallerpcs+0x3e>
8010462e:	66 90                	xchg   %ax,%ax

80104630 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104630:	55                   	push   %ebp
80104631:	89 e5                	mov    %esp,%ebp
80104633:	53                   	push   %ebx
80104634:	83 ec 04             	sub    $0x4,%esp
80104637:	9c                   	pushf
80104638:	5b                   	pop    %ebx
  asm volatile("cli");
80104639:	fa                   	cli
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010463a:	e8 f1 f3 ff ff       	call   80103a30 <mycpu>
8010463f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104645:	85 c0                	test   %eax,%eax
80104647:	74 17                	je     80104660 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104649:	e8 e2 f3 ff ff       	call   80103a30 <mycpu>
8010464e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104655:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104658:	c9                   	leave
80104659:	c3                   	ret
8010465a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104660:	e8 cb f3 ff ff       	call   80103a30 <mycpu>
80104665:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010466b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104671:	eb d6                	jmp    80104649 <pushcli+0x19>
80104673:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010467a:	00 
8010467b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104680 <popcli>:

void
popcli(void)
{
80104680:	55                   	push   %ebp
80104681:	89 e5                	mov    %esp,%ebp
80104683:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104686:	9c                   	pushf
80104687:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104688:	f6 c4 02             	test   $0x2,%ah
8010468b:	75 35                	jne    801046c2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010468d:	e8 9e f3 ff ff       	call   80103a30 <mycpu>
80104692:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104699:	78 34                	js     801046cf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010469b:	e8 90 f3 ff ff       	call   80103a30 <mycpu>
801046a0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801046a6:	85 d2                	test   %edx,%edx
801046a8:	74 06                	je     801046b0 <popcli+0x30>
    sti();
}
801046aa:	c9                   	leave
801046ab:	c3                   	ret
801046ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
801046b0:	e8 7b f3 ff ff       	call   80103a30 <mycpu>
801046b5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801046bb:	85 c0                	test   %eax,%eax
801046bd:	74 eb                	je     801046aa <popcli+0x2a>
  asm volatile("sti");
801046bf:	fb                   	sti
}
801046c0:	c9                   	leave
801046c1:	c3                   	ret
    panic("popcli - interruptible");
801046c2:	83 ec 0c             	sub    $0xc,%esp
801046c5:	68 b4 7c 10 80       	push   $0x80107cb4
801046ca:	e8 b1 bc ff ff       	call   80100380 <panic>
    panic("popcli");
801046cf:	83 ec 0c             	sub    $0xc,%esp
801046d2:	68 cb 7c 10 80       	push   $0x80107ccb
801046d7:	e8 a4 bc ff ff       	call   80100380 <panic>
801046dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801046e0 <holding>:
{
801046e0:	55                   	push   %ebp
801046e1:	89 e5                	mov    %esp,%ebp
801046e3:	56                   	push   %esi
801046e4:	53                   	push   %ebx
801046e5:	8b 75 08             	mov    0x8(%ebp),%esi
801046e8:	31 db                	xor    %ebx,%ebx
  pushcli();
801046ea:	e8 41 ff ff ff       	call   80104630 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801046ef:	8b 06                	mov    (%esi),%eax
801046f1:	85 c0                	test   %eax,%eax
801046f3:	75 0b                	jne    80104700 <holding+0x20>
  popcli();
801046f5:	e8 86 ff ff ff       	call   80104680 <popcli>
}
801046fa:	89 d8                	mov    %ebx,%eax
801046fc:	5b                   	pop    %ebx
801046fd:	5e                   	pop    %esi
801046fe:	5d                   	pop    %ebp
801046ff:	c3                   	ret
  r = lock->locked && lock->cpu == mycpu();
80104700:	8b 5e 08             	mov    0x8(%esi),%ebx
80104703:	e8 28 f3 ff ff       	call   80103a30 <mycpu>
80104708:	39 c3                	cmp    %eax,%ebx
8010470a:	0f 94 c3             	sete   %bl
  popcli();
8010470d:	e8 6e ff ff ff       	call   80104680 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104712:	0f b6 db             	movzbl %bl,%ebx
}
80104715:	89 d8                	mov    %ebx,%eax
80104717:	5b                   	pop    %ebx
80104718:	5e                   	pop    %esi
80104719:	5d                   	pop    %ebp
8010471a:	c3                   	ret
8010471b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104720 <release>:
{
80104720:	55                   	push   %ebp
80104721:	89 e5                	mov    %esp,%ebp
80104723:	56                   	push   %esi
80104724:	53                   	push   %ebx
80104725:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104728:	e8 03 ff ff ff       	call   80104630 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010472d:	8b 03                	mov    (%ebx),%eax
8010472f:	85 c0                	test   %eax,%eax
80104731:	75 15                	jne    80104748 <release+0x28>
  popcli();
80104733:	e8 48 ff ff ff       	call   80104680 <popcli>
    panic("release");
80104738:	83 ec 0c             	sub    $0xc,%esp
8010473b:	68 d2 7c 10 80       	push   $0x80107cd2
80104740:	e8 3b bc ff ff       	call   80100380 <panic>
80104745:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104748:	8b 73 08             	mov    0x8(%ebx),%esi
8010474b:	e8 e0 f2 ff ff       	call   80103a30 <mycpu>
80104750:	39 c6                	cmp    %eax,%esi
80104752:	75 df                	jne    80104733 <release+0x13>
  popcli();
80104754:	e8 27 ff ff ff       	call   80104680 <popcli>
  lk->pcs[0] = 0;
80104759:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104760:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104767:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010476c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104772:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104775:	5b                   	pop    %ebx
80104776:	5e                   	pop    %esi
80104777:	5d                   	pop    %ebp
  popcli();
80104778:	e9 03 ff ff ff       	jmp    80104680 <popcli>
8010477d:	8d 76 00             	lea    0x0(%esi),%esi

80104780 <acquire>:
{
80104780:	55                   	push   %ebp
80104781:	89 e5                	mov    %esp,%ebp
80104783:	53                   	push   %ebx
80104784:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104787:	e8 a4 fe ff ff       	call   80104630 <pushcli>
  if(holding(lk))
8010478c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010478f:	e8 9c fe ff ff       	call   80104630 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104794:	8b 03                	mov    (%ebx),%eax
80104796:	85 c0                	test   %eax,%eax
80104798:	0f 85 b2 00 00 00    	jne    80104850 <acquire+0xd0>
  popcli();
8010479e:	e8 dd fe ff ff       	call   80104680 <popcli>
  asm volatile("lock; xchgl %0, %1" :
801047a3:	b9 01 00 00 00       	mov    $0x1,%ecx
801047a8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801047af:	00 
  while(xchg(&lk->locked, 1) != 0)
801047b0:	8b 55 08             	mov    0x8(%ebp),%edx
801047b3:	89 c8                	mov    %ecx,%eax
801047b5:	f0 87 02             	lock xchg %eax,(%edx)
801047b8:	85 c0                	test   %eax,%eax
801047ba:	75 f4                	jne    801047b0 <acquire+0x30>
  __sync_synchronize();
801047bc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801047c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801047c4:	e8 67 f2 ff ff       	call   80103a30 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801047c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  for(i = 0; i < 10; i++){
801047cc:	31 d2                	xor    %edx,%edx
  lk->cpu = mycpu();
801047ce:	89 43 08             	mov    %eax,0x8(%ebx)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801047d1:	8d 85 00 00 00 80    	lea    -0x80000000(%ebp),%eax
801047d7:	3d fe ff ff 7f       	cmp    $0x7ffffffe,%eax
801047dc:	77 32                	ja     80104810 <acquire+0x90>
  ebp = (uint*)v - 2;
801047de:	89 e8                	mov    %ebp,%eax
801047e0:	eb 14                	jmp    801047f6 <acquire+0x76>
801047e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801047e8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
801047ee:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801047f4:	77 1a                	ja     80104810 <acquire+0x90>
    pcs[i] = ebp[1];     // saved %eip
801047f6:	8b 58 04             	mov    0x4(%eax),%ebx
801047f9:	89 5c 91 0c          	mov    %ebx,0xc(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801047fd:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104800:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104802:	83 fa 0a             	cmp    $0xa,%edx
80104805:	75 e1                	jne    801047e8 <acquire+0x68>
}
80104807:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010480a:	c9                   	leave
8010480b:	c3                   	ret
8010480c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104810:	8d 44 91 0c          	lea    0xc(%ecx,%edx,4),%eax
80104814:	83 c1 34             	add    $0x34,%ecx
80104817:	89 ca                	mov    %ecx,%edx
80104819:	29 c2                	sub    %eax,%edx
8010481b:	83 e2 04             	and    $0x4,%edx
8010481e:	74 10                	je     80104830 <acquire+0xb0>
    pcs[i] = 0;
80104820:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104826:	83 c0 04             	add    $0x4,%eax
80104829:	39 c1                	cmp    %eax,%ecx
8010482b:	74 da                	je     80104807 <acquire+0x87>
8010482d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104830:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104836:	83 c0 08             	add    $0x8,%eax
    pcs[i] = 0;
80104839:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(; i < 10; i++)
80104840:	39 c1                	cmp    %eax,%ecx
80104842:	75 ec                	jne    80104830 <acquire+0xb0>
80104844:	eb c1                	jmp    80104807 <acquire+0x87>
80104846:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010484d:	00 
8010484e:	66 90                	xchg   %ax,%ax
  r = lock->locked && lock->cpu == mycpu();
80104850:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104853:	e8 d8 f1 ff ff       	call   80103a30 <mycpu>
80104858:	39 c3                	cmp    %eax,%ebx
8010485a:	0f 85 3e ff ff ff    	jne    8010479e <acquire+0x1e>
  popcli();
80104860:	e8 1b fe ff ff       	call   80104680 <popcli>
    panic("acquire");
80104865:	83 ec 0c             	sub    $0xc,%esp
80104868:	68 da 7c 10 80       	push   $0x80107cda
8010486d:	e8 0e bb ff ff       	call   80100380 <panic>
80104872:	66 90                	xchg   %ax,%ax
80104874:	66 90                	xchg   %ax,%ax
80104876:	66 90                	xchg   %ax,%ax
80104878:	66 90                	xchg   %ax,%ax
8010487a:	66 90                	xchg   %ax,%ax
8010487c:	66 90                	xchg   %ax,%ax
8010487e:	66 90                	xchg   %ax,%ax

80104880 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104880:	55                   	push   %ebp
80104881:	89 e5                	mov    %esp,%ebp
80104883:	57                   	push   %edi
80104884:	8b 55 08             	mov    0x8(%ebp),%edx
80104887:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010488a:	89 d0                	mov    %edx,%eax
8010488c:	09 c8                	or     %ecx,%eax
8010488e:	a8 03                	test   $0x3,%al
80104890:	75 1e                	jne    801048b0 <memset+0x30>
    c &= 0xFF;
80104892:	0f b6 45 0c          	movzbl 0xc(%ebp),%eax
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104896:	c1 e9 02             	shr    $0x2,%ecx
  asm volatile("cld; rep stosl" :
80104899:	89 d7                	mov    %edx,%edi
8010489b:	69 c0 01 01 01 01    	imul   $0x1010101,%eax,%eax
801048a1:	fc                   	cld
801048a2:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801048a4:	8b 7d fc             	mov    -0x4(%ebp),%edi
801048a7:	89 d0                	mov    %edx,%eax
801048a9:	c9                   	leave
801048aa:	c3                   	ret
801048ab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
801048b0:	8b 45 0c             	mov    0xc(%ebp),%eax
801048b3:	89 d7                	mov    %edx,%edi
801048b5:	fc                   	cld
801048b6:	f3 aa                	rep stos %al,%es:(%edi)
801048b8:	8b 7d fc             	mov    -0x4(%ebp),%edi
801048bb:	89 d0                	mov    %edx,%eax
801048bd:	c9                   	leave
801048be:	c3                   	ret
801048bf:	90                   	nop

801048c0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801048c0:	55                   	push   %ebp
801048c1:	89 e5                	mov    %esp,%ebp
801048c3:	56                   	push   %esi
801048c4:	8b 75 10             	mov    0x10(%ebp),%esi
801048c7:	8b 45 08             	mov    0x8(%ebp),%eax
801048ca:	53                   	push   %ebx
801048cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801048ce:	85 f6                	test   %esi,%esi
801048d0:	74 2e                	je     80104900 <memcmp+0x40>
801048d2:	01 c6                	add    %eax,%esi
801048d4:	eb 14                	jmp    801048ea <memcmp+0x2a>
801048d6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801048dd:	00 
801048de:	66 90                	xchg   %ax,%ax
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
801048e0:	83 c0 01             	add    $0x1,%eax
801048e3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
801048e6:	39 f0                	cmp    %esi,%eax
801048e8:	74 16                	je     80104900 <memcmp+0x40>
    if(*s1 != *s2)
801048ea:	0f b6 08             	movzbl (%eax),%ecx
801048ed:	0f b6 1a             	movzbl (%edx),%ebx
801048f0:	38 d9                	cmp    %bl,%cl
801048f2:	74 ec                	je     801048e0 <memcmp+0x20>
      return *s1 - *s2;
801048f4:	0f b6 c1             	movzbl %cl,%eax
801048f7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
801048f9:	5b                   	pop    %ebx
801048fa:	5e                   	pop    %esi
801048fb:	5d                   	pop    %ebp
801048fc:	c3                   	ret
801048fd:	8d 76 00             	lea    0x0(%esi),%esi
80104900:	5b                   	pop    %ebx
  return 0;
80104901:	31 c0                	xor    %eax,%eax
}
80104903:	5e                   	pop    %esi
80104904:	5d                   	pop    %ebp
80104905:	c3                   	ret
80104906:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010490d:	00 
8010490e:	66 90                	xchg   %ax,%ax

80104910 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104910:	55                   	push   %ebp
80104911:	89 e5                	mov    %esp,%ebp
80104913:	57                   	push   %edi
80104914:	8b 55 08             	mov    0x8(%ebp),%edx
80104917:	8b 45 10             	mov    0x10(%ebp),%eax
8010491a:	56                   	push   %esi
8010491b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010491e:	39 d6                	cmp    %edx,%esi
80104920:	73 26                	jae    80104948 <memmove+0x38>
80104922:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
80104925:	39 ca                	cmp    %ecx,%edx
80104927:	73 1f                	jae    80104948 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104929:	85 c0                	test   %eax,%eax
8010492b:	74 0f                	je     8010493c <memmove+0x2c>
8010492d:	83 e8 01             	sub    $0x1,%eax
      *--d = *--s;
80104930:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104934:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104937:	83 e8 01             	sub    $0x1,%eax
8010493a:	73 f4                	jae    80104930 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010493c:	5e                   	pop    %esi
8010493d:	89 d0                	mov    %edx,%eax
8010493f:	5f                   	pop    %edi
80104940:	5d                   	pop    %ebp
80104941:	c3                   	ret
80104942:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104948:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
8010494b:	89 d7                	mov    %edx,%edi
8010494d:	85 c0                	test   %eax,%eax
8010494f:	74 eb                	je     8010493c <memmove+0x2c>
80104951:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104958:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104959:	39 ce                	cmp    %ecx,%esi
8010495b:	75 fb                	jne    80104958 <memmove+0x48>
}
8010495d:	5e                   	pop    %esi
8010495e:	89 d0                	mov    %edx,%eax
80104960:	5f                   	pop    %edi
80104961:	5d                   	pop    %ebp
80104962:	c3                   	ret
80104963:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010496a:	00 
8010496b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80104970 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104970:	eb 9e                	jmp    80104910 <memmove>
80104972:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104979:	00 
8010497a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104980 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
80104983:	53                   	push   %ebx
80104984:	8b 55 10             	mov    0x10(%ebp),%edx
80104987:	8b 45 08             	mov    0x8(%ebp),%eax
8010498a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(n > 0 && *p && *p == *q)
8010498d:	85 d2                	test   %edx,%edx
8010498f:	75 16                	jne    801049a7 <strncmp+0x27>
80104991:	eb 2d                	jmp    801049c0 <strncmp+0x40>
80104993:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104998:	3a 19                	cmp    (%ecx),%bl
8010499a:	75 12                	jne    801049ae <strncmp+0x2e>
    n--, p++, q++;
8010499c:	83 c0 01             	add    $0x1,%eax
8010499f:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
801049a2:	83 ea 01             	sub    $0x1,%edx
801049a5:	74 19                	je     801049c0 <strncmp+0x40>
801049a7:	0f b6 18             	movzbl (%eax),%ebx
801049aa:	84 db                	test   %bl,%bl
801049ac:	75 ea                	jne    80104998 <strncmp+0x18>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801049ae:	0f b6 00             	movzbl (%eax),%eax
801049b1:	0f b6 11             	movzbl (%ecx),%edx
}
801049b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049b7:	c9                   	leave
  return (uchar)*p - (uchar)*q;
801049b8:	29 d0                	sub    %edx,%eax
}
801049ba:	c3                   	ret
801049bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
801049c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
801049c3:	31 c0                	xor    %eax,%eax
}
801049c5:	c9                   	leave
801049c6:	c3                   	ret
801049c7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801049ce:	00 
801049cf:	90                   	nop

801049d0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801049d0:	55                   	push   %ebp
801049d1:	89 e5                	mov    %esp,%ebp
801049d3:	57                   	push   %edi
801049d4:	56                   	push   %esi
801049d5:	8b 75 08             	mov    0x8(%ebp),%esi
801049d8:	53                   	push   %ebx
801049d9:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801049dc:	89 f0                	mov    %esi,%eax
801049de:	eb 15                	jmp    801049f5 <strncpy+0x25>
801049e0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801049e4:	8b 7d 0c             	mov    0xc(%ebp),%edi
801049e7:	83 c0 01             	add    $0x1,%eax
801049ea:	0f b6 4f ff          	movzbl -0x1(%edi),%ecx
801049ee:	88 48 ff             	mov    %cl,-0x1(%eax)
801049f1:	84 c9                	test   %cl,%cl
801049f3:	74 13                	je     80104a08 <strncpy+0x38>
801049f5:	89 d3                	mov    %edx,%ebx
801049f7:	83 ea 01             	sub    $0x1,%edx
801049fa:	85 db                	test   %ebx,%ebx
801049fc:	7f e2                	jg     801049e0 <strncpy+0x10>
    ;
  while(n-- > 0)
    *s++ = 0;
  return os;
}
801049fe:	5b                   	pop    %ebx
801049ff:	89 f0                	mov    %esi,%eax
80104a01:	5e                   	pop    %esi
80104a02:	5f                   	pop    %edi
80104a03:	5d                   	pop    %ebp
80104a04:	c3                   	ret
80104a05:	8d 76 00             	lea    0x0(%esi),%esi
  while(n-- > 0)
80104a08:	8d 0c 18             	lea    (%eax,%ebx,1),%ecx
80104a0b:	83 e9 01             	sub    $0x1,%ecx
80104a0e:	85 d2                	test   %edx,%edx
80104a10:	74 ec                	je     801049fe <strncpy+0x2e>
80104a12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *s++ = 0;
80104a18:	83 c0 01             	add    $0x1,%eax
80104a1b:	89 ca                	mov    %ecx,%edx
80104a1d:	c6 40 ff 00          	movb   $0x0,-0x1(%eax)
  while(n-- > 0)
80104a21:	29 c2                	sub    %eax,%edx
80104a23:	85 d2                	test   %edx,%edx
80104a25:	7f f1                	jg     80104a18 <strncpy+0x48>
}
80104a27:	5b                   	pop    %ebx
80104a28:	89 f0                	mov    %esi,%eax
80104a2a:	5e                   	pop    %esi
80104a2b:	5f                   	pop    %edi
80104a2c:	5d                   	pop    %ebp
80104a2d:	c3                   	ret
80104a2e:	66 90                	xchg   %ax,%ax

80104a30 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104a30:	55                   	push   %ebp
80104a31:	89 e5                	mov    %esp,%ebp
80104a33:	56                   	push   %esi
80104a34:	8b 55 10             	mov    0x10(%ebp),%edx
80104a37:	8b 75 08             	mov    0x8(%ebp),%esi
80104a3a:	53                   	push   %ebx
80104a3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104a3e:	85 d2                	test   %edx,%edx
80104a40:	7e 25                	jle    80104a67 <safestrcpy+0x37>
80104a42:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104a46:	89 f2                	mov    %esi,%edx
80104a48:	eb 16                	jmp    80104a60 <safestrcpy+0x30>
80104a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104a50:	0f b6 08             	movzbl (%eax),%ecx
80104a53:	83 c0 01             	add    $0x1,%eax
80104a56:	83 c2 01             	add    $0x1,%edx
80104a59:	88 4a ff             	mov    %cl,-0x1(%edx)
80104a5c:	84 c9                	test   %cl,%cl
80104a5e:	74 04                	je     80104a64 <safestrcpy+0x34>
80104a60:	39 d8                	cmp    %ebx,%eax
80104a62:	75 ec                	jne    80104a50 <safestrcpy+0x20>
    ;
  *s = 0;
80104a64:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104a67:	89 f0                	mov    %esi,%eax
80104a69:	5b                   	pop    %ebx
80104a6a:	5e                   	pop    %esi
80104a6b:	5d                   	pop    %ebp
80104a6c:	c3                   	ret
80104a6d:	8d 76 00             	lea    0x0(%esi),%esi

80104a70 <strlen>:

int
strlen(const char *s)
{
80104a70:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104a71:	31 c0                	xor    %eax,%eax
{
80104a73:	89 e5                	mov    %esp,%ebp
80104a75:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104a78:	80 3a 00             	cmpb   $0x0,(%edx)
80104a7b:	74 0c                	je     80104a89 <strlen+0x19>
80104a7d:	8d 76 00             	lea    0x0(%esi),%esi
80104a80:	83 c0 01             	add    $0x1,%eax
80104a83:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104a87:	75 f7                	jne    80104a80 <strlen+0x10>
    ;
  return n;
}
80104a89:	5d                   	pop    %ebp
80104a8a:	c3                   	ret

80104a8b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104a8b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104a8f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104a93:	55                   	push   %ebp
  pushl %ebx
80104a94:	53                   	push   %ebx
  pushl %esi
80104a95:	56                   	push   %esi
  pushl %edi
80104a96:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104a97:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104a99:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104a9b:	5f                   	pop    %edi
  popl %esi
80104a9c:	5e                   	pop    %esi
  popl %ebx
80104a9d:	5b                   	pop    %ebx
  popl %ebp
80104a9e:	5d                   	pop    %ebp
  ret
80104a9f:	c3                   	ret

80104aa0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104aa0:	55                   	push   %ebp
80104aa1:	89 e5                	mov    %esp,%ebp
80104aa3:	53                   	push   %ebx
80104aa4:	83 ec 04             	sub    $0x4,%esp
80104aa7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104aaa:	e8 01 f0 ff ff       	call   80103ab0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104aaf:	8b 00                	mov    (%eax),%eax
80104ab1:	39 c3                	cmp    %eax,%ebx
80104ab3:	73 1b                	jae    80104ad0 <fetchint+0x30>
80104ab5:	8d 53 04             	lea    0x4(%ebx),%edx
80104ab8:	39 d0                	cmp    %edx,%eax
80104aba:	72 14                	jb     80104ad0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104abc:	8b 45 0c             	mov    0xc(%ebp),%eax
80104abf:	8b 13                	mov    (%ebx),%edx
80104ac1:	89 10                	mov    %edx,(%eax)
  return 0;
80104ac3:	31 c0                	xor    %eax,%eax
}
80104ac5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ac8:	c9                   	leave
80104ac9:	c3                   	ret
80104aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104ad0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ad5:	eb ee                	jmp    80104ac5 <fetchint+0x25>
80104ad7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104ade:	00 
80104adf:	90                   	nop

80104ae0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104ae0:	55                   	push   %ebp
80104ae1:	89 e5                	mov    %esp,%ebp
80104ae3:	53                   	push   %ebx
80104ae4:	83 ec 04             	sub    $0x4,%esp
80104ae7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104aea:	e8 c1 ef ff ff       	call   80103ab0 <myproc>

  if(addr >= curproc->sz)
80104aef:	3b 18                	cmp    (%eax),%ebx
80104af1:	73 2d                	jae    80104b20 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104af3:	8b 55 0c             	mov    0xc(%ebp),%edx
80104af6:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104af8:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104afa:	39 d3                	cmp    %edx,%ebx
80104afc:	73 22                	jae    80104b20 <fetchstr+0x40>
80104afe:	89 d8                	mov    %ebx,%eax
80104b00:	eb 0d                	jmp    80104b0f <fetchstr+0x2f>
80104b02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104b08:	83 c0 01             	add    $0x1,%eax
80104b0b:	39 d0                	cmp    %edx,%eax
80104b0d:	73 11                	jae    80104b20 <fetchstr+0x40>
    if(*s == 0)
80104b0f:	80 38 00             	cmpb   $0x0,(%eax)
80104b12:	75 f4                	jne    80104b08 <fetchstr+0x28>
      return s - *pp;
80104b14:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104b16:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104b19:	c9                   	leave
80104b1a:	c3                   	ret
80104b1b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b20:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104b23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b28:	c9                   	leave
80104b29:	c3                   	ret
80104b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b30 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104b30:	55                   	push   %ebp
80104b31:	89 e5                	mov    %esp,%ebp
80104b33:	56                   	push   %esi
80104b34:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b35:	e8 76 ef ff ff       	call   80103ab0 <myproc>
80104b3a:	8b 55 08             	mov    0x8(%ebp),%edx
80104b3d:	8b 40 18             	mov    0x18(%eax),%eax
80104b40:	8b 40 44             	mov    0x44(%eax),%eax
80104b43:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104b46:	e8 65 ef ff ff       	call   80103ab0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b4b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b4e:	8b 00                	mov    (%eax),%eax
80104b50:	39 c6                	cmp    %eax,%esi
80104b52:	73 1c                	jae    80104b70 <argint+0x40>
80104b54:	8d 53 08             	lea    0x8(%ebx),%edx
80104b57:	39 d0                	cmp    %edx,%eax
80104b59:	72 15                	jb     80104b70 <argint+0x40>
  *ip = *(int*)(addr);
80104b5b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b5e:	8b 53 04             	mov    0x4(%ebx),%edx
80104b61:	89 10                	mov    %edx,(%eax)
  return 0;
80104b63:	31 c0                	xor    %eax,%eax
}
80104b65:	5b                   	pop    %ebx
80104b66:	5e                   	pop    %esi
80104b67:	5d                   	pop    %ebp
80104b68:	c3                   	ret
80104b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104b70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b75:	eb ee                	jmp    80104b65 <argint+0x35>
80104b77:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104b7e:	00 
80104b7f:	90                   	nop

80104b80 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104b80:	55                   	push   %ebp
80104b81:	89 e5                	mov    %esp,%ebp
80104b83:	57                   	push   %edi
80104b84:	56                   	push   %esi
80104b85:	53                   	push   %ebx
80104b86:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104b89:	e8 22 ef ff ff       	call   80103ab0 <myproc>
80104b8e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104b90:	e8 1b ef ff ff       	call   80103ab0 <myproc>
80104b95:	8b 55 08             	mov    0x8(%ebp),%edx
80104b98:	8b 40 18             	mov    0x18(%eax),%eax
80104b9b:	8b 40 44             	mov    0x44(%eax),%eax
80104b9e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104ba1:	e8 0a ef ff ff       	call   80103ab0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ba6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104ba9:	8b 00                	mov    (%eax),%eax
80104bab:	39 c7                	cmp    %eax,%edi
80104bad:	73 31                	jae    80104be0 <argptr+0x60>
80104baf:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104bb2:	39 c8                	cmp    %ecx,%eax
80104bb4:	72 2a                	jb     80104be0 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104bb6:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104bb9:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104bbc:	85 d2                	test   %edx,%edx
80104bbe:	78 20                	js     80104be0 <argptr+0x60>
80104bc0:	8b 16                	mov    (%esi),%edx
80104bc2:	39 d0                	cmp    %edx,%eax
80104bc4:	73 1a                	jae    80104be0 <argptr+0x60>
80104bc6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104bc9:	01 c3                	add    %eax,%ebx
80104bcb:	39 da                	cmp    %ebx,%edx
80104bcd:	72 11                	jb     80104be0 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104bcf:	8b 55 0c             	mov    0xc(%ebp),%edx
80104bd2:	89 02                	mov    %eax,(%edx)
  return 0;
80104bd4:	31 c0                	xor    %eax,%eax
}
80104bd6:	83 c4 0c             	add    $0xc,%esp
80104bd9:	5b                   	pop    %ebx
80104bda:	5e                   	pop    %esi
80104bdb:	5f                   	pop    %edi
80104bdc:	5d                   	pop    %ebp
80104bdd:	c3                   	ret
80104bde:	66 90                	xchg   %ax,%ax
    return -1;
80104be0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104be5:	eb ef                	jmp    80104bd6 <argptr+0x56>
80104be7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104bee:	00 
80104bef:	90                   	nop

80104bf0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104bf0:	55                   	push   %ebp
80104bf1:	89 e5                	mov    %esp,%ebp
80104bf3:	56                   	push   %esi
80104bf4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bf5:	e8 b6 ee ff ff       	call   80103ab0 <myproc>
80104bfa:	8b 55 08             	mov    0x8(%ebp),%edx
80104bfd:	8b 40 18             	mov    0x18(%eax),%eax
80104c00:	8b 40 44             	mov    0x44(%eax),%eax
80104c03:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c06:	e8 a5 ee ff ff       	call   80103ab0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c0b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c0e:	8b 00                	mov    (%eax),%eax
80104c10:	39 c6                	cmp    %eax,%esi
80104c12:	73 44                	jae    80104c58 <argstr+0x68>
80104c14:	8d 53 08             	lea    0x8(%ebx),%edx
80104c17:	39 d0                	cmp    %edx,%eax
80104c19:	72 3d                	jb     80104c58 <argstr+0x68>
  *ip = *(int*)(addr);
80104c1b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104c1e:	e8 8d ee ff ff       	call   80103ab0 <myproc>
  if(addr >= curproc->sz)
80104c23:	3b 18                	cmp    (%eax),%ebx
80104c25:	73 31                	jae    80104c58 <argstr+0x68>
  *pp = (char*)addr;
80104c27:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c2a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104c2c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104c2e:	39 d3                	cmp    %edx,%ebx
80104c30:	73 26                	jae    80104c58 <argstr+0x68>
80104c32:	89 d8                	mov    %ebx,%eax
80104c34:	eb 11                	jmp    80104c47 <argstr+0x57>
80104c36:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c3d:	00 
80104c3e:	66 90                	xchg   %ax,%ax
80104c40:	83 c0 01             	add    $0x1,%eax
80104c43:	39 d0                	cmp    %edx,%eax
80104c45:	73 11                	jae    80104c58 <argstr+0x68>
    if(*s == 0)
80104c47:	80 38 00             	cmpb   $0x0,(%eax)
80104c4a:	75 f4                	jne    80104c40 <argstr+0x50>
      return s - *pp;
80104c4c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104c4e:	5b                   	pop    %ebx
80104c4f:	5e                   	pop    %esi
80104c50:	5d                   	pop    %ebp
80104c51:	c3                   	ret
80104c52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c58:	5b                   	pop    %ebx
    return -1;
80104c59:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c5e:	5e                   	pop    %esi
80104c5f:	5d                   	pop    %ebp
80104c60:	c3                   	ret
80104c61:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104c68:	00 
80104c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104c70 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
80104c73:	53                   	push   %ebx
80104c74:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104c77:	e8 34 ee ff ff       	call   80103ab0 <myproc>
80104c7c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104c7e:	8b 40 18             	mov    0x18(%eax),%eax
80104c81:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104c84:	8d 50 ff             	lea    -0x1(%eax),%edx
80104c87:	83 fa 14             	cmp    $0x14,%edx
80104c8a:	77 24                	ja     80104cb0 <syscall+0x40>
80104c8c:	8b 14 85 00 83 10 80 	mov    -0x7fef7d00(,%eax,4),%edx
80104c93:	85 d2                	test   %edx,%edx
80104c95:	74 19                	je     80104cb0 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80104c97:	ff d2                	call   *%edx
80104c99:	89 c2                	mov    %eax,%edx
80104c9b:	8b 43 18             	mov    0x18(%ebx),%eax
80104c9e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104ca1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ca4:	c9                   	leave
80104ca5:	c3                   	ret
80104ca6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104cad:	00 
80104cae:	66 90                	xchg   %ax,%ax
    cprintf("%d %s: unknown sys call %d\n",
80104cb0:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104cb1:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104cb4:	50                   	push   %eax
80104cb5:	ff 73 10             	push   0x10(%ebx)
80104cb8:	68 e2 7c 10 80       	push   $0x80107ce2
80104cbd:	e8 ee b9 ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80104cc2:	8b 43 18             	mov    0x18(%ebx),%eax
80104cc5:	83 c4 10             	add    $0x10,%esp
80104cc8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104ccf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cd2:	c9                   	leave
80104cd3:	c3                   	ret
80104cd4:	66 90                	xchg   %ax,%ax
80104cd6:	66 90                	xchg   %ax,%ax
80104cd8:	66 90                	xchg   %ax,%ax
80104cda:	66 90                	xchg   %ax,%ax
80104cdc:	66 90                	xchg   %ax,%ax
80104cde:	66 90                	xchg   %ax,%ax

80104ce0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104ce0:	55                   	push   %ebp
80104ce1:	89 e5                	mov    %esp,%ebp
80104ce3:	57                   	push   %edi
80104ce4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104ce5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104ce8:	53                   	push   %ebx
80104ce9:	83 ec 34             	sub    $0x34,%esp
80104cec:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104cef:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104cf2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104cf5:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104cf8:	57                   	push   %edi
80104cf9:	50                   	push   %eax
80104cfa:	e8 21 d4 ff ff       	call   80102120 <nameiparent>
80104cff:	83 c4 10             	add    $0x10,%esp
80104d02:	85 c0                	test   %eax,%eax
80104d04:	74 5e                	je     80104d64 <create+0x84>
    return 0;
  ilock(dp);
80104d06:	83 ec 0c             	sub    $0xc,%esp
80104d09:	89 c3                	mov    %eax,%ebx
80104d0b:	50                   	push   %eax
80104d0c:	e8 0f cb ff ff       	call   80101820 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104d11:	83 c4 0c             	add    $0xc,%esp
80104d14:	6a 00                	push   $0x0
80104d16:	57                   	push   %edi
80104d17:	53                   	push   %ebx
80104d18:	e8 53 d0 ff ff       	call   80101d70 <dirlookup>
80104d1d:	83 c4 10             	add    $0x10,%esp
80104d20:	89 c6                	mov    %eax,%esi
80104d22:	85 c0                	test   %eax,%eax
80104d24:	74 4a                	je     80104d70 <create+0x90>
    iunlockput(dp);
80104d26:	83 ec 0c             	sub    $0xc,%esp
80104d29:	53                   	push   %ebx
80104d2a:	e8 81 cd ff ff       	call   80101ab0 <iunlockput>
    ilock(ip);
80104d2f:	89 34 24             	mov    %esi,(%esp)
80104d32:	e8 e9 ca ff ff       	call   80101820 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104d37:	83 c4 10             	add    $0x10,%esp
80104d3a:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104d3f:	75 17                	jne    80104d58 <create+0x78>
80104d41:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104d46:	75 10                	jne    80104d58 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104d48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d4b:	89 f0                	mov    %esi,%eax
80104d4d:	5b                   	pop    %ebx
80104d4e:	5e                   	pop    %esi
80104d4f:	5f                   	pop    %edi
80104d50:	5d                   	pop    %ebp
80104d51:	c3                   	ret
80104d52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80104d58:	83 ec 0c             	sub    $0xc,%esp
80104d5b:	56                   	push   %esi
80104d5c:	e8 4f cd ff ff       	call   80101ab0 <iunlockput>
    return 0;
80104d61:	83 c4 10             	add    $0x10,%esp
}
80104d64:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104d67:	31 f6                	xor    %esi,%esi
}
80104d69:	5b                   	pop    %ebx
80104d6a:	89 f0                	mov    %esi,%eax
80104d6c:	5e                   	pop    %esi
80104d6d:	5f                   	pop    %edi
80104d6e:	5d                   	pop    %ebp
80104d6f:	c3                   	ret
  if((ip = ialloc(dp->dev, type)) == 0)
80104d70:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104d74:	83 ec 08             	sub    $0x8,%esp
80104d77:	50                   	push   %eax
80104d78:	ff 33                	push   (%ebx)
80104d7a:	e8 31 c9 ff ff       	call   801016b0 <ialloc>
80104d7f:	83 c4 10             	add    $0x10,%esp
80104d82:	89 c6                	mov    %eax,%esi
80104d84:	85 c0                	test   %eax,%eax
80104d86:	0f 84 bc 00 00 00    	je     80104e48 <create+0x168>
  ilock(ip);
80104d8c:	83 ec 0c             	sub    $0xc,%esp
80104d8f:	50                   	push   %eax
80104d90:	e8 8b ca ff ff       	call   80101820 <ilock>
  ip->major = major;
80104d95:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104d99:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104d9d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104da1:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104da5:	b8 01 00 00 00       	mov    $0x1,%eax
80104daa:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104dae:	89 34 24             	mov    %esi,(%esp)
80104db1:	e8 ba c9 ff ff       	call   80101770 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104db6:	83 c4 10             	add    $0x10,%esp
80104db9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104dbe:	74 30                	je     80104df0 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
80104dc0:	83 ec 04             	sub    $0x4,%esp
80104dc3:	ff 76 04             	push   0x4(%esi)
80104dc6:	57                   	push   %edi
80104dc7:	53                   	push   %ebx
80104dc8:	e8 73 d2 ff ff       	call   80102040 <dirlink>
80104dcd:	83 c4 10             	add    $0x10,%esp
80104dd0:	85 c0                	test   %eax,%eax
80104dd2:	78 67                	js     80104e3b <create+0x15b>
  iunlockput(dp);
80104dd4:	83 ec 0c             	sub    $0xc,%esp
80104dd7:	53                   	push   %ebx
80104dd8:	e8 d3 cc ff ff       	call   80101ab0 <iunlockput>
  return ip;
80104ddd:	83 c4 10             	add    $0x10,%esp
}
80104de0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104de3:	89 f0                	mov    %esi,%eax
80104de5:	5b                   	pop    %ebx
80104de6:	5e                   	pop    %esi
80104de7:	5f                   	pop    %edi
80104de8:	5d                   	pop    %ebp
80104de9:	c3                   	ret
80104dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104df0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104df3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104df8:	53                   	push   %ebx
80104df9:	e8 72 c9 ff ff       	call   80101770 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104dfe:	83 c4 0c             	add    $0xc,%esp
80104e01:	ff 76 04             	push   0x4(%esi)
80104e04:	68 1a 7d 10 80       	push   $0x80107d1a
80104e09:	56                   	push   %esi
80104e0a:	e8 31 d2 ff ff       	call   80102040 <dirlink>
80104e0f:	83 c4 10             	add    $0x10,%esp
80104e12:	85 c0                	test   %eax,%eax
80104e14:	78 18                	js     80104e2e <create+0x14e>
80104e16:	83 ec 04             	sub    $0x4,%esp
80104e19:	ff 73 04             	push   0x4(%ebx)
80104e1c:	68 19 7d 10 80       	push   $0x80107d19
80104e21:	56                   	push   %esi
80104e22:	e8 19 d2 ff ff       	call   80102040 <dirlink>
80104e27:	83 c4 10             	add    $0x10,%esp
80104e2a:	85 c0                	test   %eax,%eax
80104e2c:	79 92                	jns    80104dc0 <create+0xe0>
      panic("create dots");
80104e2e:	83 ec 0c             	sub    $0xc,%esp
80104e31:	68 0d 7d 10 80       	push   $0x80107d0d
80104e36:	e8 45 b5 ff ff       	call   80100380 <panic>
    panic("create: dirlink");
80104e3b:	83 ec 0c             	sub    $0xc,%esp
80104e3e:	68 1c 7d 10 80       	push   $0x80107d1c
80104e43:	e8 38 b5 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104e48:	83 ec 0c             	sub    $0xc,%esp
80104e4b:	68 fe 7c 10 80       	push   $0x80107cfe
80104e50:	e8 2b b5 ff ff       	call   80100380 <panic>
80104e55:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104e5c:	00 
80104e5d:	8d 76 00             	lea    0x0(%esi),%esi

80104e60 <sys_dup>:
{
80104e60:	55                   	push   %ebp
80104e61:	89 e5                	mov    %esp,%ebp
80104e63:	56                   	push   %esi
80104e64:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104e65:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104e68:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104e6b:	50                   	push   %eax
80104e6c:	6a 00                	push   $0x0
80104e6e:	e8 bd fc ff ff       	call   80104b30 <argint>
80104e73:	83 c4 10             	add    $0x10,%esp
80104e76:	85 c0                	test   %eax,%eax
80104e78:	78 36                	js     80104eb0 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104e7a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104e7e:	77 30                	ja     80104eb0 <sys_dup+0x50>
80104e80:	e8 2b ec ff ff       	call   80103ab0 <myproc>
80104e85:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104e88:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104e8c:	85 f6                	test   %esi,%esi
80104e8e:	74 20                	je     80104eb0 <sys_dup+0x50>
  struct proc *curproc = myproc();
80104e90:	e8 1b ec ff ff       	call   80103ab0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80104e95:	31 db                	xor    %ebx,%ebx
80104e97:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80104e9e:	00 
80104e9f:	90                   	nop
    if(curproc->ofile[fd] == 0){
80104ea0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104ea4:	85 d2                	test   %edx,%edx
80104ea6:	74 18                	je     80104ec0 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80104ea8:	83 c3 01             	add    $0x1,%ebx
80104eab:	83 fb 10             	cmp    $0x10,%ebx
80104eae:	75 f0                	jne    80104ea0 <sys_dup+0x40>
}
80104eb0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104eb3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104eb8:	89 d8                	mov    %ebx,%eax
80104eba:	5b                   	pop    %ebx
80104ebb:	5e                   	pop    %esi
80104ebc:	5d                   	pop    %ebp
80104ebd:	c3                   	ret
80104ebe:	66 90                	xchg   %ax,%ax
  filedup(f);
80104ec0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80104ec3:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80104ec7:	56                   	push   %esi
80104ec8:	e8 73 c0 ff ff       	call   80100f40 <filedup>
  return fd;
80104ecd:	83 c4 10             	add    $0x10,%esp
}
80104ed0:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ed3:	89 d8                	mov    %ebx,%eax
80104ed5:	5b                   	pop    %ebx
80104ed6:	5e                   	pop    %esi
80104ed7:	5d                   	pop    %ebp
80104ed8:	c3                   	ret
80104ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ee0 <sys_read>:
{
80104ee0:	55                   	push   %ebp
80104ee1:	89 e5                	mov    %esp,%ebp
80104ee3:	56                   	push   %esi
80104ee4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104ee5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104ee8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104eeb:	53                   	push   %ebx
80104eec:	6a 00                	push   $0x0
80104eee:	e8 3d fc ff ff       	call   80104b30 <argint>
80104ef3:	83 c4 10             	add    $0x10,%esp
80104ef6:	85 c0                	test   %eax,%eax
80104ef8:	78 5e                	js     80104f58 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104efa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104efe:	77 58                	ja     80104f58 <sys_read+0x78>
80104f00:	e8 ab eb ff ff       	call   80103ab0 <myproc>
80104f05:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f08:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104f0c:	85 f6                	test   %esi,%esi
80104f0e:	74 48                	je     80104f58 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f10:	83 ec 08             	sub    $0x8,%esp
80104f13:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f16:	50                   	push   %eax
80104f17:	6a 02                	push   $0x2
80104f19:	e8 12 fc ff ff       	call   80104b30 <argint>
80104f1e:	83 c4 10             	add    $0x10,%esp
80104f21:	85 c0                	test   %eax,%eax
80104f23:	78 33                	js     80104f58 <sys_read+0x78>
80104f25:	83 ec 04             	sub    $0x4,%esp
80104f28:	ff 75 f0             	push   -0x10(%ebp)
80104f2b:	53                   	push   %ebx
80104f2c:	6a 01                	push   $0x1
80104f2e:	e8 4d fc ff ff       	call   80104b80 <argptr>
80104f33:	83 c4 10             	add    $0x10,%esp
80104f36:	85 c0                	test   %eax,%eax
80104f38:	78 1e                	js     80104f58 <sys_read+0x78>
  return fileread(f, p, n);
80104f3a:	83 ec 04             	sub    $0x4,%esp
80104f3d:	ff 75 f0             	push   -0x10(%ebp)
80104f40:	ff 75 f4             	push   -0xc(%ebp)
80104f43:	56                   	push   %esi
80104f44:	e8 77 c1 ff ff       	call   801010c0 <fileread>
80104f49:	83 c4 10             	add    $0x10,%esp
}
80104f4c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f4f:	5b                   	pop    %ebx
80104f50:	5e                   	pop    %esi
80104f51:	5d                   	pop    %ebp
80104f52:	c3                   	ret
80104f53:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80104f58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f5d:	eb ed                	jmp    80104f4c <sys_read+0x6c>
80104f5f:	90                   	nop

80104f60 <sys_write>:
{
80104f60:	55                   	push   %ebp
80104f61:	89 e5                	mov    %esp,%ebp
80104f63:	56                   	push   %esi
80104f64:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104f65:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80104f68:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104f6b:	53                   	push   %ebx
80104f6c:	6a 00                	push   $0x0
80104f6e:	e8 bd fb ff ff       	call   80104b30 <argint>
80104f73:	83 c4 10             	add    $0x10,%esp
80104f76:	85 c0                	test   %eax,%eax
80104f78:	78 5e                	js     80104fd8 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f7a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f7e:	77 58                	ja     80104fd8 <sys_write+0x78>
80104f80:	e8 2b eb ff ff       	call   80103ab0 <myproc>
80104f85:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f88:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
80104f8c:	85 f6                	test   %esi,%esi
80104f8e:	74 48                	je     80104fd8 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104f90:	83 ec 08             	sub    $0x8,%esp
80104f93:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104f96:	50                   	push   %eax
80104f97:	6a 02                	push   $0x2
80104f99:	e8 92 fb ff ff       	call   80104b30 <argint>
80104f9e:	83 c4 10             	add    $0x10,%esp
80104fa1:	85 c0                	test   %eax,%eax
80104fa3:	78 33                	js     80104fd8 <sys_write+0x78>
80104fa5:	83 ec 04             	sub    $0x4,%esp
80104fa8:	ff 75 f0             	push   -0x10(%ebp)
80104fab:	53                   	push   %ebx
80104fac:	6a 01                	push   $0x1
80104fae:	e8 cd fb ff ff       	call   80104b80 <argptr>
80104fb3:	83 c4 10             	add    $0x10,%esp
80104fb6:	85 c0                	test   %eax,%eax
80104fb8:	78 1e                	js     80104fd8 <sys_write+0x78>
  return filewrite(f, p, n);
80104fba:	83 ec 04             	sub    $0x4,%esp
80104fbd:	ff 75 f0             	push   -0x10(%ebp)
80104fc0:	ff 75 f4             	push   -0xc(%ebp)
80104fc3:	56                   	push   %esi
80104fc4:	e8 87 c1 ff ff       	call   80101150 <filewrite>
80104fc9:	83 c4 10             	add    $0x10,%esp
}
80104fcc:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104fcf:	5b                   	pop    %ebx
80104fd0:	5e                   	pop    %esi
80104fd1:	5d                   	pop    %ebp
80104fd2:	c3                   	ret
80104fd3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    return -1;
80104fd8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fdd:	eb ed                	jmp    80104fcc <sys_write+0x6c>
80104fdf:	90                   	nop

80104fe0 <sys_close>:
{
80104fe0:	55                   	push   %ebp
80104fe1:	89 e5                	mov    %esp,%ebp
80104fe3:	56                   	push   %esi
80104fe4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80104fe5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80104fe8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104feb:	50                   	push   %eax
80104fec:	6a 00                	push   $0x0
80104fee:	e8 3d fb ff ff       	call   80104b30 <argint>
80104ff3:	83 c4 10             	add    $0x10,%esp
80104ff6:	85 c0                	test   %eax,%eax
80104ff8:	78 3e                	js     80105038 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104ffa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104ffe:	77 38                	ja     80105038 <sys_close+0x58>
80105000:	e8 ab ea ff ff       	call   80103ab0 <myproc>
80105005:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105008:	8d 5a 08             	lea    0x8(%edx),%ebx
8010500b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
8010500f:	85 f6                	test   %esi,%esi
80105011:	74 25                	je     80105038 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105013:	e8 98 ea ff ff       	call   80103ab0 <myproc>
  fileclose(f);
80105018:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010501b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80105022:	00 
  fileclose(f);
80105023:	56                   	push   %esi
80105024:	e8 67 bf ff ff       	call   80100f90 <fileclose>
  return 0;
80105029:	83 c4 10             	add    $0x10,%esp
8010502c:	31 c0                	xor    %eax,%eax
}
8010502e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105031:	5b                   	pop    %ebx
80105032:	5e                   	pop    %esi
80105033:	5d                   	pop    %ebp
80105034:	c3                   	ret
80105035:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105038:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010503d:	eb ef                	jmp    8010502e <sys_close+0x4e>
8010503f:	90                   	nop

80105040 <sys_fstat>:
{
80105040:	55                   	push   %ebp
80105041:	89 e5                	mov    %esp,%ebp
80105043:	56                   	push   %esi
80105044:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105045:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105048:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010504b:	53                   	push   %ebx
8010504c:	6a 00                	push   $0x0
8010504e:	e8 dd fa ff ff       	call   80104b30 <argint>
80105053:	83 c4 10             	add    $0x10,%esp
80105056:	85 c0                	test   %eax,%eax
80105058:	78 46                	js     801050a0 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010505a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010505e:	77 40                	ja     801050a0 <sys_fstat+0x60>
80105060:	e8 4b ea ff ff       	call   80103ab0 <myproc>
80105065:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105068:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010506c:	85 f6                	test   %esi,%esi
8010506e:	74 30                	je     801050a0 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105070:	83 ec 04             	sub    $0x4,%esp
80105073:	6a 14                	push   $0x14
80105075:	53                   	push   %ebx
80105076:	6a 01                	push   $0x1
80105078:	e8 03 fb ff ff       	call   80104b80 <argptr>
8010507d:	83 c4 10             	add    $0x10,%esp
80105080:	85 c0                	test   %eax,%eax
80105082:	78 1c                	js     801050a0 <sys_fstat+0x60>
  return filestat(f, st);
80105084:	83 ec 08             	sub    $0x8,%esp
80105087:	ff 75 f4             	push   -0xc(%ebp)
8010508a:	56                   	push   %esi
8010508b:	e8 e0 bf ff ff       	call   80101070 <filestat>
80105090:	83 c4 10             	add    $0x10,%esp
}
80105093:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105096:	5b                   	pop    %ebx
80105097:	5e                   	pop    %esi
80105098:	5d                   	pop    %ebp
80105099:	c3                   	ret
8010509a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801050a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050a5:	eb ec                	jmp    80105093 <sys_fstat+0x53>
801050a7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801050ae:	00 
801050af:	90                   	nop

801050b0 <sys_link>:
{
801050b0:	55                   	push   %ebp
801050b1:	89 e5                	mov    %esp,%ebp
801050b3:	57                   	push   %edi
801050b4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801050b5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801050b8:	53                   	push   %ebx
801050b9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801050bc:	50                   	push   %eax
801050bd:	6a 00                	push   $0x0
801050bf:	e8 2c fb ff ff       	call   80104bf0 <argstr>
801050c4:	83 c4 10             	add    $0x10,%esp
801050c7:	85 c0                	test   %eax,%eax
801050c9:	0f 88 fb 00 00 00    	js     801051ca <sys_link+0x11a>
801050cf:	83 ec 08             	sub    $0x8,%esp
801050d2:	8d 45 d0             	lea    -0x30(%ebp),%eax
801050d5:	50                   	push   %eax
801050d6:	6a 01                	push   $0x1
801050d8:	e8 13 fb ff ff       	call   80104bf0 <argstr>
801050dd:	83 c4 10             	add    $0x10,%esp
801050e0:	85 c0                	test   %eax,%eax
801050e2:	0f 88 e2 00 00 00    	js     801051ca <sys_link+0x11a>
  begin_op();
801050e8:	e8 13 dd ff ff       	call   80102e00 <begin_op>
  if((ip = namei(old)) == 0){
801050ed:	83 ec 0c             	sub    $0xc,%esp
801050f0:	ff 75 d4             	push   -0x2c(%ebp)
801050f3:	e8 08 d0 ff ff       	call   80102100 <namei>
801050f8:	83 c4 10             	add    $0x10,%esp
801050fb:	89 c3                	mov    %eax,%ebx
801050fd:	85 c0                	test   %eax,%eax
801050ff:	0f 84 df 00 00 00    	je     801051e4 <sys_link+0x134>
  ilock(ip);
80105105:	83 ec 0c             	sub    $0xc,%esp
80105108:	50                   	push   %eax
80105109:	e8 12 c7 ff ff       	call   80101820 <ilock>
  if(ip->type == T_DIR){
8010510e:	83 c4 10             	add    $0x10,%esp
80105111:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105116:	0f 84 b5 00 00 00    	je     801051d1 <sys_link+0x121>
  iupdate(ip);
8010511c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010511f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105124:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105127:	53                   	push   %ebx
80105128:	e8 43 c6 ff ff       	call   80101770 <iupdate>
  iunlock(ip);
8010512d:	89 1c 24             	mov    %ebx,(%esp)
80105130:	e8 cb c7 ff ff       	call   80101900 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105135:	58                   	pop    %eax
80105136:	5a                   	pop    %edx
80105137:	57                   	push   %edi
80105138:	ff 75 d0             	push   -0x30(%ebp)
8010513b:	e8 e0 cf ff ff       	call   80102120 <nameiparent>
80105140:	83 c4 10             	add    $0x10,%esp
80105143:	89 c6                	mov    %eax,%esi
80105145:	85 c0                	test   %eax,%eax
80105147:	74 5b                	je     801051a4 <sys_link+0xf4>
  ilock(dp);
80105149:	83 ec 0c             	sub    $0xc,%esp
8010514c:	50                   	push   %eax
8010514d:	e8 ce c6 ff ff       	call   80101820 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105152:	8b 03                	mov    (%ebx),%eax
80105154:	83 c4 10             	add    $0x10,%esp
80105157:	39 06                	cmp    %eax,(%esi)
80105159:	75 3d                	jne    80105198 <sys_link+0xe8>
8010515b:	83 ec 04             	sub    $0x4,%esp
8010515e:	ff 73 04             	push   0x4(%ebx)
80105161:	57                   	push   %edi
80105162:	56                   	push   %esi
80105163:	e8 d8 ce ff ff       	call   80102040 <dirlink>
80105168:	83 c4 10             	add    $0x10,%esp
8010516b:	85 c0                	test   %eax,%eax
8010516d:	78 29                	js     80105198 <sys_link+0xe8>
  iunlockput(dp);
8010516f:	83 ec 0c             	sub    $0xc,%esp
80105172:	56                   	push   %esi
80105173:	e8 38 c9 ff ff       	call   80101ab0 <iunlockput>
  iput(ip);
80105178:	89 1c 24             	mov    %ebx,(%esp)
8010517b:	e8 d0 c7 ff ff       	call   80101950 <iput>
  end_op();
80105180:	e8 eb dc ff ff       	call   80102e70 <end_op>
  return 0;
80105185:	83 c4 10             	add    $0x10,%esp
80105188:	31 c0                	xor    %eax,%eax
}
8010518a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010518d:	5b                   	pop    %ebx
8010518e:	5e                   	pop    %esi
8010518f:	5f                   	pop    %edi
80105190:	5d                   	pop    %ebp
80105191:	c3                   	ret
80105192:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105198:	83 ec 0c             	sub    $0xc,%esp
8010519b:	56                   	push   %esi
8010519c:	e8 0f c9 ff ff       	call   80101ab0 <iunlockput>
    goto bad;
801051a1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801051a4:	83 ec 0c             	sub    $0xc,%esp
801051a7:	53                   	push   %ebx
801051a8:	e8 73 c6 ff ff       	call   80101820 <ilock>
  ip->nlink--;
801051ad:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801051b2:	89 1c 24             	mov    %ebx,(%esp)
801051b5:	e8 b6 c5 ff ff       	call   80101770 <iupdate>
  iunlockput(ip);
801051ba:	89 1c 24             	mov    %ebx,(%esp)
801051bd:	e8 ee c8 ff ff       	call   80101ab0 <iunlockput>
  end_op();
801051c2:	e8 a9 dc ff ff       	call   80102e70 <end_op>
  return -1;
801051c7:	83 c4 10             	add    $0x10,%esp
    return -1;
801051ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051cf:	eb b9                	jmp    8010518a <sys_link+0xda>
    iunlockput(ip);
801051d1:	83 ec 0c             	sub    $0xc,%esp
801051d4:	53                   	push   %ebx
801051d5:	e8 d6 c8 ff ff       	call   80101ab0 <iunlockput>
    end_op();
801051da:	e8 91 dc ff ff       	call   80102e70 <end_op>
    return -1;
801051df:	83 c4 10             	add    $0x10,%esp
801051e2:	eb e6                	jmp    801051ca <sys_link+0x11a>
    end_op();
801051e4:	e8 87 dc ff ff       	call   80102e70 <end_op>
    return -1;
801051e9:	eb df                	jmp    801051ca <sys_link+0x11a>
801051eb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

801051f0 <sys_unlink>:
{
801051f0:	55                   	push   %ebp
801051f1:	89 e5                	mov    %esp,%ebp
801051f3:	57                   	push   %edi
801051f4:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801051f5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801051f8:	53                   	push   %ebx
801051f9:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801051fc:	50                   	push   %eax
801051fd:	6a 00                	push   $0x0
801051ff:	e8 ec f9 ff ff       	call   80104bf0 <argstr>
80105204:	83 c4 10             	add    $0x10,%esp
80105207:	85 c0                	test   %eax,%eax
80105209:	0f 88 54 01 00 00    	js     80105363 <sys_unlink+0x173>
  begin_op();
8010520f:	e8 ec db ff ff       	call   80102e00 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105214:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105217:	83 ec 08             	sub    $0x8,%esp
8010521a:	53                   	push   %ebx
8010521b:	ff 75 c0             	push   -0x40(%ebp)
8010521e:	e8 fd ce ff ff       	call   80102120 <nameiparent>
80105223:	83 c4 10             	add    $0x10,%esp
80105226:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105229:	85 c0                	test   %eax,%eax
8010522b:	0f 84 58 01 00 00    	je     80105389 <sys_unlink+0x199>
  ilock(dp);
80105231:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105234:	83 ec 0c             	sub    $0xc,%esp
80105237:	57                   	push   %edi
80105238:	e8 e3 c5 ff ff       	call   80101820 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010523d:	58                   	pop    %eax
8010523e:	5a                   	pop    %edx
8010523f:	68 1a 7d 10 80       	push   $0x80107d1a
80105244:	53                   	push   %ebx
80105245:	e8 06 cb ff ff       	call   80101d50 <namecmp>
8010524a:	83 c4 10             	add    $0x10,%esp
8010524d:	85 c0                	test   %eax,%eax
8010524f:	0f 84 fb 00 00 00    	je     80105350 <sys_unlink+0x160>
80105255:	83 ec 08             	sub    $0x8,%esp
80105258:	68 19 7d 10 80       	push   $0x80107d19
8010525d:	53                   	push   %ebx
8010525e:	e8 ed ca ff ff       	call   80101d50 <namecmp>
80105263:	83 c4 10             	add    $0x10,%esp
80105266:	85 c0                	test   %eax,%eax
80105268:	0f 84 e2 00 00 00    	je     80105350 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010526e:	83 ec 04             	sub    $0x4,%esp
80105271:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105274:	50                   	push   %eax
80105275:	53                   	push   %ebx
80105276:	57                   	push   %edi
80105277:	e8 f4 ca ff ff       	call   80101d70 <dirlookup>
8010527c:	83 c4 10             	add    $0x10,%esp
8010527f:	89 c3                	mov    %eax,%ebx
80105281:	85 c0                	test   %eax,%eax
80105283:	0f 84 c7 00 00 00    	je     80105350 <sys_unlink+0x160>
  ilock(ip);
80105289:	83 ec 0c             	sub    $0xc,%esp
8010528c:	50                   	push   %eax
8010528d:	e8 8e c5 ff ff       	call   80101820 <ilock>
  if(ip->nlink < 1)
80105292:	83 c4 10             	add    $0x10,%esp
80105295:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010529a:	0f 8e 0a 01 00 00    	jle    801053aa <sys_unlink+0x1ba>
  if(ip->type == T_DIR && !isdirempty(ip)){
801052a0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801052a5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801052a8:	74 66                	je     80105310 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801052aa:	83 ec 04             	sub    $0x4,%esp
801052ad:	6a 10                	push   $0x10
801052af:	6a 00                	push   $0x0
801052b1:	57                   	push   %edi
801052b2:	e8 c9 f5 ff ff       	call   80104880 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801052b7:	6a 10                	push   $0x10
801052b9:	ff 75 c4             	push   -0x3c(%ebp)
801052bc:	57                   	push   %edi
801052bd:	ff 75 b4             	push   -0x4c(%ebp)
801052c0:	e8 6b c9 ff ff       	call   80101c30 <writei>
801052c5:	83 c4 20             	add    $0x20,%esp
801052c8:	83 f8 10             	cmp    $0x10,%eax
801052cb:	0f 85 cc 00 00 00    	jne    8010539d <sys_unlink+0x1ad>
  if(ip->type == T_DIR){
801052d1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801052d6:	0f 84 94 00 00 00    	je     80105370 <sys_unlink+0x180>
  iunlockput(dp);
801052dc:	83 ec 0c             	sub    $0xc,%esp
801052df:	ff 75 b4             	push   -0x4c(%ebp)
801052e2:	e8 c9 c7 ff ff       	call   80101ab0 <iunlockput>
  ip->nlink--;
801052e7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801052ec:	89 1c 24             	mov    %ebx,(%esp)
801052ef:	e8 7c c4 ff ff       	call   80101770 <iupdate>
  iunlockput(ip);
801052f4:	89 1c 24             	mov    %ebx,(%esp)
801052f7:	e8 b4 c7 ff ff       	call   80101ab0 <iunlockput>
  end_op();
801052fc:	e8 6f db ff ff       	call   80102e70 <end_op>
  return 0;
80105301:	83 c4 10             	add    $0x10,%esp
80105304:	31 c0                	xor    %eax,%eax
}
80105306:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105309:	5b                   	pop    %ebx
8010530a:	5e                   	pop    %esi
8010530b:	5f                   	pop    %edi
8010530c:	5d                   	pop    %ebp
8010530d:	c3                   	ret
8010530e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105310:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105314:	76 94                	jbe    801052aa <sys_unlink+0xba>
80105316:	be 20 00 00 00       	mov    $0x20,%esi
8010531b:	eb 0b                	jmp    80105328 <sys_unlink+0x138>
8010531d:	8d 76 00             	lea    0x0(%esi),%esi
80105320:	83 c6 10             	add    $0x10,%esi
80105323:	3b 73 58             	cmp    0x58(%ebx),%esi
80105326:	73 82                	jae    801052aa <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105328:	6a 10                	push   $0x10
8010532a:	56                   	push   %esi
8010532b:	57                   	push   %edi
8010532c:	53                   	push   %ebx
8010532d:	e8 fe c7 ff ff       	call   80101b30 <readi>
80105332:	83 c4 10             	add    $0x10,%esp
80105335:	83 f8 10             	cmp    $0x10,%eax
80105338:	75 56                	jne    80105390 <sys_unlink+0x1a0>
    if(de.inum != 0)
8010533a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010533f:	74 df                	je     80105320 <sys_unlink+0x130>
    iunlockput(ip);
80105341:	83 ec 0c             	sub    $0xc,%esp
80105344:	53                   	push   %ebx
80105345:	e8 66 c7 ff ff       	call   80101ab0 <iunlockput>
    goto bad;
8010534a:	83 c4 10             	add    $0x10,%esp
8010534d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105350:	83 ec 0c             	sub    $0xc,%esp
80105353:	ff 75 b4             	push   -0x4c(%ebp)
80105356:	e8 55 c7 ff ff       	call   80101ab0 <iunlockput>
  end_op();
8010535b:	e8 10 db ff ff       	call   80102e70 <end_op>
  return -1;
80105360:	83 c4 10             	add    $0x10,%esp
    return -1;
80105363:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105368:	eb 9c                	jmp    80105306 <sys_unlink+0x116>
8010536a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105370:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105373:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105376:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010537b:	50                   	push   %eax
8010537c:	e8 ef c3 ff ff       	call   80101770 <iupdate>
80105381:	83 c4 10             	add    $0x10,%esp
80105384:	e9 53 ff ff ff       	jmp    801052dc <sys_unlink+0xec>
    end_op();
80105389:	e8 e2 da ff ff       	call   80102e70 <end_op>
    return -1;
8010538e:	eb d3                	jmp    80105363 <sys_unlink+0x173>
      panic("isdirempty: readi");
80105390:	83 ec 0c             	sub    $0xc,%esp
80105393:	68 3e 7d 10 80       	push   $0x80107d3e
80105398:	e8 e3 af ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010539d:	83 ec 0c             	sub    $0xc,%esp
801053a0:	68 50 7d 10 80       	push   $0x80107d50
801053a5:	e8 d6 af ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
801053aa:	83 ec 0c             	sub    $0xc,%esp
801053ad:	68 2c 7d 10 80       	push   $0x80107d2c
801053b2:	e8 c9 af ff ff       	call   80100380 <panic>
801053b7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801053be:	00 
801053bf:	90                   	nop

801053c0 <sys_open>:

int
sys_open(void)
{
801053c0:	55                   	push   %ebp
801053c1:	89 e5                	mov    %esp,%ebp
801053c3:	57                   	push   %edi
801053c4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801053c5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801053c8:	53                   	push   %ebx
801053c9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801053cc:	50                   	push   %eax
801053cd:	6a 00                	push   $0x0
801053cf:	e8 1c f8 ff ff       	call   80104bf0 <argstr>
801053d4:	83 c4 10             	add    $0x10,%esp
801053d7:	85 c0                	test   %eax,%eax
801053d9:	0f 88 8e 00 00 00    	js     8010546d <sys_open+0xad>
801053df:	83 ec 08             	sub    $0x8,%esp
801053e2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801053e5:	50                   	push   %eax
801053e6:	6a 01                	push   $0x1
801053e8:	e8 43 f7 ff ff       	call   80104b30 <argint>
801053ed:	83 c4 10             	add    $0x10,%esp
801053f0:	85 c0                	test   %eax,%eax
801053f2:	78 79                	js     8010546d <sys_open+0xad>
    return -1;

  begin_op();
801053f4:	e8 07 da ff ff       	call   80102e00 <begin_op>

  if(omode & O_CREATE){
801053f9:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801053fd:	75 79                	jne    80105478 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801053ff:	83 ec 0c             	sub    $0xc,%esp
80105402:	ff 75 e0             	push   -0x20(%ebp)
80105405:	e8 f6 cc ff ff       	call   80102100 <namei>
8010540a:	83 c4 10             	add    $0x10,%esp
8010540d:	89 c6                	mov    %eax,%esi
8010540f:	85 c0                	test   %eax,%eax
80105411:	0f 84 7e 00 00 00    	je     80105495 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105417:	83 ec 0c             	sub    $0xc,%esp
8010541a:	50                   	push   %eax
8010541b:	e8 00 c4 ff ff       	call   80101820 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105420:	83 c4 10             	add    $0x10,%esp
80105423:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105428:	0f 84 ba 00 00 00    	je     801054e8 <sys_open+0x128>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010542e:	e8 9d ba ff ff       	call   80100ed0 <filealloc>
80105433:	89 c7                	mov    %eax,%edi
80105435:	85 c0                	test   %eax,%eax
80105437:	74 23                	je     8010545c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105439:	e8 72 e6 ff ff       	call   80103ab0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010543e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105440:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105444:	85 d2                	test   %edx,%edx
80105446:	74 58                	je     801054a0 <sys_open+0xe0>
  for(fd = 0; fd < NOFILE; fd++){
80105448:	83 c3 01             	add    $0x1,%ebx
8010544b:	83 fb 10             	cmp    $0x10,%ebx
8010544e:	75 f0                	jne    80105440 <sys_open+0x80>
    if(f)
      fileclose(f);
80105450:	83 ec 0c             	sub    $0xc,%esp
80105453:	57                   	push   %edi
80105454:	e8 37 bb ff ff       	call   80100f90 <fileclose>
80105459:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010545c:	83 ec 0c             	sub    $0xc,%esp
8010545f:	56                   	push   %esi
80105460:	e8 4b c6 ff ff       	call   80101ab0 <iunlockput>
    end_op();
80105465:	e8 06 da ff ff       	call   80102e70 <end_op>
    return -1;
8010546a:	83 c4 10             	add    $0x10,%esp
    return -1;
8010546d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105472:	eb 65                	jmp    801054d9 <sys_open+0x119>
80105474:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105478:	83 ec 0c             	sub    $0xc,%esp
8010547b:	31 c9                	xor    %ecx,%ecx
8010547d:	ba 02 00 00 00       	mov    $0x2,%edx
80105482:	6a 00                	push   $0x0
80105484:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105487:	e8 54 f8 ff ff       	call   80104ce0 <create>
    if(ip == 0){
8010548c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010548f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105491:	85 c0                	test   %eax,%eax
80105493:	75 99                	jne    8010542e <sys_open+0x6e>
      end_op();
80105495:	e8 d6 d9 ff ff       	call   80102e70 <end_op>
      return -1;
8010549a:	eb d1                	jmp    8010546d <sys_open+0xad>
8010549c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801054a0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801054a3:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801054a7:	56                   	push   %esi
801054a8:	e8 53 c4 ff ff       	call   80101900 <iunlock>
  end_op();
801054ad:	e8 be d9 ff ff       	call   80102e70 <end_op>

  f->type = FD_INODE;
801054b2:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801054b8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801054bb:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801054be:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801054c1:	89 d0                	mov    %edx,%eax
  f->off = 0;
801054c3:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801054ca:	f7 d0                	not    %eax
801054cc:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801054cf:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801054d2:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801054d5:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801054d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054dc:	89 d8                	mov    %ebx,%eax
801054de:	5b                   	pop    %ebx
801054df:	5e                   	pop    %esi
801054e0:	5f                   	pop    %edi
801054e1:	5d                   	pop    %ebp
801054e2:	c3                   	ret
801054e3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
801054e8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801054eb:	85 c9                	test   %ecx,%ecx
801054ed:	0f 84 3b ff ff ff    	je     8010542e <sys_open+0x6e>
801054f3:	e9 64 ff ff ff       	jmp    8010545c <sys_open+0x9c>
801054f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801054ff:	00 

80105500 <sys_mkdir>:

int
sys_mkdir(void)
{
80105500:	55                   	push   %ebp
80105501:	89 e5                	mov    %esp,%ebp
80105503:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105506:	e8 f5 d8 ff ff       	call   80102e00 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010550b:	83 ec 08             	sub    $0x8,%esp
8010550e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105511:	50                   	push   %eax
80105512:	6a 00                	push   $0x0
80105514:	e8 d7 f6 ff ff       	call   80104bf0 <argstr>
80105519:	83 c4 10             	add    $0x10,%esp
8010551c:	85 c0                	test   %eax,%eax
8010551e:	78 30                	js     80105550 <sys_mkdir+0x50>
80105520:	83 ec 0c             	sub    $0xc,%esp
80105523:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105526:	31 c9                	xor    %ecx,%ecx
80105528:	ba 01 00 00 00       	mov    $0x1,%edx
8010552d:	6a 00                	push   $0x0
8010552f:	e8 ac f7 ff ff       	call   80104ce0 <create>
80105534:	83 c4 10             	add    $0x10,%esp
80105537:	85 c0                	test   %eax,%eax
80105539:	74 15                	je     80105550 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010553b:	83 ec 0c             	sub    $0xc,%esp
8010553e:	50                   	push   %eax
8010553f:	e8 6c c5 ff ff       	call   80101ab0 <iunlockput>
  end_op();
80105544:	e8 27 d9 ff ff       	call   80102e70 <end_op>
  return 0;
80105549:	83 c4 10             	add    $0x10,%esp
8010554c:	31 c0                	xor    %eax,%eax
}
8010554e:	c9                   	leave
8010554f:	c3                   	ret
    end_op();
80105550:	e8 1b d9 ff ff       	call   80102e70 <end_op>
    return -1;
80105555:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010555a:	c9                   	leave
8010555b:	c3                   	ret
8010555c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105560 <sys_mknod>:

int
sys_mknod(void)
{
80105560:	55                   	push   %ebp
80105561:	89 e5                	mov    %esp,%ebp
80105563:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105566:	e8 95 d8 ff ff       	call   80102e00 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010556b:	83 ec 08             	sub    $0x8,%esp
8010556e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105571:	50                   	push   %eax
80105572:	6a 00                	push   $0x0
80105574:	e8 77 f6 ff ff       	call   80104bf0 <argstr>
80105579:	83 c4 10             	add    $0x10,%esp
8010557c:	85 c0                	test   %eax,%eax
8010557e:	78 60                	js     801055e0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105580:	83 ec 08             	sub    $0x8,%esp
80105583:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105586:	50                   	push   %eax
80105587:	6a 01                	push   $0x1
80105589:	e8 a2 f5 ff ff       	call   80104b30 <argint>
  if((argstr(0, &path)) < 0 ||
8010558e:	83 c4 10             	add    $0x10,%esp
80105591:	85 c0                	test   %eax,%eax
80105593:	78 4b                	js     801055e0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105595:	83 ec 08             	sub    $0x8,%esp
80105598:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010559b:	50                   	push   %eax
8010559c:	6a 02                	push   $0x2
8010559e:	e8 8d f5 ff ff       	call   80104b30 <argint>
     argint(1, &major) < 0 ||
801055a3:	83 c4 10             	add    $0x10,%esp
801055a6:	85 c0                	test   %eax,%eax
801055a8:	78 36                	js     801055e0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801055aa:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801055ae:	83 ec 0c             	sub    $0xc,%esp
801055b1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801055b5:	ba 03 00 00 00       	mov    $0x3,%edx
801055ba:	50                   	push   %eax
801055bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801055be:	e8 1d f7 ff ff       	call   80104ce0 <create>
     argint(2, &minor) < 0 ||
801055c3:	83 c4 10             	add    $0x10,%esp
801055c6:	85 c0                	test   %eax,%eax
801055c8:	74 16                	je     801055e0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801055ca:	83 ec 0c             	sub    $0xc,%esp
801055cd:	50                   	push   %eax
801055ce:	e8 dd c4 ff ff       	call   80101ab0 <iunlockput>
  end_op();
801055d3:	e8 98 d8 ff ff       	call   80102e70 <end_op>
  return 0;
801055d8:	83 c4 10             	add    $0x10,%esp
801055db:	31 c0                	xor    %eax,%eax
}
801055dd:	c9                   	leave
801055de:	c3                   	ret
801055df:	90                   	nop
    end_op();
801055e0:	e8 8b d8 ff ff       	call   80102e70 <end_op>
    return -1;
801055e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055ea:	c9                   	leave
801055eb:	c3                   	ret
801055ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801055f0 <sys_chdir>:

int
sys_chdir(void)
{
801055f0:	55                   	push   %ebp
801055f1:	89 e5                	mov    %esp,%ebp
801055f3:	56                   	push   %esi
801055f4:	53                   	push   %ebx
801055f5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801055f8:	e8 b3 e4 ff ff       	call   80103ab0 <myproc>
801055fd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801055ff:	e8 fc d7 ff ff       	call   80102e00 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105604:	83 ec 08             	sub    $0x8,%esp
80105607:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010560a:	50                   	push   %eax
8010560b:	6a 00                	push   $0x0
8010560d:	e8 de f5 ff ff       	call   80104bf0 <argstr>
80105612:	83 c4 10             	add    $0x10,%esp
80105615:	85 c0                	test   %eax,%eax
80105617:	78 77                	js     80105690 <sys_chdir+0xa0>
80105619:	83 ec 0c             	sub    $0xc,%esp
8010561c:	ff 75 f4             	push   -0xc(%ebp)
8010561f:	e8 dc ca ff ff       	call   80102100 <namei>
80105624:	83 c4 10             	add    $0x10,%esp
80105627:	89 c3                	mov    %eax,%ebx
80105629:	85 c0                	test   %eax,%eax
8010562b:	74 63                	je     80105690 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010562d:	83 ec 0c             	sub    $0xc,%esp
80105630:	50                   	push   %eax
80105631:	e8 ea c1 ff ff       	call   80101820 <ilock>
  if(ip->type != T_DIR){
80105636:	83 c4 10             	add    $0x10,%esp
80105639:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010563e:	75 30                	jne    80105670 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105640:	83 ec 0c             	sub    $0xc,%esp
80105643:	53                   	push   %ebx
80105644:	e8 b7 c2 ff ff       	call   80101900 <iunlock>
  iput(curproc->cwd);
80105649:	58                   	pop    %eax
8010564a:	ff 76 68             	push   0x68(%esi)
8010564d:	e8 fe c2 ff ff       	call   80101950 <iput>
  end_op();
80105652:	e8 19 d8 ff ff       	call   80102e70 <end_op>
  curproc->cwd = ip;
80105657:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010565a:	83 c4 10             	add    $0x10,%esp
8010565d:	31 c0                	xor    %eax,%eax
}
8010565f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105662:	5b                   	pop    %ebx
80105663:	5e                   	pop    %esi
80105664:	5d                   	pop    %ebp
80105665:	c3                   	ret
80105666:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010566d:	00 
8010566e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80105670:	83 ec 0c             	sub    $0xc,%esp
80105673:	53                   	push   %ebx
80105674:	e8 37 c4 ff ff       	call   80101ab0 <iunlockput>
    end_op();
80105679:	e8 f2 d7 ff ff       	call   80102e70 <end_op>
    return -1;
8010567e:	83 c4 10             	add    $0x10,%esp
    return -1;
80105681:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105686:	eb d7                	jmp    8010565f <sys_chdir+0x6f>
80105688:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010568f:	00 
    end_op();
80105690:	e8 db d7 ff ff       	call   80102e70 <end_op>
    return -1;
80105695:	eb ea                	jmp    80105681 <sys_chdir+0x91>
80105697:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010569e:	00 
8010569f:	90                   	nop

801056a0 <sys_exec>:

int
sys_exec(void)
{
801056a0:	55                   	push   %ebp
801056a1:	89 e5                	mov    %esp,%ebp
801056a3:	57                   	push   %edi
801056a4:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801056a5:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801056ab:	53                   	push   %ebx
801056ac:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801056b2:	50                   	push   %eax
801056b3:	6a 00                	push   $0x0
801056b5:	e8 36 f5 ff ff       	call   80104bf0 <argstr>
801056ba:	83 c4 10             	add    $0x10,%esp
801056bd:	85 c0                	test   %eax,%eax
801056bf:	0f 88 87 00 00 00    	js     8010574c <sys_exec+0xac>
801056c5:	83 ec 08             	sub    $0x8,%esp
801056c8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801056ce:	50                   	push   %eax
801056cf:	6a 01                	push   $0x1
801056d1:	e8 5a f4 ff ff       	call   80104b30 <argint>
801056d6:	83 c4 10             	add    $0x10,%esp
801056d9:	85 c0                	test   %eax,%eax
801056db:	78 6f                	js     8010574c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801056dd:	83 ec 04             	sub    $0x4,%esp
801056e0:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
801056e6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801056e8:	68 80 00 00 00       	push   $0x80
801056ed:	6a 00                	push   $0x0
801056ef:	56                   	push   %esi
801056f0:	e8 8b f1 ff ff       	call   80104880 <memset>
801056f5:	83 c4 10             	add    $0x10,%esp
801056f8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801056ff:	00 
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105700:	83 ec 08             	sub    $0x8,%esp
80105703:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105709:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105710:	50                   	push   %eax
80105711:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105717:	01 f8                	add    %edi,%eax
80105719:	50                   	push   %eax
8010571a:	e8 81 f3 ff ff       	call   80104aa0 <fetchint>
8010571f:	83 c4 10             	add    $0x10,%esp
80105722:	85 c0                	test   %eax,%eax
80105724:	78 26                	js     8010574c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105726:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010572c:	85 c0                	test   %eax,%eax
8010572e:	74 30                	je     80105760 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105730:	83 ec 08             	sub    $0x8,%esp
80105733:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105736:	52                   	push   %edx
80105737:	50                   	push   %eax
80105738:	e8 a3 f3 ff ff       	call   80104ae0 <fetchstr>
8010573d:	83 c4 10             	add    $0x10,%esp
80105740:	85 c0                	test   %eax,%eax
80105742:	78 08                	js     8010574c <sys_exec+0xac>
  for(i=0;; i++){
80105744:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105747:	83 fb 20             	cmp    $0x20,%ebx
8010574a:	75 b4                	jne    80105700 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010574c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010574f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105754:	5b                   	pop    %ebx
80105755:	5e                   	pop    %esi
80105756:	5f                   	pop    %edi
80105757:	5d                   	pop    %ebp
80105758:	c3                   	ret
80105759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105760:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105767:	00 00 00 00 
  return exec(path, argv);
8010576b:	83 ec 08             	sub    $0x8,%esp
8010576e:	56                   	push   %esi
8010576f:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
80105775:	e8 a6 b3 ff ff       	call   80100b20 <exec>
8010577a:	83 c4 10             	add    $0x10,%esp
}
8010577d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105780:	5b                   	pop    %ebx
80105781:	5e                   	pop    %esi
80105782:	5f                   	pop    %edi
80105783:	5d                   	pop    %ebp
80105784:	c3                   	ret
80105785:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010578c:	00 
8010578d:	8d 76 00             	lea    0x0(%esi),%esi

80105790 <sys_pipe>:

int
sys_pipe(void)
{
80105790:	55                   	push   %ebp
80105791:	89 e5                	mov    %esp,%ebp
80105793:	57                   	push   %edi
80105794:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105795:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105798:	53                   	push   %ebx
80105799:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010579c:	6a 08                	push   $0x8
8010579e:	50                   	push   %eax
8010579f:	6a 00                	push   $0x0
801057a1:	e8 da f3 ff ff       	call   80104b80 <argptr>
801057a6:	83 c4 10             	add    $0x10,%esp
801057a9:	85 c0                	test   %eax,%eax
801057ab:	0f 88 8b 00 00 00    	js     8010583c <sys_pipe+0xac>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801057b1:	83 ec 08             	sub    $0x8,%esp
801057b4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801057b7:	50                   	push   %eax
801057b8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801057bb:	50                   	push   %eax
801057bc:	e8 0f dd ff ff       	call   801034d0 <pipealloc>
801057c1:	83 c4 10             	add    $0x10,%esp
801057c4:	85 c0                	test   %eax,%eax
801057c6:	78 74                	js     8010583c <sys_pipe+0xac>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801057c8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801057cb:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801057cd:	e8 de e2 ff ff       	call   80103ab0 <myproc>
    if(curproc->ofile[fd] == 0){
801057d2:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801057d6:	85 f6                	test   %esi,%esi
801057d8:	74 16                	je     801057f0 <sys_pipe+0x60>
801057da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
801057e0:	83 c3 01             	add    $0x1,%ebx
801057e3:	83 fb 10             	cmp    $0x10,%ebx
801057e6:	74 3d                	je     80105825 <sys_pipe+0x95>
    if(curproc->ofile[fd] == 0){
801057e8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801057ec:	85 f6                	test   %esi,%esi
801057ee:	75 f0                	jne    801057e0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
801057f0:	8d 73 08             	lea    0x8(%ebx),%esi
801057f3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801057f7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801057fa:	e8 b1 e2 ff ff       	call   80103ab0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801057ff:	31 d2                	xor    %edx,%edx
80105801:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105808:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
8010580c:	85 c9                	test   %ecx,%ecx
8010580e:	74 38                	je     80105848 <sys_pipe+0xb8>
  for(fd = 0; fd < NOFILE; fd++){
80105810:	83 c2 01             	add    $0x1,%edx
80105813:	83 fa 10             	cmp    $0x10,%edx
80105816:	75 f0                	jne    80105808 <sys_pipe+0x78>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105818:	e8 93 e2 ff ff       	call   80103ab0 <myproc>
8010581d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105824:	00 
    fileclose(rf);
80105825:	83 ec 0c             	sub    $0xc,%esp
80105828:	ff 75 e0             	push   -0x20(%ebp)
8010582b:	e8 60 b7 ff ff       	call   80100f90 <fileclose>
    fileclose(wf);
80105830:	58                   	pop    %eax
80105831:	ff 75 e4             	push   -0x1c(%ebp)
80105834:	e8 57 b7 ff ff       	call   80100f90 <fileclose>
    return -1;
80105839:	83 c4 10             	add    $0x10,%esp
    return -1;
8010583c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105841:	eb 16                	jmp    80105859 <sys_pipe+0xc9>
80105843:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
80105848:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
8010584c:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010584f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105851:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105854:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105857:	31 c0                	xor    %eax,%eax
}
80105859:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010585c:	5b                   	pop    %ebx
8010585d:	5e                   	pop    %esi
8010585e:	5f                   	pop    %edi
8010585f:	5d                   	pop    %ebp
80105860:	c3                   	ret
80105861:	66 90                	xchg   %ax,%ax
80105863:	66 90                	xchg   %ax,%ax
80105865:	66 90                	xchg   %ax,%ax
80105867:	66 90                	xchg   %ax,%ax
80105869:	66 90                	xchg   %ax,%ax
8010586b:	66 90                	xchg   %ax,%ax
8010586d:	66 90                	xchg   %ax,%ax
8010586f:	90                   	nop

80105870 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105870:	e9 db e3 ff ff       	jmp    80103c50 <fork>
80105875:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010587c:	00 
8010587d:	8d 76 00             	lea    0x0(%esi),%esi

80105880 <sys_exit>:
}

int
sys_exit(void)
{
80105880:	55                   	push   %ebp
80105881:	89 e5                	mov    %esp,%ebp
80105883:	83 ec 08             	sub    $0x8,%esp
  exit();
80105886:	e8 45 e6 ff ff       	call   80103ed0 <exit>
  return 0;  // not reached
}
8010588b:	31 c0                	xor    %eax,%eax
8010588d:	c9                   	leave
8010588e:	c3                   	ret
8010588f:	90                   	nop

80105890 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105890:	e9 6b e7 ff ff       	jmp    80104000 <wait>
80105895:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010589c:	00 
8010589d:	8d 76 00             	lea    0x0(%esi),%esi

801058a0 <sys_kill>:
}

int
sys_kill(void)
{
801058a0:	55                   	push   %ebp
801058a1:	89 e5                	mov    %esp,%ebp
801058a3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
801058a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058a9:	50                   	push   %eax
801058aa:	6a 00                	push   $0x0
801058ac:	e8 7f f2 ff ff       	call   80104b30 <argint>
801058b1:	83 c4 10             	add    $0x10,%esp
801058b4:	85 c0                	test   %eax,%eax
801058b6:	78 18                	js     801058d0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801058b8:	83 ec 0c             	sub    $0xc,%esp
801058bb:	ff 75 f4             	push   -0xc(%ebp)
801058be:	e8 dd e9 ff ff       	call   801042a0 <kill>
801058c3:	83 c4 10             	add    $0x10,%esp
}
801058c6:	c9                   	leave
801058c7:	c3                   	ret
801058c8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801058cf:	00 
801058d0:	c9                   	leave
    return -1;
801058d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058d6:	c3                   	ret
801058d7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801058de:	00 
801058df:	90                   	nop

801058e0 <sys_getpid>:

int
sys_getpid(void)
{
801058e0:	55                   	push   %ebp
801058e1:	89 e5                	mov    %esp,%ebp
801058e3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801058e6:	e8 c5 e1 ff ff       	call   80103ab0 <myproc>
801058eb:	8b 40 10             	mov    0x10(%eax),%eax
}
801058ee:	c9                   	leave
801058ef:	c3                   	ret

801058f0 <sys_sbrk>:

int
sys_sbrk(void)
{
801058f0:	55                   	push   %ebp
801058f1:	89 e5                	mov    %esp,%ebp
801058f3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801058f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801058f7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801058fa:	50                   	push   %eax
801058fb:	6a 00                	push   $0x0
801058fd:	e8 2e f2 ff ff       	call   80104b30 <argint>
80105902:	83 c4 10             	add    $0x10,%esp
80105905:	85 c0                	test   %eax,%eax
80105907:	78 27                	js     80105930 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105909:	e8 a2 e1 ff ff       	call   80103ab0 <myproc>
  if(growproc(n) < 0)
8010590e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105911:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105913:	ff 75 f4             	push   -0xc(%ebp)
80105916:	e8 b5 e2 ff ff       	call   80103bd0 <growproc>
8010591b:	83 c4 10             	add    $0x10,%esp
8010591e:	85 c0                	test   %eax,%eax
80105920:	78 0e                	js     80105930 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105922:	89 d8                	mov    %ebx,%eax
80105924:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105927:	c9                   	leave
80105928:	c3                   	ret
80105929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105930:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105935:	eb eb                	jmp    80105922 <sys_sbrk+0x32>
80105937:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010593e:	00 
8010593f:	90                   	nop

80105940 <sys_sleep>:

int
sys_sleep(void)
{
80105940:	55                   	push   %ebp
80105941:	89 e5                	mov    %esp,%ebp
80105943:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105944:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105947:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010594a:	50                   	push   %eax
8010594b:	6a 00                	push   $0x0
8010594d:	e8 de f1 ff ff       	call   80104b30 <argint>
80105952:	83 c4 10             	add    $0x10,%esp
80105955:	85 c0                	test   %eax,%eax
80105957:	78 64                	js     801059bd <sys_sleep+0x7d>
    return -1;
  acquire(&tickslock);
80105959:	83 ec 0c             	sub    $0xc,%esp
8010595c:	68 e0 4d 11 80       	push   $0x80114de0
80105961:	e8 1a ee ff ff       	call   80104780 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105966:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105969:	8b 1d c0 4d 11 80    	mov    0x80114dc0,%ebx
  while(ticks - ticks0 < n){
8010596f:	83 c4 10             	add    $0x10,%esp
80105972:	85 d2                	test   %edx,%edx
80105974:	75 2b                	jne    801059a1 <sys_sleep+0x61>
80105976:	eb 58                	jmp    801059d0 <sys_sleep+0x90>
80105978:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010597f:	00 
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105980:	83 ec 08             	sub    $0x8,%esp
80105983:	68 e0 4d 11 80       	push   $0x80114de0
80105988:	68 c0 4d 11 80       	push   $0x80114dc0
8010598d:	e8 ee e7 ff ff       	call   80104180 <sleep>
  while(ticks - ticks0 < n){
80105992:	a1 c0 4d 11 80       	mov    0x80114dc0,%eax
80105997:	83 c4 10             	add    $0x10,%esp
8010599a:	29 d8                	sub    %ebx,%eax
8010599c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010599f:	73 2f                	jae    801059d0 <sys_sleep+0x90>
    if(myproc()->killed){
801059a1:	e8 0a e1 ff ff       	call   80103ab0 <myproc>
801059a6:	8b 40 24             	mov    0x24(%eax),%eax
801059a9:	85 c0                	test   %eax,%eax
801059ab:	74 d3                	je     80105980 <sys_sleep+0x40>
      release(&tickslock);
801059ad:	83 ec 0c             	sub    $0xc,%esp
801059b0:	68 e0 4d 11 80       	push   $0x80114de0
801059b5:	e8 66 ed ff ff       	call   80104720 <release>
      return -1;
801059ba:	83 c4 10             	add    $0x10,%esp
  }
  release(&tickslock);
  return 0;
}
801059bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
801059c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059c5:	c9                   	leave
801059c6:	c3                   	ret
801059c7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801059ce:	00 
801059cf:	90                   	nop
  release(&tickslock);
801059d0:	83 ec 0c             	sub    $0xc,%esp
801059d3:	68 e0 4d 11 80       	push   $0x80114de0
801059d8:	e8 43 ed ff ff       	call   80104720 <release>
}
801059dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return 0;
801059e0:	83 c4 10             	add    $0x10,%esp
801059e3:	31 c0                	xor    %eax,%eax
}
801059e5:	c9                   	leave
801059e6:	c3                   	ret
801059e7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801059ee:	00 
801059ef:	90                   	nop

801059f0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801059f0:	55                   	push   %ebp
801059f1:	89 e5                	mov    %esp,%ebp
801059f3:	53                   	push   %ebx
801059f4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801059f7:	68 e0 4d 11 80       	push   $0x80114de0
801059fc:	e8 7f ed ff ff       	call   80104780 <acquire>
  xticks = ticks;
80105a01:	8b 1d c0 4d 11 80    	mov    0x80114dc0,%ebx
  release(&tickslock);
80105a07:	c7 04 24 e0 4d 11 80 	movl   $0x80114de0,(%esp)
80105a0e:	e8 0d ed ff ff       	call   80104720 <release>
  return xticks;
}
80105a13:	89 d8                	mov    %ebx,%eax
80105a15:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a18:	c9                   	leave
80105a19:	c3                   	ret

80105a1a <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105a1a:	1e                   	push   %ds
  pushl %es
80105a1b:	06                   	push   %es
  pushl %fs
80105a1c:	0f a0                	push   %fs
  pushl %gs
80105a1e:	0f a8                	push   %gs
  pushal
80105a20:	60                   	pusha
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105a21:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105a25:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105a27:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105a29:	54                   	push   %esp
  call trap
80105a2a:	e8 c1 00 00 00       	call   80105af0 <trap>
  addl $4, %esp
80105a2f:	83 c4 04             	add    $0x4,%esp

80105a32 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105a32:	61                   	popa
  popl %gs
80105a33:	0f a9                	pop    %gs
  popl %fs
80105a35:	0f a1                	pop    %fs
  popl %es
80105a37:	07                   	pop    %es
  popl %ds
80105a38:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105a39:	83 c4 08             	add    $0x8,%esp
  iret
80105a3c:	cf                   	iret
80105a3d:	66 90                	xchg   %ax,%ax
80105a3f:	90                   	nop

80105a40 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105a40:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105a41:	31 c0                	xor    %eax,%eax
{
80105a43:	89 e5                	mov    %esp,%ebp
80105a45:	83 ec 08             	sub    $0x8,%esp
80105a48:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105a4f:	00 
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105a50:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105a57:	c7 04 c5 22 4e 11 80 	movl   $0x8e000008,-0x7feeb1de(,%eax,8)
80105a5e:	08 00 00 8e 
80105a62:	66 89 14 c5 20 4e 11 	mov    %dx,-0x7feeb1e0(,%eax,8)
80105a69:	80 
80105a6a:	c1 ea 10             	shr    $0x10,%edx
80105a6d:	66 89 14 c5 26 4e 11 	mov    %dx,-0x7feeb1da(,%eax,8)
80105a74:	80 
  for(i = 0; i < 256; i++)
80105a75:	83 c0 01             	add    $0x1,%eax
80105a78:	3d 00 01 00 00       	cmp    $0x100,%eax
80105a7d:	75 d1                	jne    80105a50 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105a7f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105a82:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80105a87:	c7 05 22 50 11 80 08 	movl   $0xef000008,0x80115022
80105a8e:	00 00 ef 
  initlock(&tickslock, "time");
80105a91:	68 5f 7d 10 80       	push   $0x80107d5f
80105a96:	68 e0 4d 11 80       	push   $0x80114de0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105a9b:	66 a3 20 50 11 80    	mov    %ax,0x80115020
80105aa1:	c1 e8 10             	shr    $0x10,%eax
80105aa4:	66 a3 26 50 11 80    	mov    %ax,0x80115026
  initlock(&tickslock, "time");
80105aaa:	e8 e1 ea ff ff       	call   80104590 <initlock>
}
80105aaf:	83 c4 10             	add    $0x10,%esp
80105ab2:	c9                   	leave
80105ab3:	c3                   	ret
80105ab4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105abb:	00 
80105abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ac0 <idtinit>:

void
idtinit(void)
{
80105ac0:	55                   	push   %ebp
  pd[0] = size-1;
80105ac1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105ac6:	89 e5                	mov    %esp,%ebp
80105ac8:	83 ec 10             	sub    $0x10,%esp
80105acb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105acf:	b8 20 4e 11 80       	mov    $0x80114e20,%eax
80105ad4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105ad8:	c1 e8 10             	shr    $0x10,%eax
80105adb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105adf:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105ae2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105ae5:	c9                   	leave
80105ae6:	c3                   	ret
80105ae7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105aee:	00 
80105aef:	90                   	nop

80105af0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105af0:	55                   	push   %ebp
80105af1:	89 e5                	mov    %esp,%ebp
80105af3:	57                   	push   %edi
80105af4:	56                   	push   %esi
80105af5:	53                   	push   %ebx
80105af6:	83 ec 1c             	sub    $0x1c,%esp
80105af9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105afc:	8b 43 30             	mov    0x30(%ebx),%eax
80105aff:	83 f8 40             	cmp    $0x40,%eax
80105b02:	0f 84 30 01 00 00    	je     80105c38 <trap+0x148>
      exit();
    return;
  }

  extern void handle_page_fault(struct trapframe*);
  switch(tf->trapno){
80105b08:	83 e8 0e             	sub    $0xe,%eax
80105b0b:	83 f8 31             	cmp    $0x31,%eax
80105b0e:	0f 87 8c 00 00 00    	ja     80105ba0 <trap+0xb0>
80105b14:	ff 24 85 58 83 10 80 	jmp    *-0x7fef7ca8(,%eax,4)
80105b1b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105b20:	e8 6b df ff ff       	call   80103a90 <cpuid>
80105b25:	85 c0                	test   %eax,%eax
80105b27:	0f 84 03 02 00 00    	je     80105d30 <trap+0x240>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80105b2d:	e8 7e ce ff ff       	call   801029b0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b32:	e8 79 df ff ff       	call   80103ab0 <myproc>
80105b37:	85 c0                	test   %eax,%eax
80105b39:	74 1a                	je     80105b55 <trap+0x65>
80105b3b:	e8 70 df ff ff       	call   80103ab0 <myproc>
80105b40:	8b 50 24             	mov    0x24(%eax),%edx
80105b43:	85 d2                	test   %edx,%edx
80105b45:	74 0e                	je     80105b55 <trap+0x65>
80105b47:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105b4b:	f7 d0                	not    %eax
80105b4d:	a8 03                	test   $0x3,%al
80105b4f:	0f 84 bb 01 00 00    	je     80105d10 <trap+0x220>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105b55:	e8 56 df ff ff       	call   80103ab0 <myproc>
80105b5a:	85 c0                	test   %eax,%eax
80105b5c:	74 0f                	je     80105b6d <trap+0x7d>
80105b5e:	e8 4d df ff ff       	call   80103ab0 <myproc>
80105b63:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105b67:	0f 84 b3 00 00 00    	je     80105c20 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105b6d:	e8 3e df ff ff       	call   80103ab0 <myproc>
80105b72:	85 c0                	test   %eax,%eax
80105b74:	74 1a                	je     80105b90 <trap+0xa0>
80105b76:	e8 35 df ff ff       	call   80103ab0 <myproc>
80105b7b:	8b 40 24             	mov    0x24(%eax),%eax
80105b7e:	85 c0                	test   %eax,%eax
80105b80:	74 0e                	je     80105b90 <trap+0xa0>
80105b82:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105b86:	f7 d0                	not    %eax
80105b88:	a8 03                	test   $0x3,%al
80105b8a:	0f 84 d5 00 00 00    	je     80105c65 <trap+0x175>
    exit();
}
80105b90:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b93:	5b                   	pop    %ebx
80105b94:	5e                   	pop    %esi
80105b95:	5f                   	pop    %edi
80105b96:	5d                   	pop    %ebp
80105b97:	c3                   	ret
80105b98:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105b9f:	00 
    if(myproc() == 0 || (tf->cs&3) == 0){
80105ba0:	e8 0b df ff ff       	call   80103ab0 <myproc>
80105ba5:	8b 7b 38             	mov    0x38(%ebx),%edi
80105ba8:	85 c0                	test   %eax,%eax
80105baa:	0f 84 b4 01 00 00    	je     80105d64 <trap+0x274>
80105bb0:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105bb4:	0f 84 aa 01 00 00    	je     80105d64 <trap+0x274>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105bba:	0f 20 d1             	mov    %cr2,%ecx
80105bbd:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105bc0:	e8 cb de ff ff       	call   80103a90 <cpuid>
80105bc5:	8b 73 30             	mov    0x30(%ebx),%esi
80105bc8:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105bcb:	8b 43 34             	mov    0x34(%ebx),%eax
80105bce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105bd1:	e8 da de ff ff       	call   80103ab0 <myproc>
80105bd6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105bd9:	e8 d2 de ff ff       	call   80103ab0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105bde:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105be1:	51                   	push   %ecx
80105be2:	57                   	push   %edi
80105be3:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105be6:	52                   	push   %edx
80105be7:	ff 75 e4             	push   -0x1c(%ebp)
80105bea:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105beb:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105bee:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105bf1:	56                   	push   %esi
80105bf2:	ff 70 10             	push   0x10(%eax)
80105bf5:	68 0c 80 10 80       	push   $0x8010800c
80105bfa:	e8 b1 aa ff ff       	call   801006b0 <cprintf>
    myproc()->killed = 1;
80105bff:	83 c4 20             	add    $0x20,%esp
80105c02:	e8 a9 de ff ff       	call   80103ab0 <myproc>
80105c07:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c0e:	e8 9d de ff ff       	call   80103ab0 <myproc>
80105c13:	85 c0                	test   %eax,%eax
80105c15:	0f 85 20 ff ff ff    	jne    80105b3b <trap+0x4b>
80105c1b:	e9 35 ff ff ff       	jmp    80105b55 <trap+0x65>
  if(myproc() && myproc()->state == RUNNING &&
80105c20:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105c24:	0f 85 43 ff ff ff    	jne    80105b6d <trap+0x7d>
    yield();
80105c2a:	e8 01 e5 ff ff       	call   80104130 <yield>
80105c2f:	e9 39 ff ff ff       	jmp    80105b6d <trap+0x7d>
80105c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105c38:	e8 73 de ff ff       	call   80103ab0 <myproc>
80105c3d:	8b 70 24             	mov    0x24(%eax),%esi
80105c40:	85 f6                	test   %esi,%esi
80105c42:	0f 85 d8 00 00 00    	jne    80105d20 <trap+0x230>
    myproc()->tf = tf;
80105c48:	e8 63 de ff ff       	call   80103ab0 <myproc>
80105c4d:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105c50:	e8 1b f0 ff ff       	call   80104c70 <syscall>
    if(myproc()->killed)
80105c55:	e8 56 de ff ff       	call   80103ab0 <myproc>
80105c5a:	8b 48 24             	mov    0x24(%eax),%ecx
80105c5d:	85 c9                	test   %ecx,%ecx
80105c5f:	0f 84 2b ff ff ff    	je     80105b90 <trap+0xa0>
}
80105c65:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c68:	5b                   	pop    %ebx
80105c69:	5e                   	pop    %esi
80105c6a:	5f                   	pop    %edi
80105c6b:	5d                   	pop    %ebp
      exit();
80105c6c:	e9 5f e2 ff ff       	jmp    80103ed0 <exit>
80105c71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105c78:	8b 7b 38             	mov    0x38(%ebx),%edi
80105c7b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105c7f:	e8 0c de ff ff       	call   80103a90 <cpuid>
80105c84:	57                   	push   %edi
80105c85:	56                   	push   %esi
80105c86:	50                   	push   %eax
80105c87:	68 b4 7f 10 80       	push   $0x80107fb4
80105c8c:	e8 1f aa ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80105c91:	e8 1a cd ff ff       	call   801029b0 <lapiceoi>
    break;
80105c96:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c99:	e8 12 de ff ff       	call   80103ab0 <myproc>
80105c9e:	85 c0                	test   %eax,%eax
80105ca0:	0f 85 95 fe ff ff    	jne    80105b3b <trap+0x4b>
80105ca6:	e9 aa fe ff ff       	jmp    80105b55 <trap+0x65>
80105cab:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    kbdintr();
80105cb0:	e8 cb cb ff ff       	call   80102880 <kbdintr>
    lapiceoi();
80105cb5:	e8 f6 cc ff ff       	call   801029b0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105cba:	e8 f1 dd ff ff       	call   80103ab0 <myproc>
80105cbf:	85 c0                	test   %eax,%eax
80105cc1:	0f 85 74 fe ff ff    	jne    80105b3b <trap+0x4b>
80105cc7:	e9 89 fe ff ff       	jmp    80105b55 <trap+0x65>
80105ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105cd0:	e8 3b 02 00 00       	call   80105f10 <uartintr>
    lapiceoi();
80105cd5:	e8 d6 cc ff ff       	call   801029b0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105cda:	e8 d1 dd ff ff       	call   80103ab0 <myproc>
80105cdf:	85 c0                	test   %eax,%eax
80105ce1:	0f 85 54 fe ff ff    	jne    80105b3b <trap+0x4b>
80105ce7:	e9 69 fe ff ff       	jmp    80105b55 <trap+0x65>
80105cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80105cf0:	e8 bb c5 ff ff       	call   801022b0 <ideintr>
80105cf5:	e9 33 fe ff ff       	jmp    80105b2d <trap+0x3d>
80105cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    handle_page_fault(tf);
80105d00:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80105d03:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d06:	5b                   	pop    %ebx
80105d07:	5e                   	pop    %esi
80105d08:	5f                   	pop    %edi
80105d09:	5d                   	pop    %ebp
    handle_page_fault(tf);
80105d0a:	e9 a1 1a 00 00       	jmp    801077b0 <handle_page_fault>
80105d0f:	90                   	nop
    exit();
80105d10:	e8 bb e1 ff ff       	call   80103ed0 <exit>
80105d15:	e9 3b fe ff ff       	jmp    80105b55 <trap+0x65>
80105d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105d20:	e8 ab e1 ff ff       	call   80103ed0 <exit>
80105d25:	e9 1e ff ff ff       	jmp    80105c48 <trap+0x158>
80105d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105d30:	83 ec 0c             	sub    $0xc,%esp
80105d33:	68 e0 4d 11 80       	push   $0x80114de0
80105d38:	e8 43 ea ff ff       	call   80104780 <acquire>
      ticks++;
80105d3d:	83 05 c0 4d 11 80 01 	addl   $0x1,0x80114dc0
      wakeup(&ticks);
80105d44:	c7 04 24 c0 4d 11 80 	movl   $0x80114dc0,(%esp)
80105d4b:	e8 f0 e4 ff ff       	call   80104240 <wakeup>
      release(&tickslock);
80105d50:	c7 04 24 e0 4d 11 80 	movl   $0x80114de0,(%esp)
80105d57:	e8 c4 e9 ff ff       	call   80104720 <release>
80105d5c:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80105d5f:	e9 c9 fd ff ff       	jmp    80105b2d <trap+0x3d>
80105d64:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105d67:	e8 24 dd ff ff       	call   80103a90 <cpuid>
80105d6c:	83 ec 0c             	sub    $0xc,%esp
80105d6f:	56                   	push   %esi
80105d70:	57                   	push   %edi
80105d71:	50                   	push   %eax
80105d72:	ff 73 30             	push   0x30(%ebx)
80105d75:	68 d8 7f 10 80       	push   $0x80107fd8
80105d7a:	e8 31 a9 ff ff       	call   801006b0 <cprintf>
      panic("trap");
80105d7f:	83 c4 14             	add    $0x14,%esp
80105d82:	68 64 7d 10 80       	push   $0x80107d64
80105d87:	e8 f4 a5 ff ff       	call   80100380 <panic>
80105d8c:	66 90                	xchg   %ax,%ax
80105d8e:	66 90                	xchg   %ax,%ax

80105d90 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105d90:	a1 20 56 11 80       	mov    0x80115620,%eax
80105d95:	85 c0                	test   %eax,%eax
80105d97:	74 17                	je     80105db0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105d99:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105d9e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105d9f:	a8 01                	test   $0x1,%al
80105da1:	74 0d                	je     80105db0 <uartgetc+0x20>
80105da3:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105da8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105da9:	0f b6 c0             	movzbl %al,%eax
80105dac:	c3                   	ret
80105dad:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105db0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105db5:	c3                   	ret
80105db6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105dbd:	00 
80105dbe:	66 90                	xchg   %ax,%ax

80105dc0 <uartinit>:
{
80105dc0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105dc1:	31 c9                	xor    %ecx,%ecx
80105dc3:	89 c8                	mov    %ecx,%eax
80105dc5:	89 e5                	mov    %esp,%ebp
80105dc7:	57                   	push   %edi
80105dc8:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105dcd:	56                   	push   %esi
80105dce:	89 fa                	mov    %edi,%edx
80105dd0:	53                   	push   %ebx
80105dd1:	83 ec 1c             	sub    $0x1c,%esp
80105dd4:	ee                   	out    %al,(%dx)
80105dd5:	be fb 03 00 00       	mov    $0x3fb,%esi
80105dda:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105ddf:	89 f2                	mov    %esi,%edx
80105de1:	ee                   	out    %al,(%dx)
80105de2:	b8 0c 00 00 00       	mov    $0xc,%eax
80105de7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105dec:	ee                   	out    %al,(%dx)
80105ded:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105df2:	89 c8                	mov    %ecx,%eax
80105df4:	89 da                	mov    %ebx,%edx
80105df6:	ee                   	out    %al,(%dx)
80105df7:	b8 03 00 00 00       	mov    $0x3,%eax
80105dfc:	89 f2                	mov    %esi,%edx
80105dfe:	ee                   	out    %al,(%dx)
80105dff:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105e04:	89 c8                	mov    %ecx,%eax
80105e06:	ee                   	out    %al,(%dx)
80105e07:	b8 01 00 00 00       	mov    $0x1,%eax
80105e0c:	89 da                	mov    %ebx,%edx
80105e0e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105e0f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105e14:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105e15:	3c ff                	cmp    $0xff,%al
80105e17:	0f 84 7c 00 00 00    	je     80105e99 <uartinit+0xd9>
  uart = 1;
80105e1d:	c7 05 20 56 11 80 01 	movl   $0x1,0x80115620
80105e24:	00 00 00 
80105e27:	89 fa                	mov    %edi,%edx
80105e29:	ec                   	in     (%dx),%al
80105e2a:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e2f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105e30:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105e33:	bf 69 7d 10 80       	mov    $0x80107d69,%edi
80105e38:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
80105e3d:	6a 00                	push   $0x0
80105e3f:	6a 04                	push   $0x4
80105e41:	e8 9a c6 ff ff       	call   801024e0 <ioapicenable>
80105e46:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105e49:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
80105e4d:	8d 76 00             	lea    0x0(%esi),%esi
  if(!uart)
80105e50:	a1 20 56 11 80       	mov    0x80115620,%eax
80105e55:	85 c0                	test   %eax,%eax
80105e57:	74 32                	je     80105e8b <uartinit+0xcb>
80105e59:	89 f2                	mov    %esi,%edx
80105e5b:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105e5c:	a8 20                	test   $0x20,%al
80105e5e:	75 21                	jne    80105e81 <uartinit+0xc1>
80105e60:	bb 80 00 00 00       	mov    $0x80,%ebx
80105e65:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
80105e68:	83 ec 0c             	sub    $0xc,%esp
80105e6b:	6a 0a                	push   $0xa
80105e6d:	e8 5e cb ff ff       	call   801029d0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105e72:	83 c4 10             	add    $0x10,%esp
80105e75:	83 eb 01             	sub    $0x1,%ebx
80105e78:	74 07                	je     80105e81 <uartinit+0xc1>
80105e7a:	89 f2                	mov    %esi,%edx
80105e7c:	ec                   	in     (%dx),%al
80105e7d:	a8 20                	test   $0x20,%al
80105e7f:	74 e7                	je     80105e68 <uartinit+0xa8>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105e81:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e86:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
80105e8a:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80105e8b:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80105e8f:	83 c7 01             	add    $0x1,%edi
80105e92:	88 45 e7             	mov    %al,-0x19(%ebp)
80105e95:	84 c0                	test   %al,%al
80105e97:	75 b7                	jne    80105e50 <uartinit+0x90>
}
80105e99:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e9c:	5b                   	pop    %ebx
80105e9d:	5e                   	pop    %esi
80105e9e:	5f                   	pop    %edi
80105e9f:	5d                   	pop    %ebp
80105ea0:	c3                   	ret
80105ea1:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80105ea8:	00 
80105ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105eb0 <uartputc>:
  if(!uart)
80105eb0:	a1 20 56 11 80       	mov    0x80115620,%eax
80105eb5:	85 c0                	test   %eax,%eax
80105eb7:	74 4f                	je     80105f08 <uartputc+0x58>
{
80105eb9:	55                   	push   %ebp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105eba:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105ebf:	89 e5                	mov    %esp,%ebp
80105ec1:	56                   	push   %esi
80105ec2:	53                   	push   %ebx
80105ec3:	ec                   	in     (%dx),%al
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105ec4:	a8 20                	test   $0x20,%al
80105ec6:	75 29                	jne    80105ef1 <uartputc+0x41>
80105ec8:	bb 80 00 00 00       	mov    $0x80,%ebx
80105ecd:	be fd 03 00 00       	mov    $0x3fd,%esi
80105ed2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80105ed8:	83 ec 0c             	sub    $0xc,%esp
80105edb:	6a 0a                	push   $0xa
80105edd:	e8 ee ca ff ff       	call   801029d0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105ee2:	83 c4 10             	add    $0x10,%esp
80105ee5:	83 eb 01             	sub    $0x1,%ebx
80105ee8:	74 07                	je     80105ef1 <uartputc+0x41>
80105eea:	89 f2                	mov    %esi,%edx
80105eec:	ec                   	in     (%dx),%al
80105eed:	a8 20                	test   $0x20,%al
80105eef:	74 e7                	je     80105ed8 <uartputc+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105ef1:	8b 45 08             	mov    0x8(%ebp),%eax
80105ef4:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ef9:	ee                   	out    %al,(%dx)
}
80105efa:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105efd:	5b                   	pop    %ebx
80105efe:	5e                   	pop    %esi
80105eff:	5d                   	pop    %ebp
80105f00:	c3                   	ret
80105f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f08:	c3                   	ret
80105f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105f10 <uartintr>:

void
uartintr(void)
{
80105f10:	55                   	push   %ebp
80105f11:	89 e5                	mov    %esp,%ebp
80105f13:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105f16:	68 90 5d 10 80       	push   $0x80105d90
80105f1b:	e8 80 a9 ff ff       	call   801008a0 <consoleintr>
}
80105f20:	83 c4 10             	add    $0x10,%esp
80105f23:	c9                   	leave
80105f24:	c3                   	ret

80105f25 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105f25:	6a 00                	push   $0x0
  pushl $0
80105f27:	6a 00                	push   $0x0
  jmp alltraps
80105f29:	e9 ec fa ff ff       	jmp    80105a1a <alltraps>

80105f2e <vector1>:
.globl vector1
vector1:
  pushl $0
80105f2e:	6a 00                	push   $0x0
  pushl $1
80105f30:	6a 01                	push   $0x1
  jmp alltraps
80105f32:	e9 e3 fa ff ff       	jmp    80105a1a <alltraps>

80105f37 <vector2>:
.globl vector2
vector2:
  pushl $0
80105f37:	6a 00                	push   $0x0
  pushl $2
80105f39:	6a 02                	push   $0x2
  jmp alltraps
80105f3b:	e9 da fa ff ff       	jmp    80105a1a <alltraps>

80105f40 <vector3>:
.globl vector3
vector3:
  pushl $0
80105f40:	6a 00                	push   $0x0
  pushl $3
80105f42:	6a 03                	push   $0x3
  jmp alltraps
80105f44:	e9 d1 fa ff ff       	jmp    80105a1a <alltraps>

80105f49 <vector4>:
.globl vector4
vector4:
  pushl $0
80105f49:	6a 00                	push   $0x0
  pushl $4
80105f4b:	6a 04                	push   $0x4
  jmp alltraps
80105f4d:	e9 c8 fa ff ff       	jmp    80105a1a <alltraps>

80105f52 <vector5>:
.globl vector5
vector5:
  pushl $0
80105f52:	6a 00                	push   $0x0
  pushl $5
80105f54:	6a 05                	push   $0x5
  jmp alltraps
80105f56:	e9 bf fa ff ff       	jmp    80105a1a <alltraps>

80105f5b <vector6>:
.globl vector6
vector6:
  pushl $0
80105f5b:	6a 00                	push   $0x0
  pushl $6
80105f5d:	6a 06                	push   $0x6
  jmp alltraps
80105f5f:	e9 b6 fa ff ff       	jmp    80105a1a <alltraps>

80105f64 <vector7>:
.globl vector7
vector7:
  pushl $0
80105f64:	6a 00                	push   $0x0
  pushl $7
80105f66:	6a 07                	push   $0x7
  jmp alltraps
80105f68:	e9 ad fa ff ff       	jmp    80105a1a <alltraps>

80105f6d <vector8>:
.globl vector8
vector8:
  pushl $8
80105f6d:	6a 08                	push   $0x8
  jmp alltraps
80105f6f:	e9 a6 fa ff ff       	jmp    80105a1a <alltraps>

80105f74 <vector9>:
.globl vector9
vector9:
  pushl $0
80105f74:	6a 00                	push   $0x0
  pushl $9
80105f76:	6a 09                	push   $0x9
  jmp alltraps
80105f78:	e9 9d fa ff ff       	jmp    80105a1a <alltraps>

80105f7d <vector10>:
.globl vector10
vector10:
  pushl $10
80105f7d:	6a 0a                	push   $0xa
  jmp alltraps
80105f7f:	e9 96 fa ff ff       	jmp    80105a1a <alltraps>

80105f84 <vector11>:
.globl vector11
vector11:
  pushl $11
80105f84:	6a 0b                	push   $0xb
  jmp alltraps
80105f86:	e9 8f fa ff ff       	jmp    80105a1a <alltraps>

80105f8b <vector12>:
.globl vector12
vector12:
  pushl $12
80105f8b:	6a 0c                	push   $0xc
  jmp alltraps
80105f8d:	e9 88 fa ff ff       	jmp    80105a1a <alltraps>

80105f92 <vector13>:
.globl vector13
vector13:
  pushl $13
80105f92:	6a 0d                	push   $0xd
  jmp alltraps
80105f94:	e9 81 fa ff ff       	jmp    80105a1a <alltraps>

80105f99 <vector14>:
.globl vector14
vector14:
  pushl $14
80105f99:	6a 0e                	push   $0xe
  jmp alltraps
80105f9b:	e9 7a fa ff ff       	jmp    80105a1a <alltraps>

80105fa0 <vector15>:
.globl vector15
vector15:
  pushl $0
80105fa0:	6a 00                	push   $0x0
  pushl $15
80105fa2:	6a 0f                	push   $0xf
  jmp alltraps
80105fa4:	e9 71 fa ff ff       	jmp    80105a1a <alltraps>

80105fa9 <vector16>:
.globl vector16
vector16:
  pushl $0
80105fa9:	6a 00                	push   $0x0
  pushl $16
80105fab:	6a 10                	push   $0x10
  jmp alltraps
80105fad:	e9 68 fa ff ff       	jmp    80105a1a <alltraps>

80105fb2 <vector17>:
.globl vector17
vector17:
  pushl $17
80105fb2:	6a 11                	push   $0x11
  jmp alltraps
80105fb4:	e9 61 fa ff ff       	jmp    80105a1a <alltraps>

80105fb9 <vector18>:
.globl vector18
vector18:
  pushl $0
80105fb9:	6a 00                	push   $0x0
  pushl $18
80105fbb:	6a 12                	push   $0x12
  jmp alltraps
80105fbd:	e9 58 fa ff ff       	jmp    80105a1a <alltraps>

80105fc2 <vector19>:
.globl vector19
vector19:
  pushl $0
80105fc2:	6a 00                	push   $0x0
  pushl $19
80105fc4:	6a 13                	push   $0x13
  jmp alltraps
80105fc6:	e9 4f fa ff ff       	jmp    80105a1a <alltraps>

80105fcb <vector20>:
.globl vector20
vector20:
  pushl $0
80105fcb:	6a 00                	push   $0x0
  pushl $20
80105fcd:	6a 14                	push   $0x14
  jmp alltraps
80105fcf:	e9 46 fa ff ff       	jmp    80105a1a <alltraps>

80105fd4 <vector21>:
.globl vector21
vector21:
  pushl $0
80105fd4:	6a 00                	push   $0x0
  pushl $21
80105fd6:	6a 15                	push   $0x15
  jmp alltraps
80105fd8:	e9 3d fa ff ff       	jmp    80105a1a <alltraps>

80105fdd <vector22>:
.globl vector22
vector22:
  pushl $0
80105fdd:	6a 00                	push   $0x0
  pushl $22
80105fdf:	6a 16                	push   $0x16
  jmp alltraps
80105fe1:	e9 34 fa ff ff       	jmp    80105a1a <alltraps>

80105fe6 <vector23>:
.globl vector23
vector23:
  pushl $0
80105fe6:	6a 00                	push   $0x0
  pushl $23
80105fe8:	6a 17                	push   $0x17
  jmp alltraps
80105fea:	e9 2b fa ff ff       	jmp    80105a1a <alltraps>

80105fef <vector24>:
.globl vector24
vector24:
  pushl $0
80105fef:	6a 00                	push   $0x0
  pushl $24
80105ff1:	6a 18                	push   $0x18
  jmp alltraps
80105ff3:	e9 22 fa ff ff       	jmp    80105a1a <alltraps>

80105ff8 <vector25>:
.globl vector25
vector25:
  pushl $0
80105ff8:	6a 00                	push   $0x0
  pushl $25
80105ffa:	6a 19                	push   $0x19
  jmp alltraps
80105ffc:	e9 19 fa ff ff       	jmp    80105a1a <alltraps>

80106001 <vector26>:
.globl vector26
vector26:
  pushl $0
80106001:	6a 00                	push   $0x0
  pushl $26
80106003:	6a 1a                	push   $0x1a
  jmp alltraps
80106005:	e9 10 fa ff ff       	jmp    80105a1a <alltraps>

8010600a <vector27>:
.globl vector27
vector27:
  pushl $0
8010600a:	6a 00                	push   $0x0
  pushl $27
8010600c:	6a 1b                	push   $0x1b
  jmp alltraps
8010600e:	e9 07 fa ff ff       	jmp    80105a1a <alltraps>

80106013 <vector28>:
.globl vector28
vector28:
  pushl $0
80106013:	6a 00                	push   $0x0
  pushl $28
80106015:	6a 1c                	push   $0x1c
  jmp alltraps
80106017:	e9 fe f9 ff ff       	jmp    80105a1a <alltraps>

8010601c <vector29>:
.globl vector29
vector29:
  pushl $0
8010601c:	6a 00                	push   $0x0
  pushl $29
8010601e:	6a 1d                	push   $0x1d
  jmp alltraps
80106020:	e9 f5 f9 ff ff       	jmp    80105a1a <alltraps>

80106025 <vector30>:
.globl vector30
vector30:
  pushl $0
80106025:	6a 00                	push   $0x0
  pushl $30
80106027:	6a 1e                	push   $0x1e
  jmp alltraps
80106029:	e9 ec f9 ff ff       	jmp    80105a1a <alltraps>

8010602e <vector31>:
.globl vector31
vector31:
  pushl $0
8010602e:	6a 00                	push   $0x0
  pushl $31
80106030:	6a 1f                	push   $0x1f
  jmp alltraps
80106032:	e9 e3 f9 ff ff       	jmp    80105a1a <alltraps>

80106037 <vector32>:
.globl vector32
vector32:
  pushl $0
80106037:	6a 00                	push   $0x0
  pushl $32
80106039:	6a 20                	push   $0x20
  jmp alltraps
8010603b:	e9 da f9 ff ff       	jmp    80105a1a <alltraps>

80106040 <vector33>:
.globl vector33
vector33:
  pushl $0
80106040:	6a 00                	push   $0x0
  pushl $33
80106042:	6a 21                	push   $0x21
  jmp alltraps
80106044:	e9 d1 f9 ff ff       	jmp    80105a1a <alltraps>

80106049 <vector34>:
.globl vector34
vector34:
  pushl $0
80106049:	6a 00                	push   $0x0
  pushl $34
8010604b:	6a 22                	push   $0x22
  jmp alltraps
8010604d:	e9 c8 f9 ff ff       	jmp    80105a1a <alltraps>

80106052 <vector35>:
.globl vector35
vector35:
  pushl $0
80106052:	6a 00                	push   $0x0
  pushl $35
80106054:	6a 23                	push   $0x23
  jmp alltraps
80106056:	e9 bf f9 ff ff       	jmp    80105a1a <alltraps>

8010605b <vector36>:
.globl vector36
vector36:
  pushl $0
8010605b:	6a 00                	push   $0x0
  pushl $36
8010605d:	6a 24                	push   $0x24
  jmp alltraps
8010605f:	e9 b6 f9 ff ff       	jmp    80105a1a <alltraps>

80106064 <vector37>:
.globl vector37
vector37:
  pushl $0
80106064:	6a 00                	push   $0x0
  pushl $37
80106066:	6a 25                	push   $0x25
  jmp alltraps
80106068:	e9 ad f9 ff ff       	jmp    80105a1a <alltraps>

8010606d <vector38>:
.globl vector38
vector38:
  pushl $0
8010606d:	6a 00                	push   $0x0
  pushl $38
8010606f:	6a 26                	push   $0x26
  jmp alltraps
80106071:	e9 a4 f9 ff ff       	jmp    80105a1a <alltraps>

80106076 <vector39>:
.globl vector39
vector39:
  pushl $0
80106076:	6a 00                	push   $0x0
  pushl $39
80106078:	6a 27                	push   $0x27
  jmp alltraps
8010607a:	e9 9b f9 ff ff       	jmp    80105a1a <alltraps>

8010607f <vector40>:
.globl vector40
vector40:
  pushl $0
8010607f:	6a 00                	push   $0x0
  pushl $40
80106081:	6a 28                	push   $0x28
  jmp alltraps
80106083:	e9 92 f9 ff ff       	jmp    80105a1a <alltraps>

80106088 <vector41>:
.globl vector41
vector41:
  pushl $0
80106088:	6a 00                	push   $0x0
  pushl $41
8010608a:	6a 29                	push   $0x29
  jmp alltraps
8010608c:	e9 89 f9 ff ff       	jmp    80105a1a <alltraps>

80106091 <vector42>:
.globl vector42
vector42:
  pushl $0
80106091:	6a 00                	push   $0x0
  pushl $42
80106093:	6a 2a                	push   $0x2a
  jmp alltraps
80106095:	e9 80 f9 ff ff       	jmp    80105a1a <alltraps>

8010609a <vector43>:
.globl vector43
vector43:
  pushl $0
8010609a:	6a 00                	push   $0x0
  pushl $43
8010609c:	6a 2b                	push   $0x2b
  jmp alltraps
8010609e:	e9 77 f9 ff ff       	jmp    80105a1a <alltraps>

801060a3 <vector44>:
.globl vector44
vector44:
  pushl $0
801060a3:	6a 00                	push   $0x0
  pushl $44
801060a5:	6a 2c                	push   $0x2c
  jmp alltraps
801060a7:	e9 6e f9 ff ff       	jmp    80105a1a <alltraps>

801060ac <vector45>:
.globl vector45
vector45:
  pushl $0
801060ac:	6a 00                	push   $0x0
  pushl $45
801060ae:	6a 2d                	push   $0x2d
  jmp alltraps
801060b0:	e9 65 f9 ff ff       	jmp    80105a1a <alltraps>

801060b5 <vector46>:
.globl vector46
vector46:
  pushl $0
801060b5:	6a 00                	push   $0x0
  pushl $46
801060b7:	6a 2e                	push   $0x2e
  jmp alltraps
801060b9:	e9 5c f9 ff ff       	jmp    80105a1a <alltraps>

801060be <vector47>:
.globl vector47
vector47:
  pushl $0
801060be:	6a 00                	push   $0x0
  pushl $47
801060c0:	6a 2f                	push   $0x2f
  jmp alltraps
801060c2:	e9 53 f9 ff ff       	jmp    80105a1a <alltraps>

801060c7 <vector48>:
.globl vector48
vector48:
  pushl $0
801060c7:	6a 00                	push   $0x0
  pushl $48
801060c9:	6a 30                	push   $0x30
  jmp alltraps
801060cb:	e9 4a f9 ff ff       	jmp    80105a1a <alltraps>

801060d0 <vector49>:
.globl vector49
vector49:
  pushl $0
801060d0:	6a 00                	push   $0x0
  pushl $49
801060d2:	6a 31                	push   $0x31
  jmp alltraps
801060d4:	e9 41 f9 ff ff       	jmp    80105a1a <alltraps>

801060d9 <vector50>:
.globl vector50
vector50:
  pushl $0
801060d9:	6a 00                	push   $0x0
  pushl $50
801060db:	6a 32                	push   $0x32
  jmp alltraps
801060dd:	e9 38 f9 ff ff       	jmp    80105a1a <alltraps>

801060e2 <vector51>:
.globl vector51
vector51:
  pushl $0
801060e2:	6a 00                	push   $0x0
  pushl $51
801060e4:	6a 33                	push   $0x33
  jmp alltraps
801060e6:	e9 2f f9 ff ff       	jmp    80105a1a <alltraps>

801060eb <vector52>:
.globl vector52
vector52:
  pushl $0
801060eb:	6a 00                	push   $0x0
  pushl $52
801060ed:	6a 34                	push   $0x34
  jmp alltraps
801060ef:	e9 26 f9 ff ff       	jmp    80105a1a <alltraps>

801060f4 <vector53>:
.globl vector53
vector53:
  pushl $0
801060f4:	6a 00                	push   $0x0
  pushl $53
801060f6:	6a 35                	push   $0x35
  jmp alltraps
801060f8:	e9 1d f9 ff ff       	jmp    80105a1a <alltraps>

801060fd <vector54>:
.globl vector54
vector54:
  pushl $0
801060fd:	6a 00                	push   $0x0
  pushl $54
801060ff:	6a 36                	push   $0x36
  jmp alltraps
80106101:	e9 14 f9 ff ff       	jmp    80105a1a <alltraps>

80106106 <vector55>:
.globl vector55
vector55:
  pushl $0
80106106:	6a 00                	push   $0x0
  pushl $55
80106108:	6a 37                	push   $0x37
  jmp alltraps
8010610a:	e9 0b f9 ff ff       	jmp    80105a1a <alltraps>

8010610f <vector56>:
.globl vector56
vector56:
  pushl $0
8010610f:	6a 00                	push   $0x0
  pushl $56
80106111:	6a 38                	push   $0x38
  jmp alltraps
80106113:	e9 02 f9 ff ff       	jmp    80105a1a <alltraps>

80106118 <vector57>:
.globl vector57
vector57:
  pushl $0
80106118:	6a 00                	push   $0x0
  pushl $57
8010611a:	6a 39                	push   $0x39
  jmp alltraps
8010611c:	e9 f9 f8 ff ff       	jmp    80105a1a <alltraps>

80106121 <vector58>:
.globl vector58
vector58:
  pushl $0
80106121:	6a 00                	push   $0x0
  pushl $58
80106123:	6a 3a                	push   $0x3a
  jmp alltraps
80106125:	e9 f0 f8 ff ff       	jmp    80105a1a <alltraps>

8010612a <vector59>:
.globl vector59
vector59:
  pushl $0
8010612a:	6a 00                	push   $0x0
  pushl $59
8010612c:	6a 3b                	push   $0x3b
  jmp alltraps
8010612e:	e9 e7 f8 ff ff       	jmp    80105a1a <alltraps>

80106133 <vector60>:
.globl vector60
vector60:
  pushl $0
80106133:	6a 00                	push   $0x0
  pushl $60
80106135:	6a 3c                	push   $0x3c
  jmp alltraps
80106137:	e9 de f8 ff ff       	jmp    80105a1a <alltraps>

8010613c <vector61>:
.globl vector61
vector61:
  pushl $0
8010613c:	6a 00                	push   $0x0
  pushl $61
8010613e:	6a 3d                	push   $0x3d
  jmp alltraps
80106140:	e9 d5 f8 ff ff       	jmp    80105a1a <alltraps>

80106145 <vector62>:
.globl vector62
vector62:
  pushl $0
80106145:	6a 00                	push   $0x0
  pushl $62
80106147:	6a 3e                	push   $0x3e
  jmp alltraps
80106149:	e9 cc f8 ff ff       	jmp    80105a1a <alltraps>

8010614e <vector63>:
.globl vector63
vector63:
  pushl $0
8010614e:	6a 00                	push   $0x0
  pushl $63
80106150:	6a 3f                	push   $0x3f
  jmp alltraps
80106152:	e9 c3 f8 ff ff       	jmp    80105a1a <alltraps>

80106157 <vector64>:
.globl vector64
vector64:
  pushl $0
80106157:	6a 00                	push   $0x0
  pushl $64
80106159:	6a 40                	push   $0x40
  jmp alltraps
8010615b:	e9 ba f8 ff ff       	jmp    80105a1a <alltraps>

80106160 <vector65>:
.globl vector65
vector65:
  pushl $0
80106160:	6a 00                	push   $0x0
  pushl $65
80106162:	6a 41                	push   $0x41
  jmp alltraps
80106164:	e9 b1 f8 ff ff       	jmp    80105a1a <alltraps>

80106169 <vector66>:
.globl vector66
vector66:
  pushl $0
80106169:	6a 00                	push   $0x0
  pushl $66
8010616b:	6a 42                	push   $0x42
  jmp alltraps
8010616d:	e9 a8 f8 ff ff       	jmp    80105a1a <alltraps>

80106172 <vector67>:
.globl vector67
vector67:
  pushl $0
80106172:	6a 00                	push   $0x0
  pushl $67
80106174:	6a 43                	push   $0x43
  jmp alltraps
80106176:	e9 9f f8 ff ff       	jmp    80105a1a <alltraps>

8010617b <vector68>:
.globl vector68
vector68:
  pushl $0
8010617b:	6a 00                	push   $0x0
  pushl $68
8010617d:	6a 44                	push   $0x44
  jmp alltraps
8010617f:	e9 96 f8 ff ff       	jmp    80105a1a <alltraps>

80106184 <vector69>:
.globl vector69
vector69:
  pushl $0
80106184:	6a 00                	push   $0x0
  pushl $69
80106186:	6a 45                	push   $0x45
  jmp alltraps
80106188:	e9 8d f8 ff ff       	jmp    80105a1a <alltraps>

8010618d <vector70>:
.globl vector70
vector70:
  pushl $0
8010618d:	6a 00                	push   $0x0
  pushl $70
8010618f:	6a 46                	push   $0x46
  jmp alltraps
80106191:	e9 84 f8 ff ff       	jmp    80105a1a <alltraps>

80106196 <vector71>:
.globl vector71
vector71:
  pushl $0
80106196:	6a 00                	push   $0x0
  pushl $71
80106198:	6a 47                	push   $0x47
  jmp alltraps
8010619a:	e9 7b f8 ff ff       	jmp    80105a1a <alltraps>

8010619f <vector72>:
.globl vector72
vector72:
  pushl $0
8010619f:	6a 00                	push   $0x0
  pushl $72
801061a1:	6a 48                	push   $0x48
  jmp alltraps
801061a3:	e9 72 f8 ff ff       	jmp    80105a1a <alltraps>

801061a8 <vector73>:
.globl vector73
vector73:
  pushl $0
801061a8:	6a 00                	push   $0x0
  pushl $73
801061aa:	6a 49                	push   $0x49
  jmp alltraps
801061ac:	e9 69 f8 ff ff       	jmp    80105a1a <alltraps>

801061b1 <vector74>:
.globl vector74
vector74:
  pushl $0
801061b1:	6a 00                	push   $0x0
  pushl $74
801061b3:	6a 4a                	push   $0x4a
  jmp alltraps
801061b5:	e9 60 f8 ff ff       	jmp    80105a1a <alltraps>

801061ba <vector75>:
.globl vector75
vector75:
  pushl $0
801061ba:	6a 00                	push   $0x0
  pushl $75
801061bc:	6a 4b                	push   $0x4b
  jmp alltraps
801061be:	e9 57 f8 ff ff       	jmp    80105a1a <alltraps>

801061c3 <vector76>:
.globl vector76
vector76:
  pushl $0
801061c3:	6a 00                	push   $0x0
  pushl $76
801061c5:	6a 4c                	push   $0x4c
  jmp alltraps
801061c7:	e9 4e f8 ff ff       	jmp    80105a1a <alltraps>

801061cc <vector77>:
.globl vector77
vector77:
  pushl $0
801061cc:	6a 00                	push   $0x0
  pushl $77
801061ce:	6a 4d                	push   $0x4d
  jmp alltraps
801061d0:	e9 45 f8 ff ff       	jmp    80105a1a <alltraps>

801061d5 <vector78>:
.globl vector78
vector78:
  pushl $0
801061d5:	6a 00                	push   $0x0
  pushl $78
801061d7:	6a 4e                	push   $0x4e
  jmp alltraps
801061d9:	e9 3c f8 ff ff       	jmp    80105a1a <alltraps>

801061de <vector79>:
.globl vector79
vector79:
  pushl $0
801061de:	6a 00                	push   $0x0
  pushl $79
801061e0:	6a 4f                	push   $0x4f
  jmp alltraps
801061e2:	e9 33 f8 ff ff       	jmp    80105a1a <alltraps>

801061e7 <vector80>:
.globl vector80
vector80:
  pushl $0
801061e7:	6a 00                	push   $0x0
  pushl $80
801061e9:	6a 50                	push   $0x50
  jmp alltraps
801061eb:	e9 2a f8 ff ff       	jmp    80105a1a <alltraps>

801061f0 <vector81>:
.globl vector81
vector81:
  pushl $0
801061f0:	6a 00                	push   $0x0
  pushl $81
801061f2:	6a 51                	push   $0x51
  jmp alltraps
801061f4:	e9 21 f8 ff ff       	jmp    80105a1a <alltraps>

801061f9 <vector82>:
.globl vector82
vector82:
  pushl $0
801061f9:	6a 00                	push   $0x0
  pushl $82
801061fb:	6a 52                	push   $0x52
  jmp alltraps
801061fd:	e9 18 f8 ff ff       	jmp    80105a1a <alltraps>

80106202 <vector83>:
.globl vector83
vector83:
  pushl $0
80106202:	6a 00                	push   $0x0
  pushl $83
80106204:	6a 53                	push   $0x53
  jmp alltraps
80106206:	e9 0f f8 ff ff       	jmp    80105a1a <alltraps>

8010620b <vector84>:
.globl vector84
vector84:
  pushl $0
8010620b:	6a 00                	push   $0x0
  pushl $84
8010620d:	6a 54                	push   $0x54
  jmp alltraps
8010620f:	e9 06 f8 ff ff       	jmp    80105a1a <alltraps>

80106214 <vector85>:
.globl vector85
vector85:
  pushl $0
80106214:	6a 00                	push   $0x0
  pushl $85
80106216:	6a 55                	push   $0x55
  jmp alltraps
80106218:	e9 fd f7 ff ff       	jmp    80105a1a <alltraps>

8010621d <vector86>:
.globl vector86
vector86:
  pushl $0
8010621d:	6a 00                	push   $0x0
  pushl $86
8010621f:	6a 56                	push   $0x56
  jmp alltraps
80106221:	e9 f4 f7 ff ff       	jmp    80105a1a <alltraps>

80106226 <vector87>:
.globl vector87
vector87:
  pushl $0
80106226:	6a 00                	push   $0x0
  pushl $87
80106228:	6a 57                	push   $0x57
  jmp alltraps
8010622a:	e9 eb f7 ff ff       	jmp    80105a1a <alltraps>

8010622f <vector88>:
.globl vector88
vector88:
  pushl $0
8010622f:	6a 00                	push   $0x0
  pushl $88
80106231:	6a 58                	push   $0x58
  jmp alltraps
80106233:	e9 e2 f7 ff ff       	jmp    80105a1a <alltraps>

80106238 <vector89>:
.globl vector89
vector89:
  pushl $0
80106238:	6a 00                	push   $0x0
  pushl $89
8010623a:	6a 59                	push   $0x59
  jmp alltraps
8010623c:	e9 d9 f7 ff ff       	jmp    80105a1a <alltraps>

80106241 <vector90>:
.globl vector90
vector90:
  pushl $0
80106241:	6a 00                	push   $0x0
  pushl $90
80106243:	6a 5a                	push   $0x5a
  jmp alltraps
80106245:	e9 d0 f7 ff ff       	jmp    80105a1a <alltraps>

8010624a <vector91>:
.globl vector91
vector91:
  pushl $0
8010624a:	6a 00                	push   $0x0
  pushl $91
8010624c:	6a 5b                	push   $0x5b
  jmp alltraps
8010624e:	e9 c7 f7 ff ff       	jmp    80105a1a <alltraps>

80106253 <vector92>:
.globl vector92
vector92:
  pushl $0
80106253:	6a 00                	push   $0x0
  pushl $92
80106255:	6a 5c                	push   $0x5c
  jmp alltraps
80106257:	e9 be f7 ff ff       	jmp    80105a1a <alltraps>

8010625c <vector93>:
.globl vector93
vector93:
  pushl $0
8010625c:	6a 00                	push   $0x0
  pushl $93
8010625e:	6a 5d                	push   $0x5d
  jmp alltraps
80106260:	e9 b5 f7 ff ff       	jmp    80105a1a <alltraps>

80106265 <vector94>:
.globl vector94
vector94:
  pushl $0
80106265:	6a 00                	push   $0x0
  pushl $94
80106267:	6a 5e                	push   $0x5e
  jmp alltraps
80106269:	e9 ac f7 ff ff       	jmp    80105a1a <alltraps>

8010626e <vector95>:
.globl vector95
vector95:
  pushl $0
8010626e:	6a 00                	push   $0x0
  pushl $95
80106270:	6a 5f                	push   $0x5f
  jmp alltraps
80106272:	e9 a3 f7 ff ff       	jmp    80105a1a <alltraps>

80106277 <vector96>:
.globl vector96
vector96:
  pushl $0
80106277:	6a 00                	push   $0x0
  pushl $96
80106279:	6a 60                	push   $0x60
  jmp alltraps
8010627b:	e9 9a f7 ff ff       	jmp    80105a1a <alltraps>

80106280 <vector97>:
.globl vector97
vector97:
  pushl $0
80106280:	6a 00                	push   $0x0
  pushl $97
80106282:	6a 61                	push   $0x61
  jmp alltraps
80106284:	e9 91 f7 ff ff       	jmp    80105a1a <alltraps>

80106289 <vector98>:
.globl vector98
vector98:
  pushl $0
80106289:	6a 00                	push   $0x0
  pushl $98
8010628b:	6a 62                	push   $0x62
  jmp alltraps
8010628d:	e9 88 f7 ff ff       	jmp    80105a1a <alltraps>

80106292 <vector99>:
.globl vector99
vector99:
  pushl $0
80106292:	6a 00                	push   $0x0
  pushl $99
80106294:	6a 63                	push   $0x63
  jmp alltraps
80106296:	e9 7f f7 ff ff       	jmp    80105a1a <alltraps>

8010629b <vector100>:
.globl vector100
vector100:
  pushl $0
8010629b:	6a 00                	push   $0x0
  pushl $100
8010629d:	6a 64                	push   $0x64
  jmp alltraps
8010629f:	e9 76 f7 ff ff       	jmp    80105a1a <alltraps>

801062a4 <vector101>:
.globl vector101
vector101:
  pushl $0
801062a4:	6a 00                	push   $0x0
  pushl $101
801062a6:	6a 65                	push   $0x65
  jmp alltraps
801062a8:	e9 6d f7 ff ff       	jmp    80105a1a <alltraps>

801062ad <vector102>:
.globl vector102
vector102:
  pushl $0
801062ad:	6a 00                	push   $0x0
  pushl $102
801062af:	6a 66                	push   $0x66
  jmp alltraps
801062b1:	e9 64 f7 ff ff       	jmp    80105a1a <alltraps>

801062b6 <vector103>:
.globl vector103
vector103:
  pushl $0
801062b6:	6a 00                	push   $0x0
  pushl $103
801062b8:	6a 67                	push   $0x67
  jmp alltraps
801062ba:	e9 5b f7 ff ff       	jmp    80105a1a <alltraps>

801062bf <vector104>:
.globl vector104
vector104:
  pushl $0
801062bf:	6a 00                	push   $0x0
  pushl $104
801062c1:	6a 68                	push   $0x68
  jmp alltraps
801062c3:	e9 52 f7 ff ff       	jmp    80105a1a <alltraps>

801062c8 <vector105>:
.globl vector105
vector105:
  pushl $0
801062c8:	6a 00                	push   $0x0
  pushl $105
801062ca:	6a 69                	push   $0x69
  jmp alltraps
801062cc:	e9 49 f7 ff ff       	jmp    80105a1a <alltraps>

801062d1 <vector106>:
.globl vector106
vector106:
  pushl $0
801062d1:	6a 00                	push   $0x0
  pushl $106
801062d3:	6a 6a                	push   $0x6a
  jmp alltraps
801062d5:	e9 40 f7 ff ff       	jmp    80105a1a <alltraps>

801062da <vector107>:
.globl vector107
vector107:
  pushl $0
801062da:	6a 00                	push   $0x0
  pushl $107
801062dc:	6a 6b                	push   $0x6b
  jmp alltraps
801062de:	e9 37 f7 ff ff       	jmp    80105a1a <alltraps>

801062e3 <vector108>:
.globl vector108
vector108:
  pushl $0
801062e3:	6a 00                	push   $0x0
  pushl $108
801062e5:	6a 6c                	push   $0x6c
  jmp alltraps
801062e7:	e9 2e f7 ff ff       	jmp    80105a1a <alltraps>

801062ec <vector109>:
.globl vector109
vector109:
  pushl $0
801062ec:	6a 00                	push   $0x0
  pushl $109
801062ee:	6a 6d                	push   $0x6d
  jmp alltraps
801062f0:	e9 25 f7 ff ff       	jmp    80105a1a <alltraps>

801062f5 <vector110>:
.globl vector110
vector110:
  pushl $0
801062f5:	6a 00                	push   $0x0
  pushl $110
801062f7:	6a 6e                	push   $0x6e
  jmp alltraps
801062f9:	e9 1c f7 ff ff       	jmp    80105a1a <alltraps>

801062fe <vector111>:
.globl vector111
vector111:
  pushl $0
801062fe:	6a 00                	push   $0x0
  pushl $111
80106300:	6a 6f                	push   $0x6f
  jmp alltraps
80106302:	e9 13 f7 ff ff       	jmp    80105a1a <alltraps>

80106307 <vector112>:
.globl vector112
vector112:
  pushl $0
80106307:	6a 00                	push   $0x0
  pushl $112
80106309:	6a 70                	push   $0x70
  jmp alltraps
8010630b:	e9 0a f7 ff ff       	jmp    80105a1a <alltraps>

80106310 <vector113>:
.globl vector113
vector113:
  pushl $0
80106310:	6a 00                	push   $0x0
  pushl $113
80106312:	6a 71                	push   $0x71
  jmp alltraps
80106314:	e9 01 f7 ff ff       	jmp    80105a1a <alltraps>

80106319 <vector114>:
.globl vector114
vector114:
  pushl $0
80106319:	6a 00                	push   $0x0
  pushl $114
8010631b:	6a 72                	push   $0x72
  jmp alltraps
8010631d:	e9 f8 f6 ff ff       	jmp    80105a1a <alltraps>

80106322 <vector115>:
.globl vector115
vector115:
  pushl $0
80106322:	6a 00                	push   $0x0
  pushl $115
80106324:	6a 73                	push   $0x73
  jmp alltraps
80106326:	e9 ef f6 ff ff       	jmp    80105a1a <alltraps>

8010632b <vector116>:
.globl vector116
vector116:
  pushl $0
8010632b:	6a 00                	push   $0x0
  pushl $116
8010632d:	6a 74                	push   $0x74
  jmp alltraps
8010632f:	e9 e6 f6 ff ff       	jmp    80105a1a <alltraps>

80106334 <vector117>:
.globl vector117
vector117:
  pushl $0
80106334:	6a 00                	push   $0x0
  pushl $117
80106336:	6a 75                	push   $0x75
  jmp alltraps
80106338:	e9 dd f6 ff ff       	jmp    80105a1a <alltraps>

8010633d <vector118>:
.globl vector118
vector118:
  pushl $0
8010633d:	6a 00                	push   $0x0
  pushl $118
8010633f:	6a 76                	push   $0x76
  jmp alltraps
80106341:	e9 d4 f6 ff ff       	jmp    80105a1a <alltraps>

80106346 <vector119>:
.globl vector119
vector119:
  pushl $0
80106346:	6a 00                	push   $0x0
  pushl $119
80106348:	6a 77                	push   $0x77
  jmp alltraps
8010634a:	e9 cb f6 ff ff       	jmp    80105a1a <alltraps>

8010634f <vector120>:
.globl vector120
vector120:
  pushl $0
8010634f:	6a 00                	push   $0x0
  pushl $120
80106351:	6a 78                	push   $0x78
  jmp alltraps
80106353:	e9 c2 f6 ff ff       	jmp    80105a1a <alltraps>

80106358 <vector121>:
.globl vector121
vector121:
  pushl $0
80106358:	6a 00                	push   $0x0
  pushl $121
8010635a:	6a 79                	push   $0x79
  jmp alltraps
8010635c:	e9 b9 f6 ff ff       	jmp    80105a1a <alltraps>

80106361 <vector122>:
.globl vector122
vector122:
  pushl $0
80106361:	6a 00                	push   $0x0
  pushl $122
80106363:	6a 7a                	push   $0x7a
  jmp alltraps
80106365:	e9 b0 f6 ff ff       	jmp    80105a1a <alltraps>

8010636a <vector123>:
.globl vector123
vector123:
  pushl $0
8010636a:	6a 00                	push   $0x0
  pushl $123
8010636c:	6a 7b                	push   $0x7b
  jmp alltraps
8010636e:	e9 a7 f6 ff ff       	jmp    80105a1a <alltraps>

80106373 <vector124>:
.globl vector124
vector124:
  pushl $0
80106373:	6a 00                	push   $0x0
  pushl $124
80106375:	6a 7c                	push   $0x7c
  jmp alltraps
80106377:	e9 9e f6 ff ff       	jmp    80105a1a <alltraps>

8010637c <vector125>:
.globl vector125
vector125:
  pushl $0
8010637c:	6a 00                	push   $0x0
  pushl $125
8010637e:	6a 7d                	push   $0x7d
  jmp alltraps
80106380:	e9 95 f6 ff ff       	jmp    80105a1a <alltraps>

80106385 <vector126>:
.globl vector126
vector126:
  pushl $0
80106385:	6a 00                	push   $0x0
  pushl $126
80106387:	6a 7e                	push   $0x7e
  jmp alltraps
80106389:	e9 8c f6 ff ff       	jmp    80105a1a <alltraps>

8010638e <vector127>:
.globl vector127
vector127:
  pushl $0
8010638e:	6a 00                	push   $0x0
  pushl $127
80106390:	6a 7f                	push   $0x7f
  jmp alltraps
80106392:	e9 83 f6 ff ff       	jmp    80105a1a <alltraps>

80106397 <vector128>:
.globl vector128
vector128:
  pushl $0
80106397:	6a 00                	push   $0x0
  pushl $128
80106399:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010639e:	e9 77 f6 ff ff       	jmp    80105a1a <alltraps>

801063a3 <vector129>:
.globl vector129
vector129:
  pushl $0
801063a3:	6a 00                	push   $0x0
  pushl $129
801063a5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801063aa:	e9 6b f6 ff ff       	jmp    80105a1a <alltraps>

801063af <vector130>:
.globl vector130
vector130:
  pushl $0
801063af:	6a 00                	push   $0x0
  pushl $130
801063b1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801063b6:	e9 5f f6 ff ff       	jmp    80105a1a <alltraps>

801063bb <vector131>:
.globl vector131
vector131:
  pushl $0
801063bb:	6a 00                	push   $0x0
  pushl $131
801063bd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801063c2:	e9 53 f6 ff ff       	jmp    80105a1a <alltraps>

801063c7 <vector132>:
.globl vector132
vector132:
  pushl $0
801063c7:	6a 00                	push   $0x0
  pushl $132
801063c9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801063ce:	e9 47 f6 ff ff       	jmp    80105a1a <alltraps>

801063d3 <vector133>:
.globl vector133
vector133:
  pushl $0
801063d3:	6a 00                	push   $0x0
  pushl $133
801063d5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801063da:	e9 3b f6 ff ff       	jmp    80105a1a <alltraps>

801063df <vector134>:
.globl vector134
vector134:
  pushl $0
801063df:	6a 00                	push   $0x0
  pushl $134
801063e1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801063e6:	e9 2f f6 ff ff       	jmp    80105a1a <alltraps>

801063eb <vector135>:
.globl vector135
vector135:
  pushl $0
801063eb:	6a 00                	push   $0x0
  pushl $135
801063ed:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801063f2:	e9 23 f6 ff ff       	jmp    80105a1a <alltraps>

801063f7 <vector136>:
.globl vector136
vector136:
  pushl $0
801063f7:	6a 00                	push   $0x0
  pushl $136
801063f9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801063fe:	e9 17 f6 ff ff       	jmp    80105a1a <alltraps>

80106403 <vector137>:
.globl vector137
vector137:
  pushl $0
80106403:	6a 00                	push   $0x0
  pushl $137
80106405:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010640a:	e9 0b f6 ff ff       	jmp    80105a1a <alltraps>

8010640f <vector138>:
.globl vector138
vector138:
  pushl $0
8010640f:	6a 00                	push   $0x0
  pushl $138
80106411:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106416:	e9 ff f5 ff ff       	jmp    80105a1a <alltraps>

8010641b <vector139>:
.globl vector139
vector139:
  pushl $0
8010641b:	6a 00                	push   $0x0
  pushl $139
8010641d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106422:	e9 f3 f5 ff ff       	jmp    80105a1a <alltraps>

80106427 <vector140>:
.globl vector140
vector140:
  pushl $0
80106427:	6a 00                	push   $0x0
  pushl $140
80106429:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010642e:	e9 e7 f5 ff ff       	jmp    80105a1a <alltraps>

80106433 <vector141>:
.globl vector141
vector141:
  pushl $0
80106433:	6a 00                	push   $0x0
  pushl $141
80106435:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010643a:	e9 db f5 ff ff       	jmp    80105a1a <alltraps>

8010643f <vector142>:
.globl vector142
vector142:
  pushl $0
8010643f:	6a 00                	push   $0x0
  pushl $142
80106441:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106446:	e9 cf f5 ff ff       	jmp    80105a1a <alltraps>

8010644b <vector143>:
.globl vector143
vector143:
  pushl $0
8010644b:	6a 00                	push   $0x0
  pushl $143
8010644d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106452:	e9 c3 f5 ff ff       	jmp    80105a1a <alltraps>

80106457 <vector144>:
.globl vector144
vector144:
  pushl $0
80106457:	6a 00                	push   $0x0
  pushl $144
80106459:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010645e:	e9 b7 f5 ff ff       	jmp    80105a1a <alltraps>

80106463 <vector145>:
.globl vector145
vector145:
  pushl $0
80106463:	6a 00                	push   $0x0
  pushl $145
80106465:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010646a:	e9 ab f5 ff ff       	jmp    80105a1a <alltraps>

8010646f <vector146>:
.globl vector146
vector146:
  pushl $0
8010646f:	6a 00                	push   $0x0
  pushl $146
80106471:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106476:	e9 9f f5 ff ff       	jmp    80105a1a <alltraps>

8010647b <vector147>:
.globl vector147
vector147:
  pushl $0
8010647b:	6a 00                	push   $0x0
  pushl $147
8010647d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106482:	e9 93 f5 ff ff       	jmp    80105a1a <alltraps>

80106487 <vector148>:
.globl vector148
vector148:
  pushl $0
80106487:	6a 00                	push   $0x0
  pushl $148
80106489:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010648e:	e9 87 f5 ff ff       	jmp    80105a1a <alltraps>

80106493 <vector149>:
.globl vector149
vector149:
  pushl $0
80106493:	6a 00                	push   $0x0
  pushl $149
80106495:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010649a:	e9 7b f5 ff ff       	jmp    80105a1a <alltraps>

8010649f <vector150>:
.globl vector150
vector150:
  pushl $0
8010649f:	6a 00                	push   $0x0
  pushl $150
801064a1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801064a6:	e9 6f f5 ff ff       	jmp    80105a1a <alltraps>

801064ab <vector151>:
.globl vector151
vector151:
  pushl $0
801064ab:	6a 00                	push   $0x0
  pushl $151
801064ad:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801064b2:	e9 63 f5 ff ff       	jmp    80105a1a <alltraps>

801064b7 <vector152>:
.globl vector152
vector152:
  pushl $0
801064b7:	6a 00                	push   $0x0
  pushl $152
801064b9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801064be:	e9 57 f5 ff ff       	jmp    80105a1a <alltraps>

801064c3 <vector153>:
.globl vector153
vector153:
  pushl $0
801064c3:	6a 00                	push   $0x0
  pushl $153
801064c5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801064ca:	e9 4b f5 ff ff       	jmp    80105a1a <alltraps>

801064cf <vector154>:
.globl vector154
vector154:
  pushl $0
801064cf:	6a 00                	push   $0x0
  pushl $154
801064d1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801064d6:	e9 3f f5 ff ff       	jmp    80105a1a <alltraps>

801064db <vector155>:
.globl vector155
vector155:
  pushl $0
801064db:	6a 00                	push   $0x0
  pushl $155
801064dd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801064e2:	e9 33 f5 ff ff       	jmp    80105a1a <alltraps>

801064e7 <vector156>:
.globl vector156
vector156:
  pushl $0
801064e7:	6a 00                	push   $0x0
  pushl $156
801064e9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801064ee:	e9 27 f5 ff ff       	jmp    80105a1a <alltraps>

801064f3 <vector157>:
.globl vector157
vector157:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $157
801064f5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801064fa:	e9 1b f5 ff ff       	jmp    80105a1a <alltraps>

801064ff <vector158>:
.globl vector158
vector158:
  pushl $0
801064ff:	6a 00                	push   $0x0
  pushl $158
80106501:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106506:	e9 0f f5 ff ff       	jmp    80105a1a <alltraps>

8010650b <vector159>:
.globl vector159
vector159:
  pushl $0
8010650b:	6a 00                	push   $0x0
  pushl $159
8010650d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106512:	e9 03 f5 ff ff       	jmp    80105a1a <alltraps>

80106517 <vector160>:
.globl vector160
vector160:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $160
80106519:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010651e:	e9 f7 f4 ff ff       	jmp    80105a1a <alltraps>

80106523 <vector161>:
.globl vector161
vector161:
  pushl $0
80106523:	6a 00                	push   $0x0
  pushl $161
80106525:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010652a:	e9 eb f4 ff ff       	jmp    80105a1a <alltraps>

8010652f <vector162>:
.globl vector162
vector162:
  pushl $0
8010652f:	6a 00                	push   $0x0
  pushl $162
80106531:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106536:	e9 df f4 ff ff       	jmp    80105a1a <alltraps>

8010653b <vector163>:
.globl vector163
vector163:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $163
8010653d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106542:	e9 d3 f4 ff ff       	jmp    80105a1a <alltraps>

80106547 <vector164>:
.globl vector164
vector164:
  pushl $0
80106547:	6a 00                	push   $0x0
  pushl $164
80106549:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010654e:	e9 c7 f4 ff ff       	jmp    80105a1a <alltraps>

80106553 <vector165>:
.globl vector165
vector165:
  pushl $0
80106553:	6a 00                	push   $0x0
  pushl $165
80106555:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010655a:	e9 bb f4 ff ff       	jmp    80105a1a <alltraps>

8010655f <vector166>:
.globl vector166
vector166:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $166
80106561:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106566:	e9 af f4 ff ff       	jmp    80105a1a <alltraps>

8010656b <vector167>:
.globl vector167
vector167:
  pushl $0
8010656b:	6a 00                	push   $0x0
  pushl $167
8010656d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106572:	e9 a3 f4 ff ff       	jmp    80105a1a <alltraps>

80106577 <vector168>:
.globl vector168
vector168:
  pushl $0
80106577:	6a 00                	push   $0x0
  pushl $168
80106579:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010657e:	e9 97 f4 ff ff       	jmp    80105a1a <alltraps>

80106583 <vector169>:
.globl vector169
vector169:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $169
80106585:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010658a:	e9 8b f4 ff ff       	jmp    80105a1a <alltraps>

8010658f <vector170>:
.globl vector170
vector170:
  pushl $0
8010658f:	6a 00                	push   $0x0
  pushl $170
80106591:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106596:	e9 7f f4 ff ff       	jmp    80105a1a <alltraps>

8010659b <vector171>:
.globl vector171
vector171:
  pushl $0
8010659b:	6a 00                	push   $0x0
  pushl $171
8010659d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801065a2:	e9 73 f4 ff ff       	jmp    80105a1a <alltraps>

801065a7 <vector172>:
.globl vector172
vector172:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $172
801065a9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801065ae:	e9 67 f4 ff ff       	jmp    80105a1a <alltraps>

801065b3 <vector173>:
.globl vector173
vector173:
  pushl $0
801065b3:	6a 00                	push   $0x0
  pushl $173
801065b5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801065ba:	e9 5b f4 ff ff       	jmp    80105a1a <alltraps>

801065bf <vector174>:
.globl vector174
vector174:
  pushl $0
801065bf:	6a 00                	push   $0x0
  pushl $174
801065c1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801065c6:	e9 4f f4 ff ff       	jmp    80105a1a <alltraps>

801065cb <vector175>:
.globl vector175
vector175:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $175
801065cd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801065d2:	e9 43 f4 ff ff       	jmp    80105a1a <alltraps>

801065d7 <vector176>:
.globl vector176
vector176:
  pushl $0
801065d7:	6a 00                	push   $0x0
  pushl $176
801065d9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801065de:	e9 37 f4 ff ff       	jmp    80105a1a <alltraps>

801065e3 <vector177>:
.globl vector177
vector177:
  pushl $0
801065e3:	6a 00                	push   $0x0
  pushl $177
801065e5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801065ea:	e9 2b f4 ff ff       	jmp    80105a1a <alltraps>

801065ef <vector178>:
.globl vector178
vector178:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $178
801065f1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801065f6:	e9 1f f4 ff ff       	jmp    80105a1a <alltraps>

801065fb <vector179>:
.globl vector179
vector179:
  pushl $0
801065fb:	6a 00                	push   $0x0
  pushl $179
801065fd:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106602:	e9 13 f4 ff ff       	jmp    80105a1a <alltraps>

80106607 <vector180>:
.globl vector180
vector180:
  pushl $0
80106607:	6a 00                	push   $0x0
  pushl $180
80106609:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010660e:	e9 07 f4 ff ff       	jmp    80105a1a <alltraps>

80106613 <vector181>:
.globl vector181
vector181:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $181
80106615:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010661a:	e9 fb f3 ff ff       	jmp    80105a1a <alltraps>

8010661f <vector182>:
.globl vector182
vector182:
  pushl $0
8010661f:	6a 00                	push   $0x0
  pushl $182
80106621:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106626:	e9 ef f3 ff ff       	jmp    80105a1a <alltraps>

8010662b <vector183>:
.globl vector183
vector183:
  pushl $0
8010662b:	6a 00                	push   $0x0
  pushl $183
8010662d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106632:	e9 e3 f3 ff ff       	jmp    80105a1a <alltraps>

80106637 <vector184>:
.globl vector184
vector184:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $184
80106639:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010663e:	e9 d7 f3 ff ff       	jmp    80105a1a <alltraps>

80106643 <vector185>:
.globl vector185
vector185:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $185
80106645:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010664a:	e9 cb f3 ff ff       	jmp    80105a1a <alltraps>

8010664f <vector186>:
.globl vector186
vector186:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $186
80106651:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106656:	e9 bf f3 ff ff       	jmp    80105a1a <alltraps>

8010665b <vector187>:
.globl vector187
vector187:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $187
8010665d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106662:	e9 b3 f3 ff ff       	jmp    80105a1a <alltraps>

80106667 <vector188>:
.globl vector188
vector188:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $188
80106669:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010666e:	e9 a7 f3 ff ff       	jmp    80105a1a <alltraps>

80106673 <vector189>:
.globl vector189
vector189:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $189
80106675:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010667a:	e9 9b f3 ff ff       	jmp    80105a1a <alltraps>

8010667f <vector190>:
.globl vector190
vector190:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $190
80106681:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106686:	e9 8f f3 ff ff       	jmp    80105a1a <alltraps>

8010668b <vector191>:
.globl vector191
vector191:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $191
8010668d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106692:	e9 83 f3 ff ff       	jmp    80105a1a <alltraps>

80106697 <vector192>:
.globl vector192
vector192:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $192
80106699:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010669e:	e9 77 f3 ff ff       	jmp    80105a1a <alltraps>

801066a3 <vector193>:
.globl vector193
vector193:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $193
801066a5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801066aa:	e9 6b f3 ff ff       	jmp    80105a1a <alltraps>

801066af <vector194>:
.globl vector194
vector194:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $194
801066b1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801066b6:	e9 5f f3 ff ff       	jmp    80105a1a <alltraps>

801066bb <vector195>:
.globl vector195
vector195:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $195
801066bd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801066c2:	e9 53 f3 ff ff       	jmp    80105a1a <alltraps>

801066c7 <vector196>:
.globl vector196
vector196:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $196
801066c9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801066ce:	e9 47 f3 ff ff       	jmp    80105a1a <alltraps>

801066d3 <vector197>:
.globl vector197
vector197:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $197
801066d5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801066da:	e9 3b f3 ff ff       	jmp    80105a1a <alltraps>

801066df <vector198>:
.globl vector198
vector198:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $198
801066e1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801066e6:	e9 2f f3 ff ff       	jmp    80105a1a <alltraps>

801066eb <vector199>:
.globl vector199
vector199:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $199
801066ed:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801066f2:	e9 23 f3 ff ff       	jmp    80105a1a <alltraps>

801066f7 <vector200>:
.globl vector200
vector200:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $200
801066f9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801066fe:	e9 17 f3 ff ff       	jmp    80105a1a <alltraps>

80106703 <vector201>:
.globl vector201
vector201:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $201
80106705:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010670a:	e9 0b f3 ff ff       	jmp    80105a1a <alltraps>

8010670f <vector202>:
.globl vector202
vector202:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $202
80106711:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106716:	e9 ff f2 ff ff       	jmp    80105a1a <alltraps>

8010671b <vector203>:
.globl vector203
vector203:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $203
8010671d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106722:	e9 f3 f2 ff ff       	jmp    80105a1a <alltraps>

80106727 <vector204>:
.globl vector204
vector204:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $204
80106729:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010672e:	e9 e7 f2 ff ff       	jmp    80105a1a <alltraps>

80106733 <vector205>:
.globl vector205
vector205:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $205
80106735:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010673a:	e9 db f2 ff ff       	jmp    80105a1a <alltraps>

8010673f <vector206>:
.globl vector206
vector206:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $206
80106741:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106746:	e9 cf f2 ff ff       	jmp    80105a1a <alltraps>

8010674b <vector207>:
.globl vector207
vector207:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $207
8010674d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106752:	e9 c3 f2 ff ff       	jmp    80105a1a <alltraps>

80106757 <vector208>:
.globl vector208
vector208:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $208
80106759:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010675e:	e9 b7 f2 ff ff       	jmp    80105a1a <alltraps>

80106763 <vector209>:
.globl vector209
vector209:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $209
80106765:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010676a:	e9 ab f2 ff ff       	jmp    80105a1a <alltraps>

8010676f <vector210>:
.globl vector210
vector210:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $210
80106771:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106776:	e9 9f f2 ff ff       	jmp    80105a1a <alltraps>

8010677b <vector211>:
.globl vector211
vector211:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $211
8010677d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106782:	e9 93 f2 ff ff       	jmp    80105a1a <alltraps>

80106787 <vector212>:
.globl vector212
vector212:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $212
80106789:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010678e:	e9 87 f2 ff ff       	jmp    80105a1a <alltraps>

80106793 <vector213>:
.globl vector213
vector213:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $213
80106795:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010679a:	e9 7b f2 ff ff       	jmp    80105a1a <alltraps>

8010679f <vector214>:
.globl vector214
vector214:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $214
801067a1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801067a6:	e9 6f f2 ff ff       	jmp    80105a1a <alltraps>

801067ab <vector215>:
.globl vector215
vector215:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $215
801067ad:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801067b2:	e9 63 f2 ff ff       	jmp    80105a1a <alltraps>

801067b7 <vector216>:
.globl vector216
vector216:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $216
801067b9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801067be:	e9 57 f2 ff ff       	jmp    80105a1a <alltraps>

801067c3 <vector217>:
.globl vector217
vector217:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $217
801067c5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801067ca:	e9 4b f2 ff ff       	jmp    80105a1a <alltraps>

801067cf <vector218>:
.globl vector218
vector218:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $218
801067d1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801067d6:	e9 3f f2 ff ff       	jmp    80105a1a <alltraps>

801067db <vector219>:
.globl vector219
vector219:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $219
801067dd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801067e2:	e9 33 f2 ff ff       	jmp    80105a1a <alltraps>

801067e7 <vector220>:
.globl vector220
vector220:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $220
801067e9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801067ee:	e9 27 f2 ff ff       	jmp    80105a1a <alltraps>

801067f3 <vector221>:
.globl vector221
vector221:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $221
801067f5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801067fa:	e9 1b f2 ff ff       	jmp    80105a1a <alltraps>

801067ff <vector222>:
.globl vector222
vector222:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $222
80106801:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106806:	e9 0f f2 ff ff       	jmp    80105a1a <alltraps>

8010680b <vector223>:
.globl vector223
vector223:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $223
8010680d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106812:	e9 03 f2 ff ff       	jmp    80105a1a <alltraps>

80106817 <vector224>:
.globl vector224
vector224:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $224
80106819:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010681e:	e9 f7 f1 ff ff       	jmp    80105a1a <alltraps>

80106823 <vector225>:
.globl vector225
vector225:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $225
80106825:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010682a:	e9 eb f1 ff ff       	jmp    80105a1a <alltraps>

8010682f <vector226>:
.globl vector226
vector226:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $226
80106831:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106836:	e9 df f1 ff ff       	jmp    80105a1a <alltraps>

8010683b <vector227>:
.globl vector227
vector227:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $227
8010683d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106842:	e9 d3 f1 ff ff       	jmp    80105a1a <alltraps>

80106847 <vector228>:
.globl vector228
vector228:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $228
80106849:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010684e:	e9 c7 f1 ff ff       	jmp    80105a1a <alltraps>

80106853 <vector229>:
.globl vector229
vector229:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $229
80106855:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010685a:	e9 bb f1 ff ff       	jmp    80105a1a <alltraps>

8010685f <vector230>:
.globl vector230
vector230:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $230
80106861:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106866:	e9 af f1 ff ff       	jmp    80105a1a <alltraps>

8010686b <vector231>:
.globl vector231
vector231:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $231
8010686d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106872:	e9 a3 f1 ff ff       	jmp    80105a1a <alltraps>

80106877 <vector232>:
.globl vector232
vector232:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $232
80106879:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010687e:	e9 97 f1 ff ff       	jmp    80105a1a <alltraps>

80106883 <vector233>:
.globl vector233
vector233:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $233
80106885:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010688a:	e9 8b f1 ff ff       	jmp    80105a1a <alltraps>

8010688f <vector234>:
.globl vector234
vector234:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $234
80106891:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106896:	e9 7f f1 ff ff       	jmp    80105a1a <alltraps>

8010689b <vector235>:
.globl vector235
vector235:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $235
8010689d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801068a2:	e9 73 f1 ff ff       	jmp    80105a1a <alltraps>

801068a7 <vector236>:
.globl vector236
vector236:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $236
801068a9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801068ae:	e9 67 f1 ff ff       	jmp    80105a1a <alltraps>

801068b3 <vector237>:
.globl vector237
vector237:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $237
801068b5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801068ba:	e9 5b f1 ff ff       	jmp    80105a1a <alltraps>

801068bf <vector238>:
.globl vector238
vector238:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $238
801068c1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801068c6:	e9 4f f1 ff ff       	jmp    80105a1a <alltraps>

801068cb <vector239>:
.globl vector239
vector239:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $239
801068cd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801068d2:	e9 43 f1 ff ff       	jmp    80105a1a <alltraps>

801068d7 <vector240>:
.globl vector240
vector240:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $240
801068d9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801068de:	e9 37 f1 ff ff       	jmp    80105a1a <alltraps>

801068e3 <vector241>:
.globl vector241
vector241:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $241
801068e5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801068ea:	e9 2b f1 ff ff       	jmp    80105a1a <alltraps>

801068ef <vector242>:
.globl vector242
vector242:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $242
801068f1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801068f6:	e9 1f f1 ff ff       	jmp    80105a1a <alltraps>

801068fb <vector243>:
.globl vector243
vector243:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $243
801068fd:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106902:	e9 13 f1 ff ff       	jmp    80105a1a <alltraps>

80106907 <vector244>:
.globl vector244
vector244:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $244
80106909:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010690e:	e9 07 f1 ff ff       	jmp    80105a1a <alltraps>

80106913 <vector245>:
.globl vector245
vector245:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $245
80106915:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010691a:	e9 fb f0 ff ff       	jmp    80105a1a <alltraps>

8010691f <vector246>:
.globl vector246
vector246:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $246
80106921:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106926:	e9 ef f0 ff ff       	jmp    80105a1a <alltraps>

8010692b <vector247>:
.globl vector247
vector247:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $247
8010692d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106932:	e9 e3 f0 ff ff       	jmp    80105a1a <alltraps>

80106937 <vector248>:
.globl vector248
vector248:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $248
80106939:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010693e:	e9 d7 f0 ff ff       	jmp    80105a1a <alltraps>

80106943 <vector249>:
.globl vector249
vector249:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $249
80106945:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010694a:	e9 cb f0 ff ff       	jmp    80105a1a <alltraps>

8010694f <vector250>:
.globl vector250
vector250:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $250
80106951:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106956:	e9 bf f0 ff ff       	jmp    80105a1a <alltraps>

8010695b <vector251>:
.globl vector251
vector251:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $251
8010695d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106962:	e9 b3 f0 ff ff       	jmp    80105a1a <alltraps>

80106967 <vector252>:
.globl vector252
vector252:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $252
80106969:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010696e:	e9 a7 f0 ff ff       	jmp    80105a1a <alltraps>

80106973 <vector253>:
.globl vector253
vector253:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $253
80106975:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010697a:	e9 9b f0 ff ff       	jmp    80105a1a <alltraps>

8010697f <vector254>:
.globl vector254
vector254:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $254
80106981:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106986:	e9 8f f0 ff ff       	jmp    80105a1a <alltraps>

8010698b <vector255>:
.globl vector255
vector255:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $255
8010698d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106992:	e9 83 f0 ff ff       	jmp    80105a1a <alltraps>
80106997:	66 90                	xchg   %ax,%ax
80106999:	66 90                	xchg   %ax,%ax
8010699b:	66 90                	xchg   %ax,%ax
8010699d:	66 90                	xchg   %ax,%ax
8010699f:	90                   	nop

801069a0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801069a0:	55                   	push   %ebp
801069a1:	89 e5                	mov    %esp,%ebp
801069a3:	57                   	push   %edi
801069a4:	56                   	push   %esi
801069a5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801069a6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
801069ac:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801069b2:	83 ec 1c             	sub    $0x1c,%esp
  for(; a  < oldsz; a += PGSIZE){
801069b5:	39 d3                	cmp    %edx,%ebx
801069b7:	73 56                	jae    80106a0f <deallocuvm.part.0+0x6f>
801069b9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801069bc:	89 c6                	mov    %eax,%esi
801069be:	89 d7                	mov    %edx,%edi
801069c0:	eb 12                	jmp    801069d4 <deallocuvm.part.0+0x34>
801069c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801069c8:	83 c2 01             	add    $0x1,%edx
801069cb:	89 d3                	mov    %edx,%ebx
801069cd:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
801069d0:	39 fb                	cmp    %edi,%ebx
801069d2:	73 38                	jae    80106a0c <deallocuvm.part.0+0x6c>
  pde = &pgdir[PDX(va)];
801069d4:	89 da                	mov    %ebx,%edx
801069d6:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
801069d9:	8b 04 96             	mov    (%esi,%edx,4),%eax
801069dc:	a8 01                	test   $0x1,%al
801069de:	74 e8                	je     801069c8 <deallocuvm.part.0+0x28>
  return &pgtab[PTX(va)];
801069e0:	89 d9                	mov    %ebx,%ecx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801069e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801069e7:	c1 e9 0a             	shr    $0xa,%ecx
801069ea:	81 e1 fc 0f 00 00    	and    $0xffc,%ecx
801069f0:	8d 84 08 00 00 00 80 	lea    -0x80000000(%eax,%ecx,1),%eax
    if(!pte)
801069f7:	85 c0                	test   %eax,%eax
801069f9:	74 cd                	je     801069c8 <deallocuvm.part.0+0x28>
    else if((*pte & PTE_P) != 0){
801069fb:	8b 10                	mov    (%eax),%edx
801069fd:	f6 c2 01             	test   $0x1,%dl
80106a00:	75 1e                	jne    80106a20 <deallocuvm.part.0+0x80>
  for(; a  < oldsz; a += PGSIZE){
80106a02:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106a08:	39 fb                	cmp    %edi,%ebx
80106a0a:	72 c8                	jb     801069d4 <deallocuvm.part.0+0x34>
80106a0c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106a0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a12:	89 c8                	mov    %ecx,%eax
80106a14:	5b                   	pop    %ebx
80106a15:	5e                   	pop    %esi
80106a16:	5f                   	pop    %edi
80106a17:	5d                   	pop    %ebp
80106a18:	c3                   	ret
80106a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(pa == 0)
80106a20:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106a26:	74 26                	je     80106a4e <deallocuvm.part.0+0xae>
      kfree(v);
80106a28:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106a2b:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106a31:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106a34:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106a3a:	52                   	push   %edx
80106a3b:	e8 e0 ba ff ff       	call   80102520 <kfree>
      *pte = 0;
80106a40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  for(; a  < oldsz; a += PGSIZE){
80106a43:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80106a46:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80106a4c:	eb 82                	jmp    801069d0 <deallocuvm.part.0+0x30>
        panic("kfree");
80106a4e:	83 ec 0c             	sub    $0xc,%esp
80106a51:	68 27 7b 10 80       	push   $0x80107b27
80106a56:	e8 25 99 ff ff       	call   80100380 <panic>
80106a5b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106a60 <mappages>:
{
80106a60:	55                   	push   %ebp
80106a61:	89 e5                	mov    %esp,%ebp
80106a63:	57                   	push   %edi
80106a64:	56                   	push   %esi
80106a65:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106a66:	89 d3                	mov    %edx,%ebx
80106a68:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106a6e:	83 ec 1c             	sub    $0x1c,%esp
80106a71:	89 45 e0             	mov    %eax,-0x20(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106a74:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106a78:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106a7d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106a80:	8b 45 08             	mov    0x8(%ebp),%eax
80106a83:	29 d8                	sub    %ebx,%eax
80106a85:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106a88:	eb 3f                	jmp    80106ac9 <mappages+0x69>
80106a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106a90:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106a92:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106a97:	c1 ea 0a             	shr    $0xa,%edx
80106a9a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106aa0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106aa7:	85 c0                	test   %eax,%eax
80106aa9:	74 75                	je     80106b20 <mappages+0xc0>
    if(*pte & PTE_P)
80106aab:	f6 00 01             	testb  $0x1,(%eax)
80106aae:	0f 85 86 00 00 00    	jne    80106b3a <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106ab4:	0b 75 0c             	or     0xc(%ebp),%esi
80106ab7:	83 ce 01             	or     $0x1,%esi
80106aba:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106abc:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106abf:	39 c3                	cmp    %eax,%ebx
80106ac1:	74 6d                	je     80106b30 <mappages+0xd0>
    a += PGSIZE;
80106ac3:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106ac9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106acc:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80106acf:	8d 34 03             	lea    (%ebx,%eax,1),%esi
80106ad2:	89 d8                	mov    %ebx,%eax
80106ad4:	c1 e8 16             	shr    $0x16,%eax
80106ad7:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106ada:	8b 07                	mov    (%edi),%eax
80106adc:	a8 01                	test   $0x1,%al
80106ade:	75 b0                	jne    80106a90 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106ae0:	e8 fb bb ff ff       	call   801026e0 <kalloc>
80106ae5:	85 c0                	test   %eax,%eax
80106ae7:	74 37                	je     80106b20 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106ae9:	83 ec 04             	sub    $0x4,%esp
80106aec:	68 00 10 00 00       	push   $0x1000
80106af1:	6a 00                	push   $0x0
80106af3:	50                   	push   %eax
80106af4:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106af7:	e8 84 dd ff ff       	call   80104880 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106afc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106aff:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106b02:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106b08:	83 c8 07             	or     $0x7,%eax
80106b0b:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106b0d:	89 d8                	mov    %ebx,%eax
80106b0f:	c1 e8 0a             	shr    $0xa,%eax
80106b12:	25 fc 0f 00 00       	and    $0xffc,%eax
80106b17:	01 d0                	add    %edx,%eax
80106b19:	eb 90                	jmp    80106aab <mappages+0x4b>
80106b1b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
}
80106b20:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106b23:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106b28:	5b                   	pop    %ebx
80106b29:	5e                   	pop    %esi
80106b2a:	5f                   	pop    %edi
80106b2b:	5d                   	pop    %ebp
80106b2c:	c3                   	ret
80106b2d:	8d 76 00             	lea    0x0(%esi),%esi
80106b30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106b33:	31 c0                	xor    %eax,%eax
}
80106b35:	5b                   	pop    %ebx
80106b36:	5e                   	pop    %esi
80106b37:	5f                   	pop    %edi
80106b38:	5d                   	pop    %ebp
80106b39:	c3                   	ret
      panic("remap");
80106b3a:	83 ec 0c             	sub    $0xc,%esp
80106b3d:	68 71 7d 10 80       	push   $0x80107d71
80106b42:	e8 39 98 ff ff       	call   80100380 <panic>
80106b47:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106b4e:	00 
80106b4f:	90                   	nop

80106b50 <seginit>:
{
80106b50:	55                   	push   %ebp
80106b51:	89 e5                	mov    %esp,%ebp
80106b53:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106b56:	e8 35 cf ff ff       	call   80103a90 <cpuid>
  pd[0] = size-1;
80106b5b:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106b60:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106b66:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
80106b6a:	c7 80 78 28 11 80 ff 	movl   $0xffff,-0x7feed788(%eax)
80106b71:	ff 00 00 
80106b74:	c7 80 7c 28 11 80 00 	movl   $0xcf9a00,-0x7feed784(%eax)
80106b7b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106b7e:	c7 80 80 28 11 80 ff 	movl   $0xffff,-0x7feed780(%eax)
80106b85:	ff 00 00 
80106b88:	c7 80 84 28 11 80 00 	movl   $0xcf9200,-0x7feed77c(%eax)
80106b8f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106b92:	c7 80 88 28 11 80 ff 	movl   $0xffff,-0x7feed778(%eax)
80106b99:	ff 00 00 
80106b9c:	c7 80 8c 28 11 80 00 	movl   $0xcffa00,-0x7feed774(%eax)
80106ba3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106ba6:	c7 80 90 28 11 80 ff 	movl   $0xffff,-0x7feed770(%eax)
80106bad:	ff 00 00 
80106bb0:	c7 80 94 28 11 80 00 	movl   $0xcff200,-0x7feed76c(%eax)
80106bb7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106bba:	05 70 28 11 80       	add    $0x80112870,%eax
  pd[1] = (uint)p;
80106bbf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106bc3:	c1 e8 10             	shr    $0x10,%eax
80106bc6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106bca:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106bcd:	0f 01 10             	lgdtl  (%eax)
}
80106bd0:	c9                   	leave
80106bd1:	c3                   	ret
80106bd2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106bd9:	00 
80106bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106be0 <count_mem_pages>:
{
80106be0:	55                   	push   %ebp
80106be1:	89 e5                	mov    %esp,%ebp
80106be3:	57                   	push   %edi
80106be4:	8b 45 08             	mov    0x8(%ebp),%eax
80106be7:	56                   	push   %esi
80106be8:	53                   	push   %ebx
  for (uint va = 0; va < p->sz; va += PGSIZE) {
80106be9:	8b 18                	mov    (%eax),%ebx
  pde_t *pgdir = p->pgdir;
80106beb:	8b 70 04             	mov    0x4(%eax),%esi
  for (uint va = 0; va < p->sz; va += PGSIZE) {
80106bee:	85 db                	test   %ebx,%ebx
80106bf0:	74 56                	je     80106c48 <count_mem_pages+0x68>
80106bf2:	31 c0                	xor    %eax,%eax
  int count = 0;
80106bf4:	31 c9                	xor    %ecx,%ecx
80106bf6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106bfd:	00 
80106bfe:	66 90                	xchg   %ax,%ax
  pde = &pgdir[PDX(va)];
80106c00:	89 c2                	mov    %eax,%edx
80106c02:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80106c05:	8b 14 96             	mov    (%esi,%edx,4),%edx
80106c08:	f6 c2 01             	test   $0x1,%dl
80106c0b:	74 27                	je     80106c34 <count_mem_pages+0x54>
  return &pgtab[PTX(va)];
80106c0d:	89 c7                	mov    %eax,%edi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106c0f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80106c15:	c1 ef 0a             	shr    $0xa,%edi
80106c18:	81 e7 fc 0f 00 00    	and    $0xffc,%edi
80106c1e:	8d 94 3a 00 00 00 80 	lea    -0x80000000(%edx,%edi,1),%edx
    if (pte && (*pte & PTE_P))
80106c25:	85 d2                	test   %edx,%edx
80106c27:	74 0b                	je     80106c34 <count_mem_pages+0x54>
80106c29:	8b 12                	mov    (%edx),%edx
80106c2b:	83 e2 01             	and    $0x1,%edx
      count++;
80106c2e:	83 fa 01             	cmp    $0x1,%edx
80106c31:	83 d9 ff             	sbb    $0xffffffff,%ecx
  for (uint va = 0; va < p->sz; va += PGSIZE) {
80106c34:	05 00 10 00 00       	add    $0x1000,%eax
80106c39:	39 d8                	cmp    %ebx,%eax
80106c3b:	72 c3                	jb     80106c00 <count_mem_pages+0x20>
}
80106c3d:	5b                   	pop    %ebx
80106c3e:	89 c8                	mov    %ecx,%eax
80106c40:	5e                   	pop    %esi
80106c41:	5f                   	pop    %edi
80106c42:	5d                   	pop    %ebp
80106c43:	c3                   	ret
80106c44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int count = 0;
80106c48:	31 c9                	xor    %ecx,%ecx
}
80106c4a:	5b                   	pop    %ebx
80106c4b:	5e                   	pop    %esi
80106c4c:	89 c8                	mov    %ecx,%eax
80106c4e:	5f                   	pop    %edi
80106c4f:	5d                   	pop    %ebp
80106c50:	c3                   	ret
80106c51:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106c58:	00 
80106c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106c60 <proxytowalkpgdir>:
{
80106c60:	55                   	push   %ebp
80106c61:	89 e5                	mov    %esp,%ebp
80106c63:	57                   	push   %edi
80106c64:	56                   	push   %esi
80106c65:	53                   	push   %ebx
80106c66:	83 ec 0c             	sub    $0xc,%esp
80106c69:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pde = &pgdir[PDX(va)];
80106c6c:	8b 55 08             	mov    0x8(%ebp),%edx
80106c6f:	89 fe                	mov    %edi,%esi
80106c71:	c1 ee 16             	shr    $0x16,%esi
80106c74:	8d 34 b2             	lea    (%edx,%esi,4),%esi
  if(*pde & PTE_P){
80106c77:	8b 1e                	mov    (%esi),%ebx
80106c79:	f6 c3 01             	test   $0x1,%bl
80106c7c:	74 22                	je     80106ca0 <proxytowalkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106c7e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80106c84:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
  return &pgtab[PTX(va)];
80106c8a:	89 f8                	mov    %edi,%eax
}
80106c8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106c8f:	c1 e8 0a             	shr    $0xa,%eax
80106c92:	25 fc 0f 00 00       	and    $0xffc,%eax
80106c97:	01 d8                	add    %ebx,%eax
}
80106c99:	5b                   	pop    %ebx
80106c9a:	5e                   	pop    %esi
80106c9b:	5f                   	pop    %edi
80106c9c:	5d                   	pop    %ebp
80106c9d:	c3                   	ret
80106c9e:	66 90                	xchg   %ax,%ax
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106ca0:	8b 45 10             	mov    0x10(%ebp),%eax
80106ca3:	85 c0                	test   %eax,%eax
80106ca5:	74 31                	je     80106cd8 <proxytowalkpgdir+0x78>
80106ca7:	e8 34 ba ff ff       	call   801026e0 <kalloc>
80106cac:	89 c3                	mov    %eax,%ebx
80106cae:	85 c0                	test   %eax,%eax
80106cb0:	74 26                	je     80106cd8 <proxytowalkpgdir+0x78>
    memset(pgtab, 0, PGSIZE);
80106cb2:	83 ec 04             	sub    $0x4,%esp
80106cb5:	68 00 10 00 00       	push   $0x1000
80106cba:	6a 00                	push   $0x0
80106cbc:	50                   	push   %eax
80106cbd:	e8 be db ff ff       	call   80104880 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106cc2:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106cc8:	83 c4 10             	add    $0x10,%esp
80106ccb:	83 c8 07             	or     $0x7,%eax
80106cce:	89 06                	mov    %eax,(%esi)
80106cd0:	eb b8                	jmp    80106c8a <proxytowalkpgdir+0x2a>
80106cd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
80106cd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106cdb:	31 c0                	xor    %eax,%eax
}
80106cdd:	5b                   	pop    %ebx
80106cde:	5e                   	pop    %esi
80106cdf:	5f                   	pop    %edi
80106ce0:	5d                   	pop    %ebp
80106ce1:	c3                   	ret
80106ce2:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106ce9:	00 
80106cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106cf0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106cf0:	a1 24 56 11 80       	mov    0x80115624,%eax
80106cf5:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106cfa:	0f 22 d8             	mov    %eax,%cr3
}
80106cfd:	c3                   	ret
80106cfe:	66 90                	xchg   %ax,%ax

80106d00 <switchuvm>:
{
80106d00:	55                   	push   %ebp
80106d01:	89 e5                	mov    %esp,%ebp
80106d03:	57                   	push   %edi
80106d04:	56                   	push   %esi
80106d05:	53                   	push   %ebx
80106d06:	83 ec 1c             	sub    $0x1c,%esp
80106d09:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106d0c:	85 f6                	test   %esi,%esi
80106d0e:	0f 84 cb 00 00 00    	je     80106ddf <switchuvm+0xdf>
  if(p->kstack == 0)
80106d14:	8b 46 08             	mov    0x8(%esi),%eax
80106d17:	85 c0                	test   %eax,%eax
80106d19:	0f 84 da 00 00 00    	je     80106df9 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106d1f:	8b 46 04             	mov    0x4(%esi),%eax
80106d22:	85 c0                	test   %eax,%eax
80106d24:	0f 84 c2 00 00 00    	je     80106dec <switchuvm+0xec>
  pushcli();
80106d2a:	e8 01 d9 ff ff       	call   80104630 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106d2f:	e8 fc cc ff ff       	call   80103a30 <mycpu>
80106d34:	89 c3                	mov    %eax,%ebx
80106d36:	e8 f5 cc ff ff       	call   80103a30 <mycpu>
80106d3b:	89 c7                	mov    %eax,%edi
80106d3d:	e8 ee cc ff ff       	call   80103a30 <mycpu>
80106d42:	83 c7 08             	add    $0x8,%edi
80106d45:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106d48:	e8 e3 cc ff ff       	call   80103a30 <mycpu>
80106d4d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106d50:	ba 67 00 00 00       	mov    $0x67,%edx
80106d55:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106d5c:	83 c0 08             	add    $0x8,%eax
80106d5f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106d66:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106d6b:	83 c1 08             	add    $0x8,%ecx
80106d6e:	c1 e8 18             	shr    $0x18,%eax
80106d71:	c1 e9 10             	shr    $0x10,%ecx
80106d74:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106d7a:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106d80:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106d85:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106d8c:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106d91:	e8 9a cc ff ff       	call   80103a30 <mycpu>
80106d96:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106d9d:	e8 8e cc ff ff       	call   80103a30 <mycpu>
80106da2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106da6:	8b 5e 08             	mov    0x8(%esi),%ebx
80106da9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106daf:	e8 7c cc ff ff       	call   80103a30 <mycpu>
80106db4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106db7:	e8 74 cc ff ff       	call   80103a30 <mycpu>
80106dbc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106dc0:	b8 28 00 00 00       	mov    $0x28,%eax
80106dc5:	0f 00 d8             	ltr    %eax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106dc8:	8b 46 04             	mov    0x4(%esi),%eax
80106dcb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106dd0:	0f 22 d8             	mov    %eax,%cr3
}
80106dd3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106dd6:	5b                   	pop    %ebx
80106dd7:	5e                   	pop    %esi
80106dd8:	5f                   	pop    %edi
80106dd9:	5d                   	pop    %ebp
  popcli();
80106dda:	e9 a1 d8 ff ff       	jmp    80104680 <popcli>
    panic("switchuvm: no process");
80106ddf:	83 ec 0c             	sub    $0xc,%esp
80106de2:	68 77 7d 10 80       	push   $0x80107d77
80106de7:	e8 94 95 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
80106dec:	83 ec 0c             	sub    $0xc,%esp
80106def:	68 a2 7d 10 80       	push   $0x80107da2
80106df4:	e8 87 95 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80106df9:	83 ec 0c             	sub    $0xc,%esp
80106dfc:	68 8d 7d 10 80       	push   $0x80107d8d
80106e01:	e8 7a 95 ff ff       	call   80100380 <panic>
80106e06:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106e0d:	00 
80106e0e:	66 90                	xchg   %ax,%ax

80106e10 <inituvm>:
{
80106e10:	55                   	push   %ebp
80106e11:	89 e5                	mov    %esp,%ebp
80106e13:	57                   	push   %edi
80106e14:	56                   	push   %esi
80106e15:	53                   	push   %ebx
80106e16:	83 ec 1c             	sub    $0x1c,%esp
80106e19:	8b 45 08             	mov    0x8(%ebp),%eax
80106e1c:	8b 75 10             	mov    0x10(%ebp),%esi
80106e1f:	8b 7d 0c             	mov    0xc(%ebp),%edi
80106e22:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106e25:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106e2b:	77 49                	ja     80106e76 <inituvm+0x66>
  mem = kalloc();
80106e2d:	e8 ae b8 ff ff       	call   801026e0 <kalloc>
  memset(mem, 0, PGSIZE);
80106e32:	83 ec 04             	sub    $0x4,%esp
80106e35:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
80106e3a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106e3c:	6a 00                	push   $0x0
80106e3e:	50                   	push   %eax
80106e3f:	e8 3c da ff ff       	call   80104880 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106e44:	58                   	pop    %eax
80106e45:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106e4b:	5a                   	pop    %edx
80106e4c:	6a 06                	push   $0x6
80106e4e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106e53:	31 d2                	xor    %edx,%edx
80106e55:	50                   	push   %eax
80106e56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e59:	e8 02 fc ff ff       	call   80106a60 <mappages>
  memmove(mem, init, sz);
80106e5e:	83 c4 10             	add    $0x10,%esp
80106e61:	89 75 10             	mov    %esi,0x10(%ebp)
80106e64:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106e67:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106e6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e6d:	5b                   	pop    %ebx
80106e6e:	5e                   	pop    %esi
80106e6f:	5f                   	pop    %edi
80106e70:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106e71:	e9 9a da ff ff       	jmp    80104910 <memmove>
    panic("inituvm: more than a page");
80106e76:	83 ec 0c             	sub    $0xc,%esp
80106e79:	68 b6 7d 10 80       	push   $0x80107db6
80106e7e:	e8 fd 94 ff ff       	call   80100380 <panic>
80106e83:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106e8a:	00 
80106e8b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi

80106e90 <loaduvm>:
{
80106e90:	55                   	push   %ebp
80106e91:	89 e5                	mov    %esp,%ebp
80106e93:	57                   	push   %edi
80106e94:	56                   	push   %esi
80106e95:	53                   	push   %ebx
80106e96:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106e99:	8b 75 0c             	mov    0xc(%ebp),%esi
{
80106e9c:	8b 7d 18             	mov    0x18(%ebp),%edi
  if((uint) addr % PGSIZE != 0)
80106e9f:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80106ea5:	0f 85 a2 00 00 00    	jne    80106f4d <loaduvm+0xbd>
  for(i = 0; i < sz; i += PGSIZE){
80106eab:	85 ff                	test   %edi,%edi
80106ead:	74 7d                	je     80106f2c <loaduvm+0x9c>
80106eaf:	90                   	nop
  pde = &pgdir[PDX(va)];
80106eb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80106eb3:	8b 55 08             	mov    0x8(%ebp),%edx
80106eb6:	01 f0                	add    %esi,%eax
  pde = &pgdir[PDX(va)];
80106eb8:	89 c1                	mov    %eax,%ecx
80106eba:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80106ebd:	8b 0c 8a             	mov    (%edx,%ecx,4),%ecx
80106ec0:	f6 c1 01             	test   $0x1,%cl
80106ec3:	75 13                	jne    80106ed8 <loaduvm+0x48>
      panic("loaduvm: address should exist");
80106ec5:	83 ec 0c             	sub    $0xc,%esp
80106ec8:	68 d0 7d 10 80       	push   $0x80107dd0
80106ecd:	e8 ae 94 ff ff       	call   80100380 <panic>
80106ed2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106ed8:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106edb:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106ee1:	25 fc 0f 00 00       	and    $0xffc,%eax
80106ee6:	8d 8c 01 00 00 00 80 	lea    -0x80000000(%ecx,%eax,1),%ecx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106eed:	85 c9                	test   %ecx,%ecx
80106eef:	74 d4                	je     80106ec5 <loaduvm+0x35>
    if(sz - i < PGSIZE)
80106ef1:	89 fb                	mov    %edi,%ebx
80106ef3:	b8 00 10 00 00       	mov    $0x1000,%eax
80106ef8:	29 f3                	sub    %esi,%ebx
80106efa:	39 c3                	cmp    %eax,%ebx
80106efc:	0f 47 d8             	cmova  %eax,%ebx
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106eff:	53                   	push   %ebx
80106f00:	8b 45 14             	mov    0x14(%ebp),%eax
80106f03:	01 f0                	add    %esi,%eax
80106f05:	50                   	push   %eax
    pa = PTE_ADDR(*pte);
80106f06:	8b 01                	mov    (%ecx),%eax
80106f08:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106f0d:	05 00 00 00 80       	add    $0x80000000,%eax
80106f12:	50                   	push   %eax
80106f13:	ff 75 10             	push   0x10(%ebp)
80106f16:	e8 15 ac ff ff       	call   80101b30 <readi>
80106f1b:	83 c4 10             	add    $0x10,%esp
80106f1e:	39 d8                	cmp    %ebx,%eax
80106f20:	75 1e                	jne    80106f40 <loaduvm+0xb0>
  for(i = 0; i < sz; i += PGSIZE){
80106f22:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106f28:	39 fe                	cmp    %edi,%esi
80106f2a:	72 84                	jb     80106eb0 <loaduvm+0x20>
}
80106f2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106f2f:	31 c0                	xor    %eax,%eax
}
80106f31:	5b                   	pop    %ebx
80106f32:	5e                   	pop    %esi
80106f33:	5f                   	pop    %edi
80106f34:	5d                   	pop    %ebp
80106f35:	c3                   	ret
80106f36:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80106f3d:	00 
80106f3e:	66 90                	xchg   %ax,%ax
80106f40:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106f43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106f48:	5b                   	pop    %ebx
80106f49:	5e                   	pop    %esi
80106f4a:	5f                   	pop    %edi
80106f4b:	5d                   	pop    %ebp
80106f4c:	c3                   	ret
    panic("loaduvm: addr must be page aligned");
80106f4d:	83 ec 0c             	sub    $0xc,%esp
80106f50:	68 50 80 10 80       	push   $0x80108050
80106f55:	e8 26 94 ff ff       	call   80100380 <panic>
80106f5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106f60 <allocuvm>:
{
80106f60:	55                   	push   %ebp
80106f61:	89 e5                	mov    %esp,%ebp
80106f63:	57                   	push   %edi
80106f64:	56                   	push   %esi
80106f65:	53                   	push   %ebx
80106f66:	83 ec 1c             	sub    $0x1c,%esp
80106f69:	8b 75 10             	mov    0x10(%ebp),%esi
  if(newsz >= KERNBASE)
80106f6c:	85 f6                	test   %esi,%esi
80106f6e:	0f 88 ea 00 00 00    	js     8010705e <allocuvm+0xfe>
80106f74:	89 f1                	mov    %esi,%ecx
  if(newsz < oldsz)
80106f76:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106f79:	0f 82 a1 00 00 00    	jb     80107020 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80106f7f:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f82:	05 ff 0f 00 00       	add    $0xfff,%eax
80106f87:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106f8c:	89 c7                	mov    %eax,%edi
  for(; a < newsz; a += PGSIZE){
80106f8e:	39 f0                	cmp    %esi,%eax
80106f90:	0f 83 8d 00 00 00    	jae    80107023 <allocuvm+0xc3>
80106f96:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80106f99:	eb 4d                	jmp    80106fe8 <allocuvm+0x88>
80106f9b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80106fa0:	83 ec 04             	sub    $0x4,%esp
80106fa3:	68 00 10 00 00       	push   $0x1000
80106fa8:	6a 00                	push   $0x0
80106faa:	53                   	push   %ebx
80106fab:	e8 d0 d8 ff ff       	call   80104880 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106fb0:	58                   	pop    %eax
80106fb1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106fb7:	5a                   	pop    %edx
80106fb8:	6a 06                	push   $0x6
80106fba:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106fbf:	89 fa                	mov    %edi,%edx
80106fc1:	50                   	push   %eax
80106fc2:	8b 45 08             	mov    0x8(%ebp),%eax
80106fc5:	e8 96 fa ff ff       	call   80106a60 <mappages>
80106fca:	83 c4 10             	add    $0x10,%esp
80106fcd:	85 c0                	test   %eax,%eax
80106fcf:	78 5f                	js     80107030 <allocuvm+0xd0>
    myproc()->rss++;
80106fd1:	e8 da ca ff ff       	call   80103ab0 <myproc>
  for(; a < newsz; a += PGSIZE){
80106fd6:	81 c7 00 10 00 00    	add    $0x1000,%edi
    myproc()->rss++;
80106fdc:	83 40 7c 01          	addl   $0x1,0x7c(%eax)
  for(; a < newsz; a += PGSIZE){
80106fe0:	39 f7                	cmp    %esi,%edi
80106fe2:	0f 83 88 00 00 00    	jae    80107070 <allocuvm+0x110>
    mem = kalloc();
80106fe8:	e8 f3 b6 ff ff       	call   801026e0 <kalloc>
80106fed:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80106fef:	85 c0                	test   %eax,%eax
80106ff1:	75 ad                	jne    80106fa0 <allocuvm+0x40>
      cprintf("inside mem == 0\n");
80106ff3:	83 ec 0c             	sub    $0xc,%esp
80106ff6:	68 ee 7d 10 80       	push   $0x80107dee
80106ffb:	e8 b0 96 ff ff       	call   801006b0 <cprintf>
      handle_low_mem();
80107000:	e8 bb 06 00 00       	call   801076c0 <handle_low_mem>
80107005:	83 c4 10             	add    $0x10,%esp
80107008:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010700f:	00 
      while(mem==0) mem = kalloc();
80107010:	e8 cb b6 ff ff       	call   801026e0 <kalloc>
80107015:	85 c0                	test   %eax,%eax
80107017:	74 f7                	je     80107010 <allocuvm+0xb0>
80107019:	89 c3                	mov    %eax,%ebx
8010701b:	eb 83                	jmp    80106fa0 <allocuvm+0x40>
8010701d:	8d 76 00             	lea    0x0(%esi),%esi
    return oldsz;
80107020:	8b 4d 0c             	mov    0xc(%ebp),%ecx
}
80107023:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107026:	89 c8                	mov    %ecx,%eax
80107028:	5b                   	pop    %ebx
80107029:	5e                   	pop    %esi
8010702a:	5f                   	pop    %edi
8010702b:	5d                   	pop    %ebp
8010702c:	c3                   	ret
8010702d:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107030:	83 ec 0c             	sub    $0xc,%esp
80107033:	68 ff 7d 10 80       	push   $0x80107dff
80107038:	e8 73 96 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
8010703d:	83 c4 10             	add    $0x10,%esp
80107040:	3b 75 0c             	cmp    0xc(%ebp),%esi
80107043:	74 0d                	je     80107052 <allocuvm+0xf2>
80107045:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107048:	8b 45 08             	mov    0x8(%ebp),%eax
8010704b:	89 f2                	mov    %esi,%edx
8010704d:	e8 4e f9 ff ff       	call   801069a0 <deallocuvm.part.0>
      kfree(mem);
80107052:	83 ec 0c             	sub    $0xc,%esp
80107055:	53                   	push   %ebx
80107056:	e8 c5 b4 ff ff       	call   80102520 <kfree>
      return 0;
8010705b:	83 c4 10             	add    $0x10,%esp
}
8010705e:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80107061:	31 c9                	xor    %ecx,%ecx
}
80107063:	5b                   	pop    %ebx
80107064:	89 c8                	mov    %ecx,%eax
80107066:	5e                   	pop    %esi
80107067:	5f                   	pop    %edi
80107068:	5d                   	pop    %ebp
80107069:	c3                   	ret
8010706a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107070:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107073:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107076:	5b                   	pop    %ebx
80107077:	5e                   	pop    %esi
80107078:	89 c8                	mov    %ecx,%eax
8010707a:	5f                   	pop    %edi
8010707b:	5d                   	pop    %ebp
8010707c:	c3                   	ret
8010707d:	8d 76 00             	lea    0x0(%esi),%esi

80107080 <deallocuvm>:
{
80107080:	55                   	push   %ebp
80107081:	89 e5                	mov    %esp,%ebp
80107083:	8b 55 0c             	mov    0xc(%ebp),%edx
80107086:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107089:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010708c:	39 d1                	cmp    %edx,%ecx
8010708e:	73 10                	jae    801070a0 <deallocuvm+0x20>
}
80107090:	5d                   	pop    %ebp
80107091:	e9 0a f9 ff ff       	jmp    801069a0 <deallocuvm.part.0>
80107096:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010709d:	00 
8010709e:	66 90                	xchg   %ax,%ax
801070a0:	89 d0                	mov    %edx,%eax
801070a2:	5d                   	pop    %ebp
801070a3:	c3                   	ret
801070a4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801070ab:	00 
801070ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801070b0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801070b0:	55                   	push   %ebp
801070b1:	89 e5                	mov    %esp,%ebp
801070b3:	57                   	push   %edi
801070b4:	56                   	push   %esi
801070b5:	53                   	push   %ebx
801070b6:	83 ec 0c             	sub    $0xc,%esp
801070b9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801070bc:	85 f6                	test   %esi,%esi
801070be:	74 59                	je     80107119 <freevm+0x69>
  if(newsz >= oldsz)
801070c0:	31 c9                	xor    %ecx,%ecx
801070c2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801070c7:	89 f0                	mov    %esi,%eax
801070c9:	89 f3                	mov    %esi,%ebx
801070cb:	e8 d0 f8 ff ff       	call   801069a0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801070d0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801070d6:	eb 0f                	jmp    801070e7 <freevm+0x37>
801070d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801070df:	00 
801070e0:	83 c3 04             	add    $0x4,%ebx
801070e3:	39 fb                	cmp    %edi,%ebx
801070e5:	74 23                	je     8010710a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801070e7:	8b 03                	mov    (%ebx),%eax
801070e9:	a8 01                	test   $0x1,%al
801070eb:	74 f3                	je     801070e0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801070ed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801070f2:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
801070f5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801070f8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801070fd:	50                   	push   %eax
801070fe:	e8 1d b4 ff ff       	call   80102520 <kfree>
80107103:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107106:	39 fb                	cmp    %edi,%ebx
80107108:	75 dd                	jne    801070e7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010710a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010710d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107110:	5b                   	pop    %ebx
80107111:	5e                   	pop    %esi
80107112:	5f                   	pop    %edi
80107113:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107114:	e9 07 b4 ff ff       	jmp    80102520 <kfree>
    panic("freevm: no pgdir");
80107119:	83 ec 0c             	sub    $0xc,%esp
8010711c:	68 1b 7e 10 80       	push   $0x80107e1b
80107121:	e8 5a 92 ff ff       	call   80100380 <panic>
80107126:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010712d:	00 
8010712e:	66 90                	xchg   %ax,%ax

80107130 <setupkvm>:
{
80107130:	55                   	push   %ebp
80107131:	89 e5                	mov    %esp,%ebp
80107133:	56                   	push   %esi
80107134:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107135:	e8 a6 b5 ff ff       	call   801026e0 <kalloc>
8010713a:	85 c0                	test   %eax,%eax
8010713c:	74 5e                	je     8010719c <setupkvm+0x6c>
  memset(pgdir, 0, PGSIZE);
8010713e:	83 ec 04             	sub    $0x4,%esp
80107141:	89 c6                	mov    %eax,%esi
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107143:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107148:	68 00 10 00 00       	push   $0x1000
8010714d:	6a 00                	push   $0x0
8010714f:	50                   	push   %eax
80107150:	e8 2b d7 ff ff       	call   80104880 <memset>
80107155:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107158:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010715b:	83 ec 08             	sub    $0x8,%esp
8010715e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107161:	8b 13                	mov    (%ebx),%edx
80107163:	ff 73 0c             	push   0xc(%ebx)
80107166:	50                   	push   %eax
80107167:	29 c1                	sub    %eax,%ecx
80107169:	89 f0                	mov    %esi,%eax
8010716b:	e8 f0 f8 ff ff       	call   80106a60 <mappages>
80107170:	83 c4 10             	add    $0x10,%esp
80107173:	85 c0                	test   %eax,%eax
80107175:	78 19                	js     80107190 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107177:	83 c3 10             	add    $0x10,%ebx
8010717a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107180:	75 d6                	jne    80107158 <setupkvm+0x28>
}
80107182:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107185:	89 f0                	mov    %esi,%eax
80107187:	5b                   	pop    %ebx
80107188:	5e                   	pop    %esi
80107189:	5d                   	pop    %ebp
8010718a:	c3                   	ret
8010718b:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107190:	83 ec 0c             	sub    $0xc,%esp
80107193:	56                   	push   %esi
80107194:	e8 17 ff ff ff       	call   801070b0 <freevm>
      return 0;
80107199:	83 c4 10             	add    $0x10,%esp
}
8010719c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return 0;
8010719f:	31 f6                	xor    %esi,%esi
}
801071a1:	89 f0                	mov    %esi,%eax
801071a3:	5b                   	pop    %ebx
801071a4:	5e                   	pop    %esi
801071a5:	5d                   	pop    %ebp
801071a6:	c3                   	ret
801071a7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801071ae:	00 
801071af:	90                   	nop

801071b0 <kvmalloc>:
{
801071b0:	55                   	push   %ebp
801071b1:	89 e5                	mov    %esp,%ebp
801071b3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801071b6:	e8 75 ff ff ff       	call   80107130 <setupkvm>
801071bb:	a3 24 56 11 80       	mov    %eax,0x80115624
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801071c0:	05 00 00 00 80       	add    $0x80000000,%eax
801071c5:	0f 22 d8             	mov    %eax,%cr3
}
801071c8:	c9                   	leave
801071c9:	c3                   	ret
801071ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801071d0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801071d0:	55                   	push   %ebp
801071d1:	89 e5                	mov    %esp,%ebp
801071d3:	83 ec 08             	sub    $0x8,%esp
801071d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801071d9:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801071dc:	89 c1                	mov    %eax,%ecx
801071de:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801071e1:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801071e4:	f6 c2 01             	test   $0x1,%dl
801071e7:	75 17                	jne    80107200 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
801071e9:	83 ec 0c             	sub    $0xc,%esp
801071ec:	68 2c 7e 10 80       	push   $0x80107e2c
801071f1:	e8 8a 91 ff ff       	call   80100380 <panic>
801071f6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801071fd:	00 
801071fe:	66 90                	xchg   %ax,%ax
  return &pgtab[PTX(va)];
80107200:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107203:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107209:	25 fc 0f 00 00       	and    $0xffc,%eax
8010720e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107215:	85 c0                	test   %eax,%eax
80107217:	74 d0                	je     801071e9 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107219:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010721c:	c9                   	leave
8010721d:	c3                   	ret
8010721e:	66 90                	xchg   %ax,%ax

80107220 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107220:	55                   	push   %ebp
80107221:	89 e5                	mov    %esp,%ebp
80107223:	57                   	push   %edi
80107224:	56                   	push   %esi
80107225:	53                   	push   %ebx
80107226:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107229:	e8 02 ff ff ff       	call   80107130 <setupkvm>
8010722e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107231:	85 c0                	test   %eax,%eax
80107233:	0f 84 e9 00 00 00    	je     80107322 <copyuvm+0x102>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107239:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010723c:	85 c9                	test   %ecx,%ecx
8010723e:	0f 84 b2 00 00 00    	je     801072f6 <copyuvm+0xd6>
80107244:	31 f6                	xor    %esi,%esi
80107246:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010724d:	00 
8010724e:	66 90                	xchg   %ax,%ax
  if(*pde & PTE_P){
80107250:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
80107253:	89 f0                	mov    %esi,%eax
80107255:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80107258:	8b 04 81             	mov    (%ecx,%eax,4),%eax
8010725b:	a8 01                	test   $0x1,%al
8010725d:	75 11                	jne    80107270 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
8010725f:	83 ec 0c             	sub    $0xc,%esp
80107262:	68 36 7e 10 80       	push   $0x80107e36
80107267:	e8 14 91 ff ff       	call   80100380 <panic>
8010726c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107270:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107272:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107277:	c1 ea 0a             	shr    $0xa,%edx
8010727a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107280:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107287:	85 c0                	test   %eax,%eax
80107289:	74 d4                	je     8010725f <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010728b:	8b 00                	mov    (%eax),%eax
8010728d:	a8 01                	test   $0x1,%al
8010728f:	0f 84 9f 00 00 00    	je     80107334 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107295:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107297:	25 ff 0f 00 00       	and    $0xfff,%eax
8010729c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010729f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
801072a5:	e8 36 b4 ff ff       	call   801026e0 <kalloc>
801072aa:	89 c3                	mov    %eax,%ebx
801072ac:	85 c0                	test   %eax,%eax
801072ae:	74 64                	je     80107314 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801072b0:	83 ec 04             	sub    $0x4,%esp
801072b3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801072b9:	68 00 10 00 00       	push   $0x1000
801072be:	57                   	push   %edi
801072bf:	50                   	push   %eax
801072c0:	e8 4b d6 ff ff       	call   80104910 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801072c5:	58                   	pop    %eax
801072c6:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801072cc:	5a                   	pop    %edx
801072cd:	ff 75 e4             	push   -0x1c(%ebp)
801072d0:	b9 00 10 00 00       	mov    $0x1000,%ecx
801072d5:	89 f2                	mov    %esi,%edx
801072d7:	50                   	push   %eax
801072d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801072db:	e8 80 f7 ff ff       	call   80106a60 <mappages>
801072e0:	83 c4 10             	add    $0x10,%esp
801072e3:	85 c0                	test   %eax,%eax
801072e5:	78 21                	js     80107308 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
801072e7:	81 c6 00 10 00 00    	add    $0x1000,%esi
801072ed:	3b 75 0c             	cmp    0xc(%ebp),%esi
801072f0:	0f 82 5a ff ff ff    	jb     80107250 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
801072f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801072f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072fc:	5b                   	pop    %ebx
801072fd:	5e                   	pop    %esi
801072fe:	5f                   	pop    %edi
801072ff:	5d                   	pop    %ebp
80107300:	c3                   	ret
80107301:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107308:	83 ec 0c             	sub    $0xc,%esp
8010730b:	53                   	push   %ebx
8010730c:	e8 0f b2 ff ff       	call   80102520 <kfree>
      goto bad;
80107311:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107314:	83 ec 0c             	sub    $0xc,%esp
80107317:	ff 75 e0             	push   -0x20(%ebp)
8010731a:	e8 91 fd ff ff       	call   801070b0 <freevm>
  return 0;
8010731f:	83 c4 10             	add    $0x10,%esp
    return 0;
80107322:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107329:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010732c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010732f:	5b                   	pop    %ebx
80107330:	5e                   	pop    %esi
80107331:	5f                   	pop    %edi
80107332:	5d                   	pop    %ebp
80107333:	c3                   	ret
      panic("copyuvm: page not present");
80107334:	83 ec 0c             	sub    $0xc,%esp
80107337:	68 50 7e 10 80       	push   $0x80107e50
8010733c:	e8 3f 90 ff ff       	call   80100380 <panic>
80107341:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107348:	00 
80107349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107350 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107350:	55                   	push   %ebp
80107351:	89 e5                	mov    %esp,%ebp
80107353:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107356:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
80107359:	89 c1                	mov    %eax,%ecx
8010735b:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010735e:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107361:	f6 c2 01             	test   $0x1,%dl
80107364:	0f 84 f8 00 00 00    	je     80107462 <uva2ka.cold>
  return &pgtab[PTX(va)];
8010736a:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
8010736d:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107373:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107374:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107379:	8b 94 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107380:	89 d0                	mov    %edx,%eax
80107382:	f7 d2                	not    %edx
80107384:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107389:	05 00 00 00 80       	add    $0x80000000,%eax
8010738e:	83 e2 05             	and    $0x5,%edx
80107391:	ba 00 00 00 00       	mov    $0x0,%edx
80107396:	0f 45 c2             	cmovne %edx,%eax
}
80107399:	c3                   	ret
8010739a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801073a0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801073a0:	55                   	push   %ebp
801073a1:	89 e5                	mov    %esp,%ebp
801073a3:	57                   	push   %edi
801073a4:	56                   	push   %esi
801073a5:	53                   	push   %ebx
801073a6:	83 ec 0c             	sub    $0xc,%esp
801073a9:	8b 75 14             	mov    0x14(%ebp),%esi
801073ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801073af:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801073b2:	85 f6                	test   %esi,%esi
801073b4:	75 51                	jne    80107407 <copyout+0x67>
801073b6:	e9 9d 00 00 00       	jmp    80107458 <copyout+0xb8>
801073bb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  return (char*)P2V(PTE_ADDR(*pte));
801073c0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801073c6:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
801073cc:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
801073d2:	74 74                	je     80107448 <copyout+0xa8>
      return -1;
    n = PGSIZE - (va - va0);
801073d4:	89 fb                	mov    %edi,%ebx
801073d6:	29 c3                	sub    %eax,%ebx
801073d8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
801073de:	39 f3                	cmp    %esi,%ebx
801073e0:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801073e3:	29 f8                	sub    %edi,%eax
801073e5:	83 ec 04             	sub    $0x4,%esp
801073e8:	01 c1                	add    %eax,%ecx
801073ea:	53                   	push   %ebx
801073eb:	52                   	push   %edx
801073ec:	89 55 10             	mov    %edx,0x10(%ebp)
801073ef:	51                   	push   %ecx
801073f0:	e8 1b d5 ff ff       	call   80104910 <memmove>
    len -= n;
    buf += n;
801073f5:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
801073f8:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
801073fe:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107401:	01 da                	add    %ebx,%edx
  while(len > 0){
80107403:	29 de                	sub    %ebx,%esi
80107405:	74 51                	je     80107458 <copyout+0xb8>
  if(*pde & PTE_P){
80107407:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010740a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010740c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010740e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107411:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107417:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
8010741a:	f6 c1 01             	test   $0x1,%cl
8010741d:	0f 84 46 00 00 00    	je     80107469 <copyout.cold>
  return &pgtab[PTX(va)];
80107423:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107425:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
8010742b:	c1 eb 0c             	shr    $0xc,%ebx
8010742e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107434:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
8010743b:	89 d9                	mov    %ebx,%ecx
8010743d:	f7 d1                	not    %ecx
8010743f:	83 e1 05             	and    $0x5,%ecx
80107442:	0f 84 78 ff ff ff    	je     801073c0 <copyout+0x20>
  }
  return 0;
}
80107448:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010744b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107450:	5b                   	pop    %ebx
80107451:	5e                   	pop    %esi
80107452:	5f                   	pop    %edi
80107453:	5d                   	pop    %ebp
80107454:	c3                   	ret
80107455:	8d 76 00             	lea    0x0(%esi),%esi
80107458:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010745b:	31 c0                	xor    %eax,%eax
}
8010745d:	5b                   	pop    %ebx
8010745e:	5e                   	pop    %esi
8010745f:	5f                   	pop    %edi
80107460:	5d                   	pop    %ebp
80107461:	c3                   	ret

80107462 <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80107462:	a1 00 00 00 00       	mov    0x0,%eax
80107467:	0f 0b                	ud2

80107469 <copyout.cold>:
80107469:	a1 00 00 00 00       	mov    0x0,%eax
8010746e:	0f 0b                	ud2

80107470 <init_swap_table>:
struct swappage_t swap_table[NSWAP];
extern struct proc* choose_victim(void);

void init_swap_table()
{
    for(int i=0;i<NSWAP;i++)
80107470:	b8 40 56 11 80       	mov    $0x80115640,%eax
80107475:	8d 76 00             	lea    0x0(%esi),%esi
    {
        swap_table[i].is_free=1;
80107478:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
    for(int i=0;i<NSWAP;i++)
8010747f:	83 c0 0c             	add    $0xc,%eax
        swap_table[i].page_perm=0;
80107482:	c7 40 f4 00 00 00 00 	movl   $0x0,-0xc(%eax)
    for(int i=0;i<NSWAP;i++)
80107489:	3d c0 7b 11 80       	cmp    $0x80117bc0,%eax
8010748e:	75 e8                	jne    80107478 <init_swap_table+0x8>
    }
}
80107490:	c3                   	ret
80107491:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
80107498:	00 
80107499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801074a0 <alloc_swap_slot>:

int alloc_swap_slot(int pi)
{
    for(int i=0;i<NSWAP;i++)
801074a0:	ba 44 56 11 80       	mov    $0x80115644,%edx
801074a5:	31 c0                	xor    %eax,%eax
801074a7:	eb 14                	jmp    801074bd <alloc_swap_slot+0x1d>
801074a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074b0:	83 c0 01             	add    $0x1,%eax
801074b3:	83 c2 0c             	add    $0xc,%edx
801074b6:	3d 20 03 00 00       	cmp    $0x320,%eax
801074bb:	74 21                	je     801074de <alloc_swap_slot+0x3e>
    {
        if(swap_table[i].is_free==1)
801074bd:	83 3a 01             	cmpl   $0x1,(%edx)
801074c0:	75 ee                	jne    801074b0 <alloc_swap_slot+0x10>
{
801074c2:	55                   	push   %ebp
        {
            swap_table[i].is_free=0;
801074c3:	8d 14 40             	lea    (%eax,%eax,2),%edx
801074c6:	8d 14 95 40 56 11 80 	lea    -0x7feea9c0(,%edx,4),%edx
801074cd:	c7 42 04 00 00 00 00 	movl   $0x0,0x4(%edx)
{
801074d4:	89 e5                	mov    %esp,%ebp
            swap_table[i].pid=pi;
801074d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
801074d9:	89 4a 08             	mov    %ecx,0x8(%edx)
            return i;
        }
    }
    return -1;
}
801074dc:	5d                   	pop    %ebp
801074dd:	c3                   	ret
    return -1;
801074de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801074e3:	c3                   	ret
801074e4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801074eb:	00 
801074ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801074f0 <free_swap_slot>:
void free_swap_slot(int slot)
{
801074f0:	55                   	push   %ebp
801074f1:	89 e5                	mov    %esp,%ebp
801074f3:	8b 45 08             	mov    0x8(%ebp),%eax
    if(slot>-1 && slot<NSWAP)
801074f6:	3d 1f 03 00 00       	cmp    $0x31f,%eax
801074fb:	77 1a                	ja     80107517 <free_swap_slot+0x27>
    {
        swap_table[slot].is_free=1;
801074fd:	8d 04 40             	lea    (%eax,%eax,2),%eax
80107500:	c1 e0 02             	shl    $0x2,%eax
80107503:	c7 80 44 56 11 80 01 	movl   $0x1,-0x7feea9bc(%eax)
8010750a:	00 00 00 
        swap_table[slot].page_perm=0;
8010750d:	c7 80 40 56 11 80 00 	movl   $0x0,-0x7feea9c0(%eax)
80107514:	00 00 00 
    }
}
80107517:	5d                   	pop    %ebp
80107518:	c3                   	ret
80107519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107520 <handle_page_swap>:

extern int get_free_pages(void);

extern pte_t* proxytowalkpgdir(pde_t*, const void *, int);
int handle_page_swap(void)
{
80107520:	55                   	push   %ebp
80107521:	89 e5                	mov    %esp,%ebp
80107523:	57                   	push   %edi
80107524:	56                   	push   %esi
80107525:	53                   	push   %ebx
80107526:	83 ec 2c             	sub    $0x2c,%esp
    // cprintf("entered page swap\n");
    struct proc* p=choose_victim();
80107529:	e8 b2 ce ff ff       	call   801043e0 <choose_victim>
    if(!p || p->pid==1) return -1;
8010752e:	85 c0                	test   %eax,%eax
80107530:	74 56                	je     80107588 <handle_page_swap+0x68>
80107532:	83 78 10 01          	cmpl   $0x1,0x10(%eax)
80107536:	89 c6                	mov    %eax,%esi
80107538:	74 4e                	je     80107588 <handle_page_swap+0x68>
    // cprintf("found victim proc with pid %d\n",p->pid);
    pte_t *pte;
    uint va;
    int slot=-1;

    for(va=0;va<p->sz;va+=PGSIZE)
8010753a:	8b 10                	mov    (%eax),%edx
8010753c:	85 d2                	test   %edx,%edx
8010753e:	74 3d                	je     8010757d <handle_page_swap+0x5d>
80107540:	31 ff                	xor    %edi,%edi
80107542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    {
        pte=proxytowalkpgdir(p->pgdir,(void*)va,0);
80107548:	83 ec 04             	sub    $0x4,%esp
8010754b:	6a 00                	push   $0x0
8010754d:	57                   	push   %edi
8010754e:	ff 76 04             	push   0x4(%esi)
80107551:	e8 0a f7 ff ff       	call   80106c60 <proxytowalkpgdir>
        if(!pte) continue;
80107556:	83 c4 10             	add    $0x10,%esp
80107559:	85 c0                	test   %eax,%eax
8010755b:	74 16                	je     80107573 <handle_page_swap+0x53>
        if((*pte & PTE_P) && !(*pte & PTE_A))
8010755d:	8b 10                	mov    (%eax),%edx
8010755f:	89 d1                	mov    %edx,%ecx
80107561:	83 e1 21             	and    $0x21,%ecx
80107564:	83 f9 01             	cmp    $0x1,%ecx
80107567:	74 2f                	je     80107598 <handle_page_swap+0x78>
            lcr3(V2P(p->pgdir));
            kfree(pa);
            // cprintf("successfully moved to disk\n");
            return 0;
        }
        if((*pte & PTE_P) && (*pte & PTE_A) && ((va/PGSIZE) % 1)==0) *pte &= ~PTE_A;
80107569:	83 f9 21             	cmp    $0x21,%ecx
8010756c:	75 05                	jne    80107573 <handle_page_swap+0x53>
8010756e:	83 e2 df             	and    $0xffffffdf,%edx
80107571:	89 10                	mov    %edx,(%eax)
    for(va=0;va<p->sz;va+=PGSIZE)
80107573:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107579:	3b 3e                	cmp    (%esi),%edi
8010757b:	72 cb                	jb     80107548 <handle_page_swap+0x28>
    //     pte=proxytowalkpgdir(p->pgdir,(void*)va,0);
    //     if(!pte) continue;
    //     
    // }

}
8010757d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107580:	5b                   	pop    %ebx
80107581:	5e                   	pop    %esi
80107582:	5f                   	pop    %edi
80107583:	5d                   	pop    %ebp
80107584:	c3                   	ret
80107585:	8d 76 00             	lea    0x0(%esi),%esi
80107588:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(!p || p->pid==1) return -1;
8010758b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107590:	5b                   	pop    %ebx
80107591:	5e                   	pop    %esi
80107592:	5f                   	pop    %edi
80107593:	5d                   	pop    %ebp
80107594:	c3                   	ret
80107595:	8d 76 00             	lea    0x0(%esi),%esi
            slot=alloc_swap_slot(p->pid);
80107598:	89 c3                	mov    %eax,%ebx
8010759a:	8b 56 10             	mov    0x10(%esi),%edx
    for(int i=0;i<NSWAP;i++)
8010759d:	b8 44 56 11 80       	mov    $0x80115644,%eax
801075a2:	31 ff                	xor    %edi,%edi
801075a4:	eb 1c                	jmp    801075c2 <handle_page_swap+0xa2>
801075a6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801075ad:	00 
801075ae:	66 90                	xchg   %ax,%ax
801075b0:	83 c7 01             	add    $0x1,%edi
801075b3:	83 c0 0c             	add    $0xc,%eax
801075b6:	81 ff 20 03 00 00    	cmp    $0x320,%edi
801075bc:	0f 84 e5 00 00 00    	je     801076a7 <handle_page_swap+0x187>
        if(swap_table[i].is_free==1)
801075c2:	83 38 01             	cmpl   $0x1,(%eax)
801075c5:	75 e9                	jne    801075b0 <handle_page_swap+0x90>
            swap_table[i].is_free=0;
801075c7:	8d 04 3f             	lea    (%edi,%edi,1),%eax
801075ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
801075cd:	01 f8                	add    %edi,%eax
801075cf:	8d 04 85 40 56 11 80 	lea    -0x7feea9c0(,%eax,4),%eax
            swap_table[i].pid=pi;
801075d6:	89 50 08             	mov    %edx,0x8(%eax)
            swap_table[i].is_free=0;
801075d9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
            char* pa=P2V(PTE_ADDR(*pte)); //pa now points to 4KB page in kernel memory
801075e0:	8b 03                	mov    (%ebx),%eax
801075e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801075e7:	05 00 00 00 80       	add    $0x80000000,%eax
801075ec:	89 45 dc             	mov    %eax,-0x24(%ebp)
801075ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
            begin_op();
801075f2:	e8 09 b8 ff ff       	call   80102e00 <begin_op>
            int b0=get_block_for_slot(slot);
801075f7:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
801075fe:	89 75 d4             	mov    %esi,-0x2c(%ebp)
80107601:	8d 48 0a             	lea    0xa(%eax),%ecx
80107604:	89 5d d0             	mov    %ebx,-0x30(%ebp)
80107607:	8d 50 02             	lea    0x2(%eax),%edx
8010760a:	8b 5d dc             	mov    -0x24(%ebp),%ebx
8010760d:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80107610:	89 7d cc             	mov    %edi,-0x34(%ebp)
80107613:	89 d7                	mov    %edx,%edi
80107615:	8d 76 00             	lea    0x0(%esi),%esi
                struct buf* b=bread(ROOTDEV,b0+i);
80107618:	83 ec 08             	sub    $0x8,%esp
8010761b:	57                   	push   %edi
            for(int i=0;i<BLOCKSPERSLOT;i++)
8010761c:	83 c7 01             	add    $0x1,%edi
                struct buf* b=bread(ROOTDEV,b0+i);
8010761f:	6a 01                	push   $0x1
80107621:	e8 aa 8a ff ff       	call   801000d0 <bread>
                memmove(b->data,pa+i*512,512); //you move 512 bytes starting from pa_i*512
80107626:	83 c4 0c             	add    $0xc,%esp
                struct buf* b=bread(ROOTDEV,b0+i);
80107629:	89 c6                	mov    %eax,%esi
                memmove(b->data,pa+i*512,512); //you move 512 bytes starting from pa_i*512
8010762b:	8d 40 5c             	lea    0x5c(%eax),%eax
8010762e:	68 00 02 00 00       	push   $0x200
80107633:	53                   	push   %ebx
            for(int i=0;i<BLOCKSPERSLOT;i++)
80107634:	81 c3 00 02 00 00    	add    $0x200,%ebx
                memmove(b->data,pa+i*512,512); //you move 512 bytes starting from pa_i*512
8010763a:	50                   	push   %eax
8010763b:	e8 d0 d2 ff ff       	call   80104910 <memmove>
                log_write(b);
80107640:	89 34 24             	mov    %esi,(%esp)
80107643:	e8 98 b9 ff ff       	call   80102fe0 <log_write>
                brelse(b);
80107648:	89 34 24             	mov    %esi,(%esp)
8010764b:	e8 a0 8b ff ff       	call   801001f0 <brelse>
            for(int i=0;i<BLOCKSPERSLOT;i++)
80107650:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107653:	83 c4 10             	add    $0x10,%esp
80107656:	39 c7                	cmp    %eax,%edi
80107658:	75 be                	jne    80107618 <handle_page_swap+0xf8>
            end_op();
8010765a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
8010765d:	8b 75 d4             	mov    -0x2c(%ebp),%esi
80107660:	8b 7d cc             	mov    -0x34(%ebp),%edi
80107663:	e8 08 b8 ff ff       	call   80102e70 <end_op>
            swap_table[slot].page_perm=(*pte) & (PTE_U|PTE_W);
80107668:	8b 03                	mov    (%ebx),%eax
8010766a:	8b 55 d8             	mov    -0x28(%ebp),%edx
8010766d:	83 e0 06             	and    $0x6,%eax
80107670:	01 fa                	add    %edi,%edx
            *pte = (slot << 12) | swap_table[slot].page_perm; 
80107672:	c1 e7 0c             	shl    $0xc,%edi
80107675:	09 c7                	or     %eax,%edi
            swap_table[slot].page_perm=(*pte) & (PTE_U|PTE_W);
80107677:	89 04 95 40 56 11 80 	mov    %eax,-0x7feea9c0(,%edx,4)
            *pte = (slot << 12) | swap_table[slot].page_perm; 
8010767e:	89 3b                	mov    %edi,(%ebx)
            lcr3(V2P(p->pgdir));
80107680:	8b 46 04             	mov    0x4(%esi),%eax
            p->rss--;
80107683:	83 6e 7c 01          	subl   $0x1,0x7c(%esi)
            lcr3(V2P(p->pgdir));
80107687:	05 00 00 00 80       	add    $0x80000000,%eax
8010768c:	0f 22 d8             	mov    %eax,%cr3
            kfree(pa);
8010768f:	83 ec 0c             	sub    $0xc,%esp
80107692:	ff 75 e0             	push   -0x20(%ebp)
80107695:	e8 86 ae ff ff       	call   80102520 <kfree>
            return 0;
8010769a:	83 c4 10             	add    $0x10,%esp
}
8010769d:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return 0;
801076a0:	31 c0                	xor    %eax,%eax
}
801076a2:	5b                   	pop    %ebx
801076a3:	5e                   	pop    %esi
801076a4:	5f                   	pop    %edi
801076a5:	5d                   	pop    %ebp
801076a6:	c3                   	ret
            if(slot==-1) panic("no free swap slot");
801076a7:	83 ec 0c             	sub    $0xc,%esp
801076aa:	68 6a 7e 10 80       	push   $0x80107e6a
801076af:	e8 cc 8c ff ff       	call   80100380 <panic>
801076b4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801076bb:	00 
801076bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801076c0 <handle_low_mem>:

void handle_low_mem(void)
{
801076c0:	55                   	push   %ebp
801076c1:	89 e5                	mov    %esp,%ebp
801076c3:	57                   	push   %edi
801076c4:	56                   	push   %esi
801076c5:	53                   	push   %ebx
801076c6:	83 ec 0c             	sub    $0xc,%esp
    int freepg=get_free_pages();
801076c9:	e8 92 b0 ff ff       	call   80102760 <get_free_pages>
801076ce:	89 c2                	mov    %eax,%edx
    if(freepg<=th)
801076d0:	a1 64 b4 10 80       	mov    0x8010b464,%eax
801076d5:	39 d0                	cmp    %edx,%eax
801076d7:	7d 27                	jge    80107700 <handle_low_mem+0x40>
        // cprintf("num free pages is\n");
        th-=(th*beta)/100;
        npg+=(npg*alpha)/100;
        if(npg>=SWAP_LIMIT) npg=SWAP_LIMIT;
    }
    cprintf("free pages after is %d\n",get_free_pages());
801076d9:	e8 82 b0 ff ff       	call   80102760 <get_free_pages>
801076de:	83 ec 08             	sub    $0x8,%esp
801076e1:	50                   	push   %eax
801076e2:	68 86 7e 10 80       	push   $0x80107e86
801076e7:	e8 c4 8f ff ff       	call   801006b0 <cprintf>
}
801076ec:	83 c4 10             	add    $0x10,%esp
801076ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076f2:	5b                   	pop    %ebx
801076f3:	5e                   	pop    %esi
801076f4:	5f                   	pop    %edi
801076f5:	5d                   	pop    %ebp
801076f6:	c3                   	ret
801076f7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
801076fe:	00 
801076ff:	90                   	nop
        cprintf("Current Threshold = %d, Swapping %d pages\n",th,npg);
80107700:	83 ec 04             	sub    $0x4,%esp
80107703:	ff 35 60 b4 10 80    	push   0x8010b460
80107709:	50                   	push   %eax
8010770a:	68 74 80 10 80       	push   $0x80108074
8010770f:	e8 9c 8f ff ff       	call   801006b0 <cprintf>
        for(int i=0;i<npg;i++)
80107714:	8b 0d 60 b4 10 80    	mov    0x8010b460,%ecx
8010771a:	83 c4 10             	add    $0x10,%esp
8010771d:	85 c9                	test   %ecx,%ecx
8010771f:	7e 34                	jle    80107755 <handle_low_mem+0x95>
80107721:	31 db                	xor    %ebx,%ebx
80107723:	eb 10                	jmp    80107735 <handle_low_mem+0x75>
80107725:	8d 76 00             	lea    0x0(%esi),%esi
80107728:	8b 0d 60 b4 10 80    	mov    0x8010b460,%ecx
8010772e:	83 c3 01             	add    $0x1,%ebx
80107731:	39 d9                	cmp    %ebx,%ecx
80107733:	7e 20                	jle    80107755 <handle_low_mem+0x95>
            int x=handle_page_swap();
80107735:	e8 e6 fd ff ff       	call   80107520 <handle_page_swap>
            if(x==-1)
8010773a:	83 f8 ff             	cmp    $0xffffffff,%eax
8010773d:	75 e9                	jne    80107728 <handle_low_mem+0x68>
                cprintf("breaking ");
8010773f:	83 ec 0c             	sub    $0xc,%esp
80107742:	68 7c 7e 10 80       	push   $0x80107e7c
80107747:	e8 64 8f ff ff       	call   801006b0 <cprintf>
        npg+=(npg*alpha)/100;
8010774c:	8b 0d 60 b4 10 80    	mov    0x8010b460,%ecx
                break;
80107752:	83 c4 10             	add    $0x10,%esp
        th-=(th*beta)/100;
80107755:	8b 3d 64 b4 10 80    	mov    0x8010b464,%edi
8010775b:	8b 35 68 b4 10 80    	mov    0x8010b468,%esi
80107761:	bb 1f 85 eb 51       	mov    $0x51eb851f,%ebx
80107766:	0f af f7             	imul   %edi,%esi
80107769:	89 f0                	mov    %esi,%eax
8010776b:	c1 fe 1f             	sar    $0x1f,%esi
8010776e:	f7 eb                	imul   %ebx
80107770:	c1 fa 05             	sar    $0x5,%edx
80107773:	29 d6                	sub    %edx,%esi
80107775:	01 fe                	add    %edi,%esi
80107777:	89 35 64 b4 10 80    	mov    %esi,0x8010b464
        npg+=(npg*alpha)/100;
8010777d:	8b 35 6c b4 10 80    	mov    0x8010b46c,%esi
80107783:	0f af f1             	imul   %ecx,%esi
80107786:	89 f0                	mov    %esi,%eax
80107788:	c1 fe 1f             	sar    $0x1f,%esi
8010778b:	f7 eb                	imul   %ebx
8010778d:	c1 fa 05             	sar    $0x5,%edx
80107790:	29 f2                	sub    %esi,%edx
80107792:	8d 04 0a             	lea    (%edx,%ecx,1),%eax
80107795:	ba 64 00 00 00       	mov    $0x64,%edx
8010779a:	83 f8 63             	cmp    $0x63,%eax
8010779d:	0f 4f c2             	cmovg  %edx,%eax
801077a0:	a3 60 b4 10 80       	mov    %eax,0x8010b460
801077a5:	e9 2f ff ff ff       	jmp    801076d9 <handle_low_mem+0x19>
801077aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801077b0 <handle_page_fault>:

void handle_page_fault(struct trapframe* tf)
{
801077b0:	55                   	push   %ebp
801077b1:	89 e5                	mov    %esp,%ebp
801077b3:	57                   	push   %edi
801077b4:	56                   	push   %esi
801077b5:	53                   	push   %ebx
801077b6:	83 ec 1c             	sub    $0x1c,%esp
  asm volatile("movl %%cr2,%0" : "=r" (val));
801077b9:	0f 20 d3             	mov    %cr2,%ebx
    // cprintf("handling page fault\n");
    uint va=rcr2();
    pde_t* pgdir=myproc()->pgdir;
801077bc:	e8 ef c2 ff ff       	call   80103ab0 <myproc>
    pde_t* pte=proxytowalkpgdir(pgdir,(void*)va,0);
801077c1:	83 ec 04             	sub    $0x4,%esp
801077c4:	6a 00                	push   $0x0
801077c6:	53                   	push   %ebx
801077c7:	ff 70 04             	push   0x4(%eax)
801077ca:	e8 91 f4 ff ff       	call   80106c60 <proxytowalkpgdir>
    if(!pte || (*pte & PTE_P)) panic("page fault on non swapped page");
801077cf:	83 c4 10             	add    $0x10,%esp
    pde_t* pte=proxytowalkpgdir(pgdir,(void*)va,0);
801077d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if(!pte || (*pte & PTE_P)) panic("page fault on non swapped page");
801077d5:	85 c0                	test   %eax,%eax
801077d7:	0f 84 04 01 00 00    	je     801078e1 <handle_page_fault+0x131>
801077dd:	8b 38                	mov    (%eax),%edi
801077df:	f7 c7 01 00 00 00    	test   $0x1,%edi
801077e5:	0f 85 f6 00 00 00    	jne    801078e1 <handle_page_fault+0x131>

    int slot=PTE_SLOT(*pte);
    // handle_low_mem();
    char* mem=kalloc();
801077eb:	e8 f0 ae ff ff       	call   801026e0 <kalloc>
    int slot=PTE_SLOT(*pte);
801077f0:	c1 ef 0c             	shr    $0xc,%edi
    char* mem=kalloc();
801077f3:	89 c1                	mov    %eax,%ecx
    if(mem == 0)
801077f5:	85 c0                	test   %eax,%eax
801077f7:	0f 84 b3 00 00 00    	je     801078b0 <handle_page_fault+0x100>
801077fd:	89 4d dc             	mov    %ecx,-0x24(%ebp)
        handle_low_mem();
        mem=kalloc();
        if(mem==0) panic("kalloc failed in swap-in");
    }

    myproc()->rss++;
80107800:	e8 ab c2 ff ff       	call   80103ab0 <myproc>
    int b0=get_block_for_slot(slot);
80107805:	8b 4d dc             	mov    -0x24(%ebp),%ecx
80107808:	89 7d dc             	mov    %edi,-0x24(%ebp)
    myproc()->rss++;
8010780b:	83 40 7c 01          	addl   $0x1,0x7c(%eax)
    int b0=get_block_for_slot(slot);
8010780f:	8d 04 fd 00 00 00 00 	lea    0x0(,%edi,8),%eax
80107816:	8d 70 02             	lea    0x2(%eax),%esi
80107819:	83 c0 0a             	add    $0xa,%eax
8010781c:	89 4d d8             	mov    %ecx,-0x28(%ebp)
8010781f:	89 cb                	mov    %ecx,%ebx
80107821:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107824:	89 f7                	mov    %esi,%edi
80107826:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
8010782d:	00 
8010782e:	66 90                	xchg   %ax,%ax
    for(int i=0;i<BLOCKSPERSLOT;i++)
    {
        struct buf* b=bread(ROOTDEV,b0+i);
80107830:	83 ec 08             	sub    $0x8,%esp
80107833:	57                   	push   %edi
    for(int i=0;i<BLOCKSPERSLOT;i++)
80107834:	83 c7 01             	add    $0x1,%edi
        struct buf* b=bread(ROOTDEV,b0+i);
80107837:	6a 01                	push   $0x1
80107839:	e8 92 88 ff ff       	call   801000d0 <bread>
        memmove(mem+i*512,b->data,512);
8010783e:	83 c4 0c             	add    $0xc,%esp
        struct buf* b=bread(ROOTDEV,b0+i);
80107841:	89 c6                	mov    %eax,%esi
        memmove(mem+i*512,b->data,512);
80107843:	8d 40 5c             	lea    0x5c(%eax),%eax
80107846:	68 00 02 00 00       	push   $0x200
8010784b:	50                   	push   %eax
8010784c:	53                   	push   %ebx
    for(int i=0;i<BLOCKSPERSLOT;i++)
8010784d:	81 c3 00 02 00 00    	add    $0x200,%ebx
        memmove(mem+i*512,b->data,512);
80107853:	e8 b8 d0 ff ff       	call   80104910 <memmove>
        brelse(b);
80107858:	89 34 24             	mov    %esi,(%esp)
8010785b:	e8 90 89 ff ff       	call   801001f0 <brelse>
    for(int i=0;i<BLOCKSPERSLOT;i++)
80107860:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107863:	83 c4 10             	add    $0x10,%esp
80107866:	39 c7                	cmp    %eax,%edi
80107868:	75 c6                	jne    80107830 <handle_page_fault+0x80>
    }
    *pte=V2P(mem)|swap_table[slot].page_perm|PTE_P;
8010786a:	8b 7d dc             	mov    -0x24(%ebp),%edi
8010786d:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80107870:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80107873:	8d 04 7f             	lea    (%edi,%edi,2),%eax
80107876:	81 c1 00 00 00 80    	add    $0x80000000,%ecx
8010787c:	c1 e0 02             	shl    $0x2,%eax
8010787f:	0b 88 40 56 11 80    	or     -0x7feea9c0(%eax),%ecx
80107885:	83 c9 01             	or     $0x1,%ecx
80107888:	89 0b                	mov    %ecx,(%ebx)
    if(slot>-1 && slot<NSWAP)
8010788a:	81 ff 1f 03 00 00    	cmp    $0x31f,%edi
80107890:	77 14                	ja     801078a6 <handle_page_fault+0xf6>
        swap_table[slot].is_free=1;
80107892:	c7 80 44 56 11 80 01 	movl   $0x1,-0x7feea9bc(%eax)
80107899:	00 00 00 
        swap_table[slot].page_perm=0;
8010789c:	c7 80 40 56 11 80 00 	movl   $0x0,-0x7feea9c0(%eax)
801078a3:	00 00 00 
    free_swap_slot(slot);
}
801078a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078a9:	5b                   	pop    %ebx
801078aa:	5e                   	pop    %esi
801078ab:	5f                   	pop    %edi
801078ac:	5d                   	pop    %ebp
801078ad:	c3                   	ret
801078ae:	66 90                	xchg   %ax,%ax
        cprintf("inside mem == 0 in swap\n");
801078b0:	83 ec 0c             	sub    $0xc,%esp
801078b3:	68 9e 7e 10 80       	push   $0x80107e9e
801078b8:	e8 f3 8d ff ff       	call   801006b0 <cprintf>
        handle_low_mem();
801078bd:	e8 fe fd ff ff       	call   801076c0 <handle_low_mem>
        mem=kalloc();
801078c2:	e8 19 ae ff ff       	call   801026e0 <kalloc>
        if(mem==0) panic("kalloc failed in swap-in");
801078c7:	83 c4 10             	add    $0x10,%esp
        mem=kalloc();
801078ca:	89 c1                	mov    %eax,%ecx
        if(mem==0) panic("kalloc failed in swap-in");
801078cc:	85 c0                	test   %eax,%eax
801078ce:	0f 85 29 ff ff ff    	jne    801077fd <handle_page_fault+0x4d>
801078d4:	83 ec 0c             	sub    $0xc,%esp
801078d7:	68 b7 7e 10 80       	push   $0x80107eb7
801078dc:	e8 9f 8a ff ff       	call   80100380 <panic>
    if(!pte || (*pte & PTE_P)) panic("page fault on non swapped page");
801078e1:	83 ec 0c             	sub    $0xc,%esp
801078e4:	68 a0 80 10 80       	push   $0x801080a0
801078e9:	e8 92 8a ff ff       	call   80100380 <panic>
801078ee:	66 90                	xchg   %ax,%ax

801078f0 <clear_disk_of_proc>:

int clear_disk_of_proc(int pi)
{
801078f0:	55                   	push   %ebp
801078f1:	b8 40 56 11 80       	mov    $0x80115640,%eax
801078f6:	89 e5                	mov    %esp,%ebp
801078f8:	8b 55 08             	mov    0x8(%ebp),%edx
801078fb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
    for(int i=0;i<NSWAP;i++)
    {
        if(swap_table[i].pid==pi)
80107900:	39 50 08             	cmp    %edx,0x8(%eax)
80107903:	75 14                	jne    80107919 <clear_disk_of_proc+0x29>
        {
            swap_table[i].is_free=1;
80107905:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
            swap_table[i].page_perm=0;
8010790c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            swap_table[i].pid=0;
80107912:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    for(int i=0;i<NSWAP;i++)
80107919:	83 c0 0c             	add    $0xc,%eax
8010791c:	3d c0 7b 11 80       	cmp    $0x80117bc0,%eax
80107921:	75 dd                	jne    80107900 <clear_disk_of_proc+0x10>
        }
    }
    return 0;
80107923:	31 c0                	xor    %eax,%eax
80107925:	5d                   	pop    %ebp
80107926:	c3                   	ret
