
_wc:     file format elf32-i386


Disassembly of section .text:

00000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 48             	sub    $0x48,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
   6:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
   d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10:	89 45 ec             	mov    %eax,-0x14(%ebp)
  13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  16:	89 45 f0             	mov    %eax,-0x10(%ebp)
  inword = 0;
  19:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  20:	eb 68                	jmp    8a <wc+0x8a>
    for(i=0; i<n; i++){
  22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  29:	eb 57                	jmp    82 <wc+0x82>
      c++;
  2b:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
      if(buf[i] == '\n')
  2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  32:	05 00 0e 00 00       	add    $0xe00,%eax
  37:	0f b6 00             	movzbl (%eax),%eax
  3a:	3c 0a                	cmp    $0xa,%al
  3c:	75 04                	jne    42 <wc+0x42>
        l++;
  3e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
      if(strchr(" \r\t\n\v", buf[i]))
  42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  45:	05 00 0e 00 00       	add    $0xe00,%eax
  4a:	0f b6 00             	movzbl (%eax),%eax
  4d:	0f be c0             	movsbl %al,%eax
  50:	89 44 24 04          	mov    %eax,0x4(%esp)
  54:	c7 04 24 ba 0a 00 00 	movl   $0xaba,(%esp)
  5b:	e8 58 02 00 00       	call   2b8 <strchr>
  60:	85 c0                	test   %eax,%eax
  62:	74 09                	je     6d <wc+0x6d>
        inword = 0;
  64:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  6b:	eb 11                	jmp    7e <wc+0x7e>
      else if(!inword){
  6d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  71:	75 0b                	jne    7e <wc+0x7e>
        w++;
  73:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
        inword = 1;
  77:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
    for(i=0; i<n; i++){
  7e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  85:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  88:	7c a1                	jl     2b <wc+0x2b>
  while((n = read(fd, buf, sizeof(buf))) > 0){
  8a:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  91:	00 
  92:	c7 44 24 04 00 0e 00 	movl   $0xe00,0x4(%esp)
  99:	00 
  9a:	8b 45 08             	mov    0x8(%ebp),%eax
  9d:	89 04 24             	mov    %eax,(%esp)
  a0:	e8 d1 04 00 00       	call   576 <read>
  a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  a8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  ac:	0f 8f 70 ff ff ff    	jg     22 <wc+0x22>
      }
    }
  }
  if(n < 0){
  b2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  b6:	79 19                	jns    d1 <wc+0xd1>
    printf(1, "wc: read error\n");
  b8:	c7 44 24 04 c0 0a 00 	movl   $0xac0,0x4(%esp)
  bf:	00 
  c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  c7:	e8 22 06 00 00       	call   6ee <printf>
    exit();
  cc:	e8 8d 04 00 00       	call   55e <exit>
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
  d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  d4:	89 44 24 14          	mov    %eax,0x14(%esp)
  d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  db:	89 44 24 10          	mov    %eax,0x10(%esp)
  df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  e9:	89 44 24 08          	mov    %eax,0x8(%esp)
  ed:	c7 44 24 04 d0 0a 00 	movl   $0xad0,0x4(%esp)
  f4:	00 
  f5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  fc:	e8 ed 05 00 00       	call   6ee <printf>
}
 101:	c9                   	leave  
 102:	c3                   	ret    

00000103 <main>:

int
main(int argc, char *argv[])
{
 103:	55                   	push   %ebp
 104:	89 e5                	mov    %esp,%ebp
 106:	83 e4 f0             	and    $0xfffffff0,%esp
 109:	83 ec 20             	sub    $0x20,%esp
  int fd, i;

  if(argc <= 1){
 10c:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 110:	7f 19                	jg     12b <main+0x28>
    wc(0, "");
 112:	c7 44 24 04 dd 0a 00 	movl   $0xadd,0x4(%esp)
 119:	00 
 11a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 121:	e8 da fe ff ff       	call   0 <wc>
    exit();
 126:	e8 33 04 00 00       	call   55e <exit>
  }

  for(i = 1; i < argc; i++){
 12b:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
 132:	00 
 133:	e9 8f 00 00 00       	jmp    1c7 <main+0xc4>
    if((fd = open(argv[i], 0)) < 0){
 138:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 13c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 143:	8b 45 0c             	mov    0xc(%ebp),%eax
 146:	01 d0                	add    %edx,%eax
 148:	8b 00                	mov    (%eax),%eax
 14a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 151:	00 
 152:	89 04 24             	mov    %eax,(%esp)
 155:	e8 44 04 00 00       	call   59e <open>
 15a:	89 44 24 18          	mov    %eax,0x18(%esp)
 15e:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
 163:	79 2f                	jns    194 <main+0x91>
      printf(1, "wc: cannot open %s\n", argv[i]);
 165:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 169:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 170:	8b 45 0c             	mov    0xc(%ebp),%eax
 173:	01 d0                	add    %edx,%eax
 175:	8b 00                	mov    (%eax),%eax
 177:	89 44 24 08          	mov    %eax,0x8(%esp)
 17b:	c7 44 24 04 de 0a 00 	movl   $0xade,0x4(%esp)
 182:	00 
 183:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 18a:	e8 5f 05 00 00       	call   6ee <printf>
      exit();
 18f:	e8 ca 03 00 00       	call   55e <exit>
    }
    wc(fd, argv[i]);
 194:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 198:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 19f:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a2:	01 d0                	add    %edx,%eax
 1a4:	8b 00                	mov    (%eax),%eax
 1a6:	89 44 24 04          	mov    %eax,0x4(%esp)
 1aa:	8b 44 24 18          	mov    0x18(%esp),%eax
 1ae:	89 04 24             	mov    %eax,(%esp)
 1b1:	e8 4a fe ff ff       	call   0 <wc>
    close(fd);
 1b6:	8b 44 24 18          	mov    0x18(%esp),%eax
 1ba:	89 04 24             	mov    %eax,(%esp)
 1bd:	e8 c4 03 00 00       	call   586 <close>
  for(i = 1; i < argc; i++){
 1c2:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 1c7:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 1cb:	3b 45 08             	cmp    0x8(%ebp),%eax
 1ce:	0f 8c 64 ff ff ff    	jl     138 <main+0x35>
  }
  exit();
 1d4:	e8 85 03 00 00       	call   55e <exit>

000001d9 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1d9:	55                   	push   %ebp
 1da:	89 e5                	mov    %esp,%ebp
 1dc:	57                   	push   %edi
 1dd:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1de:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1e1:	8b 55 10             	mov    0x10(%ebp),%edx
 1e4:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e7:	89 cb                	mov    %ecx,%ebx
 1e9:	89 df                	mov    %ebx,%edi
 1eb:	89 d1                	mov    %edx,%ecx
 1ed:	fc                   	cld    
 1ee:	f3 aa                	rep stos %al,%es:(%edi)
 1f0:	89 ca                	mov    %ecx,%edx
 1f2:	89 fb                	mov    %edi,%ebx
 1f4:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1f7:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1fa:	5b                   	pop    %ebx
 1fb:	5f                   	pop    %edi
 1fc:	5d                   	pop    %ebp
 1fd:	c3                   	ret    

000001fe <strcpy>:
#include "x86.h"
#include "pstat.h"

char*
strcpy(char *s, const char *t)
{
 1fe:	55                   	push   %ebp
 1ff:	89 e5                	mov    %esp,%ebp
 201:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 204:	8b 45 08             	mov    0x8(%ebp),%eax
 207:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 20a:	90                   	nop
 20b:	8b 45 08             	mov    0x8(%ebp),%eax
 20e:	8d 50 01             	lea    0x1(%eax),%edx
 211:	89 55 08             	mov    %edx,0x8(%ebp)
 214:	8b 55 0c             	mov    0xc(%ebp),%edx
 217:	8d 4a 01             	lea    0x1(%edx),%ecx
 21a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 21d:	0f b6 12             	movzbl (%edx),%edx
 220:	88 10                	mov    %dl,(%eax)
 222:	0f b6 00             	movzbl (%eax),%eax
 225:	84 c0                	test   %al,%al
 227:	75 e2                	jne    20b <strcpy+0xd>
    ;
  return os;
 229:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 22c:	c9                   	leave  
 22d:	c3                   	ret    

0000022e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 22e:	55                   	push   %ebp
 22f:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 231:	eb 08                	jmp    23b <strcmp+0xd>
    p++, q++;
 233:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 237:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 23b:	8b 45 08             	mov    0x8(%ebp),%eax
 23e:	0f b6 00             	movzbl (%eax),%eax
 241:	84 c0                	test   %al,%al
 243:	74 10                	je     255 <strcmp+0x27>
 245:	8b 45 08             	mov    0x8(%ebp),%eax
 248:	0f b6 10             	movzbl (%eax),%edx
 24b:	8b 45 0c             	mov    0xc(%ebp),%eax
 24e:	0f b6 00             	movzbl (%eax),%eax
 251:	38 c2                	cmp    %al,%dl
 253:	74 de                	je     233 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 255:	8b 45 08             	mov    0x8(%ebp),%eax
 258:	0f b6 00             	movzbl (%eax),%eax
 25b:	0f b6 d0             	movzbl %al,%edx
 25e:	8b 45 0c             	mov    0xc(%ebp),%eax
 261:	0f b6 00             	movzbl (%eax),%eax
 264:	0f b6 c0             	movzbl %al,%eax
 267:	29 c2                	sub    %eax,%edx
 269:	89 d0                	mov    %edx,%eax
}
 26b:	5d                   	pop    %ebp
 26c:	c3                   	ret    

0000026d <strlen>:

uint
strlen(const char *s)
{
 26d:	55                   	push   %ebp
 26e:	89 e5                	mov    %esp,%ebp
 270:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 273:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 27a:	eb 04                	jmp    280 <strlen+0x13>
 27c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 280:	8b 55 fc             	mov    -0x4(%ebp),%edx
 283:	8b 45 08             	mov    0x8(%ebp),%eax
 286:	01 d0                	add    %edx,%eax
 288:	0f b6 00             	movzbl (%eax),%eax
 28b:	84 c0                	test   %al,%al
 28d:	75 ed                	jne    27c <strlen+0xf>
    ;
  return n;
 28f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 292:	c9                   	leave  
 293:	c3                   	ret    

00000294 <memset>:

void*
memset(void *dst, int c, uint n)
{
 294:	55                   	push   %ebp
 295:	89 e5                	mov    %esp,%ebp
 297:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 29a:	8b 45 10             	mov    0x10(%ebp),%eax
 29d:	89 44 24 08          	mov    %eax,0x8(%esp)
 2a1:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a4:	89 44 24 04          	mov    %eax,0x4(%esp)
 2a8:	8b 45 08             	mov    0x8(%ebp),%eax
 2ab:	89 04 24             	mov    %eax,(%esp)
 2ae:	e8 26 ff ff ff       	call   1d9 <stosb>
  return dst;
 2b3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2b6:	c9                   	leave  
 2b7:	c3                   	ret    

000002b8 <strchr>:

char*
strchr(const char *s, char c)
{
 2b8:	55                   	push   %ebp
 2b9:	89 e5                	mov    %esp,%ebp
 2bb:	83 ec 04             	sub    $0x4,%esp
 2be:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c1:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2c4:	eb 14                	jmp    2da <strchr+0x22>
    if(*s == c)
 2c6:	8b 45 08             	mov    0x8(%ebp),%eax
 2c9:	0f b6 00             	movzbl (%eax),%eax
 2cc:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2cf:	75 05                	jne    2d6 <strchr+0x1e>
      return (char*)s;
 2d1:	8b 45 08             	mov    0x8(%ebp),%eax
 2d4:	eb 13                	jmp    2e9 <strchr+0x31>
  for(; *s; s++)
 2d6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2da:	8b 45 08             	mov    0x8(%ebp),%eax
 2dd:	0f b6 00             	movzbl (%eax),%eax
 2e0:	84 c0                	test   %al,%al
 2e2:	75 e2                	jne    2c6 <strchr+0xe>
  return 0;
 2e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2e9:	c9                   	leave  
 2ea:	c3                   	ret    

000002eb <gets>:

char*
gets(char *buf, int max)
{
 2eb:	55                   	push   %ebp
 2ec:	89 e5                	mov    %esp,%ebp
 2ee:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2f1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2f8:	eb 4c                	jmp    346 <gets+0x5b>
    cc = read(0, &c, 1);
 2fa:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 301:	00 
 302:	8d 45 ef             	lea    -0x11(%ebp),%eax
 305:	89 44 24 04          	mov    %eax,0x4(%esp)
 309:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 310:	e8 61 02 00 00       	call   576 <read>
 315:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 318:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 31c:	7f 02                	jg     320 <gets+0x35>
      break;
 31e:	eb 31                	jmp    351 <gets+0x66>
    buf[i++] = c;
 320:	8b 45 f4             	mov    -0xc(%ebp),%eax
 323:	8d 50 01             	lea    0x1(%eax),%edx
 326:	89 55 f4             	mov    %edx,-0xc(%ebp)
 329:	89 c2                	mov    %eax,%edx
 32b:	8b 45 08             	mov    0x8(%ebp),%eax
 32e:	01 c2                	add    %eax,%edx
 330:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 334:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 336:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 33a:	3c 0a                	cmp    $0xa,%al
 33c:	74 13                	je     351 <gets+0x66>
 33e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 342:	3c 0d                	cmp    $0xd,%al
 344:	74 0b                	je     351 <gets+0x66>
  for(i=0; i+1 < max; ){
 346:	8b 45 f4             	mov    -0xc(%ebp),%eax
 349:	83 c0 01             	add    $0x1,%eax
 34c:	3b 45 0c             	cmp    0xc(%ebp),%eax
 34f:	7c a9                	jl     2fa <gets+0xf>
      break;
  }
  buf[i] = '\0';
 351:	8b 55 f4             	mov    -0xc(%ebp),%edx
 354:	8b 45 08             	mov    0x8(%ebp),%eax
 357:	01 d0                	add    %edx,%eax
 359:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 35c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 35f:	c9                   	leave  
 360:	c3                   	ret    

00000361 <stat>:

int
stat(const char *n, struct stat *st)
{
 361:	55                   	push   %ebp
 362:	89 e5                	mov    %esp,%ebp
 364:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 367:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 36e:	00 
 36f:	8b 45 08             	mov    0x8(%ebp),%eax
 372:	89 04 24             	mov    %eax,(%esp)
 375:	e8 24 02 00 00       	call   59e <open>
 37a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 37d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 381:	79 07                	jns    38a <stat+0x29>
    return -1;
 383:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 388:	eb 23                	jmp    3ad <stat+0x4c>
  r = fstat(fd, st);
 38a:	8b 45 0c             	mov    0xc(%ebp),%eax
 38d:	89 44 24 04          	mov    %eax,0x4(%esp)
 391:	8b 45 f4             	mov    -0xc(%ebp),%eax
 394:	89 04 24             	mov    %eax,(%esp)
 397:	e8 1a 02 00 00       	call   5b6 <fstat>
 39c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 39f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3a2:	89 04 24             	mov    %eax,(%esp)
 3a5:	e8 dc 01 00 00       	call   586 <close>
  return r;
 3aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 3ad:	c9                   	leave  
 3ae:	c3                   	ret    

000003af <atoi>:

int
atoi(const char *s)
{
 3af:	55                   	push   %ebp
 3b0:	89 e5                	mov    %esp,%ebp
 3b2:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 3b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3bc:	eb 25                	jmp    3e3 <atoi+0x34>
    n = n*10 + *s++ - '0';
 3be:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3c1:	89 d0                	mov    %edx,%eax
 3c3:	c1 e0 02             	shl    $0x2,%eax
 3c6:	01 d0                	add    %edx,%eax
 3c8:	01 c0                	add    %eax,%eax
 3ca:	89 c1                	mov    %eax,%ecx
 3cc:	8b 45 08             	mov    0x8(%ebp),%eax
 3cf:	8d 50 01             	lea    0x1(%eax),%edx
 3d2:	89 55 08             	mov    %edx,0x8(%ebp)
 3d5:	0f b6 00             	movzbl (%eax),%eax
 3d8:	0f be c0             	movsbl %al,%eax
 3db:	01 c8                	add    %ecx,%eax
 3dd:	83 e8 30             	sub    $0x30,%eax
 3e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3e3:	8b 45 08             	mov    0x8(%ebp),%eax
 3e6:	0f b6 00             	movzbl (%eax),%eax
 3e9:	3c 2f                	cmp    $0x2f,%al
 3eb:	7e 0a                	jle    3f7 <atoi+0x48>
 3ed:	8b 45 08             	mov    0x8(%ebp),%eax
 3f0:	0f b6 00             	movzbl (%eax),%eax
 3f3:	3c 39                	cmp    $0x39,%al
 3f5:	7e c7                	jle    3be <atoi+0xf>
  return n;
 3f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3fa:	c9                   	leave  
 3fb:	c3                   	ret    

000003fc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3fc:	55                   	push   %ebp
 3fd:	89 e5                	mov    %esp,%ebp
 3ff:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 402:	8b 45 08             	mov    0x8(%ebp),%eax
 405:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 408:	8b 45 0c             	mov    0xc(%ebp),%eax
 40b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 40e:	eb 17                	jmp    427 <memmove+0x2b>
    *dst++ = *src++;
 410:	8b 45 fc             	mov    -0x4(%ebp),%eax
 413:	8d 50 01             	lea    0x1(%eax),%edx
 416:	89 55 fc             	mov    %edx,-0x4(%ebp)
 419:	8b 55 f8             	mov    -0x8(%ebp),%edx
 41c:	8d 4a 01             	lea    0x1(%edx),%ecx
 41f:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 422:	0f b6 12             	movzbl (%edx),%edx
 425:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 427:	8b 45 10             	mov    0x10(%ebp),%eax
 42a:	8d 50 ff             	lea    -0x1(%eax),%edx
 42d:	89 55 10             	mov    %edx,0x10(%ebp)
 430:	85 c0                	test   %eax,%eax
 432:	7f dc                	jg     410 <memmove+0x14>
  return vdst;
 434:	8b 45 08             	mov    0x8(%ebp),%eax
}
 437:	c9                   	leave  
 438:	c3                   	ret    

00000439 <ps>:

void 
ps()
{
 439:	55                   	push   %ebp
 43a:	89 e5                	mov    %esp,%ebp
 43c:	57                   	push   %edi
 43d:	56                   	push   %esi
 43e:	53                   	push   %ebx
 43f:	81 ec 3c 09 00 00    	sub    $0x93c,%esp
  pstatTable pTable;
  getpinfo(&pTable);
 445:	8d 85 e4 f6 ff ff    	lea    -0x91c(%ebp),%eax
 44b:	89 04 24             	mov    %eax,(%esp)
 44e:	e8 ab 01 00 00       	call   5fe <getpinfo>
  printf(1, "PID\tTKTS\tTCKS\tSTAT\tNAME\n");
 453:	c7 44 24 04 f2 0a 00 	movl   $0xaf2,0x4(%esp)
 45a:	00 
 45b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 462:	e8 87 02 00 00       	call   6ee <printf>
  int i;
  for (i = 0; i < NPROC; i++)
 467:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 46e:	e9 ce 00 00 00       	jmp    541 <ps+0x108>
  {
    if(pTable[i].inuse)
 473:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 476:	89 d0                	mov    %edx,%eax
 478:	c1 e0 03             	shl    $0x3,%eax
 47b:	01 d0                	add    %edx,%eax
 47d:	c1 e0 02             	shl    $0x2,%eax
 480:	8d 5d e8             	lea    -0x18(%ebp),%ebx
 483:	01 d8                	add    %ebx,%eax
 485:	2d 04 09 00 00       	sub    $0x904,%eax
 48a:	8b 00                	mov    (%eax),%eax
 48c:	85 c0                	test   %eax,%eax
 48e:	0f 84 a9 00 00 00    	je     53d <ps+0x104>
      printf(1, "%d\t%d\t%d\t%c\t%s\n", pTable[i].pid, pTable[i].tickets, pTable[i].ticks, pTable[i].state, pTable[i].name);
 494:	8d 8d e4 f6 ff ff    	lea    -0x91c(%ebp),%ecx
 49a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 49d:	89 d0                	mov    %edx,%eax
 49f:	c1 e0 03             	shl    $0x3,%eax
 4a2:	01 d0                	add    %edx,%eax
 4a4:	c1 e0 02             	shl    $0x2,%eax
 4a7:	83 c0 10             	add    $0x10,%eax
 4aa:	8d 3c 01             	lea    (%ecx,%eax,1),%edi
 4ad:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 4b0:	89 d0                	mov    %edx,%eax
 4b2:	c1 e0 03             	shl    $0x3,%eax
 4b5:	01 d0                	add    %edx,%eax
 4b7:	c1 e0 02             	shl    $0x2,%eax
 4ba:	8d 75 e8             	lea    -0x18(%ebp),%esi
 4bd:	01 f0                	add    %esi,%eax
 4bf:	2d e4 08 00 00       	sub    $0x8e4,%eax
 4c4:	0f b6 00             	movzbl (%eax),%eax
 4c7:	0f be f0             	movsbl %al,%esi
 4ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 4cd:	89 d0                	mov    %edx,%eax
 4cf:	c1 e0 03             	shl    $0x3,%eax
 4d2:	01 d0                	add    %edx,%eax
 4d4:	c1 e0 02             	shl    $0x2,%eax
 4d7:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 4da:	01 c8                	add    %ecx,%eax
 4dc:	2d f8 08 00 00       	sub    $0x8f8,%eax
 4e1:	8b 18                	mov    (%eax),%ebx
 4e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 4e6:	89 d0                	mov    %edx,%eax
 4e8:	c1 e0 03             	shl    $0x3,%eax
 4eb:	01 d0                	add    %edx,%eax
 4ed:	c1 e0 02             	shl    $0x2,%eax
 4f0:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 4f3:	01 c8                	add    %ecx,%eax
 4f5:	2d 00 09 00 00       	sub    $0x900,%eax
 4fa:	8b 08                	mov    (%eax),%ecx
 4fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 4ff:	89 d0                	mov    %edx,%eax
 501:	c1 e0 03             	shl    $0x3,%eax
 504:	01 d0                	add    %edx,%eax
 506:	c1 e0 02             	shl    $0x2,%eax
 509:	8d 55 e8             	lea    -0x18(%ebp),%edx
 50c:	01 d0                	add    %edx,%eax
 50e:	2d fc 08 00 00       	sub    $0x8fc,%eax
 513:	8b 00                	mov    (%eax),%eax
 515:	89 7c 24 18          	mov    %edi,0x18(%esp)
 519:	89 74 24 14          	mov    %esi,0x14(%esp)
 51d:	89 5c 24 10          	mov    %ebx,0x10(%esp)
 521:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 525:	89 44 24 08          	mov    %eax,0x8(%esp)
 529:	c7 44 24 04 0b 0b 00 	movl   $0xb0b,0x4(%esp)
 530:	00 
 531:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 538:	e8 b1 01 00 00       	call   6ee <printf>
  for (i = 0; i < NPROC; i++)
 53d:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 541:	83 7d e4 3f          	cmpl   $0x3f,-0x1c(%ebp)
 545:	0f 8e 28 ff ff ff    	jle    473 <ps+0x3a>
  }
}
 54b:	81 c4 3c 09 00 00    	add    $0x93c,%esp
 551:	5b                   	pop    %ebx
 552:	5e                   	pop    %esi
 553:	5f                   	pop    %edi
 554:	5d                   	pop    %ebp
 555:	c3                   	ret    

00000556 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 556:	b8 01 00 00 00       	mov    $0x1,%eax
 55b:	cd 40                	int    $0x40
 55d:	c3                   	ret    

0000055e <exit>:
SYSCALL(exit)
 55e:	b8 02 00 00 00       	mov    $0x2,%eax
 563:	cd 40                	int    $0x40
 565:	c3                   	ret    

00000566 <wait>:
SYSCALL(wait)
 566:	b8 03 00 00 00       	mov    $0x3,%eax
 56b:	cd 40                	int    $0x40
 56d:	c3                   	ret    

0000056e <pipe>:
SYSCALL(pipe)
 56e:	b8 04 00 00 00       	mov    $0x4,%eax
 573:	cd 40                	int    $0x40
 575:	c3                   	ret    

00000576 <read>:
SYSCALL(read)
 576:	b8 05 00 00 00       	mov    $0x5,%eax
 57b:	cd 40                	int    $0x40
 57d:	c3                   	ret    

0000057e <write>:
SYSCALL(write)
 57e:	b8 10 00 00 00       	mov    $0x10,%eax
 583:	cd 40                	int    $0x40
 585:	c3                   	ret    

00000586 <close>:
SYSCALL(close)
 586:	b8 15 00 00 00       	mov    $0x15,%eax
 58b:	cd 40                	int    $0x40
 58d:	c3                   	ret    

0000058e <kill>:
SYSCALL(kill)
 58e:	b8 06 00 00 00       	mov    $0x6,%eax
 593:	cd 40                	int    $0x40
 595:	c3                   	ret    

00000596 <exec>:
SYSCALL(exec)
 596:	b8 07 00 00 00       	mov    $0x7,%eax
 59b:	cd 40                	int    $0x40
 59d:	c3                   	ret    

0000059e <open>:
SYSCALL(open)
 59e:	b8 0f 00 00 00       	mov    $0xf,%eax
 5a3:	cd 40                	int    $0x40
 5a5:	c3                   	ret    

000005a6 <mknod>:
SYSCALL(mknod)
 5a6:	b8 11 00 00 00       	mov    $0x11,%eax
 5ab:	cd 40                	int    $0x40
 5ad:	c3                   	ret    

000005ae <unlink>:
SYSCALL(unlink)
 5ae:	b8 12 00 00 00       	mov    $0x12,%eax
 5b3:	cd 40                	int    $0x40
 5b5:	c3                   	ret    

000005b6 <fstat>:
SYSCALL(fstat)
 5b6:	b8 08 00 00 00       	mov    $0x8,%eax
 5bb:	cd 40                	int    $0x40
 5bd:	c3                   	ret    

000005be <link>:
SYSCALL(link)
 5be:	b8 13 00 00 00       	mov    $0x13,%eax
 5c3:	cd 40                	int    $0x40
 5c5:	c3                   	ret    

000005c6 <mkdir>:
SYSCALL(mkdir)
 5c6:	b8 14 00 00 00       	mov    $0x14,%eax
 5cb:	cd 40                	int    $0x40
 5cd:	c3                   	ret    

000005ce <chdir>:
SYSCALL(chdir)
 5ce:	b8 09 00 00 00       	mov    $0x9,%eax
 5d3:	cd 40                	int    $0x40
 5d5:	c3                   	ret    

000005d6 <dup>:
SYSCALL(dup)
 5d6:	b8 0a 00 00 00       	mov    $0xa,%eax
 5db:	cd 40                	int    $0x40
 5dd:	c3                   	ret    

000005de <getpid>:
SYSCALL(getpid)
 5de:	b8 0b 00 00 00       	mov    $0xb,%eax
 5e3:	cd 40                	int    $0x40
 5e5:	c3                   	ret    

000005e6 <sbrk>:
SYSCALL(sbrk)
 5e6:	b8 0c 00 00 00       	mov    $0xc,%eax
 5eb:	cd 40                	int    $0x40
 5ed:	c3                   	ret    

000005ee <sleep>:
SYSCALL(sleep)
 5ee:	b8 0d 00 00 00       	mov    $0xd,%eax
 5f3:	cd 40                	int    $0x40
 5f5:	c3                   	ret    

000005f6 <uptime>:
SYSCALL(uptime)
 5f6:	b8 0e 00 00 00       	mov    $0xe,%eax
 5fb:	cd 40                	int    $0x40
 5fd:	c3                   	ret    

000005fe <getpinfo>:
SYSCALL(getpinfo)
 5fe:	b8 16 00 00 00       	mov    $0x16,%eax
 603:	cd 40                	int    $0x40
 605:	c3                   	ret    

00000606 <settickets>:
SYSCALL(settickets)
 606:	b8 18 00 00 00       	mov    $0x18,%eax
 60b:	cd 40                	int    $0x40
 60d:	c3                   	ret    

0000060e <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 60e:	55                   	push   %ebp
 60f:	89 e5                	mov    %esp,%ebp
 611:	83 ec 18             	sub    $0x18,%esp
 614:	8b 45 0c             	mov    0xc(%ebp),%eax
 617:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 61a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 621:	00 
 622:	8d 45 f4             	lea    -0xc(%ebp),%eax
 625:	89 44 24 04          	mov    %eax,0x4(%esp)
 629:	8b 45 08             	mov    0x8(%ebp),%eax
 62c:	89 04 24             	mov    %eax,(%esp)
 62f:	e8 4a ff ff ff       	call   57e <write>
}
 634:	c9                   	leave  
 635:	c3                   	ret    

00000636 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 636:	55                   	push   %ebp
 637:	89 e5                	mov    %esp,%ebp
 639:	56                   	push   %esi
 63a:	53                   	push   %ebx
 63b:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 63e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 645:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 649:	74 17                	je     662 <printint+0x2c>
 64b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 64f:	79 11                	jns    662 <printint+0x2c>
    neg = 1;
 651:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 658:	8b 45 0c             	mov    0xc(%ebp),%eax
 65b:	f7 d8                	neg    %eax
 65d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 660:	eb 06                	jmp    668 <printint+0x32>
  } else {
    x = xx;
 662:	8b 45 0c             	mov    0xc(%ebp),%eax
 665:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 668:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 66f:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 672:	8d 41 01             	lea    0x1(%ecx),%eax
 675:	89 45 f4             	mov    %eax,-0xc(%ebp)
 678:	8b 5d 10             	mov    0x10(%ebp),%ebx
 67b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 67e:	ba 00 00 00 00       	mov    $0x0,%edx
 683:	f7 f3                	div    %ebx
 685:	89 d0                	mov    %edx,%eax
 687:	0f b6 80 b8 0d 00 00 	movzbl 0xdb8(%eax),%eax
 68e:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 692:	8b 75 10             	mov    0x10(%ebp),%esi
 695:	8b 45 ec             	mov    -0x14(%ebp),%eax
 698:	ba 00 00 00 00       	mov    $0x0,%edx
 69d:	f7 f6                	div    %esi
 69f:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6a2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6a6:	75 c7                	jne    66f <printint+0x39>
  if(neg)
 6a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6ac:	74 10                	je     6be <printint+0x88>
    buf[i++] = '-';
 6ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6b1:	8d 50 01             	lea    0x1(%eax),%edx
 6b4:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6b7:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 6bc:	eb 1f                	jmp    6dd <printint+0xa7>
 6be:	eb 1d                	jmp    6dd <printint+0xa7>
    putc(fd, buf[i]);
 6c0:	8d 55 dc             	lea    -0x24(%ebp),%edx
 6c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6c6:	01 d0                	add    %edx,%eax
 6c8:	0f b6 00             	movzbl (%eax),%eax
 6cb:	0f be c0             	movsbl %al,%eax
 6ce:	89 44 24 04          	mov    %eax,0x4(%esp)
 6d2:	8b 45 08             	mov    0x8(%ebp),%eax
 6d5:	89 04 24             	mov    %eax,(%esp)
 6d8:	e8 31 ff ff ff       	call   60e <putc>
  while(--i >= 0)
 6dd:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 6e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6e5:	79 d9                	jns    6c0 <printint+0x8a>
}
 6e7:	83 c4 30             	add    $0x30,%esp
 6ea:	5b                   	pop    %ebx
 6eb:	5e                   	pop    %esi
 6ec:	5d                   	pop    %ebp
 6ed:	c3                   	ret    

000006ee <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 6ee:	55                   	push   %ebp
 6ef:	89 e5                	mov    %esp,%ebp
 6f1:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 6f4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 6fb:	8d 45 0c             	lea    0xc(%ebp),%eax
 6fe:	83 c0 04             	add    $0x4,%eax
 701:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 704:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 70b:	e9 7c 01 00 00       	jmp    88c <printf+0x19e>
    c = fmt[i] & 0xff;
 710:	8b 55 0c             	mov    0xc(%ebp),%edx
 713:	8b 45 f0             	mov    -0x10(%ebp),%eax
 716:	01 d0                	add    %edx,%eax
 718:	0f b6 00             	movzbl (%eax),%eax
 71b:	0f be c0             	movsbl %al,%eax
 71e:	25 ff 00 00 00       	and    $0xff,%eax
 723:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 726:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 72a:	75 2c                	jne    758 <printf+0x6a>
      if(c == '%'){
 72c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 730:	75 0c                	jne    73e <printf+0x50>
        state = '%';
 732:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 739:	e9 4a 01 00 00       	jmp    888 <printf+0x19a>
      } else {
        putc(fd, c);
 73e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 741:	0f be c0             	movsbl %al,%eax
 744:	89 44 24 04          	mov    %eax,0x4(%esp)
 748:	8b 45 08             	mov    0x8(%ebp),%eax
 74b:	89 04 24             	mov    %eax,(%esp)
 74e:	e8 bb fe ff ff       	call   60e <putc>
 753:	e9 30 01 00 00       	jmp    888 <printf+0x19a>
      }
    } else if(state == '%'){
 758:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 75c:	0f 85 26 01 00 00    	jne    888 <printf+0x19a>
      if(c == 'd'){
 762:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 766:	75 2d                	jne    795 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 768:	8b 45 e8             	mov    -0x18(%ebp),%eax
 76b:	8b 00                	mov    (%eax),%eax
 76d:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 774:	00 
 775:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 77c:	00 
 77d:	89 44 24 04          	mov    %eax,0x4(%esp)
 781:	8b 45 08             	mov    0x8(%ebp),%eax
 784:	89 04 24             	mov    %eax,(%esp)
 787:	e8 aa fe ff ff       	call   636 <printint>
        ap++;
 78c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 790:	e9 ec 00 00 00       	jmp    881 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 795:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 799:	74 06                	je     7a1 <printf+0xb3>
 79b:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 79f:	75 2d                	jne    7ce <printf+0xe0>
        printint(fd, *ap, 16, 0);
 7a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7a4:	8b 00                	mov    (%eax),%eax
 7a6:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 7ad:	00 
 7ae:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 7b5:	00 
 7b6:	89 44 24 04          	mov    %eax,0x4(%esp)
 7ba:	8b 45 08             	mov    0x8(%ebp),%eax
 7bd:	89 04 24             	mov    %eax,(%esp)
 7c0:	e8 71 fe ff ff       	call   636 <printint>
        ap++;
 7c5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7c9:	e9 b3 00 00 00       	jmp    881 <printf+0x193>
      } else if(c == 's'){
 7ce:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 7d2:	75 45                	jne    819 <printf+0x12b>
        s = (char*)*ap;
 7d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7d7:	8b 00                	mov    (%eax),%eax
 7d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 7dc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 7e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7e4:	75 09                	jne    7ef <printf+0x101>
          s = "(null)";
 7e6:	c7 45 f4 1b 0b 00 00 	movl   $0xb1b,-0xc(%ebp)
        while(*s != 0){
 7ed:	eb 1e                	jmp    80d <printf+0x11f>
 7ef:	eb 1c                	jmp    80d <printf+0x11f>
          putc(fd, *s);
 7f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f4:	0f b6 00             	movzbl (%eax),%eax
 7f7:	0f be c0             	movsbl %al,%eax
 7fa:	89 44 24 04          	mov    %eax,0x4(%esp)
 7fe:	8b 45 08             	mov    0x8(%ebp),%eax
 801:	89 04 24             	mov    %eax,(%esp)
 804:	e8 05 fe ff ff       	call   60e <putc>
          s++;
 809:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 80d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 810:	0f b6 00             	movzbl (%eax),%eax
 813:	84 c0                	test   %al,%al
 815:	75 da                	jne    7f1 <printf+0x103>
 817:	eb 68                	jmp    881 <printf+0x193>
        }
      } else if(c == 'c'){
 819:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 81d:	75 1d                	jne    83c <printf+0x14e>
        putc(fd, *ap);
 81f:	8b 45 e8             	mov    -0x18(%ebp),%eax
 822:	8b 00                	mov    (%eax),%eax
 824:	0f be c0             	movsbl %al,%eax
 827:	89 44 24 04          	mov    %eax,0x4(%esp)
 82b:	8b 45 08             	mov    0x8(%ebp),%eax
 82e:	89 04 24             	mov    %eax,(%esp)
 831:	e8 d8 fd ff ff       	call   60e <putc>
        ap++;
 836:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 83a:	eb 45                	jmp    881 <printf+0x193>
      } else if(c == '%'){
 83c:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 840:	75 17                	jne    859 <printf+0x16b>
        putc(fd, c);
 842:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 845:	0f be c0             	movsbl %al,%eax
 848:	89 44 24 04          	mov    %eax,0x4(%esp)
 84c:	8b 45 08             	mov    0x8(%ebp),%eax
 84f:	89 04 24             	mov    %eax,(%esp)
 852:	e8 b7 fd ff ff       	call   60e <putc>
 857:	eb 28                	jmp    881 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 859:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 860:	00 
 861:	8b 45 08             	mov    0x8(%ebp),%eax
 864:	89 04 24             	mov    %eax,(%esp)
 867:	e8 a2 fd ff ff       	call   60e <putc>
        putc(fd, c);
 86c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 86f:	0f be c0             	movsbl %al,%eax
 872:	89 44 24 04          	mov    %eax,0x4(%esp)
 876:	8b 45 08             	mov    0x8(%ebp),%eax
 879:	89 04 24             	mov    %eax,(%esp)
 87c:	e8 8d fd ff ff       	call   60e <putc>
      }
      state = 0;
 881:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 888:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 88c:	8b 55 0c             	mov    0xc(%ebp),%edx
 88f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 892:	01 d0                	add    %edx,%eax
 894:	0f b6 00             	movzbl (%eax),%eax
 897:	84 c0                	test   %al,%al
 899:	0f 85 71 fe ff ff    	jne    710 <printf+0x22>
    }
  }
}
 89f:	c9                   	leave  
 8a0:	c3                   	ret    

000008a1 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8a1:	55                   	push   %ebp
 8a2:	89 e5                	mov    %esp,%ebp
 8a4:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8a7:	8b 45 08             	mov    0x8(%ebp),%eax
 8aa:	83 e8 08             	sub    $0x8,%eax
 8ad:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8b0:	a1 e8 0d 00 00       	mov    0xde8,%eax
 8b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8b8:	eb 24                	jmp    8de <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8bd:	8b 00                	mov    (%eax),%eax
 8bf:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8c2:	77 12                	ja     8d6 <free+0x35>
 8c4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8c7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8ca:	77 24                	ja     8f0 <free+0x4f>
 8cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8cf:	8b 00                	mov    (%eax),%eax
 8d1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8d4:	77 1a                	ja     8f0 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d9:	8b 00                	mov    (%eax),%eax
 8db:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8de:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8e1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8e4:	76 d4                	jbe    8ba <free+0x19>
 8e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e9:	8b 00                	mov    (%eax),%eax
 8eb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8ee:	76 ca                	jbe    8ba <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 8f0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8f3:	8b 40 04             	mov    0x4(%eax),%eax
 8f6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 900:	01 c2                	add    %eax,%edx
 902:	8b 45 fc             	mov    -0x4(%ebp),%eax
 905:	8b 00                	mov    (%eax),%eax
 907:	39 c2                	cmp    %eax,%edx
 909:	75 24                	jne    92f <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 90b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 90e:	8b 50 04             	mov    0x4(%eax),%edx
 911:	8b 45 fc             	mov    -0x4(%ebp),%eax
 914:	8b 00                	mov    (%eax),%eax
 916:	8b 40 04             	mov    0x4(%eax),%eax
 919:	01 c2                	add    %eax,%edx
 91b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 91e:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 921:	8b 45 fc             	mov    -0x4(%ebp),%eax
 924:	8b 00                	mov    (%eax),%eax
 926:	8b 10                	mov    (%eax),%edx
 928:	8b 45 f8             	mov    -0x8(%ebp),%eax
 92b:	89 10                	mov    %edx,(%eax)
 92d:	eb 0a                	jmp    939 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 92f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 932:	8b 10                	mov    (%eax),%edx
 934:	8b 45 f8             	mov    -0x8(%ebp),%eax
 937:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 939:	8b 45 fc             	mov    -0x4(%ebp),%eax
 93c:	8b 40 04             	mov    0x4(%eax),%eax
 93f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 946:	8b 45 fc             	mov    -0x4(%ebp),%eax
 949:	01 d0                	add    %edx,%eax
 94b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 94e:	75 20                	jne    970 <free+0xcf>
    p->s.size += bp->s.size;
 950:	8b 45 fc             	mov    -0x4(%ebp),%eax
 953:	8b 50 04             	mov    0x4(%eax),%edx
 956:	8b 45 f8             	mov    -0x8(%ebp),%eax
 959:	8b 40 04             	mov    0x4(%eax),%eax
 95c:	01 c2                	add    %eax,%edx
 95e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 961:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 964:	8b 45 f8             	mov    -0x8(%ebp),%eax
 967:	8b 10                	mov    (%eax),%edx
 969:	8b 45 fc             	mov    -0x4(%ebp),%eax
 96c:	89 10                	mov    %edx,(%eax)
 96e:	eb 08                	jmp    978 <free+0xd7>
  } else
    p->s.ptr = bp;
 970:	8b 45 fc             	mov    -0x4(%ebp),%eax
 973:	8b 55 f8             	mov    -0x8(%ebp),%edx
 976:	89 10                	mov    %edx,(%eax)
  freep = p;
 978:	8b 45 fc             	mov    -0x4(%ebp),%eax
 97b:	a3 e8 0d 00 00       	mov    %eax,0xde8
}
 980:	c9                   	leave  
 981:	c3                   	ret    

00000982 <morecore>:

static Header*
morecore(uint nu)
{
 982:	55                   	push   %ebp
 983:	89 e5                	mov    %esp,%ebp
 985:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 988:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 98f:	77 07                	ja     998 <morecore+0x16>
    nu = 4096;
 991:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 998:	8b 45 08             	mov    0x8(%ebp),%eax
 99b:	c1 e0 03             	shl    $0x3,%eax
 99e:	89 04 24             	mov    %eax,(%esp)
 9a1:	e8 40 fc ff ff       	call   5e6 <sbrk>
 9a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 9a9:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 9ad:	75 07                	jne    9b6 <morecore+0x34>
    return 0;
 9af:	b8 00 00 00 00       	mov    $0x0,%eax
 9b4:	eb 22                	jmp    9d8 <morecore+0x56>
  hp = (Header*)p;
 9b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 9bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9bf:	8b 55 08             	mov    0x8(%ebp),%edx
 9c2:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 9c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9c8:	83 c0 08             	add    $0x8,%eax
 9cb:	89 04 24             	mov    %eax,(%esp)
 9ce:	e8 ce fe ff ff       	call   8a1 <free>
  return freep;
 9d3:	a1 e8 0d 00 00       	mov    0xde8,%eax
}
 9d8:	c9                   	leave  
 9d9:	c3                   	ret    

000009da <malloc>:

void*
malloc(uint nbytes)
{
 9da:	55                   	push   %ebp
 9db:	89 e5                	mov    %esp,%ebp
 9dd:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9e0:	8b 45 08             	mov    0x8(%ebp),%eax
 9e3:	83 c0 07             	add    $0x7,%eax
 9e6:	c1 e8 03             	shr    $0x3,%eax
 9e9:	83 c0 01             	add    $0x1,%eax
 9ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 9ef:	a1 e8 0d 00 00       	mov    0xde8,%eax
 9f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9fb:	75 23                	jne    a20 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 9fd:	c7 45 f0 e0 0d 00 00 	movl   $0xde0,-0x10(%ebp)
 a04:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a07:	a3 e8 0d 00 00       	mov    %eax,0xde8
 a0c:	a1 e8 0d 00 00       	mov    0xde8,%eax
 a11:	a3 e0 0d 00 00       	mov    %eax,0xde0
    base.s.size = 0;
 a16:	c7 05 e4 0d 00 00 00 	movl   $0x0,0xde4
 a1d:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a20:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a23:	8b 00                	mov    (%eax),%eax
 a25:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a2b:	8b 40 04             	mov    0x4(%eax),%eax
 a2e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a31:	72 4d                	jb     a80 <malloc+0xa6>
      if(p->s.size == nunits)
 a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a36:	8b 40 04             	mov    0x4(%eax),%eax
 a39:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a3c:	75 0c                	jne    a4a <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a41:	8b 10                	mov    (%eax),%edx
 a43:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a46:	89 10                	mov    %edx,(%eax)
 a48:	eb 26                	jmp    a70 <malloc+0x96>
      else {
        p->s.size -= nunits;
 a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a4d:	8b 40 04             	mov    0x4(%eax),%eax
 a50:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a53:	89 c2                	mov    %eax,%edx
 a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a58:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a5e:	8b 40 04             	mov    0x4(%eax),%eax
 a61:	c1 e0 03             	shl    $0x3,%eax
 a64:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a6a:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a6d:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a70:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a73:	a3 e8 0d 00 00       	mov    %eax,0xde8
      return (void*)(p + 1);
 a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a7b:	83 c0 08             	add    $0x8,%eax
 a7e:	eb 38                	jmp    ab8 <malloc+0xde>
    }
    if(p == freep)
 a80:	a1 e8 0d 00 00       	mov    0xde8,%eax
 a85:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a88:	75 1b                	jne    aa5 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 a8a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a8d:	89 04 24             	mov    %eax,(%esp)
 a90:	e8 ed fe ff ff       	call   982 <morecore>
 a95:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a98:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a9c:	75 07                	jne    aa5 <malloc+0xcb>
        return 0;
 a9e:	b8 00 00 00 00       	mov    $0x0,%eax
 aa3:	eb 13                	jmp    ab8 <malloc+0xde>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa8:	89 45 f0             	mov    %eax,-0x10(%ebp)
 aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aae:	8b 00                	mov    (%eax),%eax
 ab0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 ab3:	e9 70 ff ff ff       	jmp    a28 <malloc+0x4e>
}
 ab8:	c9                   	leave  
 ab9:	c3                   	ret    
