
_tickettest:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
      printf(1, "parent pid: %d; tickets should be 10\n", getpid());
   9:	e8 2f 05 00 00       	call   53d <getpid>
   e:	89 44 24 08          	mov    %eax,0x8(%esp)
  12:	c7 44 24 04 1c 0a 00 	movl   $0xa1c,0x4(%esp)
  19:	00 
  1a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  21:	e8 27 06 00 00       	call   64d <printf>
        ps();
  26:	e8 6d 03 00 00       	call   398 <ps>
          int pid = fork();
  2b:	e8 85 04 00 00       	call   4b5 <fork>
  30:	89 44 24 1c          	mov    %eax,0x1c(%esp)
            if (pid == 0)
  34:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  39:	75 27                	jne    62 <main+0x62>
                  {
                           printf(1, "first child pid: %d; tickets should be 10\n", getpid());
  3b:	e8 fd 04 00 00       	call   53d <getpid>
  40:	89 44 24 08          	mov    %eax,0x8(%esp)
  44:	c7 44 24 04 44 0a 00 	movl   $0xa44,0x4(%esp)
  4b:	00 
  4c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  53:	e8 f5 05 00 00       	call   64d <printf>
                                ps();
  58:	e8 3b 03 00 00       	call   398 <ps>
                                     exit();
  5d:	e8 5b 04 00 00       	call   4bd <exit>
                                       }
              wait();
  62:	e8 5e 04 00 00       	call   4c5 <wait>
                printf(1, "parent pid: %d; setting tickets to 20\n", getpid());
  67:	e8 d1 04 00 00       	call   53d <getpid>
  6c:	89 44 24 08          	mov    %eax,0x8(%esp)
  70:	c7 44 24 04 70 0a 00 	movl   $0xa70,0x4(%esp)
  77:	00 
  78:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  7f:	e8 c9 05 00 00       	call   64d <printf>
                  settickets(20);
  84:	c7 04 24 14 00 00 00 	movl   $0x14,(%esp)
  8b:	e8 d5 04 00 00       	call   565 <settickets>
                    ps();
  90:	e8 03 03 00 00       	call   398 <ps>
                      pid = fork();
  95:	e8 1b 04 00 00       	call   4b5 <fork>
  9a:	89 44 24 1c          	mov    %eax,0x1c(%esp)
                        if (pid == 0)
  9e:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  a3:	0f 85 85 00 00 00    	jne    12e <main+0x12e>
                              {
                                       printf(1, "second child pid: %d; tickets should be 20\n", getpid());
  a9:	e8 8f 04 00 00       	call   53d <getpid>
  ae:	89 44 24 08          	mov    %eax,0x8(%esp)
  b2:	c7 44 24 04 98 0a 00 	movl   $0xa98,0x4(%esp)
  b9:	00 
  ba:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  c1:	e8 87 05 00 00       	call   64d <printf>
                                            ps();
  c6:	e8 cd 02 00 00       	call   398 <ps>
                                                 settickets(30);
  cb:	c7 04 24 1e 00 00 00 	movl   $0x1e,(%esp)
  d2:	e8 8e 04 00 00       	call   565 <settickets>
                                                      printf(1, "second child pid: %d; tickets should now be 30\n");
  d7:	c7 44 24 04 c4 0a 00 	movl   $0xac4,0x4(%esp)
  de:	00 
  df:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  e6:	e8 62 05 00 00       	call   64d <printf>
                                                           ps();
  eb:	e8 a8 02 00 00       	call   398 <ps>
                                                                pid = fork();
  f0:	e8 c0 03 00 00       	call   4b5 <fork>
  f5:	89 44 24 1c          	mov    %eax,0x1c(%esp)
                                                                     if (pid == 0)
  f9:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  fe:	75 24                	jne    124 <main+0x124>
                                                                              {
                                                                                          printf(1, "child of second child pid: %d; tickets should be 30\n", getpid());
 100:	e8 38 04 00 00       	call   53d <getpid>
 105:	89 44 24 08          	mov    %eax,0x8(%esp)
 109:	c7 44 24 04 f4 0a 00 	movl   $0xaf4,0x4(%esp)
 110:	00 
 111:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 118:	e8 30 05 00 00       	call   64d <printf>
                                                                                                  ps();
 11d:	e8 76 02 00 00       	call   398 <ps>
 122:	eb 0a                	jmp    12e <main+0x12e>
                                                                                                       } else
                                                                                                                {
                                                                                                                            wait();
 124:	e8 9c 03 00 00       	call   4c5 <wait>
                                                                                                                                    exit();
 129:	e8 8f 03 00 00       	call   4bd <exit>
                                                                                                                                         }
                                                                                                         }
                          wait();
 12e:	e8 92 03 00 00       	call   4c5 <wait>
                            exit();
 133:	e8 85 03 00 00       	call   4bd <exit>

00000138 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 138:	55                   	push   %ebp
 139:	89 e5                	mov    %esp,%ebp
 13b:	57                   	push   %edi
 13c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 13d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 140:	8b 55 10             	mov    0x10(%ebp),%edx
 143:	8b 45 0c             	mov    0xc(%ebp),%eax
 146:	89 cb                	mov    %ecx,%ebx
 148:	89 df                	mov    %ebx,%edi
 14a:	89 d1                	mov    %edx,%ecx
 14c:	fc                   	cld    
 14d:	f3 aa                	rep stos %al,%es:(%edi)
 14f:	89 ca                	mov    %ecx,%edx
 151:	89 fb                	mov    %edi,%ebx
 153:	89 5d 08             	mov    %ebx,0x8(%ebp)
 156:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 159:	5b                   	pop    %ebx
 15a:	5f                   	pop    %edi
 15b:	5d                   	pop    %ebp
 15c:	c3                   	ret    

0000015d <strcpy>:
#include "x86.h"
#include "pstat.h"

char*
strcpy(char *s, const char *t)
{
 15d:	55                   	push   %ebp
 15e:	89 e5                	mov    %esp,%ebp
 160:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 163:	8b 45 08             	mov    0x8(%ebp),%eax
 166:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 169:	90                   	nop
 16a:	8b 45 08             	mov    0x8(%ebp),%eax
 16d:	8d 50 01             	lea    0x1(%eax),%edx
 170:	89 55 08             	mov    %edx,0x8(%ebp)
 173:	8b 55 0c             	mov    0xc(%ebp),%edx
 176:	8d 4a 01             	lea    0x1(%edx),%ecx
 179:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 17c:	0f b6 12             	movzbl (%edx),%edx
 17f:	88 10                	mov    %dl,(%eax)
 181:	0f b6 00             	movzbl (%eax),%eax
 184:	84 c0                	test   %al,%al
 186:	75 e2                	jne    16a <strcpy+0xd>
    ;
  return os;
 188:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 18b:	c9                   	leave  
 18c:	c3                   	ret    

0000018d <strcmp>:

int
strcmp(const char *p, const char *q)
{
 18d:	55                   	push   %ebp
 18e:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 190:	eb 08                	jmp    19a <strcmp+0xd>
    p++, q++;
 192:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 196:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 19a:	8b 45 08             	mov    0x8(%ebp),%eax
 19d:	0f b6 00             	movzbl (%eax),%eax
 1a0:	84 c0                	test   %al,%al
 1a2:	74 10                	je     1b4 <strcmp+0x27>
 1a4:	8b 45 08             	mov    0x8(%ebp),%eax
 1a7:	0f b6 10             	movzbl (%eax),%edx
 1aa:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ad:	0f b6 00             	movzbl (%eax),%eax
 1b0:	38 c2                	cmp    %al,%dl
 1b2:	74 de                	je     192 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 1b4:	8b 45 08             	mov    0x8(%ebp),%eax
 1b7:	0f b6 00             	movzbl (%eax),%eax
 1ba:	0f b6 d0             	movzbl %al,%edx
 1bd:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c0:	0f b6 00             	movzbl (%eax),%eax
 1c3:	0f b6 c0             	movzbl %al,%eax
 1c6:	29 c2                	sub    %eax,%edx
 1c8:	89 d0                	mov    %edx,%eax
}
 1ca:	5d                   	pop    %ebp
 1cb:	c3                   	ret    

000001cc <strlen>:

uint
strlen(const char *s)
{
 1cc:	55                   	push   %ebp
 1cd:	89 e5                	mov    %esp,%ebp
 1cf:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1d2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1d9:	eb 04                	jmp    1df <strlen+0x13>
 1db:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1df:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1e2:	8b 45 08             	mov    0x8(%ebp),%eax
 1e5:	01 d0                	add    %edx,%eax
 1e7:	0f b6 00             	movzbl (%eax),%eax
 1ea:	84 c0                	test   %al,%al
 1ec:	75 ed                	jne    1db <strlen+0xf>
    ;
  return n;
 1ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1f1:	c9                   	leave  
 1f2:	c3                   	ret    

000001f3 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1f3:	55                   	push   %ebp
 1f4:	89 e5                	mov    %esp,%ebp
 1f6:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1f9:	8b 45 10             	mov    0x10(%ebp),%eax
 1fc:	89 44 24 08          	mov    %eax,0x8(%esp)
 200:	8b 45 0c             	mov    0xc(%ebp),%eax
 203:	89 44 24 04          	mov    %eax,0x4(%esp)
 207:	8b 45 08             	mov    0x8(%ebp),%eax
 20a:	89 04 24             	mov    %eax,(%esp)
 20d:	e8 26 ff ff ff       	call   138 <stosb>
  return dst;
 212:	8b 45 08             	mov    0x8(%ebp),%eax
}
 215:	c9                   	leave  
 216:	c3                   	ret    

00000217 <strchr>:

char*
strchr(const char *s, char c)
{
 217:	55                   	push   %ebp
 218:	89 e5                	mov    %esp,%ebp
 21a:	83 ec 04             	sub    $0x4,%esp
 21d:	8b 45 0c             	mov    0xc(%ebp),%eax
 220:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 223:	eb 14                	jmp    239 <strchr+0x22>
    if(*s == c)
 225:	8b 45 08             	mov    0x8(%ebp),%eax
 228:	0f b6 00             	movzbl (%eax),%eax
 22b:	3a 45 fc             	cmp    -0x4(%ebp),%al
 22e:	75 05                	jne    235 <strchr+0x1e>
      return (char*)s;
 230:	8b 45 08             	mov    0x8(%ebp),%eax
 233:	eb 13                	jmp    248 <strchr+0x31>
  for(; *s; s++)
 235:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 239:	8b 45 08             	mov    0x8(%ebp),%eax
 23c:	0f b6 00             	movzbl (%eax),%eax
 23f:	84 c0                	test   %al,%al
 241:	75 e2                	jne    225 <strchr+0xe>
  return 0;
 243:	b8 00 00 00 00       	mov    $0x0,%eax
}
 248:	c9                   	leave  
 249:	c3                   	ret    

0000024a <gets>:

char*
gets(char *buf, int max)
{
 24a:	55                   	push   %ebp
 24b:	89 e5                	mov    %esp,%ebp
 24d:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 250:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 257:	eb 4c                	jmp    2a5 <gets+0x5b>
    cc = read(0, &c, 1);
 259:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 260:	00 
 261:	8d 45 ef             	lea    -0x11(%ebp),%eax
 264:	89 44 24 04          	mov    %eax,0x4(%esp)
 268:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 26f:	e8 61 02 00 00       	call   4d5 <read>
 274:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 277:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 27b:	7f 02                	jg     27f <gets+0x35>
      break;
 27d:	eb 31                	jmp    2b0 <gets+0x66>
    buf[i++] = c;
 27f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 282:	8d 50 01             	lea    0x1(%eax),%edx
 285:	89 55 f4             	mov    %edx,-0xc(%ebp)
 288:	89 c2                	mov    %eax,%edx
 28a:	8b 45 08             	mov    0x8(%ebp),%eax
 28d:	01 c2                	add    %eax,%edx
 28f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 293:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 295:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 299:	3c 0a                	cmp    $0xa,%al
 29b:	74 13                	je     2b0 <gets+0x66>
 29d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2a1:	3c 0d                	cmp    $0xd,%al
 2a3:	74 0b                	je     2b0 <gets+0x66>
  for(i=0; i+1 < max; ){
 2a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2a8:	83 c0 01             	add    $0x1,%eax
 2ab:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2ae:	7c a9                	jl     259 <gets+0xf>
      break;
  }
  buf[i] = '\0';
 2b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
 2b3:	8b 45 08             	mov    0x8(%ebp),%eax
 2b6:	01 d0                	add    %edx,%eax
 2b8:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2bb:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2be:	c9                   	leave  
 2bf:	c3                   	ret    

000002c0 <stat>:

int
stat(const char *n, struct stat *st)
{
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
 2c3:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2c6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2cd:	00 
 2ce:	8b 45 08             	mov    0x8(%ebp),%eax
 2d1:	89 04 24             	mov    %eax,(%esp)
 2d4:	e8 24 02 00 00       	call   4fd <open>
 2d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2e0:	79 07                	jns    2e9 <stat+0x29>
    return -1;
 2e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2e7:	eb 23                	jmp    30c <stat+0x4c>
  r = fstat(fd, st);
 2e9:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ec:	89 44 24 04          	mov    %eax,0x4(%esp)
 2f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2f3:	89 04 24             	mov    %eax,(%esp)
 2f6:	e8 1a 02 00 00       	call   515 <fstat>
 2fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 301:	89 04 24             	mov    %eax,(%esp)
 304:	e8 dc 01 00 00       	call   4e5 <close>
  return r;
 309:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 30c:	c9                   	leave  
 30d:	c3                   	ret    

0000030e <atoi>:

int
atoi(const char *s)
{
 30e:	55                   	push   %ebp
 30f:	89 e5                	mov    %esp,%ebp
 311:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 314:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 31b:	eb 25                	jmp    342 <atoi+0x34>
    n = n*10 + *s++ - '0';
 31d:	8b 55 fc             	mov    -0x4(%ebp),%edx
 320:	89 d0                	mov    %edx,%eax
 322:	c1 e0 02             	shl    $0x2,%eax
 325:	01 d0                	add    %edx,%eax
 327:	01 c0                	add    %eax,%eax
 329:	89 c1                	mov    %eax,%ecx
 32b:	8b 45 08             	mov    0x8(%ebp),%eax
 32e:	8d 50 01             	lea    0x1(%eax),%edx
 331:	89 55 08             	mov    %edx,0x8(%ebp)
 334:	0f b6 00             	movzbl (%eax),%eax
 337:	0f be c0             	movsbl %al,%eax
 33a:	01 c8                	add    %ecx,%eax
 33c:	83 e8 30             	sub    $0x30,%eax
 33f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 342:	8b 45 08             	mov    0x8(%ebp),%eax
 345:	0f b6 00             	movzbl (%eax),%eax
 348:	3c 2f                	cmp    $0x2f,%al
 34a:	7e 0a                	jle    356 <atoi+0x48>
 34c:	8b 45 08             	mov    0x8(%ebp),%eax
 34f:	0f b6 00             	movzbl (%eax),%eax
 352:	3c 39                	cmp    $0x39,%al
 354:	7e c7                	jle    31d <atoi+0xf>
  return n;
 356:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 359:	c9                   	leave  
 35a:	c3                   	ret    

0000035b <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 35b:	55                   	push   %ebp
 35c:	89 e5                	mov    %esp,%ebp
 35e:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 361:	8b 45 08             	mov    0x8(%ebp),%eax
 364:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 367:	8b 45 0c             	mov    0xc(%ebp),%eax
 36a:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 36d:	eb 17                	jmp    386 <memmove+0x2b>
    *dst++ = *src++;
 36f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 372:	8d 50 01             	lea    0x1(%eax),%edx
 375:	89 55 fc             	mov    %edx,-0x4(%ebp)
 378:	8b 55 f8             	mov    -0x8(%ebp),%edx
 37b:	8d 4a 01             	lea    0x1(%edx),%ecx
 37e:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 381:	0f b6 12             	movzbl (%edx),%edx
 384:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 386:	8b 45 10             	mov    0x10(%ebp),%eax
 389:	8d 50 ff             	lea    -0x1(%eax),%edx
 38c:	89 55 10             	mov    %edx,0x10(%ebp)
 38f:	85 c0                	test   %eax,%eax
 391:	7f dc                	jg     36f <memmove+0x14>
  return vdst;
 393:	8b 45 08             	mov    0x8(%ebp),%eax
}
 396:	c9                   	leave  
 397:	c3                   	ret    

00000398 <ps>:

void 
ps()
{
 398:	55                   	push   %ebp
 399:	89 e5                	mov    %esp,%ebp
 39b:	57                   	push   %edi
 39c:	56                   	push   %esi
 39d:	53                   	push   %ebx
 39e:	81 ec 3c 09 00 00    	sub    $0x93c,%esp
  pstatTable pTable;
  getpinfo(&pTable);
 3a4:	8d 85 e4 f6 ff ff    	lea    -0x91c(%ebp),%eax
 3aa:	89 04 24             	mov    %eax,(%esp)
 3ad:	e8 ab 01 00 00       	call   55d <getpinfo>
  printf(1, "PID\tTKTS\tTCKS\tSTAT\tNAME\n");
 3b2:	c7 44 24 04 29 0b 00 	movl   $0xb29,0x4(%esp)
 3b9:	00 
 3ba:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 3c1:	e8 87 02 00 00       	call   64d <printf>
  int i;
  for (i = 0; i < NPROC; i++)
 3c6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 3cd:	e9 ce 00 00 00       	jmp    4a0 <ps+0x108>
  {
    if(pTable[i].inuse)
 3d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 3d5:	89 d0                	mov    %edx,%eax
 3d7:	c1 e0 03             	shl    $0x3,%eax
 3da:	01 d0                	add    %edx,%eax
 3dc:	c1 e0 02             	shl    $0x2,%eax
 3df:	8d 5d e8             	lea    -0x18(%ebp),%ebx
 3e2:	01 d8                	add    %ebx,%eax
 3e4:	2d 04 09 00 00       	sub    $0x904,%eax
 3e9:	8b 00                	mov    (%eax),%eax
 3eb:	85 c0                	test   %eax,%eax
 3ed:	0f 84 a9 00 00 00    	je     49c <ps+0x104>
      printf(1, "%d\t%d\t%d\t%c\t%s\n", pTable[i].pid, pTable[i].tickets, pTable[i].ticks, pTable[i].state, pTable[i].name);
 3f3:	8d 8d e4 f6 ff ff    	lea    -0x91c(%ebp),%ecx
 3f9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 3fc:	89 d0                	mov    %edx,%eax
 3fe:	c1 e0 03             	shl    $0x3,%eax
 401:	01 d0                	add    %edx,%eax
 403:	c1 e0 02             	shl    $0x2,%eax
 406:	83 c0 10             	add    $0x10,%eax
 409:	8d 3c 01             	lea    (%ecx,%eax,1),%edi
 40c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 40f:	89 d0                	mov    %edx,%eax
 411:	c1 e0 03             	shl    $0x3,%eax
 414:	01 d0                	add    %edx,%eax
 416:	c1 e0 02             	shl    $0x2,%eax
 419:	8d 75 e8             	lea    -0x18(%ebp),%esi
 41c:	01 f0                	add    %esi,%eax
 41e:	2d e4 08 00 00       	sub    $0x8e4,%eax
 423:	0f b6 00             	movzbl (%eax),%eax
 426:	0f be f0             	movsbl %al,%esi
 429:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 42c:	89 d0                	mov    %edx,%eax
 42e:	c1 e0 03             	shl    $0x3,%eax
 431:	01 d0                	add    %edx,%eax
 433:	c1 e0 02             	shl    $0x2,%eax
 436:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 439:	01 c8                	add    %ecx,%eax
 43b:	2d f8 08 00 00       	sub    $0x8f8,%eax
 440:	8b 18                	mov    (%eax),%ebx
 442:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 445:	89 d0                	mov    %edx,%eax
 447:	c1 e0 03             	shl    $0x3,%eax
 44a:	01 d0                	add    %edx,%eax
 44c:	c1 e0 02             	shl    $0x2,%eax
 44f:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 452:	01 c8                	add    %ecx,%eax
 454:	2d 00 09 00 00       	sub    $0x900,%eax
 459:	8b 08                	mov    (%eax),%ecx
 45b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 45e:	89 d0                	mov    %edx,%eax
 460:	c1 e0 03             	shl    $0x3,%eax
 463:	01 d0                	add    %edx,%eax
 465:	c1 e0 02             	shl    $0x2,%eax
 468:	8d 55 e8             	lea    -0x18(%ebp),%edx
 46b:	01 d0                	add    %edx,%eax
 46d:	2d fc 08 00 00       	sub    $0x8fc,%eax
 472:	8b 00                	mov    (%eax),%eax
 474:	89 7c 24 18          	mov    %edi,0x18(%esp)
 478:	89 74 24 14          	mov    %esi,0x14(%esp)
 47c:	89 5c 24 10          	mov    %ebx,0x10(%esp)
 480:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 484:	89 44 24 08          	mov    %eax,0x8(%esp)
 488:	c7 44 24 04 42 0b 00 	movl   $0xb42,0x4(%esp)
 48f:	00 
 490:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 497:	e8 b1 01 00 00       	call   64d <printf>
  for (i = 0; i < NPROC; i++)
 49c:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 4a0:	83 7d e4 3f          	cmpl   $0x3f,-0x1c(%ebp)
 4a4:	0f 8e 28 ff ff ff    	jle    3d2 <ps+0x3a>
  }
}
 4aa:	81 c4 3c 09 00 00    	add    $0x93c,%esp
 4b0:	5b                   	pop    %ebx
 4b1:	5e                   	pop    %esi
 4b2:	5f                   	pop    %edi
 4b3:	5d                   	pop    %ebp
 4b4:	c3                   	ret    

000004b5 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4b5:	b8 01 00 00 00       	mov    $0x1,%eax
 4ba:	cd 40                	int    $0x40
 4bc:	c3                   	ret    

000004bd <exit>:
SYSCALL(exit)
 4bd:	b8 02 00 00 00       	mov    $0x2,%eax
 4c2:	cd 40                	int    $0x40
 4c4:	c3                   	ret    

000004c5 <wait>:
SYSCALL(wait)
 4c5:	b8 03 00 00 00       	mov    $0x3,%eax
 4ca:	cd 40                	int    $0x40
 4cc:	c3                   	ret    

000004cd <pipe>:
SYSCALL(pipe)
 4cd:	b8 04 00 00 00       	mov    $0x4,%eax
 4d2:	cd 40                	int    $0x40
 4d4:	c3                   	ret    

000004d5 <read>:
SYSCALL(read)
 4d5:	b8 05 00 00 00       	mov    $0x5,%eax
 4da:	cd 40                	int    $0x40
 4dc:	c3                   	ret    

000004dd <write>:
SYSCALL(write)
 4dd:	b8 10 00 00 00       	mov    $0x10,%eax
 4e2:	cd 40                	int    $0x40
 4e4:	c3                   	ret    

000004e5 <close>:
SYSCALL(close)
 4e5:	b8 15 00 00 00       	mov    $0x15,%eax
 4ea:	cd 40                	int    $0x40
 4ec:	c3                   	ret    

000004ed <kill>:
SYSCALL(kill)
 4ed:	b8 06 00 00 00       	mov    $0x6,%eax
 4f2:	cd 40                	int    $0x40
 4f4:	c3                   	ret    

000004f5 <exec>:
SYSCALL(exec)
 4f5:	b8 07 00 00 00       	mov    $0x7,%eax
 4fa:	cd 40                	int    $0x40
 4fc:	c3                   	ret    

000004fd <open>:
SYSCALL(open)
 4fd:	b8 0f 00 00 00       	mov    $0xf,%eax
 502:	cd 40                	int    $0x40
 504:	c3                   	ret    

00000505 <mknod>:
SYSCALL(mknod)
 505:	b8 11 00 00 00       	mov    $0x11,%eax
 50a:	cd 40                	int    $0x40
 50c:	c3                   	ret    

0000050d <unlink>:
SYSCALL(unlink)
 50d:	b8 12 00 00 00       	mov    $0x12,%eax
 512:	cd 40                	int    $0x40
 514:	c3                   	ret    

00000515 <fstat>:
SYSCALL(fstat)
 515:	b8 08 00 00 00       	mov    $0x8,%eax
 51a:	cd 40                	int    $0x40
 51c:	c3                   	ret    

0000051d <link>:
SYSCALL(link)
 51d:	b8 13 00 00 00       	mov    $0x13,%eax
 522:	cd 40                	int    $0x40
 524:	c3                   	ret    

00000525 <mkdir>:
SYSCALL(mkdir)
 525:	b8 14 00 00 00       	mov    $0x14,%eax
 52a:	cd 40                	int    $0x40
 52c:	c3                   	ret    

0000052d <chdir>:
SYSCALL(chdir)
 52d:	b8 09 00 00 00       	mov    $0x9,%eax
 532:	cd 40                	int    $0x40
 534:	c3                   	ret    

00000535 <dup>:
SYSCALL(dup)
 535:	b8 0a 00 00 00       	mov    $0xa,%eax
 53a:	cd 40                	int    $0x40
 53c:	c3                   	ret    

0000053d <getpid>:
SYSCALL(getpid)
 53d:	b8 0b 00 00 00       	mov    $0xb,%eax
 542:	cd 40                	int    $0x40
 544:	c3                   	ret    

00000545 <sbrk>:
SYSCALL(sbrk)
 545:	b8 0c 00 00 00       	mov    $0xc,%eax
 54a:	cd 40                	int    $0x40
 54c:	c3                   	ret    

0000054d <sleep>:
SYSCALL(sleep)
 54d:	b8 0d 00 00 00       	mov    $0xd,%eax
 552:	cd 40                	int    $0x40
 554:	c3                   	ret    

00000555 <uptime>:
SYSCALL(uptime)
 555:	b8 0e 00 00 00       	mov    $0xe,%eax
 55a:	cd 40                	int    $0x40
 55c:	c3                   	ret    

0000055d <getpinfo>:
SYSCALL(getpinfo)
 55d:	b8 16 00 00 00       	mov    $0x16,%eax
 562:	cd 40                	int    $0x40
 564:	c3                   	ret    

00000565 <settickets>:
SYSCALL(settickets)
 565:	b8 18 00 00 00       	mov    $0x18,%eax
 56a:	cd 40                	int    $0x40
 56c:	c3                   	ret    

0000056d <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 56d:	55                   	push   %ebp
 56e:	89 e5                	mov    %esp,%ebp
 570:	83 ec 18             	sub    $0x18,%esp
 573:	8b 45 0c             	mov    0xc(%ebp),%eax
 576:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 579:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 580:	00 
 581:	8d 45 f4             	lea    -0xc(%ebp),%eax
 584:	89 44 24 04          	mov    %eax,0x4(%esp)
 588:	8b 45 08             	mov    0x8(%ebp),%eax
 58b:	89 04 24             	mov    %eax,(%esp)
 58e:	e8 4a ff ff ff       	call   4dd <write>
}
 593:	c9                   	leave  
 594:	c3                   	ret    

00000595 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 595:	55                   	push   %ebp
 596:	89 e5                	mov    %esp,%ebp
 598:	56                   	push   %esi
 599:	53                   	push   %ebx
 59a:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 59d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 5a4:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 5a8:	74 17                	je     5c1 <printint+0x2c>
 5aa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 5ae:	79 11                	jns    5c1 <printint+0x2c>
    neg = 1;
 5b0:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 5b7:	8b 45 0c             	mov    0xc(%ebp),%eax
 5ba:	f7 d8                	neg    %eax
 5bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
 5bf:	eb 06                	jmp    5c7 <printint+0x32>
  } else {
    x = xx;
 5c1:	8b 45 0c             	mov    0xc(%ebp),%eax
 5c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 5c7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 5ce:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 5d1:	8d 41 01             	lea    0x1(%ecx),%eax
 5d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
 5d7:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5da:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5dd:	ba 00 00 00 00       	mov    $0x0,%edx
 5e2:	f7 f3                	div    %ebx
 5e4:	89 d0                	mov    %edx,%eax
 5e6:	0f b6 80 d0 0d 00 00 	movzbl 0xdd0(%eax),%eax
 5ed:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 5f1:	8b 75 10             	mov    0x10(%ebp),%esi
 5f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
 5f7:	ba 00 00 00 00       	mov    $0x0,%edx
 5fc:	f7 f6                	div    %esi
 5fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
 601:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 605:	75 c7                	jne    5ce <printint+0x39>
  if(neg)
 607:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 60b:	74 10                	je     61d <printint+0x88>
    buf[i++] = '-';
 60d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 610:	8d 50 01             	lea    0x1(%eax),%edx
 613:	89 55 f4             	mov    %edx,-0xc(%ebp)
 616:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 61b:	eb 1f                	jmp    63c <printint+0xa7>
 61d:	eb 1d                	jmp    63c <printint+0xa7>
    putc(fd, buf[i]);
 61f:	8d 55 dc             	lea    -0x24(%ebp),%edx
 622:	8b 45 f4             	mov    -0xc(%ebp),%eax
 625:	01 d0                	add    %edx,%eax
 627:	0f b6 00             	movzbl (%eax),%eax
 62a:	0f be c0             	movsbl %al,%eax
 62d:	89 44 24 04          	mov    %eax,0x4(%esp)
 631:	8b 45 08             	mov    0x8(%ebp),%eax
 634:	89 04 24             	mov    %eax,(%esp)
 637:	e8 31 ff ff ff       	call   56d <putc>
  while(--i >= 0)
 63c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 640:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 644:	79 d9                	jns    61f <printint+0x8a>
}
 646:	83 c4 30             	add    $0x30,%esp
 649:	5b                   	pop    %ebx
 64a:	5e                   	pop    %esi
 64b:	5d                   	pop    %ebp
 64c:	c3                   	ret    

0000064d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 64d:	55                   	push   %ebp
 64e:	89 e5                	mov    %esp,%ebp
 650:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 653:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 65a:	8d 45 0c             	lea    0xc(%ebp),%eax
 65d:	83 c0 04             	add    $0x4,%eax
 660:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 663:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 66a:	e9 7c 01 00 00       	jmp    7eb <printf+0x19e>
    c = fmt[i] & 0xff;
 66f:	8b 55 0c             	mov    0xc(%ebp),%edx
 672:	8b 45 f0             	mov    -0x10(%ebp),%eax
 675:	01 d0                	add    %edx,%eax
 677:	0f b6 00             	movzbl (%eax),%eax
 67a:	0f be c0             	movsbl %al,%eax
 67d:	25 ff 00 00 00       	and    $0xff,%eax
 682:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 685:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 689:	75 2c                	jne    6b7 <printf+0x6a>
      if(c == '%'){
 68b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 68f:	75 0c                	jne    69d <printf+0x50>
        state = '%';
 691:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 698:	e9 4a 01 00 00       	jmp    7e7 <printf+0x19a>
      } else {
        putc(fd, c);
 69d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6a0:	0f be c0             	movsbl %al,%eax
 6a3:	89 44 24 04          	mov    %eax,0x4(%esp)
 6a7:	8b 45 08             	mov    0x8(%ebp),%eax
 6aa:	89 04 24             	mov    %eax,(%esp)
 6ad:	e8 bb fe ff ff       	call   56d <putc>
 6b2:	e9 30 01 00 00       	jmp    7e7 <printf+0x19a>
      }
    } else if(state == '%'){
 6b7:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 6bb:	0f 85 26 01 00 00    	jne    7e7 <printf+0x19a>
      if(c == 'd'){
 6c1:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 6c5:	75 2d                	jne    6f4 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 6c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6ca:	8b 00                	mov    (%eax),%eax
 6cc:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 6d3:	00 
 6d4:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 6db:	00 
 6dc:	89 44 24 04          	mov    %eax,0x4(%esp)
 6e0:	8b 45 08             	mov    0x8(%ebp),%eax
 6e3:	89 04 24             	mov    %eax,(%esp)
 6e6:	e8 aa fe ff ff       	call   595 <printint>
        ap++;
 6eb:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6ef:	e9 ec 00 00 00       	jmp    7e0 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 6f4:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 6f8:	74 06                	je     700 <printf+0xb3>
 6fa:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 6fe:	75 2d                	jne    72d <printf+0xe0>
        printint(fd, *ap, 16, 0);
 700:	8b 45 e8             	mov    -0x18(%ebp),%eax
 703:	8b 00                	mov    (%eax),%eax
 705:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 70c:	00 
 70d:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 714:	00 
 715:	89 44 24 04          	mov    %eax,0x4(%esp)
 719:	8b 45 08             	mov    0x8(%ebp),%eax
 71c:	89 04 24             	mov    %eax,(%esp)
 71f:	e8 71 fe ff ff       	call   595 <printint>
        ap++;
 724:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 728:	e9 b3 00 00 00       	jmp    7e0 <printf+0x193>
      } else if(c == 's'){
 72d:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 731:	75 45                	jne    778 <printf+0x12b>
        s = (char*)*ap;
 733:	8b 45 e8             	mov    -0x18(%ebp),%eax
 736:	8b 00                	mov    (%eax),%eax
 738:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 73b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 73f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 743:	75 09                	jne    74e <printf+0x101>
          s = "(null)";
 745:	c7 45 f4 52 0b 00 00 	movl   $0xb52,-0xc(%ebp)
        while(*s != 0){
 74c:	eb 1e                	jmp    76c <printf+0x11f>
 74e:	eb 1c                	jmp    76c <printf+0x11f>
          putc(fd, *s);
 750:	8b 45 f4             	mov    -0xc(%ebp),%eax
 753:	0f b6 00             	movzbl (%eax),%eax
 756:	0f be c0             	movsbl %al,%eax
 759:	89 44 24 04          	mov    %eax,0x4(%esp)
 75d:	8b 45 08             	mov    0x8(%ebp),%eax
 760:	89 04 24             	mov    %eax,(%esp)
 763:	e8 05 fe ff ff       	call   56d <putc>
          s++;
 768:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 76c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 76f:	0f b6 00             	movzbl (%eax),%eax
 772:	84 c0                	test   %al,%al
 774:	75 da                	jne    750 <printf+0x103>
 776:	eb 68                	jmp    7e0 <printf+0x193>
        }
      } else if(c == 'c'){
 778:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 77c:	75 1d                	jne    79b <printf+0x14e>
        putc(fd, *ap);
 77e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 781:	8b 00                	mov    (%eax),%eax
 783:	0f be c0             	movsbl %al,%eax
 786:	89 44 24 04          	mov    %eax,0x4(%esp)
 78a:	8b 45 08             	mov    0x8(%ebp),%eax
 78d:	89 04 24             	mov    %eax,(%esp)
 790:	e8 d8 fd ff ff       	call   56d <putc>
        ap++;
 795:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 799:	eb 45                	jmp    7e0 <printf+0x193>
      } else if(c == '%'){
 79b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 79f:	75 17                	jne    7b8 <printf+0x16b>
        putc(fd, c);
 7a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7a4:	0f be c0             	movsbl %al,%eax
 7a7:	89 44 24 04          	mov    %eax,0x4(%esp)
 7ab:	8b 45 08             	mov    0x8(%ebp),%eax
 7ae:	89 04 24             	mov    %eax,(%esp)
 7b1:	e8 b7 fd ff ff       	call   56d <putc>
 7b6:	eb 28                	jmp    7e0 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 7b8:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 7bf:	00 
 7c0:	8b 45 08             	mov    0x8(%ebp),%eax
 7c3:	89 04 24             	mov    %eax,(%esp)
 7c6:	e8 a2 fd ff ff       	call   56d <putc>
        putc(fd, c);
 7cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 7ce:	0f be c0             	movsbl %al,%eax
 7d1:	89 44 24 04          	mov    %eax,0x4(%esp)
 7d5:	8b 45 08             	mov    0x8(%ebp),%eax
 7d8:	89 04 24             	mov    %eax,(%esp)
 7db:	e8 8d fd ff ff       	call   56d <putc>
      }
      state = 0;
 7e0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 7e7:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 7eb:	8b 55 0c             	mov    0xc(%ebp),%edx
 7ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f1:	01 d0                	add    %edx,%eax
 7f3:	0f b6 00             	movzbl (%eax),%eax
 7f6:	84 c0                	test   %al,%al
 7f8:	0f 85 71 fe ff ff    	jne    66f <printf+0x22>
    }
  }
}
 7fe:	c9                   	leave  
 7ff:	c3                   	ret    

00000800 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 800:	55                   	push   %ebp
 801:	89 e5                	mov    %esp,%ebp
 803:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 806:	8b 45 08             	mov    0x8(%ebp),%eax
 809:	83 e8 08             	sub    $0x8,%eax
 80c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 80f:	a1 ec 0d 00 00       	mov    0xdec,%eax
 814:	89 45 fc             	mov    %eax,-0x4(%ebp)
 817:	eb 24                	jmp    83d <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 819:	8b 45 fc             	mov    -0x4(%ebp),%eax
 81c:	8b 00                	mov    (%eax),%eax
 81e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 821:	77 12                	ja     835 <free+0x35>
 823:	8b 45 f8             	mov    -0x8(%ebp),%eax
 826:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 829:	77 24                	ja     84f <free+0x4f>
 82b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 82e:	8b 00                	mov    (%eax),%eax
 830:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 833:	77 1a                	ja     84f <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 835:	8b 45 fc             	mov    -0x4(%ebp),%eax
 838:	8b 00                	mov    (%eax),%eax
 83a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 83d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 840:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 843:	76 d4                	jbe    819 <free+0x19>
 845:	8b 45 fc             	mov    -0x4(%ebp),%eax
 848:	8b 00                	mov    (%eax),%eax
 84a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 84d:	76 ca                	jbe    819 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 84f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 852:	8b 40 04             	mov    0x4(%eax),%eax
 855:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 85c:	8b 45 f8             	mov    -0x8(%ebp),%eax
 85f:	01 c2                	add    %eax,%edx
 861:	8b 45 fc             	mov    -0x4(%ebp),%eax
 864:	8b 00                	mov    (%eax),%eax
 866:	39 c2                	cmp    %eax,%edx
 868:	75 24                	jne    88e <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 86a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 86d:	8b 50 04             	mov    0x4(%eax),%edx
 870:	8b 45 fc             	mov    -0x4(%ebp),%eax
 873:	8b 00                	mov    (%eax),%eax
 875:	8b 40 04             	mov    0x4(%eax),%eax
 878:	01 c2                	add    %eax,%edx
 87a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 87d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 880:	8b 45 fc             	mov    -0x4(%ebp),%eax
 883:	8b 00                	mov    (%eax),%eax
 885:	8b 10                	mov    (%eax),%edx
 887:	8b 45 f8             	mov    -0x8(%ebp),%eax
 88a:	89 10                	mov    %edx,(%eax)
 88c:	eb 0a                	jmp    898 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 88e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 891:	8b 10                	mov    (%eax),%edx
 893:	8b 45 f8             	mov    -0x8(%ebp),%eax
 896:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 898:	8b 45 fc             	mov    -0x4(%ebp),%eax
 89b:	8b 40 04             	mov    0x4(%eax),%eax
 89e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 8a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8a8:	01 d0                	add    %edx,%eax
 8aa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 8ad:	75 20                	jne    8cf <free+0xcf>
    p->s.size += bp->s.size;
 8af:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8b2:	8b 50 04             	mov    0x4(%eax),%edx
 8b5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8b8:	8b 40 04             	mov    0x4(%eax),%eax
 8bb:	01 c2                	add    %eax,%edx
 8bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8c0:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8c6:	8b 10                	mov    (%eax),%edx
 8c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8cb:	89 10                	mov    %edx,(%eax)
 8cd:	eb 08                	jmp    8d7 <free+0xd7>
  } else
    p->s.ptr = bp;
 8cf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8d2:	8b 55 f8             	mov    -0x8(%ebp),%edx
 8d5:	89 10                	mov    %edx,(%eax)
  freep = p;
 8d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8da:	a3 ec 0d 00 00       	mov    %eax,0xdec
}
 8df:	c9                   	leave  
 8e0:	c3                   	ret    

000008e1 <morecore>:

static Header*
morecore(uint nu)
{
 8e1:	55                   	push   %ebp
 8e2:	89 e5                	mov    %esp,%ebp
 8e4:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 8e7:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 8ee:	77 07                	ja     8f7 <morecore+0x16>
    nu = 4096;
 8f0:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 8f7:	8b 45 08             	mov    0x8(%ebp),%eax
 8fa:	c1 e0 03             	shl    $0x3,%eax
 8fd:	89 04 24             	mov    %eax,(%esp)
 900:	e8 40 fc ff ff       	call   545 <sbrk>
 905:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 908:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 90c:	75 07                	jne    915 <morecore+0x34>
    return 0;
 90e:	b8 00 00 00 00       	mov    $0x0,%eax
 913:	eb 22                	jmp    937 <morecore+0x56>
  hp = (Header*)p;
 915:	8b 45 f4             	mov    -0xc(%ebp),%eax
 918:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 91b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 91e:	8b 55 08             	mov    0x8(%ebp),%edx
 921:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 924:	8b 45 f0             	mov    -0x10(%ebp),%eax
 927:	83 c0 08             	add    $0x8,%eax
 92a:	89 04 24             	mov    %eax,(%esp)
 92d:	e8 ce fe ff ff       	call   800 <free>
  return freep;
 932:	a1 ec 0d 00 00       	mov    0xdec,%eax
}
 937:	c9                   	leave  
 938:	c3                   	ret    

00000939 <malloc>:

void*
malloc(uint nbytes)
{
 939:	55                   	push   %ebp
 93a:	89 e5                	mov    %esp,%ebp
 93c:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 93f:	8b 45 08             	mov    0x8(%ebp),%eax
 942:	83 c0 07             	add    $0x7,%eax
 945:	c1 e8 03             	shr    $0x3,%eax
 948:	83 c0 01             	add    $0x1,%eax
 94b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 94e:	a1 ec 0d 00 00       	mov    0xdec,%eax
 953:	89 45 f0             	mov    %eax,-0x10(%ebp)
 956:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 95a:	75 23                	jne    97f <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 95c:	c7 45 f0 e4 0d 00 00 	movl   $0xde4,-0x10(%ebp)
 963:	8b 45 f0             	mov    -0x10(%ebp),%eax
 966:	a3 ec 0d 00 00       	mov    %eax,0xdec
 96b:	a1 ec 0d 00 00       	mov    0xdec,%eax
 970:	a3 e4 0d 00 00       	mov    %eax,0xde4
    base.s.size = 0;
 975:	c7 05 e8 0d 00 00 00 	movl   $0x0,0xde8
 97c:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 97f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 982:	8b 00                	mov    (%eax),%eax
 984:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 987:	8b 45 f4             	mov    -0xc(%ebp),%eax
 98a:	8b 40 04             	mov    0x4(%eax),%eax
 98d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 990:	72 4d                	jb     9df <malloc+0xa6>
      if(p->s.size == nunits)
 992:	8b 45 f4             	mov    -0xc(%ebp),%eax
 995:	8b 40 04             	mov    0x4(%eax),%eax
 998:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 99b:	75 0c                	jne    9a9 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 99d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a0:	8b 10                	mov    (%eax),%edx
 9a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9a5:	89 10                	mov    %edx,(%eax)
 9a7:	eb 26                	jmp    9cf <malloc+0x96>
      else {
        p->s.size -= nunits;
 9a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ac:	8b 40 04             	mov    0x4(%eax),%eax
 9af:	2b 45 ec             	sub    -0x14(%ebp),%eax
 9b2:	89 c2                	mov    %eax,%edx
 9b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b7:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 9ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9bd:	8b 40 04             	mov    0x4(%eax),%eax
 9c0:	c1 e0 03             	shl    $0x3,%eax
 9c3:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 9c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9c9:	8b 55 ec             	mov    -0x14(%ebp),%edx
 9cc:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 9cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9d2:	a3 ec 0d 00 00       	mov    %eax,0xdec
      return (void*)(p + 1);
 9d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9da:	83 c0 08             	add    $0x8,%eax
 9dd:	eb 38                	jmp    a17 <malloc+0xde>
    }
    if(p == freep)
 9df:	a1 ec 0d 00 00       	mov    0xdec,%eax
 9e4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 9e7:	75 1b                	jne    a04 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 9e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 9ec:	89 04 24             	mov    %eax,(%esp)
 9ef:	e8 ed fe ff ff       	call   8e1 <morecore>
 9f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
 9f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9fb:	75 07                	jne    a04 <malloc+0xcb>
        return 0;
 9fd:	b8 00 00 00 00       	mov    $0x0,%eax
 a02:	eb 13                	jmp    a17 <malloc+0xde>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a04:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a07:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a0d:	8b 00                	mov    (%eax),%eax
 a0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 a12:	e9 70 ff ff ff       	jmp    987 <malloc+0x4e>
}
 a17:	c9                   	leave  
 a18:	c3                   	ret    
