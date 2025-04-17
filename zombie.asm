
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp
  if(fork() > 0)
   9:	e8 92 03 00 00       	call   3a0 <fork>
   e:	85 c0                	test   %eax,%eax
  10:	7e 0c                	jle    1e <main+0x1e>
    sleep(5);  // Let child exit before parent.
  12:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  19:	e8 1a 04 00 00       	call   438 <sleep>
  exit();
  1e:	e8 85 03 00 00       	call   3a8 <exit>

00000023 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  23:	55                   	push   %ebp
  24:	89 e5                	mov    %esp,%ebp
  26:	57                   	push   %edi
  27:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  28:	8b 4d 08             	mov    0x8(%ebp),%ecx
  2b:	8b 55 10             	mov    0x10(%ebp),%edx
  2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  31:	89 cb                	mov    %ecx,%ebx
  33:	89 df                	mov    %ebx,%edi
  35:	89 d1                	mov    %edx,%ecx
  37:	fc                   	cld    
  38:	f3 aa                	rep stos %al,%es:(%edi)
  3a:	89 ca                	mov    %ecx,%edx
  3c:	89 fb                	mov    %edi,%ebx
  3e:	89 5d 08             	mov    %ebx,0x8(%ebp)
  41:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  44:	5b                   	pop    %ebx
  45:	5f                   	pop    %edi
  46:	5d                   	pop    %ebp
  47:	c3                   	ret    

00000048 <strcpy>:
#include "x86.h"
#include "pstat.h"

char*
strcpy(char *s, const char *t)
{
  48:	55                   	push   %ebp
  49:	89 e5                	mov    %esp,%ebp
  4b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  4e:	8b 45 08             	mov    0x8(%ebp),%eax
  51:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  54:	90                   	nop
  55:	8b 45 08             	mov    0x8(%ebp),%eax
  58:	8d 50 01             	lea    0x1(%eax),%edx
  5b:	89 55 08             	mov    %edx,0x8(%ebp)
  5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  61:	8d 4a 01             	lea    0x1(%edx),%ecx
  64:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  67:	0f b6 12             	movzbl (%edx),%edx
  6a:	88 10                	mov    %dl,(%eax)
  6c:	0f b6 00             	movzbl (%eax),%eax
  6f:	84 c0                	test   %al,%al
  71:	75 e2                	jne    55 <strcpy+0xd>
    ;
  return os;
  73:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  76:	c9                   	leave  
  77:	c3                   	ret    

00000078 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  78:	55                   	push   %ebp
  79:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  7b:	eb 08                	jmp    85 <strcmp+0xd>
    p++, q++;
  7d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  81:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
  85:	8b 45 08             	mov    0x8(%ebp),%eax
  88:	0f b6 00             	movzbl (%eax),%eax
  8b:	84 c0                	test   %al,%al
  8d:	74 10                	je     9f <strcmp+0x27>
  8f:	8b 45 08             	mov    0x8(%ebp),%eax
  92:	0f b6 10             	movzbl (%eax),%edx
  95:	8b 45 0c             	mov    0xc(%ebp),%eax
  98:	0f b6 00             	movzbl (%eax),%eax
  9b:	38 c2                	cmp    %al,%dl
  9d:	74 de                	je     7d <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
  9f:	8b 45 08             	mov    0x8(%ebp),%eax
  a2:	0f b6 00             	movzbl (%eax),%eax
  a5:	0f b6 d0             	movzbl %al,%edx
  a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  ab:	0f b6 00             	movzbl (%eax),%eax
  ae:	0f b6 c0             	movzbl %al,%eax
  b1:	29 c2                	sub    %eax,%edx
  b3:	89 d0                	mov    %edx,%eax
}
  b5:	5d                   	pop    %ebp
  b6:	c3                   	ret    

000000b7 <strlen>:

uint
strlen(const char *s)
{
  b7:	55                   	push   %ebp
  b8:	89 e5                	mov    %esp,%ebp
  ba:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
  bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  c4:	eb 04                	jmp    ca <strlen+0x13>
  c6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  ca:	8b 55 fc             	mov    -0x4(%ebp),%edx
  cd:	8b 45 08             	mov    0x8(%ebp),%eax
  d0:	01 d0                	add    %edx,%eax
  d2:	0f b6 00             	movzbl (%eax),%eax
  d5:	84 c0                	test   %al,%al
  d7:	75 ed                	jne    c6 <strlen+0xf>
    ;
  return n;
  d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  dc:	c9                   	leave  
  dd:	c3                   	ret    

000000de <memset>:

void*
memset(void *dst, int c, uint n)
{
  de:	55                   	push   %ebp
  df:	89 e5                	mov    %esp,%ebp
  e1:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
  e4:	8b 45 10             	mov    0x10(%ebp),%eax
  e7:	89 44 24 08          	mov    %eax,0x8(%esp)
  eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  f2:	8b 45 08             	mov    0x8(%ebp),%eax
  f5:	89 04 24             	mov    %eax,(%esp)
  f8:	e8 26 ff ff ff       	call   23 <stosb>
  return dst;
  fd:	8b 45 08             	mov    0x8(%ebp),%eax
}
 100:	c9                   	leave  
 101:	c3                   	ret    

00000102 <strchr>:

char*
strchr(const char *s, char c)
{
 102:	55                   	push   %ebp
 103:	89 e5                	mov    %esp,%ebp
 105:	83 ec 04             	sub    $0x4,%esp
 108:	8b 45 0c             	mov    0xc(%ebp),%eax
 10b:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 10e:	eb 14                	jmp    124 <strchr+0x22>
    if(*s == c)
 110:	8b 45 08             	mov    0x8(%ebp),%eax
 113:	0f b6 00             	movzbl (%eax),%eax
 116:	3a 45 fc             	cmp    -0x4(%ebp),%al
 119:	75 05                	jne    120 <strchr+0x1e>
      return (char*)s;
 11b:	8b 45 08             	mov    0x8(%ebp),%eax
 11e:	eb 13                	jmp    133 <strchr+0x31>
  for(; *s; s++)
 120:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 124:	8b 45 08             	mov    0x8(%ebp),%eax
 127:	0f b6 00             	movzbl (%eax),%eax
 12a:	84 c0                	test   %al,%al
 12c:	75 e2                	jne    110 <strchr+0xe>
  return 0;
 12e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 133:	c9                   	leave  
 134:	c3                   	ret    

00000135 <gets>:

char*
gets(char *buf, int max)
{
 135:	55                   	push   %ebp
 136:	89 e5                	mov    %esp,%ebp
 138:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 13b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 142:	eb 4c                	jmp    190 <gets+0x5b>
    cc = read(0, &c, 1);
 144:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 14b:	00 
 14c:	8d 45 ef             	lea    -0x11(%ebp),%eax
 14f:	89 44 24 04          	mov    %eax,0x4(%esp)
 153:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 15a:	e8 61 02 00 00       	call   3c0 <read>
 15f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 162:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 166:	7f 02                	jg     16a <gets+0x35>
      break;
 168:	eb 31                	jmp    19b <gets+0x66>
    buf[i++] = c;
 16a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 16d:	8d 50 01             	lea    0x1(%eax),%edx
 170:	89 55 f4             	mov    %edx,-0xc(%ebp)
 173:	89 c2                	mov    %eax,%edx
 175:	8b 45 08             	mov    0x8(%ebp),%eax
 178:	01 c2                	add    %eax,%edx
 17a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 17e:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 180:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 184:	3c 0a                	cmp    $0xa,%al
 186:	74 13                	je     19b <gets+0x66>
 188:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 18c:	3c 0d                	cmp    $0xd,%al
 18e:	74 0b                	je     19b <gets+0x66>
  for(i=0; i+1 < max; ){
 190:	8b 45 f4             	mov    -0xc(%ebp),%eax
 193:	83 c0 01             	add    $0x1,%eax
 196:	3b 45 0c             	cmp    0xc(%ebp),%eax
 199:	7c a9                	jl     144 <gets+0xf>
      break;
  }
  buf[i] = '\0';
 19b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 19e:	8b 45 08             	mov    0x8(%ebp),%eax
 1a1:	01 d0                	add    %edx,%eax
 1a3:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1a6:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1a9:	c9                   	leave  
 1aa:	c3                   	ret    

000001ab <stat>:

int
stat(const char *n, struct stat *st)
{
 1ab:	55                   	push   %ebp
 1ac:	89 e5                	mov    %esp,%ebp
 1ae:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1b1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1b8:	00 
 1b9:	8b 45 08             	mov    0x8(%ebp),%eax
 1bc:	89 04 24             	mov    %eax,(%esp)
 1bf:	e8 24 02 00 00       	call   3e8 <open>
 1c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 1c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1cb:	79 07                	jns    1d4 <stat+0x29>
    return -1;
 1cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1d2:	eb 23                	jmp    1f7 <stat+0x4c>
  r = fstat(fd, st);
 1d4:	8b 45 0c             	mov    0xc(%ebp),%eax
 1d7:	89 44 24 04          	mov    %eax,0x4(%esp)
 1db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1de:	89 04 24             	mov    %eax,(%esp)
 1e1:	e8 1a 02 00 00       	call   400 <fstat>
 1e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 1e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ec:	89 04 24             	mov    %eax,(%esp)
 1ef:	e8 dc 01 00 00       	call   3d0 <close>
  return r;
 1f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 1f7:	c9                   	leave  
 1f8:	c3                   	ret    

000001f9 <atoi>:

int
atoi(const char *s)
{
 1f9:	55                   	push   %ebp
 1fa:	89 e5                	mov    %esp,%ebp
 1fc:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 1ff:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 206:	eb 25                	jmp    22d <atoi+0x34>
    n = n*10 + *s++ - '0';
 208:	8b 55 fc             	mov    -0x4(%ebp),%edx
 20b:	89 d0                	mov    %edx,%eax
 20d:	c1 e0 02             	shl    $0x2,%eax
 210:	01 d0                	add    %edx,%eax
 212:	01 c0                	add    %eax,%eax
 214:	89 c1                	mov    %eax,%ecx
 216:	8b 45 08             	mov    0x8(%ebp),%eax
 219:	8d 50 01             	lea    0x1(%eax),%edx
 21c:	89 55 08             	mov    %edx,0x8(%ebp)
 21f:	0f b6 00             	movzbl (%eax),%eax
 222:	0f be c0             	movsbl %al,%eax
 225:	01 c8                	add    %ecx,%eax
 227:	83 e8 30             	sub    $0x30,%eax
 22a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 22d:	8b 45 08             	mov    0x8(%ebp),%eax
 230:	0f b6 00             	movzbl (%eax),%eax
 233:	3c 2f                	cmp    $0x2f,%al
 235:	7e 0a                	jle    241 <atoi+0x48>
 237:	8b 45 08             	mov    0x8(%ebp),%eax
 23a:	0f b6 00             	movzbl (%eax),%eax
 23d:	3c 39                	cmp    $0x39,%al
 23f:	7e c7                	jle    208 <atoi+0xf>
  return n;
 241:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 244:	c9                   	leave  
 245:	c3                   	ret    

00000246 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 246:	55                   	push   %ebp
 247:	89 e5                	mov    %esp,%ebp
 249:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 24c:	8b 45 08             	mov    0x8(%ebp),%eax
 24f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 252:	8b 45 0c             	mov    0xc(%ebp),%eax
 255:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 258:	eb 17                	jmp    271 <memmove+0x2b>
    *dst++ = *src++;
 25a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 25d:	8d 50 01             	lea    0x1(%eax),%edx
 260:	89 55 fc             	mov    %edx,-0x4(%ebp)
 263:	8b 55 f8             	mov    -0x8(%ebp),%edx
 266:	8d 4a 01             	lea    0x1(%edx),%ecx
 269:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 26c:	0f b6 12             	movzbl (%edx),%edx
 26f:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 271:	8b 45 10             	mov    0x10(%ebp),%eax
 274:	8d 50 ff             	lea    -0x1(%eax),%edx
 277:	89 55 10             	mov    %edx,0x10(%ebp)
 27a:	85 c0                	test   %eax,%eax
 27c:	7f dc                	jg     25a <memmove+0x14>
  return vdst;
 27e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 281:	c9                   	leave  
 282:	c3                   	ret    

00000283 <ps>:

void 
ps()
{
 283:	55                   	push   %ebp
 284:	89 e5                	mov    %esp,%ebp
 286:	57                   	push   %edi
 287:	56                   	push   %esi
 288:	53                   	push   %ebx
 289:	81 ec 3c 09 00 00    	sub    $0x93c,%esp
  pstatTable pTable;
  getpinfo(&pTable);
 28f:	8d 85 e4 f6 ff ff    	lea    -0x91c(%ebp),%eax
 295:	89 04 24             	mov    %eax,(%esp)
 298:	e8 ab 01 00 00       	call   448 <getpinfo>
  printf(1, "PID\tTKTS\tTCKS\tSTAT\tNAME\n");
 29d:	c7 44 24 04 04 09 00 	movl   $0x904,0x4(%esp)
 2a4:	00 
 2a5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2ac:	e8 87 02 00 00       	call   538 <printf>
  int i;
  for (i = 0; i < NPROC; i++)
 2b1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 2b8:	e9 ce 00 00 00       	jmp    38b <ps+0x108>
  {
    if(pTable[i].inuse)
 2bd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 2c0:	89 d0                	mov    %edx,%eax
 2c2:	c1 e0 03             	shl    $0x3,%eax
 2c5:	01 d0                	add    %edx,%eax
 2c7:	c1 e0 02             	shl    $0x2,%eax
 2ca:	8d 5d e8             	lea    -0x18(%ebp),%ebx
 2cd:	01 d8                	add    %ebx,%eax
 2cf:	2d 04 09 00 00       	sub    $0x904,%eax
 2d4:	8b 00                	mov    (%eax),%eax
 2d6:	85 c0                	test   %eax,%eax
 2d8:	0f 84 a9 00 00 00    	je     387 <ps+0x104>
      printf(1, "%d\t%d\t%d\t%c\t%s\n", pTable[i].pid, pTable[i].tickets, pTable[i].ticks, pTable[i].state, pTable[i].name);
 2de:	8d 8d e4 f6 ff ff    	lea    -0x91c(%ebp),%ecx
 2e4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 2e7:	89 d0                	mov    %edx,%eax
 2e9:	c1 e0 03             	shl    $0x3,%eax
 2ec:	01 d0                	add    %edx,%eax
 2ee:	c1 e0 02             	shl    $0x2,%eax
 2f1:	83 c0 10             	add    $0x10,%eax
 2f4:	8d 3c 01             	lea    (%ecx,%eax,1),%edi
 2f7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 2fa:	89 d0                	mov    %edx,%eax
 2fc:	c1 e0 03             	shl    $0x3,%eax
 2ff:	01 d0                	add    %edx,%eax
 301:	c1 e0 02             	shl    $0x2,%eax
 304:	8d 75 e8             	lea    -0x18(%ebp),%esi
 307:	01 f0                	add    %esi,%eax
 309:	2d e4 08 00 00       	sub    $0x8e4,%eax
 30e:	0f b6 00             	movzbl (%eax),%eax
 311:	0f be f0             	movsbl %al,%esi
 314:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 317:	89 d0                	mov    %edx,%eax
 319:	c1 e0 03             	shl    $0x3,%eax
 31c:	01 d0                	add    %edx,%eax
 31e:	c1 e0 02             	shl    $0x2,%eax
 321:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 324:	01 c8                	add    %ecx,%eax
 326:	2d f8 08 00 00       	sub    $0x8f8,%eax
 32b:	8b 18                	mov    (%eax),%ebx
 32d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 330:	89 d0                	mov    %edx,%eax
 332:	c1 e0 03             	shl    $0x3,%eax
 335:	01 d0                	add    %edx,%eax
 337:	c1 e0 02             	shl    $0x2,%eax
 33a:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 33d:	01 c8                	add    %ecx,%eax
 33f:	2d 00 09 00 00       	sub    $0x900,%eax
 344:	8b 08                	mov    (%eax),%ecx
 346:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 349:	89 d0                	mov    %edx,%eax
 34b:	c1 e0 03             	shl    $0x3,%eax
 34e:	01 d0                	add    %edx,%eax
 350:	c1 e0 02             	shl    $0x2,%eax
 353:	8d 55 e8             	lea    -0x18(%ebp),%edx
 356:	01 d0                	add    %edx,%eax
 358:	2d fc 08 00 00       	sub    $0x8fc,%eax
 35d:	8b 00                	mov    (%eax),%eax
 35f:	89 7c 24 18          	mov    %edi,0x18(%esp)
 363:	89 74 24 14          	mov    %esi,0x14(%esp)
 367:	89 5c 24 10          	mov    %ebx,0x10(%esp)
 36b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 36f:	89 44 24 08          	mov    %eax,0x8(%esp)
 373:	c7 44 24 04 1d 09 00 	movl   $0x91d,0x4(%esp)
 37a:	00 
 37b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 382:	e8 b1 01 00 00       	call   538 <printf>
  for (i = 0; i < NPROC; i++)
 387:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 38b:	83 7d e4 3f          	cmpl   $0x3f,-0x1c(%ebp)
 38f:	0f 8e 28 ff ff ff    	jle    2bd <ps+0x3a>
  }
}
 395:	81 c4 3c 09 00 00    	add    $0x93c,%esp
 39b:	5b                   	pop    %ebx
 39c:	5e                   	pop    %esi
 39d:	5f                   	pop    %edi
 39e:	5d                   	pop    %ebp
 39f:	c3                   	ret    

000003a0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3a0:	b8 01 00 00 00       	mov    $0x1,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <exit>:
SYSCALL(exit)
 3a8:	b8 02 00 00 00       	mov    $0x2,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <wait>:
SYSCALL(wait)
 3b0:	b8 03 00 00 00       	mov    $0x3,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <pipe>:
SYSCALL(pipe)
 3b8:	b8 04 00 00 00       	mov    $0x4,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <read>:
SYSCALL(read)
 3c0:	b8 05 00 00 00       	mov    $0x5,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <write>:
SYSCALL(write)
 3c8:	b8 10 00 00 00       	mov    $0x10,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <close>:
SYSCALL(close)
 3d0:	b8 15 00 00 00       	mov    $0x15,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <kill>:
SYSCALL(kill)
 3d8:	b8 06 00 00 00       	mov    $0x6,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <exec>:
SYSCALL(exec)
 3e0:	b8 07 00 00 00       	mov    $0x7,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <open>:
SYSCALL(open)
 3e8:	b8 0f 00 00 00       	mov    $0xf,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <mknod>:
SYSCALL(mknod)
 3f0:	b8 11 00 00 00       	mov    $0x11,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    

000003f8 <unlink>:
SYSCALL(unlink)
 3f8:	b8 12 00 00 00       	mov    $0x12,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <fstat>:
SYSCALL(fstat)
 400:	b8 08 00 00 00       	mov    $0x8,%eax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret    

00000408 <link>:
SYSCALL(link)
 408:	b8 13 00 00 00       	mov    $0x13,%eax
 40d:	cd 40                	int    $0x40
 40f:	c3                   	ret    

00000410 <mkdir>:
SYSCALL(mkdir)
 410:	b8 14 00 00 00       	mov    $0x14,%eax
 415:	cd 40                	int    $0x40
 417:	c3                   	ret    

00000418 <chdir>:
SYSCALL(chdir)
 418:	b8 09 00 00 00       	mov    $0x9,%eax
 41d:	cd 40                	int    $0x40
 41f:	c3                   	ret    

00000420 <dup>:
SYSCALL(dup)
 420:	b8 0a 00 00 00       	mov    $0xa,%eax
 425:	cd 40                	int    $0x40
 427:	c3                   	ret    

00000428 <getpid>:
SYSCALL(getpid)
 428:	b8 0b 00 00 00       	mov    $0xb,%eax
 42d:	cd 40                	int    $0x40
 42f:	c3                   	ret    

00000430 <sbrk>:
SYSCALL(sbrk)
 430:	b8 0c 00 00 00       	mov    $0xc,%eax
 435:	cd 40                	int    $0x40
 437:	c3                   	ret    

00000438 <sleep>:
SYSCALL(sleep)
 438:	b8 0d 00 00 00       	mov    $0xd,%eax
 43d:	cd 40                	int    $0x40
 43f:	c3                   	ret    

00000440 <uptime>:
SYSCALL(uptime)
 440:	b8 0e 00 00 00       	mov    $0xe,%eax
 445:	cd 40                	int    $0x40
 447:	c3                   	ret    

00000448 <getpinfo>:
SYSCALL(getpinfo)
 448:	b8 16 00 00 00       	mov    $0x16,%eax
 44d:	cd 40                	int    $0x40
 44f:	c3                   	ret    

00000450 <settickets>:
SYSCALL(settickets)
 450:	b8 18 00 00 00       	mov    $0x18,%eax
 455:	cd 40                	int    $0x40
 457:	c3                   	ret    

00000458 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 458:	55                   	push   %ebp
 459:	89 e5                	mov    %esp,%ebp
 45b:	83 ec 18             	sub    $0x18,%esp
 45e:	8b 45 0c             	mov    0xc(%ebp),%eax
 461:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 464:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 46b:	00 
 46c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 46f:	89 44 24 04          	mov    %eax,0x4(%esp)
 473:	8b 45 08             	mov    0x8(%ebp),%eax
 476:	89 04 24             	mov    %eax,(%esp)
 479:	e8 4a ff ff ff       	call   3c8 <write>
}
 47e:	c9                   	leave  
 47f:	c3                   	ret    

00000480 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 480:	55                   	push   %ebp
 481:	89 e5                	mov    %esp,%ebp
 483:	56                   	push   %esi
 484:	53                   	push   %ebx
 485:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 488:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 48f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 493:	74 17                	je     4ac <printint+0x2c>
 495:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 499:	79 11                	jns    4ac <printint+0x2c>
    neg = 1;
 49b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4a2:	8b 45 0c             	mov    0xc(%ebp),%eax
 4a5:	f7 d8                	neg    %eax
 4a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4aa:	eb 06                	jmp    4b2 <printint+0x32>
  } else {
    x = xx;
 4ac:	8b 45 0c             	mov    0xc(%ebp),%eax
 4af:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4b2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4b9:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 4bc:	8d 41 01             	lea    0x1(%ecx),%eax
 4bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
 4c2:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4c8:	ba 00 00 00 00       	mov    $0x0,%edx
 4cd:	f7 f3                	div    %ebx
 4cf:	89 d0                	mov    %edx,%eax
 4d1:	0f b6 80 a8 0b 00 00 	movzbl 0xba8(%eax),%eax
 4d8:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 4dc:	8b 75 10             	mov    0x10(%ebp),%esi
 4df:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4e2:	ba 00 00 00 00       	mov    $0x0,%edx
 4e7:	f7 f6                	div    %esi
 4e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4ec:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4f0:	75 c7                	jne    4b9 <printint+0x39>
  if(neg)
 4f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4f6:	74 10                	je     508 <printint+0x88>
    buf[i++] = '-';
 4f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4fb:	8d 50 01             	lea    0x1(%eax),%edx
 4fe:	89 55 f4             	mov    %edx,-0xc(%ebp)
 501:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 506:	eb 1f                	jmp    527 <printint+0xa7>
 508:	eb 1d                	jmp    527 <printint+0xa7>
    putc(fd, buf[i]);
 50a:	8d 55 dc             	lea    -0x24(%ebp),%edx
 50d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 510:	01 d0                	add    %edx,%eax
 512:	0f b6 00             	movzbl (%eax),%eax
 515:	0f be c0             	movsbl %al,%eax
 518:	89 44 24 04          	mov    %eax,0x4(%esp)
 51c:	8b 45 08             	mov    0x8(%ebp),%eax
 51f:	89 04 24             	mov    %eax,(%esp)
 522:	e8 31 ff ff ff       	call   458 <putc>
  while(--i >= 0)
 527:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 52b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 52f:	79 d9                	jns    50a <printint+0x8a>
}
 531:	83 c4 30             	add    $0x30,%esp
 534:	5b                   	pop    %ebx
 535:	5e                   	pop    %esi
 536:	5d                   	pop    %ebp
 537:	c3                   	ret    

00000538 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 538:	55                   	push   %ebp
 539:	89 e5                	mov    %esp,%ebp
 53b:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 53e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 545:	8d 45 0c             	lea    0xc(%ebp),%eax
 548:	83 c0 04             	add    $0x4,%eax
 54b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 54e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 555:	e9 7c 01 00 00       	jmp    6d6 <printf+0x19e>
    c = fmt[i] & 0xff;
 55a:	8b 55 0c             	mov    0xc(%ebp),%edx
 55d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 560:	01 d0                	add    %edx,%eax
 562:	0f b6 00             	movzbl (%eax),%eax
 565:	0f be c0             	movsbl %al,%eax
 568:	25 ff 00 00 00       	and    $0xff,%eax
 56d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 570:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 574:	75 2c                	jne    5a2 <printf+0x6a>
      if(c == '%'){
 576:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 57a:	75 0c                	jne    588 <printf+0x50>
        state = '%';
 57c:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 583:	e9 4a 01 00 00       	jmp    6d2 <printf+0x19a>
      } else {
        putc(fd, c);
 588:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 58b:	0f be c0             	movsbl %al,%eax
 58e:	89 44 24 04          	mov    %eax,0x4(%esp)
 592:	8b 45 08             	mov    0x8(%ebp),%eax
 595:	89 04 24             	mov    %eax,(%esp)
 598:	e8 bb fe ff ff       	call   458 <putc>
 59d:	e9 30 01 00 00       	jmp    6d2 <printf+0x19a>
      }
    } else if(state == '%'){
 5a2:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5a6:	0f 85 26 01 00 00    	jne    6d2 <printf+0x19a>
      if(c == 'd'){
 5ac:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5b0:	75 2d                	jne    5df <printf+0xa7>
        printint(fd, *ap, 10, 1);
 5b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5b5:	8b 00                	mov    (%eax),%eax
 5b7:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 5be:	00 
 5bf:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 5c6:	00 
 5c7:	89 44 24 04          	mov    %eax,0x4(%esp)
 5cb:	8b 45 08             	mov    0x8(%ebp),%eax
 5ce:	89 04 24             	mov    %eax,(%esp)
 5d1:	e8 aa fe ff ff       	call   480 <printint>
        ap++;
 5d6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5da:	e9 ec 00 00 00       	jmp    6cb <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 5df:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5e3:	74 06                	je     5eb <printf+0xb3>
 5e5:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5e9:	75 2d                	jne    618 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 5eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ee:	8b 00                	mov    (%eax),%eax
 5f0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5f7:	00 
 5f8:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5ff:	00 
 600:	89 44 24 04          	mov    %eax,0x4(%esp)
 604:	8b 45 08             	mov    0x8(%ebp),%eax
 607:	89 04 24             	mov    %eax,(%esp)
 60a:	e8 71 fe ff ff       	call   480 <printint>
        ap++;
 60f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 613:	e9 b3 00 00 00       	jmp    6cb <printf+0x193>
      } else if(c == 's'){
 618:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 61c:	75 45                	jne    663 <printf+0x12b>
        s = (char*)*ap;
 61e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 621:	8b 00                	mov    (%eax),%eax
 623:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 626:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 62a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 62e:	75 09                	jne    639 <printf+0x101>
          s = "(null)";
 630:	c7 45 f4 2d 09 00 00 	movl   $0x92d,-0xc(%ebp)
        while(*s != 0){
 637:	eb 1e                	jmp    657 <printf+0x11f>
 639:	eb 1c                	jmp    657 <printf+0x11f>
          putc(fd, *s);
 63b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 63e:	0f b6 00             	movzbl (%eax),%eax
 641:	0f be c0             	movsbl %al,%eax
 644:	89 44 24 04          	mov    %eax,0x4(%esp)
 648:	8b 45 08             	mov    0x8(%ebp),%eax
 64b:	89 04 24             	mov    %eax,(%esp)
 64e:	e8 05 fe ff ff       	call   458 <putc>
          s++;
 653:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 657:	8b 45 f4             	mov    -0xc(%ebp),%eax
 65a:	0f b6 00             	movzbl (%eax),%eax
 65d:	84 c0                	test   %al,%al
 65f:	75 da                	jne    63b <printf+0x103>
 661:	eb 68                	jmp    6cb <printf+0x193>
        }
      } else if(c == 'c'){
 663:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 667:	75 1d                	jne    686 <printf+0x14e>
        putc(fd, *ap);
 669:	8b 45 e8             	mov    -0x18(%ebp),%eax
 66c:	8b 00                	mov    (%eax),%eax
 66e:	0f be c0             	movsbl %al,%eax
 671:	89 44 24 04          	mov    %eax,0x4(%esp)
 675:	8b 45 08             	mov    0x8(%ebp),%eax
 678:	89 04 24             	mov    %eax,(%esp)
 67b:	e8 d8 fd ff ff       	call   458 <putc>
        ap++;
 680:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 684:	eb 45                	jmp    6cb <printf+0x193>
      } else if(c == '%'){
 686:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 68a:	75 17                	jne    6a3 <printf+0x16b>
        putc(fd, c);
 68c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 68f:	0f be c0             	movsbl %al,%eax
 692:	89 44 24 04          	mov    %eax,0x4(%esp)
 696:	8b 45 08             	mov    0x8(%ebp),%eax
 699:	89 04 24             	mov    %eax,(%esp)
 69c:	e8 b7 fd ff ff       	call   458 <putc>
 6a1:	eb 28                	jmp    6cb <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6a3:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 6aa:	00 
 6ab:	8b 45 08             	mov    0x8(%ebp),%eax
 6ae:	89 04 24             	mov    %eax,(%esp)
 6b1:	e8 a2 fd ff ff       	call   458 <putc>
        putc(fd, c);
 6b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6b9:	0f be c0             	movsbl %al,%eax
 6bc:	89 44 24 04          	mov    %eax,0x4(%esp)
 6c0:	8b 45 08             	mov    0x8(%ebp),%eax
 6c3:	89 04 24             	mov    %eax,(%esp)
 6c6:	e8 8d fd ff ff       	call   458 <putc>
      }
      state = 0;
 6cb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 6d2:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6d6:	8b 55 0c             	mov    0xc(%ebp),%edx
 6d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6dc:	01 d0                	add    %edx,%eax
 6de:	0f b6 00             	movzbl (%eax),%eax
 6e1:	84 c0                	test   %al,%al
 6e3:	0f 85 71 fe ff ff    	jne    55a <printf+0x22>
    }
  }
}
 6e9:	c9                   	leave  
 6ea:	c3                   	ret    

000006eb <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6eb:	55                   	push   %ebp
 6ec:	89 e5                	mov    %esp,%ebp
 6ee:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6f1:	8b 45 08             	mov    0x8(%ebp),%eax
 6f4:	83 e8 08             	sub    $0x8,%eax
 6f7:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6fa:	a1 c4 0b 00 00       	mov    0xbc4,%eax
 6ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
 702:	eb 24                	jmp    728 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 704:	8b 45 fc             	mov    -0x4(%ebp),%eax
 707:	8b 00                	mov    (%eax),%eax
 709:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 70c:	77 12                	ja     720 <free+0x35>
 70e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 711:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 714:	77 24                	ja     73a <free+0x4f>
 716:	8b 45 fc             	mov    -0x4(%ebp),%eax
 719:	8b 00                	mov    (%eax),%eax
 71b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 71e:	77 1a                	ja     73a <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 720:	8b 45 fc             	mov    -0x4(%ebp),%eax
 723:	8b 00                	mov    (%eax),%eax
 725:	89 45 fc             	mov    %eax,-0x4(%ebp)
 728:	8b 45 f8             	mov    -0x8(%ebp),%eax
 72b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 72e:	76 d4                	jbe    704 <free+0x19>
 730:	8b 45 fc             	mov    -0x4(%ebp),%eax
 733:	8b 00                	mov    (%eax),%eax
 735:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 738:	76 ca                	jbe    704 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 73a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73d:	8b 40 04             	mov    0x4(%eax),%eax
 740:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 747:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74a:	01 c2                	add    %eax,%edx
 74c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74f:	8b 00                	mov    (%eax),%eax
 751:	39 c2                	cmp    %eax,%edx
 753:	75 24                	jne    779 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 755:	8b 45 f8             	mov    -0x8(%ebp),%eax
 758:	8b 50 04             	mov    0x4(%eax),%edx
 75b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75e:	8b 00                	mov    (%eax),%eax
 760:	8b 40 04             	mov    0x4(%eax),%eax
 763:	01 c2                	add    %eax,%edx
 765:	8b 45 f8             	mov    -0x8(%ebp),%eax
 768:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 76b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76e:	8b 00                	mov    (%eax),%eax
 770:	8b 10                	mov    (%eax),%edx
 772:	8b 45 f8             	mov    -0x8(%ebp),%eax
 775:	89 10                	mov    %edx,(%eax)
 777:	eb 0a                	jmp    783 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 779:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77c:	8b 10                	mov    (%eax),%edx
 77e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 781:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 783:	8b 45 fc             	mov    -0x4(%ebp),%eax
 786:	8b 40 04             	mov    0x4(%eax),%eax
 789:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 790:	8b 45 fc             	mov    -0x4(%ebp),%eax
 793:	01 d0                	add    %edx,%eax
 795:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 798:	75 20                	jne    7ba <free+0xcf>
    p->s.size += bp->s.size;
 79a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79d:	8b 50 04             	mov    0x4(%eax),%edx
 7a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a3:	8b 40 04             	mov    0x4(%eax),%eax
 7a6:	01 c2                	add    %eax,%edx
 7a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ab:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b1:	8b 10                	mov    (%eax),%edx
 7b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b6:	89 10                	mov    %edx,(%eax)
 7b8:	eb 08                	jmp    7c2 <free+0xd7>
  } else
    p->s.ptr = bp;
 7ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7bd:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7c0:	89 10                	mov    %edx,(%eax)
  freep = p;
 7c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c5:	a3 c4 0b 00 00       	mov    %eax,0xbc4
}
 7ca:	c9                   	leave  
 7cb:	c3                   	ret    

000007cc <morecore>:

static Header*
morecore(uint nu)
{
 7cc:	55                   	push   %ebp
 7cd:	89 e5                	mov    %esp,%ebp
 7cf:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7d2:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7d9:	77 07                	ja     7e2 <morecore+0x16>
    nu = 4096;
 7db:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7e2:	8b 45 08             	mov    0x8(%ebp),%eax
 7e5:	c1 e0 03             	shl    $0x3,%eax
 7e8:	89 04 24             	mov    %eax,(%esp)
 7eb:	e8 40 fc ff ff       	call   430 <sbrk>
 7f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7f3:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7f7:	75 07                	jne    800 <morecore+0x34>
    return 0;
 7f9:	b8 00 00 00 00       	mov    $0x0,%eax
 7fe:	eb 22                	jmp    822 <morecore+0x56>
  hp = (Header*)p;
 800:	8b 45 f4             	mov    -0xc(%ebp),%eax
 803:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 806:	8b 45 f0             	mov    -0x10(%ebp),%eax
 809:	8b 55 08             	mov    0x8(%ebp),%edx
 80c:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 80f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 812:	83 c0 08             	add    $0x8,%eax
 815:	89 04 24             	mov    %eax,(%esp)
 818:	e8 ce fe ff ff       	call   6eb <free>
  return freep;
 81d:	a1 c4 0b 00 00       	mov    0xbc4,%eax
}
 822:	c9                   	leave  
 823:	c3                   	ret    

00000824 <malloc>:

void*
malloc(uint nbytes)
{
 824:	55                   	push   %ebp
 825:	89 e5                	mov    %esp,%ebp
 827:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 82a:	8b 45 08             	mov    0x8(%ebp),%eax
 82d:	83 c0 07             	add    $0x7,%eax
 830:	c1 e8 03             	shr    $0x3,%eax
 833:	83 c0 01             	add    $0x1,%eax
 836:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 839:	a1 c4 0b 00 00       	mov    0xbc4,%eax
 83e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 841:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 845:	75 23                	jne    86a <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 847:	c7 45 f0 bc 0b 00 00 	movl   $0xbbc,-0x10(%ebp)
 84e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 851:	a3 c4 0b 00 00       	mov    %eax,0xbc4
 856:	a1 c4 0b 00 00       	mov    0xbc4,%eax
 85b:	a3 bc 0b 00 00       	mov    %eax,0xbbc
    base.s.size = 0;
 860:	c7 05 c0 0b 00 00 00 	movl   $0x0,0xbc0
 867:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 86a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 86d:	8b 00                	mov    (%eax),%eax
 86f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 872:	8b 45 f4             	mov    -0xc(%ebp),%eax
 875:	8b 40 04             	mov    0x4(%eax),%eax
 878:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 87b:	72 4d                	jb     8ca <malloc+0xa6>
      if(p->s.size == nunits)
 87d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 880:	8b 40 04             	mov    0x4(%eax),%eax
 883:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 886:	75 0c                	jne    894 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 888:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88b:	8b 10                	mov    (%eax),%edx
 88d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 890:	89 10                	mov    %edx,(%eax)
 892:	eb 26                	jmp    8ba <malloc+0x96>
      else {
        p->s.size -= nunits;
 894:	8b 45 f4             	mov    -0xc(%ebp),%eax
 897:	8b 40 04             	mov    0x4(%eax),%eax
 89a:	2b 45 ec             	sub    -0x14(%ebp),%eax
 89d:	89 c2                	mov    %eax,%edx
 89f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a2:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a8:	8b 40 04             	mov    0x4(%eax),%eax
 8ab:	c1 e0 03             	shl    $0x3,%eax
 8ae:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b4:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8b7:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8bd:	a3 c4 0b 00 00       	mov    %eax,0xbc4
      return (void*)(p + 1);
 8c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c5:	83 c0 08             	add    $0x8,%eax
 8c8:	eb 38                	jmp    902 <malloc+0xde>
    }
    if(p == freep)
 8ca:	a1 c4 0b 00 00       	mov    0xbc4,%eax
 8cf:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8d2:	75 1b                	jne    8ef <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 8d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8d7:	89 04 24             	mov    %eax,(%esp)
 8da:	e8 ed fe ff ff       	call   7cc <morecore>
 8df:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8e6:	75 07                	jne    8ef <malloc+0xcb>
        return 0;
 8e8:	b8 00 00 00 00       	mov    $0x0,%eax
 8ed:	eb 13                	jmp    902 <malloc+0xde>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f8:	8b 00                	mov    (%eax),%eax
 8fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 8fd:	e9 70 ff ff ff       	jmp    872 <malloc+0x4e>
}
 902:	c9                   	leave  
 903:	c3                   	ret    
