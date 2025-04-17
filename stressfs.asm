
_stressfs:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	81 ec 30 02 00 00    	sub    $0x230,%esp
  int fd, i;
  char path[] = "stressfs0";
   c:	c7 84 24 1e 02 00 00 	movl   $0x65727473,0x21e(%esp)
  13:	73 74 72 65 
  17:	c7 84 24 22 02 00 00 	movl   $0x73667373,0x222(%esp)
  1e:	73 73 66 73 
  22:	66 c7 84 24 26 02 00 	movw   $0x30,0x226(%esp)
  29:	00 30 00 
  char data[512];

  printf(1, "stressfs starting\n");
  2c:	c7 44 24 04 94 0a 00 	movl   $0xa94,0x4(%esp)
  33:	00 
  34:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  3b:	e8 88 06 00 00       	call   6c8 <printf>
  memset(data, 'a', sizeof(data));
  40:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  47:	00 
  48:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  4f:	00 
  50:	8d 44 24 1e          	lea    0x1e(%esp),%eax
  54:	89 04 24             	mov    %eax,(%esp)
  57:	e8 12 02 00 00       	call   26e <memset>

  for(i = 0; i < 4; i++)
  5c:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
  63:	00 00 00 00 
  67:	eb 13                	jmp    7c <main+0x7c>
    if(fork() > 0)
  69:	e8 c2 04 00 00       	call   530 <fork>
  6e:	85 c0                	test   %eax,%eax
  70:	7e 02                	jle    74 <main+0x74>
      break;
  72:	eb 12                	jmp    86 <main+0x86>
  for(i = 0; i < 4; i++)
  74:	83 84 24 2c 02 00 00 	addl   $0x1,0x22c(%esp)
  7b:	01 
  7c:	83 bc 24 2c 02 00 00 	cmpl   $0x3,0x22c(%esp)
  83:	03 
  84:	7e e3                	jle    69 <main+0x69>

  printf(1, "write %d\n", i);
  86:	8b 84 24 2c 02 00 00 	mov    0x22c(%esp),%eax
  8d:	89 44 24 08          	mov    %eax,0x8(%esp)
  91:	c7 44 24 04 a7 0a 00 	movl   $0xaa7,0x4(%esp)
  98:	00 
  99:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  a0:	e8 23 06 00 00       	call   6c8 <printf>

  path[8] += i;
  a5:	0f b6 84 24 26 02 00 	movzbl 0x226(%esp),%eax
  ac:	00 
  ad:	89 c2                	mov    %eax,%edx
  af:	8b 84 24 2c 02 00 00 	mov    0x22c(%esp),%eax
  b6:	01 d0                	add    %edx,%eax
  b8:	88 84 24 26 02 00 00 	mov    %al,0x226(%esp)
  fd = open(path, O_CREATE | O_RDWR);
  bf:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  c6:	00 
  c7:	8d 84 24 1e 02 00 00 	lea    0x21e(%esp),%eax
  ce:	89 04 24             	mov    %eax,(%esp)
  d1:	e8 a2 04 00 00       	call   578 <open>
  d6:	89 84 24 28 02 00 00 	mov    %eax,0x228(%esp)
  for(i = 0; i < 20; i++)
  dd:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
  e4:	00 00 00 00 
  e8:	eb 27                	jmp    111 <main+0x111>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  ea:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  f1:	00 
  f2:	8d 44 24 1e          	lea    0x1e(%esp),%eax
  f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  fa:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 101:	89 04 24             	mov    %eax,(%esp)
 104:	e8 4f 04 00 00       	call   558 <write>
  for(i = 0; i < 20; i++)
 109:	83 84 24 2c 02 00 00 	addl   $0x1,0x22c(%esp)
 110:	01 
 111:	83 bc 24 2c 02 00 00 	cmpl   $0x13,0x22c(%esp)
 118:	13 
 119:	7e cf                	jle    ea <main+0xea>
  close(fd);
 11b:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 122:	89 04 24             	mov    %eax,(%esp)
 125:	e8 36 04 00 00       	call   560 <close>

  printf(1, "read\n");
 12a:	c7 44 24 04 b1 0a 00 	movl   $0xab1,0x4(%esp)
 131:	00 
 132:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 139:	e8 8a 05 00 00       	call   6c8 <printf>

  fd = open(path, O_RDONLY);
 13e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 145:	00 
 146:	8d 84 24 1e 02 00 00 	lea    0x21e(%esp),%eax
 14d:	89 04 24             	mov    %eax,(%esp)
 150:	e8 23 04 00 00       	call   578 <open>
 155:	89 84 24 28 02 00 00 	mov    %eax,0x228(%esp)
  for (i = 0; i < 20; i++)
 15c:	c7 84 24 2c 02 00 00 	movl   $0x0,0x22c(%esp)
 163:	00 00 00 00 
 167:	eb 27                	jmp    190 <main+0x190>
    read(fd, data, sizeof(data));
 169:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
 170:	00 
 171:	8d 44 24 1e          	lea    0x1e(%esp),%eax
 175:	89 44 24 04          	mov    %eax,0x4(%esp)
 179:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 180:	89 04 24             	mov    %eax,(%esp)
 183:	e8 c8 03 00 00       	call   550 <read>
  for (i = 0; i < 20; i++)
 188:	83 84 24 2c 02 00 00 	addl   $0x1,0x22c(%esp)
 18f:	01 
 190:	83 bc 24 2c 02 00 00 	cmpl   $0x13,0x22c(%esp)
 197:	13 
 198:	7e cf                	jle    169 <main+0x169>
  close(fd);
 19a:	8b 84 24 28 02 00 00 	mov    0x228(%esp),%eax
 1a1:	89 04 24             	mov    %eax,(%esp)
 1a4:	e8 b7 03 00 00       	call   560 <close>

  wait();
 1a9:	e8 92 03 00 00       	call   540 <wait>

  exit();
 1ae:	e8 85 03 00 00       	call   538 <exit>

000001b3 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1b3:	55                   	push   %ebp
 1b4:	89 e5                	mov    %esp,%ebp
 1b6:	57                   	push   %edi
 1b7:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1bb:	8b 55 10             	mov    0x10(%ebp),%edx
 1be:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c1:	89 cb                	mov    %ecx,%ebx
 1c3:	89 df                	mov    %ebx,%edi
 1c5:	89 d1                	mov    %edx,%ecx
 1c7:	fc                   	cld    
 1c8:	f3 aa                	rep stos %al,%es:(%edi)
 1ca:	89 ca                	mov    %ecx,%edx
 1cc:	89 fb                	mov    %edi,%ebx
 1ce:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1d1:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 1d4:	5b                   	pop    %ebx
 1d5:	5f                   	pop    %edi
 1d6:	5d                   	pop    %ebp
 1d7:	c3                   	ret    

000001d8 <strcpy>:
#include "x86.h"
#include "pstat.h"

char*
strcpy(char *s, const char *t)
{
 1d8:	55                   	push   %ebp
 1d9:	89 e5                	mov    %esp,%ebp
 1db:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 1de:	8b 45 08             	mov    0x8(%ebp),%eax
 1e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1e4:	90                   	nop
 1e5:	8b 45 08             	mov    0x8(%ebp),%eax
 1e8:	8d 50 01             	lea    0x1(%eax),%edx
 1eb:	89 55 08             	mov    %edx,0x8(%ebp)
 1ee:	8b 55 0c             	mov    0xc(%ebp),%edx
 1f1:	8d 4a 01             	lea    0x1(%edx),%ecx
 1f4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 1f7:	0f b6 12             	movzbl (%edx),%edx
 1fa:	88 10                	mov    %dl,(%eax)
 1fc:	0f b6 00             	movzbl (%eax),%eax
 1ff:	84 c0                	test   %al,%al
 201:	75 e2                	jne    1e5 <strcpy+0xd>
    ;
  return os;
 203:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 206:	c9                   	leave  
 207:	c3                   	ret    

00000208 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 208:	55                   	push   %ebp
 209:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 20b:	eb 08                	jmp    215 <strcmp+0xd>
    p++, q++;
 20d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 211:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 215:	8b 45 08             	mov    0x8(%ebp),%eax
 218:	0f b6 00             	movzbl (%eax),%eax
 21b:	84 c0                	test   %al,%al
 21d:	74 10                	je     22f <strcmp+0x27>
 21f:	8b 45 08             	mov    0x8(%ebp),%eax
 222:	0f b6 10             	movzbl (%eax),%edx
 225:	8b 45 0c             	mov    0xc(%ebp),%eax
 228:	0f b6 00             	movzbl (%eax),%eax
 22b:	38 c2                	cmp    %al,%dl
 22d:	74 de                	je     20d <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 22f:	8b 45 08             	mov    0x8(%ebp),%eax
 232:	0f b6 00             	movzbl (%eax),%eax
 235:	0f b6 d0             	movzbl %al,%edx
 238:	8b 45 0c             	mov    0xc(%ebp),%eax
 23b:	0f b6 00             	movzbl (%eax),%eax
 23e:	0f b6 c0             	movzbl %al,%eax
 241:	29 c2                	sub    %eax,%edx
 243:	89 d0                	mov    %edx,%eax
}
 245:	5d                   	pop    %ebp
 246:	c3                   	ret    

00000247 <strlen>:

uint
strlen(const char *s)
{
 247:	55                   	push   %ebp
 248:	89 e5                	mov    %esp,%ebp
 24a:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 24d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 254:	eb 04                	jmp    25a <strlen+0x13>
 256:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 25a:	8b 55 fc             	mov    -0x4(%ebp),%edx
 25d:	8b 45 08             	mov    0x8(%ebp),%eax
 260:	01 d0                	add    %edx,%eax
 262:	0f b6 00             	movzbl (%eax),%eax
 265:	84 c0                	test   %al,%al
 267:	75 ed                	jne    256 <strlen+0xf>
    ;
  return n;
 269:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 26c:	c9                   	leave  
 26d:	c3                   	ret    

0000026e <memset>:

void*
memset(void *dst, int c, uint n)
{
 26e:	55                   	push   %ebp
 26f:	89 e5                	mov    %esp,%ebp
 271:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 274:	8b 45 10             	mov    0x10(%ebp),%eax
 277:	89 44 24 08          	mov    %eax,0x8(%esp)
 27b:	8b 45 0c             	mov    0xc(%ebp),%eax
 27e:	89 44 24 04          	mov    %eax,0x4(%esp)
 282:	8b 45 08             	mov    0x8(%ebp),%eax
 285:	89 04 24             	mov    %eax,(%esp)
 288:	e8 26 ff ff ff       	call   1b3 <stosb>
  return dst;
 28d:	8b 45 08             	mov    0x8(%ebp),%eax
}
 290:	c9                   	leave  
 291:	c3                   	ret    

00000292 <strchr>:

char*
strchr(const char *s, char c)
{
 292:	55                   	push   %ebp
 293:	89 e5                	mov    %esp,%ebp
 295:	83 ec 04             	sub    $0x4,%esp
 298:	8b 45 0c             	mov    0xc(%ebp),%eax
 29b:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 29e:	eb 14                	jmp    2b4 <strchr+0x22>
    if(*s == c)
 2a0:	8b 45 08             	mov    0x8(%ebp),%eax
 2a3:	0f b6 00             	movzbl (%eax),%eax
 2a6:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2a9:	75 05                	jne    2b0 <strchr+0x1e>
      return (char*)s;
 2ab:	8b 45 08             	mov    0x8(%ebp),%eax
 2ae:	eb 13                	jmp    2c3 <strchr+0x31>
  for(; *s; s++)
 2b0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2b4:	8b 45 08             	mov    0x8(%ebp),%eax
 2b7:	0f b6 00             	movzbl (%eax),%eax
 2ba:	84 c0                	test   %al,%al
 2bc:	75 e2                	jne    2a0 <strchr+0xe>
  return 0;
 2be:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2c3:	c9                   	leave  
 2c4:	c3                   	ret    

000002c5 <gets>:

char*
gets(char *buf, int max)
{
 2c5:	55                   	push   %ebp
 2c6:	89 e5                	mov    %esp,%ebp
 2c8:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2cb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 2d2:	eb 4c                	jmp    320 <gets+0x5b>
    cc = read(0, &c, 1);
 2d4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 2db:	00 
 2dc:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2df:	89 44 24 04          	mov    %eax,0x4(%esp)
 2e3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 2ea:	e8 61 02 00 00       	call   550 <read>
 2ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 2f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2f6:	7f 02                	jg     2fa <gets+0x35>
      break;
 2f8:	eb 31                	jmp    32b <gets+0x66>
    buf[i++] = c;
 2fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2fd:	8d 50 01             	lea    0x1(%eax),%edx
 300:	89 55 f4             	mov    %edx,-0xc(%ebp)
 303:	89 c2                	mov    %eax,%edx
 305:	8b 45 08             	mov    0x8(%ebp),%eax
 308:	01 c2                	add    %eax,%edx
 30a:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 30e:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 310:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 314:	3c 0a                	cmp    $0xa,%al
 316:	74 13                	je     32b <gets+0x66>
 318:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 31c:	3c 0d                	cmp    $0xd,%al
 31e:	74 0b                	je     32b <gets+0x66>
  for(i=0; i+1 < max; ){
 320:	8b 45 f4             	mov    -0xc(%ebp),%eax
 323:	83 c0 01             	add    $0x1,%eax
 326:	3b 45 0c             	cmp    0xc(%ebp),%eax
 329:	7c a9                	jl     2d4 <gets+0xf>
      break;
  }
  buf[i] = '\0';
 32b:	8b 55 f4             	mov    -0xc(%ebp),%edx
 32e:	8b 45 08             	mov    0x8(%ebp),%eax
 331:	01 d0                	add    %edx,%eax
 333:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 336:	8b 45 08             	mov    0x8(%ebp),%eax
}
 339:	c9                   	leave  
 33a:	c3                   	ret    

0000033b <stat>:

int
stat(const char *n, struct stat *st)
{
 33b:	55                   	push   %ebp
 33c:	89 e5                	mov    %esp,%ebp
 33e:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 341:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 348:	00 
 349:	8b 45 08             	mov    0x8(%ebp),%eax
 34c:	89 04 24             	mov    %eax,(%esp)
 34f:	e8 24 02 00 00       	call   578 <open>
 354:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 357:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 35b:	79 07                	jns    364 <stat+0x29>
    return -1;
 35d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 362:	eb 23                	jmp    387 <stat+0x4c>
  r = fstat(fd, st);
 364:	8b 45 0c             	mov    0xc(%ebp),%eax
 367:	89 44 24 04          	mov    %eax,0x4(%esp)
 36b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 36e:	89 04 24             	mov    %eax,(%esp)
 371:	e8 1a 02 00 00       	call   590 <fstat>
 376:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 379:	8b 45 f4             	mov    -0xc(%ebp),%eax
 37c:	89 04 24             	mov    %eax,(%esp)
 37f:	e8 dc 01 00 00       	call   560 <close>
  return r;
 384:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 387:	c9                   	leave  
 388:	c3                   	ret    

00000389 <atoi>:

int
atoi(const char *s)
{
 389:	55                   	push   %ebp
 38a:	89 e5                	mov    %esp,%ebp
 38c:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 38f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 396:	eb 25                	jmp    3bd <atoi+0x34>
    n = n*10 + *s++ - '0';
 398:	8b 55 fc             	mov    -0x4(%ebp),%edx
 39b:	89 d0                	mov    %edx,%eax
 39d:	c1 e0 02             	shl    $0x2,%eax
 3a0:	01 d0                	add    %edx,%eax
 3a2:	01 c0                	add    %eax,%eax
 3a4:	89 c1                	mov    %eax,%ecx
 3a6:	8b 45 08             	mov    0x8(%ebp),%eax
 3a9:	8d 50 01             	lea    0x1(%eax),%edx
 3ac:	89 55 08             	mov    %edx,0x8(%ebp)
 3af:	0f b6 00             	movzbl (%eax),%eax
 3b2:	0f be c0             	movsbl %al,%eax
 3b5:	01 c8                	add    %ecx,%eax
 3b7:	83 e8 30             	sub    $0x30,%eax
 3ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3bd:	8b 45 08             	mov    0x8(%ebp),%eax
 3c0:	0f b6 00             	movzbl (%eax),%eax
 3c3:	3c 2f                	cmp    $0x2f,%al
 3c5:	7e 0a                	jle    3d1 <atoi+0x48>
 3c7:	8b 45 08             	mov    0x8(%ebp),%eax
 3ca:	0f b6 00             	movzbl (%eax),%eax
 3cd:	3c 39                	cmp    $0x39,%al
 3cf:	7e c7                	jle    398 <atoi+0xf>
  return n;
 3d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3d4:	c9                   	leave  
 3d5:	c3                   	ret    

000003d6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3d6:	55                   	push   %ebp
 3d7:	89 e5                	mov    %esp,%ebp
 3d9:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 3dc:	8b 45 08             	mov    0x8(%ebp),%eax
 3df:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 3e2:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3e8:	eb 17                	jmp    401 <memmove+0x2b>
    *dst++ = *src++;
 3ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3ed:	8d 50 01             	lea    0x1(%eax),%edx
 3f0:	89 55 fc             	mov    %edx,-0x4(%ebp)
 3f3:	8b 55 f8             	mov    -0x8(%ebp),%edx
 3f6:	8d 4a 01             	lea    0x1(%edx),%ecx
 3f9:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 3fc:	0f b6 12             	movzbl (%edx),%edx
 3ff:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 401:	8b 45 10             	mov    0x10(%ebp),%eax
 404:	8d 50 ff             	lea    -0x1(%eax),%edx
 407:	89 55 10             	mov    %edx,0x10(%ebp)
 40a:	85 c0                	test   %eax,%eax
 40c:	7f dc                	jg     3ea <memmove+0x14>
  return vdst;
 40e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 411:	c9                   	leave  
 412:	c3                   	ret    

00000413 <ps>:

void 
ps()
{
 413:	55                   	push   %ebp
 414:	89 e5                	mov    %esp,%ebp
 416:	57                   	push   %edi
 417:	56                   	push   %esi
 418:	53                   	push   %ebx
 419:	81 ec 3c 09 00 00    	sub    $0x93c,%esp
  pstatTable pTable;
  getpinfo(&pTable);
 41f:	8d 85 e4 f6 ff ff    	lea    -0x91c(%ebp),%eax
 425:	89 04 24             	mov    %eax,(%esp)
 428:	e8 ab 01 00 00       	call   5d8 <getpinfo>
  printf(1, "PID\tTKTS\tTCKS\tSTAT\tNAME\n");
 42d:	c7 44 24 04 b7 0a 00 	movl   $0xab7,0x4(%esp)
 434:	00 
 435:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 43c:	e8 87 02 00 00       	call   6c8 <printf>
  int i;
  for (i = 0; i < NPROC; i++)
 441:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 448:	e9 ce 00 00 00       	jmp    51b <ps+0x108>
  {
    if(pTable[i].inuse)
 44d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 450:	89 d0                	mov    %edx,%eax
 452:	c1 e0 03             	shl    $0x3,%eax
 455:	01 d0                	add    %edx,%eax
 457:	c1 e0 02             	shl    $0x2,%eax
 45a:	8d 5d e8             	lea    -0x18(%ebp),%ebx
 45d:	01 d8                	add    %ebx,%eax
 45f:	2d 04 09 00 00       	sub    $0x904,%eax
 464:	8b 00                	mov    (%eax),%eax
 466:	85 c0                	test   %eax,%eax
 468:	0f 84 a9 00 00 00    	je     517 <ps+0x104>
      printf(1, "%d\t%d\t%d\t%c\t%s\n", pTable[i].pid, pTable[i].tickets, pTable[i].ticks, pTable[i].state, pTable[i].name);
 46e:	8d 8d e4 f6 ff ff    	lea    -0x91c(%ebp),%ecx
 474:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 477:	89 d0                	mov    %edx,%eax
 479:	c1 e0 03             	shl    $0x3,%eax
 47c:	01 d0                	add    %edx,%eax
 47e:	c1 e0 02             	shl    $0x2,%eax
 481:	83 c0 10             	add    $0x10,%eax
 484:	8d 3c 01             	lea    (%ecx,%eax,1),%edi
 487:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 48a:	89 d0                	mov    %edx,%eax
 48c:	c1 e0 03             	shl    $0x3,%eax
 48f:	01 d0                	add    %edx,%eax
 491:	c1 e0 02             	shl    $0x2,%eax
 494:	8d 75 e8             	lea    -0x18(%ebp),%esi
 497:	01 f0                	add    %esi,%eax
 499:	2d e4 08 00 00       	sub    $0x8e4,%eax
 49e:	0f b6 00             	movzbl (%eax),%eax
 4a1:	0f be f0             	movsbl %al,%esi
 4a4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 4a7:	89 d0                	mov    %edx,%eax
 4a9:	c1 e0 03             	shl    $0x3,%eax
 4ac:	01 d0                	add    %edx,%eax
 4ae:	c1 e0 02             	shl    $0x2,%eax
 4b1:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 4b4:	01 c8                	add    %ecx,%eax
 4b6:	2d f8 08 00 00       	sub    $0x8f8,%eax
 4bb:	8b 18                	mov    (%eax),%ebx
 4bd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 4c0:	89 d0                	mov    %edx,%eax
 4c2:	c1 e0 03             	shl    $0x3,%eax
 4c5:	01 d0                	add    %edx,%eax
 4c7:	c1 e0 02             	shl    $0x2,%eax
 4ca:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 4cd:	01 c8                	add    %ecx,%eax
 4cf:	2d 00 09 00 00       	sub    $0x900,%eax
 4d4:	8b 08                	mov    (%eax),%ecx
 4d6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 4d9:	89 d0                	mov    %edx,%eax
 4db:	c1 e0 03             	shl    $0x3,%eax
 4de:	01 d0                	add    %edx,%eax
 4e0:	c1 e0 02             	shl    $0x2,%eax
 4e3:	8d 55 e8             	lea    -0x18(%ebp),%edx
 4e6:	01 d0                	add    %edx,%eax
 4e8:	2d fc 08 00 00       	sub    $0x8fc,%eax
 4ed:	8b 00                	mov    (%eax),%eax
 4ef:	89 7c 24 18          	mov    %edi,0x18(%esp)
 4f3:	89 74 24 14          	mov    %esi,0x14(%esp)
 4f7:	89 5c 24 10          	mov    %ebx,0x10(%esp)
 4fb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 4ff:	89 44 24 08          	mov    %eax,0x8(%esp)
 503:	c7 44 24 04 d0 0a 00 	movl   $0xad0,0x4(%esp)
 50a:	00 
 50b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 512:	e8 b1 01 00 00       	call   6c8 <printf>
  for (i = 0; i < NPROC; i++)
 517:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 51b:	83 7d e4 3f          	cmpl   $0x3f,-0x1c(%ebp)
 51f:	0f 8e 28 ff ff ff    	jle    44d <ps+0x3a>
  }
}
 525:	81 c4 3c 09 00 00    	add    $0x93c,%esp
 52b:	5b                   	pop    %ebx
 52c:	5e                   	pop    %esi
 52d:	5f                   	pop    %edi
 52e:	5d                   	pop    %ebp
 52f:	c3                   	ret    

00000530 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 530:	b8 01 00 00 00       	mov    $0x1,%eax
 535:	cd 40                	int    $0x40
 537:	c3                   	ret    

00000538 <exit>:
SYSCALL(exit)
 538:	b8 02 00 00 00       	mov    $0x2,%eax
 53d:	cd 40                	int    $0x40
 53f:	c3                   	ret    

00000540 <wait>:
SYSCALL(wait)
 540:	b8 03 00 00 00       	mov    $0x3,%eax
 545:	cd 40                	int    $0x40
 547:	c3                   	ret    

00000548 <pipe>:
SYSCALL(pipe)
 548:	b8 04 00 00 00       	mov    $0x4,%eax
 54d:	cd 40                	int    $0x40
 54f:	c3                   	ret    

00000550 <read>:
SYSCALL(read)
 550:	b8 05 00 00 00       	mov    $0x5,%eax
 555:	cd 40                	int    $0x40
 557:	c3                   	ret    

00000558 <write>:
SYSCALL(write)
 558:	b8 10 00 00 00       	mov    $0x10,%eax
 55d:	cd 40                	int    $0x40
 55f:	c3                   	ret    

00000560 <close>:
SYSCALL(close)
 560:	b8 15 00 00 00       	mov    $0x15,%eax
 565:	cd 40                	int    $0x40
 567:	c3                   	ret    

00000568 <kill>:
SYSCALL(kill)
 568:	b8 06 00 00 00       	mov    $0x6,%eax
 56d:	cd 40                	int    $0x40
 56f:	c3                   	ret    

00000570 <exec>:
SYSCALL(exec)
 570:	b8 07 00 00 00       	mov    $0x7,%eax
 575:	cd 40                	int    $0x40
 577:	c3                   	ret    

00000578 <open>:
SYSCALL(open)
 578:	b8 0f 00 00 00       	mov    $0xf,%eax
 57d:	cd 40                	int    $0x40
 57f:	c3                   	ret    

00000580 <mknod>:
SYSCALL(mknod)
 580:	b8 11 00 00 00       	mov    $0x11,%eax
 585:	cd 40                	int    $0x40
 587:	c3                   	ret    

00000588 <unlink>:
SYSCALL(unlink)
 588:	b8 12 00 00 00       	mov    $0x12,%eax
 58d:	cd 40                	int    $0x40
 58f:	c3                   	ret    

00000590 <fstat>:
SYSCALL(fstat)
 590:	b8 08 00 00 00       	mov    $0x8,%eax
 595:	cd 40                	int    $0x40
 597:	c3                   	ret    

00000598 <link>:
SYSCALL(link)
 598:	b8 13 00 00 00       	mov    $0x13,%eax
 59d:	cd 40                	int    $0x40
 59f:	c3                   	ret    

000005a0 <mkdir>:
SYSCALL(mkdir)
 5a0:	b8 14 00 00 00       	mov    $0x14,%eax
 5a5:	cd 40                	int    $0x40
 5a7:	c3                   	ret    

000005a8 <chdir>:
SYSCALL(chdir)
 5a8:	b8 09 00 00 00       	mov    $0x9,%eax
 5ad:	cd 40                	int    $0x40
 5af:	c3                   	ret    

000005b0 <dup>:
SYSCALL(dup)
 5b0:	b8 0a 00 00 00       	mov    $0xa,%eax
 5b5:	cd 40                	int    $0x40
 5b7:	c3                   	ret    

000005b8 <getpid>:
SYSCALL(getpid)
 5b8:	b8 0b 00 00 00       	mov    $0xb,%eax
 5bd:	cd 40                	int    $0x40
 5bf:	c3                   	ret    

000005c0 <sbrk>:
SYSCALL(sbrk)
 5c0:	b8 0c 00 00 00       	mov    $0xc,%eax
 5c5:	cd 40                	int    $0x40
 5c7:	c3                   	ret    

000005c8 <sleep>:
SYSCALL(sleep)
 5c8:	b8 0d 00 00 00       	mov    $0xd,%eax
 5cd:	cd 40                	int    $0x40
 5cf:	c3                   	ret    

000005d0 <uptime>:
SYSCALL(uptime)
 5d0:	b8 0e 00 00 00       	mov    $0xe,%eax
 5d5:	cd 40                	int    $0x40
 5d7:	c3                   	ret    

000005d8 <getpinfo>:
SYSCALL(getpinfo)
 5d8:	b8 16 00 00 00       	mov    $0x16,%eax
 5dd:	cd 40                	int    $0x40
 5df:	c3                   	ret    

000005e0 <settickets>:
SYSCALL(settickets)
 5e0:	b8 18 00 00 00       	mov    $0x18,%eax
 5e5:	cd 40                	int    $0x40
 5e7:	c3                   	ret    

000005e8 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 5e8:	55                   	push   %ebp
 5e9:	89 e5                	mov    %esp,%ebp
 5eb:	83 ec 18             	sub    $0x18,%esp
 5ee:	8b 45 0c             	mov    0xc(%ebp),%eax
 5f1:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 5f4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5fb:	00 
 5fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
 5ff:	89 44 24 04          	mov    %eax,0x4(%esp)
 603:	8b 45 08             	mov    0x8(%ebp),%eax
 606:	89 04 24             	mov    %eax,(%esp)
 609:	e8 4a ff ff ff       	call   558 <write>
}
 60e:	c9                   	leave  
 60f:	c3                   	ret    

00000610 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 610:	55                   	push   %ebp
 611:	89 e5                	mov    %esp,%ebp
 613:	56                   	push   %esi
 614:	53                   	push   %ebx
 615:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 618:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 61f:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 623:	74 17                	je     63c <printint+0x2c>
 625:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 629:	79 11                	jns    63c <printint+0x2c>
    neg = 1;
 62b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 632:	8b 45 0c             	mov    0xc(%ebp),%eax
 635:	f7 d8                	neg    %eax
 637:	89 45 ec             	mov    %eax,-0x14(%ebp)
 63a:	eb 06                	jmp    642 <printint+0x32>
  } else {
    x = xx;
 63c:	8b 45 0c             	mov    0xc(%ebp),%eax
 63f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 642:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 649:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 64c:	8d 41 01             	lea    0x1(%ecx),%eax
 64f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 652:	8b 5d 10             	mov    0x10(%ebp),%ebx
 655:	8b 45 ec             	mov    -0x14(%ebp),%eax
 658:	ba 00 00 00 00       	mov    $0x0,%edx
 65d:	f7 f3                	div    %ebx
 65f:	89 d0                	mov    %edx,%eax
 661:	0f b6 80 5c 0d 00 00 	movzbl 0xd5c(%eax),%eax
 668:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 66c:	8b 75 10             	mov    0x10(%ebp),%esi
 66f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 672:	ba 00 00 00 00       	mov    $0x0,%edx
 677:	f7 f6                	div    %esi
 679:	89 45 ec             	mov    %eax,-0x14(%ebp)
 67c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 680:	75 c7                	jne    649 <printint+0x39>
  if(neg)
 682:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 686:	74 10                	je     698 <printint+0x88>
    buf[i++] = '-';
 688:	8b 45 f4             	mov    -0xc(%ebp),%eax
 68b:	8d 50 01             	lea    0x1(%eax),%edx
 68e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 691:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 696:	eb 1f                	jmp    6b7 <printint+0xa7>
 698:	eb 1d                	jmp    6b7 <printint+0xa7>
    putc(fd, buf[i]);
 69a:	8d 55 dc             	lea    -0x24(%ebp),%edx
 69d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6a0:	01 d0                	add    %edx,%eax
 6a2:	0f b6 00             	movzbl (%eax),%eax
 6a5:	0f be c0             	movsbl %al,%eax
 6a8:	89 44 24 04          	mov    %eax,0x4(%esp)
 6ac:	8b 45 08             	mov    0x8(%ebp),%eax
 6af:	89 04 24             	mov    %eax,(%esp)
 6b2:	e8 31 ff ff ff       	call   5e8 <putc>
  while(--i >= 0)
 6b7:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 6bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6bf:	79 d9                	jns    69a <printint+0x8a>
}
 6c1:	83 c4 30             	add    $0x30,%esp
 6c4:	5b                   	pop    %ebx
 6c5:	5e                   	pop    %esi
 6c6:	5d                   	pop    %ebp
 6c7:	c3                   	ret    

000006c8 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 6c8:	55                   	push   %ebp
 6c9:	89 e5                	mov    %esp,%ebp
 6cb:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 6ce:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 6d5:	8d 45 0c             	lea    0xc(%ebp),%eax
 6d8:	83 c0 04             	add    $0x4,%eax
 6db:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 6de:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 6e5:	e9 7c 01 00 00       	jmp    866 <printf+0x19e>
    c = fmt[i] & 0xff;
 6ea:	8b 55 0c             	mov    0xc(%ebp),%edx
 6ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6f0:	01 d0                	add    %edx,%eax
 6f2:	0f b6 00             	movzbl (%eax),%eax
 6f5:	0f be c0             	movsbl %al,%eax
 6f8:	25 ff 00 00 00       	and    $0xff,%eax
 6fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 700:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 704:	75 2c                	jne    732 <printf+0x6a>
      if(c == '%'){
 706:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 70a:	75 0c                	jne    718 <printf+0x50>
        state = '%';
 70c:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 713:	e9 4a 01 00 00       	jmp    862 <printf+0x19a>
      } else {
        putc(fd, c);
 718:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 71b:	0f be c0             	movsbl %al,%eax
 71e:	89 44 24 04          	mov    %eax,0x4(%esp)
 722:	8b 45 08             	mov    0x8(%ebp),%eax
 725:	89 04 24             	mov    %eax,(%esp)
 728:	e8 bb fe ff ff       	call   5e8 <putc>
 72d:	e9 30 01 00 00       	jmp    862 <printf+0x19a>
      }
    } else if(state == '%'){
 732:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 736:	0f 85 26 01 00 00    	jne    862 <printf+0x19a>
      if(c == 'd'){
 73c:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 740:	75 2d                	jne    76f <printf+0xa7>
        printint(fd, *ap, 10, 1);
 742:	8b 45 e8             	mov    -0x18(%ebp),%eax
 745:	8b 00                	mov    (%eax),%eax
 747:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 74e:	00 
 74f:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 756:	00 
 757:	89 44 24 04          	mov    %eax,0x4(%esp)
 75b:	8b 45 08             	mov    0x8(%ebp),%eax
 75e:	89 04 24             	mov    %eax,(%esp)
 761:	e8 aa fe ff ff       	call   610 <printint>
        ap++;
 766:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 76a:	e9 ec 00 00 00       	jmp    85b <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 76f:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 773:	74 06                	je     77b <printf+0xb3>
 775:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 779:	75 2d                	jne    7a8 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 77b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 77e:	8b 00                	mov    (%eax),%eax
 780:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 787:	00 
 788:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 78f:	00 
 790:	89 44 24 04          	mov    %eax,0x4(%esp)
 794:	8b 45 08             	mov    0x8(%ebp),%eax
 797:	89 04 24             	mov    %eax,(%esp)
 79a:	e8 71 fe ff ff       	call   610 <printint>
        ap++;
 79f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7a3:	e9 b3 00 00 00       	jmp    85b <printf+0x193>
      } else if(c == 's'){
 7a8:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 7ac:	75 45                	jne    7f3 <printf+0x12b>
        s = (char*)*ap;
 7ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7b1:	8b 00                	mov    (%eax),%eax
 7b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 7b6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 7ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7be:	75 09                	jne    7c9 <printf+0x101>
          s = "(null)";
 7c0:	c7 45 f4 e0 0a 00 00 	movl   $0xae0,-0xc(%ebp)
        while(*s != 0){
 7c7:	eb 1e                	jmp    7e7 <printf+0x11f>
 7c9:	eb 1c                	jmp    7e7 <printf+0x11f>
          putc(fd, *s);
 7cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ce:	0f b6 00             	movzbl (%eax),%eax
 7d1:	0f be c0             	movsbl %al,%eax
 7d4:	89 44 24 04          	mov    %eax,0x4(%esp)
 7d8:	8b 45 08             	mov    0x8(%ebp),%eax
 7db:	89 04 24             	mov    %eax,(%esp)
 7de:	e8 05 fe ff ff       	call   5e8 <putc>
          s++;
 7e3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 7e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ea:	0f b6 00             	movzbl (%eax),%eax
 7ed:	84 c0                	test   %al,%al
 7ef:	75 da                	jne    7cb <printf+0x103>
 7f1:	eb 68                	jmp    85b <printf+0x193>
        }
      } else if(c == 'c'){
 7f3:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 7f7:	75 1d                	jne    816 <printf+0x14e>
        putc(fd, *ap);
 7f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7fc:	8b 00                	mov    (%eax),%eax
 7fe:	0f be c0             	movsbl %al,%eax
 801:	89 44 24 04          	mov    %eax,0x4(%esp)
 805:	8b 45 08             	mov    0x8(%ebp),%eax
 808:	89 04 24             	mov    %eax,(%esp)
 80b:	e8 d8 fd ff ff       	call   5e8 <putc>
        ap++;
 810:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 814:	eb 45                	jmp    85b <printf+0x193>
      } else if(c == '%'){
 816:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 81a:	75 17                	jne    833 <printf+0x16b>
        putc(fd, c);
 81c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 81f:	0f be c0             	movsbl %al,%eax
 822:	89 44 24 04          	mov    %eax,0x4(%esp)
 826:	8b 45 08             	mov    0x8(%ebp),%eax
 829:	89 04 24             	mov    %eax,(%esp)
 82c:	e8 b7 fd ff ff       	call   5e8 <putc>
 831:	eb 28                	jmp    85b <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 833:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 83a:	00 
 83b:	8b 45 08             	mov    0x8(%ebp),%eax
 83e:	89 04 24             	mov    %eax,(%esp)
 841:	e8 a2 fd ff ff       	call   5e8 <putc>
        putc(fd, c);
 846:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 849:	0f be c0             	movsbl %al,%eax
 84c:	89 44 24 04          	mov    %eax,0x4(%esp)
 850:	8b 45 08             	mov    0x8(%ebp),%eax
 853:	89 04 24             	mov    %eax,(%esp)
 856:	e8 8d fd ff ff       	call   5e8 <putc>
      }
      state = 0;
 85b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 862:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 866:	8b 55 0c             	mov    0xc(%ebp),%edx
 869:	8b 45 f0             	mov    -0x10(%ebp),%eax
 86c:	01 d0                	add    %edx,%eax
 86e:	0f b6 00             	movzbl (%eax),%eax
 871:	84 c0                	test   %al,%al
 873:	0f 85 71 fe ff ff    	jne    6ea <printf+0x22>
    }
  }
}
 879:	c9                   	leave  
 87a:	c3                   	ret    

0000087b <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 87b:	55                   	push   %ebp
 87c:	89 e5                	mov    %esp,%ebp
 87e:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 881:	8b 45 08             	mov    0x8(%ebp),%eax
 884:	83 e8 08             	sub    $0x8,%eax
 887:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 88a:	a1 78 0d 00 00       	mov    0xd78,%eax
 88f:	89 45 fc             	mov    %eax,-0x4(%ebp)
 892:	eb 24                	jmp    8b8 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 894:	8b 45 fc             	mov    -0x4(%ebp),%eax
 897:	8b 00                	mov    (%eax),%eax
 899:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 89c:	77 12                	ja     8b0 <free+0x35>
 89e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8a1:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8a4:	77 24                	ja     8ca <free+0x4f>
 8a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a9:	8b 00                	mov    (%eax),%eax
 8ab:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8ae:	77 1a                	ja     8ca <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b3:	8b 00                	mov    (%eax),%eax
 8b5:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8bb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8be:	76 d4                	jbe    894 <free+0x19>
 8c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c3:	8b 00                	mov    (%eax),%eax
 8c5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8c8:	76 ca                	jbe    894 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 8ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8cd:	8b 40 04             	mov    0x4(%eax),%eax
 8d0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8d7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8da:	01 c2                	add    %eax,%edx
 8dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8df:	8b 00                	mov    (%eax),%eax
 8e1:	39 c2                	cmp    %eax,%edx
 8e3:	75 24                	jne    909 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 8e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8e8:	8b 50 04             	mov    0x4(%eax),%edx
 8eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ee:	8b 00                	mov    (%eax),%eax
 8f0:	8b 40 04             	mov    0x4(%eax),%eax
 8f3:	01 c2                	add    %eax,%edx
 8f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8f8:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 8fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8fe:	8b 00                	mov    (%eax),%eax
 900:	8b 10                	mov    (%eax),%edx
 902:	8b 45 f8             	mov    -0x8(%ebp),%eax
 905:	89 10                	mov    %edx,(%eax)
 907:	eb 0a                	jmp    913 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 909:	8b 45 fc             	mov    -0x4(%ebp),%eax
 90c:	8b 10                	mov    (%eax),%edx
 90e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 911:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 913:	8b 45 fc             	mov    -0x4(%ebp),%eax
 916:	8b 40 04             	mov    0x4(%eax),%eax
 919:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 920:	8b 45 fc             	mov    -0x4(%ebp),%eax
 923:	01 d0                	add    %edx,%eax
 925:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 928:	75 20                	jne    94a <free+0xcf>
    p->s.size += bp->s.size;
 92a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 92d:	8b 50 04             	mov    0x4(%eax),%edx
 930:	8b 45 f8             	mov    -0x8(%ebp),%eax
 933:	8b 40 04             	mov    0x4(%eax),%eax
 936:	01 c2                	add    %eax,%edx
 938:	8b 45 fc             	mov    -0x4(%ebp),%eax
 93b:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 93e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 941:	8b 10                	mov    (%eax),%edx
 943:	8b 45 fc             	mov    -0x4(%ebp),%eax
 946:	89 10                	mov    %edx,(%eax)
 948:	eb 08                	jmp    952 <free+0xd7>
  } else
    p->s.ptr = bp;
 94a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 94d:	8b 55 f8             	mov    -0x8(%ebp),%edx
 950:	89 10                	mov    %edx,(%eax)
  freep = p;
 952:	8b 45 fc             	mov    -0x4(%ebp),%eax
 955:	a3 78 0d 00 00       	mov    %eax,0xd78
}
 95a:	c9                   	leave  
 95b:	c3                   	ret    

0000095c <morecore>:

static Header*
morecore(uint nu)
{
 95c:	55                   	push   %ebp
 95d:	89 e5                	mov    %esp,%ebp
 95f:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 962:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 969:	77 07                	ja     972 <morecore+0x16>
    nu = 4096;
 96b:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 972:	8b 45 08             	mov    0x8(%ebp),%eax
 975:	c1 e0 03             	shl    $0x3,%eax
 978:	89 04 24             	mov    %eax,(%esp)
 97b:	e8 40 fc ff ff       	call   5c0 <sbrk>
 980:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 983:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 987:	75 07                	jne    990 <morecore+0x34>
    return 0;
 989:	b8 00 00 00 00       	mov    $0x0,%eax
 98e:	eb 22                	jmp    9b2 <morecore+0x56>
  hp = (Header*)p;
 990:	8b 45 f4             	mov    -0xc(%ebp),%eax
 993:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 996:	8b 45 f0             	mov    -0x10(%ebp),%eax
 999:	8b 55 08             	mov    0x8(%ebp),%edx
 99c:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 99f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9a2:	83 c0 08             	add    $0x8,%eax
 9a5:	89 04 24             	mov    %eax,(%esp)
 9a8:	e8 ce fe ff ff       	call   87b <free>
  return freep;
 9ad:	a1 78 0d 00 00       	mov    0xd78,%eax
}
 9b2:	c9                   	leave  
 9b3:	c3                   	ret    

000009b4 <malloc>:

void*
malloc(uint nbytes)
{
 9b4:	55                   	push   %ebp
 9b5:	89 e5                	mov    %esp,%ebp
 9b7:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9ba:	8b 45 08             	mov    0x8(%ebp),%eax
 9bd:	83 c0 07             	add    $0x7,%eax
 9c0:	c1 e8 03             	shr    $0x3,%eax
 9c3:	83 c0 01             	add    $0x1,%eax
 9c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 9c9:	a1 78 0d 00 00       	mov    0xd78,%eax
 9ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9d1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 9d5:	75 23                	jne    9fa <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 9d7:	c7 45 f0 70 0d 00 00 	movl   $0xd70,-0x10(%ebp)
 9de:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9e1:	a3 78 0d 00 00       	mov    %eax,0xd78
 9e6:	a1 78 0d 00 00       	mov    0xd78,%eax
 9eb:	a3 70 0d 00 00       	mov    %eax,0xd70
    base.s.size = 0;
 9f0:	c7 05 74 0d 00 00 00 	movl   $0x0,0xd74
 9f7:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9fd:	8b 00                	mov    (%eax),%eax
 9ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a05:	8b 40 04             	mov    0x4(%eax),%eax
 a08:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a0b:	72 4d                	jb     a5a <malloc+0xa6>
      if(p->s.size == nunits)
 a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a10:	8b 40 04             	mov    0x4(%eax),%eax
 a13:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a16:	75 0c                	jne    a24 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a18:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a1b:	8b 10                	mov    (%eax),%edx
 a1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a20:	89 10                	mov    %edx,(%eax)
 a22:	eb 26                	jmp    a4a <malloc+0x96>
      else {
        p->s.size -= nunits;
 a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a27:	8b 40 04             	mov    0x4(%eax),%eax
 a2a:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a2d:	89 c2                	mov    %eax,%edx
 a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a32:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a38:	8b 40 04             	mov    0x4(%eax),%eax
 a3b:	c1 e0 03             	shl    $0x3,%eax
 a3e:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a44:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a47:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a4a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a4d:	a3 78 0d 00 00       	mov    %eax,0xd78
      return (void*)(p + 1);
 a52:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a55:	83 c0 08             	add    $0x8,%eax
 a58:	eb 38                	jmp    a92 <malloc+0xde>
    }
    if(p == freep)
 a5a:	a1 78 0d 00 00       	mov    0xd78,%eax
 a5f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a62:	75 1b                	jne    a7f <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 a64:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a67:	89 04 24             	mov    %eax,(%esp)
 a6a:	e8 ed fe ff ff       	call   95c <morecore>
 a6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 a72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a76:	75 07                	jne    a7f <malloc+0xcb>
        return 0;
 a78:	b8 00 00 00 00       	mov    $0x0,%eax
 a7d:	eb 13                	jmp    a92 <malloc+0xde>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a82:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a88:	8b 00                	mov    (%eax),%eax
 a8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 a8d:	e9 70 ff ff ff       	jmp    a02 <malloc+0x4e>
}
 a92:	c9                   	leave  
 a93:	c3                   	ret    
