
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   9:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  10:	00 
  11:	c7 04 24 f3 09 00 00 	movl   $0x9f3,(%esp)
  18:	e8 b7 04 00 00       	call   4d4 <open>
  1d:	85 c0                	test   %eax,%eax
  1f:	79 30                	jns    51 <main+0x51>
    mknod("console", 1, 1);
  21:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  28:	00 
  29:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  30:	00 
  31:	c7 04 24 f3 09 00 00 	movl   $0x9f3,(%esp)
  38:	e8 9f 04 00 00       	call   4dc <mknod>
    open("console", O_RDWR);
  3d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  44:	00 
  45:	c7 04 24 f3 09 00 00 	movl   $0x9f3,(%esp)
  4c:	e8 83 04 00 00       	call   4d4 <open>
  }
  dup(0);  // stdout
  51:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  58:	e8 af 04 00 00       	call   50c <dup>
  dup(0);  // stderr
  5d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  64:	e8 a3 04 00 00       	call   50c <dup>

  for(;;){
    printf(1, "init: starting sh\n");
  69:	c7 44 24 04 fb 09 00 	movl   $0x9fb,0x4(%esp)
  70:	00 
  71:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  78:	e8 a7 05 00 00       	call   624 <printf>
    pid = fork();
  7d:	e8 0a 04 00 00       	call   48c <fork>
  82:	89 44 24 1c          	mov    %eax,0x1c(%esp)
    if(pid < 0){
  86:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  8b:	79 19                	jns    a6 <main+0xa6>
      printf(1, "init: fork failed\n");
  8d:	c7 44 24 04 0e 0a 00 	movl   $0xa0e,0x4(%esp)
  94:	00 
  95:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  9c:	e8 83 05 00 00       	call   624 <printf>
      exit();
  a1:	e8 ee 03 00 00       	call   494 <exit>
    }
    if(pid == 0){
  a6:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  ab:	75 2d                	jne    da <main+0xda>
      exec("sh", argv);
  ad:	c7 44 24 04 e4 0c 00 	movl   $0xce4,0x4(%esp)
  b4:	00 
  b5:	c7 04 24 f0 09 00 00 	movl   $0x9f0,(%esp)
  bc:	e8 0b 04 00 00       	call   4cc <exec>
      printf(1, "init: exec sh failed\n");
  c1:	c7 44 24 04 21 0a 00 	movl   $0xa21,0x4(%esp)
  c8:	00 
  c9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  d0:	e8 4f 05 00 00       	call   624 <printf>
      exit();
  d5:	e8 ba 03 00 00       	call   494 <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  da:	eb 14                	jmp    f0 <main+0xf0>
      printf(1, "zombie!\n");
  dc:	c7 44 24 04 37 0a 00 	movl   $0xa37,0x4(%esp)
  e3:	00 
  e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  eb:	e8 34 05 00 00       	call   624 <printf>
    while((wpid=wait()) >= 0 && wpid != pid)
  f0:	e8 a7 03 00 00       	call   49c <wait>
  f5:	89 44 24 18          	mov    %eax,0x18(%esp)
  f9:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  fe:	78 0a                	js     10a <main+0x10a>
 100:	8b 44 24 18          	mov    0x18(%esp),%eax
 104:	3b 44 24 1c          	cmp    0x1c(%esp),%eax
 108:	75 d2                	jne    dc <main+0xdc>
  }
 10a:	e9 5a ff ff ff       	jmp    69 <main+0x69>

0000010f <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 10f:	55                   	push   %ebp
 110:	89 e5                	mov    %esp,%ebp
 112:	57                   	push   %edi
 113:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 114:	8b 4d 08             	mov    0x8(%ebp),%ecx
 117:	8b 55 10             	mov    0x10(%ebp),%edx
 11a:	8b 45 0c             	mov    0xc(%ebp),%eax
 11d:	89 cb                	mov    %ecx,%ebx
 11f:	89 df                	mov    %ebx,%edi
 121:	89 d1                	mov    %edx,%ecx
 123:	fc                   	cld    
 124:	f3 aa                	rep stos %al,%es:(%edi)
 126:	89 ca                	mov    %ecx,%edx
 128:	89 fb                	mov    %edi,%ebx
 12a:	89 5d 08             	mov    %ebx,0x8(%ebp)
 12d:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 130:	5b                   	pop    %ebx
 131:	5f                   	pop    %edi
 132:	5d                   	pop    %ebp
 133:	c3                   	ret    

00000134 <strcpy>:
#include "x86.h"
#include "pstat.h"

char*
strcpy(char *s, const char *t)
{
 134:	55                   	push   %ebp
 135:	89 e5                	mov    %esp,%ebp
 137:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 13a:	8b 45 08             	mov    0x8(%ebp),%eax
 13d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 140:	90                   	nop
 141:	8b 45 08             	mov    0x8(%ebp),%eax
 144:	8d 50 01             	lea    0x1(%eax),%edx
 147:	89 55 08             	mov    %edx,0x8(%ebp)
 14a:	8b 55 0c             	mov    0xc(%ebp),%edx
 14d:	8d 4a 01             	lea    0x1(%edx),%ecx
 150:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 153:	0f b6 12             	movzbl (%edx),%edx
 156:	88 10                	mov    %dl,(%eax)
 158:	0f b6 00             	movzbl (%eax),%eax
 15b:	84 c0                	test   %al,%al
 15d:	75 e2                	jne    141 <strcpy+0xd>
    ;
  return os;
 15f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 162:	c9                   	leave  
 163:	c3                   	ret    

00000164 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 164:	55                   	push   %ebp
 165:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 167:	eb 08                	jmp    171 <strcmp+0xd>
    p++, q++;
 169:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 171:	8b 45 08             	mov    0x8(%ebp),%eax
 174:	0f b6 00             	movzbl (%eax),%eax
 177:	84 c0                	test   %al,%al
 179:	74 10                	je     18b <strcmp+0x27>
 17b:	8b 45 08             	mov    0x8(%ebp),%eax
 17e:	0f b6 10             	movzbl (%eax),%edx
 181:	8b 45 0c             	mov    0xc(%ebp),%eax
 184:	0f b6 00             	movzbl (%eax),%eax
 187:	38 c2                	cmp    %al,%dl
 189:	74 de                	je     169 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 18b:	8b 45 08             	mov    0x8(%ebp),%eax
 18e:	0f b6 00             	movzbl (%eax),%eax
 191:	0f b6 d0             	movzbl %al,%edx
 194:	8b 45 0c             	mov    0xc(%ebp),%eax
 197:	0f b6 00             	movzbl (%eax),%eax
 19a:	0f b6 c0             	movzbl %al,%eax
 19d:	29 c2                	sub    %eax,%edx
 19f:	89 d0                	mov    %edx,%eax
}
 1a1:	5d                   	pop    %ebp
 1a2:	c3                   	ret    

000001a3 <strlen>:

uint
strlen(const char *s)
{
 1a3:	55                   	push   %ebp
 1a4:	89 e5                	mov    %esp,%ebp
 1a6:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1b0:	eb 04                	jmp    1b6 <strlen+0x13>
 1b2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1b9:	8b 45 08             	mov    0x8(%ebp),%eax
 1bc:	01 d0                	add    %edx,%eax
 1be:	0f b6 00             	movzbl (%eax),%eax
 1c1:	84 c0                	test   %al,%al
 1c3:	75 ed                	jne    1b2 <strlen+0xf>
    ;
  return n;
 1c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1c8:	c9                   	leave  
 1c9:	c3                   	ret    

000001ca <memset>:

void*
memset(void *dst, int c, uint n)
{
 1ca:	55                   	push   %ebp
 1cb:	89 e5                	mov    %esp,%ebp
 1cd:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1d0:	8b 45 10             	mov    0x10(%ebp),%eax
 1d3:	89 44 24 08          	mov    %eax,0x8(%esp)
 1d7:	8b 45 0c             	mov    0xc(%ebp),%eax
 1da:	89 44 24 04          	mov    %eax,0x4(%esp)
 1de:	8b 45 08             	mov    0x8(%ebp),%eax
 1e1:	89 04 24             	mov    %eax,(%esp)
 1e4:	e8 26 ff ff ff       	call   10f <stosb>
  return dst;
 1e9:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ec:	c9                   	leave  
 1ed:	c3                   	ret    

000001ee <strchr>:

char*
strchr(const char *s, char c)
{
 1ee:	55                   	push   %ebp
 1ef:	89 e5                	mov    %esp,%ebp
 1f1:	83 ec 04             	sub    $0x4,%esp
 1f4:	8b 45 0c             	mov    0xc(%ebp),%eax
 1f7:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1fa:	eb 14                	jmp    210 <strchr+0x22>
    if(*s == c)
 1fc:	8b 45 08             	mov    0x8(%ebp),%eax
 1ff:	0f b6 00             	movzbl (%eax),%eax
 202:	3a 45 fc             	cmp    -0x4(%ebp),%al
 205:	75 05                	jne    20c <strchr+0x1e>
      return (char*)s;
 207:	8b 45 08             	mov    0x8(%ebp),%eax
 20a:	eb 13                	jmp    21f <strchr+0x31>
  for(; *s; s++)
 20c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 210:	8b 45 08             	mov    0x8(%ebp),%eax
 213:	0f b6 00             	movzbl (%eax),%eax
 216:	84 c0                	test   %al,%al
 218:	75 e2                	jne    1fc <strchr+0xe>
  return 0;
 21a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 21f:	c9                   	leave  
 220:	c3                   	ret    

00000221 <gets>:

char*
gets(char *buf, int max)
{
 221:	55                   	push   %ebp
 222:	89 e5                	mov    %esp,%ebp
 224:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 227:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 22e:	eb 4c                	jmp    27c <gets+0x5b>
    cc = read(0, &c, 1);
 230:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 237:	00 
 238:	8d 45 ef             	lea    -0x11(%ebp),%eax
 23b:	89 44 24 04          	mov    %eax,0x4(%esp)
 23f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 246:	e8 61 02 00 00       	call   4ac <read>
 24b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 24e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 252:	7f 02                	jg     256 <gets+0x35>
      break;
 254:	eb 31                	jmp    287 <gets+0x66>
    buf[i++] = c;
 256:	8b 45 f4             	mov    -0xc(%ebp),%eax
 259:	8d 50 01             	lea    0x1(%eax),%edx
 25c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 25f:	89 c2                	mov    %eax,%edx
 261:	8b 45 08             	mov    0x8(%ebp),%eax
 264:	01 c2                	add    %eax,%edx
 266:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 26a:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 26c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 270:	3c 0a                	cmp    $0xa,%al
 272:	74 13                	je     287 <gets+0x66>
 274:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 278:	3c 0d                	cmp    $0xd,%al
 27a:	74 0b                	je     287 <gets+0x66>
  for(i=0; i+1 < max; ){
 27c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 27f:	83 c0 01             	add    $0x1,%eax
 282:	3b 45 0c             	cmp    0xc(%ebp),%eax
 285:	7c a9                	jl     230 <gets+0xf>
      break;
  }
  buf[i] = '\0';
 287:	8b 55 f4             	mov    -0xc(%ebp),%edx
 28a:	8b 45 08             	mov    0x8(%ebp),%eax
 28d:	01 d0                	add    %edx,%eax
 28f:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 292:	8b 45 08             	mov    0x8(%ebp),%eax
}
 295:	c9                   	leave  
 296:	c3                   	ret    

00000297 <stat>:

int
stat(const char *n, struct stat *st)
{
 297:	55                   	push   %ebp
 298:	89 e5                	mov    %esp,%ebp
 29a:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 29d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2a4:	00 
 2a5:	8b 45 08             	mov    0x8(%ebp),%eax
 2a8:	89 04 24             	mov    %eax,(%esp)
 2ab:	e8 24 02 00 00       	call   4d4 <open>
 2b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2b7:	79 07                	jns    2c0 <stat+0x29>
    return -1;
 2b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2be:	eb 23                	jmp    2e3 <stat+0x4c>
  r = fstat(fd, st);
 2c0:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c3:	89 44 24 04          	mov    %eax,0x4(%esp)
 2c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2ca:	89 04 24             	mov    %eax,(%esp)
 2cd:	e8 1a 02 00 00       	call   4ec <fstat>
 2d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2d8:	89 04 24             	mov    %eax,(%esp)
 2db:	e8 dc 01 00 00       	call   4bc <close>
  return r;
 2e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2e3:	c9                   	leave  
 2e4:	c3                   	ret    

000002e5 <atoi>:

int
atoi(const char *s)
{
 2e5:	55                   	push   %ebp
 2e6:	89 e5                	mov    %esp,%ebp
 2e8:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2f2:	eb 25                	jmp    319 <atoi+0x34>
    n = n*10 + *s++ - '0';
 2f4:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2f7:	89 d0                	mov    %edx,%eax
 2f9:	c1 e0 02             	shl    $0x2,%eax
 2fc:	01 d0                	add    %edx,%eax
 2fe:	01 c0                	add    %eax,%eax
 300:	89 c1                	mov    %eax,%ecx
 302:	8b 45 08             	mov    0x8(%ebp),%eax
 305:	8d 50 01             	lea    0x1(%eax),%edx
 308:	89 55 08             	mov    %edx,0x8(%ebp)
 30b:	0f b6 00             	movzbl (%eax),%eax
 30e:	0f be c0             	movsbl %al,%eax
 311:	01 c8                	add    %ecx,%eax
 313:	83 e8 30             	sub    $0x30,%eax
 316:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 319:	8b 45 08             	mov    0x8(%ebp),%eax
 31c:	0f b6 00             	movzbl (%eax),%eax
 31f:	3c 2f                	cmp    $0x2f,%al
 321:	7e 0a                	jle    32d <atoi+0x48>
 323:	8b 45 08             	mov    0x8(%ebp),%eax
 326:	0f b6 00             	movzbl (%eax),%eax
 329:	3c 39                	cmp    $0x39,%al
 32b:	7e c7                	jle    2f4 <atoi+0xf>
  return n;
 32d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 330:	c9                   	leave  
 331:	c3                   	ret    

00000332 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 332:	55                   	push   %ebp
 333:	89 e5                	mov    %esp,%ebp
 335:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 338:	8b 45 08             	mov    0x8(%ebp),%eax
 33b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 33e:	8b 45 0c             	mov    0xc(%ebp),%eax
 341:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 344:	eb 17                	jmp    35d <memmove+0x2b>
    *dst++ = *src++;
 346:	8b 45 fc             	mov    -0x4(%ebp),%eax
 349:	8d 50 01             	lea    0x1(%eax),%edx
 34c:	89 55 fc             	mov    %edx,-0x4(%ebp)
 34f:	8b 55 f8             	mov    -0x8(%ebp),%edx
 352:	8d 4a 01             	lea    0x1(%edx),%ecx
 355:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 358:	0f b6 12             	movzbl (%edx),%edx
 35b:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 35d:	8b 45 10             	mov    0x10(%ebp),%eax
 360:	8d 50 ff             	lea    -0x1(%eax),%edx
 363:	89 55 10             	mov    %edx,0x10(%ebp)
 366:	85 c0                	test   %eax,%eax
 368:	7f dc                	jg     346 <memmove+0x14>
  return vdst;
 36a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 36d:	c9                   	leave  
 36e:	c3                   	ret    

0000036f <ps>:

void 
ps()
{
 36f:	55                   	push   %ebp
 370:	89 e5                	mov    %esp,%ebp
 372:	57                   	push   %edi
 373:	56                   	push   %esi
 374:	53                   	push   %ebx
 375:	81 ec 3c 09 00 00    	sub    $0x93c,%esp
  pstatTable pTable;
  getpinfo(&pTable);
 37b:	8d 85 e4 f6 ff ff    	lea    -0x91c(%ebp),%eax
 381:	89 04 24             	mov    %eax,(%esp)
 384:	e8 ab 01 00 00       	call   534 <getpinfo>
  printf(1, "PID\tTKTS\tTCKS\tSTAT\tNAME\n");
 389:	c7 44 24 04 40 0a 00 	movl   $0xa40,0x4(%esp)
 390:	00 
 391:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 398:	e8 87 02 00 00       	call   624 <printf>
  int i;
  for (i = 0; i < NPROC; i++)
 39d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 3a4:	e9 ce 00 00 00       	jmp    477 <ps+0x108>
  {
    if(pTable[i].inuse)
 3a9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 3ac:	89 d0                	mov    %edx,%eax
 3ae:	c1 e0 03             	shl    $0x3,%eax
 3b1:	01 d0                	add    %edx,%eax
 3b3:	c1 e0 02             	shl    $0x2,%eax
 3b6:	8d 5d e8             	lea    -0x18(%ebp),%ebx
 3b9:	01 d8                	add    %ebx,%eax
 3bb:	2d 04 09 00 00       	sub    $0x904,%eax
 3c0:	8b 00                	mov    (%eax),%eax
 3c2:	85 c0                	test   %eax,%eax
 3c4:	0f 84 a9 00 00 00    	je     473 <ps+0x104>
      printf(1, "%d\t%d\t%d\t%c\t%s\n", pTable[i].pid, pTable[i].tickets, pTable[i].ticks, pTable[i].state, pTable[i].name);
 3ca:	8d 8d e4 f6 ff ff    	lea    -0x91c(%ebp),%ecx
 3d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 3d3:	89 d0                	mov    %edx,%eax
 3d5:	c1 e0 03             	shl    $0x3,%eax
 3d8:	01 d0                	add    %edx,%eax
 3da:	c1 e0 02             	shl    $0x2,%eax
 3dd:	83 c0 10             	add    $0x10,%eax
 3e0:	8d 3c 01             	lea    (%ecx,%eax,1),%edi
 3e3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 3e6:	89 d0                	mov    %edx,%eax
 3e8:	c1 e0 03             	shl    $0x3,%eax
 3eb:	01 d0                	add    %edx,%eax
 3ed:	c1 e0 02             	shl    $0x2,%eax
 3f0:	8d 75 e8             	lea    -0x18(%ebp),%esi
 3f3:	01 f0                	add    %esi,%eax
 3f5:	2d e4 08 00 00       	sub    $0x8e4,%eax
 3fa:	0f b6 00             	movzbl (%eax),%eax
 3fd:	0f be f0             	movsbl %al,%esi
 400:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 403:	89 d0                	mov    %edx,%eax
 405:	c1 e0 03             	shl    $0x3,%eax
 408:	01 d0                	add    %edx,%eax
 40a:	c1 e0 02             	shl    $0x2,%eax
 40d:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 410:	01 c8                	add    %ecx,%eax
 412:	2d f8 08 00 00       	sub    $0x8f8,%eax
 417:	8b 18                	mov    (%eax),%ebx
 419:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 41c:	89 d0                	mov    %edx,%eax
 41e:	c1 e0 03             	shl    $0x3,%eax
 421:	01 d0                	add    %edx,%eax
 423:	c1 e0 02             	shl    $0x2,%eax
 426:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 429:	01 c8                	add    %ecx,%eax
 42b:	2d 00 09 00 00       	sub    $0x900,%eax
 430:	8b 08                	mov    (%eax),%ecx
 432:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 435:	89 d0                	mov    %edx,%eax
 437:	c1 e0 03             	shl    $0x3,%eax
 43a:	01 d0                	add    %edx,%eax
 43c:	c1 e0 02             	shl    $0x2,%eax
 43f:	8d 55 e8             	lea    -0x18(%ebp),%edx
 442:	01 d0                	add    %edx,%eax
 444:	2d fc 08 00 00       	sub    $0x8fc,%eax
 449:	8b 00                	mov    (%eax),%eax
 44b:	89 7c 24 18          	mov    %edi,0x18(%esp)
 44f:	89 74 24 14          	mov    %esi,0x14(%esp)
 453:	89 5c 24 10          	mov    %ebx,0x10(%esp)
 457:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 45b:	89 44 24 08          	mov    %eax,0x8(%esp)
 45f:	c7 44 24 04 59 0a 00 	movl   $0xa59,0x4(%esp)
 466:	00 
 467:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 46e:	e8 b1 01 00 00       	call   624 <printf>
  for (i = 0; i < NPROC; i++)
 473:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 477:	83 7d e4 3f          	cmpl   $0x3f,-0x1c(%ebp)
 47b:	0f 8e 28 ff ff ff    	jle    3a9 <ps+0x3a>
  }
}
 481:	81 c4 3c 09 00 00    	add    $0x93c,%esp
 487:	5b                   	pop    %ebx
 488:	5e                   	pop    %esi
 489:	5f                   	pop    %edi
 48a:	5d                   	pop    %ebp
 48b:	c3                   	ret    

0000048c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 48c:	b8 01 00 00 00       	mov    $0x1,%eax
 491:	cd 40                	int    $0x40
 493:	c3                   	ret    

00000494 <exit>:
SYSCALL(exit)
 494:	b8 02 00 00 00       	mov    $0x2,%eax
 499:	cd 40                	int    $0x40
 49b:	c3                   	ret    

0000049c <wait>:
SYSCALL(wait)
 49c:	b8 03 00 00 00       	mov    $0x3,%eax
 4a1:	cd 40                	int    $0x40
 4a3:	c3                   	ret    

000004a4 <pipe>:
SYSCALL(pipe)
 4a4:	b8 04 00 00 00       	mov    $0x4,%eax
 4a9:	cd 40                	int    $0x40
 4ab:	c3                   	ret    

000004ac <read>:
SYSCALL(read)
 4ac:	b8 05 00 00 00       	mov    $0x5,%eax
 4b1:	cd 40                	int    $0x40
 4b3:	c3                   	ret    

000004b4 <write>:
SYSCALL(write)
 4b4:	b8 10 00 00 00       	mov    $0x10,%eax
 4b9:	cd 40                	int    $0x40
 4bb:	c3                   	ret    

000004bc <close>:
SYSCALL(close)
 4bc:	b8 15 00 00 00       	mov    $0x15,%eax
 4c1:	cd 40                	int    $0x40
 4c3:	c3                   	ret    

000004c4 <kill>:
SYSCALL(kill)
 4c4:	b8 06 00 00 00       	mov    $0x6,%eax
 4c9:	cd 40                	int    $0x40
 4cb:	c3                   	ret    

000004cc <exec>:
SYSCALL(exec)
 4cc:	b8 07 00 00 00       	mov    $0x7,%eax
 4d1:	cd 40                	int    $0x40
 4d3:	c3                   	ret    

000004d4 <open>:
SYSCALL(open)
 4d4:	b8 0f 00 00 00       	mov    $0xf,%eax
 4d9:	cd 40                	int    $0x40
 4db:	c3                   	ret    

000004dc <mknod>:
SYSCALL(mknod)
 4dc:	b8 11 00 00 00       	mov    $0x11,%eax
 4e1:	cd 40                	int    $0x40
 4e3:	c3                   	ret    

000004e4 <unlink>:
SYSCALL(unlink)
 4e4:	b8 12 00 00 00       	mov    $0x12,%eax
 4e9:	cd 40                	int    $0x40
 4eb:	c3                   	ret    

000004ec <fstat>:
SYSCALL(fstat)
 4ec:	b8 08 00 00 00       	mov    $0x8,%eax
 4f1:	cd 40                	int    $0x40
 4f3:	c3                   	ret    

000004f4 <link>:
SYSCALL(link)
 4f4:	b8 13 00 00 00       	mov    $0x13,%eax
 4f9:	cd 40                	int    $0x40
 4fb:	c3                   	ret    

000004fc <mkdir>:
SYSCALL(mkdir)
 4fc:	b8 14 00 00 00       	mov    $0x14,%eax
 501:	cd 40                	int    $0x40
 503:	c3                   	ret    

00000504 <chdir>:
SYSCALL(chdir)
 504:	b8 09 00 00 00       	mov    $0x9,%eax
 509:	cd 40                	int    $0x40
 50b:	c3                   	ret    

0000050c <dup>:
SYSCALL(dup)
 50c:	b8 0a 00 00 00       	mov    $0xa,%eax
 511:	cd 40                	int    $0x40
 513:	c3                   	ret    

00000514 <getpid>:
SYSCALL(getpid)
 514:	b8 0b 00 00 00       	mov    $0xb,%eax
 519:	cd 40                	int    $0x40
 51b:	c3                   	ret    

0000051c <sbrk>:
SYSCALL(sbrk)
 51c:	b8 0c 00 00 00       	mov    $0xc,%eax
 521:	cd 40                	int    $0x40
 523:	c3                   	ret    

00000524 <sleep>:
SYSCALL(sleep)
 524:	b8 0d 00 00 00       	mov    $0xd,%eax
 529:	cd 40                	int    $0x40
 52b:	c3                   	ret    

0000052c <uptime>:
SYSCALL(uptime)
 52c:	b8 0e 00 00 00       	mov    $0xe,%eax
 531:	cd 40                	int    $0x40
 533:	c3                   	ret    

00000534 <getpinfo>:
SYSCALL(getpinfo)
 534:	b8 16 00 00 00       	mov    $0x16,%eax
 539:	cd 40                	int    $0x40
 53b:	c3                   	ret    

0000053c <settickets>:
SYSCALL(settickets)
 53c:	b8 18 00 00 00       	mov    $0x18,%eax
 541:	cd 40                	int    $0x40
 543:	c3                   	ret    

00000544 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 544:	55                   	push   %ebp
 545:	89 e5                	mov    %esp,%ebp
 547:	83 ec 18             	sub    $0x18,%esp
 54a:	8b 45 0c             	mov    0xc(%ebp),%eax
 54d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 550:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 557:	00 
 558:	8d 45 f4             	lea    -0xc(%ebp),%eax
 55b:	89 44 24 04          	mov    %eax,0x4(%esp)
 55f:	8b 45 08             	mov    0x8(%ebp),%eax
 562:	89 04 24             	mov    %eax,(%esp)
 565:	e8 4a ff ff ff       	call   4b4 <write>
}
 56a:	c9                   	leave  
 56b:	c3                   	ret    

0000056c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 56c:	55                   	push   %ebp
 56d:	89 e5                	mov    %esp,%ebp
 56f:	56                   	push   %esi
 570:	53                   	push   %ebx
 571:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 574:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 57b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 57f:	74 17                	je     598 <printint+0x2c>
 581:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 585:	79 11                	jns    598 <printint+0x2c>
    neg = 1;
 587:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 58e:	8b 45 0c             	mov    0xc(%ebp),%eax
 591:	f7 d8                	neg    %eax
 593:	89 45 ec             	mov    %eax,-0x14(%ebp)
 596:	eb 06                	jmp    59e <printint+0x32>
  } else {
    x = xx;
 598:	8b 45 0c             	mov    0xc(%ebp),%eax
 59b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 59e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 5a5:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 5a8:	8d 41 01             	lea    0x1(%ecx),%eax
 5ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
 5ae:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5b4:	ba 00 00 00 00       	mov    $0x0,%edx
 5b9:	f7 f3                	div    %ebx
 5bb:	89 d0                	mov    %edx,%eax
 5bd:	0f b6 80 ec 0c 00 00 	movzbl 0xcec(%eax),%eax
 5c4:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 5c8:	8b 75 10             	mov    0x10(%ebp),%esi
 5cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5ce:	ba 00 00 00 00       	mov    $0x0,%edx
 5d3:	f7 f6                	div    %esi
 5d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5d8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5dc:	75 c7                	jne    5a5 <printint+0x39>
  if(neg)
 5de:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 5e2:	74 10                	je     5f4 <printint+0x88>
    buf[i++] = '-';
 5e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5e7:	8d 50 01             	lea    0x1(%eax),%edx
 5ea:	89 55 f4             	mov    %edx,-0xc(%ebp)
 5ed:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 5f2:	eb 1f                	jmp    613 <printint+0xa7>
 5f4:	eb 1d                	jmp    613 <printint+0xa7>
    putc(fd, buf[i]);
 5f6:	8d 55 dc             	lea    -0x24(%ebp),%edx
 5f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5fc:	01 d0                	add    %edx,%eax
 5fe:	0f b6 00             	movzbl (%eax),%eax
 601:	0f be c0             	movsbl %al,%eax
 604:	89 44 24 04          	mov    %eax,0x4(%esp)
 608:	8b 45 08             	mov    0x8(%ebp),%eax
 60b:	89 04 24             	mov    %eax,(%esp)
 60e:	e8 31 ff ff ff       	call   544 <putc>
  while(--i >= 0)
 613:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 617:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 61b:	79 d9                	jns    5f6 <printint+0x8a>
}
 61d:	83 c4 30             	add    $0x30,%esp
 620:	5b                   	pop    %ebx
 621:	5e                   	pop    %esi
 622:	5d                   	pop    %ebp
 623:	c3                   	ret    

00000624 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 624:	55                   	push   %ebp
 625:	89 e5                	mov    %esp,%ebp
 627:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 62a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 631:	8d 45 0c             	lea    0xc(%ebp),%eax
 634:	83 c0 04             	add    $0x4,%eax
 637:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 63a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 641:	e9 7c 01 00 00       	jmp    7c2 <printf+0x19e>
    c = fmt[i] & 0xff;
 646:	8b 55 0c             	mov    0xc(%ebp),%edx
 649:	8b 45 f0             	mov    -0x10(%ebp),%eax
 64c:	01 d0                	add    %edx,%eax
 64e:	0f b6 00             	movzbl (%eax),%eax
 651:	0f be c0             	movsbl %al,%eax
 654:	25 ff 00 00 00       	and    $0xff,%eax
 659:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 65c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 660:	75 2c                	jne    68e <printf+0x6a>
      if(c == '%'){
 662:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 666:	75 0c                	jne    674 <printf+0x50>
        state = '%';
 668:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 66f:	e9 4a 01 00 00       	jmp    7be <printf+0x19a>
      } else {
        putc(fd, c);
 674:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 677:	0f be c0             	movsbl %al,%eax
 67a:	89 44 24 04          	mov    %eax,0x4(%esp)
 67e:	8b 45 08             	mov    0x8(%ebp),%eax
 681:	89 04 24             	mov    %eax,(%esp)
 684:	e8 bb fe ff ff       	call   544 <putc>
 689:	e9 30 01 00 00       	jmp    7be <printf+0x19a>
      }
    } else if(state == '%'){
 68e:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 692:	0f 85 26 01 00 00    	jne    7be <printf+0x19a>
      if(c == 'd'){
 698:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 69c:	75 2d                	jne    6cb <printf+0xa7>
        printint(fd, *ap, 10, 1);
 69e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6a1:	8b 00                	mov    (%eax),%eax
 6a3:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 6aa:	00 
 6ab:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 6b2:	00 
 6b3:	89 44 24 04          	mov    %eax,0x4(%esp)
 6b7:	8b 45 08             	mov    0x8(%ebp),%eax
 6ba:	89 04 24             	mov    %eax,(%esp)
 6bd:	e8 aa fe ff ff       	call   56c <printint>
        ap++;
 6c2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6c6:	e9 ec 00 00 00       	jmp    7b7 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 6cb:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6cf:	74 06                	je     6d7 <printf+0xb3>
 6d1:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6d5:	75 2d                	jne    704 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 6d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6da:	8b 00                	mov    (%eax),%eax
 6dc:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 6e3:	00 
 6e4:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 6eb:	00 
 6ec:	89 44 24 04          	mov    %eax,0x4(%esp)
 6f0:	8b 45 08             	mov    0x8(%ebp),%eax
 6f3:	89 04 24             	mov    %eax,(%esp)
 6f6:	e8 71 fe ff ff       	call   56c <printint>
        ap++;
 6fb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6ff:	e9 b3 00 00 00       	jmp    7b7 <printf+0x193>
      } else if(c == 's'){
 704:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 708:	75 45                	jne    74f <printf+0x12b>
        s = (char*)*ap;
 70a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 70d:	8b 00                	mov    (%eax),%eax
 70f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 712:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 716:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 71a:	75 09                	jne    725 <printf+0x101>
          s = "(null)";
 71c:	c7 45 f4 69 0a 00 00 	movl   $0xa69,-0xc(%ebp)
        while(*s != 0){
 723:	eb 1e                	jmp    743 <printf+0x11f>
 725:	eb 1c                	jmp    743 <printf+0x11f>
          putc(fd, *s);
 727:	8b 45 f4             	mov    -0xc(%ebp),%eax
 72a:	0f b6 00             	movzbl (%eax),%eax
 72d:	0f be c0             	movsbl %al,%eax
 730:	89 44 24 04          	mov    %eax,0x4(%esp)
 734:	8b 45 08             	mov    0x8(%ebp),%eax
 737:	89 04 24             	mov    %eax,(%esp)
 73a:	e8 05 fe ff ff       	call   544 <putc>
          s++;
 73f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 743:	8b 45 f4             	mov    -0xc(%ebp),%eax
 746:	0f b6 00             	movzbl (%eax),%eax
 749:	84 c0                	test   %al,%al
 74b:	75 da                	jne    727 <printf+0x103>
 74d:	eb 68                	jmp    7b7 <printf+0x193>
        }
      } else if(c == 'c'){
 74f:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 753:	75 1d                	jne    772 <printf+0x14e>
        putc(fd, *ap);
 755:	8b 45 e8             	mov    -0x18(%ebp),%eax
 758:	8b 00                	mov    (%eax),%eax
 75a:	0f be c0             	movsbl %al,%eax
 75d:	89 44 24 04          	mov    %eax,0x4(%esp)
 761:	8b 45 08             	mov    0x8(%ebp),%eax
 764:	89 04 24             	mov    %eax,(%esp)
 767:	e8 d8 fd ff ff       	call   544 <putc>
        ap++;
 76c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 770:	eb 45                	jmp    7b7 <printf+0x193>
      } else if(c == '%'){
 772:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 776:	75 17                	jne    78f <printf+0x16b>
        putc(fd, c);
 778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 77b:	0f be c0             	movsbl %al,%eax
 77e:	89 44 24 04          	mov    %eax,0x4(%esp)
 782:	8b 45 08             	mov    0x8(%ebp),%eax
 785:	89 04 24             	mov    %eax,(%esp)
 788:	e8 b7 fd ff ff       	call   544 <putc>
 78d:	eb 28                	jmp    7b7 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 78f:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 796:	00 
 797:	8b 45 08             	mov    0x8(%ebp),%eax
 79a:	89 04 24             	mov    %eax,(%esp)
 79d:	e8 a2 fd ff ff       	call   544 <putc>
        putc(fd, c);
 7a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7a5:	0f be c0             	movsbl %al,%eax
 7a8:	89 44 24 04          	mov    %eax,0x4(%esp)
 7ac:	8b 45 08             	mov    0x8(%ebp),%eax
 7af:	89 04 24             	mov    %eax,(%esp)
 7b2:	e8 8d fd ff ff       	call   544 <putc>
      }
      state = 0;
 7b7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 7be:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 7c2:	8b 55 0c             	mov    0xc(%ebp),%edx
 7c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c8:	01 d0                	add    %edx,%eax
 7ca:	0f b6 00             	movzbl (%eax),%eax
 7cd:	84 c0                	test   %al,%al
 7cf:	0f 85 71 fe ff ff    	jne    646 <printf+0x22>
    }
  }
}
 7d5:	c9                   	leave  
 7d6:	c3                   	ret    

000007d7 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7d7:	55                   	push   %ebp
 7d8:	89 e5                	mov    %esp,%ebp
 7da:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7dd:	8b 45 08             	mov    0x8(%ebp),%eax
 7e0:	83 e8 08             	sub    $0x8,%eax
 7e3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e6:	a1 08 0d 00 00       	mov    0xd08,%eax
 7eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
 7ee:	eb 24                	jmp    814 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f3:	8b 00                	mov    (%eax),%eax
 7f5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 7f8:	77 12                	ja     80c <free+0x35>
 7fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7fd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 800:	77 24                	ja     826 <free+0x4f>
 802:	8b 45 fc             	mov    -0x4(%ebp),%eax
 805:	8b 00                	mov    (%eax),%eax
 807:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 80a:	77 1a                	ja     826 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 80c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80f:	8b 00                	mov    (%eax),%eax
 811:	89 45 fc             	mov    %eax,-0x4(%ebp)
 814:	8b 45 f8             	mov    -0x8(%ebp),%eax
 817:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 81a:	76 d4                	jbe    7f0 <free+0x19>
 81c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81f:	8b 00                	mov    (%eax),%eax
 821:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 824:	76 ca                	jbe    7f0 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 826:	8b 45 f8             	mov    -0x8(%ebp),%eax
 829:	8b 40 04             	mov    0x4(%eax),%eax
 82c:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 833:	8b 45 f8             	mov    -0x8(%ebp),%eax
 836:	01 c2                	add    %eax,%edx
 838:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83b:	8b 00                	mov    (%eax),%eax
 83d:	39 c2                	cmp    %eax,%edx
 83f:	75 24                	jne    865 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 841:	8b 45 f8             	mov    -0x8(%ebp),%eax
 844:	8b 50 04             	mov    0x4(%eax),%edx
 847:	8b 45 fc             	mov    -0x4(%ebp),%eax
 84a:	8b 00                	mov    (%eax),%eax
 84c:	8b 40 04             	mov    0x4(%eax),%eax
 84f:	01 c2                	add    %eax,%edx
 851:	8b 45 f8             	mov    -0x8(%ebp),%eax
 854:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 857:	8b 45 fc             	mov    -0x4(%ebp),%eax
 85a:	8b 00                	mov    (%eax),%eax
 85c:	8b 10                	mov    (%eax),%edx
 85e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 861:	89 10                	mov    %edx,(%eax)
 863:	eb 0a                	jmp    86f <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 865:	8b 45 fc             	mov    -0x4(%ebp),%eax
 868:	8b 10                	mov    (%eax),%edx
 86a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 86d:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 86f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 872:	8b 40 04             	mov    0x4(%eax),%eax
 875:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 87c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 87f:	01 d0                	add    %edx,%eax
 881:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 884:	75 20                	jne    8a6 <free+0xcf>
    p->s.size += bp->s.size;
 886:	8b 45 fc             	mov    -0x4(%ebp),%eax
 889:	8b 50 04             	mov    0x4(%eax),%edx
 88c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 88f:	8b 40 04             	mov    0x4(%eax),%eax
 892:	01 c2                	add    %eax,%edx
 894:	8b 45 fc             	mov    -0x4(%ebp),%eax
 897:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 89a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 89d:	8b 10                	mov    (%eax),%edx
 89f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a2:	89 10                	mov    %edx,(%eax)
 8a4:	eb 08                	jmp    8ae <free+0xd7>
  } else
    p->s.ptr = bp;
 8a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a9:	8b 55 f8             	mov    -0x8(%ebp),%edx
 8ac:	89 10                	mov    %edx,(%eax)
  freep = p;
 8ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b1:	a3 08 0d 00 00       	mov    %eax,0xd08
}
 8b6:	c9                   	leave  
 8b7:	c3                   	ret    

000008b8 <morecore>:

static Header*
morecore(uint nu)
{
 8b8:	55                   	push   %ebp
 8b9:	89 e5                	mov    %esp,%ebp
 8bb:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 8be:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 8c5:	77 07                	ja     8ce <morecore+0x16>
    nu = 4096;
 8c7:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 8ce:	8b 45 08             	mov    0x8(%ebp),%eax
 8d1:	c1 e0 03             	shl    $0x3,%eax
 8d4:	89 04 24             	mov    %eax,(%esp)
 8d7:	e8 40 fc ff ff       	call   51c <sbrk>
 8dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 8df:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 8e3:	75 07                	jne    8ec <morecore+0x34>
    return 0;
 8e5:	b8 00 00 00 00       	mov    $0x0,%eax
 8ea:	eb 22                	jmp    90e <morecore+0x56>
  hp = (Header*)p;
 8ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 8f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8f5:	8b 55 08             	mov    0x8(%ebp),%edx
 8f8:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 8fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8fe:	83 c0 08             	add    $0x8,%eax
 901:	89 04 24             	mov    %eax,(%esp)
 904:	e8 ce fe ff ff       	call   7d7 <free>
  return freep;
 909:	a1 08 0d 00 00       	mov    0xd08,%eax
}
 90e:	c9                   	leave  
 90f:	c3                   	ret    

00000910 <malloc>:

void*
malloc(uint nbytes)
{
 910:	55                   	push   %ebp
 911:	89 e5                	mov    %esp,%ebp
 913:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 916:	8b 45 08             	mov    0x8(%ebp),%eax
 919:	83 c0 07             	add    $0x7,%eax
 91c:	c1 e8 03             	shr    $0x3,%eax
 91f:	83 c0 01             	add    $0x1,%eax
 922:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 925:	a1 08 0d 00 00       	mov    0xd08,%eax
 92a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 92d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 931:	75 23                	jne    956 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 933:	c7 45 f0 00 0d 00 00 	movl   $0xd00,-0x10(%ebp)
 93a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 93d:	a3 08 0d 00 00       	mov    %eax,0xd08
 942:	a1 08 0d 00 00       	mov    0xd08,%eax
 947:	a3 00 0d 00 00       	mov    %eax,0xd00
    base.s.size = 0;
 94c:	c7 05 04 0d 00 00 00 	movl   $0x0,0xd04
 953:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 956:	8b 45 f0             	mov    -0x10(%ebp),%eax
 959:	8b 00                	mov    (%eax),%eax
 95b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 95e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 961:	8b 40 04             	mov    0x4(%eax),%eax
 964:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 967:	72 4d                	jb     9b6 <malloc+0xa6>
      if(p->s.size == nunits)
 969:	8b 45 f4             	mov    -0xc(%ebp),%eax
 96c:	8b 40 04             	mov    0x4(%eax),%eax
 96f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 972:	75 0c                	jne    980 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 974:	8b 45 f4             	mov    -0xc(%ebp),%eax
 977:	8b 10                	mov    (%eax),%edx
 979:	8b 45 f0             	mov    -0x10(%ebp),%eax
 97c:	89 10                	mov    %edx,(%eax)
 97e:	eb 26                	jmp    9a6 <malloc+0x96>
      else {
        p->s.size -= nunits;
 980:	8b 45 f4             	mov    -0xc(%ebp),%eax
 983:	8b 40 04             	mov    0x4(%eax),%eax
 986:	2b 45 ec             	sub    -0x14(%ebp),%eax
 989:	89 c2                	mov    %eax,%edx
 98b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 98e:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 991:	8b 45 f4             	mov    -0xc(%ebp),%eax
 994:	8b 40 04             	mov    0x4(%eax),%eax
 997:	c1 e0 03             	shl    $0x3,%eax
 99a:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 99d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a0:	8b 55 ec             	mov    -0x14(%ebp),%edx
 9a3:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 9a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9a9:	a3 08 0d 00 00       	mov    %eax,0xd08
      return (void*)(p + 1);
 9ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b1:	83 c0 08             	add    $0x8,%eax
 9b4:	eb 38                	jmp    9ee <malloc+0xde>
    }
    if(p == freep)
 9b6:	a1 08 0d 00 00       	mov    0xd08,%eax
 9bb:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 9be:	75 1b                	jne    9db <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 9c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
 9c3:	89 04 24             	mov    %eax,(%esp)
 9c6:	e8 ed fe ff ff       	call   8b8 <morecore>
 9cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9d2:	75 07                	jne    9db <malloc+0xcb>
        return 0;
 9d4:	b8 00 00 00 00       	mov    $0x0,%eax
 9d9:	eb 13                	jmp    9ee <malloc+0xde>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9de:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9e4:	8b 00                	mov    (%eax),%eax
 9e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 9e9:	e9 70 ff ff ff       	jmp    95e <malloc+0x4e>
}
 9ee:	c9                   	leave  
 9ef:	c3                   	ret    
