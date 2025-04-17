
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
   6:	eb 39                	jmp    41 <cat+0x41>
    if (write(1, buf, n) != n) {
   8:	8b 45 f4             	mov    -0xc(%ebp),%eax
   b:	89 44 24 08          	mov    %eax,0x8(%esp)
   f:	c7 44 24 04 60 0d 00 	movl   $0xd60,0x4(%esp)
  16:	00 
  17:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1e:	e8 bd 04 00 00       	call   4e0 <write>
  23:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  26:	74 19                	je     41 <cat+0x41>
      printf(1, "cat: write error\n");
  28:	c7 44 24 04 1c 0a 00 	movl   $0xa1c,0x4(%esp)
  2f:	00 
  30:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  37:	e8 14 06 00 00       	call   650 <printf>
      exit();
  3c:	e8 7f 04 00 00       	call   4c0 <exit>
  while((n = read(fd, buf, sizeof(buf))) > 0) {
  41:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  48:	00 
  49:	c7 44 24 04 60 0d 00 	movl   $0xd60,0x4(%esp)
  50:	00 
  51:	8b 45 08             	mov    0x8(%ebp),%eax
  54:	89 04 24             	mov    %eax,(%esp)
  57:	e8 7c 04 00 00       	call   4d8 <read>
  5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  5f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  63:	7f a3                	jg     8 <cat+0x8>
    }
  }
  if(n < 0){
  65:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  69:	79 19                	jns    84 <cat+0x84>
    printf(1, "cat: read error\n");
  6b:	c7 44 24 04 2e 0a 00 	movl   $0xa2e,0x4(%esp)
  72:	00 
  73:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  7a:	e8 d1 05 00 00       	call   650 <printf>
    exit();
  7f:	e8 3c 04 00 00       	call   4c0 <exit>
  }
}
  84:	c9                   	leave  
  85:	c3                   	ret    

00000086 <main>:

int
main(int argc, char *argv[])
{
  86:	55                   	push   %ebp
  87:	89 e5                	mov    %esp,%ebp
  89:	83 e4 f0             	and    $0xfffffff0,%esp
  8c:	83 ec 20             	sub    $0x20,%esp
  int fd, i;

  if(argc <= 1){
  8f:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  93:	7f 11                	jg     a6 <main+0x20>
    cat(0);
  95:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  9c:	e8 5f ff ff ff       	call   0 <cat>
    exit();
  a1:	e8 1a 04 00 00       	call   4c0 <exit>
  }

  for(i = 1; i < argc; i++){
  a6:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
  ad:	00 
  ae:	eb 79                	jmp    129 <main+0xa3>
    if((fd = open(argv[i], 0)) < 0){
  b0:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  b4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  be:	01 d0                	add    %edx,%eax
  c0:	8b 00                	mov    (%eax),%eax
  c2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  c9:	00 
  ca:	89 04 24             	mov    %eax,(%esp)
  cd:	e8 2e 04 00 00       	call   500 <open>
  d2:	89 44 24 18          	mov    %eax,0x18(%esp)
  d6:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  db:	79 2f                	jns    10c <main+0x86>
      printf(1, "cat: cannot open %s\n", argv[i]);
  dd:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  e1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  eb:	01 d0                	add    %edx,%eax
  ed:	8b 00                	mov    (%eax),%eax
  ef:	89 44 24 08          	mov    %eax,0x8(%esp)
  f3:	c7 44 24 04 3f 0a 00 	movl   $0xa3f,0x4(%esp)
  fa:	00 
  fb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 102:	e8 49 05 00 00       	call   650 <printf>
      exit();
 107:	e8 b4 03 00 00       	call   4c0 <exit>
    }
    cat(fd);
 10c:	8b 44 24 18          	mov    0x18(%esp),%eax
 110:	89 04 24             	mov    %eax,(%esp)
 113:	e8 e8 fe ff ff       	call   0 <cat>
    close(fd);
 118:	8b 44 24 18          	mov    0x18(%esp),%eax
 11c:	89 04 24             	mov    %eax,(%esp)
 11f:	e8 c4 03 00 00       	call   4e8 <close>
  for(i = 1; i < argc; i++){
 124:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 129:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 12d:	3b 45 08             	cmp    0x8(%ebp),%eax
 130:	0f 8c 7a ff ff ff    	jl     b0 <main+0x2a>
  }
  exit();
 136:	e8 85 03 00 00       	call   4c0 <exit>

0000013b <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 13b:	55                   	push   %ebp
 13c:	89 e5                	mov    %esp,%ebp
 13e:	57                   	push   %edi
 13f:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 140:	8b 4d 08             	mov    0x8(%ebp),%ecx
 143:	8b 55 10             	mov    0x10(%ebp),%edx
 146:	8b 45 0c             	mov    0xc(%ebp),%eax
 149:	89 cb                	mov    %ecx,%ebx
 14b:	89 df                	mov    %ebx,%edi
 14d:	89 d1                	mov    %edx,%ecx
 14f:	fc                   	cld    
 150:	f3 aa                	rep stos %al,%es:(%edi)
 152:	89 ca                	mov    %ecx,%edx
 154:	89 fb                	mov    %edi,%ebx
 156:	89 5d 08             	mov    %ebx,0x8(%ebp)
 159:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 15c:	5b                   	pop    %ebx
 15d:	5f                   	pop    %edi
 15e:	5d                   	pop    %ebp
 15f:	c3                   	ret    

00000160 <strcpy>:
#include "x86.h"
#include "pstat.h"

char*
strcpy(char *s, const char *t)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 166:	8b 45 08             	mov    0x8(%ebp),%eax
 169:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 16c:	90                   	nop
 16d:	8b 45 08             	mov    0x8(%ebp),%eax
 170:	8d 50 01             	lea    0x1(%eax),%edx
 173:	89 55 08             	mov    %edx,0x8(%ebp)
 176:	8b 55 0c             	mov    0xc(%ebp),%edx
 179:	8d 4a 01             	lea    0x1(%edx),%ecx
 17c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 17f:	0f b6 12             	movzbl (%edx),%edx
 182:	88 10                	mov    %dl,(%eax)
 184:	0f b6 00             	movzbl (%eax),%eax
 187:	84 c0                	test   %al,%al
 189:	75 e2                	jne    16d <strcpy+0xd>
    ;
  return os;
 18b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 18e:	c9                   	leave  
 18f:	c3                   	ret    

00000190 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 193:	eb 08                	jmp    19d <strcmp+0xd>
    p++, q++;
 195:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 199:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 19d:	8b 45 08             	mov    0x8(%ebp),%eax
 1a0:	0f b6 00             	movzbl (%eax),%eax
 1a3:	84 c0                	test   %al,%al
 1a5:	74 10                	je     1b7 <strcmp+0x27>
 1a7:	8b 45 08             	mov    0x8(%ebp),%eax
 1aa:	0f b6 10             	movzbl (%eax),%edx
 1ad:	8b 45 0c             	mov    0xc(%ebp),%eax
 1b0:	0f b6 00             	movzbl (%eax),%eax
 1b3:	38 c2                	cmp    %al,%dl
 1b5:	74 de                	je     195 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 1b7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ba:	0f b6 00             	movzbl (%eax),%eax
 1bd:	0f b6 d0             	movzbl %al,%edx
 1c0:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c3:	0f b6 00             	movzbl (%eax),%eax
 1c6:	0f b6 c0             	movzbl %al,%eax
 1c9:	29 c2                	sub    %eax,%edx
 1cb:	89 d0                	mov    %edx,%eax
}
 1cd:	5d                   	pop    %ebp
 1ce:	c3                   	ret    

000001cf <strlen>:

uint
strlen(const char *s)
{
 1cf:	55                   	push   %ebp
 1d0:	89 e5                	mov    %esp,%ebp
 1d2:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1d5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1dc:	eb 04                	jmp    1e2 <strlen+0x13>
 1de:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1e2:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1e5:	8b 45 08             	mov    0x8(%ebp),%eax
 1e8:	01 d0                	add    %edx,%eax
 1ea:	0f b6 00             	movzbl (%eax),%eax
 1ed:	84 c0                	test   %al,%al
 1ef:	75 ed                	jne    1de <strlen+0xf>
    ;
  return n;
 1f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1f4:	c9                   	leave  
 1f5:	c3                   	ret    

000001f6 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1f6:	55                   	push   %ebp
 1f7:	89 e5                	mov    %esp,%ebp
 1f9:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1fc:	8b 45 10             	mov    0x10(%ebp),%eax
 1ff:	89 44 24 08          	mov    %eax,0x8(%esp)
 203:	8b 45 0c             	mov    0xc(%ebp),%eax
 206:	89 44 24 04          	mov    %eax,0x4(%esp)
 20a:	8b 45 08             	mov    0x8(%ebp),%eax
 20d:	89 04 24             	mov    %eax,(%esp)
 210:	e8 26 ff ff ff       	call   13b <stosb>
  return dst;
 215:	8b 45 08             	mov    0x8(%ebp),%eax
}
 218:	c9                   	leave  
 219:	c3                   	ret    

0000021a <strchr>:

char*
strchr(const char *s, char c)
{
 21a:	55                   	push   %ebp
 21b:	89 e5                	mov    %esp,%ebp
 21d:	83 ec 04             	sub    $0x4,%esp
 220:	8b 45 0c             	mov    0xc(%ebp),%eax
 223:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 226:	eb 14                	jmp    23c <strchr+0x22>
    if(*s == c)
 228:	8b 45 08             	mov    0x8(%ebp),%eax
 22b:	0f b6 00             	movzbl (%eax),%eax
 22e:	3a 45 fc             	cmp    -0x4(%ebp),%al
 231:	75 05                	jne    238 <strchr+0x1e>
      return (char*)s;
 233:	8b 45 08             	mov    0x8(%ebp),%eax
 236:	eb 13                	jmp    24b <strchr+0x31>
  for(; *s; s++)
 238:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 23c:	8b 45 08             	mov    0x8(%ebp),%eax
 23f:	0f b6 00             	movzbl (%eax),%eax
 242:	84 c0                	test   %al,%al
 244:	75 e2                	jne    228 <strchr+0xe>
  return 0;
 246:	b8 00 00 00 00       	mov    $0x0,%eax
}
 24b:	c9                   	leave  
 24c:	c3                   	ret    

0000024d <gets>:

char*
gets(char *buf, int max)
{
 24d:	55                   	push   %ebp
 24e:	89 e5                	mov    %esp,%ebp
 250:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 253:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 25a:	eb 4c                	jmp    2a8 <gets+0x5b>
    cc = read(0, &c, 1);
 25c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 263:	00 
 264:	8d 45 ef             	lea    -0x11(%ebp),%eax
 267:	89 44 24 04          	mov    %eax,0x4(%esp)
 26b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 272:	e8 61 02 00 00       	call   4d8 <read>
 277:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 27a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 27e:	7f 02                	jg     282 <gets+0x35>
      break;
 280:	eb 31                	jmp    2b3 <gets+0x66>
    buf[i++] = c;
 282:	8b 45 f4             	mov    -0xc(%ebp),%eax
 285:	8d 50 01             	lea    0x1(%eax),%edx
 288:	89 55 f4             	mov    %edx,-0xc(%ebp)
 28b:	89 c2                	mov    %eax,%edx
 28d:	8b 45 08             	mov    0x8(%ebp),%eax
 290:	01 c2                	add    %eax,%edx
 292:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 296:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 298:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 29c:	3c 0a                	cmp    $0xa,%al
 29e:	74 13                	je     2b3 <gets+0x66>
 2a0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2a4:	3c 0d                	cmp    $0xd,%al
 2a6:	74 0b                	je     2b3 <gets+0x66>
  for(i=0; i+1 < max; ){
 2a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2ab:	83 c0 01             	add    $0x1,%eax
 2ae:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2b1:	7c a9                	jl     25c <gets+0xf>
      break;
  }
  buf[i] = '\0';
 2b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2b6:	8b 45 08             	mov    0x8(%ebp),%eax
 2b9:	01 d0                	add    %edx,%eax
 2bb:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2be:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c1:	c9                   	leave  
 2c2:	c3                   	ret    

000002c3 <stat>:

int
stat(const char *n, struct stat *st)
{
 2c3:	55                   	push   %ebp
 2c4:	89 e5                	mov    %esp,%ebp
 2c6:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2c9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2d0:	00 
 2d1:	8b 45 08             	mov    0x8(%ebp),%eax
 2d4:	89 04 24             	mov    %eax,(%esp)
 2d7:	e8 24 02 00 00       	call   500 <open>
 2dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2df:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2e3:	79 07                	jns    2ec <stat+0x29>
    return -1;
 2e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2ea:	eb 23                	jmp    30f <stat+0x4c>
  r = fstat(fd, st);
 2ec:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ef:	89 44 24 04          	mov    %eax,0x4(%esp)
 2f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2f6:	89 04 24             	mov    %eax,(%esp)
 2f9:	e8 1a 02 00 00       	call   518 <fstat>
 2fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 301:	8b 45 f4             	mov    -0xc(%ebp),%eax
 304:	89 04 24             	mov    %eax,(%esp)
 307:	e8 dc 01 00 00       	call   4e8 <close>
  return r;
 30c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 30f:	c9                   	leave  
 310:	c3                   	ret    

00000311 <atoi>:

int
atoi(const char *s)
{
 311:	55                   	push   %ebp
 312:	89 e5                	mov    %esp,%ebp
 314:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 317:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 31e:	eb 25                	jmp    345 <atoi+0x34>
    n = n*10 + *s++ - '0';
 320:	8b 55 fc             	mov    -0x4(%ebp),%edx
 323:	89 d0                	mov    %edx,%eax
 325:	c1 e0 02             	shl    $0x2,%eax
 328:	01 d0                	add    %edx,%eax
 32a:	01 c0                	add    %eax,%eax
 32c:	89 c1                	mov    %eax,%ecx
 32e:	8b 45 08             	mov    0x8(%ebp),%eax
 331:	8d 50 01             	lea    0x1(%eax),%edx
 334:	89 55 08             	mov    %edx,0x8(%ebp)
 337:	0f b6 00             	movzbl (%eax),%eax
 33a:	0f be c0             	movsbl %al,%eax
 33d:	01 c8                	add    %ecx,%eax
 33f:	83 e8 30             	sub    $0x30,%eax
 342:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 345:	8b 45 08             	mov    0x8(%ebp),%eax
 348:	0f b6 00             	movzbl (%eax),%eax
 34b:	3c 2f                	cmp    $0x2f,%al
 34d:	7e 0a                	jle    359 <atoi+0x48>
 34f:	8b 45 08             	mov    0x8(%ebp),%eax
 352:	0f b6 00             	movzbl (%eax),%eax
 355:	3c 39                	cmp    $0x39,%al
 357:	7e c7                	jle    320 <atoi+0xf>
  return n;
 359:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 35c:	c9                   	leave  
 35d:	c3                   	ret    

0000035e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 35e:	55                   	push   %ebp
 35f:	89 e5                	mov    %esp,%ebp
 361:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 364:	8b 45 08             	mov    0x8(%ebp),%eax
 367:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 36a:	8b 45 0c             	mov    0xc(%ebp),%eax
 36d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 370:	eb 17                	jmp    389 <memmove+0x2b>
    *dst++ = *src++;
 372:	8b 45 fc             	mov    -0x4(%ebp),%eax
 375:	8d 50 01             	lea    0x1(%eax),%edx
 378:	89 55 fc             	mov    %edx,-0x4(%ebp)
 37b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 37e:	8d 4a 01             	lea    0x1(%edx),%ecx
 381:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 384:	0f b6 12             	movzbl (%edx),%edx
 387:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 389:	8b 45 10             	mov    0x10(%ebp),%eax
 38c:	8d 50 ff             	lea    -0x1(%eax),%edx
 38f:	89 55 10             	mov    %edx,0x10(%ebp)
 392:	85 c0                	test   %eax,%eax
 394:	7f dc                	jg     372 <memmove+0x14>
  return vdst;
 396:	8b 45 08             	mov    0x8(%ebp),%eax
}
 399:	c9                   	leave  
 39a:	c3                   	ret    

0000039b <ps>:

void 
ps()
{
 39b:	55                   	push   %ebp
 39c:	89 e5                	mov    %esp,%ebp
 39e:	57                   	push   %edi
 39f:	56                   	push   %esi
 3a0:	53                   	push   %ebx
 3a1:	81 ec 3c 09 00 00    	sub    $0x93c,%esp
  pstatTable pTable;
  getpinfo(&pTable);
 3a7:	8d 85 e4 f6 ff ff    	lea    -0x91c(%ebp),%eax
 3ad:	89 04 24             	mov    %eax,(%esp)
 3b0:	e8 ab 01 00 00       	call   560 <getpinfo>
  printf(1, "PID\tTKTS\tTCKS\tSTAT\tNAME\n");
 3b5:	c7 44 24 04 54 0a 00 	movl   $0xa54,0x4(%esp)
 3bc:	00 
 3bd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 3c4:	e8 87 02 00 00       	call   650 <printf>
  int i;
  for (i = 0; i < NPROC; i++)
 3c9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 3d0:	e9 ce 00 00 00       	jmp    4a3 <ps+0x108>
  {
    if(pTable[i].inuse)
 3d5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 3d8:	89 d0                	mov    %edx,%eax
 3da:	c1 e0 03             	shl    $0x3,%eax
 3dd:	01 d0                	add    %edx,%eax
 3df:	c1 e0 02             	shl    $0x2,%eax
 3e2:	8d 5d e8             	lea    -0x18(%ebp),%ebx
 3e5:	01 d8                	add    %ebx,%eax
 3e7:	2d 04 09 00 00       	sub    $0x904,%eax
 3ec:	8b 00                	mov    (%eax),%eax
 3ee:	85 c0                	test   %eax,%eax
 3f0:	0f 84 a9 00 00 00    	je     49f <ps+0x104>
      printf(1, "%d\t%d\t%d\t%c\t%s\n", pTable[i].pid, pTable[i].tickets, pTable[i].ticks, pTable[i].state, pTable[i].name);
 3f6:	8d 8d e4 f6 ff ff    	lea    -0x91c(%ebp),%ecx
 3fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 3ff:	89 d0                	mov    %edx,%eax
 401:	c1 e0 03             	shl    $0x3,%eax
 404:	01 d0                	add    %edx,%eax
 406:	c1 e0 02             	shl    $0x2,%eax
 409:	83 c0 10             	add    $0x10,%eax
 40c:	8d 3c 01             	lea    (%ecx,%eax,1),%edi
 40f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 412:	89 d0                	mov    %edx,%eax
 414:	c1 e0 03             	shl    $0x3,%eax
 417:	01 d0                	add    %edx,%eax
 419:	c1 e0 02             	shl    $0x2,%eax
 41c:	8d 75 e8             	lea    -0x18(%ebp),%esi
 41f:	01 f0                	add    %esi,%eax
 421:	2d e4 08 00 00       	sub    $0x8e4,%eax
 426:	0f b6 00             	movzbl (%eax),%eax
 429:	0f be f0             	movsbl %al,%esi
 42c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 42f:	89 d0                	mov    %edx,%eax
 431:	c1 e0 03             	shl    $0x3,%eax
 434:	01 d0                	add    %edx,%eax
 436:	c1 e0 02             	shl    $0x2,%eax
 439:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 43c:	01 c8                	add    %ecx,%eax
 43e:	2d f8 08 00 00       	sub    $0x8f8,%eax
 443:	8b 18                	mov    (%eax),%ebx
 445:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 448:	89 d0                	mov    %edx,%eax
 44a:	c1 e0 03             	shl    $0x3,%eax
 44d:	01 d0                	add    %edx,%eax
 44f:	c1 e0 02             	shl    $0x2,%eax
 452:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 455:	01 c8                	add    %ecx,%eax
 457:	2d 00 09 00 00       	sub    $0x900,%eax
 45c:	8b 08                	mov    (%eax),%ecx
 45e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 461:	89 d0                	mov    %edx,%eax
 463:	c1 e0 03             	shl    $0x3,%eax
 466:	01 d0                	add    %edx,%eax
 468:	c1 e0 02             	shl    $0x2,%eax
 46b:	8d 55 e8             	lea    -0x18(%ebp),%edx
 46e:	01 d0                	add    %edx,%eax
 470:	2d fc 08 00 00       	sub    $0x8fc,%eax
 475:	8b 00                	mov    (%eax),%eax
 477:	89 7c 24 18          	mov    %edi,0x18(%esp)
 47b:	89 74 24 14          	mov    %esi,0x14(%esp)
 47f:	89 5c 24 10          	mov    %ebx,0x10(%esp)
 483:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 487:	89 44 24 08          	mov    %eax,0x8(%esp)
 48b:	c7 44 24 04 6d 0a 00 	movl   $0xa6d,0x4(%esp)
 492:	00 
 493:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 49a:	e8 b1 01 00 00       	call   650 <printf>
  for (i = 0; i < NPROC; i++)
 49f:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 4a3:	83 7d e4 3f          	cmpl   $0x3f,-0x1c(%ebp)
 4a7:	0f 8e 28 ff ff ff    	jle    3d5 <ps+0x3a>
  }
}
 4ad:	81 c4 3c 09 00 00    	add    $0x93c,%esp
 4b3:	5b                   	pop    %ebx
 4b4:	5e                   	pop    %esi
 4b5:	5f                   	pop    %edi
 4b6:	5d                   	pop    %ebp
 4b7:	c3                   	ret    

000004b8 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4b8:	b8 01 00 00 00       	mov    $0x1,%eax
 4bd:	cd 40                	int    $0x40
 4bf:	c3                   	ret    

000004c0 <exit>:
SYSCALL(exit)
 4c0:	b8 02 00 00 00       	mov    $0x2,%eax
 4c5:	cd 40                	int    $0x40
 4c7:	c3                   	ret    

000004c8 <wait>:
SYSCALL(wait)
 4c8:	b8 03 00 00 00       	mov    $0x3,%eax
 4cd:	cd 40                	int    $0x40
 4cf:	c3                   	ret    

000004d0 <pipe>:
SYSCALL(pipe)
 4d0:	b8 04 00 00 00       	mov    $0x4,%eax
 4d5:	cd 40                	int    $0x40
 4d7:	c3                   	ret    

000004d8 <read>:
SYSCALL(read)
 4d8:	b8 05 00 00 00       	mov    $0x5,%eax
 4dd:	cd 40                	int    $0x40
 4df:	c3                   	ret    

000004e0 <write>:
SYSCALL(write)
 4e0:	b8 10 00 00 00       	mov    $0x10,%eax
 4e5:	cd 40                	int    $0x40
 4e7:	c3                   	ret    

000004e8 <close>:
SYSCALL(close)
 4e8:	b8 15 00 00 00       	mov    $0x15,%eax
 4ed:	cd 40                	int    $0x40
 4ef:	c3                   	ret    

000004f0 <kill>:
SYSCALL(kill)
 4f0:	b8 06 00 00 00       	mov    $0x6,%eax
 4f5:	cd 40                	int    $0x40
 4f7:	c3                   	ret    

000004f8 <exec>:
SYSCALL(exec)
 4f8:	b8 07 00 00 00       	mov    $0x7,%eax
 4fd:	cd 40                	int    $0x40
 4ff:	c3                   	ret    

00000500 <open>:
SYSCALL(open)
 500:	b8 0f 00 00 00       	mov    $0xf,%eax
 505:	cd 40                	int    $0x40
 507:	c3                   	ret    

00000508 <mknod>:
SYSCALL(mknod)
 508:	b8 11 00 00 00       	mov    $0x11,%eax
 50d:	cd 40                	int    $0x40
 50f:	c3                   	ret    

00000510 <unlink>:
SYSCALL(unlink)
 510:	b8 12 00 00 00       	mov    $0x12,%eax
 515:	cd 40                	int    $0x40
 517:	c3                   	ret    

00000518 <fstat>:
SYSCALL(fstat)
 518:	b8 08 00 00 00       	mov    $0x8,%eax
 51d:	cd 40                	int    $0x40
 51f:	c3                   	ret    

00000520 <link>:
SYSCALL(link)
 520:	b8 13 00 00 00       	mov    $0x13,%eax
 525:	cd 40                	int    $0x40
 527:	c3                   	ret    

00000528 <mkdir>:
SYSCALL(mkdir)
 528:	b8 14 00 00 00       	mov    $0x14,%eax
 52d:	cd 40                	int    $0x40
 52f:	c3                   	ret    

00000530 <chdir>:
SYSCALL(chdir)
 530:	b8 09 00 00 00       	mov    $0x9,%eax
 535:	cd 40                	int    $0x40
 537:	c3                   	ret    

00000538 <dup>:
SYSCALL(dup)
 538:	b8 0a 00 00 00       	mov    $0xa,%eax
 53d:	cd 40                	int    $0x40
 53f:	c3                   	ret    

00000540 <getpid>:
SYSCALL(getpid)
 540:	b8 0b 00 00 00       	mov    $0xb,%eax
 545:	cd 40                	int    $0x40
 547:	c3                   	ret    

00000548 <sbrk>:
SYSCALL(sbrk)
 548:	b8 0c 00 00 00       	mov    $0xc,%eax
 54d:	cd 40                	int    $0x40
 54f:	c3                   	ret    

00000550 <sleep>:
SYSCALL(sleep)
 550:	b8 0d 00 00 00       	mov    $0xd,%eax
 555:	cd 40                	int    $0x40
 557:	c3                   	ret    

00000558 <uptime>:
SYSCALL(uptime)
 558:	b8 0e 00 00 00       	mov    $0xe,%eax
 55d:	cd 40                	int    $0x40
 55f:	c3                   	ret    

00000560 <getpinfo>:
SYSCALL(getpinfo)
 560:	b8 16 00 00 00       	mov    $0x16,%eax
 565:	cd 40                	int    $0x40
 567:	c3                   	ret    

00000568 <settickets>:
SYSCALL(settickets)
 568:	b8 18 00 00 00       	mov    $0x18,%eax
 56d:	cd 40                	int    $0x40
 56f:	c3                   	ret    

00000570 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 570:	55                   	push   %ebp
 571:	89 e5                	mov    %esp,%ebp
 573:	83 ec 18             	sub    $0x18,%esp
 576:	8b 45 0c             	mov    0xc(%ebp),%eax
 579:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 57c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 583:	00 
 584:	8d 45 f4             	lea    -0xc(%ebp),%eax
 587:	89 44 24 04          	mov    %eax,0x4(%esp)
 58b:	8b 45 08             	mov    0x8(%ebp),%eax
 58e:	89 04 24             	mov    %eax,(%esp)
 591:	e8 4a ff ff ff       	call   4e0 <write>
}
 596:	c9                   	leave  
 597:	c3                   	ret    

00000598 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 598:	55                   	push   %ebp
 599:	89 e5                	mov    %esp,%ebp
 59b:	56                   	push   %esi
 59c:	53                   	push   %ebx
 59d:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 5a0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 5a7:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 5ab:	74 17                	je     5c4 <printint+0x2c>
 5ad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 5b1:	79 11                	jns    5c4 <printint+0x2c>
    neg = 1;
 5b3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 5ba:	8b 45 0c             	mov    0xc(%ebp),%eax
 5bd:	f7 d8                	neg    %eax
 5bf:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5c2:	eb 06                	jmp    5ca <printint+0x32>
  } else {
    x = xx;
 5c4:	8b 45 0c             	mov    0xc(%ebp),%eax
 5c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 5ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 5d1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 5d4:	8d 41 01             	lea    0x1(%ecx),%eax
 5d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
 5da:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5e0:	ba 00 00 00 00       	mov    $0x0,%edx
 5e5:	f7 f3                	div    %ebx
 5e7:	89 d0                	mov    %edx,%eax
 5e9:	0f b6 80 18 0d 00 00 	movzbl 0xd18(%eax),%eax
 5f0:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 5f4:	8b 75 10             	mov    0x10(%ebp),%esi
 5f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5fa:	ba 00 00 00 00       	mov    $0x0,%edx
 5ff:	f7 f6                	div    %esi
 601:	89 45 ec             	mov    %eax,-0x14(%ebp)
 604:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 608:	75 c7                	jne    5d1 <printint+0x39>
  if(neg)
 60a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 60e:	74 10                	je     620 <printint+0x88>
    buf[i++] = '-';
 610:	8b 45 f4             	mov    -0xc(%ebp),%eax
 613:	8d 50 01             	lea    0x1(%eax),%edx
 616:	89 55 f4             	mov    %edx,-0xc(%ebp)
 619:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 61e:	eb 1f                	jmp    63f <printint+0xa7>
 620:	eb 1d                	jmp    63f <printint+0xa7>
    putc(fd, buf[i]);
 622:	8d 55 dc             	lea    -0x24(%ebp),%edx
 625:	8b 45 f4             	mov    -0xc(%ebp),%eax
 628:	01 d0                	add    %edx,%eax
 62a:	0f b6 00             	movzbl (%eax),%eax
 62d:	0f be c0             	movsbl %al,%eax
 630:	89 44 24 04          	mov    %eax,0x4(%esp)
 634:	8b 45 08             	mov    0x8(%ebp),%eax
 637:	89 04 24             	mov    %eax,(%esp)
 63a:	e8 31 ff ff ff       	call   570 <putc>
  while(--i >= 0)
 63f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 643:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 647:	79 d9                	jns    622 <printint+0x8a>
}
 649:	83 c4 30             	add    $0x30,%esp
 64c:	5b                   	pop    %ebx
 64d:	5e                   	pop    %esi
 64e:	5d                   	pop    %ebp
 64f:	c3                   	ret    

00000650 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 650:	55                   	push   %ebp
 651:	89 e5                	mov    %esp,%ebp
 653:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 656:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 65d:	8d 45 0c             	lea    0xc(%ebp),%eax
 660:	83 c0 04             	add    $0x4,%eax
 663:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 666:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 66d:	e9 7c 01 00 00       	jmp    7ee <printf+0x19e>
    c = fmt[i] & 0xff;
 672:	8b 55 0c             	mov    0xc(%ebp),%edx
 675:	8b 45 f0             	mov    -0x10(%ebp),%eax
 678:	01 d0                	add    %edx,%eax
 67a:	0f b6 00             	movzbl (%eax),%eax
 67d:	0f be c0             	movsbl %al,%eax
 680:	25 ff 00 00 00       	and    $0xff,%eax
 685:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 688:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 68c:	75 2c                	jne    6ba <printf+0x6a>
      if(c == '%'){
 68e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 692:	75 0c                	jne    6a0 <printf+0x50>
        state = '%';
 694:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 69b:	e9 4a 01 00 00       	jmp    7ea <printf+0x19a>
      } else {
        putc(fd, c);
 6a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6a3:	0f be c0             	movsbl %al,%eax
 6a6:	89 44 24 04          	mov    %eax,0x4(%esp)
 6aa:	8b 45 08             	mov    0x8(%ebp),%eax
 6ad:	89 04 24             	mov    %eax,(%esp)
 6b0:	e8 bb fe ff ff       	call   570 <putc>
 6b5:	e9 30 01 00 00       	jmp    7ea <printf+0x19a>
      }
    } else if(state == '%'){
 6ba:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 6be:	0f 85 26 01 00 00    	jne    7ea <printf+0x19a>
      if(c == 'd'){
 6c4:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 6c8:	75 2d                	jne    6f7 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 6ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6cd:	8b 00                	mov    (%eax),%eax
 6cf:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 6d6:	00 
 6d7:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 6de:	00 
 6df:	89 44 24 04          	mov    %eax,0x4(%esp)
 6e3:	8b 45 08             	mov    0x8(%ebp),%eax
 6e6:	89 04 24             	mov    %eax,(%esp)
 6e9:	e8 aa fe ff ff       	call   598 <printint>
        ap++;
 6ee:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6f2:	e9 ec 00 00 00       	jmp    7e3 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 6f7:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6fb:	74 06                	je     703 <printf+0xb3>
 6fd:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 701:	75 2d                	jne    730 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 703:	8b 45 e8             	mov    -0x18(%ebp),%eax
 706:	8b 00                	mov    (%eax),%eax
 708:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 70f:	00 
 710:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 717:	00 
 718:	89 44 24 04          	mov    %eax,0x4(%esp)
 71c:	8b 45 08             	mov    0x8(%ebp),%eax
 71f:	89 04 24             	mov    %eax,(%esp)
 722:	e8 71 fe ff ff       	call   598 <printint>
        ap++;
 727:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 72b:	e9 b3 00 00 00       	jmp    7e3 <printf+0x193>
      } else if(c == 's'){
 730:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 734:	75 45                	jne    77b <printf+0x12b>
        s = (char*)*ap;
 736:	8b 45 e8             	mov    -0x18(%ebp),%eax
 739:	8b 00                	mov    (%eax),%eax
 73b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 73e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 742:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 746:	75 09                	jne    751 <printf+0x101>
          s = "(null)";
 748:	c7 45 f4 7d 0a 00 00 	movl   $0xa7d,-0xc(%ebp)
        while(*s != 0){
 74f:	eb 1e                	jmp    76f <printf+0x11f>
 751:	eb 1c                	jmp    76f <printf+0x11f>
          putc(fd, *s);
 753:	8b 45 f4             	mov    -0xc(%ebp),%eax
 756:	0f b6 00             	movzbl (%eax),%eax
 759:	0f be c0             	movsbl %al,%eax
 75c:	89 44 24 04          	mov    %eax,0x4(%esp)
 760:	8b 45 08             	mov    0x8(%ebp),%eax
 763:	89 04 24             	mov    %eax,(%esp)
 766:	e8 05 fe ff ff       	call   570 <putc>
          s++;
 76b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 76f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 772:	0f b6 00             	movzbl (%eax),%eax
 775:	84 c0                	test   %al,%al
 777:	75 da                	jne    753 <printf+0x103>
 779:	eb 68                	jmp    7e3 <printf+0x193>
        }
      } else if(c == 'c'){
 77b:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 77f:	75 1d                	jne    79e <printf+0x14e>
        putc(fd, *ap);
 781:	8b 45 e8             	mov    -0x18(%ebp),%eax
 784:	8b 00                	mov    (%eax),%eax
 786:	0f be c0             	movsbl %al,%eax
 789:	89 44 24 04          	mov    %eax,0x4(%esp)
 78d:	8b 45 08             	mov    0x8(%ebp),%eax
 790:	89 04 24             	mov    %eax,(%esp)
 793:	e8 d8 fd ff ff       	call   570 <putc>
        ap++;
 798:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 79c:	eb 45                	jmp    7e3 <printf+0x193>
      } else if(c == '%'){
 79e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7a2:	75 17                	jne    7bb <printf+0x16b>
        putc(fd, c);
 7a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7a7:	0f be c0             	movsbl %al,%eax
 7aa:	89 44 24 04          	mov    %eax,0x4(%esp)
 7ae:	8b 45 08             	mov    0x8(%ebp),%eax
 7b1:	89 04 24             	mov    %eax,(%esp)
 7b4:	e8 b7 fd ff ff       	call   570 <putc>
 7b9:	eb 28                	jmp    7e3 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7bb:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 7c2:	00 
 7c3:	8b 45 08             	mov    0x8(%ebp),%eax
 7c6:	89 04 24             	mov    %eax,(%esp)
 7c9:	e8 a2 fd ff ff       	call   570 <putc>
        putc(fd, c);
 7ce:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7d1:	0f be c0             	movsbl %al,%eax
 7d4:	89 44 24 04          	mov    %eax,0x4(%esp)
 7d8:	8b 45 08             	mov    0x8(%ebp),%eax
 7db:	89 04 24             	mov    %eax,(%esp)
 7de:	e8 8d fd ff ff       	call   570 <putc>
      }
      state = 0;
 7e3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 7ea:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 7ee:	8b 55 0c             	mov    0xc(%ebp),%edx
 7f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f4:	01 d0                	add    %edx,%eax
 7f6:	0f b6 00             	movzbl (%eax),%eax
 7f9:	84 c0                	test   %al,%al
 7fb:	0f 85 71 fe ff ff    	jne    672 <printf+0x22>
    }
  }
}
 801:	c9                   	leave  
 802:	c3                   	ret    

00000803 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 803:	55                   	push   %ebp
 804:	89 e5                	mov    %esp,%ebp
 806:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 809:	8b 45 08             	mov    0x8(%ebp),%eax
 80c:	83 e8 08             	sub    $0x8,%eax
 80f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 812:	a1 48 0d 00 00       	mov    0xd48,%eax
 817:	89 45 fc             	mov    %eax,-0x4(%ebp)
 81a:	eb 24                	jmp    840 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 81c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81f:	8b 00                	mov    (%eax),%eax
 821:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 824:	77 12                	ja     838 <free+0x35>
 826:	8b 45 f8             	mov    -0x8(%ebp),%eax
 829:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 82c:	77 24                	ja     852 <free+0x4f>
 82e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 831:	8b 00                	mov    (%eax),%eax
 833:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 836:	77 1a                	ja     852 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 838:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83b:	8b 00                	mov    (%eax),%eax
 83d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 840:	8b 45 f8             	mov    -0x8(%ebp),%eax
 843:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 846:	76 d4                	jbe    81c <free+0x19>
 848:	8b 45 fc             	mov    -0x4(%ebp),%eax
 84b:	8b 00                	mov    (%eax),%eax
 84d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 850:	76 ca                	jbe    81c <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 852:	8b 45 f8             	mov    -0x8(%ebp),%eax
 855:	8b 40 04             	mov    0x4(%eax),%eax
 858:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 85f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 862:	01 c2                	add    %eax,%edx
 864:	8b 45 fc             	mov    -0x4(%ebp),%eax
 867:	8b 00                	mov    (%eax),%eax
 869:	39 c2                	cmp    %eax,%edx
 86b:	75 24                	jne    891 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 86d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 870:	8b 50 04             	mov    0x4(%eax),%edx
 873:	8b 45 fc             	mov    -0x4(%ebp),%eax
 876:	8b 00                	mov    (%eax),%eax
 878:	8b 40 04             	mov    0x4(%eax),%eax
 87b:	01 c2                	add    %eax,%edx
 87d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 880:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 883:	8b 45 fc             	mov    -0x4(%ebp),%eax
 886:	8b 00                	mov    (%eax),%eax
 888:	8b 10                	mov    (%eax),%edx
 88a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 88d:	89 10                	mov    %edx,(%eax)
 88f:	eb 0a                	jmp    89b <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 891:	8b 45 fc             	mov    -0x4(%ebp),%eax
 894:	8b 10                	mov    (%eax),%edx
 896:	8b 45 f8             	mov    -0x8(%ebp),%eax
 899:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 89b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 89e:	8b 40 04             	mov    0x4(%eax),%eax
 8a1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ab:	01 d0                	add    %edx,%eax
 8ad:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8b0:	75 20                	jne    8d2 <free+0xcf>
    p->s.size += bp->s.size;
 8b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b5:	8b 50 04             	mov    0x4(%eax),%edx
 8b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8bb:	8b 40 04             	mov    0x4(%eax),%eax
 8be:	01 c2                	add    %eax,%edx
 8c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c3:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8c9:	8b 10                	mov    (%eax),%edx
 8cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ce:	89 10                	mov    %edx,(%eax)
 8d0:	eb 08                	jmp    8da <free+0xd7>
  } else
    p->s.ptr = bp;
 8d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d5:	8b 55 f8             	mov    -0x8(%ebp),%edx
 8d8:	89 10                	mov    %edx,(%eax)
  freep = p;
 8da:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8dd:	a3 48 0d 00 00       	mov    %eax,0xd48
}
 8e2:	c9                   	leave  
 8e3:	c3                   	ret    

000008e4 <morecore>:

static Header*
morecore(uint nu)
{
 8e4:	55                   	push   %ebp
 8e5:	89 e5                	mov    %esp,%ebp
 8e7:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 8ea:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 8f1:	77 07                	ja     8fa <morecore+0x16>
    nu = 4096;
 8f3:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 8fa:	8b 45 08             	mov    0x8(%ebp),%eax
 8fd:	c1 e0 03             	shl    $0x3,%eax
 900:	89 04 24             	mov    %eax,(%esp)
 903:	e8 40 fc ff ff       	call   548 <sbrk>
 908:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 90b:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 90f:	75 07                	jne    918 <morecore+0x34>
    return 0;
 911:	b8 00 00 00 00       	mov    $0x0,%eax
 916:	eb 22                	jmp    93a <morecore+0x56>
  hp = (Header*)p;
 918:	8b 45 f4             	mov    -0xc(%ebp),%eax
 91b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 91e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 921:	8b 55 08             	mov    0x8(%ebp),%edx
 924:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 927:	8b 45 f0             	mov    -0x10(%ebp),%eax
 92a:	83 c0 08             	add    $0x8,%eax
 92d:	89 04 24             	mov    %eax,(%esp)
 930:	e8 ce fe ff ff       	call   803 <free>
  return freep;
 935:	a1 48 0d 00 00       	mov    0xd48,%eax
}
 93a:	c9                   	leave  
 93b:	c3                   	ret    

0000093c <malloc>:

void*
malloc(uint nbytes)
{
 93c:	55                   	push   %ebp
 93d:	89 e5                	mov    %esp,%ebp
 93f:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 942:	8b 45 08             	mov    0x8(%ebp),%eax
 945:	83 c0 07             	add    $0x7,%eax
 948:	c1 e8 03             	shr    $0x3,%eax
 94b:	83 c0 01             	add    $0x1,%eax
 94e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 951:	a1 48 0d 00 00       	mov    0xd48,%eax
 956:	89 45 f0             	mov    %eax,-0x10(%ebp)
 959:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 95d:	75 23                	jne    982 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 95f:	c7 45 f0 40 0d 00 00 	movl   $0xd40,-0x10(%ebp)
 966:	8b 45 f0             	mov    -0x10(%ebp),%eax
 969:	a3 48 0d 00 00       	mov    %eax,0xd48
 96e:	a1 48 0d 00 00       	mov    0xd48,%eax
 973:	a3 40 0d 00 00       	mov    %eax,0xd40
    base.s.size = 0;
 978:	c7 05 44 0d 00 00 00 	movl   $0x0,0xd44
 97f:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 982:	8b 45 f0             	mov    -0x10(%ebp),%eax
 985:	8b 00                	mov    (%eax),%eax
 987:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 98a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 98d:	8b 40 04             	mov    0x4(%eax),%eax
 990:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 993:	72 4d                	jb     9e2 <malloc+0xa6>
      if(p->s.size == nunits)
 995:	8b 45 f4             	mov    -0xc(%ebp),%eax
 998:	8b 40 04             	mov    0x4(%eax),%eax
 99b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 99e:	75 0c                	jne    9ac <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 9a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a3:	8b 10                	mov    (%eax),%edx
 9a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9a8:	89 10                	mov    %edx,(%eax)
 9aa:	eb 26                	jmp    9d2 <malloc+0x96>
      else {
        p->s.size -= nunits;
 9ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9af:	8b 40 04             	mov    0x4(%eax),%eax
 9b2:	2b 45 ec             	sub    -0x14(%ebp),%eax
 9b5:	89 c2                	mov    %eax,%edx
 9b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ba:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 9bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c0:	8b 40 04             	mov    0x4(%eax),%eax
 9c3:	c1 e0 03             	shl    $0x3,%eax
 9c6:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 9c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9cc:	8b 55 ec             	mov    -0x14(%ebp),%edx
 9cf:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 9d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9d5:	a3 48 0d 00 00       	mov    %eax,0xd48
      return (void*)(p + 1);
 9da:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9dd:	83 c0 08             	add    $0x8,%eax
 9e0:	eb 38                	jmp    a1a <malloc+0xde>
    }
    if(p == freep)
 9e2:	a1 48 0d 00 00       	mov    0xd48,%eax
 9e7:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 9ea:	75 1b                	jne    a07 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 9ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
 9ef:	89 04 24             	mov    %eax,(%esp)
 9f2:	e8 ed fe ff ff       	call   8e4 <morecore>
 9f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9fe:	75 07                	jne    a07 <malloc+0xcb>
        return 0;
 a00:	b8 00 00 00 00       	mov    $0x0,%eax
 a05:	eb 13                	jmp    a1a <malloc+0xde>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a10:	8b 00                	mov    (%eax),%eax
 a12:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 a15:	e9 70 ff ff ff       	jmp    98a <malloc+0x4e>
}
 a1a:	c9                   	leave  
 a1b:	c3                   	ret    
