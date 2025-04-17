
_grep:     file format elf32-i386


Disassembly of section .text:

00000000 <grep>:
char buf[1024];
int match(char*, char*);

void
grep(char *pattern, int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 28             	sub    $0x28,%esp
  int n, m;
  char *p, *q;

  m = 0;
   6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
   d:	e9 c6 00 00 00       	jmp    d8 <grep+0xd8>
    m += n;
  12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  15:	01 45 f4             	add    %eax,-0xc(%ebp)
    buf[m] = '\0';
  18:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1b:	05 e0 0f 00 00       	add    $0xfe0,%eax
  20:	c6 00 00             	movb   $0x0,(%eax)
    p = buf;
  23:	c7 45 f0 e0 0f 00 00 	movl   $0xfe0,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
  2a:	eb 51                	jmp    7d <grep+0x7d>
      *q = 0;
  2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  2f:	c6 00 00             	movb   $0x0,(%eax)
      if(match(pattern, p)){
  32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  35:	89 44 24 04          	mov    %eax,0x4(%esp)
  39:	8b 45 08             	mov    0x8(%ebp),%eax
  3c:	89 04 24             	mov    %eax,(%esp)
  3f:	e8 bc 01 00 00       	call   200 <match>
  44:	85 c0                	test   %eax,%eax
  46:	74 2c                	je     74 <grep+0x74>
        *q = '\n';
  48:	8b 45 e8             	mov    -0x18(%ebp),%eax
  4b:	c6 00 0a             	movb   $0xa,(%eax)
        write(1, p, q+1 - p);
  4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  51:	83 c0 01             	add    $0x1,%eax
  54:	89 c2                	mov    %eax,%edx
  56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  59:	29 c2                	sub    %eax,%edx
  5b:	89 d0                	mov    %edx,%eax
  5d:	89 44 24 08          	mov    %eax,0x8(%esp)
  61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  64:	89 44 24 04          	mov    %eax,0x4(%esp)
  68:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  6f:	e8 91 06 00 00       	call   705 <write>
      }
      p = q+1;
  74:	8b 45 e8             	mov    -0x18(%ebp),%eax
  77:	83 c0 01             	add    $0x1,%eax
  7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while((q = strchr(p, '\n')) != 0){
  7d:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  84:	00 
  85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  88:	89 04 24             	mov    %eax,(%esp)
  8b:	e8 af 03 00 00       	call   43f <strchr>
  90:	89 45 e8             	mov    %eax,-0x18(%ebp)
  93:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  97:	75 93                	jne    2c <grep+0x2c>
    }
    if(p == buf)
  99:	81 7d f0 e0 0f 00 00 	cmpl   $0xfe0,-0x10(%ebp)
  a0:	75 07                	jne    a9 <grep+0xa9>
      m = 0;
  a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(m > 0){
  a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  ad:	7e 29                	jle    d8 <grep+0xd8>
      m -= p - buf;
  af:	ba e0 0f 00 00       	mov    $0xfe0,%edx
  b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  b7:	29 c2                	sub    %eax,%edx
  b9:	89 d0                	mov    %edx,%eax
  bb:	01 45 f4             	add    %eax,-0xc(%ebp)
      memmove(buf, p, m);
  be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  c1:	89 44 24 08          	mov    %eax,0x8(%esp)
  c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  cc:	c7 04 24 e0 0f 00 00 	movl   $0xfe0,(%esp)
  d3:	e8 ab 04 00 00       	call   583 <memmove>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
  d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  db:	ba ff 03 00 00       	mov    $0x3ff,%edx
  e0:	29 c2                	sub    %eax,%edx
  e2:	89 d0                	mov    %edx,%eax
  e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  e7:	81 c2 e0 0f 00 00    	add    $0xfe0,%edx
  ed:	89 44 24 08          	mov    %eax,0x8(%esp)
  f1:	89 54 24 04          	mov    %edx,0x4(%esp)
  f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  f8:	89 04 24             	mov    %eax,(%esp)
  fb:	e8 fd 05 00 00       	call   6fd <read>
 100:	89 45 ec             	mov    %eax,-0x14(%ebp)
 103:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 107:	0f 8f 05 ff ff ff    	jg     12 <grep+0x12>
    }
  }
}
 10d:	c9                   	leave  
 10e:	c3                   	ret    

0000010f <main>:

int
main(int argc, char *argv[])
{
 10f:	55                   	push   %ebp
 110:	89 e5                	mov    %esp,%ebp
 112:	83 e4 f0             	and    $0xfffffff0,%esp
 115:	83 ec 20             	sub    $0x20,%esp
  int fd, i;
  char *pattern;

  if(argc <= 1){
 118:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 11c:	7f 19                	jg     137 <main+0x28>
    printf(2, "usage: grep pattern [file ...]\n");
 11e:	c7 44 24 04 44 0c 00 	movl   $0xc44,0x4(%esp)
 125:	00 
 126:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 12d:	e8 43 07 00 00       	call   875 <printf>
    exit();
 132:	e8 ae 05 00 00       	call   6e5 <exit>
  }
  pattern = argv[1];
 137:	8b 45 0c             	mov    0xc(%ebp),%eax
 13a:	8b 40 04             	mov    0x4(%eax),%eax
 13d:	89 44 24 18          	mov    %eax,0x18(%esp)

  if(argc <= 2){
 141:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
 145:	7f 19                	jg     160 <main+0x51>
    grep(pattern, 0);
 147:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 14e:	00 
 14f:	8b 44 24 18          	mov    0x18(%esp),%eax
 153:	89 04 24             	mov    %eax,(%esp)
 156:	e8 a5 fe ff ff       	call   0 <grep>
    exit();
 15b:	e8 85 05 00 00       	call   6e5 <exit>
  }

  for(i = 2; i < argc; i++){
 160:	c7 44 24 1c 02 00 00 	movl   $0x2,0x1c(%esp)
 167:	00 
 168:	e9 81 00 00 00       	jmp    1ee <main+0xdf>
    if((fd = open(argv[i], 0)) < 0){
 16d:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 171:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 178:	8b 45 0c             	mov    0xc(%ebp),%eax
 17b:	01 d0                	add    %edx,%eax
 17d:	8b 00                	mov    (%eax),%eax
 17f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 186:	00 
 187:	89 04 24             	mov    %eax,(%esp)
 18a:	e8 96 05 00 00       	call   725 <open>
 18f:	89 44 24 14          	mov    %eax,0x14(%esp)
 193:	83 7c 24 14 00       	cmpl   $0x0,0x14(%esp)
 198:	79 2f                	jns    1c9 <main+0xba>
      printf(1, "grep: cannot open %s\n", argv[i]);
 19a:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 19e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 1a5:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a8:	01 d0                	add    %edx,%eax
 1aa:	8b 00                	mov    (%eax),%eax
 1ac:	89 44 24 08          	mov    %eax,0x8(%esp)
 1b0:	c7 44 24 04 64 0c 00 	movl   $0xc64,0x4(%esp)
 1b7:	00 
 1b8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1bf:	e8 b1 06 00 00       	call   875 <printf>
      exit();
 1c4:	e8 1c 05 00 00       	call   6e5 <exit>
    }
    grep(pattern, fd);
 1c9:	8b 44 24 14          	mov    0x14(%esp),%eax
 1cd:	89 44 24 04          	mov    %eax,0x4(%esp)
 1d1:	8b 44 24 18          	mov    0x18(%esp),%eax
 1d5:	89 04 24             	mov    %eax,(%esp)
 1d8:	e8 23 fe ff ff       	call   0 <grep>
    close(fd);
 1dd:	8b 44 24 14          	mov    0x14(%esp),%eax
 1e1:	89 04 24             	mov    %eax,(%esp)
 1e4:	e8 24 05 00 00       	call   70d <close>
  for(i = 2; i < argc; i++){
 1e9:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 1ee:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 1f2:	3b 45 08             	cmp    0x8(%ebp),%eax
 1f5:	0f 8c 72 ff ff ff    	jl     16d <main+0x5e>
  }
  exit();
 1fb:	e8 e5 04 00 00       	call   6e5 <exit>

00000200 <match>:
int matchhere(char*, char*);
int matchstar(int, char*, char*);

int
match(char *re, char *text)
{
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	83 ec 18             	sub    $0x18,%esp
  if(re[0] == '^')
 206:	8b 45 08             	mov    0x8(%ebp),%eax
 209:	0f b6 00             	movzbl (%eax),%eax
 20c:	3c 5e                	cmp    $0x5e,%al
 20e:	75 17                	jne    227 <match+0x27>
    return matchhere(re+1, text);
 210:	8b 45 08             	mov    0x8(%ebp),%eax
 213:	8d 50 01             	lea    0x1(%eax),%edx
 216:	8b 45 0c             	mov    0xc(%ebp),%eax
 219:	89 44 24 04          	mov    %eax,0x4(%esp)
 21d:	89 14 24             	mov    %edx,(%esp)
 220:	e8 36 00 00 00       	call   25b <matchhere>
 225:	eb 32                	jmp    259 <match+0x59>
  do{  // must look at empty string
    if(matchhere(re, text))
 227:	8b 45 0c             	mov    0xc(%ebp),%eax
 22a:	89 44 24 04          	mov    %eax,0x4(%esp)
 22e:	8b 45 08             	mov    0x8(%ebp),%eax
 231:	89 04 24             	mov    %eax,(%esp)
 234:	e8 22 00 00 00       	call   25b <matchhere>
 239:	85 c0                	test   %eax,%eax
 23b:	74 07                	je     244 <match+0x44>
      return 1;
 23d:	b8 01 00 00 00       	mov    $0x1,%eax
 242:	eb 15                	jmp    259 <match+0x59>
  }while(*text++ != '\0');
 244:	8b 45 0c             	mov    0xc(%ebp),%eax
 247:	8d 50 01             	lea    0x1(%eax),%edx
 24a:	89 55 0c             	mov    %edx,0xc(%ebp)
 24d:	0f b6 00             	movzbl (%eax),%eax
 250:	84 c0                	test   %al,%al
 252:	75 d3                	jne    227 <match+0x27>
  return 0;
 254:	b8 00 00 00 00       	mov    $0x0,%eax
}
 259:	c9                   	leave  
 25a:	c3                   	ret    

0000025b <matchhere>:

// matchhere: search for re at beginning of text
int matchhere(char *re, char *text)
{
 25b:	55                   	push   %ebp
 25c:	89 e5                	mov    %esp,%ebp
 25e:	83 ec 18             	sub    $0x18,%esp
  if(re[0] == '\0')
 261:	8b 45 08             	mov    0x8(%ebp),%eax
 264:	0f b6 00             	movzbl (%eax),%eax
 267:	84 c0                	test   %al,%al
 269:	75 0a                	jne    275 <matchhere+0x1a>
    return 1;
 26b:	b8 01 00 00 00       	mov    $0x1,%eax
 270:	e9 9b 00 00 00       	jmp    310 <matchhere+0xb5>
  if(re[1] == '*')
 275:	8b 45 08             	mov    0x8(%ebp),%eax
 278:	83 c0 01             	add    $0x1,%eax
 27b:	0f b6 00             	movzbl (%eax),%eax
 27e:	3c 2a                	cmp    $0x2a,%al
 280:	75 24                	jne    2a6 <matchhere+0x4b>
    return matchstar(re[0], re+2, text);
 282:	8b 45 08             	mov    0x8(%ebp),%eax
 285:	8d 48 02             	lea    0x2(%eax),%ecx
 288:	8b 45 08             	mov    0x8(%ebp),%eax
 28b:	0f b6 00             	movzbl (%eax),%eax
 28e:	0f be c0             	movsbl %al,%eax
 291:	8b 55 0c             	mov    0xc(%ebp),%edx
 294:	89 54 24 08          	mov    %edx,0x8(%esp)
 298:	89 4c 24 04          	mov    %ecx,0x4(%esp)
 29c:	89 04 24             	mov    %eax,(%esp)
 29f:	e8 6e 00 00 00       	call   312 <matchstar>
 2a4:	eb 6a                	jmp    310 <matchhere+0xb5>
  if(re[0] == '$' && re[1] == '\0')
 2a6:	8b 45 08             	mov    0x8(%ebp),%eax
 2a9:	0f b6 00             	movzbl (%eax),%eax
 2ac:	3c 24                	cmp    $0x24,%al
 2ae:	75 1d                	jne    2cd <matchhere+0x72>
 2b0:	8b 45 08             	mov    0x8(%ebp),%eax
 2b3:	83 c0 01             	add    $0x1,%eax
 2b6:	0f b6 00             	movzbl (%eax),%eax
 2b9:	84 c0                	test   %al,%al
 2bb:	75 10                	jne    2cd <matchhere+0x72>
    return *text == '\0';
 2bd:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c0:	0f b6 00             	movzbl (%eax),%eax
 2c3:	84 c0                	test   %al,%al
 2c5:	0f 94 c0             	sete   %al
 2c8:	0f b6 c0             	movzbl %al,%eax
 2cb:	eb 43                	jmp    310 <matchhere+0xb5>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
 2cd:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d0:	0f b6 00             	movzbl (%eax),%eax
 2d3:	84 c0                	test   %al,%al
 2d5:	74 34                	je     30b <matchhere+0xb0>
 2d7:	8b 45 08             	mov    0x8(%ebp),%eax
 2da:	0f b6 00             	movzbl (%eax),%eax
 2dd:	3c 2e                	cmp    $0x2e,%al
 2df:	74 10                	je     2f1 <matchhere+0x96>
 2e1:	8b 45 08             	mov    0x8(%ebp),%eax
 2e4:	0f b6 10             	movzbl (%eax),%edx
 2e7:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ea:	0f b6 00             	movzbl (%eax),%eax
 2ed:	38 c2                	cmp    %al,%dl
 2ef:	75 1a                	jne    30b <matchhere+0xb0>
    return matchhere(re+1, text+1);
 2f1:	8b 45 0c             	mov    0xc(%ebp),%eax
 2f4:	8d 50 01             	lea    0x1(%eax),%edx
 2f7:	8b 45 08             	mov    0x8(%ebp),%eax
 2fa:	83 c0 01             	add    $0x1,%eax
 2fd:	89 54 24 04          	mov    %edx,0x4(%esp)
 301:	89 04 24             	mov    %eax,(%esp)
 304:	e8 52 ff ff ff       	call   25b <matchhere>
 309:	eb 05                	jmp    310 <matchhere+0xb5>
  return 0;
 30b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 310:	c9                   	leave  
 311:	c3                   	ret    

00000312 <matchstar>:

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
 312:	55                   	push   %ebp
 313:	89 e5                	mov    %esp,%ebp
 315:	83 ec 18             	sub    $0x18,%esp
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
 318:	8b 45 10             	mov    0x10(%ebp),%eax
 31b:	89 44 24 04          	mov    %eax,0x4(%esp)
 31f:	8b 45 0c             	mov    0xc(%ebp),%eax
 322:	89 04 24             	mov    %eax,(%esp)
 325:	e8 31 ff ff ff       	call   25b <matchhere>
 32a:	85 c0                	test   %eax,%eax
 32c:	74 07                	je     335 <matchstar+0x23>
      return 1;
 32e:	b8 01 00 00 00       	mov    $0x1,%eax
 333:	eb 29                	jmp    35e <matchstar+0x4c>
  }while(*text!='\0' && (*text++==c || c=='.'));
 335:	8b 45 10             	mov    0x10(%ebp),%eax
 338:	0f b6 00             	movzbl (%eax),%eax
 33b:	84 c0                	test   %al,%al
 33d:	74 1a                	je     359 <matchstar+0x47>
 33f:	8b 45 10             	mov    0x10(%ebp),%eax
 342:	8d 50 01             	lea    0x1(%eax),%edx
 345:	89 55 10             	mov    %edx,0x10(%ebp)
 348:	0f b6 00             	movzbl (%eax),%eax
 34b:	0f be c0             	movsbl %al,%eax
 34e:	3b 45 08             	cmp    0x8(%ebp),%eax
 351:	74 c5                	je     318 <matchstar+0x6>
 353:	83 7d 08 2e          	cmpl   $0x2e,0x8(%ebp)
 357:	74 bf                	je     318 <matchstar+0x6>
  return 0;
 359:	b8 00 00 00 00       	mov    $0x0,%eax
}
 35e:	c9                   	leave  
 35f:	c3                   	ret    

00000360 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	57                   	push   %edi
 364:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 365:	8b 4d 08             	mov    0x8(%ebp),%ecx
 368:	8b 55 10             	mov    0x10(%ebp),%edx
 36b:	8b 45 0c             	mov    0xc(%ebp),%eax
 36e:	89 cb                	mov    %ecx,%ebx
 370:	89 df                	mov    %ebx,%edi
 372:	89 d1                	mov    %edx,%ecx
 374:	fc                   	cld    
 375:	f3 aa                	rep stos %al,%es:(%edi)
 377:	89 ca                	mov    %ecx,%edx
 379:	89 fb                	mov    %edi,%ebx
 37b:	89 5d 08             	mov    %ebx,0x8(%ebp)
 37e:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 381:	5b                   	pop    %ebx
 382:	5f                   	pop    %edi
 383:	5d                   	pop    %ebp
 384:	c3                   	ret    

00000385 <strcpy>:
#include "x86.h"
#include "pstat.h"

char*
strcpy(char *s, const char *t)
{
 385:	55                   	push   %ebp
 386:	89 e5                	mov    %esp,%ebp
 388:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 38b:	8b 45 08             	mov    0x8(%ebp),%eax
 38e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 391:	90                   	nop
 392:	8b 45 08             	mov    0x8(%ebp),%eax
 395:	8d 50 01             	lea    0x1(%eax),%edx
 398:	89 55 08             	mov    %edx,0x8(%ebp)
 39b:	8b 55 0c             	mov    0xc(%ebp),%edx
 39e:	8d 4a 01             	lea    0x1(%edx),%ecx
 3a1:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 3a4:	0f b6 12             	movzbl (%edx),%edx
 3a7:	88 10                	mov    %dl,(%eax)
 3a9:	0f b6 00             	movzbl (%eax),%eax
 3ac:	84 c0                	test   %al,%al
 3ae:	75 e2                	jne    392 <strcpy+0xd>
    ;
  return os;
 3b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3b3:	c9                   	leave  
 3b4:	c3                   	ret    

000003b5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3b5:	55                   	push   %ebp
 3b6:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 3b8:	eb 08                	jmp    3c2 <strcmp+0xd>
    p++, q++;
 3ba:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3be:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 3c2:	8b 45 08             	mov    0x8(%ebp),%eax
 3c5:	0f b6 00             	movzbl (%eax),%eax
 3c8:	84 c0                	test   %al,%al
 3ca:	74 10                	je     3dc <strcmp+0x27>
 3cc:	8b 45 08             	mov    0x8(%ebp),%eax
 3cf:	0f b6 10             	movzbl (%eax),%edx
 3d2:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d5:	0f b6 00             	movzbl (%eax),%eax
 3d8:	38 c2                	cmp    %al,%dl
 3da:	74 de                	je     3ba <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 3dc:	8b 45 08             	mov    0x8(%ebp),%eax
 3df:	0f b6 00             	movzbl (%eax),%eax
 3e2:	0f b6 d0             	movzbl %al,%edx
 3e5:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e8:	0f b6 00             	movzbl (%eax),%eax
 3eb:	0f b6 c0             	movzbl %al,%eax
 3ee:	29 c2                	sub    %eax,%edx
 3f0:	89 d0                	mov    %edx,%eax
}
 3f2:	5d                   	pop    %ebp
 3f3:	c3                   	ret    

000003f4 <strlen>:

uint
strlen(const char *s)
{
 3f4:	55                   	push   %ebp
 3f5:	89 e5                	mov    %esp,%ebp
 3f7:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 401:	eb 04                	jmp    407 <strlen+0x13>
 403:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 407:	8b 55 fc             	mov    -0x4(%ebp),%edx
 40a:	8b 45 08             	mov    0x8(%ebp),%eax
 40d:	01 d0                	add    %edx,%eax
 40f:	0f b6 00             	movzbl (%eax),%eax
 412:	84 c0                	test   %al,%al
 414:	75 ed                	jne    403 <strlen+0xf>
    ;
  return n;
 416:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 419:	c9                   	leave  
 41a:	c3                   	ret    

0000041b <memset>:

void*
memset(void *dst, int c, uint n)
{
 41b:	55                   	push   %ebp
 41c:	89 e5                	mov    %esp,%ebp
 41e:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 421:	8b 45 10             	mov    0x10(%ebp),%eax
 424:	89 44 24 08          	mov    %eax,0x8(%esp)
 428:	8b 45 0c             	mov    0xc(%ebp),%eax
 42b:	89 44 24 04          	mov    %eax,0x4(%esp)
 42f:	8b 45 08             	mov    0x8(%ebp),%eax
 432:	89 04 24             	mov    %eax,(%esp)
 435:	e8 26 ff ff ff       	call   360 <stosb>
  return dst;
 43a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 43d:	c9                   	leave  
 43e:	c3                   	ret    

0000043f <strchr>:

char*
strchr(const char *s, char c)
{
 43f:	55                   	push   %ebp
 440:	89 e5                	mov    %esp,%ebp
 442:	83 ec 04             	sub    $0x4,%esp
 445:	8b 45 0c             	mov    0xc(%ebp),%eax
 448:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 44b:	eb 14                	jmp    461 <strchr+0x22>
    if(*s == c)
 44d:	8b 45 08             	mov    0x8(%ebp),%eax
 450:	0f b6 00             	movzbl (%eax),%eax
 453:	3a 45 fc             	cmp    -0x4(%ebp),%al
 456:	75 05                	jne    45d <strchr+0x1e>
      return (char*)s;
 458:	8b 45 08             	mov    0x8(%ebp),%eax
 45b:	eb 13                	jmp    470 <strchr+0x31>
  for(; *s; s++)
 45d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 461:	8b 45 08             	mov    0x8(%ebp),%eax
 464:	0f b6 00             	movzbl (%eax),%eax
 467:	84 c0                	test   %al,%al
 469:	75 e2                	jne    44d <strchr+0xe>
  return 0;
 46b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 470:	c9                   	leave  
 471:	c3                   	ret    

00000472 <gets>:

char*
gets(char *buf, int max)
{
 472:	55                   	push   %ebp
 473:	89 e5                	mov    %esp,%ebp
 475:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 478:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 47f:	eb 4c                	jmp    4cd <gets+0x5b>
    cc = read(0, &c, 1);
 481:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 488:	00 
 489:	8d 45 ef             	lea    -0x11(%ebp),%eax
 48c:	89 44 24 04          	mov    %eax,0x4(%esp)
 490:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 497:	e8 61 02 00 00       	call   6fd <read>
 49c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 49f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4a3:	7f 02                	jg     4a7 <gets+0x35>
      break;
 4a5:	eb 31                	jmp    4d8 <gets+0x66>
    buf[i++] = c;
 4a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4aa:	8d 50 01             	lea    0x1(%eax),%edx
 4ad:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4b0:	89 c2                	mov    %eax,%edx
 4b2:	8b 45 08             	mov    0x8(%ebp),%eax
 4b5:	01 c2                	add    %eax,%edx
 4b7:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4bb:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 4bd:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4c1:	3c 0a                	cmp    $0xa,%al
 4c3:	74 13                	je     4d8 <gets+0x66>
 4c5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4c9:	3c 0d                	cmp    $0xd,%al
 4cb:	74 0b                	je     4d8 <gets+0x66>
  for(i=0; i+1 < max; ){
 4cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4d0:	83 c0 01             	add    $0x1,%eax
 4d3:	3b 45 0c             	cmp    0xc(%ebp),%eax
 4d6:	7c a9                	jl     481 <gets+0xf>
      break;
  }
  buf[i] = '\0';
 4d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4db:	8b 45 08             	mov    0x8(%ebp),%eax
 4de:	01 d0                	add    %edx,%eax
 4e0:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4e3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4e6:	c9                   	leave  
 4e7:	c3                   	ret    

000004e8 <stat>:

int
stat(const char *n, struct stat *st)
{
 4e8:	55                   	push   %ebp
 4e9:	89 e5                	mov    %esp,%ebp
 4eb:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4ee:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 4f5:	00 
 4f6:	8b 45 08             	mov    0x8(%ebp),%eax
 4f9:	89 04 24             	mov    %eax,(%esp)
 4fc:	e8 24 02 00 00       	call   725 <open>
 501:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 504:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 508:	79 07                	jns    511 <stat+0x29>
    return -1;
 50a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 50f:	eb 23                	jmp    534 <stat+0x4c>
  r = fstat(fd, st);
 511:	8b 45 0c             	mov    0xc(%ebp),%eax
 514:	89 44 24 04          	mov    %eax,0x4(%esp)
 518:	8b 45 f4             	mov    -0xc(%ebp),%eax
 51b:	89 04 24             	mov    %eax,(%esp)
 51e:	e8 1a 02 00 00       	call   73d <fstat>
 523:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 526:	8b 45 f4             	mov    -0xc(%ebp),%eax
 529:	89 04 24             	mov    %eax,(%esp)
 52c:	e8 dc 01 00 00       	call   70d <close>
  return r;
 531:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 534:	c9                   	leave  
 535:	c3                   	ret    

00000536 <atoi>:

int
atoi(const char *s)
{
 536:	55                   	push   %ebp
 537:	89 e5                	mov    %esp,%ebp
 539:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 53c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 543:	eb 25                	jmp    56a <atoi+0x34>
    n = n*10 + *s++ - '0';
 545:	8b 55 fc             	mov    -0x4(%ebp),%edx
 548:	89 d0                	mov    %edx,%eax
 54a:	c1 e0 02             	shl    $0x2,%eax
 54d:	01 d0                	add    %edx,%eax
 54f:	01 c0                	add    %eax,%eax
 551:	89 c1                	mov    %eax,%ecx
 553:	8b 45 08             	mov    0x8(%ebp),%eax
 556:	8d 50 01             	lea    0x1(%eax),%edx
 559:	89 55 08             	mov    %edx,0x8(%ebp)
 55c:	0f b6 00             	movzbl (%eax),%eax
 55f:	0f be c0             	movsbl %al,%eax
 562:	01 c8                	add    %ecx,%eax
 564:	83 e8 30             	sub    $0x30,%eax
 567:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 56a:	8b 45 08             	mov    0x8(%ebp),%eax
 56d:	0f b6 00             	movzbl (%eax),%eax
 570:	3c 2f                	cmp    $0x2f,%al
 572:	7e 0a                	jle    57e <atoi+0x48>
 574:	8b 45 08             	mov    0x8(%ebp),%eax
 577:	0f b6 00             	movzbl (%eax),%eax
 57a:	3c 39                	cmp    $0x39,%al
 57c:	7e c7                	jle    545 <atoi+0xf>
  return n;
 57e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 581:	c9                   	leave  
 582:	c3                   	ret    

00000583 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 583:	55                   	push   %ebp
 584:	89 e5                	mov    %esp,%ebp
 586:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 589:	8b 45 08             	mov    0x8(%ebp),%eax
 58c:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 58f:	8b 45 0c             	mov    0xc(%ebp),%eax
 592:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 595:	eb 17                	jmp    5ae <memmove+0x2b>
    *dst++ = *src++;
 597:	8b 45 fc             	mov    -0x4(%ebp),%eax
 59a:	8d 50 01             	lea    0x1(%eax),%edx
 59d:	89 55 fc             	mov    %edx,-0x4(%ebp)
 5a0:	8b 55 f8             	mov    -0x8(%ebp),%edx
 5a3:	8d 4a 01             	lea    0x1(%edx),%ecx
 5a6:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 5a9:	0f b6 12             	movzbl (%edx),%edx
 5ac:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 5ae:	8b 45 10             	mov    0x10(%ebp),%eax
 5b1:	8d 50 ff             	lea    -0x1(%eax),%edx
 5b4:	89 55 10             	mov    %edx,0x10(%ebp)
 5b7:	85 c0                	test   %eax,%eax
 5b9:	7f dc                	jg     597 <memmove+0x14>
  return vdst;
 5bb:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5be:	c9                   	leave  
 5bf:	c3                   	ret    

000005c0 <ps>:

void 
ps()
{
 5c0:	55                   	push   %ebp
 5c1:	89 e5                	mov    %esp,%ebp
 5c3:	57                   	push   %edi
 5c4:	56                   	push   %esi
 5c5:	53                   	push   %ebx
 5c6:	81 ec 3c 09 00 00    	sub    $0x93c,%esp
  pstatTable pTable;
  getpinfo(&pTable);
 5cc:	8d 85 e4 f6 ff ff    	lea    -0x91c(%ebp),%eax
 5d2:	89 04 24             	mov    %eax,(%esp)
 5d5:	e8 ab 01 00 00       	call   785 <getpinfo>
  printf(1, "PID\tTKTS\tTCKS\tSTAT\tNAME\n");
 5da:	c7 44 24 04 7a 0c 00 	movl   $0xc7a,0x4(%esp)
 5e1:	00 
 5e2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 5e9:	e8 87 02 00 00       	call   875 <printf>
  int i;
  for (i = 0; i < NPROC; i++)
 5ee:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 5f5:	e9 ce 00 00 00       	jmp    6c8 <ps+0x108>
  {
    if(pTable[i].inuse)
 5fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 5fd:	89 d0                	mov    %edx,%eax
 5ff:	c1 e0 03             	shl    $0x3,%eax
 602:	01 d0                	add    %edx,%eax
 604:	c1 e0 02             	shl    $0x2,%eax
 607:	8d 5d e8             	lea    -0x18(%ebp),%ebx
 60a:	01 d8                	add    %ebx,%eax
 60c:	2d 04 09 00 00       	sub    $0x904,%eax
 611:	8b 00                	mov    (%eax),%eax
 613:	85 c0                	test   %eax,%eax
 615:	0f 84 a9 00 00 00    	je     6c4 <ps+0x104>
      printf(1, "%d\t%d\t%d\t%c\t%s\n", pTable[i].pid, pTable[i].tickets, pTable[i].ticks, pTable[i].state, pTable[i].name);
 61b:	8d 8d e4 f6 ff ff    	lea    -0x91c(%ebp),%ecx
 621:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 624:	89 d0                	mov    %edx,%eax
 626:	c1 e0 03             	shl    $0x3,%eax
 629:	01 d0                	add    %edx,%eax
 62b:	c1 e0 02             	shl    $0x2,%eax
 62e:	83 c0 10             	add    $0x10,%eax
 631:	8d 3c 01             	lea    (%ecx,%eax,1),%edi
 634:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 637:	89 d0                	mov    %edx,%eax
 639:	c1 e0 03             	shl    $0x3,%eax
 63c:	01 d0                	add    %edx,%eax
 63e:	c1 e0 02             	shl    $0x2,%eax
 641:	8d 75 e8             	lea    -0x18(%ebp),%esi
 644:	01 f0                	add    %esi,%eax
 646:	2d e4 08 00 00       	sub    $0x8e4,%eax
 64b:	0f b6 00             	movzbl (%eax),%eax
 64e:	0f be f0             	movsbl %al,%esi
 651:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 654:	89 d0                	mov    %edx,%eax
 656:	c1 e0 03             	shl    $0x3,%eax
 659:	01 d0                	add    %edx,%eax
 65b:	c1 e0 02             	shl    $0x2,%eax
 65e:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 661:	01 c8                	add    %ecx,%eax
 663:	2d f8 08 00 00       	sub    $0x8f8,%eax
 668:	8b 18                	mov    (%eax),%ebx
 66a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 66d:	89 d0                	mov    %edx,%eax
 66f:	c1 e0 03             	shl    $0x3,%eax
 672:	01 d0                	add    %edx,%eax
 674:	c1 e0 02             	shl    $0x2,%eax
 677:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 67a:	01 c8                	add    %ecx,%eax
 67c:	2d 00 09 00 00       	sub    $0x900,%eax
 681:	8b 08                	mov    (%eax),%ecx
 683:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 686:	89 d0                	mov    %edx,%eax
 688:	c1 e0 03             	shl    $0x3,%eax
 68b:	01 d0                	add    %edx,%eax
 68d:	c1 e0 02             	shl    $0x2,%eax
 690:	8d 55 e8             	lea    -0x18(%ebp),%edx
 693:	01 d0                	add    %edx,%eax
 695:	2d fc 08 00 00       	sub    $0x8fc,%eax
 69a:	8b 00                	mov    (%eax),%eax
 69c:	89 7c 24 18          	mov    %edi,0x18(%esp)
 6a0:	89 74 24 14          	mov    %esi,0x14(%esp)
 6a4:	89 5c 24 10          	mov    %ebx,0x10(%esp)
 6a8:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 6ac:	89 44 24 08          	mov    %eax,0x8(%esp)
 6b0:	c7 44 24 04 93 0c 00 	movl   $0xc93,0x4(%esp)
 6b7:	00 
 6b8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 6bf:	e8 b1 01 00 00       	call   875 <printf>
  for (i = 0; i < NPROC; i++)
 6c4:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 6c8:	83 7d e4 3f          	cmpl   $0x3f,-0x1c(%ebp)
 6cc:	0f 8e 28 ff ff ff    	jle    5fa <ps+0x3a>
  }
}
 6d2:	81 c4 3c 09 00 00    	add    $0x93c,%esp
 6d8:	5b                   	pop    %ebx
 6d9:	5e                   	pop    %esi
 6da:	5f                   	pop    %edi
 6db:	5d                   	pop    %ebp
 6dc:	c3                   	ret    

000006dd <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 6dd:	b8 01 00 00 00       	mov    $0x1,%eax
 6e2:	cd 40                	int    $0x40
 6e4:	c3                   	ret    

000006e5 <exit>:
SYSCALL(exit)
 6e5:	b8 02 00 00 00       	mov    $0x2,%eax
 6ea:	cd 40                	int    $0x40
 6ec:	c3                   	ret    

000006ed <wait>:
SYSCALL(wait)
 6ed:	b8 03 00 00 00       	mov    $0x3,%eax
 6f2:	cd 40                	int    $0x40
 6f4:	c3                   	ret    

000006f5 <pipe>:
SYSCALL(pipe)
 6f5:	b8 04 00 00 00       	mov    $0x4,%eax
 6fa:	cd 40                	int    $0x40
 6fc:	c3                   	ret    

000006fd <read>:
SYSCALL(read)
 6fd:	b8 05 00 00 00       	mov    $0x5,%eax
 702:	cd 40                	int    $0x40
 704:	c3                   	ret    

00000705 <write>:
SYSCALL(write)
 705:	b8 10 00 00 00       	mov    $0x10,%eax
 70a:	cd 40                	int    $0x40
 70c:	c3                   	ret    

0000070d <close>:
SYSCALL(close)
 70d:	b8 15 00 00 00       	mov    $0x15,%eax
 712:	cd 40                	int    $0x40
 714:	c3                   	ret    

00000715 <kill>:
SYSCALL(kill)
 715:	b8 06 00 00 00       	mov    $0x6,%eax
 71a:	cd 40                	int    $0x40
 71c:	c3                   	ret    

0000071d <exec>:
SYSCALL(exec)
 71d:	b8 07 00 00 00       	mov    $0x7,%eax
 722:	cd 40                	int    $0x40
 724:	c3                   	ret    

00000725 <open>:
SYSCALL(open)
 725:	b8 0f 00 00 00       	mov    $0xf,%eax
 72a:	cd 40                	int    $0x40
 72c:	c3                   	ret    

0000072d <mknod>:
SYSCALL(mknod)
 72d:	b8 11 00 00 00       	mov    $0x11,%eax
 732:	cd 40                	int    $0x40
 734:	c3                   	ret    

00000735 <unlink>:
SYSCALL(unlink)
 735:	b8 12 00 00 00       	mov    $0x12,%eax
 73a:	cd 40                	int    $0x40
 73c:	c3                   	ret    

0000073d <fstat>:
SYSCALL(fstat)
 73d:	b8 08 00 00 00       	mov    $0x8,%eax
 742:	cd 40                	int    $0x40
 744:	c3                   	ret    

00000745 <link>:
SYSCALL(link)
 745:	b8 13 00 00 00       	mov    $0x13,%eax
 74a:	cd 40                	int    $0x40
 74c:	c3                   	ret    

0000074d <mkdir>:
SYSCALL(mkdir)
 74d:	b8 14 00 00 00       	mov    $0x14,%eax
 752:	cd 40                	int    $0x40
 754:	c3                   	ret    

00000755 <chdir>:
SYSCALL(chdir)
 755:	b8 09 00 00 00       	mov    $0x9,%eax
 75a:	cd 40                	int    $0x40
 75c:	c3                   	ret    

0000075d <dup>:
SYSCALL(dup)
 75d:	b8 0a 00 00 00       	mov    $0xa,%eax
 762:	cd 40                	int    $0x40
 764:	c3                   	ret    

00000765 <getpid>:
SYSCALL(getpid)
 765:	b8 0b 00 00 00       	mov    $0xb,%eax
 76a:	cd 40                	int    $0x40
 76c:	c3                   	ret    

0000076d <sbrk>:
SYSCALL(sbrk)
 76d:	b8 0c 00 00 00       	mov    $0xc,%eax
 772:	cd 40                	int    $0x40
 774:	c3                   	ret    

00000775 <sleep>:
SYSCALL(sleep)
 775:	b8 0d 00 00 00       	mov    $0xd,%eax
 77a:	cd 40                	int    $0x40
 77c:	c3                   	ret    

0000077d <uptime>:
SYSCALL(uptime)
 77d:	b8 0e 00 00 00       	mov    $0xe,%eax
 782:	cd 40                	int    $0x40
 784:	c3                   	ret    

00000785 <getpinfo>:
SYSCALL(getpinfo)
 785:	b8 16 00 00 00       	mov    $0x16,%eax
 78a:	cd 40                	int    $0x40
 78c:	c3                   	ret    

0000078d <settickets>:
SYSCALL(settickets)
 78d:	b8 18 00 00 00       	mov    $0x18,%eax
 792:	cd 40                	int    $0x40
 794:	c3                   	ret    

00000795 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 795:	55                   	push   %ebp
 796:	89 e5                	mov    %esp,%ebp
 798:	83 ec 18             	sub    $0x18,%esp
 79b:	8b 45 0c             	mov    0xc(%ebp),%eax
 79e:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 7a1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 7a8:	00 
 7a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
 7ac:	89 44 24 04          	mov    %eax,0x4(%esp)
 7b0:	8b 45 08             	mov    0x8(%ebp),%eax
 7b3:	89 04 24             	mov    %eax,(%esp)
 7b6:	e8 4a ff ff ff       	call   705 <write>
}
 7bb:	c9                   	leave  
 7bc:	c3                   	ret    

000007bd <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 7bd:	55                   	push   %ebp
 7be:	89 e5                	mov    %esp,%ebp
 7c0:	56                   	push   %esi
 7c1:	53                   	push   %ebx
 7c2:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 7c5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 7cc:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 7d0:	74 17                	je     7e9 <printint+0x2c>
 7d2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 7d6:	79 11                	jns    7e9 <printint+0x2c>
    neg = 1;
 7d8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 7df:	8b 45 0c             	mov    0xc(%ebp),%eax
 7e2:	f7 d8                	neg    %eax
 7e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
 7e7:	eb 06                	jmp    7ef <printint+0x32>
  } else {
    x = xx;
 7e9:	8b 45 0c             	mov    0xc(%ebp),%eax
 7ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 7ef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 7f6:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 7f9:	8d 41 01             	lea    0x1(%ecx),%eax
 7fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7ff:	8b 5d 10             	mov    0x10(%ebp),%ebx
 802:	8b 45 ec             	mov    -0x14(%ebp),%eax
 805:	ba 00 00 00 00       	mov    $0x0,%edx
 80a:	f7 f3                	div    %ebx
 80c:	89 d0                	mov    %edx,%eax
 80e:	0f b6 80 a0 0f 00 00 	movzbl 0xfa0(%eax),%eax
 815:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 819:	8b 75 10             	mov    0x10(%ebp),%esi
 81c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 81f:	ba 00 00 00 00       	mov    $0x0,%edx
 824:	f7 f6                	div    %esi
 826:	89 45 ec             	mov    %eax,-0x14(%ebp)
 829:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 82d:	75 c7                	jne    7f6 <printint+0x39>
  if(neg)
 82f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 833:	74 10                	je     845 <printint+0x88>
    buf[i++] = '-';
 835:	8b 45 f4             	mov    -0xc(%ebp),%eax
 838:	8d 50 01             	lea    0x1(%eax),%edx
 83b:	89 55 f4             	mov    %edx,-0xc(%ebp)
 83e:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 843:	eb 1f                	jmp    864 <printint+0xa7>
 845:	eb 1d                	jmp    864 <printint+0xa7>
    putc(fd, buf[i]);
 847:	8d 55 dc             	lea    -0x24(%ebp),%edx
 84a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84d:	01 d0                	add    %edx,%eax
 84f:	0f b6 00             	movzbl (%eax),%eax
 852:	0f be c0             	movsbl %al,%eax
 855:	89 44 24 04          	mov    %eax,0x4(%esp)
 859:	8b 45 08             	mov    0x8(%ebp),%eax
 85c:	89 04 24             	mov    %eax,(%esp)
 85f:	e8 31 ff ff ff       	call   795 <putc>
  while(--i >= 0)
 864:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 868:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 86c:	79 d9                	jns    847 <printint+0x8a>
}
 86e:	83 c4 30             	add    $0x30,%esp
 871:	5b                   	pop    %ebx
 872:	5e                   	pop    %esi
 873:	5d                   	pop    %ebp
 874:	c3                   	ret    

00000875 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 875:	55                   	push   %ebp
 876:	89 e5                	mov    %esp,%ebp
 878:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 87b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 882:	8d 45 0c             	lea    0xc(%ebp),%eax
 885:	83 c0 04             	add    $0x4,%eax
 888:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 88b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 892:	e9 7c 01 00 00       	jmp    a13 <printf+0x19e>
    c = fmt[i] & 0xff;
 897:	8b 55 0c             	mov    0xc(%ebp),%edx
 89a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 89d:	01 d0                	add    %edx,%eax
 89f:	0f b6 00             	movzbl (%eax),%eax
 8a2:	0f be c0             	movsbl %al,%eax
 8a5:	25 ff 00 00 00       	and    $0xff,%eax
 8aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 8ad:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 8b1:	75 2c                	jne    8df <printf+0x6a>
      if(c == '%'){
 8b3:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 8b7:	75 0c                	jne    8c5 <printf+0x50>
        state = '%';
 8b9:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 8c0:	e9 4a 01 00 00       	jmp    a0f <printf+0x19a>
      } else {
        putc(fd, c);
 8c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8c8:	0f be c0             	movsbl %al,%eax
 8cb:	89 44 24 04          	mov    %eax,0x4(%esp)
 8cf:	8b 45 08             	mov    0x8(%ebp),%eax
 8d2:	89 04 24             	mov    %eax,(%esp)
 8d5:	e8 bb fe ff ff       	call   795 <putc>
 8da:	e9 30 01 00 00       	jmp    a0f <printf+0x19a>
      }
    } else if(state == '%'){
 8df:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 8e3:	0f 85 26 01 00 00    	jne    a0f <printf+0x19a>
      if(c == 'd'){
 8e9:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 8ed:	75 2d                	jne    91c <printf+0xa7>
        printint(fd, *ap, 10, 1);
 8ef:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8f2:	8b 00                	mov    (%eax),%eax
 8f4:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 8fb:	00 
 8fc:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 903:	00 
 904:	89 44 24 04          	mov    %eax,0x4(%esp)
 908:	8b 45 08             	mov    0x8(%ebp),%eax
 90b:	89 04 24             	mov    %eax,(%esp)
 90e:	e8 aa fe ff ff       	call   7bd <printint>
        ap++;
 913:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 917:	e9 ec 00 00 00       	jmp    a08 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 91c:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 920:	74 06                	je     928 <printf+0xb3>
 922:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 926:	75 2d                	jne    955 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 928:	8b 45 e8             	mov    -0x18(%ebp),%eax
 92b:	8b 00                	mov    (%eax),%eax
 92d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 934:	00 
 935:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 93c:	00 
 93d:	89 44 24 04          	mov    %eax,0x4(%esp)
 941:	8b 45 08             	mov    0x8(%ebp),%eax
 944:	89 04 24             	mov    %eax,(%esp)
 947:	e8 71 fe ff ff       	call   7bd <printint>
        ap++;
 94c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 950:	e9 b3 00 00 00       	jmp    a08 <printf+0x193>
      } else if(c == 's'){
 955:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 959:	75 45                	jne    9a0 <printf+0x12b>
        s = (char*)*ap;
 95b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 95e:	8b 00                	mov    (%eax),%eax
 960:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 963:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 967:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 96b:	75 09                	jne    976 <printf+0x101>
          s = "(null)";
 96d:	c7 45 f4 a3 0c 00 00 	movl   $0xca3,-0xc(%ebp)
        while(*s != 0){
 974:	eb 1e                	jmp    994 <printf+0x11f>
 976:	eb 1c                	jmp    994 <printf+0x11f>
          putc(fd, *s);
 978:	8b 45 f4             	mov    -0xc(%ebp),%eax
 97b:	0f b6 00             	movzbl (%eax),%eax
 97e:	0f be c0             	movsbl %al,%eax
 981:	89 44 24 04          	mov    %eax,0x4(%esp)
 985:	8b 45 08             	mov    0x8(%ebp),%eax
 988:	89 04 24             	mov    %eax,(%esp)
 98b:	e8 05 fe ff ff       	call   795 <putc>
          s++;
 990:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 994:	8b 45 f4             	mov    -0xc(%ebp),%eax
 997:	0f b6 00             	movzbl (%eax),%eax
 99a:	84 c0                	test   %al,%al
 99c:	75 da                	jne    978 <printf+0x103>
 99e:	eb 68                	jmp    a08 <printf+0x193>
        }
      } else if(c == 'c'){
 9a0:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 9a4:	75 1d                	jne    9c3 <printf+0x14e>
        putc(fd, *ap);
 9a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 9a9:	8b 00                	mov    (%eax),%eax
 9ab:	0f be c0             	movsbl %al,%eax
 9ae:	89 44 24 04          	mov    %eax,0x4(%esp)
 9b2:	8b 45 08             	mov    0x8(%ebp),%eax
 9b5:	89 04 24             	mov    %eax,(%esp)
 9b8:	e8 d8 fd ff ff       	call   795 <putc>
        ap++;
 9bd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 9c1:	eb 45                	jmp    a08 <printf+0x193>
      } else if(c == '%'){
 9c3:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 9c7:	75 17                	jne    9e0 <printf+0x16b>
        putc(fd, c);
 9c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 9cc:	0f be c0             	movsbl %al,%eax
 9cf:	89 44 24 04          	mov    %eax,0x4(%esp)
 9d3:	8b 45 08             	mov    0x8(%ebp),%eax
 9d6:	89 04 24             	mov    %eax,(%esp)
 9d9:	e8 b7 fd ff ff       	call   795 <putc>
 9de:	eb 28                	jmp    a08 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 9e0:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 9e7:	00 
 9e8:	8b 45 08             	mov    0x8(%ebp),%eax
 9eb:	89 04 24             	mov    %eax,(%esp)
 9ee:	e8 a2 fd ff ff       	call   795 <putc>
        putc(fd, c);
 9f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 9f6:	0f be c0             	movsbl %al,%eax
 9f9:	89 44 24 04          	mov    %eax,0x4(%esp)
 9fd:	8b 45 08             	mov    0x8(%ebp),%eax
 a00:	89 04 24             	mov    %eax,(%esp)
 a03:	e8 8d fd ff ff       	call   795 <putc>
      }
      state = 0;
 a08:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 a0f:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 a13:	8b 55 0c             	mov    0xc(%ebp),%edx
 a16:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a19:	01 d0                	add    %edx,%eax
 a1b:	0f b6 00             	movzbl (%eax),%eax
 a1e:	84 c0                	test   %al,%al
 a20:	0f 85 71 fe ff ff    	jne    897 <printf+0x22>
    }
  }
}
 a26:	c9                   	leave  
 a27:	c3                   	ret    

00000a28 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a28:	55                   	push   %ebp
 a29:	89 e5                	mov    %esp,%ebp
 a2b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a2e:	8b 45 08             	mov    0x8(%ebp),%eax
 a31:	83 e8 08             	sub    $0x8,%eax
 a34:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a37:	a1 c8 0f 00 00       	mov    0xfc8,%eax
 a3c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a3f:	eb 24                	jmp    a65 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a41:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a44:	8b 00                	mov    (%eax),%eax
 a46:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a49:	77 12                	ja     a5d <free+0x35>
 a4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a4e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a51:	77 24                	ja     a77 <free+0x4f>
 a53:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a56:	8b 00                	mov    (%eax),%eax
 a58:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a5b:	77 1a                	ja     a77 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a60:	8b 00                	mov    (%eax),%eax
 a62:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a65:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a68:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a6b:	76 d4                	jbe    a41 <free+0x19>
 a6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a70:	8b 00                	mov    (%eax),%eax
 a72:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a75:	76 ca                	jbe    a41 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 a77:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a7a:	8b 40 04             	mov    0x4(%eax),%eax
 a7d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 a84:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a87:	01 c2                	add    %eax,%edx
 a89:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a8c:	8b 00                	mov    (%eax),%eax
 a8e:	39 c2                	cmp    %eax,%edx
 a90:	75 24                	jne    ab6 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 a92:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a95:	8b 50 04             	mov    0x4(%eax),%edx
 a98:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a9b:	8b 00                	mov    (%eax),%eax
 a9d:	8b 40 04             	mov    0x4(%eax),%eax
 aa0:	01 c2                	add    %eax,%edx
 aa2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 aa5:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 aa8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aab:	8b 00                	mov    (%eax),%eax
 aad:	8b 10                	mov    (%eax),%edx
 aaf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ab2:	89 10                	mov    %edx,(%eax)
 ab4:	eb 0a                	jmp    ac0 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 ab6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ab9:	8b 10                	mov    (%eax),%edx
 abb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 abe:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 ac0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ac3:	8b 40 04             	mov    0x4(%eax),%eax
 ac6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 acd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ad0:	01 d0                	add    %edx,%eax
 ad2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 ad5:	75 20                	jne    af7 <free+0xcf>
    p->s.size += bp->s.size;
 ad7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ada:	8b 50 04             	mov    0x4(%eax),%edx
 add:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ae0:	8b 40 04             	mov    0x4(%eax),%eax
 ae3:	01 c2                	add    %eax,%edx
 ae5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ae8:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 aeb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 aee:	8b 10                	mov    (%eax),%edx
 af0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 af3:	89 10                	mov    %edx,(%eax)
 af5:	eb 08                	jmp    aff <free+0xd7>
  } else
    p->s.ptr = bp;
 af7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 afa:	8b 55 f8             	mov    -0x8(%ebp),%edx
 afd:	89 10                	mov    %edx,(%eax)
  freep = p;
 aff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b02:	a3 c8 0f 00 00       	mov    %eax,0xfc8
}
 b07:	c9                   	leave  
 b08:	c3                   	ret    

00000b09 <morecore>:

static Header*
morecore(uint nu)
{
 b09:	55                   	push   %ebp
 b0a:	89 e5                	mov    %esp,%ebp
 b0c:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 b0f:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 b16:	77 07                	ja     b1f <morecore+0x16>
    nu = 4096;
 b18:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 b1f:	8b 45 08             	mov    0x8(%ebp),%eax
 b22:	c1 e0 03             	shl    $0x3,%eax
 b25:	89 04 24             	mov    %eax,(%esp)
 b28:	e8 40 fc ff ff       	call   76d <sbrk>
 b2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 b30:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 b34:	75 07                	jne    b3d <morecore+0x34>
    return 0;
 b36:	b8 00 00 00 00       	mov    $0x0,%eax
 b3b:	eb 22                	jmp    b5f <morecore+0x56>
  hp = (Header*)p;
 b3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b40:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 b43:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b46:	8b 55 08             	mov    0x8(%ebp),%edx
 b49:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 b4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b4f:	83 c0 08             	add    $0x8,%eax
 b52:	89 04 24             	mov    %eax,(%esp)
 b55:	e8 ce fe ff ff       	call   a28 <free>
  return freep;
 b5a:	a1 c8 0f 00 00       	mov    0xfc8,%eax
}
 b5f:	c9                   	leave  
 b60:	c3                   	ret    

00000b61 <malloc>:

void*
malloc(uint nbytes)
{
 b61:	55                   	push   %ebp
 b62:	89 e5                	mov    %esp,%ebp
 b64:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b67:	8b 45 08             	mov    0x8(%ebp),%eax
 b6a:	83 c0 07             	add    $0x7,%eax
 b6d:	c1 e8 03             	shr    $0x3,%eax
 b70:	83 c0 01             	add    $0x1,%eax
 b73:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 b76:	a1 c8 0f 00 00       	mov    0xfc8,%eax
 b7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b7e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 b82:	75 23                	jne    ba7 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 b84:	c7 45 f0 c0 0f 00 00 	movl   $0xfc0,-0x10(%ebp)
 b8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b8e:	a3 c8 0f 00 00       	mov    %eax,0xfc8
 b93:	a1 c8 0f 00 00       	mov    0xfc8,%eax
 b98:	a3 c0 0f 00 00       	mov    %eax,0xfc0
    base.s.size = 0;
 b9d:	c7 05 c4 0f 00 00 00 	movl   $0x0,0xfc4
 ba4:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ba7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 baa:	8b 00                	mov    (%eax),%eax
 bac:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bb2:	8b 40 04             	mov    0x4(%eax),%eax
 bb5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 bb8:	72 4d                	jb     c07 <malloc+0xa6>
      if(p->s.size == nunits)
 bba:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bbd:	8b 40 04             	mov    0x4(%eax),%eax
 bc0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 bc3:	75 0c                	jne    bd1 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bc8:	8b 10                	mov    (%eax),%edx
 bca:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bcd:	89 10                	mov    %edx,(%eax)
 bcf:	eb 26                	jmp    bf7 <malloc+0x96>
      else {
        p->s.size -= nunits;
 bd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bd4:	8b 40 04             	mov    0x4(%eax),%eax
 bd7:	2b 45 ec             	sub    -0x14(%ebp),%eax
 bda:	89 c2                	mov    %eax,%edx
 bdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bdf:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 be5:	8b 40 04             	mov    0x4(%eax),%eax
 be8:	c1 e0 03             	shl    $0x3,%eax
 beb:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bf1:	8b 55 ec             	mov    -0x14(%ebp),%edx
 bf4:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 bf7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bfa:	a3 c8 0f 00 00       	mov    %eax,0xfc8
      return (void*)(p + 1);
 bff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c02:	83 c0 08             	add    $0x8,%eax
 c05:	eb 38                	jmp    c3f <malloc+0xde>
    }
    if(p == freep)
 c07:	a1 c8 0f 00 00       	mov    0xfc8,%eax
 c0c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 c0f:	75 1b                	jne    c2c <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 c11:	8b 45 ec             	mov    -0x14(%ebp),%eax
 c14:	89 04 24             	mov    %eax,(%esp)
 c17:	e8 ed fe ff ff       	call   b09 <morecore>
 c1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 c1f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 c23:	75 07                	jne    c2c <malloc+0xcb>
        return 0;
 c25:	b8 00 00 00 00       	mov    $0x0,%eax
 c2a:	eb 13                	jmp    c3f <malloc+0xde>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 c32:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c35:	8b 00                	mov    (%eax),%eax
 c37:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 c3a:	e9 70 ff ff ff       	jmp    baf <malloc+0x4e>
}
 c3f:	c9                   	leave  
 c40:	c3                   	ret    
