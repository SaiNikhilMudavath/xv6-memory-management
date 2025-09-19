
_memtest:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
	exit();
}

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
	mem();
   6:	e8 05 00 00 00       	call   10 <mem>
   b:	66 90                	xchg   %ax,%ax
   d:	66 90                	xchg   %ax,%ax
   f:	90                   	nop

00000010 <mem>:
{
  10:	55                   	push   %ebp
  11:	89 e5                	mov    %esp,%ebp
  13:	57                   	push   %edi
  14:	56                   	push   %esi
  15:	53                   	push   %ebx
  16:	bb c8 00 00 00       	mov    $0xc8,%ebx
  1b:	83 ec 0c             	sub    $0xc,%esp
  1e:	66 90                	xchg   %ax,%ax
		char *memory = (char*) malloc(size); //4kb;
  20:	83 ec 0c             	sub    $0xc,%esp
  23:	68 00 10 00 00       	push   $0x1000
  28:	e8 43 07 00 00       	call   770 <malloc>
	for(int j=0;j<200;++j){
  2d:	83 c4 10             	add    $0x10,%esp
		memory[0] = (char) (65);
  30:	c6 00 41             	movb   $0x41,(%eax)
	for(int j=0;j<200;++j){
  33:	83 eb 01             	sub    $0x1,%ebx
  36:	75 e8                	jne    20 <mem+0x10>
	pid = fork();
  38:	e8 be 03 00 00       	call   3fb <fork>
	if(pid > 0) {
  3d:	85 c0                	test   %eax,%eax
  3f:	0f 8e 8c 00 00 00    	jle    d1 <mem+0xc1>
  45:	be 64 00 00 00       	mov    $0x64,%esi
				memory[k] = (char)(65+(k%26));
  4a:	bf 4f ec c4 4e       	mov    $0x4ec4ec4f,%edi
			char *memory = (char*) malloc(size); //4kb;
  4f:	83 ec 0c             	sub    $0xc,%esp
  52:	68 00 10 00 00       	push   $0x1000
  57:	e8 14 07 00 00       	call   770 <malloc>
			if (memory == 0) goto failed;
  5c:	83 c4 10             	add    $0x10,%esp
			char *memory = (char*) malloc(size); //4kb;
  5f:	89 c3                	mov    %eax,%ebx
			if (memory == 0) goto failed;
  61:	85 c0                	test   %eax,%eax
  63:	74 58                	je     bd <mem+0xad>
			for(int k=0;k<size;++k){
  65:	31 c9                	xor    %ecx,%ecx
  67:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
  6e:	00 
  6f:	90                   	nop
				memory[k] = (char)(65+(k%26));
  70:	89 c8                	mov    %ecx,%eax
  72:	f7 e7                	mul    %edi
  74:	89 c8                	mov    %ecx,%eax
  76:	c1 ea 03             	shr    $0x3,%edx
  79:	6b d2 1a             	imul   $0x1a,%edx,%edx
  7c:	29 d0                	sub    %edx,%eax
  7e:	83 c0 41             	add    $0x41,%eax
  81:	88 04 0b             	mov    %al,(%ebx,%ecx,1)
			for(int k=0;k<size;++k){
  84:	83 c1 01             	add    $0x1,%ecx
  87:	81 f9 00 10 00 00    	cmp    $0x1000,%ecx
  8d:	75 e1                	jne    70 <mem+0x60>
			for(int k=0;k<size;++k){
  8f:	31 c9                	xor    %ecx,%ecx
  91:	eb 14                	jmp    a7 <mem+0x97>
  93:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
  98:	83 c1 01             	add    $0x1,%ecx
  9b:	81 f9 00 10 00 00    	cmp    $0x1000,%ecx
  a1:	0f 84 c7 00 00 00    	je     16e <mem+0x15e>
				if(memory[k] != (char)(65+(k%26))) goto failed;
  a7:	89 c8                	mov    %ecx,%eax
  a9:	f7 e7                	mul    %edi
  ab:	89 c8                	mov    %ecx,%eax
  ad:	c1 ea 03             	shr    $0x3,%edx
  b0:	6b d2 1a             	imul   $0x1a,%edx,%edx
  b3:	29 d0                	sub    %edx,%eax
  b5:	83 c0 41             	add    $0x41,%eax
  b8:	38 04 0b             	cmp    %al,(%ebx,%ecx,1)
  bb:	74 db                	je     98 <mem+0x88>
	printf(1, "Memtest Failed\n");
  bd:	83 ec 08             	sub    $0x8,%esp
  c0:	68 97 08 00 00       	push   $0x897
  c5:	6a 01                	push   $0x1
  c7:	e8 84 04 00 00       	call   550 <printf>
	exit();
  cc:	e8 32 03 00 00       	call   403 <exit>
	else if(pid < 0){ 
  d1:	74 16                	je     e9 <mem+0xd9>
		printf(1, "Fork Failed\n");
  d3:	53                   	push   %ebx
  d4:	53                   	push   %ebx
  d5:	68 6a 08 00 00       	push   $0x86a
  da:	6a 01                	push   $0x1
  dc:	e8 6f 04 00 00       	call   550 <printf>
  e1:	83 c4 10             	add    $0x10,%esp
	exit();
  e4:	e8 1a 03 00 00       	call   403 <exit>
		sleep(100);
  e9:	83 ec 0c             	sub    $0xc,%esp
  ec:	be 34 01 00 00       	mov    $0x134,%esi
				memory[k] = (char)(65+(k%26));
  f1:	bf 4f ec c4 4e       	mov    $0x4ec4ec4f,%edi
		sleep(100);
  f6:	6a 64                	push   $0x64
  f8:	e8 96 03 00 00       	call   493 <sleep>
  fd:	83 c4 10             	add    $0x10,%esp
			char *memory = (char*) malloc(size); //4kb;
 100:	83 ec 0c             	sub    $0xc,%esp
 103:	68 00 10 00 00       	push   $0x1000
 108:	e8 63 06 00 00       	call   770 <malloc>
			if (memory == 0) goto failed;
 10d:	83 c4 10             	add    $0x10,%esp
			char *memory = (char*) malloc(size); //4kb;
 110:	89 c3                	mov    %eax,%ebx
			if (memory == 0) goto failed;
 112:	85 c0                	test   %eax,%eax
 114:	74 a7                	je     bd <mem+0xad>
			for(int k=0;k<size;++k){
 116:	31 c9                	xor    %ecx,%ecx
 118:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 11f:	00 
				memory[k] = (char)(65+(k%26));
 120:	89 c8                	mov    %ecx,%eax
 122:	f7 e7                	mul    %edi
 124:	89 c8                	mov    %ecx,%eax
 126:	c1 ea 03             	shr    $0x3,%edx
 129:	6b d2 1a             	imul   $0x1a,%edx,%edx
 12c:	29 d0                	sub    %edx,%eax
 12e:	83 c0 41             	add    $0x41,%eax
 131:	88 04 0b             	mov    %al,(%ebx,%ecx,1)
			for(int k=0;k<size;++k){
 134:	83 c1 01             	add    $0x1,%ecx
 137:	81 f9 00 10 00 00    	cmp    $0x1000,%ecx
 13d:	75 e1                	jne    120 <mem+0x110>
			for(int k=0;k<size;++k){
 13f:	31 c9                	xor    %ecx,%ecx
 141:	eb 10                	jmp    153 <mem+0x143>
 143:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 148:	83 c1 01             	add    $0x1,%ecx
 14b:	81 f9 00 10 00 00    	cmp    $0x1000,%ecx
 151:	74 3f                	je     192 <mem+0x182>
				if(memory[k] != (char)(65+(k%26))) goto failed;
 153:	89 c8                	mov    %ecx,%eax
 155:	f7 e7                	mul    %edi
 157:	89 c8                	mov    %ecx,%eax
 159:	c1 ea 03             	shr    $0x3,%edx
 15c:	6b d2 1a             	imul   $0x1a,%edx,%edx
 15f:	29 d0                	sub    %edx,%eax
 161:	83 c0 41             	add    $0x41,%eax
 164:	38 04 0b             	cmp    %al,(%ebx,%ecx,1)
 167:	74 df                	je     148 <mem+0x138>
 169:	e9 4f ff ff ff       	jmp    bd <mem+0xad>
		for(int j=0;j<100;++j){
 16e:	83 ee 01             	sub    $0x1,%esi
 171:	0f 85 d8 fe ff ff    	jne    4f <mem+0x3f>
		printf(1,"Parent alloc-ed:\n");
 177:	56                   	push   %esi
 178:	56                   	push   %esi
 179:	68 58 08 00 00       	push   $0x858
 17e:	6a 01                	push   $0x1
 180:	e8 cb 03 00 00       	call   550 <printf>
		wait();
 185:	e8 81 02 00 00       	call   40b <wait>
 18a:	83 c4 10             	add    $0x10,%esp
 18d:	e9 52 ff ff ff       	jmp    e4 <mem+0xd4>
		for(int j=0;j<308;++j){
 192:	83 ee 01             	sub    $0x1,%esi
 195:	0f 85 65 ff ff ff    	jne    100 <mem+0xf0>
		printf(1,"Child alloc-ed\n");
 19b:	50                   	push   %eax
 19c:	50                   	push   %eax
 19d:	68 77 08 00 00       	push   $0x877
 1a2:	6a 01                	push   $0x1
 1a4:	e8 a7 03 00 00       	call   550 <printf>
		printf(1, "Memtest Passed\n");
 1a9:	5a                   	pop    %edx
 1aa:	59                   	pop    %ecx
 1ab:	68 87 08 00 00       	push   $0x887
 1b0:	6a 01                	push   $0x1
 1b2:	e8 99 03 00 00       	call   550 <printf>
 1b7:	83 c4 10             	add    $0x10,%esp
 1ba:	e9 25 ff ff ff       	jmp    e4 <mem+0xd4>
 1bf:	90                   	nop

000001c0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 1c0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1c1:	31 c0                	xor    %eax,%eax
{
 1c3:	89 e5                	mov    %esp,%ebp
 1c5:	53                   	push   %ebx
 1c6:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 1cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 1d0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 1d4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 1d7:	83 c0 01             	add    $0x1,%eax
 1da:	84 d2                	test   %dl,%dl
 1dc:	75 f2                	jne    1d0 <strcpy+0x10>
    ;
  return os;
}
 1de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1e1:	89 c8                	mov    %ecx,%eax
 1e3:	c9                   	leave
 1e4:	c3                   	ret
 1e5:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 1ec:	00 
 1ed:	8d 76 00             	lea    0x0(%esi),%esi

000001f0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
 1f3:	53                   	push   %ebx
 1f4:	8b 55 08             	mov    0x8(%ebp),%edx
 1f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 1fa:	0f b6 02             	movzbl (%edx),%eax
 1fd:	84 c0                	test   %al,%al
 1ff:	75 17                	jne    218 <strcmp+0x28>
 201:	eb 3a                	jmp    23d <strcmp+0x4d>
 203:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 208:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 20c:	83 c2 01             	add    $0x1,%edx
 20f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 212:	84 c0                	test   %al,%al
 214:	74 1a                	je     230 <strcmp+0x40>
 216:	89 d9                	mov    %ebx,%ecx
 218:	0f b6 19             	movzbl (%ecx),%ebx
 21b:	38 c3                	cmp    %al,%bl
 21d:	74 e9                	je     208 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 21f:	29 d8                	sub    %ebx,%eax
}
 221:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 224:	c9                   	leave
 225:	c3                   	ret
 226:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 22d:	00 
 22e:	66 90                	xchg   %ax,%ax
  return (uchar)*p - (uchar)*q;
 230:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 234:	31 c0                	xor    %eax,%eax
 236:	29 d8                	sub    %ebx,%eax
}
 238:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 23b:	c9                   	leave
 23c:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 23d:	0f b6 19             	movzbl (%ecx),%ebx
 240:	31 c0                	xor    %eax,%eax
 242:	eb db                	jmp    21f <strcmp+0x2f>
 244:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 24b:	00 
 24c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000250 <strlen>:

uint
strlen(const char *s)
{
 250:	55                   	push   %ebp
 251:	89 e5                	mov    %esp,%ebp
 253:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 256:	80 3a 00             	cmpb   $0x0,(%edx)
 259:	74 15                	je     270 <strlen+0x20>
 25b:	31 c0                	xor    %eax,%eax
 25d:	8d 76 00             	lea    0x0(%esi),%esi
 260:	83 c0 01             	add    $0x1,%eax
 263:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 267:	89 c1                	mov    %eax,%ecx
 269:	75 f5                	jne    260 <strlen+0x10>
    ;
  return n;
}
 26b:	89 c8                	mov    %ecx,%eax
 26d:	5d                   	pop    %ebp
 26e:	c3                   	ret
 26f:	90                   	nop
  for(n = 0; s[n]; n++)
 270:	31 c9                	xor    %ecx,%ecx
}
 272:	5d                   	pop    %ebp
 273:	89 c8                	mov    %ecx,%eax
 275:	c3                   	ret
 276:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 27d:	00 
 27e:	66 90                	xchg   %ax,%ax

00000280 <memset>:

void*
memset(void *dst, int c, uint n)
{
 280:	55                   	push   %ebp
 281:	89 e5                	mov    %esp,%ebp
 283:	57                   	push   %edi
 284:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 287:	8b 4d 10             	mov    0x10(%ebp),%ecx
 28a:	8b 45 0c             	mov    0xc(%ebp),%eax
 28d:	89 d7                	mov    %edx,%edi
 28f:	fc                   	cld
 290:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 292:	8b 7d fc             	mov    -0x4(%ebp),%edi
 295:	89 d0                	mov    %edx,%eax
 297:	c9                   	leave
 298:	c3                   	ret
 299:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000002a0 <strchr>:

char*
strchr(const char *s, char c)
{
 2a0:	55                   	push   %ebp
 2a1:	89 e5                	mov    %esp,%ebp
 2a3:	8b 45 08             	mov    0x8(%ebp),%eax
 2a6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 2aa:	0f b6 10             	movzbl (%eax),%edx
 2ad:	84 d2                	test   %dl,%dl
 2af:	75 12                	jne    2c3 <strchr+0x23>
 2b1:	eb 1d                	jmp    2d0 <strchr+0x30>
 2b3:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 2b8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 2bc:	83 c0 01             	add    $0x1,%eax
 2bf:	84 d2                	test   %dl,%dl
 2c1:	74 0d                	je     2d0 <strchr+0x30>
    if(*s == c)
 2c3:	38 d1                	cmp    %dl,%cl
 2c5:	75 f1                	jne    2b8 <strchr+0x18>
      return (char*)s;
  return 0;
}
 2c7:	5d                   	pop    %ebp
 2c8:	c3                   	ret
 2c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 2d0:	31 c0                	xor    %eax,%eax
}
 2d2:	5d                   	pop    %ebp
 2d3:	c3                   	ret
 2d4:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 2db:	00 
 2dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000002e0 <gets>:

char*
gets(char *buf, int max)
{
 2e0:	55                   	push   %ebp
 2e1:	89 e5                	mov    %esp,%ebp
 2e3:	57                   	push   %edi
 2e4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 2e5:	8d 75 e7             	lea    -0x19(%ebp),%esi
{
 2e8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 2e9:	31 db                	xor    %ebx,%ebx
{
 2eb:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 2ee:	eb 27                	jmp    317 <gets+0x37>
    cc = read(0, &c, 1);
 2f0:	83 ec 04             	sub    $0x4,%esp
 2f3:	6a 01                	push   $0x1
 2f5:	56                   	push   %esi
 2f6:	6a 00                	push   $0x0
 2f8:	e8 1e 01 00 00       	call   41b <read>
    if(cc < 1)
 2fd:	83 c4 10             	add    $0x10,%esp
 300:	85 c0                	test   %eax,%eax
 302:	7e 1d                	jle    321 <gets+0x41>
      break;
    buf[i++] = c;
 304:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 308:	8b 55 08             	mov    0x8(%ebp),%edx
 30b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 30f:	3c 0a                	cmp    $0xa,%al
 311:	74 10                	je     323 <gets+0x43>
 313:	3c 0d                	cmp    $0xd,%al
 315:	74 0c                	je     323 <gets+0x43>
  for(i=0; i+1 < max; ){
 317:	89 df                	mov    %ebx,%edi
 319:	83 c3 01             	add    $0x1,%ebx
 31c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 31f:	7c cf                	jl     2f0 <gets+0x10>
 321:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 323:	8b 45 08             	mov    0x8(%ebp),%eax
 326:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 32a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 32d:	5b                   	pop    %ebx
 32e:	5e                   	pop    %esi
 32f:	5f                   	pop    %edi
 330:	5d                   	pop    %ebp
 331:	c3                   	ret
 332:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 339:	00 
 33a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000340 <stat>:

int
stat(const char *n, struct stat *st)
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	56                   	push   %esi
 344:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 345:	83 ec 08             	sub    $0x8,%esp
 348:	6a 00                	push   $0x0
 34a:	ff 75 08             	push   0x8(%ebp)
 34d:	e8 f1 00 00 00       	call   443 <open>
  if(fd < 0)
 352:	83 c4 10             	add    $0x10,%esp
 355:	85 c0                	test   %eax,%eax
 357:	78 27                	js     380 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 359:	83 ec 08             	sub    $0x8,%esp
 35c:	ff 75 0c             	push   0xc(%ebp)
 35f:	89 c3                	mov    %eax,%ebx
 361:	50                   	push   %eax
 362:	e8 f4 00 00 00       	call   45b <fstat>
  close(fd);
 367:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 36a:	89 c6                	mov    %eax,%esi
  close(fd);
 36c:	e8 ba 00 00 00       	call   42b <close>
  return r;
 371:	83 c4 10             	add    $0x10,%esp
}
 374:	8d 65 f8             	lea    -0x8(%ebp),%esp
 377:	89 f0                	mov    %esi,%eax
 379:	5b                   	pop    %ebx
 37a:	5e                   	pop    %esi
 37b:	5d                   	pop    %ebp
 37c:	c3                   	ret
 37d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 380:	be ff ff ff ff       	mov    $0xffffffff,%esi
 385:	eb ed                	jmp    374 <stat+0x34>
 387:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 38e:	00 
 38f:	90                   	nop

00000390 <atoi>:

int
atoi(const char *s)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	53                   	push   %ebx
 394:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 397:	0f be 02             	movsbl (%edx),%eax
 39a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 39d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 3a0:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 3a5:	77 1e                	ja     3c5 <atoi+0x35>
 3a7:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 3ae:	00 
 3af:	90                   	nop
    n = n*10 + *s++ - '0';
 3b0:	83 c2 01             	add    $0x1,%edx
 3b3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 3b6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 3ba:	0f be 02             	movsbl (%edx),%eax
 3bd:	8d 58 d0             	lea    -0x30(%eax),%ebx
 3c0:	80 fb 09             	cmp    $0x9,%bl
 3c3:	76 eb                	jbe    3b0 <atoi+0x20>
  return n;
}
 3c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 3c8:	89 c8                	mov    %ecx,%eax
 3ca:	c9                   	leave
 3cb:	c3                   	ret
 3cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000003d0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3d0:	55                   	push   %ebp
 3d1:	89 e5                	mov    %esp,%ebp
 3d3:	57                   	push   %edi
 3d4:	8b 45 10             	mov    0x10(%ebp),%eax
 3d7:	8b 55 08             	mov    0x8(%ebp),%edx
 3da:	56                   	push   %esi
 3db:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3de:	85 c0                	test   %eax,%eax
 3e0:	7e 13                	jle    3f5 <memmove+0x25>
 3e2:	01 d0                	add    %edx,%eax
  dst = vdst;
 3e4:	89 d7                	mov    %edx,%edi
 3e6:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 3ed:	00 
 3ee:	66 90                	xchg   %ax,%ax
    *dst++ = *src++;
 3f0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 3f1:	39 f8                	cmp    %edi,%eax
 3f3:	75 fb                	jne    3f0 <memmove+0x20>
  return vdst;
}
 3f5:	5e                   	pop    %esi
 3f6:	89 d0                	mov    %edx,%eax
 3f8:	5f                   	pop    %edi
 3f9:	5d                   	pop    %ebp
 3fa:	c3                   	ret

000003fb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3fb:	b8 01 00 00 00       	mov    $0x1,%eax
 400:	cd 40                	int    $0x40
 402:	c3                   	ret

00000403 <exit>:
SYSCALL(exit)
 403:	b8 02 00 00 00       	mov    $0x2,%eax
 408:	cd 40                	int    $0x40
 40a:	c3                   	ret

0000040b <wait>:
SYSCALL(wait)
 40b:	b8 03 00 00 00       	mov    $0x3,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret

00000413 <pipe>:
SYSCALL(pipe)
 413:	b8 04 00 00 00       	mov    $0x4,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret

0000041b <read>:
SYSCALL(read)
 41b:	b8 05 00 00 00       	mov    $0x5,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret

00000423 <write>:
SYSCALL(write)
 423:	b8 10 00 00 00       	mov    $0x10,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret

0000042b <close>:
SYSCALL(close)
 42b:	b8 15 00 00 00       	mov    $0x15,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret

00000433 <kill>:
SYSCALL(kill)
 433:	b8 06 00 00 00       	mov    $0x6,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret

0000043b <exec>:
SYSCALL(exec)
 43b:	b8 07 00 00 00       	mov    $0x7,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret

00000443 <open>:
SYSCALL(open)
 443:	b8 0f 00 00 00       	mov    $0xf,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret

0000044b <mknod>:
SYSCALL(mknod)
 44b:	b8 11 00 00 00       	mov    $0x11,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret

00000453 <unlink>:
SYSCALL(unlink)
 453:	b8 12 00 00 00       	mov    $0x12,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret

0000045b <fstat>:
SYSCALL(fstat)
 45b:	b8 08 00 00 00       	mov    $0x8,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret

00000463 <link>:
SYSCALL(link)
 463:	b8 13 00 00 00       	mov    $0x13,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret

0000046b <mkdir>:
SYSCALL(mkdir)
 46b:	b8 14 00 00 00       	mov    $0x14,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret

00000473 <chdir>:
SYSCALL(chdir)
 473:	b8 09 00 00 00       	mov    $0x9,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret

0000047b <dup>:
SYSCALL(dup)
 47b:	b8 0a 00 00 00       	mov    $0xa,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret

00000483 <getpid>:
SYSCALL(getpid)
 483:	b8 0b 00 00 00       	mov    $0xb,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret

0000048b <sbrk>:
SYSCALL(sbrk)
 48b:	b8 0c 00 00 00       	mov    $0xc,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret

00000493 <sleep>:
SYSCALL(sleep)
 493:	b8 0d 00 00 00       	mov    $0xd,%eax
 498:	cd 40                	int    $0x40
 49a:	c3                   	ret

0000049b <uptime>:
SYSCALL(uptime)
 49b:	b8 0e 00 00 00       	mov    $0xe,%eax
 4a0:	cd 40                	int    $0x40
 4a2:	c3                   	ret
 4a3:	66 90                	xchg   %ax,%ax
 4a5:	66 90                	xchg   %ax,%ax
 4a7:	66 90                	xchg   %ax,%ax
 4a9:	66 90                	xchg   %ax,%ax
 4ab:	66 90                	xchg   %ax,%ax
 4ad:	66 90                	xchg   %ax,%ax
 4af:	90                   	nop

000004b0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 4b0:	55                   	push   %ebp
 4b1:	89 e5                	mov    %esp,%ebp
 4b3:	57                   	push   %edi
 4b4:	56                   	push   %esi
 4b5:	53                   	push   %ebx
 4b6:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 4b8:	89 d1                	mov    %edx,%ecx
{
 4ba:	83 ec 3c             	sub    $0x3c,%esp
 4bd:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 4c0:	85 d2                	test   %edx,%edx
 4c2:	0f 89 80 00 00 00    	jns    548 <printint+0x98>
 4c8:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 4cc:	74 7a                	je     548 <printint+0x98>
    x = -xx;
 4ce:	f7 d9                	neg    %ecx
    neg = 1;
 4d0:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 4d5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 4d8:	31 f6                	xor    %esi,%esi
 4da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 4e0:	89 c8                	mov    %ecx,%eax
 4e2:	31 d2                	xor    %edx,%edx
 4e4:	89 f7                	mov    %esi,%edi
 4e6:	f7 f3                	div    %ebx
 4e8:	8d 76 01             	lea    0x1(%esi),%esi
 4eb:	0f b6 92 1c 09 00 00 	movzbl 0x91c(%edx),%edx
 4f2:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 4f6:	89 ca                	mov    %ecx,%edx
 4f8:	89 c1                	mov    %eax,%ecx
 4fa:	39 da                	cmp    %ebx,%edx
 4fc:	73 e2                	jae    4e0 <printint+0x30>
  if(neg)
 4fe:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 501:	85 c0                	test   %eax,%eax
 503:	74 07                	je     50c <printint+0x5c>
    buf[i++] = '-';
 505:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)

  while(--i >= 0)
 50a:	89 f7                	mov    %esi,%edi
 50c:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 50f:	8b 75 c0             	mov    -0x40(%ebp),%esi
 512:	01 df                	add    %ebx,%edi
 514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    putc(fd, buf[i]);
 518:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 51b:	83 ec 04             	sub    $0x4,%esp
 51e:	88 45 d7             	mov    %al,-0x29(%ebp)
 521:	8d 45 d7             	lea    -0x29(%ebp),%eax
 524:	6a 01                	push   $0x1
 526:	50                   	push   %eax
 527:	56                   	push   %esi
 528:	e8 f6 fe ff ff       	call   423 <write>
  while(--i >= 0)
 52d:	89 f8                	mov    %edi,%eax
 52f:	83 c4 10             	add    $0x10,%esp
 532:	83 ef 01             	sub    $0x1,%edi
 535:	39 c3                	cmp    %eax,%ebx
 537:	75 df                	jne    518 <printint+0x68>
}
 539:	8d 65 f4             	lea    -0xc(%ebp),%esp
 53c:	5b                   	pop    %ebx
 53d:	5e                   	pop    %esi
 53e:	5f                   	pop    %edi
 53f:	5d                   	pop    %ebp
 540:	c3                   	ret
 541:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 548:	31 c0                	xor    %eax,%eax
 54a:	eb 89                	jmp    4d5 <printint+0x25>
 54c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000550 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 550:	55                   	push   %ebp
 551:	89 e5                	mov    %esp,%ebp
 553:	57                   	push   %edi
 554:	56                   	push   %esi
 555:	53                   	push   %ebx
 556:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 559:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 55c:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 55f:	0f b6 1e             	movzbl (%esi),%ebx
 562:	83 c6 01             	add    $0x1,%esi
 565:	84 db                	test   %bl,%bl
 567:	74 67                	je     5d0 <printf+0x80>
 569:	8d 4d 10             	lea    0x10(%ebp),%ecx
 56c:	31 d2                	xor    %edx,%edx
 56e:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 571:	eb 34                	jmp    5a7 <printf+0x57>
 573:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
 578:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 57b:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 580:	83 f8 25             	cmp    $0x25,%eax
 583:	74 18                	je     59d <printf+0x4d>
  write(fd, &c, 1);
 585:	83 ec 04             	sub    $0x4,%esp
 588:	8d 45 e7             	lea    -0x19(%ebp),%eax
 58b:	88 5d e7             	mov    %bl,-0x19(%ebp)
 58e:	6a 01                	push   $0x1
 590:	50                   	push   %eax
 591:	57                   	push   %edi
 592:	e8 8c fe ff ff       	call   423 <write>
 597:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 59a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 59d:	0f b6 1e             	movzbl (%esi),%ebx
 5a0:	83 c6 01             	add    $0x1,%esi
 5a3:	84 db                	test   %bl,%bl
 5a5:	74 29                	je     5d0 <printf+0x80>
    c = fmt[i] & 0xff;
 5a7:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 5aa:	85 d2                	test   %edx,%edx
 5ac:	74 ca                	je     578 <printf+0x28>
      }
    } else if(state == '%'){
 5ae:	83 fa 25             	cmp    $0x25,%edx
 5b1:	75 ea                	jne    59d <printf+0x4d>
      if(c == 'd'){
 5b3:	83 f8 25             	cmp    $0x25,%eax
 5b6:	0f 84 04 01 00 00    	je     6c0 <printf+0x170>
 5bc:	83 e8 63             	sub    $0x63,%eax
 5bf:	83 f8 15             	cmp    $0x15,%eax
 5c2:	77 1c                	ja     5e0 <printf+0x90>
 5c4:	ff 24 85 c4 08 00 00 	jmp    *0x8c4(,%eax,4)
 5cb:	2e 8d 74 26 00       	lea    %cs:0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 5d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5d3:	5b                   	pop    %ebx
 5d4:	5e                   	pop    %esi
 5d5:	5f                   	pop    %edi
 5d6:	5d                   	pop    %ebp
 5d7:	c3                   	ret
 5d8:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 5df:	00 
  write(fd, &c, 1);
 5e0:	83 ec 04             	sub    $0x4,%esp
 5e3:	8d 55 e7             	lea    -0x19(%ebp),%edx
 5e6:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 5ea:	6a 01                	push   $0x1
 5ec:	52                   	push   %edx
 5ed:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 5f0:	57                   	push   %edi
 5f1:	e8 2d fe ff ff       	call   423 <write>
 5f6:	83 c4 0c             	add    $0xc,%esp
 5f9:	88 5d e7             	mov    %bl,-0x19(%ebp)
 5fc:	6a 01                	push   $0x1
 5fe:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 601:	52                   	push   %edx
 602:	57                   	push   %edi
 603:	e8 1b fe ff ff       	call   423 <write>
        putc(fd, c);
 608:	83 c4 10             	add    $0x10,%esp
      state = 0;
 60b:	31 d2                	xor    %edx,%edx
 60d:	eb 8e                	jmp    59d <printf+0x4d>
 60f:	90                   	nop
        printint(fd, *ap, 16, 0);
 610:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 613:	83 ec 0c             	sub    $0xc,%esp
 616:	b9 10 00 00 00       	mov    $0x10,%ecx
 61b:	8b 13                	mov    (%ebx),%edx
 61d:	6a 00                	push   $0x0
 61f:	89 f8                	mov    %edi,%eax
        ap++;
 621:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 624:	e8 87 fe ff ff       	call   4b0 <printint>
        ap++;
 629:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 62c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 62f:	31 d2                	xor    %edx,%edx
 631:	e9 67 ff ff ff       	jmp    59d <printf+0x4d>
        s = (char*)*ap;
 636:	8b 45 d0             	mov    -0x30(%ebp),%eax
 639:	8b 18                	mov    (%eax),%ebx
        ap++;
 63b:	83 c0 04             	add    $0x4,%eax
 63e:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 641:	85 db                	test   %ebx,%ebx
 643:	0f 84 87 00 00 00    	je     6d0 <printf+0x180>
        while(*s != 0){
 649:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 64c:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 64e:	84 c0                	test   %al,%al
 650:	0f 84 47 ff ff ff    	je     59d <printf+0x4d>
 656:	8d 55 e7             	lea    -0x19(%ebp),%edx
 659:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 65c:	89 de                	mov    %ebx,%esi
 65e:	89 d3                	mov    %edx,%ebx
  write(fd, &c, 1);
 660:	83 ec 04             	sub    $0x4,%esp
 663:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 666:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 669:	6a 01                	push   $0x1
 66b:	53                   	push   %ebx
 66c:	57                   	push   %edi
 66d:	e8 b1 fd ff ff       	call   423 <write>
        while(*s != 0){
 672:	0f b6 06             	movzbl (%esi),%eax
 675:	83 c4 10             	add    $0x10,%esp
 678:	84 c0                	test   %al,%al
 67a:	75 e4                	jne    660 <printf+0x110>
      state = 0;
 67c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 67f:	31 d2                	xor    %edx,%edx
 681:	e9 17 ff ff ff       	jmp    59d <printf+0x4d>
        printint(fd, *ap, 10, 1);
 686:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 689:	83 ec 0c             	sub    $0xc,%esp
 68c:	b9 0a 00 00 00       	mov    $0xa,%ecx
 691:	8b 13                	mov    (%ebx),%edx
 693:	6a 01                	push   $0x1
 695:	eb 88                	jmp    61f <printf+0xcf>
        putc(fd, *ap);
 697:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 69a:	83 ec 04             	sub    $0x4,%esp
 69d:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 6a0:	8b 03                	mov    (%ebx),%eax
        ap++;
 6a2:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 6a5:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 6a8:	6a 01                	push   $0x1
 6aa:	52                   	push   %edx
 6ab:	57                   	push   %edi
 6ac:	e8 72 fd ff ff       	call   423 <write>
        ap++;
 6b1:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 6b4:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6b7:	31 d2                	xor    %edx,%edx
 6b9:	e9 df fe ff ff       	jmp    59d <printf+0x4d>
 6be:	66 90                	xchg   %ax,%ax
  write(fd, &c, 1);
 6c0:	83 ec 04             	sub    $0x4,%esp
 6c3:	88 5d e7             	mov    %bl,-0x19(%ebp)
 6c6:	8d 55 e7             	lea    -0x19(%ebp),%edx
 6c9:	6a 01                	push   $0x1
 6cb:	e9 31 ff ff ff       	jmp    601 <printf+0xb1>
 6d0:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 6d5:	bb bd 08 00 00       	mov    $0x8bd,%ebx
 6da:	e9 77 ff ff ff       	jmp    656 <printf+0x106>
 6df:	90                   	nop

000006e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6e0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6e1:	a1 20 2c 00 00       	mov    0x2c20,%eax
{
 6e6:	89 e5                	mov    %esp,%ebp
 6e8:	57                   	push   %edi
 6e9:	56                   	push   %esi
 6ea:	53                   	push   %ebx
 6eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 6ee:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6f8:	8b 10                	mov    (%eax),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6fa:	39 c8                	cmp    %ecx,%eax
 6fc:	73 32                	jae    730 <free+0x50>
 6fe:	39 d1                	cmp    %edx,%ecx
 700:	72 04                	jb     706 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 702:	39 d0                	cmp    %edx,%eax
 704:	72 32                	jb     738 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 706:	8b 73 fc             	mov    -0x4(%ebx),%esi
 709:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 70c:	39 fa                	cmp    %edi,%edx
 70e:	74 30                	je     740 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 710:	89 53 f8             	mov    %edx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 713:	8b 50 04             	mov    0x4(%eax),%edx
 716:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 719:	39 f1                	cmp    %esi,%ecx
 71b:	74 3a                	je     757 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 71d:	89 08                	mov    %ecx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 71f:	5b                   	pop    %ebx
  freep = p;
 720:	a3 20 2c 00 00       	mov    %eax,0x2c20
}
 725:	5e                   	pop    %esi
 726:	5f                   	pop    %edi
 727:	5d                   	pop    %ebp
 728:	c3                   	ret
 729:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 730:	39 d0                	cmp    %edx,%eax
 732:	72 04                	jb     738 <free+0x58>
 734:	39 d1                	cmp    %edx,%ecx
 736:	72 ce                	jb     706 <free+0x26>
{
 738:	89 d0                	mov    %edx,%eax
 73a:	eb bc                	jmp    6f8 <free+0x18>
 73c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 740:	03 72 04             	add    0x4(%edx),%esi
 743:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 746:	8b 10                	mov    (%eax),%edx
 748:	8b 12                	mov    (%edx),%edx
 74a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 74d:	8b 50 04             	mov    0x4(%eax),%edx
 750:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 753:	39 f1                	cmp    %esi,%ecx
 755:	75 c6                	jne    71d <free+0x3d>
    p->s.size += bp->s.size;
 757:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 75a:	a3 20 2c 00 00       	mov    %eax,0x2c20
    p->s.size += bp->s.size;
 75f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 762:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 765:	89 08                	mov    %ecx,(%eax)
}
 767:	5b                   	pop    %ebx
 768:	5e                   	pop    %esi
 769:	5f                   	pop    %edi
 76a:	5d                   	pop    %ebp
 76b:	c3                   	ret
 76c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000770 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 770:	55                   	push   %ebp
 771:	89 e5                	mov    %esp,%ebp
 773:	57                   	push   %edi
 774:	56                   	push   %esi
 775:	53                   	push   %ebx
 776:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 779:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 77c:	8b 15 20 2c 00 00    	mov    0x2c20,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 782:	8d 78 07             	lea    0x7(%eax),%edi
 785:	c1 ef 03             	shr    $0x3,%edi
 788:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 78b:	85 d2                	test   %edx,%edx
 78d:	0f 84 8d 00 00 00    	je     820 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 793:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 795:	8b 48 04             	mov    0x4(%eax),%ecx
 798:	39 f9                	cmp    %edi,%ecx
 79a:	73 64                	jae    800 <malloc+0x90>
  if(nu < 4096)
 79c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 7a1:	39 df                	cmp    %ebx,%edi
 7a3:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 7a6:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 7ad:	eb 0a                	jmp    7b9 <malloc+0x49>
 7af:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7b0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 7b2:	8b 48 04             	mov    0x4(%eax),%ecx
 7b5:	39 f9                	cmp    %edi,%ecx
 7b7:	73 47                	jae    800 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7b9:	89 c2                	mov    %eax,%edx
 7bb:	3b 05 20 2c 00 00    	cmp    0x2c20,%eax
 7c1:	75 ed                	jne    7b0 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 7c3:	83 ec 0c             	sub    $0xc,%esp
 7c6:	56                   	push   %esi
 7c7:	e8 bf fc ff ff       	call   48b <sbrk>
  if(p == (char*)-1)
 7cc:	83 c4 10             	add    $0x10,%esp
 7cf:	83 f8 ff             	cmp    $0xffffffff,%eax
 7d2:	74 1c                	je     7f0 <malloc+0x80>
  hp->s.size = nu;
 7d4:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 7d7:	83 ec 0c             	sub    $0xc,%esp
 7da:	83 c0 08             	add    $0x8,%eax
 7dd:	50                   	push   %eax
 7de:	e8 fd fe ff ff       	call   6e0 <free>
  return freep;
 7e3:	8b 15 20 2c 00 00    	mov    0x2c20,%edx
      if((p = morecore(nunits)) == 0)
 7e9:	83 c4 10             	add    $0x10,%esp
 7ec:	85 d2                	test   %edx,%edx
 7ee:	75 c0                	jne    7b0 <malloc+0x40>
        return 0;
  }
}
 7f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 7f3:	31 c0                	xor    %eax,%eax
}
 7f5:	5b                   	pop    %ebx
 7f6:	5e                   	pop    %esi
 7f7:	5f                   	pop    %edi
 7f8:	5d                   	pop    %ebp
 7f9:	c3                   	ret
 7fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 800:	39 cf                	cmp    %ecx,%edi
 802:	74 4c                	je     850 <malloc+0xe0>
        p->s.size -= nunits;
 804:	29 f9                	sub    %edi,%ecx
 806:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 809:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 80c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 80f:	89 15 20 2c 00 00    	mov    %edx,0x2c20
}
 815:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 818:	83 c0 08             	add    $0x8,%eax
}
 81b:	5b                   	pop    %ebx
 81c:	5e                   	pop    %esi
 81d:	5f                   	pop    %edi
 81e:	5d                   	pop    %ebp
 81f:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 820:	c7 05 20 2c 00 00 24 	movl   $0x2c24,0x2c20
 827:	2c 00 00 
    base.s.size = 0;
 82a:	b8 24 2c 00 00       	mov    $0x2c24,%eax
    base.s.ptr = freep = prevp = &base;
 82f:	c7 05 24 2c 00 00 24 	movl   $0x2c24,0x2c24
 836:	2c 00 00 
    base.s.size = 0;
 839:	c7 05 28 2c 00 00 00 	movl   $0x0,0x2c28
 840:	00 00 00 
    if(p->s.size >= nunits){
 843:	e9 54 ff ff ff       	jmp    79c <malloc+0x2c>
 848:	2e 8d b4 26 00 00 00 	lea    %cs:0x0(%esi,%eiz,1),%esi
 84f:	00 
        prevp->s.ptr = p->s.ptr;
 850:	8b 08                	mov    (%eax),%ecx
 852:	89 0a                	mov    %ecx,(%edx)
 854:	eb b9                	jmp    80f <malloc+0x9f>
