
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 ec 24             	sub    $0x24,%esp
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   7:	8b 45 08             	mov    0x8(%ebp),%eax
   a:	89 04 24             	mov    %eax,(%esp)
   d:	e8 dd 03 00 00       	call   3ef <strlen>
  12:	8b 55 08             	mov    0x8(%ebp),%edx
  15:	01 d0                	add    %edx,%eax
  17:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1a:	eb 04                	jmp    20 <fmtname+0x20>
  1c:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  23:	3b 45 08             	cmp    0x8(%ebp),%eax
  26:	72 0a                	jb     32 <fmtname+0x32>
  28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2b:	0f b6 00             	movzbl (%eax),%eax
  2e:	3c 2f                	cmp    $0x2f,%al
  30:	75 ea                	jne    1c <fmtname+0x1c>
    ;
  p++;
  32:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  39:	89 04 24             	mov    %eax,(%esp)
  3c:	e8 ae 03 00 00       	call   3ef <strlen>
  41:	83 f8 0d             	cmp    $0xd,%eax
  44:	76 05                	jbe    4b <fmtname+0x4b>
    return p;
  46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  49:	eb 5f                	jmp    aa <fmtname+0xaa>
  memmove(buf, p, strlen(p));
  4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  4e:	89 04 24             	mov    %eax,(%esp)
  51:	e8 99 03 00 00       	call   3ef <strlen>
  56:	89 44 24 08          	mov    %eax,0x8(%esp)
  5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  61:	c7 04 24 94 0f 00 00 	movl   $0xf94,(%esp)
  68:	e8 11 05 00 00       	call   57e <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  70:	89 04 24             	mov    %eax,(%esp)
  73:	e8 77 03 00 00       	call   3ef <strlen>
  78:	ba 0e 00 00 00       	mov    $0xe,%edx
  7d:	89 d3                	mov    %edx,%ebx
  7f:	29 c3                	sub    %eax,%ebx
  81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  84:	89 04 24             	mov    %eax,(%esp)
  87:	e8 63 03 00 00       	call   3ef <strlen>
  8c:	05 94 0f 00 00       	add    $0xf94,%eax
  91:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  95:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
  9c:	00 
  9d:	89 04 24             	mov    %eax,(%esp)
  a0:	e8 71 03 00 00       	call   416 <memset>
  return buf;
  a5:	b8 94 0f 00 00       	mov    $0xf94,%eax
}
  aa:	83 c4 24             	add    $0x24,%esp
  ad:	5b                   	pop    %ebx
  ae:	5d                   	pop    %ebp
  af:	c3                   	ret    

000000b0 <ls>:

void
ls(char *path)
{
  b0:	55                   	push   %ebp
  b1:	89 e5                	mov    %esp,%ebp
  b3:	57                   	push   %edi
  b4:	56                   	push   %esi
  b5:	53                   	push   %ebx
  b6:	81 ec 5c 02 00 00    	sub    $0x25c,%esp
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
  bc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  c3:	00 
  c4:	8b 45 08             	mov    0x8(%ebp),%eax
  c7:	89 04 24             	mov    %eax,(%esp)
  ca:	e8 51 06 00 00       	call   720 <open>
  cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  d2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  d6:	79 20                	jns    f8 <ls+0x48>
    printf(2, "ls: cannot open %s\n", path);
  d8:	8b 45 08             	mov    0x8(%ebp),%eax
  db:	89 44 24 08          	mov    %eax,0x8(%esp)
  df:	c7 44 24 04 3c 0c 00 	movl   $0xc3c,0x4(%esp)
  e6:	00 
  e7:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  ee:	e8 7d 07 00 00       	call   870 <printf>
    return;
  f3:	e9 01 02 00 00       	jmp    2f9 <ls+0x249>
  }

  if(fstat(fd, &st) < 0){
  f8:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
  fe:	89 44 24 04          	mov    %eax,0x4(%esp)
 102:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 105:	89 04 24             	mov    %eax,(%esp)
 108:	e8 2b 06 00 00       	call   738 <fstat>
 10d:	85 c0                	test   %eax,%eax
 10f:	79 2b                	jns    13c <ls+0x8c>
    printf(2, "ls: cannot stat %s\n", path);
 111:	8b 45 08             	mov    0x8(%ebp),%eax
 114:	89 44 24 08          	mov    %eax,0x8(%esp)
 118:	c7 44 24 04 50 0c 00 	movl   $0xc50,0x4(%esp)
 11f:	00 
 120:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
 127:	e8 44 07 00 00       	call   870 <printf>
    close(fd);
 12c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 12f:	89 04 24             	mov    %eax,(%esp)
 132:	e8 d1 05 00 00       	call   708 <close>
    return;
 137:	e9 bd 01 00 00       	jmp    2f9 <ls+0x249>
  }

  switch(st.type){
 13c:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 143:	98                   	cwtl   
 144:	83 f8 01             	cmp    $0x1,%eax
 147:	74 53                	je     19c <ls+0xec>
 149:	83 f8 02             	cmp    $0x2,%eax
 14c:	0f 85 9c 01 00 00    	jne    2ee <ls+0x23e>
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
 152:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 158:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 15e:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 165:	0f bf d8             	movswl %ax,%ebx
 168:	8b 45 08             	mov    0x8(%ebp),%eax
 16b:	89 04 24             	mov    %eax,(%esp)
 16e:	e8 8d fe ff ff       	call   0 <fmtname>
 173:	89 7c 24 14          	mov    %edi,0x14(%esp)
 177:	89 74 24 10          	mov    %esi,0x10(%esp)
 17b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
 17f:	89 44 24 08          	mov    %eax,0x8(%esp)
 183:	c7 44 24 04 64 0c 00 	movl   $0xc64,0x4(%esp)
 18a:	00 
 18b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 192:	e8 d9 06 00 00       	call   870 <printf>
    break;
 197:	e9 52 01 00 00       	jmp    2ee <ls+0x23e>

  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 19c:	8b 45 08             	mov    0x8(%ebp),%eax
 19f:	89 04 24             	mov    %eax,(%esp)
 1a2:	e8 48 02 00 00       	call   3ef <strlen>
 1a7:	83 c0 10             	add    $0x10,%eax
 1aa:	3d 00 02 00 00       	cmp    $0x200,%eax
 1af:	76 19                	jbe    1ca <ls+0x11a>
      printf(1, "ls: path too long\n");
 1b1:	c7 44 24 04 71 0c 00 	movl   $0xc71,0x4(%esp)
 1b8:	00 
 1b9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 1c0:	e8 ab 06 00 00       	call   870 <printf>
      break;
 1c5:	e9 24 01 00 00       	jmp    2ee <ls+0x23e>
    }
    strcpy(buf, path);
 1ca:	8b 45 08             	mov    0x8(%ebp),%eax
 1cd:	89 44 24 04          	mov    %eax,0x4(%esp)
 1d1:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1d7:	89 04 24             	mov    %eax,(%esp)
 1da:	e8 a1 01 00 00       	call   380 <strcpy>
    p = buf+strlen(buf);
 1df:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1e5:	89 04 24             	mov    %eax,(%esp)
 1e8:	e8 02 02 00 00       	call   3ef <strlen>
 1ed:	8d 95 e0 fd ff ff    	lea    -0x220(%ebp),%edx
 1f3:	01 d0                	add    %edx,%eax
 1f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    *p++ = '/';
 1f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
 1fb:	8d 50 01             	lea    0x1(%eax),%edx
 1fe:	89 55 e0             	mov    %edx,-0x20(%ebp)
 201:	c6 00 2f             	movb   $0x2f,(%eax)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 204:	e9 be 00 00 00       	jmp    2c7 <ls+0x217>
      if(de.inum == 0)
 209:	0f b7 85 d0 fd ff ff 	movzwl -0x230(%ebp),%eax
 210:	66 85 c0             	test   %ax,%ax
 213:	75 05                	jne    21a <ls+0x16a>
        continue;
 215:	e9 ad 00 00 00       	jmp    2c7 <ls+0x217>
      memmove(p, de.name, DIRSIZ);
 21a:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
 221:	00 
 222:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 228:	83 c0 02             	add    $0x2,%eax
 22b:	89 44 24 04          	mov    %eax,0x4(%esp)
 22f:	8b 45 e0             	mov    -0x20(%ebp),%eax
 232:	89 04 24             	mov    %eax,(%esp)
 235:	e8 44 03 00 00       	call   57e <memmove>
      p[DIRSIZ] = 0;
 23a:	8b 45 e0             	mov    -0x20(%ebp),%eax
 23d:	83 c0 0e             	add    $0xe,%eax
 240:	c6 00 00             	movb   $0x0,(%eax)
      if(stat(buf, &st) < 0){
 243:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
 249:	89 44 24 04          	mov    %eax,0x4(%esp)
 24d:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 253:	89 04 24             	mov    %eax,(%esp)
 256:	e8 88 02 00 00       	call   4e3 <stat>
 25b:	85 c0                	test   %eax,%eax
 25d:	79 20                	jns    27f <ls+0x1cf>
        printf(1, "ls: cannot stat %s\n", buf);
 25f:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 265:	89 44 24 08          	mov    %eax,0x8(%esp)
 269:	c7 44 24 04 50 0c 00 	movl   $0xc50,0x4(%esp)
 270:	00 
 271:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 278:	e8 f3 05 00 00       	call   870 <printf>
        continue;
 27d:	eb 48                	jmp    2c7 <ls+0x217>
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 27f:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 285:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 28b:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 292:	0f bf d8             	movswl %ax,%ebx
 295:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 29b:	89 04 24             	mov    %eax,(%esp)
 29e:	e8 5d fd ff ff       	call   0 <fmtname>
 2a3:	89 7c 24 14          	mov    %edi,0x14(%esp)
 2a7:	89 74 24 10          	mov    %esi,0x10(%esp)
 2ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
 2af:	89 44 24 08          	mov    %eax,0x8(%esp)
 2b3:	c7 44 24 04 64 0c 00 	movl   $0xc64,0x4(%esp)
 2ba:	00 
 2bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 2c2:	e8 a9 05 00 00       	call   870 <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 2c7:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 2ce:	00 
 2cf:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 2d5:	89 44 24 04          	mov    %eax,0x4(%esp)
 2d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2dc:	89 04 24             	mov    %eax,(%esp)
 2df:	e8 14 04 00 00       	call   6f8 <read>
 2e4:	83 f8 10             	cmp    $0x10,%eax
 2e7:	0f 84 1c ff ff ff    	je     209 <ls+0x159>
    }
    break;
 2ed:	90                   	nop
  }
  close(fd);
 2ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2f1:	89 04 24             	mov    %eax,(%esp)
 2f4:	e8 0f 04 00 00       	call   708 <close>
}
 2f9:	81 c4 5c 02 00 00    	add    $0x25c,%esp
 2ff:	5b                   	pop    %ebx
 300:	5e                   	pop    %esi
 301:	5f                   	pop    %edi
 302:	5d                   	pop    %ebp
 303:	c3                   	ret    

00000304 <main>:

int
main(int argc, char *argv[])
{
 304:	55                   	push   %ebp
 305:	89 e5                	mov    %esp,%ebp
 307:	83 e4 f0             	and    $0xfffffff0,%esp
 30a:	83 ec 20             	sub    $0x20,%esp
  int i;

  if(argc < 2){
 30d:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
 311:	7f 11                	jg     324 <main+0x20>
    ls(".");
 313:	c7 04 24 84 0c 00 00 	movl   $0xc84,(%esp)
 31a:	e8 91 fd ff ff       	call   b0 <ls>
    exit();
 31f:	e8 bc 03 00 00       	call   6e0 <exit>
  }
  for(i=1; i<argc; i++)
 324:	c7 44 24 1c 01 00 00 	movl   $0x1,0x1c(%esp)
 32b:	00 
 32c:	eb 1f                	jmp    34d <main+0x49>
    ls(argv[i]);
 32e:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 332:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 339:	8b 45 0c             	mov    0xc(%ebp),%eax
 33c:	01 d0                	add    %edx,%eax
 33e:	8b 00                	mov    (%eax),%eax
 340:	89 04 24             	mov    %eax,(%esp)
 343:	e8 68 fd ff ff       	call   b0 <ls>
  for(i=1; i<argc; i++)
 348:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
 34d:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 351:	3b 45 08             	cmp    0x8(%ebp),%eax
 354:	7c d8                	jl     32e <main+0x2a>
  exit();
 356:	e8 85 03 00 00       	call   6e0 <exit>

0000035b <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 35b:	55                   	push   %ebp
 35c:	89 e5                	mov    %esp,%ebp
 35e:	57                   	push   %edi
 35f:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 360:	8b 4d 08             	mov    0x8(%ebp),%ecx
 363:	8b 55 10             	mov    0x10(%ebp),%edx
 366:	8b 45 0c             	mov    0xc(%ebp),%eax
 369:	89 cb                	mov    %ecx,%ebx
 36b:	89 df                	mov    %ebx,%edi
 36d:	89 d1                	mov    %edx,%ecx
 36f:	fc                   	cld    
 370:	f3 aa                	rep stos %al,%es:(%edi)
 372:	89 ca                	mov    %ecx,%edx
 374:	89 fb                	mov    %edi,%ebx
 376:	89 5d 08             	mov    %ebx,0x8(%ebp)
 379:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 37c:	5b                   	pop    %ebx
 37d:	5f                   	pop    %edi
 37e:	5d                   	pop    %ebp
 37f:	c3                   	ret    

00000380 <strcpy>:
#include "x86.h"
#include "pstat.h"

char*
strcpy(char *s, const char *t)
{
 380:	55                   	push   %ebp
 381:	89 e5                	mov    %esp,%ebp
 383:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 386:	8b 45 08             	mov    0x8(%ebp),%eax
 389:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 38c:	90                   	nop
 38d:	8b 45 08             	mov    0x8(%ebp),%eax
 390:	8d 50 01             	lea    0x1(%eax),%edx
 393:	89 55 08             	mov    %edx,0x8(%ebp)
 396:	8b 55 0c             	mov    0xc(%ebp),%edx
 399:	8d 4a 01             	lea    0x1(%edx),%ecx
 39c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
 39f:	0f b6 12             	movzbl (%edx),%edx
 3a2:	88 10                	mov    %dl,(%eax)
 3a4:	0f b6 00             	movzbl (%eax),%eax
 3a7:	84 c0                	test   %al,%al
 3a9:	75 e2                	jne    38d <strcpy+0xd>
    ;
  return os;
 3ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3ae:	c9                   	leave  
 3af:	c3                   	ret    

000003b0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 3b3:	eb 08                	jmp    3bd <strcmp+0xd>
    p++, q++;
 3b5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3b9:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 3bd:	8b 45 08             	mov    0x8(%ebp),%eax
 3c0:	0f b6 00             	movzbl (%eax),%eax
 3c3:	84 c0                	test   %al,%al
 3c5:	74 10                	je     3d7 <strcmp+0x27>
 3c7:	8b 45 08             	mov    0x8(%ebp),%eax
 3ca:	0f b6 10             	movzbl (%eax),%edx
 3cd:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d0:	0f b6 00             	movzbl (%eax),%eax
 3d3:	38 c2                	cmp    %al,%dl
 3d5:	74 de                	je     3b5 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 3d7:	8b 45 08             	mov    0x8(%ebp),%eax
 3da:	0f b6 00             	movzbl (%eax),%eax
 3dd:	0f b6 d0             	movzbl %al,%edx
 3e0:	8b 45 0c             	mov    0xc(%ebp),%eax
 3e3:	0f b6 00             	movzbl (%eax),%eax
 3e6:	0f b6 c0             	movzbl %al,%eax
 3e9:	29 c2                	sub    %eax,%edx
 3eb:	89 d0                	mov    %edx,%eax
}
 3ed:	5d                   	pop    %ebp
 3ee:	c3                   	ret    

000003ef <strlen>:

uint
strlen(const char *s)
{
 3ef:	55                   	push   %ebp
 3f0:	89 e5                	mov    %esp,%ebp
 3f2:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3f5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3fc:	eb 04                	jmp    402 <strlen+0x13>
 3fe:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 402:	8b 55 fc             	mov    -0x4(%ebp),%edx
 405:	8b 45 08             	mov    0x8(%ebp),%eax
 408:	01 d0                	add    %edx,%eax
 40a:	0f b6 00             	movzbl (%eax),%eax
 40d:	84 c0                	test   %al,%al
 40f:	75 ed                	jne    3fe <strlen+0xf>
    ;
  return n;
 411:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 414:	c9                   	leave  
 415:	c3                   	ret    

00000416 <memset>:

void*
memset(void *dst, int c, uint n)
{
 416:	55                   	push   %ebp
 417:	89 e5                	mov    %esp,%ebp
 419:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 41c:	8b 45 10             	mov    0x10(%ebp),%eax
 41f:	89 44 24 08          	mov    %eax,0x8(%esp)
 423:	8b 45 0c             	mov    0xc(%ebp),%eax
 426:	89 44 24 04          	mov    %eax,0x4(%esp)
 42a:	8b 45 08             	mov    0x8(%ebp),%eax
 42d:	89 04 24             	mov    %eax,(%esp)
 430:	e8 26 ff ff ff       	call   35b <stosb>
  return dst;
 435:	8b 45 08             	mov    0x8(%ebp),%eax
}
 438:	c9                   	leave  
 439:	c3                   	ret    

0000043a <strchr>:

char*
strchr(const char *s, char c)
{
 43a:	55                   	push   %ebp
 43b:	89 e5                	mov    %esp,%ebp
 43d:	83 ec 04             	sub    $0x4,%esp
 440:	8b 45 0c             	mov    0xc(%ebp),%eax
 443:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 446:	eb 14                	jmp    45c <strchr+0x22>
    if(*s == c)
 448:	8b 45 08             	mov    0x8(%ebp),%eax
 44b:	0f b6 00             	movzbl (%eax),%eax
 44e:	3a 45 fc             	cmp    -0x4(%ebp),%al
 451:	75 05                	jne    458 <strchr+0x1e>
      return (char*)s;
 453:	8b 45 08             	mov    0x8(%ebp),%eax
 456:	eb 13                	jmp    46b <strchr+0x31>
  for(; *s; s++)
 458:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 45c:	8b 45 08             	mov    0x8(%ebp),%eax
 45f:	0f b6 00             	movzbl (%eax),%eax
 462:	84 c0                	test   %al,%al
 464:	75 e2                	jne    448 <strchr+0xe>
  return 0;
 466:	b8 00 00 00 00       	mov    $0x0,%eax
}
 46b:	c9                   	leave  
 46c:	c3                   	ret    

0000046d <gets>:

char*
gets(char *buf, int max)
{
 46d:	55                   	push   %ebp
 46e:	89 e5                	mov    %esp,%ebp
 470:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 473:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 47a:	eb 4c                	jmp    4c8 <gets+0x5b>
    cc = read(0, &c, 1);
 47c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 483:	00 
 484:	8d 45 ef             	lea    -0x11(%ebp),%eax
 487:	89 44 24 04          	mov    %eax,0x4(%esp)
 48b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 492:	e8 61 02 00 00       	call   6f8 <read>
 497:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 49a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 49e:	7f 02                	jg     4a2 <gets+0x35>
      break;
 4a0:	eb 31                	jmp    4d3 <gets+0x66>
    buf[i++] = c;
 4a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4a5:	8d 50 01             	lea    0x1(%eax),%edx
 4a8:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4ab:	89 c2                	mov    %eax,%edx
 4ad:	8b 45 08             	mov    0x8(%ebp),%eax
 4b0:	01 c2                	add    %eax,%edx
 4b2:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4b6:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 4b8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4bc:	3c 0a                	cmp    $0xa,%al
 4be:	74 13                	je     4d3 <gets+0x66>
 4c0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 4c4:	3c 0d                	cmp    $0xd,%al
 4c6:	74 0b                	je     4d3 <gets+0x66>
  for(i=0; i+1 < max; ){
 4c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4cb:	83 c0 01             	add    $0x1,%eax
 4ce:	3b 45 0c             	cmp    0xc(%ebp),%eax
 4d1:	7c a9                	jl     47c <gets+0xf>
      break;
  }
  buf[i] = '\0';
 4d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4d6:	8b 45 08             	mov    0x8(%ebp),%eax
 4d9:	01 d0                	add    %edx,%eax
 4db:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4de:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4e1:	c9                   	leave  
 4e2:	c3                   	ret    

000004e3 <stat>:

int
stat(const char *n, struct stat *st)
{
 4e3:	55                   	push   %ebp
 4e4:	89 e5                	mov    %esp,%ebp
 4e6:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4e9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 4f0:	00 
 4f1:	8b 45 08             	mov    0x8(%ebp),%eax
 4f4:	89 04 24             	mov    %eax,(%esp)
 4f7:	e8 24 02 00 00       	call   720 <open>
 4fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 503:	79 07                	jns    50c <stat+0x29>
    return -1;
 505:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 50a:	eb 23                	jmp    52f <stat+0x4c>
  r = fstat(fd, st);
 50c:	8b 45 0c             	mov    0xc(%ebp),%eax
 50f:	89 44 24 04          	mov    %eax,0x4(%esp)
 513:	8b 45 f4             	mov    -0xc(%ebp),%eax
 516:	89 04 24             	mov    %eax,(%esp)
 519:	e8 1a 02 00 00       	call   738 <fstat>
 51e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 521:	8b 45 f4             	mov    -0xc(%ebp),%eax
 524:	89 04 24             	mov    %eax,(%esp)
 527:	e8 dc 01 00 00       	call   708 <close>
  return r;
 52c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 52f:	c9                   	leave  
 530:	c3                   	ret    

00000531 <atoi>:

int
atoi(const char *s)
{
 531:	55                   	push   %ebp
 532:	89 e5                	mov    %esp,%ebp
 534:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 537:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 53e:	eb 25                	jmp    565 <atoi+0x34>
    n = n*10 + *s++ - '0';
 540:	8b 55 fc             	mov    -0x4(%ebp),%edx
 543:	89 d0                	mov    %edx,%eax
 545:	c1 e0 02             	shl    $0x2,%eax
 548:	01 d0                	add    %edx,%eax
 54a:	01 c0                	add    %eax,%eax
 54c:	89 c1                	mov    %eax,%ecx
 54e:	8b 45 08             	mov    0x8(%ebp),%eax
 551:	8d 50 01             	lea    0x1(%eax),%edx
 554:	89 55 08             	mov    %edx,0x8(%ebp)
 557:	0f b6 00             	movzbl (%eax),%eax
 55a:	0f be c0             	movsbl %al,%eax
 55d:	01 c8                	add    %ecx,%eax
 55f:	83 e8 30             	sub    $0x30,%eax
 562:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 565:	8b 45 08             	mov    0x8(%ebp),%eax
 568:	0f b6 00             	movzbl (%eax),%eax
 56b:	3c 2f                	cmp    $0x2f,%al
 56d:	7e 0a                	jle    579 <atoi+0x48>
 56f:	8b 45 08             	mov    0x8(%ebp),%eax
 572:	0f b6 00             	movzbl (%eax),%eax
 575:	3c 39                	cmp    $0x39,%al
 577:	7e c7                	jle    540 <atoi+0xf>
  return n;
 579:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 57c:	c9                   	leave  
 57d:	c3                   	ret    

0000057e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 57e:	55                   	push   %ebp
 57f:	89 e5                	mov    %esp,%ebp
 581:	83 ec 10             	sub    $0x10,%esp
  char *dst;
  const char *src;

  dst = vdst;
 584:	8b 45 08             	mov    0x8(%ebp),%eax
 587:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 58a:	8b 45 0c             	mov    0xc(%ebp),%eax
 58d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 590:	eb 17                	jmp    5a9 <memmove+0x2b>
    *dst++ = *src++;
 592:	8b 45 fc             	mov    -0x4(%ebp),%eax
 595:	8d 50 01             	lea    0x1(%eax),%edx
 598:	89 55 fc             	mov    %edx,-0x4(%ebp)
 59b:	8b 55 f8             	mov    -0x8(%ebp),%edx
 59e:	8d 4a 01             	lea    0x1(%edx),%ecx
 5a1:	89 4d f8             	mov    %ecx,-0x8(%ebp)
 5a4:	0f b6 12             	movzbl (%edx),%edx
 5a7:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 5a9:	8b 45 10             	mov    0x10(%ebp),%eax
 5ac:	8d 50 ff             	lea    -0x1(%eax),%edx
 5af:	89 55 10             	mov    %edx,0x10(%ebp)
 5b2:	85 c0                	test   %eax,%eax
 5b4:	7f dc                	jg     592 <memmove+0x14>
  return vdst;
 5b6:	8b 45 08             	mov    0x8(%ebp),%eax
}
 5b9:	c9                   	leave  
 5ba:	c3                   	ret    

000005bb <ps>:

void 
ps()
{
 5bb:	55                   	push   %ebp
 5bc:	89 e5                	mov    %esp,%ebp
 5be:	57                   	push   %edi
 5bf:	56                   	push   %esi
 5c0:	53                   	push   %ebx
 5c1:	81 ec 3c 09 00 00    	sub    $0x93c,%esp
  pstatTable pTable;
  getpinfo(&pTable);
 5c7:	8d 85 e4 f6 ff ff    	lea    -0x91c(%ebp),%eax
 5cd:	89 04 24             	mov    %eax,(%esp)
 5d0:	e8 ab 01 00 00       	call   780 <getpinfo>
  printf(1, "PID\tTKTS\tTCKS\tSTAT\tNAME\n");
 5d5:	c7 44 24 04 86 0c 00 	movl   $0xc86,0x4(%esp)
 5dc:	00 
 5dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 5e4:	e8 87 02 00 00       	call   870 <printf>
  int i;
  for (i = 0; i < NPROC; i++)
 5e9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 5f0:	e9 ce 00 00 00       	jmp    6c3 <ps+0x108>
  {
    if(pTable[i].inuse)
 5f5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 5f8:	89 d0                	mov    %edx,%eax
 5fa:	c1 e0 03             	shl    $0x3,%eax
 5fd:	01 d0                	add    %edx,%eax
 5ff:	c1 e0 02             	shl    $0x2,%eax
 602:	8d 5d e8             	lea    -0x18(%ebp),%ebx
 605:	01 d8                	add    %ebx,%eax
 607:	2d 04 09 00 00       	sub    $0x904,%eax
 60c:	8b 00                	mov    (%eax),%eax
 60e:	85 c0                	test   %eax,%eax
 610:	0f 84 a9 00 00 00    	je     6bf <ps+0x104>
      printf(1, "%d\t%d\t%d\t%c\t%s\n", pTable[i].pid, pTable[i].tickets, pTable[i].ticks, pTable[i].state, pTable[i].name);
 616:	8d 8d e4 f6 ff ff    	lea    -0x91c(%ebp),%ecx
 61c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 61f:	89 d0                	mov    %edx,%eax
 621:	c1 e0 03             	shl    $0x3,%eax
 624:	01 d0                	add    %edx,%eax
 626:	c1 e0 02             	shl    $0x2,%eax
 629:	83 c0 10             	add    $0x10,%eax
 62c:	8d 3c 01             	lea    (%ecx,%eax,1),%edi
 62f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 632:	89 d0                	mov    %edx,%eax
 634:	c1 e0 03             	shl    $0x3,%eax
 637:	01 d0                	add    %edx,%eax
 639:	c1 e0 02             	shl    $0x2,%eax
 63c:	8d 75 e8             	lea    -0x18(%ebp),%esi
 63f:	01 f0                	add    %esi,%eax
 641:	2d e4 08 00 00       	sub    $0x8e4,%eax
 646:	0f b6 00             	movzbl (%eax),%eax
 649:	0f be f0             	movsbl %al,%esi
 64c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 64f:	89 d0                	mov    %edx,%eax
 651:	c1 e0 03             	shl    $0x3,%eax
 654:	01 d0                	add    %edx,%eax
 656:	c1 e0 02             	shl    $0x2,%eax
 659:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 65c:	01 c8                	add    %ecx,%eax
 65e:	2d f8 08 00 00       	sub    $0x8f8,%eax
 663:	8b 18                	mov    (%eax),%ebx
 665:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 668:	89 d0                	mov    %edx,%eax
 66a:	c1 e0 03             	shl    $0x3,%eax
 66d:	01 d0                	add    %edx,%eax
 66f:	c1 e0 02             	shl    $0x2,%eax
 672:	8d 4d e8             	lea    -0x18(%ebp),%ecx
 675:	01 c8                	add    %ecx,%eax
 677:	2d 00 09 00 00       	sub    $0x900,%eax
 67c:	8b 08                	mov    (%eax),%ecx
 67e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 681:	89 d0                	mov    %edx,%eax
 683:	c1 e0 03             	shl    $0x3,%eax
 686:	01 d0                	add    %edx,%eax
 688:	c1 e0 02             	shl    $0x2,%eax
 68b:	8d 55 e8             	lea    -0x18(%ebp),%edx
 68e:	01 d0                	add    %edx,%eax
 690:	2d fc 08 00 00       	sub    $0x8fc,%eax
 695:	8b 00                	mov    (%eax),%eax
 697:	89 7c 24 18          	mov    %edi,0x18(%esp)
 69b:	89 74 24 14          	mov    %esi,0x14(%esp)
 69f:	89 5c 24 10          	mov    %ebx,0x10(%esp)
 6a3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
 6a7:	89 44 24 08          	mov    %eax,0x8(%esp)
 6ab:	c7 44 24 04 9f 0c 00 	movl   $0xc9f,0x4(%esp)
 6b2:	00 
 6b3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 6ba:	e8 b1 01 00 00       	call   870 <printf>
  for (i = 0; i < NPROC; i++)
 6bf:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
 6c3:	83 7d e4 3f          	cmpl   $0x3f,-0x1c(%ebp)
 6c7:	0f 8e 28 ff ff ff    	jle    5f5 <ps+0x3a>
  }
}
 6cd:	81 c4 3c 09 00 00    	add    $0x93c,%esp
 6d3:	5b                   	pop    %ebx
 6d4:	5e                   	pop    %esi
 6d5:	5f                   	pop    %edi
 6d6:	5d                   	pop    %ebp
 6d7:	c3                   	ret    

000006d8 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 6d8:	b8 01 00 00 00       	mov    $0x1,%eax
 6dd:	cd 40                	int    $0x40
 6df:	c3                   	ret    

000006e0 <exit>:
SYSCALL(exit)
 6e0:	b8 02 00 00 00       	mov    $0x2,%eax
 6e5:	cd 40                	int    $0x40
 6e7:	c3                   	ret    

000006e8 <wait>:
SYSCALL(wait)
 6e8:	b8 03 00 00 00       	mov    $0x3,%eax
 6ed:	cd 40                	int    $0x40
 6ef:	c3                   	ret    

000006f0 <pipe>:
SYSCALL(pipe)
 6f0:	b8 04 00 00 00       	mov    $0x4,%eax
 6f5:	cd 40                	int    $0x40
 6f7:	c3                   	ret    

000006f8 <read>:
SYSCALL(read)
 6f8:	b8 05 00 00 00       	mov    $0x5,%eax
 6fd:	cd 40                	int    $0x40
 6ff:	c3                   	ret    

00000700 <write>:
SYSCALL(write)
 700:	b8 10 00 00 00       	mov    $0x10,%eax
 705:	cd 40                	int    $0x40
 707:	c3                   	ret    

00000708 <close>:
SYSCALL(close)
 708:	b8 15 00 00 00       	mov    $0x15,%eax
 70d:	cd 40                	int    $0x40
 70f:	c3                   	ret    

00000710 <kill>:
SYSCALL(kill)
 710:	b8 06 00 00 00       	mov    $0x6,%eax
 715:	cd 40                	int    $0x40
 717:	c3                   	ret    

00000718 <exec>:
SYSCALL(exec)
 718:	b8 07 00 00 00       	mov    $0x7,%eax
 71d:	cd 40                	int    $0x40
 71f:	c3                   	ret    

00000720 <open>:
SYSCALL(open)
 720:	b8 0f 00 00 00       	mov    $0xf,%eax
 725:	cd 40                	int    $0x40
 727:	c3                   	ret    

00000728 <mknod>:
SYSCALL(mknod)
 728:	b8 11 00 00 00       	mov    $0x11,%eax
 72d:	cd 40                	int    $0x40
 72f:	c3                   	ret    

00000730 <unlink>:
SYSCALL(unlink)
 730:	b8 12 00 00 00       	mov    $0x12,%eax
 735:	cd 40                	int    $0x40
 737:	c3                   	ret    

00000738 <fstat>:
SYSCALL(fstat)
 738:	b8 08 00 00 00       	mov    $0x8,%eax
 73d:	cd 40                	int    $0x40
 73f:	c3                   	ret    

00000740 <link>:
SYSCALL(link)
 740:	b8 13 00 00 00       	mov    $0x13,%eax
 745:	cd 40                	int    $0x40
 747:	c3                   	ret    

00000748 <mkdir>:
SYSCALL(mkdir)
 748:	b8 14 00 00 00       	mov    $0x14,%eax
 74d:	cd 40                	int    $0x40
 74f:	c3                   	ret    

00000750 <chdir>:
SYSCALL(chdir)
 750:	b8 09 00 00 00       	mov    $0x9,%eax
 755:	cd 40                	int    $0x40
 757:	c3                   	ret    

00000758 <dup>:
SYSCALL(dup)
 758:	b8 0a 00 00 00       	mov    $0xa,%eax
 75d:	cd 40                	int    $0x40
 75f:	c3                   	ret    

00000760 <getpid>:
SYSCALL(getpid)
 760:	b8 0b 00 00 00       	mov    $0xb,%eax
 765:	cd 40                	int    $0x40
 767:	c3                   	ret    

00000768 <sbrk>:
SYSCALL(sbrk)
 768:	b8 0c 00 00 00       	mov    $0xc,%eax
 76d:	cd 40                	int    $0x40
 76f:	c3                   	ret    

00000770 <sleep>:
SYSCALL(sleep)
 770:	b8 0d 00 00 00       	mov    $0xd,%eax
 775:	cd 40                	int    $0x40
 777:	c3                   	ret    

00000778 <uptime>:
SYSCALL(uptime)
 778:	b8 0e 00 00 00       	mov    $0xe,%eax
 77d:	cd 40                	int    $0x40
 77f:	c3                   	ret    

00000780 <getpinfo>:
SYSCALL(getpinfo)
 780:	b8 16 00 00 00       	mov    $0x16,%eax
 785:	cd 40                	int    $0x40
 787:	c3                   	ret    

00000788 <settickets>:
SYSCALL(settickets)
 788:	b8 18 00 00 00       	mov    $0x18,%eax
 78d:	cd 40                	int    $0x40
 78f:	c3                   	ret    

00000790 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 790:	55                   	push   %ebp
 791:	89 e5                	mov    %esp,%ebp
 793:	83 ec 18             	sub    $0x18,%esp
 796:	8b 45 0c             	mov    0xc(%ebp),%eax
 799:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 79c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 7a3:	00 
 7a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
 7a7:	89 44 24 04          	mov    %eax,0x4(%esp)
 7ab:	8b 45 08             	mov    0x8(%ebp),%eax
 7ae:	89 04 24             	mov    %eax,(%esp)
 7b1:	e8 4a ff ff ff       	call   700 <write>
}
 7b6:	c9                   	leave  
 7b7:	c3                   	ret    

000007b8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 7b8:	55                   	push   %ebp
 7b9:	89 e5                	mov    %esp,%ebp
 7bb:	56                   	push   %esi
 7bc:	53                   	push   %ebx
 7bd:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 7c0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 7c7:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 7cb:	74 17                	je     7e4 <printint+0x2c>
 7cd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 7d1:	79 11                	jns    7e4 <printint+0x2c>
    neg = 1;
 7d3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 7da:	8b 45 0c             	mov    0xc(%ebp),%eax
 7dd:	f7 d8                	neg    %eax
 7df:	89 45 ec             	mov    %eax,-0x14(%ebp)
 7e2:	eb 06                	jmp    7ea <printint+0x32>
  } else {
    x = xx;
 7e4:	8b 45 0c             	mov    0xc(%ebp),%eax
 7e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 7ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 7f1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
 7f4:	8d 41 01             	lea    0x1(%ecx),%eax
 7f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7fa:	8b 5d 10             	mov    0x10(%ebp),%ebx
 7fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
 800:	ba 00 00 00 00       	mov    $0x0,%edx
 805:	f7 f3                	div    %ebx
 807:	89 d0                	mov    %edx,%eax
 809:	0f b6 80 80 0f 00 00 	movzbl 0xf80(%eax),%eax
 810:	88 44 0d dc          	mov    %al,-0x24(%ebp,%ecx,1)
  }while((x /= base) != 0);
 814:	8b 75 10             	mov    0x10(%ebp),%esi
 817:	8b 45 ec             	mov    -0x14(%ebp),%eax
 81a:	ba 00 00 00 00       	mov    $0x0,%edx
 81f:	f7 f6                	div    %esi
 821:	89 45 ec             	mov    %eax,-0x14(%ebp)
 824:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 828:	75 c7                	jne    7f1 <printint+0x39>
  if(neg)
 82a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 82e:	74 10                	je     840 <printint+0x88>
    buf[i++] = '-';
 830:	8b 45 f4             	mov    -0xc(%ebp),%eax
 833:	8d 50 01             	lea    0x1(%eax),%edx
 836:	89 55 f4             	mov    %edx,-0xc(%ebp)
 839:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 83e:	eb 1f                	jmp    85f <printint+0xa7>
 840:	eb 1d                	jmp    85f <printint+0xa7>
    putc(fd, buf[i]);
 842:	8d 55 dc             	lea    -0x24(%ebp),%edx
 845:	8b 45 f4             	mov    -0xc(%ebp),%eax
 848:	01 d0                	add    %edx,%eax
 84a:	0f b6 00             	movzbl (%eax),%eax
 84d:	0f be c0             	movsbl %al,%eax
 850:	89 44 24 04          	mov    %eax,0x4(%esp)
 854:	8b 45 08             	mov    0x8(%ebp),%eax
 857:	89 04 24             	mov    %eax,(%esp)
 85a:	e8 31 ff ff ff       	call   790 <putc>
  while(--i >= 0)
 85f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 863:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 867:	79 d9                	jns    842 <printint+0x8a>
}
 869:	83 c4 30             	add    $0x30,%esp
 86c:	5b                   	pop    %ebx
 86d:	5e                   	pop    %esi
 86e:	5d                   	pop    %ebp
 86f:	c3                   	ret    

00000870 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 870:	55                   	push   %ebp
 871:	89 e5                	mov    %esp,%ebp
 873:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 876:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 87d:	8d 45 0c             	lea    0xc(%ebp),%eax
 880:	83 c0 04             	add    $0x4,%eax
 883:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 886:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 88d:	e9 7c 01 00 00       	jmp    a0e <printf+0x19e>
    c = fmt[i] & 0xff;
 892:	8b 55 0c             	mov    0xc(%ebp),%edx
 895:	8b 45 f0             	mov    -0x10(%ebp),%eax
 898:	01 d0                	add    %edx,%eax
 89a:	0f b6 00             	movzbl (%eax),%eax
 89d:	0f be c0             	movsbl %al,%eax
 8a0:	25 ff 00 00 00       	and    $0xff,%eax
 8a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 8a8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 8ac:	75 2c                	jne    8da <printf+0x6a>
      if(c == '%'){
 8ae:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 8b2:	75 0c                	jne    8c0 <printf+0x50>
        state = '%';
 8b4:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 8bb:	e9 4a 01 00 00       	jmp    a0a <printf+0x19a>
      } else {
        putc(fd, c);
 8c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 8c3:	0f be c0             	movsbl %al,%eax
 8c6:	89 44 24 04          	mov    %eax,0x4(%esp)
 8ca:	8b 45 08             	mov    0x8(%ebp),%eax
 8cd:	89 04 24             	mov    %eax,(%esp)
 8d0:	e8 bb fe ff ff       	call   790 <putc>
 8d5:	e9 30 01 00 00       	jmp    a0a <printf+0x19a>
      }
    } else if(state == '%'){
 8da:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 8de:	0f 85 26 01 00 00    	jne    a0a <printf+0x19a>
      if(c == 'd'){
 8e4:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 8e8:	75 2d                	jne    917 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 8ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
 8ed:	8b 00                	mov    (%eax),%eax
 8ef:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 8f6:	00 
 8f7:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 8fe:	00 
 8ff:	89 44 24 04          	mov    %eax,0x4(%esp)
 903:	8b 45 08             	mov    0x8(%ebp),%eax
 906:	89 04 24             	mov    %eax,(%esp)
 909:	e8 aa fe ff ff       	call   7b8 <printint>
        ap++;
 90e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 912:	e9 ec 00 00 00       	jmp    a03 <printf+0x193>
      } else if(c == 'x' || c == 'p'){
 917:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 91b:	74 06                	je     923 <printf+0xb3>
 91d:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 921:	75 2d                	jne    950 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 923:	8b 45 e8             	mov    -0x18(%ebp),%eax
 926:	8b 00                	mov    (%eax),%eax
 928:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 92f:	00 
 930:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 937:	00 
 938:	89 44 24 04          	mov    %eax,0x4(%esp)
 93c:	8b 45 08             	mov    0x8(%ebp),%eax
 93f:	89 04 24             	mov    %eax,(%esp)
 942:	e8 71 fe ff ff       	call   7b8 <printint>
        ap++;
 947:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 94b:	e9 b3 00 00 00       	jmp    a03 <printf+0x193>
      } else if(c == 's'){
 950:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 954:	75 45                	jne    99b <printf+0x12b>
        s = (char*)*ap;
 956:	8b 45 e8             	mov    -0x18(%ebp),%eax
 959:	8b 00                	mov    (%eax),%eax
 95b:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 95e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 962:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 966:	75 09                	jne    971 <printf+0x101>
          s = "(null)";
 968:	c7 45 f4 af 0c 00 00 	movl   $0xcaf,-0xc(%ebp)
        while(*s != 0){
 96f:	eb 1e                	jmp    98f <printf+0x11f>
 971:	eb 1c                	jmp    98f <printf+0x11f>
          putc(fd, *s);
 973:	8b 45 f4             	mov    -0xc(%ebp),%eax
 976:	0f b6 00             	movzbl (%eax),%eax
 979:	0f be c0             	movsbl %al,%eax
 97c:	89 44 24 04          	mov    %eax,0x4(%esp)
 980:	8b 45 08             	mov    0x8(%ebp),%eax
 983:	89 04 24             	mov    %eax,(%esp)
 986:	e8 05 fe ff ff       	call   790 <putc>
          s++;
 98b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 98f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 992:	0f b6 00             	movzbl (%eax),%eax
 995:	84 c0                	test   %al,%al
 997:	75 da                	jne    973 <printf+0x103>
 999:	eb 68                	jmp    a03 <printf+0x193>
        }
      } else if(c == 'c'){
 99b:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 99f:	75 1d                	jne    9be <printf+0x14e>
        putc(fd, *ap);
 9a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 9a4:	8b 00                	mov    (%eax),%eax
 9a6:	0f be c0             	movsbl %al,%eax
 9a9:	89 44 24 04          	mov    %eax,0x4(%esp)
 9ad:	8b 45 08             	mov    0x8(%ebp),%eax
 9b0:	89 04 24             	mov    %eax,(%esp)
 9b3:	e8 d8 fd ff ff       	call   790 <putc>
        ap++;
 9b8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 9bc:	eb 45                	jmp    a03 <printf+0x193>
      } else if(c == '%'){
 9be:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 9c2:	75 17                	jne    9db <printf+0x16b>
        putc(fd, c);
 9c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 9c7:	0f be c0             	movsbl %al,%eax
 9ca:	89 44 24 04          	mov    %eax,0x4(%esp)
 9ce:	8b 45 08             	mov    0x8(%ebp),%eax
 9d1:	89 04 24             	mov    %eax,(%esp)
 9d4:	e8 b7 fd ff ff       	call   790 <putc>
 9d9:	eb 28                	jmp    a03 <printf+0x193>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 9db:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 9e2:	00 
 9e3:	8b 45 08             	mov    0x8(%ebp),%eax
 9e6:	89 04 24             	mov    %eax,(%esp)
 9e9:	e8 a2 fd ff ff       	call   790 <putc>
        putc(fd, c);
 9ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 9f1:	0f be c0             	movsbl %al,%eax
 9f4:	89 44 24 04          	mov    %eax,0x4(%esp)
 9f8:	8b 45 08             	mov    0x8(%ebp),%eax
 9fb:	89 04 24             	mov    %eax,(%esp)
 9fe:	e8 8d fd ff ff       	call   790 <putc>
      }
      state = 0;
 a03:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 a0a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 a0e:	8b 55 0c             	mov    0xc(%ebp),%edx
 a11:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a14:	01 d0                	add    %edx,%eax
 a16:	0f b6 00             	movzbl (%eax),%eax
 a19:	84 c0                	test   %al,%al
 a1b:	0f 85 71 fe ff ff    	jne    892 <printf+0x22>
    }
  }
}
 a21:	c9                   	leave  
 a22:	c3                   	ret    

00000a23 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a23:	55                   	push   %ebp
 a24:	89 e5                	mov    %esp,%ebp
 a26:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 a29:	8b 45 08             	mov    0x8(%ebp),%eax
 a2c:	83 e8 08             	sub    $0x8,%eax
 a2f:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a32:	a1 ac 0f 00 00       	mov    0xfac,%eax
 a37:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a3a:	eb 24                	jmp    a60 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a3f:	8b 00                	mov    (%eax),%eax
 a41:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a44:	77 12                	ja     a58 <free+0x35>
 a46:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a49:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a4c:	77 24                	ja     a72 <free+0x4f>
 a4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a51:	8b 00                	mov    (%eax),%eax
 a53:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a56:	77 1a                	ja     a72 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a58:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a5b:	8b 00                	mov    (%eax),%eax
 a5d:	89 45 fc             	mov    %eax,-0x4(%ebp)
 a60:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a63:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 a66:	76 d4                	jbe    a3c <free+0x19>
 a68:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a6b:	8b 00                	mov    (%eax),%eax
 a6d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 a70:	76 ca                	jbe    a3c <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 a72:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a75:	8b 40 04             	mov    0x4(%eax),%eax
 a78:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 a7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a82:	01 c2                	add    %eax,%edx
 a84:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a87:	8b 00                	mov    (%eax),%eax
 a89:	39 c2                	cmp    %eax,%edx
 a8b:	75 24                	jne    ab1 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 a8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 a90:	8b 50 04             	mov    0x4(%eax),%edx
 a93:	8b 45 fc             	mov    -0x4(%ebp),%eax
 a96:	8b 00                	mov    (%eax),%eax
 a98:	8b 40 04             	mov    0x4(%eax),%eax
 a9b:	01 c2                	add    %eax,%edx
 a9d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 aa0:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 aa3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aa6:	8b 00                	mov    (%eax),%eax
 aa8:	8b 10                	mov    (%eax),%edx
 aaa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 aad:	89 10                	mov    %edx,(%eax)
 aaf:	eb 0a                	jmp    abb <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 ab1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ab4:	8b 10                	mov    (%eax),%edx
 ab6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ab9:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 abb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 abe:	8b 40 04             	mov    0x4(%eax),%eax
 ac1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 ac8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 acb:	01 d0                	add    %edx,%eax
 acd:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 ad0:	75 20                	jne    af2 <free+0xcf>
    p->s.size += bp->s.size;
 ad2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ad5:	8b 50 04             	mov    0x4(%eax),%edx
 ad8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 adb:	8b 40 04             	mov    0x4(%eax),%eax
 ade:	01 c2                	add    %eax,%edx
 ae0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ae3:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 ae6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 ae9:	8b 10                	mov    (%eax),%edx
 aeb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 aee:	89 10                	mov    %edx,(%eax)
 af0:	eb 08                	jmp    afa <free+0xd7>
  } else
    p->s.ptr = bp;
 af2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 af5:	8b 55 f8             	mov    -0x8(%ebp),%edx
 af8:	89 10                	mov    %edx,(%eax)
  freep = p;
 afa:	8b 45 fc             	mov    -0x4(%ebp),%eax
 afd:	a3 ac 0f 00 00       	mov    %eax,0xfac
}
 b02:	c9                   	leave  
 b03:	c3                   	ret    

00000b04 <morecore>:

static Header*
morecore(uint nu)
{
 b04:	55                   	push   %ebp
 b05:	89 e5                	mov    %esp,%ebp
 b07:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 b0a:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 b11:	77 07                	ja     b1a <morecore+0x16>
    nu = 4096;
 b13:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 b1a:	8b 45 08             	mov    0x8(%ebp),%eax
 b1d:	c1 e0 03             	shl    $0x3,%eax
 b20:	89 04 24             	mov    %eax,(%esp)
 b23:	e8 40 fc ff ff       	call   768 <sbrk>
 b28:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 b2b:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 b2f:	75 07                	jne    b38 <morecore+0x34>
    return 0;
 b31:	b8 00 00 00 00       	mov    $0x0,%eax
 b36:	eb 22                	jmp    b5a <morecore+0x56>
  hp = (Header*)p;
 b38:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b3b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 b3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b41:	8b 55 08             	mov    0x8(%ebp),%edx
 b44:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 b47:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b4a:	83 c0 08             	add    $0x8,%eax
 b4d:	89 04 24             	mov    %eax,(%esp)
 b50:	e8 ce fe ff ff       	call   a23 <free>
  return freep;
 b55:	a1 ac 0f 00 00       	mov    0xfac,%eax
}
 b5a:	c9                   	leave  
 b5b:	c3                   	ret    

00000b5c <malloc>:

void*
malloc(uint nbytes)
{
 b5c:	55                   	push   %ebp
 b5d:	89 e5                	mov    %esp,%ebp
 b5f:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b62:	8b 45 08             	mov    0x8(%ebp),%eax
 b65:	83 c0 07             	add    $0x7,%eax
 b68:	c1 e8 03             	shr    $0x3,%eax
 b6b:	83 c0 01             	add    $0x1,%eax
 b6e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 b71:	a1 ac 0f 00 00       	mov    0xfac,%eax
 b76:	89 45 f0             	mov    %eax,-0x10(%ebp)
 b79:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 b7d:	75 23                	jne    ba2 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 b7f:	c7 45 f0 a4 0f 00 00 	movl   $0xfa4,-0x10(%ebp)
 b86:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b89:	a3 ac 0f 00 00       	mov    %eax,0xfac
 b8e:	a1 ac 0f 00 00       	mov    0xfac,%eax
 b93:	a3 a4 0f 00 00       	mov    %eax,0xfa4
    base.s.size = 0;
 b98:	c7 05 a8 0f 00 00 00 	movl   $0x0,0xfa8
 b9f:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ba2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ba5:	8b 00                	mov    (%eax),%eax
 ba7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bad:	8b 40 04             	mov    0x4(%eax),%eax
 bb0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 bb3:	72 4d                	jb     c02 <malloc+0xa6>
      if(p->s.size == nunits)
 bb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bb8:	8b 40 04             	mov    0x4(%eax),%eax
 bbb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 bbe:	75 0c                	jne    bcc <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 bc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bc3:	8b 10                	mov    (%eax),%edx
 bc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bc8:	89 10                	mov    %edx,(%eax)
 bca:	eb 26                	jmp    bf2 <malloc+0x96>
      else {
        p->s.size -= nunits;
 bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bcf:	8b 40 04             	mov    0x4(%eax),%eax
 bd2:	2b 45 ec             	sub    -0x14(%ebp),%eax
 bd5:	89 c2                	mov    %eax,%edx
 bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bda:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 bdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 be0:	8b 40 04             	mov    0x4(%eax),%eax
 be3:	c1 e0 03             	shl    $0x3,%eax
 be6:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bec:	8b 55 ec             	mov    -0x14(%ebp),%edx
 bef:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 bf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 bf5:	a3 ac 0f 00 00       	mov    %eax,0xfac
      return (void*)(p + 1);
 bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 bfd:	83 c0 08             	add    $0x8,%eax
 c00:	eb 38                	jmp    c3a <malloc+0xde>
    }
    if(p == freep)
 c02:	a1 ac 0f 00 00       	mov    0xfac,%eax
 c07:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 c0a:	75 1b                	jne    c27 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 c0c:	8b 45 ec             	mov    -0x14(%ebp),%eax
 c0f:	89 04 24             	mov    %eax,(%esp)
 c12:	e8 ed fe ff ff       	call   b04 <morecore>
 c17:	89 45 f4             	mov    %eax,-0xc(%ebp)
 c1a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 c1e:	75 07                	jne    c27 <malloc+0xcb>
        return 0;
 c20:	b8 00 00 00 00       	mov    $0x0,%eax
 c25:	eb 13                	jmp    c3a <malloc+0xde>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
 c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c30:	8b 00                	mov    (%eax),%eax
 c32:	89 45 f4             	mov    %eax,-0xc(%ebp)
  }
 c35:	e9 70 ff ff ff       	jmp    baa <malloc+0x4e>
}
 c3a:	c9                   	leave  
 c3b:	c3                   	ret    
