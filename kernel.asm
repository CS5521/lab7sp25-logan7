
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
80100028:	bc 70 c6 10 80       	mov    $0x8010c670,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 74 37 10 80       	mov    $0x80103774,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	c7 44 24 04 08 85 10 	movl   $0x80108508,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 80 c6 10 80 	movl   $0x8010c680,(%esp)
80100049:	e8 de 4f 00 00       	call   8010502c <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004e:	c7 05 cc 0d 11 80 7c 	movl   $0x80110d7c,0x80110dcc
80100055:	0d 11 80 
  bcache.head.next = &bcache.head;
80100058:	c7 05 d0 0d 11 80 7c 	movl   $0x80110d7c,0x80110dd0
8010005f:	0d 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100062:	c7 45 f4 b4 c6 10 80 	movl   $0x8010c6b4,-0xc(%ebp)
80100069:	eb 46                	jmp    801000b1 <binit+0x7d>
    b->next = bcache.head.next;
8010006b:	8b 15 d0 0d 11 80    	mov    0x80110dd0,%edx
80100071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100074:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
80100077:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007a:	c7 40 50 7c 0d 11 80 	movl   $0x80110d7c,0x50(%eax)
    initsleeplock(&b->lock, "buffer");
80100081:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100084:	83 c0 0c             	add    $0xc,%eax
80100087:	c7 44 24 04 0f 85 10 	movl   $0x8010850f,0x4(%esp)
8010008e:	80 
8010008f:	89 04 24             	mov    %eax,(%esp)
80100092:	e8 32 4e 00 00       	call   80104ec9 <initsleeplock>
    bcache.head.next->prev = b;
80100097:	a1 d0 0d 11 80       	mov    0x80110dd0,%eax
8010009c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010009f:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
801000a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000a5:	a3 d0 0d 11 80       	mov    %eax,0x80110dd0
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	81 45 f4 5c 02 00 00 	addl   $0x25c,-0xc(%ebp)
801000b1:	81 7d f4 7c 0d 11 80 	cmpl   $0x80110d7c,-0xc(%ebp)
801000b8:	72 b1                	jb     8010006b <binit+0x37>
  }
}
801000ba:	c9                   	leave  
801000bb:	c3                   	ret    

801000bc <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
801000bc:	55                   	push   %ebp
801000bd:	89 e5                	mov    %esp,%ebp
801000bf:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000c2:	c7 04 24 80 c6 10 80 	movl   $0x8010c680,(%esp)
801000c9:	e8 7f 4f 00 00       	call   8010504d <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ce:	a1 d0 0d 11 80       	mov    0x80110dd0,%eax
801000d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000d6:	eb 50                	jmp    80100128 <bget+0x6c>
    if(b->dev == dev && b->blockno == blockno){
801000d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000db:	8b 40 04             	mov    0x4(%eax),%eax
801000de:	3b 45 08             	cmp    0x8(%ebp),%eax
801000e1:	75 3c                	jne    8010011f <bget+0x63>
801000e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e6:	8b 40 08             	mov    0x8(%eax),%eax
801000e9:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000ec:	75 31                	jne    8010011f <bget+0x63>
      b->refcnt++;
801000ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f1:	8b 40 4c             	mov    0x4c(%eax),%eax
801000f4:	8d 50 01             	lea    0x1(%eax),%edx
801000f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000fa:	89 50 4c             	mov    %edx,0x4c(%eax)
      release(&bcache.lock);
801000fd:	c7 04 24 80 c6 10 80 	movl   $0x8010c680,(%esp)
80100104:	e8 ac 4f 00 00       	call   801050b5 <release>
      acquiresleep(&b->lock);
80100109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010c:	83 c0 0c             	add    $0xc,%eax
8010010f:	89 04 24             	mov    %eax,(%esp)
80100112:	e8 ec 4d 00 00       	call   80104f03 <acquiresleep>
      return b;
80100117:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011a:	e9 94 00 00 00       	jmp    801001b3 <bget+0xf7>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
8010011f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100122:	8b 40 54             	mov    0x54(%eax),%eax
80100125:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100128:	81 7d f4 7c 0d 11 80 	cmpl   $0x80110d7c,-0xc(%ebp)
8010012f:	75 a7                	jne    801000d8 <bget+0x1c>
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100131:	a1 cc 0d 11 80       	mov    0x80110dcc,%eax
80100136:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100139:	eb 63                	jmp    8010019e <bget+0xe2>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010013e:	8b 40 4c             	mov    0x4c(%eax),%eax
80100141:	85 c0                	test   %eax,%eax
80100143:	75 50                	jne    80100195 <bget+0xd9>
80100145:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100148:	8b 00                	mov    (%eax),%eax
8010014a:	83 e0 04             	and    $0x4,%eax
8010014d:	85 c0                	test   %eax,%eax
8010014f:	75 44                	jne    80100195 <bget+0xd9>
      b->dev = dev;
80100151:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100154:	8b 55 08             	mov    0x8(%ebp),%edx
80100157:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
8010015a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015d:	8b 55 0c             	mov    0xc(%ebp),%edx
80100160:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = 0;
80100163:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100166:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
      b->refcnt = 1;
8010016c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010016f:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
      release(&bcache.lock);
80100176:	c7 04 24 80 c6 10 80 	movl   $0x8010c680,(%esp)
8010017d:	e8 33 4f 00 00       	call   801050b5 <release>
      acquiresleep(&b->lock);
80100182:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100185:	83 c0 0c             	add    $0xc,%eax
80100188:	89 04 24             	mov    %eax,(%esp)
8010018b:	e8 73 4d 00 00       	call   80104f03 <acquiresleep>
      return b;
80100190:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100193:	eb 1e                	jmp    801001b3 <bget+0xf7>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100195:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100198:	8b 40 50             	mov    0x50(%eax),%eax
8010019b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010019e:	81 7d f4 7c 0d 11 80 	cmpl   $0x80110d7c,-0xc(%ebp)
801001a5:	75 94                	jne    8010013b <bget+0x7f>
    }
  }
  panic("bget: no buffers");
801001a7:	c7 04 24 16 85 10 80 	movl   $0x80108516,(%esp)
801001ae:	e8 af 03 00 00       	call   80100562 <panic>
}
801001b3:	c9                   	leave  
801001b4:	c3                   	ret    

801001b5 <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801001b5:	55                   	push   %ebp
801001b6:	89 e5                	mov    %esp,%ebp
801001b8:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  b = bget(dev, blockno);
801001bb:	8b 45 0c             	mov    0xc(%ebp),%eax
801001be:	89 44 24 04          	mov    %eax,0x4(%esp)
801001c2:	8b 45 08             	mov    0x8(%ebp),%eax
801001c5:	89 04 24             	mov    %eax,(%esp)
801001c8:	e8 ef fe ff ff       	call   801000bc <bget>
801001cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((b->flags & B_VALID) == 0) {
801001d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d3:	8b 00                	mov    (%eax),%eax
801001d5:	83 e0 02             	and    $0x2,%eax
801001d8:	85 c0                	test   %eax,%eax
801001da:	75 0b                	jne    801001e7 <bread+0x32>
    iderw(b);
801001dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001df:	89 04 24             	mov    %eax,(%esp)
801001e2:	e8 a4 26 00 00       	call   8010288b <iderw>
  }
  return b;
801001e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001ea:	c9                   	leave  
801001eb:	c3                   	ret    

801001ec <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001ec:	55                   	push   %ebp
801001ed:	89 e5                	mov    %esp,%ebp
801001ef:	83 ec 18             	sub    $0x18,%esp
  if(!holdingsleep(&b->lock))
801001f2:	8b 45 08             	mov    0x8(%ebp),%eax
801001f5:	83 c0 0c             	add    $0xc,%eax
801001f8:	89 04 24             	mov    %eax,(%esp)
801001fb:	e8 a0 4d 00 00       	call   80104fa0 <holdingsleep>
80100200:	85 c0                	test   %eax,%eax
80100202:	75 0c                	jne    80100210 <bwrite+0x24>
    panic("bwrite");
80100204:	c7 04 24 27 85 10 80 	movl   $0x80108527,(%esp)
8010020b:	e8 52 03 00 00       	call   80100562 <panic>
  b->flags |= B_DIRTY;
80100210:	8b 45 08             	mov    0x8(%ebp),%eax
80100213:	8b 00                	mov    (%eax),%eax
80100215:	83 c8 04             	or     $0x4,%eax
80100218:	89 c2                	mov    %eax,%edx
8010021a:	8b 45 08             	mov    0x8(%ebp),%eax
8010021d:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010021f:	8b 45 08             	mov    0x8(%ebp),%eax
80100222:	89 04 24             	mov    %eax,(%esp)
80100225:	e8 61 26 00 00       	call   8010288b <iderw>
}
8010022a:	c9                   	leave  
8010022b:	c3                   	ret    

8010022c <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
8010022c:	55                   	push   %ebp
8010022d:	89 e5                	mov    %esp,%ebp
8010022f:	83 ec 18             	sub    $0x18,%esp
  if(!holdingsleep(&b->lock))
80100232:	8b 45 08             	mov    0x8(%ebp),%eax
80100235:	83 c0 0c             	add    $0xc,%eax
80100238:	89 04 24             	mov    %eax,(%esp)
8010023b:	e8 60 4d 00 00       	call   80104fa0 <holdingsleep>
80100240:	85 c0                	test   %eax,%eax
80100242:	75 0c                	jne    80100250 <brelse+0x24>
    panic("brelse");
80100244:	c7 04 24 2e 85 10 80 	movl   $0x8010852e,(%esp)
8010024b:	e8 12 03 00 00       	call   80100562 <panic>

  releasesleep(&b->lock);
80100250:	8b 45 08             	mov    0x8(%ebp),%eax
80100253:	83 c0 0c             	add    $0xc,%eax
80100256:	89 04 24             	mov    %eax,(%esp)
80100259:	e8 00 4d 00 00       	call   80104f5e <releasesleep>

  acquire(&bcache.lock);
8010025e:	c7 04 24 80 c6 10 80 	movl   $0x8010c680,(%esp)
80100265:	e8 e3 4d 00 00       	call   8010504d <acquire>
  b->refcnt--;
8010026a:	8b 45 08             	mov    0x8(%ebp),%eax
8010026d:	8b 40 4c             	mov    0x4c(%eax),%eax
80100270:	8d 50 ff             	lea    -0x1(%eax),%edx
80100273:	8b 45 08             	mov    0x8(%ebp),%eax
80100276:	89 50 4c             	mov    %edx,0x4c(%eax)
  if (b->refcnt == 0) {
80100279:	8b 45 08             	mov    0x8(%ebp),%eax
8010027c:	8b 40 4c             	mov    0x4c(%eax),%eax
8010027f:	85 c0                	test   %eax,%eax
80100281:	75 47                	jne    801002ca <brelse+0x9e>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100283:	8b 45 08             	mov    0x8(%ebp),%eax
80100286:	8b 40 54             	mov    0x54(%eax),%eax
80100289:	8b 55 08             	mov    0x8(%ebp),%edx
8010028c:	8b 52 50             	mov    0x50(%edx),%edx
8010028f:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100292:	8b 45 08             	mov    0x8(%ebp),%eax
80100295:	8b 40 50             	mov    0x50(%eax),%eax
80100298:	8b 55 08             	mov    0x8(%ebp),%edx
8010029b:	8b 52 54             	mov    0x54(%edx),%edx
8010029e:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
801002a1:	8b 15 d0 0d 11 80    	mov    0x80110dd0,%edx
801002a7:	8b 45 08             	mov    0x8(%ebp),%eax
801002aa:	89 50 54             	mov    %edx,0x54(%eax)
    b->prev = &bcache.head;
801002ad:	8b 45 08             	mov    0x8(%ebp),%eax
801002b0:	c7 40 50 7c 0d 11 80 	movl   $0x80110d7c,0x50(%eax)
    bcache.head.next->prev = b;
801002b7:	a1 d0 0d 11 80       	mov    0x80110dd0,%eax
801002bc:	8b 55 08             	mov    0x8(%ebp),%edx
801002bf:	89 50 50             	mov    %edx,0x50(%eax)
    bcache.head.next = b;
801002c2:	8b 45 08             	mov    0x8(%ebp),%eax
801002c5:	a3 d0 0d 11 80       	mov    %eax,0x80110dd0
  }
  
  release(&bcache.lock);
801002ca:	c7 04 24 80 c6 10 80 	movl   $0x8010c680,(%esp)
801002d1:	e8 df 4d 00 00       	call   801050b5 <release>
}
801002d6:	c9                   	leave  
801002d7:	c3                   	ret    

801002d8 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002d8:	55                   	push   %ebp
801002d9:	89 e5                	mov    %esp,%ebp
801002db:	83 ec 14             	sub    $0x14,%esp
801002de:	8b 45 08             	mov    0x8(%ebp),%eax
801002e1:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002e5:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002e9:	89 c2                	mov    %eax,%edx
801002eb:	ec                   	in     (%dx),%al
801002ec:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002ef:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801002f3:	c9                   	leave  
801002f4:	c3                   	ret    

801002f5 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002f5:	55                   	push   %ebp
801002f6:	89 e5                	mov    %esp,%ebp
801002f8:	83 ec 08             	sub    $0x8,%esp
801002fb:	8b 55 08             	mov    0x8(%ebp),%edx
801002fe:	8b 45 0c             	mov    0xc(%ebp),%eax
80100301:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80100305:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100308:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010030c:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80100310:	ee                   	out    %al,(%dx)
}
80100311:	c9                   	leave  
80100312:	c3                   	ret    

80100313 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80100313:	55                   	push   %ebp
80100314:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80100316:	fa                   	cli    
}
80100317:	5d                   	pop    %ebp
80100318:	c3                   	ret    

80100319 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100319:	55                   	push   %ebp
8010031a:	89 e5                	mov    %esp,%ebp
8010031c:	56                   	push   %esi
8010031d:	53                   	push   %ebx
8010031e:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100321:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100325:	74 1c                	je     80100343 <printint+0x2a>
80100327:	8b 45 08             	mov    0x8(%ebp),%eax
8010032a:	c1 e8 1f             	shr    $0x1f,%eax
8010032d:	0f b6 c0             	movzbl %al,%eax
80100330:	89 45 10             	mov    %eax,0x10(%ebp)
80100333:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100337:	74 0a                	je     80100343 <printint+0x2a>
    x = -xx;
80100339:	8b 45 08             	mov    0x8(%ebp),%eax
8010033c:	f7 d8                	neg    %eax
8010033e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100341:	eb 06                	jmp    80100349 <printint+0x30>
  else
    x = xx;
80100343:	8b 45 08             	mov    0x8(%ebp),%eax
80100346:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100349:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
80100350:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100353:	8d 41 01             	lea    0x1(%ecx),%eax
80100356:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100359:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010035c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010035f:	ba 00 00 00 00       	mov    $0x0,%edx
80100364:	f7 f3                	div    %ebx
80100366:	89 d0                	mov    %edx,%eax
80100368:	0f b6 80 04 90 10 80 	movzbl -0x7fef6ffc(%eax),%eax
8010036f:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
  }while((x /= base) != 0);
80100373:	8b 75 0c             	mov    0xc(%ebp),%esi
80100376:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100379:	ba 00 00 00 00       	mov    $0x0,%edx
8010037e:	f7 f6                	div    %esi
80100380:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100383:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100387:	75 c7                	jne    80100350 <printint+0x37>

  if(sign)
80100389:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010038d:	74 10                	je     8010039f <printint+0x86>
    buf[i++] = '-';
8010038f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100392:	8d 50 01             	lea    0x1(%eax),%edx
80100395:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100398:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
8010039d:	eb 18                	jmp    801003b7 <printint+0x9e>
8010039f:	eb 16                	jmp    801003b7 <printint+0x9e>
    consputc(buf[i]);
801003a1:	8d 55 e0             	lea    -0x20(%ebp),%edx
801003a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003a7:	01 d0                	add    %edx,%eax
801003a9:	0f b6 00             	movzbl (%eax),%eax
801003ac:	0f be c0             	movsbl %al,%eax
801003af:	89 04 24             	mov    %eax,(%esp)
801003b2:	e8 d5 03 00 00       	call   8010078c <consputc>
  while(--i >= 0)
801003b7:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801003bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003bf:	79 e0                	jns    801003a1 <printint+0x88>
}
801003c1:	83 c4 30             	add    $0x30,%esp
801003c4:	5b                   	pop    %ebx
801003c5:	5e                   	pop    %esi
801003c6:	5d                   	pop    %ebp
801003c7:	c3                   	ret    

801003c8 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003c8:	55                   	push   %ebp
801003c9:	89 e5                	mov    %esp,%ebp
801003cb:	83 ec 38             	sub    $0x38,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003ce:	a1 14 b6 10 80       	mov    0x8010b614,%eax
801003d3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003d6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003da:	74 0c                	je     801003e8 <cprintf+0x20>
    acquire(&cons.lock);
801003dc:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
801003e3:	e8 65 4c 00 00       	call   8010504d <acquire>

  if (fmt == 0)
801003e8:	8b 45 08             	mov    0x8(%ebp),%eax
801003eb:	85 c0                	test   %eax,%eax
801003ed:	75 0c                	jne    801003fb <cprintf+0x33>
    panic("null fmt");
801003ef:	c7 04 24 35 85 10 80 	movl   $0x80108535,(%esp)
801003f6:	e8 67 01 00 00       	call   80100562 <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003fb:	8d 45 0c             	lea    0xc(%ebp),%eax
801003fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100401:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100408:	e9 21 01 00 00       	jmp    8010052e <cprintf+0x166>
    if(c != '%'){
8010040d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
80100411:	74 10                	je     80100423 <cprintf+0x5b>
      consputc(c);
80100413:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100416:	89 04 24             	mov    %eax,(%esp)
80100419:	e8 6e 03 00 00       	call   8010078c <consputc>
      continue;
8010041e:	e9 07 01 00 00       	jmp    8010052a <cprintf+0x162>
    }
    c = fmt[++i] & 0xff;
80100423:	8b 55 08             	mov    0x8(%ebp),%edx
80100426:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010042a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010042d:	01 d0                	add    %edx,%eax
8010042f:	0f b6 00             	movzbl (%eax),%eax
80100432:	0f be c0             	movsbl %al,%eax
80100435:	25 ff 00 00 00       	and    $0xff,%eax
8010043a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
8010043d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100441:	75 05                	jne    80100448 <cprintf+0x80>
      break;
80100443:	e9 06 01 00 00       	jmp    8010054e <cprintf+0x186>
    switch(c){
80100448:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010044b:	83 f8 70             	cmp    $0x70,%eax
8010044e:	74 4f                	je     8010049f <cprintf+0xd7>
80100450:	83 f8 70             	cmp    $0x70,%eax
80100453:	7f 13                	jg     80100468 <cprintf+0xa0>
80100455:	83 f8 25             	cmp    $0x25,%eax
80100458:	0f 84 a6 00 00 00    	je     80100504 <cprintf+0x13c>
8010045e:	83 f8 64             	cmp    $0x64,%eax
80100461:	74 14                	je     80100477 <cprintf+0xaf>
80100463:	e9 aa 00 00 00       	jmp    80100512 <cprintf+0x14a>
80100468:	83 f8 73             	cmp    $0x73,%eax
8010046b:	74 57                	je     801004c4 <cprintf+0xfc>
8010046d:	83 f8 78             	cmp    $0x78,%eax
80100470:	74 2d                	je     8010049f <cprintf+0xd7>
80100472:	e9 9b 00 00 00       	jmp    80100512 <cprintf+0x14a>
    case 'd':
      printint(*argp++, 10, 1);
80100477:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010047a:	8d 50 04             	lea    0x4(%eax),%edx
8010047d:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100480:	8b 00                	mov    (%eax),%eax
80100482:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80100489:	00 
8010048a:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80100491:	00 
80100492:	89 04 24             	mov    %eax,(%esp)
80100495:	e8 7f fe ff ff       	call   80100319 <printint>
      break;
8010049a:	e9 8b 00 00 00       	jmp    8010052a <cprintf+0x162>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010049f:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004a2:	8d 50 04             	lea    0x4(%eax),%edx
801004a5:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004a8:	8b 00                	mov    (%eax),%eax
801004aa:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801004b1:	00 
801004b2:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
801004b9:	00 
801004ba:	89 04 24             	mov    %eax,(%esp)
801004bd:	e8 57 fe ff ff       	call   80100319 <printint>
      break;
801004c2:	eb 66                	jmp    8010052a <cprintf+0x162>
    case 's':
      if((s = (char*)*argp++) == 0)
801004c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004c7:	8d 50 04             	lea    0x4(%eax),%edx
801004ca:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004cd:	8b 00                	mov    (%eax),%eax
801004cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004d2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004d6:	75 09                	jne    801004e1 <cprintf+0x119>
        s = "(null)";
801004d8:	c7 45 ec 3e 85 10 80 	movl   $0x8010853e,-0x14(%ebp)
      for(; *s; s++)
801004df:	eb 17                	jmp    801004f8 <cprintf+0x130>
801004e1:	eb 15                	jmp    801004f8 <cprintf+0x130>
        consputc(*s);
801004e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004e6:	0f b6 00             	movzbl (%eax),%eax
801004e9:	0f be c0             	movsbl %al,%eax
801004ec:	89 04 24             	mov    %eax,(%esp)
801004ef:	e8 98 02 00 00       	call   8010078c <consputc>
      for(; *s; s++)
801004f4:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801004f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004fb:	0f b6 00             	movzbl (%eax),%eax
801004fe:	84 c0                	test   %al,%al
80100500:	75 e1                	jne    801004e3 <cprintf+0x11b>
      break;
80100502:	eb 26                	jmp    8010052a <cprintf+0x162>
    case '%':
      consputc('%');
80100504:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
8010050b:	e8 7c 02 00 00       	call   8010078c <consputc>
      break;
80100510:	eb 18                	jmp    8010052a <cprintf+0x162>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100512:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
80100519:	e8 6e 02 00 00       	call   8010078c <consputc>
      consputc(c);
8010051e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100521:	89 04 24             	mov    %eax,(%esp)
80100524:	e8 63 02 00 00       	call   8010078c <consputc>
      break;
80100529:	90                   	nop
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010052a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010052e:	8b 55 08             	mov    0x8(%ebp),%edx
80100531:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100534:	01 d0                	add    %edx,%eax
80100536:	0f b6 00             	movzbl (%eax),%eax
80100539:	0f be c0             	movsbl %al,%eax
8010053c:	25 ff 00 00 00       	and    $0xff,%eax
80100541:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100544:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100548:	0f 85 bf fe ff ff    	jne    8010040d <cprintf+0x45>
    }
  }

  if(locking)
8010054e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100552:	74 0c                	je     80100560 <cprintf+0x198>
    release(&cons.lock);
80100554:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
8010055b:	e8 55 4b 00 00       	call   801050b5 <release>
}
80100560:	c9                   	leave  
80100561:	c3                   	ret    

80100562 <panic>:

void
panic(char *s)
{
80100562:	55                   	push   %ebp
80100563:	89 e5                	mov    %esp,%ebp
80100565:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint pcs[10];

  cli();
80100568:	e8 a6 fd ff ff       	call   80100313 <cli>
  cons.locking = 0;
8010056d:	c7 05 14 b6 10 80 00 	movl   $0x0,0x8010b614
80100574:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
80100577:	e8 b3 29 00 00       	call   80102f2f <lapicid>
8010057c:	89 44 24 04          	mov    %eax,0x4(%esp)
80100580:	c7 04 24 45 85 10 80 	movl   $0x80108545,(%esp)
80100587:	e8 3c fe ff ff       	call   801003c8 <cprintf>
  cprintf(s);
8010058c:	8b 45 08             	mov    0x8(%ebp),%eax
8010058f:	89 04 24             	mov    %eax,(%esp)
80100592:	e8 31 fe ff ff       	call   801003c8 <cprintf>
  cprintf("\n");
80100597:	c7 04 24 59 85 10 80 	movl   $0x80108559,(%esp)
8010059e:	e8 25 fe ff ff       	call   801003c8 <cprintf>
  getcallerpcs(&s, pcs);
801005a3:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005a6:	89 44 24 04          	mov    %eax,0x4(%esp)
801005aa:	8d 45 08             	lea    0x8(%ebp),%eax
801005ad:	89 04 24             	mov    %eax,(%esp)
801005b0:	e8 4b 4b 00 00       	call   80105100 <getcallerpcs>
  for(i=0; i<10; i++)
801005b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005bc:	eb 1b                	jmp    801005d9 <panic+0x77>
    cprintf(" %p", pcs[i]);
801005be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005c1:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005c5:	89 44 24 04          	mov    %eax,0x4(%esp)
801005c9:	c7 04 24 5b 85 10 80 	movl   $0x8010855b,(%esp)
801005d0:	e8 f3 fd ff ff       	call   801003c8 <cprintf>
  for(i=0; i<10; i++)
801005d5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005d9:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005dd:	7e df                	jle    801005be <panic+0x5c>
  panicked = 1; // freeze other CPU
801005df:	c7 05 c0 b5 10 80 01 	movl   $0x1,0x8010b5c0
801005e6:	00 00 00 
  for(;;)
    ;
801005e9:	eb fe                	jmp    801005e9 <panic+0x87>

801005eb <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
801005eb:	55                   	push   %ebp
801005ec:	89 e5                	mov    %esp,%ebp
801005ee:	83 ec 28             	sub    $0x28,%esp
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
801005f1:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801005f8:	00 
801005f9:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100600:	e8 f0 fc ff ff       	call   801002f5 <outb>
  pos = inb(CRTPORT+1) << 8;
80100605:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
8010060c:	e8 c7 fc ff ff       	call   801002d8 <inb>
80100611:	0f b6 c0             	movzbl %al,%eax
80100614:	c1 e0 08             	shl    $0x8,%eax
80100617:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
8010061a:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80100621:	00 
80100622:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100629:	e8 c7 fc ff ff       	call   801002f5 <outb>
  pos |= inb(CRTPORT+1);
8010062e:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100635:	e8 9e fc ff ff       	call   801002d8 <inb>
8010063a:	0f b6 c0             	movzbl %al,%eax
8010063d:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
80100640:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100644:	75 30                	jne    80100676 <cgaputc+0x8b>
    pos += 80 - pos%80;
80100646:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100649:	ba 67 66 66 66       	mov    $0x66666667,%edx
8010064e:	89 c8                	mov    %ecx,%eax
80100650:	f7 ea                	imul   %edx
80100652:	c1 fa 05             	sar    $0x5,%edx
80100655:	89 c8                	mov    %ecx,%eax
80100657:	c1 f8 1f             	sar    $0x1f,%eax
8010065a:	29 c2                	sub    %eax,%edx
8010065c:	89 d0                	mov    %edx,%eax
8010065e:	c1 e0 02             	shl    $0x2,%eax
80100661:	01 d0                	add    %edx,%eax
80100663:	c1 e0 04             	shl    $0x4,%eax
80100666:	29 c1                	sub    %eax,%ecx
80100668:	89 ca                	mov    %ecx,%edx
8010066a:	b8 50 00 00 00       	mov    $0x50,%eax
8010066f:	29 d0                	sub    %edx,%eax
80100671:	01 45 f4             	add    %eax,-0xc(%ebp)
80100674:	eb 35                	jmp    801006ab <cgaputc+0xc0>
  else if(c == BACKSPACE){
80100676:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010067d:	75 0c                	jne    8010068b <cgaputc+0xa0>
    if(pos > 0) --pos;
8010067f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100683:	7e 26                	jle    801006ab <cgaputc+0xc0>
80100685:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100689:	eb 20                	jmp    801006ab <cgaputc+0xc0>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010068b:	8b 0d 00 90 10 80    	mov    0x80109000,%ecx
80100691:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100694:	8d 50 01             	lea    0x1(%eax),%edx
80100697:	89 55 f4             	mov    %edx,-0xc(%ebp)
8010069a:	01 c0                	add    %eax,%eax
8010069c:	8d 14 01             	lea    (%ecx,%eax,1),%edx
8010069f:	8b 45 08             	mov    0x8(%ebp),%eax
801006a2:	0f b6 c0             	movzbl %al,%eax
801006a5:	80 cc 07             	or     $0x7,%ah
801006a8:	66 89 02             	mov    %ax,(%edx)

  if(pos < 0 || pos > 25*80)
801006ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801006af:	78 09                	js     801006ba <cgaputc+0xcf>
801006b1:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
801006b8:	7e 0c                	jle    801006c6 <cgaputc+0xdb>
    panic("pos under/overflow");
801006ba:	c7 04 24 5f 85 10 80 	movl   $0x8010855f,(%esp)
801006c1:	e8 9c fe ff ff       	call   80100562 <panic>

  if((pos/80) >= 24){  // Scroll up.
801006c6:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
801006cd:	7e 53                	jle    80100722 <cgaputc+0x137>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801006cf:	a1 00 90 10 80       	mov    0x80109000,%eax
801006d4:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
801006da:	a1 00 90 10 80       	mov    0x80109000,%eax
801006df:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801006e6:	00 
801006e7:	89 54 24 04          	mov    %edx,0x4(%esp)
801006eb:	89 04 24             	mov    %eax,(%esp)
801006ee:	e8 9b 4c 00 00       	call   8010538e <memmove>
    pos -= 80;
801006f3:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801006f7:	b8 80 07 00 00       	mov    $0x780,%eax
801006fc:	2b 45 f4             	sub    -0xc(%ebp),%eax
801006ff:	8d 14 00             	lea    (%eax,%eax,1),%edx
80100702:	a1 00 90 10 80       	mov    0x80109000,%eax
80100707:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010070a:	01 c9                	add    %ecx,%ecx
8010070c:	01 c8                	add    %ecx,%eax
8010070e:	89 54 24 08          	mov    %edx,0x8(%esp)
80100712:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100719:	00 
8010071a:	89 04 24             	mov    %eax,(%esp)
8010071d:	e8 9d 4b 00 00       	call   801052bf <memset>
  }

  outb(CRTPORT, 14);
80100722:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
80100729:	00 
8010072a:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100731:	e8 bf fb ff ff       	call   801002f5 <outb>
  outb(CRTPORT+1, pos>>8);
80100736:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100739:	c1 f8 08             	sar    $0x8,%eax
8010073c:	0f b6 c0             	movzbl %al,%eax
8010073f:	89 44 24 04          	mov    %eax,0x4(%esp)
80100743:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
8010074a:	e8 a6 fb ff ff       	call   801002f5 <outb>
  outb(CRTPORT, 15);
8010074f:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80100756:	00 
80100757:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
8010075e:	e8 92 fb ff ff       	call   801002f5 <outb>
  outb(CRTPORT+1, pos);
80100763:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100766:	0f b6 c0             	movzbl %al,%eax
80100769:	89 44 24 04          	mov    %eax,0x4(%esp)
8010076d:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100774:	e8 7c fb ff ff       	call   801002f5 <outb>
  crt[pos] = ' ' | 0x0700;
80100779:	a1 00 90 10 80       	mov    0x80109000,%eax
8010077e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100781:	01 d2                	add    %edx,%edx
80100783:	01 d0                	add    %edx,%eax
80100785:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
8010078a:	c9                   	leave  
8010078b:	c3                   	ret    

8010078c <consputc>:

void
consputc(int c)
{
8010078c:	55                   	push   %ebp
8010078d:	89 e5                	mov    %esp,%ebp
8010078f:	83 ec 18             	sub    $0x18,%esp
  if(panicked){
80100792:	a1 c0 b5 10 80       	mov    0x8010b5c0,%eax
80100797:	85 c0                	test   %eax,%eax
80100799:	74 07                	je     801007a2 <consputc+0x16>
    cli();
8010079b:	e8 73 fb ff ff       	call   80100313 <cli>
    for(;;)
      ;
801007a0:	eb fe                	jmp    801007a0 <consputc+0x14>
  }

  if(c == BACKSPACE){
801007a2:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801007a9:	75 26                	jne    801007d1 <consputc+0x45>
    uartputc('\b'); uartputc(' '); uartputc('\b');
801007ab:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801007b2:	e8 9d 64 00 00       	call   80106c54 <uartputc>
801007b7:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801007be:	e8 91 64 00 00       	call   80106c54 <uartputc>
801007c3:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801007ca:	e8 85 64 00 00       	call   80106c54 <uartputc>
801007cf:	eb 0b                	jmp    801007dc <consputc+0x50>
  } else
    uartputc(c);
801007d1:	8b 45 08             	mov    0x8(%ebp),%eax
801007d4:	89 04 24             	mov    %eax,(%esp)
801007d7:	e8 78 64 00 00       	call   80106c54 <uartputc>
  cgaputc(c);
801007dc:	8b 45 08             	mov    0x8(%ebp),%eax
801007df:	89 04 24             	mov    %eax,(%esp)
801007e2:	e8 04 fe ff ff       	call   801005eb <cgaputc>
}
801007e7:	c9                   	leave  
801007e8:	c3                   	ret    

801007e9 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007e9:	55                   	push   %ebp
801007ea:	89 e5                	mov    %esp,%ebp
801007ec:	83 ec 28             	sub    $0x28,%esp
  int c, doprocdump = 0;
801007ef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&cons.lock);
801007f6:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
801007fd:	e8 4b 48 00 00       	call   8010504d <acquire>
  while((c = getc()) >= 0){
80100802:	e9 39 01 00 00       	jmp    80100940 <consoleintr+0x157>
    switch(c){
80100807:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010080a:	83 f8 10             	cmp    $0x10,%eax
8010080d:	74 1e                	je     8010082d <consoleintr+0x44>
8010080f:	83 f8 10             	cmp    $0x10,%eax
80100812:	7f 0a                	jg     8010081e <consoleintr+0x35>
80100814:	83 f8 08             	cmp    $0x8,%eax
80100817:	74 66                	je     8010087f <consoleintr+0x96>
80100819:	e9 93 00 00 00       	jmp    801008b1 <consoleintr+0xc8>
8010081e:	83 f8 15             	cmp    $0x15,%eax
80100821:	74 31                	je     80100854 <consoleintr+0x6b>
80100823:	83 f8 7f             	cmp    $0x7f,%eax
80100826:	74 57                	je     8010087f <consoleintr+0x96>
80100828:	e9 84 00 00 00       	jmp    801008b1 <consoleintr+0xc8>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
8010082d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      break;
80100834:	e9 07 01 00 00       	jmp    80100940 <consoleintr+0x157>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100839:	a1 68 10 11 80       	mov    0x80111068,%eax
8010083e:	83 e8 01             	sub    $0x1,%eax
80100841:	a3 68 10 11 80       	mov    %eax,0x80111068
        consputc(BACKSPACE);
80100846:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
8010084d:	e8 3a ff ff ff       	call   8010078c <consputc>
80100852:	eb 01                	jmp    80100855 <consoleintr+0x6c>
      while(input.e != input.w &&
80100854:	90                   	nop
80100855:	8b 15 68 10 11 80    	mov    0x80111068,%edx
8010085b:	a1 64 10 11 80       	mov    0x80111064,%eax
80100860:	39 c2                	cmp    %eax,%edx
80100862:	74 16                	je     8010087a <consoleintr+0x91>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100864:	a1 68 10 11 80       	mov    0x80111068,%eax
80100869:	83 e8 01             	sub    $0x1,%eax
8010086c:	83 e0 7f             	and    $0x7f,%eax
8010086f:	0f b6 80 e0 0f 11 80 	movzbl -0x7feef020(%eax),%eax
      while(input.e != input.w &&
80100876:	3c 0a                	cmp    $0xa,%al
80100878:	75 bf                	jne    80100839 <consoleintr+0x50>
      }
      break;
8010087a:	e9 c1 00 00 00       	jmp    80100940 <consoleintr+0x157>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
8010087f:	8b 15 68 10 11 80    	mov    0x80111068,%edx
80100885:	a1 64 10 11 80       	mov    0x80111064,%eax
8010088a:	39 c2                	cmp    %eax,%edx
8010088c:	74 1e                	je     801008ac <consoleintr+0xc3>
        input.e--;
8010088e:	a1 68 10 11 80       	mov    0x80111068,%eax
80100893:	83 e8 01             	sub    $0x1,%eax
80100896:	a3 68 10 11 80       	mov    %eax,0x80111068
        consputc(BACKSPACE);
8010089b:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
801008a2:	e8 e5 fe ff ff       	call   8010078c <consputc>
      }
      break;
801008a7:	e9 94 00 00 00       	jmp    80100940 <consoleintr+0x157>
801008ac:	e9 8f 00 00 00       	jmp    80100940 <consoleintr+0x157>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801008b5:	0f 84 84 00 00 00    	je     8010093f <consoleintr+0x156>
801008bb:	8b 15 68 10 11 80    	mov    0x80111068,%edx
801008c1:	a1 60 10 11 80       	mov    0x80111060,%eax
801008c6:	29 c2                	sub    %eax,%edx
801008c8:	89 d0                	mov    %edx,%eax
801008ca:	83 f8 7f             	cmp    $0x7f,%eax
801008cd:	77 70                	ja     8010093f <consoleintr+0x156>
        c = (c == '\r') ? '\n' : c;
801008cf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801008d3:	74 05                	je     801008da <consoleintr+0xf1>
801008d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801008d8:	eb 05                	jmp    801008df <consoleintr+0xf6>
801008da:	b8 0a 00 00 00       	mov    $0xa,%eax
801008df:	89 45 f0             	mov    %eax,-0x10(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
801008e2:	a1 68 10 11 80       	mov    0x80111068,%eax
801008e7:	8d 50 01             	lea    0x1(%eax),%edx
801008ea:	89 15 68 10 11 80    	mov    %edx,0x80111068
801008f0:	83 e0 7f             	and    $0x7f,%eax
801008f3:	89 c2                	mov    %eax,%edx
801008f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801008f8:	88 82 e0 0f 11 80    	mov    %al,-0x7feef020(%edx)
        consputc(c);
801008fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100901:	89 04 24             	mov    %eax,(%esp)
80100904:	e8 83 fe ff ff       	call   8010078c <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100909:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
8010090d:	74 18                	je     80100927 <consoleintr+0x13e>
8010090f:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100913:	74 12                	je     80100927 <consoleintr+0x13e>
80100915:	a1 68 10 11 80       	mov    0x80111068,%eax
8010091a:	8b 15 60 10 11 80    	mov    0x80111060,%edx
80100920:	83 ea 80             	sub    $0xffffff80,%edx
80100923:	39 d0                	cmp    %edx,%eax
80100925:	75 18                	jne    8010093f <consoleintr+0x156>
          input.w = input.e;
80100927:	a1 68 10 11 80       	mov    0x80111068,%eax
8010092c:	a3 64 10 11 80       	mov    %eax,0x80111064
          wakeup(&input.r);
80100931:	c7 04 24 60 10 11 80 	movl   $0x80111060,(%esp)
80100938:	e8 36 42 00 00       	call   80104b73 <wakeup>
        }
      }
      break;
8010093d:	eb 00                	jmp    8010093f <consoleintr+0x156>
8010093f:	90                   	nop
  while((c = getc()) >= 0){
80100940:	8b 45 08             	mov    0x8(%ebp),%eax
80100943:	ff d0                	call   *%eax
80100945:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100948:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010094c:	0f 89 b5 fe ff ff    	jns    80100807 <consoleintr+0x1e>
    }
  }
  release(&cons.lock);
80100952:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100959:	e8 57 47 00 00       	call   801050b5 <release>
  if(doprocdump) {
8010095e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100962:	74 05                	je     80100969 <consoleintr+0x180>
    procdump();  // now call procdump() wo. cons.lock held
80100964:	e8 b0 42 00 00       	call   80104c19 <procdump>
  }
}
80100969:	c9                   	leave  
8010096a:	c3                   	ret    

8010096b <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
8010096b:	55                   	push   %ebp
8010096c:	89 e5                	mov    %esp,%ebp
8010096e:	83 ec 28             	sub    $0x28,%esp
  uint target;
  int c;

  iunlock(ip);
80100971:	8b 45 08             	mov    0x8(%ebp),%eax
80100974:	89 04 24             	mov    %eax,(%esp)
80100977:	e8 ee 10 00 00       	call   80101a6a <iunlock>
  target = n;
8010097c:	8b 45 10             	mov    0x10(%ebp),%eax
8010097f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
80100982:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100989:	e8 bf 46 00 00       	call   8010504d <acquire>
  while(n > 0){
8010098e:	e9 a9 00 00 00       	jmp    80100a3c <consoleread+0xd1>
    while(input.r == input.w){
80100993:	eb 41                	jmp    801009d6 <consoleread+0x6b>
      if(myproc()->killed){
80100995:	e8 c7 37 00 00       	call   80104161 <myproc>
8010099a:	8b 40 24             	mov    0x24(%eax),%eax
8010099d:	85 c0                	test   %eax,%eax
8010099f:	74 21                	je     801009c2 <consoleread+0x57>
        release(&cons.lock);
801009a1:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
801009a8:	e8 08 47 00 00       	call   801050b5 <release>
        ilock(ip);
801009ad:	8b 45 08             	mov    0x8(%ebp),%eax
801009b0:	89 04 24             	mov    %eax,(%esp)
801009b3:	e8 a5 0f 00 00       	call   8010195d <ilock>
        return -1;
801009b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801009bd:	e9 a5 00 00 00       	jmp    80100a67 <consoleread+0xfc>
      }
      sleep(&input.r, &cons.lock);
801009c2:	c7 44 24 04 e0 b5 10 	movl   $0x8010b5e0,0x4(%esp)
801009c9:	80 
801009ca:	c7 04 24 60 10 11 80 	movl   $0x80111060,(%esp)
801009d1:	e8 c6 40 00 00       	call   80104a9c <sleep>
    while(input.r == input.w){
801009d6:	8b 15 60 10 11 80    	mov    0x80111060,%edx
801009dc:	a1 64 10 11 80       	mov    0x80111064,%eax
801009e1:	39 c2                	cmp    %eax,%edx
801009e3:	74 b0                	je     80100995 <consoleread+0x2a>
    }
    c = input.buf[input.r++ % INPUT_BUF];
801009e5:	a1 60 10 11 80       	mov    0x80111060,%eax
801009ea:	8d 50 01             	lea    0x1(%eax),%edx
801009ed:	89 15 60 10 11 80    	mov    %edx,0x80111060
801009f3:	83 e0 7f             	and    $0x7f,%eax
801009f6:	0f b6 80 e0 0f 11 80 	movzbl -0x7feef020(%eax),%eax
801009fd:	0f be c0             	movsbl %al,%eax
80100a00:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100a03:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100a07:	75 19                	jne    80100a22 <consoleread+0xb7>
      if(n < target){
80100a09:	8b 45 10             	mov    0x10(%ebp),%eax
80100a0c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80100a0f:	73 0f                	jae    80100a20 <consoleread+0xb5>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100a11:	a1 60 10 11 80       	mov    0x80111060,%eax
80100a16:	83 e8 01             	sub    $0x1,%eax
80100a19:	a3 60 10 11 80       	mov    %eax,0x80111060
      }
      break;
80100a1e:	eb 26                	jmp    80100a46 <consoleread+0xdb>
80100a20:	eb 24                	jmp    80100a46 <consoleread+0xdb>
    }
    *dst++ = c;
80100a22:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a25:	8d 50 01             	lea    0x1(%eax),%edx
80100a28:	89 55 0c             	mov    %edx,0xc(%ebp)
80100a2b:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100a2e:	88 10                	mov    %dl,(%eax)
    --n;
80100a30:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100a34:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100a38:	75 02                	jne    80100a3c <consoleread+0xd1>
      break;
80100a3a:	eb 0a                	jmp    80100a46 <consoleread+0xdb>
  while(n > 0){
80100a3c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100a40:	0f 8f 4d ff ff ff    	jg     80100993 <consoleread+0x28>
  }
  release(&cons.lock);
80100a46:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100a4d:	e8 63 46 00 00       	call   801050b5 <release>
  ilock(ip);
80100a52:	8b 45 08             	mov    0x8(%ebp),%eax
80100a55:	89 04 24             	mov    %eax,(%esp)
80100a58:	e8 00 0f 00 00       	call   8010195d <ilock>

  return target - n;
80100a5d:	8b 45 10             	mov    0x10(%ebp),%eax
80100a60:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a63:	29 c2                	sub    %eax,%edx
80100a65:	89 d0                	mov    %edx,%eax
}
80100a67:	c9                   	leave  
80100a68:	c3                   	ret    

80100a69 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100a69:	55                   	push   %ebp
80100a6a:	89 e5                	mov    %esp,%ebp
80100a6c:	83 ec 28             	sub    $0x28,%esp
  int i;

  iunlock(ip);
80100a6f:	8b 45 08             	mov    0x8(%ebp),%eax
80100a72:	89 04 24             	mov    %eax,(%esp)
80100a75:	e8 f0 0f 00 00       	call   80101a6a <iunlock>
  acquire(&cons.lock);
80100a7a:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100a81:	e8 c7 45 00 00       	call   8010504d <acquire>
  for(i = 0; i < n; i++)
80100a86:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100a8d:	eb 1d                	jmp    80100aac <consolewrite+0x43>
    consputc(buf[i] & 0xff);
80100a8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a92:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a95:	01 d0                	add    %edx,%eax
80100a97:	0f b6 00             	movzbl (%eax),%eax
80100a9a:	0f be c0             	movsbl %al,%eax
80100a9d:	0f b6 c0             	movzbl %al,%eax
80100aa0:	89 04 24             	mov    %eax,(%esp)
80100aa3:	e8 e4 fc ff ff       	call   8010078c <consputc>
  for(i = 0; i < n; i++)
80100aa8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100aac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100aaf:	3b 45 10             	cmp    0x10(%ebp),%eax
80100ab2:	7c db                	jl     80100a8f <consolewrite+0x26>
  release(&cons.lock);
80100ab4:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100abb:	e8 f5 45 00 00       	call   801050b5 <release>
  ilock(ip);
80100ac0:	8b 45 08             	mov    0x8(%ebp),%eax
80100ac3:	89 04 24             	mov    %eax,(%esp)
80100ac6:	e8 92 0e 00 00       	call   8010195d <ilock>

  return n;
80100acb:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100ace:	c9                   	leave  
80100acf:	c3                   	ret    

80100ad0 <consoleinit>:

void
consoleinit(void)
{
80100ad0:	55                   	push   %ebp
80100ad1:	89 e5                	mov    %esp,%ebp
80100ad3:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100ad6:	c7 44 24 04 72 85 10 	movl   $0x80108572,0x4(%esp)
80100add:	80 
80100ade:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100ae5:	e8 42 45 00 00       	call   8010502c <initlock>

  devsw[CONSOLE].write = consolewrite;
80100aea:	c7 05 2c 1a 11 80 69 	movl   $0x80100a69,0x80111a2c
80100af1:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100af4:	c7 05 28 1a 11 80 6b 	movl   $0x8010096b,0x80111a28
80100afb:	09 10 80 
  cons.locking = 1;
80100afe:	c7 05 14 b6 10 80 01 	movl   $0x1,0x8010b614
80100b05:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100b08:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100b0f:	00 
80100b10:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100b17:	e8 23 1f 00 00       	call   80102a3f <ioapicenable>
}
80100b1c:	c9                   	leave  
80100b1d:	c3                   	ret    

80100b1e <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b1e:	55                   	push   %ebp
80100b1f:	89 e5                	mov    %esp,%ebp
80100b21:	81 ec 38 01 00 00    	sub    $0x138,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100b27:	e8 35 36 00 00       	call   80104161 <myproc>
80100b2c:	89 45 d0             	mov    %eax,-0x30(%ebp)

  begin_op();
80100b2f:	e8 53 29 00 00       	call   80103487 <begin_op>

  if((ip = namei(path)) == 0){
80100b34:	8b 45 08             	mov    0x8(%ebp),%eax
80100b37:	89 04 24             	mov    %eax,(%esp)
80100b3a:	e8 58 19 00 00       	call   80102497 <namei>
80100b3f:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100b42:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100b46:	75 1b                	jne    80100b63 <exec+0x45>
    end_op();
80100b48:	e8 be 29 00 00       	call   8010350b <end_op>
    cprintf("exec: fail\n");
80100b4d:	c7 04 24 7a 85 10 80 	movl   $0x8010857a,(%esp)
80100b54:	e8 6f f8 ff ff       	call   801003c8 <cprintf>
    return -1;
80100b59:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b5e:	e9 04 04 00 00       	jmp    80100f67 <exec+0x449>
  }
  ilock(ip);
80100b63:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b66:	89 04 24             	mov    %eax,(%esp)
80100b69:	e8 ef 0d 00 00       	call   8010195d <ilock>
  pgdir = 0;
80100b6e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100b75:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
80100b7c:	00 
80100b7d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100b84:	00 
80100b85:	8d 85 08 ff ff ff    	lea    -0xf8(%ebp),%eax
80100b8b:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b8f:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b92:	89 04 24             	mov    %eax,(%esp)
80100b95:	e8 60 12 00 00       	call   80101dfa <readi>
80100b9a:	83 f8 34             	cmp    $0x34,%eax
80100b9d:	74 05                	je     80100ba4 <exec+0x86>
    goto bad;
80100b9f:	e9 97 03 00 00       	jmp    80100f3b <exec+0x41d>
  if(elf.magic != ELF_MAGIC)
80100ba4:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
80100baa:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100baf:	74 05                	je     80100bb6 <exec+0x98>
    goto bad;
80100bb1:	e9 85 03 00 00       	jmp    80100f3b <exec+0x41d>

  if((pgdir = setupkvm()) == 0)
80100bb6:	e8 96 70 00 00       	call   80107c51 <setupkvm>
80100bbb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100bbe:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100bc2:	75 05                	jne    80100bc9 <exec+0xab>
    goto bad;
80100bc4:	e9 72 03 00 00       	jmp    80100f3b <exec+0x41d>

  // Load program into memory.
  sz = 0;
80100bc9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bd0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100bd7:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
80100bdd:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100be0:	e9 fc 00 00 00       	jmp    80100ce1 <exec+0x1c3>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100be5:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100be8:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100bef:	00 
80100bf0:	89 44 24 08          	mov    %eax,0x8(%esp)
80100bf4:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
80100bfa:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bfe:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100c01:	89 04 24             	mov    %eax,(%esp)
80100c04:	e8 f1 11 00 00       	call   80101dfa <readi>
80100c09:	83 f8 20             	cmp    $0x20,%eax
80100c0c:	74 05                	je     80100c13 <exec+0xf5>
      goto bad;
80100c0e:	e9 28 03 00 00       	jmp    80100f3b <exec+0x41d>
    if(ph.type != ELF_PROG_LOAD)
80100c13:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
80100c19:	83 f8 01             	cmp    $0x1,%eax
80100c1c:	74 05                	je     80100c23 <exec+0x105>
      continue;
80100c1e:	e9 b1 00 00 00       	jmp    80100cd4 <exec+0x1b6>
    if(ph.memsz < ph.filesz)
80100c23:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100c29:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
80100c2f:	39 c2                	cmp    %eax,%edx
80100c31:	73 05                	jae    80100c38 <exec+0x11a>
      goto bad;
80100c33:	e9 03 03 00 00       	jmp    80100f3b <exec+0x41d>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100c38:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100c3e:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100c44:	01 c2                	add    %eax,%edx
80100c46:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c4c:	39 c2                	cmp    %eax,%edx
80100c4e:	73 05                	jae    80100c55 <exec+0x137>
      goto bad;
80100c50:	e9 e6 02 00 00       	jmp    80100f3b <exec+0x41d>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100c55:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100c5b:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100c61:	01 d0                	add    %edx,%eax
80100c63:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c67:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c6a:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c6e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c71:	89 04 24             	mov    %eax,(%esp)
80100c74:	e8 ae 73 00 00       	call   80108027 <allocuvm>
80100c79:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100c7c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100c80:	75 05                	jne    80100c87 <exec+0x169>
      goto bad;
80100c82:	e9 b4 02 00 00       	jmp    80100f3b <exec+0x41d>
    if(ph.vaddr % PGSIZE != 0)
80100c87:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c8d:	25 ff 0f 00 00       	and    $0xfff,%eax
80100c92:	85 c0                	test   %eax,%eax
80100c94:	74 05                	je     80100c9b <exec+0x17d>
      goto bad;
80100c96:	e9 a0 02 00 00       	jmp    80100f3b <exec+0x41d>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c9b:	8b 8d f8 fe ff ff    	mov    -0x108(%ebp),%ecx
80100ca1:	8b 95 ec fe ff ff    	mov    -0x114(%ebp),%edx
80100ca7:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100cad:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80100cb1:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100cb5:	8b 55 d8             	mov    -0x28(%ebp),%edx
80100cb8:	89 54 24 08          	mov    %edx,0x8(%esp)
80100cbc:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cc0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100cc3:	89 04 24             	mov    %eax,(%esp)
80100cc6:	e8 79 72 00 00       	call   80107f44 <loaduvm>
80100ccb:	85 c0                	test   %eax,%eax
80100ccd:	79 05                	jns    80100cd4 <exec+0x1b6>
      goto bad;
80100ccf:	e9 67 02 00 00       	jmp    80100f3b <exec+0x41d>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100cd4:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100cd8:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100cdb:	83 c0 20             	add    $0x20,%eax
80100cde:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100ce1:	0f b7 85 34 ff ff ff 	movzwl -0xcc(%ebp),%eax
80100ce8:	0f b7 c0             	movzwl %ax,%eax
80100ceb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100cee:	0f 8f f1 fe ff ff    	jg     80100be5 <exec+0xc7>
  }
  iunlockput(ip);
80100cf4:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100cf7:	89 04 24             	mov    %eax,(%esp)
80100cfa:	e8 60 0e 00 00       	call   80101b5f <iunlockput>
  end_op();
80100cff:	e8 07 28 00 00       	call   8010350b <end_op>
  ip = 0;
80100d04:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100d0b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d0e:	05 ff 0f 00 00       	add    $0xfff,%eax
80100d13:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100d18:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d1b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d1e:	05 00 20 00 00       	add    $0x2000,%eax
80100d23:	89 44 24 08          	mov    %eax,0x8(%esp)
80100d27:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d2a:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d2e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100d31:	89 04 24             	mov    %eax,(%esp)
80100d34:	e8 ee 72 00 00       	call   80108027 <allocuvm>
80100d39:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d3c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d40:	75 05                	jne    80100d47 <exec+0x229>
    goto bad;
80100d42:	e9 f4 01 00 00       	jmp    80100f3b <exec+0x41d>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d47:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d4a:	2d 00 20 00 00       	sub    $0x2000,%eax
80100d4f:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d53:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100d56:	89 04 24             	mov    %eax,(%esp)
80100d59:	e8 3c 75 00 00       	call   8010829a <clearpteu>
  sp = sz;
80100d5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d61:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d64:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100d6b:	e9 9a 00 00 00       	jmp    80100e0a <exec+0x2ec>
    if(argc >= MAXARG)
80100d70:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100d74:	76 05                	jbe    80100d7b <exec+0x25d>
      goto bad;
80100d76:	e9 c0 01 00 00       	jmp    80100f3b <exec+0x41d>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d7e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d85:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d88:	01 d0                	add    %edx,%eax
80100d8a:	8b 00                	mov    (%eax),%eax
80100d8c:	89 04 24             	mov    %eax,(%esp)
80100d8f:	e8 95 47 00 00       	call   80105529 <strlen>
80100d94:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100d97:	29 c2                	sub    %eax,%edx
80100d99:	89 d0                	mov    %edx,%eax
80100d9b:	83 e8 01             	sub    $0x1,%eax
80100d9e:	83 e0 fc             	and    $0xfffffffc,%eax
80100da1:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100da4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100da7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100dae:	8b 45 0c             	mov    0xc(%ebp),%eax
80100db1:	01 d0                	add    %edx,%eax
80100db3:	8b 00                	mov    (%eax),%eax
80100db5:	89 04 24             	mov    %eax,(%esp)
80100db8:	e8 6c 47 00 00       	call   80105529 <strlen>
80100dbd:	83 c0 01             	add    $0x1,%eax
80100dc0:	89 c2                	mov    %eax,%edx
80100dc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dc5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
80100dcc:	8b 45 0c             	mov    0xc(%ebp),%eax
80100dcf:	01 c8                	add    %ecx,%eax
80100dd1:	8b 00                	mov    (%eax),%eax
80100dd3:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100dd7:	89 44 24 08          	mov    %eax,0x8(%esp)
80100ddb:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100dde:	89 44 24 04          	mov    %eax,0x4(%esp)
80100de2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100de5:	89 04 24             	mov    %eax,(%esp)
80100de8:	e8 70 76 00 00       	call   8010845d <copyout>
80100ded:	85 c0                	test   %eax,%eax
80100def:	79 05                	jns    80100df6 <exec+0x2d8>
      goto bad;
80100df1:	e9 45 01 00 00       	jmp    80100f3b <exec+0x41d>
    ustack[3+argc] = sp;
80100df6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100df9:	8d 50 03             	lea    0x3(%eax),%edx
80100dfc:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100dff:	89 84 95 3c ff ff ff 	mov    %eax,-0xc4(%ebp,%edx,4)
  for(argc = 0; argv[argc]; argc++) {
80100e06:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100e0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e0d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e14:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e17:	01 d0                	add    %edx,%eax
80100e19:	8b 00                	mov    (%eax),%eax
80100e1b:	85 c0                	test   %eax,%eax
80100e1d:	0f 85 4d ff ff ff    	jne    80100d70 <exec+0x252>
  }
  ustack[3+argc] = 0;
80100e23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e26:	83 c0 03             	add    $0x3,%eax
80100e29:	c7 84 85 3c ff ff ff 	movl   $0x0,-0xc4(%ebp,%eax,4)
80100e30:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100e34:	c7 85 3c ff ff ff ff 	movl   $0xffffffff,-0xc4(%ebp)
80100e3b:	ff ff ff 
  ustack[1] = argc;
80100e3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e41:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e4a:	83 c0 01             	add    $0x1,%eax
80100e4d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e54:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e57:	29 d0                	sub    %edx,%eax
80100e59:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

  sp -= (3+argc+1) * 4;
80100e5f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e62:	83 c0 04             	add    $0x4,%eax
80100e65:	c1 e0 02             	shl    $0x2,%eax
80100e68:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e6b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e6e:	83 c0 04             	add    $0x4,%eax
80100e71:	c1 e0 02             	shl    $0x2,%eax
80100e74:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100e78:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
80100e7e:	89 44 24 08          	mov    %eax,0x8(%esp)
80100e82:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e85:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e89:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100e8c:	89 04 24             	mov    %eax,(%esp)
80100e8f:	e8 c9 75 00 00       	call   8010845d <copyout>
80100e94:	85 c0                	test   %eax,%eax
80100e96:	79 05                	jns    80100e9d <exec+0x37f>
    goto bad;
80100e98:	e9 9e 00 00 00       	jmp    80100f3b <exec+0x41d>

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e9d:	8b 45 08             	mov    0x8(%ebp),%eax
80100ea0:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100ea3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ea6:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100ea9:	eb 17                	jmp    80100ec2 <exec+0x3a4>
    if(*s == '/')
80100eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100eae:	0f b6 00             	movzbl (%eax),%eax
80100eb1:	3c 2f                	cmp    $0x2f,%al
80100eb3:	75 09                	jne    80100ebe <exec+0x3a0>
      last = s+1;
80100eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100eb8:	83 c0 01             	add    $0x1,%eax
80100ebb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(last=s=path; *s; s++)
80100ebe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100ec2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ec5:	0f b6 00             	movzbl (%eax),%eax
80100ec8:	84 c0                	test   %al,%al
80100eca:	75 df                	jne    80100eab <exec+0x38d>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100ecc:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100ecf:	8d 50 6c             	lea    0x6c(%eax),%edx
80100ed2:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100ed9:	00 
80100eda:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100edd:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ee1:	89 14 24             	mov    %edx,(%esp)
80100ee4:	e8 f6 45 00 00       	call   801054df <safestrcpy>

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100ee9:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100eec:	8b 40 04             	mov    0x4(%eax),%eax
80100eef:	89 45 cc             	mov    %eax,-0x34(%ebp)
  curproc->pgdir = pgdir;
80100ef2:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100ef5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100ef8:	89 50 04             	mov    %edx,0x4(%eax)
  curproc->sz = sz;
80100efb:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100efe:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100f01:	89 10                	mov    %edx,(%eax)
  curproc->tf->eip = elf.entry;  // main
80100f03:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f06:	8b 40 18             	mov    0x18(%eax),%eax
80100f09:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
80100f0f:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100f12:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f15:	8b 40 18             	mov    0x18(%eax),%eax
80100f18:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100f1b:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(curproc);
80100f1e:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100f21:	89 04 24             	mov    %eax,(%esp)
80100f24:	e8 02 6e 00 00       	call   80107d2b <switchuvm>
  freevm(oldpgdir);
80100f29:	8b 45 cc             	mov    -0x34(%ebp),%eax
80100f2c:	89 04 24             	mov    %eax,(%esp)
80100f2f:	e8 cf 72 00 00       	call   80108203 <freevm>
  return 0;
80100f34:	b8 00 00 00 00       	mov    $0x0,%eax
80100f39:	eb 2c                	jmp    80100f67 <exec+0x449>

 bad:
  if(pgdir)
80100f3b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100f3f:	74 0b                	je     80100f4c <exec+0x42e>
    freevm(pgdir);
80100f41:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100f44:	89 04 24             	mov    %eax,(%esp)
80100f47:	e8 b7 72 00 00       	call   80108203 <freevm>
  if(ip){
80100f4c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100f50:	74 10                	je     80100f62 <exec+0x444>
    iunlockput(ip);
80100f52:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100f55:	89 04 24             	mov    %eax,(%esp)
80100f58:	e8 02 0c 00 00       	call   80101b5f <iunlockput>
    end_op();
80100f5d:	e8 a9 25 00 00       	call   8010350b <end_op>
  }
  return -1;
80100f62:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f67:	c9                   	leave  
80100f68:	c3                   	ret    

80100f69 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f69:	55                   	push   %ebp
80100f6a:	89 e5                	mov    %esp,%ebp
80100f6c:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100f6f:	c7 44 24 04 86 85 10 	movl   $0x80108586,0x4(%esp)
80100f76:	80 
80100f77:	c7 04 24 80 10 11 80 	movl   $0x80111080,(%esp)
80100f7e:	e8 a9 40 00 00       	call   8010502c <initlock>
}
80100f83:	c9                   	leave  
80100f84:	c3                   	ret    

80100f85 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f85:	55                   	push   %ebp
80100f86:	89 e5                	mov    %esp,%ebp
80100f88:	83 ec 28             	sub    $0x28,%esp
  struct file *f;

  acquire(&ftable.lock);
80100f8b:	c7 04 24 80 10 11 80 	movl   $0x80111080,(%esp)
80100f92:	e8 b6 40 00 00       	call   8010504d <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f97:	c7 45 f4 b4 10 11 80 	movl   $0x801110b4,-0xc(%ebp)
80100f9e:	eb 29                	jmp    80100fc9 <filealloc+0x44>
    if(f->ref == 0){
80100fa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fa3:	8b 40 04             	mov    0x4(%eax),%eax
80100fa6:	85 c0                	test   %eax,%eax
80100fa8:	75 1b                	jne    80100fc5 <filealloc+0x40>
      f->ref = 1;
80100faa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fad:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100fb4:	c7 04 24 80 10 11 80 	movl   $0x80111080,(%esp)
80100fbb:	e8 f5 40 00 00       	call   801050b5 <release>
      return f;
80100fc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fc3:	eb 1e                	jmp    80100fe3 <filealloc+0x5e>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100fc5:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100fc9:	81 7d f4 14 1a 11 80 	cmpl   $0x80111a14,-0xc(%ebp)
80100fd0:	72 ce                	jb     80100fa0 <filealloc+0x1b>
    }
  }
  release(&ftable.lock);
80100fd2:	c7 04 24 80 10 11 80 	movl   $0x80111080,(%esp)
80100fd9:	e8 d7 40 00 00       	call   801050b5 <release>
  return 0;
80100fde:	b8 00 00 00 00       	mov    $0x0,%eax
}
80100fe3:	c9                   	leave  
80100fe4:	c3                   	ret    

80100fe5 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100fe5:	55                   	push   %ebp
80100fe6:	89 e5                	mov    %esp,%ebp
80100fe8:	83 ec 18             	sub    $0x18,%esp
  acquire(&ftable.lock);
80100feb:	c7 04 24 80 10 11 80 	movl   $0x80111080,(%esp)
80100ff2:	e8 56 40 00 00       	call   8010504d <acquire>
  if(f->ref < 1)
80100ff7:	8b 45 08             	mov    0x8(%ebp),%eax
80100ffa:	8b 40 04             	mov    0x4(%eax),%eax
80100ffd:	85 c0                	test   %eax,%eax
80100fff:	7f 0c                	jg     8010100d <filedup+0x28>
    panic("filedup");
80101001:	c7 04 24 8d 85 10 80 	movl   $0x8010858d,(%esp)
80101008:	e8 55 f5 ff ff       	call   80100562 <panic>
  f->ref++;
8010100d:	8b 45 08             	mov    0x8(%ebp),%eax
80101010:	8b 40 04             	mov    0x4(%eax),%eax
80101013:	8d 50 01             	lea    0x1(%eax),%edx
80101016:	8b 45 08             	mov    0x8(%ebp),%eax
80101019:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
8010101c:	c7 04 24 80 10 11 80 	movl   $0x80111080,(%esp)
80101023:	e8 8d 40 00 00       	call   801050b5 <release>
  return f;
80101028:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010102b:	c9                   	leave  
8010102c:	c3                   	ret    

8010102d <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
8010102d:	55                   	push   %ebp
8010102e:	89 e5                	mov    %esp,%ebp
80101030:	83 ec 38             	sub    $0x38,%esp
  struct file ff;

  acquire(&ftable.lock);
80101033:	c7 04 24 80 10 11 80 	movl   $0x80111080,(%esp)
8010103a:	e8 0e 40 00 00       	call   8010504d <acquire>
  if(f->ref < 1)
8010103f:	8b 45 08             	mov    0x8(%ebp),%eax
80101042:	8b 40 04             	mov    0x4(%eax),%eax
80101045:	85 c0                	test   %eax,%eax
80101047:	7f 0c                	jg     80101055 <fileclose+0x28>
    panic("fileclose");
80101049:	c7 04 24 95 85 10 80 	movl   $0x80108595,(%esp)
80101050:	e8 0d f5 ff ff       	call   80100562 <panic>
  if(--f->ref > 0){
80101055:	8b 45 08             	mov    0x8(%ebp),%eax
80101058:	8b 40 04             	mov    0x4(%eax),%eax
8010105b:	8d 50 ff             	lea    -0x1(%eax),%edx
8010105e:	8b 45 08             	mov    0x8(%ebp),%eax
80101061:	89 50 04             	mov    %edx,0x4(%eax)
80101064:	8b 45 08             	mov    0x8(%ebp),%eax
80101067:	8b 40 04             	mov    0x4(%eax),%eax
8010106a:	85 c0                	test   %eax,%eax
8010106c:	7e 11                	jle    8010107f <fileclose+0x52>
    release(&ftable.lock);
8010106e:	c7 04 24 80 10 11 80 	movl   $0x80111080,(%esp)
80101075:	e8 3b 40 00 00       	call   801050b5 <release>
8010107a:	e9 82 00 00 00       	jmp    80101101 <fileclose+0xd4>
    return;
  }
  ff = *f;
8010107f:	8b 45 08             	mov    0x8(%ebp),%eax
80101082:	8b 10                	mov    (%eax),%edx
80101084:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101087:	8b 50 04             	mov    0x4(%eax),%edx
8010108a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010108d:	8b 50 08             	mov    0x8(%eax),%edx
80101090:	89 55 e8             	mov    %edx,-0x18(%ebp)
80101093:	8b 50 0c             	mov    0xc(%eax),%edx
80101096:	89 55 ec             	mov    %edx,-0x14(%ebp)
80101099:	8b 50 10             	mov    0x10(%eax),%edx
8010109c:	89 55 f0             	mov    %edx,-0x10(%ebp)
8010109f:	8b 40 14             	mov    0x14(%eax),%eax
801010a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
801010a5:	8b 45 08             	mov    0x8(%ebp),%eax
801010a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
801010af:	8b 45 08             	mov    0x8(%ebp),%eax
801010b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
801010b8:	c7 04 24 80 10 11 80 	movl   $0x80111080,(%esp)
801010bf:	e8 f1 3f 00 00       	call   801050b5 <release>

  if(ff.type == FD_PIPE)
801010c4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010c7:	83 f8 01             	cmp    $0x1,%eax
801010ca:	75 18                	jne    801010e4 <fileclose+0xb7>
    pipeclose(ff.pipe, ff.writable);
801010cc:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
801010d0:	0f be d0             	movsbl %al,%edx
801010d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801010d6:	89 54 24 04          	mov    %edx,0x4(%esp)
801010da:	89 04 24             	mov    %eax,(%esp)
801010dd:	e8 46 2d 00 00       	call   80103e28 <pipeclose>
801010e2:	eb 1d                	jmp    80101101 <fileclose+0xd4>
  else if(ff.type == FD_INODE){
801010e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010e7:	83 f8 02             	cmp    $0x2,%eax
801010ea:	75 15                	jne    80101101 <fileclose+0xd4>
    begin_op();
801010ec:	e8 96 23 00 00       	call   80103487 <begin_op>
    iput(ff.ip);
801010f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801010f4:	89 04 24             	mov    %eax,(%esp)
801010f7:	e8 b2 09 00 00       	call   80101aae <iput>
    end_op();
801010fc:	e8 0a 24 00 00       	call   8010350b <end_op>
  }
}
80101101:	c9                   	leave  
80101102:	c3                   	ret    

80101103 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101103:	55                   	push   %ebp
80101104:	89 e5                	mov    %esp,%ebp
80101106:	83 ec 18             	sub    $0x18,%esp
  if(f->type == FD_INODE){
80101109:	8b 45 08             	mov    0x8(%ebp),%eax
8010110c:	8b 00                	mov    (%eax),%eax
8010110e:	83 f8 02             	cmp    $0x2,%eax
80101111:	75 38                	jne    8010114b <filestat+0x48>
    ilock(f->ip);
80101113:	8b 45 08             	mov    0x8(%ebp),%eax
80101116:	8b 40 10             	mov    0x10(%eax),%eax
80101119:	89 04 24             	mov    %eax,(%esp)
8010111c:	e8 3c 08 00 00       	call   8010195d <ilock>
    stati(f->ip, st);
80101121:	8b 45 08             	mov    0x8(%ebp),%eax
80101124:	8b 40 10             	mov    0x10(%eax),%eax
80101127:	8b 55 0c             	mov    0xc(%ebp),%edx
8010112a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010112e:	89 04 24             	mov    %eax,(%esp)
80101131:	e8 7f 0c 00 00       	call   80101db5 <stati>
    iunlock(f->ip);
80101136:	8b 45 08             	mov    0x8(%ebp),%eax
80101139:	8b 40 10             	mov    0x10(%eax),%eax
8010113c:	89 04 24             	mov    %eax,(%esp)
8010113f:	e8 26 09 00 00       	call   80101a6a <iunlock>
    return 0;
80101144:	b8 00 00 00 00       	mov    $0x0,%eax
80101149:	eb 05                	jmp    80101150 <filestat+0x4d>
  }
  return -1;
8010114b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101150:	c9                   	leave  
80101151:	c3                   	ret    

80101152 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101152:	55                   	push   %ebp
80101153:	89 e5                	mov    %esp,%ebp
80101155:	83 ec 28             	sub    $0x28,%esp
  int r;

  if(f->readable == 0)
80101158:	8b 45 08             	mov    0x8(%ebp),%eax
8010115b:	0f b6 40 08          	movzbl 0x8(%eax),%eax
8010115f:	84 c0                	test   %al,%al
80101161:	75 0a                	jne    8010116d <fileread+0x1b>
    return -1;
80101163:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101168:	e9 9f 00 00 00       	jmp    8010120c <fileread+0xba>
  if(f->type == FD_PIPE)
8010116d:	8b 45 08             	mov    0x8(%ebp),%eax
80101170:	8b 00                	mov    (%eax),%eax
80101172:	83 f8 01             	cmp    $0x1,%eax
80101175:	75 1e                	jne    80101195 <fileread+0x43>
    return piperead(f->pipe, addr, n);
80101177:	8b 45 08             	mov    0x8(%ebp),%eax
8010117a:	8b 40 0c             	mov    0xc(%eax),%eax
8010117d:	8b 55 10             	mov    0x10(%ebp),%edx
80101180:	89 54 24 08          	mov    %edx,0x8(%esp)
80101184:	8b 55 0c             	mov    0xc(%ebp),%edx
80101187:	89 54 24 04          	mov    %edx,0x4(%esp)
8010118b:	89 04 24             	mov    %eax,(%esp)
8010118e:	e8 15 2e 00 00       	call   80103fa8 <piperead>
80101193:	eb 77                	jmp    8010120c <fileread+0xba>
  if(f->type == FD_INODE){
80101195:	8b 45 08             	mov    0x8(%ebp),%eax
80101198:	8b 00                	mov    (%eax),%eax
8010119a:	83 f8 02             	cmp    $0x2,%eax
8010119d:	75 61                	jne    80101200 <fileread+0xae>
    ilock(f->ip);
8010119f:	8b 45 08             	mov    0x8(%ebp),%eax
801011a2:	8b 40 10             	mov    0x10(%eax),%eax
801011a5:	89 04 24             	mov    %eax,(%esp)
801011a8:	e8 b0 07 00 00       	call   8010195d <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801011ad:	8b 4d 10             	mov    0x10(%ebp),%ecx
801011b0:	8b 45 08             	mov    0x8(%ebp),%eax
801011b3:	8b 50 14             	mov    0x14(%eax),%edx
801011b6:	8b 45 08             	mov    0x8(%ebp),%eax
801011b9:	8b 40 10             	mov    0x10(%eax),%eax
801011bc:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801011c0:	89 54 24 08          	mov    %edx,0x8(%esp)
801011c4:	8b 55 0c             	mov    0xc(%ebp),%edx
801011c7:	89 54 24 04          	mov    %edx,0x4(%esp)
801011cb:	89 04 24             	mov    %eax,(%esp)
801011ce:	e8 27 0c 00 00       	call   80101dfa <readi>
801011d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801011d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801011da:	7e 11                	jle    801011ed <fileread+0x9b>
      f->off += r;
801011dc:	8b 45 08             	mov    0x8(%ebp),%eax
801011df:	8b 50 14             	mov    0x14(%eax),%edx
801011e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011e5:	01 c2                	add    %eax,%edx
801011e7:	8b 45 08             	mov    0x8(%ebp),%eax
801011ea:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
801011ed:	8b 45 08             	mov    0x8(%ebp),%eax
801011f0:	8b 40 10             	mov    0x10(%eax),%eax
801011f3:	89 04 24             	mov    %eax,(%esp)
801011f6:	e8 6f 08 00 00       	call   80101a6a <iunlock>
    return r;
801011fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011fe:	eb 0c                	jmp    8010120c <fileread+0xba>
  }
  panic("fileread");
80101200:	c7 04 24 9f 85 10 80 	movl   $0x8010859f,(%esp)
80101207:	e8 56 f3 ff ff       	call   80100562 <panic>
}
8010120c:	c9                   	leave  
8010120d:	c3                   	ret    

8010120e <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
8010120e:	55                   	push   %ebp
8010120f:	89 e5                	mov    %esp,%ebp
80101211:	53                   	push   %ebx
80101212:	83 ec 24             	sub    $0x24,%esp
  int r;

  if(f->writable == 0)
80101215:	8b 45 08             	mov    0x8(%ebp),%eax
80101218:	0f b6 40 09          	movzbl 0x9(%eax),%eax
8010121c:	84 c0                	test   %al,%al
8010121e:	75 0a                	jne    8010122a <filewrite+0x1c>
    return -1;
80101220:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101225:	e9 20 01 00 00       	jmp    8010134a <filewrite+0x13c>
  if(f->type == FD_PIPE)
8010122a:	8b 45 08             	mov    0x8(%ebp),%eax
8010122d:	8b 00                	mov    (%eax),%eax
8010122f:	83 f8 01             	cmp    $0x1,%eax
80101232:	75 21                	jne    80101255 <filewrite+0x47>
    return pipewrite(f->pipe, addr, n);
80101234:	8b 45 08             	mov    0x8(%ebp),%eax
80101237:	8b 40 0c             	mov    0xc(%eax),%eax
8010123a:	8b 55 10             	mov    0x10(%ebp),%edx
8010123d:	89 54 24 08          	mov    %edx,0x8(%esp)
80101241:	8b 55 0c             	mov    0xc(%ebp),%edx
80101244:	89 54 24 04          	mov    %edx,0x4(%esp)
80101248:	89 04 24             	mov    %eax,(%esp)
8010124b:	e8 6a 2c 00 00       	call   80103eba <pipewrite>
80101250:	e9 f5 00 00 00       	jmp    8010134a <filewrite+0x13c>
  if(f->type == FD_INODE){
80101255:	8b 45 08             	mov    0x8(%ebp),%eax
80101258:	8b 00                	mov    (%eax),%eax
8010125a:	83 f8 02             	cmp    $0x2,%eax
8010125d:	0f 85 db 00 00 00    	jne    8010133e <filewrite+0x130>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
80101263:	c7 45 ec 00 06 00 00 	movl   $0x600,-0x14(%ebp)
    int i = 0;
8010126a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
80101271:	e9 a8 00 00 00       	jmp    8010131e <filewrite+0x110>
      int n1 = n - i;
80101276:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101279:	8b 55 10             	mov    0x10(%ebp),%edx
8010127c:	29 c2                	sub    %eax,%edx
8010127e:	89 d0                	mov    %edx,%eax
80101280:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
80101283:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101286:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101289:	7e 06                	jle    80101291 <filewrite+0x83>
        n1 = max;
8010128b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010128e:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
80101291:	e8 f1 21 00 00       	call   80103487 <begin_op>
      ilock(f->ip);
80101296:	8b 45 08             	mov    0x8(%ebp),%eax
80101299:	8b 40 10             	mov    0x10(%eax),%eax
8010129c:	89 04 24             	mov    %eax,(%esp)
8010129f:	e8 b9 06 00 00       	call   8010195d <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801012a4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801012a7:	8b 45 08             	mov    0x8(%ebp),%eax
801012aa:	8b 50 14             	mov    0x14(%eax),%edx
801012ad:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801012b0:	8b 45 0c             	mov    0xc(%ebp),%eax
801012b3:	01 c3                	add    %eax,%ebx
801012b5:	8b 45 08             	mov    0x8(%ebp),%eax
801012b8:	8b 40 10             	mov    0x10(%eax),%eax
801012bb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801012bf:	89 54 24 08          	mov    %edx,0x8(%esp)
801012c3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801012c7:	89 04 24             	mov    %eax,(%esp)
801012ca:	e8 8f 0c 00 00       	call   80101f5e <writei>
801012cf:	89 45 e8             	mov    %eax,-0x18(%ebp)
801012d2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801012d6:	7e 11                	jle    801012e9 <filewrite+0xdb>
        f->off += r;
801012d8:	8b 45 08             	mov    0x8(%ebp),%eax
801012db:	8b 50 14             	mov    0x14(%eax),%edx
801012de:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012e1:	01 c2                	add    %eax,%edx
801012e3:	8b 45 08             	mov    0x8(%ebp),%eax
801012e6:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
801012e9:	8b 45 08             	mov    0x8(%ebp),%eax
801012ec:	8b 40 10             	mov    0x10(%eax),%eax
801012ef:	89 04 24             	mov    %eax,(%esp)
801012f2:	e8 73 07 00 00       	call   80101a6a <iunlock>
      end_op();
801012f7:	e8 0f 22 00 00       	call   8010350b <end_op>

      if(r < 0)
801012fc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101300:	79 02                	jns    80101304 <filewrite+0xf6>
        break;
80101302:	eb 26                	jmp    8010132a <filewrite+0x11c>
      if(r != n1)
80101304:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101307:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010130a:	74 0c                	je     80101318 <filewrite+0x10a>
        panic("short filewrite");
8010130c:	c7 04 24 a8 85 10 80 	movl   $0x801085a8,(%esp)
80101313:	e8 4a f2 ff ff       	call   80100562 <panic>
      i += r;
80101318:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010131b:	01 45 f4             	add    %eax,-0xc(%ebp)
    while(i < n){
8010131e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101321:	3b 45 10             	cmp    0x10(%ebp),%eax
80101324:	0f 8c 4c ff ff ff    	jl     80101276 <filewrite+0x68>
    }
    return i == n ? n : -1;
8010132a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010132d:	3b 45 10             	cmp    0x10(%ebp),%eax
80101330:	75 05                	jne    80101337 <filewrite+0x129>
80101332:	8b 45 10             	mov    0x10(%ebp),%eax
80101335:	eb 05                	jmp    8010133c <filewrite+0x12e>
80101337:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010133c:	eb 0c                	jmp    8010134a <filewrite+0x13c>
  }
  panic("filewrite");
8010133e:	c7 04 24 b8 85 10 80 	movl   $0x801085b8,(%esp)
80101345:	e8 18 f2 ff ff       	call   80100562 <panic>
}
8010134a:	83 c4 24             	add    $0x24,%esp
8010134d:	5b                   	pop    %ebx
8010134e:	5d                   	pop    %ebp
8010134f:	c3                   	ret    

80101350 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
80101350:	55                   	push   %ebp
80101351:	89 e5                	mov    %esp,%ebp
80101353:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;

  bp = bread(dev, 1);
80101356:	8b 45 08             	mov    0x8(%ebp),%eax
80101359:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80101360:	00 
80101361:	89 04 24             	mov    %eax,(%esp)
80101364:	e8 4c ee ff ff       	call   801001b5 <bread>
80101369:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
8010136c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010136f:	83 c0 5c             	add    $0x5c,%eax
80101372:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
80101379:	00 
8010137a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010137e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101381:	89 04 24             	mov    %eax,(%esp)
80101384:	e8 05 40 00 00       	call   8010538e <memmove>
  brelse(bp);
80101389:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010138c:	89 04 24             	mov    %eax,(%esp)
8010138f:	e8 98 ee ff ff       	call   8010022c <brelse>
}
80101394:	c9                   	leave  
80101395:	c3                   	ret    

80101396 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
80101396:	55                   	push   %ebp
80101397:	89 e5                	mov    %esp,%ebp
80101399:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;

  bp = bread(dev, bno);
8010139c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010139f:	8b 45 08             	mov    0x8(%ebp),%eax
801013a2:	89 54 24 04          	mov    %edx,0x4(%esp)
801013a6:	89 04 24             	mov    %eax,(%esp)
801013a9:	e8 07 ee ff ff       	call   801001b5 <bread>
801013ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
801013b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013b4:	83 c0 5c             	add    $0x5c,%eax
801013b7:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801013be:	00 
801013bf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801013c6:	00 
801013c7:	89 04 24             	mov    %eax,(%esp)
801013ca:	e8 f0 3e 00 00       	call   801052bf <memset>
  log_write(bp);
801013cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013d2:	89 04 24             	mov    %eax,(%esp)
801013d5:	e8 b8 22 00 00       	call   80103692 <log_write>
  brelse(bp);
801013da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013dd:	89 04 24             	mov    %eax,(%esp)
801013e0:	e8 47 ee ff ff       	call   8010022c <brelse>
}
801013e5:	c9                   	leave  
801013e6:	c3                   	ret    

801013e7 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801013e7:	55                   	push   %ebp
801013e8:	89 e5                	mov    %esp,%ebp
801013ea:	83 ec 28             	sub    $0x28,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
801013ed:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801013f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801013fb:	e9 07 01 00 00       	jmp    80101507 <balloc+0x120>
    bp = bread(dev, BBLOCK(b, sb));
80101400:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101403:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80101409:	85 c0                	test   %eax,%eax
8010140b:	0f 48 c2             	cmovs  %edx,%eax
8010140e:	c1 f8 0c             	sar    $0xc,%eax
80101411:	89 c2                	mov    %eax,%edx
80101413:	a1 98 1a 11 80       	mov    0x80111a98,%eax
80101418:	01 d0                	add    %edx,%eax
8010141a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010141e:	8b 45 08             	mov    0x8(%ebp),%eax
80101421:	89 04 24             	mov    %eax,(%esp)
80101424:	e8 8c ed ff ff       	call   801001b5 <bread>
80101429:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010142c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101433:	e9 9d 00 00 00       	jmp    801014d5 <balloc+0xee>
      m = 1 << (bi % 8);
80101438:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010143b:	99                   	cltd   
8010143c:	c1 ea 1d             	shr    $0x1d,%edx
8010143f:	01 d0                	add    %edx,%eax
80101441:	83 e0 07             	and    $0x7,%eax
80101444:	29 d0                	sub    %edx,%eax
80101446:	ba 01 00 00 00       	mov    $0x1,%edx
8010144b:	89 c1                	mov    %eax,%ecx
8010144d:	d3 e2                	shl    %cl,%edx
8010144f:	89 d0                	mov    %edx,%eax
80101451:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101454:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101457:	8d 50 07             	lea    0x7(%eax),%edx
8010145a:	85 c0                	test   %eax,%eax
8010145c:	0f 48 c2             	cmovs  %edx,%eax
8010145f:	c1 f8 03             	sar    $0x3,%eax
80101462:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101465:	0f b6 44 02 5c       	movzbl 0x5c(%edx,%eax,1),%eax
8010146a:	0f b6 c0             	movzbl %al,%eax
8010146d:	23 45 e8             	and    -0x18(%ebp),%eax
80101470:	85 c0                	test   %eax,%eax
80101472:	75 5d                	jne    801014d1 <balloc+0xea>
        bp->data[bi/8] |= m;  // Mark block in use.
80101474:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101477:	8d 50 07             	lea    0x7(%eax),%edx
8010147a:	85 c0                	test   %eax,%eax
8010147c:	0f 48 c2             	cmovs  %edx,%eax
8010147f:	c1 f8 03             	sar    $0x3,%eax
80101482:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101485:	0f b6 54 02 5c       	movzbl 0x5c(%edx,%eax,1),%edx
8010148a:	89 d1                	mov    %edx,%ecx
8010148c:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010148f:	09 ca                	or     %ecx,%edx
80101491:	89 d1                	mov    %edx,%ecx
80101493:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101496:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
        log_write(bp);
8010149a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010149d:	89 04 24             	mov    %eax,(%esp)
801014a0:	e8 ed 21 00 00       	call   80103692 <log_write>
        brelse(bp);
801014a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014a8:	89 04 24             	mov    %eax,(%esp)
801014ab:	e8 7c ed ff ff       	call   8010022c <brelse>
        bzero(dev, b + bi);
801014b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014b6:	01 c2                	add    %eax,%edx
801014b8:	8b 45 08             	mov    0x8(%ebp),%eax
801014bb:	89 54 24 04          	mov    %edx,0x4(%esp)
801014bf:	89 04 24             	mov    %eax,(%esp)
801014c2:	e8 cf fe ff ff       	call   80101396 <bzero>
        return b + bi;
801014c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014cd:	01 d0                	add    %edx,%eax
801014cf:	eb 52                	jmp    80101523 <balloc+0x13c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801014d1:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801014d5:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
801014dc:	7f 17                	jg     801014f5 <balloc+0x10e>
801014de:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014e4:	01 d0                	add    %edx,%eax
801014e6:	89 c2                	mov    %eax,%edx
801014e8:	a1 80 1a 11 80       	mov    0x80111a80,%eax
801014ed:	39 c2                	cmp    %eax,%edx
801014ef:	0f 82 43 ff ff ff    	jb     80101438 <balloc+0x51>
      }
    }
    brelse(bp);
801014f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014f8:	89 04 24             	mov    %eax,(%esp)
801014fb:	e8 2c ed ff ff       	call   8010022c <brelse>
  for(b = 0; b < sb.size; b += BPB){
80101500:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80101507:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010150a:	a1 80 1a 11 80       	mov    0x80111a80,%eax
8010150f:	39 c2                	cmp    %eax,%edx
80101511:	0f 82 e9 fe ff ff    	jb     80101400 <balloc+0x19>
  }
  panic("balloc: out of blocks");
80101517:	c7 04 24 c4 85 10 80 	movl   $0x801085c4,(%esp)
8010151e:	e8 3f f0 ff ff       	call   80100562 <panic>
}
80101523:	c9                   	leave  
80101524:	c3                   	ret    

80101525 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101525:	55                   	push   %ebp
80101526:	89 e5                	mov    %esp,%ebp
80101528:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
8010152b:	c7 44 24 04 80 1a 11 	movl   $0x80111a80,0x4(%esp)
80101532:	80 
80101533:	8b 45 08             	mov    0x8(%ebp),%eax
80101536:	89 04 24             	mov    %eax,(%esp)
80101539:	e8 12 fe ff ff       	call   80101350 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
8010153e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101541:	c1 e8 0c             	shr    $0xc,%eax
80101544:	89 c2                	mov    %eax,%edx
80101546:	a1 98 1a 11 80       	mov    0x80111a98,%eax
8010154b:	01 c2                	add    %eax,%edx
8010154d:	8b 45 08             	mov    0x8(%ebp),%eax
80101550:	89 54 24 04          	mov    %edx,0x4(%esp)
80101554:	89 04 24             	mov    %eax,(%esp)
80101557:	e8 59 ec ff ff       	call   801001b5 <bread>
8010155c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
8010155f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101562:	25 ff 0f 00 00       	and    $0xfff,%eax
80101567:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
8010156a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010156d:	99                   	cltd   
8010156e:	c1 ea 1d             	shr    $0x1d,%edx
80101571:	01 d0                	add    %edx,%eax
80101573:	83 e0 07             	and    $0x7,%eax
80101576:	29 d0                	sub    %edx,%eax
80101578:	ba 01 00 00 00       	mov    $0x1,%edx
8010157d:	89 c1                	mov    %eax,%ecx
8010157f:	d3 e2                	shl    %cl,%edx
80101581:	89 d0                	mov    %edx,%eax
80101583:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101586:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101589:	8d 50 07             	lea    0x7(%eax),%edx
8010158c:	85 c0                	test   %eax,%eax
8010158e:	0f 48 c2             	cmovs  %edx,%eax
80101591:	c1 f8 03             	sar    $0x3,%eax
80101594:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101597:	0f b6 44 02 5c       	movzbl 0x5c(%edx,%eax,1),%eax
8010159c:	0f b6 c0             	movzbl %al,%eax
8010159f:	23 45 ec             	and    -0x14(%ebp),%eax
801015a2:	85 c0                	test   %eax,%eax
801015a4:	75 0c                	jne    801015b2 <bfree+0x8d>
    panic("freeing free block");
801015a6:	c7 04 24 da 85 10 80 	movl   $0x801085da,(%esp)
801015ad:	e8 b0 ef ff ff       	call   80100562 <panic>
  bp->data[bi/8] &= ~m;
801015b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015b5:	8d 50 07             	lea    0x7(%eax),%edx
801015b8:	85 c0                	test   %eax,%eax
801015ba:	0f 48 c2             	cmovs  %edx,%eax
801015bd:	c1 f8 03             	sar    $0x3,%eax
801015c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015c3:	0f b6 54 02 5c       	movzbl 0x5c(%edx,%eax,1),%edx
801015c8:	8b 4d ec             	mov    -0x14(%ebp),%ecx
801015cb:	f7 d1                	not    %ecx
801015cd:	21 ca                	and    %ecx,%edx
801015cf:	89 d1                	mov    %edx,%ecx
801015d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015d4:	88 4c 02 5c          	mov    %cl,0x5c(%edx,%eax,1)
  log_write(bp);
801015d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015db:	89 04 24             	mov    %eax,(%esp)
801015de:	e8 af 20 00 00       	call   80103692 <log_write>
  brelse(bp);
801015e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015e6:	89 04 24             	mov    %eax,(%esp)
801015e9:	e8 3e ec ff ff       	call   8010022c <brelse>
}
801015ee:	c9                   	leave  
801015ef:	c3                   	ret    

801015f0 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
801015f0:	55                   	push   %ebp
801015f1:	89 e5                	mov    %esp,%ebp
801015f3:	57                   	push   %edi
801015f4:	56                   	push   %esi
801015f5:	53                   	push   %ebx
801015f6:	83 ec 4c             	sub    $0x4c,%esp
  int i = 0;
801015f9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  
  initlock(&icache.lock, "icache");
80101600:	c7 44 24 04 ed 85 10 	movl   $0x801085ed,0x4(%esp)
80101607:	80 
80101608:	c7 04 24 a0 1a 11 80 	movl   $0x80111aa0,(%esp)
8010160f:	e8 18 3a 00 00       	call   8010502c <initlock>
  for(i = 0; i < NINODE; i++) {
80101614:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010161b:	eb 2c                	jmp    80101649 <iinit+0x59>
    initsleeplock(&icache.inode[i].lock, "inode");
8010161d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101620:	89 d0                	mov    %edx,%eax
80101622:	c1 e0 03             	shl    $0x3,%eax
80101625:	01 d0                	add    %edx,%eax
80101627:	c1 e0 04             	shl    $0x4,%eax
8010162a:	83 c0 30             	add    $0x30,%eax
8010162d:	05 a0 1a 11 80       	add    $0x80111aa0,%eax
80101632:	83 c0 10             	add    $0x10,%eax
80101635:	c7 44 24 04 f4 85 10 	movl   $0x801085f4,0x4(%esp)
8010163c:	80 
8010163d:	89 04 24             	mov    %eax,(%esp)
80101640:	e8 84 38 00 00       	call   80104ec9 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101645:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80101649:	83 7d e4 31          	cmpl   $0x31,-0x1c(%ebp)
8010164d:	7e ce                	jle    8010161d <iinit+0x2d>
  }

  readsb(dev, &sb);
8010164f:	c7 44 24 04 80 1a 11 	movl   $0x80111a80,0x4(%esp)
80101656:	80 
80101657:	8b 45 08             	mov    0x8(%ebp),%eax
8010165a:	89 04 24             	mov    %eax,(%esp)
8010165d:	e8 ee fc ff ff       	call   80101350 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101662:	a1 98 1a 11 80       	mov    0x80111a98,%eax
80101667:	8b 3d 94 1a 11 80    	mov    0x80111a94,%edi
8010166d:	8b 35 90 1a 11 80    	mov    0x80111a90,%esi
80101673:	8b 1d 8c 1a 11 80    	mov    0x80111a8c,%ebx
80101679:	8b 0d 88 1a 11 80    	mov    0x80111a88,%ecx
8010167f:	8b 15 84 1a 11 80    	mov    0x80111a84,%edx
80101685:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80101688:	8b 15 80 1a 11 80    	mov    0x80111a80,%edx
8010168e:	89 44 24 1c          	mov    %eax,0x1c(%esp)
80101692:	89 7c 24 18          	mov    %edi,0x18(%esp)
80101696:	89 74 24 14          	mov    %esi,0x14(%esp)
8010169a:	89 5c 24 10          	mov    %ebx,0x10(%esp)
8010169e:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801016a2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801016a5:	89 44 24 08          	mov    %eax,0x8(%esp)
801016a9:	89 d0                	mov    %edx,%eax
801016ab:	89 44 24 04          	mov    %eax,0x4(%esp)
801016af:	c7 04 24 fc 85 10 80 	movl   $0x801085fc,(%esp)
801016b6:	e8 0d ed ff ff       	call   801003c8 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
801016bb:	83 c4 4c             	add    $0x4c,%esp
801016be:	5b                   	pop    %ebx
801016bf:	5e                   	pop    %esi
801016c0:	5f                   	pop    %edi
801016c1:	5d                   	pop    %ebp
801016c2:	c3                   	ret    

801016c3 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
801016c3:	55                   	push   %ebp
801016c4:	89 e5                	mov    %esp,%ebp
801016c6:	83 ec 28             	sub    $0x28,%esp
801016c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801016cc:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801016d0:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
801016d7:	e9 9e 00 00 00       	jmp    8010177a <ialloc+0xb7>
    bp = bread(dev, IBLOCK(inum, sb));
801016dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016df:	c1 e8 03             	shr    $0x3,%eax
801016e2:	89 c2                	mov    %eax,%edx
801016e4:	a1 94 1a 11 80       	mov    0x80111a94,%eax
801016e9:	01 d0                	add    %edx,%eax
801016eb:	89 44 24 04          	mov    %eax,0x4(%esp)
801016ef:	8b 45 08             	mov    0x8(%ebp),%eax
801016f2:	89 04 24             	mov    %eax,(%esp)
801016f5:	e8 bb ea ff ff       	call   801001b5 <bread>
801016fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
801016fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101700:	8d 50 5c             	lea    0x5c(%eax),%edx
80101703:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101706:	83 e0 07             	and    $0x7,%eax
80101709:	c1 e0 06             	shl    $0x6,%eax
8010170c:	01 d0                	add    %edx,%eax
8010170e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
80101711:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101714:	0f b7 00             	movzwl (%eax),%eax
80101717:	66 85 c0             	test   %ax,%ax
8010171a:	75 4f                	jne    8010176b <ialloc+0xa8>
      memset(dip, 0, sizeof(*dip));
8010171c:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
80101723:	00 
80101724:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010172b:	00 
8010172c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010172f:	89 04 24             	mov    %eax,(%esp)
80101732:	e8 88 3b 00 00       	call   801052bf <memset>
      dip->type = type;
80101737:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010173a:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
8010173e:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
80101741:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101744:	89 04 24             	mov    %eax,(%esp)
80101747:	e8 46 1f 00 00       	call   80103692 <log_write>
      brelse(bp);
8010174c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010174f:	89 04 24             	mov    %eax,(%esp)
80101752:	e8 d5 ea ff ff       	call   8010022c <brelse>
      return iget(dev, inum);
80101757:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010175a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010175e:	8b 45 08             	mov    0x8(%ebp),%eax
80101761:	89 04 24             	mov    %eax,(%esp)
80101764:	e8 ed 00 00 00       	call   80101856 <iget>
80101769:	eb 2b                	jmp    80101796 <ialloc+0xd3>
    }
    brelse(bp);
8010176b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010176e:	89 04 24             	mov    %eax,(%esp)
80101771:	e8 b6 ea ff ff       	call   8010022c <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
80101776:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010177a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010177d:	a1 88 1a 11 80       	mov    0x80111a88,%eax
80101782:	39 c2                	cmp    %eax,%edx
80101784:	0f 82 52 ff ff ff    	jb     801016dc <ialloc+0x19>
  }
  panic("ialloc: no inodes");
8010178a:	c7 04 24 4f 86 10 80 	movl   $0x8010864f,(%esp)
80101791:	e8 cc ed ff ff       	call   80100562 <panic>
}
80101796:	c9                   	leave  
80101797:	c3                   	ret    

80101798 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
80101798:	55                   	push   %ebp
80101799:	89 e5                	mov    %esp,%ebp
8010179b:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010179e:	8b 45 08             	mov    0x8(%ebp),%eax
801017a1:	8b 40 04             	mov    0x4(%eax),%eax
801017a4:	c1 e8 03             	shr    $0x3,%eax
801017a7:	89 c2                	mov    %eax,%edx
801017a9:	a1 94 1a 11 80       	mov    0x80111a94,%eax
801017ae:	01 c2                	add    %eax,%edx
801017b0:	8b 45 08             	mov    0x8(%ebp),%eax
801017b3:	8b 00                	mov    (%eax),%eax
801017b5:	89 54 24 04          	mov    %edx,0x4(%esp)
801017b9:	89 04 24             	mov    %eax,(%esp)
801017bc:	e8 f4 e9 ff ff       	call   801001b5 <bread>
801017c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801017c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017c7:	8d 50 5c             	lea    0x5c(%eax),%edx
801017ca:	8b 45 08             	mov    0x8(%ebp),%eax
801017cd:	8b 40 04             	mov    0x4(%eax),%eax
801017d0:	83 e0 07             	and    $0x7,%eax
801017d3:	c1 e0 06             	shl    $0x6,%eax
801017d6:	01 d0                	add    %edx,%eax
801017d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
801017db:	8b 45 08             	mov    0x8(%ebp),%eax
801017de:	0f b7 50 50          	movzwl 0x50(%eax),%edx
801017e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017e5:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801017e8:	8b 45 08             	mov    0x8(%ebp),%eax
801017eb:	0f b7 50 52          	movzwl 0x52(%eax),%edx
801017ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017f2:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
801017f6:	8b 45 08             	mov    0x8(%ebp),%eax
801017f9:	0f b7 50 54          	movzwl 0x54(%eax),%edx
801017fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101800:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
80101804:	8b 45 08             	mov    0x8(%ebp),%eax
80101807:	0f b7 50 56          	movzwl 0x56(%eax),%edx
8010180b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010180e:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101812:	8b 45 08             	mov    0x8(%ebp),%eax
80101815:	8b 50 58             	mov    0x58(%eax),%edx
80101818:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010181b:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010181e:	8b 45 08             	mov    0x8(%ebp),%eax
80101821:	8d 50 5c             	lea    0x5c(%eax),%edx
80101824:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101827:	83 c0 0c             	add    $0xc,%eax
8010182a:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101831:	00 
80101832:	89 54 24 04          	mov    %edx,0x4(%esp)
80101836:	89 04 24             	mov    %eax,(%esp)
80101839:	e8 50 3b 00 00       	call   8010538e <memmove>
  log_write(bp);
8010183e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101841:	89 04 24             	mov    %eax,(%esp)
80101844:	e8 49 1e 00 00       	call   80103692 <log_write>
  brelse(bp);
80101849:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010184c:	89 04 24             	mov    %eax,(%esp)
8010184f:	e8 d8 e9 ff ff       	call   8010022c <brelse>
}
80101854:	c9                   	leave  
80101855:	c3                   	ret    

80101856 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101856:	55                   	push   %ebp
80101857:	89 e5                	mov    %esp,%ebp
80101859:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
8010185c:	c7 04 24 a0 1a 11 80 	movl   $0x80111aa0,(%esp)
80101863:	e8 e5 37 00 00       	call   8010504d <acquire>

  // Is the inode already cached?
  empty = 0;
80101868:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010186f:	c7 45 f4 d4 1a 11 80 	movl   $0x80111ad4,-0xc(%ebp)
80101876:	eb 5c                	jmp    801018d4 <iget+0x7e>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101878:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010187b:	8b 40 08             	mov    0x8(%eax),%eax
8010187e:	85 c0                	test   %eax,%eax
80101880:	7e 35                	jle    801018b7 <iget+0x61>
80101882:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101885:	8b 00                	mov    (%eax),%eax
80101887:	3b 45 08             	cmp    0x8(%ebp),%eax
8010188a:	75 2b                	jne    801018b7 <iget+0x61>
8010188c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010188f:	8b 40 04             	mov    0x4(%eax),%eax
80101892:	3b 45 0c             	cmp    0xc(%ebp),%eax
80101895:	75 20                	jne    801018b7 <iget+0x61>
      ip->ref++;
80101897:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010189a:	8b 40 08             	mov    0x8(%eax),%eax
8010189d:	8d 50 01             	lea    0x1(%eax),%edx
801018a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018a3:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
801018a6:	c7 04 24 a0 1a 11 80 	movl   $0x80111aa0,(%esp)
801018ad:	e8 03 38 00 00       	call   801050b5 <release>
      return ip;
801018b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018b5:	eb 72                	jmp    80101929 <iget+0xd3>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801018b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801018bb:	75 10                	jne    801018cd <iget+0x77>
801018bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018c0:	8b 40 08             	mov    0x8(%eax),%eax
801018c3:	85 c0                	test   %eax,%eax
801018c5:	75 06                	jne    801018cd <iget+0x77>
      empty = ip;
801018c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801018cd:	81 45 f4 90 00 00 00 	addl   $0x90,-0xc(%ebp)
801018d4:	81 7d f4 f4 36 11 80 	cmpl   $0x801136f4,-0xc(%ebp)
801018db:	72 9b                	jb     80101878 <iget+0x22>
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801018dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801018e1:	75 0c                	jne    801018ef <iget+0x99>
    panic("iget: no inodes");
801018e3:	c7 04 24 61 86 10 80 	movl   $0x80108661,(%esp)
801018ea:	e8 73 ec ff ff       	call   80100562 <panic>

  ip = empty;
801018ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801018f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
801018f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018f8:	8b 55 08             	mov    0x8(%ebp),%edx
801018fb:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
801018fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101900:	8b 55 0c             	mov    0xc(%ebp),%edx
80101903:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101906:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101909:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->valid = 0;
80101910:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101913:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  release(&icache.lock);
8010191a:	c7 04 24 a0 1a 11 80 	movl   $0x80111aa0,(%esp)
80101921:	e8 8f 37 00 00       	call   801050b5 <release>

  return ip;
80101926:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101929:	c9                   	leave  
8010192a:	c3                   	ret    

8010192b <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
8010192b:	55                   	push   %ebp
8010192c:	89 e5                	mov    %esp,%ebp
8010192e:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101931:	c7 04 24 a0 1a 11 80 	movl   $0x80111aa0,(%esp)
80101938:	e8 10 37 00 00       	call   8010504d <acquire>
  ip->ref++;
8010193d:	8b 45 08             	mov    0x8(%ebp),%eax
80101940:	8b 40 08             	mov    0x8(%eax),%eax
80101943:	8d 50 01             	lea    0x1(%eax),%edx
80101946:	8b 45 08             	mov    0x8(%ebp),%eax
80101949:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
8010194c:	c7 04 24 a0 1a 11 80 	movl   $0x80111aa0,(%esp)
80101953:	e8 5d 37 00 00       	call   801050b5 <release>
  return ip;
80101958:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010195b:	c9                   	leave  
8010195c:	c3                   	ret    

8010195d <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
8010195d:	55                   	push   %ebp
8010195e:	89 e5                	mov    %esp,%ebp
80101960:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101963:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101967:	74 0a                	je     80101973 <ilock+0x16>
80101969:	8b 45 08             	mov    0x8(%ebp),%eax
8010196c:	8b 40 08             	mov    0x8(%eax),%eax
8010196f:	85 c0                	test   %eax,%eax
80101971:	7f 0c                	jg     8010197f <ilock+0x22>
    panic("ilock");
80101973:	c7 04 24 71 86 10 80 	movl   $0x80108671,(%esp)
8010197a:	e8 e3 eb ff ff       	call   80100562 <panic>

  acquiresleep(&ip->lock);
8010197f:	8b 45 08             	mov    0x8(%ebp),%eax
80101982:	83 c0 0c             	add    $0xc,%eax
80101985:	89 04 24             	mov    %eax,(%esp)
80101988:	e8 76 35 00 00       	call   80104f03 <acquiresleep>

  if(ip->valid == 0){
8010198d:	8b 45 08             	mov    0x8(%ebp),%eax
80101990:	8b 40 4c             	mov    0x4c(%eax),%eax
80101993:	85 c0                	test   %eax,%eax
80101995:	0f 85 cd 00 00 00    	jne    80101a68 <ilock+0x10b>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010199b:	8b 45 08             	mov    0x8(%ebp),%eax
8010199e:	8b 40 04             	mov    0x4(%eax),%eax
801019a1:	c1 e8 03             	shr    $0x3,%eax
801019a4:	89 c2                	mov    %eax,%edx
801019a6:	a1 94 1a 11 80       	mov    0x80111a94,%eax
801019ab:	01 c2                	add    %eax,%edx
801019ad:	8b 45 08             	mov    0x8(%ebp),%eax
801019b0:	8b 00                	mov    (%eax),%eax
801019b2:	89 54 24 04          	mov    %edx,0x4(%esp)
801019b6:	89 04 24             	mov    %eax,(%esp)
801019b9:	e8 f7 e7 ff ff       	call   801001b5 <bread>
801019be:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801019c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019c4:	8d 50 5c             	lea    0x5c(%eax),%edx
801019c7:	8b 45 08             	mov    0x8(%ebp),%eax
801019ca:	8b 40 04             	mov    0x4(%eax),%eax
801019cd:	83 e0 07             	and    $0x7,%eax
801019d0:	c1 e0 06             	shl    $0x6,%eax
801019d3:	01 d0                	add    %edx,%eax
801019d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
801019d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019db:	0f b7 10             	movzwl (%eax),%edx
801019de:	8b 45 08             	mov    0x8(%ebp),%eax
801019e1:	66 89 50 50          	mov    %dx,0x50(%eax)
    ip->major = dip->major;
801019e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019e8:	0f b7 50 02          	movzwl 0x2(%eax),%edx
801019ec:	8b 45 08             	mov    0x8(%ebp),%eax
801019ef:	66 89 50 52          	mov    %dx,0x52(%eax)
    ip->minor = dip->minor;
801019f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801019f6:	0f b7 50 04          	movzwl 0x4(%eax),%edx
801019fa:	8b 45 08             	mov    0x8(%ebp),%eax
801019fd:	66 89 50 54          	mov    %dx,0x54(%eax)
    ip->nlink = dip->nlink;
80101a01:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a04:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101a08:	8b 45 08             	mov    0x8(%ebp),%eax
80101a0b:	66 89 50 56          	mov    %dx,0x56(%eax)
    ip->size = dip->size;
80101a0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a12:	8b 50 08             	mov    0x8(%eax),%edx
80101a15:	8b 45 08             	mov    0x8(%ebp),%eax
80101a18:	89 50 58             	mov    %edx,0x58(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a1e:	8d 50 0c             	lea    0xc(%eax),%edx
80101a21:	8b 45 08             	mov    0x8(%ebp),%eax
80101a24:	83 c0 5c             	add    $0x5c,%eax
80101a27:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101a2e:	00 
80101a2f:	89 54 24 04          	mov    %edx,0x4(%esp)
80101a33:	89 04 24             	mov    %eax,(%esp)
80101a36:	e8 53 39 00 00       	call   8010538e <memmove>
    brelse(bp);
80101a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a3e:	89 04 24             	mov    %eax,(%esp)
80101a41:	e8 e6 e7 ff ff       	call   8010022c <brelse>
    ip->valid = 1;
80101a46:	8b 45 08             	mov    0x8(%ebp),%eax
80101a49:	c7 40 4c 01 00 00 00 	movl   $0x1,0x4c(%eax)
    if(ip->type == 0)
80101a50:	8b 45 08             	mov    0x8(%ebp),%eax
80101a53:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80101a57:	66 85 c0             	test   %ax,%ax
80101a5a:	75 0c                	jne    80101a68 <ilock+0x10b>
      panic("ilock: no type");
80101a5c:	c7 04 24 77 86 10 80 	movl   $0x80108677,(%esp)
80101a63:	e8 fa ea ff ff       	call   80100562 <panic>
  }
}
80101a68:	c9                   	leave  
80101a69:	c3                   	ret    

80101a6a <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101a6a:	55                   	push   %ebp
80101a6b:	89 e5                	mov    %esp,%ebp
80101a6d:	83 ec 18             	sub    $0x18,%esp
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101a70:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101a74:	74 1c                	je     80101a92 <iunlock+0x28>
80101a76:	8b 45 08             	mov    0x8(%ebp),%eax
80101a79:	83 c0 0c             	add    $0xc,%eax
80101a7c:	89 04 24             	mov    %eax,(%esp)
80101a7f:	e8 1c 35 00 00       	call   80104fa0 <holdingsleep>
80101a84:	85 c0                	test   %eax,%eax
80101a86:	74 0a                	je     80101a92 <iunlock+0x28>
80101a88:	8b 45 08             	mov    0x8(%ebp),%eax
80101a8b:	8b 40 08             	mov    0x8(%eax),%eax
80101a8e:	85 c0                	test   %eax,%eax
80101a90:	7f 0c                	jg     80101a9e <iunlock+0x34>
    panic("iunlock");
80101a92:	c7 04 24 86 86 10 80 	movl   $0x80108686,(%esp)
80101a99:	e8 c4 ea ff ff       	call   80100562 <panic>

  releasesleep(&ip->lock);
80101a9e:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa1:	83 c0 0c             	add    $0xc,%eax
80101aa4:	89 04 24             	mov    %eax,(%esp)
80101aa7:	e8 b2 34 00 00       	call   80104f5e <releasesleep>
}
80101aac:	c9                   	leave  
80101aad:	c3                   	ret    

80101aae <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101aae:	55                   	push   %ebp
80101aaf:	89 e5                	mov    %esp,%ebp
80101ab1:	83 ec 28             	sub    $0x28,%esp
  acquiresleep(&ip->lock);
80101ab4:	8b 45 08             	mov    0x8(%ebp),%eax
80101ab7:	83 c0 0c             	add    $0xc,%eax
80101aba:	89 04 24             	mov    %eax,(%esp)
80101abd:	e8 41 34 00 00       	call   80104f03 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101ac2:	8b 45 08             	mov    0x8(%ebp),%eax
80101ac5:	8b 40 4c             	mov    0x4c(%eax),%eax
80101ac8:	85 c0                	test   %eax,%eax
80101aca:	74 5c                	je     80101b28 <iput+0x7a>
80101acc:	8b 45 08             	mov    0x8(%ebp),%eax
80101acf:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80101ad3:	66 85 c0             	test   %ax,%ax
80101ad6:	75 50                	jne    80101b28 <iput+0x7a>
    acquire(&icache.lock);
80101ad8:	c7 04 24 a0 1a 11 80 	movl   $0x80111aa0,(%esp)
80101adf:	e8 69 35 00 00       	call   8010504d <acquire>
    int r = ip->ref;
80101ae4:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae7:	8b 40 08             	mov    0x8(%eax),%eax
80101aea:	89 45 f4             	mov    %eax,-0xc(%ebp)
    release(&icache.lock);
80101aed:	c7 04 24 a0 1a 11 80 	movl   $0x80111aa0,(%esp)
80101af4:	e8 bc 35 00 00       	call   801050b5 <release>
    if(r == 1){
80101af9:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80101afd:	75 29                	jne    80101b28 <iput+0x7a>
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
80101aff:	8b 45 08             	mov    0x8(%ebp),%eax
80101b02:	89 04 24             	mov    %eax,(%esp)
80101b05:	e8 86 01 00 00       	call   80101c90 <itrunc>
      ip->type = 0;
80101b0a:	8b 45 08             	mov    0x8(%ebp),%eax
80101b0d:	66 c7 40 50 00 00    	movw   $0x0,0x50(%eax)
      iupdate(ip);
80101b13:	8b 45 08             	mov    0x8(%ebp),%eax
80101b16:	89 04 24             	mov    %eax,(%esp)
80101b19:	e8 7a fc ff ff       	call   80101798 <iupdate>
      ip->valid = 0;
80101b1e:	8b 45 08             	mov    0x8(%ebp),%eax
80101b21:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
    }
  }
  releasesleep(&ip->lock);
80101b28:	8b 45 08             	mov    0x8(%ebp),%eax
80101b2b:	83 c0 0c             	add    $0xc,%eax
80101b2e:	89 04 24             	mov    %eax,(%esp)
80101b31:	e8 28 34 00 00       	call   80104f5e <releasesleep>

  acquire(&icache.lock);
80101b36:	c7 04 24 a0 1a 11 80 	movl   $0x80111aa0,(%esp)
80101b3d:	e8 0b 35 00 00       	call   8010504d <acquire>
  ip->ref--;
80101b42:	8b 45 08             	mov    0x8(%ebp),%eax
80101b45:	8b 40 08             	mov    0x8(%eax),%eax
80101b48:	8d 50 ff             	lea    -0x1(%eax),%edx
80101b4b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b4e:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101b51:	c7 04 24 a0 1a 11 80 	movl   $0x80111aa0,(%esp)
80101b58:	e8 58 35 00 00       	call   801050b5 <release>
}
80101b5d:	c9                   	leave  
80101b5e:	c3                   	ret    

80101b5f <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101b5f:	55                   	push   %ebp
80101b60:	89 e5                	mov    %esp,%ebp
80101b62:	83 ec 18             	sub    $0x18,%esp
  iunlock(ip);
80101b65:	8b 45 08             	mov    0x8(%ebp),%eax
80101b68:	89 04 24             	mov    %eax,(%esp)
80101b6b:	e8 fa fe ff ff       	call   80101a6a <iunlock>
  iput(ip);
80101b70:	8b 45 08             	mov    0x8(%ebp),%eax
80101b73:	89 04 24             	mov    %eax,(%esp)
80101b76:	e8 33 ff ff ff       	call   80101aae <iput>
}
80101b7b:	c9                   	leave  
80101b7c:	c3                   	ret    

80101b7d <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101b7d:	55                   	push   %ebp
80101b7e:	89 e5                	mov    %esp,%ebp
80101b80:	53                   	push   %ebx
80101b81:	83 ec 24             	sub    $0x24,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101b84:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101b88:	77 3e                	ja     80101bc8 <bmap+0x4b>
    if((addr = ip->addrs[bn]) == 0)
80101b8a:	8b 45 08             	mov    0x8(%ebp),%eax
80101b8d:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b90:	83 c2 14             	add    $0x14,%edx
80101b93:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101b97:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101b9e:	75 20                	jne    80101bc0 <bmap+0x43>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101ba0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ba3:	8b 00                	mov    (%eax),%eax
80101ba5:	89 04 24             	mov    %eax,(%esp)
80101ba8:	e8 3a f8 ff ff       	call   801013e7 <balloc>
80101bad:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bb0:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb3:	8b 55 0c             	mov    0xc(%ebp),%edx
80101bb6:	8d 4a 14             	lea    0x14(%edx),%ecx
80101bb9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101bbc:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101bc3:	e9 c2 00 00 00       	jmp    80101c8a <bmap+0x10d>
  }
  bn -= NDIRECT;
80101bc8:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101bcc:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101bd0:	0f 87 a8 00 00 00    	ja     80101c7e <bmap+0x101>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101bd6:	8b 45 08             	mov    0x8(%ebp),%eax
80101bd9:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101bdf:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101be2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101be6:	75 1c                	jne    80101c04 <bmap+0x87>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101be8:	8b 45 08             	mov    0x8(%ebp),%eax
80101beb:	8b 00                	mov    (%eax),%eax
80101bed:	89 04 24             	mov    %eax,(%esp)
80101bf0:	e8 f2 f7 ff ff       	call   801013e7 <balloc>
80101bf5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bf8:	8b 45 08             	mov    0x8(%ebp),%eax
80101bfb:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101bfe:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
    bp = bread(ip->dev, addr);
80101c04:	8b 45 08             	mov    0x8(%ebp),%eax
80101c07:	8b 00                	mov    (%eax),%eax
80101c09:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c0c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c10:	89 04 24             	mov    %eax,(%esp)
80101c13:	e8 9d e5 ff ff       	call   801001b5 <bread>
80101c18:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101c1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c1e:	83 c0 5c             	add    $0x5c,%eax
80101c21:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101c24:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c27:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101c2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c31:	01 d0                	add    %edx,%eax
80101c33:	8b 00                	mov    (%eax),%eax
80101c35:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c3c:	75 30                	jne    80101c6e <bmap+0xf1>
      a[bn] = addr = balloc(ip->dev);
80101c3e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c41:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101c48:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c4b:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101c4e:	8b 45 08             	mov    0x8(%ebp),%eax
80101c51:	8b 00                	mov    (%eax),%eax
80101c53:	89 04 24             	mov    %eax,(%esp)
80101c56:	e8 8c f7 ff ff       	call   801013e7 <balloc>
80101c5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c61:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101c63:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c66:	89 04 24             	mov    %eax,(%esp)
80101c69:	e8 24 1a 00 00       	call   80103692 <log_write>
    }
    brelse(bp);
80101c6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c71:	89 04 24             	mov    %eax,(%esp)
80101c74:	e8 b3 e5 ff ff       	call   8010022c <brelse>
    return addr;
80101c79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c7c:	eb 0c                	jmp    80101c8a <bmap+0x10d>
  }

  panic("bmap: out of range");
80101c7e:	c7 04 24 8e 86 10 80 	movl   $0x8010868e,(%esp)
80101c85:	e8 d8 e8 ff ff       	call   80100562 <panic>
}
80101c8a:	83 c4 24             	add    $0x24,%esp
80101c8d:	5b                   	pop    %ebx
80101c8e:	5d                   	pop    %ebp
80101c8f:	c3                   	ret    

80101c90 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101c90:	55                   	push   %ebp
80101c91:	89 e5                	mov    %esp,%ebp
80101c93:	83 ec 28             	sub    $0x28,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c96:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101c9d:	eb 44                	jmp    80101ce3 <itrunc+0x53>
    if(ip->addrs[i]){
80101c9f:	8b 45 08             	mov    0x8(%ebp),%eax
80101ca2:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101ca5:	83 c2 14             	add    $0x14,%edx
80101ca8:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101cac:	85 c0                	test   %eax,%eax
80101cae:	74 2f                	je     80101cdf <itrunc+0x4f>
      bfree(ip->dev, ip->addrs[i]);
80101cb0:	8b 45 08             	mov    0x8(%ebp),%eax
80101cb3:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cb6:	83 c2 14             	add    $0x14,%edx
80101cb9:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
80101cbd:	8b 45 08             	mov    0x8(%ebp),%eax
80101cc0:	8b 00                	mov    (%eax),%eax
80101cc2:	89 54 24 04          	mov    %edx,0x4(%esp)
80101cc6:	89 04 24             	mov    %eax,(%esp)
80101cc9:	e8 57 f8 ff ff       	call   80101525 <bfree>
      ip->addrs[i] = 0;
80101cce:	8b 45 08             	mov    0x8(%ebp),%eax
80101cd1:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cd4:	83 c2 14             	add    $0x14,%edx
80101cd7:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101cde:	00 
  for(i = 0; i < NDIRECT; i++){
80101cdf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101ce3:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101ce7:	7e b6                	jle    80101c9f <itrunc+0xf>
    }
  }

  if(ip->addrs[NDIRECT]){
80101ce9:	8b 45 08             	mov    0x8(%ebp),%eax
80101cec:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101cf2:	85 c0                	test   %eax,%eax
80101cf4:	0f 84 a4 00 00 00    	je     80101d9e <itrunc+0x10e>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101cfa:	8b 45 08             	mov    0x8(%ebp),%eax
80101cfd:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80101d03:	8b 45 08             	mov    0x8(%ebp),%eax
80101d06:	8b 00                	mov    (%eax),%eax
80101d08:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d0c:	89 04 24             	mov    %eax,(%esp)
80101d0f:	e8 a1 e4 ff ff       	call   801001b5 <bread>
80101d14:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101d17:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d1a:	83 c0 5c             	add    $0x5c,%eax
80101d1d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101d20:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101d27:	eb 3b                	jmp    80101d64 <itrunc+0xd4>
      if(a[j])
80101d29:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d2c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d33:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101d36:	01 d0                	add    %edx,%eax
80101d38:	8b 00                	mov    (%eax),%eax
80101d3a:	85 c0                	test   %eax,%eax
80101d3c:	74 22                	je     80101d60 <itrunc+0xd0>
        bfree(ip->dev, a[j]);
80101d3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d41:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d48:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101d4b:	01 d0                	add    %edx,%eax
80101d4d:	8b 10                	mov    (%eax),%edx
80101d4f:	8b 45 08             	mov    0x8(%ebp),%eax
80101d52:	8b 00                	mov    (%eax),%eax
80101d54:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d58:	89 04 24             	mov    %eax,(%esp)
80101d5b:	e8 c5 f7 ff ff       	call   80101525 <bfree>
    for(j = 0; j < NINDIRECT; j++){
80101d60:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101d64:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d67:	83 f8 7f             	cmp    $0x7f,%eax
80101d6a:	76 bd                	jbe    80101d29 <itrunc+0x99>
    }
    brelse(bp);
80101d6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d6f:	89 04 24             	mov    %eax,(%esp)
80101d72:	e8 b5 e4 ff ff       	call   8010022c <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101d77:	8b 45 08             	mov    0x8(%ebp),%eax
80101d7a:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80101d80:	8b 45 08             	mov    0x8(%ebp),%eax
80101d83:	8b 00                	mov    (%eax),%eax
80101d85:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d89:	89 04 24             	mov    %eax,(%esp)
80101d8c:	e8 94 f7 ff ff       	call   80101525 <bfree>
    ip->addrs[NDIRECT] = 0;
80101d91:	8b 45 08             	mov    0x8(%ebp),%eax
80101d94:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
80101d9b:	00 00 00 
  }

  ip->size = 0;
80101d9e:	8b 45 08             	mov    0x8(%ebp),%eax
80101da1:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  iupdate(ip);
80101da8:	8b 45 08             	mov    0x8(%ebp),%eax
80101dab:	89 04 24             	mov    %eax,(%esp)
80101dae:	e8 e5 f9 ff ff       	call   80101798 <iupdate>
}
80101db3:	c9                   	leave  
80101db4:	c3                   	ret    

80101db5 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101db5:	55                   	push   %ebp
80101db6:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101db8:	8b 45 08             	mov    0x8(%ebp),%eax
80101dbb:	8b 00                	mov    (%eax),%eax
80101dbd:	89 c2                	mov    %eax,%edx
80101dbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80101dc2:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101dc5:	8b 45 08             	mov    0x8(%ebp),%eax
80101dc8:	8b 50 04             	mov    0x4(%eax),%edx
80101dcb:	8b 45 0c             	mov    0xc(%ebp),%eax
80101dce:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101dd1:	8b 45 08             	mov    0x8(%ebp),%eax
80101dd4:	0f b7 50 50          	movzwl 0x50(%eax),%edx
80101dd8:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ddb:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101dde:	8b 45 08             	mov    0x8(%ebp),%eax
80101de1:	0f b7 50 56          	movzwl 0x56(%eax),%edx
80101de5:	8b 45 0c             	mov    0xc(%ebp),%eax
80101de8:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101dec:	8b 45 08             	mov    0x8(%ebp),%eax
80101def:	8b 50 58             	mov    0x58(%eax),%edx
80101df2:	8b 45 0c             	mov    0xc(%ebp),%eax
80101df5:	89 50 10             	mov    %edx,0x10(%eax)
}
80101df8:	5d                   	pop    %ebp
80101df9:	c3                   	ret    

80101dfa <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101dfa:	55                   	push   %ebp
80101dfb:	89 e5                	mov    %esp,%ebp
80101dfd:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101e00:	8b 45 08             	mov    0x8(%ebp),%eax
80101e03:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80101e07:	66 83 f8 03          	cmp    $0x3,%ax
80101e0b:	75 60                	jne    80101e6d <readi+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101e0d:	8b 45 08             	mov    0x8(%ebp),%eax
80101e10:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101e14:	66 85 c0             	test   %ax,%ax
80101e17:	78 20                	js     80101e39 <readi+0x3f>
80101e19:	8b 45 08             	mov    0x8(%ebp),%eax
80101e1c:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101e20:	66 83 f8 09          	cmp    $0x9,%ax
80101e24:	7f 13                	jg     80101e39 <readi+0x3f>
80101e26:	8b 45 08             	mov    0x8(%ebp),%eax
80101e29:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101e2d:	98                   	cwtl   
80101e2e:	8b 04 c5 20 1a 11 80 	mov    -0x7feee5e0(,%eax,8),%eax
80101e35:	85 c0                	test   %eax,%eax
80101e37:	75 0a                	jne    80101e43 <readi+0x49>
      return -1;
80101e39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e3e:	e9 19 01 00 00       	jmp    80101f5c <readi+0x162>
    return devsw[ip->major].read(ip, dst, n);
80101e43:	8b 45 08             	mov    0x8(%ebp),%eax
80101e46:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101e4a:	98                   	cwtl   
80101e4b:	8b 04 c5 20 1a 11 80 	mov    -0x7feee5e0(,%eax,8),%eax
80101e52:	8b 55 14             	mov    0x14(%ebp),%edx
80101e55:	89 54 24 08          	mov    %edx,0x8(%esp)
80101e59:	8b 55 0c             	mov    0xc(%ebp),%edx
80101e5c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101e60:	8b 55 08             	mov    0x8(%ebp),%edx
80101e63:	89 14 24             	mov    %edx,(%esp)
80101e66:	ff d0                	call   *%eax
80101e68:	e9 ef 00 00 00       	jmp    80101f5c <readi+0x162>
  }

  if(off > ip->size || off + n < off)
80101e6d:	8b 45 08             	mov    0x8(%ebp),%eax
80101e70:	8b 40 58             	mov    0x58(%eax),%eax
80101e73:	3b 45 10             	cmp    0x10(%ebp),%eax
80101e76:	72 0d                	jb     80101e85 <readi+0x8b>
80101e78:	8b 45 14             	mov    0x14(%ebp),%eax
80101e7b:	8b 55 10             	mov    0x10(%ebp),%edx
80101e7e:	01 d0                	add    %edx,%eax
80101e80:	3b 45 10             	cmp    0x10(%ebp),%eax
80101e83:	73 0a                	jae    80101e8f <readi+0x95>
    return -1;
80101e85:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e8a:	e9 cd 00 00 00       	jmp    80101f5c <readi+0x162>
  if(off + n > ip->size)
80101e8f:	8b 45 14             	mov    0x14(%ebp),%eax
80101e92:	8b 55 10             	mov    0x10(%ebp),%edx
80101e95:	01 c2                	add    %eax,%edx
80101e97:	8b 45 08             	mov    0x8(%ebp),%eax
80101e9a:	8b 40 58             	mov    0x58(%eax),%eax
80101e9d:	39 c2                	cmp    %eax,%edx
80101e9f:	76 0c                	jbe    80101ead <readi+0xb3>
    n = ip->size - off;
80101ea1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ea4:	8b 40 58             	mov    0x58(%eax),%eax
80101ea7:	2b 45 10             	sub    0x10(%ebp),%eax
80101eaa:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ead:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101eb4:	e9 94 00 00 00       	jmp    80101f4d <readi+0x153>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101eb9:	8b 45 10             	mov    0x10(%ebp),%eax
80101ebc:	c1 e8 09             	shr    $0x9,%eax
80101ebf:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ec3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ec6:	89 04 24             	mov    %eax,(%esp)
80101ec9:	e8 af fc ff ff       	call   80101b7d <bmap>
80101ece:	8b 55 08             	mov    0x8(%ebp),%edx
80101ed1:	8b 12                	mov    (%edx),%edx
80101ed3:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ed7:	89 14 24             	mov    %edx,(%esp)
80101eda:	e8 d6 e2 ff ff       	call   801001b5 <bread>
80101edf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101ee2:	8b 45 10             	mov    0x10(%ebp),%eax
80101ee5:	25 ff 01 00 00       	and    $0x1ff,%eax
80101eea:	89 c2                	mov    %eax,%edx
80101eec:	b8 00 02 00 00       	mov    $0x200,%eax
80101ef1:	29 d0                	sub    %edx,%eax
80101ef3:	89 c2                	mov    %eax,%edx
80101ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ef8:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101efb:	29 c1                	sub    %eax,%ecx
80101efd:	89 c8                	mov    %ecx,%eax
80101eff:	39 c2                	cmp    %eax,%edx
80101f01:	0f 46 c2             	cmovbe %edx,%eax
80101f04:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101f07:	8b 45 10             	mov    0x10(%ebp),%eax
80101f0a:	25 ff 01 00 00       	and    $0x1ff,%eax
80101f0f:	8d 50 50             	lea    0x50(%eax),%edx
80101f12:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f15:	01 d0                	add    %edx,%eax
80101f17:	8d 50 0c             	lea    0xc(%eax),%edx
80101f1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f1d:	89 44 24 08          	mov    %eax,0x8(%esp)
80101f21:	89 54 24 04          	mov    %edx,0x4(%esp)
80101f25:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f28:	89 04 24             	mov    %eax,(%esp)
80101f2b:	e8 5e 34 00 00       	call   8010538e <memmove>
    brelse(bp);
80101f30:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101f33:	89 04 24             	mov    %eax,(%esp)
80101f36:	e8 f1 e2 ff ff       	call   8010022c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101f3b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f3e:	01 45 f4             	add    %eax,-0xc(%ebp)
80101f41:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f44:	01 45 10             	add    %eax,0x10(%ebp)
80101f47:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101f4a:	01 45 0c             	add    %eax,0xc(%ebp)
80101f4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101f50:	3b 45 14             	cmp    0x14(%ebp),%eax
80101f53:	0f 82 60 ff ff ff    	jb     80101eb9 <readi+0xbf>
  }
  return n;
80101f59:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101f5c:	c9                   	leave  
80101f5d:	c3                   	ret    

80101f5e <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101f5e:	55                   	push   %ebp
80101f5f:	89 e5                	mov    %esp,%ebp
80101f61:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101f64:	8b 45 08             	mov    0x8(%ebp),%eax
80101f67:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80101f6b:	66 83 f8 03          	cmp    $0x3,%ax
80101f6f:	75 60                	jne    80101fd1 <writei+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101f71:	8b 45 08             	mov    0x8(%ebp),%eax
80101f74:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101f78:	66 85 c0             	test   %ax,%ax
80101f7b:	78 20                	js     80101f9d <writei+0x3f>
80101f7d:	8b 45 08             	mov    0x8(%ebp),%eax
80101f80:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101f84:	66 83 f8 09          	cmp    $0x9,%ax
80101f88:	7f 13                	jg     80101f9d <writei+0x3f>
80101f8a:	8b 45 08             	mov    0x8(%ebp),%eax
80101f8d:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101f91:	98                   	cwtl   
80101f92:	8b 04 c5 24 1a 11 80 	mov    -0x7feee5dc(,%eax,8),%eax
80101f99:	85 c0                	test   %eax,%eax
80101f9b:	75 0a                	jne    80101fa7 <writei+0x49>
      return -1;
80101f9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fa2:	e9 44 01 00 00       	jmp    801020eb <writei+0x18d>
    return devsw[ip->major].write(ip, src, n);
80101fa7:	8b 45 08             	mov    0x8(%ebp),%eax
80101faa:	0f b7 40 52          	movzwl 0x52(%eax),%eax
80101fae:	98                   	cwtl   
80101faf:	8b 04 c5 24 1a 11 80 	mov    -0x7feee5dc(,%eax,8),%eax
80101fb6:	8b 55 14             	mov    0x14(%ebp),%edx
80101fb9:	89 54 24 08          	mov    %edx,0x8(%esp)
80101fbd:	8b 55 0c             	mov    0xc(%ebp),%edx
80101fc0:	89 54 24 04          	mov    %edx,0x4(%esp)
80101fc4:	8b 55 08             	mov    0x8(%ebp),%edx
80101fc7:	89 14 24             	mov    %edx,(%esp)
80101fca:	ff d0                	call   *%eax
80101fcc:	e9 1a 01 00 00       	jmp    801020eb <writei+0x18d>
  }

  if(off > ip->size || off + n < off)
80101fd1:	8b 45 08             	mov    0x8(%ebp),%eax
80101fd4:	8b 40 58             	mov    0x58(%eax),%eax
80101fd7:	3b 45 10             	cmp    0x10(%ebp),%eax
80101fda:	72 0d                	jb     80101fe9 <writei+0x8b>
80101fdc:	8b 45 14             	mov    0x14(%ebp),%eax
80101fdf:	8b 55 10             	mov    0x10(%ebp),%edx
80101fe2:	01 d0                	add    %edx,%eax
80101fe4:	3b 45 10             	cmp    0x10(%ebp),%eax
80101fe7:	73 0a                	jae    80101ff3 <writei+0x95>
    return -1;
80101fe9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101fee:	e9 f8 00 00 00       	jmp    801020eb <writei+0x18d>
  if(off + n > MAXFILE*BSIZE)
80101ff3:	8b 45 14             	mov    0x14(%ebp),%eax
80101ff6:	8b 55 10             	mov    0x10(%ebp),%edx
80101ff9:	01 d0                	add    %edx,%eax
80101ffb:	3d 00 18 01 00       	cmp    $0x11800,%eax
80102000:	76 0a                	jbe    8010200c <writei+0xae>
    return -1;
80102002:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102007:	e9 df 00 00 00       	jmp    801020eb <writei+0x18d>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010200c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102013:	e9 9f 00 00 00       	jmp    801020b7 <writei+0x159>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80102018:	8b 45 10             	mov    0x10(%ebp),%eax
8010201b:	c1 e8 09             	shr    $0x9,%eax
8010201e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102022:	8b 45 08             	mov    0x8(%ebp),%eax
80102025:	89 04 24             	mov    %eax,(%esp)
80102028:	e8 50 fb ff ff       	call   80101b7d <bmap>
8010202d:	8b 55 08             	mov    0x8(%ebp),%edx
80102030:	8b 12                	mov    (%edx),%edx
80102032:	89 44 24 04          	mov    %eax,0x4(%esp)
80102036:	89 14 24             	mov    %edx,(%esp)
80102039:	e8 77 e1 ff ff       	call   801001b5 <bread>
8010203e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102041:	8b 45 10             	mov    0x10(%ebp),%eax
80102044:	25 ff 01 00 00       	and    $0x1ff,%eax
80102049:	89 c2                	mov    %eax,%edx
8010204b:	b8 00 02 00 00       	mov    $0x200,%eax
80102050:	29 d0                	sub    %edx,%eax
80102052:	89 c2                	mov    %eax,%edx
80102054:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102057:	8b 4d 14             	mov    0x14(%ebp),%ecx
8010205a:	29 c1                	sub    %eax,%ecx
8010205c:	89 c8                	mov    %ecx,%eax
8010205e:	39 c2                	cmp    %eax,%edx
80102060:	0f 46 c2             	cmovbe %edx,%eax
80102063:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
80102066:	8b 45 10             	mov    0x10(%ebp),%eax
80102069:	25 ff 01 00 00       	and    $0x1ff,%eax
8010206e:	8d 50 50             	lea    0x50(%eax),%edx
80102071:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102074:	01 d0                	add    %edx,%eax
80102076:	8d 50 0c             	lea    0xc(%eax),%edx
80102079:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010207c:	89 44 24 08          	mov    %eax,0x8(%esp)
80102080:	8b 45 0c             	mov    0xc(%ebp),%eax
80102083:	89 44 24 04          	mov    %eax,0x4(%esp)
80102087:	89 14 24             	mov    %edx,(%esp)
8010208a:	e8 ff 32 00 00       	call   8010538e <memmove>
    log_write(bp);
8010208f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102092:	89 04 24             	mov    %eax,(%esp)
80102095:	e8 f8 15 00 00       	call   80103692 <log_write>
    brelse(bp);
8010209a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010209d:	89 04 24             	mov    %eax,(%esp)
801020a0:	e8 87 e1 ff ff       	call   8010022c <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801020a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020a8:	01 45 f4             	add    %eax,-0xc(%ebp)
801020ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020ae:	01 45 10             	add    %eax,0x10(%ebp)
801020b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801020b4:	01 45 0c             	add    %eax,0xc(%ebp)
801020b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801020ba:	3b 45 14             	cmp    0x14(%ebp),%eax
801020bd:	0f 82 55 ff ff ff    	jb     80102018 <writei+0xba>
  }

  if(n > 0 && off > ip->size){
801020c3:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801020c7:	74 1f                	je     801020e8 <writei+0x18a>
801020c9:	8b 45 08             	mov    0x8(%ebp),%eax
801020cc:	8b 40 58             	mov    0x58(%eax),%eax
801020cf:	3b 45 10             	cmp    0x10(%ebp),%eax
801020d2:	73 14                	jae    801020e8 <writei+0x18a>
    ip->size = off;
801020d4:	8b 45 08             	mov    0x8(%ebp),%eax
801020d7:	8b 55 10             	mov    0x10(%ebp),%edx
801020da:	89 50 58             	mov    %edx,0x58(%eax)
    iupdate(ip);
801020dd:	8b 45 08             	mov    0x8(%ebp),%eax
801020e0:	89 04 24             	mov    %eax,(%esp)
801020e3:	e8 b0 f6 ff ff       	call   80101798 <iupdate>
  }
  return n;
801020e8:	8b 45 14             	mov    0x14(%ebp),%eax
}
801020eb:	c9                   	leave  
801020ec:	c3                   	ret    

801020ed <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801020ed:	55                   	push   %ebp
801020ee:	89 e5                	mov    %esp,%ebp
801020f0:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
801020f3:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801020fa:	00 
801020fb:	8b 45 0c             	mov    0xc(%ebp),%eax
801020fe:	89 44 24 04          	mov    %eax,0x4(%esp)
80102102:	8b 45 08             	mov    0x8(%ebp),%eax
80102105:	89 04 24             	mov    %eax,(%esp)
80102108:	e8 24 33 00 00       	call   80105431 <strncmp>
}
8010210d:	c9                   	leave  
8010210e:	c3                   	ret    

8010210f <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
8010210f:	55                   	push   %ebp
80102110:	89 e5                	mov    %esp,%ebp
80102112:	83 ec 38             	sub    $0x38,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102115:	8b 45 08             	mov    0x8(%ebp),%eax
80102118:	0f b7 40 50          	movzwl 0x50(%eax),%eax
8010211c:	66 83 f8 01          	cmp    $0x1,%ax
80102120:	74 0c                	je     8010212e <dirlookup+0x1f>
    panic("dirlookup not DIR");
80102122:	c7 04 24 a1 86 10 80 	movl   $0x801086a1,(%esp)
80102129:	e8 34 e4 ff ff       	call   80100562 <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
8010212e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102135:	e9 88 00 00 00       	jmp    801021c2 <dirlookup+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010213a:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102141:	00 
80102142:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102145:	89 44 24 08          	mov    %eax,0x8(%esp)
80102149:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010214c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102150:	8b 45 08             	mov    0x8(%ebp),%eax
80102153:	89 04 24             	mov    %eax,(%esp)
80102156:	e8 9f fc ff ff       	call   80101dfa <readi>
8010215b:	83 f8 10             	cmp    $0x10,%eax
8010215e:	74 0c                	je     8010216c <dirlookup+0x5d>
      panic("dirlookup read");
80102160:	c7 04 24 b3 86 10 80 	movl   $0x801086b3,(%esp)
80102167:	e8 f6 e3 ff ff       	call   80100562 <panic>
    if(de.inum == 0)
8010216c:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102170:	66 85 c0             	test   %ax,%ax
80102173:	75 02                	jne    80102177 <dirlookup+0x68>
      continue;
80102175:	eb 47                	jmp    801021be <dirlookup+0xaf>
    if(namecmp(name, de.name) == 0){
80102177:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010217a:	83 c0 02             	add    $0x2,%eax
8010217d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102181:	8b 45 0c             	mov    0xc(%ebp),%eax
80102184:	89 04 24             	mov    %eax,(%esp)
80102187:	e8 61 ff ff ff       	call   801020ed <namecmp>
8010218c:	85 c0                	test   %eax,%eax
8010218e:	75 2e                	jne    801021be <dirlookup+0xaf>
      // entry matches path element
      if(poff)
80102190:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102194:	74 08                	je     8010219e <dirlookup+0x8f>
        *poff = off;
80102196:	8b 45 10             	mov    0x10(%ebp),%eax
80102199:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010219c:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
8010219e:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801021a2:	0f b7 c0             	movzwl %ax,%eax
801021a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
801021a8:	8b 45 08             	mov    0x8(%ebp),%eax
801021ab:	8b 00                	mov    (%eax),%eax
801021ad:	8b 55 f0             	mov    -0x10(%ebp),%edx
801021b0:	89 54 24 04          	mov    %edx,0x4(%esp)
801021b4:	89 04 24             	mov    %eax,(%esp)
801021b7:	e8 9a f6 ff ff       	call   80101856 <iget>
801021bc:	eb 18                	jmp    801021d6 <dirlookup+0xc7>
  for(off = 0; off < dp->size; off += sizeof(de)){
801021be:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801021c2:	8b 45 08             	mov    0x8(%ebp),%eax
801021c5:	8b 40 58             	mov    0x58(%eax),%eax
801021c8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801021cb:	0f 87 69 ff ff ff    	ja     8010213a <dirlookup+0x2b>
    }
  }

  return 0;
801021d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801021d6:	c9                   	leave  
801021d7:	c3                   	ret    

801021d8 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
801021d8:	55                   	push   %ebp
801021d9:	89 e5                	mov    %esp,%ebp
801021db:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
801021de:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801021e5:	00 
801021e6:	8b 45 0c             	mov    0xc(%ebp),%eax
801021e9:	89 44 24 04          	mov    %eax,0x4(%esp)
801021ed:	8b 45 08             	mov    0x8(%ebp),%eax
801021f0:	89 04 24             	mov    %eax,(%esp)
801021f3:	e8 17 ff ff ff       	call   8010210f <dirlookup>
801021f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
801021fb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801021ff:	74 15                	je     80102216 <dirlink+0x3e>
    iput(ip);
80102201:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102204:	89 04 24             	mov    %eax,(%esp)
80102207:	e8 a2 f8 ff ff       	call   80101aae <iput>
    return -1;
8010220c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102211:	e9 b7 00 00 00       	jmp    801022cd <dirlink+0xf5>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102216:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010221d:	eb 46                	jmp    80102265 <dirlink+0x8d>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010221f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102222:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102229:	00 
8010222a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010222e:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102231:	89 44 24 04          	mov    %eax,0x4(%esp)
80102235:	8b 45 08             	mov    0x8(%ebp),%eax
80102238:	89 04 24             	mov    %eax,(%esp)
8010223b:	e8 ba fb ff ff       	call   80101dfa <readi>
80102240:	83 f8 10             	cmp    $0x10,%eax
80102243:	74 0c                	je     80102251 <dirlink+0x79>
      panic("dirlink read");
80102245:	c7 04 24 c2 86 10 80 	movl   $0x801086c2,(%esp)
8010224c:	e8 11 e3 ff ff       	call   80100562 <panic>
    if(de.inum == 0)
80102251:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102255:	66 85 c0             	test   %ax,%ax
80102258:	75 02                	jne    8010225c <dirlink+0x84>
      break;
8010225a:	eb 16                	jmp    80102272 <dirlink+0x9a>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010225c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010225f:	83 c0 10             	add    $0x10,%eax
80102262:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102265:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102268:	8b 45 08             	mov    0x8(%ebp),%eax
8010226b:	8b 40 58             	mov    0x58(%eax),%eax
8010226e:	39 c2                	cmp    %eax,%edx
80102270:	72 ad                	jb     8010221f <dirlink+0x47>
  }

  strncpy(de.name, name, DIRSIZ);
80102272:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80102279:	00 
8010227a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010227d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102281:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102284:	83 c0 02             	add    $0x2,%eax
80102287:	89 04 24             	mov    %eax,(%esp)
8010228a:	e8 f8 31 00 00       	call   80105487 <strncpy>
  de.inum = inum;
8010228f:	8b 45 10             	mov    0x10(%ebp),%eax
80102292:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102296:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102299:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801022a0:	00 
801022a1:	89 44 24 08          	mov    %eax,0x8(%esp)
801022a5:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022a8:	89 44 24 04          	mov    %eax,0x4(%esp)
801022ac:	8b 45 08             	mov    0x8(%ebp),%eax
801022af:	89 04 24             	mov    %eax,(%esp)
801022b2:	e8 a7 fc ff ff       	call   80101f5e <writei>
801022b7:	83 f8 10             	cmp    $0x10,%eax
801022ba:	74 0c                	je     801022c8 <dirlink+0xf0>
    panic("dirlink");
801022bc:	c7 04 24 cf 86 10 80 	movl   $0x801086cf,(%esp)
801022c3:	e8 9a e2 ff ff       	call   80100562 <panic>

  return 0;
801022c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801022cd:	c9                   	leave  
801022ce:	c3                   	ret    

801022cf <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
801022cf:	55                   	push   %ebp
801022d0:	89 e5                	mov    %esp,%ebp
801022d2:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int len;

  while(*path == '/')
801022d5:	eb 04                	jmp    801022db <skipelem+0xc>
    path++;
801022d7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
801022db:	8b 45 08             	mov    0x8(%ebp),%eax
801022de:	0f b6 00             	movzbl (%eax),%eax
801022e1:	3c 2f                	cmp    $0x2f,%al
801022e3:	74 f2                	je     801022d7 <skipelem+0x8>
  if(*path == 0)
801022e5:	8b 45 08             	mov    0x8(%ebp),%eax
801022e8:	0f b6 00             	movzbl (%eax),%eax
801022eb:	84 c0                	test   %al,%al
801022ed:	75 0a                	jne    801022f9 <skipelem+0x2a>
    return 0;
801022ef:	b8 00 00 00 00       	mov    $0x0,%eax
801022f4:	e9 86 00 00 00       	jmp    8010237f <skipelem+0xb0>
  s = path;
801022f9:	8b 45 08             	mov    0x8(%ebp),%eax
801022fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
801022ff:	eb 04                	jmp    80102305 <skipelem+0x36>
    path++;
80102301:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path != '/' && *path != 0)
80102305:	8b 45 08             	mov    0x8(%ebp),%eax
80102308:	0f b6 00             	movzbl (%eax),%eax
8010230b:	3c 2f                	cmp    $0x2f,%al
8010230d:	74 0a                	je     80102319 <skipelem+0x4a>
8010230f:	8b 45 08             	mov    0x8(%ebp),%eax
80102312:	0f b6 00             	movzbl (%eax),%eax
80102315:	84 c0                	test   %al,%al
80102317:	75 e8                	jne    80102301 <skipelem+0x32>
  len = path - s;
80102319:	8b 55 08             	mov    0x8(%ebp),%edx
8010231c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010231f:	29 c2                	sub    %eax,%edx
80102321:	89 d0                	mov    %edx,%eax
80102323:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
80102326:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
8010232a:	7e 1c                	jle    80102348 <skipelem+0x79>
    memmove(name, s, DIRSIZ);
8010232c:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80102333:	00 
80102334:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102337:	89 44 24 04          	mov    %eax,0x4(%esp)
8010233b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010233e:	89 04 24             	mov    %eax,(%esp)
80102341:	e8 48 30 00 00       	call   8010538e <memmove>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80102346:	eb 2a                	jmp    80102372 <skipelem+0xa3>
    memmove(name, s, len);
80102348:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010234b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010234f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102352:	89 44 24 04          	mov    %eax,0x4(%esp)
80102356:	8b 45 0c             	mov    0xc(%ebp),%eax
80102359:	89 04 24             	mov    %eax,(%esp)
8010235c:	e8 2d 30 00 00       	call   8010538e <memmove>
    name[len] = 0;
80102361:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102364:	8b 45 0c             	mov    0xc(%ebp),%eax
80102367:	01 d0                	add    %edx,%eax
80102369:	c6 00 00             	movb   $0x0,(%eax)
  while(*path == '/')
8010236c:	eb 04                	jmp    80102372 <skipelem+0xa3>
    path++;
8010236e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
80102372:	8b 45 08             	mov    0x8(%ebp),%eax
80102375:	0f b6 00             	movzbl (%eax),%eax
80102378:	3c 2f                	cmp    $0x2f,%al
8010237a:	74 f2                	je     8010236e <skipelem+0x9f>
  return path;
8010237c:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010237f:	c9                   	leave  
80102380:	c3                   	ret    

80102381 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102381:	55                   	push   %ebp
80102382:	89 e5                	mov    %esp,%ebp
80102384:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *next;

  if(*path == '/')
80102387:	8b 45 08             	mov    0x8(%ebp),%eax
8010238a:	0f b6 00             	movzbl (%eax),%eax
8010238d:	3c 2f                	cmp    $0x2f,%al
8010238f:	75 1c                	jne    801023ad <namex+0x2c>
    ip = iget(ROOTDEV, ROOTINO);
80102391:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102398:	00 
80102399:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801023a0:	e8 b1 f4 ff ff       	call   80101856 <iget>
801023a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
801023a8:	e9 ae 00 00 00       	jmp    8010245b <namex+0xda>
    ip = idup(myproc()->cwd);
801023ad:	e8 af 1d 00 00       	call   80104161 <myproc>
801023b2:	8b 40 68             	mov    0x68(%eax),%eax
801023b5:	89 04 24             	mov    %eax,(%esp)
801023b8:	e8 6e f5 ff ff       	call   8010192b <idup>
801023bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while((path = skipelem(path, name)) != 0){
801023c0:	e9 96 00 00 00       	jmp    8010245b <namex+0xda>
    ilock(ip);
801023c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023c8:	89 04 24             	mov    %eax,(%esp)
801023cb:	e8 8d f5 ff ff       	call   8010195d <ilock>
    if(ip->type != T_DIR){
801023d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023d3:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801023d7:	66 83 f8 01          	cmp    $0x1,%ax
801023db:	74 15                	je     801023f2 <namex+0x71>
      iunlockput(ip);
801023dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023e0:	89 04 24             	mov    %eax,(%esp)
801023e3:	e8 77 f7 ff ff       	call   80101b5f <iunlockput>
      return 0;
801023e8:	b8 00 00 00 00       	mov    $0x0,%eax
801023ed:	e9 a3 00 00 00       	jmp    80102495 <namex+0x114>
    }
    if(nameiparent && *path == '\0'){
801023f2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801023f6:	74 1d                	je     80102415 <namex+0x94>
801023f8:	8b 45 08             	mov    0x8(%ebp),%eax
801023fb:	0f b6 00             	movzbl (%eax),%eax
801023fe:	84 c0                	test   %al,%al
80102400:	75 13                	jne    80102415 <namex+0x94>
      // Stop one level early.
      iunlock(ip);
80102402:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102405:	89 04 24             	mov    %eax,(%esp)
80102408:	e8 5d f6 ff ff       	call   80101a6a <iunlock>
      return ip;
8010240d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102410:	e9 80 00 00 00       	jmp    80102495 <namex+0x114>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102415:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010241c:	00 
8010241d:	8b 45 10             	mov    0x10(%ebp),%eax
80102420:	89 44 24 04          	mov    %eax,0x4(%esp)
80102424:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102427:	89 04 24             	mov    %eax,(%esp)
8010242a:	e8 e0 fc ff ff       	call   8010210f <dirlookup>
8010242f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80102432:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102436:	75 12                	jne    8010244a <namex+0xc9>
      iunlockput(ip);
80102438:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010243b:	89 04 24             	mov    %eax,(%esp)
8010243e:	e8 1c f7 ff ff       	call   80101b5f <iunlockput>
      return 0;
80102443:	b8 00 00 00 00       	mov    $0x0,%eax
80102448:	eb 4b                	jmp    80102495 <namex+0x114>
    }
    iunlockput(ip);
8010244a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010244d:	89 04 24             	mov    %eax,(%esp)
80102450:	e8 0a f7 ff ff       	call   80101b5f <iunlockput>
    ip = next;
80102455:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102458:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while((path = skipelem(path, name)) != 0){
8010245b:	8b 45 10             	mov    0x10(%ebp),%eax
8010245e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102462:	8b 45 08             	mov    0x8(%ebp),%eax
80102465:	89 04 24             	mov    %eax,(%esp)
80102468:	e8 62 fe ff ff       	call   801022cf <skipelem>
8010246d:	89 45 08             	mov    %eax,0x8(%ebp)
80102470:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102474:	0f 85 4b ff ff ff    	jne    801023c5 <namex+0x44>
  }
  if(nameiparent){
8010247a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010247e:	74 12                	je     80102492 <namex+0x111>
    iput(ip);
80102480:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102483:	89 04 24             	mov    %eax,(%esp)
80102486:	e8 23 f6 ff ff       	call   80101aae <iput>
    return 0;
8010248b:	b8 00 00 00 00       	mov    $0x0,%eax
80102490:	eb 03                	jmp    80102495 <namex+0x114>
  }
  return ip;
80102492:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102495:	c9                   	leave  
80102496:	c3                   	ret    

80102497 <namei>:

struct inode*
namei(char *path)
{
80102497:	55                   	push   %ebp
80102498:	89 e5                	mov    %esp,%ebp
8010249a:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
8010249d:	8d 45 ea             	lea    -0x16(%ebp),%eax
801024a0:	89 44 24 08          	mov    %eax,0x8(%esp)
801024a4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801024ab:	00 
801024ac:	8b 45 08             	mov    0x8(%ebp),%eax
801024af:	89 04 24             	mov    %eax,(%esp)
801024b2:	e8 ca fe ff ff       	call   80102381 <namex>
}
801024b7:	c9                   	leave  
801024b8:	c3                   	ret    

801024b9 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801024b9:	55                   	push   %ebp
801024ba:	89 e5                	mov    %esp,%ebp
801024bc:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 1, name);
801024bf:	8b 45 0c             	mov    0xc(%ebp),%eax
801024c2:	89 44 24 08          	mov    %eax,0x8(%esp)
801024c6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801024cd:	00 
801024ce:	8b 45 08             	mov    0x8(%ebp),%eax
801024d1:	89 04 24             	mov    %eax,(%esp)
801024d4:	e8 a8 fe ff ff       	call   80102381 <namex>
}
801024d9:	c9                   	leave  
801024da:	c3                   	ret    

801024db <inb>:
{
801024db:	55                   	push   %ebp
801024dc:	89 e5                	mov    %esp,%ebp
801024de:	83 ec 14             	sub    $0x14,%esp
801024e1:	8b 45 08             	mov    0x8(%ebp),%eax
801024e4:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024e8:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801024ec:	89 c2                	mov    %eax,%edx
801024ee:	ec                   	in     (%dx),%al
801024ef:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801024f2:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801024f6:	c9                   	leave  
801024f7:	c3                   	ret    

801024f8 <insl>:
{
801024f8:	55                   	push   %ebp
801024f9:	89 e5                	mov    %esp,%ebp
801024fb:	57                   	push   %edi
801024fc:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
801024fd:	8b 55 08             	mov    0x8(%ebp),%edx
80102500:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102503:	8b 45 10             	mov    0x10(%ebp),%eax
80102506:	89 cb                	mov    %ecx,%ebx
80102508:	89 df                	mov    %ebx,%edi
8010250a:	89 c1                	mov    %eax,%ecx
8010250c:	fc                   	cld    
8010250d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010250f:	89 c8                	mov    %ecx,%eax
80102511:	89 fb                	mov    %edi,%ebx
80102513:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102516:	89 45 10             	mov    %eax,0x10(%ebp)
}
80102519:	5b                   	pop    %ebx
8010251a:	5f                   	pop    %edi
8010251b:	5d                   	pop    %ebp
8010251c:	c3                   	ret    

8010251d <outb>:
{
8010251d:	55                   	push   %ebp
8010251e:	89 e5                	mov    %esp,%ebp
80102520:	83 ec 08             	sub    $0x8,%esp
80102523:	8b 55 08             	mov    0x8(%ebp),%edx
80102526:	8b 45 0c             	mov    0xc(%ebp),%eax
80102529:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010252d:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102530:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102534:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102538:	ee                   	out    %al,(%dx)
}
80102539:	c9                   	leave  
8010253a:	c3                   	ret    

8010253b <outsl>:
{
8010253b:	55                   	push   %ebp
8010253c:	89 e5                	mov    %esp,%ebp
8010253e:	56                   	push   %esi
8010253f:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
80102540:	8b 55 08             	mov    0x8(%ebp),%edx
80102543:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102546:	8b 45 10             	mov    0x10(%ebp),%eax
80102549:	89 cb                	mov    %ecx,%ebx
8010254b:	89 de                	mov    %ebx,%esi
8010254d:	89 c1                	mov    %eax,%ecx
8010254f:	fc                   	cld    
80102550:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80102552:	89 c8                	mov    %ecx,%eax
80102554:	89 f3                	mov    %esi,%ebx
80102556:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102559:	89 45 10             	mov    %eax,0x10(%ebp)
}
8010255c:	5b                   	pop    %ebx
8010255d:	5e                   	pop    %esi
8010255e:	5d                   	pop    %ebp
8010255f:	c3                   	ret    

80102560 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80102560:	55                   	push   %ebp
80102561:	89 e5                	mov    %esp,%ebp
80102563:	83 ec 14             	sub    $0x14,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102566:	90                   	nop
80102567:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
8010256e:	e8 68 ff ff ff       	call   801024db <inb>
80102573:	0f b6 c0             	movzbl %al,%eax
80102576:	89 45 fc             	mov    %eax,-0x4(%ebp)
80102579:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010257c:	25 c0 00 00 00       	and    $0xc0,%eax
80102581:	83 f8 40             	cmp    $0x40,%eax
80102584:	75 e1                	jne    80102567 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102586:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010258a:	74 11                	je     8010259d <idewait+0x3d>
8010258c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010258f:	83 e0 21             	and    $0x21,%eax
80102592:	85 c0                	test   %eax,%eax
80102594:	74 07                	je     8010259d <idewait+0x3d>
    return -1;
80102596:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010259b:	eb 05                	jmp    801025a2 <idewait+0x42>
  return 0;
8010259d:	b8 00 00 00 00       	mov    $0x0,%eax
}
801025a2:	c9                   	leave  
801025a3:	c3                   	ret    

801025a4 <ideinit>:

void
ideinit(void)
{
801025a4:	55                   	push   %ebp
801025a5:	89 e5                	mov    %esp,%ebp
801025a7:	83 ec 28             	sub    $0x28,%esp
  int i;

  initlock(&idelock, "ide");
801025aa:	c7 44 24 04 d7 86 10 	movl   $0x801086d7,0x4(%esp)
801025b1:	80 
801025b2:	c7 04 24 20 b6 10 80 	movl   $0x8010b620,(%esp)
801025b9:	e8 6e 2a 00 00       	call   8010502c <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801025be:	a1 c0 3d 11 80       	mov    0x80113dc0,%eax
801025c3:	83 e8 01             	sub    $0x1,%eax
801025c6:	89 44 24 04          	mov    %eax,0x4(%esp)
801025ca:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
801025d1:	e8 69 04 00 00       	call   80102a3f <ioapicenable>
  idewait(0);
801025d6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801025dd:	e8 7e ff ff ff       	call   80102560 <idewait>

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
801025e2:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
801025e9:	00 
801025ea:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801025f1:	e8 27 ff ff ff       	call   8010251d <outb>
  for(i=0; i<1000; i++){
801025f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801025fd:	eb 20                	jmp    8010261f <ideinit+0x7b>
    if(inb(0x1f7) != 0){
801025ff:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102606:	e8 d0 fe ff ff       	call   801024db <inb>
8010260b:	84 c0                	test   %al,%al
8010260d:	74 0c                	je     8010261b <ideinit+0x77>
      havedisk1 = 1;
8010260f:	c7 05 58 b6 10 80 01 	movl   $0x1,0x8010b658
80102616:	00 00 00 
      break;
80102619:	eb 0d                	jmp    80102628 <ideinit+0x84>
  for(i=0; i<1000; i++){
8010261b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010261f:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
80102626:	7e d7                	jle    801025ff <ideinit+0x5b>
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
80102628:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
8010262f:	00 
80102630:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102637:	e8 e1 fe ff ff       	call   8010251d <outb>
}
8010263c:	c9                   	leave  
8010263d:	c3                   	ret    

8010263e <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
8010263e:	55                   	push   %ebp
8010263f:	89 e5                	mov    %esp,%ebp
80102641:	83 ec 28             	sub    $0x28,%esp
  if(b == 0)
80102644:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102648:	75 0c                	jne    80102656 <idestart+0x18>
    panic("idestart");
8010264a:	c7 04 24 db 86 10 80 	movl   $0x801086db,(%esp)
80102651:	e8 0c df ff ff       	call   80100562 <panic>
  if(b->blockno >= FSSIZE)
80102656:	8b 45 08             	mov    0x8(%ebp),%eax
80102659:	8b 40 08             	mov    0x8(%eax),%eax
8010265c:	3d e7 03 00 00       	cmp    $0x3e7,%eax
80102661:	76 0c                	jbe    8010266f <idestart+0x31>
    panic("incorrect blockno");
80102663:	c7 04 24 e4 86 10 80 	movl   $0x801086e4,(%esp)
8010266a:	e8 f3 de ff ff       	call   80100562 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
8010266f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
80102676:	8b 45 08             	mov    0x8(%ebp),%eax
80102679:	8b 50 08             	mov    0x8(%eax),%edx
8010267c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010267f:	0f af c2             	imul   %edx,%eax
80102682:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
80102685:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
80102689:	75 07                	jne    80102692 <idestart+0x54>
8010268b:	b8 20 00 00 00       	mov    $0x20,%eax
80102690:	eb 05                	jmp    80102697 <idestart+0x59>
80102692:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102697:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;
8010269a:	83 7d f4 01          	cmpl   $0x1,-0xc(%ebp)
8010269e:	75 07                	jne    801026a7 <idestart+0x69>
801026a0:	b8 30 00 00 00       	mov    $0x30,%eax
801026a5:	eb 05                	jmp    801026ac <idestart+0x6e>
801026a7:	b8 c5 00 00 00       	mov    $0xc5,%eax
801026ac:	89 45 e8             	mov    %eax,-0x18(%ebp)

  if (sector_per_block > 7) panic("idestart");
801026af:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
801026b3:	7e 0c                	jle    801026c1 <idestart+0x83>
801026b5:	c7 04 24 db 86 10 80 	movl   $0x801086db,(%esp)
801026bc:	e8 a1 de ff ff       	call   80100562 <panic>

  idewait(0);
801026c1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801026c8:	e8 93 fe ff ff       	call   80102560 <idewait>
  outb(0x3f6, 0);  // generate interrupt
801026cd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801026d4:	00 
801026d5:	c7 04 24 f6 03 00 00 	movl   $0x3f6,(%esp)
801026dc:	e8 3c fe ff ff       	call   8010251d <outb>
  outb(0x1f2, sector_per_block);  // number of sectors
801026e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801026e4:	0f b6 c0             	movzbl %al,%eax
801026e7:	89 44 24 04          	mov    %eax,0x4(%esp)
801026eb:	c7 04 24 f2 01 00 00 	movl   $0x1f2,(%esp)
801026f2:	e8 26 fe ff ff       	call   8010251d <outb>
  outb(0x1f3, sector & 0xff);
801026f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801026fa:	0f b6 c0             	movzbl %al,%eax
801026fd:	89 44 24 04          	mov    %eax,0x4(%esp)
80102701:	c7 04 24 f3 01 00 00 	movl   $0x1f3,(%esp)
80102708:	e8 10 fe ff ff       	call   8010251d <outb>
  outb(0x1f4, (sector >> 8) & 0xff);
8010270d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102710:	c1 f8 08             	sar    $0x8,%eax
80102713:	0f b6 c0             	movzbl %al,%eax
80102716:	89 44 24 04          	mov    %eax,0x4(%esp)
8010271a:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
80102721:	e8 f7 fd ff ff       	call   8010251d <outb>
  outb(0x1f5, (sector >> 16) & 0xff);
80102726:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102729:	c1 f8 10             	sar    $0x10,%eax
8010272c:	0f b6 c0             	movzbl %al,%eax
8010272f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102733:	c7 04 24 f5 01 00 00 	movl   $0x1f5,(%esp)
8010273a:	e8 de fd ff ff       	call   8010251d <outb>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010273f:	8b 45 08             	mov    0x8(%ebp),%eax
80102742:	8b 40 04             	mov    0x4(%eax),%eax
80102745:	83 e0 01             	and    $0x1,%eax
80102748:	c1 e0 04             	shl    $0x4,%eax
8010274b:	89 c2                	mov    %eax,%edx
8010274d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102750:	c1 f8 18             	sar    $0x18,%eax
80102753:	83 e0 0f             	and    $0xf,%eax
80102756:	09 d0                	or     %edx,%eax
80102758:	83 c8 e0             	or     $0xffffffe0,%eax
8010275b:	0f b6 c0             	movzbl %al,%eax
8010275e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102762:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102769:	e8 af fd ff ff       	call   8010251d <outb>
  if(b->flags & B_DIRTY){
8010276e:	8b 45 08             	mov    0x8(%ebp),%eax
80102771:	8b 00                	mov    (%eax),%eax
80102773:	83 e0 04             	and    $0x4,%eax
80102776:	85 c0                	test   %eax,%eax
80102778:	74 36                	je     801027b0 <idestart+0x172>
    outb(0x1f7, write_cmd);
8010277a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010277d:	0f b6 c0             	movzbl %al,%eax
80102780:	89 44 24 04          	mov    %eax,0x4(%esp)
80102784:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
8010278b:	e8 8d fd ff ff       	call   8010251d <outb>
    outsl(0x1f0, b->data, BSIZE/4);
80102790:	8b 45 08             	mov    0x8(%ebp),%eax
80102793:	83 c0 5c             	add    $0x5c,%eax
80102796:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
8010279d:	00 
8010279e:	89 44 24 04          	mov    %eax,0x4(%esp)
801027a2:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
801027a9:	e8 8d fd ff ff       	call   8010253b <outsl>
801027ae:	eb 16                	jmp    801027c6 <idestart+0x188>
  } else {
    outb(0x1f7, read_cmd);
801027b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801027b3:	0f b6 c0             	movzbl %al,%eax
801027b6:	89 44 24 04          	mov    %eax,0x4(%esp)
801027ba:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801027c1:	e8 57 fd ff ff       	call   8010251d <outb>
  }
}
801027c6:	c9                   	leave  
801027c7:	c3                   	ret    

801027c8 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801027c8:	55                   	push   %ebp
801027c9:	89 e5                	mov    %esp,%ebp
801027cb:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801027ce:	c7 04 24 20 b6 10 80 	movl   $0x8010b620,(%esp)
801027d5:	e8 73 28 00 00       	call   8010504d <acquire>

  if((b = idequeue) == 0){
801027da:	a1 54 b6 10 80       	mov    0x8010b654,%eax
801027df:	89 45 f4             	mov    %eax,-0xc(%ebp)
801027e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801027e6:	75 11                	jne    801027f9 <ideintr+0x31>
    release(&idelock);
801027e8:	c7 04 24 20 b6 10 80 	movl   $0x8010b620,(%esp)
801027ef:	e8 c1 28 00 00       	call   801050b5 <release>
    return;
801027f4:	e9 90 00 00 00       	jmp    80102889 <ideintr+0xc1>
  }
  idequeue = b->qnext;
801027f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027fc:	8b 40 58             	mov    0x58(%eax),%eax
801027ff:	a3 54 b6 10 80       	mov    %eax,0x8010b654

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102804:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102807:	8b 00                	mov    (%eax),%eax
80102809:	83 e0 04             	and    $0x4,%eax
8010280c:	85 c0                	test   %eax,%eax
8010280e:	75 2e                	jne    8010283e <ideintr+0x76>
80102810:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102817:	e8 44 fd ff ff       	call   80102560 <idewait>
8010281c:	85 c0                	test   %eax,%eax
8010281e:	78 1e                	js     8010283e <ideintr+0x76>
    insl(0x1f0, b->data, BSIZE/4);
80102820:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102823:	83 c0 5c             	add    $0x5c,%eax
80102826:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
8010282d:	00 
8010282e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102832:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
80102839:	e8 ba fc ff ff       	call   801024f8 <insl>

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010283e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102841:	8b 00                	mov    (%eax),%eax
80102843:	83 c8 02             	or     $0x2,%eax
80102846:	89 c2                	mov    %eax,%edx
80102848:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010284b:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
8010284d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102850:	8b 00                	mov    (%eax),%eax
80102852:	83 e0 fb             	and    $0xfffffffb,%eax
80102855:	89 c2                	mov    %eax,%edx
80102857:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010285a:	89 10                	mov    %edx,(%eax)
  wakeup(b);
8010285c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010285f:	89 04 24             	mov    %eax,(%esp)
80102862:	e8 0c 23 00 00       	call   80104b73 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102867:	a1 54 b6 10 80       	mov    0x8010b654,%eax
8010286c:	85 c0                	test   %eax,%eax
8010286e:	74 0d                	je     8010287d <ideintr+0xb5>
    idestart(idequeue);
80102870:	a1 54 b6 10 80       	mov    0x8010b654,%eax
80102875:	89 04 24             	mov    %eax,(%esp)
80102878:	e8 c1 fd ff ff       	call   8010263e <idestart>

  release(&idelock);
8010287d:	c7 04 24 20 b6 10 80 	movl   $0x8010b620,(%esp)
80102884:	e8 2c 28 00 00       	call   801050b5 <release>
}
80102889:	c9                   	leave  
8010288a:	c3                   	ret    

8010288b <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
8010288b:	55                   	push   %ebp
8010288c:	89 e5                	mov    %esp,%ebp
8010288e:	83 ec 28             	sub    $0x28,%esp
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80102891:	8b 45 08             	mov    0x8(%ebp),%eax
80102894:	83 c0 0c             	add    $0xc,%eax
80102897:	89 04 24             	mov    %eax,(%esp)
8010289a:	e8 01 27 00 00       	call   80104fa0 <holdingsleep>
8010289f:	85 c0                	test   %eax,%eax
801028a1:	75 0c                	jne    801028af <iderw+0x24>
    panic("iderw: buf not locked");
801028a3:	c7 04 24 f6 86 10 80 	movl   $0x801086f6,(%esp)
801028aa:	e8 b3 dc ff ff       	call   80100562 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801028af:	8b 45 08             	mov    0x8(%ebp),%eax
801028b2:	8b 00                	mov    (%eax),%eax
801028b4:	83 e0 06             	and    $0x6,%eax
801028b7:	83 f8 02             	cmp    $0x2,%eax
801028ba:	75 0c                	jne    801028c8 <iderw+0x3d>
    panic("iderw: nothing to do");
801028bc:	c7 04 24 0c 87 10 80 	movl   $0x8010870c,(%esp)
801028c3:	e8 9a dc ff ff       	call   80100562 <panic>
  if(b->dev != 0 && !havedisk1)
801028c8:	8b 45 08             	mov    0x8(%ebp),%eax
801028cb:	8b 40 04             	mov    0x4(%eax),%eax
801028ce:	85 c0                	test   %eax,%eax
801028d0:	74 15                	je     801028e7 <iderw+0x5c>
801028d2:	a1 58 b6 10 80       	mov    0x8010b658,%eax
801028d7:	85 c0                	test   %eax,%eax
801028d9:	75 0c                	jne    801028e7 <iderw+0x5c>
    panic("iderw: ide disk 1 not present");
801028db:	c7 04 24 21 87 10 80 	movl   $0x80108721,(%esp)
801028e2:	e8 7b dc ff ff       	call   80100562 <panic>

  acquire(&idelock);  //DOC:acquire-lock
801028e7:	c7 04 24 20 b6 10 80 	movl   $0x8010b620,(%esp)
801028ee:	e8 5a 27 00 00       	call   8010504d <acquire>

  // Append b to idequeue.
  b->qnext = 0;
801028f3:	8b 45 08             	mov    0x8(%ebp),%eax
801028f6:	c7 40 58 00 00 00 00 	movl   $0x0,0x58(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801028fd:	c7 45 f4 54 b6 10 80 	movl   $0x8010b654,-0xc(%ebp)
80102904:	eb 0b                	jmp    80102911 <iderw+0x86>
80102906:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102909:	8b 00                	mov    (%eax),%eax
8010290b:	83 c0 58             	add    $0x58,%eax
8010290e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102911:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102914:	8b 00                	mov    (%eax),%eax
80102916:	85 c0                	test   %eax,%eax
80102918:	75 ec                	jne    80102906 <iderw+0x7b>
    ;
  *pp = b;
8010291a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010291d:	8b 55 08             	mov    0x8(%ebp),%edx
80102920:	89 10                	mov    %edx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
80102922:	a1 54 b6 10 80       	mov    0x8010b654,%eax
80102927:	3b 45 08             	cmp    0x8(%ebp),%eax
8010292a:	75 0d                	jne    80102939 <iderw+0xae>
    idestart(b);
8010292c:	8b 45 08             	mov    0x8(%ebp),%eax
8010292f:	89 04 24             	mov    %eax,(%esp)
80102932:	e8 07 fd ff ff       	call   8010263e <idestart>

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102937:	eb 15                	jmp    8010294e <iderw+0xc3>
80102939:	eb 13                	jmp    8010294e <iderw+0xc3>
    sleep(b, &idelock);
8010293b:	c7 44 24 04 20 b6 10 	movl   $0x8010b620,0x4(%esp)
80102942:	80 
80102943:	8b 45 08             	mov    0x8(%ebp),%eax
80102946:	89 04 24             	mov    %eax,(%esp)
80102949:	e8 4e 21 00 00       	call   80104a9c <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010294e:	8b 45 08             	mov    0x8(%ebp),%eax
80102951:	8b 00                	mov    (%eax),%eax
80102953:	83 e0 06             	and    $0x6,%eax
80102956:	83 f8 02             	cmp    $0x2,%eax
80102959:	75 e0                	jne    8010293b <iderw+0xb0>
  }


  release(&idelock);
8010295b:	c7 04 24 20 b6 10 80 	movl   $0x8010b620,(%esp)
80102962:	e8 4e 27 00 00       	call   801050b5 <release>
}
80102967:	c9                   	leave  
80102968:	c3                   	ret    

80102969 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102969:	55                   	push   %ebp
8010296a:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
8010296c:	a1 f4 36 11 80       	mov    0x801136f4,%eax
80102971:	8b 55 08             	mov    0x8(%ebp),%edx
80102974:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102976:	a1 f4 36 11 80       	mov    0x801136f4,%eax
8010297b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010297e:	5d                   	pop    %ebp
8010297f:	c3                   	ret    

80102980 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102980:	55                   	push   %ebp
80102981:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102983:	a1 f4 36 11 80       	mov    0x801136f4,%eax
80102988:	8b 55 08             	mov    0x8(%ebp),%edx
8010298b:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
8010298d:	a1 f4 36 11 80       	mov    0x801136f4,%eax
80102992:	8b 55 0c             	mov    0xc(%ebp),%edx
80102995:	89 50 10             	mov    %edx,0x10(%eax)
}
80102998:	5d                   	pop    %ebp
80102999:	c3                   	ret    

8010299a <ioapicinit>:

void
ioapicinit(void)
{
8010299a:	55                   	push   %ebp
8010299b:	89 e5                	mov    %esp,%ebp
8010299d:	83 ec 28             	sub    $0x28,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801029a0:	c7 05 f4 36 11 80 00 	movl   $0xfec00000,0x801136f4
801029a7:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801029aa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801029b1:	e8 b3 ff ff ff       	call   80102969 <ioapicread>
801029b6:	c1 e8 10             	shr    $0x10,%eax
801029b9:	25 ff 00 00 00       	and    $0xff,%eax
801029be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
801029c1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801029c8:	e8 9c ff ff ff       	call   80102969 <ioapicread>
801029cd:	c1 e8 18             	shr    $0x18,%eax
801029d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
801029d3:	0f b6 05 20 38 11 80 	movzbl 0x80113820,%eax
801029da:	0f b6 c0             	movzbl %al,%eax
801029dd:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801029e0:	74 0c                	je     801029ee <ioapicinit+0x54>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801029e2:	c7 04 24 40 87 10 80 	movl   $0x80108740,(%esp)
801029e9:	e8 da d9 ff ff       	call   801003c8 <cprintf>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801029ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801029f5:	eb 3e                	jmp    80102a35 <ioapicinit+0x9b>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801029f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029fa:	83 c0 20             	add    $0x20,%eax
801029fd:	0d 00 00 01 00       	or     $0x10000,%eax
80102a02:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102a05:	83 c2 08             	add    $0x8,%edx
80102a08:	01 d2                	add    %edx,%edx
80102a0a:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a0e:	89 14 24             	mov    %edx,(%esp)
80102a11:	e8 6a ff ff ff       	call   80102980 <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a19:	83 c0 08             	add    $0x8,%eax
80102a1c:	01 c0                	add    %eax,%eax
80102a1e:	83 c0 01             	add    $0x1,%eax
80102a21:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102a28:	00 
80102a29:	89 04 24             	mov    %eax,(%esp)
80102a2c:	e8 4f ff ff ff       	call   80102980 <ioapicwrite>
  for(i = 0; i <= maxintr; i++){
80102a31:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a38:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102a3b:	7e ba                	jle    801029f7 <ioapicinit+0x5d>
  }
}
80102a3d:	c9                   	leave  
80102a3e:	c3                   	ret    

80102a3f <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102a3f:	55                   	push   %ebp
80102a40:	89 e5                	mov    %esp,%ebp
80102a42:	83 ec 08             	sub    $0x8,%esp
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102a45:	8b 45 08             	mov    0x8(%ebp),%eax
80102a48:	83 c0 20             	add    $0x20,%eax
80102a4b:	8b 55 08             	mov    0x8(%ebp),%edx
80102a4e:	83 c2 08             	add    $0x8,%edx
80102a51:	01 d2                	add    %edx,%edx
80102a53:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a57:	89 14 24             	mov    %edx,(%esp)
80102a5a:	e8 21 ff ff ff       	call   80102980 <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102a5f:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a62:	c1 e0 18             	shl    $0x18,%eax
80102a65:	8b 55 08             	mov    0x8(%ebp),%edx
80102a68:	83 c2 08             	add    $0x8,%edx
80102a6b:	01 d2                	add    %edx,%edx
80102a6d:	83 c2 01             	add    $0x1,%edx
80102a70:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a74:	89 14 24             	mov    %edx,(%esp)
80102a77:	e8 04 ff ff ff       	call   80102980 <ioapicwrite>
}
80102a7c:	c9                   	leave  
80102a7d:	c3                   	ret    

80102a7e <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102a7e:	55                   	push   %ebp
80102a7f:	89 e5                	mov    %esp,%ebp
80102a81:	83 ec 18             	sub    $0x18,%esp
  initlock(&kmem.lock, "kmem");
80102a84:	c7 44 24 04 72 87 10 	movl   $0x80108772,0x4(%esp)
80102a8b:	80 
80102a8c:	c7 04 24 00 37 11 80 	movl   $0x80113700,(%esp)
80102a93:	e8 94 25 00 00       	call   8010502c <initlock>
  kmem.use_lock = 0;
80102a98:	c7 05 34 37 11 80 00 	movl   $0x0,0x80113734
80102a9f:	00 00 00 
  freerange(vstart, vend);
80102aa2:	8b 45 0c             	mov    0xc(%ebp),%eax
80102aa5:	89 44 24 04          	mov    %eax,0x4(%esp)
80102aa9:	8b 45 08             	mov    0x8(%ebp),%eax
80102aac:	89 04 24             	mov    %eax,(%esp)
80102aaf:	e8 26 00 00 00       	call   80102ada <freerange>
}
80102ab4:	c9                   	leave  
80102ab5:	c3                   	ret    

80102ab6 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102ab6:	55                   	push   %ebp
80102ab7:	89 e5                	mov    %esp,%ebp
80102ab9:	83 ec 18             	sub    $0x18,%esp
  freerange(vstart, vend);
80102abc:	8b 45 0c             	mov    0xc(%ebp),%eax
80102abf:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ac3:	8b 45 08             	mov    0x8(%ebp),%eax
80102ac6:	89 04 24             	mov    %eax,(%esp)
80102ac9:	e8 0c 00 00 00       	call   80102ada <freerange>
  kmem.use_lock = 1;
80102ace:	c7 05 34 37 11 80 01 	movl   $0x1,0x80113734
80102ad5:	00 00 00 
}
80102ad8:	c9                   	leave  
80102ad9:	c3                   	ret    

80102ada <freerange>:

void
freerange(void *vstart, void *vend)
{
80102ada:	55                   	push   %ebp
80102adb:	89 e5                	mov    %esp,%ebp
80102add:	83 ec 28             	sub    $0x28,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102ae0:	8b 45 08             	mov    0x8(%ebp),%eax
80102ae3:	05 ff 0f 00 00       	add    $0xfff,%eax
80102ae8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102aed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102af0:	eb 12                	jmp    80102b04 <freerange+0x2a>
    kfree(p);
80102af2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102af5:	89 04 24             	mov    %eax,(%esp)
80102af8:	e8 16 00 00 00       	call   80102b13 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102afd:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b07:	05 00 10 00 00       	add    $0x1000,%eax
80102b0c:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102b0f:	76 e1                	jbe    80102af2 <freerange+0x18>
}
80102b11:	c9                   	leave  
80102b12:	c3                   	ret    

80102b13 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102b13:	55                   	push   %ebp
80102b14:	89 e5                	mov    %esp,%ebp
80102b16:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102b19:	8b 45 08             	mov    0x8(%ebp),%eax
80102b1c:	25 ff 0f 00 00       	and    $0xfff,%eax
80102b21:	85 c0                	test   %eax,%eax
80102b23:	75 18                	jne    80102b3d <kfree+0x2a>
80102b25:	81 7d 08 68 67 11 80 	cmpl   $0x80116768,0x8(%ebp)
80102b2c:	72 0f                	jb     80102b3d <kfree+0x2a>
80102b2e:	8b 45 08             	mov    0x8(%ebp),%eax
80102b31:	05 00 00 00 80       	add    $0x80000000,%eax
80102b36:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102b3b:	76 0c                	jbe    80102b49 <kfree+0x36>
    panic("kfree");
80102b3d:	c7 04 24 77 87 10 80 	movl   $0x80108777,(%esp)
80102b44:	e8 19 da ff ff       	call   80100562 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102b49:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102b50:	00 
80102b51:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102b58:	00 
80102b59:	8b 45 08             	mov    0x8(%ebp),%eax
80102b5c:	89 04 24             	mov    %eax,(%esp)
80102b5f:	e8 5b 27 00 00       	call   801052bf <memset>

  if(kmem.use_lock)
80102b64:	a1 34 37 11 80       	mov    0x80113734,%eax
80102b69:	85 c0                	test   %eax,%eax
80102b6b:	74 0c                	je     80102b79 <kfree+0x66>
    acquire(&kmem.lock);
80102b6d:	c7 04 24 00 37 11 80 	movl   $0x80113700,(%esp)
80102b74:	e8 d4 24 00 00       	call   8010504d <acquire>
  r = (struct run*)v;
80102b79:	8b 45 08             	mov    0x8(%ebp),%eax
80102b7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102b7f:	8b 15 38 37 11 80    	mov    0x80113738,%edx
80102b85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b88:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102b8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b8d:	a3 38 37 11 80       	mov    %eax,0x80113738
  if(kmem.use_lock)
80102b92:	a1 34 37 11 80       	mov    0x80113734,%eax
80102b97:	85 c0                	test   %eax,%eax
80102b99:	74 0c                	je     80102ba7 <kfree+0x94>
    release(&kmem.lock);
80102b9b:	c7 04 24 00 37 11 80 	movl   $0x80113700,(%esp)
80102ba2:	e8 0e 25 00 00       	call   801050b5 <release>
}
80102ba7:	c9                   	leave  
80102ba8:	c3                   	ret    

80102ba9 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102ba9:	55                   	push   %ebp
80102baa:	89 e5                	mov    %esp,%ebp
80102bac:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if(kmem.use_lock)
80102baf:	a1 34 37 11 80       	mov    0x80113734,%eax
80102bb4:	85 c0                	test   %eax,%eax
80102bb6:	74 0c                	je     80102bc4 <kalloc+0x1b>
    acquire(&kmem.lock);
80102bb8:	c7 04 24 00 37 11 80 	movl   $0x80113700,(%esp)
80102bbf:	e8 89 24 00 00       	call   8010504d <acquire>
  r = kmem.freelist;
80102bc4:	a1 38 37 11 80       	mov    0x80113738,%eax
80102bc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102bcc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102bd0:	74 0a                	je     80102bdc <kalloc+0x33>
    kmem.freelist = r->next;
80102bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bd5:	8b 00                	mov    (%eax),%eax
80102bd7:	a3 38 37 11 80       	mov    %eax,0x80113738
  if(kmem.use_lock)
80102bdc:	a1 34 37 11 80       	mov    0x80113734,%eax
80102be1:	85 c0                	test   %eax,%eax
80102be3:	74 0c                	je     80102bf1 <kalloc+0x48>
    release(&kmem.lock);
80102be5:	c7 04 24 00 37 11 80 	movl   $0x80113700,(%esp)
80102bec:	e8 c4 24 00 00       	call   801050b5 <release>
  return (char*)r;
80102bf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102bf4:	c9                   	leave  
80102bf5:	c3                   	ret    

80102bf6 <inb>:
{
80102bf6:	55                   	push   %ebp
80102bf7:	89 e5                	mov    %esp,%ebp
80102bf9:	83 ec 14             	sub    $0x14,%esp
80102bfc:	8b 45 08             	mov    0x8(%ebp),%eax
80102bff:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c03:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102c07:	89 c2                	mov    %eax,%edx
80102c09:	ec                   	in     (%dx),%al
80102c0a:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102c0d:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102c11:	c9                   	leave  
80102c12:	c3                   	ret    

80102c13 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102c13:	55                   	push   %ebp
80102c14:	89 e5                	mov    %esp,%ebp
80102c16:	83 ec 14             	sub    $0x14,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102c19:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102c20:	e8 d1 ff ff ff       	call   80102bf6 <inb>
80102c25:	0f b6 c0             	movzbl %al,%eax
80102c28:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c2e:	83 e0 01             	and    $0x1,%eax
80102c31:	85 c0                	test   %eax,%eax
80102c33:	75 0a                	jne    80102c3f <kbdgetc+0x2c>
    return -1;
80102c35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102c3a:	e9 25 01 00 00       	jmp    80102d64 <kbdgetc+0x151>
  data = inb(KBDATAP);
80102c3f:	c7 04 24 60 00 00 00 	movl   $0x60,(%esp)
80102c46:	e8 ab ff ff ff       	call   80102bf6 <inb>
80102c4b:	0f b6 c0             	movzbl %al,%eax
80102c4e:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102c51:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102c58:	75 17                	jne    80102c71 <kbdgetc+0x5e>
    shift |= E0ESC;
80102c5a:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102c5f:	83 c8 40             	or     $0x40,%eax
80102c62:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
    return 0;
80102c67:	b8 00 00 00 00       	mov    $0x0,%eax
80102c6c:	e9 f3 00 00 00       	jmp    80102d64 <kbdgetc+0x151>
  } else if(data & 0x80){
80102c71:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c74:	25 80 00 00 00       	and    $0x80,%eax
80102c79:	85 c0                	test   %eax,%eax
80102c7b:	74 45                	je     80102cc2 <kbdgetc+0xaf>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102c7d:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102c82:	83 e0 40             	and    $0x40,%eax
80102c85:	85 c0                	test   %eax,%eax
80102c87:	75 08                	jne    80102c91 <kbdgetc+0x7e>
80102c89:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c8c:	83 e0 7f             	and    $0x7f,%eax
80102c8f:	eb 03                	jmp    80102c94 <kbdgetc+0x81>
80102c91:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c94:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102c97:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c9a:	05 20 90 10 80       	add    $0x80109020,%eax
80102c9f:	0f b6 00             	movzbl (%eax),%eax
80102ca2:	83 c8 40             	or     $0x40,%eax
80102ca5:	0f b6 c0             	movzbl %al,%eax
80102ca8:	f7 d0                	not    %eax
80102caa:	89 c2                	mov    %eax,%edx
80102cac:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102cb1:	21 d0                	and    %edx,%eax
80102cb3:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
    return 0;
80102cb8:	b8 00 00 00 00       	mov    $0x0,%eax
80102cbd:	e9 a2 00 00 00       	jmp    80102d64 <kbdgetc+0x151>
  } else if(shift & E0ESC){
80102cc2:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102cc7:	83 e0 40             	and    $0x40,%eax
80102cca:	85 c0                	test   %eax,%eax
80102ccc:	74 14                	je     80102ce2 <kbdgetc+0xcf>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102cce:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102cd5:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102cda:	83 e0 bf             	and    $0xffffffbf,%eax
80102cdd:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
  }

  shift |= shiftcode[data];
80102ce2:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102ce5:	05 20 90 10 80       	add    $0x80109020,%eax
80102cea:	0f b6 00             	movzbl (%eax),%eax
80102ced:	0f b6 d0             	movzbl %al,%edx
80102cf0:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102cf5:	09 d0                	or     %edx,%eax
80102cf7:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
  shift ^= togglecode[data];
80102cfc:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102cff:	05 20 91 10 80       	add    $0x80109120,%eax
80102d04:	0f b6 00             	movzbl (%eax),%eax
80102d07:	0f b6 d0             	movzbl %al,%edx
80102d0a:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102d0f:	31 d0                	xor    %edx,%eax
80102d11:	a3 5c b6 10 80       	mov    %eax,0x8010b65c
  c = charcode[shift & (CTL | SHIFT)][data];
80102d16:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102d1b:	83 e0 03             	and    $0x3,%eax
80102d1e:	8b 14 85 20 95 10 80 	mov    -0x7fef6ae0(,%eax,4),%edx
80102d25:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d28:	01 d0                	add    %edx,%eax
80102d2a:	0f b6 00             	movzbl (%eax),%eax
80102d2d:	0f b6 c0             	movzbl %al,%eax
80102d30:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102d33:	a1 5c b6 10 80       	mov    0x8010b65c,%eax
80102d38:	83 e0 08             	and    $0x8,%eax
80102d3b:	85 c0                	test   %eax,%eax
80102d3d:	74 22                	je     80102d61 <kbdgetc+0x14e>
    if('a' <= c && c <= 'z')
80102d3f:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102d43:	76 0c                	jbe    80102d51 <kbdgetc+0x13e>
80102d45:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102d49:	77 06                	ja     80102d51 <kbdgetc+0x13e>
      c += 'A' - 'a';
80102d4b:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102d4f:	eb 10                	jmp    80102d61 <kbdgetc+0x14e>
    else if('A' <= c && c <= 'Z')
80102d51:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102d55:	76 0a                	jbe    80102d61 <kbdgetc+0x14e>
80102d57:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102d5b:	77 04                	ja     80102d61 <kbdgetc+0x14e>
      c += 'a' - 'A';
80102d5d:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102d61:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102d64:	c9                   	leave  
80102d65:	c3                   	ret    

80102d66 <kbdintr>:

void
kbdintr(void)
{
80102d66:	55                   	push   %ebp
80102d67:	89 e5                	mov    %esp,%ebp
80102d69:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102d6c:	c7 04 24 13 2c 10 80 	movl   $0x80102c13,(%esp)
80102d73:	e8 71 da ff ff       	call   801007e9 <consoleintr>
}
80102d78:	c9                   	leave  
80102d79:	c3                   	ret    

80102d7a <inb>:
{
80102d7a:	55                   	push   %ebp
80102d7b:	89 e5                	mov    %esp,%ebp
80102d7d:	83 ec 14             	sub    $0x14,%esp
80102d80:	8b 45 08             	mov    0x8(%ebp),%eax
80102d83:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d87:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102d8b:	89 c2                	mov    %eax,%edx
80102d8d:	ec                   	in     (%dx),%al
80102d8e:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102d91:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102d95:	c9                   	leave  
80102d96:	c3                   	ret    

80102d97 <outb>:
{
80102d97:	55                   	push   %ebp
80102d98:	89 e5                	mov    %esp,%ebp
80102d9a:	83 ec 08             	sub    $0x8,%esp
80102d9d:	8b 55 08             	mov    0x8(%ebp),%edx
80102da0:	8b 45 0c             	mov    0xc(%ebp),%eax
80102da3:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102da7:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102daa:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102dae:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102db2:	ee                   	out    %al,(%dx)
}
80102db3:	c9                   	leave  
80102db4:	c3                   	ret    

80102db5 <lapicw>:
volatile uint *lapic;  // Initialized in mp.c

//PAGEBREAK!
static void
lapicw(int index, int value)
{
80102db5:	55                   	push   %ebp
80102db6:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102db8:	a1 3c 37 11 80       	mov    0x8011373c,%eax
80102dbd:	8b 55 08             	mov    0x8(%ebp),%edx
80102dc0:	c1 e2 02             	shl    $0x2,%edx
80102dc3:	01 c2                	add    %eax,%edx
80102dc5:	8b 45 0c             	mov    0xc(%ebp),%eax
80102dc8:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102dca:	a1 3c 37 11 80       	mov    0x8011373c,%eax
80102dcf:	83 c0 20             	add    $0x20,%eax
80102dd2:	8b 00                	mov    (%eax),%eax
}
80102dd4:	5d                   	pop    %ebp
80102dd5:	c3                   	ret    

80102dd6 <lapicinit>:

void
lapicinit(void)
{
80102dd6:	55                   	push   %ebp
80102dd7:	89 e5                	mov    %esp,%ebp
80102dd9:	83 ec 08             	sub    $0x8,%esp
  if(!lapic)
80102ddc:	a1 3c 37 11 80       	mov    0x8011373c,%eax
80102de1:	85 c0                	test   %eax,%eax
80102de3:	75 05                	jne    80102dea <lapicinit+0x14>
    return;
80102de5:	e9 43 01 00 00       	jmp    80102f2d <lapicinit+0x157>

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102dea:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
80102df1:	00 
80102df2:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
80102df9:	e8 b7 ff ff ff       	call   80102db5 <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102dfe:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
80102e05:	00 
80102e06:	c7 04 24 f8 00 00 00 	movl   $0xf8,(%esp)
80102e0d:	e8 a3 ff ff ff       	call   80102db5 <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102e12:	c7 44 24 04 20 00 02 	movl   $0x20020,0x4(%esp)
80102e19:	00 
80102e1a:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102e21:	e8 8f ff ff ff       	call   80102db5 <lapicw>
  lapicw(TICR, 10000000);
80102e26:	c7 44 24 04 80 96 98 	movl   $0x989680,0x4(%esp)
80102e2d:	00 
80102e2e:	c7 04 24 e0 00 00 00 	movl   $0xe0,(%esp)
80102e35:	e8 7b ff ff ff       	call   80102db5 <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102e3a:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102e41:	00 
80102e42:	c7 04 24 d4 00 00 00 	movl   $0xd4,(%esp)
80102e49:	e8 67 ff ff ff       	call   80102db5 <lapicw>
  lapicw(LINT1, MASKED);
80102e4e:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102e55:	00 
80102e56:	c7 04 24 d8 00 00 00 	movl   $0xd8,(%esp)
80102e5d:	e8 53 ff ff ff       	call   80102db5 <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102e62:	a1 3c 37 11 80       	mov    0x8011373c,%eax
80102e67:	83 c0 30             	add    $0x30,%eax
80102e6a:	8b 00                	mov    (%eax),%eax
80102e6c:	c1 e8 10             	shr    $0x10,%eax
80102e6f:	0f b6 c0             	movzbl %al,%eax
80102e72:	83 f8 03             	cmp    $0x3,%eax
80102e75:	76 14                	jbe    80102e8b <lapicinit+0xb5>
    lapicw(PCINT, MASKED);
80102e77:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102e7e:	00 
80102e7f:	c7 04 24 d0 00 00 00 	movl   $0xd0,(%esp)
80102e86:	e8 2a ff ff ff       	call   80102db5 <lapicw>

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102e8b:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
80102e92:	00 
80102e93:	c7 04 24 dc 00 00 00 	movl   $0xdc,(%esp)
80102e9a:	e8 16 ff ff ff       	call   80102db5 <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102e9f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102ea6:	00 
80102ea7:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102eae:	e8 02 ff ff ff       	call   80102db5 <lapicw>
  lapicw(ESR, 0);
80102eb3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102eba:	00 
80102ebb:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102ec2:	e8 ee fe ff ff       	call   80102db5 <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102ec7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102ece:	00 
80102ecf:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102ed6:	e8 da fe ff ff       	call   80102db5 <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102edb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102ee2:	00 
80102ee3:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102eea:	e8 c6 fe ff ff       	call   80102db5 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102eef:	c7 44 24 04 00 85 08 	movl   $0x88500,0x4(%esp)
80102ef6:	00 
80102ef7:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102efe:	e8 b2 fe ff ff       	call   80102db5 <lapicw>
  while(lapic[ICRLO] & DELIVS)
80102f03:	90                   	nop
80102f04:	a1 3c 37 11 80       	mov    0x8011373c,%eax
80102f09:	05 00 03 00 00       	add    $0x300,%eax
80102f0e:	8b 00                	mov    (%eax),%eax
80102f10:	25 00 10 00 00       	and    $0x1000,%eax
80102f15:	85 c0                	test   %eax,%eax
80102f17:	75 eb                	jne    80102f04 <lapicinit+0x12e>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102f19:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102f20:	00 
80102f21:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80102f28:	e8 88 fe ff ff       	call   80102db5 <lapicw>
}
80102f2d:	c9                   	leave  
80102f2e:	c3                   	ret    

80102f2f <lapicid>:

int
lapicid(void)
{
80102f2f:	55                   	push   %ebp
80102f30:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102f32:	a1 3c 37 11 80       	mov    0x8011373c,%eax
80102f37:	85 c0                	test   %eax,%eax
80102f39:	75 07                	jne    80102f42 <lapicid+0x13>
    return 0;
80102f3b:	b8 00 00 00 00       	mov    $0x0,%eax
80102f40:	eb 0d                	jmp    80102f4f <lapicid+0x20>
  return lapic[ID] >> 24;
80102f42:	a1 3c 37 11 80       	mov    0x8011373c,%eax
80102f47:	83 c0 20             	add    $0x20,%eax
80102f4a:	8b 00                	mov    (%eax),%eax
80102f4c:	c1 e8 18             	shr    $0x18,%eax
}
80102f4f:	5d                   	pop    %ebp
80102f50:	c3                   	ret    

80102f51 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102f51:	55                   	push   %ebp
80102f52:	89 e5                	mov    %esp,%ebp
80102f54:	83 ec 08             	sub    $0x8,%esp
  if(lapic)
80102f57:	a1 3c 37 11 80       	mov    0x8011373c,%eax
80102f5c:	85 c0                	test   %eax,%eax
80102f5e:	74 14                	je     80102f74 <lapiceoi+0x23>
    lapicw(EOI, 0);
80102f60:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102f67:	00 
80102f68:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102f6f:	e8 41 fe ff ff       	call   80102db5 <lapicw>
}
80102f74:	c9                   	leave  
80102f75:	c3                   	ret    

80102f76 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102f76:	55                   	push   %ebp
80102f77:	89 e5                	mov    %esp,%ebp
}
80102f79:	5d                   	pop    %ebp
80102f7a:	c3                   	ret    

80102f7b <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102f7b:	55                   	push   %ebp
80102f7c:	89 e5                	mov    %esp,%ebp
80102f7e:	83 ec 1c             	sub    $0x1c,%esp
80102f81:	8b 45 08             	mov    0x8(%ebp),%eax
80102f84:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;

  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
80102f87:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80102f8e:	00 
80102f8f:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
80102f96:	e8 fc fd ff ff       	call   80102d97 <outb>
  outb(CMOS_PORT+1, 0x0A);
80102f9b:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80102fa2:	00 
80102fa3:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80102faa:	e8 e8 fd ff ff       	call   80102d97 <outb>
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80102faf:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80102fb6:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102fb9:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80102fbe:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102fc1:	8d 50 02             	lea    0x2(%eax),%edx
80102fc4:	8b 45 0c             	mov    0xc(%ebp),%eax
80102fc7:	c1 e8 04             	shr    $0x4,%eax
80102fca:	66 89 02             	mov    %ax,(%edx)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102fcd:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102fd1:	c1 e0 18             	shl    $0x18,%eax
80102fd4:	89 44 24 04          	mov    %eax,0x4(%esp)
80102fd8:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102fdf:	e8 d1 fd ff ff       	call   80102db5 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80102fe4:	c7 44 24 04 00 c5 00 	movl   $0xc500,0x4(%esp)
80102feb:	00 
80102fec:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102ff3:	e8 bd fd ff ff       	call   80102db5 <lapicw>
  microdelay(200);
80102ff8:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102fff:	e8 72 ff ff ff       	call   80102f76 <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
80103004:	c7 44 24 04 00 85 00 	movl   $0x8500,0x4(%esp)
8010300b:	00 
8010300c:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80103013:	e8 9d fd ff ff       	call   80102db5 <lapicw>
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80103018:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
8010301f:	e8 52 ff ff ff       	call   80102f76 <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103024:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010302b:	eb 40                	jmp    8010306d <lapicstartap+0xf2>
    lapicw(ICRHI, apicid<<24);
8010302d:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103031:	c1 e0 18             	shl    $0x18,%eax
80103034:	89 44 24 04          	mov    %eax,0x4(%esp)
80103038:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
8010303f:	e8 71 fd ff ff       	call   80102db5 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
80103044:	8b 45 0c             	mov    0xc(%ebp),%eax
80103047:	c1 e8 0c             	shr    $0xc,%eax
8010304a:	80 cc 06             	or     $0x6,%ah
8010304d:	89 44 24 04          	mov    %eax,0x4(%esp)
80103051:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80103058:	e8 58 fd ff ff       	call   80102db5 <lapicw>
    microdelay(200);
8010305d:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80103064:	e8 0d ff ff ff       	call   80102f76 <microdelay>
  for(i = 0; i < 2; i++){
80103069:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010306d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80103071:	7e ba                	jle    8010302d <lapicstartap+0xb2>
  }
}
80103073:	c9                   	leave  
80103074:	c3                   	ret    

80103075 <cmos_read>:
#define MONTH   0x08
#define YEAR    0x09

static uint
cmos_read(uint reg)
{
80103075:	55                   	push   %ebp
80103076:	89 e5                	mov    %esp,%ebp
80103078:	83 ec 08             	sub    $0x8,%esp
  outb(CMOS_PORT,  reg);
8010307b:	8b 45 08             	mov    0x8(%ebp),%eax
8010307e:	0f b6 c0             	movzbl %al,%eax
80103081:	89 44 24 04          	mov    %eax,0x4(%esp)
80103085:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
8010308c:	e8 06 fd ff ff       	call   80102d97 <outb>
  microdelay(200);
80103091:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80103098:	e8 d9 fe ff ff       	call   80102f76 <microdelay>

  return inb(CMOS_RETURN);
8010309d:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
801030a4:	e8 d1 fc ff ff       	call   80102d7a <inb>
801030a9:	0f b6 c0             	movzbl %al,%eax
}
801030ac:	c9                   	leave  
801030ad:	c3                   	ret    

801030ae <fill_rtcdate>:

static void
fill_rtcdate(struct rtcdate *r)
{
801030ae:	55                   	push   %ebp
801030af:	89 e5                	mov    %esp,%ebp
801030b1:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
801030b4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801030bb:	e8 b5 ff ff ff       	call   80103075 <cmos_read>
801030c0:	8b 55 08             	mov    0x8(%ebp),%edx
801030c3:	89 02                	mov    %eax,(%edx)
  r->minute = cmos_read(MINS);
801030c5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801030cc:	e8 a4 ff ff ff       	call   80103075 <cmos_read>
801030d1:	8b 55 08             	mov    0x8(%ebp),%edx
801030d4:	89 42 04             	mov    %eax,0x4(%edx)
  r->hour   = cmos_read(HOURS);
801030d7:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
801030de:	e8 92 ff ff ff       	call   80103075 <cmos_read>
801030e3:	8b 55 08             	mov    0x8(%ebp),%edx
801030e6:	89 42 08             	mov    %eax,0x8(%edx)
  r->day    = cmos_read(DAY);
801030e9:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
801030f0:	e8 80 ff ff ff       	call   80103075 <cmos_read>
801030f5:	8b 55 08             	mov    0x8(%ebp),%edx
801030f8:	89 42 0c             	mov    %eax,0xc(%edx)
  r->month  = cmos_read(MONTH);
801030fb:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80103102:	e8 6e ff ff ff       	call   80103075 <cmos_read>
80103107:	8b 55 08             	mov    0x8(%ebp),%edx
8010310a:	89 42 10             	mov    %eax,0x10(%edx)
  r->year   = cmos_read(YEAR);
8010310d:	c7 04 24 09 00 00 00 	movl   $0x9,(%esp)
80103114:	e8 5c ff ff ff       	call   80103075 <cmos_read>
80103119:	8b 55 08             	mov    0x8(%ebp),%edx
8010311c:	89 42 14             	mov    %eax,0x14(%edx)
}
8010311f:	c9                   	leave  
80103120:	c3                   	ret    

80103121 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80103121:	55                   	push   %ebp
80103122:	89 e5                	mov    %esp,%ebp
80103124:	83 ec 58             	sub    $0x58,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
80103127:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
8010312e:	e8 42 ff ff ff       	call   80103075 <cmos_read>
80103133:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
80103136:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103139:	83 e0 04             	and    $0x4,%eax
8010313c:	85 c0                	test   %eax,%eax
8010313e:	0f 94 c0             	sete   %al
80103141:	0f b6 c0             	movzbl %al,%eax
80103144:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
80103147:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010314a:	89 04 24             	mov    %eax,(%esp)
8010314d:	e8 5c ff ff ff       	call   801030ae <fill_rtcdate>
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80103152:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80103159:	e8 17 ff ff ff       	call   80103075 <cmos_read>
8010315e:	25 80 00 00 00       	and    $0x80,%eax
80103163:	85 c0                	test   %eax,%eax
80103165:	74 02                	je     80103169 <cmostime+0x48>
        continue;
80103167:	eb 36                	jmp    8010319f <cmostime+0x7e>
    fill_rtcdate(&t2);
80103169:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010316c:	89 04 24             	mov    %eax,(%esp)
8010316f:	e8 3a ff ff ff       	call   801030ae <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103174:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
8010317b:	00 
8010317c:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010317f:	89 44 24 04          	mov    %eax,0x4(%esp)
80103183:	8d 45 d8             	lea    -0x28(%ebp),%eax
80103186:	89 04 24             	mov    %eax,(%esp)
80103189:	e8 a8 21 00 00       	call   80105336 <memcmp>
8010318e:	85 c0                	test   %eax,%eax
80103190:	75 0d                	jne    8010319f <cmostime+0x7e>
      break;
80103192:	90                   	nop
  }

  // convert
  if(bcd) {
80103193:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103197:	0f 84 ac 00 00 00    	je     80103249 <cmostime+0x128>
8010319d:	eb 02                	jmp    801031a1 <cmostime+0x80>
  }
8010319f:	eb a6                	jmp    80103147 <cmostime+0x26>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801031a1:	8b 45 d8             	mov    -0x28(%ebp),%eax
801031a4:	c1 e8 04             	shr    $0x4,%eax
801031a7:	89 c2                	mov    %eax,%edx
801031a9:	89 d0                	mov    %edx,%eax
801031ab:	c1 e0 02             	shl    $0x2,%eax
801031ae:	01 d0                	add    %edx,%eax
801031b0:	01 c0                	add    %eax,%eax
801031b2:	8b 55 d8             	mov    -0x28(%ebp),%edx
801031b5:	83 e2 0f             	and    $0xf,%edx
801031b8:	01 d0                	add    %edx,%eax
801031ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
801031bd:	8b 45 dc             	mov    -0x24(%ebp),%eax
801031c0:	c1 e8 04             	shr    $0x4,%eax
801031c3:	89 c2                	mov    %eax,%edx
801031c5:	89 d0                	mov    %edx,%eax
801031c7:	c1 e0 02             	shl    $0x2,%eax
801031ca:	01 d0                	add    %edx,%eax
801031cc:	01 c0                	add    %eax,%eax
801031ce:	8b 55 dc             	mov    -0x24(%ebp),%edx
801031d1:	83 e2 0f             	and    $0xf,%edx
801031d4:	01 d0                	add    %edx,%eax
801031d6:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
801031d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801031dc:	c1 e8 04             	shr    $0x4,%eax
801031df:	89 c2                	mov    %eax,%edx
801031e1:	89 d0                	mov    %edx,%eax
801031e3:	c1 e0 02             	shl    $0x2,%eax
801031e6:	01 d0                	add    %edx,%eax
801031e8:	01 c0                	add    %eax,%eax
801031ea:	8b 55 e0             	mov    -0x20(%ebp),%edx
801031ed:	83 e2 0f             	and    $0xf,%edx
801031f0:	01 d0                	add    %edx,%eax
801031f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
801031f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801031f8:	c1 e8 04             	shr    $0x4,%eax
801031fb:	89 c2                	mov    %eax,%edx
801031fd:	89 d0                	mov    %edx,%eax
801031ff:	c1 e0 02             	shl    $0x2,%eax
80103202:	01 d0                	add    %edx,%eax
80103204:	01 c0                	add    %eax,%eax
80103206:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103209:	83 e2 0f             	and    $0xf,%edx
8010320c:	01 d0                	add    %edx,%eax
8010320e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
80103211:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103214:	c1 e8 04             	shr    $0x4,%eax
80103217:	89 c2                	mov    %eax,%edx
80103219:	89 d0                	mov    %edx,%eax
8010321b:	c1 e0 02             	shl    $0x2,%eax
8010321e:	01 d0                	add    %edx,%eax
80103220:	01 c0                	add    %eax,%eax
80103222:	8b 55 e8             	mov    -0x18(%ebp),%edx
80103225:	83 e2 0f             	and    $0xf,%edx
80103228:	01 d0                	add    %edx,%eax
8010322a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
8010322d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103230:	c1 e8 04             	shr    $0x4,%eax
80103233:	89 c2                	mov    %eax,%edx
80103235:	89 d0                	mov    %edx,%eax
80103237:	c1 e0 02             	shl    $0x2,%eax
8010323a:	01 d0                	add    %edx,%eax
8010323c:	01 c0                	add    %eax,%eax
8010323e:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103241:	83 e2 0f             	and    $0xf,%edx
80103244:	01 d0                	add    %edx,%eax
80103246:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
80103249:	8b 45 08             	mov    0x8(%ebp),%eax
8010324c:	8b 55 d8             	mov    -0x28(%ebp),%edx
8010324f:	89 10                	mov    %edx,(%eax)
80103251:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103254:	89 50 04             	mov    %edx,0x4(%eax)
80103257:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010325a:	89 50 08             	mov    %edx,0x8(%eax)
8010325d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103260:	89 50 0c             	mov    %edx,0xc(%eax)
80103263:	8b 55 e8             	mov    -0x18(%ebp),%edx
80103266:	89 50 10             	mov    %edx,0x10(%eax)
80103269:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010326c:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
8010326f:	8b 45 08             	mov    0x8(%ebp),%eax
80103272:	8b 40 14             	mov    0x14(%eax),%eax
80103275:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
8010327b:	8b 45 08             	mov    0x8(%ebp),%eax
8010327e:	89 50 14             	mov    %edx,0x14(%eax)
}
80103281:	c9                   	leave  
80103282:	c3                   	ret    

80103283 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80103283:	55                   	push   %ebp
80103284:	89 e5                	mov    %esp,%ebp
80103286:	83 ec 38             	sub    $0x38,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80103289:	c7 44 24 04 7d 87 10 	movl   $0x8010877d,0x4(%esp)
80103290:	80 
80103291:	c7 04 24 40 37 11 80 	movl   $0x80113740,(%esp)
80103298:	e8 8f 1d 00 00       	call   8010502c <initlock>
  readsb(dev, &sb);
8010329d:	8d 45 dc             	lea    -0x24(%ebp),%eax
801032a0:	89 44 24 04          	mov    %eax,0x4(%esp)
801032a4:	8b 45 08             	mov    0x8(%ebp),%eax
801032a7:	89 04 24             	mov    %eax,(%esp)
801032aa:	e8 a1 e0 ff ff       	call   80101350 <readsb>
  log.start = sb.logstart;
801032af:	8b 45 ec             	mov    -0x14(%ebp),%eax
801032b2:	a3 74 37 11 80       	mov    %eax,0x80113774
  log.size = sb.nlog;
801032b7:	8b 45 e8             	mov    -0x18(%ebp),%eax
801032ba:	a3 78 37 11 80       	mov    %eax,0x80113778
  log.dev = dev;
801032bf:	8b 45 08             	mov    0x8(%ebp),%eax
801032c2:	a3 84 37 11 80       	mov    %eax,0x80113784
  recover_from_log();
801032c7:	e8 9a 01 00 00       	call   80103466 <recover_from_log>
}
801032cc:	c9                   	leave  
801032cd:	c3                   	ret    

801032ce <install_trans>:

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
801032ce:	55                   	push   %ebp
801032cf:	89 e5                	mov    %esp,%ebp
801032d1:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801032d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801032db:	e9 8c 00 00 00       	jmp    8010336c <install_trans+0x9e>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801032e0:	8b 15 74 37 11 80    	mov    0x80113774,%edx
801032e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801032e9:	01 d0                	add    %edx,%eax
801032eb:	83 c0 01             	add    $0x1,%eax
801032ee:	89 c2                	mov    %eax,%edx
801032f0:	a1 84 37 11 80       	mov    0x80113784,%eax
801032f5:	89 54 24 04          	mov    %edx,0x4(%esp)
801032f9:	89 04 24             	mov    %eax,(%esp)
801032fc:	e8 b4 ce ff ff       	call   801001b5 <bread>
80103301:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103304:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103307:	83 c0 10             	add    $0x10,%eax
8010330a:	8b 04 85 4c 37 11 80 	mov    -0x7feec8b4(,%eax,4),%eax
80103311:	89 c2                	mov    %eax,%edx
80103313:	a1 84 37 11 80       	mov    0x80113784,%eax
80103318:	89 54 24 04          	mov    %edx,0x4(%esp)
8010331c:	89 04 24             	mov    %eax,(%esp)
8010331f:	e8 91 ce ff ff       	call   801001b5 <bread>
80103324:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103327:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010332a:	8d 50 5c             	lea    0x5c(%eax),%edx
8010332d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103330:	83 c0 5c             	add    $0x5c,%eax
80103333:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
8010333a:	00 
8010333b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010333f:	89 04 24             	mov    %eax,(%esp)
80103342:	e8 47 20 00 00       	call   8010538e <memmove>
    bwrite(dbuf);  // write dst to disk
80103347:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010334a:	89 04 24             	mov    %eax,(%esp)
8010334d:	e8 9a ce ff ff       	call   801001ec <bwrite>
    brelse(lbuf);
80103352:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103355:	89 04 24             	mov    %eax,(%esp)
80103358:	e8 cf ce ff ff       	call   8010022c <brelse>
    brelse(dbuf);
8010335d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103360:	89 04 24             	mov    %eax,(%esp)
80103363:	e8 c4 ce ff ff       	call   8010022c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103368:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010336c:	a1 88 37 11 80       	mov    0x80113788,%eax
80103371:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103374:	0f 8f 66 ff ff ff    	jg     801032e0 <install_trans+0x12>
  }
}
8010337a:	c9                   	leave  
8010337b:	c3                   	ret    

8010337c <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
8010337c:	55                   	push   %ebp
8010337d:	89 e5                	mov    %esp,%ebp
8010337f:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
80103382:	a1 74 37 11 80       	mov    0x80113774,%eax
80103387:	89 c2                	mov    %eax,%edx
80103389:	a1 84 37 11 80       	mov    0x80113784,%eax
8010338e:	89 54 24 04          	mov    %edx,0x4(%esp)
80103392:	89 04 24             	mov    %eax,(%esp)
80103395:	e8 1b ce ff ff       	call   801001b5 <bread>
8010339a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
8010339d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033a0:	83 c0 5c             	add    $0x5c,%eax
801033a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
801033a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033a9:	8b 00                	mov    (%eax),%eax
801033ab:	a3 88 37 11 80       	mov    %eax,0x80113788
  for (i = 0; i < log.lh.n; i++) {
801033b0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801033b7:	eb 1b                	jmp    801033d4 <read_head+0x58>
    log.lh.block[i] = lh->block[i];
801033b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801033bf:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
801033c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
801033c6:	83 c2 10             	add    $0x10,%edx
801033c9:	89 04 95 4c 37 11 80 	mov    %eax,-0x7feec8b4(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801033d0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801033d4:	a1 88 37 11 80       	mov    0x80113788,%eax
801033d9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801033dc:	7f db                	jg     801033b9 <read_head+0x3d>
  }
  brelse(buf);
801033de:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033e1:	89 04 24             	mov    %eax,(%esp)
801033e4:	e8 43 ce ff ff       	call   8010022c <brelse>
}
801033e9:	c9                   	leave  
801033ea:	c3                   	ret    

801033eb <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801033eb:	55                   	push   %ebp
801033ec:	89 e5                	mov    %esp,%ebp
801033ee:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
801033f1:	a1 74 37 11 80       	mov    0x80113774,%eax
801033f6:	89 c2                	mov    %eax,%edx
801033f8:	a1 84 37 11 80       	mov    0x80113784,%eax
801033fd:	89 54 24 04          	mov    %edx,0x4(%esp)
80103401:	89 04 24             	mov    %eax,(%esp)
80103404:	e8 ac cd ff ff       	call   801001b5 <bread>
80103409:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
8010340c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010340f:	83 c0 5c             	add    $0x5c,%eax
80103412:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
80103415:	8b 15 88 37 11 80    	mov    0x80113788,%edx
8010341b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010341e:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103420:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103427:	eb 1b                	jmp    80103444 <write_head+0x59>
    hb->block[i] = log.lh.block[i];
80103429:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010342c:	83 c0 10             	add    $0x10,%eax
8010342f:	8b 0c 85 4c 37 11 80 	mov    -0x7feec8b4(,%eax,4),%ecx
80103436:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103439:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010343c:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80103440:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103444:	a1 88 37 11 80       	mov    0x80113788,%eax
80103449:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010344c:	7f db                	jg     80103429 <write_head+0x3e>
  }
  bwrite(buf);
8010344e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103451:	89 04 24             	mov    %eax,(%esp)
80103454:	e8 93 cd ff ff       	call   801001ec <bwrite>
  brelse(buf);
80103459:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010345c:	89 04 24             	mov    %eax,(%esp)
8010345f:	e8 c8 cd ff ff       	call   8010022c <brelse>
}
80103464:	c9                   	leave  
80103465:	c3                   	ret    

80103466 <recover_from_log>:

static void
recover_from_log(void)
{
80103466:	55                   	push   %ebp
80103467:	89 e5                	mov    %esp,%ebp
80103469:	83 ec 08             	sub    $0x8,%esp
  read_head();
8010346c:	e8 0b ff ff ff       	call   8010337c <read_head>
  install_trans(); // if committed, copy from log to disk
80103471:	e8 58 fe ff ff       	call   801032ce <install_trans>
  log.lh.n = 0;
80103476:	c7 05 88 37 11 80 00 	movl   $0x0,0x80113788
8010347d:	00 00 00 
  write_head(); // clear the log
80103480:	e8 66 ff ff ff       	call   801033eb <write_head>
}
80103485:	c9                   	leave  
80103486:	c3                   	ret    

80103487 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
80103487:	55                   	push   %ebp
80103488:	89 e5                	mov    %esp,%ebp
8010348a:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
8010348d:	c7 04 24 40 37 11 80 	movl   $0x80113740,(%esp)
80103494:	e8 b4 1b 00 00       	call   8010504d <acquire>
  while(1){
    if(log.committing){
80103499:	a1 80 37 11 80       	mov    0x80113780,%eax
8010349e:	85 c0                	test   %eax,%eax
801034a0:	74 16                	je     801034b8 <begin_op+0x31>
      sleep(&log, &log.lock);
801034a2:	c7 44 24 04 40 37 11 	movl   $0x80113740,0x4(%esp)
801034a9:	80 
801034aa:	c7 04 24 40 37 11 80 	movl   $0x80113740,(%esp)
801034b1:	e8 e6 15 00 00       	call   80104a9c <sleep>
801034b6:	eb 4f                	jmp    80103507 <begin_op+0x80>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801034b8:	8b 0d 88 37 11 80    	mov    0x80113788,%ecx
801034be:	a1 7c 37 11 80       	mov    0x8011377c,%eax
801034c3:	8d 50 01             	lea    0x1(%eax),%edx
801034c6:	89 d0                	mov    %edx,%eax
801034c8:	c1 e0 02             	shl    $0x2,%eax
801034cb:	01 d0                	add    %edx,%eax
801034cd:	01 c0                	add    %eax,%eax
801034cf:	01 c8                	add    %ecx,%eax
801034d1:	83 f8 1e             	cmp    $0x1e,%eax
801034d4:	7e 16                	jle    801034ec <begin_op+0x65>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
801034d6:	c7 44 24 04 40 37 11 	movl   $0x80113740,0x4(%esp)
801034dd:	80 
801034de:	c7 04 24 40 37 11 80 	movl   $0x80113740,(%esp)
801034e5:	e8 b2 15 00 00       	call   80104a9c <sleep>
801034ea:	eb 1b                	jmp    80103507 <begin_op+0x80>
    } else {
      log.outstanding += 1;
801034ec:	a1 7c 37 11 80       	mov    0x8011377c,%eax
801034f1:	83 c0 01             	add    $0x1,%eax
801034f4:	a3 7c 37 11 80       	mov    %eax,0x8011377c
      release(&log.lock);
801034f9:	c7 04 24 40 37 11 80 	movl   $0x80113740,(%esp)
80103500:	e8 b0 1b 00 00       	call   801050b5 <release>
      break;
80103505:	eb 02                	jmp    80103509 <begin_op+0x82>
    }
  }
80103507:	eb 90                	jmp    80103499 <begin_op+0x12>
}
80103509:	c9                   	leave  
8010350a:	c3                   	ret    

8010350b <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
8010350b:	55                   	push   %ebp
8010350c:	89 e5                	mov    %esp,%ebp
8010350e:	83 ec 28             	sub    $0x28,%esp
  int do_commit = 0;
80103511:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
80103518:	c7 04 24 40 37 11 80 	movl   $0x80113740,(%esp)
8010351f:	e8 29 1b 00 00       	call   8010504d <acquire>
  log.outstanding -= 1;
80103524:	a1 7c 37 11 80       	mov    0x8011377c,%eax
80103529:	83 e8 01             	sub    $0x1,%eax
8010352c:	a3 7c 37 11 80       	mov    %eax,0x8011377c
  if(log.committing)
80103531:	a1 80 37 11 80       	mov    0x80113780,%eax
80103536:	85 c0                	test   %eax,%eax
80103538:	74 0c                	je     80103546 <end_op+0x3b>
    panic("log.committing");
8010353a:	c7 04 24 81 87 10 80 	movl   $0x80108781,(%esp)
80103541:	e8 1c d0 ff ff       	call   80100562 <panic>
  if(log.outstanding == 0){
80103546:	a1 7c 37 11 80       	mov    0x8011377c,%eax
8010354b:	85 c0                	test   %eax,%eax
8010354d:	75 13                	jne    80103562 <end_op+0x57>
    do_commit = 1;
8010354f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
80103556:	c7 05 80 37 11 80 01 	movl   $0x1,0x80113780
8010355d:	00 00 00 
80103560:	eb 0c                	jmp    8010356e <end_op+0x63>
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
80103562:	c7 04 24 40 37 11 80 	movl   $0x80113740,(%esp)
80103569:	e8 05 16 00 00       	call   80104b73 <wakeup>
  }
  release(&log.lock);
8010356e:	c7 04 24 40 37 11 80 	movl   $0x80113740,(%esp)
80103575:	e8 3b 1b 00 00       	call   801050b5 <release>

  if(do_commit){
8010357a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010357e:	74 33                	je     801035b3 <end_op+0xa8>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
80103580:	e8 de 00 00 00       	call   80103663 <commit>
    acquire(&log.lock);
80103585:	c7 04 24 40 37 11 80 	movl   $0x80113740,(%esp)
8010358c:	e8 bc 1a 00 00       	call   8010504d <acquire>
    log.committing = 0;
80103591:	c7 05 80 37 11 80 00 	movl   $0x0,0x80113780
80103598:	00 00 00 
    wakeup(&log);
8010359b:	c7 04 24 40 37 11 80 	movl   $0x80113740,(%esp)
801035a2:	e8 cc 15 00 00       	call   80104b73 <wakeup>
    release(&log.lock);
801035a7:	c7 04 24 40 37 11 80 	movl   $0x80113740,(%esp)
801035ae:	e8 02 1b 00 00       	call   801050b5 <release>
  }
}
801035b3:	c9                   	leave  
801035b4:	c3                   	ret    

801035b5 <write_log>:

// Copy modified blocks from cache to log.
static void
write_log(void)
{
801035b5:	55                   	push   %ebp
801035b6:	89 e5                	mov    %esp,%ebp
801035b8:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801035bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801035c2:	e9 8c 00 00 00       	jmp    80103653 <write_log+0x9e>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801035c7:	8b 15 74 37 11 80    	mov    0x80113774,%edx
801035cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035d0:	01 d0                	add    %edx,%eax
801035d2:	83 c0 01             	add    $0x1,%eax
801035d5:	89 c2                	mov    %eax,%edx
801035d7:	a1 84 37 11 80       	mov    0x80113784,%eax
801035dc:	89 54 24 04          	mov    %edx,0x4(%esp)
801035e0:	89 04 24             	mov    %eax,(%esp)
801035e3:	e8 cd cb ff ff       	call   801001b5 <bread>
801035e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801035eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035ee:	83 c0 10             	add    $0x10,%eax
801035f1:	8b 04 85 4c 37 11 80 	mov    -0x7feec8b4(,%eax,4),%eax
801035f8:	89 c2                	mov    %eax,%edx
801035fa:	a1 84 37 11 80       	mov    0x80113784,%eax
801035ff:	89 54 24 04          	mov    %edx,0x4(%esp)
80103603:	89 04 24             	mov    %eax,(%esp)
80103606:	e8 aa cb ff ff       	call   801001b5 <bread>
8010360b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
8010360e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103611:	8d 50 5c             	lea    0x5c(%eax),%edx
80103614:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103617:	83 c0 5c             	add    $0x5c,%eax
8010361a:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80103621:	00 
80103622:	89 54 24 04          	mov    %edx,0x4(%esp)
80103626:	89 04 24             	mov    %eax,(%esp)
80103629:	e8 60 1d 00 00       	call   8010538e <memmove>
    bwrite(to);  // write the log
8010362e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103631:	89 04 24             	mov    %eax,(%esp)
80103634:	e8 b3 cb ff ff       	call   801001ec <bwrite>
    brelse(from);
80103639:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010363c:	89 04 24             	mov    %eax,(%esp)
8010363f:	e8 e8 cb ff ff       	call   8010022c <brelse>
    brelse(to);
80103644:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103647:	89 04 24             	mov    %eax,(%esp)
8010364a:	e8 dd cb ff ff       	call   8010022c <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
8010364f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103653:	a1 88 37 11 80       	mov    0x80113788,%eax
80103658:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010365b:	0f 8f 66 ff ff ff    	jg     801035c7 <write_log+0x12>
  }
}
80103661:	c9                   	leave  
80103662:	c3                   	ret    

80103663 <commit>:

static void
commit()
{
80103663:	55                   	push   %ebp
80103664:	89 e5                	mov    %esp,%ebp
80103666:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
80103669:	a1 88 37 11 80       	mov    0x80113788,%eax
8010366e:	85 c0                	test   %eax,%eax
80103670:	7e 1e                	jle    80103690 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
80103672:	e8 3e ff ff ff       	call   801035b5 <write_log>
    write_head();    // Write header to disk -- the real commit
80103677:	e8 6f fd ff ff       	call   801033eb <write_head>
    install_trans(); // Now install writes to home locations
8010367c:	e8 4d fc ff ff       	call   801032ce <install_trans>
    log.lh.n = 0;
80103681:	c7 05 88 37 11 80 00 	movl   $0x0,0x80113788
80103688:	00 00 00 
    write_head();    // Erase the transaction from the log
8010368b:	e8 5b fd ff ff       	call   801033eb <write_head>
  }
}
80103690:	c9                   	leave  
80103691:	c3                   	ret    

80103692 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103692:	55                   	push   %ebp
80103693:	89 e5                	mov    %esp,%ebp
80103695:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103698:	a1 88 37 11 80       	mov    0x80113788,%eax
8010369d:	83 f8 1d             	cmp    $0x1d,%eax
801036a0:	7f 12                	jg     801036b4 <log_write+0x22>
801036a2:	a1 88 37 11 80       	mov    0x80113788,%eax
801036a7:	8b 15 78 37 11 80    	mov    0x80113778,%edx
801036ad:	83 ea 01             	sub    $0x1,%edx
801036b0:	39 d0                	cmp    %edx,%eax
801036b2:	7c 0c                	jl     801036c0 <log_write+0x2e>
    panic("too big a transaction");
801036b4:	c7 04 24 90 87 10 80 	movl   $0x80108790,(%esp)
801036bb:	e8 a2 ce ff ff       	call   80100562 <panic>
  if (log.outstanding < 1)
801036c0:	a1 7c 37 11 80       	mov    0x8011377c,%eax
801036c5:	85 c0                	test   %eax,%eax
801036c7:	7f 0c                	jg     801036d5 <log_write+0x43>
    panic("log_write outside of trans");
801036c9:	c7 04 24 a6 87 10 80 	movl   $0x801087a6,(%esp)
801036d0:	e8 8d ce ff ff       	call   80100562 <panic>

  acquire(&log.lock);
801036d5:	c7 04 24 40 37 11 80 	movl   $0x80113740,(%esp)
801036dc:	e8 6c 19 00 00       	call   8010504d <acquire>
  for (i = 0; i < log.lh.n; i++) {
801036e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801036e8:	eb 1f                	jmp    80103709 <log_write+0x77>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801036ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036ed:	83 c0 10             	add    $0x10,%eax
801036f0:	8b 04 85 4c 37 11 80 	mov    -0x7feec8b4(,%eax,4),%eax
801036f7:	89 c2                	mov    %eax,%edx
801036f9:	8b 45 08             	mov    0x8(%ebp),%eax
801036fc:	8b 40 08             	mov    0x8(%eax),%eax
801036ff:	39 c2                	cmp    %eax,%edx
80103701:	75 02                	jne    80103705 <log_write+0x73>
      break;
80103703:	eb 0e                	jmp    80103713 <log_write+0x81>
  for (i = 0; i < log.lh.n; i++) {
80103705:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103709:	a1 88 37 11 80       	mov    0x80113788,%eax
8010370e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103711:	7f d7                	jg     801036ea <log_write+0x58>
  }
  log.lh.block[i] = b->blockno;
80103713:	8b 45 08             	mov    0x8(%ebp),%eax
80103716:	8b 40 08             	mov    0x8(%eax),%eax
80103719:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010371c:	83 c2 10             	add    $0x10,%edx
8010371f:	89 04 95 4c 37 11 80 	mov    %eax,-0x7feec8b4(,%edx,4)
  if (i == log.lh.n)
80103726:	a1 88 37 11 80       	mov    0x80113788,%eax
8010372b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010372e:	75 0d                	jne    8010373d <log_write+0xab>
    log.lh.n++;
80103730:	a1 88 37 11 80       	mov    0x80113788,%eax
80103735:	83 c0 01             	add    $0x1,%eax
80103738:	a3 88 37 11 80       	mov    %eax,0x80113788
  b->flags |= B_DIRTY; // prevent eviction
8010373d:	8b 45 08             	mov    0x8(%ebp),%eax
80103740:	8b 00                	mov    (%eax),%eax
80103742:	83 c8 04             	or     $0x4,%eax
80103745:	89 c2                	mov    %eax,%edx
80103747:	8b 45 08             	mov    0x8(%ebp),%eax
8010374a:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
8010374c:	c7 04 24 40 37 11 80 	movl   $0x80113740,(%esp)
80103753:	e8 5d 19 00 00       	call   801050b5 <release>
}
80103758:	c9                   	leave  
80103759:	c3                   	ret    

8010375a <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
8010375a:	55                   	push   %ebp
8010375b:	89 e5                	mov    %esp,%ebp
8010375d:	83 ec 10             	sub    $0x10,%esp
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103760:	8b 55 08             	mov    0x8(%ebp),%edx
80103763:	8b 45 0c             	mov    0xc(%ebp),%eax
80103766:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103769:	f0 87 02             	lock xchg %eax,(%edx)
8010376c:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
8010376f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103772:	c9                   	leave  
80103773:	c3                   	ret    

80103774 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103774:	55                   	push   %ebp
80103775:	89 e5                	mov    %esp,%ebp
80103777:	83 e4 f0             	and    $0xfffffff0,%esp
8010377a:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010377d:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80103784:	80 
80103785:	c7 04 24 68 67 11 80 	movl   $0x80116768,(%esp)
8010378c:	e8 ed f2 ff ff       	call   80102a7e <kinit1>
  kvmalloc();      // kernel page table
80103791:	e8 64 45 00 00       	call   80107cfa <kvmalloc>
  mpinit();        // detect other processors
80103796:	e8 cb 03 00 00       	call   80103b66 <mpinit>
  lapicinit();     // interrupt controller
8010379b:	e8 36 f6 ff ff       	call   80102dd6 <lapicinit>
  seginit();       // segment descriptors
801037a0:	e8 21 40 00 00       	call   801077c6 <seginit>
  picinit();       // disable pic
801037a5:	e8 0b 05 00 00       	call   80103cb5 <picinit>
  ioapicinit();    // another interrupt controller
801037aa:	e8 eb f1 ff ff       	call   8010299a <ioapicinit>
  consoleinit();   // console hardware
801037af:	e8 1c d3 ff ff       	call   80100ad0 <consoleinit>
  uartinit();      // serial port
801037b4:	e8 97 33 00 00       	call   80106b50 <uartinit>
  pinit();         // process table
801037b9:	e8 f0 08 00 00       	call   801040ae <pinit>
  tvinit();        // trap vectors
801037be:	e8 56 2f 00 00       	call   80106719 <tvinit>
  binit();         // buffer cache
801037c3:	e8 6c c8 ff ff       	call   80100034 <binit>
  fileinit();      // file table
801037c8:	e8 9c d7 ff ff       	call   80100f69 <fileinit>
  ideinit();       // disk 
801037cd:	e8 d2 ed ff ff       	call   801025a4 <ideinit>
  startothers();   // start other processors
801037d2:	e8 83 00 00 00       	call   8010385a <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801037d7:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
801037de:	8e 
801037df:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
801037e6:	e8 cb f2 ff ff       	call   80102ab6 <kinit2>
  userinit();      // first user process
801037eb:	e8 9c 0a 00 00       	call   8010428c <userinit>
  mpmain();        // finish this processor's setup
801037f0:	e8 1a 00 00 00       	call   8010380f <mpmain>

801037f5 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
801037f5:	55                   	push   %ebp
801037f6:	89 e5                	mov    %esp,%ebp
801037f8:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801037fb:	e8 11 45 00 00       	call   80107d11 <switchkvm>
  seginit();
80103800:	e8 c1 3f 00 00       	call   801077c6 <seginit>
  lapicinit();
80103805:	e8 cc f5 ff ff       	call   80102dd6 <lapicinit>
  mpmain();
8010380a:	e8 00 00 00 00       	call   8010380f <mpmain>

8010380f <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
8010380f:	55                   	push   %ebp
80103810:	89 e5                	mov    %esp,%ebp
80103812:	53                   	push   %ebx
80103813:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103816:	e8 af 08 00 00       	call   801040ca <cpuid>
8010381b:	89 c3                	mov    %eax,%ebx
8010381d:	e8 a8 08 00 00       	call   801040ca <cpuid>
80103822:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80103826:	89 44 24 04          	mov    %eax,0x4(%esp)
8010382a:	c7 04 24 c1 87 10 80 	movl   $0x801087c1,(%esp)
80103831:	e8 92 cb ff ff       	call   801003c8 <cprintf>
  idtinit();       // load idt register
80103836:	e8 52 30 00 00       	call   8010688d <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
8010383b:	e8 ab 08 00 00       	call   801040eb <mycpu>
80103840:	05 a0 00 00 00       	add    $0xa0,%eax
80103845:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010384c:	00 
8010384d:	89 04 24             	mov    %eax,(%esp)
80103850:	e8 05 ff ff ff       	call   8010375a <xchg>
  scheduler();     // start running processes
80103855:	e8 f6 0f 00 00       	call   80104850 <scheduler>

8010385a <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
8010385a:	55                   	push   %ebp
8010385b:	89 e5                	mov    %esp,%ebp
8010385d:	83 ec 28             	sub    $0x28,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
80103860:	c7 45 f0 00 70 00 80 	movl   $0x80007000,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103867:	b8 8a 00 00 00       	mov    $0x8a,%eax
8010386c:	89 44 24 08          	mov    %eax,0x8(%esp)
80103870:	c7 44 24 04 2c b5 10 	movl   $0x8010b52c,0x4(%esp)
80103877:	80 
80103878:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010387b:	89 04 24             	mov    %eax,(%esp)
8010387e:	e8 0b 1b 00 00       	call   8010538e <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103883:	c7 45 f4 40 38 11 80 	movl   $0x80113840,-0xc(%ebp)
8010388a:	eb 76                	jmp    80103902 <startothers+0xa8>
    if(c == mycpu())  // We've started already.
8010388c:	e8 5a 08 00 00       	call   801040eb <mycpu>
80103891:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103894:	75 02                	jne    80103898 <startothers+0x3e>
      continue;
80103896:	eb 63                	jmp    801038fb <startothers+0xa1>

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103898:	e8 0c f3 ff ff       	call   80102ba9 <kalloc>
8010389d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
801038a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038a3:	83 e8 04             	sub    $0x4,%eax
801038a6:	8b 55 ec             	mov    -0x14(%ebp),%edx
801038a9:	81 c2 00 10 00 00    	add    $0x1000,%edx
801038af:	89 10                	mov    %edx,(%eax)
    *(void(**)(void))(code-8) = mpenter;
801038b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038b4:	83 e8 08             	sub    $0x8,%eax
801038b7:	c7 00 f5 37 10 80    	movl   $0x801037f5,(%eax)
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801038bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038c0:	8d 50 f4             	lea    -0xc(%eax),%edx
801038c3:	b8 00 a0 10 80       	mov    $0x8010a000,%eax
801038c8:	05 00 00 00 80       	add    $0x80000000,%eax
801038cd:	89 02                	mov    %eax,(%edx)

    lapicstartap(c->apicid, V2P(code));
801038cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038d2:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801038d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038db:	0f b6 00             	movzbl (%eax),%eax
801038de:	0f b6 c0             	movzbl %al,%eax
801038e1:	89 54 24 04          	mov    %edx,0x4(%esp)
801038e5:	89 04 24             	mov    %eax,(%esp)
801038e8:	e8 8e f6 ff ff       	call   80102f7b <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801038ed:	90                   	nop
801038ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038f1:	8b 80 a0 00 00 00    	mov    0xa0(%eax),%eax
801038f7:	85 c0                	test   %eax,%eax
801038f9:	74 f3                	je     801038ee <startothers+0x94>
  for(c = cpus; c < cpus+ncpu; c++){
801038fb:	81 45 f4 b0 00 00 00 	addl   $0xb0,-0xc(%ebp)
80103902:	a1 c0 3d 11 80       	mov    0x80113dc0,%eax
80103907:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
8010390d:	05 40 38 11 80       	add    $0x80113840,%eax
80103912:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103915:	0f 87 71 ff ff ff    	ja     8010388c <startothers+0x32>
      ;
  }
}
8010391b:	c9                   	leave  
8010391c:	c3                   	ret    

8010391d <inb>:
{
8010391d:	55                   	push   %ebp
8010391e:	89 e5                	mov    %esp,%ebp
80103920:	83 ec 14             	sub    $0x14,%esp
80103923:	8b 45 08             	mov    0x8(%ebp),%eax
80103926:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010392a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010392e:	89 c2                	mov    %eax,%edx
80103930:	ec                   	in     (%dx),%al
80103931:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103934:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103938:	c9                   	leave  
80103939:	c3                   	ret    

8010393a <outb>:
{
8010393a:	55                   	push   %ebp
8010393b:	89 e5                	mov    %esp,%ebp
8010393d:	83 ec 08             	sub    $0x8,%esp
80103940:	8b 55 08             	mov    0x8(%ebp),%edx
80103943:	8b 45 0c             	mov    0xc(%ebp),%eax
80103946:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010394a:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010394d:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103951:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103955:	ee                   	out    %al,(%dx)
}
80103956:	c9                   	leave  
80103957:	c3                   	ret    

80103958 <sum>:
int ncpu;
uchar ioapicid;

static uchar
sum(uchar *addr, int len)
{
80103958:	55                   	push   %ebp
80103959:	89 e5                	mov    %esp,%ebp
8010395b:	83 ec 10             	sub    $0x10,%esp
  int i, sum;

  sum = 0;
8010395e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103965:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010396c:	eb 15                	jmp    80103983 <sum+0x2b>
    sum += addr[i];
8010396e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103971:	8b 45 08             	mov    0x8(%ebp),%eax
80103974:	01 d0                	add    %edx,%eax
80103976:	0f b6 00             	movzbl (%eax),%eax
80103979:	0f b6 c0             	movzbl %al,%eax
8010397c:	01 45 f8             	add    %eax,-0x8(%ebp)
  for(i=0; i<len; i++)
8010397f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103983:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103986:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103989:	7c e3                	jl     8010396e <sum+0x16>
  return sum;
8010398b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
8010398e:	c9                   	leave  
8010398f:	c3                   	ret    

80103990 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103990:	55                   	push   %ebp
80103991:	89 e5                	mov    %esp,%ebp
80103993:	83 ec 28             	sub    $0x28,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
80103996:	8b 45 08             	mov    0x8(%ebp),%eax
80103999:	05 00 00 00 80       	add    $0x80000000,%eax
8010399e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
801039a1:	8b 55 0c             	mov    0xc(%ebp),%edx
801039a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039a7:	01 d0                	add    %edx,%eax
801039a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
801039ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039af:	89 45 f4             	mov    %eax,-0xc(%ebp)
801039b2:	eb 3f                	jmp    801039f3 <mpsearch1+0x63>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801039b4:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801039bb:	00 
801039bc:	c7 44 24 04 d8 87 10 	movl   $0x801087d8,0x4(%esp)
801039c3:	80 
801039c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039c7:	89 04 24             	mov    %eax,(%esp)
801039ca:	e8 67 19 00 00       	call   80105336 <memcmp>
801039cf:	85 c0                	test   %eax,%eax
801039d1:	75 1c                	jne    801039ef <mpsearch1+0x5f>
801039d3:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
801039da:	00 
801039db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039de:	89 04 24             	mov    %eax,(%esp)
801039e1:	e8 72 ff ff ff       	call   80103958 <sum>
801039e6:	84 c0                	test   %al,%al
801039e8:	75 05                	jne    801039ef <mpsearch1+0x5f>
      return (struct mp*)p;
801039ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039ed:	eb 11                	jmp    80103a00 <mpsearch1+0x70>
  for(p = addr; p < e; p += sizeof(struct mp))
801039ef:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
801039f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039f6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801039f9:	72 b9                	jb     801039b4 <mpsearch1+0x24>
  return 0;
801039fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103a00:	c9                   	leave  
80103a01:	c3                   	ret    

80103a02 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103a02:	55                   	push   %ebp
80103a03:	89 e5                	mov    %esp,%ebp
80103a05:	83 ec 28             	sub    $0x28,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103a08:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a12:	83 c0 0f             	add    $0xf,%eax
80103a15:	0f b6 00             	movzbl (%eax),%eax
80103a18:	0f b6 c0             	movzbl %al,%eax
80103a1b:	c1 e0 08             	shl    $0x8,%eax
80103a1e:	89 c2                	mov    %eax,%edx
80103a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a23:	83 c0 0e             	add    $0xe,%eax
80103a26:	0f b6 00             	movzbl (%eax),%eax
80103a29:	0f b6 c0             	movzbl %al,%eax
80103a2c:	09 d0                	or     %edx,%eax
80103a2e:	c1 e0 04             	shl    $0x4,%eax
80103a31:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103a34:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103a38:	74 21                	je     80103a5b <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103a3a:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103a41:	00 
80103a42:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a45:	89 04 24             	mov    %eax,(%esp)
80103a48:	e8 43 ff ff ff       	call   80103990 <mpsearch1>
80103a4d:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103a50:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103a54:	74 50                	je     80103aa6 <mpsearch+0xa4>
      return mp;
80103a56:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103a59:	eb 5f                	jmp    80103aba <mpsearch+0xb8>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a5e:	83 c0 14             	add    $0x14,%eax
80103a61:	0f b6 00             	movzbl (%eax),%eax
80103a64:	0f b6 c0             	movzbl %al,%eax
80103a67:	c1 e0 08             	shl    $0x8,%eax
80103a6a:	89 c2                	mov    %eax,%edx
80103a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a6f:	83 c0 13             	add    $0x13,%eax
80103a72:	0f b6 00             	movzbl (%eax),%eax
80103a75:	0f b6 c0             	movzbl %al,%eax
80103a78:	09 d0                	or     %edx,%eax
80103a7a:	c1 e0 0a             	shl    $0xa,%eax
80103a7d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103a80:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a83:	2d 00 04 00 00       	sub    $0x400,%eax
80103a88:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103a8f:	00 
80103a90:	89 04 24             	mov    %eax,(%esp)
80103a93:	e8 f8 fe ff ff       	call   80103990 <mpsearch1>
80103a98:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103a9b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103a9f:	74 05                	je     80103aa6 <mpsearch+0xa4>
      return mp;
80103aa1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103aa4:	eb 14                	jmp    80103aba <mpsearch+0xb8>
  }
  return mpsearch1(0xF0000, 0x10000);
80103aa6:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80103aad:	00 
80103aae:	c7 04 24 00 00 0f 00 	movl   $0xf0000,(%esp)
80103ab5:	e8 d6 fe ff ff       	call   80103990 <mpsearch1>
}
80103aba:	c9                   	leave  
80103abb:	c3                   	ret    

80103abc <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103abc:	55                   	push   %ebp
80103abd:	89 e5                	mov    %esp,%ebp
80103abf:	83 ec 28             	sub    $0x28,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103ac2:	e8 3b ff ff ff       	call   80103a02 <mpsearch>
80103ac7:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103aca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103ace:	74 0a                	je     80103ada <mpconfig+0x1e>
80103ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ad3:	8b 40 04             	mov    0x4(%eax),%eax
80103ad6:	85 c0                	test   %eax,%eax
80103ad8:	75 0a                	jne    80103ae4 <mpconfig+0x28>
    return 0;
80103ada:	b8 00 00 00 00       	mov    $0x0,%eax
80103adf:	e9 80 00 00 00       	jmp    80103b64 <mpconfig+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ae7:	8b 40 04             	mov    0x4(%eax),%eax
80103aea:	05 00 00 00 80       	add    $0x80000000,%eax
80103aef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103af2:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103af9:	00 
80103afa:	c7 44 24 04 dd 87 10 	movl   $0x801087dd,0x4(%esp)
80103b01:	80 
80103b02:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b05:	89 04 24             	mov    %eax,(%esp)
80103b08:	e8 29 18 00 00       	call   80105336 <memcmp>
80103b0d:	85 c0                	test   %eax,%eax
80103b0f:	74 07                	je     80103b18 <mpconfig+0x5c>
    return 0;
80103b11:	b8 00 00 00 00       	mov    $0x0,%eax
80103b16:	eb 4c                	jmp    80103b64 <mpconfig+0xa8>
  if(conf->version != 1 && conf->version != 4)
80103b18:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b1b:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103b1f:	3c 01                	cmp    $0x1,%al
80103b21:	74 12                	je     80103b35 <mpconfig+0x79>
80103b23:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b26:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103b2a:	3c 04                	cmp    $0x4,%al
80103b2c:	74 07                	je     80103b35 <mpconfig+0x79>
    return 0;
80103b2e:	b8 00 00 00 00       	mov    $0x0,%eax
80103b33:	eb 2f                	jmp    80103b64 <mpconfig+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103b35:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b38:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103b3c:	0f b7 c0             	movzwl %ax,%eax
80103b3f:	89 44 24 04          	mov    %eax,0x4(%esp)
80103b43:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b46:	89 04 24             	mov    %eax,(%esp)
80103b49:	e8 0a fe ff ff       	call   80103958 <sum>
80103b4e:	84 c0                	test   %al,%al
80103b50:	74 07                	je     80103b59 <mpconfig+0x9d>
    return 0;
80103b52:	b8 00 00 00 00       	mov    $0x0,%eax
80103b57:	eb 0b                	jmp    80103b64 <mpconfig+0xa8>
  *pmp = mp;
80103b59:	8b 45 08             	mov    0x8(%ebp),%eax
80103b5c:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103b5f:	89 10                	mov    %edx,(%eax)
  return conf;
80103b61:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103b64:	c9                   	leave  
80103b65:	c3                   	ret    

80103b66 <mpinit>:

void
mpinit(void)
{
80103b66:	55                   	push   %ebp
80103b67:	89 e5                	mov    %esp,%ebp
80103b69:	83 ec 38             	sub    $0x38,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103b6c:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103b6f:	89 04 24             	mov    %eax,(%esp)
80103b72:	e8 45 ff ff ff       	call   80103abc <mpconfig>
80103b77:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103b7a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103b7e:	75 0c                	jne    80103b8c <mpinit+0x26>
    panic("Expect to run on an SMP");
80103b80:	c7 04 24 e2 87 10 80 	movl   $0x801087e2,(%esp)
80103b87:	e8 d6 c9 ff ff       	call   80100562 <panic>
  ismp = 1;
80103b8c:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  lapic = (uint*)conf->lapicaddr;
80103b93:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103b96:	8b 40 24             	mov    0x24(%eax),%eax
80103b99:	a3 3c 37 11 80       	mov    %eax,0x8011373c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103b9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103ba1:	83 c0 2c             	add    $0x2c,%eax
80103ba4:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103ba7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103baa:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103bae:	0f b7 d0             	movzwl %ax,%edx
80103bb1:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103bb4:	01 d0                	add    %edx,%eax
80103bb6:	89 45 e8             	mov    %eax,-0x18(%ebp)
80103bb9:	eb 7b                	jmp    80103c36 <mpinit+0xd0>
    switch(*p){
80103bbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bbe:	0f b6 00             	movzbl (%eax),%eax
80103bc1:	0f b6 c0             	movzbl %al,%eax
80103bc4:	83 f8 04             	cmp    $0x4,%eax
80103bc7:	77 65                	ja     80103c2e <mpinit+0xc8>
80103bc9:	8b 04 85 1c 88 10 80 	mov    -0x7fef77e4(,%eax,4),%eax
80103bd0:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bd5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(ncpu < NCPU) {
80103bd8:	a1 c0 3d 11 80       	mov    0x80113dc0,%eax
80103bdd:	83 f8 07             	cmp    $0x7,%eax
80103be0:	7f 28                	jg     80103c0a <mpinit+0xa4>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103be2:	8b 15 c0 3d 11 80    	mov    0x80113dc0,%edx
80103be8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103beb:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103bef:	69 d2 b0 00 00 00    	imul   $0xb0,%edx,%edx
80103bf5:	81 c2 40 38 11 80    	add    $0x80113840,%edx
80103bfb:	88 02                	mov    %al,(%edx)
        ncpu++;
80103bfd:	a1 c0 3d 11 80       	mov    0x80113dc0,%eax
80103c02:	83 c0 01             	add    $0x1,%eax
80103c05:	a3 c0 3d 11 80       	mov    %eax,0x80113dc0
      }
      p += sizeof(struct mpproc);
80103c0a:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103c0e:	eb 26                	jmp    80103c36 <mpinit+0xd0>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103c10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c13:	89 45 e0             	mov    %eax,-0x20(%ebp)
      ioapicid = ioapic->apicno;
80103c16:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103c19:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103c1d:	a2 20 38 11 80       	mov    %al,0x80113820
      p += sizeof(struct mpioapic);
80103c22:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103c26:	eb 0e                	jmp    80103c36 <mpinit+0xd0>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103c28:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103c2c:	eb 08                	jmp    80103c36 <mpinit+0xd0>
    default:
      ismp = 0;
80103c2e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
      break;
80103c35:	90                   	nop
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c39:	3b 45 e8             	cmp    -0x18(%ebp),%eax
80103c3c:	0f 82 79 ff ff ff    	jb     80103bbb <mpinit+0x55>
    }
  }
  if(!ismp)
80103c42:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103c46:	75 0c                	jne    80103c54 <mpinit+0xee>
    panic("Didn't find a suitable machine");
80103c48:	c7 04 24 fc 87 10 80 	movl   $0x801087fc,(%esp)
80103c4f:	e8 0e c9 ff ff       	call   80100562 <panic>

  if(mp->imcrp){
80103c54:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103c57:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103c5b:	84 c0                	test   %al,%al
80103c5d:	74 36                	je     80103c95 <mpinit+0x12f>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103c5f:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
80103c66:	00 
80103c67:	c7 04 24 22 00 00 00 	movl   $0x22,(%esp)
80103c6e:	e8 c7 fc ff ff       	call   8010393a <outb>
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103c73:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103c7a:	e8 9e fc ff ff       	call   8010391d <inb>
80103c7f:	83 c8 01             	or     $0x1,%eax
80103c82:	0f b6 c0             	movzbl %al,%eax
80103c85:	89 44 24 04          	mov    %eax,0x4(%esp)
80103c89:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103c90:	e8 a5 fc ff ff       	call   8010393a <outb>
  }
}
80103c95:	c9                   	leave  
80103c96:	c3                   	ret    

80103c97 <outb>:
{
80103c97:	55                   	push   %ebp
80103c98:	89 e5                	mov    %esp,%ebp
80103c9a:	83 ec 08             	sub    $0x8,%esp
80103c9d:	8b 55 08             	mov    0x8(%ebp),%edx
80103ca0:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ca3:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103ca7:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103caa:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103cae:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103cb2:	ee                   	out    %al,(%dx)
}
80103cb3:	c9                   	leave  
80103cb4:	c3                   	ret    

80103cb5 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103cb5:	55                   	push   %ebp
80103cb6:	89 e5                	mov    %esp,%ebp
80103cb8:	83 ec 08             	sub    $0x8,%esp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103cbb:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103cc2:	00 
80103cc3:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103cca:	e8 c8 ff ff ff       	call   80103c97 <outb>
  outb(IO_PIC2+1, 0xFF);
80103ccf:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103cd6:	00 
80103cd7:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103cde:	e8 b4 ff ff ff       	call   80103c97 <outb>
}
80103ce3:	c9                   	leave  
80103ce4:	c3                   	ret    

80103ce5 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103ce5:	55                   	push   %ebp
80103ce6:	89 e5                	mov    %esp,%ebp
80103ce8:	83 ec 28             	sub    $0x28,%esp
  struct pipe *p;

  p = 0;
80103ceb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103cf2:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cf5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103cfb:	8b 45 0c             	mov    0xc(%ebp),%eax
80103cfe:	8b 10                	mov    (%eax),%edx
80103d00:	8b 45 08             	mov    0x8(%ebp),%eax
80103d03:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103d05:	e8 7b d2 ff ff       	call   80100f85 <filealloc>
80103d0a:	8b 55 08             	mov    0x8(%ebp),%edx
80103d0d:	89 02                	mov    %eax,(%edx)
80103d0f:	8b 45 08             	mov    0x8(%ebp),%eax
80103d12:	8b 00                	mov    (%eax),%eax
80103d14:	85 c0                	test   %eax,%eax
80103d16:	0f 84 c8 00 00 00    	je     80103de4 <pipealloc+0xff>
80103d1c:	e8 64 d2 ff ff       	call   80100f85 <filealloc>
80103d21:	8b 55 0c             	mov    0xc(%ebp),%edx
80103d24:	89 02                	mov    %eax,(%edx)
80103d26:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d29:	8b 00                	mov    (%eax),%eax
80103d2b:	85 c0                	test   %eax,%eax
80103d2d:	0f 84 b1 00 00 00    	je     80103de4 <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103d33:	e8 71 ee ff ff       	call   80102ba9 <kalloc>
80103d38:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103d3b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103d3f:	75 05                	jne    80103d46 <pipealloc+0x61>
    goto bad;
80103d41:	e9 9e 00 00 00       	jmp    80103de4 <pipealloc+0xff>
  p->readopen = 1;
80103d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d49:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103d50:	00 00 00 
  p->writeopen = 1;
80103d53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d56:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103d5d:	00 00 00 
  p->nwrite = 0;
80103d60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d63:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103d6a:	00 00 00 
  p->nread = 0;
80103d6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d70:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103d77:	00 00 00 
  initlock(&p->lock, "pipe");
80103d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d7d:	c7 44 24 04 30 88 10 	movl   $0x80108830,0x4(%esp)
80103d84:	80 
80103d85:	89 04 24             	mov    %eax,(%esp)
80103d88:	e8 9f 12 00 00       	call   8010502c <initlock>
  (*f0)->type = FD_PIPE;
80103d8d:	8b 45 08             	mov    0x8(%ebp),%eax
80103d90:	8b 00                	mov    (%eax),%eax
80103d92:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103d98:	8b 45 08             	mov    0x8(%ebp),%eax
80103d9b:	8b 00                	mov    (%eax),%eax
80103d9d:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103da1:	8b 45 08             	mov    0x8(%ebp),%eax
80103da4:	8b 00                	mov    (%eax),%eax
80103da6:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103daa:	8b 45 08             	mov    0x8(%ebp),%eax
80103dad:	8b 00                	mov    (%eax),%eax
80103daf:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103db2:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103db5:	8b 45 0c             	mov    0xc(%ebp),%eax
80103db8:	8b 00                	mov    (%eax),%eax
80103dba:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103dc0:	8b 45 0c             	mov    0xc(%ebp),%eax
80103dc3:	8b 00                	mov    (%eax),%eax
80103dc5:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103dc9:	8b 45 0c             	mov    0xc(%ebp),%eax
80103dcc:	8b 00                	mov    (%eax),%eax
80103dce:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103dd2:	8b 45 0c             	mov    0xc(%ebp),%eax
80103dd5:	8b 00                	mov    (%eax),%eax
80103dd7:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103dda:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80103ddd:	b8 00 00 00 00       	mov    $0x0,%eax
80103de2:	eb 42                	jmp    80103e26 <pipealloc+0x141>

//PAGEBREAK: 20
 bad:
  if(p)
80103de4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103de8:	74 0b                	je     80103df5 <pipealloc+0x110>
    kfree((char*)p);
80103dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ded:	89 04 24             	mov    %eax,(%esp)
80103df0:	e8 1e ed ff ff       	call   80102b13 <kfree>
  if(*f0)
80103df5:	8b 45 08             	mov    0x8(%ebp),%eax
80103df8:	8b 00                	mov    (%eax),%eax
80103dfa:	85 c0                	test   %eax,%eax
80103dfc:	74 0d                	je     80103e0b <pipealloc+0x126>
    fileclose(*f0);
80103dfe:	8b 45 08             	mov    0x8(%ebp),%eax
80103e01:	8b 00                	mov    (%eax),%eax
80103e03:	89 04 24             	mov    %eax,(%esp)
80103e06:	e8 22 d2 ff ff       	call   8010102d <fileclose>
  if(*f1)
80103e0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e0e:	8b 00                	mov    (%eax),%eax
80103e10:	85 c0                	test   %eax,%eax
80103e12:	74 0d                	je     80103e21 <pipealloc+0x13c>
    fileclose(*f1);
80103e14:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e17:	8b 00                	mov    (%eax),%eax
80103e19:	89 04 24             	mov    %eax,(%esp)
80103e1c:	e8 0c d2 ff ff       	call   8010102d <fileclose>
  return -1;
80103e21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103e26:	c9                   	leave  
80103e27:	c3                   	ret    

80103e28 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103e28:	55                   	push   %ebp
80103e29:	89 e5                	mov    %esp,%ebp
80103e2b:	83 ec 18             	sub    $0x18,%esp
  acquire(&p->lock);
80103e2e:	8b 45 08             	mov    0x8(%ebp),%eax
80103e31:	89 04 24             	mov    %eax,(%esp)
80103e34:	e8 14 12 00 00       	call   8010504d <acquire>
  if(writable){
80103e39:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80103e3d:	74 1f                	je     80103e5e <pipeclose+0x36>
    p->writeopen = 0;
80103e3f:	8b 45 08             	mov    0x8(%ebp),%eax
80103e42:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80103e49:	00 00 00 
    wakeup(&p->nread);
80103e4c:	8b 45 08             	mov    0x8(%ebp),%eax
80103e4f:	05 34 02 00 00       	add    $0x234,%eax
80103e54:	89 04 24             	mov    %eax,(%esp)
80103e57:	e8 17 0d 00 00       	call   80104b73 <wakeup>
80103e5c:	eb 1d                	jmp    80103e7b <pipeclose+0x53>
  } else {
    p->readopen = 0;
80103e5e:	8b 45 08             	mov    0x8(%ebp),%eax
80103e61:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80103e68:	00 00 00 
    wakeup(&p->nwrite);
80103e6b:	8b 45 08             	mov    0x8(%ebp),%eax
80103e6e:	05 38 02 00 00       	add    $0x238,%eax
80103e73:	89 04 24             	mov    %eax,(%esp)
80103e76:	e8 f8 0c 00 00       	call   80104b73 <wakeup>
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103e7b:	8b 45 08             	mov    0x8(%ebp),%eax
80103e7e:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103e84:	85 c0                	test   %eax,%eax
80103e86:	75 25                	jne    80103ead <pipeclose+0x85>
80103e88:	8b 45 08             	mov    0x8(%ebp),%eax
80103e8b:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103e91:	85 c0                	test   %eax,%eax
80103e93:	75 18                	jne    80103ead <pipeclose+0x85>
    release(&p->lock);
80103e95:	8b 45 08             	mov    0x8(%ebp),%eax
80103e98:	89 04 24             	mov    %eax,(%esp)
80103e9b:	e8 15 12 00 00       	call   801050b5 <release>
    kfree((char*)p);
80103ea0:	8b 45 08             	mov    0x8(%ebp),%eax
80103ea3:	89 04 24             	mov    %eax,(%esp)
80103ea6:	e8 68 ec ff ff       	call   80102b13 <kfree>
80103eab:	eb 0b                	jmp    80103eb8 <pipeclose+0x90>
  } else
    release(&p->lock);
80103ead:	8b 45 08             	mov    0x8(%ebp),%eax
80103eb0:	89 04 24             	mov    %eax,(%esp)
80103eb3:	e8 fd 11 00 00       	call   801050b5 <release>
}
80103eb8:	c9                   	leave  
80103eb9:	c3                   	ret    

80103eba <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103eba:	55                   	push   %ebp
80103ebb:	89 e5                	mov    %esp,%ebp
80103ebd:	83 ec 28             	sub    $0x28,%esp
  int i;

  acquire(&p->lock);
80103ec0:	8b 45 08             	mov    0x8(%ebp),%eax
80103ec3:	89 04 24             	mov    %eax,(%esp)
80103ec6:	e8 82 11 00 00       	call   8010504d <acquire>
  for(i = 0; i < n; i++){
80103ecb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103ed2:	e9 a5 00 00 00       	jmp    80103f7c <pipewrite+0xc2>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103ed7:	eb 56                	jmp    80103f2f <pipewrite+0x75>
      if(p->readopen == 0 || myproc()->killed){
80103ed9:	8b 45 08             	mov    0x8(%ebp),%eax
80103edc:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103ee2:	85 c0                	test   %eax,%eax
80103ee4:	74 0c                	je     80103ef2 <pipewrite+0x38>
80103ee6:	e8 76 02 00 00       	call   80104161 <myproc>
80103eeb:	8b 40 24             	mov    0x24(%eax),%eax
80103eee:	85 c0                	test   %eax,%eax
80103ef0:	74 15                	je     80103f07 <pipewrite+0x4d>
        release(&p->lock);
80103ef2:	8b 45 08             	mov    0x8(%ebp),%eax
80103ef5:	89 04 24             	mov    %eax,(%esp)
80103ef8:	e8 b8 11 00 00       	call   801050b5 <release>
        return -1;
80103efd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f02:	e9 9f 00 00 00       	jmp    80103fa6 <pipewrite+0xec>
      }
      wakeup(&p->nread);
80103f07:	8b 45 08             	mov    0x8(%ebp),%eax
80103f0a:	05 34 02 00 00       	add    $0x234,%eax
80103f0f:	89 04 24             	mov    %eax,(%esp)
80103f12:	e8 5c 0c 00 00       	call   80104b73 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103f17:	8b 45 08             	mov    0x8(%ebp),%eax
80103f1a:	8b 55 08             	mov    0x8(%ebp),%edx
80103f1d:	81 c2 38 02 00 00    	add    $0x238,%edx
80103f23:	89 44 24 04          	mov    %eax,0x4(%esp)
80103f27:	89 14 24             	mov    %edx,(%esp)
80103f2a:	e8 6d 0b 00 00       	call   80104a9c <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103f2f:	8b 45 08             	mov    0x8(%ebp),%eax
80103f32:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80103f38:	8b 45 08             	mov    0x8(%ebp),%eax
80103f3b:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103f41:	05 00 02 00 00       	add    $0x200,%eax
80103f46:	39 c2                	cmp    %eax,%edx
80103f48:	74 8f                	je     80103ed9 <pipewrite+0x1f>
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103f4a:	8b 45 08             	mov    0x8(%ebp),%eax
80103f4d:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103f53:	8d 48 01             	lea    0x1(%eax),%ecx
80103f56:	8b 55 08             	mov    0x8(%ebp),%edx
80103f59:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
80103f5f:	25 ff 01 00 00       	and    $0x1ff,%eax
80103f64:	89 c1                	mov    %eax,%ecx
80103f66:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103f69:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f6c:	01 d0                	add    %edx,%eax
80103f6e:	0f b6 10             	movzbl (%eax),%edx
80103f71:	8b 45 08             	mov    0x8(%ebp),%eax
80103f74:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
  for(i = 0; i < n; i++){
80103f78:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103f7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f7f:	3b 45 10             	cmp    0x10(%ebp),%eax
80103f82:	0f 8c 4f ff ff ff    	jl     80103ed7 <pipewrite+0x1d>
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103f88:	8b 45 08             	mov    0x8(%ebp),%eax
80103f8b:	05 34 02 00 00       	add    $0x234,%eax
80103f90:	89 04 24             	mov    %eax,(%esp)
80103f93:	e8 db 0b 00 00       	call   80104b73 <wakeup>
  release(&p->lock);
80103f98:	8b 45 08             	mov    0x8(%ebp),%eax
80103f9b:	89 04 24             	mov    %eax,(%esp)
80103f9e:	e8 12 11 00 00       	call   801050b5 <release>
  return n;
80103fa3:	8b 45 10             	mov    0x10(%ebp),%eax
}
80103fa6:	c9                   	leave  
80103fa7:	c3                   	ret    

80103fa8 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103fa8:	55                   	push   %ebp
80103fa9:	89 e5                	mov    %esp,%ebp
80103fab:	53                   	push   %ebx
80103fac:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
80103faf:	8b 45 08             	mov    0x8(%ebp),%eax
80103fb2:	89 04 24             	mov    %eax,(%esp)
80103fb5:	e8 93 10 00 00       	call   8010504d <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103fba:	eb 39                	jmp    80103ff5 <piperead+0x4d>
    if(myproc()->killed){
80103fbc:	e8 a0 01 00 00       	call   80104161 <myproc>
80103fc1:	8b 40 24             	mov    0x24(%eax),%eax
80103fc4:	85 c0                	test   %eax,%eax
80103fc6:	74 15                	je     80103fdd <piperead+0x35>
      release(&p->lock);
80103fc8:	8b 45 08             	mov    0x8(%ebp),%eax
80103fcb:	89 04 24             	mov    %eax,(%esp)
80103fce:	e8 e2 10 00 00       	call   801050b5 <release>
      return -1;
80103fd3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103fd8:	e9 b5 00 00 00       	jmp    80104092 <piperead+0xea>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103fdd:	8b 45 08             	mov    0x8(%ebp),%eax
80103fe0:	8b 55 08             	mov    0x8(%ebp),%edx
80103fe3:	81 c2 34 02 00 00    	add    $0x234,%edx
80103fe9:	89 44 24 04          	mov    %eax,0x4(%esp)
80103fed:	89 14 24             	mov    %edx,(%esp)
80103ff0:	e8 a7 0a 00 00       	call   80104a9c <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103ff5:	8b 45 08             	mov    0x8(%ebp),%eax
80103ff8:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80103ffe:	8b 45 08             	mov    0x8(%ebp),%eax
80104001:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104007:	39 c2                	cmp    %eax,%edx
80104009:	75 0d                	jne    80104018 <piperead+0x70>
8010400b:	8b 45 08             	mov    0x8(%ebp),%eax
8010400e:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104014:	85 c0                	test   %eax,%eax
80104016:	75 a4                	jne    80103fbc <piperead+0x14>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104018:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010401f:	eb 4b                	jmp    8010406c <piperead+0xc4>
    if(p->nread == p->nwrite)
80104021:	8b 45 08             	mov    0x8(%ebp),%eax
80104024:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
8010402a:	8b 45 08             	mov    0x8(%ebp),%eax
8010402d:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104033:	39 c2                	cmp    %eax,%edx
80104035:	75 02                	jne    80104039 <piperead+0x91>
      break;
80104037:	eb 3b                	jmp    80104074 <piperead+0xcc>
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104039:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010403c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010403f:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80104042:	8b 45 08             	mov    0x8(%ebp),%eax
80104045:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
8010404b:	8d 48 01             	lea    0x1(%eax),%ecx
8010404e:	8b 55 08             	mov    0x8(%ebp),%edx
80104051:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
80104057:	25 ff 01 00 00       	and    $0x1ff,%eax
8010405c:	89 c2                	mov    %eax,%edx
8010405e:	8b 45 08             	mov    0x8(%ebp),%eax
80104061:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
80104066:	88 03                	mov    %al,(%ebx)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104068:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010406c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010406f:	3b 45 10             	cmp    0x10(%ebp),%eax
80104072:	7c ad                	jl     80104021 <piperead+0x79>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80104074:	8b 45 08             	mov    0x8(%ebp),%eax
80104077:	05 38 02 00 00       	add    $0x238,%eax
8010407c:	89 04 24             	mov    %eax,(%esp)
8010407f:	e8 ef 0a 00 00       	call   80104b73 <wakeup>
  release(&p->lock);
80104084:	8b 45 08             	mov    0x8(%ebp),%eax
80104087:	89 04 24             	mov    %eax,(%esp)
8010408a:	e8 26 10 00 00       	call   801050b5 <release>
  return i;
8010408f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104092:	83 c4 24             	add    $0x24,%esp
80104095:	5b                   	pop    %ebx
80104096:	5d                   	pop    %ebp
80104097:	c3                   	ret    

80104098 <readeflags>:
{
80104098:	55                   	push   %ebp
80104099:	89 e5                	mov    %esp,%ebp
8010409b:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010409e:	9c                   	pushf  
8010409f:	58                   	pop    %eax
801040a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801040a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801040a6:	c9                   	leave  
801040a7:	c3                   	ret    

801040a8 <sti>:
{
801040a8:	55                   	push   %ebp
801040a9:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801040ab:	fb                   	sti    
}
801040ac:	5d                   	pop    %ebp
801040ad:	c3                   	ret    

801040ae <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
801040ae:	55                   	push   %ebp
801040af:	89 e5                	mov    %esp,%ebp
801040b1:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
801040b4:	c7 44 24 04 38 88 10 	movl   $0x80108838,0x4(%esp)
801040bb:	80 
801040bc:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
801040c3:	e8 64 0f 00 00       	call   8010502c <initlock>
}
801040c8:	c9                   	leave  
801040c9:	c3                   	ret    

801040ca <cpuid>:

// Must be called with interrupts disabled
int
cpuid() {
801040ca:	55                   	push   %ebp
801040cb:	89 e5                	mov    %esp,%ebp
801040cd:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801040d0:	e8 16 00 00 00       	call   801040eb <mycpu>
801040d5:	89 c2                	mov    %eax,%edx
801040d7:	b8 40 38 11 80       	mov    $0x80113840,%eax
801040dc:	29 c2                	sub    %eax,%edx
801040de:	89 d0                	mov    %edx,%eax
801040e0:	c1 f8 04             	sar    $0x4,%eax
801040e3:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801040e9:	c9                   	leave  
801040ea:	c3                   	ret    

801040eb <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
801040eb:	55                   	push   %ebp
801040ec:	89 e5                	mov    %esp,%ebp
801040ee:	83 ec 28             	sub    $0x28,%esp
  int apicid, i;
  
  if(readeflags()&FL_IF)
801040f1:	e8 a2 ff ff ff       	call   80104098 <readeflags>
801040f6:	25 00 02 00 00       	and    $0x200,%eax
801040fb:	85 c0                	test   %eax,%eax
801040fd:	74 0c                	je     8010410b <mycpu+0x20>
    panic("mycpu called with interrupts enabled\n");
801040ff:	c7 04 24 40 88 10 80 	movl   $0x80108840,(%esp)
80104106:	e8 57 c4 ff ff       	call   80100562 <panic>
  
  apicid = lapicid();
8010410b:	e8 1f ee ff ff       	call   80102f2f <lapicid>
80104110:	89 45 f0             	mov    %eax,-0x10(%ebp)
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80104113:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010411a:	eb 2d                	jmp    80104149 <mycpu+0x5e>
    if (cpus[i].apicid == apicid)
8010411c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010411f:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80104125:	05 40 38 11 80       	add    $0x80113840,%eax
8010412a:	0f b6 00             	movzbl (%eax),%eax
8010412d:	0f b6 c0             	movzbl %al,%eax
80104130:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80104133:	75 10                	jne    80104145 <mycpu+0x5a>
      return &cpus[i];
80104135:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104138:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
8010413e:	05 40 38 11 80       	add    $0x80113840,%eax
80104143:	eb 1a                	jmp    8010415f <mycpu+0x74>
  for (i = 0; i < ncpu; ++i) {
80104145:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104149:	a1 c0 3d 11 80       	mov    0x80113dc0,%eax
8010414e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80104151:	7c c9                	jl     8010411c <mycpu+0x31>
  }
  panic("unknown apicid\n");
80104153:	c7 04 24 66 88 10 80 	movl   $0x80108866,(%esp)
8010415a:	e8 03 c4 ff ff       	call   80100562 <panic>
}
8010415f:	c9                   	leave  
80104160:	c3                   	ret    

80104161 <myproc>:

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
80104161:	55                   	push   %ebp
80104162:	89 e5                	mov    %esp,%ebp
80104164:	83 ec 18             	sub    $0x18,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
80104167:	e8 4e 10 00 00       	call   801051ba <pushcli>
  c = mycpu();
8010416c:	e8 7a ff ff ff       	call   801040eb <mycpu>
80104171:	89 45 f4             	mov    %eax,-0xc(%ebp)
  p = c->proc;
80104174:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104177:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010417d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  popcli();
80104180:	e8 81 10 00 00       	call   80105206 <popcli>
  return p;
80104185:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80104188:	c9                   	leave  
80104189:	c3                   	ret    

8010418a <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
8010418a:	55                   	push   %ebp
8010418b:	89 e5                	mov    %esp,%ebp
8010418d:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80104190:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
80104197:	e8 b1 0e 00 00       	call   8010504d <acquire>

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010419c:	c7 45 f4 14 3e 11 80 	movl   $0x80113e14,-0xc(%ebp)
801041a3:	eb 53                	jmp    801041f8 <allocproc+0x6e>
    if(p->state == UNUSED)
801041a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041a8:	8b 40 0c             	mov    0xc(%eax),%eax
801041ab:	85 c0                	test   %eax,%eax
801041ad:	75 42                	jne    801041f1 <allocproc+0x67>
      goto found;
801041af:	90                   	nop

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
801041b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041b3:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
801041ba:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801041bf:	8d 50 01             	lea    0x1(%eax),%edx
801041c2:	89 15 00 b0 10 80    	mov    %edx,0x8010b000
801041c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041cb:	89 42 10             	mov    %eax,0x10(%edx)

  release(&ptable.lock);
801041ce:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
801041d5:	e8 db 0e 00 00       	call   801050b5 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801041da:	e8 ca e9 ff ff       	call   80102ba9 <kalloc>
801041df:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041e2:	89 42 08             	mov    %eax,0x8(%edx)
801041e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041e8:	8b 40 08             	mov    0x8(%eax),%eax
801041eb:	85 c0                	test   %eax,%eax
801041ed:	75 36                	jne    80104225 <allocproc+0x9b>
801041ef:	eb 23                	jmp    80104214 <allocproc+0x8a>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041f1:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
801041f8:	81 7d f4 14 5f 11 80 	cmpl   $0x80115f14,-0xc(%ebp)
801041ff:	72 a4                	jb     801041a5 <allocproc+0x1b>
  release(&ptable.lock);
80104201:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
80104208:	e8 a8 0e 00 00       	call   801050b5 <release>
  return 0;
8010420d:	b8 00 00 00 00       	mov    $0x0,%eax
80104212:	eb 76                	jmp    8010428a <allocproc+0x100>
    p->state = UNUSED;
80104214:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104217:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
8010421e:	b8 00 00 00 00       	mov    $0x0,%eax
80104223:	eb 65                	jmp    8010428a <allocproc+0x100>
  }
  sp = p->kstack + KSTACKSIZE;
80104225:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104228:	8b 40 08             	mov    0x8(%eax),%eax
8010422b:	05 00 10 00 00       	add    $0x1000,%eax
80104230:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104233:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
80104237:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010423a:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010423d:	89 50 18             	mov    %edx,0x18(%eax)

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
80104240:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
80104244:	ba d4 66 10 80       	mov    $0x801066d4,%edx
80104249:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010424c:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
8010424e:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
80104252:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104255:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104258:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
8010425b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010425e:	8b 40 1c             	mov    0x1c(%eax),%eax
80104261:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104268:	00 
80104269:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104270:	00 
80104271:	89 04 24             	mov    %eax,(%esp)
80104274:	e8 46 10 00 00       	call   801052bf <memset>
  p->context->eip = (uint)forkret;
80104279:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010427c:	8b 40 1c             	mov    0x1c(%eax),%eax
8010427f:	ba 5d 4a 10 80       	mov    $0x80104a5d,%edx
80104284:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
80104287:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010428a:	c9                   	leave  
8010428b:	c3                   	ret    

8010428c <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
8010428c:	55                   	push   %ebp
8010428d:	89 e5                	mov    %esp,%ebp
8010428f:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
80104292:	e8 f3 fe ff ff       	call   8010418a <allocproc>
80104297:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  initproc = p;
8010429a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010429d:	a3 60 b6 10 80       	mov    %eax,0x8010b660
  if((p->pgdir = setupkvm()) == 0)
801042a2:	e8 aa 39 00 00       	call   80107c51 <setupkvm>
801042a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042aa:	89 42 04             	mov    %eax,0x4(%edx)
801042ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042b0:	8b 40 04             	mov    0x4(%eax),%eax
801042b3:	85 c0                	test   %eax,%eax
801042b5:	75 0c                	jne    801042c3 <userinit+0x37>
    panic("userinit: out of memory?");
801042b7:	c7 04 24 76 88 10 80 	movl   $0x80108876,(%esp)
801042be:	e8 9f c2 ff ff       	call   80100562 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801042c3:	ba 2c 00 00 00       	mov    $0x2c,%edx
801042c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042cb:	8b 40 04             	mov    0x4(%eax),%eax
801042ce:	89 54 24 08          	mov    %edx,0x8(%esp)
801042d2:	c7 44 24 04 00 b5 10 	movl   $0x8010b500,0x4(%esp)
801042d9:	80 
801042da:	89 04 24             	mov    %eax,(%esp)
801042dd:	e8 da 3b 00 00       	call   80107ebc <inituvm>
  p->sz = PGSIZE;
801042e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042e5:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
801042eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042ee:	8b 40 18             	mov    0x18(%eax),%eax
801042f1:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
801042f8:	00 
801042f9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104300:	00 
80104301:	89 04 24             	mov    %eax,(%esp)
80104304:	e8 b6 0f 00 00       	call   801052bf <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104309:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010430c:	8b 40 18             	mov    0x18(%eax),%eax
8010430f:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104315:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104318:	8b 40 18             	mov    0x18(%eax),%eax
8010431b:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104321:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104324:	8b 40 18             	mov    0x18(%eax),%eax
80104327:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010432a:	8b 52 18             	mov    0x18(%edx),%edx
8010432d:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104331:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104335:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104338:	8b 40 18             	mov    0x18(%eax),%eax
8010433b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010433e:	8b 52 18             	mov    0x18(%edx),%edx
80104341:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104345:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104349:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010434c:	8b 40 18             	mov    0x18(%eax),%eax
8010434f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104356:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104359:	8b 40 18             	mov    0x18(%eax),%eax
8010435c:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104363:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104366:	8b 40 18             	mov    0x18(%eax),%eax
80104369:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  p->tickets = 10;
80104370:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104373:	c7 40 7c 0a 00 00 00 	movl   $0xa,0x7c(%eax)
  p->ticks = 0;
8010437a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010437d:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80104384:	00 00 00 
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104387:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010438a:	83 c0 6c             	add    $0x6c,%eax
8010438d:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104394:	00 
80104395:	c7 44 24 04 8f 88 10 	movl   $0x8010888f,0x4(%esp)
8010439c:	80 
8010439d:	89 04 24             	mov    %eax,(%esp)
801043a0:	e8 3a 11 00 00       	call   801054df <safestrcpy>
  p->cwd = namei("/");
801043a5:	c7 04 24 98 88 10 80 	movl   $0x80108898,(%esp)
801043ac:	e8 e6 e0 ff ff       	call   80102497 <namei>
801043b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043b4:	89 42 68             	mov    %eax,0x68(%edx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
801043b7:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
801043be:	e8 8a 0c 00 00       	call   8010504d <acquire>

  p->state = RUNNABLE;
801043c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043c6:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
801043cd:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
801043d4:	e8 dc 0c 00 00       	call   801050b5 <release>
}
801043d9:	c9                   	leave  
801043da:	c3                   	ret    

801043db <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801043db:	55                   	push   %ebp
801043dc:	89 e5                	mov    %esp,%ebp
801043de:	83 ec 28             	sub    $0x28,%esp
  uint sz;
  struct proc *curproc = myproc();
801043e1:	e8 7b fd ff ff       	call   80104161 <myproc>
801043e6:	89 45 f0             	mov    %eax,-0x10(%ebp)

  sz = curproc->sz;
801043e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801043ec:	8b 00                	mov    (%eax),%eax
801043ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
801043f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801043f5:	7e 31                	jle    80104428 <growproc+0x4d>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801043f7:	8b 55 08             	mov    0x8(%ebp),%edx
801043fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043fd:	01 c2                	add    %eax,%edx
801043ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104402:	8b 40 04             	mov    0x4(%eax),%eax
80104405:	89 54 24 08          	mov    %edx,0x8(%esp)
80104409:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010440c:	89 54 24 04          	mov    %edx,0x4(%esp)
80104410:	89 04 24             	mov    %eax,(%esp)
80104413:	e8 0f 3c 00 00       	call   80108027 <allocuvm>
80104418:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010441b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010441f:	75 3e                	jne    8010445f <growproc+0x84>
      return -1;
80104421:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104426:	eb 4f                	jmp    80104477 <growproc+0x9c>
  } else if(n < 0){
80104428:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010442c:	79 31                	jns    8010445f <growproc+0x84>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010442e:	8b 55 08             	mov    0x8(%ebp),%edx
80104431:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104434:	01 c2                	add    %eax,%edx
80104436:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104439:	8b 40 04             	mov    0x4(%eax),%eax
8010443c:	89 54 24 08          	mov    %edx,0x8(%esp)
80104440:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104443:	89 54 24 04          	mov    %edx,0x4(%esp)
80104447:	89 04 24             	mov    %eax,(%esp)
8010444a:	e8 ee 3c 00 00       	call   8010813d <deallocuvm>
8010444f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104452:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104456:	75 07                	jne    8010445f <growproc+0x84>
      return -1;
80104458:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010445d:	eb 18                	jmp    80104477 <growproc+0x9c>
  }
  curproc->sz = sz;
8010445f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104462:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104465:	89 10                	mov    %edx,(%eax)
  switchuvm(curproc);
80104467:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010446a:	89 04 24             	mov    %eax,(%esp)
8010446d:	e8 b9 38 00 00       	call   80107d2b <switchuvm>
  return 0;
80104472:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104477:	c9                   	leave  
80104478:	c3                   	ret    

80104479 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80104479:	55                   	push   %ebp
8010447a:	89 e5                	mov    %esp,%ebp
8010447c:	57                   	push   %edi
8010447d:	56                   	push   %esi
8010447e:	53                   	push   %ebx
8010447f:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();
80104482:	e8 da fc ff ff       	call   80104161 <myproc>
80104487:	89 45 e0             	mov    %eax,-0x20(%ebp)

  // Allocate process.
  if((np = allocproc()) == 0){
8010448a:	e8 fb fc ff ff       	call   8010418a <allocproc>
8010448f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80104492:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80104496:	75 0a                	jne    801044a2 <fork+0x29>
    return -1;
80104498:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010449d:	e9 66 01 00 00       	jmp    80104608 <fork+0x18f>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801044a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801044a5:	8b 10                	mov    (%eax),%edx
801044a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801044aa:	8b 40 04             	mov    0x4(%eax),%eax
801044ad:	89 54 24 04          	mov    %edx,0x4(%esp)
801044b1:	89 04 24             	mov    %eax,(%esp)
801044b4:	e8 27 3e 00 00       	call   801082e0 <copyuvm>
801044b9:	8b 55 dc             	mov    -0x24(%ebp),%edx
801044bc:	89 42 04             	mov    %eax,0x4(%edx)
801044bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
801044c2:	8b 40 04             	mov    0x4(%eax),%eax
801044c5:	85 c0                	test   %eax,%eax
801044c7:	75 2c                	jne    801044f5 <fork+0x7c>
    kfree(np->kstack);
801044c9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801044cc:	8b 40 08             	mov    0x8(%eax),%eax
801044cf:	89 04 24             	mov    %eax,(%esp)
801044d2:	e8 3c e6 ff ff       	call   80102b13 <kfree>
    np->kstack = 0;
801044d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
801044da:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
801044e1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801044e4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
801044eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044f0:	e9 13 01 00 00       	jmp    80104608 <fork+0x18f>
  }
  np->sz = curproc->sz;
801044f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801044f8:	8b 10                	mov    (%eax),%edx
801044fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
801044fd:	89 10                	mov    %edx,(%eax)
  np->parent = curproc;
801044ff:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104502:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104505:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *curproc->tf;
80104508:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010450b:	8b 50 18             	mov    0x18(%eax),%edx
8010450e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104511:	8b 40 18             	mov    0x18(%eax),%eax
80104514:	89 c3                	mov    %eax,%ebx
80104516:	b8 13 00 00 00       	mov    $0x13,%eax
8010451b:	89 d7                	mov    %edx,%edi
8010451d:	89 de                	mov    %ebx,%esi
8010451f:	89 c1                	mov    %eax,%ecx
80104521:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104523:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104526:	8b 40 18             	mov    0x18(%eax),%eax
80104529:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104530:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104537:	eb 37                	jmp    80104570 <fork+0xf7>
    if(curproc->ofile[i])
80104539:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010453c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010453f:	83 c2 08             	add    $0x8,%edx
80104542:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104546:	85 c0                	test   %eax,%eax
80104548:	74 22                	je     8010456c <fork+0xf3>
      np->ofile[i] = filedup(curproc->ofile[i]);
8010454a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010454d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104550:	83 c2 08             	add    $0x8,%edx
80104553:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104557:	89 04 24             	mov    %eax,(%esp)
8010455a:	e8 86 ca ff ff       	call   80100fe5 <filedup>
8010455f:	8b 55 dc             	mov    -0x24(%ebp),%edx
80104562:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104565:	83 c1 08             	add    $0x8,%ecx
80104568:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  for(i = 0; i < NOFILE; i++)
8010456c:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104570:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104574:	7e c3                	jle    80104539 <fork+0xc0>
  np->cwd = idup(curproc->cwd);
80104576:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104579:	8b 40 68             	mov    0x68(%eax),%eax
8010457c:	89 04 24             	mov    %eax,(%esp)
8010457f:	e8 a7 d3 ff ff       	call   8010192b <idup>
80104584:	8b 55 dc             	mov    -0x24(%ebp),%edx
80104587:	89 42 68             	mov    %eax,0x68(%edx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010458a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010458d:	8d 50 6c             	lea    0x6c(%eax),%edx
80104590:	8b 45 dc             	mov    -0x24(%ebp),%eax
80104593:	83 c0 6c             	add    $0x6c,%eax
80104596:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
8010459d:	00 
8010459e:	89 54 24 04          	mov    %edx,0x4(%esp)
801045a2:	89 04 24             	mov    %eax,(%esp)
801045a5:	e8 35 0f 00 00       	call   801054df <safestrcpy>

  pid = np->pid;
801045aa:	8b 45 dc             	mov    -0x24(%ebp),%eax
801045ad:	8b 40 10             	mov    0x10(%eax),%eax
801045b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  
  np->ticks = 0;
801045b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
801045b6:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801045bd:	00 00 00 
  if(curproc->tickets > 10)
801045c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801045c3:	8b 40 7c             	mov    0x7c(%eax),%eax
801045c6:	83 f8 0a             	cmp    $0xa,%eax
801045c9:	7e 0e                	jle    801045d9 <fork+0x160>
      np->tickets = curproc->tickets;
801045cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801045ce:	8b 50 7c             	mov    0x7c(%eax),%edx
801045d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801045d4:	89 50 7c             	mov    %edx,0x7c(%eax)
801045d7:	eb 0a                	jmp    801045e3 <fork+0x16a>
  else
      np->tickets = 10;
801045d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
801045dc:	c7 40 7c 0a 00 00 00 	movl   $0xa,0x7c(%eax)

  acquire(&ptable.lock);
801045e3:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
801045ea:	e8 5e 0a 00 00       	call   8010504d <acquire>

  np->state = RUNNABLE;
801045ef:	8b 45 dc             	mov    -0x24(%ebp),%eax
801045f2:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
801045f9:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
80104600:	e8 b0 0a 00 00       	call   801050b5 <release>

  return pid;
80104605:	8b 45 d8             	mov    -0x28(%ebp),%eax
}
80104608:	83 c4 2c             	add    $0x2c,%esp
8010460b:	5b                   	pop    %ebx
8010460c:	5e                   	pop    %esi
8010460d:	5f                   	pop    %edi
8010460e:	5d                   	pop    %ebp
8010460f:	c3                   	ret    

80104610 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104610:	55                   	push   %ebp
80104611:	89 e5                	mov    %esp,%ebp
80104613:	83 ec 28             	sub    $0x28,%esp
  struct proc *curproc = myproc();
80104616:	e8 46 fb ff ff       	call   80104161 <myproc>
8010461b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  struct proc *p;
  int fd;

  if(curproc == initproc)
8010461e:	a1 60 b6 10 80       	mov    0x8010b660,%eax
80104623:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80104626:	75 0c                	jne    80104634 <exit+0x24>
    panic("init exiting");
80104628:	c7 04 24 9a 88 10 80 	movl   $0x8010889a,(%esp)
8010462f:	e8 2e bf ff ff       	call   80100562 <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104634:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
8010463b:	eb 3b                	jmp    80104678 <exit+0x68>
    if(curproc->ofile[fd]){
8010463d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104640:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104643:	83 c2 08             	add    $0x8,%edx
80104646:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010464a:	85 c0                	test   %eax,%eax
8010464c:	74 26                	je     80104674 <exit+0x64>
      fileclose(curproc->ofile[fd]);
8010464e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104651:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104654:	83 c2 08             	add    $0x8,%edx
80104657:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010465b:	89 04 24             	mov    %eax,(%esp)
8010465e:	e8 ca c9 ff ff       	call   8010102d <fileclose>
      curproc->ofile[fd] = 0;
80104663:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104666:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104669:	83 c2 08             	add    $0x8,%edx
8010466c:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104673:	00 
  for(fd = 0; fd < NOFILE; fd++){
80104674:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104678:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
8010467c:	7e bf                	jle    8010463d <exit+0x2d>
    }
  }

  begin_op();
8010467e:	e8 04 ee ff ff       	call   80103487 <begin_op>
  iput(curproc->cwd);
80104683:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104686:	8b 40 68             	mov    0x68(%eax),%eax
80104689:	89 04 24             	mov    %eax,(%esp)
8010468c:	e8 1d d4 ff ff       	call   80101aae <iput>
  end_op();
80104691:	e8 75 ee ff ff       	call   8010350b <end_op>
  curproc->cwd = 0;
80104696:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104699:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
801046a0:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
801046a7:	e8 a1 09 00 00       	call   8010504d <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
801046ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
801046af:	8b 40 14             	mov    0x14(%eax),%eax
801046b2:	89 04 24             	mov    %eax,(%esp)
801046b5:	e8 78 04 00 00       	call   80104b32 <wakeup1>

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046ba:	c7 45 f4 14 3e 11 80 	movl   $0x80113e14,-0xc(%ebp)
801046c1:	eb 36                	jmp    801046f9 <exit+0xe9>
    if(p->parent == curproc){
801046c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046c6:	8b 40 14             	mov    0x14(%eax),%eax
801046c9:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801046cc:	75 24                	jne    801046f2 <exit+0xe2>
      p->parent = initproc;
801046ce:	8b 15 60 b6 10 80    	mov    0x8010b660,%edx
801046d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046d7:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
801046da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046dd:	8b 40 0c             	mov    0xc(%eax),%eax
801046e0:	83 f8 05             	cmp    $0x5,%eax
801046e3:	75 0d                	jne    801046f2 <exit+0xe2>
        wakeup1(initproc);
801046e5:	a1 60 b6 10 80       	mov    0x8010b660,%eax
801046ea:	89 04 24             	mov    %eax,(%esp)
801046ed:	e8 40 04 00 00       	call   80104b32 <wakeup1>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046f2:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
801046f9:	81 7d f4 14 5f 11 80 	cmpl   $0x80115f14,-0xc(%ebp)
80104700:	72 c1                	jb     801046c3 <exit+0xb3>
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80104702:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104705:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
8010470c:	e8 6c 02 00 00       	call   8010497d <sched>
  panic("zombie exit");
80104711:	c7 04 24 a7 88 10 80 	movl   $0x801088a7,(%esp)
80104718:	e8 45 be ff ff       	call   80100562 <panic>

8010471d <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
8010471d:	55                   	push   %ebp
8010471e:	89 e5                	mov    %esp,%ebp
80104720:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80104723:	e8 39 fa ff ff       	call   80104161 <myproc>
80104728:	89 45 ec             	mov    %eax,-0x14(%ebp)
  
  acquire(&ptable.lock);
8010472b:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
80104732:	e8 16 09 00 00       	call   8010504d <acquire>
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80104737:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010473e:	c7 45 f4 14 3e 11 80 	movl   $0x80113e14,-0xc(%ebp)
80104745:	e9 98 00 00 00       	jmp    801047e2 <wait+0xc5>
      if(p->parent != curproc)
8010474a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010474d:	8b 40 14             	mov    0x14(%eax),%eax
80104750:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80104753:	74 05                	je     8010475a <wait+0x3d>
        continue;
80104755:	e9 81 00 00 00       	jmp    801047db <wait+0xbe>
      havekids = 1;
8010475a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104761:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104764:	8b 40 0c             	mov    0xc(%eax),%eax
80104767:	83 f8 05             	cmp    $0x5,%eax
8010476a:	75 6f                	jne    801047db <wait+0xbe>
        // Found one.
        pid = p->pid;
8010476c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010476f:	8b 40 10             	mov    0x10(%eax),%eax
80104772:	89 45 e8             	mov    %eax,-0x18(%ebp)
        kfree(p->kstack);
80104775:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104778:	8b 40 08             	mov    0x8(%eax),%eax
8010477b:	89 04 24             	mov    %eax,(%esp)
8010477e:	e8 90 e3 ff ff       	call   80102b13 <kfree>
        p->kstack = 0;
80104783:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104786:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
8010478d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104790:	8b 40 04             	mov    0x4(%eax),%eax
80104793:	89 04 24             	mov    %eax,(%esp)
80104796:	e8 68 3a 00 00       	call   80108203 <freevm>
        p->pid = 0;
8010479b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010479e:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
801047a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047a8:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
801047af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047b2:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
801047b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047b9:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->state = UNUSED;
801047c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047c3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        release(&ptable.lock);
801047ca:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
801047d1:	e8 df 08 00 00       	call   801050b5 <release>
        return pid;
801047d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
801047d9:	eb 4f                	jmp    8010482a <wait+0x10d>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047db:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
801047e2:	81 7d f4 14 5f 11 80 	cmpl   $0x80115f14,-0xc(%ebp)
801047e9:	0f 82 5b ff ff ff    	jb     8010474a <wait+0x2d>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
801047ef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801047f3:	74 0a                	je     801047ff <wait+0xe2>
801047f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
801047f8:	8b 40 24             	mov    0x24(%eax),%eax
801047fb:	85 c0                	test   %eax,%eax
801047fd:	74 13                	je     80104812 <wait+0xf5>
      release(&ptable.lock);
801047ff:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
80104806:	e8 aa 08 00 00       	call   801050b5 <release>
      return -1;
8010480b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104810:	eb 18                	jmp    8010482a <wait+0x10d>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104812:	c7 44 24 04 e0 3d 11 	movl   $0x80113de0,0x4(%esp)
80104819:	80 
8010481a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010481d:	89 04 24             	mov    %eax,(%esp)
80104820:	e8 77 02 00 00       	call   80104a9c <sleep>
  }
80104825:	e9 0d ff ff ff       	jmp    80104737 <wait+0x1a>
}
8010482a:	c9                   	leave  
8010482b:	c3                   	ret    

8010482c <random>:

static int rseed = 1898888478;
int random()
{
8010482c:	55                   	push   %ebp
8010482d:	89 e5                	mov    %esp,%ebp
  return rseed = (rseed * 1103515245 + 12345) & RAND_MAX;
8010482f:	a1 04 b0 10 80       	mov    0x8010b004,%eax
80104834:	69 c0 6d 4e c6 41    	imul   $0x41c64e6d,%eax,%eax
8010483a:	05 39 30 00 00       	add    $0x3039,%eax
8010483f:	25 ff ff ff 7f       	and    $0x7fffffff,%eax
80104844:	a3 04 b0 10 80       	mov    %eax,0x8010b004
80104849:	a1 04 b0 10 80       	mov    0x8010b004,%eax
}
8010484e:	5d                   	pop    %ebp
8010484f:	c3                   	ret    

80104850 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104850:	55                   	push   %ebp
80104851:	89 e5                	mov    %esp,%ebp
80104853:	83 ec 38             	sub    $0x38,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80104856:	e8 90 f8 ff ff       	call   801040eb <mycpu>
8010485b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  c->proc = 0;
8010485e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104861:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104868:	00 00 00 
  
  for(;;){

    // Enable interrupts on this processor.
    sti();
8010486b:	e8 38 f8 ff ff       	call   801040a8 <sti>
    int runnableTickets = 0;
80104870:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    int randomNum;
    int counter = 0;
80104877:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
8010487e:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
80104885:	e8 c3 07 00 00       	call   8010504d <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010488a:	c7 45 f4 14 3e 11 80 	movl   $0x80113e14,-0xc(%ebp)
80104891:	eb 1d                	jmp    801048b0 <scheduler+0x60>
      if(p->state != RUNNABLE)
80104893:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104896:	8b 40 0c             	mov    0xc(%eax),%eax
80104899:	83 f8 03             	cmp    $0x3,%eax
8010489c:	74 02                	je     801048a0 <scheduler+0x50>
        continue;
8010489e:	eb 09                	jmp    801048a9 <scheduler+0x59>
      runnableTickets += p->tickets;
801048a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048a3:	8b 40 7c             	mov    0x7c(%eax),%eax
801048a6:	01 45 f0             	add    %eax,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801048a9:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
801048b0:	81 7d f4 14 5f 11 80 	cmpl   $0x80115f14,-0xc(%ebp)
801048b7:	72 da                	jb     80104893 <scheduler+0x43>
    } 
    
    if(runnableTickets <= 0)
801048b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801048bd:	7f 0f                	jg     801048ce <scheduler+0x7e>
    {
        release(&ptable.lock);
801048bf:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
801048c6:	e8 ea 07 00 00       	call   801050b5 <release>
        continue;
801048cb:	90                   	nop
    p->ticks += 1;
    swtch(&(c->scheduler), p->context);
    switchkvm();
    c->proc = 0;
    release(&ptable.lock);
  }
801048cc:	eb 9d                	jmp    8010486b <scheduler+0x1b>
    randomNum = random();
801048ce:	e8 59 ff ff ff       	call   8010482c <random>
801048d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    int winner = randomNum % runnableTickets;
801048d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801048d9:	99                   	cltd   
801048da:	f7 7d f0             	idivl  -0x10(%ebp)
801048dd:	89 55 e0             	mov    %edx,-0x20(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801048e0:	c7 45 f4 14 3e 11 80 	movl   $0x80113e14,-0xc(%ebp)
801048e7:	eb 1a                	jmp    80104903 <scheduler+0xb3>
      counter = counter + p->tickets;
801048e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048ec:	8b 40 7c             	mov    0x7c(%eax),%eax
801048ef:	01 45 ec             	add    %eax,-0x14(%ebp)
      if(counter > winner)
801048f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801048f5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
801048f8:	7e 02                	jle    801048fc <scheduler+0xac>
        break;
801048fa:	eb 10                	jmp    8010490c <scheduler+0xbc>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801048fc:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104903:	81 7d f4 14 5f 11 80 	cmpl   $0x80115f14,-0xc(%ebp)
8010490a:	72 dd                	jb     801048e9 <scheduler+0x99>
    c->proc = p;
8010490c:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010490f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104912:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
    switchuvm(p);
80104918:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010491b:	89 04 24             	mov    %eax,(%esp)
8010491e:	e8 08 34 00 00       	call   80107d2b <switchuvm>
    p->state = RUNNING;
80104923:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104926:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
    p->ticks += 1;
8010492d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104930:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104936:	8d 50 01             	lea    0x1(%eax),%edx
80104939:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010493c:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
    swtch(&(c->scheduler), p->context);
80104942:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104945:	8b 40 1c             	mov    0x1c(%eax),%eax
80104948:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010494b:	83 c2 04             	add    $0x4,%edx
8010494e:	89 44 24 04          	mov    %eax,0x4(%esp)
80104952:	89 14 24             	mov    %edx,(%esp)
80104955:	e8 f6 0b 00 00       	call   80105550 <swtch>
    switchkvm();
8010495a:	e8 b2 33 00 00       	call   80107d11 <switchkvm>
    c->proc = 0;
8010495f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104962:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104969:	00 00 00 
    release(&ptable.lock);
8010496c:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
80104973:	e8 3d 07 00 00       	call   801050b5 <release>
  }
80104978:	e9 ee fe ff ff       	jmp    8010486b <scheduler+0x1b>

8010497d <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
8010497d:	55                   	push   %ebp
8010497e:	89 e5                	mov    %esp,%ebp
80104980:	83 ec 28             	sub    $0x28,%esp
  int intena;
  struct proc *p = myproc();
80104983:	e8 d9 f7 ff ff       	call   80104161 <myproc>
80104988:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(!holding(&ptable.lock))
8010498b:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
80104992:	e8 e2 07 00 00       	call   80105179 <holding>
80104997:	85 c0                	test   %eax,%eax
80104999:	75 0c                	jne    801049a7 <sched+0x2a>
    panic("sched ptable.lock");
8010499b:	c7 04 24 b3 88 10 80 	movl   $0x801088b3,(%esp)
801049a2:	e8 bb bb ff ff       	call   80100562 <panic>
  if(mycpu()->ncli != 1)
801049a7:	e8 3f f7 ff ff       	call   801040eb <mycpu>
801049ac:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801049b2:	83 f8 01             	cmp    $0x1,%eax
801049b5:	74 0c                	je     801049c3 <sched+0x46>
    panic("sched locks");
801049b7:	c7 04 24 c5 88 10 80 	movl   $0x801088c5,(%esp)
801049be:	e8 9f bb ff ff       	call   80100562 <panic>
  if(p->state == RUNNING)
801049c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049c6:	8b 40 0c             	mov    0xc(%eax),%eax
801049c9:	83 f8 04             	cmp    $0x4,%eax
801049cc:	75 0c                	jne    801049da <sched+0x5d>
    panic("sched running");
801049ce:	c7 04 24 d1 88 10 80 	movl   $0x801088d1,(%esp)
801049d5:	e8 88 bb ff ff       	call   80100562 <panic>
  if(readeflags()&FL_IF)
801049da:	e8 b9 f6 ff ff       	call   80104098 <readeflags>
801049df:	25 00 02 00 00       	and    $0x200,%eax
801049e4:	85 c0                	test   %eax,%eax
801049e6:	74 0c                	je     801049f4 <sched+0x77>
    panic("sched interruptible");
801049e8:	c7 04 24 df 88 10 80 	movl   $0x801088df,(%esp)
801049ef:	e8 6e bb ff ff       	call   80100562 <panic>
  intena = mycpu()->intena;
801049f4:	e8 f2 f6 ff ff       	call   801040eb <mycpu>
801049f9:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801049ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  swtch(&p->context, mycpu()->scheduler);
80104a02:	e8 e4 f6 ff ff       	call   801040eb <mycpu>
80104a07:	8b 40 04             	mov    0x4(%eax),%eax
80104a0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104a0d:	83 c2 1c             	add    $0x1c,%edx
80104a10:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a14:	89 14 24             	mov    %edx,(%esp)
80104a17:	e8 34 0b 00 00       	call   80105550 <swtch>
  mycpu()->intena = intena;
80104a1c:	e8 ca f6 ff ff       	call   801040eb <mycpu>
80104a21:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104a24:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
}
80104a2a:	c9                   	leave  
80104a2b:	c3                   	ret    

80104a2c <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104a2c:	55                   	push   %ebp
80104a2d:	89 e5                	mov    %esp,%ebp
80104a2f:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104a32:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
80104a39:	e8 0f 06 00 00       	call   8010504d <acquire>
  myproc()->state = RUNNABLE;
80104a3e:	e8 1e f7 ff ff       	call   80104161 <myproc>
80104a43:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104a4a:	e8 2e ff ff ff       	call   8010497d <sched>
  release(&ptable.lock);
80104a4f:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
80104a56:	e8 5a 06 00 00       	call   801050b5 <release>
}
80104a5b:	c9                   	leave  
80104a5c:	c3                   	ret    

80104a5d <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104a5d:	55                   	push   %ebp
80104a5e:	89 e5                	mov    %esp,%ebp
80104a60:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104a63:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
80104a6a:	e8 46 06 00 00       	call   801050b5 <release>

  if (first) {
80104a6f:	a1 08 b0 10 80       	mov    0x8010b008,%eax
80104a74:	85 c0                	test   %eax,%eax
80104a76:	74 22                	je     80104a9a <forkret+0x3d>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80104a78:	c7 05 08 b0 10 80 00 	movl   $0x0,0x8010b008
80104a7f:	00 00 00 
    iinit(ROOTDEV);
80104a82:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104a89:	e8 62 cb ff ff       	call   801015f0 <iinit>
    initlog(ROOTDEV);
80104a8e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104a95:	e8 e9 e7 ff ff       	call   80103283 <initlog>
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104a9a:	c9                   	leave  
80104a9b:	c3                   	ret    

80104a9c <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104a9c:	55                   	push   %ebp
80104a9d:	89 e5                	mov    %esp,%ebp
80104a9f:	83 ec 28             	sub    $0x28,%esp
  struct proc *p = myproc();
80104aa2:	e8 ba f6 ff ff       	call   80104161 <myproc>
80104aa7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  if(p == 0)
80104aaa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104aae:	75 0c                	jne    80104abc <sleep+0x20>
    panic("sleep");
80104ab0:	c7 04 24 f3 88 10 80 	movl   $0x801088f3,(%esp)
80104ab7:	e8 a6 ba ff ff       	call   80100562 <panic>

  if(lk == 0)
80104abc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104ac0:	75 0c                	jne    80104ace <sleep+0x32>
    panic("sleep without lk");
80104ac2:	c7 04 24 f9 88 10 80 	movl   $0x801088f9,(%esp)
80104ac9:	e8 94 ba ff ff       	call   80100562 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104ace:	81 7d 0c e0 3d 11 80 	cmpl   $0x80113de0,0xc(%ebp)
80104ad5:	74 17                	je     80104aee <sleep+0x52>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104ad7:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
80104ade:	e8 6a 05 00 00       	call   8010504d <acquire>
    release(lk);
80104ae3:	8b 45 0c             	mov    0xc(%ebp),%eax
80104ae6:	89 04 24             	mov    %eax,(%esp)
80104ae9:	e8 c7 05 00 00       	call   801050b5 <release>
  }
  // Go to sleep.
  p->chan = chan;
80104aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104af1:	8b 55 08             	mov    0x8(%ebp),%edx
80104af4:	89 50 20             	mov    %edx,0x20(%eax)
  p->state = SLEEPING;
80104af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104afa:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

  sched();
80104b01:	e8 77 fe ff ff       	call   8010497d <sched>

  // Tidy up.
  p->chan = 0;
80104b06:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b09:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104b10:	81 7d 0c e0 3d 11 80 	cmpl   $0x80113de0,0xc(%ebp)
80104b17:	74 17                	je     80104b30 <sleep+0x94>
    release(&ptable.lock);
80104b19:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
80104b20:	e8 90 05 00 00       	call   801050b5 <release>
    acquire(lk);
80104b25:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b28:	89 04 24             	mov    %eax,(%esp)
80104b2b:	e8 1d 05 00 00       	call   8010504d <acquire>
  }
}
80104b30:	c9                   	leave  
80104b31:	c3                   	ret    

80104b32 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104b32:	55                   	push   %ebp
80104b33:	89 e5                	mov    %esp,%ebp
80104b35:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104b38:	c7 45 fc 14 3e 11 80 	movl   $0x80113e14,-0x4(%ebp)
80104b3f:	eb 27                	jmp    80104b68 <wakeup1+0x36>
    if(p->state == SLEEPING && p->chan == chan)
80104b41:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104b44:	8b 40 0c             	mov    0xc(%eax),%eax
80104b47:	83 f8 02             	cmp    $0x2,%eax
80104b4a:	75 15                	jne    80104b61 <wakeup1+0x2f>
80104b4c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104b4f:	8b 40 20             	mov    0x20(%eax),%eax
80104b52:	3b 45 08             	cmp    0x8(%ebp),%eax
80104b55:	75 0a                	jne    80104b61 <wakeup1+0x2f>
      p->state = RUNNABLE;
80104b57:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104b5a:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104b61:	81 45 fc 84 00 00 00 	addl   $0x84,-0x4(%ebp)
80104b68:	81 7d fc 14 5f 11 80 	cmpl   $0x80115f14,-0x4(%ebp)
80104b6f:	72 d0                	jb     80104b41 <wakeup1+0xf>
}
80104b71:	c9                   	leave  
80104b72:	c3                   	ret    

80104b73 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104b73:	55                   	push   %ebp
80104b74:	89 e5                	mov    %esp,%ebp
80104b76:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80104b79:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
80104b80:	e8 c8 04 00 00       	call   8010504d <acquire>
  wakeup1(chan);
80104b85:	8b 45 08             	mov    0x8(%ebp),%eax
80104b88:	89 04 24             	mov    %eax,(%esp)
80104b8b:	e8 a2 ff ff ff       	call   80104b32 <wakeup1>
  release(&ptable.lock);
80104b90:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
80104b97:	e8 19 05 00 00       	call   801050b5 <release>
}
80104b9c:	c9                   	leave  
80104b9d:	c3                   	ret    

80104b9e <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104b9e:	55                   	push   %ebp
80104b9f:	89 e5                	mov    %esp,%ebp
80104ba1:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104ba4:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
80104bab:	e8 9d 04 00 00       	call   8010504d <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bb0:	c7 45 f4 14 3e 11 80 	movl   $0x80113e14,-0xc(%ebp)
80104bb7:	eb 44                	jmp    80104bfd <kill+0x5f>
    if(p->pid == pid){
80104bb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bbc:	8b 40 10             	mov    0x10(%eax),%eax
80104bbf:	3b 45 08             	cmp    0x8(%ebp),%eax
80104bc2:	75 32                	jne    80104bf6 <kill+0x58>
      p->killed = 1;
80104bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bc7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bd1:	8b 40 0c             	mov    0xc(%eax),%eax
80104bd4:	83 f8 02             	cmp    $0x2,%eax
80104bd7:	75 0a                	jne    80104be3 <kill+0x45>
        p->state = RUNNABLE;
80104bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bdc:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104be3:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
80104bea:	e8 c6 04 00 00       	call   801050b5 <release>
      return 0;
80104bef:	b8 00 00 00 00       	mov    $0x0,%eax
80104bf4:	eb 21                	jmp    80104c17 <kill+0x79>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bf6:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104bfd:	81 7d f4 14 5f 11 80 	cmpl   $0x80115f14,-0xc(%ebp)
80104c04:	72 b3                	jb     80104bb9 <kill+0x1b>
    }
  }
  release(&ptable.lock);
80104c06:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
80104c0d:	e8 a3 04 00 00       	call   801050b5 <release>
  return -1;
80104c12:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c17:	c9                   	leave  
80104c18:	c3                   	ret    

80104c19 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104c19:	55                   	push   %ebp
80104c1a:	89 e5                	mov    %esp,%ebp
80104c1c:	83 ec 58             	sub    $0x58,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c1f:	c7 45 f0 14 3e 11 80 	movl   $0x80113e14,-0x10(%ebp)
80104c26:	e9 d9 00 00 00       	jmp    80104d04 <procdump+0xeb>
    if(p->state == UNUSED)
80104c2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c2e:	8b 40 0c             	mov    0xc(%eax),%eax
80104c31:	85 c0                	test   %eax,%eax
80104c33:	75 05                	jne    80104c3a <procdump+0x21>
      continue;
80104c35:	e9 c3 00 00 00       	jmp    80104cfd <procdump+0xe4>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104c3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c3d:	8b 40 0c             	mov    0xc(%eax),%eax
80104c40:	83 f8 05             	cmp    $0x5,%eax
80104c43:	77 23                	ja     80104c68 <procdump+0x4f>
80104c45:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c48:	8b 40 0c             	mov    0xc(%eax),%eax
80104c4b:	8b 04 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%eax
80104c52:	85 c0                	test   %eax,%eax
80104c54:	74 12                	je     80104c68 <procdump+0x4f>
      state = states[p->state];
80104c56:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c59:	8b 40 0c             	mov    0xc(%eax),%eax
80104c5c:	8b 04 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%eax
80104c63:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104c66:	eb 07                	jmp    80104c6f <procdump+0x56>
    else
      state = "???";
80104c68:	c7 45 ec 0a 89 10 80 	movl   $0x8010890a,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104c6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c72:	8d 50 6c             	lea    0x6c(%eax),%edx
80104c75:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c78:	8b 40 10             	mov    0x10(%eax),%eax
80104c7b:	89 54 24 0c          	mov    %edx,0xc(%esp)
80104c7f:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104c82:	89 54 24 08          	mov    %edx,0x8(%esp)
80104c86:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c8a:	c7 04 24 0e 89 10 80 	movl   $0x8010890e,(%esp)
80104c91:	e8 32 b7 ff ff       	call   801003c8 <cprintf>
    if(p->state == SLEEPING){
80104c96:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c99:	8b 40 0c             	mov    0xc(%eax),%eax
80104c9c:	83 f8 02             	cmp    $0x2,%eax
80104c9f:	75 50                	jne    80104cf1 <procdump+0xd8>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104ca1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ca4:	8b 40 1c             	mov    0x1c(%eax),%eax
80104ca7:	8b 40 0c             	mov    0xc(%eax),%eax
80104caa:	83 c0 08             	add    $0x8,%eax
80104cad:	8d 55 c4             	lea    -0x3c(%ebp),%edx
80104cb0:	89 54 24 04          	mov    %edx,0x4(%esp)
80104cb4:	89 04 24             	mov    %eax,(%esp)
80104cb7:	e8 44 04 00 00       	call   80105100 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104cbc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104cc3:	eb 1b                	jmp    80104ce0 <procdump+0xc7>
        cprintf(" %p", pc[i]);
80104cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cc8:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104ccc:	89 44 24 04          	mov    %eax,0x4(%esp)
80104cd0:	c7 04 24 17 89 10 80 	movl   $0x80108917,(%esp)
80104cd7:	e8 ec b6 ff ff       	call   801003c8 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104cdc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104ce0:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104ce4:	7f 0b                	jg     80104cf1 <procdump+0xd8>
80104ce6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ce9:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104ced:	85 c0                	test   %eax,%eax
80104cef:	75 d4                	jne    80104cc5 <procdump+0xac>
    }
    cprintf("\n");
80104cf1:	c7 04 24 1b 89 10 80 	movl   $0x8010891b,(%esp)
80104cf8:	e8 cb b6 ff ff       	call   801003c8 <cprintf>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104cfd:	81 45 f0 84 00 00 00 	addl   $0x84,-0x10(%ebp)
80104d04:	81 7d f0 14 5f 11 80 	cmpl   $0x80115f14,-0x10(%ebp)
80104d0b:	0f 82 1a ff ff ff    	jb     80104c2b <procdump+0x12>
  }
}
80104d11:	c9                   	leave  
80104d12:	c3                   	ret    

80104d13 <fillpstat>:
extern void fillpstat(pstatTable* pstat);
void fillpstat(pstatTable * pstat)
{
80104d13:	55                   	push   %ebp
80104d14:	89 e5                	mov    %esp,%ebp
80104d16:	53                   	push   %ebx
80104d17:	83 ec 24             	sub    $0x24,%esp
  struct proc *p;
  int i/*,j*/ = 0;
80104d1a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  acquire(&ptable.lock);
80104d21:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
80104d28:	e8 20 03 00 00       	call   8010504d <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d2d:	c7 45 f4 14 3e 11 80 	movl   $0x80113e14,-0xc(%ebp)
80104d34:	e9 71 01 00 00       	jmp    80104eaa <fillpstat+0x197>
  {
    if(p->state == UNUSED)
80104d39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d3c:	8b 40 0c             	mov    0xc(%eax),%eax
80104d3f:	85 c0                	test   %eax,%eax
80104d41:	75 1d                	jne    80104d60 <fillpstat+0x4d>
      (*pstat)[i].inuse = 0;
80104d43:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104d46:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104d49:	89 d0                	mov    %edx,%eax
80104d4b:	c1 e0 03             	shl    $0x3,%eax
80104d4e:	01 d0                	add    %edx,%eax
80104d50:	c1 e0 02             	shl    $0x2,%eax
80104d53:	01 c8                	add    %ecx,%eax
80104d55:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104d5b:	e9 3f 01 00 00       	jmp    80104e9f <fillpstat+0x18c>
    else
    {
      (*pstat)[i].inuse = 1;
80104d60:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104d63:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104d66:	89 d0                	mov    %edx,%eax
80104d68:	c1 e0 03             	shl    $0x3,%eax
80104d6b:	01 d0                	add    %edx,%eax
80104d6d:	c1 e0 02             	shl    $0x2,%eax
80104d70:	01 c8                	add    %ecx,%eax
80104d72:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      (*pstat)[i].tickets = p->tickets;
80104d78:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d7b:	8b 48 7c             	mov    0x7c(%eax),%ecx
80104d7e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104d81:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104d84:	89 d0                	mov    %edx,%eax
80104d86:	c1 e0 03             	shl    $0x3,%eax
80104d89:	01 d0                	add    %edx,%eax
80104d8b:	c1 e0 02             	shl    $0x2,%eax
80104d8e:	01 d8                	add    %ebx,%eax
80104d90:	83 c0 04             	add    $0x4,%eax
80104d93:	89 08                	mov    %ecx,(%eax)
      (*pstat)[i].pid = p->pid;
80104d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d98:	8b 48 10             	mov    0x10(%eax),%ecx
80104d9b:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104d9e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104da1:	89 d0                	mov    %edx,%eax
80104da3:	c1 e0 03             	shl    $0x3,%eax
80104da6:	01 d0                	add    %edx,%eax
80104da8:	c1 e0 02             	shl    $0x2,%eax
80104dab:	01 d8                	add    %ebx,%eax
80104dad:	83 c0 08             	add    $0x8,%eax
80104db0:	89 08                	mov    %ecx,(%eax)
      (*pstat)[i].ticks = p->ticks;
80104db2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104db5:	8b 88 80 00 00 00    	mov    0x80(%eax),%ecx
80104dbb:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104dbe:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104dc1:	89 d0                	mov    %edx,%eax
80104dc3:	c1 e0 03             	shl    $0x3,%eax
80104dc6:	01 d0                	add    %edx,%eax
80104dc8:	c1 e0 02             	shl    $0x2,%eax
80104dcb:	01 d8                	add    %ebx,%eax
80104dcd:	83 c0 0c             	add    $0xc,%eax
80104dd0:	89 08                	mov    %ecx,(%eax)
      /*
      for(j = 0; p->name[j] != '\0'; j++)
        cprintf("p->name[j]: %c", p->name[j]);
      */
      (*pstat)[i].name[0] = p->name[0];
80104dd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dd5:	0f b6 48 6c          	movzbl 0x6c(%eax),%ecx
80104dd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104ddc:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104ddf:	89 d0                	mov    %edx,%eax
80104de1:	c1 e0 03             	shl    $0x3,%eax
80104de4:	01 d0                	add    %edx,%eax
80104de6:	c1 e0 02             	shl    $0x2,%eax
80104de9:	01 d8                	add    %ebx,%eax
80104deb:	83 c0 10             	add    $0x10,%eax
80104dee:	88 08                	mov    %cl,(%eax)
      if(p->state == EMBRYO)
80104df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104df3:	8b 40 0c             	mov    0xc(%eax),%eax
80104df6:	83 f8 01             	cmp    $0x1,%eax
80104df9:	75 18                	jne    80104e13 <fillpstat+0x100>
        (*pstat)[i].state = 'E';
80104dfb:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104dfe:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104e01:	89 d0                	mov    %edx,%eax
80104e03:	c1 e0 03             	shl    $0x3,%eax
80104e06:	01 d0                	add    %edx,%eax
80104e08:	c1 e0 02             	shl    $0x2,%eax
80104e0b:	01 c8                	add    %ecx,%eax
80104e0d:	83 c0 20             	add    $0x20,%eax
80104e10:	c6 00 45             	movb   $0x45,(%eax)
      if(p->state == SLEEPING)
80104e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e16:	8b 40 0c             	mov    0xc(%eax),%eax
80104e19:	83 f8 02             	cmp    $0x2,%eax
80104e1c:	75 18                	jne    80104e36 <fillpstat+0x123>
        (*pstat)[i].state = 'S'; 
80104e1e:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104e21:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104e24:	89 d0                	mov    %edx,%eax
80104e26:	c1 e0 03             	shl    $0x3,%eax
80104e29:	01 d0                	add    %edx,%eax
80104e2b:	c1 e0 02             	shl    $0x2,%eax
80104e2e:	01 c8                	add    %ecx,%eax
80104e30:	83 c0 20             	add    $0x20,%eax
80104e33:	c6 00 53             	movb   $0x53,(%eax)
      if(p->state == RUNNABLE)
80104e36:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e39:	8b 40 0c             	mov    0xc(%eax),%eax
80104e3c:	83 f8 03             	cmp    $0x3,%eax
80104e3f:	75 18                	jne    80104e59 <fillpstat+0x146>
        (*pstat)[i].state = 'A';
80104e41:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104e44:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104e47:	89 d0                	mov    %edx,%eax
80104e49:	c1 e0 03             	shl    $0x3,%eax
80104e4c:	01 d0                	add    %edx,%eax
80104e4e:	c1 e0 02             	shl    $0x2,%eax
80104e51:	01 c8                	add    %ecx,%eax
80104e53:	83 c0 20             	add    $0x20,%eax
80104e56:	c6 00 41             	movb   $0x41,(%eax)
      if(p->state == RUNNING)
80104e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e5c:	8b 40 0c             	mov    0xc(%eax),%eax
80104e5f:	83 f8 04             	cmp    $0x4,%eax
80104e62:	75 18                	jne    80104e7c <fillpstat+0x169>
        (*pstat)[i].state = 'R';
80104e64:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104e67:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104e6a:	89 d0                	mov    %edx,%eax
80104e6c:	c1 e0 03             	shl    $0x3,%eax
80104e6f:	01 d0                	add    %edx,%eax
80104e71:	c1 e0 02             	shl    $0x2,%eax
80104e74:	01 c8                	add    %ecx,%eax
80104e76:	83 c0 20             	add    $0x20,%eax
80104e79:	c6 00 52             	movb   $0x52,(%eax)
      if(p->state == ZOMBIE)
80104e7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e7f:	8b 40 0c             	mov    0xc(%eax),%eax
80104e82:	83 f8 05             	cmp    $0x5,%eax
80104e85:	75 18                	jne    80104e9f <fillpstat+0x18c>
        (*pstat)[i].state = 'Z';
80104e87:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104e8a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104e8d:	89 d0                	mov    %edx,%eax
80104e8f:	c1 e0 03             	shl    $0x3,%eax
80104e92:	01 d0                	add    %edx,%eax
80104e94:	c1 e0 02             	shl    $0x2,%eax
80104e97:	01 c8                	add    %ecx,%eax
80104e99:	83 c0 20             	add    $0x20,%eax
80104e9c:	c6 00 5a             	movb   $0x5a,(%eax)
    }
    i++;  
80104e9f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104ea3:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104eaa:	81 7d f4 14 5f 11 80 	cmpl   $0x80115f14,-0xc(%ebp)
80104eb1:	0f 82 82 fe ff ff    	jb     80104d39 <fillpstat+0x26>
  }
  release(&ptable.lock);
80104eb7:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
80104ebe:	e8 f2 01 00 00       	call   801050b5 <release>
}
80104ec3:	83 c4 24             	add    $0x24,%esp
80104ec6:	5b                   	pop    %ebx
80104ec7:	5d                   	pop    %ebp
80104ec8:	c3                   	ret    

80104ec9 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104ec9:	55                   	push   %ebp
80104eca:	89 e5                	mov    %esp,%ebp
80104ecc:	83 ec 18             	sub    $0x18,%esp
  initlock(&lk->lk, "sleep lock");
80104ecf:	8b 45 08             	mov    0x8(%ebp),%eax
80104ed2:	83 c0 04             	add    $0x4,%eax
80104ed5:	c7 44 24 04 47 89 10 	movl   $0x80108947,0x4(%esp)
80104edc:	80 
80104edd:	89 04 24             	mov    %eax,(%esp)
80104ee0:	e8 47 01 00 00       	call   8010502c <initlock>
  lk->name = name;
80104ee5:	8b 45 08             	mov    0x8(%ebp),%eax
80104ee8:	8b 55 0c             	mov    0xc(%ebp),%edx
80104eeb:	89 50 38             	mov    %edx,0x38(%eax)
  lk->locked = 0;
80104eee:	8b 45 08             	mov    0x8(%ebp),%eax
80104ef1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
80104ef7:	8b 45 08             	mov    0x8(%ebp),%eax
80104efa:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
}
80104f01:	c9                   	leave  
80104f02:	c3                   	ret    

80104f03 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104f03:	55                   	push   %ebp
80104f04:	89 e5                	mov    %esp,%ebp
80104f06:	83 ec 18             	sub    $0x18,%esp
  acquire(&lk->lk);
80104f09:	8b 45 08             	mov    0x8(%ebp),%eax
80104f0c:	83 c0 04             	add    $0x4,%eax
80104f0f:	89 04 24             	mov    %eax,(%esp)
80104f12:	e8 36 01 00 00       	call   8010504d <acquire>
  while (lk->locked) {
80104f17:	eb 15                	jmp    80104f2e <acquiresleep+0x2b>
    sleep(lk, &lk->lk);
80104f19:	8b 45 08             	mov    0x8(%ebp),%eax
80104f1c:	83 c0 04             	add    $0x4,%eax
80104f1f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f23:	8b 45 08             	mov    0x8(%ebp),%eax
80104f26:	89 04 24             	mov    %eax,(%esp)
80104f29:	e8 6e fb ff ff       	call   80104a9c <sleep>
  while (lk->locked) {
80104f2e:	8b 45 08             	mov    0x8(%ebp),%eax
80104f31:	8b 00                	mov    (%eax),%eax
80104f33:	85 c0                	test   %eax,%eax
80104f35:	75 e2                	jne    80104f19 <acquiresleep+0x16>
  }
  lk->locked = 1;
80104f37:	8b 45 08             	mov    0x8(%ebp),%eax
80104f3a:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  lk->pid = myproc()->pid;
80104f40:	e8 1c f2 ff ff       	call   80104161 <myproc>
80104f45:	8b 50 10             	mov    0x10(%eax),%edx
80104f48:	8b 45 08             	mov    0x8(%ebp),%eax
80104f4b:	89 50 3c             	mov    %edx,0x3c(%eax)
  release(&lk->lk);
80104f4e:	8b 45 08             	mov    0x8(%ebp),%eax
80104f51:	83 c0 04             	add    $0x4,%eax
80104f54:	89 04 24             	mov    %eax,(%esp)
80104f57:	e8 59 01 00 00       	call   801050b5 <release>
}
80104f5c:	c9                   	leave  
80104f5d:	c3                   	ret    

80104f5e <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104f5e:	55                   	push   %ebp
80104f5f:	89 e5                	mov    %esp,%ebp
80104f61:	83 ec 18             	sub    $0x18,%esp
  acquire(&lk->lk);
80104f64:	8b 45 08             	mov    0x8(%ebp),%eax
80104f67:	83 c0 04             	add    $0x4,%eax
80104f6a:	89 04 24             	mov    %eax,(%esp)
80104f6d:	e8 db 00 00 00       	call   8010504d <acquire>
  lk->locked = 0;
80104f72:	8b 45 08             	mov    0x8(%ebp),%eax
80104f75:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
80104f7b:	8b 45 08             	mov    0x8(%ebp),%eax
80104f7e:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
  wakeup(lk);
80104f85:	8b 45 08             	mov    0x8(%ebp),%eax
80104f88:	89 04 24             	mov    %eax,(%esp)
80104f8b:	e8 e3 fb ff ff       	call   80104b73 <wakeup>
  release(&lk->lk);
80104f90:	8b 45 08             	mov    0x8(%ebp),%eax
80104f93:	83 c0 04             	add    $0x4,%eax
80104f96:	89 04 24             	mov    %eax,(%esp)
80104f99:	e8 17 01 00 00       	call   801050b5 <release>
}
80104f9e:	c9                   	leave  
80104f9f:	c3                   	ret    

80104fa0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104fa0:	55                   	push   %ebp
80104fa1:	89 e5                	mov    %esp,%ebp
80104fa3:	53                   	push   %ebx
80104fa4:	83 ec 24             	sub    $0x24,%esp
  int r;
  
  acquire(&lk->lk);
80104fa7:	8b 45 08             	mov    0x8(%ebp),%eax
80104faa:	83 c0 04             	add    $0x4,%eax
80104fad:	89 04 24             	mov    %eax,(%esp)
80104fb0:	e8 98 00 00 00       	call   8010504d <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104fb5:	8b 45 08             	mov    0x8(%ebp),%eax
80104fb8:	8b 00                	mov    (%eax),%eax
80104fba:	85 c0                	test   %eax,%eax
80104fbc:	74 19                	je     80104fd7 <holdingsleep+0x37>
80104fbe:	8b 45 08             	mov    0x8(%ebp),%eax
80104fc1:	8b 58 3c             	mov    0x3c(%eax),%ebx
80104fc4:	e8 98 f1 ff ff       	call   80104161 <myproc>
80104fc9:	8b 40 10             	mov    0x10(%eax),%eax
80104fcc:	39 c3                	cmp    %eax,%ebx
80104fce:	75 07                	jne    80104fd7 <holdingsleep+0x37>
80104fd0:	b8 01 00 00 00       	mov    $0x1,%eax
80104fd5:	eb 05                	jmp    80104fdc <holdingsleep+0x3c>
80104fd7:	b8 00 00 00 00       	mov    $0x0,%eax
80104fdc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&lk->lk);
80104fdf:	8b 45 08             	mov    0x8(%ebp),%eax
80104fe2:	83 c0 04             	add    $0x4,%eax
80104fe5:	89 04 24             	mov    %eax,(%esp)
80104fe8:	e8 c8 00 00 00       	call   801050b5 <release>
  return r;
80104fed:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104ff0:	83 c4 24             	add    $0x24,%esp
80104ff3:	5b                   	pop    %ebx
80104ff4:	5d                   	pop    %ebp
80104ff5:	c3                   	ret    

80104ff6 <readeflags>:
{
80104ff6:	55                   	push   %ebp
80104ff7:	89 e5                	mov    %esp,%ebp
80104ff9:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104ffc:	9c                   	pushf  
80104ffd:	58                   	pop    %eax
80104ffe:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80105001:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105004:	c9                   	leave  
80105005:	c3                   	ret    

80105006 <cli>:
{
80105006:	55                   	push   %ebp
80105007:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80105009:	fa                   	cli    
}
8010500a:	5d                   	pop    %ebp
8010500b:	c3                   	ret    

8010500c <sti>:
{
8010500c:	55                   	push   %ebp
8010500d:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
8010500f:	fb                   	sti    
}
80105010:	5d                   	pop    %ebp
80105011:	c3                   	ret    

80105012 <xchg>:
{
80105012:	55                   	push   %ebp
80105013:	89 e5                	mov    %esp,%ebp
80105015:	83 ec 10             	sub    $0x10,%esp
  asm volatile("lock; xchgl %0, %1" :
80105018:	8b 55 08             	mov    0x8(%ebp),%edx
8010501b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010501e:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105021:	f0 87 02             	lock xchg %eax,(%edx)
80105024:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return result;
80105027:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010502a:	c9                   	leave  
8010502b:	c3                   	ret    

8010502c <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
8010502c:	55                   	push   %ebp
8010502d:	89 e5                	mov    %esp,%ebp
  lk->name = name;
8010502f:	8b 45 08             	mov    0x8(%ebp),%eax
80105032:	8b 55 0c             	mov    0xc(%ebp),%edx
80105035:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80105038:	8b 45 08             	mov    0x8(%ebp),%eax
8010503b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80105041:	8b 45 08             	mov    0x8(%ebp),%eax
80105044:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
8010504b:	5d                   	pop    %ebp
8010504c:	c3                   	ret    

8010504d <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
8010504d:	55                   	push   %ebp
8010504e:	89 e5                	mov    %esp,%ebp
80105050:	53                   	push   %ebx
80105051:	83 ec 14             	sub    $0x14,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80105054:	e8 61 01 00 00       	call   801051ba <pushcli>
  if(holding(lk))
80105059:	8b 45 08             	mov    0x8(%ebp),%eax
8010505c:	89 04 24             	mov    %eax,(%esp)
8010505f:	e8 15 01 00 00       	call   80105179 <holding>
80105064:	85 c0                	test   %eax,%eax
80105066:	74 0c                	je     80105074 <acquire+0x27>
    panic("acquire");
80105068:	c7 04 24 52 89 10 80 	movl   $0x80108952,(%esp)
8010506f:	e8 ee b4 ff ff       	call   80100562 <panic>

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80105074:	90                   	nop
80105075:	8b 45 08             	mov    0x8(%ebp),%eax
80105078:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010507f:	00 
80105080:	89 04 24             	mov    %eax,(%esp)
80105083:	e8 8a ff ff ff       	call   80105012 <xchg>
80105088:	85 c0                	test   %eax,%eax
8010508a:	75 e9                	jne    80105075 <acquire+0x28>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
8010508c:	0f ae f0             	mfence 

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
8010508f:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105092:	e8 54 f0 ff ff       	call   801040eb <mycpu>
80105097:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
8010509a:	8b 45 08             	mov    0x8(%ebp),%eax
8010509d:	83 c0 0c             	add    $0xc,%eax
801050a0:	89 44 24 04          	mov    %eax,0x4(%esp)
801050a4:	8d 45 08             	lea    0x8(%ebp),%eax
801050a7:	89 04 24             	mov    %eax,(%esp)
801050aa:	e8 51 00 00 00       	call   80105100 <getcallerpcs>
}
801050af:	83 c4 14             	add    $0x14,%esp
801050b2:	5b                   	pop    %ebx
801050b3:	5d                   	pop    %ebp
801050b4:	c3                   	ret    

801050b5 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
801050b5:	55                   	push   %ebp
801050b6:	89 e5                	mov    %esp,%ebp
801050b8:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
801050bb:	8b 45 08             	mov    0x8(%ebp),%eax
801050be:	89 04 24             	mov    %eax,(%esp)
801050c1:	e8 b3 00 00 00       	call   80105179 <holding>
801050c6:	85 c0                	test   %eax,%eax
801050c8:	75 0c                	jne    801050d6 <release+0x21>
    panic("release");
801050ca:	c7 04 24 5a 89 10 80 	movl   $0x8010895a,(%esp)
801050d1:	e8 8c b4 ff ff       	call   80100562 <panic>

  lk->pcs[0] = 0;
801050d6:	8b 45 08             	mov    0x8(%ebp),%eax
801050d9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
801050e0:	8b 45 08             	mov    0x8(%ebp),%eax
801050e3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
801050ea:	0f ae f0             	mfence 

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801050ed:	8b 45 08             	mov    0x8(%ebp),%eax
801050f0:	8b 55 08             	mov    0x8(%ebp),%edx
801050f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
801050f9:	e8 08 01 00 00       	call   80105206 <popcli>
}
801050fe:	c9                   	leave  
801050ff:	c3                   	ret    

80105100 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105100:	55                   	push   %ebp
80105101:	89 e5                	mov    %esp,%ebp
80105103:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80105106:	8b 45 08             	mov    0x8(%ebp),%eax
80105109:	83 e8 08             	sub    $0x8,%eax
8010510c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
8010510f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80105116:	eb 38                	jmp    80105150 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105118:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
8010511c:	74 38                	je     80105156 <getcallerpcs+0x56>
8010511e:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80105125:	76 2f                	jbe    80105156 <getcallerpcs+0x56>
80105127:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
8010512b:	74 29                	je     80105156 <getcallerpcs+0x56>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010512d:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105130:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105137:	8b 45 0c             	mov    0xc(%ebp),%eax
8010513a:	01 c2                	add    %eax,%edx
8010513c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010513f:	8b 40 04             	mov    0x4(%eax),%eax
80105142:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80105144:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105147:	8b 00                	mov    (%eax),%eax
80105149:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
8010514c:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105150:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105154:	7e c2                	jle    80105118 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
80105156:	eb 19                	jmp    80105171 <getcallerpcs+0x71>
    pcs[i] = 0;
80105158:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010515b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105162:	8b 45 0c             	mov    0xc(%ebp),%eax
80105165:	01 d0                	add    %edx,%eax
80105167:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
8010516d:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105171:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105175:	7e e1                	jle    80105158 <getcallerpcs+0x58>
}
80105177:	c9                   	leave  
80105178:	c3                   	ret    

80105179 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80105179:	55                   	push   %ebp
8010517a:	89 e5                	mov    %esp,%ebp
8010517c:	53                   	push   %ebx
8010517d:	83 ec 14             	sub    $0x14,%esp
  int r;
  pushcli();
80105180:	e8 35 00 00 00       	call   801051ba <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80105185:	8b 45 08             	mov    0x8(%ebp),%eax
80105188:	8b 00                	mov    (%eax),%eax
8010518a:	85 c0                	test   %eax,%eax
8010518c:	74 16                	je     801051a4 <holding+0x2b>
8010518e:	8b 45 08             	mov    0x8(%ebp),%eax
80105191:	8b 58 08             	mov    0x8(%eax),%ebx
80105194:	e8 52 ef ff ff       	call   801040eb <mycpu>
80105199:	39 c3                	cmp    %eax,%ebx
8010519b:	75 07                	jne    801051a4 <holding+0x2b>
8010519d:	b8 01 00 00 00       	mov    $0x1,%eax
801051a2:	eb 05                	jmp    801051a9 <holding+0x30>
801051a4:	b8 00 00 00 00       	mov    $0x0,%eax
801051a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  popcli();
801051ac:	e8 55 00 00 00       	call   80105206 <popcli>
  return r;
801051b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801051b4:	83 c4 14             	add    $0x14,%esp
801051b7:	5b                   	pop    %ebx
801051b8:	5d                   	pop    %ebp
801051b9:	c3                   	ret    

801051ba <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801051ba:	55                   	push   %ebp
801051bb:	89 e5                	mov    %esp,%ebp
801051bd:	83 ec 18             	sub    $0x18,%esp
  int eflags;

  eflags = readeflags();
801051c0:	e8 31 fe ff ff       	call   80104ff6 <readeflags>
801051c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cli();
801051c8:	e8 39 fe ff ff       	call   80105006 <cli>
  if(mycpu()->ncli == 0)
801051cd:	e8 19 ef ff ff       	call   801040eb <mycpu>
801051d2:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801051d8:	85 c0                	test   %eax,%eax
801051da:	75 14                	jne    801051f0 <pushcli+0x36>
    mycpu()->intena = eflags & FL_IF;
801051dc:	e8 0a ef ff ff       	call   801040eb <mycpu>
801051e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801051e4:	81 e2 00 02 00 00    	and    $0x200,%edx
801051ea:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
  mycpu()->ncli += 1;
801051f0:	e8 f6 ee ff ff       	call   801040eb <mycpu>
801051f5:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801051fb:	83 c2 01             	add    $0x1,%edx
801051fe:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
}
80105204:	c9                   	leave  
80105205:	c3                   	ret    

80105206 <popcli>:

void
popcli(void)
{
80105206:	55                   	push   %ebp
80105207:	89 e5                	mov    %esp,%ebp
80105209:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
8010520c:	e8 e5 fd ff ff       	call   80104ff6 <readeflags>
80105211:	25 00 02 00 00       	and    $0x200,%eax
80105216:	85 c0                	test   %eax,%eax
80105218:	74 0c                	je     80105226 <popcli+0x20>
    panic("popcli - interruptible");
8010521a:	c7 04 24 62 89 10 80 	movl   $0x80108962,(%esp)
80105221:	e8 3c b3 ff ff       	call   80100562 <panic>
  if(--mycpu()->ncli < 0)
80105226:	e8 c0 ee ff ff       	call   801040eb <mycpu>
8010522b:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80105231:	83 ea 01             	sub    $0x1,%edx
80105234:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
8010523a:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105240:	85 c0                	test   %eax,%eax
80105242:	79 0c                	jns    80105250 <popcli+0x4a>
    panic("popcli");
80105244:	c7 04 24 79 89 10 80 	movl   $0x80108979,(%esp)
8010524b:	e8 12 b3 ff ff       	call   80100562 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
80105250:	e8 96 ee ff ff       	call   801040eb <mycpu>
80105255:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
8010525b:	85 c0                	test   %eax,%eax
8010525d:	75 14                	jne    80105273 <popcli+0x6d>
8010525f:	e8 87 ee ff ff       	call   801040eb <mycpu>
80105264:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010526a:	85 c0                	test   %eax,%eax
8010526c:	74 05                	je     80105273 <popcli+0x6d>
    sti();
8010526e:	e8 99 fd ff ff       	call   8010500c <sti>
}
80105273:	c9                   	leave  
80105274:	c3                   	ret    

80105275 <stosb>:
{
80105275:	55                   	push   %ebp
80105276:	89 e5                	mov    %esp,%ebp
80105278:	57                   	push   %edi
80105279:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
8010527a:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010527d:	8b 55 10             	mov    0x10(%ebp),%edx
80105280:	8b 45 0c             	mov    0xc(%ebp),%eax
80105283:	89 cb                	mov    %ecx,%ebx
80105285:	89 df                	mov    %ebx,%edi
80105287:	89 d1                	mov    %edx,%ecx
80105289:	fc                   	cld    
8010528a:	f3 aa                	rep stos %al,%es:(%edi)
8010528c:	89 ca                	mov    %ecx,%edx
8010528e:	89 fb                	mov    %edi,%ebx
80105290:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105293:	89 55 10             	mov    %edx,0x10(%ebp)
}
80105296:	5b                   	pop    %ebx
80105297:	5f                   	pop    %edi
80105298:	5d                   	pop    %ebp
80105299:	c3                   	ret    

8010529a <stosl>:
{
8010529a:	55                   	push   %ebp
8010529b:	89 e5                	mov    %esp,%ebp
8010529d:	57                   	push   %edi
8010529e:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
8010529f:	8b 4d 08             	mov    0x8(%ebp),%ecx
801052a2:	8b 55 10             	mov    0x10(%ebp),%edx
801052a5:	8b 45 0c             	mov    0xc(%ebp),%eax
801052a8:	89 cb                	mov    %ecx,%ebx
801052aa:	89 df                	mov    %ebx,%edi
801052ac:	89 d1                	mov    %edx,%ecx
801052ae:	fc                   	cld    
801052af:	f3 ab                	rep stos %eax,%es:(%edi)
801052b1:	89 ca                	mov    %ecx,%edx
801052b3:	89 fb                	mov    %edi,%ebx
801052b5:	89 5d 08             	mov    %ebx,0x8(%ebp)
801052b8:	89 55 10             	mov    %edx,0x10(%ebp)
}
801052bb:	5b                   	pop    %ebx
801052bc:	5f                   	pop    %edi
801052bd:	5d                   	pop    %ebp
801052be:	c3                   	ret    

801052bf <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801052bf:	55                   	push   %ebp
801052c0:	89 e5                	mov    %esp,%ebp
801052c2:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
801052c5:	8b 45 08             	mov    0x8(%ebp),%eax
801052c8:	83 e0 03             	and    $0x3,%eax
801052cb:	85 c0                	test   %eax,%eax
801052cd:	75 49                	jne    80105318 <memset+0x59>
801052cf:	8b 45 10             	mov    0x10(%ebp),%eax
801052d2:	83 e0 03             	and    $0x3,%eax
801052d5:	85 c0                	test   %eax,%eax
801052d7:	75 3f                	jne    80105318 <memset+0x59>
    c &= 0xFF;
801052d9:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801052e0:	8b 45 10             	mov    0x10(%ebp),%eax
801052e3:	c1 e8 02             	shr    $0x2,%eax
801052e6:	89 c2                	mov    %eax,%edx
801052e8:	8b 45 0c             	mov    0xc(%ebp),%eax
801052eb:	c1 e0 18             	shl    $0x18,%eax
801052ee:	89 c1                	mov    %eax,%ecx
801052f0:	8b 45 0c             	mov    0xc(%ebp),%eax
801052f3:	c1 e0 10             	shl    $0x10,%eax
801052f6:	09 c1                	or     %eax,%ecx
801052f8:	8b 45 0c             	mov    0xc(%ebp),%eax
801052fb:	c1 e0 08             	shl    $0x8,%eax
801052fe:	09 c8                	or     %ecx,%eax
80105300:	0b 45 0c             	or     0xc(%ebp),%eax
80105303:	89 54 24 08          	mov    %edx,0x8(%esp)
80105307:	89 44 24 04          	mov    %eax,0x4(%esp)
8010530b:	8b 45 08             	mov    0x8(%ebp),%eax
8010530e:	89 04 24             	mov    %eax,(%esp)
80105311:	e8 84 ff ff ff       	call   8010529a <stosl>
80105316:	eb 19                	jmp    80105331 <memset+0x72>
  } else
    stosb(dst, c, n);
80105318:	8b 45 10             	mov    0x10(%ebp),%eax
8010531b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010531f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105322:	89 44 24 04          	mov    %eax,0x4(%esp)
80105326:	8b 45 08             	mov    0x8(%ebp),%eax
80105329:	89 04 24             	mov    %eax,(%esp)
8010532c:	e8 44 ff ff ff       	call   80105275 <stosb>
  return dst;
80105331:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105334:	c9                   	leave  
80105335:	c3                   	ret    

80105336 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105336:	55                   	push   %ebp
80105337:	89 e5                	mov    %esp,%ebp
80105339:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;

  s1 = v1;
8010533c:	8b 45 08             	mov    0x8(%ebp),%eax
8010533f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80105342:	8b 45 0c             	mov    0xc(%ebp),%eax
80105345:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80105348:	eb 30                	jmp    8010537a <memcmp+0x44>
    if(*s1 != *s2)
8010534a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010534d:	0f b6 10             	movzbl (%eax),%edx
80105350:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105353:	0f b6 00             	movzbl (%eax),%eax
80105356:	38 c2                	cmp    %al,%dl
80105358:	74 18                	je     80105372 <memcmp+0x3c>
      return *s1 - *s2;
8010535a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010535d:	0f b6 00             	movzbl (%eax),%eax
80105360:	0f b6 d0             	movzbl %al,%edx
80105363:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105366:	0f b6 00             	movzbl (%eax),%eax
80105369:	0f b6 c0             	movzbl %al,%eax
8010536c:	29 c2                	sub    %eax,%edx
8010536e:	89 d0                	mov    %edx,%eax
80105370:	eb 1a                	jmp    8010538c <memcmp+0x56>
    s1++, s2++;
80105372:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105376:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  while(n-- > 0){
8010537a:	8b 45 10             	mov    0x10(%ebp),%eax
8010537d:	8d 50 ff             	lea    -0x1(%eax),%edx
80105380:	89 55 10             	mov    %edx,0x10(%ebp)
80105383:	85 c0                	test   %eax,%eax
80105385:	75 c3                	jne    8010534a <memcmp+0x14>
  }

  return 0;
80105387:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010538c:	c9                   	leave  
8010538d:	c3                   	ret    

8010538e <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
8010538e:	55                   	push   %ebp
8010538f:	89 e5                	mov    %esp,%ebp
80105391:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80105394:	8b 45 0c             	mov    0xc(%ebp),%eax
80105397:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
8010539a:	8b 45 08             	mov    0x8(%ebp),%eax
8010539d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
801053a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
801053a3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801053a6:	73 3d                	jae    801053e5 <memmove+0x57>
801053a8:	8b 45 10             	mov    0x10(%ebp),%eax
801053ab:	8b 55 fc             	mov    -0x4(%ebp),%edx
801053ae:	01 d0                	add    %edx,%eax
801053b0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801053b3:	76 30                	jbe    801053e5 <memmove+0x57>
    s += n;
801053b5:	8b 45 10             	mov    0x10(%ebp),%eax
801053b8:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
801053bb:	8b 45 10             	mov    0x10(%ebp),%eax
801053be:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
801053c1:	eb 13                	jmp    801053d6 <memmove+0x48>
      *--d = *--s;
801053c3:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
801053c7:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
801053cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
801053ce:	0f b6 10             	movzbl (%eax),%edx
801053d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
801053d4:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
801053d6:	8b 45 10             	mov    0x10(%ebp),%eax
801053d9:	8d 50 ff             	lea    -0x1(%eax),%edx
801053dc:	89 55 10             	mov    %edx,0x10(%ebp)
801053df:	85 c0                	test   %eax,%eax
801053e1:	75 e0                	jne    801053c3 <memmove+0x35>
  if(s < d && s + n > d){
801053e3:	eb 26                	jmp    8010540b <memmove+0x7d>
  } else
    while(n-- > 0)
801053e5:	eb 17                	jmp    801053fe <memmove+0x70>
      *d++ = *s++;
801053e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
801053ea:	8d 50 01             	lea    0x1(%eax),%edx
801053ed:	89 55 f8             	mov    %edx,-0x8(%ebp)
801053f0:	8b 55 fc             	mov    -0x4(%ebp),%edx
801053f3:	8d 4a 01             	lea    0x1(%edx),%ecx
801053f6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
801053f9:	0f b6 12             	movzbl (%edx),%edx
801053fc:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
801053fe:	8b 45 10             	mov    0x10(%ebp),%eax
80105401:	8d 50 ff             	lea    -0x1(%eax),%edx
80105404:	89 55 10             	mov    %edx,0x10(%ebp)
80105407:	85 c0                	test   %eax,%eax
80105409:	75 dc                	jne    801053e7 <memmove+0x59>

  return dst;
8010540b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010540e:	c9                   	leave  
8010540f:	c3                   	ret    

80105410 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105410:	55                   	push   %ebp
80105411:	89 e5                	mov    %esp,%ebp
80105413:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
80105416:	8b 45 10             	mov    0x10(%ebp),%eax
80105419:	89 44 24 08          	mov    %eax,0x8(%esp)
8010541d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105420:	89 44 24 04          	mov    %eax,0x4(%esp)
80105424:	8b 45 08             	mov    0x8(%ebp),%eax
80105427:	89 04 24             	mov    %eax,(%esp)
8010542a:	e8 5f ff ff ff       	call   8010538e <memmove>
}
8010542f:	c9                   	leave  
80105430:	c3                   	ret    

80105431 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105431:	55                   	push   %ebp
80105432:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80105434:	eb 0c                	jmp    80105442 <strncmp+0x11>
    n--, p++, q++;
80105436:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
8010543a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
8010543e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(n > 0 && *p && *p == *q)
80105442:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105446:	74 1a                	je     80105462 <strncmp+0x31>
80105448:	8b 45 08             	mov    0x8(%ebp),%eax
8010544b:	0f b6 00             	movzbl (%eax),%eax
8010544e:	84 c0                	test   %al,%al
80105450:	74 10                	je     80105462 <strncmp+0x31>
80105452:	8b 45 08             	mov    0x8(%ebp),%eax
80105455:	0f b6 10             	movzbl (%eax),%edx
80105458:	8b 45 0c             	mov    0xc(%ebp),%eax
8010545b:	0f b6 00             	movzbl (%eax),%eax
8010545e:	38 c2                	cmp    %al,%dl
80105460:	74 d4                	je     80105436 <strncmp+0x5>
  if(n == 0)
80105462:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105466:	75 07                	jne    8010546f <strncmp+0x3e>
    return 0;
80105468:	b8 00 00 00 00       	mov    $0x0,%eax
8010546d:	eb 16                	jmp    80105485 <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
8010546f:	8b 45 08             	mov    0x8(%ebp),%eax
80105472:	0f b6 00             	movzbl (%eax),%eax
80105475:	0f b6 d0             	movzbl %al,%edx
80105478:	8b 45 0c             	mov    0xc(%ebp),%eax
8010547b:	0f b6 00             	movzbl (%eax),%eax
8010547e:	0f b6 c0             	movzbl %al,%eax
80105481:	29 c2                	sub    %eax,%edx
80105483:	89 d0                	mov    %edx,%eax
}
80105485:	5d                   	pop    %ebp
80105486:	c3                   	ret    

80105487 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105487:	55                   	push   %ebp
80105488:	89 e5                	mov    %esp,%ebp
8010548a:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
8010548d:	8b 45 08             	mov    0x8(%ebp),%eax
80105490:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80105493:	90                   	nop
80105494:	8b 45 10             	mov    0x10(%ebp),%eax
80105497:	8d 50 ff             	lea    -0x1(%eax),%edx
8010549a:	89 55 10             	mov    %edx,0x10(%ebp)
8010549d:	85 c0                	test   %eax,%eax
8010549f:	7e 1e                	jle    801054bf <strncpy+0x38>
801054a1:	8b 45 08             	mov    0x8(%ebp),%eax
801054a4:	8d 50 01             	lea    0x1(%eax),%edx
801054a7:	89 55 08             	mov    %edx,0x8(%ebp)
801054aa:	8b 55 0c             	mov    0xc(%ebp),%edx
801054ad:	8d 4a 01             	lea    0x1(%edx),%ecx
801054b0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
801054b3:	0f b6 12             	movzbl (%edx),%edx
801054b6:	88 10                	mov    %dl,(%eax)
801054b8:	0f b6 00             	movzbl (%eax),%eax
801054bb:	84 c0                	test   %al,%al
801054bd:	75 d5                	jne    80105494 <strncpy+0xd>
    ;
  while(n-- > 0)
801054bf:	eb 0c                	jmp    801054cd <strncpy+0x46>
    *s++ = 0;
801054c1:	8b 45 08             	mov    0x8(%ebp),%eax
801054c4:	8d 50 01             	lea    0x1(%eax),%edx
801054c7:	89 55 08             	mov    %edx,0x8(%ebp)
801054ca:	c6 00 00             	movb   $0x0,(%eax)
  while(n-- > 0)
801054cd:	8b 45 10             	mov    0x10(%ebp),%eax
801054d0:	8d 50 ff             	lea    -0x1(%eax),%edx
801054d3:	89 55 10             	mov    %edx,0x10(%ebp)
801054d6:	85 c0                	test   %eax,%eax
801054d8:	7f e7                	jg     801054c1 <strncpy+0x3a>
  return os;
801054da:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801054dd:	c9                   	leave  
801054de:	c3                   	ret    

801054df <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801054df:	55                   	push   %ebp
801054e0:	89 e5                	mov    %esp,%ebp
801054e2:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
801054e5:	8b 45 08             	mov    0x8(%ebp),%eax
801054e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
801054eb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801054ef:	7f 05                	jg     801054f6 <safestrcpy+0x17>
    return os;
801054f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
801054f4:	eb 31                	jmp    80105527 <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
801054f6:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801054fa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801054fe:	7e 1e                	jle    8010551e <safestrcpy+0x3f>
80105500:	8b 45 08             	mov    0x8(%ebp),%eax
80105503:	8d 50 01             	lea    0x1(%eax),%edx
80105506:	89 55 08             	mov    %edx,0x8(%ebp)
80105509:	8b 55 0c             	mov    0xc(%ebp),%edx
8010550c:	8d 4a 01             	lea    0x1(%edx),%ecx
8010550f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80105512:	0f b6 12             	movzbl (%edx),%edx
80105515:	88 10                	mov    %dl,(%eax)
80105517:	0f b6 00             	movzbl (%eax),%eax
8010551a:	84 c0                	test   %al,%al
8010551c:	75 d8                	jne    801054f6 <safestrcpy+0x17>
    ;
  *s = 0;
8010551e:	8b 45 08             	mov    0x8(%ebp),%eax
80105521:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80105524:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105527:	c9                   	leave  
80105528:	c3                   	ret    

80105529 <strlen>:

int
strlen(const char *s)
{
80105529:	55                   	push   %ebp
8010552a:	89 e5                	mov    %esp,%ebp
8010552c:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
8010552f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105536:	eb 04                	jmp    8010553c <strlen+0x13>
80105538:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010553c:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010553f:	8b 45 08             	mov    0x8(%ebp),%eax
80105542:	01 d0                	add    %edx,%eax
80105544:	0f b6 00             	movzbl (%eax),%eax
80105547:	84 c0                	test   %al,%al
80105549:	75 ed                	jne    80105538 <strlen+0xf>
    ;
  return n;
8010554b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010554e:	c9                   	leave  
8010554f:	c3                   	ret    

80105550 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105550:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105554:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105558:	55                   	push   %ebp
  pushl %ebx
80105559:	53                   	push   %ebx
  pushl %esi
8010555a:	56                   	push   %esi
  pushl %edi
8010555b:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
8010555c:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
8010555e:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80105560:	5f                   	pop    %edi
  popl %esi
80105561:	5e                   	pop    %esi
  popl %ebx
80105562:	5b                   	pop    %ebx
  popl %ebp
80105563:	5d                   	pop    %ebp
  ret
80105564:	c3                   	ret    

80105565 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105565:	55                   	push   %ebp
80105566:	89 e5                	mov    %esp,%ebp
80105568:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
8010556b:	e8 f1 eb ff ff       	call   80104161 <myproc>
80105570:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105573:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105576:	8b 00                	mov    (%eax),%eax
80105578:	3b 45 08             	cmp    0x8(%ebp),%eax
8010557b:	76 0f                	jbe    8010558c <fetchint+0x27>
8010557d:	8b 45 08             	mov    0x8(%ebp),%eax
80105580:	8d 50 04             	lea    0x4(%eax),%edx
80105583:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105586:	8b 00                	mov    (%eax),%eax
80105588:	39 c2                	cmp    %eax,%edx
8010558a:	76 07                	jbe    80105593 <fetchint+0x2e>
    return -1;
8010558c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105591:	eb 0f                	jmp    801055a2 <fetchint+0x3d>
  *ip = *(int*)(addr);
80105593:	8b 45 08             	mov    0x8(%ebp),%eax
80105596:	8b 10                	mov    (%eax),%edx
80105598:	8b 45 0c             	mov    0xc(%ebp),%eax
8010559b:	89 10                	mov    %edx,(%eax)
  return 0;
8010559d:	b8 00 00 00 00       	mov    $0x0,%eax
}
801055a2:	c9                   	leave  
801055a3:	c3                   	ret    

801055a4 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801055a4:	55                   	push   %ebp
801055a5:	89 e5                	mov    %esp,%ebp
801055a7:	83 ec 18             	sub    $0x18,%esp
  char *s, *ep;
  struct proc *curproc = myproc();
801055aa:	e8 b2 eb ff ff       	call   80104161 <myproc>
801055af:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(addr >= curproc->sz)
801055b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055b5:	8b 00                	mov    (%eax),%eax
801055b7:	3b 45 08             	cmp    0x8(%ebp),%eax
801055ba:	77 07                	ja     801055c3 <fetchstr+0x1f>
    return -1;
801055bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055c1:	eb 43                	jmp    80105606 <fetchstr+0x62>
  *pp = (char*)addr;
801055c3:	8b 55 08             	mov    0x8(%ebp),%edx
801055c6:	8b 45 0c             	mov    0xc(%ebp),%eax
801055c9:	89 10                	mov    %edx,(%eax)
  ep = (char*)curproc->sz;
801055cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055ce:	8b 00                	mov    (%eax),%eax
801055d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(s = *pp; s < ep; s++){
801055d3:	8b 45 0c             	mov    0xc(%ebp),%eax
801055d6:	8b 00                	mov    (%eax),%eax
801055d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
801055db:	eb 1c                	jmp    801055f9 <fetchstr+0x55>
    if(*s == 0)
801055dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055e0:	0f b6 00             	movzbl (%eax),%eax
801055e3:	84 c0                	test   %al,%al
801055e5:	75 0e                	jne    801055f5 <fetchstr+0x51>
      return s - *pp;
801055e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801055ea:	8b 45 0c             	mov    0xc(%ebp),%eax
801055ed:	8b 00                	mov    (%eax),%eax
801055ef:	29 c2                	sub    %eax,%edx
801055f1:	89 d0                	mov    %edx,%eax
801055f3:	eb 11                	jmp    80105606 <fetchstr+0x62>
  for(s = *pp; s < ep; s++){
801055f5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801055f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055fc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801055ff:	72 dc                	jb     801055dd <fetchstr+0x39>
  }
  return -1;
80105601:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105606:	c9                   	leave  
80105607:	c3                   	ret    

80105608 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105608:	55                   	push   %ebp
80105609:	89 e5                	mov    %esp,%ebp
8010560b:	83 ec 18             	sub    $0x18,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010560e:	e8 4e eb ff ff       	call   80104161 <myproc>
80105613:	8b 40 18             	mov    0x18(%eax),%eax
80105616:	8b 50 44             	mov    0x44(%eax),%edx
80105619:	8b 45 08             	mov    0x8(%ebp),%eax
8010561c:	c1 e0 02             	shl    $0x2,%eax
8010561f:	01 d0                	add    %edx,%eax
80105621:	8d 50 04             	lea    0x4(%eax),%edx
80105624:	8b 45 0c             	mov    0xc(%ebp),%eax
80105627:	89 44 24 04          	mov    %eax,0x4(%esp)
8010562b:	89 14 24             	mov    %edx,(%esp)
8010562e:	e8 32 ff ff ff       	call   80105565 <fetchint>
}
80105633:	c9                   	leave  
80105634:	c3                   	ret    

80105635 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105635:	55                   	push   %ebp
80105636:	89 e5                	mov    %esp,%ebp
80105638:	83 ec 28             	sub    $0x28,%esp
  int i;
  struct proc *curproc = myproc();
8010563b:	e8 21 eb ff ff       	call   80104161 <myproc>
80105640:	89 45 f4             	mov    %eax,-0xc(%ebp)
 
  if(argint(n, &i) < 0)
80105643:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105646:	89 44 24 04          	mov    %eax,0x4(%esp)
8010564a:	8b 45 08             	mov    0x8(%ebp),%eax
8010564d:	89 04 24             	mov    %eax,(%esp)
80105650:	e8 b3 ff ff ff       	call   80105608 <argint>
80105655:	85 c0                	test   %eax,%eax
80105657:	79 07                	jns    80105660 <argptr+0x2b>
    return -1;
80105659:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010565e:	eb 3d                	jmp    8010569d <argptr+0x68>
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105660:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105664:	78 21                	js     80105687 <argptr+0x52>
80105666:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105669:	89 c2                	mov    %eax,%edx
8010566b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010566e:	8b 00                	mov    (%eax),%eax
80105670:	39 c2                	cmp    %eax,%edx
80105672:	73 13                	jae    80105687 <argptr+0x52>
80105674:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105677:	89 c2                	mov    %eax,%edx
80105679:	8b 45 10             	mov    0x10(%ebp),%eax
8010567c:	01 c2                	add    %eax,%edx
8010567e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105681:	8b 00                	mov    (%eax),%eax
80105683:	39 c2                	cmp    %eax,%edx
80105685:	76 07                	jbe    8010568e <argptr+0x59>
    return -1;
80105687:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010568c:	eb 0f                	jmp    8010569d <argptr+0x68>
  *pp = (char*)i;
8010568e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105691:	89 c2                	mov    %eax,%edx
80105693:	8b 45 0c             	mov    0xc(%ebp),%eax
80105696:	89 10                	mov    %edx,(%eax)
  return 0;
80105698:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010569d:	c9                   	leave  
8010569e:	c3                   	ret    

8010569f <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
8010569f:	55                   	push   %ebp
801056a0:	89 e5                	mov    %esp,%ebp
801056a2:	83 ec 28             	sub    $0x28,%esp
  int addr;
  if(argint(n, &addr) < 0)
801056a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056a8:	89 44 24 04          	mov    %eax,0x4(%esp)
801056ac:	8b 45 08             	mov    0x8(%ebp),%eax
801056af:	89 04 24             	mov    %eax,(%esp)
801056b2:	e8 51 ff ff ff       	call   80105608 <argint>
801056b7:	85 c0                	test   %eax,%eax
801056b9:	79 07                	jns    801056c2 <argstr+0x23>
    return -1;
801056bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056c0:	eb 12                	jmp    801056d4 <argstr+0x35>
  return fetchstr(addr, pp);
801056c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056c5:	8b 55 0c             	mov    0xc(%ebp),%edx
801056c8:	89 54 24 04          	mov    %edx,0x4(%esp)
801056cc:	89 04 24             	mov    %eax,(%esp)
801056cf:	e8 d0 fe ff ff       	call   801055a4 <fetchstr>
}
801056d4:	c9                   	leave  
801056d5:	c3                   	ret    

801056d6 <syscall>:
[SYS_settickets] sys_settickets,
};

void
syscall(void)
{
801056d6:	55                   	push   %ebp
801056d7:	89 e5                	mov    %esp,%ebp
801056d9:	53                   	push   %ebx
801056da:	83 ec 24             	sub    $0x24,%esp
  int num;
  struct proc *curproc = myproc();
801056dd:	e8 7f ea ff ff       	call   80104161 <myproc>
801056e2:	89 45 f4             	mov    %eax,-0xc(%ebp)

  num = curproc->tf->eax;
801056e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056e8:	8b 40 18             	mov    0x18(%eax),%eax
801056eb:	8b 40 1c             	mov    0x1c(%eax),%eax
801056ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801056f1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801056f5:	7e 2d                	jle    80105724 <syscall+0x4e>
801056f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056fa:	83 f8 18             	cmp    $0x18,%eax
801056fd:	77 25                	ja     80105724 <syscall+0x4e>
801056ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105702:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
80105709:	85 c0                	test   %eax,%eax
8010570b:	74 17                	je     80105724 <syscall+0x4e>
    curproc->tf->eax = syscalls[num]();
8010570d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105710:	8b 58 18             	mov    0x18(%eax),%ebx
80105713:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105716:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
8010571d:	ff d0                	call   *%eax
8010571f:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105722:	eb 34                	jmp    80105758 <syscall+0x82>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
80105724:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105727:	8d 48 6c             	lea    0x6c(%eax),%ecx
    cprintf("%d %s: unknown sys call %d\n",
8010572a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010572d:	8b 40 10             	mov    0x10(%eax),%eax
80105730:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105733:	89 54 24 0c          	mov    %edx,0xc(%esp)
80105737:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010573b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010573f:	c7 04 24 80 89 10 80 	movl   $0x80108980,(%esp)
80105746:	e8 7d ac ff ff       	call   801003c8 <cprintf>
    curproc->tf->eax = -1;
8010574b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010574e:	8b 40 18             	mov    0x18(%eax),%eax
80105751:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105758:	83 c4 24             	add    $0x24,%esp
8010575b:	5b                   	pop    %ebx
8010575c:	5d                   	pop    %ebp
8010575d:	c3                   	ret    

8010575e <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
8010575e:	55                   	push   %ebp
8010575f:	89 e5                	mov    %esp,%ebp
80105761:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105764:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105767:	89 44 24 04          	mov    %eax,0x4(%esp)
8010576b:	8b 45 08             	mov    0x8(%ebp),%eax
8010576e:	89 04 24             	mov    %eax,(%esp)
80105771:	e8 92 fe ff ff       	call   80105608 <argint>
80105776:	85 c0                	test   %eax,%eax
80105778:	79 07                	jns    80105781 <argfd+0x23>
    return -1;
8010577a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010577f:	eb 4f                	jmp    801057d0 <argfd+0x72>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80105781:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105784:	85 c0                	test   %eax,%eax
80105786:	78 20                	js     801057a8 <argfd+0x4a>
80105788:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010578b:	83 f8 0f             	cmp    $0xf,%eax
8010578e:	7f 18                	jg     801057a8 <argfd+0x4a>
80105790:	e8 cc e9 ff ff       	call   80104161 <myproc>
80105795:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105798:	83 c2 08             	add    $0x8,%edx
8010579b:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010579f:	89 45 f4             	mov    %eax,-0xc(%ebp)
801057a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801057a6:	75 07                	jne    801057af <argfd+0x51>
    return -1;
801057a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057ad:	eb 21                	jmp    801057d0 <argfd+0x72>
  if(pfd)
801057af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801057b3:	74 08                	je     801057bd <argfd+0x5f>
    *pfd = fd;
801057b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
801057b8:	8b 45 0c             	mov    0xc(%ebp),%eax
801057bb:	89 10                	mov    %edx,(%eax)
  if(pf)
801057bd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801057c1:	74 08                	je     801057cb <argfd+0x6d>
    *pf = f;
801057c3:	8b 45 10             	mov    0x10(%ebp),%eax
801057c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801057c9:	89 10                	mov    %edx,(%eax)
  return 0;
801057cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
801057d0:	c9                   	leave  
801057d1:	c3                   	ret    

801057d2 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801057d2:	55                   	push   %ebp
801057d3:	89 e5                	mov    %esp,%ebp
801057d5:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct proc *curproc = myproc();
801057d8:	e8 84 e9 ff ff       	call   80104161 <myproc>
801057dd:	89 45 f0             	mov    %eax,-0x10(%ebp)

  for(fd = 0; fd < NOFILE; fd++){
801057e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801057e7:	eb 2a                	jmp    80105813 <fdalloc+0x41>
    if(curproc->ofile[fd] == 0){
801057e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
801057ef:	83 c2 08             	add    $0x8,%edx
801057f2:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801057f6:	85 c0                	test   %eax,%eax
801057f8:	75 15                	jne    8010580f <fdalloc+0x3d>
      curproc->ofile[fd] = f;
801057fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105800:	8d 4a 08             	lea    0x8(%edx),%ecx
80105803:	8b 55 08             	mov    0x8(%ebp),%edx
80105806:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
8010580a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010580d:	eb 0f                	jmp    8010581e <fdalloc+0x4c>
  for(fd = 0; fd < NOFILE; fd++){
8010580f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105813:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105817:	7e d0                	jle    801057e9 <fdalloc+0x17>
    }
  }
  return -1;
80105819:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010581e:	c9                   	leave  
8010581f:	c3                   	ret    

80105820 <sys_dup>:

int
sys_dup(void)
{
80105820:	55                   	push   %ebp
80105821:	89 e5                	mov    %esp,%ebp
80105823:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105826:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105829:	89 44 24 08          	mov    %eax,0x8(%esp)
8010582d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105834:	00 
80105835:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010583c:	e8 1d ff ff ff       	call   8010575e <argfd>
80105841:	85 c0                	test   %eax,%eax
80105843:	79 07                	jns    8010584c <sys_dup+0x2c>
    return -1;
80105845:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010584a:	eb 29                	jmp    80105875 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
8010584c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010584f:	89 04 24             	mov    %eax,(%esp)
80105852:	e8 7b ff ff ff       	call   801057d2 <fdalloc>
80105857:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010585a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010585e:	79 07                	jns    80105867 <sys_dup+0x47>
    return -1;
80105860:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105865:	eb 0e                	jmp    80105875 <sys_dup+0x55>
  filedup(f);
80105867:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010586a:	89 04 24             	mov    %eax,(%esp)
8010586d:	e8 73 b7 ff ff       	call   80100fe5 <filedup>
  return fd;
80105872:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105875:	c9                   	leave  
80105876:	c3                   	ret    

80105877 <sys_read>:

int
sys_read(void)
{
80105877:	55                   	push   %ebp
80105878:	89 e5                	mov    %esp,%ebp
8010587a:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010587d:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105880:	89 44 24 08          	mov    %eax,0x8(%esp)
80105884:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010588b:	00 
8010588c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105893:	e8 c6 fe ff ff       	call   8010575e <argfd>
80105898:	85 c0                	test   %eax,%eax
8010589a:	78 35                	js     801058d1 <sys_read+0x5a>
8010589c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010589f:	89 44 24 04          	mov    %eax,0x4(%esp)
801058a3:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801058aa:	e8 59 fd ff ff       	call   80105608 <argint>
801058af:	85 c0                	test   %eax,%eax
801058b1:	78 1e                	js     801058d1 <sys_read+0x5a>
801058b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058b6:	89 44 24 08          	mov    %eax,0x8(%esp)
801058ba:	8d 45 ec             	lea    -0x14(%ebp),%eax
801058bd:	89 44 24 04          	mov    %eax,0x4(%esp)
801058c1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801058c8:	e8 68 fd ff ff       	call   80105635 <argptr>
801058cd:	85 c0                	test   %eax,%eax
801058cf:	79 07                	jns    801058d8 <sys_read+0x61>
    return -1;
801058d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058d6:	eb 19                	jmp    801058f1 <sys_read+0x7a>
  return fileread(f, p, n);
801058d8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801058db:	8b 55 ec             	mov    -0x14(%ebp),%edx
801058de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058e1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801058e5:	89 54 24 04          	mov    %edx,0x4(%esp)
801058e9:	89 04 24             	mov    %eax,(%esp)
801058ec:	e8 61 b8 ff ff       	call   80101152 <fileread>
}
801058f1:	c9                   	leave  
801058f2:	c3                   	ret    

801058f3 <sys_write>:

int
sys_write(void)
{
801058f3:	55                   	push   %ebp
801058f4:	89 e5                	mov    %esp,%ebp
801058f6:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801058f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058fc:	89 44 24 08          	mov    %eax,0x8(%esp)
80105900:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105907:	00 
80105908:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010590f:	e8 4a fe ff ff       	call   8010575e <argfd>
80105914:	85 c0                	test   %eax,%eax
80105916:	78 35                	js     8010594d <sys_write+0x5a>
80105918:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010591b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010591f:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105926:	e8 dd fc ff ff       	call   80105608 <argint>
8010592b:	85 c0                	test   %eax,%eax
8010592d:	78 1e                	js     8010594d <sys_write+0x5a>
8010592f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105932:	89 44 24 08          	mov    %eax,0x8(%esp)
80105936:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105939:	89 44 24 04          	mov    %eax,0x4(%esp)
8010593d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105944:	e8 ec fc ff ff       	call   80105635 <argptr>
80105949:	85 c0                	test   %eax,%eax
8010594b:	79 07                	jns    80105954 <sys_write+0x61>
    return -1;
8010594d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105952:	eb 19                	jmp    8010596d <sys_write+0x7a>
  return filewrite(f, p, n);
80105954:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105957:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010595a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010595d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105961:	89 54 24 04          	mov    %edx,0x4(%esp)
80105965:	89 04 24             	mov    %eax,(%esp)
80105968:	e8 a1 b8 ff ff       	call   8010120e <filewrite>
}
8010596d:	c9                   	leave  
8010596e:	c3                   	ret    

8010596f <sys_close>:

int
sys_close(void)
{
8010596f:	55                   	push   %ebp
80105970:	89 e5                	mov    %esp,%ebp
80105972:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105975:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105978:	89 44 24 08          	mov    %eax,0x8(%esp)
8010597c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010597f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105983:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010598a:	e8 cf fd ff ff       	call   8010575e <argfd>
8010598f:	85 c0                	test   %eax,%eax
80105991:	79 07                	jns    8010599a <sys_close+0x2b>
    return -1;
80105993:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105998:	eb 23                	jmp    801059bd <sys_close+0x4e>
  myproc()->ofile[fd] = 0;
8010599a:	e8 c2 e7 ff ff       	call   80104161 <myproc>
8010599f:	8b 55 f4             	mov    -0xc(%ebp),%edx
801059a2:	83 c2 08             	add    $0x8,%edx
801059a5:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801059ac:	00 
  fileclose(f);
801059ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059b0:	89 04 24             	mov    %eax,(%esp)
801059b3:	e8 75 b6 ff ff       	call   8010102d <fileclose>
  return 0;
801059b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801059bd:	c9                   	leave  
801059be:	c3                   	ret    

801059bf <sys_fstat>:

int
sys_fstat(void)
{
801059bf:	55                   	push   %ebp
801059c0:	89 e5                	mov    %esp,%ebp
801059c2:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801059c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059c8:	89 44 24 08          	mov    %eax,0x8(%esp)
801059cc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801059d3:	00 
801059d4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801059db:	e8 7e fd ff ff       	call   8010575e <argfd>
801059e0:	85 c0                	test   %eax,%eax
801059e2:	78 1f                	js     80105a03 <sys_fstat+0x44>
801059e4:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
801059eb:	00 
801059ec:	8d 45 f0             	lea    -0x10(%ebp),%eax
801059ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801059f3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801059fa:	e8 36 fc ff ff       	call   80105635 <argptr>
801059ff:	85 c0                	test   %eax,%eax
80105a01:	79 07                	jns    80105a0a <sys_fstat+0x4b>
    return -1;
80105a03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a08:	eb 12                	jmp    80105a1c <sys_fstat+0x5d>
  return filestat(f, st);
80105a0a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a10:	89 54 24 04          	mov    %edx,0x4(%esp)
80105a14:	89 04 24             	mov    %eax,(%esp)
80105a17:	e8 e7 b6 ff ff       	call   80101103 <filestat>
}
80105a1c:	c9                   	leave  
80105a1d:	c3                   	ret    

80105a1e <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105a1e:	55                   	push   %ebp
80105a1f:	89 e5                	mov    %esp,%ebp
80105a21:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105a24:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105a27:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a2b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105a32:	e8 68 fc ff ff       	call   8010569f <argstr>
80105a37:	85 c0                	test   %eax,%eax
80105a39:	78 17                	js     80105a52 <sys_link+0x34>
80105a3b:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105a3e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a42:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105a49:	e8 51 fc ff ff       	call   8010569f <argstr>
80105a4e:	85 c0                	test   %eax,%eax
80105a50:	79 0a                	jns    80105a5c <sys_link+0x3e>
    return -1;
80105a52:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a57:	e9 42 01 00 00       	jmp    80105b9e <sys_link+0x180>

  begin_op();
80105a5c:	e8 26 da ff ff       	call   80103487 <begin_op>
  if((ip = namei(old)) == 0){
80105a61:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105a64:	89 04 24             	mov    %eax,(%esp)
80105a67:	e8 2b ca ff ff       	call   80102497 <namei>
80105a6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105a6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a73:	75 0f                	jne    80105a84 <sys_link+0x66>
    end_op();
80105a75:	e8 91 da ff ff       	call   8010350b <end_op>
    return -1;
80105a7a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a7f:	e9 1a 01 00 00       	jmp    80105b9e <sys_link+0x180>
  }

  ilock(ip);
80105a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a87:	89 04 24             	mov    %eax,(%esp)
80105a8a:	e8 ce be ff ff       	call   8010195d <ilock>
  if(ip->type == T_DIR){
80105a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a92:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105a96:	66 83 f8 01          	cmp    $0x1,%ax
80105a9a:	75 1a                	jne    80105ab6 <sys_link+0x98>
    iunlockput(ip);
80105a9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a9f:	89 04 24             	mov    %eax,(%esp)
80105aa2:	e8 b8 c0 ff ff       	call   80101b5f <iunlockput>
    end_op();
80105aa7:	e8 5f da ff ff       	call   8010350b <end_op>
    return -1;
80105aac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ab1:	e9 e8 00 00 00       	jmp    80105b9e <sys_link+0x180>
  }

  ip->nlink++;
80105ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ab9:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105abd:	8d 50 01             	lea    0x1(%eax),%edx
80105ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ac3:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80105ac7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105aca:	89 04 24             	mov    %eax,(%esp)
80105acd:	e8 c6 bc ff ff       	call   80101798 <iupdate>
  iunlock(ip);
80105ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ad5:	89 04 24             	mov    %eax,(%esp)
80105ad8:	e8 8d bf ff ff       	call   80101a6a <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80105add:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105ae0:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105ae3:	89 54 24 04          	mov    %edx,0x4(%esp)
80105ae7:	89 04 24             	mov    %eax,(%esp)
80105aea:	e8 ca c9 ff ff       	call   801024b9 <nameiparent>
80105aef:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105af2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105af6:	75 02                	jne    80105afa <sys_link+0xdc>
    goto bad;
80105af8:	eb 68                	jmp    80105b62 <sys_link+0x144>
  ilock(dp);
80105afa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105afd:	89 04 24             	mov    %eax,(%esp)
80105b00:	e8 58 be ff ff       	call   8010195d <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105b05:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b08:	8b 10                	mov    (%eax),%edx
80105b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b0d:	8b 00                	mov    (%eax),%eax
80105b0f:	39 c2                	cmp    %eax,%edx
80105b11:	75 20                	jne    80105b33 <sys_link+0x115>
80105b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b16:	8b 40 04             	mov    0x4(%eax),%eax
80105b19:	89 44 24 08          	mov    %eax,0x8(%esp)
80105b1d:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105b20:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b24:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b27:	89 04 24             	mov    %eax,(%esp)
80105b2a:	e8 a9 c6 ff ff       	call   801021d8 <dirlink>
80105b2f:	85 c0                	test   %eax,%eax
80105b31:	79 0d                	jns    80105b40 <sys_link+0x122>
    iunlockput(dp);
80105b33:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b36:	89 04 24             	mov    %eax,(%esp)
80105b39:	e8 21 c0 ff ff       	call   80101b5f <iunlockput>
    goto bad;
80105b3e:	eb 22                	jmp    80105b62 <sys_link+0x144>
  }
  iunlockput(dp);
80105b40:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b43:	89 04 24             	mov    %eax,(%esp)
80105b46:	e8 14 c0 ff ff       	call   80101b5f <iunlockput>
  iput(ip);
80105b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b4e:	89 04 24             	mov    %eax,(%esp)
80105b51:	e8 58 bf ff ff       	call   80101aae <iput>

  end_op();
80105b56:	e8 b0 d9 ff ff       	call   8010350b <end_op>

  return 0;
80105b5b:	b8 00 00 00 00       	mov    $0x0,%eax
80105b60:	eb 3c                	jmp    80105b9e <sys_link+0x180>

bad:
  ilock(ip);
80105b62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b65:	89 04 24             	mov    %eax,(%esp)
80105b68:	e8 f0 bd ff ff       	call   8010195d <ilock>
  ip->nlink--;
80105b6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b70:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105b74:	8d 50 ff             	lea    -0x1(%eax),%edx
80105b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b7a:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80105b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b81:	89 04 24             	mov    %eax,(%esp)
80105b84:	e8 0f bc ff ff       	call   80101798 <iupdate>
  iunlockput(ip);
80105b89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b8c:	89 04 24             	mov    %eax,(%esp)
80105b8f:	e8 cb bf ff ff       	call   80101b5f <iunlockput>
  end_op();
80105b94:	e8 72 d9 ff ff       	call   8010350b <end_op>
  return -1;
80105b99:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b9e:	c9                   	leave  
80105b9f:	c3                   	ret    

80105ba0 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105ba0:	55                   	push   %ebp
80105ba1:	89 e5                	mov    %esp,%ebp
80105ba3:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105ba6:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105bad:	eb 4b                	jmp    80105bfa <isdirempty+0x5a>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bb2:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105bb9:	00 
80105bba:	89 44 24 08          	mov    %eax,0x8(%esp)
80105bbe:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105bc1:	89 44 24 04          	mov    %eax,0x4(%esp)
80105bc5:	8b 45 08             	mov    0x8(%ebp),%eax
80105bc8:	89 04 24             	mov    %eax,(%esp)
80105bcb:	e8 2a c2 ff ff       	call   80101dfa <readi>
80105bd0:	83 f8 10             	cmp    $0x10,%eax
80105bd3:	74 0c                	je     80105be1 <isdirempty+0x41>
      panic("isdirempty: readi");
80105bd5:	c7 04 24 9c 89 10 80 	movl   $0x8010899c,(%esp)
80105bdc:	e8 81 a9 ff ff       	call   80100562 <panic>
    if(de.inum != 0)
80105be1:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105be5:	66 85 c0             	test   %ax,%ax
80105be8:	74 07                	je     80105bf1 <isdirempty+0x51>
      return 0;
80105bea:	b8 00 00 00 00       	mov    $0x0,%eax
80105bef:	eb 1b                	jmp    80105c0c <isdirempty+0x6c>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105bf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bf4:	83 c0 10             	add    $0x10,%eax
80105bf7:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105bfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105bfd:	8b 45 08             	mov    0x8(%ebp),%eax
80105c00:	8b 40 58             	mov    0x58(%eax),%eax
80105c03:	39 c2                	cmp    %eax,%edx
80105c05:	72 a8                	jb     80105baf <isdirempty+0xf>
  }
  return 1;
80105c07:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105c0c:	c9                   	leave  
80105c0d:	c3                   	ret    

80105c0e <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105c0e:	55                   	push   %ebp
80105c0f:	89 e5                	mov    %esp,%ebp
80105c11:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105c14:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105c17:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c1b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105c22:	e8 78 fa ff ff       	call   8010569f <argstr>
80105c27:	85 c0                	test   %eax,%eax
80105c29:	79 0a                	jns    80105c35 <sys_unlink+0x27>
    return -1;
80105c2b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c30:	e9 af 01 00 00       	jmp    80105de4 <sys_unlink+0x1d6>

  begin_op();
80105c35:	e8 4d d8 ff ff       	call   80103487 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105c3a:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105c3d:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105c40:	89 54 24 04          	mov    %edx,0x4(%esp)
80105c44:	89 04 24             	mov    %eax,(%esp)
80105c47:	e8 6d c8 ff ff       	call   801024b9 <nameiparent>
80105c4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105c4f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c53:	75 0f                	jne    80105c64 <sys_unlink+0x56>
    end_op();
80105c55:	e8 b1 d8 ff ff       	call   8010350b <end_op>
    return -1;
80105c5a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c5f:	e9 80 01 00 00       	jmp    80105de4 <sys_unlink+0x1d6>
  }

  ilock(dp);
80105c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c67:	89 04 24             	mov    %eax,(%esp)
80105c6a:	e8 ee bc ff ff       	call   8010195d <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105c6f:	c7 44 24 04 ae 89 10 	movl   $0x801089ae,0x4(%esp)
80105c76:	80 
80105c77:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105c7a:	89 04 24             	mov    %eax,(%esp)
80105c7d:	e8 6b c4 ff ff       	call   801020ed <namecmp>
80105c82:	85 c0                	test   %eax,%eax
80105c84:	0f 84 45 01 00 00    	je     80105dcf <sys_unlink+0x1c1>
80105c8a:	c7 44 24 04 b0 89 10 	movl   $0x801089b0,0x4(%esp)
80105c91:	80 
80105c92:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105c95:	89 04 24             	mov    %eax,(%esp)
80105c98:	e8 50 c4 ff ff       	call   801020ed <namecmp>
80105c9d:	85 c0                	test   %eax,%eax
80105c9f:	0f 84 2a 01 00 00    	je     80105dcf <sys_unlink+0x1c1>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105ca5:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105ca8:	89 44 24 08          	mov    %eax,0x8(%esp)
80105cac:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105caf:	89 44 24 04          	mov    %eax,0x4(%esp)
80105cb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cb6:	89 04 24             	mov    %eax,(%esp)
80105cb9:	e8 51 c4 ff ff       	call   8010210f <dirlookup>
80105cbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105cc1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105cc5:	75 05                	jne    80105ccc <sys_unlink+0xbe>
    goto bad;
80105cc7:	e9 03 01 00 00       	jmp    80105dcf <sys_unlink+0x1c1>
  ilock(ip);
80105ccc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ccf:	89 04 24             	mov    %eax,(%esp)
80105cd2:	e8 86 bc ff ff       	call   8010195d <ilock>

  if(ip->nlink < 1)
80105cd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cda:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105cde:	66 85 c0             	test   %ax,%ax
80105ce1:	7f 0c                	jg     80105cef <sys_unlink+0xe1>
    panic("unlink: nlink < 1");
80105ce3:	c7 04 24 b3 89 10 80 	movl   $0x801089b3,(%esp)
80105cea:	e8 73 a8 ff ff       	call   80100562 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105cef:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cf2:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105cf6:	66 83 f8 01          	cmp    $0x1,%ax
80105cfa:	75 1f                	jne    80105d1b <sys_unlink+0x10d>
80105cfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cff:	89 04 24             	mov    %eax,(%esp)
80105d02:	e8 99 fe ff ff       	call   80105ba0 <isdirempty>
80105d07:	85 c0                	test   %eax,%eax
80105d09:	75 10                	jne    80105d1b <sys_unlink+0x10d>
    iunlockput(ip);
80105d0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d0e:	89 04 24             	mov    %eax,(%esp)
80105d11:	e8 49 be ff ff       	call   80101b5f <iunlockput>
    goto bad;
80105d16:	e9 b4 00 00 00       	jmp    80105dcf <sys_unlink+0x1c1>
  }

  memset(&de, 0, sizeof(de));
80105d1b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80105d22:	00 
80105d23:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105d2a:	00 
80105d2b:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105d2e:	89 04 24             	mov    %eax,(%esp)
80105d31:	e8 89 f5 ff ff       	call   801052bf <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105d36:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105d39:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105d40:	00 
80105d41:	89 44 24 08          	mov    %eax,0x8(%esp)
80105d45:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105d48:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d4f:	89 04 24             	mov    %eax,(%esp)
80105d52:	e8 07 c2 ff ff       	call   80101f5e <writei>
80105d57:	83 f8 10             	cmp    $0x10,%eax
80105d5a:	74 0c                	je     80105d68 <sys_unlink+0x15a>
    panic("unlink: writei");
80105d5c:	c7 04 24 c5 89 10 80 	movl   $0x801089c5,(%esp)
80105d63:	e8 fa a7 ff ff       	call   80100562 <panic>
  if(ip->type == T_DIR){
80105d68:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d6b:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105d6f:	66 83 f8 01          	cmp    $0x1,%ax
80105d73:	75 1c                	jne    80105d91 <sys_unlink+0x183>
    dp->nlink--;
80105d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d78:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105d7c:	8d 50 ff             	lea    -0x1(%eax),%edx
80105d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d82:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
80105d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d89:	89 04 24             	mov    %eax,(%esp)
80105d8c:	e8 07 ba ff ff       	call   80101798 <iupdate>
  }
  iunlockput(dp);
80105d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d94:	89 04 24             	mov    %eax,(%esp)
80105d97:	e8 c3 bd ff ff       	call   80101b5f <iunlockput>

  ip->nlink--;
80105d9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d9f:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105da3:	8d 50 ff             	lea    -0x1(%eax),%edx
80105da6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105da9:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80105dad:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105db0:	89 04 24             	mov    %eax,(%esp)
80105db3:	e8 e0 b9 ff ff       	call   80101798 <iupdate>
  iunlockput(ip);
80105db8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dbb:	89 04 24             	mov    %eax,(%esp)
80105dbe:	e8 9c bd ff ff       	call   80101b5f <iunlockput>

  end_op();
80105dc3:	e8 43 d7 ff ff       	call   8010350b <end_op>

  return 0;
80105dc8:	b8 00 00 00 00       	mov    $0x0,%eax
80105dcd:	eb 15                	jmp    80105de4 <sys_unlink+0x1d6>

bad:
  iunlockput(dp);
80105dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dd2:	89 04 24             	mov    %eax,(%esp)
80105dd5:	e8 85 bd ff ff       	call   80101b5f <iunlockput>
  end_op();
80105dda:	e8 2c d7 ff ff       	call   8010350b <end_op>
  return -1;
80105ddf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105de4:	c9                   	leave  
80105de5:	c3                   	ret    

80105de6 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105de6:	55                   	push   %ebp
80105de7:	89 e5                	mov    %esp,%ebp
80105de9:	83 ec 48             	sub    $0x48,%esp
80105dec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105def:	8b 55 10             	mov    0x10(%ebp),%edx
80105df2:	8b 45 14             	mov    0x14(%ebp),%eax
80105df5:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105df9:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105dfd:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105e01:	8d 45 de             	lea    -0x22(%ebp),%eax
80105e04:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e08:	8b 45 08             	mov    0x8(%ebp),%eax
80105e0b:	89 04 24             	mov    %eax,(%esp)
80105e0e:	e8 a6 c6 ff ff       	call   801024b9 <nameiparent>
80105e13:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105e16:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e1a:	75 0a                	jne    80105e26 <create+0x40>
    return 0;
80105e1c:	b8 00 00 00 00       	mov    $0x0,%eax
80105e21:	e9 7e 01 00 00       	jmp    80105fa4 <create+0x1be>
  ilock(dp);
80105e26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e29:	89 04 24             	mov    %eax,(%esp)
80105e2c:	e8 2c bb ff ff       	call   8010195d <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80105e31:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105e34:	89 44 24 08          	mov    %eax,0x8(%esp)
80105e38:	8d 45 de             	lea    -0x22(%ebp),%eax
80105e3b:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e42:	89 04 24             	mov    %eax,(%esp)
80105e45:	e8 c5 c2 ff ff       	call   8010210f <dirlookup>
80105e4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105e4d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105e51:	74 47                	je     80105e9a <create+0xb4>
    iunlockput(dp);
80105e53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e56:	89 04 24             	mov    %eax,(%esp)
80105e59:	e8 01 bd ff ff       	call   80101b5f <iunlockput>
    ilock(ip);
80105e5e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e61:	89 04 24             	mov    %eax,(%esp)
80105e64:	e8 f4 ba ff ff       	call   8010195d <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105e69:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105e6e:	75 15                	jne    80105e85 <create+0x9f>
80105e70:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e73:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105e77:	66 83 f8 02          	cmp    $0x2,%ax
80105e7b:	75 08                	jne    80105e85 <create+0x9f>
      return ip;
80105e7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e80:	e9 1f 01 00 00       	jmp    80105fa4 <create+0x1be>
    iunlockput(ip);
80105e85:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e88:	89 04 24             	mov    %eax,(%esp)
80105e8b:	e8 cf bc ff ff       	call   80101b5f <iunlockput>
    return 0;
80105e90:	b8 00 00 00 00       	mov    $0x0,%eax
80105e95:	e9 0a 01 00 00       	jmp    80105fa4 <create+0x1be>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105e9a:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105e9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ea1:	8b 00                	mov    (%eax),%eax
80105ea3:	89 54 24 04          	mov    %edx,0x4(%esp)
80105ea7:	89 04 24             	mov    %eax,(%esp)
80105eaa:	e8 14 b8 ff ff       	call   801016c3 <ialloc>
80105eaf:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105eb2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105eb6:	75 0c                	jne    80105ec4 <create+0xde>
    panic("create: ialloc");
80105eb8:	c7 04 24 d4 89 10 80 	movl   $0x801089d4,(%esp)
80105ebf:	e8 9e a6 ff ff       	call   80100562 <panic>

  ilock(ip);
80105ec4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ec7:	89 04 24             	mov    %eax,(%esp)
80105eca:	e8 8e ba ff ff       	call   8010195d <ilock>
  ip->major = major;
80105ecf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ed2:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80105ed6:	66 89 50 52          	mov    %dx,0x52(%eax)
  ip->minor = minor;
80105eda:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105edd:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80105ee1:	66 89 50 54          	mov    %dx,0x54(%eax)
  ip->nlink = 1;
80105ee5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ee8:	66 c7 40 56 01 00    	movw   $0x1,0x56(%eax)
  iupdate(ip);
80105eee:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ef1:	89 04 24             	mov    %eax,(%esp)
80105ef4:	e8 9f b8 ff ff       	call   80101798 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80105ef9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105efe:	75 6a                	jne    80105f6a <create+0x184>
    dp->nlink++;  // for ".."
80105f00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f03:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105f07:	8d 50 01             	lea    0x1(%eax),%edx
80105f0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f0d:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
80105f11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f14:	89 04 24             	mov    %eax,(%esp)
80105f17:	e8 7c b8 ff ff       	call   80101798 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105f1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f1f:	8b 40 04             	mov    0x4(%eax),%eax
80105f22:	89 44 24 08          	mov    %eax,0x8(%esp)
80105f26:	c7 44 24 04 ae 89 10 	movl   $0x801089ae,0x4(%esp)
80105f2d:	80 
80105f2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f31:	89 04 24             	mov    %eax,(%esp)
80105f34:	e8 9f c2 ff ff       	call   801021d8 <dirlink>
80105f39:	85 c0                	test   %eax,%eax
80105f3b:	78 21                	js     80105f5e <create+0x178>
80105f3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f40:	8b 40 04             	mov    0x4(%eax),%eax
80105f43:	89 44 24 08          	mov    %eax,0x8(%esp)
80105f47:	c7 44 24 04 b0 89 10 	movl   $0x801089b0,0x4(%esp)
80105f4e:	80 
80105f4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f52:	89 04 24             	mov    %eax,(%esp)
80105f55:	e8 7e c2 ff ff       	call   801021d8 <dirlink>
80105f5a:	85 c0                	test   %eax,%eax
80105f5c:	79 0c                	jns    80105f6a <create+0x184>
      panic("create dots");
80105f5e:	c7 04 24 e3 89 10 80 	movl   $0x801089e3,(%esp)
80105f65:	e8 f8 a5 ff ff       	call   80100562 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105f6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f6d:	8b 40 04             	mov    0x4(%eax),%eax
80105f70:	89 44 24 08          	mov    %eax,0x8(%esp)
80105f74:	8d 45 de             	lea    -0x22(%ebp),%eax
80105f77:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f7e:	89 04 24             	mov    %eax,(%esp)
80105f81:	e8 52 c2 ff ff       	call   801021d8 <dirlink>
80105f86:	85 c0                	test   %eax,%eax
80105f88:	79 0c                	jns    80105f96 <create+0x1b0>
    panic("create: dirlink");
80105f8a:	c7 04 24 ef 89 10 80 	movl   $0x801089ef,(%esp)
80105f91:	e8 cc a5 ff ff       	call   80100562 <panic>

  iunlockput(dp);
80105f96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f99:	89 04 24             	mov    %eax,(%esp)
80105f9c:	e8 be bb ff ff       	call   80101b5f <iunlockput>

  return ip;
80105fa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105fa4:	c9                   	leave  
80105fa5:	c3                   	ret    

80105fa6 <sys_open>:

int
sys_open(void)
{
80105fa6:	55                   	push   %ebp
80105fa7:	89 e5                	mov    %esp,%ebp
80105fa9:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105fac:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105faf:	89 44 24 04          	mov    %eax,0x4(%esp)
80105fb3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105fba:	e8 e0 f6 ff ff       	call   8010569f <argstr>
80105fbf:	85 c0                	test   %eax,%eax
80105fc1:	78 17                	js     80105fda <sys_open+0x34>
80105fc3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105fc6:	89 44 24 04          	mov    %eax,0x4(%esp)
80105fca:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105fd1:	e8 32 f6 ff ff       	call   80105608 <argint>
80105fd6:	85 c0                	test   %eax,%eax
80105fd8:	79 0a                	jns    80105fe4 <sys_open+0x3e>
    return -1;
80105fda:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fdf:	e9 5c 01 00 00       	jmp    80106140 <sys_open+0x19a>

  begin_op();
80105fe4:	e8 9e d4 ff ff       	call   80103487 <begin_op>

  if(omode & O_CREATE){
80105fe9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105fec:	25 00 02 00 00       	and    $0x200,%eax
80105ff1:	85 c0                	test   %eax,%eax
80105ff3:	74 3b                	je     80106030 <sys_open+0x8a>
    ip = create(path, T_FILE, 0, 0);
80105ff5:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105ff8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80105fff:	00 
80106000:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106007:	00 
80106008:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
8010600f:	00 
80106010:	89 04 24             	mov    %eax,(%esp)
80106013:	e8 ce fd ff ff       	call   80105de6 <create>
80106018:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
8010601b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010601f:	75 6b                	jne    8010608c <sys_open+0xe6>
      end_op();
80106021:	e8 e5 d4 ff ff       	call   8010350b <end_op>
      return -1;
80106026:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010602b:	e9 10 01 00 00       	jmp    80106140 <sys_open+0x19a>
    }
  } else {
    if((ip = namei(path)) == 0){
80106030:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106033:	89 04 24             	mov    %eax,(%esp)
80106036:	e8 5c c4 ff ff       	call   80102497 <namei>
8010603b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010603e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106042:	75 0f                	jne    80106053 <sys_open+0xad>
      end_op();
80106044:	e8 c2 d4 ff ff       	call   8010350b <end_op>
      return -1;
80106049:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010604e:	e9 ed 00 00 00       	jmp    80106140 <sys_open+0x19a>
    }
    ilock(ip);
80106053:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106056:	89 04 24             	mov    %eax,(%esp)
80106059:	e8 ff b8 ff ff       	call   8010195d <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
8010605e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106061:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80106065:	66 83 f8 01          	cmp    $0x1,%ax
80106069:	75 21                	jne    8010608c <sys_open+0xe6>
8010606b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010606e:	85 c0                	test   %eax,%eax
80106070:	74 1a                	je     8010608c <sys_open+0xe6>
      iunlockput(ip);
80106072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106075:	89 04 24             	mov    %eax,(%esp)
80106078:	e8 e2 ba ff ff       	call   80101b5f <iunlockput>
      end_op();
8010607d:	e8 89 d4 ff ff       	call   8010350b <end_op>
      return -1;
80106082:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106087:	e9 b4 00 00 00       	jmp    80106140 <sys_open+0x19a>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010608c:	e8 f4 ae ff ff       	call   80100f85 <filealloc>
80106091:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106094:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106098:	74 14                	je     801060ae <sys_open+0x108>
8010609a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010609d:	89 04 24             	mov    %eax,(%esp)
801060a0:	e8 2d f7 ff ff       	call   801057d2 <fdalloc>
801060a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
801060a8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801060ac:	79 28                	jns    801060d6 <sys_open+0x130>
    if(f)
801060ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801060b2:	74 0b                	je     801060bf <sys_open+0x119>
      fileclose(f);
801060b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060b7:	89 04 24             	mov    %eax,(%esp)
801060ba:	e8 6e af ff ff       	call   8010102d <fileclose>
    iunlockput(ip);
801060bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060c2:	89 04 24             	mov    %eax,(%esp)
801060c5:	e8 95 ba ff ff       	call   80101b5f <iunlockput>
    end_op();
801060ca:	e8 3c d4 ff ff       	call   8010350b <end_op>
    return -1;
801060cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060d4:	eb 6a                	jmp    80106140 <sys_open+0x19a>
  }
  iunlock(ip);
801060d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060d9:	89 04 24             	mov    %eax,(%esp)
801060dc:	e8 89 b9 ff ff       	call   80101a6a <iunlock>
  end_op();
801060e1:	e8 25 d4 ff ff       	call   8010350b <end_op>

  f->type = FD_INODE;
801060e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060e9:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
801060ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801060f5:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
801060f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060fb:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80106102:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106105:	83 e0 01             	and    $0x1,%eax
80106108:	85 c0                	test   %eax,%eax
8010610a:	0f 94 c0             	sete   %al
8010610d:	89 c2                	mov    %eax,%edx
8010610f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106112:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106115:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106118:	83 e0 01             	and    $0x1,%eax
8010611b:	85 c0                	test   %eax,%eax
8010611d:	75 0a                	jne    80106129 <sys_open+0x183>
8010611f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106122:	83 e0 02             	and    $0x2,%eax
80106125:	85 c0                	test   %eax,%eax
80106127:	74 07                	je     80106130 <sys_open+0x18a>
80106129:	b8 01 00 00 00       	mov    $0x1,%eax
8010612e:	eb 05                	jmp    80106135 <sys_open+0x18f>
80106130:	b8 00 00 00 00       	mov    $0x0,%eax
80106135:	89 c2                	mov    %eax,%edx
80106137:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010613a:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
8010613d:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80106140:	c9                   	leave  
80106141:	c3                   	ret    

80106142 <sys_mkdir>:

int
sys_mkdir(void)
{
80106142:	55                   	push   %ebp
80106143:	89 e5                	mov    %esp,%ebp
80106145:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106148:	e8 3a d3 ff ff       	call   80103487 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010614d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106150:	89 44 24 04          	mov    %eax,0x4(%esp)
80106154:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010615b:	e8 3f f5 ff ff       	call   8010569f <argstr>
80106160:	85 c0                	test   %eax,%eax
80106162:	78 2c                	js     80106190 <sys_mkdir+0x4e>
80106164:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106167:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
8010616e:	00 
8010616f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106176:	00 
80106177:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010617e:	00 
8010617f:	89 04 24             	mov    %eax,(%esp)
80106182:	e8 5f fc ff ff       	call   80105de6 <create>
80106187:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010618a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010618e:	75 0c                	jne    8010619c <sys_mkdir+0x5a>
    end_op();
80106190:	e8 76 d3 ff ff       	call   8010350b <end_op>
    return -1;
80106195:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010619a:	eb 15                	jmp    801061b1 <sys_mkdir+0x6f>
  }
  iunlockput(ip);
8010619c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010619f:	89 04 24             	mov    %eax,(%esp)
801061a2:	e8 b8 b9 ff ff       	call   80101b5f <iunlockput>
  end_op();
801061a7:	e8 5f d3 ff ff       	call   8010350b <end_op>
  return 0;
801061ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
801061b1:	c9                   	leave  
801061b2:	c3                   	ret    

801061b3 <sys_mknod>:

int
sys_mknod(void)
{
801061b3:	55                   	push   %ebp
801061b4:	89 e5                	mov    %esp,%ebp
801061b6:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801061b9:	e8 c9 d2 ff ff       	call   80103487 <begin_op>
  if((argstr(0, &path)) < 0 ||
801061be:	8d 45 f0             	lea    -0x10(%ebp),%eax
801061c1:	89 44 24 04          	mov    %eax,0x4(%esp)
801061c5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801061cc:	e8 ce f4 ff ff       	call   8010569f <argstr>
801061d1:	85 c0                	test   %eax,%eax
801061d3:	78 5e                	js     80106233 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801061d5:	8d 45 ec             	lea    -0x14(%ebp),%eax
801061d8:	89 44 24 04          	mov    %eax,0x4(%esp)
801061dc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801061e3:	e8 20 f4 ff ff       	call   80105608 <argint>
  if((argstr(0, &path)) < 0 ||
801061e8:	85 c0                	test   %eax,%eax
801061ea:	78 47                	js     80106233 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801061ec:	8d 45 e8             	lea    -0x18(%ebp),%eax
801061ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801061f3:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801061fa:	e8 09 f4 ff ff       	call   80105608 <argint>
     argint(1, &major) < 0 ||
801061ff:	85 c0                	test   %eax,%eax
80106201:	78 30                	js     80106233 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80106203:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106206:	0f bf c8             	movswl %ax,%ecx
80106209:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010620c:	0f bf d0             	movswl %ax,%edx
8010620f:	8b 45 f0             	mov    -0x10(%ebp),%eax
     argint(2, &minor) < 0 ||
80106212:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106216:	89 54 24 08          	mov    %edx,0x8(%esp)
8010621a:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80106221:	00 
80106222:	89 04 24             	mov    %eax,(%esp)
80106225:	e8 bc fb ff ff       	call   80105de6 <create>
8010622a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010622d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106231:	75 0c                	jne    8010623f <sys_mknod+0x8c>
    end_op();
80106233:	e8 d3 d2 ff ff       	call   8010350b <end_op>
    return -1;
80106238:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010623d:	eb 15                	jmp    80106254 <sys_mknod+0xa1>
  }
  iunlockput(ip);
8010623f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106242:	89 04 24             	mov    %eax,(%esp)
80106245:	e8 15 b9 ff ff       	call   80101b5f <iunlockput>
  end_op();
8010624a:	e8 bc d2 ff ff       	call   8010350b <end_op>
  return 0;
8010624f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106254:	c9                   	leave  
80106255:	c3                   	ret    

80106256 <sys_chdir>:

int
sys_chdir(void)
{
80106256:	55                   	push   %ebp
80106257:	89 e5                	mov    %esp,%ebp
80106259:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
8010625c:	e8 00 df ff ff       	call   80104161 <myproc>
80106261:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  begin_op();
80106264:	e8 1e d2 ff ff       	call   80103487 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106269:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010626c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106270:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106277:	e8 23 f4 ff ff       	call   8010569f <argstr>
8010627c:	85 c0                	test   %eax,%eax
8010627e:	78 14                	js     80106294 <sys_chdir+0x3e>
80106280:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106283:	89 04 24             	mov    %eax,(%esp)
80106286:	e8 0c c2 ff ff       	call   80102497 <namei>
8010628b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010628e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106292:	75 0c                	jne    801062a0 <sys_chdir+0x4a>
    end_op();
80106294:	e8 72 d2 ff ff       	call   8010350b <end_op>
    return -1;
80106299:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010629e:	eb 5b                	jmp    801062fb <sys_chdir+0xa5>
  }
  ilock(ip);
801062a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062a3:	89 04 24             	mov    %eax,(%esp)
801062a6:	e8 b2 b6 ff ff       	call   8010195d <ilock>
  if(ip->type != T_DIR){
801062ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062ae:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801062b2:	66 83 f8 01          	cmp    $0x1,%ax
801062b6:	74 17                	je     801062cf <sys_chdir+0x79>
    iunlockput(ip);
801062b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062bb:	89 04 24             	mov    %eax,(%esp)
801062be:	e8 9c b8 ff ff       	call   80101b5f <iunlockput>
    end_op();
801062c3:	e8 43 d2 ff ff       	call   8010350b <end_op>
    return -1;
801062c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062cd:	eb 2c                	jmp    801062fb <sys_chdir+0xa5>
  }
  iunlock(ip);
801062cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062d2:	89 04 24             	mov    %eax,(%esp)
801062d5:	e8 90 b7 ff ff       	call   80101a6a <iunlock>
  iput(curproc->cwd);
801062da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062dd:	8b 40 68             	mov    0x68(%eax),%eax
801062e0:	89 04 24             	mov    %eax,(%esp)
801062e3:	e8 c6 b7 ff ff       	call   80101aae <iput>
  end_op();
801062e8:	e8 1e d2 ff ff       	call   8010350b <end_op>
  curproc->cwd = ip;
801062ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062f0:	8b 55 f0             	mov    -0x10(%ebp),%edx
801062f3:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
801062f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801062fb:	c9                   	leave  
801062fc:	c3                   	ret    

801062fd <sys_exec>:

int
sys_exec(void)
{
801062fd:	55                   	push   %ebp
801062fe:	89 e5                	mov    %esp,%ebp
80106300:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106306:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106309:	89 44 24 04          	mov    %eax,0x4(%esp)
8010630d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106314:	e8 86 f3 ff ff       	call   8010569f <argstr>
80106319:	85 c0                	test   %eax,%eax
8010631b:	78 1a                	js     80106337 <sys_exec+0x3a>
8010631d:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80106323:	89 44 24 04          	mov    %eax,0x4(%esp)
80106327:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010632e:	e8 d5 f2 ff ff       	call   80105608 <argint>
80106333:	85 c0                	test   %eax,%eax
80106335:	79 0a                	jns    80106341 <sys_exec+0x44>
    return -1;
80106337:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010633c:	e9 c8 00 00 00       	jmp    80106409 <sys_exec+0x10c>
  }
  memset(argv, 0, sizeof(argv));
80106341:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80106348:	00 
80106349:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106350:	00 
80106351:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106357:	89 04 24             	mov    %eax,(%esp)
8010635a:	e8 60 ef ff ff       	call   801052bf <memset>
  for(i=0;; i++){
8010635f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80106366:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106369:	83 f8 1f             	cmp    $0x1f,%eax
8010636c:	76 0a                	jbe    80106378 <sys_exec+0x7b>
      return -1;
8010636e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106373:	e9 91 00 00 00       	jmp    80106409 <sys_exec+0x10c>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106378:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010637b:	c1 e0 02             	shl    $0x2,%eax
8010637e:	89 c2                	mov    %eax,%edx
80106380:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80106386:	01 c2                	add    %eax,%edx
80106388:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
8010638e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106392:	89 14 24             	mov    %edx,(%esp)
80106395:	e8 cb f1 ff ff       	call   80105565 <fetchint>
8010639a:	85 c0                	test   %eax,%eax
8010639c:	79 07                	jns    801063a5 <sys_exec+0xa8>
      return -1;
8010639e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063a3:	eb 64                	jmp    80106409 <sys_exec+0x10c>
    if(uarg == 0){
801063a5:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801063ab:	85 c0                	test   %eax,%eax
801063ad:	75 26                	jne    801063d5 <sys_exec+0xd8>
      argv[i] = 0;
801063af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063b2:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
801063b9:	00 00 00 00 
      break;
801063bd:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801063be:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063c1:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
801063c7:	89 54 24 04          	mov    %edx,0x4(%esp)
801063cb:	89 04 24             	mov    %eax,(%esp)
801063ce:	e8 4b a7 ff ff       	call   80100b1e <exec>
801063d3:	eb 34                	jmp    80106409 <sys_exec+0x10c>
    if(fetchstr(uarg, &argv[i]) < 0)
801063d5:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801063db:	8b 55 f4             	mov    -0xc(%ebp),%edx
801063de:	c1 e2 02             	shl    $0x2,%edx
801063e1:	01 c2                	add    %eax,%edx
801063e3:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801063e9:	89 54 24 04          	mov    %edx,0x4(%esp)
801063ed:	89 04 24             	mov    %eax,(%esp)
801063f0:	e8 af f1 ff ff       	call   801055a4 <fetchstr>
801063f5:	85 c0                	test   %eax,%eax
801063f7:	79 07                	jns    80106400 <sys_exec+0x103>
      return -1;
801063f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063fe:	eb 09                	jmp    80106409 <sys_exec+0x10c>
  for(i=0;; i++){
80106400:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }
80106404:	e9 5d ff ff ff       	jmp    80106366 <sys_exec+0x69>
}
80106409:	c9                   	leave  
8010640a:	c3                   	ret    

8010640b <sys_pipe>:

int
sys_pipe(void)
{
8010640b:	55                   	push   %ebp
8010640c:	89 e5                	mov    %esp,%ebp
8010640e:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106411:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80106418:	00 
80106419:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010641c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106420:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106427:	e8 09 f2 ff ff       	call   80105635 <argptr>
8010642c:	85 c0                	test   %eax,%eax
8010642e:	79 0a                	jns    8010643a <sys_pipe+0x2f>
    return -1;
80106430:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106435:	e9 9a 00 00 00       	jmp    801064d4 <sys_pipe+0xc9>
  if(pipealloc(&rf, &wf) < 0)
8010643a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010643d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106441:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106444:	89 04 24             	mov    %eax,(%esp)
80106447:	e8 99 d8 ff ff       	call   80103ce5 <pipealloc>
8010644c:	85 c0                	test   %eax,%eax
8010644e:	79 07                	jns    80106457 <sys_pipe+0x4c>
    return -1;
80106450:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106455:	eb 7d                	jmp    801064d4 <sys_pipe+0xc9>
  fd0 = -1;
80106457:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010645e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106461:	89 04 24             	mov    %eax,(%esp)
80106464:	e8 69 f3 ff ff       	call   801057d2 <fdalloc>
80106469:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010646c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106470:	78 14                	js     80106486 <sys_pipe+0x7b>
80106472:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106475:	89 04 24             	mov    %eax,(%esp)
80106478:	e8 55 f3 ff ff       	call   801057d2 <fdalloc>
8010647d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106480:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106484:	79 36                	jns    801064bc <sys_pipe+0xb1>
    if(fd0 >= 0)
80106486:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010648a:	78 13                	js     8010649f <sys_pipe+0x94>
      myproc()->ofile[fd0] = 0;
8010648c:	e8 d0 dc ff ff       	call   80104161 <myproc>
80106491:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106494:	83 c2 08             	add    $0x8,%edx
80106497:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
8010649e:	00 
    fileclose(rf);
8010649f:	8b 45 e8             	mov    -0x18(%ebp),%eax
801064a2:	89 04 24             	mov    %eax,(%esp)
801064a5:	e8 83 ab ff ff       	call   8010102d <fileclose>
    fileclose(wf);
801064aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801064ad:	89 04 24             	mov    %eax,(%esp)
801064b0:	e8 78 ab ff ff       	call   8010102d <fileclose>
    return -1;
801064b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064ba:	eb 18                	jmp    801064d4 <sys_pipe+0xc9>
  }
  fd[0] = fd0;
801064bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801064bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
801064c2:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
801064c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
801064c7:	8d 50 04             	lea    0x4(%eax),%edx
801064ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064cd:	89 02                	mov    %eax,(%edx)
  return 0;
801064cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
801064d4:	c9                   	leave  
801064d5:	c3                   	ret    

801064d6 <sys_fork>:
#include "proc.h"
#include "pstat.h"

int
sys_fork(void)
{
801064d6:	55                   	push   %ebp
801064d7:	89 e5                	mov    %esp,%ebp
801064d9:	83 ec 08             	sub    $0x8,%esp
  return fork();
801064dc:	e8 98 df ff ff       	call   80104479 <fork>
}
801064e1:	c9                   	leave  
801064e2:	c3                   	ret    

801064e3 <sys_exit>:

int
sys_exit(void)
{
801064e3:	55                   	push   %ebp
801064e4:	89 e5                	mov    %esp,%ebp
801064e6:	83 ec 08             	sub    $0x8,%esp
  exit();
801064e9:	e8 22 e1 ff ff       	call   80104610 <exit>
  return 0;  // not reached
801064ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
801064f3:	c9                   	leave  
801064f4:	c3                   	ret    

801064f5 <sys_wait>:

int
sys_wait(void)
{
801064f5:	55                   	push   %ebp
801064f6:	89 e5                	mov    %esp,%ebp
801064f8:	83 ec 08             	sub    $0x8,%esp
  return wait();
801064fb:	e8 1d e2 ff ff       	call   8010471d <wait>
}
80106500:	c9                   	leave  
80106501:	c3                   	ret    

80106502 <sys_kill>:

int
sys_kill(void)
{
80106502:	55                   	push   %ebp
80106503:	89 e5                	mov    %esp,%ebp
80106505:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106508:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010650b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010650f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106516:	e8 ed f0 ff ff       	call   80105608 <argint>
8010651b:	85 c0                	test   %eax,%eax
8010651d:	79 07                	jns    80106526 <sys_kill+0x24>
    return -1;
8010651f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106524:	eb 0b                	jmp    80106531 <sys_kill+0x2f>
  return kill(pid);
80106526:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106529:	89 04 24             	mov    %eax,(%esp)
8010652c:	e8 6d e6 ff ff       	call   80104b9e <kill>
}
80106531:	c9                   	leave  
80106532:	c3                   	ret    

80106533 <sys_getpid>:

int
sys_getpid(void)
{
80106533:	55                   	push   %ebp
80106534:	89 e5                	mov    %esp,%ebp
80106536:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106539:	e8 23 dc ff ff       	call   80104161 <myproc>
8010653e:	8b 40 10             	mov    0x10(%eax),%eax
}
80106541:	c9                   	leave  
80106542:	c3                   	ret    

80106543 <sys_sbrk>:

int
sys_sbrk(void)
{
80106543:	55                   	push   %ebp
80106544:	89 e5                	mov    %esp,%ebp
80106546:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106549:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010654c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106550:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106557:	e8 ac f0 ff ff       	call   80105608 <argint>
8010655c:	85 c0                	test   %eax,%eax
8010655e:	79 07                	jns    80106567 <sys_sbrk+0x24>
    return -1;
80106560:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106565:	eb 23                	jmp    8010658a <sys_sbrk+0x47>
  addr = myproc()->sz;
80106567:	e8 f5 db ff ff       	call   80104161 <myproc>
8010656c:	8b 00                	mov    (%eax),%eax
8010656e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106571:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106574:	89 04 24             	mov    %eax,(%esp)
80106577:	e8 5f de ff ff       	call   801043db <growproc>
8010657c:	85 c0                	test   %eax,%eax
8010657e:	79 07                	jns    80106587 <sys_sbrk+0x44>
    return -1;
80106580:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106585:	eb 03                	jmp    8010658a <sys_sbrk+0x47>
  return addr;
80106587:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010658a:	c9                   	leave  
8010658b:	c3                   	ret    

8010658c <sys_sleep>:

int
sys_sleep(void)
{
8010658c:	55                   	push   %ebp
8010658d:	89 e5                	mov    %esp,%ebp
8010658f:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106592:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106595:	89 44 24 04          	mov    %eax,0x4(%esp)
80106599:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801065a0:	e8 63 f0 ff ff       	call   80105608 <argint>
801065a5:	85 c0                	test   %eax,%eax
801065a7:	79 07                	jns    801065b0 <sys_sleep+0x24>
    return -1;
801065a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065ae:	eb 6b                	jmp    8010661b <sys_sleep+0x8f>
  acquire(&tickslock);
801065b0:	c7 04 24 20 5f 11 80 	movl   $0x80115f20,(%esp)
801065b7:	e8 91 ea ff ff       	call   8010504d <acquire>
  ticks0 = ticks;
801065bc:	a1 60 67 11 80       	mov    0x80116760,%eax
801065c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
801065c4:	eb 33                	jmp    801065f9 <sys_sleep+0x6d>
    if(myproc()->killed){
801065c6:	e8 96 db ff ff       	call   80104161 <myproc>
801065cb:	8b 40 24             	mov    0x24(%eax),%eax
801065ce:	85 c0                	test   %eax,%eax
801065d0:	74 13                	je     801065e5 <sys_sleep+0x59>
      release(&tickslock);
801065d2:	c7 04 24 20 5f 11 80 	movl   $0x80115f20,(%esp)
801065d9:	e8 d7 ea ff ff       	call   801050b5 <release>
      return -1;
801065de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065e3:	eb 36                	jmp    8010661b <sys_sleep+0x8f>
    }
    sleep(&ticks, &tickslock);
801065e5:	c7 44 24 04 20 5f 11 	movl   $0x80115f20,0x4(%esp)
801065ec:	80 
801065ed:	c7 04 24 60 67 11 80 	movl   $0x80116760,(%esp)
801065f4:	e8 a3 e4 ff ff       	call   80104a9c <sleep>
  while(ticks - ticks0 < n){
801065f9:	a1 60 67 11 80       	mov    0x80116760,%eax
801065fe:	2b 45 f4             	sub    -0xc(%ebp),%eax
80106601:	89 c2                	mov    %eax,%edx
80106603:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106606:	39 c2                	cmp    %eax,%edx
80106608:	72 bc                	jb     801065c6 <sys_sleep+0x3a>
  }
  release(&tickslock);
8010660a:	c7 04 24 20 5f 11 80 	movl   $0x80115f20,(%esp)
80106611:	e8 9f ea ff ff       	call   801050b5 <release>
  return 0;
80106616:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010661b:	c9                   	leave  
8010661c:	c3                   	ret    

8010661d <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
8010661d:	55                   	push   %ebp
8010661e:	89 e5                	mov    %esp,%ebp
80106620:	83 ec 28             	sub    $0x28,%esp
  uint xticks;

  acquire(&tickslock);
80106623:	c7 04 24 20 5f 11 80 	movl   $0x80115f20,(%esp)
8010662a:	e8 1e ea ff ff       	call   8010504d <acquire>
  xticks = ticks;
8010662f:	a1 60 67 11 80       	mov    0x80116760,%eax
80106634:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80106637:	c7 04 24 20 5f 11 80 	movl   $0x80115f20,(%esp)
8010663e:	e8 72 ea ff ff       	call   801050b5 <release>
  return xticks;
80106643:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106646:	c9                   	leave  
80106647:	c3                   	ret    

80106648 <sys_getpinfo>:

extern void fillpstat(pstatTable *);
int
sys_getpinfo(void)
{
80106648:	55                   	push   %ebp
80106649:	89 e5                	mov    %esp,%ebp
8010664b:	83 ec 28             	sub    $0x28,%esp
  struct pstatTable * ptr;

  argptr(0,(char **)&ptr, sizeof(struct pstatTable *));
8010664e:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80106655:	00 
80106656:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106659:	89 44 24 04          	mov    %eax,0x4(%esp)
8010665d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106664:	e8 cc ef ff ff       	call   80105635 <argptr>

  fillpstat((pstatTable *) ptr);
80106669:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010666c:	89 04 24             	mov    %eax,(%esp)
8010666f:	e8 9f e6 ff ff       	call   80104d13 <fillpstat>

  return 0;
80106674:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106679:	c9                   	leave  
8010667a:	c3                   	ret    

8010667b <sys_settickets>:

int
sys_settickets(int number)
{
8010667b:	55                   	push   %ebp
8010667c:	89 e5                	mov    %esp,%ebp
8010667e:	83 ec 28             	sub    $0x28,%esp
  int n = 0;
80106681:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  argint(0, &n);
80106688:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010668b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010668f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106696:	e8 6d ef ff ff       	call   80105608 <argint>
  if(n < 10)
8010669b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010669e:	83 f8 09             	cmp    $0x9,%eax
801066a1:	7f 07                	jg     801066aa <sys_settickets+0x2f>
  {
    return -1;
801066a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066a8:	eb 10                	jmp    801066ba <sys_settickets+0x3f>
  }
  myproc()->tickets = n;
801066aa:	e8 b2 da ff ff       	call   80104161 <myproc>
801066af:	8b 55 f4             	mov    -0xc(%ebp),%edx
801066b2:	89 50 7c             	mov    %edx,0x7c(%eax)
  return 0;
801066b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801066ba:	c9                   	leave  
801066bb:	c3                   	ret    

801066bc <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801066bc:	1e                   	push   %ds
  pushl %es
801066bd:	06                   	push   %es
  pushl %fs
801066be:	0f a0                	push   %fs
  pushl %gs
801066c0:	0f a8                	push   %gs
  pushal
801066c2:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801066c3:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801066c7:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801066c9:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801066cb:	54                   	push   %esp
  call trap
801066cc:	e8 d8 01 00 00       	call   801068a9 <trap>
  addl $4, %esp
801066d1:	83 c4 04             	add    $0x4,%esp

801066d4 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801066d4:	61                   	popa   
  popl %gs
801066d5:	0f a9                	pop    %gs
  popl %fs
801066d7:	0f a1                	pop    %fs
  popl %es
801066d9:	07                   	pop    %es
  popl %ds
801066da:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801066db:	83 c4 08             	add    $0x8,%esp
  iret
801066de:	cf                   	iret   

801066df <lidt>:
{
801066df:	55                   	push   %ebp
801066e0:	89 e5                	mov    %esp,%ebp
801066e2:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
801066e5:	8b 45 0c             	mov    0xc(%ebp),%eax
801066e8:	83 e8 01             	sub    $0x1,%eax
801066eb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801066ef:	8b 45 08             	mov    0x8(%ebp),%eax
801066f2:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801066f6:	8b 45 08             	mov    0x8(%ebp),%eax
801066f9:	c1 e8 10             	shr    $0x10,%eax
801066fc:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106700:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106703:	0f 01 18             	lidtl  (%eax)
}
80106706:	c9                   	leave  
80106707:	c3                   	ret    

80106708 <rcr2>:

static inline uint
rcr2(void)
{
80106708:	55                   	push   %ebp
80106709:	89 e5                	mov    %esp,%ebp
8010670b:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010670e:	0f 20 d0             	mov    %cr2,%eax
80106711:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106714:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106717:	c9                   	leave  
80106718:	c3                   	ret    

80106719 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106719:	55                   	push   %ebp
8010671a:	89 e5                	mov    %esp,%ebp
8010671c:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
8010671f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106726:	e9 c3 00 00 00       	jmp    801067ee <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
8010672b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010672e:	8b 04 85 a4 b0 10 80 	mov    -0x7fef4f5c(,%eax,4),%eax
80106735:	89 c2                	mov    %eax,%edx
80106737:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010673a:	66 89 14 c5 60 5f 11 	mov    %dx,-0x7feea0a0(,%eax,8)
80106741:	80 
80106742:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106745:	66 c7 04 c5 62 5f 11 	movw   $0x8,-0x7feea09e(,%eax,8)
8010674c:	80 08 00 
8010674f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106752:	0f b6 14 c5 64 5f 11 	movzbl -0x7feea09c(,%eax,8),%edx
80106759:	80 
8010675a:	83 e2 e0             	and    $0xffffffe0,%edx
8010675d:	88 14 c5 64 5f 11 80 	mov    %dl,-0x7feea09c(,%eax,8)
80106764:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106767:	0f b6 14 c5 64 5f 11 	movzbl -0x7feea09c(,%eax,8),%edx
8010676e:	80 
8010676f:	83 e2 1f             	and    $0x1f,%edx
80106772:	88 14 c5 64 5f 11 80 	mov    %dl,-0x7feea09c(,%eax,8)
80106779:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010677c:	0f b6 14 c5 65 5f 11 	movzbl -0x7feea09b(,%eax,8),%edx
80106783:	80 
80106784:	83 e2 f0             	and    $0xfffffff0,%edx
80106787:	83 ca 0e             	or     $0xe,%edx
8010678a:	88 14 c5 65 5f 11 80 	mov    %dl,-0x7feea09b(,%eax,8)
80106791:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106794:	0f b6 14 c5 65 5f 11 	movzbl -0x7feea09b(,%eax,8),%edx
8010679b:	80 
8010679c:	83 e2 ef             	and    $0xffffffef,%edx
8010679f:	88 14 c5 65 5f 11 80 	mov    %dl,-0x7feea09b(,%eax,8)
801067a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067a9:	0f b6 14 c5 65 5f 11 	movzbl -0x7feea09b(,%eax,8),%edx
801067b0:	80 
801067b1:	83 e2 9f             	and    $0xffffff9f,%edx
801067b4:	88 14 c5 65 5f 11 80 	mov    %dl,-0x7feea09b(,%eax,8)
801067bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067be:	0f b6 14 c5 65 5f 11 	movzbl -0x7feea09b(,%eax,8),%edx
801067c5:	80 
801067c6:	83 ca 80             	or     $0xffffff80,%edx
801067c9:	88 14 c5 65 5f 11 80 	mov    %dl,-0x7feea09b(,%eax,8)
801067d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067d3:	8b 04 85 a4 b0 10 80 	mov    -0x7fef4f5c(,%eax,4),%eax
801067da:	c1 e8 10             	shr    $0x10,%eax
801067dd:	89 c2                	mov    %eax,%edx
801067df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067e2:	66 89 14 c5 66 5f 11 	mov    %dx,-0x7feea09a(,%eax,8)
801067e9:	80 
  for(i = 0; i < 256; i++)
801067ea:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801067ee:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
801067f5:	0f 8e 30 ff ff ff    	jle    8010672b <tvinit+0x12>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801067fb:	a1 a4 b1 10 80       	mov    0x8010b1a4,%eax
80106800:	66 a3 60 61 11 80    	mov    %ax,0x80116160
80106806:	66 c7 05 62 61 11 80 	movw   $0x8,0x80116162
8010680d:	08 00 
8010680f:	0f b6 05 64 61 11 80 	movzbl 0x80116164,%eax
80106816:	83 e0 e0             	and    $0xffffffe0,%eax
80106819:	a2 64 61 11 80       	mov    %al,0x80116164
8010681e:	0f b6 05 64 61 11 80 	movzbl 0x80116164,%eax
80106825:	83 e0 1f             	and    $0x1f,%eax
80106828:	a2 64 61 11 80       	mov    %al,0x80116164
8010682d:	0f b6 05 65 61 11 80 	movzbl 0x80116165,%eax
80106834:	83 c8 0f             	or     $0xf,%eax
80106837:	a2 65 61 11 80       	mov    %al,0x80116165
8010683c:	0f b6 05 65 61 11 80 	movzbl 0x80116165,%eax
80106843:	83 e0 ef             	and    $0xffffffef,%eax
80106846:	a2 65 61 11 80       	mov    %al,0x80116165
8010684b:	0f b6 05 65 61 11 80 	movzbl 0x80116165,%eax
80106852:	83 c8 60             	or     $0x60,%eax
80106855:	a2 65 61 11 80       	mov    %al,0x80116165
8010685a:	0f b6 05 65 61 11 80 	movzbl 0x80116165,%eax
80106861:	83 c8 80             	or     $0xffffff80,%eax
80106864:	a2 65 61 11 80       	mov    %al,0x80116165
80106869:	a1 a4 b1 10 80       	mov    0x8010b1a4,%eax
8010686e:	c1 e8 10             	shr    $0x10,%eax
80106871:	66 a3 66 61 11 80    	mov    %ax,0x80116166

  initlock(&tickslock, "time");
80106877:	c7 44 24 04 00 8a 10 	movl   $0x80108a00,0x4(%esp)
8010687e:	80 
8010687f:	c7 04 24 20 5f 11 80 	movl   $0x80115f20,(%esp)
80106886:	e8 a1 e7 ff ff       	call   8010502c <initlock>
}
8010688b:	c9                   	leave  
8010688c:	c3                   	ret    

8010688d <idtinit>:

void
idtinit(void)
{
8010688d:	55                   	push   %ebp
8010688e:	89 e5                	mov    %esp,%ebp
80106890:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
80106893:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
8010689a:	00 
8010689b:	c7 04 24 60 5f 11 80 	movl   $0x80115f60,(%esp)
801068a2:	e8 38 fe ff ff       	call   801066df <lidt>
}
801068a7:	c9                   	leave  
801068a8:	c3                   	ret    

801068a9 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801068a9:	55                   	push   %ebp
801068aa:	89 e5                	mov    %esp,%ebp
801068ac:	57                   	push   %edi
801068ad:	56                   	push   %esi
801068ae:	53                   	push   %ebx
801068af:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
801068b2:	8b 45 08             	mov    0x8(%ebp),%eax
801068b5:	8b 40 30             	mov    0x30(%eax),%eax
801068b8:	83 f8 40             	cmp    $0x40,%eax
801068bb:	75 3c                	jne    801068f9 <trap+0x50>
    if(myproc()->killed)
801068bd:	e8 9f d8 ff ff       	call   80104161 <myproc>
801068c2:	8b 40 24             	mov    0x24(%eax),%eax
801068c5:	85 c0                	test   %eax,%eax
801068c7:	74 05                	je     801068ce <trap+0x25>
      exit();
801068c9:	e8 42 dd ff ff       	call   80104610 <exit>
    myproc()->tf = tf;
801068ce:	e8 8e d8 ff ff       	call   80104161 <myproc>
801068d3:	8b 55 08             	mov    0x8(%ebp),%edx
801068d6:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
801068d9:	e8 f8 ed ff ff       	call   801056d6 <syscall>
    if(myproc()->killed)
801068de:	e8 7e d8 ff ff       	call   80104161 <myproc>
801068e3:	8b 40 24             	mov    0x24(%eax),%eax
801068e6:	85 c0                	test   %eax,%eax
801068e8:	74 0a                	je     801068f4 <trap+0x4b>
      exit();
801068ea:	e8 21 dd ff ff       	call   80104610 <exit>
    return;
801068ef:	e9 19 02 00 00       	jmp    80106b0d <trap+0x264>
801068f4:	e9 14 02 00 00       	jmp    80106b0d <trap+0x264>
  }

  switch(tf->trapno){
801068f9:	8b 45 08             	mov    0x8(%ebp),%eax
801068fc:	8b 40 30             	mov    0x30(%eax),%eax
801068ff:	83 e8 20             	sub    $0x20,%eax
80106902:	83 f8 1f             	cmp    $0x1f,%eax
80106905:	0f 87 b1 00 00 00    	ja     801069bc <trap+0x113>
8010690b:	8b 04 85 a8 8a 10 80 	mov    -0x7fef7558(,%eax,4),%eax
80106912:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80106914:	e8 b1 d7 ff ff       	call   801040ca <cpuid>
80106919:	85 c0                	test   %eax,%eax
8010691b:	75 31                	jne    8010694e <trap+0xa5>
      acquire(&tickslock);
8010691d:	c7 04 24 20 5f 11 80 	movl   $0x80115f20,(%esp)
80106924:	e8 24 e7 ff ff       	call   8010504d <acquire>
      ticks++;
80106929:	a1 60 67 11 80       	mov    0x80116760,%eax
8010692e:	83 c0 01             	add    $0x1,%eax
80106931:	a3 60 67 11 80       	mov    %eax,0x80116760
      wakeup(&ticks);
80106936:	c7 04 24 60 67 11 80 	movl   $0x80116760,(%esp)
8010693d:	e8 31 e2 ff ff       	call   80104b73 <wakeup>
      release(&tickslock);
80106942:	c7 04 24 20 5f 11 80 	movl   $0x80115f20,(%esp)
80106949:	e8 67 e7 ff ff       	call   801050b5 <release>
    }
    lapiceoi();
8010694e:	e8 fe c5 ff ff       	call   80102f51 <lapiceoi>
    break;
80106953:	e9 37 01 00 00       	jmp    80106a8f <trap+0x1e6>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106958:	e8 6b be ff ff       	call   801027c8 <ideintr>
    lapiceoi();
8010695d:	e8 ef c5 ff ff       	call   80102f51 <lapiceoi>
    break;
80106962:	e9 28 01 00 00       	jmp    80106a8f <trap+0x1e6>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106967:	e8 fa c3 ff ff       	call   80102d66 <kbdintr>
    lapiceoi();
8010696c:	e8 e0 c5 ff ff       	call   80102f51 <lapiceoi>
    break;
80106971:	e9 19 01 00 00       	jmp    80106a8f <trap+0x1e6>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106976:	e8 7b 03 00 00       	call   80106cf6 <uartintr>
    lapiceoi();
8010697b:	e8 d1 c5 ff ff       	call   80102f51 <lapiceoi>
    break;
80106980:	e9 0a 01 00 00       	jmp    80106a8f <trap+0x1e6>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106985:	8b 45 08             	mov    0x8(%ebp),%eax
80106988:	8b 70 38             	mov    0x38(%eax),%esi
            cpuid(), tf->cs, tf->eip);
8010698b:	8b 45 08             	mov    0x8(%ebp),%eax
8010698e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106992:	0f b7 d8             	movzwl %ax,%ebx
80106995:	e8 30 d7 ff ff       	call   801040ca <cpuid>
8010699a:	89 74 24 0c          	mov    %esi,0xc(%esp)
8010699e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
801069a2:	89 44 24 04          	mov    %eax,0x4(%esp)
801069a6:	c7 04 24 08 8a 10 80 	movl   $0x80108a08,(%esp)
801069ad:	e8 16 9a ff ff       	call   801003c8 <cprintf>
    lapiceoi();
801069b2:	e8 9a c5 ff ff       	call   80102f51 <lapiceoi>
    break;
801069b7:	e9 d3 00 00 00       	jmp    80106a8f <trap+0x1e6>

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801069bc:	e8 a0 d7 ff ff       	call   80104161 <myproc>
801069c1:	85 c0                	test   %eax,%eax
801069c3:	74 11                	je     801069d6 <trap+0x12d>
801069c5:	8b 45 08             	mov    0x8(%ebp),%eax
801069c8:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801069cc:	0f b7 c0             	movzwl %ax,%eax
801069cf:	83 e0 03             	and    $0x3,%eax
801069d2:	85 c0                	test   %eax,%eax
801069d4:	75 40                	jne    80106a16 <trap+0x16d>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801069d6:	e8 2d fd ff ff       	call   80106708 <rcr2>
801069db:	89 c3                	mov    %eax,%ebx
801069dd:	8b 45 08             	mov    0x8(%ebp),%eax
801069e0:	8b 70 38             	mov    0x38(%eax),%esi
801069e3:	e8 e2 d6 ff ff       	call   801040ca <cpuid>
801069e8:	8b 55 08             	mov    0x8(%ebp),%edx
801069eb:	8b 52 30             	mov    0x30(%edx),%edx
801069ee:	89 5c 24 10          	mov    %ebx,0x10(%esp)
801069f2:	89 74 24 0c          	mov    %esi,0xc(%esp)
801069f6:	89 44 24 08          	mov    %eax,0x8(%esp)
801069fa:	89 54 24 04          	mov    %edx,0x4(%esp)
801069fe:	c7 04 24 2c 8a 10 80 	movl   $0x80108a2c,(%esp)
80106a05:	e8 be 99 ff ff       	call   801003c8 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
80106a0a:	c7 04 24 5e 8a 10 80 	movl   $0x80108a5e,(%esp)
80106a11:	e8 4c 9b ff ff       	call   80100562 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106a16:	e8 ed fc ff ff       	call   80106708 <rcr2>
80106a1b:	89 c6                	mov    %eax,%esi
80106a1d:	8b 45 08             	mov    0x8(%ebp),%eax
80106a20:	8b 40 38             	mov    0x38(%eax),%eax
80106a23:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106a26:	e8 9f d6 ff ff       	call   801040ca <cpuid>
80106a2b:	89 c3                	mov    %eax,%ebx
80106a2d:	8b 45 08             	mov    0x8(%ebp),%eax
80106a30:	8b 78 34             	mov    0x34(%eax),%edi
80106a33:	89 7d e0             	mov    %edi,-0x20(%ebp)
80106a36:	8b 45 08             	mov    0x8(%ebp),%eax
80106a39:	8b 78 30             	mov    0x30(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106a3c:	e8 20 d7 ff ff       	call   80104161 <myproc>
80106a41:	8d 50 6c             	lea    0x6c(%eax),%edx
80106a44:	89 55 dc             	mov    %edx,-0x24(%ebp)
80106a47:	e8 15 d7 ff ff       	call   80104161 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106a4c:	8b 40 10             	mov    0x10(%eax),%eax
80106a4f:	89 74 24 1c          	mov    %esi,0x1c(%esp)
80106a53:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106a56:	89 4c 24 18          	mov    %ecx,0x18(%esp)
80106a5a:	89 5c 24 14          	mov    %ebx,0x14(%esp)
80106a5e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80106a61:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80106a65:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80106a69:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106a6c:	89 54 24 08          	mov    %edx,0x8(%esp)
80106a70:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a74:	c7 04 24 64 8a 10 80 	movl   $0x80108a64,(%esp)
80106a7b:	e8 48 99 ff ff       	call   801003c8 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80106a80:	e8 dc d6 ff ff       	call   80104161 <myproc>
80106a85:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106a8c:	eb 01                	jmp    80106a8f <trap+0x1e6>
    break;
80106a8e:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106a8f:	e8 cd d6 ff ff       	call   80104161 <myproc>
80106a94:	85 c0                	test   %eax,%eax
80106a96:	74 23                	je     80106abb <trap+0x212>
80106a98:	e8 c4 d6 ff ff       	call   80104161 <myproc>
80106a9d:	8b 40 24             	mov    0x24(%eax),%eax
80106aa0:	85 c0                	test   %eax,%eax
80106aa2:	74 17                	je     80106abb <trap+0x212>
80106aa4:	8b 45 08             	mov    0x8(%ebp),%eax
80106aa7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106aab:	0f b7 c0             	movzwl %ax,%eax
80106aae:	83 e0 03             	and    $0x3,%eax
80106ab1:	83 f8 03             	cmp    $0x3,%eax
80106ab4:	75 05                	jne    80106abb <trap+0x212>
    exit();
80106ab6:	e8 55 db ff ff       	call   80104610 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106abb:	e8 a1 d6 ff ff       	call   80104161 <myproc>
80106ac0:	85 c0                	test   %eax,%eax
80106ac2:	74 1d                	je     80106ae1 <trap+0x238>
80106ac4:	e8 98 d6 ff ff       	call   80104161 <myproc>
80106ac9:	8b 40 0c             	mov    0xc(%eax),%eax
80106acc:	83 f8 04             	cmp    $0x4,%eax
80106acf:	75 10                	jne    80106ae1 <trap+0x238>
     tf->trapno == T_IRQ0+IRQ_TIMER)
80106ad1:	8b 45 08             	mov    0x8(%ebp),%eax
80106ad4:	8b 40 30             	mov    0x30(%eax),%eax
  if(myproc() && myproc()->state == RUNNING &&
80106ad7:	83 f8 20             	cmp    $0x20,%eax
80106ada:	75 05                	jne    80106ae1 <trap+0x238>
    yield();
80106adc:	e8 4b df ff ff       	call   80104a2c <yield>

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106ae1:	e8 7b d6 ff ff       	call   80104161 <myproc>
80106ae6:	85 c0                	test   %eax,%eax
80106ae8:	74 23                	je     80106b0d <trap+0x264>
80106aea:	e8 72 d6 ff ff       	call   80104161 <myproc>
80106aef:	8b 40 24             	mov    0x24(%eax),%eax
80106af2:	85 c0                	test   %eax,%eax
80106af4:	74 17                	je     80106b0d <trap+0x264>
80106af6:	8b 45 08             	mov    0x8(%ebp),%eax
80106af9:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106afd:	0f b7 c0             	movzwl %ax,%eax
80106b00:	83 e0 03             	and    $0x3,%eax
80106b03:	83 f8 03             	cmp    $0x3,%eax
80106b06:	75 05                	jne    80106b0d <trap+0x264>
    exit();
80106b08:	e8 03 db ff ff       	call   80104610 <exit>
}
80106b0d:	83 c4 3c             	add    $0x3c,%esp
80106b10:	5b                   	pop    %ebx
80106b11:	5e                   	pop    %esi
80106b12:	5f                   	pop    %edi
80106b13:	5d                   	pop    %ebp
80106b14:	c3                   	ret    

80106b15 <inb>:
{
80106b15:	55                   	push   %ebp
80106b16:	89 e5                	mov    %esp,%ebp
80106b18:	83 ec 14             	sub    $0x14,%esp
80106b1b:	8b 45 08             	mov    0x8(%ebp),%eax
80106b1e:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106b22:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80106b26:	89 c2                	mov    %eax,%edx
80106b28:	ec                   	in     (%dx),%al
80106b29:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80106b2c:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80106b30:	c9                   	leave  
80106b31:	c3                   	ret    

80106b32 <outb>:
{
80106b32:	55                   	push   %ebp
80106b33:	89 e5                	mov    %esp,%ebp
80106b35:	83 ec 08             	sub    $0x8,%esp
80106b38:	8b 55 08             	mov    0x8(%ebp),%edx
80106b3b:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b3e:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106b42:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106b45:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106b49:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106b4d:	ee                   	out    %al,(%dx)
}
80106b4e:	c9                   	leave  
80106b4f:	c3                   	ret    

80106b50 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106b50:	55                   	push   %ebp
80106b51:	89 e5                	mov    %esp,%ebp
80106b53:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80106b56:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106b5d:	00 
80106b5e:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106b65:	e8 c8 ff ff ff       	call   80106b32 <outb>

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106b6a:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
80106b71:	00 
80106b72:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106b79:	e8 b4 ff ff ff       	call   80106b32 <outb>
  outb(COM1+0, 115200/9600);
80106b7e:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
80106b85:	00 
80106b86:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106b8d:	e8 a0 ff ff ff       	call   80106b32 <outb>
  outb(COM1+1, 0);
80106b92:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106b99:	00 
80106b9a:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106ba1:	e8 8c ff ff ff       	call   80106b32 <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106ba6:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80106bad:	00 
80106bae:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106bb5:	e8 78 ff ff ff       	call   80106b32 <outb>
  outb(COM1+4, 0);
80106bba:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106bc1:	00 
80106bc2:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
80106bc9:	e8 64 ff ff ff       	call   80106b32 <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106bce:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80106bd5:	00 
80106bd6:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106bdd:	e8 50 ff ff ff       	call   80106b32 <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106be2:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106be9:	e8 27 ff ff ff       	call   80106b15 <inb>
80106bee:	3c ff                	cmp    $0xff,%al
80106bf0:	75 02                	jne    80106bf4 <uartinit+0xa4>
    return;
80106bf2:	eb 5e                	jmp    80106c52 <uartinit+0x102>
  uart = 1;
80106bf4:	c7 05 64 b6 10 80 01 	movl   $0x1,0x8010b664
80106bfb:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106bfe:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106c05:	e8 0b ff ff ff       	call   80106b15 <inb>
  inb(COM1+0);
80106c0a:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106c11:	e8 ff fe ff ff       	call   80106b15 <inb>
  ioapicenable(IRQ_COM1, 0);
80106c16:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106c1d:	00 
80106c1e:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80106c25:	e8 15 be ff ff       	call   80102a3f <ioapicenable>

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106c2a:	c7 45 f4 28 8b 10 80 	movl   $0x80108b28,-0xc(%ebp)
80106c31:	eb 15                	jmp    80106c48 <uartinit+0xf8>
    uartputc(*p);
80106c33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c36:	0f b6 00             	movzbl (%eax),%eax
80106c39:	0f be c0             	movsbl %al,%eax
80106c3c:	89 04 24             	mov    %eax,(%esp)
80106c3f:	e8 10 00 00 00       	call   80106c54 <uartputc>
  for(p="xv6...\n"; *p; p++)
80106c44:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c4b:	0f b6 00             	movzbl (%eax),%eax
80106c4e:	84 c0                	test   %al,%al
80106c50:	75 e1                	jne    80106c33 <uartinit+0xe3>
}
80106c52:	c9                   	leave  
80106c53:	c3                   	ret    

80106c54 <uartputc>:

void
uartputc(int c)
{
80106c54:	55                   	push   %ebp
80106c55:	89 e5                	mov    %esp,%ebp
80106c57:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
80106c5a:	a1 64 b6 10 80       	mov    0x8010b664,%eax
80106c5f:	85 c0                	test   %eax,%eax
80106c61:	75 02                	jne    80106c65 <uartputc+0x11>
    return;
80106c63:	eb 4b                	jmp    80106cb0 <uartputc+0x5c>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106c65:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106c6c:	eb 10                	jmp    80106c7e <uartputc+0x2a>
    microdelay(10);
80106c6e:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80106c75:	e8 fc c2 ff ff       	call   80102f76 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106c7a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106c7e:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106c82:	7f 16                	jg     80106c9a <uartputc+0x46>
80106c84:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106c8b:	e8 85 fe ff ff       	call   80106b15 <inb>
80106c90:	0f b6 c0             	movzbl %al,%eax
80106c93:	83 e0 20             	and    $0x20,%eax
80106c96:	85 c0                	test   %eax,%eax
80106c98:	74 d4                	je     80106c6e <uartputc+0x1a>
  outb(COM1+0, c);
80106c9a:	8b 45 08             	mov    0x8(%ebp),%eax
80106c9d:	0f b6 c0             	movzbl %al,%eax
80106ca0:	89 44 24 04          	mov    %eax,0x4(%esp)
80106ca4:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106cab:	e8 82 fe ff ff       	call   80106b32 <outb>
}
80106cb0:	c9                   	leave  
80106cb1:	c3                   	ret    

80106cb2 <uartgetc>:

static int
uartgetc(void)
{
80106cb2:	55                   	push   %ebp
80106cb3:	89 e5                	mov    %esp,%ebp
80106cb5:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
80106cb8:	a1 64 b6 10 80       	mov    0x8010b664,%eax
80106cbd:	85 c0                	test   %eax,%eax
80106cbf:	75 07                	jne    80106cc8 <uartgetc+0x16>
    return -1;
80106cc1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106cc6:	eb 2c                	jmp    80106cf4 <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
80106cc8:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106ccf:	e8 41 fe ff ff       	call   80106b15 <inb>
80106cd4:	0f b6 c0             	movzbl %al,%eax
80106cd7:	83 e0 01             	and    $0x1,%eax
80106cda:	85 c0                	test   %eax,%eax
80106cdc:	75 07                	jne    80106ce5 <uartgetc+0x33>
    return -1;
80106cde:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ce3:	eb 0f                	jmp    80106cf4 <uartgetc+0x42>
  return inb(COM1+0);
80106ce5:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106cec:	e8 24 fe ff ff       	call   80106b15 <inb>
80106cf1:	0f b6 c0             	movzbl %al,%eax
}
80106cf4:	c9                   	leave  
80106cf5:	c3                   	ret    

80106cf6 <uartintr>:

void
uartintr(void)
{
80106cf6:	55                   	push   %ebp
80106cf7:	89 e5                	mov    %esp,%ebp
80106cf9:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80106cfc:	c7 04 24 b2 6c 10 80 	movl   $0x80106cb2,(%esp)
80106d03:	e8 e1 9a ff ff       	call   801007e9 <consoleintr>
}
80106d08:	c9                   	leave  
80106d09:	c3                   	ret    

80106d0a <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106d0a:	6a 00                	push   $0x0
  pushl $0
80106d0c:	6a 00                	push   $0x0
  jmp alltraps
80106d0e:	e9 a9 f9 ff ff       	jmp    801066bc <alltraps>

80106d13 <vector1>:
.globl vector1
vector1:
  pushl $0
80106d13:	6a 00                	push   $0x0
  pushl $1
80106d15:	6a 01                	push   $0x1
  jmp alltraps
80106d17:	e9 a0 f9 ff ff       	jmp    801066bc <alltraps>

80106d1c <vector2>:
.globl vector2
vector2:
  pushl $0
80106d1c:	6a 00                	push   $0x0
  pushl $2
80106d1e:	6a 02                	push   $0x2
  jmp alltraps
80106d20:	e9 97 f9 ff ff       	jmp    801066bc <alltraps>

80106d25 <vector3>:
.globl vector3
vector3:
  pushl $0
80106d25:	6a 00                	push   $0x0
  pushl $3
80106d27:	6a 03                	push   $0x3
  jmp alltraps
80106d29:	e9 8e f9 ff ff       	jmp    801066bc <alltraps>

80106d2e <vector4>:
.globl vector4
vector4:
  pushl $0
80106d2e:	6a 00                	push   $0x0
  pushl $4
80106d30:	6a 04                	push   $0x4
  jmp alltraps
80106d32:	e9 85 f9 ff ff       	jmp    801066bc <alltraps>

80106d37 <vector5>:
.globl vector5
vector5:
  pushl $0
80106d37:	6a 00                	push   $0x0
  pushl $5
80106d39:	6a 05                	push   $0x5
  jmp alltraps
80106d3b:	e9 7c f9 ff ff       	jmp    801066bc <alltraps>

80106d40 <vector6>:
.globl vector6
vector6:
  pushl $0
80106d40:	6a 00                	push   $0x0
  pushl $6
80106d42:	6a 06                	push   $0x6
  jmp alltraps
80106d44:	e9 73 f9 ff ff       	jmp    801066bc <alltraps>

80106d49 <vector7>:
.globl vector7
vector7:
  pushl $0
80106d49:	6a 00                	push   $0x0
  pushl $7
80106d4b:	6a 07                	push   $0x7
  jmp alltraps
80106d4d:	e9 6a f9 ff ff       	jmp    801066bc <alltraps>

80106d52 <vector8>:
.globl vector8
vector8:
  pushl $8
80106d52:	6a 08                	push   $0x8
  jmp alltraps
80106d54:	e9 63 f9 ff ff       	jmp    801066bc <alltraps>

80106d59 <vector9>:
.globl vector9
vector9:
  pushl $0
80106d59:	6a 00                	push   $0x0
  pushl $9
80106d5b:	6a 09                	push   $0x9
  jmp alltraps
80106d5d:	e9 5a f9 ff ff       	jmp    801066bc <alltraps>

80106d62 <vector10>:
.globl vector10
vector10:
  pushl $10
80106d62:	6a 0a                	push   $0xa
  jmp alltraps
80106d64:	e9 53 f9 ff ff       	jmp    801066bc <alltraps>

80106d69 <vector11>:
.globl vector11
vector11:
  pushl $11
80106d69:	6a 0b                	push   $0xb
  jmp alltraps
80106d6b:	e9 4c f9 ff ff       	jmp    801066bc <alltraps>

80106d70 <vector12>:
.globl vector12
vector12:
  pushl $12
80106d70:	6a 0c                	push   $0xc
  jmp alltraps
80106d72:	e9 45 f9 ff ff       	jmp    801066bc <alltraps>

80106d77 <vector13>:
.globl vector13
vector13:
  pushl $13
80106d77:	6a 0d                	push   $0xd
  jmp alltraps
80106d79:	e9 3e f9 ff ff       	jmp    801066bc <alltraps>

80106d7e <vector14>:
.globl vector14
vector14:
  pushl $14
80106d7e:	6a 0e                	push   $0xe
  jmp alltraps
80106d80:	e9 37 f9 ff ff       	jmp    801066bc <alltraps>

80106d85 <vector15>:
.globl vector15
vector15:
  pushl $0
80106d85:	6a 00                	push   $0x0
  pushl $15
80106d87:	6a 0f                	push   $0xf
  jmp alltraps
80106d89:	e9 2e f9 ff ff       	jmp    801066bc <alltraps>

80106d8e <vector16>:
.globl vector16
vector16:
  pushl $0
80106d8e:	6a 00                	push   $0x0
  pushl $16
80106d90:	6a 10                	push   $0x10
  jmp alltraps
80106d92:	e9 25 f9 ff ff       	jmp    801066bc <alltraps>

80106d97 <vector17>:
.globl vector17
vector17:
  pushl $17
80106d97:	6a 11                	push   $0x11
  jmp alltraps
80106d99:	e9 1e f9 ff ff       	jmp    801066bc <alltraps>

80106d9e <vector18>:
.globl vector18
vector18:
  pushl $0
80106d9e:	6a 00                	push   $0x0
  pushl $18
80106da0:	6a 12                	push   $0x12
  jmp alltraps
80106da2:	e9 15 f9 ff ff       	jmp    801066bc <alltraps>

80106da7 <vector19>:
.globl vector19
vector19:
  pushl $0
80106da7:	6a 00                	push   $0x0
  pushl $19
80106da9:	6a 13                	push   $0x13
  jmp alltraps
80106dab:	e9 0c f9 ff ff       	jmp    801066bc <alltraps>

80106db0 <vector20>:
.globl vector20
vector20:
  pushl $0
80106db0:	6a 00                	push   $0x0
  pushl $20
80106db2:	6a 14                	push   $0x14
  jmp alltraps
80106db4:	e9 03 f9 ff ff       	jmp    801066bc <alltraps>

80106db9 <vector21>:
.globl vector21
vector21:
  pushl $0
80106db9:	6a 00                	push   $0x0
  pushl $21
80106dbb:	6a 15                	push   $0x15
  jmp alltraps
80106dbd:	e9 fa f8 ff ff       	jmp    801066bc <alltraps>

80106dc2 <vector22>:
.globl vector22
vector22:
  pushl $0
80106dc2:	6a 00                	push   $0x0
  pushl $22
80106dc4:	6a 16                	push   $0x16
  jmp alltraps
80106dc6:	e9 f1 f8 ff ff       	jmp    801066bc <alltraps>

80106dcb <vector23>:
.globl vector23
vector23:
  pushl $0
80106dcb:	6a 00                	push   $0x0
  pushl $23
80106dcd:	6a 17                	push   $0x17
  jmp alltraps
80106dcf:	e9 e8 f8 ff ff       	jmp    801066bc <alltraps>

80106dd4 <vector24>:
.globl vector24
vector24:
  pushl $0
80106dd4:	6a 00                	push   $0x0
  pushl $24
80106dd6:	6a 18                	push   $0x18
  jmp alltraps
80106dd8:	e9 df f8 ff ff       	jmp    801066bc <alltraps>

80106ddd <vector25>:
.globl vector25
vector25:
  pushl $0
80106ddd:	6a 00                	push   $0x0
  pushl $25
80106ddf:	6a 19                	push   $0x19
  jmp alltraps
80106de1:	e9 d6 f8 ff ff       	jmp    801066bc <alltraps>

80106de6 <vector26>:
.globl vector26
vector26:
  pushl $0
80106de6:	6a 00                	push   $0x0
  pushl $26
80106de8:	6a 1a                	push   $0x1a
  jmp alltraps
80106dea:	e9 cd f8 ff ff       	jmp    801066bc <alltraps>

80106def <vector27>:
.globl vector27
vector27:
  pushl $0
80106def:	6a 00                	push   $0x0
  pushl $27
80106df1:	6a 1b                	push   $0x1b
  jmp alltraps
80106df3:	e9 c4 f8 ff ff       	jmp    801066bc <alltraps>

80106df8 <vector28>:
.globl vector28
vector28:
  pushl $0
80106df8:	6a 00                	push   $0x0
  pushl $28
80106dfa:	6a 1c                	push   $0x1c
  jmp alltraps
80106dfc:	e9 bb f8 ff ff       	jmp    801066bc <alltraps>

80106e01 <vector29>:
.globl vector29
vector29:
  pushl $0
80106e01:	6a 00                	push   $0x0
  pushl $29
80106e03:	6a 1d                	push   $0x1d
  jmp alltraps
80106e05:	e9 b2 f8 ff ff       	jmp    801066bc <alltraps>

80106e0a <vector30>:
.globl vector30
vector30:
  pushl $0
80106e0a:	6a 00                	push   $0x0
  pushl $30
80106e0c:	6a 1e                	push   $0x1e
  jmp alltraps
80106e0e:	e9 a9 f8 ff ff       	jmp    801066bc <alltraps>

80106e13 <vector31>:
.globl vector31
vector31:
  pushl $0
80106e13:	6a 00                	push   $0x0
  pushl $31
80106e15:	6a 1f                	push   $0x1f
  jmp alltraps
80106e17:	e9 a0 f8 ff ff       	jmp    801066bc <alltraps>

80106e1c <vector32>:
.globl vector32
vector32:
  pushl $0
80106e1c:	6a 00                	push   $0x0
  pushl $32
80106e1e:	6a 20                	push   $0x20
  jmp alltraps
80106e20:	e9 97 f8 ff ff       	jmp    801066bc <alltraps>

80106e25 <vector33>:
.globl vector33
vector33:
  pushl $0
80106e25:	6a 00                	push   $0x0
  pushl $33
80106e27:	6a 21                	push   $0x21
  jmp alltraps
80106e29:	e9 8e f8 ff ff       	jmp    801066bc <alltraps>

80106e2e <vector34>:
.globl vector34
vector34:
  pushl $0
80106e2e:	6a 00                	push   $0x0
  pushl $34
80106e30:	6a 22                	push   $0x22
  jmp alltraps
80106e32:	e9 85 f8 ff ff       	jmp    801066bc <alltraps>

80106e37 <vector35>:
.globl vector35
vector35:
  pushl $0
80106e37:	6a 00                	push   $0x0
  pushl $35
80106e39:	6a 23                	push   $0x23
  jmp alltraps
80106e3b:	e9 7c f8 ff ff       	jmp    801066bc <alltraps>

80106e40 <vector36>:
.globl vector36
vector36:
  pushl $0
80106e40:	6a 00                	push   $0x0
  pushl $36
80106e42:	6a 24                	push   $0x24
  jmp alltraps
80106e44:	e9 73 f8 ff ff       	jmp    801066bc <alltraps>

80106e49 <vector37>:
.globl vector37
vector37:
  pushl $0
80106e49:	6a 00                	push   $0x0
  pushl $37
80106e4b:	6a 25                	push   $0x25
  jmp alltraps
80106e4d:	e9 6a f8 ff ff       	jmp    801066bc <alltraps>

80106e52 <vector38>:
.globl vector38
vector38:
  pushl $0
80106e52:	6a 00                	push   $0x0
  pushl $38
80106e54:	6a 26                	push   $0x26
  jmp alltraps
80106e56:	e9 61 f8 ff ff       	jmp    801066bc <alltraps>

80106e5b <vector39>:
.globl vector39
vector39:
  pushl $0
80106e5b:	6a 00                	push   $0x0
  pushl $39
80106e5d:	6a 27                	push   $0x27
  jmp alltraps
80106e5f:	e9 58 f8 ff ff       	jmp    801066bc <alltraps>

80106e64 <vector40>:
.globl vector40
vector40:
  pushl $0
80106e64:	6a 00                	push   $0x0
  pushl $40
80106e66:	6a 28                	push   $0x28
  jmp alltraps
80106e68:	e9 4f f8 ff ff       	jmp    801066bc <alltraps>

80106e6d <vector41>:
.globl vector41
vector41:
  pushl $0
80106e6d:	6a 00                	push   $0x0
  pushl $41
80106e6f:	6a 29                	push   $0x29
  jmp alltraps
80106e71:	e9 46 f8 ff ff       	jmp    801066bc <alltraps>

80106e76 <vector42>:
.globl vector42
vector42:
  pushl $0
80106e76:	6a 00                	push   $0x0
  pushl $42
80106e78:	6a 2a                	push   $0x2a
  jmp alltraps
80106e7a:	e9 3d f8 ff ff       	jmp    801066bc <alltraps>

80106e7f <vector43>:
.globl vector43
vector43:
  pushl $0
80106e7f:	6a 00                	push   $0x0
  pushl $43
80106e81:	6a 2b                	push   $0x2b
  jmp alltraps
80106e83:	e9 34 f8 ff ff       	jmp    801066bc <alltraps>

80106e88 <vector44>:
.globl vector44
vector44:
  pushl $0
80106e88:	6a 00                	push   $0x0
  pushl $44
80106e8a:	6a 2c                	push   $0x2c
  jmp alltraps
80106e8c:	e9 2b f8 ff ff       	jmp    801066bc <alltraps>

80106e91 <vector45>:
.globl vector45
vector45:
  pushl $0
80106e91:	6a 00                	push   $0x0
  pushl $45
80106e93:	6a 2d                	push   $0x2d
  jmp alltraps
80106e95:	e9 22 f8 ff ff       	jmp    801066bc <alltraps>

80106e9a <vector46>:
.globl vector46
vector46:
  pushl $0
80106e9a:	6a 00                	push   $0x0
  pushl $46
80106e9c:	6a 2e                	push   $0x2e
  jmp alltraps
80106e9e:	e9 19 f8 ff ff       	jmp    801066bc <alltraps>

80106ea3 <vector47>:
.globl vector47
vector47:
  pushl $0
80106ea3:	6a 00                	push   $0x0
  pushl $47
80106ea5:	6a 2f                	push   $0x2f
  jmp alltraps
80106ea7:	e9 10 f8 ff ff       	jmp    801066bc <alltraps>

80106eac <vector48>:
.globl vector48
vector48:
  pushl $0
80106eac:	6a 00                	push   $0x0
  pushl $48
80106eae:	6a 30                	push   $0x30
  jmp alltraps
80106eb0:	e9 07 f8 ff ff       	jmp    801066bc <alltraps>

80106eb5 <vector49>:
.globl vector49
vector49:
  pushl $0
80106eb5:	6a 00                	push   $0x0
  pushl $49
80106eb7:	6a 31                	push   $0x31
  jmp alltraps
80106eb9:	e9 fe f7 ff ff       	jmp    801066bc <alltraps>

80106ebe <vector50>:
.globl vector50
vector50:
  pushl $0
80106ebe:	6a 00                	push   $0x0
  pushl $50
80106ec0:	6a 32                	push   $0x32
  jmp alltraps
80106ec2:	e9 f5 f7 ff ff       	jmp    801066bc <alltraps>

80106ec7 <vector51>:
.globl vector51
vector51:
  pushl $0
80106ec7:	6a 00                	push   $0x0
  pushl $51
80106ec9:	6a 33                	push   $0x33
  jmp alltraps
80106ecb:	e9 ec f7 ff ff       	jmp    801066bc <alltraps>

80106ed0 <vector52>:
.globl vector52
vector52:
  pushl $0
80106ed0:	6a 00                	push   $0x0
  pushl $52
80106ed2:	6a 34                	push   $0x34
  jmp alltraps
80106ed4:	e9 e3 f7 ff ff       	jmp    801066bc <alltraps>

80106ed9 <vector53>:
.globl vector53
vector53:
  pushl $0
80106ed9:	6a 00                	push   $0x0
  pushl $53
80106edb:	6a 35                	push   $0x35
  jmp alltraps
80106edd:	e9 da f7 ff ff       	jmp    801066bc <alltraps>

80106ee2 <vector54>:
.globl vector54
vector54:
  pushl $0
80106ee2:	6a 00                	push   $0x0
  pushl $54
80106ee4:	6a 36                	push   $0x36
  jmp alltraps
80106ee6:	e9 d1 f7 ff ff       	jmp    801066bc <alltraps>

80106eeb <vector55>:
.globl vector55
vector55:
  pushl $0
80106eeb:	6a 00                	push   $0x0
  pushl $55
80106eed:	6a 37                	push   $0x37
  jmp alltraps
80106eef:	e9 c8 f7 ff ff       	jmp    801066bc <alltraps>

80106ef4 <vector56>:
.globl vector56
vector56:
  pushl $0
80106ef4:	6a 00                	push   $0x0
  pushl $56
80106ef6:	6a 38                	push   $0x38
  jmp alltraps
80106ef8:	e9 bf f7 ff ff       	jmp    801066bc <alltraps>

80106efd <vector57>:
.globl vector57
vector57:
  pushl $0
80106efd:	6a 00                	push   $0x0
  pushl $57
80106eff:	6a 39                	push   $0x39
  jmp alltraps
80106f01:	e9 b6 f7 ff ff       	jmp    801066bc <alltraps>

80106f06 <vector58>:
.globl vector58
vector58:
  pushl $0
80106f06:	6a 00                	push   $0x0
  pushl $58
80106f08:	6a 3a                	push   $0x3a
  jmp alltraps
80106f0a:	e9 ad f7 ff ff       	jmp    801066bc <alltraps>

80106f0f <vector59>:
.globl vector59
vector59:
  pushl $0
80106f0f:	6a 00                	push   $0x0
  pushl $59
80106f11:	6a 3b                	push   $0x3b
  jmp alltraps
80106f13:	e9 a4 f7 ff ff       	jmp    801066bc <alltraps>

80106f18 <vector60>:
.globl vector60
vector60:
  pushl $0
80106f18:	6a 00                	push   $0x0
  pushl $60
80106f1a:	6a 3c                	push   $0x3c
  jmp alltraps
80106f1c:	e9 9b f7 ff ff       	jmp    801066bc <alltraps>

80106f21 <vector61>:
.globl vector61
vector61:
  pushl $0
80106f21:	6a 00                	push   $0x0
  pushl $61
80106f23:	6a 3d                	push   $0x3d
  jmp alltraps
80106f25:	e9 92 f7 ff ff       	jmp    801066bc <alltraps>

80106f2a <vector62>:
.globl vector62
vector62:
  pushl $0
80106f2a:	6a 00                	push   $0x0
  pushl $62
80106f2c:	6a 3e                	push   $0x3e
  jmp alltraps
80106f2e:	e9 89 f7 ff ff       	jmp    801066bc <alltraps>

80106f33 <vector63>:
.globl vector63
vector63:
  pushl $0
80106f33:	6a 00                	push   $0x0
  pushl $63
80106f35:	6a 3f                	push   $0x3f
  jmp alltraps
80106f37:	e9 80 f7 ff ff       	jmp    801066bc <alltraps>

80106f3c <vector64>:
.globl vector64
vector64:
  pushl $0
80106f3c:	6a 00                	push   $0x0
  pushl $64
80106f3e:	6a 40                	push   $0x40
  jmp alltraps
80106f40:	e9 77 f7 ff ff       	jmp    801066bc <alltraps>

80106f45 <vector65>:
.globl vector65
vector65:
  pushl $0
80106f45:	6a 00                	push   $0x0
  pushl $65
80106f47:	6a 41                	push   $0x41
  jmp alltraps
80106f49:	e9 6e f7 ff ff       	jmp    801066bc <alltraps>

80106f4e <vector66>:
.globl vector66
vector66:
  pushl $0
80106f4e:	6a 00                	push   $0x0
  pushl $66
80106f50:	6a 42                	push   $0x42
  jmp alltraps
80106f52:	e9 65 f7 ff ff       	jmp    801066bc <alltraps>

80106f57 <vector67>:
.globl vector67
vector67:
  pushl $0
80106f57:	6a 00                	push   $0x0
  pushl $67
80106f59:	6a 43                	push   $0x43
  jmp alltraps
80106f5b:	e9 5c f7 ff ff       	jmp    801066bc <alltraps>

80106f60 <vector68>:
.globl vector68
vector68:
  pushl $0
80106f60:	6a 00                	push   $0x0
  pushl $68
80106f62:	6a 44                	push   $0x44
  jmp alltraps
80106f64:	e9 53 f7 ff ff       	jmp    801066bc <alltraps>

80106f69 <vector69>:
.globl vector69
vector69:
  pushl $0
80106f69:	6a 00                	push   $0x0
  pushl $69
80106f6b:	6a 45                	push   $0x45
  jmp alltraps
80106f6d:	e9 4a f7 ff ff       	jmp    801066bc <alltraps>

80106f72 <vector70>:
.globl vector70
vector70:
  pushl $0
80106f72:	6a 00                	push   $0x0
  pushl $70
80106f74:	6a 46                	push   $0x46
  jmp alltraps
80106f76:	e9 41 f7 ff ff       	jmp    801066bc <alltraps>

80106f7b <vector71>:
.globl vector71
vector71:
  pushl $0
80106f7b:	6a 00                	push   $0x0
  pushl $71
80106f7d:	6a 47                	push   $0x47
  jmp alltraps
80106f7f:	e9 38 f7 ff ff       	jmp    801066bc <alltraps>

80106f84 <vector72>:
.globl vector72
vector72:
  pushl $0
80106f84:	6a 00                	push   $0x0
  pushl $72
80106f86:	6a 48                	push   $0x48
  jmp alltraps
80106f88:	e9 2f f7 ff ff       	jmp    801066bc <alltraps>

80106f8d <vector73>:
.globl vector73
vector73:
  pushl $0
80106f8d:	6a 00                	push   $0x0
  pushl $73
80106f8f:	6a 49                	push   $0x49
  jmp alltraps
80106f91:	e9 26 f7 ff ff       	jmp    801066bc <alltraps>

80106f96 <vector74>:
.globl vector74
vector74:
  pushl $0
80106f96:	6a 00                	push   $0x0
  pushl $74
80106f98:	6a 4a                	push   $0x4a
  jmp alltraps
80106f9a:	e9 1d f7 ff ff       	jmp    801066bc <alltraps>

80106f9f <vector75>:
.globl vector75
vector75:
  pushl $0
80106f9f:	6a 00                	push   $0x0
  pushl $75
80106fa1:	6a 4b                	push   $0x4b
  jmp alltraps
80106fa3:	e9 14 f7 ff ff       	jmp    801066bc <alltraps>

80106fa8 <vector76>:
.globl vector76
vector76:
  pushl $0
80106fa8:	6a 00                	push   $0x0
  pushl $76
80106faa:	6a 4c                	push   $0x4c
  jmp alltraps
80106fac:	e9 0b f7 ff ff       	jmp    801066bc <alltraps>

80106fb1 <vector77>:
.globl vector77
vector77:
  pushl $0
80106fb1:	6a 00                	push   $0x0
  pushl $77
80106fb3:	6a 4d                	push   $0x4d
  jmp alltraps
80106fb5:	e9 02 f7 ff ff       	jmp    801066bc <alltraps>

80106fba <vector78>:
.globl vector78
vector78:
  pushl $0
80106fba:	6a 00                	push   $0x0
  pushl $78
80106fbc:	6a 4e                	push   $0x4e
  jmp alltraps
80106fbe:	e9 f9 f6 ff ff       	jmp    801066bc <alltraps>

80106fc3 <vector79>:
.globl vector79
vector79:
  pushl $0
80106fc3:	6a 00                	push   $0x0
  pushl $79
80106fc5:	6a 4f                	push   $0x4f
  jmp alltraps
80106fc7:	e9 f0 f6 ff ff       	jmp    801066bc <alltraps>

80106fcc <vector80>:
.globl vector80
vector80:
  pushl $0
80106fcc:	6a 00                	push   $0x0
  pushl $80
80106fce:	6a 50                	push   $0x50
  jmp alltraps
80106fd0:	e9 e7 f6 ff ff       	jmp    801066bc <alltraps>

80106fd5 <vector81>:
.globl vector81
vector81:
  pushl $0
80106fd5:	6a 00                	push   $0x0
  pushl $81
80106fd7:	6a 51                	push   $0x51
  jmp alltraps
80106fd9:	e9 de f6 ff ff       	jmp    801066bc <alltraps>

80106fde <vector82>:
.globl vector82
vector82:
  pushl $0
80106fde:	6a 00                	push   $0x0
  pushl $82
80106fe0:	6a 52                	push   $0x52
  jmp alltraps
80106fe2:	e9 d5 f6 ff ff       	jmp    801066bc <alltraps>

80106fe7 <vector83>:
.globl vector83
vector83:
  pushl $0
80106fe7:	6a 00                	push   $0x0
  pushl $83
80106fe9:	6a 53                	push   $0x53
  jmp alltraps
80106feb:	e9 cc f6 ff ff       	jmp    801066bc <alltraps>

80106ff0 <vector84>:
.globl vector84
vector84:
  pushl $0
80106ff0:	6a 00                	push   $0x0
  pushl $84
80106ff2:	6a 54                	push   $0x54
  jmp alltraps
80106ff4:	e9 c3 f6 ff ff       	jmp    801066bc <alltraps>

80106ff9 <vector85>:
.globl vector85
vector85:
  pushl $0
80106ff9:	6a 00                	push   $0x0
  pushl $85
80106ffb:	6a 55                	push   $0x55
  jmp alltraps
80106ffd:	e9 ba f6 ff ff       	jmp    801066bc <alltraps>

80107002 <vector86>:
.globl vector86
vector86:
  pushl $0
80107002:	6a 00                	push   $0x0
  pushl $86
80107004:	6a 56                	push   $0x56
  jmp alltraps
80107006:	e9 b1 f6 ff ff       	jmp    801066bc <alltraps>

8010700b <vector87>:
.globl vector87
vector87:
  pushl $0
8010700b:	6a 00                	push   $0x0
  pushl $87
8010700d:	6a 57                	push   $0x57
  jmp alltraps
8010700f:	e9 a8 f6 ff ff       	jmp    801066bc <alltraps>

80107014 <vector88>:
.globl vector88
vector88:
  pushl $0
80107014:	6a 00                	push   $0x0
  pushl $88
80107016:	6a 58                	push   $0x58
  jmp alltraps
80107018:	e9 9f f6 ff ff       	jmp    801066bc <alltraps>

8010701d <vector89>:
.globl vector89
vector89:
  pushl $0
8010701d:	6a 00                	push   $0x0
  pushl $89
8010701f:	6a 59                	push   $0x59
  jmp alltraps
80107021:	e9 96 f6 ff ff       	jmp    801066bc <alltraps>

80107026 <vector90>:
.globl vector90
vector90:
  pushl $0
80107026:	6a 00                	push   $0x0
  pushl $90
80107028:	6a 5a                	push   $0x5a
  jmp alltraps
8010702a:	e9 8d f6 ff ff       	jmp    801066bc <alltraps>

8010702f <vector91>:
.globl vector91
vector91:
  pushl $0
8010702f:	6a 00                	push   $0x0
  pushl $91
80107031:	6a 5b                	push   $0x5b
  jmp alltraps
80107033:	e9 84 f6 ff ff       	jmp    801066bc <alltraps>

80107038 <vector92>:
.globl vector92
vector92:
  pushl $0
80107038:	6a 00                	push   $0x0
  pushl $92
8010703a:	6a 5c                	push   $0x5c
  jmp alltraps
8010703c:	e9 7b f6 ff ff       	jmp    801066bc <alltraps>

80107041 <vector93>:
.globl vector93
vector93:
  pushl $0
80107041:	6a 00                	push   $0x0
  pushl $93
80107043:	6a 5d                	push   $0x5d
  jmp alltraps
80107045:	e9 72 f6 ff ff       	jmp    801066bc <alltraps>

8010704a <vector94>:
.globl vector94
vector94:
  pushl $0
8010704a:	6a 00                	push   $0x0
  pushl $94
8010704c:	6a 5e                	push   $0x5e
  jmp alltraps
8010704e:	e9 69 f6 ff ff       	jmp    801066bc <alltraps>

80107053 <vector95>:
.globl vector95
vector95:
  pushl $0
80107053:	6a 00                	push   $0x0
  pushl $95
80107055:	6a 5f                	push   $0x5f
  jmp alltraps
80107057:	e9 60 f6 ff ff       	jmp    801066bc <alltraps>

8010705c <vector96>:
.globl vector96
vector96:
  pushl $0
8010705c:	6a 00                	push   $0x0
  pushl $96
8010705e:	6a 60                	push   $0x60
  jmp alltraps
80107060:	e9 57 f6 ff ff       	jmp    801066bc <alltraps>

80107065 <vector97>:
.globl vector97
vector97:
  pushl $0
80107065:	6a 00                	push   $0x0
  pushl $97
80107067:	6a 61                	push   $0x61
  jmp alltraps
80107069:	e9 4e f6 ff ff       	jmp    801066bc <alltraps>

8010706e <vector98>:
.globl vector98
vector98:
  pushl $0
8010706e:	6a 00                	push   $0x0
  pushl $98
80107070:	6a 62                	push   $0x62
  jmp alltraps
80107072:	e9 45 f6 ff ff       	jmp    801066bc <alltraps>

80107077 <vector99>:
.globl vector99
vector99:
  pushl $0
80107077:	6a 00                	push   $0x0
  pushl $99
80107079:	6a 63                	push   $0x63
  jmp alltraps
8010707b:	e9 3c f6 ff ff       	jmp    801066bc <alltraps>

80107080 <vector100>:
.globl vector100
vector100:
  pushl $0
80107080:	6a 00                	push   $0x0
  pushl $100
80107082:	6a 64                	push   $0x64
  jmp alltraps
80107084:	e9 33 f6 ff ff       	jmp    801066bc <alltraps>

80107089 <vector101>:
.globl vector101
vector101:
  pushl $0
80107089:	6a 00                	push   $0x0
  pushl $101
8010708b:	6a 65                	push   $0x65
  jmp alltraps
8010708d:	e9 2a f6 ff ff       	jmp    801066bc <alltraps>

80107092 <vector102>:
.globl vector102
vector102:
  pushl $0
80107092:	6a 00                	push   $0x0
  pushl $102
80107094:	6a 66                	push   $0x66
  jmp alltraps
80107096:	e9 21 f6 ff ff       	jmp    801066bc <alltraps>

8010709b <vector103>:
.globl vector103
vector103:
  pushl $0
8010709b:	6a 00                	push   $0x0
  pushl $103
8010709d:	6a 67                	push   $0x67
  jmp alltraps
8010709f:	e9 18 f6 ff ff       	jmp    801066bc <alltraps>

801070a4 <vector104>:
.globl vector104
vector104:
  pushl $0
801070a4:	6a 00                	push   $0x0
  pushl $104
801070a6:	6a 68                	push   $0x68
  jmp alltraps
801070a8:	e9 0f f6 ff ff       	jmp    801066bc <alltraps>

801070ad <vector105>:
.globl vector105
vector105:
  pushl $0
801070ad:	6a 00                	push   $0x0
  pushl $105
801070af:	6a 69                	push   $0x69
  jmp alltraps
801070b1:	e9 06 f6 ff ff       	jmp    801066bc <alltraps>

801070b6 <vector106>:
.globl vector106
vector106:
  pushl $0
801070b6:	6a 00                	push   $0x0
  pushl $106
801070b8:	6a 6a                	push   $0x6a
  jmp alltraps
801070ba:	e9 fd f5 ff ff       	jmp    801066bc <alltraps>

801070bf <vector107>:
.globl vector107
vector107:
  pushl $0
801070bf:	6a 00                	push   $0x0
  pushl $107
801070c1:	6a 6b                	push   $0x6b
  jmp alltraps
801070c3:	e9 f4 f5 ff ff       	jmp    801066bc <alltraps>

801070c8 <vector108>:
.globl vector108
vector108:
  pushl $0
801070c8:	6a 00                	push   $0x0
  pushl $108
801070ca:	6a 6c                	push   $0x6c
  jmp alltraps
801070cc:	e9 eb f5 ff ff       	jmp    801066bc <alltraps>

801070d1 <vector109>:
.globl vector109
vector109:
  pushl $0
801070d1:	6a 00                	push   $0x0
  pushl $109
801070d3:	6a 6d                	push   $0x6d
  jmp alltraps
801070d5:	e9 e2 f5 ff ff       	jmp    801066bc <alltraps>

801070da <vector110>:
.globl vector110
vector110:
  pushl $0
801070da:	6a 00                	push   $0x0
  pushl $110
801070dc:	6a 6e                	push   $0x6e
  jmp alltraps
801070de:	e9 d9 f5 ff ff       	jmp    801066bc <alltraps>

801070e3 <vector111>:
.globl vector111
vector111:
  pushl $0
801070e3:	6a 00                	push   $0x0
  pushl $111
801070e5:	6a 6f                	push   $0x6f
  jmp alltraps
801070e7:	e9 d0 f5 ff ff       	jmp    801066bc <alltraps>

801070ec <vector112>:
.globl vector112
vector112:
  pushl $0
801070ec:	6a 00                	push   $0x0
  pushl $112
801070ee:	6a 70                	push   $0x70
  jmp alltraps
801070f0:	e9 c7 f5 ff ff       	jmp    801066bc <alltraps>

801070f5 <vector113>:
.globl vector113
vector113:
  pushl $0
801070f5:	6a 00                	push   $0x0
  pushl $113
801070f7:	6a 71                	push   $0x71
  jmp alltraps
801070f9:	e9 be f5 ff ff       	jmp    801066bc <alltraps>

801070fe <vector114>:
.globl vector114
vector114:
  pushl $0
801070fe:	6a 00                	push   $0x0
  pushl $114
80107100:	6a 72                	push   $0x72
  jmp alltraps
80107102:	e9 b5 f5 ff ff       	jmp    801066bc <alltraps>

80107107 <vector115>:
.globl vector115
vector115:
  pushl $0
80107107:	6a 00                	push   $0x0
  pushl $115
80107109:	6a 73                	push   $0x73
  jmp alltraps
8010710b:	e9 ac f5 ff ff       	jmp    801066bc <alltraps>

80107110 <vector116>:
.globl vector116
vector116:
  pushl $0
80107110:	6a 00                	push   $0x0
  pushl $116
80107112:	6a 74                	push   $0x74
  jmp alltraps
80107114:	e9 a3 f5 ff ff       	jmp    801066bc <alltraps>

80107119 <vector117>:
.globl vector117
vector117:
  pushl $0
80107119:	6a 00                	push   $0x0
  pushl $117
8010711b:	6a 75                	push   $0x75
  jmp alltraps
8010711d:	e9 9a f5 ff ff       	jmp    801066bc <alltraps>

80107122 <vector118>:
.globl vector118
vector118:
  pushl $0
80107122:	6a 00                	push   $0x0
  pushl $118
80107124:	6a 76                	push   $0x76
  jmp alltraps
80107126:	e9 91 f5 ff ff       	jmp    801066bc <alltraps>

8010712b <vector119>:
.globl vector119
vector119:
  pushl $0
8010712b:	6a 00                	push   $0x0
  pushl $119
8010712d:	6a 77                	push   $0x77
  jmp alltraps
8010712f:	e9 88 f5 ff ff       	jmp    801066bc <alltraps>

80107134 <vector120>:
.globl vector120
vector120:
  pushl $0
80107134:	6a 00                	push   $0x0
  pushl $120
80107136:	6a 78                	push   $0x78
  jmp alltraps
80107138:	e9 7f f5 ff ff       	jmp    801066bc <alltraps>

8010713d <vector121>:
.globl vector121
vector121:
  pushl $0
8010713d:	6a 00                	push   $0x0
  pushl $121
8010713f:	6a 79                	push   $0x79
  jmp alltraps
80107141:	e9 76 f5 ff ff       	jmp    801066bc <alltraps>

80107146 <vector122>:
.globl vector122
vector122:
  pushl $0
80107146:	6a 00                	push   $0x0
  pushl $122
80107148:	6a 7a                	push   $0x7a
  jmp alltraps
8010714a:	e9 6d f5 ff ff       	jmp    801066bc <alltraps>

8010714f <vector123>:
.globl vector123
vector123:
  pushl $0
8010714f:	6a 00                	push   $0x0
  pushl $123
80107151:	6a 7b                	push   $0x7b
  jmp alltraps
80107153:	e9 64 f5 ff ff       	jmp    801066bc <alltraps>

80107158 <vector124>:
.globl vector124
vector124:
  pushl $0
80107158:	6a 00                	push   $0x0
  pushl $124
8010715a:	6a 7c                	push   $0x7c
  jmp alltraps
8010715c:	e9 5b f5 ff ff       	jmp    801066bc <alltraps>

80107161 <vector125>:
.globl vector125
vector125:
  pushl $0
80107161:	6a 00                	push   $0x0
  pushl $125
80107163:	6a 7d                	push   $0x7d
  jmp alltraps
80107165:	e9 52 f5 ff ff       	jmp    801066bc <alltraps>

8010716a <vector126>:
.globl vector126
vector126:
  pushl $0
8010716a:	6a 00                	push   $0x0
  pushl $126
8010716c:	6a 7e                	push   $0x7e
  jmp alltraps
8010716e:	e9 49 f5 ff ff       	jmp    801066bc <alltraps>

80107173 <vector127>:
.globl vector127
vector127:
  pushl $0
80107173:	6a 00                	push   $0x0
  pushl $127
80107175:	6a 7f                	push   $0x7f
  jmp alltraps
80107177:	e9 40 f5 ff ff       	jmp    801066bc <alltraps>

8010717c <vector128>:
.globl vector128
vector128:
  pushl $0
8010717c:	6a 00                	push   $0x0
  pushl $128
8010717e:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107183:	e9 34 f5 ff ff       	jmp    801066bc <alltraps>

80107188 <vector129>:
.globl vector129
vector129:
  pushl $0
80107188:	6a 00                	push   $0x0
  pushl $129
8010718a:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010718f:	e9 28 f5 ff ff       	jmp    801066bc <alltraps>

80107194 <vector130>:
.globl vector130
vector130:
  pushl $0
80107194:	6a 00                	push   $0x0
  pushl $130
80107196:	68 82 00 00 00       	push   $0x82
  jmp alltraps
8010719b:	e9 1c f5 ff ff       	jmp    801066bc <alltraps>

801071a0 <vector131>:
.globl vector131
vector131:
  pushl $0
801071a0:	6a 00                	push   $0x0
  pushl $131
801071a2:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801071a7:	e9 10 f5 ff ff       	jmp    801066bc <alltraps>

801071ac <vector132>:
.globl vector132
vector132:
  pushl $0
801071ac:	6a 00                	push   $0x0
  pushl $132
801071ae:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801071b3:	e9 04 f5 ff ff       	jmp    801066bc <alltraps>

801071b8 <vector133>:
.globl vector133
vector133:
  pushl $0
801071b8:	6a 00                	push   $0x0
  pushl $133
801071ba:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801071bf:	e9 f8 f4 ff ff       	jmp    801066bc <alltraps>

801071c4 <vector134>:
.globl vector134
vector134:
  pushl $0
801071c4:	6a 00                	push   $0x0
  pushl $134
801071c6:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801071cb:	e9 ec f4 ff ff       	jmp    801066bc <alltraps>

801071d0 <vector135>:
.globl vector135
vector135:
  pushl $0
801071d0:	6a 00                	push   $0x0
  pushl $135
801071d2:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801071d7:	e9 e0 f4 ff ff       	jmp    801066bc <alltraps>

801071dc <vector136>:
.globl vector136
vector136:
  pushl $0
801071dc:	6a 00                	push   $0x0
  pushl $136
801071de:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801071e3:	e9 d4 f4 ff ff       	jmp    801066bc <alltraps>

801071e8 <vector137>:
.globl vector137
vector137:
  pushl $0
801071e8:	6a 00                	push   $0x0
  pushl $137
801071ea:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801071ef:	e9 c8 f4 ff ff       	jmp    801066bc <alltraps>

801071f4 <vector138>:
.globl vector138
vector138:
  pushl $0
801071f4:	6a 00                	push   $0x0
  pushl $138
801071f6:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801071fb:	e9 bc f4 ff ff       	jmp    801066bc <alltraps>

80107200 <vector139>:
.globl vector139
vector139:
  pushl $0
80107200:	6a 00                	push   $0x0
  pushl $139
80107202:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107207:	e9 b0 f4 ff ff       	jmp    801066bc <alltraps>

8010720c <vector140>:
.globl vector140
vector140:
  pushl $0
8010720c:	6a 00                	push   $0x0
  pushl $140
8010720e:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80107213:	e9 a4 f4 ff ff       	jmp    801066bc <alltraps>

80107218 <vector141>:
.globl vector141
vector141:
  pushl $0
80107218:	6a 00                	push   $0x0
  pushl $141
8010721a:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010721f:	e9 98 f4 ff ff       	jmp    801066bc <alltraps>

80107224 <vector142>:
.globl vector142
vector142:
  pushl $0
80107224:	6a 00                	push   $0x0
  pushl $142
80107226:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
8010722b:	e9 8c f4 ff ff       	jmp    801066bc <alltraps>

80107230 <vector143>:
.globl vector143
vector143:
  pushl $0
80107230:	6a 00                	push   $0x0
  pushl $143
80107232:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107237:	e9 80 f4 ff ff       	jmp    801066bc <alltraps>

8010723c <vector144>:
.globl vector144
vector144:
  pushl $0
8010723c:	6a 00                	push   $0x0
  pushl $144
8010723e:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107243:	e9 74 f4 ff ff       	jmp    801066bc <alltraps>

80107248 <vector145>:
.globl vector145
vector145:
  pushl $0
80107248:	6a 00                	push   $0x0
  pushl $145
8010724a:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010724f:	e9 68 f4 ff ff       	jmp    801066bc <alltraps>

80107254 <vector146>:
.globl vector146
vector146:
  pushl $0
80107254:	6a 00                	push   $0x0
  pushl $146
80107256:	68 92 00 00 00       	push   $0x92
  jmp alltraps
8010725b:	e9 5c f4 ff ff       	jmp    801066bc <alltraps>

80107260 <vector147>:
.globl vector147
vector147:
  pushl $0
80107260:	6a 00                	push   $0x0
  pushl $147
80107262:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107267:	e9 50 f4 ff ff       	jmp    801066bc <alltraps>

8010726c <vector148>:
.globl vector148
vector148:
  pushl $0
8010726c:	6a 00                	push   $0x0
  pushl $148
8010726e:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107273:	e9 44 f4 ff ff       	jmp    801066bc <alltraps>

80107278 <vector149>:
.globl vector149
vector149:
  pushl $0
80107278:	6a 00                	push   $0x0
  pushl $149
8010727a:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010727f:	e9 38 f4 ff ff       	jmp    801066bc <alltraps>

80107284 <vector150>:
.globl vector150
vector150:
  pushl $0
80107284:	6a 00                	push   $0x0
  pushl $150
80107286:	68 96 00 00 00       	push   $0x96
  jmp alltraps
8010728b:	e9 2c f4 ff ff       	jmp    801066bc <alltraps>

80107290 <vector151>:
.globl vector151
vector151:
  pushl $0
80107290:	6a 00                	push   $0x0
  pushl $151
80107292:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80107297:	e9 20 f4 ff ff       	jmp    801066bc <alltraps>

8010729c <vector152>:
.globl vector152
vector152:
  pushl $0
8010729c:	6a 00                	push   $0x0
  pushl $152
8010729e:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801072a3:	e9 14 f4 ff ff       	jmp    801066bc <alltraps>

801072a8 <vector153>:
.globl vector153
vector153:
  pushl $0
801072a8:	6a 00                	push   $0x0
  pushl $153
801072aa:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801072af:	e9 08 f4 ff ff       	jmp    801066bc <alltraps>

801072b4 <vector154>:
.globl vector154
vector154:
  pushl $0
801072b4:	6a 00                	push   $0x0
  pushl $154
801072b6:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801072bb:	e9 fc f3 ff ff       	jmp    801066bc <alltraps>

801072c0 <vector155>:
.globl vector155
vector155:
  pushl $0
801072c0:	6a 00                	push   $0x0
  pushl $155
801072c2:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801072c7:	e9 f0 f3 ff ff       	jmp    801066bc <alltraps>

801072cc <vector156>:
.globl vector156
vector156:
  pushl $0
801072cc:	6a 00                	push   $0x0
  pushl $156
801072ce:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801072d3:	e9 e4 f3 ff ff       	jmp    801066bc <alltraps>

801072d8 <vector157>:
.globl vector157
vector157:
  pushl $0
801072d8:	6a 00                	push   $0x0
  pushl $157
801072da:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801072df:	e9 d8 f3 ff ff       	jmp    801066bc <alltraps>

801072e4 <vector158>:
.globl vector158
vector158:
  pushl $0
801072e4:	6a 00                	push   $0x0
  pushl $158
801072e6:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801072eb:	e9 cc f3 ff ff       	jmp    801066bc <alltraps>

801072f0 <vector159>:
.globl vector159
vector159:
  pushl $0
801072f0:	6a 00                	push   $0x0
  pushl $159
801072f2:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801072f7:	e9 c0 f3 ff ff       	jmp    801066bc <alltraps>

801072fc <vector160>:
.globl vector160
vector160:
  pushl $0
801072fc:	6a 00                	push   $0x0
  pushl $160
801072fe:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107303:	e9 b4 f3 ff ff       	jmp    801066bc <alltraps>

80107308 <vector161>:
.globl vector161
vector161:
  pushl $0
80107308:	6a 00                	push   $0x0
  pushl $161
8010730a:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010730f:	e9 a8 f3 ff ff       	jmp    801066bc <alltraps>

80107314 <vector162>:
.globl vector162
vector162:
  pushl $0
80107314:	6a 00                	push   $0x0
  pushl $162
80107316:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
8010731b:	e9 9c f3 ff ff       	jmp    801066bc <alltraps>

80107320 <vector163>:
.globl vector163
vector163:
  pushl $0
80107320:	6a 00                	push   $0x0
  pushl $163
80107322:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107327:	e9 90 f3 ff ff       	jmp    801066bc <alltraps>

8010732c <vector164>:
.globl vector164
vector164:
  pushl $0
8010732c:	6a 00                	push   $0x0
  pushl $164
8010732e:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107333:	e9 84 f3 ff ff       	jmp    801066bc <alltraps>

80107338 <vector165>:
.globl vector165
vector165:
  pushl $0
80107338:	6a 00                	push   $0x0
  pushl $165
8010733a:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010733f:	e9 78 f3 ff ff       	jmp    801066bc <alltraps>

80107344 <vector166>:
.globl vector166
vector166:
  pushl $0
80107344:	6a 00                	push   $0x0
  pushl $166
80107346:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
8010734b:	e9 6c f3 ff ff       	jmp    801066bc <alltraps>

80107350 <vector167>:
.globl vector167
vector167:
  pushl $0
80107350:	6a 00                	push   $0x0
  pushl $167
80107352:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107357:	e9 60 f3 ff ff       	jmp    801066bc <alltraps>

8010735c <vector168>:
.globl vector168
vector168:
  pushl $0
8010735c:	6a 00                	push   $0x0
  pushl $168
8010735e:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107363:	e9 54 f3 ff ff       	jmp    801066bc <alltraps>

80107368 <vector169>:
.globl vector169
vector169:
  pushl $0
80107368:	6a 00                	push   $0x0
  pushl $169
8010736a:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010736f:	e9 48 f3 ff ff       	jmp    801066bc <alltraps>

80107374 <vector170>:
.globl vector170
vector170:
  pushl $0
80107374:	6a 00                	push   $0x0
  pushl $170
80107376:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
8010737b:	e9 3c f3 ff ff       	jmp    801066bc <alltraps>

80107380 <vector171>:
.globl vector171
vector171:
  pushl $0
80107380:	6a 00                	push   $0x0
  pushl $171
80107382:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107387:	e9 30 f3 ff ff       	jmp    801066bc <alltraps>

8010738c <vector172>:
.globl vector172
vector172:
  pushl $0
8010738c:	6a 00                	push   $0x0
  pushl $172
8010738e:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107393:	e9 24 f3 ff ff       	jmp    801066bc <alltraps>

80107398 <vector173>:
.globl vector173
vector173:
  pushl $0
80107398:	6a 00                	push   $0x0
  pushl $173
8010739a:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010739f:	e9 18 f3 ff ff       	jmp    801066bc <alltraps>

801073a4 <vector174>:
.globl vector174
vector174:
  pushl $0
801073a4:	6a 00                	push   $0x0
  pushl $174
801073a6:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801073ab:	e9 0c f3 ff ff       	jmp    801066bc <alltraps>

801073b0 <vector175>:
.globl vector175
vector175:
  pushl $0
801073b0:	6a 00                	push   $0x0
  pushl $175
801073b2:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801073b7:	e9 00 f3 ff ff       	jmp    801066bc <alltraps>

801073bc <vector176>:
.globl vector176
vector176:
  pushl $0
801073bc:	6a 00                	push   $0x0
  pushl $176
801073be:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801073c3:	e9 f4 f2 ff ff       	jmp    801066bc <alltraps>

801073c8 <vector177>:
.globl vector177
vector177:
  pushl $0
801073c8:	6a 00                	push   $0x0
  pushl $177
801073ca:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801073cf:	e9 e8 f2 ff ff       	jmp    801066bc <alltraps>

801073d4 <vector178>:
.globl vector178
vector178:
  pushl $0
801073d4:	6a 00                	push   $0x0
  pushl $178
801073d6:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801073db:	e9 dc f2 ff ff       	jmp    801066bc <alltraps>

801073e0 <vector179>:
.globl vector179
vector179:
  pushl $0
801073e0:	6a 00                	push   $0x0
  pushl $179
801073e2:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801073e7:	e9 d0 f2 ff ff       	jmp    801066bc <alltraps>

801073ec <vector180>:
.globl vector180
vector180:
  pushl $0
801073ec:	6a 00                	push   $0x0
  pushl $180
801073ee:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801073f3:	e9 c4 f2 ff ff       	jmp    801066bc <alltraps>

801073f8 <vector181>:
.globl vector181
vector181:
  pushl $0
801073f8:	6a 00                	push   $0x0
  pushl $181
801073fa:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801073ff:	e9 b8 f2 ff ff       	jmp    801066bc <alltraps>

80107404 <vector182>:
.globl vector182
vector182:
  pushl $0
80107404:	6a 00                	push   $0x0
  pushl $182
80107406:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
8010740b:	e9 ac f2 ff ff       	jmp    801066bc <alltraps>

80107410 <vector183>:
.globl vector183
vector183:
  pushl $0
80107410:	6a 00                	push   $0x0
  pushl $183
80107412:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107417:	e9 a0 f2 ff ff       	jmp    801066bc <alltraps>

8010741c <vector184>:
.globl vector184
vector184:
  pushl $0
8010741c:	6a 00                	push   $0x0
  pushl $184
8010741e:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107423:	e9 94 f2 ff ff       	jmp    801066bc <alltraps>

80107428 <vector185>:
.globl vector185
vector185:
  pushl $0
80107428:	6a 00                	push   $0x0
  pushl $185
8010742a:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010742f:	e9 88 f2 ff ff       	jmp    801066bc <alltraps>

80107434 <vector186>:
.globl vector186
vector186:
  pushl $0
80107434:	6a 00                	push   $0x0
  pushl $186
80107436:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
8010743b:	e9 7c f2 ff ff       	jmp    801066bc <alltraps>

80107440 <vector187>:
.globl vector187
vector187:
  pushl $0
80107440:	6a 00                	push   $0x0
  pushl $187
80107442:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107447:	e9 70 f2 ff ff       	jmp    801066bc <alltraps>

8010744c <vector188>:
.globl vector188
vector188:
  pushl $0
8010744c:	6a 00                	push   $0x0
  pushl $188
8010744e:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107453:	e9 64 f2 ff ff       	jmp    801066bc <alltraps>

80107458 <vector189>:
.globl vector189
vector189:
  pushl $0
80107458:	6a 00                	push   $0x0
  pushl $189
8010745a:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010745f:	e9 58 f2 ff ff       	jmp    801066bc <alltraps>

80107464 <vector190>:
.globl vector190
vector190:
  pushl $0
80107464:	6a 00                	push   $0x0
  pushl $190
80107466:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
8010746b:	e9 4c f2 ff ff       	jmp    801066bc <alltraps>

80107470 <vector191>:
.globl vector191
vector191:
  pushl $0
80107470:	6a 00                	push   $0x0
  pushl $191
80107472:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107477:	e9 40 f2 ff ff       	jmp    801066bc <alltraps>

8010747c <vector192>:
.globl vector192
vector192:
  pushl $0
8010747c:	6a 00                	push   $0x0
  pushl $192
8010747e:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107483:	e9 34 f2 ff ff       	jmp    801066bc <alltraps>

80107488 <vector193>:
.globl vector193
vector193:
  pushl $0
80107488:	6a 00                	push   $0x0
  pushl $193
8010748a:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010748f:	e9 28 f2 ff ff       	jmp    801066bc <alltraps>

80107494 <vector194>:
.globl vector194
vector194:
  pushl $0
80107494:	6a 00                	push   $0x0
  pushl $194
80107496:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
8010749b:	e9 1c f2 ff ff       	jmp    801066bc <alltraps>

801074a0 <vector195>:
.globl vector195
vector195:
  pushl $0
801074a0:	6a 00                	push   $0x0
  pushl $195
801074a2:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801074a7:	e9 10 f2 ff ff       	jmp    801066bc <alltraps>

801074ac <vector196>:
.globl vector196
vector196:
  pushl $0
801074ac:	6a 00                	push   $0x0
  pushl $196
801074ae:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801074b3:	e9 04 f2 ff ff       	jmp    801066bc <alltraps>

801074b8 <vector197>:
.globl vector197
vector197:
  pushl $0
801074b8:	6a 00                	push   $0x0
  pushl $197
801074ba:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801074bf:	e9 f8 f1 ff ff       	jmp    801066bc <alltraps>

801074c4 <vector198>:
.globl vector198
vector198:
  pushl $0
801074c4:	6a 00                	push   $0x0
  pushl $198
801074c6:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801074cb:	e9 ec f1 ff ff       	jmp    801066bc <alltraps>

801074d0 <vector199>:
.globl vector199
vector199:
  pushl $0
801074d0:	6a 00                	push   $0x0
  pushl $199
801074d2:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801074d7:	e9 e0 f1 ff ff       	jmp    801066bc <alltraps>

801074dc <vector200>:
.globl vector200
vector200:
  pushl $0
801074dc:	6a 00                	push   $0x0
  pushl $200
801074de:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801074e3:	e9 d4 f1 ff ff       	jmp    801066bc <alltraps>

801074e8 <vector201>:
.globl vector201
vector201:
  pushl $0
801074e8:	6a 00                	push   $0x0
  pushl $201
801074ea:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801074ef:	e9 c8 f1 ff ff       	jmp    801066bc <alltraps>

801074f4 <vector202>:
.globl vector202
vector202:
  pushl $0
801074f4:	6a 00                	push   $0x0
  pushl $202
801074f6:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801074fb:	e9 bc f1 ff ff       	jmp    801066bc <alltraps>

80107500 <vector203>:
.globl vector203
vector203:
  pushl $0
80107500:	6a 00                	push   $0x0
  pushl $203
80107502:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107507:	e9 b0 f1 ff ff       	jmp    801066bc <alltraps>

8010750c <vector204>:
.globl vector204
vector204:
  pushl $0
8010750c:	6a 00                	push   $0x0
  pushl $204
8010750e:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107513:	e9 a4 f1 ff ff       	jmp    801066bc <alltraps>

80107518 <vector205>:
.globl vector205
vector205:
  pushl $0
80107518:	6a 00                	push   $0x0
  pushl $205
8010751a:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010751f:	e9 98 f1 ff ff       	jmp    801066bc <alltraps>

80107524 <vector206>:
.globl vector206
vector206:
  pushl $0
80107524:	6a 00                	push   $0x0
  pushl $206
80107526:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
8010752b:	e9 8c f1 ff ff       	jmp    801066bc <alltraps>

80107530 <vector207>:
.globl vector207
vector207:
  pushl $0
80107530:	6a 00                	push   $0x0
  pushl $207
80107532:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107537:	e9 80 f1 ff ff       	jmp    801066bc <alltraps>

8010753c <vector208>:
.globl vector208
vector208:
  pushl $0
8010753c:	6a 00                	push   $0x0
  pushl $208
8010753e:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107543:	e9 74 f1 ff ff       	jmp    801066bc <alltraps>

80107548 <vector209>:
.globl vector209
vector209:
  pushl $0
80107548:	6a 00                	push   $0x0
  pushl $209
8010754a:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010754f:	e9 68 f1 ff ff       	jmp    801066bc <alltraps>

80107554 <vector210>:
.globl vector210
vector210:
  pushl $0
80107554:	6a 00                	push   $0x0
  pushl $210
80107556:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
8010755b:	e9 5c f1 ff ff       	jmp    801066bc <alltraps>

80107560 <vector211>:
.globl vector211
vector211:
  pushl $0
80107560:	6a 00                	push   $0x0
  pushl $211
80107562:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107567:	e9 50 f1 ff ff       	jmp    801066bc <alltraps>

8010756c <vector212>:
.globl vector212
vector212:
  pushl $0
8010756c:	6a 00                	push   $0x0
  pushl $212
8010756e:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107573:	e9 44 f1 ff ff       	jmp    801066bc <alltraps>

80107578 <vector213>:
.globl vector213
vector213:
  pushl $0
80107578:	6a 00                	push   $0x0
  pushl $213
8010757a:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010757f:	e9 38 f1 ff ff       	jmp    801066bc <alltraps>

80107584 <vector214>:
.globl vector214
vector214:
  pushl $0
80107584:	6a 00                	push   $0x0
  pushl $214
80107586:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
8010758b:	e9 2c f1 ff ff       	jmp    801066bc <alltraps>

80107590 <vector215>:
.globl vector215
vector215:
  pushl $0
80107590:	6a 00                	push   $0x0
  pushl $215
80107592:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107597:	e9 20 f1 ff ff       	jmp    801066bc <alltraps>

8010759c <vector216>:
.globl vector216
vector216:
  pushl $0
8010759c:	6a 00                	push   $0x0
  pushl $216
8010759e:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801075a3:	e9 14 f1 ff ff       	jmp    801066bc <alltraps>

801075a8 <vector217>:
.globl vector217
vector217:
  pushl $0
801075a8:	6a 00                	push   $0x0
  pushl $217
801075aa:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801075af:	e9 08 f1 ff ff       	jmp    801066bc <alltraps>

801075b4 <vector218>:
.globl vector218
vector218:
  pushl $0
801075b4:	6a 00                	push   $0x0
  pushl $218
801075b6:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801075bb:	e9 fc f0 ff ff       	jmp    801066bc <alltraps>

801075c0 <vector219>:
.globl vector219
vector219:
  pushl $0
801075c0:	6a 00                	push   $0x0
  pushl $219
801075c2:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801075c7:	e9 f0 f0 ff ff       	jmp    801066bc <alltraps>

801075cc <vector220>:
.globl vector220
vector220:
  pushl $0
801075cc:	6a 00                	push   $0x0
  pushl $220
801075ce:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801075d3:	e9 e4 f0 ff ff       	jmp    801066bc <alltraps>

801075d8 <vector221>:
.globl vector221
vector221:
  pushl $0
801075d8:	6a 00                	push   $0x0
  pushl $221
801075da:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801075df:	e9 d8 f0 ff ff       	jmp    801066bc <alltraps>

801075e4 <vector222>:
.globl vector222
vector222:
  pushl $0
801075e4:	6a 00                	push   $0x0
  pushl $222
801075e6:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801075eb:	e9 cc f0 ff ff       	jmp    801066bc <alltraps>

801075f0 <vector223>:
.globl vector223
vector223:
  pushl $0
801075f0:	6a 00                	push   $0x0
  pushl $223
801075f2:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801075f7:	e9 c0 f0 ff ff       	jmp    801066bc <alltraps>

801075fc <vector224>:
.globl vector224
vector224:
  pushl $0
801075fc:	6a 00                	push   $0x0
  pushl $224
801075fe:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107603:	e9 b4 f0 ff ff       	jmp    801066bc <alltraps>

80107608 <vector225>:
.globl vector225
vector225:
  pushl $0
80107608:	6a 00                	push   $0x0
  pushl $225
8010760a:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010760f:	e9 a8 f0 ff ff       	jmp    801066bc <alltraps>

80107614 <vector226>:
.globl vector226
vector226:
  pushl $0
80107614:	6a 00                	push   $0x0
  pushl $226
80107616:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010761b:	e9 9c f0 ff ff       	jmp    801066bc <alltraps>

80107620 <vector227>:
.globl vector227
vector227:
  pushl $0
80107620:	6a 00                	push   $0x0
  pushl $227
80107622:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107627:	e9 90 f0 ff ff       	jmp    801066bc <alltraps>

8010762c <vector228>:
.globl vector228
vector228:
  pushl $0
8010762c:	6a 00                	push   $0x0
  pushl $228
8010762e:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107633:	e9 84 f0 ff ff       	jmp    801066bc <alltraps>

80107638 <vector229>:
.globl vector229
vector229:
  pushl $0
80107638:	6a 00                	push   $0x0
  pushl $229
8010763a:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010763f:	e9 78 f0 ff ff       	jmp    801066bc <alltraps>

80107644 <vector230>:
.globl vector230
vector230:
  pushl $0
80107644:	6a 00                	push   $0x0
  pushl $230
80107646:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
8010764b:	e9 6c f0 ff ff       	jmp    801066bc <alltraps>

80107650 <vector231>:
.globl vector231
vector231:
  pushl $0
80107650:	6a 00                	push   $0x0
  pushl $231
80107652:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107657:	e9 60 f0 ff ff       	jmp    801066bc <alltraps>

8010765c <vector232>:
.globl vector232
vector232:
  pushl $0
8010765c:	6a 00                	push   $0x0
  pushl $232
8010765e:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107663:	e9 54 f0 ff ff       	jmp    801066bc <alltraps>

80107668 <vector233>:
.globl vector233
vector233:
  pushl $0
80107668:	6a 00                	push   $0x0
  pushl $233
8010766a:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010766f:	e9 48 f0 ff ff       	jmp    801066bc <alltraps>

80107674 <vector234>:
.globl vector234
vector234:
  pushl $0
80107674:	6a 00                	push   $0x0
  pushl $234
80107676:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
8010767b:	e9 3c f0 ff ff       	jmp    801066bc <alltraps>

80107680 <vector235>:
.globl vector235
vector235:
  pushl $0
80107680:	6a 00                	push   $0x0
  pushl $235
80107682:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107687:	e9 30 f0 ff ff       	jmp    801066bc <alltraps>

8010768c <vector236>:
.globl vector236
vector236:
  pushl $0
8010768c:	6a 00                	push   $0x0
  pushl $236
8010768e:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107693:	e9 24 f0 ff ff       	jmp    801066bc <alltraps>

80107698 <vector237>:
.globl vector237
vector237:
  pushl $0
80107698:	6a 00                	push   $0x0
  pushl $237
8010769a:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010769f:	e9 18 f0 ff ff       	jmp    801066bc <alltraps>

801076a4 <vector238>:
.globl vector238
vector238:
  pushl $0
801076a4:	6a 00                	push   $0x0
  pushl $238
801076a6:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801076ab:	e9 0c f0 ff ff       	jmp    801066bc <alltraps>

801076b0 <vector239>:
.globl vector239
vector239:
  pushl $0
801076b0:	6a 00                	push   $0x0
  pushl $239
801076b2:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801076b7:	e9 00 f0 ff ff       	jmp    801066bc <alltraps>

801076bc <vector240>:
.globl vector240
vector240:
  pushl $0
801076bc:	6a 00                	push   $0x0
  pushl $240
801076be:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801076c3:	e9 f4 ef ff ff       	jmp    801066bc <alltraps>

801076c8 <vector241>:
.globl vector241
vector241:
  pushl $0
801076c8:	6a 00                	push   $0x0
  pushl $241
801076ca:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801076cf:	e9 e8 ef ff ff       	jmp    801066bc <alltraps>

801076d4 <vector242>:
.globl vector242
vector242:
  pushl $0
801076d4:	6a 00                	push   $0x0
  pushl $242
801076d6:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801076db:	e9 dc ef ff ff       	jmp    801066bc <alltraps>

801076e0 <vector243>:
.globl vector243
vector243:
  pushl $0
801076e0:	6a 00                	push   $0x0
  pushl $243
801076e2:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801076e7:	e9 d0 ef ff ff       	jmp    801066bc <alltraps>

801076ec <vector244>:
.globl vector244
vector244:
  pushl $0
801076ec:	6a 00                	push   $0x0
  pushl $244
801076ee:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801076f3:	e9 c4 ef ff ff       	jmp    801066bc <alltraps>

801076f8 <vector245>:
.globl vector245
vector245:
  pushl $0
801076f8:	6a 00                	push   $0x0
  pushl $245
801076fa:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801076ff:	e9 b8 ef ff ff       	jmp    801066bc <alltraps>

80107704 <vector246>:
.globl vector246
vector246:
  pushl $0
80107704:	6a 00                	push   $0x0
  pushl $246
80107706:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010770b:	e9 ac ef ff ff       	jmp    801066bc <alltraps>

80107710 <vector247>:
.globl vector247
vector247:
  pushl $0
80107710:	6a 00                	push   $0x0
  pushl $247
80107712:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107717:	e9 a0 ef ff ff       	jmp    801066bc <alltraps>

8010771c <vector248>:
.globl vector248
vector248:
  pushl $0
8010771c:	6a 00                	push   $0x0
  pushl $248
8010771e:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107723:	e9 94 ef ff ff       	jmp    801066bc <alltraps>

80107728 <vector249>:
.globl vector249
vector249:
  pushl $0
80107728:	6a 00                	push   $0x0
  pushl $249
8010772a:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010772f:	e9 88 ef ff ff       	jmp    801066bc <alltraps>

80107734 <vector250>:
.globl vector250
vector250:
  pushl $0
80107734:	6a 00                	push   $0x0
  pushl $250
80107736:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
8010773b:	e9 7c ef ff ff       	jmp    801066bc <alltraps>

80107740 <vector251>:
.globl vector251
vector251:
  pushl $0
80107740:	6a 00                	push   $0x0
  pushl $251
80107742:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107747:	e9 70 ef ff ff       	jmp    801066bc <alltraps>

8010774c <vector252>:
.globl vector252
vector252:
  pushl $0
8010774c:	6a 00                	push   $0x0
  pushl $252
8010774e:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107753:	e9 64 ef ff ff       	jmp    801066bc <alltraps>

80107758 <vector253>:
.globl vector253
vector253:
  pushl $0
80107758:	6a 00                	push   $0x0
  pushl $253
8010775a:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010775f:	e9 58 ef ff ff       	jmp    801066bc <alltraps>

80107764 <vector254>:
.globl vector254
vector254:
  pushl $0
80107764:	6a 00                	push   $0x0
  pushl $254
80107766:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
8010776b:	e9 4c ef ff ff       	jmp    801066bc <alltraps>

80107770 <vector255>:
.globl vector255
vector255:
  pushl $0
80107770:	6a 00                	push   $0x0
  pushl $255
80107772:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107777:	e9 40 ef ff ff       	jmp    801066bc <alltraps>

8010777c <lgdt>:
{
8010777c:	55                   	push   %ebp
8010777d:	89 e5                	mov    %esp,%ebp
8010777f:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80107782:	8b 45 0c             	mov    0xc(%ebp),%eax
80107785:	83 e8 01             	sub    $0x1,%eax
80107788:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010778c:	8b 45 08             	mov    0x8(%ebp),%eax
8010778f:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107793:	8b 45 08             	mov    0x8(%ebp),%eax
80107796:	c1 e8 10             	shr    $0x10,%eax
80107799:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010779d:	8d 45 fa             	lea    -0x6(%ebp),%eax
801077a0:	0f 01 10             	lgdtl  (%eax)
}
801077a3:	c9                   	leave  
801077a4:	c3                   	ret    

801077a5 <ltr>:
{
801077a5:	55                   	push   %ebp
801077a6:	89 e5                	mov    %esp,%ebp
801077a8:	83 ec 04             	sub    $0x4,%esp
801077ab:	8b 45 08             	mov    0x8(%ebp),%eax
801077ae:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
801077b2:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801077b6:	0f 00 d8             	ltr    %ax
}
801077b9:	c9                   	leave  
801077ba:	c3                   	ret    

801077bb <lcr3>:

static inline void
lcr3(uint val)
{
801077bb:	55                   	push   %ebp
801077bc:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
801077be:	8b 45 08             	mov    0x8(%ebp),%eax
801077c1:	0f 22 d8             	mov    %eax,%cr3
}
801077c4:	5d                   	pop    %ebp
801077c5:	c3                   	ret    

801077c6 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
801077c6:	55                   	push   %ebp
801077c7:	89 e5                	mov    %esp,%ebp
801077c9:	83 ec 28             	sub    $0x28,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
801077cc:	e8 f9 c8 ff ff       	call   801040ca <cpuid>
801077d1:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801077d7:	05 40 38 11 80       	add    $0x80113840,%eax
801077dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801077df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077e2:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
801077e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077eb:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
801077f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077f4:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
801077f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077fb:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801077ff:	83 e2 f0             	and    $0xfffffff0,%edx
80107802:	83 ca 0a             	or     $0xa,%edx
80107805:	88 50 7d             	mov    %dl,0x7d(%eax)
80107808:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010780b:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010780f:	83 ca 10             	or     $0x10,%edx
80107812:	88 50 7d             	mov    %dl,0x7d(%eax)
80107815:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107818:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010781c:	83 e2 9f             	and    $0xffffff9f,%edx
8010781f:	88 50 7d             	mov    %dl,0x7d(%eax)
80107822:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107825:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107829:	83 ca 80             	or     $0xffffff80,%edx
8010782c:	88 50 7d             	mov    %dl,0x7d(%eax)
8010782f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107832:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107836:	83 ca 0f             	or     $0xf,%edx
80107839:	88 50 7e             	mov    %dl,0x7e(%eax)
8010783c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010783f:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107843:	83 e2 ef             	and    $0xffffffef,%edx
80107846:	88 50 7e             	mov    %dl,0x7e(%eax)
80107849:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010784c:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107850:	83 e2 df             	and    $0xffffffdf,%edx
80107853:	88 50 7e             	mov    %dl,0x7e(%eax)
80107856:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107859:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010785d:	83 ca 40             	or     $0x40,%edx
80107860:	88 50 7e             	mov    %dl,0x7e(%eax)
80107863:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107866:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010786a:	83 ca 80             	or     $0xffffff80,%edx
8010786d:	88 50 7e             	mov    %dl,0x7e(%eax)
80107870:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107873:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107877:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010787a:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107881:	ff ff 
80107883:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107886:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
8010788d:	00 00 
8010788f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107892:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107899:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010789c:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801078a3:	83 e2 f0             	and    $0xfffffff0,%edx
801078a6:	83 ca 02             	or     $0x2,%edx
801078a9:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801078af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078b2:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801078b9:	83 ca 10             	or     $0x10,%edx
801078bc:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801078c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078c5:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801078cc:	83 e2 9f             	and    $0xffffff9f,%edx
801078cf:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801078d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078d8:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801078df:	83 ca 80             	or     $0xffffff80,%edx
801078e2:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801078e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078eb:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801078f2:	83 ca 0f             	or     $0xf,%edx
801078f5:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801078fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078fe:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107905:	83 e2 ef             	and    $0xffffffef,%edx
80107908:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010790e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107911:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107918:	83 e2 df             	and    $0xffffffdf,%edx
8010791b:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107921:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107924:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010792b:	83 ca 40             	or     $0x40,%edx
8010792e:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107934:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107937:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010793e:	83 ca 80             	or     $0xffffff80,%edx
80107941:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107947:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010794a:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107951:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107954:	66 c7 80 88 00 00 00 	movw   $0xffff,0x88(%eax)
8010795b:	ff ff 
8010795d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107960:	66 c7 80 8a 00 00 00 	movw   $0x0,0x8a(%eax)
80107967:	00 00 
80107969:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010796c:	c6 80 8c 00 00 00 00 	movb   $0x0,0x8c(%eax)
80107973:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107976:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
8010797d:	83 e2 f0             	and    $0xfffffff0,%edx
80107980:	83 ca 0a             	or     $0xa,%edx
80107983:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107989:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010798c:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107993:	83 ca 10             	or     $0x10,%edx
80107996:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010799c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010799f:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801079a6:	83 ca 60             	or     $0x60,%edx
801079a9:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801079af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079b2:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801079b9:	83 ca 80             	or     $0xffffff80,%edx
801079bc:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801079c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079c5:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801079cc:	83 ca 0f             	or     $0xf,%edx
801079cf:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801079d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079d8:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801079df:	83 e2 ef             	and    $0xffffffef,%edx
801079e2:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801079e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079eb:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801079f2:	83 e2 df             	and    $0xffffffdf,%edx
801079f5:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801079fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079fe:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107a05:	83 ca 40             	or     $0x40,%edx
80107a08:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107a0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a11:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107a18:	83 ca 80             	or     $0xffffff80,%edx
80107a1b:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a24:	c6 80 8f 00 00 00 00 	movb   $0x0,0x8f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a2e:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107a35:	ff ff 
80107a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a3a:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107a41:	00 00 
80107a43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a46:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a50:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107a57:	83 e2 f0             	and    $0xfffffff0,%edx
80107a5a:	83 ca 02             	or     $0x2,%edx
80107a5d:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a66:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107a6d:	83 ca 10             	or     $0x10,%edx
80107a70:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107a76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a79:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107a80:	83 ca 60             	or     $0x60,%edx
80107a83:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a8c:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107a93:	83 ca 80             	or     $0xffffff80,%edx
80107a96:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107a9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a9f:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107aa6:	83 ca 0f             	or     $0xf,%edx
80107aa9:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ab2:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107ab9:	83 e2 ef             	and    $0xffffffef,%edx
80107abc:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ac5:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107acc:	83 e2 df             	and    $0xffffffdf,%edx
80107acf:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ad8:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107adf:	83 ca 40             	or     $0x40,%edx
80107ae2:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107aeb:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107af2:	83 ca 80             	or     $0xffffff80,%edx
80107af5:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107afe:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
80107b05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b08:	83 c0 70             	add    $0x70,%eax
80107b0b:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
80107b12:	00 
80107b13:	89 04 24             	mov    %eax,(%esp)
80107b16:	e8 61 fc ff ff       	call   8010777c <lgdt>
}
80107b1b:	c9                   	leave  
80107b1c:	c3                   	ret    

80107b1d <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107b1d:	55                   	push   %ebp
80107b1e:	89 e5                	mov    %esp,%ebp
80107b20:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107b23:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b26:	c1 e8 16             	shr    $0x16,%eax
80107b29:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107b30:	8b 45 08             	mov    0x8(%ebp),%eax
80107b33:	01 d0                	add    %edx,%eax
80107b35:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80107b38:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b3b:	8b 00                	mov    (%eax),%eax
80107b3d:	83 e0 01             	and    $0x1,%eax
80107b40:	85 c0                	test   %eax,%eax
80107b42:	74 14                	je     80107b58 <walkpgdir+0x3b>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107b44:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b47:	8b 00                	mov    (%eax),%eax
80107b49:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107b4e:	05 00 00 00 80       	add    $0x80000000,%eax
80107b53:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107b56:	eb 48                	jmp    80107ba0 <walkpgdir+0x83>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107b58:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80107b5c:	74 0e                	je     80107b6c <walkpgdir+0x4f>
80107b5e:	e8 46 b0 ff ff       	call   80102ba9 <kalloc>
80107b63:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107b66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107b6a:	75 07                	jne    80107b73 <walkpgdir+0x56>
      return 0;
80107b6c:	b8 00 00 00 00       	mov    $0x0,%eax
80107b71:	eb 44                	jmp    80107bb7 <walkpgdir+0x9a>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80107b73:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107b7a:	00 
80107b7b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107b82:	00 
80107b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b86:	89 04 24             	mov    %eax,(%esp)
80107b89:	e8 31 d7 ff ff       	call   801052bf <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107b8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b91:	05 00 00 00 80       	add    $0x80000000,%eax
80107b96:	83 c8 07             	or     $0x7,%eax
80107b99:	89 c2                	mov    %eax,%edx
80107b9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b9e:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80107ba0:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ba3:	c1 e8 0c             	shr    $0xc,%eax
80107ba6:	25 ff 03 00 00       	and    $0x3ff,%eax
80107bab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bb5:	01 d0                	add    %edx,%eax
}
80107bb7:	c9                   	leave  
80107bb8:	c3                   	ret    

80107bb9 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107bb9:	55                   	push   %ebp
80107bba:	89 e5                	mov    %esp,%ebp
80107bbc:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107bbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80107bc2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107bc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107bca:	8b 55 0c             	mov    0xc(%ebp),%edx
80107bcd:	8b 45 10             	mov    0x10(%ebp),%eax
80107bd0:	01 d0                	add    %edx,%eax
80107bd2:	83 e8 01             	sub    $0x1,%eax
80107bd5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107bda:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107bdd:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80107be4:	00 
80107be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107be8:	89 44 24 04          	mov    %eax,0x4(%esp)
80107bec:	8b 45 08             	mov    0x8(%ebp),%eax
80107bef:	89 04 24             	mov    %eax,(%esp)
80107bf2:	e8 26 ff ff ff       	call   80107b1d <walkpgdir>
80107bf7:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107bfa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107bfe:	75 07                	jne    80107c07 <mappages+0x4e>
      return -1;
80107c00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107c05:	eb 48                	jmp    80107c4f <mappages+0x96>
    if(*pte & PTE_P)
80107c07:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107c0a:	8b 00                	mov    (%eax),%eax
80107c0c:	83 e0 01             	and    $0x1,%eax
80107c0f:	85 c0                	test   %eax,%eax
80107c11:	74 0c                	je     80107c1f <mappages+0x66>
      panic("remap");
80107c13:	c7 04 24 30 8b 10 80 	movl   $0x80108b30,(%esp)
80107c1a:	e8 43 89 ff ff       	call   80100562 <panic>
    *pte = pa | perm | PTE_P;
80107c1f:	8b 45 18             	mov    0x18(%ebp),%eax
80107c22:	0b 45 14             	or     0x14(%ebp),%eax
80107c25:	83 c8 01             	or     $0x1,%eax
80107c28:	89 c2                	mov    %eax,%edx
80107c2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107c2d:	89 10                	mov    %edx,(%eax)
    if(a == last)
80107c2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c32:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107c35:	75 08                	jne    80107c3f <mappages+0x86>
      break;
80107c37:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80107c38:	b8 00 00 00 00       	mov    $0x0,%eax
80107c3d:	eb 10                	jmp    80107c4f <mappages+0x96>
    a += PGSIZE;
80107c3f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80107c46:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80107c4d:	eb 8e                	jmp    80107bdd <mappages+0x24>
}
80107c4f:	c9                   	leave  
80107c50:	c3                   	ret    

80107c51 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107c51:	55                   	push   %ebp
80107c52:	89 e5                	mov    %esp,%ebp
80107c54:	53                   	push   %ebx
80107c55:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107c58:	e8 4c af ff ff       	call   80102ba9 <kalloc>
80107c5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107c60:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107c64:	75 0a                	jne    80107c70 <setupkvm+0x1f>
    return 0;
80107c66:	b8 00 00 00 00       	mov    $0x0,%eax
80107c6b:	e9 84 00 00 00       	jmp    80107cf4 <setupkvm+0xa3>
  memset(pgdir, 0, PGSIZE);
80107c70:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107c77:	00 
80107c78:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107c7f:	00 
80107c80:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107c83:	89 04 24             	mov    %eax,(%esp)
80107c86:	e8 34 d6 ff ff       	call   801052bf <memset>
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107c8b:	c7 45 f4 c0 b4 10 80 	movl   $0x8010b4c0,-0xc(%ebp)
80107c92:	eb 54                	jmp    80107ce8 <setupkvm+0x97>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c97:	8b 48 0c             	mov    0xc(%eax),%ecx
80107c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c9d:	8b 50 04             	mov    0x4(%eax),%edx
80107ca0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ca3:	8b 58 08             	mov    0x8(%eax),%ebx
80107ca6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ca9:	8b 40 04             	mov    0x4(%eax),%eax
80107cac:	29 c3                	sub    %eax,%ebx
80107cae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cb1:	8b 00                	mov    (%eax),%eax
80107cb3:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80107cb7:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107cbb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80107cbf:	89 44 24 04          	mov    %eax,0x4(%esp)
80107cc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107cc6:	89 04 24             	mov    %eax,(%esp)
80107cc9:	e8 eb fe ff ff       	call   80107bb9 <mappages>
80107cce:	85 c0                	test   %eax,%eax
80107cd0:	79 12                	jns    80107ce4 <setupkvm+0x93>
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80107cd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107cd5:	89 04 24             	mov    %eax,(%esp)
80107cd8:	e8 26 05 00 00       	call   80108203 <freevm>
      return 0;
80107cdd:	b8 00 00 00 00       	mov    $0x0,%eax
80107ce2:	eb 10                	jmp    80107cf4 <setupkvm+0xa3>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107ce4:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80107ce8:	81 7d f4 00 b5 10 80 	cmpl   $0x8010b500,-0xc(%ebp)
80107cef:	72 a3                	jb     80107c94 <setupkvm+0x43>
    }
  return pgdir;
80107cf1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107cf4:	83 c4 34             	add    $0x34,%esp
80107cf7:	5b                   	pop    %ebx
80107cf8:	5d                   	pop    %ebp
80107cf9:	c3                   	ret    

80107cfa <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107cfa:	55                   	push   %ebp
80107cfb:	89 e5                	mov    %esp,%ebp
80107cfd:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107d00:	e8 4c ff ff ff       	call   80107c51 <setupkvm>
80107d05:	a3 64 67 11 80       	mov    %eax,0x80116764
  switchkvm();
80107d0a:	e8 02 00 00 00       	call   80107d11 <switchkvm>
}
80107d0f:	c9                   	leave  
80107d10:	c3                   	ret    

80107d11 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107d11:	55                   	push   %ebp
80107d12:	89 e5                	mov    %esp,%ebp
80107d14:	83 ec 04             	sub    $0x4,%esp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107d17:	a1 64 67 11 80       	mov    0x80116764,%eax
80107d1c:	05 00 00 00 80       	add    $0x80000000,%eax
80107d21:	89 04 24             	mov    %eax,(%esp)
80107d24:	e8 92 fa ff ff       	call   801077bb <lcr3>
}
80107d29:	c9                   	leave  
80107d2a:	c3                   	ret    

80107d2b <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107d2b:	55                   	push   %ebp
80107d2c:	89 e5                	mov    %esp,%ebp
80107d2e:	57                   	push   %edi
80107d2f:	56                   	push   %esi
80107d30:	53                   	push   %ebx
80107d31:	83 ec 1c             	sub    $0x1c,%esp
  if(p == 0)
80107d34:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80107d38:	75 0c                	jne    80107d46 <switchuvm+0x1b>
    panic("switchuvm: no process");
80107d3a:	c7 04 24 36 8b 10 80 	movl   $0x80108b36,(%esp)
80107d41:	e8 1c 88 ff ff       	call   80100562 <panic>
  if(p->kstack == 0)
80107d46:	8b 45 08             	mov    0x8(%ebp),%eax
80107d49:	8b 40 08             	mov    0x8(%eax),%eax
80107d4c:	85 c0                	test   %eax,%eax
80107d4e:	75 0c                	jne    80107d5c <switchuvm+0x31>
    panic("switchuvm: no kstack");
80107d50:	c7 04 24 4c 8b 10 80 	movl   $0x80108b4c,(%esp)
80107d57:	e8 06 88 ff ff       	call   80100562 <panic>
  if(p->pgdir == 0)
80107d5c:	8b 45 08             	mov    0x8(%ebp),%eax
80107d5f:	8b 40 04             	mov    0x4(%eax),%eax
80107d62:	85 c0                	test   %eax,%eax
80107d64:	75 0c                	jne    80107d72 <switchuvm+0x47>
    panic("switchuvm: no pgdir");
80107d66:	c7 04 24 61 8b 10 80 	movl   $0x80108b61,(%esp)
80107d6d:	e8 f0 87 ff ff       	call   80100562 <panic>

  pushcli();
80107d72:	e8 43 d4 ff ff       	call   801051ba <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107d77:	e8 6f c3 ff ff       	call   801040eb <mycpu>
80107d7c:	89 c3                	mov    %eax,%ebx
80107d7e:	e8 68 c3 ff ff       	call   801040eb <mycpu>
80107d83:	83 c0 08             	add    $0x8,%eax
80107d86:	89 c7                	mov    %eax,%edi
80107d88:	e8 5e c3 ff ff       	call   801040eb <mycpu>
80107d8d:	83 c0 08             	add    $0x8,%eax
80107d90:	c1 e8 10             	shr    $0x10,%eax
80107d93:	89 c6                	mov    %eax,%esi
80107d95:	e8 51 c3 ff ff       	call   801040eb <mycpu>
80107d9a:	83 c0 08             	add    $0x8,%eax
80107d9d:	c1 e8 18             	shr    $0x18,%eax
80107da0:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
80107da7:	67 00 
80107da9:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107db0:	89 f1                	mov    %esi,%ecx
80107db2:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107db8:	0f b6 93 9d 00 00 00 	movzbl 0x9d(%ebx),%edx
80107dbf:	83 e2 f0             	and    $0xfffffff0,%edx
80107dc2:	83 ca 09             	or     $0x9,%edx
80107dc5:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80107dcb:	0f b6 93 9d 00 00 00 	movzbl 0x9d(%ebx),%edx
80107dd2:	83 ca 10             	or     $0x10,%edx
80107dd5:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80107ddb:	0f b6 93 9d 00 00 00 	movzbl 0x9d(%ebx),%edx
80107de2:	83 e2 9f             	and    $0xffffff9f,%edx
80107de5:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80107deb:	0f b6 93 9d 00 00 00 	movzbl 0x9d(%ebx),%edx
80107df2:	83 ca 80             	or     $0xffffff80,%edx
80107df5:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80107dfb:	0f b6 93 9e 00 00 00 	movzbl 0x9e(%ebx),%edx
80107e02:	83 e2 f0             	and    $0xfffffff0,%edx
80107e05:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80107e0b:	0f b6 93 9e 00 00 00 	movzbl 0x9e(%ebx),%edx
80107e12:	83 e2 ef             	and    $0xffffffef,%edx
80107e15:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80107e1b:	0f b6 93 9e 00 00 00 	movzbl 0x9e(%ebx),%edx
80107e22:	83 e2 df             	and    $0xffffffdf,%edx
80107e25:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80107e2b:	0f b6 93 9e 00 00 00 	movzbl 0x9e(%ebx),%edx
80107e32:	83 ca 40             	or     $0x40,%edx
80107e35:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80107e3b:	0f b6 93 9e 00 00 00 	movzbl 0x9e(%ebx),%edx
80107e42:	83 e2 7f             	and    $0x7f,%edx
80107e45:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80107e4b:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80107e51:	e8 95 c2 ff ff       	call   801040eb <mycpu>
80107e56:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107e5d:	83 e2 ef             	and    $0xffffffef,%edx
80107e60:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107e66:	e8 80 c2 ff ff       	call   801040eb <mycpu>
80107e6b:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107e71:	e8 75 c2 ff ff       	call   801040eb <mycpu>
80107e76:	8b 55 08             	mov    0x8(%ebp),%edx
80107e79:	8b 52 08             	mov    0x8(%edx),%edx
80107e7c:	81 c2 00 10 00 00    	add    $0x1000,%edx
80107e82:	89 50 0c             	mov    %edx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107e85:	e8 61 c2 ff ff       	call   801040eb <mycpu>
80107e8a:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  ltr(SEG_TSS << 3);
80107e90:	c7 04 24 28 00 00 00 	movl   $0x28,(%esp)
80107e97:	e8 09 f9 ff ff       	call   801077a5 <ltr>
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107e9c:	8b 45 08             	mov    0x8(%ebp),%eax
80107e9f:	8b 40 04             	mov    0x4(%eax),%eax
80107ea2:	05 00 00 00 80       	add    $0x80000000,%eax
80107ea7:	89 04 24             	mov    %eax,(%esp)
80107eaa:	e8 0c f9 ff ff       	call   801077bb <lcr3>
  popcli();
80107eaf:	e8 52 d3 ff ff       	call   80105206 <popcli>
}
80107eb4:	83 c4 1c             	add    $0x1c,%esp
80107eb7:	5b                   	pop    %ebx
80107eb8:	5e                   	pop    %esi
80107eb9:	5f                   	pop    %edi
80107eba:	5d                   	pop    %ebp
80107ebb:	c3                   	ret    

80107ebc <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107ebc:	55                   	push   %ebp
80107ebd:	89 e5                	mov    %esp,%ebp
80107ebf:	83 ec 38             	sub    $0x38,%esp
  char *mem;

  if(sz >= PGSIZE)
80107ec2:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80107ec9:	76 0c                	jbe    80107ed7 <inituvm+0x1b>
    panic("inituvm: more than a page");
80107ecb:	c7 04 24 75 8b 10 80 	movl   $0x80108b75,(%esp)
80107ed2:	e8 8b 86 ff ff       	call   80100562 <panic>
  mem = kalloc();
80107ed7:	e8 cd ac ff ff       	call   80102ba9 <kalloc>
80107edc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80107edf:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107ee6:	00 
80107ee7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107eee:	00 
80107eef:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ef2:	89 04 24             	mov    %eax,(%esp)
80107ef5:	e8 c5 d3 ff ff       	call   801052bf <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107efd:	05 00 00 00 80       	add    $0x80000000,%eax
80107f02:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80107f09:	00 
80107f0a:	89 44 24 0c          	mov    %eax,0xc(%esp)
80107f0e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107f15:	00 
80107f16:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107f1d:	00 
80107f1e:	8b 45 08             	mov    0x8(%ebp),%eax
80107f21:	89 04 24             	mov    %eax,(%esp)
80107f24:	e8 90 fc ff ff       	call   80107bb9 <mappages>
  memmove(mem, init, sz);
80107f29:	8b 45 10             	mov    0x10(%ebp),%eax
80107f2c:	89 44 24 08          	mov    %eax,0x8(%esp)
80107f30:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f33:	89 44 24 04          	mov    %eax,0x4(%esp)
80107f37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f3a:	89 04 24             	mov    %eax,(%esp)
80107f3d:	e8 4c d4 ff ff       	call   8010538e <memmove>
}
80107f42:	c9                   	leave  
80107f43:	c3                   	ret    

80107f44 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107f44:	55                   	push   %ebp
80107f45:	89 e5                	mov    %esp,%ebp
80107f47:	83 ec 28             	sub    $0x28,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107f4a:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f4d:	25 ff 0f 00 00       	and    $0xfff,%eax
80107f52:	85 c0                	test   %eax,%eax
80107f54:	74 0c                	je     80107f62 <loaduvm+0x1e>
    panic("loaduvm: addr must be page aligned");
80107f56:	c7 04 24 90 8b 10 80 	movl   $0x80108b90,(%esp)
80107f5d:	e8 00 86 ff ff       	call   80100562 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80107f62:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107f69:	e9 a6 00 00 00       	jmp    80108014 <loaduvm+0xd0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107f6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f71:	8b 55 0c             	mov    0xc(%ebp),%edx
80107f74:	01 d0                	add    %edx,%eax
80107f76:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107f7d:	00 
80107f7e:	89 44 24 04          	mov    %eax,0x4(%esp)
80107f82:	8b 45 08             	mov    0x8(%ebp),%eax
80107f85:	89 04 24             	mov    %eax,(%esp)
80107f88:	e8 90 fb ff ff       	call   80107b1d <walkpgdir>
80107f8d:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107f90:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107f94:	75 0c                	jne    80107fa2 <loaduvm+0x5e>
      panic("loaduvm: address should exist");
80107f96:	c7 04 24 b3 8b 10 80 	movl   $0x80108bb3,(%esp)
80107f9d:	e8 c0 85 ff ff       	call   80100562 <panic>
    pa = PTE_ADDR(*pte);
80107fa2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107fa5:	8b 00                	mov    (%eax),%eax
80107fa7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107fac:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80107faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fb2:	8b 55 18             	mov    0x18(%ebp),%edx
80107fb5:	29 c2                	sub    %eax,%edx
80107fb7:	89 d0                	mov    %edx,%eax
80107fb9:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80107fbe:	77 0f                	ja     80107fcf <loaduvm+0x8b>
      n = sz - i;
80107fc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fc3:	8b 55 18             	mov    0x18(%ebp),%edx
80107fc6:	29 c2                	sub    %eax,%edx
80107fc8:	89 d0                	mov    %edx,%eax
80107fca:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107fcd:	eb 07                	jmp    80107fd6 <loaduvm+0x92>
    else
      n = PGSIZE;
80107fcf:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107fd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fd9:	8b 55 14             	mov    0x14(%ebp),%edx
80107fdc:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80107fdf:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107fe2:	05 00 00 00 80       	add    $0x80000000,%eax
80107fe7:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107fea:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107fee:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80107ff2:	89 44 24 04          	mov    %eax,0x4(%esp)
80107ff6:	8b 45 10             	mov    0x10(%ebp),%eax
80107ff9:	89 04 24             	mov    %eax,(%esp)
80107ffc:	e8 f9 9d ff ff       	call   80101dfa <readi>
80108001:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108004:	74 07                	je     8010800d <loaduvm+0xc9>
      return -1;
80108006:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010800b:	eb 18                	jmp    80108025 <loaduvm+0xe1>
  for(i = 0; i < sz; i += PGSIZE){
8010800d:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108014:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108017:	3b 45 18             	cmp    0x18(%ebp),%eax
8010801a:	0f 82 4e ff ff ff    	jb     80107f6e <loaduvm+0x2a>
  }
  return 0;
80108020:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108025:	c9                   	leave  
80108026:	c3                   	ret    

80108027 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108027:	55                   	push   %ebp
80108028:	89 e5                	mov    %esp,%ebp
8010802a:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
8010802d:	8b 45 10             	mov    0x10(%ebp),%eax
80108030:	85 c0                	test   %eax,%eax
80108032:	79 0a                	jns    8010803e <allocuvm+0x17>
    return 0;
80108034:	b8 00 00 00 00       	mov    $0x0,%eax
80108039:	e9 fd 00 00 00       	jmp    8010813b <allocuvm+0x114>
  if(newsz < oldsz)
8010803e:	8b 45 10             	mov    0x10(%ebp),%eax
80108041:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108044:	73 08                	jae    8010804e <allocuvm+0x27>
    return oldsz;
80108046:	8b 45 0c             	mov    0xc(%ebp),%eax
80108049:	e9 ed 00 00 00       	jmp    8010813b <allocuvm+0x114>

  a = PGROUNDUP(oldsz);
8010804e:	8b 45 0c             	mov    0xc(%ebp),%eax
80108051:	05 ff 0f 00 00       	add    $0xfff,%eax
80108056:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010805b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
8010805e:	e9 c9 00 00 00       	jmp    8010812c <allocuvm+0x105>
    mem = kalloc();
80108063:	e8 41 ab ff ff       	call   80102ba9 <kalloc>
80108068:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
8010806b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010806f:	75 2f                	jne    801080a0 <allocuvm+0x79>
      cprintf("allocuvm out of memory\n");
80108071:	c7 04 24 d1 8b 10 80 	movl   $0x80108bd1,(%esp)
80108078:	e8 4b 83 ff ff       	call   801003c8 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
8010807d:	8b 45 0c             	mov    0xc(%ebp),%eax
80108080:	89 44 24 08          	mov    %eax,0x8(%esp)
80108084:	8b 45 10             	mov    0x10(%ebp),%eax
80108087:	89 44 24 04          	mov    %eax,0x4(%esp)
8010808b:	8b 45 08             	mov    0x8(%ebp),%eax
8010808e:	89 04 24             	mov    %eax,(%esp)
80108091:	e8 a7 00 00 00       	call   8010813d <deallocuvm>
      return 0;
80108096:	b8 00 00 00 00       	mov    $0x0,%eax
8010809b:	e9 9b 00 00 00       	jmp    8010813b <allocuvm+0x114>
    }
    memset(mem, 0, PGSIZE);
801080a0:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801080a7:	00 
801080a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801080af:	00 
801080b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080b3:	89 04 24             	mov    %eax,(%esp)
801080b6:	e8 04 d2 ff ff       	call   801052bf <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801080bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080be:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801080c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080c7:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
801080ce:	00 
801080cf:	89 54 24 0c          	mov    %edx,0xc(%esp)
801080d3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801080da:	00 
801080db:	89 44 24 04          	mov    %eax,0x4(%esp)
801080df:	8b 45 08             	mov    0x8(%ebp),%eax
801080e2:	89 04 24             	mov    %eax,(%esp)
801080e5:	e8 cf fa ff ff       	call   80107bb9 <mappages>
801080ea:	85 c0                	test   %eax,%eax
801080ec:	79 37                	jns    80108125 <allocuvm+0xfe>
      cprintf("allocuvm out of memory (2)\n");
801080ee:	c7 04 24 e9 8b 10 80 	movl   $0x80108be9,(%esp)
801080f5:	e8 ce 82 ff ff       	call   801003c8 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801080fa:	8b 45 0c             	mov    0xc(%ebp),%eax
801080fd:	89 44 24 08          	mov    %eax,0x8(%esp)
80108101:	8b 45 10             	mov    0x10(%ebp),%eax
80108104:	89 44 24 04          	mov    %eax,0x4(%esp)
80108108:	8b 45 08             	mov    0x8(%ebp),%eax
8010810b:	89 04 24             	mov    %eax,(%esp)
8010810e:	e8 2a 00 00 00       	call   8010813d <deallocuvm>
      kfree(mem);
80108113:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108116:	89 04 24             	mov    %eax,(%esp)
80108119:	e8 f5 a9 ff ff       	call   80102b13 <kfree>
      return 0;
8010811e:	b8 00 00 00 00       	mov    $0x0,%eax
80108123:	eb 16                	jmp    8010813b <allocuvm+0x114>
  for(; a < newsz; a += PGSIZE){
80108125:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010812c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010812f:	3b 45 10             	cmp    0x10(%ebp),%eax
80108132:	0f 82 2b ff ff ff    	jb     80108063 <allocuvm+0x3c>
    }
  }
  return newsz;
80108138:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010813b:	c9                   	leave  
8010813c:	c3                   	ret    

8010813d <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010813d:	55                   	push   %ebp
8010813e:	89 e5                	mov    %esp,%ebp
80108140:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80108143:	8b 45 10             	mov    0x10(%ebp),%eax
80108146:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108149:	72 08                	jb     80108153 <deallocuvm+0x16>
    return oldsz;
8010814b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010814e:	e9 ae 00 00 00       	jmp    80108201 <deallocuvm+0xc4>

  a = PGROUNDUP(newsz);
80108153:	8b 45 10             	mov    0x10(%ebp),%eax
80108156:	05 ff 0f 00 00       	add    $0xfff,%eax
8010815b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108160:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80108163:	e9 8a 00 00 00       	jmp    801081f2 <deallocuvm+0xb5>
    pte = walkpgdir(pgdir, (char*)a, 0);
80108168:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010816b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108172:	00 
80108173:	89 44 24 04          	mov    %eax,0x4(%esp)
80108177:	8b 45 08             	mov    0x8(%ebp),%eax
8010817a:	89 04 24             	mov    %eax,(%esp)
8010817d:	e8 9b f9 ff ff       	call   80107b1d <walkpgdir>
80108182:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80108185:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108189:	75 16                	jne    801081a1 <deallocuvm+0x64>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010818b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010818e:	c1 e8 16             	shr    $0x16,%eax
80108191:	83 c0 01             	add    $0x1,%eax
80108194:	c1 e0 16             	shl    $0x16,%eax
80108197:	2d 00 10 00 00       	sub    $0x1000,%eax
8010819c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010819f:	eb 4a                	jmp    801081eb <deallocuvm+0xae>
    else if((*pte & PTE_P) != 0){
801081a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081a4:	8b 00                	mov    (%eax),%eax
801081a6:	83 e0 01             	and    $0x1,%eax
801081a9:	85 c0                	test   %eax,%eax
801081ab:	74 3e                	je     801081eb <deallocuvm+0xae>
      pa = PTE_ADDR(*pte);
801081ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081b0:	8b 00                	mov    (%eax),%eax
801081b2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801081b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
801081ba:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801081be:	75 0c                	jne    801081cc <deallocuvm+0x8f>
        panic("kfree");
801081c0:	c7 04 24 05 8c 10 80 	movl   $0x80108c05,(%esp)
801081c7:	e8 96 83 ff ff       	call   80100562 <panic>
      char *v = P2V(pa);
801081cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801081cf:	05 00 00 00 80       	add    $0x80000000,%eax
801081d4:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
801081d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
801081da:	89 04 24             	mov    %eax,(%esp)
801081dd:	e8 31 a9 ff ff       	call   80102b13 <kfree>
      *pte = 0;
801081e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
801081eb:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801081f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081f5:	3b 45 0c             	cmp    0xc(%ebp),%eax
801081f8:	0f 82 6a ff ff ff    	jb     80108168 <deallocuvm+0x2b>
    }
  }
  return newsz;
801081fe:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108201:	c9                   	leave  
80108202:	c3                   	ret    

80108203 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108203:	55                   	push   %ebp
80108204:	89 e5                	mov    %esp,%ebp
80108206:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
80108209:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010820d:	75 0c                	jne    8010821b <freevm+0x18>
    panic("freevm: no pgdir");
8010820f:	c7 04 24 0b 8c 10 80 	movl   $0x80108c0b,(%esp)
80108216:	e8 47 83 ff ff       	call   80100562 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
8010821b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108222:	00 
80108223:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
8010822a:	80 
8010822b:	8b 45 08             	mov    0x8(%ebp),%eax
8010822e:	89 04 24             	mov    %eax,(%esp)
80108231:	e8 07 ff ff ff       	call   8010813d <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
80108236:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010823d:	eb 45                	jmp    80108284 <freevm+0x81>
    if(pgdir[i] & PTE_P){
8010823f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108242:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108249:	8b 45 08             	mov    0x8(%ebp),%eax
8010824c:	01 d0                	add    %edx,%eax
8010824e:	8b 00                	mov    (%eax),%eax
80108250:	83 e0 01             	and    $0x1,%eax
80108253:	85 c0                	test   %eax,%eax
80108255:	74 29                	je     80108280 <freevm+0x7d>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80108257:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010825a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108261:	8b 45 08             	mov    0x8(%ebp),%eax
80108264:	01 d0                	add    %edx,%eax
80108266:	8b 00                	mov    (%eax),%eax
80108268:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010826d:	05 00 00 00 80       	add    $0x80000000,%eax
80108272:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80108275:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108278:	89 04 24             	mov    %eax,(%esp)
8010827b:	e8 93 a8 ff ff       	call   80102b13 <kfree>
  for(i = 0; i < NPDENTRIES; i++){
80108280:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108284:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
8010828b:	76 b2                	jbe    8010823f <freevm+0x3c>
    }
  }
  kfree((char*)pgdir);
8010828d:	8b 45 08             	mov    0x8(%ebp),%eax
80108290:	89 04 24             	mov    %eax,(%esp)
80108293:	e8 7b a8 ff ff       	call   80102b13 <kfree>
}
80108298:	c9                   	leave  
80108299:	c3                   	ret    

8010829a <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
8010829a:	55                   	push   %ebp
8010829b:	89 e5                	mov    %esp,%ebp
8010829d:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801082a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801082a7:	00 
801082a8:	8b 45 0c             	mov    0xc(%ebp),%eax
801082ab:	89 44 24 04          	mov    %eax,0x4(%esp)
801082af:	8b 45 08             	mov    0x8(%ebp),%eax
801082b2:	89 04 24             	mov    %eax,(%esp)
801082b5:	e8 63 f8 ff ff       	call   80107b1d <walkpgdir>
801082ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
801082bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801082c1:	75 0c                	jne    801082cf <clearpteu+0x35>
    panic("clearpteu");
801082c3:	c7 04 24 1c 8c 10 80 	movl   $0x80108c1c,(%esp)
801082ca:	e8 93 82 ff ff       	call   80100562 <panic>
  *pte &= ~PTE_U;
801082cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082d2:	8b 00                	mov    (%eax),%eax
801082d4:	83 e0 fb             	and    $0xfffffffb,%eax
801082d7:	89 c2                	mov    %eax,%edx
801082d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082dc:	89 10                	mov    %edx,(%eax)
}
801082de:	c9                   	leave  
801082df:	c3                   	ret    

801082e0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801082e0:	55                   	push   %ebp
801082e1:	89 e5                	mov    %esp,%ebp
801082e3:	83 ec 48             	sub    $0x48,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801082e6:	e8 66 f9 ff ff       	call   80107c51 <setupkvm>
801082eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
801082ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801082f2:	75 0a                	jne    801082fe <copyuvm+0x1e>
    return 0;
801082f4:	b8 00 00 00 00       	mov    $0x0,%eax
801082f9:	e9 03 01 00 00       	jmp    80108401 <copyuvm+0x121>
  for(i = 0; i < sz; i += PGSIZE){
801082fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108305:	e9 d6 00 00 00       	jmp    801083e0 <copyuvm+0x100>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
8010830a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010830d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108314:	00 
80108315:	89 44 24 04          	mov    %eax,0x4(%esp)
80108319:	8b 45 08             	mov    0x8(%ebp),%eax
8010831c:	89 04 24             	mov    %eax,(%esp)
8010831f:	e8 f9 f7 ff ff       	call   80107b1d <walkpgdir>
80108324:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108327:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010832b:	75 0c                	jne    80108339 <copyuvm+0x59>
      panic("copyuvm: pte should exist");
8010832d:	c7 04 24 26 8c 10 80 	movl   $0x80108c26,(%esp)
80108334:	e8 29 82 ff ff       	call   80100562 <panic>
    if(!(*pte & PTE_P))
80108339:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010833c:	8b 00                	mov    (%eax),%eax
8010833e:	83 e0 01             	and    $0x1,%eax
80108341:	85 c0                	test   %eax,%eax
80108343:	75 0c                	jne    80108351 <copyuvm+0x71>
      panic("copyuvm: page not present");
80108345:	c7 04 24 40 8c 10 80 	movl   $0x80108c40,(%esp)
8010834c:	e8 11 82 ff ff       	call   80100562 <panic>
    pa = PTE_ADDR(*pte);
80108351:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108354:	8b 00                	mov    (%eax),%eax
80108356:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010835b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
8010835e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108361:	8b 00                	mov    (%eax),%eax
80108363:	25 ff 0f 00 00       	and    $0xfff,%eax
80108368:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
8010836b:	e8 39 a8 ff ff       	call   80102ba9 <kalloc>
80108370:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108373:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80108377:	75 02                	jne    8010837b <copyuvm+0x9b>
      goto bad;
80108379:	eb 76                	jmp    801083f1 <copyuvm+0x111>
    memmove(mem, (char*)P2V(pa), PGSIZE);
8010837b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010837e:	05 00 00 00 80       	add    $0x80000000,%eax
80108383:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010838a:	00 
8010838b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010838f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108392:	89 04 24             	mov    %eax,(%esp)
80108395:	e8 f4 cf ff ff       	call   8010538e <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
8010839a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010839d:	8b 45 e0             	mov    -0x20(%ebp),%eax
801083a0:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
801083a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083a9:	89 54 24 10          	mov    %edx,0x10(%esp)
801083ad:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801083b1:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801083b8:	00 
801083b9:	89 44 24 04          	mov    %eax,0x4(%esp)
801083bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801083c0:	89 04 24             	mov    %eax,(%esp)
801083c3:	e8 f1 f7 ff ff       	call   80107bb9 <mappages>
801083c8:	85 c0                	test   %eax,%eax
801083ca:	79 0d                	jns    801083d9 <copyuvm+0xf9>
      kfree(mem);
801083cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
801083cf:	89 04 24             	mov    %eax,(%esp)
801083d2:	e8 3c a7 ff ff       	call   80102b13 <kfree>
      goto bad;
801083d7:	eb 18                	jmp    801083f1 <copyuvm+0x111>
  for(i = 0; i < sz; i += PGSIZE){
801083d9:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801083e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083e3:	3b 45 0c             	cmp    0xc(%ebp),%eax
801083e6:	0f 82 1e ff ff ff    	jb     8010830a <copyuvm+0x2a>
    }
  }
  return d;
801083ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
801083ef:	eb 10                	jmp    80108401 <copyuvm+0x121>

bad:
  freevm(d);
801083f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801083f4:	89 04 24             	mov    %eax,(%esp)
801083f7:	e8 07 fe ff ff       	call   80108203 <freevm>
  return 0;
801083fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108401:	c9                   	leave  
80108402:	c3                   	ret    

80108403 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108403:	55                   	push   %ebp
80108404:	89 e5                	mov    %esp,%ebp
80108406:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108409:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108410:	00 
80108411:	8b 45 0c             	mov    0xc(%ebp),%eax
80108414:	89 44 24 04          	mov    %eax,0x4(%esp)
80108418:	8b 45 08             	mov    0x8(%ebp),%eax
8010841b:	89 04 24             	mov    %eax,(%esp)
8010841e:	e8 fa f6 ff ff       	call   80107b1d <walkpgdir>
80108423:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108426:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108429:	8b 00                	mov    (%eax),%eax
8010842b:	83 e0 01             	and    $0x1,%eax
8010842e:	85 c0                	test   %eax,%eax
80108430:	75 07                	jne    80108439 <uva2ka+0x36>
    return 0;
80108432:	b8 00 00 00 00       	mov    $0x0,%eax
80108437:	eb 22                	jmp    8010845b <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
80108439:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010843c:	8b 00                	mov    (%eax),%eax
8010843e:	83 e0 04             	and    $0x4,%eax
80108441:	85 c0                	test   %eax,%eax
80108443:	75 07                	jne    8010844c <uva2ka+0x49>
    return 0;
80108445:	b8 00 00 00 00       	mov    $0x0,%eax
8010844a:	eb 0f                	jmp    8010845b <uva2ka+0x58>
  return (char*)P2V(PTE_ADDR(*pte));
8010844c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010844f:	8b 00                	mov    (%eax),%eax
80108451:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108456:	05 00 00 00 80       	add    $0x80000000,%eax
}
8010845b:	c9                   	leave  
8010845c:	c3                   	ret    

8010845d <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
8010845d:	55                   	push   %ebp
8010845e:	89 e5                	mov    %esp,%ebp
80108460:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108463:	8b 45 10             	mov    0x10(%ebp),%eax
80108466:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108469:	e9 87 00 00 00       	jmp    801084f5 <copyout+0x98>
    va0 = (uint)PGROUNDDOWN(va);
8010846e:	8b 45 0c             	mov    0xc(%ebp),%eax
80108471:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108476:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108479:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010847c:	89 44 24 04          	mov    %eax,0x4(%esp)
80108480:	8b 45 08             	mov    0x8(%ebp),%eax
80108483:	89 04 24             	mov    %eax,(%esp)
80108486:	e8 78 ff ff ff       	call   80108403 <uva2ka>
8010848b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
8010848e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108492:	75 07                	jne    8010849b <copyout+0x3e>
      return -1;
80108494:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108499:	eb 69                	jmp    80108504 <copyout+0xa7>
    n = PGSIZE - (va - va0);
8010849b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010849e:	8b 55 ec             	mov    -0x14(%ebp),%edx
801084a1:	29 c2                	sub    %eax,%edx
801084a3:	89 d0                	mov    %edx,%eax
801084a5:	05 00 10 00 00       	add    $0x1000,%eax
801084aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
801084ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801084b0:	3b 45 14             	cmp    0x14(%ebp),%eax
801084b3:	76 06                	jbe    801084bb <copyout+0x5e>
      n = len;
801084b5:	8b 45 14             	mov    0x14(%ebp),%eax
801084b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
801084bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084be:	8b 55 0c             	mov    0xc(%ebp),%edx
801084c1:	29 c2                	sub    %eax,%edx
801084c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
801084c6:	01 c2                	add    %eax,%edx
801084c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801084cb:	89 44 24 08          	mov    %eax,0x8(%esp)
801084cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084d2:	89 44 24 04          	mov    %eax,0x4(%esp)
801084d6:	89 14 24             	mov    %edx,(%esp)
801084d9:	e8 b0 ce ff ff       	call   8010538e <memmove>
    len -= n;
801084de:	8b 45 f0             	mov    -0x10(%ebp),%eax
801084e1:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
801084e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801084e7:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
801084ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084ed:	05 00 10 00 00       	add    $0x1000,%eax
801084f2:	89 45 0c             	mov    %eax,0xc(%ebp)
  while(len > 0){
801084f5:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801084f9:	0f 85 6f ff ff ff    	jne    8010846e <copyout+0x11>
  }
  return 0;
801084ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108504:	c9                   	leave  
80108505:	c3                   	ret    
