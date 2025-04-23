
user/_bigfile:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fcntl.h"
#include "kernel/fs.h"

int
main()
{
   0:	bb010113          	addi	sp,sp,-1104
   4:	44113423          	sd	ra,1096(sp)
   8:	44813023          	sd	s0,1088(sp)
   c:	45010413          	addi	s0,sp,1104
  char buf[BSIZE];
  int fd, i, blocks, readblocks;

  fd = open("big.file", O_CREATE | O_WRONLY);
  10:	20100593          	li	a1,513
  14:	00001517          	auipc	a0,0x1
  18:	a1c50513          	addi	a0,a0,-1508 # a30 <malloc+0x100>
  1c:	492000ef          	jal	4ae <open>
  if(fd < 0){
  20:	06054a63          	bltz	a0,94 <main+0x94>
  24:	42913c23          	sd	s1,1080(sp)
  28:	43213823          	sd	s2,1072(sp)
  2c:	43313423          	sd	s3,1064(sp)
  30:	43413023          	sd	s4,1056(sp)
  34:	41513c23          	sd	s5,1048(sp)
  38:	41613823          	sd	s6,1040(sp)
  3c:	41713423          	sd	s7,1032(sp)
  40:	892a                	mv	s2,a0
  42:	4481                	li	s1,0
  }

  blocks = 0;
  while(1){
    *(int*)buf = blocks;
    int cc = write(fd, buf, sizeof(buf));
  44:	bb040a93          	addi	s5,s0,-1104
  48:	40000a13          	li	s4,1024
    if(cc <= 0)
      break;
    blocks++;
    if (blocks % 100 == 0)
  4c:	51eb89b7          	lui	s3,0x51eb8
  50:	51f98993          	addi	s3,s3,1311 # 51eb851f <base+0x51eb750f>
  54:	06400b13          	li	s6,100
      printf(".");
  58:	00001b97          	auipc	s7,0x1
  5c:	a18b8b93          	addi	s7,s7,-1512 # a70 <malloc+0x140>
    *(int*)buf = blocks;
  60:	ba942823          	sw	s1,-1104(s0)
    int cc = write(fd, buf, sizeof(buf));
  64:	8652                	mv	a2,s4
  66:	85d6                	mv	a1,s5
  68:	854a                	mv	a0,s2
  6a:	424000ef          	jal	48e <write>
    if(cc <= 0)
  6e:	04a05c63          	blez	a0,c6 <main+0xc6>
    blocks++;
  72:	0014871b          	addiw	a4,s1,1
  76:	84ba                	mv	s1,a4
    if (blocks % 100 == 0)
  78:	033707b3          	mul	a5,a4,s3
  7c:	9795                	srai	a5,a5,0x25
  7e:	41f7569b          	sraiw	a3,a4,0x1f
  82:	9f95                	subw	a5,a5,a3
  84:	02fb07bb          	mulw	a5,s6,a5
  88:	9f1d                	subw	a4,a4,a5
  8a:	fb79                	bnez	a4,60 <main+0x60>
      printf(".");
  8c:	855e                	mv	a0,s7
  8e:	7ea000ef          	jal	878 <printf>
  92:	b7f9                	j	60 <main+0x60>
  94:	42913c23          	sd	s1,1080(sp)
  98:	43213823          	sd	s2,1072(sp)
  9c:	43313423          	sd	s3,1064(sp)
  a0:	43413023          	sd	s4,1056(sp)
  a4:	41513c23          	sd	s5,1048(sp)
  a8:	41613823          	sd	s6,1040(sp)
  ac:	41713423          	sd	s7,1032(sp)
  b0:	41813023          	sd	s8,1024(sp)
    printf("bigfile: cannot open big.file for writing\n");
  b4:	00001517          	auipc	a0,0x1
  b8:	98c50513          	addi	a0,a0,-1652 # a40 <malloc+0x110>
  bc:	7bc000ef          	jal	878 <printf>
    exit(-1);
  c0:	557d                	li	a0,-1
  c2:	3ac000ef          	jal	46e <exit>
  }

  printf("\nwrote %d blocks\n", blocks);
  c6:	85a6                	mv	a1,s1
  c8:	00001517          	auipc	a0,0x1
  cc:	9b050513          	addi	a0,a0,-1616 # a78 <malloc+0x148>
  d0:	7a8000ef          	jal	878 <printf>
  if(blocks != 65803) {
  d4:	67c1                	lui	a5,0x10
  d6:	10b78793          	addi	a5,a5,267 # 1010b <base+0xf0fb>
  da:	00f48d63          	beq	s1,a5,f4 <main+0xf4>
  de:	41813023          	sd	s8,1024(sp)
    printf("bigfile: file is too small\n");
  e2:	00001517          	auipc	a0,0x1
  e6:	9ae50513          	addi	a0,a0,-1618 # a90 <malloc+0x160>
  ea:	78e000ef          	jal	878 <printf>
    exit(-1);
  ee:	557d                	li	a0,-1
  f0:	37e000ef          	jal	46e <exit>
  }
  
  close(fd);
  f4:	854a                	mv	a0,s2
  f6:	3a0000ef          	jal	496 <close>
  fd = open("big.file", O_RDONLY);
  fa:	4581                	li	a1,0
  fc:	00001517          	auipc	a0,0x1
 100:	93450513          	addi	a0,a0,-1740 # a30 <malloc+0x100>
 104:	3aa000ef          	jal	4ae <open>
 108:	892a                	mv	s2,a0
  printf("reading bigfile\n");
 10a:	00001517          	auipc	a0,0x1
 10e:	9a650513          	addi	a0,a0,-1626 # ab0 <malloc+0x180>
 112:	766000ef          	jal	878 <printf>
  if(fd < 0){
    printf("bigfile: cannot re-open big.file for reading\n");
    exit(-1);
  }
  readblocks = 0;
 116:	4481                	li	s1,0
  if(fd < 0){
 118:	02094663          	bltz	s2,144 <main+0x144>
 11c:	41813023          	sd	s8,1024(sp)
  for(i = 0; i < blocks; i++){
    int cc = read(fd, buf, sizeof(buf));
 120:	bb040b13          	addi	s6,s0,-1104
 124:	40000a93          	li	s5,1024
      printf("bigfile: read the wrong data (%d) for block %d\n",
             *(int*)buf, i);
      exit(-1);
    }
    readblocks++;
    if (readblocks % 100 == 0)
 128:	51eb8a37          	lui	s4,0x51eb8
 12c:	51fa0a13          	addi	s4,s4,1311 # 51eb851f <base+0x51eb750f>
 130:	06400b93          	li	s7,100
      printf(".");
 134:	00001c17          	auipc	s8,0x1
 138:	93cc0c13          	addi	s8,s8,-1732 # a70 <malloc+0x140>
  for(i = 0; i < blocks; i++){
 13c:	69c1                	lui	s3,0x10
 13e:	10b98993          	addi	s3,s3,267 # 1010b <base+0xf0fb>
 142:	a091                	j	186 <main+0x186>
 144:	41813023          	sd	s8,1024(sp)
    printf("bigfile: cannot re-open big.file for reading\n");
 148:	00001517          	auipc	a0,0x1
 14c:	98050513          	addi	a0,a0,-1664 # ac8 <malloc+0x198>
 150:	728000ef          	jal	878 <printf>
    exit(-1);
 154:	557d                	li	a0,-1
 156:	318000ef          	jal	46e <exit>
      printf("bigfile: read error at block %d\n", i);
 15a:	85a6                	mv	a1,s1
 15c:	00001517          	auipc	a0,0x1
 160:	99c50513          	addi	a0,a0,-1636 # af8 <malloc+0x1c8>
 164:	714000ef          	jal	878 <printf>
      exit(-1);
 168:	557d                	li	a0,-1
 16a:	304000ef          	jal	46e <exit>
      printf("bigfile: read the wrong data (%d) for block %d\n",
 16e:	8626                	mv	a2,s1
 170:	00001517          	auipc	a0,0x1
 174:	9b050513          	addi	a0,a0,-1616 # b20 <malloc+0x1f0>
 178:	700000ef          	jal	878 <printf>
      exit(-1);
 17c:	557d                	li	a0,-1
 17e:	2f0000ef          	jal	46e <exit>
  for(i = 0; i < blocks; i++){
 182:	03348e63          	beq	s1,s3,1be <main+0x1be>
    int cc = read(fd, buf, sizeof(buf));
 186:	8656                	mv	a2,s5
 188:	85da                	mv	a1,s6
 18a:	854a                	mv	a0,s2
 18c:	2fa000ef          	jal	486 <read>
    if(cc <= 0){
 190:	fca055e3          	blez	a0,15a <main+0x15a>
    if(*(int*)buf != i){
 194:	bb042583          	lw	a1,-1104(s0)
 198:	fc959be3          	bne	a1,s1,16e <main+0x16e>
    readblocks++;
 19c:	0014871b          	addiw	a4,s1,1
 1a0:	84ba                	mv	s1,a4
    if (readblocks % 100 == 0)
 1a2:	034707b3          	mul	a5,a4,s4
 1a6:	9795                	srai	a5,a5,0x25
 1a8:	41f7569b          	sraiw	a3,a4,0x1f
 1ac:	9f95                	subw	a5,a5,a3
 1ae:	02fb87bb          	mulw	a5,s7,a5
 1b2:	9f1d                	subw	a4,a4,a5
 1b4:	f779                	bnez	a4,182 <main+0x182>
      printf(".");
 1b6:	8562                	mv	a0,s8
 1b8:	6c0000ef          	jal	878 <printf>
 1bc:	b7d9                	j	182 <main+0x182>
  }

  printf("\nbigfile done; ok\n"); 
 1be:	00001517          	auipc	a0,0x1
 1c2:	99250513          	addi	a0,a0,-1646 # b50 <malloc+0x220>
 1c6:	6b2000ef          	jal	878 <printf>

  exit(0);
 1ca:	4501                	li	a0,0
 1cc:	2a2000ef          	jal	46e <exit>

00000000000001d0 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 1d0:	1141                	addi	sp,sp,-16
 1d2:	e406                	sd	ra,8(sp)
 1d4:	e022                	sd	s0,0(sp)
 1d6:	0800                	addi	s0,sp,16
  extern int main();
  main();
 1d8:	e29ff0ef          	jal	0 <main>
  exit(0);
 1dc:	4501                	li	a0,0
 1de:	290000ef          	jal	46e <exit>

00000000000001e2 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1e2:	1141                	addi	sp,sp,-16
 1e4:	e406                	sd	ra,8(sp)
 1e6:	e022                	sd	s0,0(sp)
 1e8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1ea:	87aa                	mv	a5,a0
 1ec:	0585                	addi	a1,a1,1
 1ee:	0785                	addi	a5,a5,1
 1f0:	fff5c703          	lbu	a4,-1(a1)
 1f4:	fee78fa3          	sb	a4,-1(a5)
 1f8:	fb75                	bnez	a4,1ec <strcpy+0xa>
    ;
  return os;
}
 1fa:	60a2                	ld	ra,8(sp)
 1fc:	6402                	ld	s0,0(sp)
 1fe:	0141                	addi	sp,sp,16
 200:	8082                	ret

0000000000000202 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 202:	1141                	addi	sp,sp,-16
 204:	e406                	sd	ra,8(sp)
 206:	e022                	sd	s0,0(sp)
 208:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 20a:	00054783          	lbu	a5,0(a0)
 20e:	cb91                	beqz	a5,222 <strcmp+0x20>
 210:	0005c703          	lbu	a4,0(a1)
 214:	00f71763          	bne	a4,a5,222 <strcmp+0x20>
    p++, q++;
 218:	0505                	addi	a0,a0,1
 21a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 21c:	00054783          	lbu	a5,0(a0)
 220:	fbe5                	bnez	a5,210 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 222:	0005c503          	lbu	a0,0(a1)
}
 226:	40a7853b          	subw	a0,a5,a0
 22a:	60a2                	ld	ra,8(sp)
 22c:	6402                	ld	s0,0(sp)
 22e:	0141                	addi	sp,sp,16
 230:	8082                	ret

0000000000000232 <strlen>:

uint
strlen(const char *s)
{
 232:	1141                	addi	sp,sp,-16
 234:	e406                	sd	ra,8(sp)
 236:	e022                	sd	s0,0(sp)
 238:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 23a:	00054783          	lbu	a5,0(a0)
 23e:	cf99                	beqz	a5,25c <strlen+0x2a>
 240:	0505                	addi	a0,a0,1
 242:	87aa                	mv	a5,a0
 244:	86be                	mv	a3,a5
 246:	0785                	addi	a5,a5,1
 248:	fff7c703          	lbu	a4,-1(a5)
 24c:	ff65                	bnez	a4,244 <strlen+0x12>
 24e:	40a6853b          	subw	a0,a3,a0
 252:	2505                	addiw	a0,a0,1
    ;
  return n;
}
 254:	60a2                	ld	ra,8(sp)
 256:	6402                	ld	s0,0(sp)
 258:	0141                	addi	sp,sp,16
 25a:	8082                	ret
  for(n = 0; s[n]; n++)
 25c:	4501                	li	a0,0
 25e:	bfdd                	j	254 <strlen+0x22>

0000000000000260 <memset>:

void*
memset(void *dst, int c, uint n)
{
 260:	1141                	addi	sp,sp,-16
 262:	e406                	sd	ra,8(sp)
 264:	e022                	sd	s0,0(sp)
 266:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 268:	ca19                	beqz	a2,27e <memset+0x1e>
 26a:	87aa                	mv	a5,a0
 26c:	1602                	slli	a2,a2,0x20
 26e:	9201                	srli	a2,a2,0x20
 270:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 274:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 278:	0785                	addi	a5,a5,1
 27a:	fee79de3          	bne	a5,a4,274 <memset+0x14>
  }
  return dst;
}
 27e:	60a2                	ld	ra,8(sp)
 280:	6402                	ld	s0,0(sp)
 282:	0141                	addi	sp,sp,16
 284:	8082                	ret

0000000000000286 <strchr>:

char*
strchr(const char *s, char c)
{
 286:	1141                	addi	sp,sp,-16
 288:	e406                	sd	ra,8(sp)
 28a:	e022                	sd	s0,0(sp)
 28c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 28e:	00054783          	lbu	a5,0(a0)
 292:	cf81                	beqz	a5,2aa <strchr+0x24>
    if(*s == c)
 294:	00f58763          	beq	a1,a5,2a2 <strchr+0x1c>
  for(; *s; s++)
 298:	0505                	addi	a0,a0,1
 29a:	00054783          	lbu	a5,0(a0)
 29e:	fbfd                	bnez	a5,294 <strchr+0xe>
      return (char*)s;
  return 0;
 2a0:	4501                	li	a0,0
}
 2a2:	60a2                	ld	ra,8(sp)
 2a4:	6402                	ld	s0,0(sp)
 2a6:	0141                	addi	sp,sp,16
 2a8:	8082                	ret
  return 0;
 2aa:	4501                	li	a0,0
 2ac:	bfdd                	j	2a2 <strchr+0x1c>

00000000000002ae <gets>:

char*
gets(char *buf, int max)
{
 2ae:	7159                	addi	sp,sp,-112
 2b0:	f486                	sd	ra,104(sp)
 2b2:	f0a2                	sd	s0,96(sp)
 2b4:	eca6                	sd	s1,88(sp)
 2b6:	e8ca                	sd	s2,80(sp)
 2b8:	e4ce                	sd	s3,72(sp)
 2ba:	e0d2                	sd	s4,64(sp)
 2bc:	fc56                	sd	s5,56(sp)
 2be:	f85a                	sd	s6,48(sp)
 2c0:	f45e                	sd	s7,40(sp)
 2c2:	f062                	sd	s8,32(sp)
 2c4:	ec66                	sd	s9,24(sp)
 2c6:	e86a                	sd	s10,16(sp)
 2c8:	1880                	addi	s0,sp,112
 2ca:	8caa                	mv	s9,a0
 2cc:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2ce:	892a                	mv	s2,a0
 2d0:	4481                	li	s1,0
    cc = read(0, &c, 1);
 2d2:	f9f40b13          	addi	s6,s0,-97
 2d6:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2d8:	4ba9                	li	s7,10
 2da:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
 2dc:	8d26                	mv	s10,s1
 2de:	0014899b          	addiw	s3,s1,1
 2e2:	84ce                	mv	s1,s3
 2e4:	0349d563          	bge	s3,s4,30e <gets+0x60>
    cc = read(0, &c, 1);
 2e8:	8656                	mv	a2,s5
 2ea:	85da                	mv	a1,s6
 2ec:	4501                	li	a0,0
 2ee:	198000ef          	jal	486 <read>
    if(cc < 1)
 2f2:	00a05e63          	blez	a0,30e <gets+0x60>
    buf[i++] = c;
 2f6:	f9f44783          	lbu	a5,-97(s0)
 2fa:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2fe:	01778763          	beq	a5,s7,30c <gets+0x5e>
 302:	0905                	addi	s2,s2,1
 304:	fd879ce3          	bne	a5,s8,2dc <gets+0x2e>
    buf[i++] = c;
 308:	8d4e                	mv	s10,s3
 30a:	a011                	j	30e <gets+0x60>
 30c:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
 30e:	9d66                	add	s10,s10,s9
 310:	000d0023          	sb	zero,0(s10)
  return buf;
}
 314:	8566                	mv	a0,s9
 316:	70a6                	ld	ra,104(sp)
 318:	7406                	ld	s0,96(sp)
 31a:	64e6                	ld	s1,88(sp)
 31c:	6946                	ld	s2,80(sp)
 31e:	69a6                	ld	s3,72(sp)
 320:	6a06                	ld	s4,64(sp)
 322:	7ae2                	ld	s5,56(sp)
 324:	7b42                	ld	s6,48(sp)
 326:	7ba2                	ld	s7,40(sp)
 328:	7c02                	ld	s8,32(sp)
 32a:	6ce2                	ld	s9,24(sp)
 32c:	6d42                	ld	s10,16(sp)
 32e:	6165                	addi	sp,sp,112
 330:	8082                	ret

0000000000000332 <stat>:

int
stat(const char *n, struct stat *st)
{
 332:	1101                	addi	sp,sp,-32
 334:	ec06                	sd	ra,24(sp)
 336:	e822                	sd	s0,16(sp)
 338:	e04a                	sd	s2,0(sp)
 33a:	1000                	addi	s0,sp,32
 33c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 33e:	4581                	li	a1,0
 340:	16e000ef          	jal	4ae <open>
  if(fd < 0)
 344:	02054263          	bltz	a0,368 <stat+0x36>
 348:	e426                	sd	s1,8(sp)
 34a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 34c:	85ca                	mv	a1,s2
 34e:	178000ef          	jal	4c6 <fstat>
 352:	892a                	mv	s2,a0
  close(fd);
 354:	8526                	mv	a0,s1
 356:	140000ef          	jal	496 <close>
  return r;
 35a:	64a2                	ld	s1,8(sp)
}
 35c:	854a                	mv	a0,s2
 35e:	60e2                	ld	ra,24(sp)
 360:	6442                	ld	s0,16(sp)
 362:	6902                	ld	s2,0(sp)
 364:	6105                	addi	sp,sp,32
 366:	8082                	ret
    return -1;
 368:	597d                	li	s2,-1
 36a:	bfcd                	j	35c <stat+0x2a>

000000000000036c <atoi>:

int
atoi(const char *s)
{
 36c:	1141                	addi	sp,sp,-16
 36e:	e406                	sd	ra,8(sp)
 370:	e022                	sd	s0,0(sp)
 372:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 374:	00054683          	lbu	a3,0(a0)
 378:	fd06879b          	addiw	a5,a3,-48
 37c:	0ff7f793          	zext.b	a5,a5
 380:	4625                	li	a2,9
 382:	02f66963          	bltu	a2,a5,3b4 <atoi+0x48>
 386:	872a                	mv	a4,a0
  n = 0;
 388:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 38a:	0705                	addi	a4,a4,1
 38c:	0025179b          	slliw	a5,a0,0x2
 390:	9fa9                	addw	a5,a5,a0
 392:	0017979b          	slliw	a5,a5,0x1
 396:	9fb5                	addw	a5,a5,a3
 398:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 39c:	00074683          	lbu	a3,0(a4)
 3a0:	fd06879b          	addiw	a5,a3,-48
 3a4:	0ff7f793          	zext.b	a5,a5
 3a8:	fef671e3          	bgeu	a2,a5,38a <atoi+0x1e>
  return n;
}
 3ac:	60a2                	ld	ra,8(sp)
 3ae:	6402                	ld	s0,0(sp)
 3b0:	0141                	addi	sp,sp,16
 3b2:	8082                	ret
  n = 0;
 3b4:	4501                	li	a0,0
 3b6:	bfdd                	j	3ac <atoi+0x40>

00000000000003b8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3b8:	1141                	addi	sp,sp,-16
 3ba:	e406                	sd	ra,8(sp)
 3bc:	e022                	sd	s0,0(sp)
 3be:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3c0:	02b57563          	bgeu	a0,a1,3ea <memmove+0x32>
    while(n-- > 0)
 3c4:	00c05f63          	blez	a2,3e2 <memmove+0x2a>
 3c8:	1602                	slli	a2,a2,0x20
 3ca:	9201                	srli	a2,a2,0x20
 3cc:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3d0:	872a                	mv	a4,a0
      *dst++ = *src++;
 3d2:	0585                	addi	a1,a1,1
 3d4:	0705                	addi	a4,a4,1
 3d6:	fff5c683          	lbu	a3,-1(a1)
 3da:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3de:	fee79ae3          	bne	a5,a4,3d2 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3e2:	60a2                	ld	ra,8(sp)
 3e4:	6402                	ld	s0,0(sp)
 3e6:	0141                	addi	sp,sp,16
 3e8:	8082                	ret
    dst += n;
 3ea:	00c50733          	add	a4,a0,a2
    src += n;
 3ee:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3f0:	fec059e3          	blez	a2,3e2 <memmove+0x2a>
 3f4:	fff6079b          	addiw	a5,a2,-1
 3f8:	1782                	slli	a5,a5,0x20
 3fa:	9381                	srli	a5,a5,0x20
 3fc:	fff7c793          	not	a5,a5
 400:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 402:	15fd                	addi	a1,a1,-1
 404:	177d                	addi	a4,a4,-1
 406:	0005c683          	lbu	a3,0(a1)
 40a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 40e:	fef71ae3          	bne	a4,a5,402 <memmove+0x4a>
 412:	bfc1                	j	3e2 <memmove+0x2a>

0000000000000414 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 414:	1141                	addi	sp,sp,-16
 416:	e406                	sd	ra,8(sp)
 418:	e022                	sd	s0,0(sp)
 41a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 41c:	ca0d                	beqz	a2,44e <memcmp+0x3a>
 41e:	fff6069b          	addiw	a3,a2,-1
 422:	1682                	slli	a3,a3,0x20
 424:	9281                	srli	a3,a3,0x20
 426:	0685                	addi	a3,a3,1
 428:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 42a:	00054783          	lbu	a5,0(a0)
 42e:	0005c703          	lbu	a4,0(a1)
 432:	00e79863          	bne	a5,a4,442 <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
 436:	0505                	addi	a0,a0,1
    p2++;
 438:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 43a:	fed518e3          	bne	a0,a3,42a <memcmp+0x16>
  }
  return 0;
 43e:	4501                	li	a0,0
 440:	a019                	j	446 <memcmp+0x32>
      return *p1 - *p2;
 442:	40e7853b          	subw	a0,a5,a4
}
 446:	60a2                	ld	ra,8(sp)
 448:	6402                	ld	s0,0(sp)
 44a:	0141                	addi	sp,sp,16
 44c:	8082                	ret
  return 0;
 44e:	4501                	li	a0,0
 450:	bfdd                	j	446 <memcmp+0x32>

0000000000000452 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 452:	1141                	addi	sp,sp,-16
 454:	e406                	sd	ra,8(sp)
 456:	e022                	sd	s0,0(sp)
 458:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 45a:	f5fff0ef          	jal	3b8 <memmove>
}
 45e:	60a2                	ld	ra,8(sp)
 460:	6402                	ld	s0,0(sp)
 462:	0141                	addi	sp,sp,16
 464:	8082                	ret

0000000000000466 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 466:	4885                	li	a7,1
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <exit>:
.global exit
exit:
 li a7, SYS_exit
 46e:	4889                	li	a7,2
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <wait>:
.global wait
wait:
 li a7, SYS_wait
 476:	488d                	li	a7,3
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 47e:	4891                	li	a7,4
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <read>:
.global read
read:
 li a7, SYS_read
 486:	4895                	li	a7,5
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <write>:
.global write
write:
 li a7, SYS_write
 48e:	48c1                	li	a7,16
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <close>:
.global close
close:
 li a7, SYS_close
 496:	48d5                	li	a7,21
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <kill>:
.global kill
kill:
 li a7, SYS_kill
 49e:	4899                	li	a7,6
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 4a6:	489d                	li	a7,7
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <open>:
.global open
open:
 li a7, SYS_open
 4ae:	48bd                	li	a7,15
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4b6:	48c5                	li	a7,17
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4be:	48c9                	li	a7,18
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4c6:	48a1                	li	a7,8
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <link>:
.global link
link:
 li a7, SYS_link
 4ce:	48cd                	li	a7,19
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4d6:	48d1                	li	a7,20
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4de:	48a5                	li	a7,9
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	8082                	ret

00000000000004e6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4e6:	48a9                	li	a7,10
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4ee:	48ad                	li	a7,11
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4f6:	48b1                	li	a7,12
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4fe:	48b5                	li	a7,13
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 506:	48b9                	li	a7,14
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
 50e:	48d9                	li	a7,22
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 516:	1101                	addi	sp,sp,-32
 518:	ec06                	sd	ra,24(sp)
 51a:	e822                	sd	s0,16(sp)
 51c:	1000                	addi	s0,sp,32
 51e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 522:	4605                	li	a2,1
 524:	fef40593          	addi	a1,s0,-17
 528:	f67ff0ef          	jal	48e <write>
}
 52c:	60e2                	ld	ra,24(sp)
 52e:	6442                	ld	s0,16(sp)
 530:	6105                	addi	sp,sp,32
 532:	8082                	ret

0000000000000534 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 534:	7139                	addi	sp,sp,-64
 536:	fc06                	sd	ra,56(sp)
 538:	f822                	sd	s0,48(sp)
 53a:	f426                	sd	s1,40(sp)
 53c:	f04a                	sd	s2,32(sp)
 53e:	ec4e                	sd	s3,24(sp)
 540:	0080                	addi	s0,sp,64
 542:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 544:	c299                	beqz	a3,54a <printint+0x16>
 546:	0605ce63          	bltz	a1,5c2 <printint+0x8e>
  neg = 0;
 54a:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 54c:	fc040313          	addi	t1,s0,-64
  neg = 0;
 550:	869a                	mv	a3,t1
  i = 0;
 552:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
 554:	00000817          	auipc	a6,0x0
 558:	61c80813          	addi	a6,a6,1564 # b70 <digits>
 55c:	88be                	mv	a7,a5
 55e:	0017851b          	addiw	a0,a5,1
 562:	87aa                	mv	a5,a0
 564:	02c5f73b          	remuw	a4,a1,a2
 568:	1702                	slli	a4,a4,0x20
 56a:	9301                	srli	a4,a4,0x20
 56c:	9742                	add	a4,a4,a6
 56e:	00074703          	lbu	a4,0(a4)
 572:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
 576:	872e                	mv	a4,a1
 578:	02c5d5bb          	divuw	a1,a1,a2
 57c:	0685                	addi	a3,a3,1
 57e:	fcc77fe3          	bgeu	a4,a2,55c <printint+0x28>
  if(neg)
 582:	000e0c63          	beqz	t3,59a <printint+0x66>
    buf[i++] = '-';
 586:	fd050793          	addi	a5,a0,-48
 58a:	00878533          	add	a0,a5,s0
 58e:	02d00793          	li	a5,45
 592:	fef50823          	sb	a5,-16(a0)
 596:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
 59a:	fff7899b          	addiw	s3,a5,-1
 59e:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
 5a2:	fff4c583          	lbu	a1,-1(s1)
 5a6:	854a                	mv	a0,s2
 5a8:	f6fff0ef          	jal	516 <putc>
  while(--i >= 0)
 5ac:	39fd                	addiw	s3,s3,-1
 5ae:	14fd                	addi	s1,s1,-1
 5b0:	fe09d9e3          	bgez	s3,5a2 <printint+0x6e>
}
 5b4:	70e2                	ld	ra,56(sp)
 5b6:	7442                	ld	s0,48(sp)
 5b8:	74a2                	ld	s1,40(sp)
 5ba:	7902                	ld	s2,32(sp)
 5bc:	69e2                	ld	s3,24(sp)
 5be:	6121                	addi	sp,sp,64
 5c0:	8082                	ret
    x = -xx;
 5c2:	40b005bb          	negw	a1,a1
    neg = 1;
 5c6:	4e05                	li	t3,1
    x = -xx;
 5c8:	b751                	j	54c <printint+0x18>

00000000000005ca <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5ca:	711d                	addi	sp,sp,-96
 5cc:	ec86                	sd	ra,88(sp)
 5ce:	e8a2                	sd	s0,80(sp)
 5d0:	e4a6                	sd	s1,72(sp)
 5d2:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5d4:	0005c483          	lbu	s1,0(a1)
 5d8:	26048663          	beqz	s1,844 <vprintf+0x27a>
 5dc:	e0ca                	sd	s2,64(sp)
 5de:	fc4e                	sd	s3,56(sp)
 5e0:	f852                	sd	s4,48(sp)
 5e2:	f456                	sd	s5,40(sp)
 5e4:	f05a                	sd	s6,32(sp)
 5e6:	ec5e                	sd	s7,24(sp)
 5e8:	e862                	sd	s8,16(sp)
 5ea:	e466                	sd	s9,8(sp)
 5ec:	8b2a                	mv	s6,a0
 5ee:	8a2e                	mv	s4,a1
 5f0:	8bb2                	mv	s7,a2
  state = 0;
 5f2:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5f4:	4901                	li	s2,0
 5f6:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5f8:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5fc:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 600:	06c00c93          	li	s9,108
 604:	a00d                	j	626 <vprintf+0x5c>
        putc(fd, c0);
 606:	85a6                	mv	a1,s1
 608:	855a                	mv	a0,s6
 60a:	f0dff0ef          	jal	516 <putc>
 60e:	a019                	j	614 <vprintf+0x4a>
    } else if(state == '%'){
 610:	03598363          	beq	s3,s5,636 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
 614:	0019079b          	addiw	a5,s2,1
 618:	893e                	mv	s2,a5
 61a:	873e                	mv	a4,a5
 61c:	97d2                	add	a5,a5,s4
 61e:	0007c483          	lbu	s1,0(a5)
 622:	20048963          	beqz	s1,834 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
 626:	0004879b          	sext.w	a5,s1
    if(state == 0){
 62a:	fe0993e3          	bnez	s3,610 <vprintf+0x46>
      if(c0 == '%'){
 62e:	fd579ce3          	bne	a5,s5,606 <vprintf+0x3c>
        state = '%';
 632:	89be                	mv	s3,a5
 634:	b7c5                	j	614 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
 636:	00ea06b3          	add	a3,s4,a4
 63a:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
 63e:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
 640:	c681                	beqz	a3,648 <vprintf+0x7e>
 642:	9752                	add	a4,a4,s4
 644:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
 648:	03878e63          	beq	a5,s8,684 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
 64c:	05978863          	beq	a5,s9,69c <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
 650:	07500713          	li	a4,117
 654:	0ee78263          	beq	a5,a4,738 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
 658:	07800713          	li	a4,120
 65c:	12e78463          	beq	a5,a4,784 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
 660:	07000713          	li	a4,112
 664:	14e78963          	beq	a5,a4,7b6 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
 668:	07300713          	li	a4,115
 66c:	18e78863          	beq	a5,a4,7fc <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
 670:	02500713          	li	a4,37
 674:	04e79463          	bne	a5,a4,6bc <vprintf+0xf2>
        putc(fd, '%');
 678:	85ba                	mv	a1,a4
 67a:	855a                	mv	a0,s6
 67c:	e9bff0ef          	jal	516 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
 680:	4981                	li	s3,0
 682:	bf49                	j	614 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
 684:	008b8493          	addi	s1,s7,8
 688:	4685                	li	a3,1
 68a:	4629                	li	a2,10
 68c:	000ba583          	lw	a1,0(s7)
 690:	855a                	mv	a0,s6
 692:	ea3ff0ef          	jal	534 <printint>
 696:	8ba6                	mv	s7,s1
      state = 0;
 698:	4981                	li	s3,0
 69a:	bfad                	j	614 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
 69c:	06400793          	li	a5,100
 6a0:	02f68963          	beq	a3,a5,6d2 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6a4:	06c00793          	li	a5,108
 6a8:	04f68263          	beq	a3,a5,6ec <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
 6ac:	07500793          	li	a5,117
 6b0:	0af68063          	beq	a3,a5,750 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
 6b4:	07800793          	li	a5,120
 6b8:	0ef68263          	beq	a3,a5,79c <vprintf+0x1d2>
        putc(fd, '%');
 6bc:	02500593          	li	a1,37
 6c0:	855a                	mv	a0,s6
 6c2:	e55ff0ef          	jal	516 <putc>
        putc(fd, c0);
 6c6:	85a6                	mv	a1,s1
 6c8:	855a                	mv	a0,s6
 6ca:	e4dff0ef          	jal	516 <putc>
      state = 0;
 6ce:	4981                	li	s3,0
 6d0:	b791                	j	614 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6d2:	008b8493          	addi	s1,s7,8
 6d6:	4685                	li	a3,1
 6d8:	4629                	li	a2,10
 6da:	000ba583          	lw	a1,0(s7)
 6de:	855a                	mv	a0,s6
 6e0:	e55ff0ef          	jal	534 <printint>
        i += 1;
 6e4:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6e6:	8ba6                	mv	s7,s1
      state = 0;
 6e8:	4981                	li	s3,0
        i += 1;
 6ea:	b72d                	j	614 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6ec:	06400793          	li	a5,100
 6f0:	02f60763          	beq	a2,a5,71e <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6f4:	07500793          	li	a5,117
 6f8:	06f60963          	beq	a2,a5,76a <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6fc:	07800793          	li	a5,120
 700:	faf61ee3          	bne	a2,a5,6bc <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
 704:	008b8493          	addi	s1,s7,8
 708:	4681                	li	a3,0
 70a:	4641                	li	a2,16
 70c:	000ba583          	lw	a1,0(s7)
 710:	855a                	mv	a0,s6
 712:	e23ff0ef          	jal	534 <printint>
        i += 2;
 716:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 718:	8ba6                	mv	s7,s1
      state = 0;
 71a:	4981                	li	s3,0
        i += 2;
 71c:	bde5                	j	614 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
 71e:	008b8493          	addi	s1,s7,8
 722:	4685                	li	a3,1
 724:	4629                	li	a2,10
 726:	000ba583          	lw	a1,0(s7)
 72a:	855a                	mv	a0,s6
 72c:	e09ff0ef          	jal	534 <printint>
        i += 2;
 730:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 732:	8ba6                	mv	s7,s1
      state = 0;
 734:	4981                	li	s3,0
        i += 2;
 736:	bdf9                	j	614 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
 738:	008b8493          	addi	s1,s7,8
 73c:	4681                	li	a3,0
 73e:	4629                	li	a2,10
 740:	000ba583          	lw	a1,0(s7)
 744:	855a                	mv	a0,s6
 746:	defff0ef          	jal	534 <printint>
 74a:	8ba6                	mv	s7,s1
      state = 0;
 74c:	4981                	li	s3,0
 74e:	b5d9                	j	614 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 750:	008b8493          	addi	s1,s7,8
 754:	4681                	li	a3,0
 756:	4629                	li	a2,10
 758:	000ba583          	lw	a1,0(s7)
 75c:	855a                	mv	a0,s6
 75e:	dd7ff0ef          	jal	534 <printint>
        i += 1;
 762:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 764:	8ba6                	mv	s7,s1
      state = 0;
 766:	4981                	li	s3,0
        i += 1;
 768:	b575                	j	614 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
 76a:	008b8493          	addi	s1,s7,8
 76e:	4681                	li	a3,0
 770:	4629                	li	a2,10
 772:	000ba583          	lw	a1,0(s7)
 776:	855a                	mv	a0,s6
 778:	dbdff0ef          	jal	534 <printint>
        i += 2;
 77c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 77e:	8ba6                	mv	s7,s1
      state = 0;
 780:	4981                	li	s3,0
        i += 2;
 782:	bd49                	j	614 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
 784:	008b8493          	addi	s1,s7,8
 788:	4681                	li	a3,0
 78a:	4641                	li	a2,16
 78c:	000ba583          	lw	a1,0(s7)
 790:	855a                	mv	a0,s6
 792:	da3ff0ef          	jal	534 <printint>
 796:	8ba6                	mv	s7,s1
      state = 0;
 798:	4981                	li	s3,0
 79a:	bdad                	j	614 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
 79c:	008b8493          	addi	s1,s7,8
 7a0:	4681                	li	a3,0
 7a2:	4641                	li	a2,16
 7a4:	000ba583          	lw	a1,0(s7)
 7a8:	855a                	mv	a0,s6
 7aa:	d8bff0ef          	jal	534 <printint>
        i += 1;
 7ae:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 7b0:	8ba6                	mv	s7,s1
      state = 0;
 7b2:	4981                	li	s3,0
        i += 1;
 7b4:	b585                	j	614 <vprintf+0x4a>
 7b6:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
 7b8:	008b8d13          	addi	s10,s7,8
 7bc:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7c0:	03000593          	li	a1,48
 7c4:	855a                	mv	a0,s6
 7c6:	d51ff0ef          	jal	516 <putc>
  putc(fd, 'x');
 7ca:	07800593          	li	a1,120
 7ce:	855a                	mv	a0,s6
 7d0:	d47ff0ef          	jal	516 <putc>
 7d4:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7d6:	00000b97          	auipc	s7,0x0
 7da:	39ab8b93          	addi	s7,s7,922 # b70 <digits>
 7de:	03c9d793          	srli	a5,s3,0x3c
 7e2:	97de                	add	a5,a5,s7
 7e4:	0007c583          	lbu	a1,0(a5)
 7e8:	855a                	mv	a0,s6
 7ea:	d2dff0ef          	jal	516 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7ee:	0992                	slli	s3,s3,0x4
 7f0:	34fd                	addiw	s1,s1,-1
 7f2:	f4f5                	bnez	s1,7de <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
 7f4:	8bea                	mv	s7,s10
      state = 0;
 7f6:	4981                	li	s3,0
 7f8:	6d02                	ld	s10,0(sp)
 7fa:	bd29                	j	614 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
 7fc:	008b8993          	addi	s3,s7,8
 800:	000bb483          	ld	s1,0(s7)
 804:	cc91                	beqz	s1,820 <vprintf+0x256>
        for(; *s; s++)
 806:	0004c583          	lbu	a1,0(s1)
 80a:	c195                	beqz	a1,82e <vprintf+0x264>
          putc(fd, *s);
 80c:	855a                	mv	a0,s6
 80e:	d09ff0ef          	jal	516 <putc>
        for(; *s; s++)
 812:	0485                	addi	s1,s1,1
 814:	0004c583          	lbu	a1,0(s1)
 818:	f9f5                	bnez	a1,80c <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 81a:	8bce                	mv	s7,s3
      state = 0;
 81c:	4981                	li	s3,0
 81e:	bbdd                	j	614 <vprintf+0x4a>
          s = "(null)";
 820:	00000497          	auipc	s1,0x0
 824:	34848493          	addi	s1,s1,840 # b68 <malloc+0x238>
        for(; *s; s++)
 828:	02800593          	li	a1,40
 82c:	b7c5                	j	80c <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
 82e:	8bce                	mv	s7,s3
      state = 0;
 830:	4981                	li	s3,0
 832:	b3cd                	j	614 <vprintf+0x4a>
 834:	6906                	ld	s2,64(sp)
 836:	79e2                	ld	s3,56(sp)
 838:	7a42                	ld	s4,48(sp)
 83a:	7aa2                	ld	s5,40(sp)
 83c:	7b02                	ld	s6,32(sp)
 83e:	6be2                	ld	s7,24(sp)
 840:	6c42                	ld	s8,16(sp)
 842:	6ca2                	ld	s9,8(sp)
    }
  }
}
 844:	60e6                	ld	ra,88(sp)
 846:	6446                	ld	s0,80(sp)
 848:	64a6                	ld	s1,72(sp)
 84a:	6125                	addi	sp,sp,96
 84c:	8082                	ret

000000000000084e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 84e:	715d                	addi	sp,sp,-80
 850:	ec06                	sd	ra,24(sp)
 852:	e822                	sd	s0,16(sp)
 854:	1000                	addi	s0,sp,32
 856:	e010                	sd	a2,0(s0)
 858:	e414                	sd	a3,8(s0)
 85a:	e818                	sd	a4,16(s0)
 85c:	ec1c                	sd	a5,24(s0)
 85e:	03043023          	sd	a6,32(s0)
 862:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 866:	8622                	mv	a2,s0
 868:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 86c:	d5fff0ef          	jal	5ca <vprintf>
}
 870:	60e2                	ld	ra,24(sp)
 872:	6442                	ld	s0,16(sp)
 874:	6161                	addi	sp,sp,80
 876:	8082                	ret

0000000000000878 <printf>:

void
printf(const char *fmt, ...)
{
 878:	711d                	addi	sp,sp,-96
 87a:	ec06                	sd	ra,24(sp)
 87c:	e822                	sd	s0,16(sp)
 87e:	1000                	addi	s0,sp,32
 880:	e40c                	sd	a1,8(s0)
 882:	e810                	sd	a2,16(s0)
 884:	ec14                	sd	a3,24(s0)
 886:	f018                	sd	a4,32(s0)
 888:	f41c                	sd	a5,40(s0)
 88a:	03043823          	sd	a6,48(s0)
 88e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 892:	00840613          	addi	a2,s0,8
 896:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 89a:	85aa                	mv	a1,a0
 89c:	4505                	li	a0,1
 89e:	d2dff0ef          	jal	5ca <vprintf>
}
 8a2:	60e2                	ld	ra,24(sp)
 8a4:	6442                	ld	s0,16(sp)
 8a6:	6125                	addi	sp,sp,96
 8a8:	8082                	ret

00000000000008aa <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8aa:	1141                	addi	sp,sp,-16
 8ac:	e406                	sd	ra,8(sp)
 8ae:	e022                	sd	s0,0(sp)
 8b0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8b2:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8b6:	00000797          	auipc	a5,0x0
 8ba:	74a7b783          	ld	a5,1866(a5) # 1000 <freep>
 8be:	a02d                	j	8e8 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 8c0:	4618                	lw	a4,8(a2)
 8c2:	9f2d                	addw	a4,a4,a1
 8c4:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8c8:	6398                	ld	a4,0(a5)
 8ca:	6310                	ld	a2,0(a4)
 8cc:	a83d                	j	90a <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 8ce:	ff852703          	lw	a4,-8(a0)
 8d2:	9f31                	addw	a4,a4,a2
 8d4:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8d6:	ff053683          	ld	a3,-16(a0)
 8da:	a091                	j	91e <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8dc:	6398                	ld	a4,0(a5)
 8de:	00e7e463          	bltu	a5,a4,8e6 <free+0x3c>
 8e2:	00e6ea63          	bltu	a3,a4,8f6 <free+0x4c>
{
 8e6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8e8:	fed7fae3          	bgeu	a5,a3,8dc <free+0x32>
 8ec:	6398                	ld	a4,0(a5)
 8ee:	00e6e463          	bltu	a3,a4,8f6 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8f2:	fee7eae3          	bltu	a5,a4,8e6 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
 8f6:	ff852583          	lw	a1,-8(a0)
 8fa:	6390                	ld	a2,0(a5)
 8fc:	02059813          	slli	a6,a1,0x20
 900:	01c85713          	srli	a4,a6,0x1c
 904:	9736                	add	a4,a4,a3
 906:	fae60de3          	beq	a2,a4,8c0 <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
 90a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 90e:	4790                	lw	a2,8(a5)
 910:	02061593          	slli	a1,a2,0x20
 914:	01c5d713          	srli	a4,a1,0x1c
 918:	973e                	add	a4,a4,a5
 91a:	fae68ae3          	beq	a3,a4,8ce <free+0x24>
    p->s.ptr = bp->s.ptr;
 91e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 920:	00000717          	auipc	a4,0x0
 924:	6ef73023          	sd	a5,1760(a4) # 1000 <freep>
}
 928:	60a2                	ld	ra,8(sp)
 92a:	6402                	ld	s0,0(sp)
 92c:	0141                	addi	sp,sp,16
 92e:	8082                	ret

0000000000000930 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 930:	7139                	addi	sp,sp,-64
 932:	fc06                	sd	ra,56(sp)
 934:	f822                	sd	s0,48(sp)
 936:	f04a                	sd	s2,32(sp)
 938:	ec4e                	sd	s3,24(sp)
 93a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 93c:	02051993          	slli	s3,a0,0x20
 940:	0209d993          	srli	s3,s3,0x20
 944:	09bd                	addi	s3,s3,15
 946:	0049d993          	srli	s3,s3,0x4
 94a:	2985                	addiw	s3,s3,1
 94c:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 94e:	00000517          	auipc	a0,0x0
 952:	6b253503          	ld	a0,1714(a0) # 1000 <freep>
 956:	c905                	beqz	a0,986 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 958:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 95a:	4798                	lw	a4,8(a5)
 95c:	09377663          	bgeu	a4,s3,9e8 <malloc+0xb8>
 960:	f426                	sd	s1,40(sp)
 962:	e852                	sd	s4,16(sp)
 964:	e456                	sd	s5,8(sp)
 966:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 968:	8a4e                	mv	s4,s3
 96a:	6705                	lui	a4,0x1
 96c:	00e9f363          	bgeu	s3,a4,972 <malloc+0x42>
 970:	6a05                	lui	s4,0x1
 972:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 976:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 97a:	00000497          	auipc	s1,0x0
 97e:	68648493          	addi	s1,s1,1670 # 1000 <freep>
  if(p == (char*)-1)
 982:	5afd                	li	s5,-1
 984:	a83d                	j	9c2 <malloc+0x92>
 986:	f426                	sd	s1,40(sp)
 988:	e852                	sd	s4,16(sp)
 98a:	e456                	sd	s5,8(sp)
 98c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 98e:	00000797          	auipc	a5,0x0
 992:	68278793          	addi	a5,a5,1666 # 1010 <base>
 996:	00000717          	auipc	a4,0x0
 99a:	66f73523          	sd	a5,1642(a4) # 1000 <freep>
 99e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9a0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9a4:	b7d1                	j	968 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 9a6:	6398                	ld	a4,0(a5)
 9a8:	e118                	sd	a4,0(a0)
 9aa:	a899                	j	a00 <malloc+0xd0>
  hp->s.size = nu;
 9ac:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9b0:	0541                	addi	a0,a0,16
 9b2:	ef9ff0ef          	jal	8aa <free>
  return freep;
 9b6:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 9b8:	c125                	beqz	a0,a18 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9ba:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9bc:	4798                	lw	a4,8(a5)
 9be:	03277163          	bgeu	a4,s2,9e0 <malloc+0xb0>
    if(p == freep)
 9c2:	6098                	ld	a4,0(s1)
 9c4:	853e                	mv	a0,a5
 9c6:	fef71ae3          	bne	a4,a5,9ba <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 9ca:	8552                	mv	a0,s4
 9cc:	b2bff0ef          	jal	4f6 <sbrk>
  if(p == (char*)-1)
 9d0:	fd551ee3          	bne	a0,s5,9ac <malloc+0x7c>
        return 0;
 9d4:	4501                	li	a0,0
 9d6:	74a2                	ld	s1,40(sp)
 9d8:	6a42                	ld	s4,16(sp)
 9da:	6aa2                	ld	s5,8(sp)
 9dc:	6b02                	ld	s6,0(sp)
 9de:	a03d                	j	a0c <malloc+0xdc>
 9e0:	74a2                	ld	s1,40(sp)
 9e2:	6a42                	ld	s4,16(sp)
 9e4:	6aa2                	ld	s5,8(sp)
 9e6:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 9e8:	fae90fe3          	beq	s2,a4,9a6 <malloc+0x76>
        p->s.size -= nunits;
 9ec:	4137073b          	subw	a4,a4,s3
 9f0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9f2:	02071693          	slli	a3,a4,0x20
 9f6:	01c6d713          	srli	a4,a3,0x1c
 9fa:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9fc:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a00:	00000717          	auipc	a4,0x0
 a04:	60a73023          	sd	a0,1536(a4) # 1000 <freep>
      return (void*)(p + 1);
 a08:	01078513          	addi	a0,a5,16
  }
}
 a0c:	70e2                	ld	ra,56(sp)
 a0e:	7442                	ld	s0,48(sp)
 a10:	7902                	ld	s2,32(sp)
 a12:	69e2                	ld	s3,24(sp)
 a14:	6121                	addi	sp,sp,64
 a16:	8082                	ret
 a18:	74a2                	ld	s1,40(sp)
 a1a:	6a42                	ld	s4,16(sp)
 a1c:	6aa2                	ld	s5,8(sp)
 a1e:	6b02                	ld	s6,0(sp)
 a20:	b7f5                	j	a0c <malloc+0xdc>
