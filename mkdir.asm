
_mkdir:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int i;

  if(argc < 2){
   9:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
   d:	7f 19                	jg     28 <main+0x28>
    printf(2, "Usage: mkdir files...\n");
   f:	c7 44 24 04 70 09 00 	movl   $0x970,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 81 05 00 00       	call   5a4 <printf>
    exit();
  23:	e8 ec 03 00 00       	call   414 <exit>
  }

  for(i = 1; i < argc; i++){
  28:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  2f:	00 
  30:	eb 4f                	jmp    81 <main+0x81>
    if(mkdir(argv[i]) < 0){
  32:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  36:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  40:	01 d0                	add    %edx,%eax
  42:	8b 00                	mov    (%eax),%eax
  44:	89 04 24             	mov    %eax,(%esp)
  47:	e8 30 04 00 00       	call   47c <mkdir>
  4c:	85 c0                	test   %eax,%eax
  4e:	79 2c                	jns    7c <main+0x7c>
      printf(2, "mkdir: %s failed to create\n", argv[i]);
  50:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  54:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  5e:	01 d0                	add    %edx,%eax
  60:	8b 00                	mov    (%eax),%eax
  62:	89 44 24 08          	mov    %eax,0x8(%esp)
  66:	c7 44 24 04 87 09 00 	movl   $0x987,0x4(%esp)
  6d:	00 
  6e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  75:	e8 2a 05 00 00       	call   5a4 <printf>
      break;
  7a:	eb 0e                	jmp    8a <main+0x8a>
  for(i = 1; i < argc; i++){
  7c:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  81:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  85:	3b 45 08             	cmp    0x8(%ebp),%eax
  88:	7c a8                	jl     32 <main+0x32>
    }
  }

  exit();
  8a:	e8 85 03 00 00       	call   414 <exit>

0000008f <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  8f:	55                   	push   %ebp
  90:	89 e5                	mov    %esp,%ebp
  92:	57                   	push   %edi
  93:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  94:	8b 4d 08             	mov    0x8(%ebp),%ecx
  97:	8b 55 10             	mov    0x10(%ebp),%edx
  9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  9d:	89 cb                	mov    %ecx,%ebx
  9f:	89 df                	mov    %ebx,%edi
  a1:	89 d1                	mov    %edx,%ecx
  a3:	fc                   	cld    
  a4:	f3 aa                	rep stos %al,%es:(%edi)
  a6:	89 ca                	mov    %ecx,%edx
  a8:	89 fb                	mov    %edi,%ebx
  aa:	89 5d 08             	mov    %ebx,0x8(%ebp)
  ad:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  b0:	5b                   	pop    %ebx
  b1:	5f                   	pop    %edi
  b2:	5d                   	pop    %ebp
  b3:	c3                   	ret    

000000b4 <strcpy>:
#include "x86.h"
#include "pstat.h"

char*
strcpy(char *s, const char *t)
{
  b4:	55                   	push   %ebp
  b5:	89 e5                	mov    %esp,%ebp
  b7:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  ba:	8b 45 08             	mov    0x8(%ebp),%eax
  bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  c0:	90                   	nop
  c1:	8b 45 08             	mov    0x8(%ebp),%eax
  c4:	8d 50 01             	lea    0x1(%eax),%edx
  c7:	89 55 08             	mov    %edx,0x8(%ebp)
  ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  cd:	8d 4a 01             	lea    0x1(%edx),%ecx
  d0:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  d3:	0f b6 12             	movzbl (%edx),%edx
  d6:	88 10                	mov    %dl,(%eax)
  d8:	0f b6 00             	movzbl (%eax),%eax
  db:	84 c0                	test   %al,%al
  dd:	75 e2                	jne    c1 <strcpy+0xd>
    ;
  return os;
  df:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  e2:	c9                   	leave  
  e3:	c3                   	ret    

000000e4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  e4:	55                   	push   %ebp
  e5:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  e7:	eb 08                	jmp    f1 <strcmp+0xd>
    p++, q++;
  e9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  ed:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
  f1:	8b 45 08             	mov    0x8(%ebp),%eax
  f4:	0f b6 00             	movzbl (%eax),%eax
  f7:	84 c0                	test   %al,%al
  f9:	74 10                	je     10b <strcmp+0x27>
  fb:	8b 45 08             	mov    0x8(%ebp),%eax
  fe:	0f b6 10             	movzbl (%eax),%edx
 101:	8b 45 0c             	mov    0xc(%ebp),%eax
 104:	0f b6 00             	movzbl (%eax),%eax
 107:	38 c2                	cmp    %al,%dl
 109:	74 de                	je     e9 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 10b:	8b 45 08             	mov    0x8(%ebp),%eax
 10e:	0f b6 00             	movzbl (%eax),%eax
 111:	0f b6 d0             	movzbl %al,%edx
 114:	8b 45 0c             	mov    0xc(%ebp),%eax
 117:	0f b6 00             	movzbl (%eax),%eax
 11a:	0f b6 c0             	movzbl %al,%eax
 11d:	29 c2                	sub    %eax,%edx
 11f:	89 d0                	mov    %edx,%eax
}
 121:	5d                   	pop    %ebp
 122:	c3                   	ret    

00000123 <strlen>:

uint
strlen(const char *s)
{
 123:	55                   	push   %ebp
 124:	89 e5                	mov    %esp,%ebp
 126:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 129:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 130:	eb 04                	jmp    136 <strlen+0x13>
 132:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 136:	8b 55 fc             	mov    -0x4(%ebp),%edx
 139:	8b 45 08             	mov    0x8(%ebp),%eax
 13c:	01 d0                	add    %edx,%eax
 13e:	0f b6 00             	movzbl (%eax),%eax
 141:	84 c0                	test   %al,%al
 143:	75 ed                	jne    132 <strlen+0xf>
    ;
  return n;
 145:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 148:	c9                   	leave  
 149:	c3                   	ret    

0000014a <memset>:

void*
memset(void *dst, int c, uint n)
{
 14a:	55                   	push   %ebp
 14b:	89 e5                	mov    %esp,%ebp
 14d:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 150:	8b 45 10             	mov    0x10(%ebp),%eax
 153:	89 44 24 08          	mov    %eax,0x8(%esp)
 157:	8b 45 0c             	mov    0xc(%ebp),%eax
 15a:	89 44 24 04          	mov    %eax,0x4(%esp)
 15e:	8b 45 08             	mov    0x8(%ebp),%eax
 161:	89 04 24             	mov    %eax,(%esp)
 164:	e8 26 ff ff ff       	call   8f <stosb>
  return dst;
 169:	8b 45 08             	mov    0x8(%ebp),%eax
}
 16c:	c9                   	leave  
 16d:	c3                   	ret    

0000016e <strchr>:

char*
strchr(const char *s, char c)
{
 16e:	55                   	push   %ebp
 16f:	89 e5                	mov    %esp,%ebp
 171:	83 ec 04             	sub    $0x4,%esp
 174:	8b 45 0c             	mov    0xc(%ebp),%eax
 177:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 17a:	eb 14                	jmp    190 <strchr+0x22>
    if(*s == c)
 17c:	8b 45 08             	mov    0x8(%ebp),%eax
 17f:	0f b6 00             	movzbl (%eax),%eax
 182:	3a 45 fc             	cmp    -0x4(%ebp),%al
 185:	75 05                	jne    18c <strchr+0x1e>
      return (char*)s;
 187:	8b 45 08             	mov    0x8(%ebp),%eax
 18a:	eb 13                	jmp    19f <strchr+0x31>
  for(; *s; s++)
 18c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 190:	8b 45 08             	mov    0x8(%ebp),%eax
 193:	0f b6 00             	movzbl (%eax),%eax
 196:	84 c0                	test   %al,%al
 198:	75 e2                	jne    17c <strchr+0xe>
  return 0;
 19a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 19f:	c9                   	leave  
 1a0:	c3                   	ret    

000001a1 <gets>:

char*
gets(char *buf, int max)
{
 1a1:	55                   	push   %ebp
 1a2:	89 e5                	mov    %esp,%ebp
 1a4:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 1ae:	eb 4c                	jmp    1fc <gets+0x5b>
    cc = read(0, &c, 1);
 1b0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1b7:	00 
 1b8:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1bb:	89 44 24 04          	mov    %eax,0x4(%esp)
 1bf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1c6:	e8 61 02 00 00       	call   42c <read>
 1cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1d2:	7f 02                	jg     1d6 <gets+0x35>
      break;
 1d4:	eb 31                	jmp    207 <gets+0x66>
    buf[i++] = c;
 1d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d9:	8d 50 01             	lea    0x1(%eax),%edx
 1dc:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1df:	89 c2                	mov    %eax,%edx
 1e1:	8b 45 08             	mov    0x8(%ebp),%eax
 1e4:	01 c2                	add    %eax,%edx
 1e6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ea:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1ec:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1f0:	3c 0a                	cmp    $0xa,%al
 1f2:	74 13                	je     207 <gets+0x66>
 1f4:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1f8:	3c 0d                	cmp    $0xd,%al
 1fa:	74 0b                	je     207 <gets+0x66>
  for(i=0; i+1 < max; ){
 1fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ff:	83 c0 01             	add    $0x1,%eax
 202:	3b 45 0c             	cmp    0xc(%ebp),%eax
 205:	7c a9                	jl     1b0 <gets+0xf>
      break;
  }
  buf[i] = '\0';
 207:	8b 55 f4             	mov    -0xc(%ebp),%edx
 20a:	8b 45 08             	mov    0x8(%ebp),%eax
 20d:	01 d0                	add    %edx,%eax
 20f:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 212:	8b 45 08             	mov    0x8(%ebp),%eax
}
 215:	c9                   	leave  
 216:	c3                   	ret    

00000217 <stat>:

int
stat(const char *n, struct stat *st)
{
 217:	55                   	push   %ebp
 218:	89 e5                	mov    %esp,%ebp
 21a:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 21d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 224:	00 
 225:	8b 45 08             	mov    0x8(%ebp),%eax
 228:	89 04 24             	mov    %eax,(%esp)
 22b:	e8 24 02 00 00       	call   454 <open>
 230:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 233:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 237:	79 07                	jns    240 <stat+0x29>
    return -1;
 239:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 23e:	eb 23                	jmp    263 <stat+0x4c>
  r = fstat(fd, st);
 240:	8b 45 0c             	mov    0xc(%ebp),%eax
 243:	89 44 24 04          	mov    %eax,0x4(%esp)
 247:	8b 45 f4             	mov    -0xc(%ebp),%eax
 24a:	89 04 24             	mov    %eax,(%esp)
 24d:	e8 1a 02 00 00       	call   46c <fstat>
 252:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 255:	8b 45 f4             	mov    -0xc(%ebp),%eax
 258:	89 04 24             	mov    %eax,(%esp)
 25b:	e8 dc 01 00 00       	call   43c <close>
  return r;
 260:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 263:	c9                   	leave  
 264:	c3                   	ret    

00000265 <atoi>:

int
atoi(const char *s)
{
 265:	55                   	push   %ebp
 266:	89 e5                	mov    %esp,%ebp
 268:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 26b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 272:	eb 25                	jmp    299 <atoi+0x34>
    n = n*10 + *s++ - '0';
 274:	8b 55 fc             	mov    -0x4(%ebp),%edx
 277:	89 d0                	mov    %edx,%eax
 279:	c1 e0 02             	shl    $0x2,%eax
 27c:	01 d0                	add    %edx,%eax
 27e:	01 c0                	add    %eax,%eax
 280:	89 c1                	mov    %eax,%ecx
 282:	8b 45 08             	mov    0x8(%ebp),%eax
 285:	8d 50 01             	lea    0x1(%eax),%edx
 288:	89 55 08             	mov    %edx,0x8(%ebp)
 28b:	0f b6 00             	movzbl (%eax),%eax
 28e:	0f be c0             	movsbl %al,%eax
 291:	01 c8                	add    %ecx,%eax
 293:	83 e8 30             	sub    $0x30,%eax
 296:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 299:	8b 45 08             	mov    0x8(%ebp),%eax
 29c:	0f b6 00             	movzbl (%eax),%eax
 29f:	3c 2f                	cmp    $0x2f,%al
 2a1:	7e 0a                	jle    2ad <atoi+0x48>
 2a3:	8b 45 08             	mov    0x8(%ebp),%eax
 2a6:	0f b6 00             	movzbl (%eax),%eax
 2a9:	3c 39                	cmp    $0x39,%al
 2ab:	7e c7                	jle    274 <atoi+0xf>
  return n;
 2ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 2b0:	c9                   	leave  
 2b1:	c3                   	ret    

000002b2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2b2:	55                   	push   %ebp
 2b3:	89 e5                	mov    %esp,%ebp
 2b5:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 2b8:	8b 45 08             	mov    0x8(%ebp),%eax
 2bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2be:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2c4:	eb 17                	jmp    2dd <memmove+0x2b>
    *dst++ = *src++;
 2c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2c9:	8d 50 01             	lea    0x1(%eax),%edx
 2cc:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2cf:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2d2:	8d 4a 01             	lea    0x1(%edx),%ecx
 2d5:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2d8:	0f b6 12             	movzbl (%edx),%edx
 2db:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 2dd:	8b 45 10             	mov    0x10(%ebp),%eax
 2e0:	8d 50 ff             	lea    -0x1(%eax),%edx
 2e3:	89 55 10             	mov    %edx,0x10(%ebp)
 2e6:	85 c0                	test   %eax,%eax
 2e8:	7f dc                	jg     2c6 <memmove+0x14>
  return vdst;
 2ea:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2ed:	c9                   	leave  
 2ee:	c3                   	ret    

000002ef <ps>:

void 
ps()
{
 2ef:	55                   	push   %ebp
 2f0:	89 e5                	mov    %esp,%ebp
 2f2:	57                   	push   %edi
 2f3:	56                   	push   %esi
 2f4:	53                   	push   %ebx
 2f5:	81 ec 3c 09 00 00    	sub    $0x93c,%esp
  pstatTable pTable;
  getpinfo(&pTable);
 2fb:	8d 85 e4 f6 ff ff    	lea    -0x91c(%ebp),%eax
 301:	89 04 24             	mov    %eax,(%esp)
 304:	e8 ab 01 00 00       	call   4b4 <getpinfo>
  printf(1, "PID\tTKTS\tTCKS\tSTAT\tNAME\n");
 309:	c7 44 24 04 a3 09 00 	movl   $0x9a3,0x4(%esp)
 310:	00 
 311:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 318:	e8 87 02 00 00       	call   5a4 <printf>
  int i;
  for (i = 0; i < NPROC; i++)
 31d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 324:	e9 ce 00 00 00       	jmp    3f7 <ps+0x108>
  {
    if(pTable[i].inuse)
 329:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 32c:	89 d0                	mov    %edx,%eax
 32e:	c1 e0 03             	shl    $0x3,%eax
 331:	01 d0                	add    %edx,%eax
 333:	c1 e0 02             	shl    $0x2,%eax
 336:	8d 5d e8             	lea    -0x18(%ebp),%ebx
 339:	01 d8                	add    %ebx,%eax
 33b:	2d 04 09 00 00       	sub    $0x904,%eax
 340:	8b 00                	mov    (%eax),%eax
 342:	85 c0                	test   %eax,%eax
 344:	0f 84 a9 00 00 00    	je     3f3 <ps+0x104>
      printf(1, "%d\t%d\t%d\t%c\t%s\n", pTable[i].pid, pTable[i].tickets, pTable[i].ticks, pTable[i].state, pTable[i].name);
 34a:	8d 8d e4 f6 ff ff    	lea    -0x91c(%ebp),%ecx
 350:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 353:	89 d0                	mov    %edx,%eax
 355:	c1 e0 03             	shl    $0x3,%eax
 358:	01 d0                	add    %edx,%eax
 35a:	c1 e0 02             	shl    $0x2,%eax
 35d:	83 c0 10             	add    $0x10,%eax
 360:	8d 3c 01             	lea    (%ecx,%eax,1),%edi
 363:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 366:	89 d0                	mov    %edx,%eax
 368:	c1 e0 03             	shl    $0x3,%eax
 36b:	01 d0                	add    %edx,%eax
 36d:	c1 e0 02             	shl    $0x2,%eax
 370:	8d 75 e8             	lea    -0x18(%ebp),%esi
 373:	01 f0                	add    %esi,%eax
 375:	2d e4 08 00 00       	sub    $0x8e4,%eax
 37a:	0f b6 00             	movzbl (%eax),%eax
 37d:	0f be f0             	movsbl %al,%esi
 380:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 383:	89 d0                	mov    %edx,%eax
 385:	c1 e0 03             	shl    $0x3,%eax
 388:	01 d0                	add    %edx,%eax
 38a:	c1 e0 02             	shl    $0x2,%eax
 38d:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 390:	01 c8                	add    %ecx,%eax
 392:	2d f8 08 00 00       	sub    $0x8f8,%eax
 397:	8b 18                	mov    (%eax),%ebx
 399:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 39c:	89 d0                	mov    %edx,%eax
 39e:	c1 e0 03             	shl    $0x3,%eax
 3a1:	01 d0                	add    %edx,%eax
 3a3:	c1 e0 02             	shl    $0x2,%eax
 3a6:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 3a9:	01 c8                	add    %ecx,%eax
 3ab:	2d 00 09 00 00       	sub    $0x900,%eax
 3b0:	8b 08                	mov    (%eax),%ecx
 3b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 3b5:	89 d0                	mov    %edx,%eax
 3b7:	c1 e0 03             	shl    $0x3,%eax
 3ba:	01 d0                	add    %edx,%eax
 3bc:	c1 e0 02             	shl    $0x2,%eax
 3bf:	8d 55 e8             	lea    -0x18(%ebp),%edx
 3c2:	01 d0                	add    %edx,%eax
 3c4:	2d fc 08 00 00       	sub    $0x8fc,%eax
 3c9:	8b 00                	mov    (%eax),%eax
 3cb:	89 7c 24 18          	mov    %edi,0x18(%esp)
 3cf:	89 74 24 14          	mov    %esi,0x14(%esp)
 3d3:	89 5c 24 10          	mov    %ebx,0x10(%esp)
 3d7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 3db:	89 44 24 08          	mov    %eax,0x8(%esp)
 3df:	c7 44 24 04 bc 09 00 	movl   $0x9bc,0x4(%esp)
 3e6:	00 
 3e7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 3ee:	e8 b1 01 00 00       	call   5a4 <printf>
  for (i = 0; i < NPROC; i++)
 3f3:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 3f7:	83 7d e4 3f          	cmpl   $0x3f,-0x1c(%ebp)
 3fb:	0f 8e 28 ff ff ff    	jle    329 <ps+0x3a>
  }
}
 401:	81 c4 3c 09 00 00    	add    $0x93c,%esp
 407:	5b                   	pop    %ebx
 408:	5e                   	pop    %esi
 409:	5f                   	pop    %edi
 40a:	5d                   	pop    %ebp
 40b:	c3                   	ret    

0000040c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 40c:	b8 01 00 00 00       	mov    $0x1,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret    

00000414 <exit>:
SYSCALL(exit)
 414:	b8 02 00 00 00       	mov    $0x2,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <wait>:
SYSCALL(wait)
 41c:	b8 03 00 00 00       	mov    $0x3,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <pipe>:
SYSCALL(pipe)
 424:	b8 04 00 00 00       	mov    $0x4,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <read>:
SYSCALL(read)
 42c:	b8 05 00 00 00       	mov    $0x5,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret    

00000434 <write>:
SYSCALL(write)
 434:	b8 10 00 00 00       	mov    $0x10,%eax
 439:	cd 40                	int    $0x40
 43b:	c3                   	ret    

0000043c <close>:
SYSCALL(close)
 43c:	b8 15 00 00 00       	mov    $0x15,%eax
 441:	cd 40                	int    $0x40
 443:	c3                   	ret    

00000444 <kill>:
SYSCALL(kill)
 444:	b8 06 00 00 00       	mov    $0x6,%eax
 449:	cd 40                	int    $0x40
 44b:	c3                   	ret    

0000044c <exec>:
SYSCALL(exec)
 44c:	b8 07 00 00 00       	mov    $0x7,%eax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret    

00000454 <open>:
SYSCALL(open)
 454:	b8 0f 00 00 00       	mov    $0xf,%eax
 459:	cd 40                	int    $0x40
 45b:	c3                   	ret    

0000045c <mknod>:
SYSCALL(mknod)
 45c:	b8 11 00 00 00       	mov    $0x11,%eax
 461:	cd 40                	int    $0x40
 463:	c3                   	ret    

00000464 <unlink>:
SYSCALL(unlink)
 464:	b8 12 00 00 00       	mov    $0x12,%eax
 469:	cd 40                	int    $0x40
 46b:	c3                   	ret    

0000046c <fstat>:
SYSCALL(fstat)
 46c:	b8 08 00 00 00       	mov    $0x8,%eax
 471:	cd 40                	int    $0x40
 473:	c3                   	ret    

00000474 <link>:
SYSCALL(link)
 474:	b8 13 00 00 00       	mov    $0x13,%eax
 479:	cd 40                	int    $0x40
 47b:	c3                   	ret    

0000047c <mkdir>:
SYSCALL(mkdir)
 47c:	b8 14 00 00 00       	mov    $0x14,%eax
 481:	cd 40                	int    $0x40
 483:	c3                   	ret    

00000484 <chdir>:
SYSCALL(chdir)
 484:	b8 09 00 00 00       	mov    $0x9,%eax
 489:	cd 40                	int    $0x40
 48b:	c3                   	ret    

0000048c <dup>:
SYSCALL(dup)
 48c:	b8 0a 00 00 00       	mov    $0xa,%eax
 491:	cd 40                	int    $0x40
 493:	c3                   	ret    

00000494 <getpid>:
SYSCALL(getpid)
 494:	b8 0b 00 00 00       	mov    $0xb,%eax
 499:	cd 40                	int    $0x40
 49b:	c3                   	ret    

0000049c <sbrk>:
SYSCALL(sbrk)
 49c:	b8 0c 00 00 00       	mov    $0xc,%eax
 4a1:	cd 40                	int    $0x40
 4a3:	c3                   	ret    

000004a4 <sleep>:
SYSCALL(sleep)
 4a4:	b8 0d 00 00 00       	mov    $0xd,%eax
 4a9:	cd 40                	int    $0x40
 4ab:	c3                   	ret    

000004ac <uptime>:
SYSCALL(uptime)
 4ac:	b8 0e 00 00 00       	mov    $0xe,%eax
 4b1:	cd 40                	int    $0x40
 4b3:	c3                   	ret    

000004b4 <getpinfo>:
SYSCALL(getpinfo)
 4b4:	b8 16 00 00 00       	mov    $0x16,%eax
 4b9:	cd 40                	int    $0x40
 4bb:	c3                   	ret    

000004bc <settickets>:
SYSCALL(settickets)
 4bc:	b8 18 00 00 00       	mov    $0x18,%eax
 4c1:	cd 40                	int    $0x40
 4c3:	c3                   	ret    

000004c4 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4c4:	55                   	push   %ebp
 4c5:	89 e5                	mov    %esp,%ebp
 4c7:	83 ec 18             	sub    $0x18,%esp
 4ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 4cd:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4d0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4d7:	00 
 4d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4db:	89 44 24 04          	mov    %eax,0x4(%esp)
 4df:	8b 45 08             	mov    0x8(%ebp),%eax
 4e2:	89 04 24             	mov    %eax,(%esp)
 4e5:	e8 4a ff ff ff       	call   434 <write>
}
 4ea:	c9                   	leave  
 4eb:	c3                   	ret    

000004ec <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4ec:	55                   	push   %ebp
 4ed:	89 e5                	mov    %esp,%ebp
 4ef:	56                   	push   %esi
 4f0:	53                   	push   %ebx
 4f1:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4f4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4fb:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4ff:	74 17                	je     518 <printint+0x2c>
 501:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 505:	79 11                	jns    518 <printint+0x2c>
    neg = 1;
 507:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 50e:	8b 45 0c             	mov    0xc(%ebp),%eax
 511:	f7 d8                	neg    %eax
 513:	89 45 ec             	mov    %eax,-0x14(%ebp)
 516:	eb 06                	jmp    51e <printint+0x32>
  } else {
    x = xx;
 518:	8b 45 0c             	mov    0xc(%ebp),%eax
 51b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 51e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 525:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 528:	8d 41 01             	lea    0x1(%ecx),%eax
 52b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 52e:	8b 5d 10             	mov    0x10(%ebp),%ebx
 531:	8b 45 ec             	mov    -0x14(%ebp),%eax
 534:	ba 00 00 00 00       	mov    $0x0,%edx
 539:	f7 f3                	div    %ebx
 53b:	89 d0                	mov    %edx,%eax
 53d:	0f b6 80 48 0c 00 00 	movzbl 0xc48(%eax),%eax
 544:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 548:	8b 75 10             	mov    0x10(%ebp),%esi
 54b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 54e:	ba 00 00 00 00       	mov    $0x0,%edx
 553:	f7 f6                	div    %esi
 555:	89 45 ec             	mov    %eax,-0x14(%ebp)
 558:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 55c:	75 c7                	jne    525 <printint+0x39>
  if(neg)
 55e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 562:	74 10                	je     574 <printint+0x88>
    buf[i++] = '-';
 564:	8b 45 f4             	mov    -0xc(%ebp),%eax
 567:	8d 50 01             	lea    0x1(%eax),%edx
 56a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 56d:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 572:	eb 1f                	jmp    593 <printint+0xa7>
 574:	eb 1d                	jmp    593 <printint+0xa7>
    putc(fd, buf[i]);
 576:	8d 55 dc             	lea    -0x24(%ebp),%edx
 579:	8b 45 f4             	mov    -0xc(%ebp),%eax
 57c:	01 d0                	add    %edx,%eax
 57e:	0f b6 00             	movzbl (%eax),%eax
 581:	0f be c0             	movsbl %al,%eax
 584:	89 44 24 04          	mov    %eax,0x4(%esp)
 588:	8b 45 08             	mov    0x8(%ebp),%eax
 58b:	89 04 24             	mov    %eax,(%esp)
 58e:	e8 31 ff ff ff       	call   4c4 <putc>
  while(--i >= 0)
 593:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 597:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 59b:	79 d9                	jns    576 <printint+0x8a>
}
 59d:	83 c4 30             	add    $0x30,%esp
 5a0:	5b                   	pop    %ebx
 5a1:	5e                   	pop    %esi
 5a2:	5d                   	pop    %ebp
 5a3:	c3                   	ret    

000005a4 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5a4:	55                   	push   %ebp
 5a5:	89 e5                	mov    %esp,%ebp
 5a7:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 5aa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 5b1:	8d 45 0c             	lea    0xc(%ebp),%eax
 5b4:	83 c0 04             	add    $0x4,%eax
 5b7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5ba:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5c1:	e9 7c 01 00 00       	jmp    742 <printf+0x19e>
    c = fmt[i] & 0xff;
 5c6:	8b 55 0c             	mov    0xc(%ebp),%edx
 5c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5cc:	01 d0                	add    %edx,%eax
 5ce:	0f b6 00             	movzbl (%eax),%eax
 5d1:	0f be c0             	movsbl %al,%eax
 5d4:	25 ff 00 00 00       	and    $0xff,%eax
 5d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5dc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5e0:	75 2c                	jne    60e <printf+0x6a>
      if(c == '%'){
 5e2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5e6:	75 0c                	jne    5f4 <printf+0x50>
        state = '%';
 5e8:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5ef:	e9 4a 01 00 00       	jmp    73e <printf+0x19a>
      } else {
        putc(fd, c);
 5f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5f7:	0f be c0             	movsbl %al,%eax
 5fa:	89 44 24 04          	mov    %eax,0x4(%esp)
 5fe:	8b 45 08             	mov    0x8(%ebp),%eax
 601:	89 04 24             	mov    %eax,(%esp)
 604:	e8 bb fe ff ff       	call   4c4 <putc>
 609:	e9 30 01 00 00       	jmp    73e <printf+0x19a>
      }
    } else if(state == '%'){
 60e:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 612:	0f 85 26 01 00 00    	jne    73e <printf+0x19a>
      if(c == 'd'){
 618:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 61c:	75 2d                	jne    64b <printf+0xa7>
        printint(fd, *ap, 10, 1);
 61e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 621:	8b 00                	mov    (%eax),%eax
 623:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 62a:	00 
 62b:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 632:	00 
 633:	89 44 24 04          	mov    %eax,0x4(%esp)
 637:	8b 45 08             	mov    0x8(%ebp),%eax
 63a:	89 04 24             	mov    %eax,(%esp)
 63d:	e8 aa fe ff ff       	call   4ec <printint>
        ap++;
 642:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 646:	e9 ec 00 00 00       	jmp    737 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 64b:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 64f:	74 06                	je     657 <printf+0xb3>
 651:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 655:	75 2d                	jne    684 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 657:	8b 45 e8             	mov    -0x18(%ebp),%eax
 65a:	8b 00                	mov    (%eax),%eax
 65c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 663:	00 
 664:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 66b:	00 
 66c:	89 44 24 04          	mov    %eax,0x4(%esp)
 670:	8b 45 08             	mov    0x8(%ebp),%eax
 673:	89 04 24             	mov    %eax,(%esp)
 676:	e8 71 fe ff ff       	call   4ec <printint>
        ap++;
 67b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 67f:	e9 b3 00 00 00       	jmp    737 <printf+0x193>
      } else if(c == 's'){
 684:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 688:	75 45                	jne    6cf <printf+0x12b>
        s = (char*)*ap;
 68a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 68d:	8b 00                	mov    (%eax),%eax
 68f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 692:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 696:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 69a:	75 09                	jne    6a5 <printf+0x101>
          s = "(null)";
 69c:	c7 45 f4 cc 09 00 00 	movl   $0x9cc,-0xc(%ebp)
        while(*s != 0){
 6a3:	eb 1e                	jmp    6c3 <printf+0x11f>
 6a5:	eb 1c                	jmp    6c3 <printf+0x11f>
          putc(fd, *s);
 6a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6aa:	0f b6 00             	movzbl (%eax),%eax
 6ad:	0f be c0             	movsbl %al,%eax
 6b0:	89 44 24 04          	mov    %eax,0x4(%esp)
 6b4:	8b 45 08             	mov    0x8(%ebp),%eax
 6b7:	89 04 24             	mov    %eax,(%esp)
 6ba:	e8 05 fe ff ff       	call   4c4 <putc>
          s++;
 6bf:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 6c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6c6:	0f b6 00             	movzbl (%eax),%eax
 6c9:	84 c0                	test   %al,%al
 6cb:	75 da                	jne    6a7 <printf+0x103>
 6cd:	eb 68                	jmp    737 <printf+0x193>
        }
      } else if(c == 'c'){
 6cf:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6d3:	75 1d                	jne    6f2 <printf+0x14e>
        putc(fd, *ap);
 6d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6d8:	8b 00                	mov    (%eax),%eax
 6da:	0f be c0             	movsbl %al,%eax
 6dd:	89 44 24 04          	mov    %eax,0x4(%esp)
 6e1:	8b 45 08             	mov    0x8(%ebp),%eax
 6e4:	89 04 24             	mov    %eax,(%esp)
 6e7:	e8 d8 fd ff ff       	call   4c4 <putc>
        ap++;
 6ec:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6f0:	eb 45                	jmp    737 <printf+0x193>
      } else if(c == '%'){
 6f2:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6f6:	75 17                	jne    70f <printf+0x16b>
        putc(fd, c);
 6f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6fb:	0f be c0             	movsbl %al,%eax
 6fe:	89 44 24 04          	mov    %eax,0x4(%esp)
 702:	8b 45 08             	mov    0x8(%ebp),%eax
 705:	89 04 24             	mov    %eax,(%esp)
 708:	e8 b7 fd ff ff       	call   4c4 <putc>
 70d:	eb 28                	jmp    737 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 70f:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 716:	00 
 717:	8b 45 08             	mov    0x8(%ebp),%eax
 71a:	89 04 24             	mov    %eax,(%esp)
 71d:	e8 a2 fd ff ff       	call   4c4 <putc>
        putc(fd, c);
 722:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 725:	0f be c0             	movsbl %al,%eax
 728:	89 44 24 04          	mov    %eax,0x4(%esp)
 72c:	8b 45 08             	mov    0x8(%ebp),%eax
 72f:	89 04 24             	mov    %eax,(%esp)
 732:	e8 8d fd ff ff       	call   4c4 <putc>
      }
      state = 0;
 737:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 73e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 742:	8b 55 0c             	mov    0xc(%ebp),%edx
 745:	8b 45 f0             	mov    -0x10(%ebp),%eax
 748:	01 d0                	add    %edx,%eax
 74a:	0f b6 00             	movzbl (%eax),%eax
 74d:	84 c0                	test   %al,%al
 74f:	0f 85 71 fe ff ff    	jne    5c6 <printf+0x22>
    }
  }
}
 755:	c9                   	leave  
 756:	c3                   	ret    

00000757 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 757:	55                   	push   %ebp
 758:	89 e5                	mov    %esp,%ebp
 75a:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 75d:	8b 45 08             	mov    0x8(%ebp),%eax
 760:	83 e8 08             	sub    $0x8,%eax
 763:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 766:	a1 64 0c 00 00       	mov    0xc64,%eax
 76b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 76e:	eb 24                	jmp    794 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 770:	8b 45 fc             	mov    -0x4(%ebp),%eax
 773:	8b 00                	mov    (%eax),%eax
 775:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 778:	77 12                	ja     78c <free+0x35>
 77a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 780:	77 24                	ja     7a6 <free+0x4f>
 782:	8b 45 fc             	mov    -0x4(%ebp),%eax
 785:	8b 00                	mov    (%eax),%eax
 787:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 78a:	77 1a                	ja     7a6 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 78c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78f:	8b 00                	mov    (%eax),%eax
 791:	89 45 fc             	mov    %eax,-0x4(%ebp)
 794:	8b 45 f8             	mov    -0x8(%ebp),%eax
 797:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 79a:	76 d4                	jbe    770 <free+0x19>
 79c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79f:	8b 00                	mov    (%eax),%eax
 7a1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7a4:	76 ca                	jbe    770 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a9:	8b 40 04             	mov    0x4(%eax),%eax
 7ac:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7b3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b6:	01 c2                	add    %eax,%edx
 7b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bb:	8b 00                	mov    (%eax),%eax
 7bd:	39 c2                	cmp    %eax,%edx
 7bf:	75 24                	jne    7e5 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 7c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c4:	8b 50 04             	mov    0x4(%eax),%edx
 7c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ca:	8b 00                	mov    (%eax),%eax
 7cc:	8b 40 04             	mov    0x4(%eax),%eax
 7cf:	01 c2                	add    %eax,%edx
 7d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d4:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7da:	8b 00                	mov    (%eax),%eax
 7dc:	8b 10                	mov    (%eax),%edx
 7de:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7e1:	89 10                	mov    %edx,(%eax)
 7e3:	eb 0a                	jmp    7ef <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e8:	8b 10                	mov    (%eax),%edx
 7ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ed:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f2:	8b 40 04             	mov    0x4(%eax),%eax
 7f5:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ff:	01 d0                	add    %edx,%eax
 801:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 804:	75 20                	jne    826 <free+0xcf>
    p->s.size += bp->s.size;
 806:	8b 45 fc             	mov    -0x4(%ebp),%eax
 809:	8b 50 04             	mov    0x4(%eax),%edx
 80c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 80f:	8b 40 04             	mov    0x4(%eax),%eax
 812:	01 c2                	add    %eax,%edx
 814:	8b 45 fc             	mov    -0x4(%ebp),%eax
 817:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 81a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 81d:	8b 10                	mov    (%eax),%edx
 81f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 822:	89 10                	mov    %edx,(%eax)
 824:	eb 08                	jmp    82e <free+0xd7>
  } else
    p->s.ptr = bp;
 826:	8b 45 fc             	mov    -0x4(%ebp),%eax
 829:	8b 55 f8             	mov    -0x8(%ebp),%edx
 82c:	89 10                	mov    %edx,(%eax)
  freep = p;
 82e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 831:	a3 64 0c 00 00       	mov    %eax,0xc64
}
 836:	c9                   	leave  
 837:	c3                   	ret    

00000838 <morecore>:

static Header*
morecore(uint nu)
{
 838:	55                   	push   %ebp
 839:	89 e5                	mov    %esp,%ebp
 83b:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 83e:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 845:	77 07                	ja     84e <morecore+0x16>
    nu = 4096;
 847:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 84e:	8b 45 08             	mov    0x8(%ebp),%eax
 851:	c1 e0 03             	shl    $0x3,%eax
 854:	89 04 24             	mov    %eax,(%esp)
 857:	e8 40 fc ff ff       	call   49c <sbrk>
 85c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 85f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 863:	75 07                	jne    86c <morecore+0x34>
    return 0;
 865:	b8 00 00 00 00       	mov    $0x0,%eax
 86a:	eb 22                	jmp    88e <morecore+0x56>
  hp = (Header*)p;
 86c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 872:	8b 45 f0             	mov    -0x10(%ebp),%eax
 875:	8b 55 08             	mov    0x8(%ebp),%edx
 878:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 87b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 87e:	83 c0 08             	add    $0x8,%eax
 881:	89 04 24             	mov    %eax,(%esp)
 884:	e8 ce fe ff ff       	call   757 <free>
  return freep;
 889:	a1 64 0c 00 00       	mov    0xc64,%eax
}
 88e:	c9                   	leave  
 88f:	c3                   	ret    

00000890 <malloc>:

void*
malloc(uint nbytes)
{
 890:	55                   	push   %ebp
 891:	89 e5                	mov    %esp,%ebp
 893:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 896:	8b 45 08             	mov    0x8(%ebp),%eax
 899:	83 c0 07             	add    $0x7,%eax
 89c:	c1 e8 03             	shr    $0x3,%eax
 89f:	83 c0 01             	add    $0x1,%eax
 8a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 8a5:	a1 64 0c 00 00       	mov    0xc64,%eax
 8aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8ad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8b1:	75 23                	jne    8d6 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 8b3:	c7 45 f0 5c 0c 00 00 	movl   $0xc5c,-0x10(%ebp)
 8ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8bd:	a3 64 0c 00 00       	mov    %eax,0xc64
 8c2:	a1 64 0c 00 00       	mov    0xc64,%eax
 8c7:	a3 5c 0c 00 00       	mov    %eax,0xc5c
    base.s.size = 0;
 8cc:	c7 05 60 0c 00 00 00 	movl   $0x0,0xc60
 8d3:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d9:	8b 00                	mov    (%eax),%eax
 8db:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8de:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e1:	8b 40 04             	mov    0x4(%eax),%eax
 8e4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8e7:	72 4d                	jb     936 <malloc+0xa6>
      if(p->s.size == nunits)
 8e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ec:	8b 40 04             	mov    0x4(%eax),%eax
 8ef:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8f2:	75 0c                	jne    900 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f7:	8b 10                	mov    (%eax),%edx
 8f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8fc:	89 10                	mov    %edx,(%eax)
 8fe:	eb 26                	jmp    926 <malloc+0x96>
      else {
        p->s.size -= nunits;
 900:	8b 45 f4             	mov    -0xc(%ebp),%eax
 903:	8b 40 04             	mov    0x4(%eax),%eax
 906:	2b 45 ec             	sub    -0x14(%ebp),%eax
 909:	89 c2                	mov    %eax,%edx
 90b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90e:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 911:	8b 45 f4             	mov    -0xc(%ebp),%eax
 914:	8b 40 04             	mov    0x4(%eax),%eax
 917:	c1 e0 03             	shl    $0x3,%eax
 91a:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 91d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 920:	8b 55 ec             	mov    -0x14(%ebp),%edx
 923:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 926:	8b 45 f0             	mov    -0x10(%ebp),%eax
 929:	a3 64 0c 00 00       	mov    %eax,0xc64
      return (void*)(p + 1);
 92e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 931:	83 c0 08             	add    $0x8,%eax
 934:	eb 38                	jmp    96e <malloc+0xde>
    }
    if(p == freep)
 936:	a1 64 0c 00 00       	mov    0xc64,%eax
 93b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 93e:	75 1b                	jne    95b <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 940:	8b 45 ec             	mov    -0x14(%ebp),%eax
 943:	89 04 24             	mov    %eax,(%esp)
 946:	e8 ed fe ff ff       	call   838 <morecore>
 94b:	89 45 f4             	mov    %eax,-0xc(%ebp)
 94e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 952:	75 07                	jne    95b <malloc+0xcb>
        return 0;
 954:	b8 00 00 00 00       	mov    $0x0,%eax
 959:	eb 13                	jmp    96e <malloc+0xde>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 95b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 961:	8b 45 f4             	mov    -0xc(%ebp),%eax
 964:	8b 00                	mov    (%eax),%eax
 966:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 969:	e9 70 ff ff ff       	jmp    8de <malloc+0x4e>
}
 96e:	c9                   	leave  
 96f:	c3                   	ret    
