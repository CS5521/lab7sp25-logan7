
_schedtest:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 38             	sub    $0x38,%esp
  14:	89 cb                	mov    %ecx,%ebx
  16:	89 e0                	mov    %esp,%eax
  18:	89 c6                	mov    %eax,%esi
  int loops = atoi(argv[1]);
  1a:	8b 43 04             	mov    0x4(%ebx),%eax
  1d:	83 c0 04             	add    $0x4,%eax
  20:	8b 00                	mov    (%eax),%eax
  22:	89 04 24             	mov    %eax,(%esp)
  25:	e8 e6 02 00 00       	call   310 <atoi>
  2a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  int tickets[argc - 2];
  2d:	8b 03                	mov    (%ebx),%eax
  2f:	83 e8 02             	sub    $0x2,%eax
  32:	8d 50 ff             	lea    -0x1(%eax),%edx
  35:	89 55 dc             	mov    %edx,-0x24(%ebp)
  38:	c1 e0 02             	shl    $0x2,%eax
  3b:	8d 50 03             	lea    0x3(%eax),%edx
  3e:	b8 10 00 00 00       	mov    $0x10,%eax
  43:	83 e8 01             	sub    $0x1,%eax
  46:	01 d0                	add    %edx,%eax
  48:	b9 10 00 00 00       	mov    $0x10,%ecx
  4d:	ba 00 00 00 00       	mov    $0x0,%edx
  52:	f7 f1                	div    %ecx
  54:	6b c0 10             	imul   $0x10,%eax,%eax
  57:	29 c4                	sub    %eax,%esp
  59:	8d 44 24 04          	lea    0x4(%esp),%eax
  5d:	83 c0 03             	add    $0x3,%eax
  60:	c1 e8 02             	shr    $0x2,%eax
  63:	c1 e0 02             	shl    $0x2,%eax
  66:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int pid;

  int i;
  for(i = 2; i < argc; i++)
  69:	c7 45 e4 02 00 00 00 	movl   $0x2,-0x1c(%ebp)
  70:	eb 29                	jmp    9b <main+0x9b>
  {
    tickets[i-2] = atoi(argv[i]);
  72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  75:	8d 78 fe             	lea    -0x2(%eax),%edi
  78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  7b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  82:	8b 43 04             	mov    0x4(%ebx),%eax
  85:	01 d0                	add    %edx,%eax
  87:	8b 00                	mov    (%eax),%eax
  89:	89 04 24             	mov    %eax,(%esp)
  8c:	e8 7f 02 00 00       	call   310 <atoi>
  91:	8b 55 d8             	mov    -0x28(%ebp),%edx
  94:	89 04 ba             	mov    %eax,(%edx,%edi,4)
  for(i = 2; i < argc; i++)
  97:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
  9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  9e:	3b 03                	cmp    (%ebx),%eax
  a0:	7c d0                	jl     72 <main+0x72>
  }

  for(i = 0; i < argc-2; i++)
  a2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  a9:	90                   	nop
  aa:	8b 03                	mov    (%ebx),%eax
  ac:	83 e8 02             	sub    $0x2,%eax
  af:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  b2:	7e 73                	jle    127 <main+0x127>
  {
    pid = fork();
  b4:	e8 fe 03 00 00       	call   4b7 <fork>
  b9:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    if(pid == 0)
  bc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  c0:	75 13                	jne    d5 <main+0xd5>
    {
      settickets(tickets[i]);
  c2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  c5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  c8:	8b 04 90             	mov    (%eax,%edx,4),%eax
  cb:	89 04 24             	mov    %eax,(%esp)
  ce:	e8 94 04 00 00       	call   567 <settickets>
      while(1);
  d3:	eb fe                	jmp    d3 <main+0xd3>
    }
    else
    {
      for(i = 0; i < loops; i++)
  d5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  dc:	eb 15                	jmp    f3 <main+0xf3>
      {
        ps();
  de:	e8 b7 02 00 00       	call   39a <ps>
        sleep(3);
  e3:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  ea:	e8 60 04 00 00       	call   54f <sleep>
      for(i = 0; i < loops; i++)
  ef:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
  f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  f6:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  f9:	7c e3                	jl     de <main+0xde>
      }
      for(i = 0; i < argc-2; i++)
  fb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 102:	eb 14                	jmp    118 <main+0x118>
      {
        kill(pid);
 104:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 107:	89 04 24             	mov    %eax,(%esp)
 10a:	e8 e0 03 00 00       	call   4ef <kill>
        wait();
 10f:	e8 b3 03 00 00       	call   4c7 <wait>
      for(i = 0; i < argc-2; i++)
 114:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 118:	8b 03                	mov    (%ebx),%eax
 11a:	83 e8 02             	sub    $0x2,%eax
 11d:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
 120:	7f e2                	jg     104 <main+0x104>
      }
      exit();
 122:	e8 98 03 00 00       	call   4bf <exit>
    }
  }
  return 0;
 127:	b8 00 00 00 00       	mov    $0x0,%eax
 12c:	89 f4                	mov    %esi,%esp
}
 12e:	8d 65 f0             	lea    -0x10(%ebp),%esp
 131:	59                   	pop    %ecx
 132:	5b                   	pop    %ebx
 133:	5e                   	pop    %esi
 134:	5f                   	pop    %edi
 135:	5d                   	pop    %ebp
 136:	8d 61 fc             	lea    -0x4(%ecx),%esp
 139:	c3                   	ret    

0000013a <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 13a:	55                   	push   %ebp
 13b:	89 e5                	mov    %esp,%ebp
 13d:	57                   	push   %edi
 13e:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 13f:	8b 4d 08             	mov    0x8(%ebp),%ecx
 142:	8b 55 10             	mov    0x10(%ebp),%edx
 145:	8b 45 0c             	mov    0xc(%ebp),%eax
 148:	89 cb                	mov    %ecx,%ebx
 14a:	89 df                	mov    %ebx,%edi
 14c:	89 d1                	mov    %edx,%ecx
 14e:	fc                   	cld    
 14f:	f3 aa                	rep stos %al,%es:(%edi)
 151:	89 ca                	mov    %ecx,%edx
 153:	89 fb                	mov    %edi,%ebx
 155:	89 5d 08             	mov    %ebx,0x8(%ebp)
 158:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 15b:	5b                   	pop    %ebx
 15c:	5f                   	pop    %edi
 15d:	5d                   	pop    %ebp
 15e:	c3                   	ret    

0000015f <strcpy>:
#include "x86.h"
#include "pstat.h"

char*
strcpy(char *s, const char *t)
{
 15f:	55                   	push   %ebp
 160:	89 e5                	mov    %esp,%ebp
 162:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 165:	8b 45 08             	mov    0x8(%ebp),%eax
 168:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 16b:	90                   	nop
 16c:	8b 45 08             	mov    0x8(%ebp),%eax
 16f:	8d 50 01             	lea    0x1(%eax),%edx
 172:	89 55 08             	mov    %edx,0x8(%ebp)
 175:	8b 55 0c             	mov    0xc(%ebp),%edx
 178:	8d 4a 01             	lea    0x1(%edx),%ecx
 17b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 17e:	0f b6 12             	movzbl (%edx),%edx
 181:	88 10                	mov    %dl,(%eax)
 183:	0f b6 00             	movzbl (%eax),%eax
 186:	84 c0                	test   %al,%al
 188:	75 e2                	jne    16c <strcpy+0xd>
    ;
  return os;
 18a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 18d:	c9                   	leave  
 18e:	c3                   	ret    

0000018f <strcmp>:

int
strcmp(const char *p, const char *q)
{
 18f:	55                   	push   %ebp
 190:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 192:	eb 08                	jmp    19c <strcmp+0xd>
    p++, q++;
 194:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 198:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 19c:	8b 45 08             	mov    0x8(%ebp),%eax
 19f:	0f b6 00             	movzbl (%eax),%eax
 1a2:	84 c0                	test   %al,%al
 1a4:	74 10                	je     1b6 <strcmp+0x27>
 1a6:	8b 45 08             	mov    0x8(%ebp),%eax
 1a9:	0f b6 10             	movzbl (%eax),%edx
 1ac:	8b 45 0c             	mov    0xc(%ebp),%eax
 1af:	0f b6 00             	movzbl (%eax),%eax
 1b2:	38 c2                	cmp    %al,%dl
 1b4:	74 de                	je     194 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 1b6:	8b 45 08             	mov    0x8(%ebp),%eax
 1b9:	0f b6 00             	movzbl (%eax),%eax
 1bc:	0f b6 d0             	movzbl %al,%edx
 1bf:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c2:	0f b6 00             	movzbl (%eax),%eax
 1c5:	0f b6 c0             	movzbl %al,%eax
 1c8:	29 c2                	sub    %eax,%edx
 1ca:	89 d0                	mov    %edx,%eax
}
 1cc:	5d                   	pop    %ebp
 1cd:	c3                   	ret    

000001ce <strlen>:

uint
strlen(const char *s)
{
 1ce:	55                   	push   %ebp
 1cf:	89 e5                	mov    %esp,%ebp
 1d1:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1db:	eb 04                	jmp    1e1 <strlen+0x13>
 1dd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1e1:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1e4:	8b 45 08             	mov    0x8(%ebp),%eax
 1e7:	01 d0                	add    %edx,%eax
 1e9:	0f b6 00             	movzbl (%eax),%eax
 1ec:	84 c0                	test   %al,%al
 1ee:	75 ed                	jne    1dd <strlen+0xf>
    ;
  return n;
 1f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1f3:	c9                   	leave  
 1f4:	c3                   	ret    

000001f5 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1f5:	55                   	push   %ebp
 1f6:	89 e5                	mov    %esp,%ebp
 1f8:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1fb:	8b 45 10             	mov    0x10(%ebp),%eax
 1fe:	89 44 24 08          	mov    %eax,0x8(%esp)
 202:	8b 45 0c             	mov    0xc(%ebp),%eax
 205:	89 44 24 04          	mov    %eax,0x4(%esp)
 209:	8b 45 08             	mov    0x8(%ebp),%eax
 20c:	89 04 24             	mov    %eax,(%esp)
 20f:	e8 26 ff ff ff       	call   13a <stosb>
  return dst;
 214:	8b 45 08             	mov    0x8(%ebp),%eax
}
 217:	c9                   	leave  
 218:	c3                   	ret    

00000219 <strchr>:

char*
strchr(const char *s, char c)
{
 219:	55                   	push   %ebp
 21a:	89 e5                	mov    %esp,%ebp
 21c:	83 ec 04             	sub    $0x4,%esp
 21f:	8b 45 0c             	mov    0xc(%ebp),%eax
 222:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 225:	eb 14                	jmp    23b <strchr+0x22>
    if(*s == c)
 227:	8b 45 08             	mov    0x8(%ebp),%eax
 22a:	0f b6 00             	movzbl (%eax),%eax
 22d:	3a 45 fc             	cmp    -0x4(%ebp),%al
 230:	75 05                	jne    237 <strchr+0x1e>
      return (char*)s;
 232:	8b 45 08             	mov    0x8(%ebp),%eax
 235:	eb 13                	jmp    24a <strchr+0x31>
  for(; *s; s++)
 237:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 23b:	8b 45 08             	mov    0x8(%ebp),%eax
 23e:	0f b6 00             	movzbl (%eax),%eax
 241:	84 c0                	test   %al,%al
 243:	75 e2                	jne    227 <strchr+0xe>
  return 0;
 245:	b8 00 00 00 00       	mov    $0x0,%eax
}
 24a:	c9                   	leave  
 24b:	c3                   	ret    

0000024c <gets>:

char*
gets(char *buf, int max)
{
 24c:	55                   	push   %ebp
 24d:	89 e5                	mov    %esp,%ebp
 24f:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 252:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 259:	eb 4c                	jmp    2a7 <gets+0x5b>
    cc = read(0, &c, 1);
 25b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 262:	00 
 263:	8d 45 ef             	lea    -0x11(%ebp),%eax
 266:	89 44 24 04          	mov    %eax,0x4(%esp)
 26a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 271:	e8 61 02 00 00       	call   4d7 <read>
 276:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 279:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 27d:	7f 02                	jg     281 <gets+0x35>
      break;
 27f:	eb 31                	jmp    2b2 <gets+0x66>
    buf[i++] = c;
 281:	8b 45 f4             	mov    -0xc(%ebp),%eax
 284:	8d 50 01             	lea    0x1(%eax),%edx
 287:	89 55 f4             	mov    %edx,-0xc(%ebp)
 28a:	89 c2                	mov    %eax,%edx
 28c:	8b 45 08             	mov    0x8(%ebp),%eax
 28f:	01 c2                	add    %eax,%edx
 291:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 295:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 297:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 29b:	3c 0a                	cmp    $0xa,%al
 29d:	74 13                	je     2b2 <gets+0x66>
 29f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2a3:	3c 0d                	cmp    $0xd,%al
 2a5:	74 0b                	je     2b2 <gets+0x66>
  for(i=0; i+1 < max; ){
 2a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2aa:	83 c0 01             	add    $0x1,%eax
 2ad:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2b0:	7c a9                	jl     25b <gets+0xf>
      break;
  }
  buf[i] = '\0';
 2b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2b5:	8b 45 08             	mov    0x8(%ebp),%eax
 2b8:	01 d0                	add    %edx,%eax
 2ba:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2bd:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c0:	c9                   	leave  
 2c1:	c3                   	ret    

000002c2 <stat>:

int
stat(const char *n, struct stat *st)
{
 2c2:	55                   	push   %ebp
 2c3:	89 e5                	mov    %esp,%ebp
 2c5:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2c8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2cf:	00 
 2d0:	8b 45 08             	mov    0x8(%ebp),%eax
 2d3:	89 04 24             	mov    %eax,(%esp)
 2d6:	e8 24 02 00 00       	call   4ff <open>
 2db:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2e2:	79 07                	jns    2eb <stat+0x29>
    return -1;
 2e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2e9:	eb 23                	jmp    30e <stat+0x4c>
  r = fstat(fd, st);
 2eb:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ee:	89 44 24 04          	mov    %eax,0x4(%esp)
 2f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2f5:	89 04 24             	mov    %eax,(%esp)
 2f8:	e8 1a 02 00 00       	call   517 <fstat>
 2fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 300:	8b 45 f4             	mov    -0xc(%ebp),%eax
 303:	89 04 24             	mov    %eax,(%esp)
 306:	e8 dc 01 00 00       	call   4e7 <close>
  return r;
 30b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 30e:	c9                   	leave  
 30f:	c3                   	ret    

00000310 <atoi>:

int
atoi(const char *s)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 316:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 31d:	eb 25                	jmp    344 <atoi+0x34>
    n = n*10 + *s++ - '0';
 31f:	8b 55 fc             	mov    -0x4(%ebp),%edx
 322:	89 d0                	mov    %edx,%eax
 324:	c1 e0 02             	shl    $0x2,%eax
 327:	01 d0                	add    %edx,%eax
 329:	01 c0                	add    %eax,%eax
 32b:	89 c1                	mov    %eax,%ecx
 32d:	8b 45 08             	mov    0x8(%ebp),%eax
 330:	8d 50 01             	lea    0x1(%eax),%edx
 333:	89 55 08             	mov    %edx,0x8(%ebp)
 336:	0f b6 00             	movzbl (%eax),%eax
 339:	0f be c0             	movsbl %al,%eax
 33c:	01 c8                	add    %ecx,%eax
 33e:	83 e8 30             	sub    $0x30,%eax
 341:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 344:	8b 45 08             	mov    0x8(%ebp),%eax
 347:	0f b6 00             	movzbl (%eax),%eax
 34a:	3c 2f                	cmp    $0x2f,%al
 34c:	7e 0a                	jle    358 <atoi+0x48>
 34e:	8b 45 08             	mov    0x8(%ebp),%eax
 351:	0f b6 00             	movzbl (%eax),%eax
 354:	3c 39                	cmp    $0x39,%al
 356:	7e c7                	jle    31f <atoi+0xf>
  return n;
 358:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 35b:	c9                   	leave  
 35c:	c3                   	ret    

0000035d <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 35d:	55                   	push   %ebp
 35e:	89 e5                	mov    %esp,%ebp
 360:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 363:	8b 45 08             	mov    0x8(%ebp),%eax
 366:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 369:	8b 45 0c             	mov    0xc(%ebp),%eax
 36c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 36f:	eb 17                	jmp    388 <memmove+0x2b>
    *dst++ = *src++;
 371:	8b 45 fc             	mov    -0x4(%ebp),%eax
 374:	8d 50 01             	lea    0x1(%eax),%edx
 377:	89 55 fc             	mov    %edx,-0x4(%ebp)
 37a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 37d:	8d 4a 01             	lea    0x1(%edx),%ecx
 380:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 383:	0f b6 12             	movzbl (%edx),%edx
 386:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 388:	8b 45 10             	mov    0x10(%ebp),%eax
 38b:	8d 50 ff             	lea    -0x1(%eax),%edx
 38e:	89 55 10             	mov    %edx,0x10(%ebp)
 391:	85 c0                	test   %eax,%eax
 393:	7f dc                	jg     371 <memmove+0x14>
  return vdst;
 395:	8b 45 08             	mov    0x8(%ebp),%eax
}
 398:	c9                   	leave  
 399:	c3                   	ret    

0000039a <ps>:

void 
ps()
{
 39a:	55                   	push   %ebp
 39b:	89 e5                	mov    %esp,%ebp
 39d:	57                   	push   %edi
 39e:	56                   	push   %esi
 39f:	53                   	push   %ebx
 3a0:	81 ec 3c 09 00 00    	sub    $0x93c,%esp
  pstatTable pTable;
  getpinfo(&pTable);
 3a6:	8d 85 e4 f6 ff ff    	lea    -0x91c(%ebp),%eax
 3ac:	89 04 24             	mov    %eax,(%esp)
 3af:	e8 ab 01 00 00       	call   55f <getpinfo>
  printf(1, "PID\tTKTS\tTCKS\tSTAT\tNAME\n");
 3b4:	c7 44 24 04 1b 0a 00 	movl   $0xa1b,0x4(%esp)
 3bb:	00 
 3bc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 3c3:	e8 87 02 00 00       	call   64f <printf>
  int i;
  for (i = 0; i < NPROC; i++)
 3c8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 3cf:	e9 ce 00 00 00       	jmp    4a2 <ps+0x108>
  {
    if(pTable[i].inuse)
 3d4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 3d7:	89 d0                	mov    %edx,%eax
 3d9:	c1 e0 03             	shl    $0x3,%eax
 3dc:	01 d0                	add    %edx,%eax
 3de:	c1 e0 02             	shl    $0x2,%eax
 3e1:	8d 5d e8             	lea    -0x18(%ebp),%ebx
 3e4:	01 d8                	add    %ebx,%eax
 3e6:	2d 04 09 00 00       	sub    $0x904,%eax
 3eb:	8b 00                	mov    (%eax),%eax
 3ed:	85 c0                	test   %eax,%eax
 3ef:	0f 84 a9 00 00 00    	je     49e <ps+0x104>
      printf(1, "%d\t%d\t%d\t%c\t%s\n", pTable[i].pid, pTable[i].tickets, pTable[i].ticks, pTable[i].state, pTable[i].name);
 3f5:	8d 8d e4 f6 ff ff    	lea    -0x91c(%ebp),%ecx
 3fb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 3fe:	89 d0                	mov    %edx,%eax
 400:	c1 e0 03             	shl    $0x3,%eax
 403:	01 d0                	add    %edx,%eax
 405:	c1 e0 02             	shl    $0x2,%eax
 408:	83 c0 10             	add    $0x10,%eax
 40b:	8d 3c 01             	lea    (%ecx,%eax,1),%edi
 40e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 411:	89 d0                	mov    %edx,%eax
 413:	c1 e0 03             	shl    $0x3,%eax
 416:	01 d0                	add    %edx,%eax
 418:	c1 e0 02             	shl    $0x2,%eax
 41b:	8d 75 e8             	lea    -0x18(%ebp),%esi
 41e:	01 f0                	add    %esi,%eax
 420:	2d e4 08 00 00       	sub    $0x8e4,%eax
 425:	0f b6 00             	movzbl (%eax),%eax
 428:	0f be f0             	movsbl %al,%esi
 42b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 42e:	89 d0                	mov    %edx,%eax
 430:	c1 e0 03             	shl    $0x3,%eax
 433:	01 d0                	add    %edx,%eax
 435:	c1 e0 02             	shl    $0x2,%eax
 438:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 43b:	01 c8                	add    %ecx,%eax
 43d:	2d f8 08 00 00       	sub    $0x8f8,%eax
 442:	8b 18                	mov    (%eax),%ebx
 444:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 447:	89 d0                	mov    %edx,%eax
 449:	c1 e0 03             	shl    $0x3,%eax
 44c:	01 d0                	add    %edx,%eax
 44e:	c1 e0 02             	shl    $0x2,%eax
 451:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 454:	01 c8                	add    %ecx,%eax
 456:	2d 00 09 00 00       	sub    $0x900,%eax
 45b:	8b 08                	mov    (%eax),%ecx
 45d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 460:	89 d0                	mov    %edx,%eax
 462:	c1 e0 03             	shl    $0x3,%eax
 465:	01 d0                	add    %edx,%eax
 467:	c1 e0 02             	shl    $0x2,%eax
 46a:	8d 55 e8             	lea    -0x18(%ebp),%edx
 46d:	01 d0                	add    %edx,%eax
 46f:	2d fc 08 00 00       	sub    $0x8fc,%eax
 474:	8b 00                	mov    (%eax),%eax
 476:	89 7c 24 18          	mov    %edi,0x18(%esp)
 47a:	89 74 24 14          	mov    %esi,0x14(%esp)
 47e:	89 5c 24 10          	mov    %ebx,0x10(%esp)
 482:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 486:	89 44 24 08          	mov    %eax,0x8(%esp)
 48a:	c7 44 24 04 34 0a 00 	movl   $0xa34,0x4(%esp)
 491:	00 
 492:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 499:	e8 b1 01 00 00       	call   64f <printf>
  for (i = 0; i < NPROC; i++)
 49e:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 4a2:	83 7d e4 3f          	cmpl   $0x3f,-0x1c(%ebp)
 4a6:	0f 8e 28 ff ff ff    	jle    3d4 <ps+0x3a>
  }
}
 4ac:	81 c4 3c 09 00 00    	add    $0x93c,%esp
 4b2:	5b                   	pop    %ebx
 4b3:	5e                   	pop    %esi
 4b4:	5f                   	pop    %edi
 4b5:	5d                   	pop    %ebp
 4b6:	c3                   	ret    

000004b7 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4b7:	b8 01 00 00 00       	mov    $0x1,%eax
 4bc:	cd 40                	int    $0x40
 4be:	c3                   	ret    

000004bf <exit>:
SYSCALL(exit)
 4bf:	b8 02 00 00 00       	mov    $0x2,%eax
 4c4:	cd 40                	int    $0x40
 4c6:	c3                   	ret    

000004c7 <wait>:
SYSCALL(wait)
 4c7:	b8 03 00 00 00       	mov    $0x3,%eax
 4cc:	cd 40                	int    $0x40
 4ce:	c3                   	ret    

000004cf <pipe>:
SYSCALL(pipe)
 4cf:	b8 04 00 00 00       	mov    $0x4,%eax
 4d4:	cd 40                	int    $0x40
 4d6:	c3                   	ret    

000004d7 <read>:
SYSCALL(read)
 4d7:	b8 05 00 00 00       	mov    $0x5,%eax
 4dc:	cd 40                	int    $0x40
 4de:	c3                   	ret    

000004df <write>:
SYSCALL(write)
 4df:	b8 10 00 00 00       	mov    $0x10,%eax
 4e4:	cd 40                	int    $0x40
 4e6:	c3                   	ret    

000004e7 <close>:
SYSCALL(close)
 4e7:	b8 15 00 00 00       	mov    $0x15,%eax
 4ec:	cd 40                	int    $0x40
 4ee:	c3                   	ret    

000004ef <kill>:
SYSCALL(kill)
 4ef:	b8 06 00 00 00       	mov    $0x6,%eax
 4f4:	cd 40                	int    $0x40
 4f6:	c3                   	ret    

000004f7 <exec>:
SYSCALL(exec)
 4f7:	b8 07 00 00 00       	mov    $0x7,%eax
 4fc:	cd 40                	int    $0x40
 4fe:	c3                   	ret    

000004ff <open>:
SYSCALL(open)
 4ff:	b8 0f 00 00 00       	mov    $0xf,%eax
 504:	cd 40                	int    $0x40
 506:	c3                   	ret    

00000507 <mknod>:
SYSCALL(mknod)
 507:	b8 11 00 00 00       	mov    $0x11,%eax
 50c:	cd 40                	int    $0x40
 50e:	c3                   	ret    

0000050f <unlink>:
SYSCALL(unlink)
 50f:	b8 12 00 00 00       	mov    $0x12,%eax
 514:	cd 40                	int    $0x40
 516:	c3                   	ret    

00000517 <fstat>:
SYSCALL(fstat)
 517:	b8 08 00 00 00       	mov    $0x8,%eax
 51c:	cd 40                	int    $0x40
 51e:	c3                   	ret    

0000051f <link>:
SYSCALL(link)
 51f:	b8 13 00 00 00       	mov    $0x13,%eax
 524:	cd 40                	int    $0x40
 526:	c3                   	ret    

00000527 <mkdir>:
SYSCALL(mkdir)
 527:	b8 14 00 00 00       	mov    $0x14,%eax
 52c:	cd 40                	int    $0x40
 52e:	c3                   	ret    

0000052f <chdir>:
SYSCALL(chdir)
 52f:	b8 09 00 00 00       	mov    $0x9,%eax
 534:	cd 40                	int    $0x40
 536:	c3                   	ret    

00000537 <dup>:
SYSCALL(dup)
 537:	b8 0a 00 00 00       	mov    $0xa,%eax
 53c:	cd 40                	int    $0x40
 53e:	c3                   	ret    

0000053f <getpid>:
SYSCALL(getpid)
 53f:	b8 0b 00 00 00       	mov    $0xb,%eax
 544:	cd 40                	int    $0x40
 546:	c3                   	ret    

00000547 <sbrk>:
SYSCALL(sbrk)
 547:	b8 0c 00 00 00       	mov    $0xc,%eax
 54c:	cd 40                	int    $0x40
 54e:	c3                   	ret    

0000054f <sleep>:
SYSCALL(sleep)
 54f:	b8 0d 00 00 00       	mov    $0xd,%eax
 554:	cd 40                	int    $0x40
 556:	c3                   	ret    

00000557 <uptime>:
SYSCALL(uptime)
 557:	b8 0e 00 00 00       	mov    $0xe,%eax
 55c:	cd 40                	int    $0x40
 55e:	c3                   	ret    

0000055f <getpinfo>:
SYSCALL(getpinfo)
 55f:	b8 16 00 00 00       	mov    $0x16,%eax
 564:	cd 40                	int    $0x40
 566:	c3                   	ret    

00000567 <settickets>:
SYSCALL(settickets)
 567:	b8 18 00 00 00       	mov    $0x18,%eax
 56c:	cd 40                	int    $0x40
 56e:	c3                   	ret    

0000056f <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 56f:	55                   	push   %ebp
 570:	89 e5                	mov    %esp,%ebp
 572:	83 ec 18             	sub    $0x18,%esp
 575:	8b 45 0c             	mov    0xc(%ebp),%eax
 578:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 57b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 582:	00 
 583:	8d 45 f4             	lea    -0xc(%ebp),%eax
 586:	89 44 24 04          	mov    %eax,0x4(%esp)
 58a:	8b 45 08             	mov    0x8(%ebp),%eax
 58d:	89 04 24             	mov    %eax,(%esp)
 590:	e8 4a ff ff ff       	call   4df <write>
}
 595:	c9                   	leave  
 596:	c3                   	ret    

00000597 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 597:	55                   	push   %ebp
 598:	89 e5                	mov    %esp,%ebp
 59a:	56                   	push   %esi
 59b:	53                   	push   %ebx
 59c:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 59f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 5a6:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 5aa:	74 17                	je     5c3 <printint+0x2c>
 5ac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 5b0:	79 11                	jns    5c3 <printint+0x2c>
    neg = 1;
 5b2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 5b9:	8b 45 0c             	mov    0xc(%ebp),%eax
 5bc:	f7 d8                	neg    %eax
 5be:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5c1:	eb 06                	jmp    5c9 <printint+0x32>
  } else {
    x = xx;
 5c3:	8b 45 0c             	mov    0xc(%ebp),%eax
 5c6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 5c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 5d0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 5d3:	8d 41 01             	lea    0x1(%ecx),%eax
 5d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
 5d9:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5df:	ba 00 00 00 00       	mov    $0x0,%edx
 5e4:	f7 f3                	div    %ebx
 5e6:	89 d0                	mov    %edx,%eax
 5e8:	0f b6 80 e8 0c 00 00 	movzbl 0xce8(%eax),%eax
 5ef:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 5f3:	8b 75 10             	mov    0x10(%ebp),%esi
 5f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5f9:	ba 00 00 00 00       	mov    $0x0,%edx
 5fe:	f7 f6                	div    %esi
 600:	89 45 ec             	mov    %eax,-0x14(%ebp)
 603:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 607:	75 c7                	jne    5d0 <printint+0x39>
  if(neg)
 609:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 60d:	74 10                	je     61f <printint+0x88>
    buf[i++] = '-';
 60f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 612:	8d 50 01             	lea    0x1(%eax),%edx
 615:	89 55 f4             	mov    %edx,-0xc(%ebp)
 618:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 61d:	eb 1f                	jmp    63e <printint+0xa7>
 61f:	eb 1d                	jmp    63e <printint+0xa7>
    putc(fd, buf[i]);
 621:	8d 55 dc             	lea    -0x24(%ebp),%edx
 624:	8b 45 f4             	mov    -0xc(%ebp),%eax
 627:	01 d0                	add    %edx,%eax
 629:	0f b6 00             	movzbl (%eax),%eax
 62c:	0f be c0             	movsbl %al,%eax
 62f:	89 44 24 04          	mov    %eax,0x4(%esp)
 633:	8b 45 08             	mov    0x8(%ebp),%eax
 636:	89 04 24             	mov    %eax,(%esp)
 639:	e8 31 ff ff ff       	call   56f <putc>
  while(--i >= 0)
 63e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 642:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 646:	79 d9                	jns    621 <printint+0x8a>
}
 648:	83 c4 30             	add    $0x30,%esp
 64b:	5b                   	pop    %ebx
 64c:	5e                   	pop    %esi
 64d:	5d                   	pop    %ebp
 64e:	c3                   	ret    

0000064f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 64f:	55                   	push   %ebp
 650:	89 e5                	mov    %esp,%ebp
 652:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 655:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 65c:	8d 45 0c             	lea    0xc(%ebp),%eax
 65f:	83 c0 04             	add    $0x4,%eax
 662:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 665:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 66c:	e9 7c 01 00 00       	jmp    7ed <printf+0x19e>
    c = fmt[i] & 0xff;
 671:	8b 55 0c             	mov    0xc(%ebp),%edx
 674:	8b 45 f0             	mov    -0x10(%ebp),%eax
 677:	01 d0                	add    %edx,%eax
 679:	0f b6 00             	movzbl (%eax),%eax
 67c:	0f be c0             	movsbl %al,%eax
 67f:	25 ff 00 00 00       	and    $0xff,%eax
 684:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 687:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 68b:	75 2c                	jne    6b9 <printf+0x6a>
      if(c == '%'){
 68d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 691:	75 0c                	jne    69f <printf+0x50>
        state = '%';
 693:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 69a:	e9 4a 01 00 00       	jmp    7e9 <printf+0x19a>
      } else {
        putc(fd, c);
 69f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6a2:	0f be c0             	movsbl %al,%eax
 6a5:	89 44 24 04          	mov    %eax,0x4(%esp)
 6a9:	8b 45 08             	mov    0x8(%ebp),%eax
 6ac:	89 04 24             	mov    %eax,(%esp)
 6af:	e8 bb fe ff ff       	call   56f <putc>
 6b4:	e9 30 01 00 00       	jmp    7e9 <printf+0x19a>
      }
    } else if(state == '%'){
 6b9:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 6bd:	0f 85 26 01 00 00    	jne    7e9 <printf+0x19a>
      if(c == 'd'){
 6c3:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 6c7:	75 2d                	jne    6f6 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 6c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6cc:	8b 00                	mov    (%eax),%eax
 6ce:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 6d5:	00 
 6d6:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 6dd:	00 
 6de:	89 44 24 04          	mov    %eax,0x4(%esp)
 6e2:	8b 45 08             	mov    0x8(%ebp),%eax
 6e5:	89 04 24             	mov    %eax,(%esp)
 6e8:	e8 aa fe ff ff       	call   597 <printint>
        ap++;
 6ed:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6f1:	e9 ec 00 00 00       	jmp    7e2 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 6f6:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6fa:	74 06                	je     702 <printf+0xb3>
 6fc:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 700:	75 2d                	jne    72f <printf+0xe0>
        printint(fd, *ap, 16, 0);
 702:	8b 45 e8             	mov    -0x18(%ebp),%eax
 705:	8b 00                	mov    (%eax),%eax
 707:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 70e:	00 
 70f:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 716:	00 
 717:	89 44 24 04          	mov    %eax,0x4(%esp)
 71b:	8b 45 08             	mov    0x8(%ebp),%eax
 71e:	89 04 24             	mov    %eax,(%esp)
 721:	e8 71 fe ff ff       	call   597 <printint>
        ap++;
 726:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 72a:	e9 b3 00 00 00       	jmp    7e2 <printf+0x193>
      } else if(c == 's'){
 72f:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 733:	75 45                	jne    77a <printf+0x12b>
        s = (char*)*ap;
 735:	8b 45 e8             	mov    -0x18(%ebp),%eax
 738:	8b 00                	mov    (%eax),%eax
 73a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 73d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 741:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 745:	75 09                	jne    750 <printf+0x101>
          s = "(null)";
 747:	c7 45 f4 44 0a 00 00 	movl   $0xa44,-0xc(%ebp)
        while(*s != 0){
 74e:	eb 1e                	jmp    76e <printf+0x11f>
 750:	eb 1c                	jmp    76e <printf+0x11f>
          putc(fd, *s);
 752:	8b 45 f4             	mov    -0xc(%ebp),%eax
 755:	0f b6 00             	movzbl (%eax),%eax
 758:	0f be c0             	movsbl %al,%eax
 75b:	89 44 24 04          	mov    %eax,0x4(%esp)
 75f:	8b 45 08             	mov    0x8(%ebp),%eax
 762:	89 04 24             	mov    %eax,(%esp)
 765:	e8 05 fe ff ff       	call   56f <putc>
          s++;
 76a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 76e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 771:	0f b6 00             	movzbl (%eax),%eax
 774:	84 c0                	test   %al,%al
 776:	75 da                	jne    752 <printf+0x103>
 778:	eb 68                	jmp    7e2 <printf+0x193>
        }
      } else if(c == 'c'){
 77a:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 77e:	75 1d                	jne    79d <printf+0x14e>
        putc(fd, *ap);
 780:	8b 45 e8             	mov    -0x18(%ebp),%eax
 783:	8b 00                	mov    (%eax),%eax
 785:	0f be c0             	movsbl %al,%eax
 788:	89 44 24 04          	mov    %eax,0x4(%esp)
 78c:	8b 45 08             	mov    0x8(%ebp),%eax
 78f:	89 04 24             	mov    %eax,(%esp)
 792:	e8 d8 fd ff ff       	call   56f <putc>
        ap++;
 797:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 79b:	eb 45                	jmp    7e2 <printf+0x193>
      } else if(c == '%'){
 79d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 7a1:	75 17                	jne    7ba <printf+0x16b>
        putc(fd, c);
 7a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7a6:	0f be c0             	movsbl %al,%eax
 7a9:	89 44 24 04          	mov    %eax,0x4(%esp)
 7ad:	8b 45 08             	mov    0x8(%ebp),%eax
 7b0:	89 04 24             	mov    %eax,(%esp)
 7b3:	e8 b7 fd ff ff       	call   56f <putc>
 7b8:	eb 28                	jmp    7e2 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7ba:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 7c1:	00 
 7c2:	8b 45 08             	mov    0x8(%ebp),%eax
 7c5:	89 04 24             	mov    %eax,(%esp)
 7c8:	e8 a2 fd ff ff       	call   56f <putc>
        putc(fd, c);
 7cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7d0:	0f be c0             	movsbl %al,%eax
 7d3:	89 44 24 04          	mov    %eax,0x4(%esp)
 7d7:	8b 45 08             	mov    0x8(%ebp),%eax
 7da:	89 04 24             	mov    %eax,(%esp)
 7dd:	e8 8d fd ff ff       	call   56f <putc>
      }
      state = 0;
 7e2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 7e9:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 7ed:	8b 55 0c             	mov    0xc(%ebp),%edx
 7f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f3:	01 d0                	add    %edx,%eax
 7f5:	0f b6 00             	movzbl (%eax),%eax
 7f8:	84 c0                	test   %al,%al
 7fa:	0f 85 71 fe ff ff    	jne    671 <printf+0x22>
    }
  }
}
 800:	c9                   	leave  
 801:	c3                   	ret    

00000802 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 802:	55                   	push   %ebp
 803:	89 e5                	mov    %esp,%ebp
 805:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 808:	8b 45 08             	mov    0x8(%ebp),%eax
 80b:	83 e8 08             	sub    $0x8,%eax
 80e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 811:	a1 04 0d 00 00       	mov    0xd04,%eax
 816:	89 45 fc             	mov    %eax,-0x4(%ebp)
 819:	eb 24                	jmp    83f <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 81b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81e:	8b 00                	mov    (%eax),%eax
 820:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 823:	77 12                	ja     837 <free+0x35>
 825:	8b 45 f8             	mov    -0x8(%ebp),%eax
 828:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 82b:	77 24                	ja     851 <free+0x4f>
 82d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 830:	8b 00                	mov    (%eax),%eax
 832:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 835:	77 1a                	ja     851 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 837:	8b 45 fc             	mov    -0x4(%ebp),%eax
 83a:	8b 00                	mov    (%eax),%eax
 83c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 83f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 842:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 845:	76 d4                	jbe    81b <free+0x19>
 847:	8b 45 fc             	mov    -0x4(%ebp),%eax
 84a:	8b 00                	mov    (%eax),%eax
 84c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 84f:	76 ca                	jbe    81b <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 851:	8b 45 f8             	mov    -0x8(%ebp),%eax
 854:	8b 40 04             	mov    0x4(%eax),%eax
 857:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 85e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 861:	01 c2                	add    %eax,%edx
 863:	8b 45 fc             	mov    -0x4(%ebp),%eax
 866:	8b 00                	mov    (%eax),%eax
 868:	39 c2                	cmp    %eax,%edx
 86a:	75 24                	jne    890 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 86c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 86f:	8b 50 04             	mov    0x4(%eax),%edx
 872:	8b 45 fc             	mov    -0x4(%ebp),%eax
 875:	8b 00                	mov    (%eax),%eax
 877:	8b 40 04             	mov    0x4(%eax),%eax
 87a:	01 c2                	add    %eax,%edx
 87c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 87f:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 882:	8b 45 fc             	mov    -0x4(%ebp),%eax
 885:	8b 00                	mov    (%eax),%eax
 887:	8b 10                	mov    (%eax),%edx
 889:	8b 45 f8             	mov    -0x8(%ebp),%eax
 88c:	89 10                	mov    %edx,(%eax)
 88e:	eb 0a                	jmp    89a <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 890:	8b 45 fc             	mov    -0x4(%ebp),%eax
 893:	8b 10                	mov    (%eax),%edx
 895:	8b 45 f8             	mov    -0x8(%ebp),%eax
 898:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 89a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 89d:	8b 40 04             	mov    0x4(%eax),%eax
 8a0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8aa:	01 d0                	add    %edx,%eax
 8ac:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8af:	75 20                	jne    8d1 <free+0xcf>
    p->s.size += bp->s.size;
 8b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b4:	8b 50 04             	mov    0x4(%eax),%edx
 8b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ba:	8b 40 04             	mov    0x4(%eax),%eax
 8bd:	01 c2                	add    %eax,%edx
 8bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c2:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8c8:	8b 10                	mov    (%eax),%edx
 8ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8cd:	89 10                	mov    %edx,(%eax)
 8cf:	eb 08                	jmp    8d9 <free+0xd7>
  } else
    p->s.ptr = bp;
 8d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d4:	8b 55 f8             	mov    -0x8(%ebp),%edx
 8d7:	89 10                	mov    %edx,(%eax)
  freep = p;
 8d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8dc:	a3 04 0d 00 00       	mov    %eax,0xd04
}
 8e1:	c9                   	leave  
 8e2:	c3                   	ret    

000008e3 <morecore>:

static Header*
morecore(uint nu)
{
 8e3:	55                   	push   %ebp
 8e4:	89 e5                	mov    %esp,%ebp
 8e6:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 8e9:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 8f0:	77 07                	ja     8f9 <morecore+0x16>
    nu = 4096;
 8f2:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 8f9:	8b 45 08             	mov    0x8(%ebp),%eax
 8fc:	c1 e0 03             	shl    $0x3,%eax
 8ff:	89 04 24             	mov    %eax,(%esp)
 902:	e8 40 fc ff ff       	call   547 <sbrk>
 907:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 90a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 90e:	75 07                	jne    917 <morecore+0x34>
    return 0;
 910:	b8 00 00 00 00       	mov    $0x0,%eax
 915:	eb 22                	jmp    939 <morecore+0x56>
  hp = (Header*)p;
 917:	8b 45 f4             	mov    -0xc(%ebp),%eax
 91a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 91d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 920:	8b 55 08             	mov    0x8(%ebp),%edx
 923:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 926:	8b 45 f0             	mov    -0x10(%ebp),%eax
 929:	83 c0 08             	add    $0x8,%eax
 92c:	89 04 24             	mov    %eax,(%esp)
 92f:	e8 ce fe ff ff       	call   802 <free>
  return freep;
 934:	a1 04 0d 00 00       	mov    0xd04,%eax
}
 939:	c9                   	leave  
 93a:	c3                   	ret    

0000093b <malloc>:

void*
malloc(uint nbytes)
{
 93b:	55                   	push   %ebp
 93c:	89 e5                	mov    %esp,%ebp
 93e:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 941:	8b 45 08             	mov    0x8(%ebp),%eax
 944:	83 c0 07             	add    $0x7,%eax
 947:	c1 e8 03             	shr    $0x3,%eax
 94a:	83 c0 01             	add    $0x1,%eax
 94d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 950:	a1 04 0d 00 00       	mov    0xd04,%eax
 955:	89 45 f0             	mov    %eax,-0x10(%ebp)
 958:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 95c:	75 23                	jne    981 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 95e:	c7 45 f0 fc 0c 00 00 	movl   $0xcfc,-0x10(%ebp)
 965:	8b 45 f0             	mov    -0x10(%ebp),%eax
 968:	a3 04 0d 00 00       	mov    %eax,0xd04
 96d:	a1 04 0d 00 00       	mov    0xd04,%eax
 972:	a3 fc 0c 00 00       	mov    %eax,0xcfc
    base.s.size = 0;
 977:	c7 05 00 0d 00 00 00 	movl   $0x0,0xd00
 97e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 981:	8b 45 f0             	mov    -0x10(%ebp),%eax
 984:	8b 00                	mov    (%eax),%eax
 986:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 989:	8b 45 f4             	mov    -0xc(%ebp),%eax
 98c:	8b 40 04             	mov    0x4(%eax),%eax
 98f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 992:	72 4d                	jb     9e1 <malloc+0xa6>
      if(p->s.size == nunits)
 994:	8b 45 f4             	mov    -0xc(%ebp),%eax
 997:	8b 40 04             	mov    0x4(%eax),%eax
 99a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 99d:	75 0c                	jne    9ab <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 99f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a2:	8b 10                	mov    (%eax),%edx
 9a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9a7:	89 10                	mov    %edx,(%eax)
 9a9:	eb 26                	jmp    9d1 <malloc+0x96>
      else {
        p->s.size -= nunits;
 9ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ae:	8b 40 04             	mov    0x4(%eax),%eax
 9b1:	2b 45 ec             	sub    -0x14(%ebp),%eax
 9b4:	89 c2                	mov    %eax,%edx
 9b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 9bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9bf:	8b 40 04             	mov    0x4(%eax),%eax
 9c2:	c1 e0 03             	shl    $0x3,%eax
 9c5:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 9c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9cb:	8b 55 ec             	mov    -0x14(%ebp),%edx
 9ce:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 9d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9d4:	a3 04 0d 00 00       	mov    %eax,0xd04
      return (void*)(p + 1);
 9d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9dc:	83 c0 08             	add    $0x8,%eax
 9df:	eb 38                	jmp    a19 <malloc+0xde>
    }
    if(p == freep)
 9e1:	a1 04 0d 00 00       	mov    0xd04,%eax
 9e6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 9e9:	75 1b                	jne    a06 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 9eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 9ee:	89 04 24             	mov    %eax,(%esp)
 9f1:	e8 ed fe ff ff       	call   8e3 <morecore>
 9f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9fd:	75 07                	jne    a06 <malloc+0xcb>
        return 0;
 9ff:	b8 00 00 00 00       	mov    $0x0,%eax
 a04:	eb 13                	jmp    a19 <malloc+0xde>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a09:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a0f:	8b 00                	mov    (%eax),%eax
 a11:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 a14:	e9 70 ff ff ff       	jmp    989 <malloc+0x4e>
}
 a19:	c9                   	leave  
 a1a:	c3                   	ret    
