
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
  
  if(argc < 2)
  16:	83 3b 01             	cmpl   $0x1,(%ebx)
  19:	7f 19                	jg     34 <main+0x34>
  {
    printf(1, "usage: schedtest loops tickets1 [ tickets2 ... ticketsN ]\n\t\
  1b:	c7 44 24 04 c4 0a 00 	movl   $0xac4,0x4(%esp)
  22:	00 
  23:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  2a:	e8 c7 06 00 00       	call   6f6 <printf>
              loops must be greater than 0\n\t\
              tickets must be greater than or equal to  10\n\t\
              up to 7 tickets can be provided\n\t");
    exit();
  2f:	e8 32 05 00 00       	call   566 <exit>
  }
  if(atoi(argv[1]) < 10)
  34:	8b 43 04             	mov    0x4(%ebx),%eax
  37:	83 c0 04             	add    $0x4,%eax
  3a:	8b 00                	mov    (%eax),%eax
  3c:	89 04 24             	mov    %eax,(%esp)
  3f:	e8 73 03 00 00       	call   3b7 <atoi>
  44:	83 f8 09             	cmp    $0x9,%eax
  47:	7f 19                	jg     62 <main+0x62>
  {
    printf(1, "usage: schedtest loops tickets1 [ tickets2 ... ticketsN ]\n\t\
  49:	c7 44 24 04 c4 0a 00 	movl   $0xac4,0x4(%esp)
  50:	00 
  51:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  58:	e8 99 06 00 00       	call   6f6 <printf>
              loops must be greater than 0\n\t\
              tickets must be greater than or equal to  10\n\t\
              up to 7 tickets can be provided\n\t");
    exit();
  5d:	e8 04 05 00 00       	call   566 <exit>
  }
  if(argc > 9)
  62:	83 3b 09             	cmpl   $0x9,(%ebx)
  65:	7e 19                	jle    80 <main+0x80>
  {
    printf(1, "usage: schedtest loops tickets1 [ tickets2 ... ticketsN ]\n\t\
  67:	c7 44 24 04 c4 0a 00 	movl   $0xac4,0x4(%esp)
  6e:	00 
  6f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  76:	e8 7b 06 00 00       	call   6f6 <printf>
              loops must be greater than 0\n\t\
              tickets must be greater than or equal to  10\n\t\
              up to 7 tickets can be provided\n\t");
    exit();
  7b:	e8 e6 04 00 00       	call   566 <exit>
  }

  int loops = atoi(argv[1]);
  80:	8b 43 04             	mov    0x4(%ebx),%eax
  83:	83 c0 04             	add    $0x4,%eax
  86:	8b 00                	mov    (%eax),%eax
  88:	89 04 24             	mov    %eax,(%esp)
  8b:	e8 27 03 00 00       	call   3b7 <atoi>
  90:	89 45 e0             	mov    %eax,-0x20(%ebp)
  int tickets[argc - 2];
  93:	8b 03                	mov    (%ebx),%eax
  95:	83 e8 02             	sub    $0x2,%eax
  98:	8d 50 ff             	lea    -0x1(%eax),%edx
  9b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  9e:	c1 e0 02             	shl    $0x2,%eax
  a1:	8d 50 03             	lea    0x3(%eax),%edx
  a4:	b8 10 00 00 00       	mov    $0x10,%eax
  a9:	83 e8 01             	sub    $0x1,%eax
  ac:	01 d0                	add    %edx,%eax
  ae:	bf 10 00 00 00       	mov    $0x10,%edi
  b3:	ba 00 00 00 00       	mov    $0x0,%edx
  b8:	f7 f7                	div    %edi
  ba:	6b c0 10             	imul   $0x10,%eax,%eax
  bd:	29 c4                	sub    %eax,%esp
  bf:	8d 44 24 08          	lea    0x8(%esp),%eax
  c3:	83 c0 03             	add    $0x3,%eax
  c6:	c1 e8 02             	shr    $0x2,%eax
  c9:	c1 e0 02             	shl    $0x2,%eax
  cc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int pids[argc - 2];
  cf:	8b 03                	mov    (%ebx),%eax
  d1:	83 e8 02             	sub    $0x2,%eax
  d4:	8d 50 ff             	lea    -0x1(%eax),%edx
  d7:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  da:	c1 e0 02             	shl    $0x2,%eax
  dd:	8d 50 03             	lea    0x3(%eax),%edx
  e0:	b8 10 00 00 00       	mov    $0x10,%eax
  e5:	83 e8 01             	sub    $0x1,%eax
  e8:	01 d0                	add    %edx,%eax
  ea:	be 10 00 00 00       	mov    $0x10,%esi
  ef:	ba 00 00 00 00       	mov    $0x0,%edx
  f4:	f7 f6                	div    %esi
  f6:	6b c0 10             	imul   $0x10,%eax,%eax
  f9:	29 c4                	sub    %eax,%esp
  fb:	8d 44 24 08          	lea    0x8(%esp),%eax
  ff:	83 c0 03             	add    $0x3,%eax
 102:	c1 e8 02             	shr    $0x2,%eax
 105:	c1 e0 02             	shl    $0x2,%eax
 108:	89 45 d0             	mov    %eax,-0x30(%ebp)

  int i;
  for(i = 2; i < argc; i++)
 10b:	c7 45 e4 02 00 00 00 	movl   $0x2,-0x1c(%ebp)
 112:	eb 29                	jmp    13d <main+0x13d>
  {
    tickets[i-2] = atoi(argv[i]);
 114:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 117:	8d 70 fe             	lea    -0x2(%eax),%esi
 11a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 11d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 124:	8b 43 04             	mov    0x4(%ebx),%eax
 127:	01 d0                	add    %edx,%eax
 129:	8b 00                	mov    (%eax),%eax
 12b:	89 04 24             	mov    %eax,(%esp)
 12e:	e8 84 02 00 00       	call   3b7 <atoi>
 133:	8b 55 d8             	mov    -0x28(%ebp),%edx
 136:	89 04 b2             	mov    %eax,(%edx,%esi,4)
  for(i = 2; i < argc; i++)
 139:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 13d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 140:	3b 03                	cmp    (%ebx),%eax
 142:	7c d0                	jl     114 <main+0x114>
  }

  for(i = 0; i < argc-2; i++)
 144:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 14b:	eb 32                	jmp    17f <main+0x17f>
  {
    pids[i] = fork();
 14d:	e8 0c 04 00 00       	call   55e <fork>
 152:	8b 55 d0             	mov    -0x30(%ebp),%edx
 155:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
 158:	89 04 8a             	mov    %eax,(%edx,%ecx,4)

    if(pids[i] == 0)
 15b:	8b 45 d0             	mov    -0x30(%ebp),%eax
 15e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 161:	8b 04 90             	mov    (%eax,%edx,4),%eax
 164:	85 c0                	test   %eax,%eax
 166:	75 13                	jne    17b <main+0x17b>
    {
      settickets(tickets[i]);
 168:	8b 45 d8             	mov    -0x28(%ebp),%eax
 16b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 16e:	8b 04 90             	mov    (%eax,%edx,4),%eax
 171:	89 04 24             	mov    %eax,(%esp)
 174:	e8 95 04 00 00       	call   60e <settickets>
      for(;;)
      {
          continue;
      }
 179:	eb fe                	jmp    179 <main+0x179>
  for(i = 0; i < argc-2; i++)
 17b:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 17f:	8b 03                	mov    (%ebx),%eax
 181:	83 e8 02             	sub    $0x2,%eax
 184:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
 187:	7f c4                	jg     14d <main+0x14d>
    }  
  }
  for(i = 0; i < loops; i++)
 189:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 190:	eb 15                	jmp    1a7 <main+0x1a7>
  {
    ps();
 192:	e8 aa 02 00 00       	call   441 <ps>
    sleep(3);
 197:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
 19e:	e8 53 04 00 00       	call   5f6 <sleep>
  for(i = 0; i < loops; i++)
 1a3:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 1a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 1aa:	3b 45 e0             	cmp    -0x20(%ebp),%eax
 1ad:	7c e3                	jl     192 <main+0x192>
  }
  for(i = 0; i < argc-2; i++)
 1af:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 1b6:	eb 1a                	jmp    1d2 <main+0x1d2>
  {
    kill(pids[i]);
 1b8:	8b 45 d0             	mov    -0x30(%ebp),%eax
 1bb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 1be:	8b 04 90             	mov    (%eax,%edx,4),%eax
 1c1:	89 04 24             	mov    %eax,(%esp)
 1c4:	e8 cd 03 00 00       	call   596 <kill>
    wait();
 1c9:	e8 a0 03 00 00       	call   56e <wait>
  for(i = 0; i < argc-2; i++)
 1ce:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 1d2:	8b 03                	mov    (%ebx),%eax
 1d4:	83 e8 02             	sub    $0x2,%eax
 1d7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
 1da:	7f dc                	jg     1b8 <main+0x1b8>
  }
  exit();
 1dc:	e8 85 03 00 00       	call   566 <exit>

000001e1 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 1e1:	55                   	push   %ebp
 1e2:	89 e5                	mov    %esp,%ebp
 1e4:	57                   	push   %edi
 1e5:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 1e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1e9:	8b 55 10             	mov    0x10(%ebp),%edx
 1ec:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ef:	89 cb                	mov    %ecx,%ebx
 1f1:	89 df                	mov    %ebx,%edi
 1f3:	89 d1                	mov    %edx,%ecx
 1f5:	fc                   	cld    
 1f6:	f3 aa                	rep stos %al,%es:(%edi)
 1f8:	89 ca                	mov    %ecx,%edx
 1fa:	89 fb                	mov    %edi,%ebx
 1fc:	89 5d 08             	mov    %ebx,0x8(%ebp)
 1ff:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 202:	5b                   	pop    %ebx
 203:	5f                   	pop    %edi
 204:	5d                   	pop    %ebp
 205:	c3                   	ret    

00000206 <strcpy>:
#include "x86.h"
#include "pstat.h"

char*
strcpy(char *s, const char *t)
{
 206:	55                   	push   %ebp
 207:	89 e5                	mov    %esp,%ebp
 209:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 20c:	8b 45 08             	mov    0x8(%ebp),%eax
 20f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 212:	90                   	nop
 213:	8b 45 08             	mov    0x8(%ebp),%eax
 216:	8d 50 01             	lea    0x1(%eax),%edx
 219:	89 55 08             	mov    %edx,0x8(%ebp)
 21c:	8b 55 0c             	mov    0xc(%ebp),%edx
 21f:	8d 4a 01             	lea    0x1(%edx),%ecx
 222:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 225:	0f b6 12             	movzbl (%edx),%edx
 228:	88 10                	mov    %dl,(%eax)
 22a:	0f b6 00             	movzbl (%eax),%eax
 22d:	84 c0                	test   %al,%al
 22f:	75 e2                	jne    213 <strcpy+0xd>
    ;
  return os;
 231:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 234:	c9                   	leave  
 235:	c3                   	ret    

00000236 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 236:	55                   	push   %ebp
 237:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 239:	eb 08                	jmp    243 <strcmp+0xd>
    p++, q++;
 23b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 23f:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 243:	8b 45 08             	mov    0x8(%ebp),%eax
 246:	0f b6 00             	movzbl (%eax),%eax
 249:	84 c0                	test   %al,%al
 24b:	74 10                	je     25d <strcmp+0x27>
 24d:	8b 45 08             	mov    0x8(%ebp),%eax
 250:	0f b6 10             	movzbl (%eax),%edx
 253:	8b 45 0c             	mov    0xc(%ebp),%eax
 256:	0f b6 00             	movzbl (%eax),%eax
 259:	38 c2                	cmp    %al,%dl
 25b:	74 de                	je     23b <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 25d:	8b 45 08             	mov    0x8(%ebp),%eax
 260:	0f b6 00             	movzbl (%eax),%eax
 263:	0f b6 d0             	movzbl %al,%edx
 266:	8b 45 0c             	mov    0xc(%ebp),%eax
 269:	0f b6 00             	movzbl (%eax),%eax
 26c:	0f b6 c0             	movzbl %al,%eax
 26f:	29 c2                	sub    %eax,%edx
 271:	89 d0                	mov    %edx,%eax
}
 273:	5d                   	pop    %ebp
 274:	c3                   	ret    

00000275 <strlen>:

uint
strlen(const char *s)
{
 275:	55                   	push   %ebp
 276:	89 e5                	mov    %esp,%ebp
 278:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 27b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 282:	eb 04                	jmp    288 <strlen+0x13>
 284:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 288:	8b 55 fc             	mov    -0x4(%ebp),%edx
 28b:	8b 45 08             	mov    0x8(%ebp),%eax
 28e:	01 d0                	add    %edx,%eax
 290:	0f b6 00             	movzbl (%eax),%eax
 293:	84 c0                	test   %al,%al
 295:	75 ed                	jne    284 <strlen+0xf>
    ;
  return n;
 297:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 29a:	c9                   	leave  
 29b:	c3                   	ret    

0000029c <memset>:

void*
memset(void *dst, int c, uint n)
{
 29c:	55                   	push   %ebp
 29d:	89 e5                	mov    %esp,%ebp
 29f:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 2a2:	8b 45 10             	mov    0x10(%ebp),%eax
 2a5:	89 44 24 08          	mov    %eax,0x8(%esp)
 2a9:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ac:	89 44 24 04          	mov    %eax,0x4(%esp)
 2b0:	8b 45 08             	mov    0x8(%ebp),%eax
 2b3:	89 04 24             	mov    %eax,(%esp)
 2b6:	e8 26 ff ff ff       	call   1e1 <stosb>
  return dst;
 2bb:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2be:	c9                   	leave  
 2bf:	c3                   	ret    

000002c0 <strchr>:

char*
strchr(const char *s, char c)
{
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
 2c3:	83 ec 04             	sub    $0x4,%esp
 2c6:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c9:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 2cc:	eb 14                	jmp    2e2 <strchr+0x22>
    if(*s == c)
 2ce:	8b 45 08             	mov    0x8(%ebp),%eax
 2d1:	0f b6 00             	movzbl (%eax),%eax
 2d4:	3a 45 fc             	cmp    -0x4(%ebp),%al
 2d7:	75 05                	jne    2de <strchr+0x1e>
      return (char*)s;
 2d9:	8b 45 08             	mov    0x8(%ebp),%eax
 2dc:	eb 13                	jmp    2f1 <strchr+0x31>
  for(; *s; s++)
 2de:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 2e2:	8b 45 08             	mov    0x8(%ebp),%eax
 2e5:	0f b6 00             	movzbl (%eax),%eax
 2e8:	84 c0                	test   %al,%al
 2ea:	75 e2                	jne    2ce <strchr+0xe>
  return 0;
 2ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
 2f1:	c9                   	leave  
 2f2:	c3                   	ret    

000002f3 <gets>:

char*
gets(char *buf, int max)
{
 2f3:	55                   	push   %ebp
 2f4:	89 e5                	mov    %esp,%ebp
 2f6:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2f9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 300:	eb 4c                	jmp    34e <gets+0x5b>
    cc = read(0, &c, 1);
 302:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 309:	00 
 30a:	8d 45 ef             	lea    -0x11(%ebp),%eax
 30d:	89 44 24 04          	mov    %eax,0x4(%esp)
 311:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 318:	e8 61 02 00 00       	call   57e <read>
 31d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 320:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 324:	7f 02                	jg     328 <gets+0x35>
      break;
 326:	eb 31                	jmp    359 <gets+0x66>
    buf[i++] = c;
 328:	8b 45 f4             	mov    -0xc(%ebp),%eax
 32b:	8d 50 01             	lea    0x1(%eax),%edx
 32e:	89 55 f4             	mov    %edx,-0xc(%ebp)
 331:	89 c2                	mov    %eax,%edx
 333:	8b 45 08             	mov    0x8(%ebp),%eax
 336:	01 c2                	add    %eax,%edx
 338:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 33c:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 33e:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 342:	3c 0a                	cmp    $0xa,%al
 344:	74 13                	je     359 <gets+0x66>
 346:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 34a:	3c 0d                	cmp    $0xd,%al
 34c:	74 0b                	je     359 <gets+0x66>
  for(i=0; i+1 < max; ){
 34e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 351:	83 c0 01             	add    $0x1,%eax
 354:	3b 45 0c             	cmp    0xc(%ebp),%eax
 357:	7c a9                	jl     302 <gets+0xf>
      break;
  }
  buf[i] = '\0';
 359:	8b 55 f4             	mov    -0xc(%ebp),%edx
 35c:	8b 45 08             	mov    0x8(%ebp),%eax
 35f:	01 d0                	add    %edx,%eax
 361:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 364:	8b 45 08             	mov    0x8(%ebp),%eax
}
 367:	c9                   	leave  
 368:	c3                   	ret    

00000369 <stat>:

int
stat(const char *n, struct stat *st)
{
 369:	55                   	push   %ebp
 36a:	89 e5                	mov    %esp,%ebp
 36c:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 36f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 376:	00 
 377:	8b 45 08             	mov    0x8(%ebp),%eax
 37a:	89 04 24             	mov    %eax,(%esp)
 37d:	e8 24 02 00 00       	call   5a6 <open>
 382:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 385:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 389:	79 07                	jns    392 <stat+0x29>
    return -1;
 38b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 390:	eb 23                	jmp    3b5 <stat+0x4c>
  r = fstat(fd, st);
 392:	8b 45 0c             	mov    0xc(%ebp),%eax
 395:	89 44 24 04          	mov    %eax,0x4(%esp)
 399:	8b 45 f4             	mov    -0xc(%ebp),%eax
 39c:	89 04 24             	mov    %eax,(%esp)
 39f:	e8 1a 02 00 00       	call   5be <fstat>
 3a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 3a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3aa:	89 04 24             	mov    %eax,(%esp)
 3ad:	e8 dc 01 00 00       	call   58e <close>
  return r;
 3b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 3b5:	c9                   	leave  
 3b6:	c3                   	ret    

000003b7 <atoi>:

int
atoi(const char *s)
{
 3b7:	55                   	push   %ebp
 3b8:	89 e5                	mov    %esp,%ebp
 3ba:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 3bd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3c4:	eb 25                	jmp    3eb <atoi+0x34>
    n = n*10 + *s++ - '0';
 3c6:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3c9:	89 d0                	mov    %edx,%eax
 3cb:	c1 e0 02             	shl    $0x2,%eax
 3ce:	01 d0                	add    %edx,%eax
 3d0:	01 c0                	add    %eax,%eax
 3d2:	89 c1                	mov    %eax,%ecx
 3d4:	8b 45 08             	mov    0x8(%ebp),%eax
 3d7:	8d 50 01             	lea    0x1(%eax),%edx
 3da:	89 55 08             	mov    %edx,0x8(%ebp)
 3dd:	0f b6 00             	movzbl (%eax),%eax
 3e0:	0f be c0             	movsbl %al,%eax
 3e3:	01 c8                	add    %ecx,%eax
 3e5:	83 e8 30             	sub    $0x30,%eax
 3e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 3eb:	8b 45 08             	mov    0x8(%ebp),%eax
 3ee:	0f b6 00             	movzbl (%eax),%eax
 3f1:	3c 2f                	cmp    $0x2f,%al
 3f3:	7e 0a                	jle    3ff <atoi+0x48>
 3f5:	8b 45 08             	mov    0x8(%ebp),%eax
 3f8:	0f b6 00             	movzbl (%eax),%eax
 3fb:	3c 39                	cmp    $0x39,%al
 3fd:	7e c7                	jle    3c6 <atoi+0xf>
  return n;
 3ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 402:	c9                   	leave  
 403:	c3                   	ret    

00000404 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 404:	55                   	push   %ebp
 405:	89 e5                	mov    %esp,%ebp
 407:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 40a:	8b 45 08             	mov    0x8(%ebp),%eax
 40d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 410:	8b 45 0c             	mov    0xc(%ebp),%eax
 413:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 416:	eb 17                	jmp    42f <memmove+0x2b>
    *dst++ = *src++;
 418:	8b 45 fc             	mov    -0x4(%ebp),%eax
 41b:	8d 50 01             	lea    0x1(%eax),%edx
 41e:	89 55 fc             	mov    %edx,-0x4(%ebp)
 421:	8b 55 f8             	mov    -0x8(%ebp),%edx
 424:	8d 4a 01             	lea    0x1(%edx),%ecx
 427:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 42a:	0f b6 12             	movzbl (%edx),%edx
 42d:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 42f:	8b 45 10             	mov    0x10(%ebp),%eax
 432:	8d 50 ff             	lea    -0x1(%eax),%edx
 435:	89 55 10             	mov    %edx,0x10(%ebp)
 438:	85 c0                	test   %eax,%eax
 43a:	7f dc                	jg     418 <memmove+0x14>
  return vdst;
 43c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 43f:	c9                   	leave  
 440:	c3                   	ret    

00000441 <ps>:

void 
ps()
{
 441:	55                   	push   %ebp
 442:	89 e5                	mov    %esp,%ebp
 444:	57                   	push   %edi
 445:	56                   	push   %esi
 446:	53                   	push   %ebx
 447:	81 ec 3c 09 00 00    	sub    $0x93c,%esp
  pstatTable pTable;
  getpinfo(&pTable);
 44d:	8d 85 e4 f6 ff ff    	lea    -0x91c(%ebp),%eax
 453:	89 04 24             	mov    %eax,(%esp)
 456:	e8 ab 01 00 00       	call   606 <getpinfo>
  printf(1, "PID\tTKTS\tTCKS\tSTAT\tNAME\n");
 45b:	c7 44 24 04 97 0b 00 	movl   $0xb97,0x4(%esp)
 462:	00 
 463:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 46a:	e8 87 02 00 00       	call   6f6 <printf>
  int i;
  for (i = 0; i < NPROC; i++)
 46f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 476:	e9 ce 00 00 00       	jmp    549 <ps+0x108>
  {
    if(pTable[i].inuse)
 47b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 47e:	89 d0                	mov    %edx,%eax
 480:	c1 e0 03             	shl    $0x3,%eax
 483:	01 d0                	add    %edx,%eax
 485:	c1 e0 02             	shl    $0x2,%eax
 488:	8d 5d e8             	lea    -0x18(%ebp),%ebx
 48b:	01 d8                	add    %ebx,%eax
 48d:	2d 04 09 00 00       	sub    $0x904,%eax
 492:	8b 00                	mov    (%eax),%eax
 494:	85 c0                	test   %eax,%eax
 496:	0f 84 a9 00 00 00    	je     545 <ps+0x104>
      printf(1, "%d\t%d\t%d\t%c\t%s\n", pTable[i].pid, pTable[i].tickets, pTable[i].ticks, pTable[i].state, pTable[i].name);
 49c:	8d 8d e4 f6 ff ff    	lea    -0x91c(%ebp),%ecx
 4a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 4a5:	89 d0                	mov    %edx,%eax
 4a7:	c1 e0 03             	shl    $0x3,%eax
 4aa:	01 d0                	add    %edx,%eax
 4ac:	c1 e0 02             	shl    $0x2,%eax
 4af:	83 c0 10             	add    $0x10,%eax
 4b2:	8d 3c 01             	lea    (%ecx,%eax,1),%edi
 4b5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 4b8:	89 d0                	mov    %edx,%eax
 4ba:	c1 e0 03             	shl    $0x3,%eax
 4bd:	01 d0                	add    %edx,%eax
 4bf:	c1 e0 02             	shl    $0x2,%eax
 4c2:	8d 75 e8             	lea    -0x18(%ebp),%esi
 4c5:	01 f0                	add    %esi,%eax
 4c7:	2d e4 08 00 00       	sub    $0x8e4,%eax
 4cc:	0f b6 00             	movzbl (%eax),%eax
 4cf:	0f be f0             	movsbl %al,%esi
 4d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 4d5:	89 d0                	mov    %edx,%eax
 4d7:	c1 e0 03             	shl    $0x3,%eax
 4da:	01 d0                	add    %edx,%eax
 4dc:	c1 e0 02             	shl    $0x2,%eax
 4df:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 4e2:	01 c8                	add    %ecx,%eax
 4e4:	2d f8 08 00 00       	sub    $0x8f8,%eax
 4e9:	8b 18                	mov    (%eax),%ebx
 4eb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 4ee:	89 d0                	mov    %edx,%eax
 4f0:	c1 e0 03             	shl    $0x3,%eax
 4f3:	01 d0                	add    %edx,%eax
 4f5:	c1 e0 02             	shl    $0x2,%eax
 4f8:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 4fb:	01 c8                	add    %ecx,%eax
 4fd:	2d 00 09 00 00       	sub    $0x900,%eax
 502:	8b 08                	mov    (%eax),%ecx
 504:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 507:	89 d0                	mov    %edx,%eax
 509:	c1 e0 03             	shl    $0x3,%eax
 50c:	01 d0                	add    %edx,%eax
 50e:	c1 e0 02             	shl    $0x2,%eax
 511:	8d 55 e8             	lea    -0x18(%ebp),%edx
 514:	01 d0                	add    %edx,%eax
 516:	2d fc 08 00 00       	sub    $0x8fc,%eax
 51b:	8b 00                	mov    (%eax),%eax
 51d:	89 7c 24 18          	mov    %edi,0x18(%esp)
 521:	89 74 24 14          	mov    %esi,0x14(%esp)
 525:	89 5c 24 10          	mov    %ebx,0x10(%esp)
 529:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 52d:	89 44 24 08          	mov    %eax,0x8(%esp)
 531:	c7 44 24 04 b0 0b 00 	movl   $0xbb0,0x4(%esp)
 538:	00 
 539:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 540:	e8 b1 01 00 00       	call   6f6 <printf>
  for (i = 0; i < NPROC; i++)
 545:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 549:	83 7d e4 3f          	cmpl   $0x3f,-0x1c(%ebp)
 54d:	0f 8e 28 ff ff ff    	jle    47b <ps+0x3a>
  }
}
 553:	81 c4 3c 09 00 00    	add    $0x93c,%esp
 559:	5b                   	pop    %ebx
 55a:	5e                   	pop    %esi
 55b:	5f                   	pop    %edi
 55c:	5d                   	pop    %ebp
 55d:	c3                   	ret    

0000055e <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 55e:	b8 01 00 00 00       	mov    $0x1,%eax
 563:	cd 40                	int    $0x40
 565:	c3                   	ret    

00000566 <exit>:
SYSCALL(exit)
 566:	b8 02 00 00 00       	mov    $0x2,%eax
 56b:	cd 40                	int    $0x40
 56d:	c3                   	ret    

0000056e <wait>:
SYSCALL(wait)
 56e:	b8 03 00 00 00       	mov    $0x3,%eax
 573:	cd 40                	int    $0x40
 575:	c3                   	ret    

00000576 <pipe>:
SYSCALL(pipe)
 576:	b8 04 00 00 00       	mov    $0x4,%eax
 57b:	cd 40                	int    $0x40
 57d:	c3                   	ret    

0000057e <read>:
SYSCALL(read)
 57e:	b8 05 00 00 00       	mov    $0x5,%eax
 583:	cd 40                	int    $0x40
 585:	c3                   	ret    

00000586 <write>:
SYSCALL(write)
 586:	b8 10 00 00 00       	mov    $0x10,%eax
 58b:	cd 40                	int    $0x40
 58d:	c3                   	ret    

0000058e <close>:
SYSCALL(close)
 58e:	b8 15 00 00 00       	mov    $0x15,%eax
 593:	cd 40                	int    $0x40
 595:	c3                   	ret    

00000596 <kill>:
SYSCALL(kill)
 596:	b8 06 00 00 00       	mov    $0x6,%eax
 59b:	cd 40                	int    $0x40
 59d:	c3                   	ret    

0000059e <exec>:
SYSCALL(exec)
 59e:	b8 07 00 00 00       	mov    $0x7,%eax
 5a3:	cd 40                	int    $0x40
 5a5:	c3                   	ret    

000005a6 <open>:
SYSCALL(open)
 5a6:	b8 0f 00 00 00       	mov    $0xf,%eax
 5ab:	cd 40                	int    $0x40
 5ad:	c3                   	ret    

000005ae <mknod>:
SYSCALL(mknod)
 5ae:	b8 11 00 00 00       	mov    $0x11,%eax
 5b3:	cd 40                	int    $0x40
 5b5:	c3                   	ret    

000005b6 <unlink>:
SYSCALL(unlink)
 5b6:	b8 12 00 00 00       	mov    $0x12,%eax
 5bb:	cd 40                	int    $0x40
 5bd:	c3                   	ret    

000005be <fstat>:
SYSCALL(fstat)
 5be:	b8 08 00 00 00       	mov    $0x8,%eax
 5c3:	cd 40                	int    $0x40
 5c5:	c3                   	ret    

000005c6 <link>:
SYSCALL(link)
 5c6:	b8 13 00 00 00       	mov    $0x13,%eax
 5cb:	cd 40                	int    $0x40
 5cd:	c3                   	ret    

000005ce <mkdir>:
SYSCALL(mkdir)
 5ce:	b8 14 00 00 00       	mov    $0x14,%eax
 5d3:	cd 40                	int    $0x40
 5d5:	c3                   	ret    

000005d6 <chdir>:
SYSCALL(chdir)
 5d6:	b8 09 00 00 00       	mov    $0x9,%eax
 5db:	cd 40                	int    $0x40
 5dd:	c3                   	ret    

000005de <dup>:
SYSCALL(dup)
 5de:	b8 0a 00 00 00       	mov    $0xa,%eax
 5e3:	cd 40                	int    $0x40
 5e5:	c3                   	ret    

000005e6 <getpid>:
SYSCALL(getpid)
 5e6:	b8 0b 00 00 00       	mov    $0xb,%eax
 5eb:	cd 40                	int    $0x40
 5ed:	c3                   	ret    

000005ee <sbrk>:
SYSCALL(sbrk)
 5ee:	b8 0c 00 00 00       	mov    $0xc,%eax
 5f3:	cd 40                	int    $0x40
 5f5:	c3                   	ret    

000005f6 <sleep>:
SYSCALL(sleep)
 5f6:	b8 0d 00 00 00       	mov    $0xd,%eax
 5fb:	cd 40                	int    $0x40
 5fd:	c3                   	ret    

000005fe <uptime>:
SYSCALL(uptime)
 5fe:	b8 0e 00 00 00       	mov    $0xe,%eax
 603:	cd 40                	int    $0x40
 605:	c3                   	ret    

00000606 <getpinfo>:
SYSCALL(getpinfo)
 606:	b8 16 00 00 00       	mov    $0x16,%eax
 60b:	cd 40                	int    $0x40
 60d:	c3                   	ret    

0000060e <settickets>:
SYSCALL(settickets)
 60e:	b8 18 00 00 00       	mov    $0x18,%eax
 613:	cd 40                	int    $0x40
 615:	c3                   	ret    

00000616 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 616:	55                   	push   %ebp
 617:	89 e5                	mov    %esp,%ebp
 619:	83 ec 18             	sub    $0x18,%esp
 61c:	8b 45 0c             	mov    0xc(%ebp),%eax
 61f:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 622:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 629:	00 
 62a:	8d 45 f4             	lea    -0xc(%ebp),%eax
 62d:	89 44 24 04          	mov    %eax,0x4(%esp)
 631:	8b 45 08             	mov    0x8(%ebp),%eax
 634:	89 04 24             	mov    %eax,(%esp)
 637:	e8 4a ff ff ff       	call   586 <write>
}
 63c:	c9                   	leave  
 63d:	c3                   	ret    

0000063e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 63e:	55                   	push   %ebp
 63f:	89 e5                	mov    %esp,%ebp
 641:	56                   	push   %esi
 642:	53                   	push   %ebx
 643:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 646:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 64d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 651:	74 17                	je     66a <printint+0x2c>
 653:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 657:	79 11                	jns    66a <printint+0x2c>
    neg = 1;
 659:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 660:	8b 45 0c             	mov    0xc(%ebp),%eax
 663:	f7 d8                	neg    %eax
 665:	89 45 ec             	mov    %eax,-0x14(%ebp)
 668:	eb 06                	jmp    670 <printint+0x32>
  } else {
    x = xx;
 66a:	8b 45 0c             	mov    0xc(%ebp),%eax
 66d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 670:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 677:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 67a:	8d 41 01             	lea    0x1(%ecx),%eax
 67d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 680:	8b 5d 10             	mov    0x10(%ebp),%ebx
 683:	8b 45 ec             	mov    -0x14(%ebp),%eax
 686:	ba 00 00 00 00       	mov    $0x0,%edx
 68b:	f7 f3                	div    %ebx
 68d:	89 d0                	mov    %edx,%eax
 68f:	0f b6 80 50 0e 00 00 	movzbl 0xe50(%eax),%eax
 696:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 69a:	8b 75 10             	mov    0x10(%ebp),%esi
 69d:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6a0:	ba 00 00 00 00       	mov    $0x0,%edx
 6a5:	f7 f6                	div    %esi
 6a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6aa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6ae:	75 c7                	jne    677 <printint+0x39>
  if(neg)
 6b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6b4:	74 10                	je     6c6 <printint+0x88>
    buf[i++] = '-';
 6b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6b9:	8d 50 01             	lea    0x1(%eax),%edx
 6bc:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6bf:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 6c4:	eb 1f                	jmp    6e5 <printint+0xa7>
 6c6:	eb 1d                	jmp    6e5 <printint+0xa7>
    putc(fd, buf[i]);
 6c8:	8d 55 dc             	lea    -0x24(%ebp),%edx
 6cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6ce:	01 d0                	add    %edx,%eax
 6d0:	0f b6 00             	movzbl (%eax),%eax
 6d3:	0f be c0             	movsbl %al,%eax
 6d6:	89 44 24 04          	mov    %eax,0x4(%esp)
 6da:	8b 45 08             	mov    0x8(%ebp),%eax
 6dd:	89 04 24             	mov    %eax,(%esp)
 6e0:	e8 31 ff ff ff       	call   616 <putc>
  while(--i >= 0)
 6e5:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 6e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 6ed:	79 d9                	jns    6c8 <printint+0x8a>
}
 6ef:	83 c4 30             	add    $0x30,%esp
 6f2:	5b                   	pop    %ebx
 6f3:	5e                   	pop    %esi
 6f4:	5d                   	pop    %ebp
 6f5:	c3                   	ret    

000006f6 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 6f6:	55                   	push   %ebp
 6f7:	89 e5                	mov    %esp,%ebp
 6f9:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 6fc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 703:	8d 45 0c             	lea    0xc(%ebp),%eax
 706:	83 c0 04             	add    $0x4,%eax
 709:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 70c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 713:	e9 7c 01 00 00       	jmp    894 <printf+0x19e>
    c = fmt[i] & 0xff;
 718:	8b 55 0c             	mov    0xc(%ebp),%edx
 71b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 71e:	01 d0                	add    %edx,%eax
 720:	0f b6 00             	movzbl (%eax),%eax
 723:	0f be c0             	movsbl %al,%eax
 726:	25 ff 00 00 00       	and    $0xff,%eax
 72b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 72e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 732:	75 2c                	jne    760 <printf+0x6a>
      if(c == '%'){
 734:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 738:	75 0c                	jne    746 <printf+0x50>
        state = '%';
 73a:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 741:	e9 4a 01 00 00       	jmp    890 <printf+0x19a>
      } else {
        putc(fd, c);
 746:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 749:	0f be c0             	movsbl %al,%eax
 74c:	89 44 24 04          	mov    %eax,0x4(%esp)
 750:	8b 45 08             	mov    0x8(%ebp),%eax
 753:	89 04 24             	mov    %eax,(%esp)
 756:	e8 bb fe ff ff       	call   616 <putc>
 75b:	e9 30 01 00 00       	jmp    890 <printf+0x19a>
      }
    } else if(state == '%'){
 760:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 764:	0f 85 26 01 00 00    	jne    890 <printf+0x19a>
      if(c == 'd'){
 76a:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 76e:	75 2d                	jne    79d <printf+0xa7>
        printint(fd, *ap, 10, 1);
 770:	8b 45 e8             	mov    -0x18(%ebp),%eax
 773:	8b 00                	mov    (%eax),%eax
 775:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 77c:	00 
 77d:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 784:	00 
 785:	89 44 24 04          	mov    %eax,0x4(%esp)
 789:	8b 45 08             	mov    0x8(%ebp),%eax
 78c:	89 04 24             	mov    %eax,(%esp)
 78f:	e8 aa fe ff ff       	call   63e <printint>
        ap++;
 794:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 798:	e9 ec 00 00 00       	jmp    889 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 79d:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 7a1:	74 06                	je     7a9 <printf+0xb3>
 7a3:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 7a7:	75 2d                	jne    7d6 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 7a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7ac:	8b 00                	mov    (%eax),%eax
 7ae:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 7b5:	00 
 7b6:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 7bd:	00 
 7be:	89 44 24 04          	mov    %eax,0x4(%esp)
 7c2:	8b 45 08             	mov    0x8(%ebp),%eax
 7c5:	89 04 24             	mov    %eax,(%esp)
 7c8:	e8 71 fe ff ff       	call   63e <printint>
        ap++;
 7cd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7d1:	e9 b3 00 00 00       	jmp    889 <printf+0x193>
      } else if(c == 's'){
 7d6:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 7da:	75 45                	jne    821 <printf+0x12b>
        s = (char*)*ap;
 7dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7df:	8b 00                	mov    (%eax),%eax
 7e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 7e4:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 7e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7ec:	75 09                	jne    7f7 <printf+0x101>
          s = "(null)";
 7ee:	c7 45 f4 c0 0b 00 00 	movl   $0xbc0,-0xc(%ebp)
        while(*s != 0){
 7f5:	eb 1e                	jmp    815 <printf+0x11f>
 7f7:	eb 1c                	jmp    815 <printf+0x11f>
          putc(fd, *s);
 7f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7fc:	0f b6 00             	movzbl (%eax),%eax
 7ff:	0f be c0             	movsbl %al,%eax
 802:	89 44 24 04          	mov    %eax,0x4(%esp)
 806:	8b 45 08             	mov    0x8(%ebp),%eax
 809:	89 04 24             	mov    %eax,(%esp)
 80c:	e8 05 fe ff ff       	call   616 <putc>
          s++;
 811:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 815:	8b 45 f4             	mov    -0xc(%ebp),%eax
 818:	0f b6 00             	movzbl (%eax),%eax
 81b:	84 c0                	test   %al,%al
 81d:	75 da                	jne    7f9 <printf+0x103>
 81f:	eb 68                	jmp    889 <printf+0x193>
        }
      } else if(c == 'c'){
 821:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 825:	75 1d                	jne    844 <printf+0x14e>
        putc(fd, *ap);
 827:	8b 45 e8             	mov    -0x18(%ebp),%eax
 82a:	8b 00                	mov    (%eax),%eax
 82c:	0f be c0             	movsbl %al,%eax
 82f:	89 44 24 04          	mov    %eax,0x4(%esp)
 833:	8b 45 08             	mov    0x8(%ebp),%eax
 836:	89 04 24             	mov    %eax,(%esp)
 839:	e8 d8 fd ff ff       	call   616 <putc>
        ap++;
 83e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 842:	eb 45                	jmp    889 <printf+0x193>
      } else if(c == '%'){
 844:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 848:	75 17                	jne    861 <printf+0x16b>
        putc(fd, c);
 84a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 84d:	0f be c0             	movsbl %al,%eax
 850:	89 44 24 04          	mov    %eax,0x4(%esp)
 854:	8b 45 08             	mov    0x8(%ebp),%eax
 857:	89 04 24             	mov    %eax,(%esp)
 85a:	e8 b7 fd ff ff       	call   616 <putc>
 85f:	eb 28                	jmp    889 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 861:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 868:	00 
 869:	8b 45 08             	mov    0x8(%ebp),%eax
 86c:	89 04 24             	mov    %eax,(%esp)
 86f:	e8 a2 fd ff ff       	call   616 <putc>
        putc(fd, c);
 874:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 877:	0f be c0             	movsbl %al,%eax
 87a:	89 44 24 04          	mov    %eax,0x4(%esp)
 87e:	8b 45 08             	mov    0x8(%ebp),%eax
 881:	89 04 24             	mov    %eax,(%esp)
 884:	e8 8d fd ff ff       	call   616 <putc>
      }
      state = 0;
 889:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 890:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 894:	8b 55 0c             	mov    0xc(%ebp),%edx
 897:	8b 45 f0             	mov    -0x10(%ebp),%eax
 89a:	01 d0                	add    %edx,%eax
 89c:	0f b6 00             	movzbl (%eax),%eax
 89f:	84 c0                	test   %al,%al
 8a1:	0f 85 71 fe ff ff    	jne    718 <printf+0x22>
    }
  }
}
 8a7:	c9                   	leave  
 8a8:	c3                   	ret    

000008a9 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8a9:	55                   	push   %ebp
 8aa:	89 e5                	mov    %esp,%ebp
 8ac:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8af:	8b 45 08             	mov    0x8(%ebp),%eax
 8b2:	83 e8 08             	sub    $0x8,%eax
 8b5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8b8:	a1 6c 0e 00 00       	mov    0xe6c,%eax
 8bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8c0:	eb 24                	jmp    8e6 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c5:	8b 00                	mov    (%eax),%eax
 8c7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8ca:	77 12                	ja     8de <free+0x35>
 8cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8cf:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8d2:	77 24                	ja     8f8 <free+0x4f>
 8d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d7:	8b 00                	mov    (%eax),%eax
 8d9:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8dc:	77 1a                	ja     8f8 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8de:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8e1:	8b 00                	mov    (%eax),%eax
 8e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8e6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8e9:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8ec:	76 d4                	jbe    8c2 <free+0x19>
 8ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f1:	8b 00                	mov    (%eax),%eax
 8f3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8f6:	76 ca                	jbe    8c2 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 8f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8fb:	8b 40 04             	mov    0x4(%eax),%eax
 8fe:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 905:	8b 45 f8             	mov    -0x8(%ebp),%eax
 908:	01 c2                	add    %eax,%edx
 90a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 90d:	8b 00                	mov    (%eax),%eax
 90f:	39 c2                	cmp    %eax,%edx
 911:	75 24                	jne    937 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 913:	8b 45 f8             	mov    -0x8(%ebp),%eax
 916:	8b 50 04             	mov    0x4(%eax),%edx
 919:	8b 45 fc             	mov    -0x4(%ebp),%eax
 91c:	8b 00                	mov    (%eax),%eax
 91e:	8b 40 04             	mov    0x4(%eax),%eax
 921:	01 c2                	add    %eax,%edx
 923:	8b 45 f8             	mov    -0x8(%ebp),%eax
 926:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 929:	8b 45 fc             	mov    -0x4(%ebp),%eax
 92c:	8b 00                	mov    (%eax),%eax
 92e:	8b 10                	mov    (%eax),%edx
 930:	8b 45 f8             	mov    -0x8(%ebp),%eax
 933:	89 10                	mov    %edx,(%eax)
 935:	eb 0a                	jmp    941 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 937:	8b 45 fc             	mov    -0x4(%ebp),%eax
 93a:	8b 10                	mov    (%eax),%edx
 93c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 93f:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 941:	8b 45 fc             	mov    -0x4(%ebp),%eax
 944:	8b 40 04             	mov    0x4(%eax),%eax
 947:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 94e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 951:	01 d0                	add    %edx,%eax
 953:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 956:	75 20                	jne    978 <free+0xcf>
    p->s.size += bp->s.size;
 958:	8b 45 fc             	mov    -0x4(%ebp),%eax
 95b:	8b 50 04             	mov    0x4(%eax),%edx
 95e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 961:	8b 40 04             	mov    0x4(%eax),%eax
 964:	01 c2                	add    %eax,%edx
 966:	8b 45 fc             	mov    -0x4(%ebp),%eax
 969:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 96c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 96f:	8b 10                	mov    (%eax),%edx
 971:	8b 45 fc             	mov    -0x4(%ebp),%eax
 974:	89 10                	mov    %edx,(%eax)
 976:	eb 08                	jmp    980 <free+0xd7>
  } else
    p->s.ptr = bp;
 978:	8b 45 fc             	mov    -0x4(%ebp),%eax
 97b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 97e:	89 10                	mov    %edx,(%eax)
  freep = p;
 980:	8b 45 fc             	mov    -0x4(%ebp),%eax
 983:	a3 6c 0e 00 00       	mov    %eax,0xe6c
}
 988:	c9                   	leave  
 989:	c3                   	ret    

0000098a <morecore>:

static Header*
morecore(uint nu)
{
 98a:	55                   	push   %ebp
 98b:	89 e5                	mov    %esp,%ebp
 98d:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 990:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 997:	77 07                	ja     9a0 <morecore+0x16>
    nu = 4096;
 999:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 9a0:	8b 45 08             	mov    0x8(%ebp),%eax
 9a3:	c1 e0 03             	shl    $0x3,%eax
 9a6:	89 04 24             	mov    %eax,(%esp)
 9a9:	e8 40 fc ff ff       	call   5ee <sbrk>
 9ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 9b1:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 9b5:	75 07                	jne    9be <morecore+0x34>
    return 0;
 9b7:	b8 00 00 00 00       	mov    $0x0,%eax
 9bc:	eb 22                	jmp    9e0 <morecore+0x56>
  hp = (Header*)p;
 9be:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 9c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9c7:	8b 55 08             	mov    0x8(%ebp),%edx
 9ca:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 9cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9d0:	83 c0 08             	add    $0x8,%eax
 9d3:	89 04 24             	mov    %eax,(%esp)
 9d6:	e8 ce fe ff ff       	call   8a9 <free>
  return freep;
 9db:	a1 6c 0e 00 00       	mov    0xe6c,%eax
}
 9e0:	c9                   	leave  
 9e1:	c3                   	ret    

000009e2 <malloc>:

void*
malloc(uint nbytes)
{
 9e2:	55                   	push   %ebp
 9e3:	89 e5                	mov    %esp,%ebp
 9e5:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9e8:	8b 45 08             	mov    0x8(%ebp),%eax
 9eb:	83 c0 07             	add    $0x7,%eax
 9ee:	c1 e8 03             	shr    $0x3,%eax
 9f1:	83 c0 01             	add    $0x1,%eax
 9f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 9f7:	a1 6c 0e 00 00       	mov    0xe6c,%eax
 9fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
 9ff:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a03:	75 23                	jne    a28 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a05:	c7 45 f0 64 0e 00 00 	movl   $0xe64,-0x10(%ebp)
 a0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a0f:	a3 6c 0e 00 00       	mov    %eax,0xe6c
 a14:	a1 6c 0e 00 00       	mov    0xe6c,%eax
 a19:	a3 64 0e 00 00       	mov    %eax,0xe64
    base.s.size = 0;
 a1e:	c7 05 68 0e 00 00 00 	movl   $0x0,0xe68
 a25:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a28:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a2b:	8b 00                	mov    (%eax),%eax
 a2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a33:	8b 40 04             	mov    0x4(%eax),%eax
 a36:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a39:	72 4d                	jb     a88 <malloc+0xa6>
      if(p->s.size == nunits)
 a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a3e:	8b 40 04             	mov    0x4(%eax),%eax
 a41:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 a44:	75 0c                	jne    a52 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a46:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a49:	8b 10                	mov    (%eax),%edx
 a4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a4e:	89 10                	mov    %edx,(%eax)
 a50:	eb 26                	jmp    a78 <malloc+0x96>
      else {
        p->s.size -= nunits;
 a52:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a55:	8b 40 04             	mov    0x4(%eax),%eax
 a58:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a5b:	89 c2                	mov    %eax,%edx
 a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a60:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a63:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a66:	8b 40 04             	mov    0x4(%eax),%eax
 a69:	c1 e0 03             	shl    $0x3,%eax
 a6c:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a72:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a75:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a78:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a7b:	a3 6c 0e 00 00       	mov    %eax,0xe6c
      return (void*)(p + 1);
 a80:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a83:	83 c0 08             	add    $0x8,%eax
 a86:	eb 38                	jmp    ac0 <malloc+0xde>
    }
    if(p == freep)
 a88:	a1 6c 0e 00 00       	mov    0xe6c,%eax
 a8d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 a90:	75 1b                	jne    aad <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 a92:	8b 45 ec             	mov    -0x14(%ebp),%eax
 a95:	89 04 24             	mov    %eax,(%esp)
 a98:	e8 ed fe ff ff       	call   98a <morecore>
 a9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
 aa0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 aa4:	75 07                	jne    aad <malloc+0xcb>
        return 0;
 aa6:	b8 00 00 00 00       	mov    $0x0,%eax
 aab:	eb 13                	jmp    ac0 <malloc+0xde>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab0:	89 45 f0             	mov    %eax,-0x10(%ebp)
 ab3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ab6:	8b 00                	mov    (%eax),%eax
 ab8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 abb:	e9 70 ff ff ff       	jmp    a30 <malloc+0x4e>
}
 ac0:	c9                   	leave  
 ac1:	c3                   	ret    
