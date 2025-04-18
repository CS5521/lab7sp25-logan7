
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
8010003a:	c7 44 24 04 34 85 10 	movl   $0x80108534,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 80 c6 10 80 	movl   $0x8010c680,(%esp)
80100049:	e8 0c 50 00 00       	call   8010505a <initlock>

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
80100087:	c7 44 24 04 3b 85 10 	movl   $0x8010853b,0x4(%esp)
8010008e:	80 
8010008f:	89 04 24             	mov    %eax,(%esp)
80100092:	e8 60 4e 00 00       	call   80104ef7 <initsleeplock>
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
801000c9:	e8 ad 4f 00 00       	call   8010507b <acquire>

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
80100104:	e8 da 4f 00 00       	call   801050e3 <release>
      acquiresleep(&b->lock);
80100109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010c:	83 c0 0c             	add    $0xc,%eax
8010010f:	89 04 24             	mov    %eax,(%esp)
80100112:	e8 1a 4e 00 00       	call   80104f31 <acquiresleep>
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
8010017d:	e8 61 4f 00 00       	call   801050e3 <release>
      acquiresleep(&b->lock);
80100182:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100185:	83 c0 0c             	add    $0xc,%eax
80100188:	89 04 24             	mov    %eax,(%esp)
8010018b:	e8 a1 4d 00 00       	call   80104f31 <acquiresleep>
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
801001a7:	c7 04 24 42 85 10 80 	movl   $0x80108542,(%esp)
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
801001fb:	e8 ce 4d 00 00       	call   80104fce <holdingsleep>
80100200:	85 c0                	test   %eax,%eax
80100202:	75 0c                	jne    80100210 <bwrite+0x24>
    panic("bwrite");
80100204:	c7 04 24 53 85 10 80 	movl   $0x80108553,(%esp)
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
8010023b:	e8 8e 4d 00 00       	call   80104fce <holdingsleep>
80100240:	85 c0                	test   %eax,%eax
80100242:	75 0c                	jne    80100250 <brelse+0x24>
    panic("brelse");
80100244:	c7 04 24 5a 85 10 80 	movl   $0x8010855a,(%esp)
8010024b:	e8 12 03 00 00       	call   80100562 <panic>

  releasesleep(&b->lock);
80100250:	8b 45 08             	mov    0x8(%ebp),%eax
80100253:	83 c0 0c             	add    $0xc,%eax
80100256:	89 04 24             	mov    %eax,(%esp)
80100259:	e8 2e 4d 00 00       	call   80104f8c <releasesleep>

  acquire(&bcache.lock);
8010025e:	c7 04 24 80 c6 10 80 	movl   $0x8010c680,(%esp)
80100265:	e8 11 4e 00 00       	call   8010507b <acquire>
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
801002d1:	e8 0d 4e 00 00       	call   801050e3 <release>
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
801003e3:	e8 93 4c 00 00       	call   8010507b <acquire>

  if (fmt == 0)
801003e8:	8b 45 08             	mov    0x8(%ebp),%eax
801003eb:	85 c0                	test   %eax,%eax
801003ed:	75 0c                	jne    801003fb <cprintf+0x33>
    panic("null fmt");
801003ef:	c7 04 24 61 85 10 80 	movl   $0x80108561,(%esp)
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
801004d8:	c7 45 ec 6a 85 10 80 	movl   $0x8010856a,-0x14(%ebp)
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
8010055b:	e8 83 4b 00 00       	call   801050e3 <release>
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
80100580:	c7 04 24 71 85 10 80 	movl   $0x80108571,(%esp)
80100587:	e8 3c fe ff ff       	call   801003c8 <cprintf>
  cprintf(s);
8010058c:	8b 45 08             	mov    0x8(%ebp),%eax
8010058f:	89 04 24             	mov    %eax,(%esp)
80100592:	e8 31 fe ff ff       	call   801003c8 <cprintf>
  cprintf("\n");
80100597:	c7 04 24 85 85 10 80 	movl   $0x80108585,(%esp)
8010059e:	e8 25 fe ff ff       	call   801003c8 <cprintf>
  getcallerpcs(&s, pcs);
801005a3:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005a6:	89 44 24 04          	mov    %eax,0x4(%esp)
801005aa:	8d 45 08             	lea    0x8(%ebp),%eax
801005ad:	89 04 24             	mov    %eax,(%esp)
801005b0:	e8 79 4b 00 00       	call   8010512e <getcallerpcs>
  for(i=0; i<10; i++)
801005b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005bc:	eb 1b                	jmp    801005d9 <panic+0x77>
    cprintf(" %p", pcs[i]);
801005be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005c1:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005c5:	89 44 24 04          	mov    %eax,0x4(%esp)
801005c9:	c7 04 24 87 85 10 80 	movl   $0x80108587,(%esp)
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
801006ba:	c7 04 24 8b 85 10 80 	movl   $0x8010858b,(%esp)
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
801006ee:	e8 c9 4c 00 00       	call   801053bc <memmove>
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
8010071d:	e8 cb 4b 00 00       	call   801052ed <memset>
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
801007b2:	e8 cb 64 00 00       	call   80106c82 <uartputc>
801007b7:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801007be:	e8 bf 64 00 00       	call   80106c82 <uartputc>
801007c3:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801007ca:	e8 b3 64 00 00       	call   80106c82 <uartputc>
801007cf:	eb 0b                	jmp    801007dc <consputc+0x50>
  } else
    uartputc(c);
801007d1:	8b 45 08             	mov    0x8(%ebp),%eax
801007d4:	89 04 24             	mov    %eax,(%esp)
801007d7:	e8 a6 64 00 00       	call   80106c82 <uartputc>
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
801007fd:	e8 79 48 00 00       	call   8010507b <acquire>
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
80100938:	e8 43 42 00 00       	call   80104b80 <wakeup>
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
80100959:	e8 85 47 00 00       	call   801050e3 <release>
  if(doprocdump) {
8010095e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100962:	74 05                	je     80100969 <consoleintr+0x180>
    procdump();  // now call procdump() wo. cons.lock held
80100964:	e8 bd 42 00 00       	call   80104c26 <procdump>
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
80100989:	e8 ed 46 00 00       	call   8010507b <acquire>
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
801009a8:	e8 36 47 00 00       	call   801050e3 <release>
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
801009d1:	e8 d3 40 00 00       	call   80104aa9 <sleep>
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
80100a4d:	e8 91 46 00 00       	call   801050e3 <release>
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
80100a81:	e8 f5 45 00 00       	call   8010507b <acquire>
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
80100abb:	e8 23 46 00 00       	call   801050e3 <release>
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
80100ad6:	c7 44 24 04 9e 85 10 	movl   $0x8010859e,0x4(%esp)
80100add:	80 
80100ade:	c7 04 24 e0 b5 10 80 	movl   $0x8010b5e0,(%esp)
80100ae5:	e8 70 45 00 00       	call   8010505a <initlock>

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
80100b4d:	c7 04 24 a6 85 10 80 	movl   $0x801085a6,(%esp)
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
80100bb6:	e8 c4 70 00 00       	call   80107c7f <setupkvm>
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
80100c74:	e8 dc 73 00 00       	call   80108055 <allocuvm>
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
80100cc6:	e8 a7 72 00 00       	call   80107f72 <loaduvm>
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
80100d34:	e8 1c 73 00 00       	call   80108055 <allocuvm>
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
80100d59:	e8 6a 75 00 00       	call   801082c8 <clearpteu>
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
80100d8f:	e8 c3 47 00 00       	call   80105557 <strlen>
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
80100db8:	e8 9a 47 00 00       	call   80105557 <strlen>
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
80100de8:	e8 9e 76 00 00       	call   8010848b <copyout>
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
80100e8f:	e8 f7 75 00 00       	call   8010848b <copyout>
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
80100ee4:	e8 24 46 00 00       	call   8010550d <safestrcpy>

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
80100f24:	e8 30 6e 00 00       	call   80107d59 <switchuvm>
  freevm(oldpgdir);
80100f29:	8b 45 cc             	mov    -0x34(%ebp),%eax
80100f2c:	89 04 24             	mov    %eax,(%esp)
80100f2f:	e8 fd 72 00 00       	call   80108231 <freevm>
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
80100f47:	e8 e5 72 00 00       	call   80108231 <freevm>
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
80100f6f:	c7 44 24 04 b2 85 10 	movl   $0x801085b2,0x4(%esp)
80100f76:	80 
80100f77:	c7 04 24 80 10 11 80 	movl   $0x80111080,(%esp)
80100f7e:	e8 d7 40 00 00       	call   8010505a <initlock>
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
80100f92:	e8 e4 40 00 00       	call   8010507b <acquire>
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
80100fbb:	e8 23 41 00 00       	call   801050e3 <release>
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
80100fd9:	e8 05 41 00 00       	call   801050e3 <release>
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
80100ff2:	e8 84 40 00 00       	call   8010507b <acquire>
  if(f->ref < 1)
80100ff7:	8b 45 08             	mov    0x8(%ebp),%eax
80100ffa:	8b 40 04             	mov    0x4(%eax),%eax
80100ffd:	85 c0                	test   %eax,%eax
80100fff:	7f 0c                	jg     8010100d <filedup+0x28>
    panic("filedup");
80101001:	c7 04 24 b9 85 10 80 	movl   $0x801085b9,(%esp)
80101008:	e8 55 f5 ff ff       	call   80100562 <panic>
  f->ref++;
8010100d:	8b 45 08             	mov    0x8(%ebp),%eax
80101010:	8b 40 04             	mov    0x4(%eax),%eax
80101013:	8d 50 01             	lea    0x1(%eax),%edx
80101016:	8b 45 08             	mov    0x8(%ebp),%eax
80101019:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
8010101c:	c7 04 24 80 10 11 80 	movl   $0x80111080,(%esp)
80101023:	e8 bb 40 00 00       	call   801050e3 <release>
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
8010103a:	e8 3c 40 00 00       	call   8010507b <acquire>
  if(f->ref < 1)
8010103f:	8b 45 08             	mov    0x8(%ebp),%eax
80101042:	8b 40 04             	mov    0x4(%eax),%eax
80101045:	85 c0                	test   %eax,%eax
80101047:	7f 0c                	jg     80101055 <fileclose+0x28>
    panic("fileclose");
80101049:	c7 04 24 c1 85 10 80 	movl   $0x801085c1,(%esp)
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
80101075:	e8 69 40 00 00       	call   801050e3 <release>
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
801010bf:	e8 1f 40 00 00       	call   801050e3 <release>

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
80101200:	c7 04 24 cb 85 10 80 	movl   $0x801085cb,(%esp)
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
8010130c:	c7 04 24 d4 85 10 80 	movl   $0x801085d4,(%esp)
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
8010133e:	c7 04 24 e4 85 10 80 	movl   $0x801085e4,(%esp)
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
80101384:	e8 33 40 00 00       	call   801053bc <memmove>
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
801013ca:	e8 1e 3f 00 00       	call   801052ed <memset>
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
80101517:	c7 04 24 f0 85 10 80 	movl   $0x801085f0,(%esp)
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
801015a6:	c7 04 24 06 86 10 80 	movl   $0x80108606,(%esp)
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
80101600:	c7 44 24 04 19 86 10 	movl   $0x80108619,0x4(%esp)
80101607:	80 
80101608:	c7 04 24 a0 1a 11 80 	movl   $0x80111aa0,(%esp)
8010160f:	e8 46 3a 00 00       	call   8010505a <initlock>
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
80101635:	c7 44 24 04 20 86 10 	movl   $0x80108620,0x4(%esp)
8010163c:	80 
8010163d:	89 04 24             	mov    %eax,(%esp)
80101640:	e8 b2 38 00 00       	call   80104ef7 <initsleeplock>
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
801016af:	c7 04 24 28 86 10 80 	movl   $0x80108628,(%esp)
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
80101732:	e8 b6 3b 00 00       	call   801052ed <memset>
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
8010178a:	c7 04 24 7b 86 10 80 	movl   $0x8010867b,(%esp)
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
80101839:	e8 7e 3b 00 00       	call   801053bc <memmove>
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
80101863:	e8 13 38 00 00       	call   8010507b <acquire>

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
801018ad:	e8 31 38 00 00       	call   801050e3 <release>
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
801018e3:	c7 04 24 8d 86 10 80 	movl   $0x8010868d,(%esp)
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
80101921:	e8 bd 37 00 00       	call   801050e3 <release>

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
80101938:	e8 3e 37 00 00       	call   8010507b <acquire>
  ip->ref++;
8010193d:	8b 45 08             	mov    0x8(%ebp),%eax
80101940:	8b 40 08             	mov    0x8(%eax),%eax
80101943:	8d 50 01             	lea    0x1(%eax),%edx
80101946:	8b 45 08             	mov    0x8(%ebp),%eax
80101949:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
8010194c:	c7 04 24 a0 1a 11 80 	movl   $0x80111aa0,(%esp)
80101953:	e8 8b 37 00 00       	call   801050e3 <release>
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
80101973:	c7 04 24 9d 86 10 80 	movl   $0x8010869d,(%esp)
8010197a:	e8 e3 eb ff ff       	call   80100562 <panic>

  acquiresleep(&ip->lock);
8010197f:	8b 45 08             	mov    0x8(%ebp),%eax
80101982:	83 c0 0c             	add    $0xc,%eax
80101985:	89 04 24             	mov    %eax,(%esp)
80101988:	e8 a4 35 00 00       	call   80104f31 <acquiresleep>

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
80101a36:	e8 81 39 00 00       	call   801053bc <memmove>
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
80101a5c:	c7 04 24 a3 86 10 80 	movl   $0x801086a3,(%esp)
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
80101a7f:	e8 4a 35 00 00       	call   80104fce <holdingsleep>
80101a84:	85 c0                	test   %eax,%eax
80101a86:	74 0a                	je     80101a92 <iunlock+0x28>
80101a88:	8b 45 08             	mov    0x8(%ebp),%eax
80101a8b:	8b 40 08             	mov    0x8(%eax),%eax
80101a8e:	85 c0                	test   %eax,%eax
80101a90:	7f 0c                	jg     80101a9e <iunlock+0x34>
    panic("iunlock");
80101a92:	c7 04 24 b2 86 10 80 	movl   $0x801086b2,(%esp)
80101a99:	e8 c4 ea ff ff       	call   80100562 <panic>

  releasesleep(&ip->lock);
80101a9e:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa1:	83 c0 0c             	add    $0xc,%eax
80101aa4:	89 04 24             	mov    %eax,(%esp)
80101aa7:	e8 e0 34 00 00       	call   80104f8c <releasesleep>
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
80101abd:	e8 6f 34 00 00       	call   80104f31 <acquiresleep>
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
80101adf:	e8 97 35 00 00       	call   8010507b <acquire>
    int r = ip->ref;
80101ae4:	8b 45 08             	mov    0x8(%ebp),%eax
80101ae7:	8b 40 08             	mov    0x8(%eax),%eax
80101aea:	89 45 f4             	mov    %eax,-0xc(%ebp)
    release(&icache.lock);
80101aed:	c7 04 24 a0 1a 11 80 	movl   $0x80111aa0,(%esp)
80101af4:	e8 ea 35 00 00       	call   801050e3 <release>
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
80101b31:	e8 56 34 00 00       	call   80104f8c <releasesleep>

  acquire(&icache.lock);
80101b36:	c7 04 24 a0 1a 11 80 	movl   $0x80111aa0,(%esp)
80101b3d:	e8 39 35 00 00       	call   8010507b <acquire>
  ip->ref--;
80101b42:	8b 45 08             	mov    0x8(%ebp),%eax
80101b45:	8b 40 08             	mov    0x8(%eax),%eax
80101b48:	8d 50 ff             	lea    -0x1(%eax),%edx
80101b4b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b4e:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101b51:	c7 04 24 a0 1a 11 80 	movl   $0x80111aa0,(%esp)
80101b58:	e8 86 35 00 00       	call   801050e3 <release>
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
80101c7e:	c7 04 24 ba 86 10 80 	movl   $0x801086ba,(%esp)
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
80101f2b:	e8 8c 34 00 00       	call   801053bc <memmove>
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
8010208a:	e8 2d 33 00 00       	call   801053bc <memmove>
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
80102108:	e8 52 33 00 00       	call   8010545f <strncmp>
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
80102122:	c7 04 24 cd 86 10 80 	movl   $0x801086cd,(%esp)
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
80102160:	c7 04 24 df 86 10 80 	movl   $0x801086df,(%esp)
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
80102245:	c7 04 24 ee 86 10 80 	movl   $0x801086ee,(%esp)
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
8010228a:	e8 26 32 00 00       	call   801054b5 <strncpy>
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
801022bc:	c7 04 24 fb 86 10 80 	movl   $0x801086fb,(%esp)
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
80102341:	e8 76 30 00 00       	call   801053bc <memmove>
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
8010235c:	e8 5b 30 00 00       	call   801053bc <memmove>
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
801025aa:	c7 44 24 04 03 87 10 	movl   $0x80108703,0x4(%esp)
801025b1:	80 
801025b2:	c7 04 24 20 b6 10 80 	movl   $0x8010b620,(%esp)
801025b9:	e8 9c 2a 00 00       	call   8010505a <initlock>
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
8010264a:	c7 04 24 07 87 10 80 	movl   $0x80108707,(%esp)
80102651:	e8 0c df ff ff       	call   80100562 <panic>
  if(b->blockno >= FSSIZE)
80102656:	8b 45 08             	mov    0x8(%ebp),%eax
80102659:	8b 40 08             	mov    0x8(%eax),%eax
8010265c:	3d e7 03 00 00       	cmp    $0x3e7,%eax
80102661:	76 0c                	jbe    8010266f <idestart+0x31>
    panic("incorrect blockno");
80102663:	c7 04 24 10 87 10 80 	movl   $0x80108710,(%esp)
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
801026b5:	c7 04 24 07 87 10 80 	movl   $0x80108707,(%esp)
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
801027d5:	e8 a1 28 00 00       	call   8010507b <acquire>

  if((b = idequeue) == 0){
801027da:	a1 54 b6 10 80       	mov    0x8010b654,%eax
801027df:	89 45 f4             	mov    %eax,-0xc(%ebp)
801027e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801027e6:	75 11                	jne    801027f9 <ideintr+0x31>
    release(&idelock);
801027e8:	c7 04 24 20 b6 10 80 	movl   $0x8010b620,(%esp)
801027ef:	e8 ef 28 00 00       	call   801050e3 <release>
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
80102862:	e8 19 23 00 00       	call   80104b80 <wakeup>

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
80102884:	e8 5a 28 00 00       	call   801050e3 <release>
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
8010289a:	e8 2f 27 00 00       	call   80104fce <holdingsleep>
8010289f:	85 c0                	test   %eax,%eax
801028a1:	75 0c                	jne    801028af <iderw+0x24>
    panic("iderw: buf not locked");
801028a3:	c7 04 24 22 87 10 80 	movl   $0x80108722,(%esp)
801028aa:	e8 b3 dc ff ff       	call   80100562 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801028af:	8b 45 08             	mov    0x8(%ebp),%eax
801028b2:	8b 00                	mov    (%eax),%eax
801028b4:	83 e0 06             	and    $0x6,%eax
801028b7:	83 f8 02             	cmp    $0x2,%eax
801028ba:	75 0c                	jne    801028c8 <iderw+0x3d>
    panic("iderw: nothing to do");
801028bc:	c7 04 24 38 87 10 80 	movl   $0x80108738,(%esp)
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
801028db:	c7 04 24 4d 87 10 80 	movl   $0x8010874d,(%esp)
801028e2:	e8 7b dc ff ff       	call   80100562 <panic>

  acquire(&idelock);  //DOC:acquire-lock
801028e7:	c7 04 24 20 b6 10 80 	movl   $0x8010b620,(%esp)
801028ee:	e8 88 27 00 00       	call   8010507b <acquire>

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
80102949:	e8 5b 21 00 00       	call   80104aa9 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010294e:	8b 45 08             	mov    0x8(%ebp),%eax
80102951:	8b 00                	mov    (%eax),%eax
80102953:	83 e0 06             	and    $0x6,%eax
80102956:	83 f8 02             	cmp    $0x2,%eax
80102959:	75 e0                	jne    8010293b <iderw+0xb0>
  }


  release(&idelock);
8010295b:	c7 04 24 20 b6 10 80 	movl   $0x8010b620,(%esp)
80102962:	e8 7c 27 00 00       	call   801050e3 <release>
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
801029e2:	c7 04 24 6c 87 10 80 	movl   $0x8010876c,(%esp)
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
80102a84:	c7 44 24 04 9e 87 10 	movl   $0x8010879e,0x4(%esp)
80102a8b:	80 
80102a8c:	c7 04 24 00 37 11 80 	movl   $0x80113700,(%esp)
80102a93:	e8 c2 25 00 00       	call   8010505a <initlock>
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
80102b3d:	c7 04 24 a3 87 10 80 	movl   $0x801087a3,(%esp)
80102b44:	e8 19 da ff ff       	call   80100562 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102b49:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102b50:	00 
80102b51:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102b58:	00 
80102b59:	8b 45 08             	mov    0x8(%ebp),%eax
80102b5c:	89 04 24             	mov    %eax,(%esp)
80102b5f:	e8 89 27 00 00       	call   801052ed <memset>

  if(kmem.use_lock)
80102b64:	a1 34 37 11 80       	mov    0x80113734,%eax
80102b69:	85 c0                	test   %eax,%eax
80102b6b:	74 0c                	je     80102b79 <kfree+0x66>
    acquire(&kmem.lock);
80102b6d:	c7 04 24 00 37 11 80 	movl   $0x80113700,(%esp)
80102b74:	e8 02 25 00 00       	call   8010507b <acquire>
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
80102ba2:	e8 3c 25 00 00       	call   801050e3 <release>
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
80102bbf:	e8 b7 24 00 00       	call   8010507b <acquire>
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
80102bec:	e8 f2 24 00 00       	call   801050e3 <release>
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
80103189:	e8 d6 21 00 00       	call   80105364 <memcmp>
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
80103289:	c7 44 24 04 a9 87 10 	movl   $0x801087a9,0x4(%esp)
80103290:	80 
80103291:	c7 04 24 40 37 11 80 	movl   $0x80113740,(%esp)
80103298:	e8 bd 1d 00 00       	call   8010505a <initlock>
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
80103342:	e8 75 20 00 00       	call   801053bc <memmove>
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
80103494:	e8 e2 1b 00 00       	call   8010507b <acquire>
  while(1){
    if(log.committing){
80103499:	a1 80 37 11 80       	mov    0x80113780,%eax
8010349e:	85 c0                	test   %eax,%eax
801034a0:	74 16                	je     801034b8 <begin_op+0x31>
      sleep(&log, &log.lock);
801034a2:	c7 44 24 04 40 37 11 	movl   $0x80113740,0x4(%esp)
801034a9:	80 
801034aa:	c7 04 24 40 37 11 80 	movl   $0x80113740,(%esp)
801034b1:	e8 f3 15 00 00       	call   80104aa9 <sleep>
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
801034e5:	e8 bf 15 00 00       	call   80104aa9 <sleep>
801034ea:	eb 1b                	jmp    80103507 <begin_op+0x80>
    } else {
      log.outstanding += 1;
801034ec:	a1 7c 37 11 80       	mov    0x8011377c,%eax
801034f1:	83 c0 01             	add    $0x1,%eax
801034f4:	a3 7c 37 11 80       	mov    %eax,0x8011377c
      release(&log.lock);
801034f9:	c7 04 24 40 37 11 80 	movl   $0x80113740,(%esp)
80103500:	e8 de 1b 00 00       	call   801050e3 <release>
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
8010351f:	e8 57 1b 00 00       	call   8010507b <acquire>
  log.outstanding -= 1;
80103524:	a1 7c 37 11 80       	mov    0x8011377c,%eax
80103529:	83 e8 01             	sub    $0x1,%eax
8010352c:	a3 7c 37 11 80       	mov    %eax,0x8011377c
  if(log.committing)
80103531:	a1 80 37 11 80       	mov    0x80113780,%eax
80103536:	85 c0                	test   %eax,%eax
80103538:	74 0c                	je     80103546 <end_op+0x3b>
    panic("log.committing");
8010353a:	c7 04 24 ad 87 10 80 	movl   $0x801087ad,(%esp)
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
80103569:	e8 12 16 00 00       	call   80104b80 <wakeup>
  }
  release(&log.lock);
8010356e:	c7 04 24 40 37 11 80 	movl   $0x80113740,(%esp)
80103575:	e8 69 1b 00 00       	call   801050e3 <release>

  if(do_commit){
8010357a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010357e:	74 33                	je     801035b3 <end_op+0xa8>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
80103580:	e8 de 00 00 00       	call   80103663 <commit>
    acquire(&log.lock);
80103585:	c7 04 24 40 37 11 80 	movl   $0x80113740,(%esp)
8010358c:	e8 ea 1a 00 00       	call   8010507b <acquire>
    log.committing = 0;
80103591:	c7 05 80 37 11 80 00 	movl   $0x0,0x80113780
80103598:	00 00 00 
    wakeup(&log);
8010359b:	c7 04 24 40 37 11 80 	movl   $0x80113740,(%esp)
801035a2:	e8 d9 15 00 00       	call   80104b80 <wakeup>
    release(&log.lock);
801035a7:	c7 04 24 40 37 11 80 	movl   $0x80113740,(%esp)
801035ae:	e8 30 1b 00 00       	call   801050e3 <release>
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
80103629:	e8 8e 1d 00 00       	call   801053bc <memmove>
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
801036b4:	c7 04 24 bc 87 10 80 	movl   $0x801087bc,(%esp)
801036bb:	e8 a2 ce ff ff       	call   80100562 <panic>
  if (log.outstanding < 1)
801036c0:	a1 7c 37 11 80       	mov    0x8011377c,%eax
801036c5:	85 c0                	test   %eax,%eax
801036c7:	7f 0c                	jg     801036d5 <log_write+0x43>
    panic("log_write outside of trans");
801036c9:	c7 04 24 d2 87 10 80 	movl   $0x801087d2,(%esp)
801036d0:	e8 8d ce ff ff       	call   80100562 <panic>

  acquire(&log.lock);
801036d5:	c7 04 24 40 37 11 80 	movl   $0x80113740,(%esp)
801036dc:	e8 9a 19 00 00       	call   8010507b <acquire>
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
80103753:	e8 8b 19 00 00       	call   801050e3 <release>
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
80103791:	e8 92 45 00 00       	call   80107d28 <kvmalloc>
  mpinit();        // detect other processors
80103796:	e8 cb 03 00 00       	call   80103b66 <mpinit>
  lapicinit();     // interrupt controller
8010379b:	e8 36 f6 ff ff       	call   80102dd6 <lapicinit>
  seginit();       // segment descriptors
801037a0:	e8 4f 40 00 00       	call   801077f4 <seginit>
  picinit();       // disable pic
801037a5:	e8 0b 05 00 00       	call   80103cb5 <picinit>
  ioapicinit();    // another interrupt controller
801037aa:	e8 eb f1 ff ff       	call   8010299a <ioapicinit>
  consoleinit();   // console hardware
801037af:	e8 1c d3 ff ff       	call   80100ad0 <consoleinit>
  uartinit();      // serial port
801037b4:	e8 c5 33 00 00       	call   80106b7e <uartinit>
  pinit();         // process table
801037b9:	e8 f0 08 00 00       	call   801040ae <pinit>
  tvinit();        // trap vectors
801037be:	e8 84 2f 00 00       	call   80106747 <tvinit>
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
801037fb:	e8 3f 45 00 00       	call   80107d3f <switchkvm>
  seginit();
80103800:	e8 ef 3f 00 00       	call   801077f4 <seginit>
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
8010382a:	c7 04 24 ed 87 10 80 	movl   $0x801087ed,(%esp)
80103831:	e8 92 cb ff ff       	call   801003c8 <cprintf>
  idtinit();       // load idt register
80103836:	e8 80 30 00 00       	call   801068bb <idtinit>
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
8010387e:	e8 39 1b 00 00       	call   801053bc <memmove>

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
801039bc:	c7 44 24 04 04 88 10 	movl   $0x80108804,0x4(%esp)
801039c3:	80 
801039c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039c7:	89 04 24             	mov    %eax,(%esp)
801039ca:	e8 95 19 00 00       	call   80105364 <memcmp>
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
80103afa:	c7 44 24 04 09 88 10 	movl   $0x80108809,0x4(%esp)
80103b01:	80 
80103b02:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b05:	89 04 24             	mov    %eax,(%esp)
80103b08:	e8 57 18 00 00       	call   80105364 <memcmp>
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
80103b80:	c7 04 24 0e 88 10 80 	movl   $0x8010880e,(%esp)
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
80103bc9:	8b 04 85 48 88 10 80 	mov    -0x7fef77b8(,%eax,4),%eax
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
80103c48:	c7 04 24 28 88 10 80 	movl   $0x80108828,(%esp)
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
80103d7d:	c7 44 24 04 5c 88 10 	movl   $0x8010885c,0x4(%esp)
80103d84:	80 
80103d85:	89 04 24             	mov    %eax,(%esp)
80103d88:	e8 cd 12 00 00       	call   8010505a <initlock>
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
80103e34:	e8 42 12 00 00       	call   8010507b <acquire>
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
80103e57:	e8 24 0d 00 00       	call   80104b80 <wakeup>
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
80103e76:	e8 05 0d 00 00       	call   80104b80 <wakeup>
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
80103e9b:	e8 43 12 00 00       	call   801050e3 <release>
    kfree((char*)p);
80103ea0:	8b 45 08             	mov    0x8(%ebp),%eax
80103ea3:	89 04 24             	mov    %eax,(%esp)
80103ea6:	e8 68 ec ff ff       	call   80102b13 <kfree>
80103eab:	eb 0b                	jmp    80103eb8 <pipeclose+0x90>
  } else
    release(&p->lock);
80103ead:	8b 45 08             	mov    0x8(%ebp),%eax
80103eb0:	89 04 24             	mov    %eax,(%esp)
80103eb3:	e8 2b 12 00 00       	call   801050e3 <release>
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
80103ec6:	e8 b0 11 00 00       	call   8010507b <acquire>
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
80103ef8:	e8 e6 11 00 00       	call   801050e3 <release>
        return -1;
80103efd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f02:	e9 9f 00 00 00       	jmp    80103fa6 <pipewrite+0xec>
      }
      wakeup(&p->nread);
80103f07:	8b 45 08             	mov    0x8(%ebp),%eax
80103f0a:	05 34 02 00 00       	add    $0x234,%eax
80103f0f:	89 04 24             	mov    %eax,(%esp)
80103f12:	e8 69 0c 00 00       	call   80104b80 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103f17:	8b 45 08             	mov    0x8(%ebp),%eax
80103f1a:	8b 55 08             	mov    0x8(%ebp),%edx
80103f1d:	81 c2 38 02 00 00    	add    $0x238,%edx
80103f23:	89 44 24 04          	mov    %eax,0x4(%esp)
80103f27:	89 14 24             	mov    %edx,(%esp)
80103f2a:	e8 7a 0b 00 00       	call   80104aa9 <sleep>
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
80103f93:	e8 e8 0b 00 00       	call   80104b80 <wakeup>
  release(&p->lock);
80103f98:	8b 45 08             	mov    0x8(%ebp),%eax
80103f9b:	89 04 24             	mov    %eax,(%esp)
80103f9e:	e8 40 11 00 00       	call   801050e3 <release>
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
80103fb5:	e8 c1 10 00 00       	call   8010507b <acquire>
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
80103fce:	e8 10 11 00 00       	call   801050e3 <release>
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
80103ff0:	e8 b4 0a 00 00       	call   80104aa9 <sleep>
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
8010407f:	e8 fc 0a 00 00       	call   80104b80 <wakeup>
  release(&p->lock);
80104084:	8b 45 08             	mov    0x8(%ebp),%eax
80104087:	89 04 24             	mov    %eax,(%esp)
8010408a:	e8 54 10 00 00       	call   801050e3 <release>
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
801040b4:	c7 44 24 04 64 88 10 	movl   $0x80108864,0x4(%esp)
801040bb:	80 
801040bc:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
801040c3:	e8 92 0f 00 00       	call   8010505a <initlock>
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
801040ff:	c7 04 24 6c 88 10 80 	movl   $0x8010886c,(%esp)
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
80104153:	c7 04 24 92 88 10 80 	movl   $0x80108892,(%esp)
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
80104167:	e8 7c 10 00 00       	call   801051e8 <pushcli>
  c = mycpu();
8010416c:	e8 7a ff ff ff       	call   801040eb <mycpu>
80104171:	89 45 f4             	mov    %eax,-0xc(%ebp)
  p = c->proc;
80104174:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104177:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010417d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  popcli();
80104180:	e8 af 10 00 00       	call   80105234 <popcli>
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
80104197:	e8 df 0e 00 00       	call   8010507b <acquire>

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
801041d5:	e8 09 0f 00 00       	call   801050e3 <release>

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
80104208:	e8 d6 0e 00 00       	call   801050e3 <release>
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
80104244:	ba 02 67 10 80       	mov    $0x80106702,%edx
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
80104274:	e8 74 10 00 00       	call   801052ed <memset>
  p->context->eip = (uint)forkret;
80104279:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010427c:	8b 40 1c             	mov    0x1c(%eax),%eax
8010427f:	ba 6a 4a 10 80       	mov    $0x80104a6a,%edx
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
801042a2:	e8 d8 39 00 00       	call   80107c7f <setupkvm>
801042a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042aa:	89 42 04             	mov    %eax,0x4(%edx)
801042ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042b0:	8b 40 04             	mov    0x4(%eax),%eax
801042b3:	85 c0                	test   %eax,%eax
801042b5:	75 0c                	jne    801042c3 <userinit+0x37>
    panic("userinit: out of memory?");
801042b7:	c7 04 24 a2 88 10 80 	movl   $0x801088a2,(%esp)
801042be:	e8 9f c2 ff ff       	call   80100562 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801042c3:	ba 2c 00 00 00       	mov    $0x2c,%edx
801042c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042cb:	8b 40 04             	mov    0x4(%eax),%eax
801042ce:	89 54 24 08          	mov    %edx,0x8(%esp)
801042d2:	c7 44 24 04 00 b5 10 	movl   $0x8010b500,0x4(%esp)
801042d9:	80 
801042da:	89 04 24             	mov    %eax,(%esp)
801042dd:	e8 08 3c 00 00       	call   80107eea <inituvm>
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
80104304:	e8 e4 0f 00 00       	call   801052ed <memset>
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
80104395:	c7 44 24 04 bb 88 10 	movl   $0x801088bb,0x4(%esp)
8010439c:	80 
8010439d:	89 04 24             	mov    %eax,(%esp)
801043a0:	e8 68 11 00 00       	call   8010550d <safestrcpy>
  p->cwd = namei("/");
801043a5:	c7 04 24 c4 88 10 80 	movl   $0x801088c4,(%esp)
801043ac:	e8 e6 e0 ff ff       	call   80102497 <namei>
801043b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801043b4:	89 42 68             	mov    %eax,0x68(%edx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
801043b7:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
801043be:	e8 b8 0c 00 00       	call   8010507b <acquire>

  p->state = RUNNABLE;
801043c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043c6:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
801043cd:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
801043d4:	e8 0a 0d 00 00       	call   801050e3 <release>
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
80104413:	e8 3d 3c 00 00       	call   80108055 <allocuvm>
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
8010444a:	e8 1c 3d 00 00       	call   8010816b <deallocuvm>
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
8010446d:	e8 e7 38 00 00       	call   80107d59 <switchuvm>
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
801044b4:	e8 55 3e 00 00       	call   8010830e <copyuvm>
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
801045a5:	e8 63 0f 00 00       	call   8010550d <safestrcpy>

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
801045ea:	e8 8c 0a 00 00       	call   8010507b <acquire>

  np->state = RUNNABLE;
801045ef:	8b 45 dc             	mov    -0x24(%ebp),%eax
801045f2:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)

  release(&ptable.lock);
801045f9:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
80104600:	e8 de 0a 00 00       	call   801050e3 <release>

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
80104628:	c7 04 24 c6 88 10 80 	movl   $0x801088c6,(%esp)
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
801046a7:	e8 cf 09 00 00       	call   8010507b <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
801046ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
801046af:	8b 40 14             	mov    0x14(%eax),%eax
801046b2:	89 04 24             	mov    %eax,(%esp)
801046b5:	e8 85 04 00 00       	call   80104b3f <wakeup1>

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
801046ed:	e8 4d 04 00 00       	call   80104b3f <wakeup1>
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
8010470c:	e8 79 02 00 00       	call   8010498a <sched>
  panic("zombie exit");
80104711:	c7 04 24 d3 88 10 80 	movl   $0x801088d3,(%esp)
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
80104732:	e8 44 09 00 00       	call   8010507b <acquire>
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
80104796:	e8 96 3a 00 00       	call   80108231 <freevm>
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
801047d1:	e8 0d 09 00 00       	call   801050e3 <release>
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
80104806:	e8 d8 08 00 00       	call   801050e3 <release>
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
80104820:	e8 84 02 00 00       	call   80104aa9 <sleep>
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
80104885:	e8 f1 07 00 00       	call   8010507b <acquire>
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
801048c6:	e8 18 08 00 00       	call   801050e3 <release>
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
801048e7:	eb 27                	jmp    80104910 <scheduler+0xc0>
      if(p->state != RUNNABLE)
801048e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048ec:	8b 40 0c             	mov    0xc(%eax),%eax
801048ef:	83 f8 03             	cmp    $0x3,%eax
801048f2:	74 02                	je     801048f6 <scheduler+0xa6>
          continue;
801048f4:	eb 13                	jmp    80104909 <scheduler+0xb9>
      counter = counter + p->tickets;
801048f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048f9:	8b 40 7c             	mov    0x7c(%eax),%eax
801048fc:	01 45 ec             	add    %eax,-0x14(%ebp)
      if(counter > winner)
801048ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104902:	3b 45 e0             	cmp    -0x20(%ebp),%eax
80104905:	7e 02                	jle    80104909 <scheduler+0xb9>
        break;
80104907:	eb 10                	jmp    80104919 <scheduler+0xc9>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104909:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104910:	81 7d f4 14 5f 11 80 	cmpl   $0x80115f14,-0xc(%ebp)
80104917:	72 d0                	jb     801048e9 <scheduler+0x99>
    c->proc = p;
80104919:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010491c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010491f:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
    switchuvm(p);
80104925:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104928:	89 04 24             	mov    %eax,(%esp)
8010492b:	e8 29 34 00 00       	call   80107d59 <switchuvm>
    p->state = RUNNING;
80104930:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104933:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
    p->ticks += 1;
8010493a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010493d:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104943:	8d 50 01             	lea    0x1(%eax),%edx
80104946:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104949:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
    swtch(&(c->scheduler), p->context);
8010494f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104952:	8b 40 1c             	mov    0x1c(%eax),%eax
80104955:	8b 55 e8             	mov    -0x18(%ebp),%edx
80104958:	83 c2 04             	add    $0x4,%edx
8010495b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010495f:	89 14 24             	mov    %edx,(%esp)
80104962:	e8 17 0c 00 00       	call   8010557e <swtch>
    switchkvm();
80104967:	e8 d3 33 00 00       	call   80107d3f <switchkvm>
    c->proc = 0;
8010496c:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010496f:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80104976:	00 00 00 
    release(&ptable.lock);
80104979:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
80104980:	e8 5e 07 00 00       	call   801050e3 <release>
  }
80104985:	e9 e1 fe ff ff       	jmp    8010486b <scheduler+0x1b>

8010498a <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
8010498a:	55                   	push   %ebp
8010498b:	89 e5                	mov    %esp,%ebp
8010498d:	83 ec 28             	sub    $0x28,%esp
  int intena;
  struct proc *p = myproc();
80104990:	e8 cc f7 ff ff       	call   80104161 <myproc>
80104995:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(!holding(&ptable.lock))
80104998:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
8010499f:	e8 03 08 00 00       	call   801051a7 <holding>
801049a4:	85 c0                	test   %eax,%eax
801049a6:	75 0c                	jne    801049b4 <sched+0x2a>
    panic("sched ptable.lock");
801049a8:	c7 04 24 df 88 10 80 	movl   $0x801088df,(%esp)
801049af:	e8 ae bb ff ff       	call   80100562 <panic>
  if(mycpu()->ncli != 1)
801049b4:	e8 32 f7 ff ff       	call   801040eb <mycpu>
801049b9:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801049bf:	83 f8 01             	cmp    $0x1,%eax
801049c2:	74 0c                	je     801049d0 <sched+0x46>
    panic("sched locks");
801049c4:	c7 04 24 f1 88 10 80 	movl   $0x801088f1,(%esp)
801049cb:	e8 92 bb ff ff       	call   80100562 <panic>
  if(p->state == RUNNING)
801049d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049d3:	8b 40 0c             	mov    0xc(%eax),%eax
801049d6:	83 f8 04             	cmp    $0x4,%eax
801049d9:	75 0c                	jne    801049e7 <sched+0x5d>
    panic("sched running");
801049db:	c7 04 24 fd 88 10 80 	movl   $0x801088fd,(%esp)
801049e2:	e8 7b bb ff ff       	call   80100562 <panic>
  if(readeflags()&FL_IF)
801049e7:	e8 ac f6 ff ff       	call   80104098 <readeflags>
801049ec:	25 00 02 00 00       	and    $0x200,%eax
801049f1:	85 c0                	test   %eax,%eax
801049f3:	74 0c                	je     80104a01 <sched+0x77>
    panic("sched interruptible");
801049f5:	c7 04 24 0b 89 10 80 	movl   $0x8010890b,(%esp)
801049fc:	e8 61 bb ff ff       	call   80100562 <panic>
  intena = mycpu()->intena;
80104a01:	e8 e5 f6 ff ff       	call   801040eb <mycpu>
80104a06:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104a0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  swtch(&p->context, mycpu()->scheduler);
80104a0f:	e8 d7 f6 ff ff       	call   801040eb <mycpu>
80104a14:	8b 40 04             	mov    0x4(%eax),%eax
80104a17:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104a1a:	83 c2 1c             	add    $0x1c,%edx
80104a1d:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a21:	89 14 24             	mov    %edx,(%esp)
80104a24:	e8 55 0b 00 00       	call   8010557e <swtch>
  mycpu()->intena = intena;
80104a29:	e8 bd f6 ff ff       	call   801040eb <mycpu>
80104a2e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104a31:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
}
80104a37:	c9                   	leave  
80104a38:	c3                   	ret    

80104a39 <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104a39:	55                   	push   %ebp
80104a3a:	89 e5                	mov    %esp,%ebp
80104a3c:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104a3f:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
80104a46:	e8 30 06 00 00       	call   8010507b <acquire>
  myproc()->state = RUNNABLE;
80104a4b:	e8 11 f7 ff ff       	call   80104161 <myproc>
80104a50:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104a57:	e8 2e ff ff ff       	call   8010498a <sched>
  release(&ptable.lock);
80104a5c:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
80104a63:	e8 7b 06 00 00       	call   801050e3 <release>
}
80104a68:	c9                   	leave  
80104a69:	c3                   	ret    

80104a6a <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104a6a:	55                   	push   %ebp
80104a6b:	89 e5                	mov    %esp,%ebp
80104a6d:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104a70:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
80104a77:	e8 67 06 00 00       	call   801050e3 <release>

  if (first) {
80104a7c:	a1 08 b0 10 80       	mov    0x8010b008,%eax
80104a81:	85 c0                	test   %eax,%eax
80104a83:	74 22                	je     80104aa7 <forkret+0x3d>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
80104a85:	c7 05 08 b0 10 80 00 	movl   $0x0,0x8010b008
80104a8c:	00 00 00 
    iinit(ROOTDEV);
80104a8f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104a96:	e8 55 cb ff ff       	call   801015f0 <iinit>
    initlog(ROOTDEV);
80104a9b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104aa2:	e8 dc e7 ff ff       	call   80103283 <initlog>
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104aa7:	c9                   	leave  
80104aa8:	c3                   	ret    

80104aa9 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104aa9:	55                   	push   %ebp
80104aaa:	89 e5                	mov    %esp,%ebp
80104aac:	83 ec 28             	sub    $0x28,%esp
  struct proc *p = myproc();
80104aaf:	e8 ad f6 ff ff       	call   80104161 <myproc>
80104ab4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  if(p == 0)
80104ab7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104abb:	75 0c                	jne    80104ac9 <sleep+0x20>
    panic("sleep");
80104abd:	c7 04 24 1f 89 10 80 	movl   $0x8010891f,(%esp)
80104ac4:	e8 99 ba ff ff       	call   80100562 <panic>

  if(lk == 0)
80104ac9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104acd:	75 0c                	jne    80104adb <sleep+0x32>
    panic("sleep without lk");
80104acf:	c7 04 24 25 89 10 80 	movl   $0x80108925,(%esp)
80104ad6:	e8 87 ba ff ff       	call   80100562 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104adb:	81 7d 0c e0 3d 11 80 	cmpl   $0x80113de0,0xc(%ebp)
80104ae2:	74 17                	je     80104afb <sleep+0x52>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104ae4:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
80104aeb:	e8 8b 05 00 00       	call   8010507b <acquire>
    release(lk);
80104af0:	8b 45 0c             	mov    0xc(%ebp),%eax
80104af3:	89 04 24             	mov    %eax,(%esp)
80104af6:	e8 e8 05 00 00       	call   801050e3 <release>
  }
  // Go to sleep.
  p->chan = chan;
80104afb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104afe:	8b 55 08             	mov    0x8(%ebp),%edx
80104b01:	89 50 20             	mov    %edx,0x20(%eax)
  p->state = SLEEPING;
80104b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b07:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

  sched();
80104b0e:	e8 77 fe ff ff       	call   8010498a <sched>

  // Tidy up.
  p->chan = 0;
80104b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b16:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104b1d:	81 7d 0c e0 3d 11 80 	cmpl   $0x80113de0,0xc(%ebp)
80104b24:	74 17                	je     80104b3d <sleep+0x94>
    release(&ptable.lock);
80104b26:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
80104b2d:	e8 b1 05 00 00       	call   801050e3 <release>
    acquire(lk);
80104b32:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b35:	89 04 24             	mov    %eax,(%esp)
80104b38:	e8 3e 05 00 00       	call   8010507b <acquire>
  }
}
80104b3d:	c9                   	leave  
80104b3e:	c3                   	ret    

80104b3f <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104b3f:	55                   	push   %ebp
80104b40:	89 e5                	mov    %esp,%ebp
80104b42:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104b45:	c7 45 fc 14 3e 11 80 	movl   $0x80113e14,-0x4(%ebp)
80104b4c:	eb 27                	jmp    80104b75 <wakeup1+0x36>
    if(p->state == SLEEPING && p->chan == chan)
80104b4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104b51:	8b 40 0c             	mov    0xc(%eax),%eax
80104b54:	83 f8 02             	cmp    $0x2,%eax
80104b57:	75 15                	jne    80104b6e <wakeup1+0x2f>
80104b59:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104b5c:	8b 40 20             	mov    0x20(%eax),%eax
80104b5f:	3b 45 08             	cmp    0x8(%ebp),%eax
80104b62:	75 0a                	jne    80104b6e <wakeup1+0x2f>
      p->state = RUNNABLE;
80104b64:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104b67:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104b6e:	81 45 fc 84 00 00 00 	addl   $0x84,-0x4(%ebp)
80104b75:	81 7d fc 14 5f 11 80 	cmpl   $0x80115f14,-0x4(%ebp)
80104b7c:	72 d0                	jb     80104b4e <wakeup1+0xf>
}
80104b7e:	c9                   	leave  
80104b7f:	c3                   	ret    

80104b80 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104b80:	55                   	push   %ebp
80104b81:	89 e5                	mov    %esp,%ebp
80104b83:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80104b86:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
80104b8d:	e8 e9 04 00 00       	call   8010507b <acquire>
  wakeup1(chan);
80104b92:	8b 45 08             	mov    0x8(%ebp),%eax
80104b95:	89 04 24             	mov    %eax,(%esp)
80104b98:	e8 a2 ff ff ff       	call   80104b3f <wakeup1>
  release(&ptable.lock);
80104b9d:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
80104ba4:	e8 3a 05 00 00       	call   801050e3 <release>
}
80104ba9:	c9                   	leave  
80104baa:	c3                   	ret    

80104bab <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104bab:	55                   	push   %ebp
80104bac:	89 e5                	mov    %esp,%ebp
80104bae:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104bb1:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
80104bb8:	e8 be 04 00 00       	call   8010507b <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bbd:	c7 45 f4 14 3e 11 80 	movl   $0x80113e14,-0xc(%ebp)
80104bc4:	eb 44                	jmp    80104c0a <kill+0x5f>
    if(p->pid == pid){
80104bc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bc9:	8b 40 10             	mov    0x10(%eax),%eax
80104bcc:	3b 45 08             	cmp    0x8(%ebp),%eax
80104bcf:	75 32                	jne    80104c03 <kill+0x58>
      p->killed = 1;
80104bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bd4:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104bdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bde:	8b 40 0c             	mov    0xc(%eax),%eax
80104be1:	83 f8 02             	cmp    $0x2,%eax
80104be4:	75 0a                	jne    80104bf0 <kill+0x45>
        p->state = RUNNABLE;
80104be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104be9:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104bf0:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
80104bf7:	e8 e7 04 00 00       	call   801050e3 <release>
      return 0;
80104bfc:	b8 00 00 00 00       	mov    $0x0,%eax
80104c01:	eb 21                	jmp    80104c24 <kill+0x79>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c03:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104c0a:	81 7d f4 14 5f 11 80 	cmpl   $0x80115f14,-0xc(%ebp)
80104c11:	72 b3                	jb     80104bc6 <kill+0x1b>
    }
  }
  release(&ptable.lock);
80104c13:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
80104c1a:	e8 c4 04 00 00       	call   801050e3 <release>
  return -1;
80104c1f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c24:	c9                   	leave  
80104c25:	c3                   	ret    

80104c26 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104c26:	55                   	push   %ebp
80104c27:	89 e5                	mov    %esp,%ebp
80104c29:	83 ec 58             	sub    $0x58,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c2c:	c7 45 f0 14 3e 11 80 	movl   $0x80113e14,-0x10(%ebp)
80104c33:	e9 d9 00 00 00       	jmp    80104d11 <procdump+0xeb>
    if(p->state == UNUSED)
80104c38:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c3b:	8b 40 0c             	mov    0xc(%eax),%eax
80104c3e:	85 c0                	test   %eax,%eax
80104c40:	75 05                	jne    80104c47 <procdump+0x21>
      continue;
80104c42:	e9 c3 00 00 00       	jmp    80104d0a <procdump+0xe4>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104c47:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c4a:	8b 40 0c             	mov    0xc(%eax),%eax
80104c4d:	83 f8 05             	cmp    $0x5,%eax
80104c50:	77 23                	ja     80104c75 <procdump+0x4f>
80104c52:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c55:	8b 40 0c             	mov    0xc(%eax),%eax
80104c58:	8b 04 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%eax
80104c5f:	85 c0                	test   %eax,%eax
80104c61:	74 12                	je     80104c75 <procdump+0x4f>
      state = states[p->state];
80104c63:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c66:	8b 40 0c             	mov    0xc(%eax),%eax
80104c69:	8b 04 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%eax
80104c70:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104c73:	eb 07                	jmp    80104c7c <procdump+0x56>
    else
      state = "???";
80104c75:	c7 45 ec 36 89 10 80 	movl   $0x80108936,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104c7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c7f:	8d 50 6c             	lea    0x6c(%eax),%edx
80104c82:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c85:	8b 40 10             	mov    0x10(%eax),%eax
80104c88:	89 54 24 0c          	mov    %edx,0xc(%esp)
80104c8c:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104c8f:	89 54 24 08          	mov    %edx,0x8(%esp)
80104c93:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c97:	c7 04 24 3a 89 10 80 	movl   $0x8010893a,(%esp)
80104c9e:	e8 25 b7 ff ff       	call   801003c8 <cprintf>
    if(p->state == SLEEPING){
80104ca3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ca6:	8b 40 0c             	mov    0xc(%eax),%eax
80104ca9:	83 f8 02             	cmp    $0x2,%eax
80104cac:	75 50                	jne    80104cfe <procdump+0xd8>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104cae:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104cb1:	8b 40 1c             	mov    0x1c(%eax),%eax
80104cb4:	8b 40 0c             	mov    0xc(%eax),%eax
80104cb7:	83 c0 08             	add    $0x8,%eax
80104cba:	8d 55 c4             	lea    -0x3c(%ebp),%edx
80104cbd:	89 54 24 04          	mov    %edx,0x4(%esp)
80104cc1:	89 04 24             	mov    %eax,(%esp)
80104cc4:	e8 65 04 00 00       	call   8010512e <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104cc9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104cd0:	eb 1b                	jmp    80104ced <procdump+0xc7>
        cprintf(" %p", pc[i]);
80104cd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cd5:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104cd9:	89 44 24 04          	mov    %eax,0x4(%esp)
80104cdd:	c7 04 24 43 89 10 80 	movl   $0x80108943,(%esp)
80104ce4:	e8 df b6 ff ff       	call   801003c8 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104ce9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104ced:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104cf1:	7f 0b                	jg     80104cfe <procdump+0xd8>
80104cf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cf6:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104cfa:	85 c0                	test   %eax,%eax
80104cfc:	75 d4                	jne    80104cd2 <procdump+0xac>
    }
    cprintf("\n");
80104cfe:	c7 04 24 47 89 10 80 	movl   $0x80108947,(%esp)
80104d05:	e8 be b6 ff ff       	call   801003c8 <cprintf>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d0a:	81 45 f0 84 00 00 00 	addl   $0x84,-0x10(%ebp)
80104d11:	81 7d f0 14 5f 11 80 	cmpl   $0x80115f14,-0x10(%ebp)
80104d18:	0f 82 1a ff ff ff    	jb     80104c38 <procdump+0x12>
  }
}
80104d1e:	c9                   	leave  
80104d1f:	c3                   	ret    

80104d20 <fillpstat>:
extern void fillpstat(pstatTable* pstat);
void fillpstat(pstatTable * pstat)
{
80104d20:	55                   	push   %ebp
80104d21:	89 e5                	mov    %esp,%ebp
80104d23:	53                   	push   %ebx
80104d24:	83 ec 24             	sub    $0x24,%esp
  struct proc *p;
  int i,j = 0;
80104d27:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  acquire(&ptable.lock);
80104d2e:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
80104d35:	e8 41 03 00 00       	call   8010507b <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104d3a:	c7 45 f4 14 3e 11 80 	movl   $0x80113e14,-0xc(%ebp)
80104d41:	e9 92 01 00 00       	jmp    80104ed8 <fillpstat+0x1b8>
  {
    if(p->state == UNUSED)
80104d46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d49:	8b 40 0c             	mov    0xc(%eax),%eax
80104d4c:	85 c0                	test   %eax,%eax
80104d4e:	75 1d                	jne    80104d6d <fillpstat+0x4d>
      (*pstat)[i].inuse = 0;
80104d50:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104d53:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104d56:	89 d0                	mov    %edx,%eax
80104d58:	c1 e0 03             	shl    $0x3,%eax
80104d5b:	01 d0                	add    %edx,%eax
80104d5d:	c1 e0 02             	shl    $0x2,%eax
80104d60:	01 c8                	add    %ecx,%eax
80104d62:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104d68:	e9 60 01 00 00       	jmp    80104ecd <fillpstat+0x1ad>
    else
    {
      (*pstat)[i].inuse = 1;
80104d6d:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104d70:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104d73:	89 d0                	mov    %edx,%eax
80104d75:	c1 e0 03             	shl    $0x3,%eax
80104d78:	01 d0                	add    %edx,%eax
80104d7a:	c1 e0 02             	shl    $0x2,%eax
80104d7d:	01 c8                	add    %ecx,%eax
80104d7f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      (*pstat)[i].tickets = p->tickets;
80104d85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d88:	8b 48 7c             	mov    0x7c(%eax),%ecx
80104d8b:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104d8e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104d91:	89 d0                	mov    %edx,%eax
80104d93:	c1 e0 03             	shl    $0x3,%eax
80104d96:	01 d0                	add    %edx,%eax
80104d98:	c1 e0 02             	shl    $0x2,%eax
80104d9b:	01 d8                	add    %ebx,%eax
80104d9d:	83 c0 04             	add    $0x4,%eax
80104da0:	89 08                	mov    %ecx,(%eax)
      (*pstat)[i].pid = p->pid;
80104da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104da5:	8b 48 10             	mov    0x10(%eax),%ecx
80104da8:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104dab:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104dae:	89 d0                	mov    %edx,%eax
80104db0:	c1 e0 03             	shl    $0x3,%eax
80104db3:	01 d0                	add    %edx,%eax
80104db5:	c1 e0 02             	shl    $0x2,%eax
80104db8:	01 d8                	add    %ebx,%eax
80104dba:	83 c0 08             	add    $0x8,%eax
80104dbd:	89 08                	mov    %ecx,(%eax)
      (*pstat)[i].ticks = p->ticks;
80104dbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dc2:	8b 88 80 00 00 00    	mov    0x80(%eax),%ecx
80104dc8:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104dcb:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104dce:	89 d0                	mov    %edx,%eax
80104dd0:	c1 e0 03             	shl    $0x3,%eax
80104dd3:	01 d0                	add    %edx,%eax
80104dd5:	c1 e0 02             	shl    $0x2,%eax
80104dd8:	01 d8                	add    %ebx,%eax
80104dda:	83 c0 0c             	add    $0xc,%eax
80104ddd:	89 08                	mov    %ecx,(%eax)
      
      for(j = 0; j < 16; j++)
80104ddf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80104de6:	eb 30                	jmp    80104e18 <fillpstat+0xf8>
         (*pstat)[i].name[j] = p->name[j];
80104de8:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104deb:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104dee:	01 d0                	add    %edx,%eax
80104df0:	83 c0 60             	add    $0x60,%eax
80104df3:	0f b6 48 0c          	movzbl 0xc(%eax),%ecx
80104df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104dfa:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104dfd:	89 d0                	mov    %edx,%eax
80104dff:	c1 e0 03             	shl    $0x3,%eax
80104e02:	01 d0                	add    %edx,%eax
80104e04:	c1 e0 02             	shl    $0x2,%eax
80104e07:	8d 14 03             	lea    (%ebx,%eax,1),%edx
80104e0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104e0d:	01 d0                	add    %edx,%eax
80104e0f:	83 c0 10             	add    $0x10,%eax
80104e12:	88 08                	mov    %cl,(%eax)
      for(j = 0; j < 16; j++)
80104e14:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80104e18:	83 7d ec 0f          	cmpl   $0xf,-0x14(%ebp)
80104e1c:	7e ca                	jle    80104de8 <fillpstat+0xc8>
   //   (*pstat)[i].name[0] = p->name[0];
      if(p->state == EMBRYO)
80104e1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e21:	8b 40 0c             	mov    0xc(%eax),%eax
80104e24:	83 f8 01             	cmp    $0x1,%eax
80104e27:	75 18                	jne    80104e41 <fillpstat+0x121>
        (*pstat)[i].state = 'E';
80104e29:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104e2c:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104e2f:	89 d0                	mov    %edx,%eax
80104e31:	c1 e0 03             	shl    $0x3,%eax
80104e34:	01 d0                	add    %edx,%eax
80104e36:	c1 e0 02             	shl    $0x2,%eax
80104e39:	01 c8                	add    %ecx,%eax
80104e3b:	83 c0 20             	add    $0x20,%eax
80104e3e:	c6 00 45             	movb   $0x45,(%eax)
      if(p->state == SLEEPING)
80104e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e44:	8b 40 0c             	mov    0xc(%eax),%eax
80104e47:	83 f8 02             	cmp    $0x2,%eax
80104e4a:	75 18                	jne    80104e64 <fillpstat+0x144>
        (*pstat)[i].state = 'S'; 
80104e4c:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104e4f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104e52:	89 d0                	mov    %edx,%eax
80104e54:	c1 e0 03             	shl    $0x3,%eax
80104e57:	01 d0                	add    %edx,%eax
80104e59:	c1 e0 02             	shl    $0x2,%eax
80104e5c:	01 c8                	add    %ecx,%eax
80104e5e:	83 c0 20             	add    $0x20,%eax
80104e61:	c6 00 53             	movb   $0x53,(%eax)
      if(p->state == RUNNABLE)
80104e64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e67:	8b 40 0c             	mov    0xc(%eax),%eax
80104e6a:	83 f8 03             	cmp    $0x3,%eax
80104e6d:	75 18                	jne    80104e87 <fillpstat+0x167>
        (*pstat)[i].state = 'A';
80104e6f:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104e72:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104e75:	89 d0                	mov    %edx,%eax
80104e77:	c1 e0 03             	shl    $0x3,%eax
80104e7a:	01 d0                	add    %edx,%eax
80104e7c:	c1 e0 02             	shl    $0x2,%eax
80104e7f:	01 c8                	add    %ecx,%eax
80104e81:	83 c0 20             	add    $0x20,%eax
80104e84:	c6 00 41             	movb   $0x41,(%eax)
      if(p->state == RUNNING)
80104e87:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e8a:	8b 40 0c             	mov    0xc(%eax),%eax
80104e8d:	83 f8 04             	cmp    $0x4,%eax
80104e90:	75 18                	jne    80104eaa <fillpstat+0x18a>
        (*pstat)[i].state = 'R';
80104e92:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104e95:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104e98:	89 d0                	mov    %edx,%eax
80104e9a:	c1 e0 03             	shl    $0x3,%eax
80104e9d:	01 d0                	add    %edx,%eax
80104e9f:	c1 e0 02             	shl    $0x2,%eax
80104ea2:	01 c8                	add    %ecx,%eax
80104ea4:	83 c0 20             	add    $0x20,%eax
80104ea7:	c6 00 52             	movb   $0x52,(%eax)
      if(p->state == ZOMBIE)
80104eaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ead:	8b 40 0c             	mov    0xc(%eax),%eax
80104eb0:	83 f8 05             	cmp    $0x5,%eax
80104eb3:	75 18                	jne    80104ecd <fillpstat+0x1ad>
        (*pstat)[i].state = 'Z';
80104eb5:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104eb8:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104ebb:	89 d0                	mov    %edx,%eax
80104ebd:	c1 e0 03             	shl    $0x3,%eax
80104ec0:	01 d0                	add    %edx,%eax
80104ec2:	c1 e0 02             	shl    $0x2,%eax
80104ec5:	01 c8                	add    %ecx,%eax
80104ec7:	83 c0 20             	add    $0x20,%eax
80104eca:	c6 00 5a             	movb   $0x5a,(%eax)
    }
    i++;  
80104ecd:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104ed1:	81 45 f4 84 00 00 00 	addl   $0x84,-0xc(%ebp)
80104ed8:	81 7d f4 14 5f 11 80 	cmpl   $0x80115f14,-0xc(%ebp)
80104edf:	0f 82 61 fe ff ff    	jb     80104d46 <fillpstat+0x26>
  }
  release(&ptable.lock);
80104ee5:	c7 04 24 e0 3d 11 80 	movl   $0x80113de0,(%esp)
80104eec:	e8 f2 01 00 00       	call   801050e3 <release>
}
80104ef1:	83 c4 24             	add    $0x24,%esp
80104ef4:	5b                   	pop    %ebx
80104ef5:	5d                   	pop    %ebp
80104ef6:	c3                   	ret    

80104ef7 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104ef7:	55                   	push   %ebp
80104ef8:	89 e5                	mov    %esp,%ebp
80104efa:	83 ec 18             	sub    $0x18,%esp
  initlock(&lk->lk, "sleep lock");
80104efd:	8b 45 08             	mov    0x8(%ebp),%eax
80104f00:	83 c0 04             	add    $0x4,%eax
80104f03:	c7 44 24 04 73 89 10 	movl   $0x80108973,0x4(%esp)
80104f0a:	80 
80104f0b:	89 04 24             	mov    %eax,(%esp)
80104f0e:	e8 47 01 00 00       	call   8010505a <initlock>
  lk->name = name;
80104f13:	8b 45 08             	mov    0x8(%ebp),%eax
80104f16:	8b 55 0c             	mov    0xc(%ebp),%edx
80104f19:	89 50 38             	mov    %edx,0x38(%eax)
  lk->locked = 0;
80104f1c:	8b 45 08             	mov    0x8(%ebp),%eax
80104f1f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
80104f25:	8b 45 08             	mov    0x8(%ebp),%eax
80104f28:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
}
80104f2f:	c9                   	leave  
80104f30:	c3                   	ret    

80104f31 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104f31:	55                   	push   %ebp
80104f32:	89 e5                	mov    %esp,%ebp
80104f34:	83 ec 18             	sub    $0x18,%esp
  acquire(&lk->lk);
80104f37:	8b 45 08             	mov    0x8(%ebp),%eax
80104f3a:	83 c0 04             	add    $0x4,%eax
80104f3d:	89 04 24             	mov    %eax,(%esp)
80104f40:	e8 36 01 00 00       	call   8010507b <acquire>
  while (lk->locked) {
80104f45:	eb 15                	jmp    80104f5c <acquiresleep+0x2b>
    sleep(lk, &lk->lk);
80104f47:	8b 45 08             	mov    0x8(%ebp),%eax
80104f4a:	83 c0 04             	add    $0x4,%eax
80104f4d:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f51:	8b 45 08             	mov    0x8(%ebp),%eax
80104f54:	89 04 24             	mov    %eax,(%esp)
80104f57:	e8 4d fb ff ff       	call   80104aa9 <sleep>
  while (lk->locked) {
80104f5c:	8b 45 08             	mov    0x8(%ebp),%eax
80104f5f:	8b 00                	mov    (%eax),%eax
80104f61:	85 c0                	test   %eax,%eax
80104f63:	75 e2                	jne    80104f47 <acquiresleep+0x16>
  }
  lk->locked = 1;
80104f65:	8b 45 08             	mov    0x8(%ebp),%eax
80104f68:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  lk->pid = myproc()->pid;
80104f6e:	e8 ee f1 ff ff       	call   80104161 <myproc>
80104f73:	8b 50 10             	mov    0x10(%eax),%edx
80104f76:	8b 45 08             	mov    0x8(%ebp),%eax
80104f79:	89 50 3c             	mov    %edx,0x3c(%eax)
  release(&lk->lk);
80104f7c:	8b 45 08             	mov    0x8(%ebp),%eax
80104f7f:	83 c0 04             	add    $0x4,%eax
80104f82:	89 04 24             	mov    %eax,(%esp)
80104f85:	e8 59 01 00 00       	call   801050e3 <release>
}
80104f8a:	c9                   	leave  
80104f8b:	c3                   	ret    

80104f8c <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104f8c:	55                   	push   %ebp
80104f8d:	89 e5                	mov    %esp,%ebp
80104f8f:	83 ec 18             	sub    $0x18,%esp
  acquire(&lk->lk);
80104f92:	8b 45 08             	mov    0x8(%ebp),%eax
80104f95:	83 c0 04             	add    $0x4,%eax
80104f98:	89 04 24             	mov    %eax,(%esp)
80104f9b:	e8 db 00 00 00       	call   8010507b <acquire>
  lk->locked = 0;
80104fa0:	8b 45 08             	mov    0x8(%ebp),%eax
80104fa3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->pid = 0;
80104fa9:	8b 45 08             	mov    0x8(%ebp),%eax
80104fac:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
  wakeup(lk);
80104fb3:	8b 45 08             	mov    0x8(%ebp),%eax
80104fb6:	89 04 24             	mov    %eax,(%esp)
80104fb9:	e8 c2 fb ff ff       	call   80104b80 <wakeup>
  release(&lk->lk);
80104fbe:	8b 45 08             	mov    0x8(%ebp),%eax
80104fc1:	83 c0 04             	add    $0x4,%eax
80104fc4:	89 04 24             	mov    %eax,(%esp)
80104fc7:	e8 17 01 00 00       	call   801050e3 <release>
}
80104fcc:	c9                   	leave  
80104fcd:	c3                   	ret    

80104fce <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104fce:	55                   	push   %ebp
80104fcf:	89 e5                	mov    %esp,%ebp
80104fd1:	53                   	push   %ebx
80104fd2:	83 ec 24             	sub    $0x24,%esp
  int r;
  
  acquire(&lk->lk);
80104fd5:	8b 45 08             	mov    0x8(%ebp),%eax
80104fd8:	83 c0 04             	add    $0x4,%eax
80104fdb:	89 04 24             	mov    %eax,(%esp)
80104fde:	e8 98 00 00 00       	call   8010507b <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104fe3:	8b 45 08             	mov    0x8(%ebp),%eax
80104fe6:	8b 00                	mov    (%eax),%eax
80104fe8:	85 c0                	test   %eax,%eax
80104fea:	74 19                	je     80105005 <holdingsleep+0x37>
80104fec:	8b 45 08             	mov    0x8(%ebp),%eax
80104fef:	8b 58 3c             	mov    0x3c(%eax),%ebx
80104ff2:	e8 6a f1 ff ff       	call   80104161 <myproc>
80104ff7:	8b 40 10             	mov    0x10(%eax),%eax
80104ffa:	39 c3                	cmp    %eax,%ebx
80104ffc:	75 07                	jne    80105005 <holdingsleep+0x37>
80104ffe:	b8 01 00 00 00       	mov    $0x1,%eax
80105003:	eb 05                	jmp    8010500a <holdingsleep+0x3c>
80105005:	b8 00 00 00 00       	mov    $0x0,%eax
8010500a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&lk->lk);
8010500d:	8b 45 08             	mov    0x8(%ebp),%eax
80105010:	83 c0 04             	add    $0x4,%eax
80105013:	89 04 24             	mov    %eax,(%esp)
80105016:	e8 c8 00 00 00       	call   801050e3 <release>
  return r;
8010501b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010501e:	83 c4 24             	add    $0x24,%esp
80105021:	5b                   	pop    %ebx
80105022:	5d                   	pop    %ebp
80105023:	c3                   	ret    

80105024 <readeflags>:
{
80105024:	55                   	push   %ebp
80105025:	89 e5                	mov    %esp,%ebp
80105027:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010502a:	9c                   	pushf  
8010502b:	58                   	pop    %eax
8010502c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
8010502f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105032:	c9                   	leave  
80105033:	c3                   	ret    

80105034 <cli>:
{
80105034:	55                   	push   %ebp
80105035:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80105037:	fa                   	cli    
}
80105038:	5d                   	pop    %ebp
80105039:	c3                   	ret    

8010503a <sti>:
{
8010503a:	55                   	push   %ebp
8010503b:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
8010503d:	fb                   	sti    
}
8010503e:	5d                   	pop    %ebp
8010503f:	c3                   	ret    

80105040 <xchg>:
{
80105040:	55                   	push   %ebp
80105041:	89 e5                	mov    %esp,%ebp
80105043:	83 ec 10             	sub    $0x10,%esp
  asm volatile("lock; xchgl %0, %1" :
80105046:	8b 55 08             	mov    0x8(%ebp),%edx
80105049:	8b 45 0c             	mov    0xc(%ebp),%eax
8010504c:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010504f:	f0 87 02             	lock xchg %eax,(%edx)
80105052:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return result;
80105055:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105058:	c9                   	leave  
80105059:	c3                   	ret    

8010505a <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
8010505a:	55                   	push   %ebp
8010505b:	89 e5                	mov    %esp,%ebp
  lk->name = name;
8010505d:	8b 45 08             	mov    0x8(%ebp),%eax
80105060:	8b 55 0c             	mov    0xc(%ebp),%edx
80105063:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80105066:	8b 45 08             	mov    0x8(%ebp),%eax
80105069:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
8010506f:	8b 45 08             	mov    0x8(%ebp),%eax
80105072:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80105079:	5d                   	pop    %ebp
8010507a:	c3                   	ret    

8010507b <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
8010507b:	55                   	push   %ebp
8010507c:	89 e5                	mov    %esp,%ebp
8010507e:	53                   	push   %ebx
8010507f:	83 ec 14             	sub    $0x14,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80105082:	e8 61 01 00 00       	call   801051e8 <pushcli>
  if(holding(lk))
80105087:	8b 45 08             	mov    0x8(%ebp),%eax
8010508a:	89 04 24             	mov    %eax,(%esp)
8010508d:	e8 15 01 00 00       	call   801051a7 <holding>
80105092:	85 c0                	test   %eax,%eax
80105094:	74 0c                	je     801050a2 <acquire+0x27>
    panic("acquire");
80105096:	c7 04 24 7e 89 10 80 	movl   $0x8010897e,(%esp)
8010509d:	e8 c0 b4 ff ff       	call   80100562 <panic>

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
801050a2:	90                   	nop
801050a3:	8b 45 08             	mov    0x8(%ebp),%eax
801050a6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801050ad:	00 
801050ae:	89 04 24             	mov    %eax,(%esp)
801050b1:	e8 8a ff ff ff       	call   80105040 <xchg>
801050b6:	85 c0                	test   %eax,%eax
801050b8:	75 e9                	jne    801050a3 <acquire+0x28>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
801050ba:	0f ae f0             	mfence 

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
801050bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
801050c0:	e8 26 f0 ff ff       	call   801040eb <mycpu>
801050c5:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
801050c8:	8b 45 08             	mov    0x8(%ebp),%eax
801050cb:	83 c0 0c             	add    $0xc,%eax
801050ce:	89 44 24 04          	mov    %eax,0x4(%esp)
801050d2:	8d 45 08             	lea    0x8(%ebp),%eax
801050d5:	89 04 24             	mov    %eax,(%esp)
801050d8:	e8 51 00 00 00       	call   8010512e <getcallerpcs>
}
801050dd:	83 c4 14             	add    $0x14,%esp
801050e0:	5b                   	pop    %ebx
801050e1:	5d                   	pop    %ebp
801050e2:	c3                   	ret    

801050e3 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
801050e3:	55                   	push   %ebp
801050e4:	89 e5                	mov    %esp,%ebp
801050e6:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
801050e9:	8b 45 08             	mov    0x8(%ebp),%eax
801050ec:	89 04 24             	mov    %eax,(%esp)
801050ef:	e8 b3 00 00 00       	call   801051a7 <holding>
801050f4:	85 c0                	test   %eax,%eax
801050f6:	75 0c                	jne    80105104 <release+0x21>
    panic("release");
801050f8:	c7 04 24 86 89 10 80 	movl   $0x80108986,(%esp)
801050ff:	e8 5e b4 ff ff       	call   80100562 <panic>

  lk->pcs[0] = 0;
80105104:	8b 45 08             	mov    0x8(%ebp),%eax
80105107:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
8010510e:	8b 45 08             	mov    0x8(%ebp),%eax
80105111:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80105118:	0f ae f0             	mfence 

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010511b:	8b 45 08             	mov    0x8(%ebp),%eax
8010511e:	8b 55 08             	mov    0x8(%ebp),%edx
80105121:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  popcli();
80105127:	e8 08 01 00 00       	call   80105234 <popcli>
}
8010512c:	c9                   	leave  
8010512d:	c3                   	ret    

8010512e <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
8010512e:	55                   	push   %ebp
8010512f:	89 e5                	mov    %esp,%ebp
80105131:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80105134:	8b 45 08             	mov    0x8(%ebp),%eax
80105137:	83 e8 08             	sub    $0x8,%eax
8010513a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
8010513d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80105144:	eb 38                	jmp    8010517e <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105146:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
8010514a:	74 38                	je     80105184 <getcallerpcs+0x56>
8010514c:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
80105153:	76 2f                	jbe    80105184 <getcallerpcs+0x56>
80105155:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80105159:	74 29                	je     80105184 <getcallerpcs+0x56>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010515b:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010515e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105165:	8b 45 0c             	mov    0xc(%ebp),%eax
80105168:	01 c2                	add    %eax,%edx
8010516a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010516d:	8b 40 04             	mov    0x4(%eax),%eax
80105170:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
80105172:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105175:	8b 00                	mov    (%eax),%eax
80105177:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
8010517a:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010517e:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105182:	7e c2                	jle    80105146 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
80105184:	eb 19                	jmp    8010519f <getcallerpcs+0x71>
    pcs[i] = 0;
80105186:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105189:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105190:	8b 45 0c             	mov    0xc(%ebp),%eax
80105193:	01 d0                	add    %edx,%eax
80105195:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
8010519b:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010519f:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801051a3:	7e e1                	jle    80105186 <getcallerpcs+0x58>
}
801051a5:	c9                   	leave  
801051a6:	c3                   	ret    

801051a7 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801051a7:	55                   	push   %ebp
801051a8:	89 e5                	mov    %esp,%ebp
801051aa:	53                   	push   %ebx
801051ab:	83 ec 14             	sub    $0x14,%esp
  int r;
  pushcli();
801051ae:	e8 35 00 00 00       	call   801051e8 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801051b3:	8b 45 08             	mov    0x8(%ebp),%eax
801051b6:	8b 00                	mov    (%eax),%eax
801051b8:	85 c0                	test   %eax,%eax
801051ba:	74 16                	je     801051d2 <holding+0x2b>
801051bc:	8b 45 08             	mov    0x8(%ebp),%eax
801051bf:	8b 58 08             	mov    0x8(%eax),%ebx
801051c2:	e8 24 ef ff ff       	call   801040eb <mycpu>
801051c7:	39 c3                	cmp    %eax,%ebx
801051c9:	75 07                	jne    801051d2 <holding+0x2b>
801051cb:	b8 01 00 00 00       	mov    $0x1,%eax
801051d0:	eb 05                	jmp    801051d7 <holding+0x30>
801051d2:	b8 00 00 00 00       	mov    $0x0,%eax
801051d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  popcli();
801051da:	e8 55 00 00 00       	call   80105234 <popcli>
  return r;
801051df:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801051e2:	83 c4 14             	add    $0x14,%esp
801051e5:	5b                   	pop    %ebx
801051e6:	5d                   	pop    %ebp
801051e7:	c3                   	ret    

801051e8 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801051e8:	55                   	push   %ebp
801051e9:	89 e5                	mov    %esp,%ebp
801051eb:	83 ec 18             	sub    $0x18,%esp
  int eflags;

  eflags = readeflags();
801051ee:	e8 31 fe ff ff       	call   80105024 <readeflags>
801051f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  cli();
801051f6:	e8 39 fe ff ff       	call   80105034 <cli>
  if(mycpu()->ncli == 0)
801051fb:	e8 eb ee ff ff       	call   801040eb <mycpu>
80105200:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105206:	85 c0                	test   %eax,%eax
80105208:	75 14                	jne    8010521e <pushcli+0x36>
    mycpu()->intena = eflags & FL_IF;
8010520a:	e8 dc ee ff ff       	call   801040eb <mycpu>
8010520f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105212:	81 e2 00 02 00 00    	and    $0x200,%edx
80105218:	89 90 a8 00 00 00    	mov    %edx,0xa8(%eax)
  mycpu()->ncli += 1;
8010521e:	e8 c8 ee ff ff       	call   801040eb <mycpu>
80105223:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80105229:	83 c2 01             	add    $0x1,%edx
8010522c:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
}
80105232:	c9                   	leave  
80105233:	c3                   	ret    

80105234 <popcli>:

void
popcli(void)
{
80105234:	55                   	push   %ebp
80105235:	89 e5                	mov    %esp,%ebp
80105237:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
8010523a:	e8 e5 fd ff ff       	call   80105024 <readeflags>
8010523f:	25 00 02 00 00       	and    $0x200,%eax
80105244:	85 c0                	test   %eax,%eax
80105246:	74 0c                	je     80105254 <popcli+0x20>
    panic("popcli - interruptible");
80105248:	c7 04 24 8e 89 10 80 	movl   $0x8010898e,(%esp)
8010524f:	e8 0e b3 ff ff       	call   80100562 <panic>
  if(--mycpu()->ncli < 0)
80105254:	e8 92 ee ff ff       	call   801040eb <mycpu>
80105259:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
8010525f:	83 ea 01             	sub    $0x1,%edx
80105262:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80105268:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
8010526e:	85 c0                	test   %eax,%eax
80105270:	79 0c                	jns    8010527e <popcli+0x4a>
    panic("popcli");
80105272:	c7 04 24 a5 89 10 80 	movl   $0x801089a5,(%esp)
80105279:	e8 e4 b2 ff ff       	call   80100562 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010527e:	e8 68 ee ff ff       	call   801040eb <mycpu>
80105283:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80105289:	85 c0                	test   %eax,%eax
8010528b:	75 14                	jne    801052a1 <popcli+0x6d>
8010528d:	e8 59 ee ff ff       	call   801040eb <mycpu>
80105292:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80105298:	85 c0                	test   %eax,%eax
8010529a:	74 05                	je     801052a1 <popcli+0x6d>
    sti();
8010529c:	e8 99 fd ff ff       	call   8010503a <sti>
}
801052a1:	c9                   	leave  
801052a2:	c3                   	ret    

801052a3 <stosb>:
{
801052a3:	55                   	push   %ebp
801052a4:	89 e5                	mov    %esp,%ebp
801052a6:	57                   	push   %edi
801052a7:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
801052a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
801052ab:	8b 55 10             	mov    0x10(%ebp),%edx
801052ae:	8b 45 0c             	mov    0xc(%ebp),%eax
801052b1:	89 cb                	mov    %ecx,%ebx
801052b3:	89 df                	mov    %ebx,%edi
801052b5:	89 d1                	mov    %edx,%ecx
801052b7:	fc                   	cld    
801052b8:	f3 aa                	rep stos %al,%es:(%edi)
801052ba:	89 ca                	mov    %ecx,%edx
801052bc:	89 fb                	mov    %edi,%ebx
801052be:	89 5d 08             	mov    %ebx,0x8(%ebp)
801052c1:	89 55 10             	mov    %edx,0x10(%ebp)
}
801052c4:	5b                   	pop    %ebx
801052c5:	5f                   	pop    %edi
801052c6:	5d                   	pop    %ebp
801052c7:	c3                   	ret    

801052c8 <stosl>:
{
801052c8:	55                   	push   %ebp
801052c9:	89 e5                	mov    %esp,%ebp
801052cb:	57                   	push   %edi
801052cc:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
801052cd:	8b 4d 08             	mov    0x8(%ebp),%ecx
801052d0:	8b 55 10             	mov    0x10(%ebp),%edx
801052d3:	8b 45 0c             	mov    0xc(%ebp),%eax
801052d6:	89 cb                	mov    %ecx,%ebx
801052d8:	89 df                	mov    %ebx,%edi
801052da:	89 d1                	mov    %edx,%ecx
801052dc:	fc                   	cld    
801052dd:	f3 ab                	rep stos %eax,%es:(%edi)
801052df:	89 ca                	mov    %ecx,%edx
801052e1:	89 fb                	mov    %edi,%ebx
801052e3:	89 5d 08             	mov    %ebx,0x8(%ebp)
801052e6:	89 55 10             	mov    %edx,0x10(%ebp)
}
801052e9:	5b                   	pop    %ebx
801052ea:	5f                   	pop    %edi
801052eb:	5d                   	pop    %ebp
801052ec:	c3                   	ret    

801052ed <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801052ed:	55                   	push   %ebp
801052ee:	89 e5                	mov    %esp,%ebp
801052f0:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
801052f3:	8b 45 08             	mov    0x8(%ebp),%eax
801052f6:	83 e0 03             	and    $0x3,%eax
801052f9:	85 c0                	test   %eax,%eax
801052fb:	75 49                	jne    80105346 <memset+0x59>
801052fd:	8b 45 10             	mov    0x10(%ebp),%eax
80105300:	83 e0 03             	and    $0x3,%eax
80105303:	85 c0                	test   %eax,%eax
80105305:	75 3f                	jne    80105346 <memset+0x59>
    c &= 0xFF;
80105307:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010530e:	8b 45 10             	mov    0x10(%ebp),%eax
80105311:	c1 e8 02             	shr    $0x2,%eax
80105314:	89 c2                	mov    %eax,%edx
80105316:	8b 45 0c             	mov    0xc(%ebp),%eax
80105319:	c1 e0 18             	shl    $0x18,%eax
8010531c:	89 c1                	mov    %eax,%ecx
8010531e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105321:	c1 e0 10             	shl    $0x10,%eax
80105324:	09 c1                	or     %eax,%ecx
80105326:	8b 45 0c             	mov    0xc(%ebp),%eax
80105329:	c1 e0 08             	shl    $0x8,%eax
8010532c:	09 c8                	or     %ecx,%eax
8010532e:	0b 45 0c             	or     0xc(%ebp),%eax
80105331:	89 54 24 08          	mov    %edx,0x8(%esp)
80105335:	89 44 24 04          	mov    %eax,0x4(%esp)
80105339:	8b 45 08             	mov    0x8(%ebp),%eax
8010533c:	89 04 24             	mov    %eax,(%esp)
8010533f:	e8 84 ff ff ff       	call   801052c8 <stosl>
80105344:	eb 19                	jmp    8010535f <memset+0x72>
  } else
    stosb(dst, c, n);
80105346:	8b 45 10             	mov    0x10(%ebp),%eax
80105349:	89 44 24 08          	mov    %eax,0x8(%esp)
8010534d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105350:	89 44 24 04          	mov    %eax,0x4(%esp)
80105354:	8b 45 08             	mov    0x8(%ebp),%eax
80105357:	89 04 24             	mov    %eax,(%esp)
8010535a:	e8 44 ff ff ff       	call   801052a3 <stosb>
  return dst;
8010535f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105362:	c9                   	leave  
80105363:	c3                   	ret    

80105364 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105364:	55                   	push   %ebp
80105365:	89 e5                	mov    %esp,%ebp
80105367:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;

  s1 = v1;
8010536a:	8b 45 08             	mov    0x8(%ebp),%eax
8010536d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80105370:	8b 45 0c             	mov    0xc(%ebp),%eax
80105373:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80105376:	eb 30                	jmp    801053a8 <memcmp+0x44>
    if(*s1 != *s2)
80105378:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010537b:	0f b6 10             	movzbl (%eax),%edx
8010537e:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105381:	0f b6 00             	movzbl (%eax),%eax
80105384:	38 c2                	cmp    %al,%dl
80105386:	74 18                	je     801053a0 <memcmp+0x3c>
      return *s1 - *s2;
80105388:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010538b:	0f b6 00             	movzbl (%eax),%eax
8010538e:	0f b6 d0             	movzbl %al,%edx
80105391:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105394:	0f b6 00             	movzbl (%eax),%eax
80105397:	0f b6 c0             	movzbl %al,%eax
8010539a:	29 c2                	sub    %eax,%edx
8010539c:	89 d0                	mov    %edx,%eax
8010539e:	eb 1a                	jmp    801053ba <memcmp+0x56>
    s1++, s2++;
801053a0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801053a4:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  while(n-- > 0){
801053a8:	8b 45 10             	mov    0x10(%ebp),%eax
801053ab:	8d 50 ff             	lea    -0x1(%eax),%edx
801053ae:	89 55 10             	mov    %edx,0x10(%ebp)
801053b1:	85 c0                	test   %eax,%eax
801053b3:	75 c3                	jne    80105378 <memcmp+0x14>
  }

  return 0;
801053b5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801053ba:	c9                   	leave  
801053bb:	c3                   	ret    

801053bc <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801053bc:	55                   	push   %ebp
801053bd:	89 e5                	mov    %esp,%ebp
801053bf:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
801053c2:	8b 45 0c             	mov    0xc(%ebp),%eax
801053c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
801053c8:	8b 45 08             	mov    0x8(%ebp),%eax
801053cb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
801053ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
801053d1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801053d4:	73 3d                	jae    80105413 <memmove+0x57>
801053d6:	8b 45 10             	mov    0x10(%ebp),%eax
801053d9:	8b 55 fc             	mov    -0x4(%ebp),%edx
801053dc:	01 d0                	add    %edx,%eax
801053de:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801053e1:	76 30                	jbe    80105413 <memmove+0x57>
    s += n;
801053e3:	8b 45 10             	mov    0x10(%ebp),%eax
801053e6:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
801053e9:	8b 45 10             	mov    0x10(%ebp),%eax
801053ec:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
801053ef:	eb 13                	jmp    80105404 <memmove+0x48>
      *--d = *--s;
801053f1:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
801053f5:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
801053f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801053fc:	0f b6 10             	movzbl (%eax),%edx
801053ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105402:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
80105404:	8b 45 10             	mov    0x10(%ebp),%eax
80105407:	8d 50 ff             	lea    -0x1(%eax),%edx
8010540a:	89 55 10             	mov    %edx,0x10(%ebp)
8010540d:	85 c0                	test   %eax,%eax
8010540f:	75 e0                	jne    801053f1 <memmove+0x35>
  if(s < d && s + n > d){
80105411:	eb 26                	jmp    80105439 <memmove+0x7d>
  } else
    while(n-- > 0)
80105413:	eb 17                	jmp    8010542c <memmove+0x70>
      *d++ = *s++;
80105415:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105418:	8d 50 01             	lea    0x1(%eax),%edx
8010541b:	89 55 f8             	mov    %edx,-0x8(%ebp)
8010541e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105421:	8d 4a 01             	lea    0x1(%edx),%ecx
80105424:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80105427:	0f b6 12             	movzbl (%edx),%edx
8010542a:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
8010542c:	8b 45 10             	mov    0x10(%ebp),%eax
8010542f:	8d 50 ff             	lea    -0x1(%eax),%edx
80105432:	89 55 10             	mov    %edx,0x10(%ebp)
80105435:	85 c0                	test   %eax,%eax
80105437:	75 dc                	jne    80105415 <memmove+0x59>

  return dst;
80105439:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010543c:	c9                   	leave  
8010543d:	c3                   	ret    

8010543e <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
8010543e:	55                   	push   %ebp
8010543f:	89 e5                	mov    %esp,%ebp
80105441:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
80105444:	8b 45 10             	mov    0x10(%ebp),%eax
80105447:	89 44 24 08          	mov    %eax,0x8(%esp)
8010544b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010544e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105452:	8b 45 08             	mov    0x8(%ebp),%eax
80105455:	89 04 24             	mov    %eax,(%esp)
80105458:	e8 5f ff ff ff       	call   801053bc <memmove>
}
8010545d:	c9                   	leave  
8010545e:	c3                   	ret    

8010545f <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
8010545f:	55                   	push   %ebp
80105460:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80105462:	eb 0c                	jmp    80105470 <strncmp+0x11>
    n--, p++, q++;
80105464:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105468:	83 45 08 01          	addl   $0x1,0x8(%ebp)
8010546c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(n > 0 && *p && *p == *q)
80105470:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105474:	74 1a                	je     80105490 <strncmp+0x31>
80105476:	8b 45 08             	mov    0x8(%ebp),%eax
80105479:	0f b6 00             	movzbl (%eax),%eax
8010547c:	84 c0                	test   %al,%al
8010547e:	74 10                	je     80105490 <strncmp+0x31>
80105480:	8b 45 08             	mov    0x8(%ebp),%eax
80105483:	0f b6 10             	movzbl (%eax),%edx
80105486:	8b 45 0c             	mov    0xc(%ebp),%eax
80105489:	0f b6 00             	movzbl (%eax),%eax
8010548c:	38 c2                	cmp    %al,%dl
8010548e:	74 d4                	je     80105464 <strncmp+0x5>
  if(n == 0)
80105490:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105494:	75 07                	jne    8010549d <strncmp+0x3e>
    return 0;
80105496:	b8 00 00 00 00       	mov    $0x0,%eax
8010549b:	eb 16                	jmp    801054b3 <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
8010549d:	8b 45 08             	mov    0x8(%ebp),%eax
801054a0:	0f b6 00             	movzbl (%eax),%eax
801054a3:	0f b6 d0             	movzbl %al,%edx
801054a6:	8b 45 0c             	mov    0xc(%ebp),%eax
801054a9:	0f b6 00             	movzbl (%eax),%eax
801054ac:	0f b6 c0             	movzbl %al,%eax
801054af:	29 c2                	sub    %eax,%edx
801054b1:	89 d0                	mov    %edx,%eax
}
801054b3:	5d                   	pop    %ebp
801054b4:	c3                   	ret    

801054b5 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801054b5:	55                   	push   %ebp
801054b6:	89 e5                	mov    %esp,%ebp
801054b8:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
801054bb:	8b 45 08             	mov    0x8(%ebp),%eax
801054be:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
801054c1:	90                   	nop
801054c2:	8b 45 10             	mov    0x10(%ebp),%eax
801054c5:	8d 50 ff             	lea    -0x1(%eax),%edx
801054c8:	89 55 10             	mov    %edx,0x10(%ebp)
801054cb:	85 c0                	test   %eax,%eax
801054cd:	7e 1e                	jle    801054ed <strncpy+0x38>
801054cf:	8b 45 08             	mov    0x8(%ebp),%eax
801054d2:	8d 50 01             	lea    0x1(%eax),%edx
801054d5:	89 55 08             	mov    %edx,0x8(%ebp)
801054d8:	8b 55 0c             	mov    0xc(%ebp),%edx
801054db:	8d 4a 01             	lea    0x1(%edx),%ecx
801054de:	89 4d 0c             	mov    %ecx,0xc(%ebp)
801054e1:	0f b6 12             	movzbl (%edx),%edx
801054e4:	88 10                	mov    %dl,(%eax)
801054e6:	0f b6 00             	movzbl (%eax),%eax
801054e9:	84 c0                	test   %al,%al
801054eb:	75 d5                	jne    801054c2 <strncpy+0xd>
    ;
  while(n-- > 0)
801054ed:	eb 0c                	jmp    801054fb <strncpy+0x46>
    *s++ = 0;
801054ef:	8b 45 08             	mov    0x8(%ebp),%eax
801054f2:	8d 50 01             	lea    0x1(%eax),%edx
801054f5:	89 55 08             	mov    %edx,0x8(%ebp)
801054f8:	c6 00 00             	movb   $0x0,(%eax)
  while(n-- > 0)
801054fb:	8b 45 10             	mov    0x10(%ebp),%eax
801054fe:	8d 50 ff             	lea    -0x1(%eax),%edx
80105501:	89 55 10             	mov    %edx,0x10(%ebp)
80105504:	85 c0                	test   %eax,%eax
80105506:	7f e7                	jg     801054ef <strncpy+0x3a>
  return os;
80105508:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010550b:	c9                   	leave  
8010550c:	c3                   	ret    

8010550d <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
8010550d:	55                   	push   %ebp
8010550e:	89 e5                	mov    %esp,%ebp
80105510:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
80105513:	8b 45 08             	mov    0x8(%ebp),%eax
80105516:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80105519:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010551d:	7f 05                	jg     80105524 <safestrcpy+0x17>
    return os;
8010551f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105522:	eb 31                	jmp    80105555 <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
80105524:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105528:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010552c:	7e 1e                	jle    8010554c <safestrcpy+0x3f>
8010552e:	8b 45 08             	mov    0x8(%ebp),%eax
80105531:	8d 50 01             	lea    0x1(%eax),%edx
80105534:	89 55 08             	mov    %edx,0x8(%ebp)
80105537:	8b 55 0c             	mov    0xc(%ebp),%edx
8010553a:	8d 4a 01             	lea    0x1(%edx),%ecx
8010553d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80105540:	0f b6 12             	movzbl (%edx),%edx
80105543:	88 10                	mov    %dl,(%eax)
80105545:	0f b6 00             	movzbl (%eax),%eax
80105548:	84 c0                	test   %al,%al
8010554a:	75 d8                	jne    80105524 <safestrcpy+0x17>
    ;
  *s = 0;
8010554c:	8b 45 08             	mov    0x8(%ebp),%eax
8010554f:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80105552:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105555:	c9                   	leave  
80105556:	c3                   	ret    

80105557 <strlen>:

int
strlen(const char *s)
{
80105557:	55                   	push   %ebp
80105558:	89 e5                	mov    %esp,%ebp
8010555a:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
8010555d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105564:	eb 04                	jmp    8010556a <strlen+0x13>
80105566:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010556a:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010556d:	8b 45 08             	mov    0x8(%ebp),%eax
80105570:	01 d0                	add    %edx,%eax
80105572:	0f b6 00             	movzbl (%eax),%eax
80105575:	84 c0                	test   %al,%al
80105577:	75 ed                	jne    80105566 <strlen+0xf>
    ;
  return n;
80105579:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010557c:	c9                   	leave  
8010557d:	c3                   	ret    

8010557e <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010557e:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105582:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105586:	55                   	push   %ebp
  pushl %ebx
80105587:	53                   	push   %ebx
  pushl %esi
80105588:	56                   	push   %esi
  pushl %edi
80105589:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
8010558a:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
8010558c:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010558e:	5f                   	pop    %edi
  popl %esi
8010558f:	5e                   	pop    %esi
  popl %ebx
80105590:	5b                   	pop    %ebx
  popl %ebp
80105591:	5d                   	pop    %ebp
  ret
80105592:	c3                   	ret    

80105593 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105593:	55                   	push   %ebp
80105594:	89 e5                	mov    %esp,%ebp
80105596:	83 ec 18             	sub    $0x18,%esp
  struct proc *curproc = myproc();
80105599:	e8 c3 eb ff ff       	call   80104161 <myproc>
8010559e:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801055a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055a4:	8b 00                	mov    (%eax),%eax
801055a6:	3b 45 08             	cmp    0x8(%ebp),%eax
801055a9:	76 0f                	jbe    801055ba <fetchint+0x27>
801055ab:	8b 45 08             	mov    0x8(%ebp),%eax
801055ae:	8d 50 04             	lea    0x4(%eax),%edx
801055b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055b4:	8b 00                	mov    (%eax),%eax
801055b6:	39 c2                	cmp    %eax,%edx
801055b8:	76 07                	jbe    801055c1 <fetchint+0x2e>
    return -1;
801055ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055bf:	eb 0f                	jmp    801055d0 <fetchint+0x3d>
  *ip = *(int*)(addr);
801055c1:	8b 45 08             	mov    0x8(%ebp),%eax
801055c4:	8b 10                	mov    (%eax),%edx
801055c6:	8b 45 0c             	mov    0xc(%ebp),%eax
801055c9:	89 10                	mov    %edx,(%eax)
  return 0;
801055cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
801055d0:	c9                   	leave  
801055d1:	c3                   	ret    

801055d2 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801055d2:	55                   	push   %ebp
801055d3:	89 e5                	mov    %esp,%ebp
801055d5:	83 ec 18             	sub    $0x18,%esp
  char *s, *ep;
  struct proc *curproc = myproc();
801055d8:	e8 84 eb ff ff       	call   80104161 <myproc>
801055dd:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if(addr >= curproc->sz)
801055e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055e3:	8b 00                	mov    (%eax),%eax
801055e5:	3b 45 08             	cmp    0x8(%ebp),%eax
801055e8:	77 07                	ja     801055f1 <fetchstr+0x1f>
    return -1;
801055ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055ef:	eb 43                	jmp    80105634 <fetchstr+0x62>
  *pp = (char*)addr;
801055f1:	8b 55 08             	mov    0x8(%ebp),%edx
801055f4:	8b 45 0c             	mov    0xc(%ebp),%eax
801055f7:	89 10                	mov    %edx,(%eax)
  ep = (char*)curproc->sz;
801055f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801055fc:	8b 00                	mov    (%eax),%eax
801055fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(s = *pp; s < ep; s++){
80105601:	8b 45 0c             	mov    0xc(%ebp),%eax
80105604:	8b 00                	mov    (%eax),%eax
80105606:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105609:	eb 1c                	jmp    80105627 <fetchstr+0x55>
    if(*s == 0)
8010560b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010560e:	0f b6 00             	movzbl (%eax),%eax
80105611:	84 c0                	test   %al,%al
80105613:	75 0e                	jne    80105623 <fetchstr+0x51>
      return s - *pp;
80105615:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105618:	8b 45 0c             	mov    0xc(%ebp),%eax
8010561b:	8b 00                	mov    (%eax),%eax
8010561d:	29 c2                	sub    %eax,%edx
8010561f:	89 d0                	mov    %edx,%eax
80105621:	eb 11                	jmp    80105634 <fetchstr+0x62>
  for(s = *pp; s < ep; s++){
80105623:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105627:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010562a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010562d:	72 dc                	jb     8010560b <fetchstr+0x39>
  }
  return -1;
8010562f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105634:	c9                   	leave  
80105635:	c3                   	ret    

80105636 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105636:	55                   	push   %ebp
80105637:	89 e5                	mov    %esp,%ebp
80105639:	83 ec 18             	sub    $0x18,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010563c:	e8 20 eb ff ff       	call   80104161 <myproc>
80105641:	8b 40 18             	mov    0x18(%eax),%eax
80105644:	8b 50 44             	mov    0x44(%eax),%edx
80105647:	8b 45 08             	mov    0x8(%ebp),%eax
8010564a:	c1 e0 02             	shl    $0x2,%eax
8010564d:	01 d0                	add    %edx,%eax
8010564f:	8d 50 04             	lea    0x4(%eax),%edx
80105652:	8b 45 0c             	mov    0xc(%ebp),%eax
80105655:	89 44 24 04          	mov    %eax,0x4(%esp)
80105659:	89 14 24             	mov    %edx,(%esp)
8010565c:	e8 32 ff ff ff       	call   80105593 <fetchint>
}
80105661:	c9                   	leave  
80105662:	c3                   	ret    

80105663 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105663:	55                   	push   %ebp
80105664:	89 e5                	mov    %esp,%ebp
80105666:	83 ec 28             	sub    $0x28,%esp
  int i;
  struct proc *curproc = myproc();
80105669:	e8 f3 ea ff ff       	call   80104161 <myproc>
8010566e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 
  if(argint(n, &i) < 0)
80105671:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105674:	89 44 24 04          	mov    %eax,0x4(%esp)
80105678:	8b 45 08             	mov    0x8(%ebp),%eax
8010567b:	89 04 24             	mov    %eax,(%esp)
8010567e:	e8 b3 ff ff ff       	call   80105636 <argint>
80105683:	85 c0                	test   %eax,%eax
80105685:	79 07                	jns    8010568e <argptr+0x2b>
    return -1;
80105687:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010568c:	eb 3d                	jmp    801056cb <argptr+0x68>
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
8010568e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105692:	78 21                	js     801056b5 <argptr+0x52>
80105694:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105697:	89 c2                	mov    %eax,%edx
80105699:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010569c:	8b 00                	mov    (%eax),%eax
8010569e:	39 c2                	cmp    %eax,%edx
801056a0:	73 13                	jae    801056b5 <argptr+0x52>
801056a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056a5:	89 c2                	mov    %eax,%edx
801056a7:	8b 45 10             	mov    0x10(%ebp),%eax
801056aa:	01 c2                	add    %eax,%edx
801056ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056af:	8b 00                	mov    (%eax),%eax
801056b1:	39 c2                	cmp    %eax,%edx
801056b3:	76 07                	jbe    801056bc <argptr+0x59>
    return -1;
801056b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056ba:	eb 0f                	jmp    801056cb <argptr+0x68>
  *pp = (char*)i;
801056bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056bf:	89 c2                	mov    %eax,%edx
801056c1:	8b 45 0c             	mov    0xc(%ebp),%eax
801056c4:	89 10                	mov    %edx,(%eax)
  return 0;
801056c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801056cb:	c9                   	leave  
801056cc:	c3                   	ret    

801056cd <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801056cd:	55                   	push   %ebp
801056ce:	89 e5                	mov    %esp,%ebp
801056d0:	83 ec 28             	sub    $0x28,%esp
  int addr;
  if(argint(n, &addr) < 0)
801056d3:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056d6:	89 44 24 04          	mov    %eax,0x4(%esp)
801056da:	8b 45 08             	mov    0x8(%ebp),%eax
801056dd:	89 04 24             	mov    %eax,(%esp)
801056e0:	e8 51 ff ff ff       	call   80105636 <argint>
801056e5:	85 c0                	test   %eax,%eax
801056e7:	79 07                	jns    801056f0 <argstr+0x23>
    return -1;
801056e9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056ee:	eb 12                	jmp    80105702 <argstr+0x35>
  return fetchstr(addr, pp);
801056f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801056f3:	8b 55 0c             	mov    0xc(%ebp),%edx
801056f6:	89 54 24 04          	mov    %edx,0x4(%esp)
801056fa:	89 04 24             	mov    %eax,(%esp)
801056fd:	e8 d0 fe ff ff       	call   801055d2 <fetchstr>
}
80105702:	c9                   	leave  
80105703:	c3                   	ret    

80105704 <syscall>:
[SYS_settickets] sys_settickets,
};

void
syscall(void)
{
80105704:	55                   	push   %ebp
80105705:	89 e5                	mov    %esp,%ebp
80105707:	53                   	push   %ebx
80105708:	83 ec 24             	sub    $0x24,%esp
  int num;
  struct proc *curproc = myproc();
8010570b:	e8 51 ea ff ff       	call   80104161 <myproc>
80105710:	89 45 f4             	mov    %eax,-0xc(%ebp)

  num = curproc->tf->eax;
80105713:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105716:	8b 40 18             	mov    0x18(%eax),%eax
80105719:	8b 40 1c             	mov    0x1c(%eax),%eax
8010571c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
8010571f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105723:	7e 2d                	jle    80105752 <syscall+0x4e>
80105725:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105728:	83 f8 18             	cmp    $0x18,%eax
8010572b:	77 25                	ja     80105752 <syscall+0x4e>
8010572d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105730:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
80105737:	85 c0                	test   %eax,%eax
80105739:	74 17                	je     80105752 <syscall+0x4e>
    curproc->tf->eax = syscalls[num]();
8010573b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010573e:	8b 58 18             	mov    0x18(%eax),%ebx
80105741:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105744:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
8010574b:	ff d0                	call   *%eax
8010574d:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105750:	eb 34                	jmp    80105786 <syscall+0x82>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
80105752:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105755:	8d 48 6c             	lea    0x6c(%eax),%ecx
    cprintf("%d %s: unknown sys call %d\n",
80105758:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010575b:	8b 40 10             	mov    0x10(%eax),%eax
8010575e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105761:	89 54 24 0c          	mov    %edx,0xc(%esp)
80105765:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105769:	89 44 24 04          	mov    %eax,0x4(%esp)
8010576d:	c7 04 24 ac 89 10 80 	movl   $0x801089ac,(%esp)
80105774:	e8 4f ac ff ff       	call   801003c8 <cprintf>
    curproc->tf->eax = -1;
80105779:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010577c:	8b 40 18             	mov    0x18(%eax),%eax
8010577f:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105786:	83 c4 24             	add    $0x24,%esp
80105789:	5b                   	pop    %ebx
8010578a:	5d                   	pop    %ebp
8010578b:	c3                   	ret    

8010578c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
8010578c:	55                   	push   %ebp
8010578d:	89 e5                	mov    %esp,%ebp
8010578f:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105792:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105795:	89 44 24 04          	mov    %eax,0x4(%esp)
80105799:	8b 45 08             	mov    0x8(%ebp),%eax
8010579c:	89 04 24             	mov    %eax,(%esp)
8010579f:	e8 92 fe ff ff       	call   80105636 <argint>
801057a4:	85 c0                	test   %eax,%eax
801057a6:	79 07                	jns    801057af <argfd+0x23>
    return -1;
801057a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057ad:	eb 4f                	jmp    801057fe <argfd+0x72>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801057af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057b2:	85 c0                	test   %eax,%eax
801057b4:	78 20                	js     801057d6 <argfd+0x4a>
801057b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057b9:	83 f8 0f             	cmp    $0xf,%eax
801057bc:	7f 18                	jg     801057d6 <argfd+0x4a>
801057be:	e8 9e e9 ff ff       	call   80104161 <myproc>
801057c3:	8b 55 f0             	mov    -0x10(%ebp),%edx
801057c6:	83 c2 08             	add    $0x8,%edx
801057c9:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801057cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
801057d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801057d4:	75 07                	jne    801057dd <argfd+0x51>
    return -1;
801057d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057db:	eb 21                	jmp    801057fe <argfd+0x72>
  if(pfd)
801057dd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801057e1:	74 08                	je     801057eb <argfd+0x5f>
    *pfd = fd;
801057e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
801057e6:	8b 45 0c             	mov    0xc(%ebp),%eax
801057e9:	89 10                	mov    %edx,(%eax)
  if(pf)
801057eb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801057ef:	74 08                	je     801057f9 <argfd+0x6d>
    *pf = f;
801057f1:	8b 45 10             	mov    0x10(%ebp),%eax
801057f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801057f7:	89 10                	mov    %edx,(%eax)
  return 0;
801057f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801057fe:	c9                   	leave  
801057ff:	c3                   	ret    

80105800 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105800:	55                   	push   %ebp
80105801:	89 e5                	mov    %esp,%ebp
80105803:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct proc *curproc = myproc();
80105806:	e8 56 e9 ff ff       	call   80104161 <myproc>
8010580b:	89 45 f0             	mov    %eax,-0x10(%ebp)

  for(fd = 0; fd < NOFILE; fd++){
8010580e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105815:	eb 2a                	jmp    80105841 <fdalloc+0x41>
    if(curproc->ofile[fd] == 0){
80105817:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010581a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010581d:	83 c2 08             	add    $0x8,%edx
80105820:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105824:	85 c0                	test   %eax,%eax
80105826:	75 15                	jne    8010583d <fdalloc+0x3d>
      curproc->ofile[fd] = f;
80105828:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010582b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010582e:	8d 4a 08             	lea    0x8(%edx),%ecx
80105831:	8b 55 08             	mov    0x8(%ebp),%edx
80105834:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105838:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010583b:	eb 0f                	jmp    8010584c <fdalloc+0x4c>
  for(fd = 0; fd < NOFILE; fd++){
8010583d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105841:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105845:	7e d0                	jle    80105817 <fdalloc+0x17>
    }
  }
  return -1;
80105847:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010584c:	c9                   	leave  
8010584d:	c3                   	ret    

8010584e <sys_dup>:

int
sys_dup(void)
{
8010584e:	55                   	push   %ebp
8010584f:	89 e5                	mov    %esp,%ebp
80105851:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80105854:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105857:	89 44 24 08          	mov    %eax,0x8(%esp)
8010585b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105862:	00 
80105863:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010586a:	e8 1d ff ff ff       	call   8010578c <argfd>
8010586f:	85 c0                	test   %eax,%eax
80105871:	79 07                	jns    8010587a <sys_dup+0x2c>
    return -1;
80105873:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105878:	eb 29                	jmp    801058a3 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
8010587a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010587d:	89 04 24             	mov    %eax,(%esp)
80105880:	e8 7b ff ff ff       	call   80105800 <fdalloc>
80105885:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105888:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010588c:	79 07                	jns    80105895 <sys_dup+0x47>
    return -1;
8010588e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105893:	eb 0e                	jmp    801058a3 <sys_dup+0x55>
  filedup(f);
80105895:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105898:	89 04 24             	mov    %eax,(%esp)
8010589b:	e8 45 b7 ff ff       	call   80100fe5 <filedup>
  return fd;
801058a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801058a3:	c9                   	leave  
801058a4:	c3                   	ret    

801058a5 <sys_read>:

int
sys_read(void)
{
801058a5:	55                   	push   %ebp
801058a6:	89 e5                	mov    %esp,%ebp
801058a8:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801058ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058ae:	89 44 24 08          	mov    %eax,0x8(%esp)
801058b2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801058b9:	00 
801058ba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801058c1:	e8 c6 fe ff ff       	call   8010578c <argfd>
801058c6:	85 c0                	test   %eax,%eax
801058c8:	78 35                	js     801058ff <sys_read+0x5a>
801058ca:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058cd:	89 44 24 04          	mov    %eax,0x4(%esp)
801058d1:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801058d8:	e8 59 fd ff ff       	call   80105636 <argint>
801058dd:	85 c0                	test   %eax,%eax
801058df:	78 1e                	js     801058ff <sys_read+0x5a>
801058e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058e4:	89 44 24 08          	mov    %eax,0x8(%esp)
801058e8:	8d 45 ec             	lea    -0x14(%ebp),%eax
801058eb:	89 44 24 04          	mov    %eax,0x4(%esp)
801058ef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801058f6:	e8 68 fd ff ff       	call   80105663 <argptr>
801058fb:	85 c0                	test   %eax,%eax
801058fd:	79 07                	jns    80105906 <sys_read+0x61>
    return -1;
801058ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105904:	eb 19                	jmp    8010591f <sys_read+0x7a>
  return fileread(f, p, n);
80105906:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105909:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010590c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010590f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105913:	89 54 24 04          	mov    %edx,0x4(%esp)
80105917:	89 04 24             	mov    %eax,(%esp)
8010591a:	e8 33 b8 ff ff       	call   80101152 <fileread>
}
8010591f:	c9                   	leave  
80105920:	c3                   	ret    

80105921 <sys_write>:

int
sys_write(void)
{
80105921:	55                   	push   %ebp
80105922:	89 e5                	mov    %esp,%ebp
80105924:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105927:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010592a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010592e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105935:	00 
80105936:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010593d:	e8 4a fe ff ff       	call   8010578c <argfd>
80105942:	85 c0                	test   %eax,%eax
80105944:	78 35                	js     8010597b <sys_write+0x5a>
80105946:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105949:	89 44 24 04          	mov    %eax,0x4(%esp)
8010594d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105954:	e8 dd fc ff ff       	call   80105636 <argint>
80105959:	85 c0                	test   %eax,%eax
8010595b:	78 1e                	js     8010597b <sys_write+0x5a>
8010595d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105960:	89 44 24 08          	mov    %eax,0x8(%esp)
80105964:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105967:	89 44 24 04          	mov    %eax,0x4(%esp)
8010596b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105972:	e8 ec fc ff ff       	call   80105663 <argptr>
80105977:	85 c0                	test   %eax,%eax
80105979:	79 07                	jns    80105982 <sys_write+0x61>
    return -1;
8010597b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105980:	eb 19                	jmp    8010599b <sys_write+0x7a>
  return filewrite(f, p, n);
80105982:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105985:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105988:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010598b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010598f:	89 54 24 04          	mov    %edx,0x4(%esp)
80105993:	89 04 24             	mov    %eax,(%esp)
80105996:	e8 73 b8 ff ff       	call   8010120e <filewrite>
}
8010599b:	c9                   	leave  
8010599c:	c3                   	ret    

8010599d <sys_close>:

int
sys_close(void)
{
8010599d:	55                   	push   %ebp
8010599e:	89 e5                	mov    %esp,%ebp
801059a0:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
801059a3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801059a6:	89 44 24 08          	mov    %eax,0x8(%esp)
801059aa:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059ad:	89 44 24 04          	mov    %eax,0x4(%esp)
801059b1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801059b8:	e8 cf fd ff ff       	call   8010578c <argfd>
801059bd:	85 c0                	test   %eax,%eax
801059bf:	79 07                	jns    801059c8 <sys_close+0x2b>
    return -1;
801059c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059c6:	eb 23                	jmp    801059eb <sys_close+0x4e>
  myproc()->ofile[fd] = 0;
801059c8:	e8 94 e7 ff ff       	call   80104161 <myproc>
801059cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801059d0:	83 c2 08             	add    $0x8,%edx
801059d3:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801059da:	00 
  fileclose(f);
801059db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059de:	89 04 24             	mov    %eax,(%esp)
801059e1:	e8 47 b6 ff ff       	call   8010102d <fileclose>
  return 0;
801059e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
801059eb:	c9                   	leave  
801059ec:	c3                   	ret    

801059ed <sys_fstat>:

int
sys_fstat(void)
{
801059ed:	55                   	push   %ebp
801059ee:	89 e5                	mov    %esp,%ebp
801059f0:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801059f3:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059f6:	89 44 24 08          	mov    %eax,0x8(%esp)
801059fa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105a01:	00 
80105a02:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105a09:	e8 7e fd ff ff       	call   8010578c <argfd>
80105a0e:	85 c0                	test   %eax,%eax
80105a10:	78 1f                	js     80105a31 <sys_fstat+0x44>
80105a12:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80105a19:	00 
80105a1a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105a1d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a21:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105a28:	e8 36 fc ff ff       	call   80105663 <argptr>
80105a2d:	85 c0                	test   %eax,%eax
80105a2f:	79 07                	jns    80105a38 <sys_fstat+0x4b>
    return -1;
80105a31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a36:	eb 12                	jmp    80105a4a <sys_fstat+0x5d>
  return filestat(f, st);
80105a38:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a3e:	89 54 24 04          	mov    %edx,0x4(%esp)
80105a42:	89 04 24             	mov    %eax,(%esp)
80105a45:	e8 b9 b6 ff ff       	call   80101103 <filestat>
}
80105a4a:	c9                   	leave  
80105a4b:	c3                   	ret    

80105a4c <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105a4c:	55                   	push   %ebp
80105a4d:	89 e5                	mov    %esp,%ebp
80105a4f:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105a52:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105a55:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a59:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105a60:	e8 68 fc ff ff       	call   801056cd <argstr>
80105a65:	85 c0                	test   %eax,%eax
80105a67:	78 17                	js     80105a80 <sys_link+0x34>
80105a69:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105a6c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a70:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105a77:	e8 51 fc ff ff       	call   801056cd <argstr>
80105a7c:	85 c0                	test   %eax,%eax
80105a7e:	79 0a                	jns    80105a8a <sys_link+0x3e>
    return -1;
80105a80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a85:	e9 42 01 00 00       	jmp    80105bcc <sys_link+0x180>

  begin_op();
80105a8a:	e8 f8 d9 ff ff       	call   80103487 <begin_op>
  if((ip = namei(old)) == 0){
80105a8f:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105a92:	89 04 24             	mov    %eax,(%esp)
80105a95:	e8 fd c9 ff ff       	call   80102497 <namei>
80105a9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105a9d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105aa1:	75 0f                	jne    80105ab2 <sys_link+0x66>
    end_op();
80105aa3:	e8 63 da ff ff       	call   8010350b <end_op>
    return -1;
80105aa8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105aad:	e9 1a 01 00 00       	jmp    80105bcc <sys_link+0x180>
  }

  ilock(ip);
80105ab2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ab5:	89 04 24             	mov    %eax,(%esp)
80105ab8:	e8 a0 be ff ff       	call   8010195d <ilock>
  if(ip->type == T_DIR){
80105abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ac0:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105ac4:	66 83 f8 01          	cmp    $0x1,%ax
80105ac8:	75 1a                	jne    80105ae4 <sys_link+0x98>
    iunlockput(ip);
80105aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105acd:	89 04 24             	mov    %eax,(%esp)
80105ad0:	e8 8a c0 ff ff       	call   80101b5f <iunlockput>
    end_op();
80105ad5:	e8 31 da ff ff       	call   8010350b <end_op>
    return -1;
80105ada:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105adf:	e9 e8 00 00 00       	jmp    80105bcc <sys_link+0x180>
  }

  ip->nlink++;
80105ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ae7:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105aeb:	8d 50 01             	lea    0x1(%eax),%edx
80105aee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105af1:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80105af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105af8:	89 04 24             	mov    %eax,(%esp)
80105afb:	e8 98 bc ff ff       	call   80101798 <iupdate>
  iunlock(ip);
80105b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b03:	89 04 24             	mov    %eax,(%esp)
80105b06:	e8 5f bf ff ff       	call   80101a6a <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80105b0b:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105b0e:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105b11:	89 54 24 04          	mov    %edx,0x4(%esp)
80105b15:	89 04 24             	mov    %eax,(%esp)
80105b18:	e8 9c c9 ff ff       	call   801024b9 <nameiparent>
80105b1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105b20:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105b24:	75 02                	jne    80105b28 <sys_link+0xdc>
    goto bad;
80105b26:	eb 68                	jmp    80105b90 <sys_link+0x144>
  ilock(dp);
80105b28:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b2b:	89 04 24             	mov    %eax,(%esp)
80105b2e:	e8 2a be ff ff       	call   8010195d <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105b33:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b36:	8b 10                	mov    (%eax),%edx
80105b38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b3b:	8b 00                	mov    (%eax),%eax
80105b3d:	39 c2                	cmp    %eax,%edx
80105b3f:	75 20                	jne    80105b61 <sys_link+0x115>
80105b41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b44:	8b 40 04             	mov    0x4(%eax),%eax
80105b47:	89 44 24 08          	mov    %eax,0x8(%esp)
80105b4b:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105b4e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b52:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b55:	89 04 24             	mov    %eax,(%esp)
80105b58:	e8 7b c6 ff ff       	call   801021d8 <dirlink>
80105b5d:	85 c0                	test   %eax,%eax
80105b5f:	79 0d                	jns    80105b6e <sys_link+0x122>
    iunlockput(dp);
80105b61:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b64:	89 04 24             	mov    %eax,(%esp)
80105b67:	e8 f3 bf ff ff       	call   80101b5f <iunlockput>
    goto bad;
80105b6c:	eb 22                	jmp    80105b90 <sys_link+0x144>
  }
  iunlockput(dp);
80105b6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b71:	89 04 24             	mov    %eax,(%esp)
80105b74:	e8 e6 bf ff ff       	call   80101b5f <iunlockput>
  iput(ip);
80105b79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b7c:	89 04 24             	mov    %eax,(%esp)
80105b7f:	e8 2a bf ff ff       	call   80101aae <iput>

  end_op();
80105b84:	e8 82 d9 ff ff       	call   8010350b <end_op>

  return 0;
80105b89:	b8 00 00 00 00       	mov    $0x0,%eax
80105b8e:	eb 3c                	jmp    80105bcc <sys_link+0x180>

bad:
  ilock(ip);
80105b90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b93:	89 04 24             	mov    %eax,(%esp)
80105b96:	e8 c2 bd ff ff       	call   8010195d <ilock>
  ip->nlink--;
80105b9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b9e:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105ba2:	8d 50 ff             	lea    -0x1(%eax),%edx
80105ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ba8:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80105bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105baf:	89 04 24             	mov    %eax,(%esp)
80105bb2:	e8 e1 bb ff ff       	call   80101798 <iupdate>
  iunlockput(ip);
80105bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bba:	89 04 24             	mov    %eax,(%esp)
80105bbd:	e8 9d bf ff ff       	call   80101b5f <iunlockput>
  end_op();
80105bc2:	e8 44 d9 ff ff       	call   8010350b <end_op>
  return -1;
80105bc7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105bcc:	c9                   	leave  
80105bcd:	c3                   	ret    

80105bce <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105bce:	55                   	push   %ebp
80105bcf:	89 e5                	mov    %esp,%ebp
80105bd1:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105bd4:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105bdb:	eb 4b                	jmp    80105c28 <isdirempty+0x5a>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105bdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105be0:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105be7:	00 
80105be8:	89 44 24 08          	mov    %eax,0x8(%esp)
80105bec:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105bef:	89 44 24 04          	mov    %eax,0x4(%esp)
80105bf3:	8b 45 08             	mov    0x8(%ebp),%eax
80105bf6:	89 04 24             	mov    %eax,(%esp)
80105bf9:	e8 fc c1 ff ff       	call   80101dfa <readi>
80105bfe:	83 f8 10             	cmp    $0x10,%eax
80105c01:	74 0c                	je     80105c0f <isdirempty+0x41>
      panic("isdirempty: readi");
80105c03:	c7 04 24 c8 89 10 80 	movl   $0x801089c8,(%esp)
80105c0a:	e8 53 a9 ff ff       	call   80100562 <panic>
    if(de.inum != 0)
80105c0f:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105c13:	66 85 c0             	test   %ax,%ax
80105c16:	74 07                	je     80105c1f <isdirempty+0x51>
      return 0;
80105c18:	b8 00 00 00 00       	mov    $0x0,%eax
80105c1d:	eb 1b                	jmp    80105c3a <isdirempty+0x6c>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c22:	83 c0 10             	add    $0x10,%eax
80105c25:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105c28:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105c2b:	8b 45 08             	mov    0x8(%ebp),%eax
80105c2e:	8b 40 58             	mov    0x58(%eax),%eax
80105c31:	39 c2                	cmp    %eax,%edx
80105c33:	72 a8                	jb     80105bdd <isdirempty+0xf>
  }
  return 1;
80105c35:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105c3a:	c9                   	leave  
80105c3b:	c3                   	ret    

80105c3c <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105c3c:	55                   	push   %ebp
80105c3d:	89 e5                	mov    %esp,%ebp
80105c3f:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105c42:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105c45:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c49:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105c50:	e8 78 fa ff ff       	call   801056cd <argstr>
80105c55:	85 c0                	test   %eax,%eax
80105c57:	79 0a                	jns    80105c63 <sys_unlink+0x27>
    return -1;
80105c59:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c5e:	e9 af 01 00 00       	jmp    80105e12 <sys_unlink+0x1d6>

  begin_op();
80105c63:	e8 1f d8 ff ff       	call   80103487 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105c68:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105c6b:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105c6e:	89 54 24 04          	mov    %edx,0x4(%esp)
80105c72:	89 04 24             	mov    %eax,(%esp)
80105c75:	e8 3f c8 ff ff       	call   801024b9 <nameiparent>
80105c7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105c7d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c81:	75 0f                	jne    80105c92 <sys_unlink+0x56>
    end_op();
80105c83:	e8 83 d8 ff ff       	call   8010350b <end_op>
    return -1;
80105c88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c8d:	e9 80 01 00 00       	jmp    80105e12 <sys_unlink+0x1d6>
  }

  ilock(dp);
80105c92:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c95:	89 04 24             	mov    %eax,(%esp)
80105c98:	e8 c0 bc ff ff       	call   8010195d <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105c9d:	c7 44 24 04 da 89 10 	movl   $0x801089da,0x4(%esp)
80105ca4:	80 
80105ca5:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105ca8:	89 04 24             	mov    %eax,(%esp)
80105cab:	e8 3d c4 ff ff       	call   801020ed <namecmp>
80105cb0:	85 c0                	test   %eax,%eax
80105cb2:	0f 84 45 01 00 00    	je     80105dfd <sys_unlink+0x1c1>
80105cb8:	c7 44 24 04 dc 89 10 	movl   $0x801089dc,0x4(%esp)
80105cbf:	80 
80105cc0:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105cc3:	89 04 24             	mov    %eax,(%esp)
80105cc6:	e8 22 c4 ff ff       	call   801020ed <namecmp>
80105ccb:	85 c0                	test   %eax,%eax
80105ccd:	0f 84 2a 01 00 00    	je     80105dfd <sys_unlink+0x1c1>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105cd3:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105cd6:	89 44 24 08          	mov    %eax,0x8(%esp)
80105cda:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105cdd:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ce4:	89 04 24             	mov    %eax,(%esp)
80105ce7:	e8 23 c4 ff ff       	call   8010210f <dirlookup>
80105cec:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105cef:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105cf3:	75 05                	jne    80105cfa <sys_unlink+0xbe>
    goto bad;
80105cf5:	e9 03 01 00 00       	jmp    80105dfd <sys_unlink+0x1c1>
  ilock(ip);
80105cfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cfd:	89 04 24             	mov    %eax,(%esp)
80105d00:	e8 58 bc ff ff       	call   8010195d <ilock>

  if(ip->nlink < 1)
80105d05:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d08:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105d0c:	66 85 c0             	test   %ax,%ax
80105d0f:	7f 0c                	jg     80105d1d <sys_unlink+0xe1>
    panic("unlink: nlink < 1");
80105d11:	c7 04 24 df 89 10 80 	movl   $0x801089df,(%esp)
80105d18:	e8 45 a8 ff ff       	call   80100562 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105d1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d20:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105d24:	66 83 f8 01          	cmp    $0x1,%ax
80105d28:	75 1f                	jne    80105d49 <sys_unlink+0x10d>
80105d2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d2d:	89 04 24             	mov    %eax,(%esp)
80105d30:	e8 99 fe ff ff       	call   80105bce <isdirempty>
80105d35:	85 c0                	test   %eax,%eax
80105d37:	75 10                	jne    80105d49 <sys_unlink+0x10d>
    iunlockput(ip);
80105d39:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d3c:	89 04 24             	mov    %eax,(%esp)
80105d3f:	e8 1b be ff ff       	call   80101b5f <iunlockput>
    goto bad;
80105d44:	e9 b4 00 00 00       	jmp    80105dfd <sys_unlink+0x1c1>
  }

  memset(&de, 0, sizeof(de));
80105d49:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80105d50:	00 
80105d51:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105d58:	00 
80105d59:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105d5c:	89 04 24             	mov    %eax,(%esp)
80105d5f:	e8 89 f5 ff ff       	call   801052ed <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105d64:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105d67:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105d6e:	00 
80105d6f:	89 44 24 08          	mov    %eax,0x8(%esp)
80105d73:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105d76:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d7d:	89 04 24             	mov    %eax,(%esp)
80105d80:	e8 d9 c1 ff ff       	call   80101f5e <writei>
80105d85:	83 f8 10             	cmp    $0x10,%eax
80105d88:	74 0c                	je     80105d96 <sys_unlink+0x15a>
    panic("unlink: writei");
80105d8a:	c7 04 24 f1 89 10 80 	movl   $0x801089f1,(%esp)
80105d91:	e8 cc a7 ff ff       	call   80100562 <panic>
  if(ip->type == T_DIR){
80105d96:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d99:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105d9d:	66 83 f8 01          	cmp    $0x1,%ax
80105da1:	75 1c                	jne    80105dbf <sys_unlink+0x183>
    dp->nlink--;
80105da3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105da6:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105daa:	8d 50 ff             	lea    -0x1(%eax),%edx
80105dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105db0:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
80105db4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105db7:	89 04 24             	mov    %eax,(%esp)
80105dba:	e8 d9 b9 ff ff       	call   80101798 <iupdate>
  }
  iunlockput(dp);
80105dbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dc2:	89 04 24             	mov    %eax,(%esp)
80105dc5:	e8 95 bd ff ff       	call   80101b5f <iunlockput>

  ip->nlink--;
80105dca:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dcd:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105dd1:	8d 50 ff             	lea    -0x1(%eax),%edx
80105dd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dd7:	66 89 50 56          	mov    %dx,0x56(%eax)
  iupdate(ip);
80105ddb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dde:	89 04 24             	mov    %eax,(%esp)
80105de1:	e8 b2 b9 ff ff       	call   80101798 <iupdate>
  iunlockput(ip);
80105de6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105de9:	89 04 24             	mov    %eax,(%esp)
80105dec:	e8 6e bd ff ff       	call   80101b5f <iunlockput>

  end_op();
80105df1:	e8 15 d7 ff ff       	call   8010350b <end_op>

  return 0;
80105df6:	b8 00 00 00 00       	mov    $0x0,%eax
80105dfb:	eb 15                	jmp    80105e12 <sys_unlink+0x1d6>

bad:
  iunlockput(dp);
80105dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e00:	89 04 24             	mov    %eax,(%esp)
80105e03:	e8 57 bd ff ff       	call   80101b5f <iunlockput>
  end_op();
80105e08:	e8 fe d6 ff ff       	call   8010350b <end_op>
  return -1;
80105e0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e12:	c9                   	leave  
80105e13:	c3                   	ret    

80105e14 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105e14:	55                   	push   %ebp
80105e15:	89 e5                	mov    %esp,%ebp
80105e17:	83 ec 48             	sub    $0x48,%esp
80105e1a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105e1d:	8b 55 10             	mov    0x10(%ebp),%edx
80105e20:	8b 45 14             	mov    0x14(%ebp),%eax
80105e23:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105e27:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105e2b:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105e2f:	8d 45 de             	lea    -0x22(%ebp),%eax
80105e32:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e36:	8b 45 08             	mov    0x8(%ebp),%eax
80105e39:	89 04 24             	mov    %eax,(%esp)
80105e3c:	e8 78 c6 ff ff       	call   801024b9 <nameiparent>
80105e41:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105e44:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e48:	75 0a                	jne    80105e54 <create+0x40>
    return 0;
80105e4a:	b8 00 00 00 00       	mov    $0x0,%eax
80105e4f:	e9 7e 01 00 00       	jmp    80105fd2 <create+0x1be>
  ilock(dp);
80105e54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e57:	89 04 24             	mov    %eax,(%esp)
80105e5a:	e8 fe ba ff ff       	call   8010195d <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80105e5f:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105e62:	89 44 24 08          	mov    %eax,0x8(%esp)
80105e66:	8d 45 de             	lea    -0x22(%ebp),%eax
80105e69:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e70:	89 04 24             	mov    %eax,(%esp)
80105e73:	e8 97 c2 ff ff       	call   8010210f <dirlookup>
80105e78:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105e7b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105e7f:	74 47                	je     80105ec8 <create+0xb4>
    iunlockput(dp);
80105e81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e84:	89 04 24             	mov    %eax,(%esp)
80105e87:	e8 d3 bc ff ff       	call   80101b5f <iunlockput>
    ilock(ip);
80105e8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e8f:	89 04 24             	mov    %eax,(%esp)
80105e92:	e8 c6 ba ff ff       	call   8010195d <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105e97:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105e9c:	75 15                	jne    80105eb3 <create+0x9f>
80105e9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ea1:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80105ea5:	66 83 f8 02          	cmp    $0x2,%ax
80105ea9:	75 08                	jne    80105eb3 <create+0x9f>
      return ip;
80105eab:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105eae:	e9 1f 01 00 00       	jmp    80105fd2 <create+0x1be>
    iunlockput(ip);
80105eb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105eb6:	89 04 24             	mov    %eax,(%esp)
80105eb9:	e8 a1 bc ff ff       	call   80101b5f <iunlockput>
    return 0;
80105ebe:	b8 00 00 00 00       	mov    $0x0,%eax
80105ec3:	e9 0a 01 00 00       	jmp    80105fd2 <create+0x1be>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105ec8:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105ecc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ecf:	8b 00                	mov    (%eax),%eax
80105ed1:	89 54 24 04          	mov    %edx,0x4(%esp)
80105ed5:	89 04 24             	mov    %eax,(%esp)
80105ed8:	e8 e6 b7 ff ff       	call   801016c3 <ialloc>
80105edd:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105ee0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105ee4:	75 0c                	jne    80105ef2 <create+0xde>
    panic("create: ialloc");
80105ee6:	c7 04 24 00 8a 10 80 	movl   $0x80108a00,(%esp)
80105eed:	e8 70 a6 ff ff       	call   80100562 <panic>

  ilock(ip);
80105ef2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ef5:	89 04 24             	mov    %eax,(%esp)
80105ef8:	e8 60 ba ff ff       	call   8010195d <ilock>
  ip->major = major;
80105efd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f00:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80105f04:	66 89 50 52          	mov    %dx,0x52(%eax)
  ip->minor = minor;
80105f08:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f0b:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80105f0f:	66 89 50 54          	mov    %dx,0x54(%eax)
  ip->nlink = 1;
80105f13:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f16:	66 c7 40 56 01 00    	movw   $0x1,0x56(%eax)
  iupdate(ip);
80105f1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f1f:	89 04 24             	mov    %eax,(%esp)
80105f22:	e8 71 b8 ff ff       	call   80101798 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80105f27:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105f2c:	75 6a                	jne    80105f98 <create+0x184>
    dp->nlink++;  // for ".."
80105f2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f31:	0f b7 40 56          	movzwl 0x56(%eax),%eax
80105f35:	8d 50 01             	lea    0x1(%eax),%edx
80105f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f3b:	66 89 50 56          	mov    %dx,0x56(%eax)
    iupdate(dp);
80105f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f42:	89 04 24             	mov    %eax,(%esp)
80105f45:	e8 4e b8 ff ff       	call   80101798 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105f4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f4d:	8b 40 04             	mov    0x4(%eax),%eax
80105f50:	89 44 24 08          	mov    %eax,0x8(%esp)
80105f54:	c7 44 24 04 da 89 10 	movl   $0x801089da,0x4(%esp)
80105f5b:	80 
80105f5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f5f:	89 04 24             	mov    %eax,(%esp)
80105f62:	e8 71 c2 ff ff       	call   801021d8 <dirlink>
80105f67:	85 c0                	test   %eax,%eax
80105f69:	78 21                	js     80105f8c <create+0x178>
80105f6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f6e:	8b 40 04             	mov    0x4(%eax),%eax
80105f71:	89 44 24 08          	mov    %eax,0x8(%esp)
80105f75:	c7 44 24 04 dc 89 10 	movl   $0x801089dc,0x4(%esp)
80105f7c:	80 
80105f7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f80:	89 04 24             	mov    %eax,(%esp)
80105f83:	e8 50 c2 ff ff       	call   801021d8 <dirlink>
80105f88:	85 c0                	test   %eax,%eax
80105f8a:	79 0c                	jns    80105f98 <create+0x184>
      panic("create dots");
80105f8c:	c7 04 24 0f 8a 10 80 	movl   $0x80108a0f,(%esp)
80105f93:	e8 ca a5 ff ff       	call   80100562 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105f98:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f9b:	8b 40 04             	mov    0x4(%eax),%eax
80105f9e:	89 44 24 08          	mov    %eax,0x8(%esp)
80105fa2:	8d 45 de             	lea    -0x22(%ebp),%eax
80105fa5:	89 44 24 04          	mov    %eax,0x4(%esp)
80105fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fac:	89 04 24             	mov    %eax,(%esp)
80105faf:	e8 24 c2 ff ff       	call   801021d8 <dirlink>
80105fb4:	85 c0                	test   %eax,%eax
80105fb6:	79 0c                	jns    80105fc4 <create+0x1b0>
    panic("create: dirlink");
80105fb8:	c7 04 24 1b 8a 10 80 	movl   $0x80108a1b,(%esp)
80105fbf:	e8 9e a5 ff ff       	call   80100562 <panic>

  iunlockput(dp);
80105fc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fc7:	89 04 24             	mov    %eax,(%esp)
80105fca:	e8 90 bb ff ff       	call   80101b5f <iunlockput>

  return ip;
80105fcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105fd2:	c9                   	leave  
80105fd3:	c3                   	ret    

80105fd4 <sys_open>:

int
sys_open(void)
{
80105fd4:	55                   	push   %ebp
80105fd5:	89 e5                	mov    %esp,%ebp
80105fd7:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105fda:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105fdd:	89 44 24 04          	mov    %eax,0x4(%esp)
80105fe1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105fe8:	e8 e0 f6 ff ff       	call   801056cd <argstr>
80105fed:	85 c0                	test   %eax,%eax
80105fef:	78 17                	js     80106008 <sys_open+0x34>
80105ff1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105ff4:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ff8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105fff:	e8 32 f6 ff ff       	call   80105636 <argint>
80106004:	85 c0                	test   %eax,%eax
80106006:	79 0a                	jns    80106012 <sys_open+0x3e>
    return -1;
80106008:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010600d:	e9 5c 01 00 00       	jmp    8010616e <sys_open+0x19a>

  begin_op();
80106012:	e8 70 d4 ff ff       	call   80103487 <begin_op>

  if(omode & O_CREATE){
80106017:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010601a:	25 00 02 00 00       	and    $0x200,%eax
8010601f:	85 c0                	test   %eax,%eax
80106021:	74 3b                	je     8010605e <sys_open+0x8a>
    ip = create(path, T_FILE, 0, 0);
80106023:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106026:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
8010602d:	00 
8010602e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106035:	00 
80106036:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
8010603d:	00 
8010603e:	89 04 24             	mov    %eax,(%esp)
80106041:	e8 ce fd ff ff       	call   80105e14 <create>
80106046:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80106049:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010604d:	75 6b                	jne    801060ba <sys_open+0xe6>
      end_op();
8010604f:	e8 b7 d4 ff ff       	call   8010350b <end_op>
      return -1;
80106054:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106059:	e9 10 01 00 00       	jmp    8010616e <sys_open+0x19a>
    }
  } else {
    if((ip = namei(path)) == 0){
8010605e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106061:	89 04 24             	mov    %eax,(%esp)
80106064:	e8 2e c4 ff ff       	call   80102497 <namei>
80106069:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010606c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106070:	75 0f                	jne    80106081 <sys_open+0xad>
      end_op();
80106072:	e8 94 d4 ff ff       	call   8010350b <end_op>
      return -1;
80106077:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010607c:	e9 ed 00 00 00       	jmp    8010616e <sys_open+0x19a>
    }
    ilock(ip);
80106081:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106084:	89 04 24             	mov    %eax,(%esp)
80106087:	e8 d1 b8 ff ff       	call   8010195d <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
8010608c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010608f:	0f b7 40 50          	movzwl 0x50(%eax),%eax
80106093:	66 83 f8 01          	cmp    $0x1,%ax
80106097:	75 21                	jne    801060ba <sys_open+0xe6>
80106099:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010609c:	85 c0                	test   %eax,%eax
8010609e:	74 1a                	je     801060ba <sys_open+0xe6>
      iunlockput(ip);
801060a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060a3:	89 04 24             	mov    %eax,(%esp)
801060a6:	e8 b4 ba ff ff       	call   80101b5f <iunlockput>
      end_op();
801060ab:	e8 5b d4 ff ff       	call   8010350b <end_op>
      return -1;
801060b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060b5:	e9 b4 00 00 00       	jmp    8010616e <sys_open+0x19a>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801060ba:	e8 c6 ae ff ff       	call   80100f85 <filealloc>
801060bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
801060c2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801060c6:	74 14                	je     801060dc <sys_open+0x108>
801060c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060cb:	89 04 24             	mov    %eax,(%esp)
801060ce:	e8 2d f7 ff ff       	call   80105800 <fdalloc>
801060d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
801060d6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801060da:	79 28                	jns    80106104 <sys_open+0x130>
    if(f)
801060dc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801060e0:	74 0b                	je     801060ed <sys_open+0x119>
      fileclose(f);
801060e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060e5:	89 04 24             	mov    %eax,(%esp)
801060e8:	e8 40 af ff ff       	call   8010102d <fileclose>
    iunlockput(ip);
801060ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060f0:	89 04 24             	mov    %eax,(%esp)
801060f3:	e8 67 ba ff ff       	call   80101b5f <iunlockput>
    end_op();
801060f8:	e8 0e d4 ff ff       	call   8010350b <end_op>
    return -1;
801060fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106102:	eb 6a                	jmp    8010616e <sys_open+0x19a>
  }
  iunlock(ip);
80106104:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106107:	89 04 24             	mov    %eax,(%esp)
8010610a:	e8 5b b9 ff ff       	call   80101a6a <iunlock>
  end_op();
8010610f:	e8 f7 d3 ff ff       	call   8010350b <end_op>

  f->type = FD_INODE;
80106114:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106117:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
8010611d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106120:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106123:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80106126:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106129:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80106130:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106133:	83 e0 01             	and    $0x1,%eax
80106136:	85 c0                	test   %eax,%eax
80106138:	0f 94 c0             	sete   %al
8010613b:	89 c2                	mov    %eax,%edx
8010613d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106140:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106143:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106146:	83 e0 01             	and    $0x1,%eax
80106149:	85 c0                	test   %eax,%eax
8010614b:	75 0a                	jne    80106157 <sys_open+0x183>
8010614d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106150:	83 e0 02             	and    $0x2,%eax
80106153:	85 c0                	test   %eax,%eax
80106155:	74 07                	je     8010615e <sys_open+0x18a>
80106157:	b8 01 00 00 00       	mov    $0x1,%eax
8010615c:	eb 05                	jmp    80106163 <sys_open+0x18f>
8010615e:	b8 00 00 00 00       	mov    $0x0,%eax
80106163:	89 c2                	mov    %eax,%edx
80106165:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106168:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
8010616b:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
8010616e:	c9                   	leave  
8010616f:	c3                   	ret    

80106170 <sys_mkdir>:

int
sys_mkdir(void)
{
80106170:	55                   	push   %ebp
80106171:	89 e5                	mov    %esp,%ebp
80106173:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106176:	e8 0c d3 ff ff       	call   80103487 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010617b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010617e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106182:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106189:	e8 3f f5 ff ff       	call   801056cd <argstr>
8010618e:	85 c0                	test   %eax,%eax
80106190:	78 2c                	js     801061be <sys_mkdir+0x4e>
80106192:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106195:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
8010619c:	00 
8010619d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801061a4:	00 
801061a5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801061ac:	00 
801061ad:	89 04 24             	mov    %eax,(%esp)
801061b0:	e8 5f fc ff ff       	call   80105e14 <create>
801061b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801061b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801061bc:	75 0c                	jne    801061ca <sys_mkdir+0x5a>
    end_op();
801061be:	e8 48 d3 ff ff       	call   8010350b <end_op>
    return -1;
801061c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061c8:	eb 15                	jmp    801061df <sys_mkdir+0x6f>
  }
  iunlockput(ip);
801061ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061cd:	89 04 24             	mov    %eax,(%esp)
801061d0:	e8 8a b9 ff ff       	call   80101b5f <iunlockput>
  end_op();
801061d5:	e8 31 d3 ff ff       	call   8010350b <end_op>
  return 0;
801061da:	b8 00 00 00 00       	mov    $0x0,%eax
}
801061df:	c9                   	leave  
801061e0:	c3                   	ret    

801061e1 <sys_mknod>:

int
sys_mknod(void)
{
801061e1:	55                   	push   %ebp
801061e2:	89 e5                	mov    %esp,%ebp
801061e4:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801061e7:	e8 9b d2 ff ff       	call   80103487 <begin_op>
  if((argstr(0, &path)) < 0 ||
801061ec:	8d 45 f0             	lea    -0x10(%ebp),%eax
801061ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801061f3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801061fa:	e8 ce f4 ff ff       	call   801056cd <argstr>
801061ff:	85 c0                	test   %eax,%eax
80106201:	78 5e                	js     80106261 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80106203:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106206:	89 44 24 04          	mov    %eax,0x4(%esp)
8010620a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106211:	e8 20 f4 ff ff       	call   80105636 <argint>
  if((argstr(0, &path)) < 0 ||
80106216:	85 c0                	test   %eax,%eax
80106218:	78 47                	js     80106261 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
8010621a:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010621d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106221:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80106228:	e8 09 f4 ff ff       	call   80105636 <argint>
     argint(1, &major) < 0 ||
8010622d:	85 c0                	test   %eax,%eax
8010622f:	78 30                	js     80106261 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80106231:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106234:	0f bf c8             	movswl %ax,%ecx
80106237:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010623a:	0f bf d0             	movswl %ax,%edx
8010623d:	8b 45 f0             	mov    -0x10(%ebp),%eax
     argint(2, &minor) < 0 ||
80106240:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106244:	89 54 24 08          	mov    %edx,0x8(%esp)
80106248:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
8010624f:	00 
80106250:	89 04 24             	mov    %eax,(%esp)
80106253:	e8 bc fb ff ff       	call   80105e14 <create>
80106258:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010625b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010625f:	75 0c                	jne    8010626d <sys_mknod+0x8c>
    end_op();
80106261:	e8 a5 d2 ff ff       	call   8010350b <end_op>
    return -1;
80106266:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010626b:	eb 15                	jmp    80106282 <sys_mknod+0xa1>
  }
  iunlockput(ip);
8010626d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106270:	89 04 24             	mov    %eax,(%esp)
80106273:	e8 e7 b8 ff ff       	call   80101b5f <iunlockput>
  end_op();
80106278:	e8 8e d2 ff ff       	call   8010350b <end_op>
  return 0;
8010627d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106282:	c9                   	leave  
80106283:	c3                   	ret    

80106284 <sys_chdir>:

int
sys_chdir(void)
{
80106284:	55                   	push   %ebp
80106285:	89 e5                	mov    %esp,%ebp
80106287:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
8010628a:	e8 d2 de ff ff       	call   80104161 <myproc>
8010628f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  
  begin_op();
80106292:	e8 f0 d1 ff ff       	call   80103487 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80106297:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010629a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010629e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801062a5:	e8 23 f4 ff ff       	call   801056cd <argstr>
801062aa:	85 c0                	test   %eax,%eax
801062ac:	78 14                	js     801062c2 <sys_chdir+0x3e>
801062ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
801062b1:	89 04 24             	mov    %eax,(%esp)
801062b4:	e8 de c1 ff ff       	call   80102497 <namei>
801062b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
801062bc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801062c0:	75 0c                	jne    801062ce <sys_chdir+0x4a>
    end_op();
801062c2:	e8 44 d2 ff ff       	call   8010350b <end_op>
    return -1;
801062c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062cc:	eb 5b                	jmp    80106329 <sys_chdir+0xa5>
  }
  ilock(ip);
801062ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062d1:	89 04 24             	mov    %eax,(%esp)
801062d4:	e8 84 b6 ff ff       	call   8010195d <ilock>
  if(ip->type != T_DIR){
801062d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062dc:	0f b7 40 50          	movzwl 0x50(%eax),%eax
801062e0:	66 83 f8 01          	cmp    $0x1,%ax
801062e4:	74 17                	je     801062fd <sys_chdir+0x79>
    iunlockput(ip);
801062e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062e9:	89 04 24             	mov    %eax,(%esp)
801062ec:	e8 6e b8 ff ff       	call   80101b5f <iunlockput>
    end_op();
801062f1:	e8 15 d2 ff ff       	call   8010350b <end_op>
    return -1;
801062f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062fb:	eb 2c                	jmp    80106329 <sys_chdir+0xa5>
  }
  iunlock(ip);
801062fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106300:	89 04 24             	mov    %eax,(%esp)
80106303:	e8 62 b7 ff ff       	call   80101a6a <iunlock>
  iput(curproc->cwd);
80106308:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010630b:	8b 40 68             	mov    0x68(%eax),%eax
8010630e:	89 04 24             	mov    %eax,(%esp)
80106311:	e8 98 b7 ff ff       	call   80101aae <iput>
  end_op();
80106316:	e8 f0 d1 ff ff       	call   8010350b <end_op>
  curproc->cwd = ip;
8010631b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010631e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106321:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80106324:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106329:	c9                   	leave  
8010632a:	c3                   	ret    

8010632b <sys_exec>:

int
sys_exec(void)
{
8010632b:	55                   	push   %ebp
8010632c:	89 e5                	mov    %esp,%ebp
8010632e:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80106334:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106337:	89 44 24 04          	mov    %eax,0x4(%esp)
8010633b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106342:	e8 86 f3 ff ff       	call   801056cd <argstr>
80106347:	85 c0                	test   %eax,%eax
80106349:	78 1a                	js     80106365 <sys_exec+0x3a>
8010634b:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80106351:	89 44 24 04          	mov    %eax,0x4(%esp)
80106355:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010635c:	e8 d5 f2 ff ff       	call   80105636 <argint>
80106361:	85 c0                	test   %eax,%eax
80106363:	79 0a                	jns    8010636f <sys_exec+0x44>
    return -1;
80106365:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010636a:	e9 c8 00 00 00       	jmp    80106437 <sys_exec+0x10c>
  }
  memset(argv, 0, sizeof(argv));
8010636f:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80106376:	00 
80106377:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010637e:	00 
8010637f:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106385:	89 04 24             	mov    %eax,(%esp)
80106388:	e8 60 ef ff ff       	call   801052ed <memset>
  for(i=0;; i++){
8010638d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80106394:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106397:	83 f8 1f             	cmp    $0x1f,%eax
8010639a:	76 0a                	jbe    801063a6 <sys_exec+0x7b>
      return -1;
8010639c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063a1:	e9 91 00 00 00       	jmp    80106437 <sys_exec+0x10c>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801063a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063a9:	c1 e0 02             	shl    $0x2,%eax
801063ac:	89 c2                	mov    %eax,%edx
801063ae:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
801063b4:	01 c2                	add    %eax,%edx
801063b6:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801063bc:	89 44 24 04          	mov    %eax,0x4(%esp)
801063c0:	89 14 24             	mov    %edx,(%esp)
801063c3:	e8 cb f1 ff ff       	call   80105593 <fetchint>
801063c8:	85 c0                	test   %eax,%eax
801063ca:	79 07                	jns    801063d3 <sys_exec+0xa8>
      return -1;
801063cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063d1:	eb 64                	jmp    80106437 <sys_exec+0x10c>
    if(uarg == 0){
801063d3:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801063d9:	85 c0                	test   %eax,%eax
801063db:	75 26                	jne    80106403 <sys_exec+0xd8>
      argv[i] = 0;
801063dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063e0:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
801063e7:	00 00 00 00 
      break;
801063eb:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801063ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063ef:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
801063f5:	89 54 24 04          	mov    %edx,0x4(%esp)
801063f9:	89 04 24             	mov    %eax,(%esp)
801063fc:	e8 1d a7 ff ff       	call   80100b1e <exec>
80106401:	eb 34                	jmp    80106437 <sys_exec+0x10c>
    if(fetchstr(uarg, &argv[i]) < 0)
80106403:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106409:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010640c:	c1 e2 02             	shl    $0x2,%edx
8010640f:	01 c2                	add    %eax,%edx
80106411:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80106417:	89 54 24 04          	mov    %edx,0x4(%esp)
8010641b:	89 04 24             	mov    %eax,(%esp)
8010641e:	e8 af f1 ff ff       	call   801055d2 <fetchstr>
80106423:	85 c0                	test   %eax,%eax
80106425:	79 07                	jns    8010642e <sys_exec+0x103>
      return -1;
80106427:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010642c:	eb 09                	jmp    80106437 <sys_exec+0x10c>
  for(i=0;; i++){
8010642e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }
80106432:	e9 5d ff ff ff       	jmp    80106394 <sys_exec+0x69>
}
80106437:	c9                   	leave  
80106438:	c3                   	ret    

80106439 <sys_pipe>:

int
sys_pipe(void)
{
80106439:	55                   	push   %ebp
8010643a:	89 e5                	mov    %esp,%ebp
8010643c:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010643f:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80106446:	00 
80106447:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010644a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010644e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106455:	e8 09 f2 ff ff       	call   80105663 <argptr>
8010645a:	85 c0                	test   %eax,%eax
8010645c:	79 0a                	jns    80106468 <sys_pipe+0x2f>
    return -1;
8010645e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106463:	e9 9a 00 00 00       	jmp    80106502 <sys_pipe+0xc9>
  if(pipealloc(&rf, &wf) < 0)
80106468:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010646b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010646f:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106472:	89 04 24             	mov    %eax,(%esp)
80106475:	e8 6b d8 ff ff       	call   80103ce5 <pipealloc>
8010647a:	85 c0                	test   %eax,%eax
8010647c:	79 07                	jns    80106485 <sys_pipe+0x4c>
    return -1;
8010647e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106483:	eb 7d                	jmp    80106502 <sys_pipe+0xc9>
  fd0 = -1;
80106485:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010648c:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010648f:	89 04 24             	mov    %eax,(%esp)
80106492:	e8 69 f3 ff ff       	call   80105800 <fdalloc>
80106497:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010649a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010649e:	78 14                	js     801064b4 <sys_pipe+0x7b>
801064a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801064a3:	89 04 24             	mov    %eax,(%esp)
801064a6:	e8 55 f3 ff ff       	call   80105800 <fdalloc>
801064ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
801064ae:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801064b2:	79 36                	jns    801064ea <sys_pipe+0xb1>
    if(fd0 >= 0)
801064b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801064b8:	78 13                	js     801064cd <sys_pipe+0x94>
      myproc()->ofile[fd0] = 0;
801064ba:	e8 a2 dc ff ff       	call   80104161 <myproc>
801064bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
801064c2:	83 c2 08             	add    $0x8,%edx
801064c5:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801064cc:	00 
    fileclose(rf);
801064cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
801064d0:	89 04 24             	mov    %eax,(%esp)
801064d3:	e8 55 ab ff ff       	call   8010102d <fileclose>
    fileclose(wf);
801064d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801064db:	89 04 24             	mov    %eax,(%esp)
801064de:	e8 4a ab ff ff       	call   8010102d <fileclose>
    return -1;
801064e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064e8:	eb 18                	jmp    80106502 <sys_pipe+0xc9>
  }
  fd[0] = fd0;
801064ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
801064ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
801064f0:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
801064f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801064f5:	8d 50 04             	lea    0x4(%eax),%edx
801064f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064fb:	89 02                	mov    %eax,(%edx)
  return 0;
801064fd:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106502:	c9                   	leave  
80106503:	c3                   	ret    

80106504 <sys_fork>:
#include "proc.h"
#include "pstat.h"

int
sys_fork(void)
{
80106504:	55                   	push   %ebp
80106505:	89 e5                	mov    %esp,%ebp
80106507:	83 ec 08             	sub    $0x8,%esp
  return fork();
8010650a:	e8 6a df ff ff       	call   80104479 <fork>
}
8010650f:	c9                   	leave  
80106510:	c3                   	ret    

80106511 <sys_exit>:

int
sys_exit(void)
{
80106511:	55                   	push   %ebp
80106512:	89 e5                	mov    %esp,%ebp
80106514:	83 ec 08             	sub    $0x8,%esp
  exit();
80106517:	e8 f4 e0 ff ff       	call   80104610 <exit>
  return 0;  // not reached
8010651c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106521:	c9                   	leave  
80106522:	c3                   	ret    

80106523 <sys_wait>:

int
sys_wait(void)
{
80106523:	55                   	push   %ebp
80106524:	89 e5                	mov    %esp,%ebp
80106526:	83 ec 08             	sub    $0x8,%esp
  return wait();
80106529:	e8 ef e1 ff ff       	call   8010471d <wait>
}
8010652e:	c9                   	leave  
8010652f:	c3                   	ret    

80106530 <sys_kill>:

int
sys_kill(void)
{
80106530:	55                   	push   %ebp
80106531:	89 e5                	mov    %esp,%ebp
80106533:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106536:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106539:	89 44 24 04          	mov    %eax,0x4(%esp)
8010653d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106544:	e8 ed f0 ff ff       	call   80105636 <argint>
80106549:	85 c0                	test   %eax,%eax
8010654b:	79 07                	jns    80106554 <sys_kill+0x24>
    return -1;
8010654d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106552:	eb 0b                	jmp    8010655f <sys_kill+0x2f>
  return kill(pid);
80106554:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106557:	89 04 24             	mov    %eax,(%esp)
8010655a:	e8 4c e6 ff ff       	call   80104bab <kill>
}
8010655f:	c9                   	leave  
80106560:	c3                   	ret    

80106561 <sys_getpid>:

int
sys_getpid(void)
{
80106561:	55                   	push   %ebp
80106562:	89 e5                	mov    %esp,%ebp
80106564:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80106567:	e8 f5 db ff ff       	call   80104161 <myproc>
8010656c:	8b 40 10             	mov    0x10(%eax),%eax
}
8010656f:	c9                   	leave  
80106570:	c3                   	ret    

80106571 <sys_sbrk>:

int
sys_sbrk(void)
{
80106571:	55                   	push   %ebp
80106572:	89 e5                	mov    %esp,%ebp
80106574:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106577:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010657a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010657e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106585:	e8 ac f0 ff ff       	call   80105636 <argint>
8010658a:	85 c0                	test   %eax,%eax
8010658c:	79 07                	jns    80106595 <sys_sbrk+0x24>
    return -1;
8010658e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106593:	eb 23                	jmp    801065b8 <sys_sbrk+0x47>
  addr = myproc()->sz;
80106595:	e8 c7 db ff ff       	call   80104161 <myproc>
8010659a:	8b 00                	mov    (%eax),%eax
8010659c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
8010659f:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065a2:	89 04 24             	mov    %eax,(%esp)
801065a5:	e8 31 de ff ff       	call   801043db <growproc>
801065aa:	85 c0                	test   %eax,%eax
801065ac:	79 07                	jns    801065b5 <sys_sbrk+0x44>
    return -1;
801065ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065b3:	eb 03                	jmp    801065b8 <sys_sbrk+0x47>
  return addr;
801065b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801065b8:	c9                   	leave  
801065b9:	c3                   	ret    

801065ba <sys_sleep>:

int
sys_sleep(void)
{
801065ba:	55                   	push   %ebp
801065bb:	89 e5                	mov    %esp,%ebp
801065bd:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801065c0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801065c3:	89 44 24 04          	mov    %eax,0x4(%esp)
801065c7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801065ce:	e8 63 f0 ff ff       	call   80105636 <argint>
801065d3:	85 c0                	test   %eax,%eax
801065d5:	79 07                	jns    801065de <sys_sleep+0x24>
    return -1;
801065d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065dc:	eb 6b                	jmp    80106649 <sys_sleep+0x8f>
  acquire(&tickslock);
801065de:	c7 04 24 20 5f 11 80 	movl   $0x80115f20,(%esp)
801065e5:	e8 91 ea ff ff       	call   8010507b <acquire>
  ticks0 = ticks;
801065ea:	a1 60 67 11 80       	mov    0x80116760,%eax
801065ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
801065f2:	eb 33                	jmp    80106627 <sys_sleep+0x6d>
    if(myproc()->killed){
801065f4:	e8 68 db ff ff       	call   80104161 <myproc>
801065f9:	8b 40 24             	mov    0x24(%eax),%eax
801065fc:	85 c0                	test   %eax,%eax
801065fe:	74 13                	je     80106613 <sys_sleep+0x59>
      release(&tickslock);
80106600:	c7 04 24 20 5f 11 80 	movl   $0x80115f20,(%esp)
80106607:	e8 d7 ea ff ff       	call   801050e3 <release>
      return -1;
8010660c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106611:	eb 36                	jmp    80106649 <sys_sleep+0x8f>
    }
    sleep(&ticks, &tickslock);
80106613:	c7 44 24 04 20 5f 11 	movl   $0x80115f20,0x4(%esp)
8010661a:	80 
8010661b:	c7 04 24 60 67 11 80 	movl   $0x80116760,(%esp)
80106622:	e8 82 e4 ff ff       	call   80104aa9 <sleep>
  while(ticks - ticks0 < n){
80106627:	a1 60 67 11 80       	mov    0x80116760,%eax
8010662c:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010662f:	89 c2                	mov    %eax,%edx
80106631:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106634:	39 c2                	cmp    %eax,%edx
80106636:	72 bc                	jb     801065f4 <sys_sleep+0x3a>
  }
  release(&tickslock);
80106638:	c7 04 24 20 5f 11 80 	movl   $0x80115f20,(%esp)
8010663f:	e8 9f ea ff ff       	call   801050e3 <release>
  return 0;
80106644:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106649:	c9                   	leave  
8010664a:	c3                   	ret    

8010664b <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
8010664b:	55                   	push   %ebp
8010664c:	89 e5                	mov    %esp,%ebp
8010664e:	83 ec 28             	sub    $0x28,%esp
  uint xticks;

  acquire(&tickslock);
80106651:	c7 04 24 20 5f 11 80 	movl   $0x80115f20,(%esp)
80106658:	e8 1e ea ff ff       	call   8010507b <acquire>
  xticks = ticks;
8010665d:	a1 60 67 11 80       	mov    0x80116760,%eax
80106662:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80106665:	c7 04 24 20 5f 11 80 	movl   $0x80115f20,(%esp)
8010666c:	e8 72 ea ff ff       	call   801050e3 <release>
  return xticks;
80106671:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106674:	c9                   	leave  
80106675:	c3                   	ret    

80106676 <sys_getpinfo>:

extern void fillpstat(pstatTable *);
int
sys_getpinfo(void)
{
80106676:	55                   	push   %ebp
80106677:	89 e5                	mov    %esp,%ebp
80106679:	83 ec 28             	sub    $0x28,%esp
  struct pstatTable * ptr;

  argptr(0,(char **)&ptr, sizeof(struct pstatTable *));
8010667c:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80106683:	00 
80106684:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106687:	89 44 24 04          	mov    %eax,0x4(%esp)
8010668b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106692:	e8 cc ef ff ff       	call   80105663 <argptr>

  fillpstat((pstatTable *) ptr);
80106697:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010669a:	89 04 24             	mov    %eax,(%esp)
8010669d:	e8 7e e6 ff ff       	call   80104d20 <fillpstat>

  return 0;
801066a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
801066a7:	c9                   	leave  
801066a8:	c3                   	ret    

801066a9 <sys_settickets>:

int
sys_settickets(int number)
{
801066a9:	55                   	push   %ebp
801066aa:	89 e5                	mov    %esp,%ebp
801066ac:	83 ec 28             	sub    $0x28,%esp
  int n = 0;
801066af:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  argint(0, &n);
801066b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801066b9:	89 44 24 04          	mov    %eax,0x4(%esp)
801066bd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801066c4:	e8 6d ef ff ff       	call   80105636 <argint>
  if(n < 10)
801066c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066cc:	83 f8 09             	cmp    $0x9,%eax
801066cf:	7f 07                	jg     801066d8 <sys_settickets+0x2f>
  {
    return -1;
801066d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066d6:	eb 10                	jmp    801066e8 <sys_settickets+0x3f>
  }
  myproc()->tickets = n;
801066d8:	e8 84 da ff ff       	call   80104161 <myproc>
801066dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801066e0:	89 50 7c             	mov    %edx,0x7c(%eax)
  return 0;
801066e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801066e8:	c9                   	leave  
801066e9:	c3                   	ret    

801066ea <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801066ea:	1e                   	push   %ds
  pushl %es
801066eb:	06                   	push   %es
  pushl %fs
801066ec:	0f a0                	push   %fs
  pushl %gs
801066ee:	0f a8                	push   %gs
  pushal
801066f0:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801066f1:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801066f5:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801066f7:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801066f9:	54                   	push   %esp
  call trap
801066fa:	e8 d8 01 00 00       	call   801068d7 <trap>
  addl $4, %esp
801066ff:	83 c4 04             	add    $0x4,%esp

80106702 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106702:	61                   	popa   
  popl %gs
80106703:	0f a9                	pop    %gs
  popl %fs
80106705:	0f a1                	pop    %fs
  popl %es
80106707:	07                   	pop    %es
  popl %ds
80106708:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106709:	83 c4 08             	add    $0x8,%esp
  iret
8010670c:	cf                   	iret   

8010670d <lidt>:
{
8010670d:	55                   	push   %ebp
8010670e:	89 e5                	mov    %esp,%ebp
80106710:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80106713:	8b 45 0c             	mov    0xc(%ebp),%eax
80106716:	83 e8 01             	sub    $0x1,%eax
80106719:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010671d:	8b 45 08             	mov    0x8(%ebp),%eax
80106720:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106724:	8b 45 08             	mov    0x8(%ebp),%eax
80106727:	c1 e8 10             	shr    $0x10,%eax
8010672a:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010672e:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106731:	0f 01 18             	lidtl  (%eax)
}
80106734:	c9                   	leave  
80106735:	c3                   	ret    

80106736 <rcr2>:

static inline uint
rcr2(void)
{
80106736:	55                   	push   %ebp
80106737:	89 e5                	mov    %esp,%ebp
80106739:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010673c:	0f 20 d0             	mov    %cr2,%eax
8010673f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106742:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106745:	c9                   	leave  
80106746:	c3                   	ret    

80106747 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106747:	55                   	push   %ebp
80106748:	89 e5                	mov    %esp,%ebp
8010674a:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
8010674d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106754:	e9 c3 00 00 00       	jmp    8010681c <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106759:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010675c:	8b 04 85 a4 b0 10 80 	mov    -0x7fef4f5c(,%eax,4),%eax
80106763:	89 c2                	mov    %eax,%edx
80106765:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106768:	66 89 14 c5 60 5f 11 	mov    %dx,-0x7feea0a0(,%eax,8)
8010676f:	80 
80106770:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106773:	66 c7 04 c5 62 5f 11 	movw   $0x8,-0x7feea09e(,%eax,8)
8010677a:	80 08 00 
8010677d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106780:	0f b6 14 c5 64 5f 11 	movzbl -0x7feea09c(,%eax,8),%edx
80106787:	80 
80106788:	83 e2 e0             	and    $0xffffffe0,%edx
8010678b:	88 14 c5 64 5f 11 80 	mov    %dl,-0x7feea09c(,%eax,8)
80106792:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106795:	0f b6 14 c5 64 5f 11 	movzbl -0x7feea09c(,%eax,8),%edx
8010679c:	80 
8010679d:	83 e2 1f             	and    $0x1f,%edx
801067a0:	88 14 c5 64 5f 11 80 	mov    %dl,-0x7feea09c(,%eax,8)
801067a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067aa:	0f b6 14 c5 65 5f 11 	movzbl -0x7feea09b(,%eax,8),%edx
801067b1:	80 
801067b2:	83 e2 f0             	and    $0xfffffff0,%edx
801067b5:	83 ca 0e             	or     $0xe,%edx
801067b8:	88 14 c5 65 5f 11 80 	mov    %dl,-0x7feea09b(,%eax,8)
801067bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067c2:	0f b6 14 c5 65 5f 11 	movzbl -0x7feea09b(,%eax,8),%edx
801067c9:	80 
801067ca:	83 e2 ef             	and    $0xffffffef,%edx
801067cd:	88 14 c5 65 5f 11 80 	mov    %dl,-0x7feea09b(,%eax,8)
801067d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067d7:	0f b6 14 c5 65 5f 11 	movzbl -0x7feea09b(,%eax,8),%edx
801067de:	80 
801067df:	83 e2 9f             	and    $0xffffff9f,%edx
801067e2:	88 14 c5 65 5f 11 80 	mov    %dl,-0x7feea09b(,%eax,8)
801067e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067ec:	0f b6 14 c5 65 5f 11 	movzbl -0x7feea09b(,%eax,8),%edx
801067f3:	80 
801067f4:	83 ca 80             	or     $0xffffff80,%edx
801067f7:	88 14 c5 65 5f 11 80 	mov    %dl,-0x7feea09b(,%eax,8)
801067fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106801:	8b 04 85 a4 b0 10 80 	mov    -0x7fef4f5c(,%eax,4),%eax
80106808:	c1 e8 10             	shr    $0x10,%eax
8010680b:	89 c2                	mov    %eax,%edx
8010680d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106810:	66 89 14 c5 66 5f 11 	mov    %dx,-0x7feea09a(,%eax,8)
80106817:	80 
  for(i = 0; i < 256; i++)
80106818:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010681c:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106823:	0f 8e 30 ff ff ff    	jle    80106759 <tvinit+0x12>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106829:	a1 a4 b1 10 80       	mov    0x8010b1a4,%eax
8010682e:	66 a3 60 61 11 80    	mov    %ax,0x80116160
80106834:	66 c7 05 62 61 11 80 	movw   $0x8,0x80116162
8010683b:	08 00 
8010683d:	0f b6 05 64 61 11 80 	movzbl 0x80116164,%eax
80106844:	83 e0 e0             	and    $0xffffffe0,%eax
80106847:	a2 64 61 11 80       	mov    %al,0x80116164
8010684c:	0f b6 05 64 61 11 80 	movzbl 0x80116164,%eax
80106853:	83 e0 1f             	and    $0x1f,%eax
80106856:	a2 64 61 11 80       	mov    %al,0x80116164
8010685b:	0f b6 05 65 61 11 80 	movzbl 0x80116165,%eax
80106862:	83 c8 0f             	or     $0xf,%eax
80106865:	a2 65 61 11 80       	mov    %al,0x80116165
8010686a:	0f b6 05 65 61 11 80 	movzbl 0x80116165,%eax
80106871:	83 e0 ef             	and    $0xffffffef,%eax
80106874:	a2 65 61 11 80       	mov    %al,0x80116165
80106879:	0f b6 05 65 61 11 80 	movzbl 0x80116165,%eax
80106880:	83 c8 60             	or     $0x60,%eax
80106883:	a2 65 61 11 80       	mov    %al,0x80116165
80106888:	0f b6 05 65 61 11 80 	movzbl 0x80116165,%eax
8010688f:	83 c8 80             	or     $0xffffff80,%eax
80106892:	a2 65 61 11 80       	mov    %al,0x80116165
80106897:	a1 a4 b1 10 80       	mov    0x8010b1a4,%eax
8010689c:	c1 e8 10             	shr    $0x10,%eax
8010689f:	66 a3 66 61 11 80    	mov    %ax,0x80116166

  initlock(&tickslock, "time");
801068a5:	c7 44 24 04 2c 8a 10 	movl   $0x80108a2c,0x4(%esp)
801068ac:	80 
801068ad:	c7 04 24 20 5f 11 80 	movl   $0x80115f20,(%esp)
801068b4:	e8 a1 e7 ff ff       	call   8010505a <initlock>
}
801068b9:	c9                   	leave  
801068ba:	c3                   	ret    

801068bb <idtinit>:

void
idtinit(void)
{
801068bb:	55                   	push   %ebp
801068bc:	89 e5                	mov    %esp,%ebp
801068be:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
801068c1:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
801068c8:	00 
801068c9:	c7 04 24 60 5f 11 80 	movl   $0x80115f60,(%esp)
801068d0:	e8 38 fe ff ff       	call   8010670d <lidt>
}
801068d5:	c9                   	leave  
801068d6:	c3                   	ret    

801068d7 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801068d7:	55                   	push   %ebp
801068d8:	89 e5                	mov    %esp,%ebp
801068da:	57                   	push   %edi
801068db:	56                   	push   %esi
801068dc:	53                   	push   %ebx
801068dd:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
801068e0:	8b 45 08             	mov    0x8(%ebp),%eax
801068e3:	8b 40 30             	mov    0x30(%eax),%eax
801068e6:	83 f8 40             	cmp    $0x40,%eax
801068e9:	75 3c                	jne    80106927 <trap+0x50>
    if(myproc()->killed)
801068eb:	e8 71 d8 ff ff       	call   80104161 <myproc>
801068f0:	8b 40 24             	mov    0x24(%eax),%eax
801068f3:	85 c0                	test   %eax,%eax
801068f5:	74 05                	je     801068fc <trap+0x25>
      exit();
801068f7:	e8 14 dd ff ff       	call   80104610 <exit>
    myproc()->tf = tf;
801068fc:	e8 60 d8 ff ff       	call   80104161 <myproc>
80106901:	8b 55 08             	mov    0x8(%ebp),%edx
80106904:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106907:	e8 f8 ed ff ff       	call   80105704 <syscall>
    if(myproc()->killed)
8010690c:	e8 50 d8 ff ff       	call   80104161 <myproc>
80106911:	8b 40 24             	mov    0x24(%eax),%eax
80106914:	85 c0                	test   %eax,%eax
80106916:	74 0a                	je     80106922 <trap+0x4b>
      exit();
80106918:	e8 f3 dc ff ff       	call   80104610 <exit>
    return;
8010691d:	e9 19 02 00 00       	jmp    80106b3b <trap+0x264>
80106922:	e9 14 02 00 00       	jmp    80106b3b <trap+0x264>
  }

  switch(tf->trapno){
80106927:	8b 45 08             	mov    0x8(%ebp),%eax
8010692a:	8b 40 30             	mov    0x30(%eax),%eax
8010692d:	83 e8 20             	sub    $0x20,%eax
80106930:	83 f8 1f             	cmp    $0x1f,%eax
80106933:	0f 87 b1 00 00 00    	ja     801069ea <trap+0x113>
80106939:	8b 04 85 d4 8a 10 80 	mov    -0x7fef752c(,%eax,4),%eax
80106940:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80106942:	e8 83 d7 ff ff       	call   801040ca <cpuid>
80106947:	85 c0                	test   %eax,%eax
80106949:	75 31                	jne    8010697c <trap+0xa5>
      acquire(&tickslock);
8010694b:	c7 04 24 20 5f 11 80 	movl   $0x80115f20,(%esp)
80106952:	e8 24 e7 ff ff       	call   8010507b <acquire>
      ticks++;
80106957:	a1 60 67 11 80       	mov    0x80116760,%eax
8010695c:	83 c0 01             	add    $0x1,%eax
8010695f:	a3 60 67 11 80       	mov    %eax,0x80116760
      wakeup(&ticks);
80106964:	c7 04 24 60 67 11 80 	movl   $0x80116760,(%esp)
8010696b:	e8 10 e2 ff ff       	call   80104b80 <wakeup>
      release(&tickslock);
80106970:	c7 04 24 20 5f 11 80 	movl   $0x80115f20,(%esp)
80106977:	e8 67 e7 ff ff       	call   801050e3 <release>
    }
    lapiceoi();
8010697c:	e8 d0 c5 ff ff       	call   80102f51 <lapiceoi>
    break;
80106981:	e9 37 01 00 00       	jmp    80106abd <trap+0x1e6>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106986:	e8 3d be ff ff       	call   801027c8 <ideintr>
    lapiceoi();
8010698b:	e8 c1 c5 ff ff       	call   80102f51 <lapiceoi>
    break;
80106990:	e9 28 01 00 00       	jmp    80106abd <trap+0x1e6>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106995:	e8 cc c3 ff ff       	call   80102d66 <kbdintr>
    lapiceoi();
8010699a:	e8 b2 c5 ff ff       	call   80102f51 <lapiceoi>
    break;
8010699f:	e9 19 01 00 00       	jmp    80106abd <trap+0x1e6>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801069a4:	e8 7b 03 00 00       	call   80106d24 <uartintr>
    lapiceoi();
801069a9:	e8 a3 c5 ff ff       	call   80102f51 <lapiceoi>
    break;
801069ae:	e9 0a 01 00 00       	jmp    80106abd <trap+0x1e6>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801069b3:	8b 45 08             	mov    0x8(%ebp),%eax
801069b6:	8b 70 38             	mov    0x38(%eax),%esi
            cpuid(), tf->cs, tf->eip);
801069b9:	8b 45 08             	mov    0x8(%ebp),%eax
801069bc:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801069c0:	0f b7 d8             	movzwl %ax,%ebx
801069c3:	e8 02 d7 ff ff       	call   801040ca <cpuid>
801069c8:	89 74 24 0c          	mov    %esi,0xc(%esp)
801069cc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
801069d0:	89 44 24 04          	mov    %eax,0x4(%esp)
801069d4:	c7 04 24 34 8a 10 80 	movl   $0x80108a34,(%esp)
801069db:	e8 e8 99 ff ff       	call   801003c8 <cprintf>
    lapiceoi();
801069e0:	e8 6c c5 ff ff       	call   80102f51 <lapiceoi>
    break;
801069e5:	e9 d3 00 00 00       	jmp    80106abd <trap+0x1e6>

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801069ea:	e8 72 d7 ff ff       	call   80104161 <myproc>
801069ef:	85 c0                	test   %eax,%eax
801069f1:	74 11                	je     80106a04 <trap+0x12d>
801069f3:	8b 45 08             	mov    0x8(%ebp),%eax
801069f6:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801069fa:	0f b7 c0             	movzwl %ax,%eax
801069fd:	83 e0 03             	and    $0x3,%eax
80106a00:	85 c0                	test   %eax,%eax
80106a02:	75 40                	jne    80106a44 <trap+0x16d>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106a04:	e8 2d fd ff ff       	call   80106736 <rcr2>
80106a09:	89 c3                	mov    %eax,%ebx
80106a0b:	8b 45 08             	mov    0x8(%ebp),%eax
80106a0e:	8b 70 38             	mov    0x38(%eax),%esi
80106a11:	e8 b4 d6 ff ff       	call   801040ca <cpuid>
80106a16:	8b 55 08             	mov    0x8(%ebp),%edx
80106a19:	8b 52 30             	mov    0x30(%edx),%edx
80106a1c:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80106a20:	89 74 24 0c          	mov    %esi,0xc(%esp)
80106a24:	89 44 24 08          	mov    %eax,0x8(%esp)
80106a28:	89 54 24 04          	mov    %edx,0x4(%esp)
80106a2c:	c7 04 24 58 8a 10 80 	movl   $0x80108a58,(%esp)
80106a33:	e8 90 99 ff ff       	call   801003c8 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
80106a38:	c7 04 24 8a 8a 10 80 	movl   $0x80108a8a,(%esp)
80106a3f:	e8 1e 9b ff ff       	call   80100562 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106a44:	e8 ed fc ff ff       	call   80106736 <rcr2>
80106a49:	89 c6                	mov    %eax,%esi
80106a4b:	8b 45 08             	mov    0x8(%ebp),%eax
80106a4e:	8b 40 38             	mov    0x38(%eax),%eax
80106a51:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106a54:	e8 71 d6 ff ff       	call   801040ca <cpuid>
80106a59:	89 c3                	mov    %eax,%ebx
80106a5b:	8b 45 08             	mov    0x8(%ebp),%eax
80106a5e:	8b 78 34             	mov    0x34(%eax),%edi
80106a61:	89 7d e0             	mov    %edi,-0x20(%ebp)
80106a64:	8b 45 08             	mov    0x8(%ebp),%eax
80106a67:	8b 78 30             	mov    0x30(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106a6a:	e8 f2 d6 ff ff       	call   80104161 <myproc>
80106a6f:	8d 50 6c             	lea    0x6c(%eax),%edx
80106a72:	89 55 dc             	mov    %edx,-0x24(%ebp)
80106a75:	e8 e7 d6 ff ff       	call   80104161 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106a7a:	8b 40 10             	mov    0x10(%eax),%eax
80106a7d:	89 74 24 1c          	mov    %esi,0x1c(%esp)
80106a81:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106a84:	89 4c 24 18          	mov    %ecx,0x18(%esp)
80106a88:	89 5c 24 14          	mov    %ebx,0x14(%esp)
80106a8c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80106a8f:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80106a93:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80106a97:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106a9a:	89 54 24 08          	mov    %edx,0x8(%esp)
80106a9e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106aa2:	c7 04 24 90 8a 10 80 	movl   $0x80108a90,(%esp)
80106aa9:	e8 1a 99 ff ff       	call   801003c8 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80106aae:	e8 ae d6 ff ff       	call   80104161 <myproc>
80106ab3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106aba:	eb 01                	jmp    80106abd <trap+0x1e6>
    break;
80106abc:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106abd:	e8 9f d6 ff ff       	call   80104161 <myproc>
80106ac2:	85 c0                	test   %eax,%eax
80106ac4:	74 23                	je     80106ae9 <trap+0x212>
80106ac6:	e8 96 d6 ff ff       	call   80104161 <myproc>
80106acb:	8b 40 24             	mov    0x24(%eax),%eax
80106ace:	85 c0                	test   %eax,%eax
80106ad0:	74 17                	je     80106ae9 <trap+0x212>
80106ad2:	8b 45 08             	mov    0x8(%ebp),%eax
80106ad5:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106ad9:	0f b7 c0             	movzwl %ax,%eax
80106adc:	83 e0 03             	and    $0x3,%eax
80106adf:	83 f8 03             	cmp    $0x3,%eax
80106ae2:	75 05                	jne    80106ae9 <trap+0x212>
    exit();
80106ae4:	e8 27 db ff ff       	call   80104610 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80106ae9:	e8 73 d6 ff ff       	call   80104161 <myproc>
80106aee:	85 c0                	test   %eax,%eax
80106af0:	74 1d                	je     80106b0f <trap+0x238>
80106af2:	e8 6a d6 ff ff       	call   80104161 <myproc>
80106af7:	8b 40 0c             	mov    0xc(%eax),%eax
80106afa:	83 f8 04             	cmp    $0x4,%eax
80106afd:	75 10                	jne    80106b0f <trap+0x238>
     tf->trapno == T_IRQ0+IRQ_TIMER)
80106aff:	8b 45 08             	mov    0x8(%ebp),%eax
80106b02:	8b 40 30             	mov    0x30(%eax),%eax
  if(myproc() && myproc()->state == RUNNING &&
80106b05:	83 f8 20             	cmp    $0x20,%eax
80106b08:	75 05                	jne    80106b0f <trap+0x238>
    yield();
80106b0a:	e8 2a df ff ff       	call   80104a39 <yield>

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106b0f:	e8 4d d6 ff ff       	call   80104161 <myproc>
80106b14:	85 c0                	test   %eax,%eax
80106b16:	74 23                	je     80106b3b <trap+0x264>
80106b18:	e8 44 d6 ff ff       	call   80104161 <myproc>
80106b1d:	8b 40 24             	mov    0x24(%eax),%eax
80106b20:	85 c0                	test   %eax,%eax
80106b22:	74 17                	je     80106b3b <trap+0x264>
80106b24:	8b 45 08             	mov    0x8(%ebp),%eax
80106b27:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106b2b:	0f b7 c0             	movzwl %ax,%eax
80106b2e:	83 e0 03             	and    $0x3,%eax
80106b31:	83 f8 03             	cmp    $0x3,%eax
80106b34:	75 05                	jne    80106b3b <trap+0x264>
    exit();
80106b36:	e8 d5 da ff ff       	call   80104610 <exit>
}
80106b3b:	83 c4 3c             	add    $0x3c,%esp
80106b3e:	5b                   	pop    %ebx
80106b3f:	5e                   	pop    %esi
80106b40:	5f                   	pop    %edi
80106b41:	5d                   	pop    %ebp
80106b42:	c3                   	ret    

80106b43 <inb>:
{
80106b43:	55                   	push   %ebp
80106b44:	89 e5                	mov    %esp,%ebp
80106b46:	83 ec 14             	sub    $0x14,%esp
80106b49:	8b 45 08             	mov    0x8(%ebp),%eax
80106b4c:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106b50:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80106b54:	89 c2                	mov    %eax,%edx
80106b56:	ec                   	in     (%dx),%al
80106b57:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80106b5a:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80106b5e:	c9                   	leave  
80106b5f:	c3                   	ret    

80106b60 <outb>:
{
80106b60:	55                   	push   %ebp
80106b61:	89 e5                	mov    %esp,%ebp
80106b63:	83 ec 08             	sub    $0x8,%esp
80106b66:	8b 55 08             	mov    0x8(%ebp),%edx
80106b69:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b6c:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106b70:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106b73:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106b77:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106b7b:	ee                   	out    %al,(%dx)
}
80106b7c:	c9                   	leave  
80106b7d:	c3                   	ret    

80106b7e <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106b7e:	55                   	push   %ebp
80106b7f:	89 e5                	mov    %esp,%ebp
80106b81:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80106b84:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106b8b:	00 
80106b8c:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106b93:	e8 c8 ff ff ff       	call   80106b60 <outb>

  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106b98:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
80106b9f:	00 
80106ba0:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106ba7:	e8 b4 ff ff ff       	call   80106b60 <outb>
  outb(COM1+0, 115200/9600);
80106bac:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
80106bb3:	00 
80106bb4:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106bbb:	e8 a0 ff ff ff       	call   80106b60 <outb>
  outb(COM1+1, 0);
80106bc0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106bc7:	00 
80106bc8:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106bcf:	e8 8c ff ff ff       	call   80106b60 <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106bd4:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80106bdb:	00 
80106bdc:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106be3:	e8 78 ff ff ff       	call   80106b60 <outb>
  outb(COM1+4, 0);
80106be8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106bef:	00 
80106bf0:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
80106bf7:	e8 64 ff ff ff       	call   80106b60 <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106bfc:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80106c03:	00 
80106c04:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106c0b:	e8 50 ff ff ff       	call   80106b60 <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106c10:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106c17:	e8 27 ff ff ff       	call   80106b43 <inb>
80106c1c:	3c ff                	cmp    $0xff,%al
80106c1e:	75 02                	jne    80106c22 <uartinit+0xa4>
    return;
80106c20:	eb 5e                	jmp    80106c80 <uartinit+0x102>
  uart = 1;
80106c22:	c7 05 64 b6 10 80 01 	movl   $0x1,0x8010b664
80106c29:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106c2c:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106c33:	e8 0b ff ff ff       	call   80106b43 <inb>
  inb(COM1+0);
80106c38:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106c3f:	e8 ff fe ff ff       	call   80106b43 <inb>
  ioapicenable(IRQ_COM1, 0);
80106c44:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106c4b:	00 
80106c4c:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80106c53:	e8 e7 bd ff ff       	call   80102a3f <ioapicenable>

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106c58:	c7 45 f4 54 8b 10 80 	movl   $0x80108b54,-0xc(%ebp)
80106c5f:	eb 15                	jmp    80106c76 <uartinit+0xf8>
    uartputc(*p);
80106c61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c64:	0f b6 00             	movzbl (%eax),%eax
80106c67:	0f be c0             	movsbl %al,%eax
80106c6a:	89 04 24             	mov    %eax,(%esp)
80106c6d:	e8 10 00 00 00       	call   80106c82 <uartputc>
  for(p="xv6...\n"; *p; p++)
80106c72:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106c76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c79:	0f b6 00             	movzbl (%eax),%eax
80106c7c:	84 c0                	test   %al,%al
80106c7e:	75 e1                	jne    80106c61 <uartinit+0xe3>
}
80106c80:	c9                   	leave  
80106c81:	c3                   	ret    

80106c82 <uartputc>:

void
uartputc(int c)
{
80106c82:	55                   	push   %ebp
80106c83:	89 e5                	mov    %esp,%ebp
80106c85:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
80106c88:	a1 64 b6 10 80       	mov    0x8010b664,%eax
80106c8d:	85 c0                	test   %eax,%eax
80106c8f:	75 02                	jne    80106c93 <uartputc+0x11>
    return;
80106c91:	eb 4b                	jmp    80106cde <uartputc+0x5c>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106c93:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106c9a:	eb 10                	jmp    80106cac <uartputc+0x2a>
    microdelay(10);
80106c9c:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80106ca3:	e8 ce c2 ff ff       	call   80102f76 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106ca8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106cac:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106cb0:	7f 16                	jg     80106cc8 <uartputc+0x46>
80106cb2:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106cb9:	e8 85 fe ff ff       	call   80106b43 <inb>
80106cbe:	0f b6 c0             	movzbl %al,%eax
80106cc1:	83 e0 20             	and    $0x20,%eax
80106cc4:	85 c0                	test   %eax,%eax
80106cc6:	74 d4                	je     80106c9c <uartputc+0x1a>
  outb(COM1+0, c);
80106cc8:	8b 45 08             	mov    0x8(%ebp),%eax
80106ccb:	0f b6 c0             	movzbl %al,%eax
80106cce:	89 44 24 04          	mov    %eax,0x4(%esp)
80106cd2:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106cd9:	e8 82 fe ff ff       	call   80106b60 <outb>
}
80106cde:	c9                   	leave  
80106cdf:	c3                   	ret    

80106ce0 <uartgetc>:

static int
uartgetc(void)
{
80106ce0:	55                   	push   %ebp
80106ce1:	89 e5                	mov    %esp,%ebp
80106ce3:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
80106ce6:	a1 64 b6 10 80       	mov    0x8010b664,%eax
80106ceb:	85 c0                	test   %eax,%eax
80106ced:	75 07                	jne    80106cf6 <uartgetc+0x16>
    return -1;
80106cef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106cf4:	eb 2c                	jmp    80106d22 <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
80106cf6:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106cfd:	e8 41 fe ff ff       	call   80106b43 <inb>
80106d02:	0f b6 c0             	movzbl %al,%eax
80106d05:	83 e0 01             	and    $0x1,%eax
80106d08:	85 c0                	test   %eax,%eax
80106d0a:	75 07                	jne    80106d13 <uartgetc+0x33>
    return -1;
80106d0c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d11:	eb 0f                	jmp    80106d22 <uartgetc+0x42>
  return inb(COM1+0);
80106d13:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106d1a:	e8 24 fe ff ff       	call   80106b43 <inb>
80106d1f:	0f b6 c0             	movzbl %al,%eax
}
80106d22:	c9                   	leave  
80106d23:	c3                   	ret    

80106d24 <uartintr>:

void
uartintr(void)
{
80106d24:	55                   	push   %ebp
80106d25:	89 e5                	mov    %esp,%ebp
80106d27:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80106d2a:	c7 04 24 e0 6c 10 80 	movl   $0x80106ce0,(%esp)
80106d31:	e8 b3 9a ff ff       	call   801007e9 <consoleintr>
}
80106d36:	c9                   	leave  
80106d37:	c3                   	ret    

80106d38 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106d38:	6a 00                	push   $0x0
  pushl $0
80106d3a:	6a 00                	push   $0x0
  jmp alltraps
80106d3c:	e9 a9 f9 ff ff       	jmp    801066ea <alltraps>

80106d41 <vector1>:
.globl vector1
vector1:
  pushl $0
80106d41:	6a 00                	push   $0x0
  pushl $1
80106d43:	6a 01                	push   $0x1
  jmp alltraps
80106d45:	e9 a0 f9 ff ff       	jmp    801066ea <alltraps>

80106d4a <vector2>:
.globl vector2
vector2:
  pushl $0
80106d4a:	6a 00                	push   $0x0
  pushl $2
80106d4c:	6a 02                	push   $0x2
  jmp alltraps
80106d4e:	e9 97 f9 ff ff       	jmp    801066ea <alltraps>

80106d53 <vector3>:
.globl vector3
vector3:
  pushl $0
80106d53:	6a 00                	push   $0x0
  pushl $3
80106d55:	6a 03                	push   $0x3
  jmp alltraps
80106d57:	e9 8e f9 ff ff       	jmp    801066ea <alltraps>

80106d5c <vector4>:
.globl vector4
vector4:
  pushl $0
80106d5c:	6a 00                	push   $0x0
  pushl $4
80106d5e:	6a 04                	push   $0x4
  jmp alltraps
80106d60:	e9 85 f9 ff ff       	jmp    801066ea <alltraps>

80106d65 <vector5>:
.globl vector5
vector5:
  pushl $0
80106d65:	6a 00                	push   $0x0
  pushl $5
80106d67:	6a 05                	push   $0x5
  jmp alltraps
80106d69:	e9 7c f9 ff ff       	jmp    801066ea <alltraps>

80106d6e <vector6>:
.globl vector6
vector6:
  pushl $0
80106d6e:	6a 00                	push   $0x0
  pushl $6
80106d70:	6a 06                	push   $0x6
  jmp alltraps
80106d72:	e9 73 f9 ff ff       	jmp    801066ea <alltraps>

80106d77 <vector7>:
.globl vector7
vector7:
  pushl $0
80106d77:	6a 00                	push   $0x0
  pushl $7
80106d79:	6a 07                	push   $0x7
  jmp alltraps
80106d7b:	e9 6a f9 ff ff       	jmp    801066ea <alltraps>

80106d80 <vector8>:
.globl vector8
vector8:
  pushl $8
80106d80:	6a 08                	push   $0x8
  jmp alltraps
80106d82:	e9 63 f9 ff ff       	jmp    801066ea <alltraps>

80106d87 <vector9>:
.globl vector9
vector9:
  pushl $0
80106d87:	6a 00                	push   $0x0
  pushl $9
80106d89:	6a 09                	push   $0x9
  jmp alltraps
80106d8b:	e9 5a f9 ff ff       	jmp    801066ea <alltraps>

80106d90 <vector10>:
.globl vector10
vector10:
  pushl $10
80106d90:	6a 0a                	push   $0xa
  jmp alltraps
80106d92:	e9 53 f9 ff ff       	jmp    801066ea <alltraps>

80106d97 <vector11>:
.globl vector11
vector11:
  pushl $11
80106d97:	6a 0b                	push   $0xb
  jmp alltraps
80106d99:	e9 4c f9 ff ff       	jmp    801066ea <alltraps>

80106d9e <vector12>:
.globl vector12
vector12:
  pushl $12
80106d9e:	6a 0c                	push   $0xc
  jmp alltraps
80106da0:	e9 45 f9 ff ff       	jmp    801066ea <alltraps>

80106da5 <vector13>:
.globl vector13
vector13:
  pushl $13
80106da5:	6a 0d                	push   $0xd
  jmp alltraps
80106da7:	e9 3e f9 ff ff       	jmp    801066ea <alltraps>

80106dac <vector14>:
.globl vector14
vector14:
  pushl $14
80106dac:	6a 0e                	push   $0xe
  jmp alltraps
80106dae:	e9 37 f9 ff ff       	jmp    801066ea <alltraps>

80106db3 <vector15>:
.globl vector15
vector15:
  pushl $0
80106db3:	6a 00                	push   $0x0
  pushl $15
80106db5:	6a 0f                	push   $0xf
  jmp alltraps
80106db7:	e9 2e f9 ff ff       	jmp    801066ea <alltraps>

80106dbc <vector16>:
.globl vector16
vector16:
  pushl $0
80106dbc:	6a 00                	push   $0x0
  pushl $16
80106dbe:	6a 10                	push   $0x10
  jmp alltraps
80106dc0:	e9 25 f9 ff ff       	jmp    801066ea <alltraps>

80106dc5 <vector17>:
.globl vector17
vector17:
  pushl $17
80106dc5:	6a 11                	push   $0x11
  jmp alltraps
80106dc7:	e9 1e f9 ff ff       	jmp    801066ea <alltraps>

80106dcc <vector18>:
.globl vector18
vector18:
  pushl $0
80106dcc:	6a 00                	push   $0x0
  pushl $18
80106dce:	6a 12                	push   $0x12
  jmp alltraps
80106dd0:	e9 15 f9 ff ff       	jmp    801066ea <alltraps>

80106dd5 <vector19>:
.globl vector19
vector19:
  pushl $0
80106dd5:	6a 00                	push   $0x0
  pushl $19
80106dd7:	6a 13                	push   $0x13
  jmp alltraps
80106dd9:	e9 0c f9 ff ff       	jmp    801066ea <alltraps>

80106dde <vector20>:
.globl vector20
vector20:
  pushl $0
80106dde:	6a 00                	push   $0x0
  pushl $20
80106de0:	6a 14                	push   $0x14
  jmp alltraps
80106de2:	e9 03 f9 ff ff       	jmp    801066ea <alltraps>

80106de7 <vector21>:
.globl vector21
vector21:
  pushl $0
80106de7:	6a 00                	push   $0x0
  pushl $21
80106de9:	6a 15                	push   $0x15
  jmp alltraps
80106deb:	e9 fa f8 ff ff       	jmp    801066ea <alltraps>

80106df0 <vector22>:
.globl vector22
vector22:
  pushl $0
80106df0:	6a 00                	push   $0x0
  pushl $22
80106df2:	6a 16                	push   $0x16
  jmp alltraps
80106df4:	e9 f1 f8 ff ff       	jmp    801066ea <alltraps>

80106df9 <vector23>:
.globl vector23
vector23:
  pushl $0
80106df9:	6a 00                	push   $0x0
  pushl $23
80106dfb:	6a 17                	push   $0x17
  jmp alltraps
80106dfd:	e9 e8 f8 ff ff       	jmp    801066ea <alltraps>

80106e02 <vector24>:
.globl vector24
vector24:
  pushl $0
80106e02:	6a 00                	push   $0x0
  pushl $24
80106e04:	6a 18                	push   $0x18
  jmp alltraps
80106e06:	e9 df f8 ff ff       	jmp    801066ea <alltraps>

80106e0b <vector25>:
.globl vector25
vector25:
  pushl $0
80106e0b:	6a 00                	push   $0x0
  pushl $25
80106e0d:	6a 19                	push   $0x19
  jmp alltraps
80106e0f:	e9 d6 f8 ff ff       	jmp    801066ea <alltraps>

80106e14 <vector26>:
.globl vector26
vector26:
  pushl $0
80106e14:	6a 00                	push   $0x0
  pushl $26
80106e16:	6a 1a                	push   $0x1a
  jmp alltraps
80106e18:	e9 cd f8 ff ff       	jmp    801066ea <alltraps>

80106e1d <vector27>:
.globl vector27
vector27:
  pushl $0
80106e1d:	6a 00                	push   $0x0
  pushl $27
80106e1f:	6a 1b                	push   $0x1b
  jmp alltraps
80106e21:	e9 c4 f8 ff ff       	jmp    801066ea <alltraps>

80106e26 <vector28>:
.globl vector28
vector28:
  pushl $0
80106e26:	6a 00                	push   $0x0
  pushl $28
80106e28:	6a 1c                	push   $0x1c
  jmp alltraps
80106e2a:	e9 bb f8 ff ff       	jmp    801066ea <alltraps>

80106e2f <vector29>:
.globl vector29
vector29:
  pushl $0
80106e2f:	6a 00                	push   $0x0
  pushl $29
80106e31:	6a 1d                	push   $0x1d
  jmp alltraps
80106e33:	e9 b2 f8 ff ff       	jmp    801066ea <alltraps>

80106e38 <vector30>:
.globl vector30
vector30:
  pushl $0
80106e38:	6a 00                	push   $0x0
  pushl $30
80106e3a:	6a 1e                	push   $0x1e
  jmp alltraps
80106e3c:	e9 a9 f8 ff ff       	jmp    801066ea <alltraps>

80106e41 <vector31>:
.globl vector31
vector31:
  pushl $0
80106e41:	6a 00                	push   $0x0
  pushl $31
80106e43:	6a 1f                	push   $0x1f
  jmp alltraps
80106e45:	e9 a0 f8 ff ff       	jmp    801066ea <alltraps>

80106e4a <vector32>:
.globl vector32
vector32:
  pushl $0
80106e4a:	6a 00                	push   $0x0
  pushl $32
80106e4c:	6a 20                	push   $0x20
  jmp alltraps
80106e4e:	e9 97 f8 ff ff       	jmp    801066ea <alltraps>

80106e53 <vector33>:
.globl vector33
vector33:
  pushl $0
80106e53:	6a 00                	push   $0x0
  pushl $33
80106e55:	6a 21                	push   $0x21
  jmp alltraps
80106e57:	e9 8e f8 ff ff       	jmp    801066ea <alltraps>

80106e5c <vector34>:
.globl vector34
vector34:
  pushl $0
80106e5c:	6a 00                	push   $0x0
  pushl $34
80106e5e:	6a 22                	push   $0x22
  jmp alltraps
80106e60:	e9 85 f8 ff ff       	jmp    801066ea <alltraps>

80106e65 <vector35>:
.globl vector35
vector35:
  pushl $0
80106e65:	6a 00                	push   $0x0
  pushl $35
80106e67:	6a 23                	push   $0x23
  jmp alltraps
80106e69:	e9 7c f8 ff ff       	jmp    801066ea <alltraps>

80106e6e <vector36>:
.globl vector36
vector36:
  pushl $0
80106e6e:	6a 00                	push   $0x0
  pushl $36
80106e70:	6a 24                	push   $0x24
  jmp alltraps
80106e72:	e9 73 f8 ff ff       	jmp    801066ea <alltraps>

80106e77 <vector37>:
.globl vector37
vector37:
  pushl $0
80106e77:	6a 00                	push   $0x0
  pushl $37
80106e79:	6a 25                	push   $0x25
  jmp alltraps
80106e7b:	e9 6a f8 ff ff       	jmp    801066ea <alltraps>

80106e80 <vector38>:
.globl vector38
vector38:
  pushl $0
80106e80:	6a 00                	push   $0x0
  pushl $38
80106e82:	6a 26                	push   $0x26
  jmp alltraps
80106e84:	e9 61 f8 ff ff       	jmp    801066ea <alltraps>

80106e89 <vector39>:
.globl vector39
vector39:
  pushl $0
80106e89:	6a 00                	push   $0x0
  pushl $39
80106e8b:	6a 27                	push   $0x27
  jmp alltraps
80106e8d:	e9 58 f8 ff ff       	jmp    801066ea <alltraps>

80106e92 <vector40>:
.globl vector40
vector40:
  pushl $0
80106e92:	6a 00                	push   $0x0
  pushl $40
80106e94:	6a 28                	push   $0x28
  jmp alltraps
80106e96:	e9 4f f8 ff ff       	jmp    801066ea <alltraps>

80106e9b <vector41>:
.globl vector41
vector41:
  pushl $0
80106e9b:	6a 00                	push   $0x0
  pushl $41
80106e9d:	6a 29                	push   $0x29
  jmp alltraps
80106e9f:	e9 46 f8 ff ff       	jmp    801066ea <alltraps>

80106ea4 <vector42>:
.globl vector42
vector42:
  pushl $0
80106ea4:	6a 00                	push   $0x0
  pushl $42
80106ea6:	6a 2a                	push   $0x2a
  jmp alltraps
80106ea8:	e9 3d f8 ff ff       	jmp    801066ea <alltraps>

80106ead <vector43>:
.globl vector43
vector43:
  pushl $0
80106ead:	6a 00                	push   $0x0
  pushl $43
80106eaf:	6a 2b                	push   $0x2b
  jmp alltraps
80106eb1:	e9 34 f8 ff ff       	jmp    801066ea <alltraps>

80106eb6 <vector44>:
.globl vector44
vector44:
  pushl $0
80106eb6:	6a 00                	push   $0x0
  pushl $44
80106eb8:	6a 2c                	push   $0x2c
  jmp alltraps
80106eba:	e9 2b f8 ff ff       	jmp    801066ea <alltraps>

80106ebf <vector45>:
.globl vector45
vector45:
  pushl $0
80106ebf:	6a 00                	push   $0x0
  pushl $45
80106ec1:	6a 2d                	push   $0x2d
  jmp alltraps
80106ec3:	e9 22 f8 ff ff       	jmp    801066ea <alltraps>

80106ec8 <vector46>:
.globl vector46
vector46:
  pushl $0
80106ec8:	6a 00                	push   $0x0
  pushl $46
80106eca:	6a 2e                	push   $0x2e
  jmp alltraps
80106ecc:	e9 19 f8 ff ff       	jmp    801066ea <alltraps>

80106ed1 <vector47>:
.globl vector47
vector47:
  pushl $0
80106ed1:	6a 00                	push   $0x0
  pushl $47
80106ed3:	6a 2f                	push   $0x2f
  jmp alltraps
80106ed5:	e9 10 f8 ff ff       	jmp    801066ea <alltraps>

80106eda <vector48>:
.globl vector48
vector48:
  pushl $0
80106eda:	6a 00                	push   $0x0
  pushl $48
80106edc:	6a 30                	push   $0x30
  jmp alltraps
80106ede:	e9 07 f8 ff ff       	jmp    801066ea <alltraps>

80106ee3 <vector49>:
.globl vector49
vector49:
  pushl $0
80106ee3:	6a 00                	push   $0x0
  pushl $49
80106ee5:	6a 31                	push   $0x31
  jmp alltraps
80106ee7:	e9 fe f7 ff ff       	jmp    801066ea <alltraps>

80106eec <vector50>:
.globl vector50
vector50:
  pushl $0
80106eec:	6a 00                	push   $0x0
  pushl $50
80106eee:	6a 32                	push   $0x32
  jmp alltraps
80106ef0:	e9 f5 f7 ff ff       	jmp    801066ea <alltraps>

80106ef5 <vector51>:
.globl vector51
vector51:
  pushl $0
80106ef5:	6a 00                	push   $0x0
  pushl $51
80106ef7:	6a 33                	push   $0x33
  jmp alltraps
80106ef9:	e9 ec f7 ff ff       	jmp    801066ea <alltraps>

80106efe <vector52>:
.globl vector52
vector52:
  pushl $0
80106efe:	6a 00                	push   $0x0
  pushl $52
80106f00:	6a 34                	push   $0x34
  jmp alltraps
80106f02:	e9 e3 f7 ff ff       	jmp    801066ea <alltraps>

80106f07 <vector53>:
.globl vector53
vector53:
  pushl $0
80106f07:	6a 00                	push   $0x0
  pushl $53
80106f09:	6a 35                	push   $0x35
  jmp alltraps
80106f0b:	e9 da f7 ff ff       	jmp    801066ea <alltraps>

80106f10 <vector54>:
.globl vector54
vector54:
  pushl $0
80106f10:	6a 00                	push   $0x0
  pushl $54
80106f12:	6a 36                	push   $0x36
  jmp alltraps
80106f14:	e9 d1 f7 ff ff       	jmp    801066ea <alltraps>

80106f19 <vector55>:
.globl vector55
vector55:
  pushl $0
80106f19:	6a 00                	push   $0x0
  pushl $55
80106f1b:	6a 37                	push   $0x37
  jmp alltraps
80106f1d:	e9 c8 f7 ff ff       	jmp    801066ea <alltraps>

80106f22 <vector56>:
.globl vector56
vector56:
  pushl $0
80106f22:	6a 00                	push   $0x0
  pushl $56
80106f24:	6a 38                	push   $0x38
  jmp alltraps
80106f26:	e9 bf f7 ff ff       	jmp    801066ea <alltraps>

80106f2b <vector57>:
.globl vector57
vector57:
  pushl $0
80106f2b:	6a 00                	push   $0x0
  pushl $57
80106f2d:	6a 39                	push   $0x39
  jmp alltraps
80106f2f:	e9 b6 f7 ff ff       	jmp    801066ea <alltraps>

80106f34 <vector58>:
.globl vector58
vector58:
  pushl $0
80106f34:	6a 00                	push   $0x0
  pushl $58
80106f36:	6a 3a                	push   $0x3a
  jmp alltraps
80106f38:	e9 ad f7 ff ff       	jmp    801066ea <alltraps>

80106f3d <vector59>:
.globl vector59
vector59:
  pushl $0
80106f3d:	6a 00                	push   $0x0
  pushl $59
80106f3f:	6a 3b                	push   $0x3b
  jmp alltraps
80106f41:	e9 a4 f7 ff ff       	jmp    801066ea <alltraps>

80106f46 <vector60>:
.globl vector60
vector60:
  pushl $0
80106f46:	6a 00                	push   $0x0
  pushl $60
80106f48:	6a 3c                	push   $0x3c
  jmp alltraps
80106f4a:	e9 9b f7 ff ff       	jmp    801066ea <alltraps>

80106f4f <vector61>:
.globl vector61
vector61:
  pushl $0
80106f4f:	6a 00                	push   $0x0
  pushl $61
80106f51:	6a 3d                	push   $0x3d
  jmp alltraps
80106f53:	e9 92 f7 ff ff       	jmp    801066ea <alltraps>

80106f58 <vector62>:
.globl vector62
vector62:
  pushl $0
80106f58:	6a 00                	push   $0x0
  pushl $62
80106f5a:	6a 3e                	push   $0x3e
  jmp alltraps
80106f5c:	e9 89 f7 ff ff       	jmp    801066ea <alltraps>

80106f61 <vector63>:
.globl vector63
vector63:
  pushl $0
80106f61:	6a 00                	push   $0x0
  pushl $63
80106f63:	6a 3f                	push   $0x3f
  jmp alltraps
80106f65:	e9 80 f7 ff ff       	jmp    801066ea <alltraps>

80106f6a <vector64>:
.globl vector64
vector64:
  pushl $0
80106f6a:	6a 00                	push   $0x0
  pushl $64
80106f6c:	6a 40                	push   $0x40
  jmp alltraps
80106f6e:	e9 77 f7 ff ff       	jmp    801066ea <alltraps>

80106f73 <vector65>:
.globl vector65
vector65:
  pushl $0
80106f73:	6a 00                	push   $0x0
  pushl $65
80106f75:	6a 41                	push   $0x41
  jmp alltraps
80106f77:	e9 6e f7 ff ff       	jmp    801066ea <alltraps>

80106f7c <vector66>:
.globl vector66
vector66:
  pushl $0
80106f7c:	6a 00                	push   $0x0
  pushl $66
80106f7e:	6a 42                	push   $0x42
  jmp alltraps
80106f80:	e9 65 f7 ff ff       	jmp    801066ea <alltraps>

80106f85 <vector67>:
.globl vector67
vector67:
  pushl $0
80106f85:	6a 00                	push   $0x0
  pushl $67
80106f87:	6a 43                	push   $0x43
  jmp alltraps
80106f89:	e9 5c f7 ff ff       	jmp    801066ea <alltraps>

80106f8e <vector68>:
.globl vector68
vector68:
  pushl $0
80106f8e:	6a 00                	push   $0x0
  pushl $68
80106f90:	6a 44                	push   $0x44
  jmp alltraps
80106f92:	e9 53 f7 ff ff       	jmp    801066ea <alltraps>

80106f97 <vector69>:
.globl vector69
vector69:
  pushl $0
80106f97:	6a 00                	push   $0x0
  pushl $69
80106f99:	6a 45                	push   $0x45
  jmp alltraps
80106f9b:	e9 4a f7 ff ff       	jmp    801066ea <alltraps>

80106fa0 <vector70>:
.globl vector70
vector70:
  pushl $0
80106fa0:	6a 00                	push   $0x0
  pushl $70
80106fa2:	6a 46                	push   $0x46
  jmp alltraps
80106fa4:	e9 41 f7 ff ff       	jmp    801066ea <alltraps>

80106fa9 <vector71>:
.globl vector71
vector71:
  pushl $0
80106fa9:	6a 00                	push   $0x0
  pushl $71
80106fab:	6a 47                	push   $0x47
  jmp alltraps
80106fad:	e9 38 f7 ff ff       	jmp    801066ea <alltraps>

80106fb2 <vector72>:
.globl vector72
vector72:
  pushl $0
80106fb2:	6a 00                	push   $0x0
  pushl $72
80106fb4:	6a 48                	push   $0x48
  jmp alltraps
80106fb6:	e9 2f f7 ff ff       	jmp    801066ea <alltraps>

80106fbb <vector73>:
.globl vector73
vector73:
  pushl $0
80106fbb:	6a 00                	push   $0x0
  pushl $73
80106fbd:	6a 49                	push   $0x49
  jmp alltraps
80106fbf:	e9 26 f7 ff ff       	jmp    801066ea <alltraps>

80106fc4 <vector74>:
.globl vector74
vector74:
  pushl $0
80106fc4:	6a 00                	push   $0x0
  pushl $74
80106fc6:	6a 4a                	push   $0x4a
  jmp alltraps
80106fc8:	e9 1d f7 ff ff       	jmp    801066ea <alltraps>

80106fcd <vector75>:
.globl vector75
vector75:
  pushl $0
80106fcd:	6a 00                	push   $0x0
  pushl $75
80106fcf:	6a 4b                	push   $0x4b
  jmp alltraps
80106fd1:	e9 14 f7 ff ff       	jmp    801066ea <alltraps>

80106fd6 <vector76>:
.globl vector76
vector76:
  pushl $0
80106fd6:	6a 00                	push   $0x0
  pushl $76
80106fd8:	6a 4c                	push   $0x4c
  jmp alltraps
80106fda:	e9 0b f7 ff ff       	jmp    801066ea <alltraps>

80106fdf <vector77>:
.globl vector77
vector77:
  pushl $0
80106fdf:	6a 00                	push   $0x0
  pushl $77
80106fe1:	6a 4d                	push   $0x4d
  jmp alltraps
80106fe3:	e9 02 f7 ff ff       	jmp    801066ea <alltraps>

80106fe8 <vector78>:
.globl vector78
vector78:
  pushl $0
80106fe8:	6a 00                	push   $0x0
  pushl $78
80106fea:	6a 4e                	push   $0x4e
  jmp alltraps
80106fec:	e9 f9 f6 ff ff       	jmp    801066ea <alltraps>

80106ff1 <vector79>:
.globl vector79
vector79:
  pushl $0
80106ff1:	6a 00                	push   $0x0
  pushl $79
80106ff3:	6a 4f                	push   $0x4f
  jmp alltraps
80106ff5:	e9 f0 f6 ff ff       	jmp    801066ea <alltraps>

80106ffa <vector80>:
.globl vector80
vector80:
  pushl $0
80106ffa:	6a 00                	push   $0x0
  pushl $80
80106ffc:	6a 50                	push   $0x50
  jmp alltraps
80106ffe:	e9 e7 f6 ff ff       	jmp    801066ea <alltraps>

80107003 <vector81>:
.globl vector81
vector81:
  pushl $0
80107003:	6a 00                	push   $0x0
  pushl $81
80107005:	6a 51                	push   $0x51
  jmp alltraps
80107007:	e9 de f6 ff ff       	jmp    801066ea <alltraps>

8010700c <vector82>:
.globl vector82
vector82:
  pushl $0
8010700c:	6a 00                	push   $0x0
  pushl $82
8010700e:	6a 52                	push   $0x52
  jmp alltraps
80107010:	e9 d5 f6 ff ff       	jmp    801066ea <alltraps>

80107015 <vector83>:
.globl vector83
vector83:
  pushl $0
80107015:	6a 00                	push   $0x0
  pushl $83
80107017:	6a 53                	push   $0x53
  jmp alltraps
80107019:	e9 cc f6 ff ff       	jmp    801066ea <alltraps>

8010701e <vector84>:
.globl vector84
vector84:
  pushl $0
8010701e:	6a 00                	push   $0x0
  pushl $84
80107020:	6a 54                	push   $0x54
  jmp alltraps
80107022:	e9 c3 f6 ff ff       	jmp    801066ea <alltraps>

80107027 <vector85>:
.globl vector85
vector85:
  pushl $0
80107027:	6a 00                	push   $0x0
  pushl $85
80107029:	6a 55                	push   $0x55
  jmp alltraps
8010702b:	e9 ba f6 ff ff       	jmp    801066ea <alltraps>

80107030 <vector86>:
.globl vector86
vector86:
  pushl $0
80107030:	6a 00                	push   $0x0
  pushl $86
80107032:	6a 56                	push   $0x56
  jmp alltraps
80107034:	e9 b1 f6 ff ff       	jmp    801066ea <alltraps>

80107039 <vector87>:
.globl vector87
vector87:
  pushl $0
80107039:	6a 00                	push   $0x0
  pushl $87
8010703b:	6a 57                	push   $0x57
  jmp alltraps
8010703d:	e9 a8 f6 ff ff       	jmp    801066ea <alltraps>

80107042 <vector88>:
.globl vector88
vector88:
  pushl $0
80107042:	6a 00                	push   $0x0
  pushl $88
80107044:	6a 58                	push   $0x58
  jmp alltraps
80107046:	e9 9f f6 ff ff       	jmp    801066ea <alltraps>

8010704b <vector89>:
.globl vector89
vector89:
  pushl $0
8010704b:	6a 00                	push   $0x0
  pushl $89
8010704d:	6a 59                	push   $0x59
  jmp alltraps
8010704f:	e9 96 f6 ff ff       	jmp    801066ea <alltraps>

80107054 <vector90>:
.globl vector90
vector90:
  pushl $0
80107054:	6a 00                	push   $0x0
  pushl $90
80107056:	6a 5a                	push   $0x5a
  jmp alltraps
80107058:	e9 8d f6 ff ff       	jmp    801066ea <alltraps>

8010705d <vector91>:
.globl vector91
vector91:
  pushl $0
8010705d:	6a 00                	push   $0x0
  pushl $91
8010705f:	6a 5b                	push   $0x5b
  jmp alltraps
80107061:	e9 84 f6 ff ff       	jmp    801066ea <alltraps>

80107066 <vector92>:
.globl vector92
vector92:
  pushl $0
80107066:	6a 00                	push   $0x0
  pushl $92
80107068:	6a 5c                	push   $0x5c
  jmp alltraps
8010706a:	e9 7b f6 ff ff       	jmp    801066ea <alltraps>

8010706f <vector93>:
.globl vector93
vector93:
  pushl $0
8010706f:	6a 00                	push   $0x0
  pushl $93
80107071:	6a 5d                	push   $0x5d
  jmp alltraps
80107073:	e9 72 f6 ff ff       	jmp    801066ea <alltraps>

80107078 <vector94>:
.globl vector94
vector94:
  pushl $0
80107078:	6a 00                	push   $0x0
  pushl $94
8010707a:	6a 5e                	push   $0x5e
  jmp alltraps
8010707c:	e9 69 f6 ff ff       	jmp    801066ea <alltraps>

80107081 <vector95>:
.globl vector95
vector95:
  pushl $0
80107081:	6a 00                	push   $0x0
  pushl $95
80107083:	6a 5f                	push   $0x5f
  jmp alltraps
80107085:	e9 60 f6 ff ff       	jmp    801066ea <alltraps>

8010708a <vector96>:
.globl vector96
vector96:
  pushl $0
8010708a:	6a 00                	push   $0x0
  pushl $96
8010708c:	6a 60                	push   $0x60
  jmp alltraps
8010708e:	e9 57 f6 ff ff       	jmp    801066ea <alltraps>

80107093 <vector97>:
.globl vector97
vector97:
  pushl $0
80107093:	6a 00                	push   $0x0
  pushl $97
80107095:	6a 61                	push   $0x61
  jmp alltraps
80107097:	e9 4e f6 ff ff       	jmp    801066ea <alltraps>

8010709c <vector98>:
.globl vector98
vector98:
  pushl $0
8010709c:	6a 00                	push   $0x0
  pushl $98
8010709e:	6a 62                	push   $0x62
  jmp alltraps
801070a0:	e9 45 f6 ff ff       	jmp    801066ea <alltraps>

801070a5 <vector99>:
.globl vector99
vector99:
  pushl $0
801070a5:	6a 00                	push   $0x0
  pushl $99
801070a7:	6a 63                	push   $0x63
  jmp alltraps
801070a9:	e9 3c f6 ff ff       	jmp    801066ea <alltraps>

801070ae <vector100>:
.globl vector100
vector100:
  pushl $0
801070ae:	6a 00                	push   $0x0
  pushl $100
801070b0:	6a 64                	push   $0x64
  jmp alltraps
801070b2:	e9 33 f6 ff ff       	jmp    801066ea <alltraps>

801070b7 <vector101>:
.globl vector101
vector101:
  pushl $0
801070b7:	6a 00                	push   $0x0
  pushl $101
801070b9:	6a 65                	push   $0x65
  jmp alltraps
801070bb:	e9 2a f6 ff ff       	jmp    801066ea <alltraps>

801070c0 <vector102>:
.globl vector102
vector102:
  pushl $0
801070c0:	6a 00                	push   $0x0
  pushl $102
801070c2:	6a 66                	push   $0x66
  jmp alltraps
801070c4:	e9 21 f6 ff ff       	jmp    801066ea <alltraps>

801070c9 <vector103>:
.globl vector103
vector103:
  pushl $0
801070c9:	6a 00                	push   $0x0
  pushl $103
801070cb:	6a 67                	push   $0x67
  jmp alltraps
801070cd:	e9 18 f6 ff ff       	jmp    801066ea <alltraps>

801070d2 <vector104>:
.globl vector104
vector104:
  pushl $0
801070d2:	6a 00                	push   $0x0
  pushl $104
801070d4:	6a 68                	push   $0x68
  jmp alltraps
801070d6:	e9 0f f6 ff ff       	jmp    801066ea <alltraps>

801070db <vector105>:
.globl vector105
vector105:
  pushl $0
801070db:	6a 00                	push   $0x0
  pushl $105
801070dd:	6a 69                	push   $0x69
  jmp alltraps
801070df:	e9 06 f6 ff ff       	jmp    801066ea <alltraps>

801070e4 <vector106>:
.globl vector106
vector106:
  pushl $0
801070e4:	6a 00                	push   $0x0
  pushl $106
801070e6:	6a 6a                	push   $0x6a
  jmp alltraps
801070e8:	e9 fd f5 ff ff       	jmp    801066ea <alltraps>

801070ed <vector107>:
.globl vector107
vector107:
  pushl $0
801070ed:	6a 00                	push   $0x0
  pushl $107
801070ef:	6a 6b                	push   $0x6b
  jmp alltraps
801070f1:	e9 f4 f5 ff ff       	jmp    801066ea <alltraps>

801070f6 <vector108>:
.globl vector108
vector108:
  pushl $0
801070f6:	6a 00                	push   $0x0
  pushl $108
801070f8:	6a 6c                	push   $0x6c
  jmp alltraps
801070fa:	e9 eb f5 ff ff       	jmp    801066ea <alltraps>

801070ff <vector109>:
.globl vector109
vector109:
  pushl $0
801070ff:	6a 00                	push   $0x0
  pushl $109
80107101:	6a 6d                	push   $0x6d
  jmp alltraps
80107103:	e9 e2 f5 ff ff       	jmp    801066ea <alltraps>

80107108 <vector110>:
.globl vector110
vector110:
  pushl $0
80107108:	6a 00                	push   $0x0
  pushl $110
8010710a:	6a 6e                	push   $0x6e
  jmp alltraps
8010710c:	e9 d9 f5 ff ff       	jmp    801066ea <alltraps>

80107111 <vector111>:
.globl vector111
vector111:
  pushl $0
80107111:	6a 00                	push   $0x0
  pushl $111
80107113:	6a 6f                	push   $0x6f
  jmp alltraps
80107115:	e9 d0 f5 ff ff       	jmp    801066ea <alltraps>

8010711a <vector112>:
.globl vector112
vector112:
  pushl $0
8010711a:	6a 00                	push   $0x0
  pushl $112
8010711c:	6a 70                	push   $0x70
  jmp alltraps
8010711e:	e9 c7 f5 ff ff       	jmp    801066ea <alltraps>

80107123 <vector113>:
.globl vector113
vector113:
  pushl $0
80107123:	6a 00                	push   $0x0
  pushl $113
80107125:	6a 71                	push   $0x71
  jmp alltraps
80107127:	e9 be f5 ff ff       	jmp    801066ea <alltraps>

8010712c <vector114>:
.globl vector114
vector114:
  pushl $0
8010712c:	6a 00                	push   $0x0
  pushl $114
8010712e:	6a 72                	push   $0x72
  jmp alltraps
80107130:	e9 b5 f5 ff ff       	jmp    801066ea <alltraps>

80107135 <vector115>:
.globl vector115
vector115:
  pushl $0
80107135:	6a 00                	push   $0x0
  pushl $115
80107137:	6a 73                	push   $0x73
  jmp alltraps
80107139:	e9 ac f5 ff ff       	jmp    801066ea <alltraps>

8010713e <vector116>:
.globl vector116
vector116:
  pushl $0
8010713e:	6a 00                	push   $0x0
  pushl $116
80107140:	6a 74                	push   $0x74
  jmp alltraps
80107142:	e9 a3 f5 ff ff       	jmp    801066ea <alltraps>

80107147 <vector117>:
.globl vector117
vector117:
  pushl $0
80107147:	6a 00                	push   $0x0
  pushl $117
80107149:	6a 75                	push   $0x75
  jmp alltraps
8010714b:	e9 9a f5 ff ff       	jmp    801066ea <alltraps>

80107150 <vector118>:
.globl vector118
vector118:
  pushl $0
80107150:	6a 00                	push   $0x0
  pushl $118
80107152:	6a 76                	push   $0x76
  jmp alltraps
80107154:	e9 91 f5 ff ff       	jmp    801066ea <alltraps>

80107159 <vector119>:
.globl vector119
vector119:
  pushl $0
80107159:	6a 00                	push   $0x0
  pushl $119
8010715b:	6a 77                	push   $0x77
  jmp alltraps
8010715d:	e9 88 f5 ff ff       	jmp    801066ea <alltraps>

80107162 <vector120>:
.globl vector120
vector120:
  pushl $0
80107162:	6a 00                	push   $0x0
  pushl $120
80107164:	6a 78                	push   $0x78
  jmp alltraps
80107166:	e9 7f f5 ff ff       	jmp    801066ea <alltraps>

8010716b <vector121>:
.globl vector121
vector121:
  pushl $0
8010716b:	6a 00                	push   $0x0
  pushl $121
8010716d:	6a 79                	push   $0x79
  jmp alltraps
8010716f:	e9 76 f5 ff ff       	jmp    801066ea <alltraps>

80107174 <vector122>:
.globl vector122
vector122:
  pushl $0
80107174:	6a 00                	push   $0x0
  pushl $122
80107176:	6a 7a                	push   $0x7a
  jmp alltraps
80107178:	e9 6d f5 ff ff       	jmp    801066ea <alltraps>

8010717d <vector123>:
.globl vector123
vector123:
  pushl $0
8010717d:	6a 00                	push   $0x0
  pushl $123
8010717f:	6a 7b                	push   $0x7b
  jmp alltraps
80107181:	e9 64 f5 ff ff       	jmp    801066ea <alltraps>

80107186 <vector124>:
.globl vector124
vector124:
  pushl $0
80107186:	6a 00                	push   $0x0
  pushl $124
80107188:	6a 7c                	push   $0x7c
  jmp alltraps
8010718a:	e9 5b f5 ff ff       	jmp    801066ea <alltraps>

8010718f <vector125>:
.globl vector125
vector125:
  pushl $0
8010718f:	6a 00                	push   $0x0
  pushl $125
80107191:	6a 7d                	push   $0x7d
  jmp alltraps
80107193:	e9 52 f5 ff ff       	jmp    801066ea <alltraps>

80107198 <vector126>:
.globl vector126
vector126:
  pushl $0
80107198:	6a 00                	push   $0x0
  pushl $126
8010719a:	6a 7e                	push   $0x7e
  jmp alltraps
8010719c:	e9 49 f5 ff ff       	jmp    801066ea <alltraps>

801071a1 <vector127>:
.globl vector127
vector127:
  pushl $0
801071a1:	6a 00                	push   $0x0
  pushl $127
801071a3:	6a 7f                	push   $0x7f
  jmp alltraps
801071a5:	e9 40 f5 ff ff       	jmp    801066ea <alltraps>

801071aa <vector128>:
.globl vector128
vector128:
  pushl $0
801071aa:	6a 00                	push   $0x0
  pushl $128
801071ac:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801071b1:	e9 34 f5 ff ff       	jmp    801066ea <alltraps>

801071b6 <vector129>:
.globl vector129
vector129:
  pushl $0
801071b6:	6a 00                	push   $0x0
  pushl $129
801071b8:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801071bd:	e9 28 f5 ff ff       	jmp    801066ea <alltraps>

801071c2 <vector130>:
.globl vector130
vector130:
  pushl $0
801071c2:	6a 00                	push   $0x0
  pushl $130
801071c4:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801071c9:	e9 1c f5 ff ff       	jmp    801066ea <alltraps>

801071ce <vector131>:
.globl vector131
vector131:
  pushl $0
801071ce:	6a 00                	push   $0x0
  pushl $131
801071d0:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801071d5:	e9 10 f5 ff ff       	jmp    801066ea <alltraps>

801071da <vector132>:
.globl vector132
vector132:
  pushl $0
801071da:	6a 00                	push   $0x0
  pushl $132
801071dc:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801071e1:	e9 04 f5 ff ff       	jmp    801066ea <alltraps>

801071e6 <vector133>:
.globl vector133
vector133:
  pushl $0
801071e6:	6a 00                	push   $0x0
  pushl $133
801071e8:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801071ed:	e9 f8 f4 ff ff       	jmp    801066ea <alltraps>

801071f2 <vector134>:
.globl vector134
vector134:
  pushl $0
801071f2:	6a 00                	push   $0x0
  pushl $134
801071f4:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801071f9:	e9 ec f4 ff ff       	jmp    801066ea <alltraps>

801071fe <vector135>:
.globl vector135
vector135:
  pushl $0
801071fe:	6a 00                	push   $0x0
  pushl $135
80107200:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107205:	e9 e0 f4 ff ff       	jmp    801066ea <alltraps>

8010720a <vector136>:
.globl vector136
vector136:
  pushl $0
8010720a:	6a 00                	push   $0x0
  pushl $136
8010720c:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80107211:	e9 d4 f4 ff ff       	jmp    801066ea <alltraps>

80107216 <vector137>:
.globl vector137
vector137:
  pushl $0
80107216:	6a 00                	push   $0x0
  pushl $137
80107218:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010721d:	e9 c8 f4 ff ff       	jmp    801066ea <alltraps>

80107222 <vector138>:
.globl vector138
vector138:
  pushl $0
80107222:	6a 00                	push   $0x0
  pushl $138
80107224:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107229:	e9 bc f4 ff ff       	jmp    801066ea <alltraps>

8010722e <vector139>:
.globl vector139
vector139:
  pushl $0
8010722e:	6a 00                	push   $0x0
  pushl $139
80107230:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107235:	e9 b0 f4 ff ff       	jmp    801066ea <alltraps>

8010723a <vector140>:
.globl vector140
vector140:
  pushl $0
8010723a:	6a 00                	push   $0x0
  pushl $140
8010723c:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80107241:	e9 a4 f4 ff ff       	jmp    801066ea <alltraps>

80107246 <vector141>:
.globl vector141
vector141:
  pushl $0
80107246:	6a 00                	push   $0x0
  pushl $141
80107248:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010724d:	e9 98 f4 ff ff       	jmp    801066ea <alltraps>

80107252 <vector142>:
.globl vector142
vector142:
  pushl $0
80107252:	6a 00                	push   $0x0
  pushl $142
80107254:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107259:	e9 8c f4 ff ff       	jmp    801066ea <alltraps>

8010725e <vector143>:
.globl vector143
vector143:
  pushl $0
8010725e:	6a 00                	push   $0x0
  pushl $143
80107260:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107265:	e9 80 f4 ff ff       	jmp    801066ea <alltraps>

8010726a <vector144>:
.globl vector144
vector144:
  pushl $0
8010726a:	6a 00                	push   $0x0
  pushl $144
8010726c:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107271:	e9 74 f4 ff ff       	jmp    801066ea <alltraps>

80107276 <vector145>:
.globl vector145
vector145:
  pushl $0
80107276:	6a 00                	push   $0x0
  pushl $145
80107278:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010727d:	e9 68 f4 ff ff       	jmp    801066ea <alltraps>

80107282 <vector146>:
.globl vector146
vector146:
  pushl $0
80107282:	6a 00                	push   $0x0
  pushl $146
80107284:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80107289:	e9 5c f4 ff ff       	jmp    801066ea <alltraps>

8010728e <vector147>:
.globl vector147
vector147:
  pushl $0
8010728e:	6a 00                	push   $0x0
  pushl $147
80107290:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80107295:	e9 50 f4 ff ff       	jmp    801066ea <alltraps>

8010729a <vector148>:
.globl vector148
vector148:
  pushl $0
8010729a:	6a 00                	push   $0x0
  pushl $148
8010729c:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801072a1:	e9 44 f4 ff ff       	jmp    801066ea <alltraps>

801072a6 <vector149>:
.globl vector149
vector149:
  pushl $0
801072a6:	6a 00                	push   $0x0
  pushl $149
801072a8:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801072ad:	e9 38 f4 ff ff       	jmp    801066ea <alltraps>

801072b2 <vector150>:
.globl vector150
vector150:
  pushl $0
801072b2:	6a 00                	push   $0x0
  pushl $150
801072b4:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801072b9:	e9 2c f4 ff ff       	jmp    801066ea <alltraps>

801072be <vector151>:
.globl vector151
vector151:
  pushl $0
801072be:	6a 00                	push   $0x0
  pushl $151
801072c0:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801072c5:	e9 20 f4 ff ff       	jmp    801066ea <alltraps>

801072ca <vector152>:
.globl vector152
vector152:
  pushl $0
801072ca:	6a 00                	push   $0x0
  pushl $152
801072cc:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801072d1:	e9 14 f4 ff ff       	jmp    801066ea <alltraps>

801072d6 <vector153>:
.globl vector153
vector153:
  pushl $0
801072d6:	6a 00                	push   $0x0
  pushl $153
801072d8:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801072dd:	e9 08 f4 ff ff       	jmp    801066ea <alltraps>

801072e2 <vector154>:
.globl vector154
vector154:
  pushl $0
801072e2:	6a 00                	push   $0x0
  pushl $154
801072e4:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801072e9:	e9 fc f3 ff ff       	jmp    801066ea <alltraps>

801072ee <vector155>:
.globl vector155
vector155:
  pushl $0
801072ee:	6a 00                	push   $0x0
  pushl $155
801072f0:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801072f5:	e9 f0 f3 ff ff       	jmp    801066ea <alltraps>

801072fa <vector156>:
.globl vector156
vector156:
  pushl $0
801072fa:	6a 00                	push   $0x0
  pushl $156
801072fc:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80107301:	e9 e4 f3 ff ff       	jmp    801066ea <alltraps>

80107306 <vector157>:
.globl vector157
vector157:
  pushl $0
80107306:	6a 00                	push   $0x0
  pushl $157
80107308:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010730d:	e9 d8 f3 ff ff       	jmp    801066ea <alltraps>

80107312 <vector158>:
.globl vector158
vector158:
  pushl $0
80107312:	6a 00                	push   $0x0
  pushl $158
80107314:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107319:	e9 cc f3 ff ff       	jmp    801066ea <alltraps>

8010731e <vector159>:
.globl vector159
vector159:
  pushl $0
8010731e:	6a 00                	push   $0x0
  pushl $159
80107320:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107325:	e9 c0 f3 ff ff       	jmp    801066ea <alltraps>

8010732a <vector160>:
.globl vector160
vector160:
  pushl $0
8010732a:	6a 00                	push   $0x0
  pushl $160
8010732c:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107331:	e9 b4 f3 ff ff       	jmp    801066ea <alltraps>

80107336 <vector161>:
.globl vector161
vector161:
  pushl $0
80107336:	6a 00                	push   $0x0
  pushl $161
80107338:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010733d:	e9 a8 f3 ff ff       	jmp    801066ea <alltraps>

80107342 <vector162>:
.globl vector162
vector162:
  pushl $0
80107342:	6a 00                	push   $0x0
  pushl $162
80107344:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107349:	e9 9c f3 ff ff       	jmp    801066ea <alltraps>

8010734e <vector163>:
.globl vector163
vector163:
  pushl $0
8010734e:	6a 00                	push   $0x0
  pushl $163
80107350:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107355:	e9 90 f3 ff ff       	jmp    801066ea <alltraps>

8010735a <vector164>:
.globl vector164
vector164:
  pushl $0
8010735a:	6a 00                	push   $0x0
  pushl $164
8010735c:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107361:	e9 84 f3 ff ff       	jmp    801066ea <alltraps>

80107366 <vector165>:
.globl vector165
vector165:
  pushl $0
80107366:	6a 00                	push   $0x0
  pushl $165
80107368:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010736d:	e9 78 f3 ff ff       	jmp    801066ea <alltraps>

80107372 <vector166>:
.globl vector166
vector166:
  pushl $0
80107372:	6a 00                	push   $0x0
  pushl $166
80107374:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107379:	e9 6c f3 ff ff       	jmp    801066ea <alltraps>

8010737e <vector167>:
.globl vector167
vector167:
  pushl $0
8010737e:	6a 00                	push   $0x0
  pushl $167
80107380:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107385:	e9 60 f3 ff ff       	jmp    801066ea <alltraps>

8010738a <vector168>:
.globl vector168
vector168:
  pushl $0
8010738a:	6a 00                	push   $0x0
  pushl $168
8010738c:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107391:	e9 54 f3 ff ff       	jmp    801066ea <alltraps>

80107396 <vector169>:
.globl vector169
vector169:
  pushl $0
80107396:	6a 00                	push   $0x0
  pushl $169
80107398:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010739d:	e9 48 f3 ff ff       	jmp    801066ea <alltraps>

801073a2 <vector170>:
.globl vector170
vector170:
  pushl $0
801073a2:	6a 00                	push   $0x0
  pushl $170
801073a4:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801073a9:	e9 3c f3 ff ff       	jmp    801066ea <alltraps>

801073ae <vector171>:
.globl vector171
vector171:
  pushl $0
801073ae:	6a 00                	push   $0x0
  pushl $171
801073b0:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801073b5:	e9 30 f3 ff ff       	jmp    801066ea <alltraps>

801073ba <vector172>:
.globl vector172
vector172:
  pushl $0
801073ba:	6a 00                	push   $0x0
  pushl $172
801073bc:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801073c1:	e9 24 f3 ff ff       	jmp    801066ea <alltraps>

801073c6 <vector173>:
.globl vector173
vector173:
  pushl $0
801073c6:	6a 00                	push   $0x0
  pushl $173
801073c8:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801073cd:	e9 18 f3 ff ff       	jmp    801066ea <alltraps>

801073d2 <vector174>:
.globl vector174
vector174:
  pushl $0
801073d2:	6a 00                	push   $0x0
  pushl $174
801073d4:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801073d9:	e9 0c f3 ff ff       	jmp    801066ea <alltraps>

801073de <vector175>:
.globl vector175
vector175:
  pushl $0
801073de:	6a 00                	push   $0x0
  pushl $175
801073e0:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801073e5:	e9 00 f3 ff ff       	jmp    801066ea <alltraps>

801073ea <vector176>:
.globl vector176
vector176:
  pushl $0
801073ea:	6a 00                	push   $0x0
  pushl $176
801073ec:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801073f1:	e9 f4 f2 ff ff       	jmp    801066ea <alltraps>

801073f6 <vector177>:
.globl vector177
vector177:
  pushl $0
801073f6:	6a 00                	push   $0x0
  pushl $177
801073f8:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801073fd:	e9 e8 f2 ff ff       	jmp    801066ea <alltraps>

80107402 <vector178>:
.globl vector178
vector178:
  pushl $0
80107402:	6a 00                	push   $0x0
  pushl $178
80107404:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107409:	e9 dc f2 ff ff       	jmp    801066ea <alltraps>

8010740e <vector179>:
.globl vector179
vector179:
  pushl $0
8010740e:	6a 00                	push   $0x0
  pushl $179
80107410:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107415:	e9 d0 f2 ff ff       	jmp    801066ea <alltraps>

8010741a <vector180>:
.globl vector180
vector180:
  pushl $0
8010741a:	6a 00                	push   $0x0
  pushl $180
8010741c:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107421:	e9 c4 f2 ff ff       	jmp    801066ea <alltraps>

80107426 <vector181>:
.globl vector181
vector181:
  pushl $0
80107426:	6a 00                	push   $0x0
  pushl $181
80107428:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010742d:	e9 b8 f2 ff ff       	jmp    801066ea <alltraps>

80107432 <vector182>:
.globl vector182
vector182:
  pushl $0
80107432:	6a 00                	push   $0x0
  pushl $182
80107434:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107439:	e9 ac f2 ff ff       	jmp    801066ea <alltraps>

8010743e <vector183>:
.globl vector183
vector183:
  pushl $0
8010743e:	6a 00                	push   $0x0
  pushl $183
80107440:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107445:	e9 a0 f2 ff ff       	jmp    801066ea <alltraps>

8010744a <vector184>:
.globl vector184
vector184:
  pushl $0
8010744a:	6a 00                	push   $0x0
  pushl $184
8010744c:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107451:	e9 94 f2 ff ff       	jmp    801066ea <alltraps>

80107456 <vector185>:
.globl vector185
vector185:
  pushl $0
80107456:	6a 00                	push   $0x0
  pushl $185
80107458:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010745d:	e9 88 f2 ff ff       	jmp    801066ea <alltraps>

80107462 <vector186>:
.globl vector186
vector186:
  pushl $0
80107462:	6a 00                	push   $0x0
  pushl $186
80107464:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107469:	e9 7c f2 ff ff       	jmp    801066ea <alltraps>

8010746e <vector187>:
.globl vector187
vector187:
  pushl $0
8010746e:	6a 00                	push   $0x0
  pushl $187
80107470:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107475:	e9 70 f2 ff ff       	jmp    801066ea <alltraps>

8010747a <vector188>:
.globl vector188
vector188:
  pushl $0
8010747a:	6a 00                	push   $0x0
  pushl $188
8010747c:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107481:	e9 64 f2 ff ff       	jmp    801066ea <alltraps>

80107486 <vector189>:
.globl vector189
vector189:
  pushl $0
80107486:	6a 00                	push   $0x0
  pushl $189
80107488:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010748d:	e9 58 f2 ff ff       	jmp    801066ea <alltraps>

80107492 <vector190>:
.globl vector190
vector190:
  pushl $0
80107492:	6a 00                	push   $0x0
  pushl $190
80107494:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107499:	e9 4c f2 ff ff       	jmp    801066ea <alltraps>

8010749e <vector191>:
.globl vector191
vector191:
  pushl $0
8010749e:	6a 00                	push   $0x0
  pushl $191
801074a0:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801074a5:	e9 40 f2 ff ff       	jmp    801066ea <alltraps>

801074aa <vector192>:
.globl vector192
vector192:
  pushl $0
801074aa:	6a 00                	push   $0x0
  pushl $192
801074ac:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801074b1:	e9 34 f2 ff ff       	jmp    801066ea <alltraps>

801074b6 <vector193>:
.globl vector193
vector193:
  pushl $0
801074b6:	6a 00                	push   $0x0
  pushl $193
801074b8:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801074bd:	e9 28 f2 ff ff       	jmp    801066ea <alltraps>

801074c2 <vector194>:
.globl vector194
vector194:
  pushl $0
801074c2:	6a 00                	push   $0x0
  pushl $194
801074c4:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801074c9:	e9 1c f2 ff ff       	jmp    801066ea <alltraps>

801074ce <vector195>:
.globl vector195
vector195:
  pushl $0
801074ce:	6a 00                	push   $0x0
  pushl $195
801074d0:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801074d5:	e9 10 f2 ff ff       	jmp    801066ea <alltraps>

801074da <vector196>:
.globl vector196
vector196:
  pushl $0
801074da:	6a 00                	push   $0x0
  pushl $196
801074dc:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801074e1:	e9 04 f2 ff ff       	jmp    801066ea <alltraps>

801074e6 <vector197>:
.globl vector197
vector197:
  pushl $0
801074e6:	6a 00                	push   $0x0
  pushl $197
801074e8:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801074ed:	e9 f8 f1 ff ff       	jmp    801066ea <alltraps>

801074f2 <vector198>:
.globl vector198
vector198:
  pushl $0
801074f2:	6a 00                	push   $0x0
  pushl $198
801074f4:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801074f9:	e9 ec f1 ff ff       	jmp    801066ea <alltraps>

801074fe <vector199>:
.globl vector199
vector199:
  pushl $0
801074fe:	6a 00                	push   $0x0
  pushl $199
80107500:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107505:	e9 e0 f1 ff ff       	jmp    801066ea <alltraps>

8010750a <vector200>:
.globl vector200
vector200:
  pushl $0
8010750a:	6a 00                	push   $0x0
  pushl $200
8010750c:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107511:	e9 d4 f1 ff ff       	jmp    801066ea <alltraps>

80107516 <vector201>:
.globl vector201
vector201:
  pushl $0
80107516:	6a 00                	push   $0x0
  pushl $201
80107518:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010751d:	e9 c8 f1 ff ff       	jmp    801066ea <alltraps>

80107522 <vector202>:
.globl vector202
vector202:
  pushl $0
80107522:	6a 00                	push   $0x0
  pushl $202
80107524:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107529:	e9 bc f1 ff ff       	jmp    801066ea <alltraps>

8010752e <vector203>:
.globl vector203
vector203:
  pushl $0
8010752e:	6a 00                	push   $0x0
  pushl $203
80107530:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107535:	e9 b0 f1 ff ff       	jmp    801066ea <alltraps>

8010753a <vector204>:
.globl vector204
vector204:
  pushl $0
8010753a:	6a 00                	push   $0x0
  pushl $204
8010753c:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107541:	e9 a4 f1 ff ff       	jmp    801066ea <alltraps>

80107546 <vector205>:
.globl vector205
vector205:
  pushl $0
80107546:	6a 00                	push   $0x0
  pushl $205
80107548:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010754d:	e9 98 f1 ff ff       	jmp    801066ea <alltraps>

80107552 <vector206>:
.globl vector206
vector206:
  pushl $0
80107552:	6a 00                	push   $0x0
  pushl $206
80107554:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107559:	e9 8c f1 ff ff       	jmp    801066ea <alltraps>

8010755e <vector207>:
.globl vector207
vector207:
  pushl $0
8010755e:	6a 00                	push   $0x0
  pushl $207
80107560:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107565:	e9 80 f1 ff ff       	jmp    801066ea <alltraps>

8010756a <vector208>:
.globl vector208
vector208:
  pushl $0
8010756a:	6a 00                	push   $0x0
  pushl $208
8010756c:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107571:	e9 74 f1 ff ff       	jmp    801066ea <alltraps>

80107576 <vector209>:
.globl vector209
vector209:
  pushl $0
80107576:	6a 00                	push   $0x0
  pushl $209
80107578:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010757d:	e9 68 f1 ff ff       	jmp    801066ea <alltraps>

80107582 <vector210>:
.globl vector210
vector210:
  pushl $0
80107582:	6a 00                	push   $0x0
  pushl $210
80107584:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107589:	e9 5c f1 ff ff       	jmp    801066ea <alltraps>

8010758e <vector211>:
.globl vector211
vector211:
  pushl $0
8010758e:	6a 00                	push   $0x0
  pushl $211
80107590:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107595:	e9 50 f1 ff ff       	jmp    801066ea <alltraps>

8010759a <vector212>:
.globl vector212
vector212:
  pushl $0
8010759a:	6a 00                	push   $0x0
  pushl $212
8010759c:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801075a1:	e9 44 f1 ff ff       	jmp    801066ea <alltraps>

801075a6 <vector213>:
.globl vector213
vector213:
  pushl $0
801075a6:	6a 00                	push   $0x0
  pushl $213
801075a8:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801075ad:	e9 38 f1 ff ff       	jmp    801066ea <alltraps>

801075b2 <vector214>:
.globl vector214
vector214:
  pushl $0
801075b2:	6a 00                	push   $0x0
  pushl $214
801075b4:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801075b9:	e9 2c f1 ff ff       	jmp    801066ea <alltraps>

801075be <vector215>:
.globl vector215
vector215:
  pushl $0
801075be:	6a 00                	push   $0x0
  pushl $215
801075c0:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801075c5:	e9 20 f1 ff ff       	jmp    801066ea <alltraps>

801075ca <vector216>:
.globl vector216
vector216:
  pushl $0
801075ca:	6a 00                	push   $0x0
  pushl $216
801075cc:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801075d1:	e9 14 f1 ff ff       	jmp    801066ea <alltraps>

801075d6 <vector217>:
.globl vector217
vector217:
  pushl $0
801075d6:	6a 00                	push   $0x0
  pushl $217
801075d8:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801075dd:	e9 08 f1 ff ff       	jmp    801066ea <alltraps>

801075e2 <vector218>:
.globl vector218
vector218:
  pushl $0
801075e2:	6a 00                	push   $0x0
  pushl $218
801075e4:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801075e9:	e9 fc f0 ff ff       	jmp    801066ea <alltraps>

801075ee <vector219>:
.globl vector219
vector219:
  pushl $0
801075ee:	6a 00                	push   $0x0
  pushl $219
801075f0:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801075f5:	e9 f0 f0 ff ff       	jmp    801066ea <alltraps>

801075fa <vector220>:
.globl vector220
vector220:
  pushl $0
801075fa:	6a 00                	push   $0x0
  pushl $220
801075fc:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107601:	e9 e4 f0 ff ff       	jmp    801066ea <alltraps>

80107606 <vector221>:
.globl vector221
vector221:
  pushl $0
80107606:	6a 00                	push   $0x0
  pushl $221
80107608:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010760d:	e9 d8 f0 ff ff       	jmp    801066ea <alltraps>

80107612 <vector222>:
.globl vector222
vector222:
  pushl $0
80107612:	6a 00                	push   $0x0
  pushl $222
80107614:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107619:	e9 cc f0 ff ff       	jmp    801066ea <alltraps>

8010761e <vector223>:
.globl vector223
vector223:
  pushl $0
8010761e:	6a 00                	push   $0x0
  pushl $223
80107620:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107625:	e9 c0 f0 ff ff       	jmp    801066ea <alltraps>

8010762a <vector224>:
.globl vector224
vector224:
  pushl $0
8010762a:	6a 00                	push   $0x0
  pushl $224
8010762c:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107631:	e9 b4 f0 ff ff       	jmp    801066ea <alltraps>

80107636 <vector225>:
.globl vector225
vector225:
  pushl $0
80107636:	6a 00                	push   $0x0
  pushl $225
80107638:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010763d:	e9 a8 f0 ff ff       	jmp    801066ea <alltraps>

80107642 <vector226>:
.globl vector226
vector226:
  pushl $0
80107642:	6a 00                	push   $0x0
  pushl $226
80107644:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107649:	e9 9c f0 ff ff       	jmp    801066ea <alltraps>

8010764e <vector227>:
.globl vector227
vector227:
  pushl $0
8010764e:	6a 00                	push   $0x0
  pushl $227
80107650:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107655:	e9 90 f0 ff ff       	jmp    801066ea <alltraps>

8010765a <vector228>:
.globl vector228
vector228:
  pushl $0
8010765a:	6a 00                	push   $0x0
  pushl $228
8010765c:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107661:	e9 84 f0 ff ff       	jmp    801066ea <alltraps>

80107666 <vector229>:
.globl vector229
vector229:
  pushl $0
80107666:	6a 00                	push   $0x0
  pushl $229
80107668:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010766d:	e9 78 f0 ff ff       	jmp    801066ea <alltraps>

80107672 <vector230>:
.globl vector230
vector230:
  pushl $0
80107672:	6a 00                	push   $0x0
  pushl $230
80107674:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107679:	e9 6c f0 ff ff       	jmp    801066ea <alltraps>

8010767e <vector231>:
.globl vector231
vector231:
  pushl $0
8010767e:	6a 00                	push   $0x0
  pushl $231
80107680:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107685:	e9 60 f0 ff ff       	jmp    801066ea <alltraps>

8010768a <vector232>:
.globl vector232
vector232:
  pushl $0
8010768a:	6a 00                	push   $0x0
  pushl $232
8010768c:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107691:	e9 54 f0 ff ff       	jmp    801066ea <alltraps>

80107696 <vector233>:
.globl vector233
vector233:
  pushl $0
80107696:	6a 00                	push   $0x0
  pushl $233
80107698:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010769d:	e9 48 f0 ff ff       	jmp    801066ea <alltraps>

801076a2 <vector234>:
.globl vector234
vector234:
  pushl $0
801076a2:	6a 00                	push   $0x0
  pushl $234
801076a4:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801076a9:	e9 3c f0 ff ff       	jmp    801066ea <alltraps>

801076ae <vector235>:
.globl vector235
vector235:
  pushl $0
801076ae:	6a 00                	push   $0x0
  pushl $235
801076b0:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801076b5:	e9 30 f0 ff ff       	jmp    801066ea <alltraps>

801076ba <vector236>:
.globl vector236
vector236:
  pushl $0
801076ba:	6a 00                	push   $0x0
  pushl $236
801076bc:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801076c1:	e9 24 f0 ff ff       	jmp    801066ea <alltraps>

801076c6 <vector237>:
.globl vector237
vector237:
  pushl $0
801076c6:	6a 00                	push   $0x0
  pushl $237
801076c8:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801076cd:	e9 18 f0 ff ff       	jmp    801066ea <alltraps>

801076d2 <vector238>:
.globl vector238
vector238:
  pushl $0
801076d2:	6a 00                	push   $0x0
  pushl $238
801076d4:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801076d9:	e9 0c f0 ff ff       	jmp    801066ea <alltraps>

801076de <vector239>:
.globl vector239
vector239:
  pushl $0
801076de:	6a 00                	push   $0x0
  pushl $239
801076e0:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801076e5:	e9 00 f0 ff ff       	jmp    801066ea <alltraps>

801076ea <vector240>:
.globl vector240
vector240:
  pushl $0
801076ea:	6a 00                	push   $0x0
  pushl $240
801076ec:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801076f1:	e9 f4 ef ff ff       	jmp    801066ea <alltraps>

801076f6 <vector241>:
.globl vector241
vector241:
  pushl $0
801076f6:	6a 00                	push   $0x0
  pushl $241
801076f8:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801076fd:	e9 e8 ef ff ff       	jmp    801066ea <alltraps>

80107702 <vector242>:
.globl vector242
vector242:
  pushl $0
80107702:	6a 00                	push   $0x0
  pushl $242
80107704:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107709:	e9 dc ef ff ff       	jmp    801066ea <alltraps>

8010770e <vector243>:
.globl vector243
vector243:
  pushl $0
8010770e:	6a 00                	push   $0x0
  pushl $243
80107710:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107715:	e9 d0 ef ff ff       	jmp    801066ea <alltraps>

8010771a <vector244>:
.globl vector244
vector244:
  pushl $0
8010771a:	6a 00                	push   $0x0
  pushl $244
8010771c:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107721:	e9 c4 ef ff ff       	jmp    801066ea <alltraps>

80107726 <vector245>:
.globl vector245
vector245:
  pushl $0
80107726:	6a 00                	push   $0x0
  pushl $245
80107728:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010772d:	e9 b8 ef ff ff       	jmp    801066ea <alltraps>

80107732 <vector246>:
.globl vector246
vector246:
  pushl $0
80107732:	6a 00                	push   $0x0
  pushl $246
80107734:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107739:	e9 ac ef ff ff       	jmp    801066ea <alltraps>

8010773e <vector247>:
.globl vector247
vector247:
  pushl $0
8010773e:	6a 00                	push   $0x0
  pushl $247
80107740:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107745:	e9 a0 ef ff ff       	jmp    801066ea <alltraps>

8010774a <vector248>:
.globl vector248
vector248:
  pushl $0
8010774a:	6a 00                	push   $0x0
  pushl $248
8010774c:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107751:	e9 94 ef ff ff       	jmp    801066ea <alltraps>

80107756 <vector249>:
.globl vector249
vector249:
  pushl $0
80107756:	6a 00                	push   $0x0
  pushl $249
80107758:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010775d:	e9 88 ef ff ff       	jmp    801066ea <alltraps>

80107762 <vector250>:
.globl vector250
vector250:
  pushl $0
80107762:	6a 00                	push   $0x0
  pushl $250
80107764:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107769:	e9 7c ef ff ff       	jmp    801066ea <alltraps>

8010776e <vector251>:
.globl vector251
vector251:
  pushl $0
8010776e:	6a 00                	push   $0x0
  pushl $251
80107770:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107775:	e9 70 ef ff ff       	jmp    801066ea <alltraps>

8010777a <vector252>:
.globl vector252
vector252:
  pushl $0
8010777a:	6a 00                	push   $0x0
  pushl $252
8010777c:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107781:	e9 64 ef ff ff       	jmp    801066ea <alltraps>

80107786 <vector253>:
.globl vector253
vector253:
  pushl $0
80107786:	6a 00                	push   $0x0
  pushl $253
80107788:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010778d:	e9 58 ef ff ff       	jmp    801066ea <alltraps>

80107792 <vector254>:
.globl vector254
vector254:
  pushl $0
80107792:	6a 00                	push   $0x0
  pushl $254
80107794:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107799:	e9 4c ef ff ff       	jmp    801066ea <alltraps>

8010779e <vector255>:
.globl vector255
vector255:
  pushl $0
8010779e:	6a 00                	push   $0x0
  pushl $255
801077a0:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801077a5:	e9 40 ef ff ff       	jmp    801066ea <alltraps>

801077aa <lgdt>:
{
801077aa:	55                   	push   %ebp
801077ab:	89 e5                	mov    %esp,%ebp
801077ad:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
801077b0:	8b 45 0c             	mov    0xc(%ebp),%eax
801077b3:	83 e8 01             	sub    $0x1,%eax
801077b6:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801077ba:	8b 45 08             	mov    0x8(%ebp),%eax
801077bd:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801077c1:	8b 45 08             	mov    0x8(%ebp),%eax
801077c4:	c1 e8 10             	shr    $0x10,%eax
801077c7:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801077cb:	8d 45 fa             	lea    -0x6(%ebp),%eax
801077ce:	0f 01 10             	lgdtl  (%eax)
}
801077d1:	c9                   	leave  
801077d2:	c3                   	ret    

801077d3 <ltr>:
{
801077d3:	55                   	push   %ebp
801077d4:	89 e5                	mov    %esp,%ebp
801077d6:	83 ec 04             	sub    $0x4,%esp
801077d9:	8b 45 08             	mov    0x8(%ebp),%eax
801077dc:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
801077e0:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801077e4:	0f 00 d8             	ltr    %ax
}
801077e7:	c9                   	leave  
801077e8:	c3                   	ret    

801077e9 <lcr3>:

static inline void
lcr3(uint val)
{
801077e9:	55                   	push   %ebp
801077ea:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
801077ec:	8b 45 08             	mov    0x8(%ebp),%eax
801077ef:	0f 22 d8             	mov    %eax,%cr3
}
801077f2:	5d                   	pop    %ebp
801077f3:	c3                   	ret    

801077f4 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
801077f4:	55                   	push   %ebp
801077f5:	89 e5                	mov    %esp,%ebp
801077f7:	83 ec 28             	sub    $0x28,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
801077fa:	e8 cb c8 ff ff       	call   801040ca <cpuid>
801077ff:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80107805:	05 40 38 11 80       	add    $0x80113840,%eax
8010780a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010780d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107810:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107816:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107819:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
8010781f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107822:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107826:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107829:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010782d:	83 e2 f0             	and    $0xfffffff0,%edx
80107830:	83 ca 0a             	or     $0xa,%edx
80107833:	88 50 7d             	mov    %dl,0x7d(%eax)
80107836:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107839:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010783d:	83 ca 10             	or     $0x10,%edx
80107840:	88 50 7d             	mov    %dl,0x7d(%eax)
80107843:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107846:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
8010784a:	83 e2 9f             	and    $0xffffff9f,%edx
8010784d:	88 50 7d             	mov    %dl,0x7d(%eax)
80107850:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107853:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107857:	83 ca 80             	or     $0xffffff80,%edx
8010785a:	88 50 7d             	mov    %dl,0x7d(%eax)
8010785d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107860:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107864:	83 ca 0f             	or     $0xf,%edx
80107867:	88 50 7e             	mov    %dl,0x7e(%eax)
8010786a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010786d:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107871:	83 e2 ef             	and    $0xffffffef,%edx
80107874:	88 50 7e             	mov    %dl,0x7e(%eax)
80107877:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010787a:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010787e:	83 e2 df             	and    $0xffffffdf,%edx
80107881:	88 50 7e             	mov    %dl,0x7e(%eax)
80107884:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107887:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010788b:	83 ca 40             	or     $0x40,%edx
8010788e:	88 50 7e             	mov    %dl,0x7e(%eax)
80107891:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107894:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107898:	83 ca 80             	or     $0xffffff80,%edx
8010789b:	88 50 7e             	mov    %dl,0x7e(%eax)
8010789e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078a1:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801078a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078a8:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
801078af:	ff ff 
801078b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078b4:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
801078bb:	00 00 
801078bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078c0:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
801078c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078ca:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801078d1:	83 e2 f0             	and    $0xfffffff0,%edx
801078d4:	83 ca 02             	or     $0x2,%edx
801078d7:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801078dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078e0:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801078e7:	83 ca 10             	or     $0x10,%edx
801078ea:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801078f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078f3:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801078fa:	83 e2 9f             	and    $0xffffff9f,%edx
801078fd:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107903:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107906:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010790d:	83 ca 80             	or     $0xffffff80,%edx
80107910:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107916:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107919:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107920:	83 ca 0f             	or     $0xf,%edx
80107923:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107929:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010792c:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107933:	83 e2 ef             	and    $0xffffffef,%edx
80107936:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010793c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010793f:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107946:	83 e2 df             	and    $0xffffffdf,%edx
80107949:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010794f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107952:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107959:	83 ca 40             	or     $0x40,%edx
8010795c:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107962:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107965:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010796c:	83 ca 80             	or     $0xffffff80,%edx
8010796f:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107975:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107978:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010797f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107982:	66 c7 80 88 00 00 00 	movw   $0xffff,0x88(%eax)
80107989:	ff ff 
8010798b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010798e:	66 c7 80 8a 00 00 00 	movw   $0x0,0x8a(%eax)
80107995:	00 00 
80107997:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010799a:	c6 80 8c 00 00 00 00 	movb   $0x0,0x8c(%eax)
801079a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079a4:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801079ab:	83 e2 f0             	and    $0xfffffff0,%edx
801079ae:	83 ca 0a             	or     $0xa,%edx
801079b1:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801079b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079ba:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801079c1:	83 ca 10             	or     $0x10,%edx
801079c4:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801079ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079cd:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801079d4:	83 ca 60             	or     $0x60,%edx
801079d7:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801079dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079e0:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
801079e7:	83 ca 80             	or     $0xffffff80,%edx
801079ea:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801079f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079f3:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801079fa:	83 ca 0f             	or     $0xf,%edx
801079fd:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a06:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107a0d:	83 e2 ef             	and    $0xffffffef,%edx
80107a10:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a19:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107a20:	83 e2 df             	and    $0xffffffdf,%edx
80107a23:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a2c:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107a33:	83 ca 40             	or     $0x40,%edx
80107a36:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a3f:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107a46:	83 ca 80             	or     $0xffffff80,%edx
80107a49:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a52:	c6 80 8f 00 00 00 00 	movb   $0x0,0x8f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107a59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a5c:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107a63:	ff ff 
80107a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a68:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107a6f:	00 00 
80107a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a74:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a7e:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107a85:	83 e2 f0             	and    $0xfffffff0,%edx
80107a88:	83 ca 02             	or     $0x2,%edx
80107a8b:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a94:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107a9b:	83 ca 10             	or     $0x10,%edx
80107a9e:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107aa7:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107aae:	83 ca 60             	or     $0x60,%edx
80107ab1:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107aba:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107ac1:	83 ca 80             	or     $0xffffff80,%edx
80107ac4:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107acd:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107ad4:	83 ca 0f             	or     $0xf,%edx
80107ad7:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107add:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ae0:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107ae7:	83 e2 ef             	and    $0xffffffef,%edx
80107aea:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107af3:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107afa:	83 e2 df             	and    $0xffffffdf,%edx
80107afd:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b06:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107b0d:	83 ca 40             	or     $0x40,%edx
80107b10:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b19:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107b20:	83 ca 80             	or     $0xffffff80,%edx
80107b23:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b2c:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
80107b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b36:	83 c0 70             	add    $0x70,%eax
80107b39:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
80107b40:	00 
80107b41:	89 04 24             	mov    %eax,(%esp)
80107b44:	e8 61 fc ff ff       	call   801077aa <lgdt>
}
80107b49:	c9                   	leave  
80107b4a:	c3                   	ret    

80107b4b <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107b4b:	55                   	push   %ebp
80107b4c:	89 e5                	mov    %esp,%ebp
80107b4e:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107b51:	8b 45 0c             	mov    0xc(%ebp),%eax
80107b54:	c1 e8 16             	shr    $0x16,%eax
80107b57:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107b5e:	8b 45 08             	mov    0x8(%ebp),%eax
80107b61:	01 d0                	add    %edx,%eax
80107b63:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80107b66:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b69:	8b 00                	mov    (%eax),%eax
80107b6b:	83 e0 01             	and    $0x1,%eax
80107b6e:	85 c0                	test   %eax,%eax
80107b70:	74 14                	je     80107b86 <walkpgdir+0x3b>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107b72:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107b75:	8b 00                	mov    (%eax),%eax
80107b77:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107b7c:	05 00 00 00 80       	add    $0x80000000,%eax
80107b81:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107b84:	eb 48                	jmp    80107bce <walkpgdir+0x83>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107b86:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80107b8a:	74 0e                	je     80107b9a <walkpgdir+0x4f>
80107b8c:	e8 18 b0 ff ff       	call   80102ba9 <kalloc>
80107b91:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107b94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107b98:	75 07                	jne    80107ba1 <walkpgdir+0x56>
      return 0;
80107b9a:	b8 00 00 00 00       	mov    $0x0,%eax
80107b9f:	eb 44                	jmp    80107be5 <walkpgdir+0x9a>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80107ba1:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107ba8:	00 
80107ba9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107bb0:	00 
80107bb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bb4:	89 04 24             	mov    %eax,(%esp)
80107bb7:	e8 31 d7 ff ff       	call   801052ed <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107bbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bbf:	05 00 00 00 80       	add    $0x80000000,%eax
80107bc4:	83 c8 07             	or     $0x7,%eax
80107bc7:	89 c2                	mov    %eax,%edx
80107bc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107bcc:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80107bce:	8b 45 0c             	mov    0xc(%ebp),%eax
80107bd1:	c1 e8 0c             	shr    $0xc,%eax
80107bd4:	25 ff 03 00 00       	and    $0x3ff,%eax
80107bd9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107be0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107be3:	01 d0                	add    %edx,%eax
}
80107be5:	c9                   	leave  
80107be6:	c3                   	ret    

80107be7 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107be7:	55                   	push   %ebp
80107be8:	89 e5                	mov    %esp,%ebp
80107bea:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80107bed:	8b 45 0c             	mov    0xc(%ebp),%eax
80107bf0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107bf5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107bf8:	8b 55 0c             	mov    0xc(%ebp),%edx
80107bfb:	8b 45 10             	mov    0x10(%ebp),%eax
80107bfe:	01 d0                	add    %edx,%eax
80107c00:	83 e8 01             	sub    $0x1,%eax
80107c03:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107c08:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107c0b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80107c12:	00 
80107c13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c16:	89 44 24 04          	mov    %eax,0x4(%esp)
80107c1a:	8b 45 08             	mov    0x8(%ebp),%eax
80107c1d:	89 04 24             	mov    %eax,(%esp)
80107c20:	e8 26 ff ff ff       	call   80107b4b <walkpgdir>
80107c25:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107c28:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107c2c:	75 07                	jne    80107c35 <mappages+0x4e>
      return -1;
80107c2e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107c33:	eb 48                	jmp    80107c7d <mappages+0x96>
    if(*pte & PTE_P)
80107c35:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107c38:	8b 00                	mov    (%eax),%eax
80107c3a:	83 e0 01             	and    $0x1,%eax
80107c3d:	85 c0                	test   %eax,%eax
80107c3f:	74 0c                	je     80107c4d <mappages+0x66>
      panic("remap");
80107c41:	c7 04 24 5c 8b 10 80 	movl   $0x80108b5c,(%esp)
80107c48:	e8 15 89 ff ff       	call   80100562 <panic>
    *pte = pa | perm | PTE_P;
80107c4d:	8b 45 18             	mov    0x18(%ebp),%eax
80107c50:	0b 45 14             	or     0x14(%ebp),%eax
80107c53:	83 c8 01             	or     $0x1,%eax
80107c56:	89 c2                	mov    %eax,%edx
80107c58:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107c5b:	89 10                	mov    %edx,(%eax)
    if(a == last)
80107c5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c60:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107c63:	75 08                	jne    80107c6d <mappages+0x86>
      break;
80107c65:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80107c66:	b8 00 00 00 00       	mov    $0x0,%eax
80107c6b:	eb 10                	jmp    80107c7d <mappages+0x96>
    a += PGSIZE;
80107c6d:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80107c74:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80107c7b:	eb 8e                	jmp    80107c0b <mappages+0x24>
}
80107c7d:	c9                   	leave  
80107c7e:	c3                   	ret    

80107c7f <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107c7f:	55                   	push   %ebp
80107c80:	89 e5                	mov    %esp,%ebp
80107c82:	53                   	push   %ebx
80107c83:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107c86:	e8 1e af ff ff       	call   80102ba9 <kalloc>
80107c8b:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107c8e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107c92:	75 0a                	jne    80107c9e <setupkvm+0x1f>
    return 0;
80107c94:	b8 00 00 00 00       	mov    $0x0,%eax
80107c99:	e9 84 00 00 00       	jmp    80107d22 <setupkvm+0xa3>
  memset(pgdir, 0, PGSIZE);
80107c9e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107ca5:	00 
80107ca6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107cad:	00 
80107cae:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107cb1:	89 04 24             	mov    %eax,(%esp)
80107cb4:	e8 34 d6 ff ff       	call   801052ed <memset>
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107cb9:	c7 45 f4 c0 b4 10 80 	movl   $0x8010b4c0,-0xc(%ebp)
80107cc0:	eb 54                	jmp    80107d16 <setupkvm+0x97>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80107cc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cc5:	8b 48 0c             	mov    0xc(%eax),%ecx
80107cc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ccb:	8b 50 04             	mov    0x4(%eax),%edx
80107cce:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cd1:	8b 58 08             	mov    0x8(%eax),%ebx
80107cd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cd7:	8b 40 04             	mov    0x4(%eax),%eax
80107cda:	29 c3                	sub    %eax,%ebx
80107cdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cdf:	8b 00                	mov    (%eax),%eax
80107ce1:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80107ce5:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107ce9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80107ced:	89 44 24 04          	mov    %eax,0x4(%esp)
80107cf1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107cf4:	89 04 24             	mov    %eax,(%esp)
80107cf7:	e8 eb fe ff ff       	call   80107be7 <mappages>
80107cfc:	85 c0                	test   %eax,%eax
80107cfe:	79 12                	jns    80107d12 <setupkvm+0x93>
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80107d00:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d03:	89 04 24             	mov    %eax,(%esp)
80107d06:	e8 26 05 00 00       	call   80108231 <freevm>
      return 0;
80107d0b:	b8 00 00 00 00       	mov    $0x0,%eax
80107d10:	eb 10                	jmp    80107d22 <setupkvm+0xa3>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107d12:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80107d16:	81 7d f4 00 b5 10 80 	cmpl   $0x8010b500,-0xc(%ebp)
80107d1d:	72 a3                	jb     80107cc2 <setupkvm+0x43>
    }
  return pgdir;
80107d1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107d22:	83 c4 34             	add    $0x34,%esp
80107d25:	5b                   	pop    %ebx
80107d26:	5d                   	pop    %ebp
80107d27:	c3                   	ret    

80107d28 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107d28:	55                   	push   %ebp
80107d29:	89 e5                	mov    %esp,%ebp
80107d2b:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107d2e:	e8 4c ff ff ff       	call   80107c7f <setupkvm>
80107d33:	a3 64 67 11 80       	mov    %eax,0x80116764
  switchkvm();
80107d38:	e8 02 00 00 00       	call   80107d3f <switchkvm>
}
80107d3d:	c9                   	leave  
80107d3e:	c3                   	ret    

80107d3f <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107d3f:	55                   	push   %ebp
80107d40:	89 e5                	mov    %esp,%ebp
80107d42:	83 ec 04             	sub    $0x4,%esp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107d45:	a1 64 67 11 80       	mov    0x80116764,%eax
80107d4a:	05 00 00 00 80       	add    $0x80000000,%eax
80107d4f:	89 04 24             	mov    %eax,(%esp)
80107d52:	e8 92 fa ff ff       	call   801077e9 <lcr3>
}
80107d57:	c9                   	leave  
80107d58:	c3                   	ret    

80107d59 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107d59:	55                   	push   %ebp
80107d5a:	89 e5                	mov    %esp,%ebp
80107d5c:	57                   	push   %edi
80107d5d:	56                   	push   %esi
80107d5e:	53                   	push   %ebx
80107d5f:	83 ec 1c             	sub    $0x1c,%esp
  if(p == 0)
80107d62:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80107d66:	75 0c                	jne    80107d74 <switchuvm+0x1b>
    panic("switchuvm: no process");
80107d68:	c7 04 24 62 8b 10 80 	movl   $0x80108b62,(%esp)
80107d6f:	e8 ee 87 ff ff       	call   80100562 <panic>
  if(p->kstack == 0)
80107d74:	8b 45 08             	mov    0x8(%ebp),%eax
80107d77:	8b 40 08             	mov    0x8(%eax),%eax
80107d7a:	85 c0                	test   %eax,%eax
80107d7c:	75 0c                	jne    80107d8a <switchuvm+0x31>
    panic("switchuvm: no kstack");
80107d7e:	c7 04 24 78 8b 10 80 	movl   $0x80108b78,(%esp)
80107d85:	e8 d8 87 ff ff       	call   80100562 <panic>
  if(p->pgdir == 0)
80107d8a:	8b 45 08             	mov    0x8(%ebp),%eax
80107d8d:	8b 40 04             	mov    0x4(%eax),%eax
80107d90:	85 c0                	test   %eax,%eax
80107d92:	75 0c                	jne    80107da0 <switchuvm+0x47>
    panic("switchuvm: no pgdir");
80107d94:	c7 04 24 8d 8b 10 80 	movl   $0x80108b8d,(%esp)
80107d9b:	e8 c2 87 ff ff       	call   80100562 <panic>

  pushcli();
80107da0:	e8 43 d4 ff ff       	call   801051e8 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107da5:	e8 41 c3 ff ff       	call   801040eb <mycpu>
80107daa:	89 c3                	mov    %eax,%ebx
80107dac:	e8 3a c3 ff ff       	call   801040eb <mycpu>
80107db1:	83 c0 08             	add    $0x8,%eax
80107db4:	89 c7                	mov    %eax,%edi
80107db6:	e8 30 c3 ff ff       	call   801040eb <mycpu>
80107dbb:	83 c0 08             	add    $0x8,%eax
80107dbe:	c1 e8 10             	shr    $0x10,%eax
80107dc1:	89 c6                	mov    %eax,%esi
80107dc3:	e8 23 c3 ff ff       	call   801040eb <mycpu>
80107dc8:	83 c0 08             	add    $0x8,%eax
80107dcb:	c1 e8 18             	shr    $0x18,%eax
80107dce:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
80107dd5:	67 00 
80107dd7:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107dde:	89 f1                	mov    %esi,%ecx
80107de0:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107de6:	0f b6 93 9d 00 00 00 	movzbl 0x9d(%ebx),%edx
80107ded:	83 e2 f0             	and    $0xfffffff0,%edx
80107df0:	83 ca 09             	or     $0x9,%edx
80107df3:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80107df9:	0f b6 93 9d 00 00 00 	movzbl 0x9d(%ebx),%edx
80107e00:	83 ca 10             	or     $0x10,%edx
80107e03:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80107e09:	0f b6 93 9d 00 00 00 	movzbl 0x9d(%ebx),%edx
80107e10:	83 e2 9f             	and    $0xffffff9f,%edx
80107e13:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80107e19:	0f b6 93 9d 00 00 00 	movzbl 0x9d(%ebx),%edx
80107e20:	83 ca 80             	or     $0xffffff80,%edx
80107e23:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80107e29:	0f b6 93 9e 00 00 00 	movzbl 0x9e(%ebx),%edx
80107e30:	83 e2 f0             	and    $0xfffffff0,%edx
80107e33:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80107e39:	0f b6 93 9e 00 00 00 	movzbl 0x9e(%ebx),%edx
80107e40:	83 e2 ef             	and    $0xffffffef,%edx
80107e43:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80107e49:	0f b6 93 9e 00 00 00 	movzbl 0x9e(%ebx),%edx
80107e50:	83 e2 df             	and    $0xffffffdf,%edx
80107e53:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80107e59:	0f b6 93 9e 00 00 00 	movzbl 0x9e(%ebx),%edx
80107e60:	83 ca 40             	or     $0x40,%edx
80107e63:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80107e69:	0f b6 93 9e 00 00 00 	movzbl 0x9e(%ebx),%edx
80107e70:	83 e2 7f             	and    $0x7f,%edx
80107e73:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80107e79:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80107e7f:	e8 67 c2 ff ff       	call   801040eb <mycpu>
80107e84:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107e8b:	83 e2 ef             	and    $0xffffffef,%edx
80107e8e:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107e94:	e8 52 c2 ff ff       	call   801040eb <mycpu>
80107e99:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107e9f:	e8 47 c2 ff ff       	call   801040eb <mycpu>
80107ea4:	8b 55 08             	mov    0x8(%ebp),%edx
80107ea7:	8b 52 08             	mov    0x8(%edx),%edx
80107eaa:	81 c2 00 10 00 00    	add    $0x1000,%edx
80107eb0:	89 50 0c             	mov    %edx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107eb3:	e8 33 c2 ff ff       	call   801040eb <mycpu>
80107eb8:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  ltr(SEG_TSS << 3);
80107ebe:	c7 04 24 28 00 00 00 	movl   $0x28,(%esp)
80107ec5:	e8 09 f9 ff ff       	call   801077d3 <ltr>
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107eca:	8b 45 08             	mov    0x8(%ebp),%eax
80107ecd:	8b 40 04             	mov    0x4(%eax),%eax
80107ed0:	05 00 00 00 80       	add    $0x80000000,%eax
80107ed5:	89 04 24             	mov    %eax,(%esp)
80107ed8:	e8 0c f9 ff ff       	call   801077e9 <lcr3>
  popcli();
80107edd:	e8 52 d3 ff ff       	call   80105234 <popcli>
}
80107ee2:	83 c4 1c             	add    $0x1c,%esp
80107ee5:	5b                   	pop    %ebx
80107ee6:	5e                   	pop    %esi
80107ee7:	5f                   	pop    %edi
80107ee8:	5d                   	pop    %ebp
80107ee9:	c3                   	ret    

80107eea <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107eea:	55                   	push   %ebp
80107eeb:	89 e5                	mov    %esp,%ebp
80107eed:	83 ec 38             	sub    $0x38,%esp
  char *mem;

  if(sz >= PGSIZE)
80107ef0:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80107ef7:	76 0c                	jbe    80107f05 <inituvm+0x1b>
    panic("inituvm: more than a page");
80107ef9:	c7 04 24 a1 8b 10 80 	movl   $0x80108ba1,(%esp)
80107f00:	e8 5d 86 ff ff       	call   80100562 <panic>
  mem = kalloc();
80107f05:	e8 9f ac ff ff       	call   80102ba9 <kalloc>
80107f0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80107f0d:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107f14:	00 
80107f15:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107f1c:	00 
80107f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f20:	89 04 24             	mov    %eax,(%esp)
80107f23:	e8 c5 d3 ff ff       	call   801052ed <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107f28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f2b:	05 00 00 00 80       	add    $0x80000000,%eax
80107f30:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80107f37:	00 
80107f38:	89 44 24 0c          	mov    %eax,0xc(%esp)
80107f3c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107f43:	00 
80107f44:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107f4b:	00 
80107f4c:	8b 45 08             	mov    0x8(%ebp),%eax
80107f4f:	89 04 24             	mov    %eax,(%esp)
80107f52:	e8 90 fc ff ff       	call   80107be7 <mappages>
  memmove(mem, init, sz);
80107f57:	8b 45 10             	mov    0x10(%ebp),%eax
80107f5a:	89 44 24 08          	mov    %eax,0x8(%esp)
80107f5e:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f61:	89 44 24 04          	mov    %eax,0x4(%esp)
80107f65:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f68:	89 04 24             	mov    %eax,(%esp)
80107f6b:	e8 4c d4 ff ff       	call   801053bc <memmove>
}
80107f70:	c9                   	leave  
80107f71:	c3                   	ret    

80107f72 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80107f72:	55                   	push   %ebp
80107f73:	89 e5                	mov    %esp,%ebp
80107f75:	83 ec 28             	sub    $0x28,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80107f78:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f7b:	25 ff 0f 00 00       	and    $0xfff,%eax
80107f80:	85 c0                	test   %eax,%eax
80107f82:	74 0c                	je     80107f90 <loaduvm+0x1e>
    panic("loaduvm: addr must be page aligned");
80107f84:	c7 04 24 bc 8b 10 80 	movl   $0x80108bbc,(%esp)
80107f8b:	e8 d2 85 ff ff       	call   80100562 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80107f90:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80107f97:	e9 a6 00 00 00       	jmp    80108042 <loaduvm+0xd0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107f9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f9f:	8b 55 0c             	mov    0xc(%ebp),%edx
80107fa2:	01 d0                	add    %edx,%eax
80107fa4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80107fab:	00 
80107fac:	89 44 24 04          	mov    %eax,0x4(%esp)
80107fb0:	8b 45 08             	mov    0x8(%ebp),%eax
80107fb3:	89 04 24             	mov    %eax,(%esp)
80107fb6:	e8 90 fb ff ff       	call   80107b4b <walkpgdir>
80107fbb:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107fbe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107fc2:	75 0c                	jne    80107fd0 <loaduvm+0x5e>
      panic("loaduvm: address should exist");
80107fc4:	c7 04 24 df 8b 10 80 	movl   $0x80108bdf,(%esp)
80107fcb:	e8 92 85 ff ff       	call   80100562 <panic>
    pa = PTE_ADDR(*pte);
80107fd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107fd3:	8b 00                	mov    (%eax),%eax
80107fd5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107fda:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80107fdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fe0:	8b 55 18             	mov    0x18(%ebp),%edx
80107fe3:	29 c2                	sub    %eax,%edx
80107fe5:	89 d0                	mov    %edx,%eax
80107fe7:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80107fec:	77 0f                	ja     80107ffd <loaduvm+0x8b>
      n = sz - i;
80107fee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ff1:	8b 55 18             	mov    0x18(%ebp),%edx
80107ff4:	29 c2                	sub    %eax,%edx
80107ff6:	89 d0                	mov    %edx,%eax
80107ff8:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107ffb:	eb 07                	jmp    80108004 <loaduvm+0x92>
    else
      n = PGSIZE;
80107ffd:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80108004:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108007:	8b 55 14             	mov    0x14(%ebp),%edx
8010800a:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
8010800d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108010:	05 00 00 00 80       	add    $0x80000000,%eax
80108015:	8b 55 f0             	mov    -0x10(%ebp),%edx
80108018:	89 54 24 0c          	mov    %edx,0xc(%esp)
8010801c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80108020:	89 44 24 04          	mov    %eax,0x4(%esp)
80108024:	8b 45 10             	mov    0x10(%ebp),%eax
80108027:	89 04 24             	mov    %eax,(%esp)
8010802a:	e8 cb 9d ff ff       	call   80101dfa <readi>
8010802f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108032:	74 07                	je     8010803b <loaduvm+0xc9>
      return -1;
80108034:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108039:	eb 18                	jmp    80108053 <loaduvm+0xe1>
  for(i = 0; i < sz; i += PGSIZE){
8010803b:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108042:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108045:	3b 45 18             	cmp    0x18(%ebp),%eax
80108048:	0f 82 4e ff ff ff    	jb     80107f9c <loaduvm+0x2a>
  }
  return 0;
8010804e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108053:	c9                   	leave  
80108054:	c3                   	ret    

80108055 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108055:	55                   	push   %ebp
80108056:	89 e5                	mov    %esp,%ebp
80108058:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
8010805b:	8b 45 10             	mov    0x10(%ebp),%eax
8010805e:	85 c0                	test   %eax,%eax
80108060:	79 0a                	jns    8010806c <allocuvm+0x17>
    return 0;
80108062:	b8 00 00 00 00       	mov    $0x0,%eax
80108067:	e9 fd 00 00 00       	jmp    80108169 <allocuvm+0x114>
  if(newsz < oldsz)
8010806c:	8b 45 10             	mov    0x10(%ebp),%eax
8010806f:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108072:	73 08                	jae    8010807c <allocuvm+0x27>
    return oldsz;
80108074:	8b 45 0c             	mov    0xc(%ebp),%eax
80108077:	e9 ed 00 00 00       	jmp    80108169 <allocuvm+0x114>

  a = PGROUNDUP(oldsz);
8010807c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010807f:	05 ff 0f 00 00       	add    $0xfff,%eax
80108084:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108089:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
8010808c:	e9 c9 00 00 00       	jmp    8010815a <allocuvm+0x105>
    mem = kalloc();
80108091:	e8 13 ab ff ff       	call   80102ba9 <kalloc>
80108096:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80108099:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010809d:	75 2f                	jne    801080ce <allocuvm+0x79>
      cprintf("allocuvm out of memory\n");
8010809f:	c7 04 24 fd 8b 10 80 	movl   $0x80108bfd,(%esp)
801080a6:	e8 1d 83 ff ff       	call   801003c8 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801080ab:	8b 45 0c             	mov    0xc(%ebp),%eax
801080ae:	89 44 24 08          	mov    %eax,0x8(%esp)
801080b2:	8b 45 10             	mov    0x10(%ebp),%eax
801080b5:	89 44 24 04          	mov    %eax,0x4(%esp)
801080b9:	8b 45 08             	mov    0x8(%ebp),%eax
801080bc:	89 04 24             	mov    %eax,(%esp)
801080bf:	e8 a7 00 00 00       	call   8010816b <deallocuvm>
      return 0;
801080c4:	b8 00 00 00 00       	mov    $0x0,%eax
801080c9:	e9 9b 00 00 00       	jmp    80108169 <allocuvm+0x114>
    }
    memset(mem, 0, PGSIZE);
801080ce:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801080d5:	00 
801080d6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801080dd:	00 
801080de:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080e1:	89 04 24             	mov    %eax,(%esp)
801080e4:	e8 04 d2 ff ff       	call   801052ed <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801080e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801080ec:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
801080f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080f5:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
801080fc:	00 
801080fd:	89 54 24 0c          	mov    %edx,0xc(%esp)
80108101:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108108:	00 
80108109:	89 44 24 04          	mov    %eax,0x4(%esp)
8010810d:	8b 45 08             	mov    0x8(%ebp),%eax
80108110:	89 04 24             	mov    %eax,(%esp)
80108113:	e8 cf fa ff ff       	call   80107be7 <mappages>
80108118:	85 c0                	test   %eax,%eax
8010811a:	79 37                	jns    80108153 <allocuvm+0xfe>
      cprintf("allocuvm out of memory (2)\n");
8010811c:	c7 04 24 15 8c 10 80 	movl   $0x80108c15,(%esp)
80108123:	e8 a0 82 ff ff       	call   801003c8 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80108128:	8b 45 0c             	mov    0xc(%ebp),%eax
8010812b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010812f:	8b 45 10             	mov    0x10(%ebp),%eax
80108132:	89 44 24 04          	mov    %eax,0x4(%esp)
80108136:	8b 45 08             	mov    0x8(%ebp),%eax
80108139:	89 04 24             	mov    %eax,(%esp)
8010813c:	e8 2a 00 00 00       	call   8010816b <deallocuvm>
      kfree(mem);
80108141:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108144:	89 04 24             	mov    %eax,(%esp)
80108147:	e8 c7 a9 ff ff       	call   80102b13 <kfree>
      return 0;
8010814c:	b8 00 00 00 00       	mov    $0x0,%eax
80108151:	eb 16                	jmp    80108169 <allocuvm+0x114>
  for(; a < newsz; a += PGSIZE){
80108153:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010815a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010815d:	3b 45 10             	cmp    0x10(%ebp),%eax
80108160:	0f 82 2b ff ff ff    	jb     80108091 <allocuvm+0x3c>
    }
  }
  return newsz;
80108166:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108169:	c9                   	leave  
8010816a:	c3                   	ret    

8010816b <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010816b:	55                   	push   %ebp
8010816c:	89 e5                	mov    %esp,%ebp
8010816e:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80108171:	8b 45 10             	mov    0x10(%ebp),%eax
80108174:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108177:	72 08                	jb     80108181 <deallocuvm+0x16>
    return oldsz;
80108179:	8b 45 0c             	mov    0xc(%ebp),%eax
8010817c:	e9 ae 00 00 00       	jmp    8010822f <deallocuvm+0xc4>

  a = PGROUNDUP(newsz);
80108181:	8b 45 10             	mov    0x10(%ebp),%eax
80108184:	05 ff 0f 00 00       	add    $0xfff,%eax
80108189:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010818e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80108191:	e9 8a 00 00 00       	jmp    80108220 <deallocuvm+0xb5>
    pte = walkpgdir(pgdir, (char*)a, 0);
80108196:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108199:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801081a0:	00 
801081a1:	89 44 24 04          	mov    %eax,0x4(%esp)
801081a5:	8b 45 08             	mov    0x8(%ebp),%eax
801081a8:	89 04 24             	mov    %eax,(%esp)
801081ab:	e8 9b f9 ff ff       	call   80107b4b <walkpgdir>
801081b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
801081b3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801081b7:	75 16                	jne    801081cf <deallocuvm+0x64>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801081b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081bc:	c1 e8 16             	shr    $0x16,%eax
801081bf:	83 c0 01             	add    $0x1,%eax
801081c2:	c1 e0 16             	shl    $0x16,%eax
801081c5:	2d 00 10 00 00       	sub    $0x1000,%eax
801081ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
801081cd:	eb 4a                	jmp    80108219 <deallocuvm+0xae>
    else if((*pte & PTE_P) != 0){
801081cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081d2:	8b 00                	mov    (%eax),%eax
801081d4:	83 e0 01             	and    $0x1,%eax
801081d7:	85 c0                	test   %eax,%eax
801081d9:	74 3e                	je     80108219 <deallocuvm+0xae>
      pa = PTE_ADDR(*pte);
801081db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801081de:	8b 00                	mov    (%eax),%eax
801081e0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801081e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
801081e8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801081ec:	75 0c                	jne    801081fa <deallocuvm+0x8f>
        panic("kfree");
801081ee:	c7 04 24 31 8c 10 80 	movl   $0x80108c31,(%esp)
801081f5:	e8 68 83 ff ff       	call   80100562 <panic>
      char *v = P2V(pa);
801081fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
801081fd:	05 00 00 00 80       	add    $0x80000000,%eax
80108202:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80108205:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108208:	89 04 24             	mov    %eax,(%esp)
8010820b:	e8 03 a9 ff ff       	call   80102b13 <kfree>
      *pte = 0;
80108210:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108213:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80108219:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108220:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108223:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108226:	0f 82 6a ff ff ff    	jb     80108196 <deallocuvm+0x2b>
    }
  }
  return newsz;
8010822c:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010822f:	c9                   	leave  
80108230:	c3                   	ret    

80108231 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108231:	55                   	push   %ebp
80108232:	89 e5                	mov    %esp,%ebp
80108234:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
80108237:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010823b:	75 0c                	jne    80108249 <freevm+0x18>
    panic("freevm: no pgdir");
8010823d:	c7 04 24 37 8c 10 80 	movl   $0x80108c37,(%esp)
80108244:	e8 19 83 ff ff       	call   80100562 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80108249:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108250:	00 
80108251:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
80108258:	80 
80108259:	8b 45 08             	mov    0x8(%ebp),%eax
8010825c:	89 04 24             	mov    %eax,(%esp)
8010825f:	e8 07 ff ff ff       	call   8010816b <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
80108264:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010826b:	eb 45                	jmp    801082b2 <freevm+0x81>
    if(pgdir[i] & PTE_P){
8010826d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108270:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108277:	8b 45 08             	mov    0x8(%ebp),%eax
8010827a:	01 d0                	add    %edx,%eax
8010827c:	8b 00                	mov    (%eax),%eax
8010827e:	83 e0 01             	and    $0x1,%eax
80108281:	85 c0                	test   %eax,%eax
80108283:	74 29                	je     801082ae <freevm+0x7d>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80108285:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108288:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
8010828f:	8b 45 08             	mov    0x8(%ebp),%eax
80108292:	01 d0                	add    %edx,%eax
80108294:	8b 00                	mov    (%eax),%eax
80108296:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010829b:	05 00 00 00 80       	add    $0x80000000,%eax
801082a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
801082a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801082a6:	89 04 24             	mov    %eax,(%esp)
801082a9:	e8 65 a8 ff ff       	call   80102b13 <kfree>
  for(i = 0; i < NPDENTRIES; i++){
801082ae:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801082b2:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
801082b9:	76 b2                	jbe    8010826d <freevm+0x3c>
    }
  }
  kfree((char*)pgdir);
801082bb:	8b 45 08             	mov    0x8(%ebp),%eax
801082be:	89 04 24             	mov    %eax,(%esp)
801082c1:	e8 4d a8 ff ff       	call   80102b13 <kfree>
}
801082c6:	c9                   	leave  
801082c7:	c3                   	ret    

801082c8 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801082c8:	55                   	push   %ebp
801082c9:	89 e5                	mov    %esp,%ebp
801082cb:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801082ce:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801082d5:	00 
801082d6:	8b 45 0c             	mov    0xc(%ebp),%eax
801082d9:	89 44 24 04          	mov    %eax,0x4(%esp)
801082dd:	8b 45 08             	mov    0x8(%ebp),%eax
801082e0:	89 04 24             	mov    %eax,(%esp)
801082e3:	e8 63 f8 ff ff       	call   80107b4b <walkpgdir>
801082e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
801082eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801082ef:	75 0c                	jne    801082fd <clearpteu+0x35>
    panic("clearpteu");
801082f1:	c7 04 24 48 8c 10 80 	movl   $0x80108c48,(%esp)
801082f8:	e8 65 82 ff ff       	call   80100562 <panic>
  *pte &= ~PTE_U;
801082fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108300:	8b 00                	mov    (%eax),%eax
80108302:	83 e0 fb             	and    $0xfffffffb,%eax
80108305:	89 c2                	mov    %eax,%edx
80108307:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010830a:	89 10                	mov    %edx,(%eax)
}
8010830c:	c9                   	leave  
8010830d:	c3                   	ret    

8010830e <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
8010830e:	55                   	push   %ebp
8010830f:	89 e5                	mov    %esp,%ebp
80108311:	83 ec 48             	sub    $0x48,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108314:	e8 66 f9 ff ff       	call   80107c7f <setupkvm>
80108319:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010831c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108320:	75 0a                	jne    8010832c <copyuvm+0x1e>
    return 0;
80108322:	b8 00 00 00 00       	mov    $0x0,%eax
80108327:	e9 03 01 00 00       	jmp    8010842f <copyuvm+0x121>
  for(i = 0; i < sz; i += PGSIZE){
8010832c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108333:	e9 d6 00 00 00       	jmp    8010840e <copyuvm+0x100>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108338:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010833b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108342:	00 
80108343:	89 44 24 04          	mov    %eax,0x4(%esp)
80108347:	8b 45 08             	mov    0x8(%ebp),%eax
8010834a:	89 04 24             	mov    %eax,(%esp)
8010834d:	e8 f9 f7 ff ff       	call   80107b4b <walkpgdir>
80108352:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108355:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108359:	75 0c                	jne    80108367 <copyuvm+0x59>
      panic("copyuvm: pte should exist");
8010835b:	c7 04 24 52 8c 10 80 	movl   $0x80108c52,(%esp)
80108362:	e8 fb 81 ff ff       	call   80100562 <panic>
    if(!(*pte & PTE_P))
80108367:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010836a:	8b 00                	mov    (%eax),%eax
8010836c:	83 e0 01             	and    $0x1,%eax
8010836f:	85 c0                	test   %eax,%eax
80108371:	75 0c                	jne    8010837f <copyuvm+0x71>
      panic("copyuvm: page not present");
80108373:	c7 04 24 6c 8c 10 80 	movl   $0x80108c6c,(%esp)
8010837a:	e8 e3 81 ff ff       	call   80100562 <panic>
    pa = PTE_ADDR(*pte);
8010837f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108382:	8b 00                	mov    (%eax),%eax
80108384:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108389:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
8010838c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010838f:	8b 00                	mov    (%eax),%eax
80108391:	25 ff 0f 00 00       	and    $0xfff,%eax
80108396:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80108399:	e8 0b a8 ff ff       	call   80102ba9 <kalloc>
8010839e:	89 45 e0             	mov    %eax,-0x20(%ebp)
801083a1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801083a5:	75 02                	jne    801083a9 <copyuvm+0x9b>
      goto bad;
801083a7:	eb 76                	jmp    8010841f <copyuvm+0x111>
    memmove(mem, (char*)P2V(pa), PGSIZE);
801083a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
801083ac:	05 00 00 00 80       	add    $0x80000000,%eax
801083b1:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801083b8:	00 
801083b9:	89 44 24 04          	mov    %eax,0x4(%esp)
801083bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
801083c0:	89 04 24             	mov    %eax,(%esp)
801083c3:	e8 f4 cf ff ff       	call   801053bc <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801083c8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801083cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801083ce:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
801083d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083d7:	89 54 24 10          	mov    %edx,0x10(%esp)
801083db:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801083df:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801083e6:	00 
801083e7:	89 44 24 04          	mov    %eax,0x4(%esp)
801083eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801083ee:	89 04 24             	mov    %eax,(%esp)
801083f1:	e8 f1 f7 ff ff       	call   80107be7 <mappages>
801083f6:	85 c0                	test   %eax,%eax
801083f8:	79 0d                	jns    80108407 <copyuvm+0xf9>
      kfree(mem);
801083fa:	8b 45 e0             	mov    -0x20(%ebp),%eax
801083fd:	89 04 24             	mov    %eax,(%esp)
80108400:	e8 0e a7 ff ff       	call   80102b13 <kfree>
      goto bad;
80108405:	eb 18                	jmp    8010841f <copyuvm+0x111>
  for(i = 0; i < sz; i += PGSIZE){
80108407:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010840e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108411:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108414:	0f 82 1e ff ff ff    	jb     80108338 <copyuvm+0x2a>
    }
  }
  return d;
8010841a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010841d:	eb 10                	jmp    8010842f <copyuvm+0x121>

bad:
  freevm(d);
8010841f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108422:	89 04 24             	mov    %eax,(%esp)
80108425:	e8 07 fe ff ff       	call   80108231 <freevm>
  return 0;
8010842a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010842f:	c9                   	leave  
80108430:	c3                   	ret    

80108431 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108431:	55                   	push   %ebp
80108432:	89 e5                	mov    %esp,%ebp
80108434:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108437:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010843e:	00 
8010843f:	8b 45 0c             	mov    0xc(%ebp),%eax
80108442:	89 44 24 04          	mov    %eax,0x4(%esp)
80108446:	8b 45 08             	mov    0x8(%ebp),%eax
80108449:	89 04 24             	mov    %eax,(%esp)
8010844c:	e8 fa f6 ff ff       	call   80107b4b <walkpgdir>
80108451:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108454:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108457:	8b 00                	mov    (%eax),%eax
80108459:	83 e0 01             	and    $0x1,%eax
8010845c:	85 c0                	test   %eax,%eax
8010845e:	75 07                	jne    80108467 <uva2ka+0x36>
    return 0;
80108460:	b8 00 00 00 00       	mov    $0x0,%eax
80108465:	eb 22                	jmp    80108489 <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
80108467:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010846a:	8b 00                	mov    (%eax),%eax
8010846c:	83 e0 04             	and    $0x4,%eax
8010846f:	85 c0                	test   %eax,%eax
80108471:	75 07                	jne    8010847a <uva2ka+0x49>
    return 0;
80108473:	b8 00 00 00 00       	mov    $0x0,%eax
80108478:	eb 0f                	jmp    80108489 <uva2ka+0x58>
  return (char*)P2V(PTE_ADDR(*pte));
8010847a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010847d:	8b 00                	mov    (%eax),%eax
8010847f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108484:	05 00 00 00 80       	add    $0x80000000,%eax
}
80108489:	c9                   	leave  
8010848a:	c3                   	ret    

8010848b <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
8010848b:	55                   	push   %ebp
8010848c:	89 e5                	mov    %esp,%ebp
8010848e:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108491:	8b 45 10             	mov    0x10(%ebp),%eax
80108494:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108497:	e9 87 00 00 00       	jmp    80108523 <copyout+0x98>
    va0 = (uint)PGROUNDDOWN(va);
8010849c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010849f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801084a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
801084a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084aa:	89 44 24 04          	mov    %eax,0x4(%esp)
801084ae:	8b 45 08             	mov    0x8(%ebp),%eax
801084b1:	89 04 24             	mov    %eax,(%esp)
801084b4:	e8 78 ff ff ff       	call   80108431 <uva2ka>
801084b9:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
801084bc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801084c0:	75 07                	jne    801084c9 <copyout+0x3e>
      return -1;
801084c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801084c7:	eb 69                	jmp    80108532 <copyout+0xa7>
    n = PGSIZE - (va - va0);
801084c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801084cc:	8b 55 ec             	mov    -0x14(%ebp),%edx
801084cf:	29 c2                	sub    %eax,%edx
801084d1:	89 d0                	mov    %edx,%eax
801084d3:	05 00 10 00 00       	add    $0x1000,%eax
801084d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
801084db:	8b 45 f0             	mov    -0x10(%ebp),%eax
801084de:	3b 45 14             	cmp    0x14(%ebp),%eax
801084e1:	76 06                	jbe    801084e9 <copyout+0x5e>
      n = len;
801084e3:	8b 45 14             	mov    0x14(%ebp),%eax
801084e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
801084e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084ec:	8b 55 0c             	mov    0xc(%ebp),%edx
801084ef:	29 c2                	sub    %eax,%edx
801084f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801084f4:	01 c2                	add    %eax,%edx
801084f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801084f9:	89 44 24 08          	mov    %eax,0x8(%esp)
801084fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108500:	89 44 24 04          	mov    %eax,0x4(%esp)
80108504:	89 14 24             	mov    %edx,(%esp)
80108507:	e8 b0 ce ff ff       	call   801053bc <memmove>
    len -= n;
8010850c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010850f:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108512:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108515:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108518:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010851b:	05 00 10 00 00       	add    $0x1000,%eax
80108520:	89 45 0c             	mov    %eax,0xc(%ebp)
  while(len > 0){
80108523:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108527:	0f 85 6f ff ff ff    	jne    8010849c <copyout+0x11>
  }
  return 0;
8010852d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108532:	c9                   	leave  
80108533:	c3                   	ret    
