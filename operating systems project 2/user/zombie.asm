
user/_zombie:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if(fork() > 0)
   8:	2ac000ef          	jal	2b4 <fork>
   c:	00a04563          	bgtz	a0,16 <main+0x16>
    sleep(5);  // Let child exit before parent.
  exit(0);
  10:	4501                	li	a0,0
  12:	2aa000ef          	jal	2bc <exit>
    sleep(5);  // Let child exit before parent.
  16:	4515                	li	a0,5
  18:	334000ef          	jal	34c <sleep>
  1c:	bfd5                	j	10 <main+0x10>

000000000000001e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  1e:	1141                	addi	sp,sp,-16
  20:	e406                	sd	ra,8(sp)
  22:	e022                	sd	s0,0(sp)
  24:	0800                	addi	s0,sp,16
  extern int main();
  main();
  26:	fdbff0ef          	jal	0 <main>
  exit(0);
  2a:	4501                	li	a0,0
  2c:	290000ef          	jal	2bc <exit>

0000000000000030 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  30:	1141                	addi	sp,sp,-16
  32:	e406                	sd	ra,8(sp)
  34:	e022                	sd	s0,0(sp)
  36:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  38:	87aa                	mv	a5,a0
  3a:	0585                	addi	a1,a1,1
  3c:	0785                	addi	a5,a5,1
  3e:	fff5c703          	lbu	a4,-1(a1)
  42:	fee78fa3          	sb	a4,-1(a5)
  46:	fb75                	bnez	a4,3a <strcpy+0xa>
    ;
  return os;
}
  48:	60a2                	ld	ra,8(sp)
  4a:	6402                	ld	s0,0(sp)
  4c:	0141                	addi	sp,sp,16
  4e:	8082                	ret

0000000000000050 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  50:	1141                	addi	sp,sp,-16
  52:	e406                	sd	ra,8(sp)
  54:	e022                	sd	s0,0(sp)
  56:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  58:	00054783          	lbu	a5,0(a0)
  5c:	cb91                	beqz	a5,70 <strcmp+0x20>
  5e:	0005c703          	lbu	a4,0(a1)
  62:	00f71763          	bne	a4,a5,70 <strcmp+0x20>
    p++, q++;
  66:	0505                	addi	a0,a0,1
  68:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  6a:	00054783          	lbu	a5,0(a0)
  6e:	fbe5                	bnez	a5,5e <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  70:	0005c503          	lbu	a0,0(a1)
}
  74:	40a7853b          	subw	a0,a5,a0
  78:	60a2                	ld	ra,8(sp)
  7a:	6402                	ld	s0,0(sp)
  7c:	0141                	addi	sp,sp,16
  7e:	8082                	ret

0000000000000080 <strlen>:

uint
strlen(const char *s)
{
  80:	1141                	addi	sp,sp,-16
  82:	e406                	sd	ra,8(sp)
  84:	e022                	sd	s0,0(sp)
  86:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  88:	00054783          	lbu	a5,0(a0)
  8c:	cf99                	beqz	a5,aa <strlen+0x2a>
  8e:	0505                	addi	a0,a0,1
  90:	87aa                	mv	a5,a0
  92:	86be                	mv	a3,a5
  94:	0785                	addi	a5,a5,1
  96:	fff7c703          	lbu	a4,-1(a5)
  9a:	ff65                	bnez	a4,92 <strlen+0x12>
  9c:	40a6853b          	subw	a0,a3,a0
  a0:	2505                	addiw	a0,a0,1
    ;
  return n;
}
  a2:	60a2                	ld	ra,8(sp)
  a4:	6402                	ld	s0,0(sp)
  a6:	0141                	addi	sp,sp,16
  a8:	8082                	ret
  for(n = 0; s[n]; n++)
  aa:	4501                	li	a0,0
  ac:	bfdd                	j	a2 <strlen+0x22>

00000000000000ae <memset>:

void*
memset(void *dst, int c, uint n)
{
  ae:	1141                	addi	sp,sp,-16
  b0:	e406                	sd	ra,8(sp)
  b2:	e022                	sd	s0,0(sp)
  b4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  b6:	ca19                	beqz	a2,cc <memset+0x1e>
  b8:	87aa                	mv	a5,a0
  ba:	1602                	slli	a2,a2,0x20
  bc:	9201                	srli	a2,a2,0x20
  be:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  c2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  c6:	0785                	addi	a5,a5,1
  c8:	fee79de3          	bne	a5,a4,c2 <memset+0x14>
  }
  return dst;
}
  cc:	60a2                	ld	ra,8(sp)
  ce:	6402                	ld	s0,0(sp)
  d0:	0141                	addi	sp,sp,16
  d2:	8082                	ret

00000000000000d4 <strchr>:

char*
strchr(const char *s, char c)
{
  d4:	1141                	addi	sp,sp,-16
  d6:	e406                	sd	ra,8(sp)
  d8:	e022                	sd	s0,0(sp)
  da:	0800                	addi	s0,sp,16
  for(; *s; s++)
  dc:	00054783          	lbu	a5,0(a0)
  e0:	cf81                	beqz	a5,f8 <strchr+0x24>
    if(*s == c)
  e2:	00f58763          	beq	a1,a5,f0 <strchr+0x1c>
  for(; *s; s++)
  e6:	0505                	addi	a0,a0,1
  e8:	00054783          	lbu	a5,0(a0)
  ec:	fbfd                	bnez	a5,e2 <strchr+0xe>
      return (char*)s;
  return 0;
  ee:	4501                	li	a0,0
}
  f0:	60a2                	ld	ra,8(sp)
  f2:	6402                	ld	s0,0(sp)
  f4:	0141                	addi	sp,sp,16
  f6:	8082                	ret
  return 0;
  f8:	4501                	li	a0,0
  fa:	bfdd                	j	f0 <strchr+0x1c>

00000000000000fc <gets>:

char*
gets(char *buf, int max)
{
  fc:	7159                	addi	sp,sp,-112
  fe:	f486                	sd	ra,104(sp)
 100:	f0a2                	sd	s0,96(sp)
 102:	eca6                	sd	s1,88(sp)
 104:	e8ca                	sd	s2,80(sp)
 106:	e4ce                	sd	s3,72(sp)
 108:	e0d2                	sd	s4,64(sp)
 10a:	fc56                	sd	s5,56(sp)
 10c:	f85a                	sd	s6,48(sp)
 10e:	f45e                	sd	s7,40(sp)
 110:	f062                	sd	s8,32(sp)
 112:	ec66                	sd	s9,24(sp)
 114:	e86a                	sd	s10,16(sp)
 116:	1880                	addi	s0,sp,112
 118:	8caa                	mv	s9,a0
 11a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 11c:	892a                	mv	s2,a0
 11e:	4481                	li	s1,0
    cc = read(0, &c, 1);
 120:	f9f40b13          	addi	s6,s0,-97
 124:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 126:	4ba9                	li	s7,10
 128:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 12a:	8d26                	mv	s10,s1
 12c:	0014899b          	addiw	s3,s1,1
 130:	84ce                	mv	s1,s3
 132:	0349d563          	bge	s3,s4,15c <gets+0x60>
    cc = read(0, &c, 1);
 136:	8656                	mv	a2,s5
 138:	85da                	mv	a1,s6
 13a:	4501                	li	a0,0
 13c:	198000ef          	jal	2d4 <read>
    if(cc < 1)
 140:	00a05e63          	blez	a0,15c <gets+0x60>
    buf[i++] = c;
 144:	f9f44783          	lbu	a5,-97(s0)
 148:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 14c:	01778763          	beq	a5,s7,15a <gets+0x5e>
 150:	0905                	addi	s2,s2,1
 152:	fd879ce3          	bne	a5,s8,12a <gets+0x2e>
    buf[i++] = c;
 156:	8d4e                	mv	s10,s3
 158:	a011                	j	15c <gets+0x60>
 15a:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 15c:	9d66                	add	s10,s10,s9
 15e:	000d0023          	sb	zero,0(s10)
  return buf;
}
 162:	8566                	mv	a0,s9
 164:	70a6                	ld	ra,104(sp)
 166:	7406                	ld	s0,96(sp)
 168:	64e6                	ld	s1,88(sp)
 16a:	6946                	ld	s2,80(sp)
 16c:	69a6                	ld	s3,72(sp)
 16e:	6a06                	ld	s4,64(sp)
 170:	7ae2                	ld	s5,56(sp)
 172:	7b42                	ld	s6,48(sp)
 174:	7ba2                	ld	s7,40(sp)
 176:	7c02                	ld	s8,32(sp)
 178:	6ce2                	ld	s9,24(sp)
 17a:	6d42                	ld	s10,16(sp)
 17c:	6165                	addi	sp,sp,112
 17e:	8082                	ret

0000000000000180 <stat>:

int
stat(const char *n, struct stat *st)
{
 180:	1101                	addi	sp,sp,-32
 182:	ec06                	sd	ra,24(sp)
 184:	e822                	sd	s0,16(sp)
 186:	e04a                	sd	s2,0(sp)
 188:	1000                	addi	s0,sp,32
 18a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 18c:	4581                	li	a1,0
 18e:	16e000ef          	jal	2fc <open>
  if(fd < 0)
 192:	02054263          	bltz	a0,1b6 <stat+0x36>
 196:	e426                	sd	s1,8(sp)
 198:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 19a:	85ca                	mv	a1,s2
 19c:	178000ef          	jal	314 <fstat>
 1a0:	892a                	mv	s2,a0
  close(fd);
 1a2:	8526                	mv	a0,s1
 1a4:	140000ef          	jal	2e4 <close>
  return r;
 1a8:	64a2                	ld	s1,8(sp)
}
 1aa:	854a                	mv	a0,s2
 1ac:	60e2                	ld	ra,24(sp)
 1ae:	6442                	ld	s0,16(sp)
 1b0:	6902                	ld	s2,0(sp)
 1b2:	6105                	addi	sp,sp,32
 1b4:	8082                	ret
    return -1;
 1b6:	597d                	li	s2,-1
 1b8:	bfcd                	j	1aa <stat+0x2a>

00000000000001ba <atoi>:

int
atoi(const char *s)
{
 1ba:	1141                	addi	sp,sp,-16
 1bc:	e406                	sd	ra,8(sp)
 1be:	e022                	sd	s0,0(sp)
 1c0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1c2:	00054683          	lbu	a3,0(a0)
 1c6:	fd06879b          	addiw	a5,a3,-48
 1ca:	0ff7f793          	zext.b	a5,a5
 1ce:	4625                	li	a2,9
 1d0:	02f66963          	bltu	a2,a5,202 <atoi+0x48>
 1d4:	872a                	mv	a4,a0
  n = 0;
 1d6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1d8:	0705                	addi	a4,a4,1
 1da:	0025179b          	slliw	a5,a0,0x2
 1de:	9fa9                	addw	a5,a5,a0
 1e0:	0017979b          	slliw	a5,a5,0x1
 1e4:	9fb5                	addw	a5,a5,a3
 1e6:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1ea:	00074683          	lbu	a3,0(a4)
 1ee:	fd06879b          	addiw	a5,a3,-48
 1f2:	0ff7f793          	zext.b	a5,a5
 1f6:	fef671e3          	bgeu	a2,a5,1d8 <atoi+0x1e>
  return n;
}
 1fa:	60a2                	ld	ra,8(sp)
 1fc:	6402                	ld	s0,0(sp)
 1fe:	0141                	addi	sp,sp,16
 200:	8082                	ret
  n = 0;
 202:	4501                	li	a0,0
 204:	bfdd                	j	1fa <atoi+0x40>

0000000000000206 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 206:	1141                	addi	sp,sp,-16
 208:	e406                	sd	ra,8(sp)
 20a:	e022                	sd	s0,0(sp)
 20c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 20e:	02b57563          	bgeu	a0,a1,238 <memmove+0x32>
    while(n-- > 0)
 212:	00c05f63          	blez	a2,230 <memmove+0x2a>
 216:	1602                	slli	a2,a2,0x20
 218:	9201                	srli	a2,a2,0x20
 21a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 21e:	872a                	mv	a4,a0
      *dst++ = *src++;
 220:	0585                	addi	a1,a1,1
 222:	0705                	addi	a4,a4,1
 224:	fff5c683          	lbu	a3,-1(a1)
 228:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 22c:	fee79ae3          	bne	a5,a4,220 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 230:	60a2                	ld	ra,8(sp)
 232:	6402                	ld	s0,0(sp)
 234:	0141                	addi	sp,sp,16
 236:	8082                	ret
    dst += n;
 238:	00c50733          	add	a4,a0,a2
    src += n;
 23c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 23e:	fec059e3          	blez	a2,230 <memmove+0x2a>
 242:	fff6079b          	addiw	a5,a2,-1
 246:	1782                	slli	a5,a5,0x20
 248:	9381                	srli	a5,a5,0x20
 24a:	fff7c793          	not	a5,a5
 24e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 250:	15fd                	addi	a1,a1,-1
 252:	177d                	addi	a4,a4,-1
 254:	0005c683          	lbu	a3,0(a1)
 258:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 25c:	fef71ae3          	bne	a4,a5,250 <memmove+0x4a>
 260:	bfc1                	j	230 <memmove+0x2a>

0000000000000262 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 262:	1141                	addi	sp,sp,-16
 264:	e406                	sd	ra,8(sp)
 266:	e022                	sd	s0,0(sp)
 268:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 26a:	ca0d                	beqz	a2,29c <memcmp+0x3a>
 26c:	fff6069b          	addiw	a3,a2,-1
 270:	1682                	slli	a3,a3,0x20
 272:	9281                	srli	a3,a3,0x20
 274:	0685                	addi	a3,a3,1
 276:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 278:	00054783          	lbu	a5,0(a0)
 27c:	0005c703          	lbu	a4,0(a1)
 280:	00e79863          	bne	a5,a4,290 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 284:	0505                	addi	a0,a0,1
    p2++;
 286:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 288:	fed518e3          	bne	a0,a3,278 <memcmp+0x16>
  }
  return 0;
 28c:	4501                	li	a0,0
 28e:	a019                	j	294 <memcmp+0x32>
      return *p1 - *p2;
 290:	40e7853b          	subw	a0,a5,a4
}
 294:	60a2                	ld	ra,8(sp)
 296:	6402                	ld	s0,0(sp)
 298:	0141                	addi	sp,sp,16
 29a:	8082                	ret
  return 0;
 29c:	4501                	li	a0,0
 29e:	bfdd                	j	294 <memcmp+0x32>

00000000000002a0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2a0:	1141                	addi	sp,sp,-16
 2a2:	e406                	sd	ra,8(sp)
 2a4:	e022                	sd	s0,0(sp)
 2a6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2a8:	f5fff0ef          	jal	206 <memmove>
}
 2ac:	60a2                	ld	ra,8(sp)
 2ae:	6402                	ld	s0,0(sp)
 2b0:	0141                	addi	sp,sp,16
 2b2:	8082                	ret

00000000000002b4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2b4:	4885                	li	a7,1
 ecall
 2b6:	00000073          	ecall
 ret
 2ba:	8082                	ret

00000000000002bc <exit>:
.global exit
exit:
 li a7, SYS_exit
 2bc:	4889                	li	a7,2
 ecall
 2be:	00000073          	ecall
 ret
 2c2:	8082                	ret

00000000000002c4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2c4:	488d                	li	a7,3
 ecall
 2c6:	00000073          	ecall
 ret
 2ca:	8082                	ret

00000000000002cc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2cc:	4891                	li	a7,4
 ecall
 2ce:	00000073          	ecall
 ret
 2d2:	8082                	ret

00000000000002d4 <read>:
.global read
read:
 li a7, SYS_read
 2d4:	4895                	li	a7,5
 ecall
 2d6:	00000073          	ecall
 ret
 2da:	8082                	ret

00000000000002dc <write>:
.global write
write:
 li a7, SYS_write
 2dc:	48c1                	li	a7,16
 ecall
 2de:	00000073          	ecall
 ret
 2e2:	8082                	ret

00000000000002e4 <close>:
.global close
close:
 li a7, SYS_close
 2e4:	48d5                	li	a7,21
 ecall
 2e6:	00000073          	ecall
 ret
 2ea:	8082                	ret

00000000000002ec <kill>:
.global kill
kill:
 li a7, SYS_kill
 2ec:	4899                	li	a7,6
 ecall
 2ee:	00000073          	ecall
 ret
 2f2:	8082                	ret

00000000000002f4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 2f4:	489d                	li	a7,7
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <open>:
.global open
open:
 li a7, SYS_open
 2fc:	48bd                	li	a7,15
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 304:	48c5                	li	a7,17
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 30c:	48c9                	li	a7,18
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 314:	48a1                	li	a7,8
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <link>:
.global link
link:
 li a7, SYS_link
 31c:	48cd                	li	a7,19
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 324:	48d1                	li	a7,20
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 32c:	48a5                	li	a7,9
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <dup>:
.global dup
dup:
 li a7, SYS_dup
 334:	48a9                	li	a7,10
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 33c:	48ad                	li	a7,11
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 344:	48b1                	li	a7,12
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 34c:	48b5                	li	a7,13
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 354:	48b9                	li	a7,14
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
 35c:	48d9                	li	a7,22
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 364:	1101                	addi	sp,sp,-32
 366:	ec06                	sd	ra,24(sp)
 368:	e822                	sd	s0,16(sp)
 36a:	1000                	addi	s0,sp,32
 36c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 370:	4605                	li	a2,1
 372:	fef40593          	addi	a1,s0,-17
 376:	f67ff0ef          	jal	2dc <write>
}
 37a:	60e2                	ld	ra,24(sp)
 37c:	6442                	ld	s0,16(sp)
 37e:	6105                	addi	sp,sp,32
 380:	8082                	ret

0000000000000382 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 382:	7139                	addi	sp,sp,-64
 384:	fc06                	sd	ra,56(sp)
 386:	f822                	sd	s0,48(sp)
 388:	f426                	sd	s1,40(sp)
 38a:	f04a                	sd	s2,32(sp)
 38c:	ec4e                	sd	s3,24(sp)
 38e:	0080                	addi	s0,sp,64
 390:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 392:	c299                	beqz	a3,398 <printint+0x16>
 394:	0605ce63          	bltz	a1,410 <printint+0x8e>
  neg = 0;
 398:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 39a:	fc040313          	addi	t1,s0,-64
  neg = 0;
 39e:	869a                	mv	a3,t1
  i = 0;
 3a0:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 3a2:	00000817          	auipc	a6,0x0
 3a6:	4d680813          	addi	a6,a6,1238 # 878 <digits>
 3aa:	88be                	mv	a7,a5
 3ac:	0017851b          	addiw	a0,a5,1
 3b0:	87aa                	mv	a5,a0
 3b2:	02c5f73b          	remuw	a4,a1,a2
 3b6:	1702                	slli	a4,a4,0x20
 3b8:	9301                	srli	a4,a4,0x20
 3ba:	9742                	add	a4,a4,a6
 3bc:	00074703          	lbu	a4,0(a4)
 3c0:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 3c4:	872e                	mv	a4,a1
 3c6:	02c5d5bb          	divuw	a1,a1,a2
 3ca:	0685                	addi	a3,a3,1
 3cc:	fcc77fe3          	bgeu	a4,a2,3aa <printint+0x28>
  if(neg)
 3d0:	000e0c63          	beqz	t3,3e8 <printint+0x66>
    buf[i++] = '-';
 3d4:	fd050793          	addi	a5,a0,-48
 3d8:	00878533          	add	a0,a5,s0
 3dc:	02d00793          	li	a5,45
 3e0:	fef50823          	sb	a5,-16(a0)
 3e4:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 3e8:	fff7899b          	addiw	s3,a5,-1
 3ec:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 3f0:	fff4c583          	lbu	a1,-1(s1)
 3f4:	854a                	mv	a0,s2
 3f6:	f6fff0ef          	jal	364 <putc>
  while(--i >= 0)
 3fa:	39fd                	addiw	s3,s3,-1
 3fc:	14fd                	addi	s1,s1,-1
 3fe:	fe09d9e3          	bgez	s3,3f0 <printint+0x6e>
}
 402:	70e2                	ld	ra,56(sp)
 404:	7442                	ld	s0,48(sp)
 406:	74a2                	ld	s1,40(sp)
 408:	7902                	ld	s2,32(sp)
 40a:	69e2                	ld	s3,24(sp)
 40c:	6121                	addi	sp,sp,64
 40e:	8082                	ret
    x = -xx;
 410:	40b005bb          	negw	a1,a1
    neg = 1;
 414:	4e05                	li	t3,1
    x = -xx;
 416:	b751                	j	39a <printint+0x18>

0000000000000418 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 418:	711d                	addi	sp,sp,-96
 41a:	ec86                	sd	ra,88(sp)
 41c:	e8a2                	sd	s0,80(sp)
 41e:	e4a6                	sd	s1,72(sp)
 420:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 422:	0005c483          	lbu	s1,0(a1)
 426:	26048663          	beqz	s1,692 <vprintf+0x27a>
 42a:	e0ca                	sd	s2,64(sp)
 42c:	fc4e                	sd	s3,56(sp)
 42e:	f852                	sd	s4,48(sp)
 430:	f456                	sd	s5,40(sp)
 432:	f05a                	sd	s6,32(sp)
 434:	ec5e                	sd	s7,24(sp)
 436:	e862                	sd	s8,16(sp)
 438:	e466                	sd	s9,8(sp)
 43a:	8b2a                	mv	s6,a0
 43c:	8a2e                	mv	s4,a1
 43e:	8bb2                	mv	s7,a2
  state = 0;
 440:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 442:	4901                	li	s2,0
 444:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 446:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 44a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 44e:	06c00c93          	li	s9,108
 452:	a00d                	j	474 <vprintf+0x5c>
        putc(fd, c0);
 454:	85a6                	mv	a1,s1
 456:	855a                	mv	a0,s6
 458:	f0dff0ef          	jal	364 <putc>
 45c:	a019                	j	462 <vprintf+0x4a>
    } else if(state == '%'){
 45e:	03598363          	beq	s3,s5,484 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 462:	0019079b          	addiw	a5,s2,1
 466:	893e                	mv	s2,a5
 468:	873e                	mv	a4,a5
 46a:	97d2                	add	a5,a5,s4
 46c:	0007c483          	lbu	s1,0(a5)
 470:	20048963          	beqz	s1,682 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
 474:	0004879b          	sext.w	a5,s1
    if(state == 0){
 478:	fe0993e3          	bnez	s3,45e <vprintf+0x46>
      if(c0 == '%'){
 47c:	fd579ce3          	bne	a5,s5,454 <vprintf+0x3c>
        state = '%';
 480:	89be                	mv	s3,a5
 482:	b7c5                	j	462 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 484:	00ea06b3          	add	a3,s4,a4
 488:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 48c:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 48e:	c681                	beqz	a3,496 <vprintf+0x7e>
 490:	9752                	add	a4,a4,s4
 492:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 496:	03878e63          	beq	a5,s8,4d2 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 49a:	05978863          	beq	a5,s9,4ea <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 49e:	07500713          	li	a4,117
 4a2:	0ee78263          	beq	a5,a4,586 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 4a6:	07800713          	li	a4,120
 4aa:	12e78463          	beq	a5,a4,5d2 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 4ae:	07000713          	li	a4,112
 4b2:	14e78963          	beq	a5,a4,604 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 4b6:	07300713          	li	a4,115
 4ba:	18e78863          	beq	a5,a4,64a <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 4be:	02500713          	li	a4,37
 4c2:	04e79463          	bne	a5,a4,50a <vprintf+0xf2>
        putc(fd, '%');
 4c6:	85ba                	mv	a1,a4
 4c8:	855a                	mv	a0,s6
 4ca:	e9bff0ef          	jal	364 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 4ce:	4981                	li	s3,0
 4d0:	bf49                	j	462 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 4d2:	008b8493          	addi	s1,s7,8
 4d6:	4685                	li	a3,1
 4d8:	4629                	li	a2,10
 4da:	000ba583          	lw	a1,0(s7)
 4de:	855a                	mv	a0,s6
 4e0:	ea3ff0ef          	jal	382 <printint>
 4e4:	8ba6                	mv	s7,s1
      state = 0;
 4e6:	4981                	li	s3,0
 4e8:	bfad                	j	462 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 4ea:	06400793          	li	a5,100
 4ee:	02f68963          	beq	a3,a5,520 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 4f2:	06c00793          	li	a5,108
 4f6:	04f68263          	beq	a3,a5,53a <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 4fa:	07500793          	li	a5,117
 4fe:	0af68063          	beq	a3,a5,59e <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 502:	07800793          	li	a5,120
 506:	0ef68263          	beq	a3,a5,5ea <vprintf+0x1d2>
        putc(fd, '%');
 50a:	02500593          	li	a1,37
 50e:	855a                	mv	a0,s6
 510:	e55ff0ef          	jal	364 <putc>
        putc(fd, c0);
 514:	85a6                	mv	a1,s1
 516:	855a                	mv	a0,s6
 518:	e4dff0ef          	jal	364 <putc>
      state = 0;
 51c:	4981                	li	s3,0
 51e:	b791                	j	462 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 520:	008b8493          	addi	s1,s7,8
 524:	4685                	li	a3,1
 526:	4629                	li	a2,10
 528:	000ba583          	lw	a1,0(s7)
 52c:	855a                	mv	a0,s6
 52e:	e55ff0ef          	jal	382 <printint>
        i += 1;
 532:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 534:	8ba6                	mv	s7,s1
      state = 0;
 536:	4981                	li	s3,0
        i += 1;
 538:	b72d                	j	462 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 53a:	06400793          	li	a5,100
 53e:	02f60763          	beq	a2,a5,56c <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 542:	07500793          	li	a5,117
 546:	06f60963          	beq	a2,a5,5b8 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 54a:	07800793          	li	a5,120
 54e:	faf61ee3          	bne	a2,a5,50a <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 552:	008b8493          	addi	s1,s7,8
 556:	4681                	li	a3,0
 558:	4641                	li	a2,16
 55a:	000ba583          	lw	a1,0(s7)
 55e:	855a                	mv	a0,s6
 560:	e23ff0ef          	jal	382 <printint>
        i += 2;
 564:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 566:	8ba6                	mv	s7,s1
      state = 0;
 568:	4981                	li	s3,0
        i += 2;
 56a:	bde5                	j	462 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 56c:	008b8493          	addi	s1,s7,8
 570:	4685                	li	a3,1
 572:	4629                	li	a2,10
 574:	000ba583          	lw	a1,0(s7)
 578:	855a                	mv	a0,s6
 57a:	e09ff0ef          	jal	382 <printint>
        i += 2;
 57e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 580:	8ba6                	mv	s7,s1
      state = 0;
 582:	4981                	li	s3,0
        i += 2;
 584:	bdf9                	j	462 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 586:	008b8493          	addi	s1,s7,8
 58a:	4681                	li	a3,0
 58c:	4629                	li	a2,10
 58e:	000ba583          	lw	a1,0(s7)
 592:	855a                	mv	a0,s6
 594:	defff0ef          	jal	382 <printint>
 598:	8ba6                	mv	s7,s1
      state = 0;
 59a:	4981                	li	s3,0
 59c:	b5d9                	j	462 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 59e:	008b8493          	addi	s1,s7,8
 5a2:	4681                	li	a3,0
 5a4:	4629                	li	a2,10
 5a6:	000ba583          	lw	a1,0(s7)
 5aa:	855a                	mv	a0,s6
 5ac:	dd7ff0ef          	jal	382 <printint>
        i += 1;
 5b0:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5b2:	8ba6                	mv	s7,s1
      state = 0;
 5b4:	4981                	li	s3,0
        i += 1;
 5b6:	b575                	j	462 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5b8:	008b8493          	addi	s1,s7,8
 5bc:	4681                	li	a3,0
 5be:	4629                	li	a2,10
 5c0:	000ba583          	lw	a1,0(s7)
 5c4:	855a                	mv	a0,s6
 5c6:	dbdff0ef          	jal	382 <printint>
        i += 2;
 5ca:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5cc:	8ba6                	mv	s7,s1
      state = 0;
 5ce:	4981                	li	s3,0
        i += 2;
 5d0:	bd49                	j	462 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 5d2:	008b8493          	addi	s1,s7,8
 5d6:	4681                	li	a3,0
 5d8:	4641                	li	a2,16
 5da:	000ba583          	lw	a1,0(s7)
 5de:	855a                	mv	a0,s6
 5e0:	da3ff0ef          	jal	382 <printint>
 5e4:	8ba6                	mv	s7,s1
      state = 0;
 5e6:	4981                	li	s3,0
 5e8:	bdad                	j	462 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5ea:	008b8493          	addi	s1,s7,8
 5ee:	4681                	li	a3,0
 5f0:	4641                	li	a2,16
 5f2:	000ba583          	lw	a1,0(s7)
 5f6:	855a                	mv	a0,s6
 5f8:	d8bff0ef          	jal	382 <printint>
        i += 1;
 5fc:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5fe:	8ba6                	mv	s7,s1
      state = 0;
 600:	4981                	li	s3,0
        i += 1;
 602:	b585                	j	462 <vprintf+0x4a>
 604:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 606:	008b8d13          	addi	s10,s7,8
 60a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 60e:	03000593          	li	a1,48
 612:	855a                	mv	a0,s6
 614:	d51ff0ef          	jal	364 <putc>
  putc(fd, 'x');
 618:	07800593          	li	a1,120
 61c:	855a                	mv	a0,s6
 61e:	d47ff0ef          	jal	364 <putc>
 622:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 624:	00000b97          	auipc	s7,0x0
 628:	254b8b93          	addi	s7,s7,596 # 878 <digits>
 62c:	03c9d793          	srli	a5,s3,0x3c
 630:	97de                	add	a5,a5,s7
 632:	0007c583          	lbu	a1,0(a5)
 636:	855a                	mv	a0,s6
 638:	d2dff0ef          	jal	364 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 63c:	0992                	slli	s3,s3,0x4
 63e:	34fd                	addiw	s1,s1,-1
 640:	f4f5                	bnez	s1,62c <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 642:	8bea                	mv	s7,s10
      state = 0;
 644:	4981                	li	s3,0
 646:	6d02                	ld	s10,0(sp)
 648:	bd29                	j	462 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 64a:	008b8993          	addi	s3,s7,8
 64e:	000bb483          	ld	s1,0(s7)
 652:	cc91                	beqz	s1,66e <vprintf+0x256>
        for(; *s; s++)
 654:	0004c583          	lbu	a1,0(s1)
 658:	c195                	beqz	a1,67c <vprintf+0x264>
          putc(fd, *s);
 65a:	855a                	mv	a0,s6
 65c:	d09ff0ef          	jal	364 <putc>
        for(; *s; s++)
 660:	0485                	addi	s1,s1,1
 662:	0004c583          	lbu	a1,0(s1)
 666:	f9f5                	bnez	a1,65a <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 668:	8bce                	mv	s7,s3
      state = 0;
 66a:	4981                	li	s3,0
 66c:	bbdd                	j	462 <vprintf+0x4a>
          s = "(null)";
 66e:	00000497          	auipc	s1,0x0
 672:	20248493          	addi	s1,s1,514 # 870 <malloc+0xf2>
        for(; *s; s++)
 676:	02800593          	li	a1,40
 67a:	b7c5                	j	65a <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 67c:	8bce                	mv	s7,s3
      state = 0;
 67e:	4981                	li	s3,0
 680:	b3cd                	j	462 <vprintf+0x4a>
 682:	6906                	ld	s2,64(sp)
 684:	79e2                	ld	s3,56(sp)
 686:	7a42                	ld	s4,48(sp)
 688:	7aa2                	ld	s5,40(sp)
 68a:	7b02                	ld	s6,32(sp)
 68c:	6be2                	ld	s7,24(sp)
 68e:	6c42                	ld	s8,16(sp)
 690:	6ca2                	ld	s9,8(sp)
    }
  }
}
 692:	60e6                	ld	ra,88(sp)
 694:	6446                	ld	s0,80(sp)
 696:	64a6                	ld	s1,72(sp)
 698:	6125                	addi	sp,sp,96
 69a:	8082                	ret

000000000000069c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 69c:	715d                	addi	sp,sp,-80
 69e:	ec06                	sd	ra,24(sp)
 6a0:	e822                	sd	s0,16(sp)
 6a2:	1000                	addi	s0,sp,32
 6a4:	e010                	sd	a2,0(s0)
 6a6:	e414                	sd	a3,8(s0)
 6a8:	e818                	sd	a4,16(s0)
 6aa:	ec1c                	sd	a5,24(s0)
 6ac:	03043023          	sd	a6,32(s0)
 6b0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 6b4:	8622                	mv	a2,s0
 6b6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6ba:	d5fff0ef          	jal	418 <vprintf>
}
 6be:	60e2                	ld	ra,24(sp)
 6c0:	6442                	ld	s0,16(sp)
 6c2:	6161                	addi	sp,sp,80
 6c4:	8082                	ret

00000000000006c6 <printf>:

void
printf(const char *fmt, ...)
{
 6c6:	711d                	addi	sp,sp,-96
 6c8:	ec06                	sd	ra,24(sp)
 6ca:	e822                	sd	s0,16(sp)
 6cc:	1000                	addi	s0,sp,32
 6ce:	e40c                	sd	a1,8(s0)
 6d0:	e810                	sd	a2,16(s0)
 6d2:	ec14                	sd	a3,24(s0)
 6d4:	f018                	sd	a4,32(s0)
 6d6:	f41c                	sd	a5,40(s0)
 6d8:	03043823          	sd	a6,48(s0)
 6dc:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6e0:	00840613          	addi	a2,s0,8
 6e4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6e8:	85aa                	mv	a1,a0
 6ea:	4505                	li	a0,1
 6ec:	d2dff0ef          	jal	418 <vprintf>
}
 6f0:	60e2                	ld	ra,24(sp)
 6f2:	6442                	ld	s0,16(sp)
 6f4:	6125                	addi	sp,sp,96
 6f6:	8082                	ret

00000000000006f8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6f8:	1141                	addi	sp,sp,-16
 6fa:	e406                	sd	ra,8(sp)
 6fc:	e022                	sd	s0,0(sp)
 6fe:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 700:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 704:	00001797          	auipc	a5,0x1
 708:	8fc7b783          	ld	a5,-1796(a5) # 1000 <freep>
 70c:	a02d                	j	736 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 70e:	4618                	lw	a4,8(a2)
 710:	9f2d                	addw	a4,a4,a1
 712:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 716:	6398                	ld	a4,0(a5)
 718:	6310                	ld	a2,0(a4)
 71a:	a83d                	j	758 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 71c:	ff852703          	lw	a4,-8(a0)
 720:	9f31                	addw	a4,a4,a2
 722:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 724:	ff053683          	ld	a3,-16(a0)
 728:	a091                	j	76c <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 72a:	6398                	ld	a4,0(a5)
 72c:	00e7e463          	bltu	a5,a4,734 <free+0x3c>
 730:	00e6ea63          	bltu	a3,a4,744 <free+0x4c>
{
 734:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 736:	fed7fae3          	bgeu	a5,a3,72a <free+0x32>
 73a:	6398                	ld	a4,0(a5)
 73c:	00e6e463          	bltu	a3,a4,744 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 740:	fee7eae3          	bltu	a5,a4,734 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 744:	ff852583          	lw	a1,-8(a0)
 748:	6390                	ld	a2,0(a5)
 74a:	02059813          	slli	a6,a1,0x20
 74e:	01c85713          	srli	a4,a6,0x1c
 752:	9736                	add	a4,a4,a3
 754:	fae60de3          	beq	a2,a4,70e <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 758:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 75c:	4790                	lw	a2,8(a5)
 75e:	02061593          	slli	a1,a2,0x20
 762:	01c5d713          	srli	a4,a1,0x1c
 766:	973e                	add	a4,a4,a5
 768:	fae68ae3          	beq	a3,a4,71c <free+0x24>
    p->s.ptr = bp->s.ptr;
 76c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 76e:	00001717          	auipc	a4,0x1
 772:	88f73923          	sd	a5,-1902(a4) # 1000 <freep>
}
 776:	60a2                	ld	ra,8(sp)
 778:	6402                	ld	s0,0(sp)
 77a:	0141                	addi	sp,sp,16
 77c:	8082                	ret

000000000000077e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 77e:	7139                	addi	sp,sp,-64
 780:	fc06                	sd	ra,56(sp)
 782:	f822                	sd	s0,48(sp)
 784:	f04a                	sd	s2,32(sp)
 786:	ec4e                	sd	s3,24(sp)
 788:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 78a:	02051993          	slli	s3,a0,0x20
 78e:	0209d993          	srli	s3,s3,0x20
 792:	09bd                	addi	s3,s3,15
 794:	0049d993          	srli	s3,s3,0x4
 798:	2985                	addiw	s3,s3,1
 79a:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 79c:	00001517          	auipc	a0,0x1
 7a0:	86453503          	ld	a0,-1948(a0) # 1000 <freep>
 7a4:	c905                	beqz	a0,7d4 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7a8:	4798                	lw	a4,8(a5)
 7aa:	09377663          	bgeu	a4,s3,836 <malloc+0xb8>
 7ae:	f426                	sd	s1,40(sp)
 7b0:	e852                	sd	s4,16(sp)
 7b2:	e456                	sd	s5,8(sp)
 7b4:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7b6:	8a4e                	mv	s4,s3
 7b8:	6705                	lui	a4,0x1
 7ba:	00e9f363          	bgeu	s3,a4,7c0 <malloc+0x42>
 7be:	6a05                	lui	s4,0x1
 7c0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7c4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7c8:	00001497          	auipc	s1,0x1
 7cc:	83848493          	addi	s1,s1,-1992 # 1000 <freep>
  if(p == (char*)-1)
 7d0:	5afd                	li	s5,-1
 7d2:	a83d                	j	810 <malloc+0x92>
 7d4:	f426                	sd	s1,40(sp)
 7d6:	e852                	sd	s4,16(sp)
 7d8:	e456                	sd	s5,8(sp)
 7da:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7dc:	00001797          	auipc	a5,0x1
 7e0:	83478793          	addi	a5,a5,-1996 # 1010 <base>
 7e4:	00001717          	auipc	a4,0x1
 7e8:	80f73e23          	sd	a5,-2020(a4) # 1000 <freep>
 7ec:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7ee:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7f2:	b7d1                	j	7b6 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 7f4:	6398                	ld	a4,0(a5)
 7f6:	e118                	sd	a4,0(a0)
 7f8:	a899                	j	84e <malloc+0xd0>
  hp->s.size = nu;
 7fa:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7fe:	0541                	addi	a0,a0,16
 800:	ef9ff0ef          	jal	6f8 <free>
  return freep;
 804:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 806:	c125                	beqz	a0,866 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 808:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 80a:	4798                	lw	a4,8(a5)
 80c:	03277163          	bgeu	a4,s2,82e <malloc+0xb0>
    if(p == freep)
 810:	6098                	ld	a4,0(s1)
 812:	853e                	mv	a0,a5
 814:	fef71ae3          	bne	a4,a5,808 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 818:	8552                	mv	a0,s4
 81a:	b2bff0ef          	jal	344 <sbrk>
  if(p == (char*)-1)
 81e:	fd551ee3          	bne	a0,s5,7fa <malloc+0x7c>
        return 0;
 822:	4501                	li	a0,0
 824:	74a2                	ld	s1,40(sp)
 826:	6a42                	ld	s4,16(sp)
 828:	6aa2                	ld	s5,8(sp)
 82a:	6b02                	ld	s6,0(sp)
 82c:	a03d                	j	85a <malloc+0xdc>
 82e:	74a2                	ld	s1,40(sp)
 830:	6a42                	ld	s4,16(sp)
 832:	6aa2                	ld	s5,8(sp)
 834:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 836:	fae90fe3          	beq	s2,a4,7f4 <malloc+0x76>
        p->s.size -= nunits;
 83a:	4137073b          	subw	a4,a4,s3
 83e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 840:	02071693          	slli	a3,a4,0x20
 844:	01c6d713          	srli	a4,a3,0x1c
 848:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 84a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 84e:	00000717          	auipc	a4,0x0
 852:	7aa73923          	sd	a0,1970(a4) # 1000 <freep>
      return (void*)(p + 1);
 856:	01078513          	addi	a0,a5,16
  }
}
 85a:	70e2                	ld	ra,56(sp)
 85c:	7442                	ld	s0,48(sp)
 85e:	7902                	ld	s2,32(sp)
 860:	69e2                	ld	s3,24(sp)
 862:	6121                	addi	sp,sp,64
 864:	8082                	ret
 866:	74a2                	ld	s1,40(sp)
 868:	6a42                	ld	s4,16(sp)
 86a:	6aa2                	ld	s5,8(sp)
 86c:	6b02                	ld	s6,0(sp)
 86e:	b7f5                	j	85a <malloc+0xdc>
