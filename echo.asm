
_echo:     file format elf32-i386


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

  for(i = 1; i < argc; i++)
   9:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  10:	00 
  11:	eb 4b                	jmp    5e <main+0x5e>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  13:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  17:	83 c0 01             	add    $0x1,%eax
  1a:	3b 45 08             	cmp    0x8(%ebp),%eax
  1d:	7d 07                	jge    26 <main+0x26>
  1f:	b8 4d 09 00 00       	mov    $0x94d,%eax
  24:	eb 05                	jmp    2b <main+0x2b>
  26:	b8 4f 09 00 00       	mov    $0x94f,%eax
  2b:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  2f:	8d 0c 95 00 00 00 00 	lea    0x0(,%edx,4),%ecx
  36:	8b 55 0c             	mov    0xc(%ebp),%edx
  39:	01 ca                	add    %ecx,%edx
  3b:	8b 12                	mov    (%edx),%edx
  3d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  41:	89 54 24 08          	mov    %edx,0x8(%esp)
  45:	c7 44 24 04 51 09 00 	movl   $0x951,0x4(%esp)
  4c:	00 
  4d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  54:	e8 28 05 00 00       	call   581 <printf>
  for(i = 1; i < argc; i++)
  59:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  5e:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  62:	3b 45 08             	cmp    0x8(%ebp),%eax
  65:	7c ac                	jl     13 <main+0x13>
  exit();
  67:	e8 85 03 00 00       	call   3f1 <exit>

0000006c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  6c:	55                   	push   %ebp
  6d:	89 e5                	mov    %esp,%ebp
  6f:	57                   	push   %edi
  70:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  71:	8b 4d 08             	mov    0x8(%ebp),%ecx
  74:	8b 55 10             	mov    0x10(%ebp),%edx
  77:	8b 45 0c             	mov    0xc(%ebp),%eax
  7a:	89 cb                	mov    %ecx,%ebx
  7c:	89 df                	mov    %ebx,%edi
  7e:	89 d1                	mov    %edx,%ecx
  80:	fc                   	cld    
  81:	f3 aa                	rep stos %al,%es:(%edi)
  83:	89 ca                	mov    %ecx,%edx
  85:	89 fb                	mov    %edi,%ebx
  87:	89 5d 08             	mov    %ebx,0x8(%ebp)
  8a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  8d:	5b                   	pop    %ebx
  8e:	5f                   	pop    %edi
  8f:	5d                   	pop    %ebp
  90:	c3                   	ret    

00000091 <strcpy>:
#include "x86.h"
#include "pstat.h"

char*
strcpy(char *s, const char *t)
{
  91:	55                   	push   %ebp
  92:	89 e5                	mov    %esp,%ebp
  94:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  97:	8b 45 08             	mov    0x8(%ebp),%eax
  9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  9d:	90                   	nop
  9e:	8b 45 08             	mov    0x8(%ebp),%eax
  a1:	8d 50 01             	lea    0x1(%eax),%edx
  a4:	89 55 08             	mov    %edx,0x8(%ebp)
  a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  aa:	8d 4a 01             	lea    0x1(%edx),%ecx
  ad:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  b0:	0f b6 12             	movzbl (%edx),%edx
  b3:	88 10                	mov    %dl,(%eax)
  b5:	0f b6 00             	movzbl (%eax),%eax
  b8:	84 c0                	test   %al,%al
  ba:	75 e2                	jne    9e <strcpy+0xd>
    ;
  return os;
  bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  bf:	c9                   	leave  
  c0:	c3                   	ret    

000000c1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c1:	55                   	push   %ebp
  c2:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  c4:	eb 08                	jmp    ce <strcmp+0xd>
    p++, q++;
  c6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  ca:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
  ce:	8b 45 08             	mov    0x8(%ebp),%eax
  d1:	0f b6 00             	movzbl (%eax),%eax
  d4:	84 c0                	test   %al,%al
  d6:	74 10                	je     e8 <strcmp+0x27>
  d8:	8b 45 08             	mov    0x8(%ebp),%eax
  db:	0f b6 10             	movzbl (%eax),%edx
  de:	8b 45 0c             	mov    0xc(%ebp),%eax
  e1:	0f b6 00             	movzbl (%eax),%eax
  e4:	38 c2                	cmp    %al,%dl
  e6:	74 de                	je     c6 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
  e8:	8b 45 08             	mov    0x8(%ebp),%eax
  eb:	0f b6 00             	movzbl (%eax),%eax
  ee:	0f b6 d0             	movzbl %al,%edx
  f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  f4:	0f b6 00             	movzbl (%eax),%eax
  f7:	0f b6 c0             	movzbl %al,%eax
  fa:	29 c2                	sub    %eax,%edx
  fc:	89 d0                	mov    %edx,%eax
}
  fe:	5d                   	pop    %ebp
  ff:	c3                   	ret    

00000100 <strlen>:

uint
strlen(const char *s)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 106:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 10d:	eb 04                	jmp    113 <strlen+0x13>
 10f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 113:	8b 55 fc             	mov    -0x4(%ebp),%edx
 116:	8b 45 08             	mov    0x8(%ebp),%eax
 119:	01 d0                	add    %edx,%eax
 11b:	0f b6 00             	movzbl (%eax),%eax
 11e:	84 c0                	test   %al,%al
 120:	75 ed                	jne    10f <strlen+0xf>
    ;
  return n;
 122:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 125:	c9                   	leave  
 126:	c3                   	ret    

00000127 <memset>:

void*
memset(void *dst, int c, uint n)
{
 127:	55                   	push   %ebp
 128:	89 e5                	mov    %esp,%ebp
 12a:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 12d:	8b 45 10             	mov    0x10(%ebp),%eax
 130:	89 44 24 08          	mov    %eax,0x8(%esp)
 134:	8b 45 0c             	mov    0xc(%ebp),%eax
 137:	89 44 24 04          	mov    %eax,0x4(%esp)
 13b:	8b 45 08             	mov    0x8(%ebp),%eax
 13e:	89 04 24             	mov    %eax,(%esp)
 141:	e8 26 ff ff ff       	call   6c <stosb>
  return dst;
 146:	8b 45 08             	mov    0x8(%ebp),%eax
}
 149:	c9                   	leave  
 14a:	c3                   	ret    

0000014b <strchr>:

char*
strchr(const char *s, char c)
{
 14b:	55                   	push   %ebp
 14c:	89 e5                	mov    %esp,%ebp
 14e:	83 ec 04             	sub    $0x4,%esp
 151:	8b 45 0c             	mov    0xc(%ebp),%eax
 154:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 157:	eb 14                	jmp    16d <strchr+0x22>
    if(*s == c)
 159:	8b 45 08             	mov    0x8(%ebp),%eax
 15c:	0f b6 00             	movzbl (%eax),%eax
 15f:	3a 45 fc             	cmp    -0x4(%ebp),%al
 162:	75 05                	jne    169 <strchr+0x1e>
      return (char*)s;
 164:	8b 45 08             	mov    0x8(%ebp),%eax
 167:	eb 13                	jmp    17c <strchr+0x31>
  for(; *s; s++)
 169:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16d:	8b 45 08             	mov    0x8(%ebp),%eax
 170:	0f b6 00             	movzbl (%eax),%eax
 173:	84 c0                	test   %al,%al
 175:	75 e2                	jne    159 <strchr+0xe>
  return 0;
 177:	b8 00 00 00 00       	mov    $0x0,%eax
}
 17c:	c9                   	leave  
 17d:	c3                   	ret    

0000017e <gets>:

char*
gets(char *buf, int max)
{
 17e:	55                   	push   %ebp
 17f:	89 e5                	mov    %esp,%ebp
 181:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 184:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 18b:	eb 4c                	jmp    1d9 <gets+0x5b>
    cc = read(0, &c, 1);
 18d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 194:	00 
 195:	8d 45 ef             	lea    -0x11(%ebp),%eax
 198:	89 44 24 04          	mov    %eax,0x4(%esp)
 19c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1a3:	e8 61 02 00 00       	call   409 <read>
 1a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1af:	7f 02                	jg     1b3 <gets+0x35>
      break;
 1b1:	eb 31                	jmp    1e4 <gets+0x66>
    buf[i++] = c;
 1b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1b6:	8d 50 01             	lea    0x1(%eax),%edx
 1b9:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1bc:	89 c2                	mov    %eax,%edx
 1be:	8b 45 08             	mov    0x8(%ebp),%eax
 1c1:	01 c2                	add    %eax,%edx
 1c3:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c7:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1c9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1cd:	3c 0a                	cmp    $0xa,%al
 1cf:	74 13                	je     1e4 <gets+0x66>
 1d1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d5:	3c 0d                	cmp    $0xd,%al
 1d7:	74 0b                	je     1e4 <gets+0x66>
  for(i=0; i+1 < max; ){
 1d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1dc:	83 c0 01             	add    $0x1,%eax
 1df:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1e2:	7c a9                	jl     18d <gets+0xf>
      break;
  }
  buf[i] = '\0';
 1e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1e7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ea:	01 d0                	add    %edx,%eax
 1ec:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1ef:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1f2:	c9                   	leave  
 1f3:	c3                   	ret    

000001f4 <stat>:

int
stat(const char *n, struct stat *st)
{
 1f4:	55                   	push   %ebp
 1f5:	89 e5                	mov    %esp,%ebp
 1f7:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1fa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 201:	00 
 202:	8b 45 08             	mov    0x8(%ebp),%eax
 205:	89 04 24             	mov    %eax,(%esp)
 208:	e8 24 02 00 00       	call   431 <open>
 20d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 210:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 214:	79 07                	jns    21d <stat+0x29>
    return -1;
 216:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 21b:	eb 23                	jmp    240 <stat+0x4c>
  r = fstat(fd, st);
 21d:	8b 45 0c             	mov    0xc(%ebp),%eax
 220:	89 44 24 04          	mov    %eax,0x4(%esp)
 224:	8b 45 f4             	mov    -0xc(%ebp),%eax
 227:	89 04 24             	mov    %eax,(%esp)
 22a:	e8 1a 02 00 00       	call   449 <fstat>
 22f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 232:	8b 45 f4             	mov    -0xc(%ebp),%eax
 235:	89 04 24             	mov    %eax,(%esp)
 238:	e8 dc 01 00 00       	call   419 <close>
  return r;
 23d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 240:	c9                   	leave  
 241:	c3                   	ret    

00000242 <atoi>:

int
atoi(const char *s)
{
 242:	55                   	push   %ebp
 243:	89 e5                	mov    %esp,%ebp
 245:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 248:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 24f:	eb 25                	jmp    276 <atoi+0x34>
    n = n*10 + *s++ - '0';
 251:	8b 55 fc             	mov    -0x4(%ebp),%edx
 254:	89 d0                	mov    %edx,%eax
 256:	c1 e0 02             	shl    $0x2,%eax
 259:	01 d0                	add    %edx,%eax
 25b:	01 c0                	add    %eax,%eax
 25d:	89 c1                	mov    %eax,%ecx
 25f:	8b 45 08             	mov    0x8(%ebp),%eax
 262:	8d 50 01             	lea    0x1(%eax),%edx
 265:	89 55 08             	mov    %edx,0x8(%ebp)
 268:	0f b6 00             	movzbl (%eax),%eax
 26b:	0f be c0             	movsbl %al,%eax
 26e:	01 c8                	add    %ecx,%eax
 270:	83 e8 30             	sub    $0x30,%eax
 273:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 276:	8b 45 08             	mov    0x8(%ebp),%eax
 279:	0f b6 00             	movzbl (%eax),%eax
 27c:	3c 2f                	cmp    $0x2f,%al
 27e:	7e 0a                	jle    28a <atoi+0x48>
 280:	8b 45 08             	mov    0x8(%ebp),%eax
 283:	0f b6 00             	movzbl (%eax),%eax
 286:	3c 39                	cmp    $0x39,%al
 288:	7e c7                	jle    251 <atoi+0xf>
  return n;
 28a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 28d:	c9                   	leave  
 28e:	c3                   	ret    

0000028f <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 28f:	55                   	push   %ebp
 290:	89 e5                	mov    %esp,%ebp
 292:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 295:	8b 45 08             	mov    0x8(%ebp),%eax
 298:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 29b:	8b 45 0c             	mov    0xc(%ebp),%eax
 29e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2a1:	eb 17                	jmp    2ba <memmove+0x2b>
    *dst++ = *src++;
 2a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2a6:	8d 50 01             	lea    0x1(%eax),%edx
 2a9:	89 55 fc             	mov    %edx,-0x4(%ebp)
 2ac:	8b 55 f8             	mov    -0x8(%ebp),%edx
 2af:	8d 4a 01             	lea    0x1(%edx),%ecx
 2b2:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 2b5:	0f b6 12             	movzbl (%edx),%edx
 2b8:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 2ba:	8b 45 10             	mov    0x10(%ebp),%eax
 2bd:	8d 50 ff             	lea    -0x1(%eax),%edx
 2c0:	89 55 10             	mov    %edx,0x10(%ebp)
 2c3:	85 c0                	test   %eax,%eax
 2c5:	7f dc                	jg     2a3 <memmove+0x14>
  return vdst;
 2c7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2ca:	c9                   	leave  
 2cb:	c3                   	ret    

000002cc <ps>:

void 
ps()
{
 2cc:	55                   	push   %ebp
 2cd:	89 e5                	mov    %esp,%ebp
 2cf:	57                   	push   %edi
 2d0:	56                   	push   %esi
 2d1:	53                   	push   %ebx
 2d2:	81 ec 3c 09 00 00    	sub    $0x93c,%esp
  pstatTable pTable;
  getpinfo(&pTable);
 2d8:	8d 85 e4 f6 ff ff    	lea    -0x91c(%ebp),%eax
 2de:	89 04 24             	mov    %eax,(%esp)
 2e1:	e8 ab 01 00 00       	call   491 <getpinfo>
  printf(1, "PID\tTKTS\tTCKS\tSTAT\tNAME\n");
 2e6:	c7 44 24 04 56 09 00 	movl   $0x956,0x4(%esp)
 2ed:	00 
 2ee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2f5:	e8 87 02 00 00       	call   581 <printf>
  int i;
  for (i = 0; i < NPROC; i++)
 2fa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 301:	e9 ce 00 00 00       	jmp    3d4 <ps+0x108>
  {
    if(pTable[i].inuse)
 306:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 309:	89 d0                	mov    %edx,%eax
 30b:	c1 e0 03             	shl    $0x3,%eax
 30e:	01 d0                	add    %edx,%eax
 310:	c1 e0 02             	shl    $0x2,%eax
 313:	8d 5d e8             	lea    -0x18(%ebp),%ebx
 316:	01 d8                	add    %ebx,%eax
 318:	2d 04 09 00 00       	sub    $0x904,%eax
 31d:	8b 00                	mov    (%eax),%eax
 31f:	85 c0                	test   %eax,%eax
 321:	0f 84 a9 00 00 00    	je     3d0 <ps+0x104>
      printf(1, "%d\t%d\t%d\t%c\t%s\n", pTable[i].pid, pTable[i].tickets, pTable[i].ticks, pTable[i].state, pTable[i].name);
 327:	8d 8d e4 f6 ff ff    	lea    -0x91c(%ebp),%ecx
 32d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 330:	89 d0                	mov    %edx,%eax
 332:	c1 e0 03             	shl    $0x3,%eax
 335:	01 d0                	add    %edx,%eax
 337:	c1 e0 02             	shl    $0x2,%eax
 33a:	83 c0 10             	add    $0x10,%eax
 33d:	8d 3c 01             	lea    (%ecx,%eax,1),%edi
 340:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 343:	89 d0                	mov    %edx,%eax
 345:	c1 e0 03             	shl    $0x3,%eax
 348:	01 d0                	add    %edx,%eax
 34a:	c1 e0 02             	shl    $0x2,%eax
 34d:	8d 75 e8             	lea    -0x18(%ebp),%esi
 350:	01 f0                	add    %esi,%eax
 352:	2d e4 08 00 00       	sub    $0x8e4,%eax
 357:	0f b6 00             	movzbl (%eax),%eax
 35a:	0f be f0             	movsbl %al,%esi
 35d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 360:	89 d0                	mov    %edx,%eax
 362:	c1 e0 03             	shl    $0x3,%eax
 365:	01 d0                	add    %edx,%eax
 367:	c1 e0 02             	shl    $0x2,%eax
 36a:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 36d:	01 c8                	add    %ecx,%eax
 36f:	2d f8 08 00 00       	sub    $0x8f8,%eax
 374:	8b 18                	mov    (%eax),%ebx
 376:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 379:	89 d0                	mov    %edx,%eax
 37b:	c1 e0 03             	shl    $0x3,%eax
 37e:	01 d0                	add    %edx,%eax
 380:	c1 e0 02             	shl    $0x2,%eax
 383:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 386:	01 c8                	add    %ecx,%eax
 388:	2d 00 09 00 00       	sub    $0x900,%eax
 38d:	8b 08                	mov    (%eax),%ecx
 38f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 392:	89 d0                	mov    %edx,%eax
 394:	c1 e0 03             	shl    $0x3,%eax
 397:	01 d0                	add    %edx,%eax
 399:	c1 e0 02             	shl    $0x2,%eax
 39c:	8d 55 e8             	lea    -0x18(%ebp),%edx
 39f:	01 d0                	add    %edx,%eax
 3a1:	2d fc 08 00 00       	sub    $0x8fc,%eax
 3a6:	8b 00                	mov    (%eax),%eax
 3a8:	89 7c 24 18          	mov    %edi,0x18(%esp)
 3ac:	89 74 24 14          	mov    %esi,0x14(%esp)
 3b0:	89 5c 24 10          	mov    %ebx,0x10(%esp)
 3b4:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 3b8:	89 44 24 08          	mov    %eax,0x8(%esp)
 3bc:	c7 44 24 04 6f 09 00 	movl   $0x96f,0x4(%esp)
 3c3:	00 
 3c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 3cb:	e8 b1 01 00 00       	call   581 <printf>
  for (i = 0; i < NPROC; i++)
 3d0:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 3d4:	83 7d e4 3f          	cmpl   $0x3f,-0x1c(%ebp)
 3d8:	0f 8e 28 ff ff ff    	jle    306 <ps+0x3a>
  }
}
 3de:	81 c4 3c 09 00 00    	add    $0x93c,%esp
 3e4:	5b                   	pop    %ebx
 3e5:	5e                   	pop    %esi
 3e6:	5f                   	pop    %edi
 3e7:	5d                   	pop    %ebp
 3e8:	c3                   	ret    

000003e9 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3e9:	b8 01 00 00 00       	mov    $0x1,%eax
 3ee:	cd 40                	int    $0x40
 3f0:	c3                   	ret    

000003f1 <exit>:
SYSCALL(exit)
 3f1:	b8 02 00 00 00       	mov    $0x2,%eax
 3f6:	cd 40                	int    $0x40
 3f8:	c3                   	ret    

000003f9 <wait>:
SYSCALL(wait)
 3f9:	b8 03 00 00 00       	mov    $0x3,%eax
 3fe:	cd 40                	int    $0x40
 400:	c3                   	ret    

00000401 <pipe>:
SYSCALL(pipe)
 401:	b8 04 00 00 00       	mov    $0x4,%eax
 406:	cd 40                	int    $0x40
 408:	c3                   	ret    

00000409 <read>:
SYSCALL(read)
 409:	b8 05 00 00 00       	mov    $0x5,%eax
 40e:	cd 40                	int    $0x40
 410:	c3                   	ret    

00000411 <write>:
SYSCALL(write)
 411:	b8 10 00 00 00       	mov    $0x10,%eax
 416:	cd 40                	int    $0x40
 418:	c3                   	ret    

00000419 <close>:
SYSCALL(close)
 419:	b8 15 00 00 00       	mov    $0x15,%eax
 41e:	cd 40                	int    $0x40
 420:	c3                   	ret    

00000421 <kill>:
SYSCALL(kill)
 421:	b8 06 00 00 00       	mov    $0x6,%eax
 426:	cd 40                	int    $0x40
 428:	c3                   	ret    

00000429 <exec>:
SYSCALL(exec)
 429:	b8 07 00 00 00       	mov    $0x7,%eax
 42e:	cd 40                	int    $0x40
 430:	c3                   	ret    

00000431 <open>:
SYSCALL(open)
 431:	b8 0f 00 00 00       	mov    $0xf,%eax
 436:	cd 40                	int    $0x40
 438:	c3                   	ret    

00000439 <mknod>:
SYSCALL(mknod)
 439:	b8 11 00 00 00       	mov    $0x11,%eax
 43e:	cd 40                	int    $0x40
 440:	c3                   	ret    

00000441 <unlink>:
SYSCALL(unlink)
 441:	b8 12 00 00 00       	mov    $0x12,%eax
 446:	cd 40                	int    $0x40
 448:	c3                   	ret    

00000449 <fstat>:
SYSCALL(fstat)
 449:	b8 08 00 00 00       	mov    $0x8,%eax
 44e:	cd 40                	int    $0x40
 450:	c3                   	ret    

00000451 <link>:
SYSCALL(link)
 451:	b8 13 00 00 00       	mov    $0x13,%eax
 456:	cd 40                	int    $0x40
 458:	c3                   	ret    

00000459 <mkdir>:
SYSCALL(mkdir)
 459:	b8 14 00 00 00       	mov    $0x14,%eax
 45e:	cd 40                	int    $0x40
 460:	c3                   	ret    

00000461 <chdir>:
SYSCALL(chdir)
 461:	b8 09 00 00 00       	mov    $0x9,%eax
 466:	cd 40                	int    $0x40
 468:	c3                   	ret    

00000469 <dup>:
SYSCALL(dup)
 469:	b8 0a 00 00 00       	mov    $0xa,%eax
 46e:	cd 40                	int    $0x40
 470:	c3                   	ret    

00000471 <getpid>:
SYSCALL(getpid)
 471:	b8 0b 00 00 00       	mov    $0xb,%eax
 476:	cd 40                	int    $0x40
 478:	c3                   	ret    

00000479 <sbrk>:
SYSCALL(sbrk)
 479:	b8 0c 00 00 00       	mov    $0xc,%eax
 47e:	cd 40                	int    $0x40
 480:	c3                   	ret    

00000481 <sleep>:
SYSCALL(sleep)
 481:	b8 0d 00 00 00       	mov    $0xd,%eax
 486:	cd 40                	int    $0x40
 488:	c3                   	ret    

00000489 <uptime>:
SYSCALL(uptime)
 489:	b8 0e 00 00 00       	mov    $0xe,%eax
 48e:	cd 40                	int    $0x40
 490:	c3                   	ret    

00000491 <getpinfo>:
SYSCALL(getpinfo)
 491:	b8 16 00 00 00       	mov    $0x16,%eax
 496:	cd 40                	int    $0x40
 498:	c3                   	ret    

00000499 <settickets>:
SYSCALL(settickets)
 499:	b8 18 00 00 00       	mov    $0x18,%eax
 49e:	cd 40                	int    $0x40
 4a0:	c3                   	ret    

000004a1 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4a1:	55                   	push   %ebp
 4a2:	89 e5                	mov    %esp,%ebp
 4a4:	83 ec 18             	sub    $0x18,%esp
 4a7:	8b 45 0c             	mov    0xc(%ebp),%eax
 4aa:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4ad:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4b4:	00 
 4b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4b8:	89 44 24 04          	mov    %eax,0x4(%esp)
 4bc:	8b 45 08             	mov    0x8(%ebp),%eax
 4bf:	89 04 24             	mov    %eax,(%esp)
 4c2:	e8 4a ff ff ff       	call   411 <write>
}
 4c7:	c9                   	leave  
 4c8:	c3                   	ret    

000004c9 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4c9:	55                   	push   %ebp
 4ca:	89 e5                	mov    %esp,%ebp
 4cc:	56                   	push   %esi
 4cd:	53                   	push   %ebx
 4ce:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4d1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4d8:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4dc:	74 17                	je     4f5 <printint+0x2c>
 4de:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4e2:	79 11                	jns    4f5 <printint+0x2c>
    neg = 1;
 4e4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4eb:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ee:	f7 d8                	neg    %eax
 4f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4f3:	eb 06                	jmp    4fb <printint+0x32>
  } else {
    x = xx;
 4f5:	8b 45 0c             	mov    0xc(%ebp),%eax
 4f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4fb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 502:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 505:	8d 41 01             	lea    0x1(%ecx),%eax
 508:	89 45 f4             	mov    %eax,-0xc(%ebp)
 50b:	8b 5d 10             	mov    0x10(%ebp),%ebx
 50e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 511:	ba 00 00 00 00       	mov    $0x0,%edx
 516:	f7 f3                	div    %ebx
 518:	89 d0                	mov    %edx,%eax
 51a:	0f b6 80 fc 0b 00 00 	movzbl 0xbfc(%eax),%eax
 521:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 525:	8b 75 10             	mov    0x10(%ebp),%esi
 528:	8b 45 ec             	mov    -0x14(%ebp),%eax
 52b:	ba 00 00 00 00       	mov    $0x0,%edx
 530:	f7 f6                	div    %esi
 532:	89 45 ec             	mov    %eax,-0x14(%ebp)
 535:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 539:	75 c7                	jne    502 <printint+0x39>
  if(neg)
 53b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 53f:	74 10                	je     551 <printint+0x88>
    buf[i++] = '-';
 541:	8b 45 f4             	mov    -0xc(%ebp),%eax
 544:	8d 50 01             	lea    0x1(%eax),%edx
 547:	89 55 f4             	mov    %edx,-0xc(%ebp)
 54a:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 54f:	eb 1f                	jmp    570 <printint+0xa7>
 551:	eb 1d                	jmp    570 <printint+0xa7>
    putc(fd, buf[i]);
 553:	8d 55 dc             	lea    -0x24(%ebp),%edx
 556:	8b 45 f4             	mov    -0xc(%ebp),%eax
 559:	01 d0                	add    %edx,%eax
 55b:	0f b6 00             	movzbl (%eax),%eax
 55e:	0f be c0             	movsbl %al,%eax
 561:	89 44 24 04          	mov    %eax,0x4(%esp)
 565:	8b 45 08             	mov    0x8(%ebp),%eax
 568:	89 04 24             	mov    %eax,(%esp)
 56b:	e8 31 ff ff ff       	call   4a1 <putc>
  while(--i >= 0)
 570:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 574:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 578:	79 d9                	jns    553 <printint+0x8a>
}
 57a:	83 c4 30             	add    $0x30,%esp
 57d:	5b                   	pop    %ebx
 57e:	5e                   	pop    %esi
 57f:	5d                   	pop    %ebp
 580:	c3                   	ret    

00000581 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 581:	55                   	push   %ebp
 582:	89 e5                	mov    %esp,%ebp
 584:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 587:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 58e:	8d 45 0c             	lea    0xc(%ebp),%eax
 591:	83 c0 04             	add    $0x4,%eax
 594:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 597:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 59e:	e9 7c 01 00 00       	jmp    71f <printf+0x19e>
    c = fmt[i] & 0xff;
 5a3:	8b 55 0c             	mov    0xc(%ebp),%edx
 5a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5a9:	01 d0                	add    %edx,%eax
 5ab:	0f b6 00             	movzbl (%eax),%eax
 5ae:	0f be c0             	movsbl %al,%eax
 5b1:	25 ff 00 00 00       	and    $0xff,%eax
 5b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5b9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5bd:	75 2c                	jne    5eb <printf+0x6a>
      if(c == '%'){
 5bf:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5c3:	75 0c                	jne    5d1 <printf+0x50>
        state = '%';
 5c5:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5cc:	e9 4a 01 00 00       	jmp    71b <printf+0x19a>
      } else {
        putc(fd, c);
 5d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5d4:	0f be c0             	movsbl %al,%eax
 5d7:	89 44 24 04          	mov    %eax,0x4(%esp)
 5db:	8b 45 08             	mov    0x8(%ebp),%eax
 5de:	89 04 24             	mov    %eax,(%esp)
 5e1:	e8 bb fe ff ff       	call   4a1 <putc>
 5e6:	e9 30 01 00 00       	jmp    71b <printf+0x19a>
      }
    } else if(state == '%'){
 5eb:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5ef:	0f 85 26 01 00 00    	jne    71b <printf+0x19a>
      if(c == 'd'){
 5f5:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5f9:	75 2d                	jne    628 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 5fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5fe:	8b 00                	mov    (%eax),%eax
 600:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 607:	00 
 608:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 60f:	00 
 610:	89 44 24 04          	mov    %eax,0x4(%esp)
 614:	8b 45 08             	mov    0x8(%ebp),%eax
 617:	89 04 24             	mov    %eax,(%esp)
 61a:	e8 aa fe ff ff       	call   4c9 <printint>
        ap++;
 61f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 623:	e9 ec 00 00 00       	jmp    714 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 628:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 62c:	74 06                	je     634 <printf+0xb3>
 62e:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 632:	75 2d                	jne    661 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 634:	8b 45 e8             	mov    -0x18(%ebp),%eax
 637:	8b 00                	mov    (%eax),%eax
 639:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 640:	00 
 641:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 648:	00 
 649:	89 44 24 04          	mov    %eax,0x4(%esp)
 64d:	8b 45 08             	mov    0x8(%ebp),%eax
 650:	89 04 24             	mov    %eax,(%esp)
 653:	e8 71 fe ff ff       	call   4c9 <printint>
        ap++;
 658:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 65c:	e9 b3 00 00 00       	jmp    714 <printf+0x193>
      } else if(c == 's'){
 661:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 665:	75 45                	jne    6ac <printf+0x12b>
        s = (char*)*ap;
 667:	8b 45 e8             	mov    -0x18(%ebp),%eax
 66a:	8b 00                	mov    (%eax),%eax
 66c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 66f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 673:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 677:	75 09                	jne    682 <printf+0x101>
          s = "(null)";
 679:	c7 45 f4 7f 09 00 00 	movl   $0x97f,-0xc(%ebp)
        while(*s != 0){
 680:	eb 1e                	jmp    6a0 <printf+0x11f>
 682:	eb 1c                	jmp    6a0 <printf+0x11f>
          putc(fd, *s);
 684:	8b 45 f4             	mov    -0xc(%ebp),%eax
 687:	0f b6 00             	movzbl (%eax),%eax
 68a:	0f be c0             	movsbl %al,%eax
 68d:	89 44 24 04          	mov    %eax,0x4(%esp)
 691:	8b 45 08             	mov    0x8(%ebp),%eax
 694:	89 04 24             	mov    %eax,(%esp)
 697:	e8 05 fe ff ff       	call   4a1 <putc>
          s++;
 69c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 6a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6a3:	0f b6 00             	movzbl (%eax),%eax
 6a6:	84 c0                	test   %al,%al
 6a8:	75 da                	jne    684 <printf+0x103>
 6aa:	eb 68                	jmp    714 <printf+0x193>
        }
      } else if(c == 'c'){
 6ac:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6b0:	75 1d                	jne    6cf <printf+0x14e>
        putc(fd, *ap);
 6b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6b5:	8b 00                	mov    (%eax),%eax
 6b7:	0f be c0             	movsbl %al,%eax
 6ba:	89 44 24 04          	mov    %eax,0x4(%esp)
 6be:	8b 45 08             	mov    0x8(%ebp),%eax
 6c1:	89 04 24             	mov    %eax,(%esp)
 6c4:	e8 d8 fd ff ff       	call   4a1 <putc>
        ap++;
 6c9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6cd:	eb 45                	jmp    714 <printf+0x193>
      } else if(c == '%'){
 6cf:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6d3:	75 17                	jne    6ec <printf+0x16b>
        putc(fd, c);
 6d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6d8:	0f be c0             	movsbl %al,%eax
 6db:	89 44 24 04          	mov    %eax,0x4(%esp)
 6df:	8b 45 08             	mov    0x8(%ebp),%eax
 6e2:	89 04 24             	mov    %eax,(%esp)
 6e5:	e8 b7 fd ff ff       	call   4a1 <putc>
 6ea:	eb 28                	jmp    714 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6ec:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 6f3:	00 
 6f4:	8b 45 08             	mov    0x8(%ebp),%eax
 6f7:	89 04 24             	mov    %eax,(%esp)
 6fa:	e8 a2 fd ff ff       	call   4a1 <putc>
        putc(fd, c);
 6ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 702:	0f be c0             	movsbl %al,%eax
 705:	89 44 24 04          	mov    %eax,0x4(%esp)
 709:	8b 45 08             	mov    0x8(%ebp),%eax
 70c:	89 04 24             	mov    %eax,(%esp)
 70f:	e8 8d fd ff ff       	call   4a1 <putc>
      }
      state = 0;
 714:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 71b:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 71f:	8b 55 0c             	mov    0xc(%ebp),%edx
 722:	8b 45 f0             	mov    -0x10(%ebp),%eax
 725:	01 d0                	add    %edx,%eax
 727:	0f b6 00             	movzbl (%eax),%eax
 72a:	84 c0                	test   %al,%al
 72c:	0f 85 71 fe ff ff    	jne    5a3 <printf+0x22>
    }
  }
}
 732:	c9                   	leave  
 733:	c3                   	ret    

00000734 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 734:	55                   	push   %ebp
 735:	89 e5                	mov    %esp,%ebp
 737:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 73a:	8b 45 08             	mov    0x8(%ebp),%eax
 73d:	83 e8 08             	sub    $0x8,%eax
 740:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 743:	a1 18 0c 00 00       	mov    0xc18,%eax
 748:	89 45 fc             	mov    %eax,-0x4(%ebp)
 74b:	eb 24                	jmp    771 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 74d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 750:	8b 00                	mov    (%eax),%eax
 752:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 755:	77 12                	ja     769 <free+0x35>
 757:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 75d:	77 24                	ja     783 <free+0x4f>
 75f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 762:	8b 00                	mov    (%eax),%eax
 764:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 767:	77 1a                	ja     783 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 769:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76c:	8b 00                	mov    (%eax),%eax
 76e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 771:	8b 45 f8             	mov    -0x8(%ebp),%eax
 774:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 777:	76 d4                	jbe    74d <free+0x19>
 779:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77c:	8b 00                	mov    (%eax),%eax
 77e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 781:	76 ca                	jbe    74d <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 783:	8b 45 f8             	mov    -0x8(%ebp),%eax
 786:	8b 40 04             	mov    0x4(%eax),%eax
 789:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 790:	8b 45 f8             	mov    -0x8(%ebp),%eax
 793:	01 c2                	add    %eax,%edx
 795:	8b 45 fc             	mov    -0x4(%ebp),%eax
 798:	8b 00                	mov    (%eax),%eax
 79a:	39 c2                	cmp    %eax,%edx
 79c:	75 24                	jne    7c2 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 79e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a1:	8b 50 04             	mov    0x4(%eax),%edx
 7a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a7:	8b 00                	mov    (%eax),%eax
 7a9:	8b 40 04             	mov    0x4(%eax),%eax
 7ac:	01 c2                	add    %eax,%edx
 7ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7b1:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b7:	8b 00                	mov    (%eax),%eax
 7b9:	8b 10                	mov    (%eax),%edx
 7bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7be:	89 10                	mov    %edx,(%eax)
 7c0:	eb 0a                	jmp    7cc <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 7c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c5:	8b 10                	mov    (%eax),%edx
 7c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ca:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cf:	8b 40 04             	mov    0x4(%eax),%eax
 7d2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 7d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7dc:	01 d0                	add    %edx,%eax
 7de:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7e1:	75 20                	jne    803 <free+0xcf>
    p->s.size += bp->s.size;
 7e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7e6:	8b 50 04             	mov    0x4(%eax),%edx
 7e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ec:	8b 40 04             	mov    0x4(%eax),%eax
 7ef:	01 c2                	add    %eax,%edx
 7f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7f4:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7fa:	8b 10                	mov    (%eax),%edx
 7fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ff:	89 10                	mov    %edx,(%eax)
 801:	eb 08                	jmp    80b <free+0xd7>
  } else
    p->s.ptr = bp;
 803:	8b 45 fc             	mov    -0x4(%ebp),%eax
 806:	8b 55 f8             	mov    -0x8(%ebp),%edx
 809:	89 10                	mov    %edx,(%eax)
  freep = p;
 80b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80e:	a3 18 0c 00 00       	mov    %eax,0xc18
}
 813:	c9                   	leave  
 814:	c3                   	ret    

00000815 <morecore>:

static Header*
morecore(uint nu)
{
 815:	55                   	push   %ebp
 816:	89 e5                	mov    %esp,%ebp
 818:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 81b:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 822:	77 07                	ja     82b <morecore+0x16>
    nu = 4096;
 824:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 82b:	8b 45 08             	mov    0x8(%ebp),%eax
 82e:	c1 e0 03             	shl    $0x3,%eax
 831:	89 04 24             	mov    %eax,(%esp)
 834:	e8 40 fc ff ff       	call   479 <sbrk>
 839:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 83c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 840:	75 07                	jne    849 <morecore+0x34>
    return 0;
 842:	b8 00 00 00 00       	mov    $0x0,%eax
 847:	eb 22                	jmp    86b <morecore+0x56>
  hp = (Header*)p;
 849:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 84f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 852:	8b 55 08             	mov    0x8(%ebp),%edx
 855:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 858:	8b 45 f0             	mov    -0x10(%ebp),%eax
 85b:	83 c0 08             	add    $0x8,%eax
 85e:	89 04 24             	mov    %eax,(%esp)
 861:	e8 ce fe ff ff       	call   734 <free>
  return freep;
 866:	a1 18 0c 00 00       	mov    0xc18,%eax
}
 86b:	c9                   	leave  
 86c:	c3                   	ret    

0000086d <malloc>:

void*
malloc(uint nbytes)
{
 86d:	55                   	push   %ebp
 86e:	89 e5                	mov    %esp,%ebp
 870:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 873:	8b 45 08             	mov    0x8(%ebp),%eax
 876:	83 c0 07             	add    $0x7,%eax
 879:	c1 e8 03             	shr    $0x3,%eax
 87c:	83 c0 01             	add    $0x1,%eax
 87f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 882:	a1 18 0c 00 00       	mov    0xc18,%eax
 887:	89 45 f0             	mov    %eax,-0x10(%ebp)
 88a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 88e:	75 23                	jne    8b3 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 890:	c7 45 f0 10 0c 00 00 	movl   $0xc10,-0x10(%ebp)
 897:	8b 45 f0             	mov    -0x10(%ebp),%eax
 89a:	a3 18 0c 00 00       	mov    %eax,0xc18
 89f:	a1 18 0c 00 00       	mov    0xc18,%eax
 8a4:	a3 10 0c 00 00       	mov    %eax,0xc10
    base.s.size = 0;
 8a9:	c7 05 14 0c 00 00 00 	movl   $0x0,0xc14
 8b0:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b6:	8b 00                	mov    (%eax),%eax
 8b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8be:	8b 40 04             	mov    0x4(%eax),%eax
 8c1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8c4:	72 4d                	jb     913 <malloc+0xa6>
      if(p->s.size == nunits)
 8c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c9:	8b 40 04             	mov    0x4(%eax),%eax
 8cc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8cf:	75 0c                	jne    8dd <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8d4:	8b 10                	mov    (%eax),%edx
 8d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d9:	89 10                	mov    %edx,(%eax)
 8db:	eb 26                	jmp    903 <malloc+0x96>
      else {
        p->s.size -= nunits;
 8dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e0:	8b 40 04             	mov    0x4(%eax),%eax
 8e3:	2b 45 ec             	sub    -0x14(%ebp),%eax
 8e6:	89 c2                	mov    %eax,%edx
 8e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8eb:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f1:	8b 40 04             	mov    0x4(%eax),%eax
 8f4:	c1 e0 03             	shl    $0x3,%eax
 8f7:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8fd:	8b 55 ec             	mov    -0x14(%ebp),%edx
 900:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 903:	8b 45 f0             	mov    -0x10(%ebp),%eax
 906:	a3 18 0c 00 00       	mov    %eax,0xc18
      return (void*)(p + 1);
 90b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90e:	83 c0 08             	add    $0x8,%eax
 911:	eb 38                	jmp    94b <malloc+0xde>
    }
    if(p == freep)
 913:	a1 18 0c 00 00       	mov    0xc18,%eax
 918:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 91b:	75 1b                	jne    938 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 91d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 920:	89 04 24             	mov    %eax,(%esp)
 923:	e8 ed fe ff ff       	call   815 <morecore>
 928:	89 45 f4             	mov    %eax,-0xc(%ebp)
 92b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 92f:	75 07                	jne    938 <malloc+0xcb>
        return 0;
 931:	b8 00 00 00 00       	mov    $0x0,%eax
 936:	eb 13                	jmp    94b <malloc+0xde>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 938:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 93e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 941:	8b 00                	mov    (%eax),%eax
 943:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 946:	e9 70 ff ff ff       	jmp    8bb <malloc+0x4e>
}
 94b:	c9                   	leave  
 94c:	c3                   	ret    
