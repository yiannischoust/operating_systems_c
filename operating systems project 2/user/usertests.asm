
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	711d                	addi	sp,sp,-96
       2:	ec86                	sd	ra,88(sp)
       4:	e8a2                	sd	s0,80(sp)
       6:	e4a6                	sd	s1,72(sp)
       8:	e0ca                	sd	s2,64(sp)
       a:	fc4e                	sd	s3,56(sp)
       c:	f852                	sd	s4,48(sp)
       e:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
      10:	00007797          	auipc	a5,0x7
      14:	64878793          	addi	a5,a5,1608 # 7658 <malloc+0x248e>
      18:	638c                	ld	a1,0(a5)
      1a:	6790                	ld	a2,8(a5)
      1c:	6b94                	ld	a3,16(a5)
      1e:	6f98                	ld	a4,24(a5)
      20:	739c                	ld	a5,32(a5)
      22:	fab43423          	sd	a1,-88(s0)
      26:	fac43823          	sd	a2,-80(s0)
      2a:	fad43c23          	sd	a3,-72(s0)
      2e:	fce43023          	sd	a4,-64(s0)
      32:	fcf43423          	sd	a5,-56(s0)
                     0xffffffffffffffff };

  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
      36:	fa840493          	addi	s1,s0,-88
      3a:	fd040a13          	addi	s4,s0,-48
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      3e:	20100993          	li	s3,513
      42:	0004b903          	ld	s2,0(s1)
      46:	85ce                	mv	a1,s3
      48:	854a                	mv	a0,s2
      4a:	4ff040ef          	jal	4d48 <open>
    if(fd >= 0){
      4e:	00055d63          	bgez	a0,68 <copyinstr1+0x68>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
      52:	04a1                	addi	s1,s1,8
      54:	ff4497e3          	bne	s1,s4,42 <copyinstr1+0x42>
      printf("open(%p) returned %d, not -1\n", (void*)addr, fd);
      exit(1);
    }
  }
}
      58:	60e6                	ld	ra,88(sp)
      5a:	6446                	ld	s0,80(sp)
      5c:	64a6                	ld	s1,72(sp)
      5e:	6906                	ld	s2,64(sp)
      60:	79e2                	ld	s3,56(sp)
      62:	7a42                	ld	s4,48(sp)
      64:	6125                	addi	sp,sp,96
      66:	8082                	ret
      printf("open(%p) returned %d, not -1\n", (void*)addr, fd);
      68:	862a                	mv	a2,a0
      6a:	85ca                	mv	a1,s2
      6c:	00005517          	auipc	a0,0x5
      70:	25450513          	addi	a0,a0,596 # 52c0 <malloc+0xf6>
      74:	09e050ef          	jal	5112 <printf>
      exit(1);
      78:	4505                	li	a0,1
      7a:	48f040ef          	jal	4d08 <exit>

000000000000007e <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      7e:	00009797          	auipc	a5,0x9
      82:	4ea78793          	addi	a5,a5,1258 # 9568 <uninit>
      86:	0000c697          	auipc	a3,0xc
      8a:	bf268693          	addi	a3,a3,-1038 # bc78 <buf>
    if(uninit[i] != '\0'){
      8e:	0007c703          	lbu	a4,0(a5)
      92:	e709                	bnez	a4,9c <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      94:	0785                	addi	a5,a5,1
      96:	fed79ce3          	bne	a5,a3,8e <bsstest+0x10>
      9a:	8082                	ret
{
      9c:	1141                	addi	sp,sp,-16
      9e:	e406                	sd	ra,8(sp)
      a0:	e022                	sd	s0,0(sp)
      a2:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      a4:	85aa                	mv	a1,a0
      a6:	00005517          	auipc	a0,0x5
      aa:	23a50513          	addi	a0,a0,570 # 52e0 <malloc+0x116>
      ae:	064050ef          	jal	5112 <printf>
      exit(1);
      b2:	4505                	li	a0,1
      b4:	455040ef          	jal	4d08 <exit>

00000000000000b8 <opentest>:
{
      b8:	1101                	addi	sp,sp,-32
      ba:	ec06                	sd	ra,24(sp)
      bc:	e822                	sd	s0,16(sp)
      be:	e426                	sd	s1,8(sp)
      c0:	1000                	addi	s0,sp,32
      c2:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      c4:	4581                	li	a1,0
      c6:	00005517          	auipc	a0,0x5
      ca:	23250513          	addi	a0,a0,562 # 52f8 <malloc+0x12e>
      ce:	47b040ef          	jal	4d48 <open>
  if(fd < 0){
      d2:	02054263          	bltz	a0,f6 <opentest+0x3e>
  close(fd);
      d6:	45b040ef          	jal	4d30 <close>
  fd = open("doesnotexist", 0);
      da:	4581                	li	a1,0
      dc:	00005517          	auipc	a0,0x5
      e0:	23c50513          	addi	a0,a0,572 # 5318 <malloc+0x14e>
      e4:	465040ef          	jal	4d48 <open>
  if(fd >= 0){
      e8:	02055163          	bgez	a0,10a <opentest+0x52>
}
      ec:	60e2                	ld	ra,24(sp)
      ee:	6442                	ld	s0,16(sp)
      f0:	64a2                	ld	s1,8(sp)
      f2:	6105                	addi	sp,sp,32
      f4:	8082                	ret
    printf("%s: open echo failed!\n", s);
      f6:	85a6                	mv	a1,s1
      f8:	00005517          	auipc	a0,0x5
      fc:	20850513          	addi	a0,a0,520 # 5300 <malloc+0x136>
     100:	012050ef          	jal	5112 <printf>
    exit(1);
     104:	4505                	li	a0,1
     106:	403040ef          	jal	4d08 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     10a:	85a6                	mv	a1,s1
     10c:	00005517          	auipc	a0,0x5
     110:	21c50513          	addi	a0,a0,540 # 5328 <malloc+0x15e>
     114:	7ff040ef          	jal	5112 <printf>
    exit(1);
     118:	4505                	li	a0,1
     11a:	3ef040ef          	jal	4d08 <exit>

000000000000011e <truncate2>:
{
     11e:	7179                	addi	sp,sp,-48
     120:	f406                	sd	ra,40(sp)
     122:	f022                	sd	s0,32(sp)
     124:	ec26                	sd	s1,24(sp)
     126:	e84a                	sd	s2,16(sp)
     128:	e44e                	sd	s3,8(sp)
     12a:	1800                	addi	s0,sp,48
     12c:	89aa                	mv	s3,a0
  unlink("truncfile");
     12e:	00005517          	auipc	a0,0x5
     132:	22250513          	addi	a0,a0,546 # 5350 <malloc+0x186>
     136:	423040ef          	jal	4d58 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     13a:	60100593          	li	a1,1537
     13e:	00005517          	auipc	a0,0x5
     142:	21250513          	addi	a0,a0,530 # 5350 <malloc+0x186>
     146:	403040ef          	jal	4d48 <open>
     14a:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     14c:	4611                	li	a2,4
     14e:	00005597          	auipc	a1,0x5
     152:	21258593          	addi	a1,a1,530 # 5360 <malloc+0x196>
     156:	3d3040ef          	jal	4d28 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     15a:	40100593          	li	a1,1025
     15e:	00005517          	auipc	a0,0x5
     162:	1f250513          	addi	a0,a0,498 # 5350 <malloc+0x186>
     166:	3e3040ef          	jal	4d48 <open>
     16a:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     16c:	4605                	li	a2,1
     16e:	00005597          	auipc	a1,0x5
     172:	1fa58593          	addi	a1,a1,506 # 5368 <malloc+0x19e>
     176:	8526                	mv	a0,s1
     178:	3b1040ef          	jal	4d28 <write>
  if(n != -1){
     17c:	57fd                	li	a5,-1
     17e:	02f51563          	bne	a0,a5,1a8 <truncate2+0x8a>
  unlink("truncfile");
     182:	00005517          	auipc	a0,0x5
     186:	1ce50513          	addi	a0,a0,462 # 5350 <malloc+0x186>
     18a:	3cf040ef          	jal	4d58 <unlink>
  close(fd1);
     18e:	8526                	mv	a0,s1
     190:	3a1040ef          	jal	4d30 <close>
  close(fd2);
     194:	854a                	mv	a0,s2
     196:	39b040ef          	jal	4d30 <close>
}
     19a:	70a2                	ld	ra,40(sp)
     19c:	7402                	ld	s0,32(sp)
     19e:	64e2                	ld	s1,24(sp)
     1a0:	6942                	ld	s2,16(sp)
     1a2:	69a2                	ld	s3,8(sp)
     1a4:	6145                	addi	sp,sp,48
     1a6:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1a8:	862a                	mv	a2,a0
     1aa:	85ce                	mv	a1,s3
     1ac:	00005517          	auipc	a0,0x5
     1b0:	1c450513          	addi	a0,a0,452 # 5370 <malloc+0x1a6>
     1b4:	75f040ef          	jal	5112 <printf>
    exit(1);
     1b8:	4505                	li	a0,1
     1ba:	34f040ef          	jal	4d08 <exit>

00000000000001be <createtest>:
{
     1be:	7139                	addi	sp,sp,-64
     1c0:	fc06                	sd	ra,56(sp)
     1c2:	f822                	sd	s0,48(sp)
     1c4:	f426                	sd	s1,40(sp)
     1c6:	f04a                	sd	s2,32(sp)
     1c8:	ec4e                	sd	s3,24(sp)
     1ca:	e852                	sd	s4,16(sp)
     1cc:	0080                	addi	s0,sp,64
  name[0] = 'a';
     1ce:	06100793          	li	a5,97
     1d2:	fcf40423          	sb	a5,-56(s0)
  name[2] = '\0';
     1d6:	fc040523          	sb	zero,-54(s0)
     1da:	03000493          	li	s1,48
    fd = open(name, O_CREATE|O_RDWR);
     1de:	fc840a13          	addi	s4,s0,-56
     1e2:	20200993          	li	s3,514
  for(i = 0; i < N; i++){
     1e6:	06400913          	li	s2,100
    name[1] = '0' + i;
     1ea:	fc9404a3          	sb	s1,-55(s0)
    fd = open(name, O_CREATE|O_RDWR);
     1ee:	85ce                	mv	a1,s3
     1f0:	8552                	mv	a0,s4
     1f2:	357040ef          	jal	4d48 <open>
    close(fd);
     1f6:	33b040ef          	jal	4d30 <close>
  for(i = 0; i < N; i++){
     1fa:	2485                	addiw	s1,s1,1
     1fc:	0ff4f493          	zext.b	s1,s1
     200:	ff2495e3          	bne	s1,s2,1ea <createtest+0x2c>
  name[0] = 'a';
     204:	06100793          	li	a5,97
     208:	fcf40423          	sb	a5,-56(s0)
  name[2] = '\0';
     20c:	fc040523          	sb	zero,-54(s0)
     210:	03000493          	li	s1,48
    unlink(name);
     214:	fc840993          	addi	s3,s0,-56
  for(i = 0; i < N; i++){
     218:	06400913          	li	s2,100
    name[1] = '0' + i;
     21c:	fc9404a3          	sb	s1,-55(s0)
    unlink(name);
     220:	854e                	mv	a0,s3
     222:	337040ef          	jal	4d58 <unlink>
  for(i = 0; i < N; i++){
     226:	2485                	addiw	s1,s1,1
     228:	0ff4f493          	zext.b	s1,s1
     22c:	ff2498e3          	bne	s1,s2,21c <createtest+0x5e>
}
     230:	70e2                	ld	ra,56(sp)
     232:	7442                	ld	s0,48(sp)
     234:	74a2                	ld	s1,40(sp)
     236:	7902                	ld	s2,32(sp)
     238:	69e2                	ld	s3,24(sp)
     23a:	6a42                	ld	s4,16(sp)
     23c:	6121                	addi	sp,sp,64
     23e:	8082                	ret

0000000000000240 <bigwrite>:
{
     240:	715d                	addi	sp,sp,-80
     242:	e486                	sd	ra,72(sp)
     244:	e0a2                	sd	s0,64(sp)
     246:	fc26                	sd	s1,56(sp)
     248:	f84a                	sd	s2,48(sp)
     24a:	f44e                	sd	s3,40(sp)
     24c:	f052                	sd	s4,32(sp)
     24e:	ec56                	sd	s5,24(sp)
     250:	e85a                	sd	s6,16(sp)
     252:	e45e                	sd	s7,8(sp)
     254:	e062                	sd	s8,0(sp)
     256:	0880                	addi	s0,sp,80
     258:	8c2a                	mv	s8,a0
  unlink("bigwrite");
     25a:	00005517          	auipc	a0,0x5
     25e:	13e50513          	addi	a0,a0,318 # 5398 <malloc+0x1ce>
     262:	2f7040ef          	jal	4d58 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     266:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     26a:	20200b93          	li	s7,514
     26e:	00005a97          	auipc	s5,0x5
     272:	12aa8a93          	addi	s5,s5,298 # 5398 <malloc+0x1ce>
      int cc = write(fd, buf, sz);
     276:	0000ca17          	auipc	s4,0xc
     27a:	a02a0a13          	addi	s4,s4,-1534 # bc78 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     27e:	6b0d                	lui	s6,0x3
     280:	1c9b0b13          	addi	s6,s6,457 # 31c9 <subdir+0x4c7>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     284:	85de                	mv	a1,s7
     286:	8556                	mv	a0,s5
     288:	2c1040ef          	jal	4d48 <open>
     28c:	892a                	mv	s2,a0
    if(fd < 0){
     28e:	04054663          	bltz	a0,2da <bigwrite+0x9a>
      int cc = write(fd, buf, sz);
     292:	8626                	mv	a2,s1
     294:	85d2                	mv	a1,s4
     296:	293040ef          	jal	4d28 <write>
     29a:	89aa                	mv	s3,a0
      if(cc != sz){
     29c:	04a49963          	bne	s1,a0,2ee <bigwrite+0xae>
      int cc = write(fd, buf, sz);
     2a0:	8626                	mv	a2,s1
     2a2:	85d2                	mv	a1,s4
     2a4:	854a                	mv	a0,s2
     2a6:	283040ef          	jal	4d28 <write>
      if(cc != sz){
     2aa:	04951363          	bne	a0,s1,2f0 <bigwrite+0xb0>
    close(fd);
     2ae:	854a                	mv	a0,s2
     2b0:	281040ef          	jal	4d30 <close>
    unlink("bigwrite");
     2b4:	8556                	mv	a0,s5
     2b6:	2a3040ef          	jal	4d58 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2ba:	1d74849b          	addiw	s1,s1,471
     2be:	fd6493e3          	bne	s1,s6,284 <bigwrite+0x44>
}
     2c2:	60a6                	ld	ra,72(sp)
     2c4:	6406                	ld	s0,64(sp)
     2c6:	74e2                	ld	s1,56(sp)
     2c8:	7942                	ld	s2,48(sp)
     2ca:	79a2                	ld	s3,40(sp)
     2cc:	7a02                	ld	s4,32(sp)
     2ce:	6ae2                	ld	s5,24(sp)
     2d0:	6b42                	ld	s6,16(sp)
     2d2:	6ba2                	ld	s7,8(sp)
     2d4:	6c02                	ld	s8,0(sp)
     2d6:	6161                	addi	sp,sp,80
     2d8:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     2da:	85e2                	mv	a1,s8
     2dc:	00005517          	auipc	a0,0x5
     2e0:	0cc50513          	addi	a0,a0,204 # 53a8 <malloc+0x1de>
     2e4:	62f040ef          	jal	5112 <printf>
      exit(1);
     2e8:	4505                	li	a0,1
     2ea:	21f040ef          	jal	4d08 <exit>
      if(cc != sz){
     2ee:	89a6                	mv	s3,s1
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     2f0:	86aa                	mv	a3,a0
     2f2:	864e                	mv	a2,s3
     2f4:	85e2                	mv	a1,s8
     2f6:	00005517          	auipc	a0,0x5
     2fa:	0d250513          	addi	a0,a0,210 # 53c8 <malloc+0x1fe>
     2fe:	615040ef          	jal	5112 <printf>
        exit(1);
     302:	4505                	li	a0,1
     304:	205040ef          	jal	4d08 <exit>

0000000000000308 <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
     308:	7139                	addi	sp,sp,-64
     30a:	fc06                	sd	ra,56(sp)
     30c:	f822                	sd	s0,48(sp)
     30e:	f426                	sd	s1,40(sp)
     310:	f04a                	sd	s2,32(sp)
     312:	ec4e                	sd	s3,24(sp)
     314:	e852                	sd	s4,16(sp)
     316:	e456                	sd	s5,8(sp)
     318:	e05a                	sd	s6,0(sp)
     31a:	0080                	addi	s0,sp,64
  int assumed_free = 600;
  
  unlink("junk");
     31c:	00005517          	auipc	a0,0x5
     320:	0c450513          	addi	a0,a0,196 # 53e0 <malloc+0x216>
     324:	235040ef          	jal	4d58 <unlink>
     328:	25800913          	li	s2,600
  for(int i = 0; i < assumed_free; i++){
    int fd = open("junk", O_CREATE|O_WRONLY);
     32c:	20100a93          	li	s5,513
     330:	00005997          	auipc	s3,0x5
     334:	0b098993          	addi	s3,s3,176 # 53e0 <malloc+0x216>
    if(fd < 0){
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char*)0xffffffffffL, 1);
     338:	4b05                	li	s6,1
     33a:	5a7d                	li	s4,-1
     33c:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
     340:	85d6                	mv	a1,s5
     342:	854e                	mv	a0,s3
     344:	205040ef          	jal	4d48 <open>
     348:	84aa                	mv	s1,a0
    if(fd < 0){
     34a:	04054d63          	bltz	a0,3a4 <badwrite+0x9c>
    write(fd, (char*)0xffffffffffL, 1);
     34e:	865a                	mv	a2,s6
     350:	85d2                	mv	a1,s4
     352:	1d7040ef          	jal	4d28 <write>
    close(fd);
     356:	8526                	mv	a0,s1
     358:	1d9040ef          	jal	4d30 <close>
    unlink("junk");
     35c:	854e                	mv	a0,s3
     35e:	1fb040ef          	jal	4d58 <unlink>
  for(int i = 0; i < assumed_free; i++){
     362:	397d                	addiw	s2,s2,-1
     364:	fc091ee3          	bnez	s2,340 <badwrite+0x38>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
     368:	20100593          	li	a1,513
     36c:	00005517          	auipc	a0,0x5
     370:	07450513          	addi	a0,a0,116 # 53e0 <malloc+0x216>
     374:	1d5040ef          	jal	4d48 <open>
     378:	84aa                	mv	s1,a0
  if(fd < 0){
     37a:	02054e63          	bltz	a0,3b6 <badwrite+0xae>
    printf("open junk failed\n");
    exit(1);
  }
  if(write(fd, "x", 1) != 1){
     37e:	4605                	li	a2,1
     380:	00005597          	auipc	a1,0x5
     384:	fe858593          	addi	a1,a1,-24 # 5368 <malloc+0x19e>
     388:	1a1040ef          	jal	4d28 <write>
     38c:	4785                	li	a5,1
     38e:	02f50d63          	beq	a0,a5,3c8 <badwrite+0xc0>
    printf("write failed\n");
     392:	00005517          	auipc	a0,0x5
     396:	06e50513          	addi	a0,a0,110 # 5400 <malloc+0x236>
     39a:	579040ef          	jal	5112 <printf>
    exit(1);
     39e:	4505                	li	a0,1
     3a0:	169040ef          	jal	4d08 <exit>
      printf("open junk failed\n");
     3a4:	00005517          	auipc	a0,0x5
     3a8:	04450513          	addi	a0,a0,68 # 53e8 <malloc+0x21e>
     3ac:	567040ef          	jal	5112 <printf>
      exit(1);
     3b0:	4505                	li	a0,1
     3b2:	157040ef          	jal	4d08 <exit>
    printf("open junk failed\n");
     3b6:	00005517          	auipc	a0,0x5
     3ba:	03250513          	addi	a0,a0,50 # 53e8 <malloc+0x21e>
     3be:	555040ef          	jal	5112 <printf>
    exit(1);
     3c2:	4505                	li	a0,1
     3c4:	145040ef          	jal	4d08 <exit>
  }
  close(fd);
     3c8:	8526                	mv	a0,s1
     3ca:	167040ef          	jal	4d30 <close>
  unlink("junk");
     3ce:	00005517          	auipc	a0,0x5
     3d2:	01250513          	addi	a0,a0,18 # 53e0 <malloc+0x216>
     3d6:	183040ef          	jal	4d58 <unlink>

  exit(0);
     3da:	4501                	li	a0,0
     3dc:	12d040ef          	jal	4d08 <exit>

00000000000003e0 <outofinodes>:
  }
}

void
outofinodes(char *s)
{
     3e0:	711d                	addi	sp,sp,-96
     3e2:	ec86                	sd	ra,88(sp)
     3e4:	e8a2                	sd	s0,80(sp)
     3e6:	e4a6                	sd	s1,72(sp)
     3e8:	e0ca                	sd	s2,64(sp)
     3ea:	fc4e                	sd	s3,56(sp)
     3ec:	f852                	sd	s4,48(sp)
     3ee:	f456                	sd	s5,40(sp)
     3f0:	1080                	addi	s0,sp,96
  int nzz = 32*32;
  for(int i = 0; i < nzz; i++){
     3f2:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     3f4:	07a00993          	li	s3,122
    name[1] = 'z';
    name[2] = '0' + (i / 32);
    name[3] = '0' + (i % 32);
    name[4] = '\0';
    unlink(name);
     3f8:	fa040913          	addi	s2,s0,-96
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     3fc:	60200a13          	li	s4,1538
  for(int i = 0; i < nzz; i++){
     400:	40000a93          	li	s5,1024
    name[0] = 'z';
     404:	fb340023          	sb	s3,-96(s0)
    name[1] = 'z';
     408:	fb3400a3          	sb	s3,-95(s0)
    name[2] = '0' + (i / 32);
     40c:	41f4d71b          	sraiw	a4,s1,0x1f
     410:	01b7571b          	srliw	a4,a4,0x1b
     414:	009707bb          	addw	a5,a4,s1
     418:	4057d69b          	sraiw	a3,a5,0x5
     41c:	0306869b          	addiw	a3,a3,48
     420:	fad40123          	sb	a3,-94(s0)
    name[3] = '0' + (i % 32);
     424:	8bfd                	andi	a5,a5,31
     426:	9f99                	subw	a5,a5,a4
     428:	0307879b          	addiw	a5,a5,48
     42c:	faf401a3          	sb	a5,-93(s0)
    name[4] = '\0';
     430:	fa040223          	sb	zero,-92(s0)
    unlink(name);
     434:	854a                	mv	a0,s2
     436:	123040ef          	jal	4d58 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     43a:	85d2                	mv	a1,s4
     43c:	854a                	mv	a0,s2
     43e:	10b040ef          	jal	4d48 <open>
    if(fd < 0){
     442:	00054763          	bltz	a0,450 <outofinodes+0x70>
      // failure is eventually expected.
      break;
    }
    close(fd);
     446:	0eb040ef          	jal	4d30 <close>
  for(int i = 0; i < nzz; i++){
     44a:	2485                	addiw	s1,s1,1
     44c:	fb549ce3          	bne	s1,s5,404 <outofinodes+0x24>
     450:	4481                	li	s1,0
  }

  for(int i = 0; i < nzz; i++){
    char name[32];
    name[0] = 'z';
     452:	07a00913          	li	s2,122
    name[1] = 'z';
    name[2] = '0' + (i / 32);
    name[3] = '0' + (i % 32);
    name[4] = '\0';
    unlink(name);
     456:	fa040a13          	addi	s4,s0,-96
  for(int i = 0; i < nzz; i++){
     45a:	40000993          	li	s3,1024
    name[0] = 'z';
     45e:	fb240023          	sb	s2,-96(s0)
    name[1] = 'z';
     462:	fb2400a3          	sb	s2,-95(s0)
    name[2] = '0' + (i / 32);
     466:	41f4d71b          	sraiw	a4,s1,0x1f
     46a:	01b7571b          	srliw	a4,a4,0x1b
     46e:	009707bb          	addw	a5,a4,s1
     472:	4057d69b          	sraiw	a3,a5,0x5
     476:	0306869b          	addiw	a3,a3,48
     47a:	fad40123          	sb	a3,-94(s0)
    name[3] = '0' + (i % 32);
     47e:	8bfd                	andi	a5,a5,31
     480:	9f99                	subw	a5,a5,a4
     482:	0307879b          	addiw	a5,a5,48
     486:	faf401a3          	sb	a5,-93(s0)
    name[4] = '\0';
     48a:	fa040223          	sb	zero,-92(s0)
    unlink(name);
     48e:	8552                	mv	a0,s4
     490:	0c9040ef          	jal	4d58 <unlink>
  for(int i = 0; i < nzz; i++){
     494:	2485                	addiw	s1,s1,1
     496:	fd3494e3          	bne	s1,s3,45e <outofinodes+0x7e>
  }
}
     49a:	60e6                	ld	ra,88(sp)
     49c:	6446                	ld	s0,80(sp)
     49e:	64a6                	ld	s1,72(sp)
     4a0:	6906                	ld	s2,64(sp)
     4a2:	79e2                	ld	s3,56(sp)
     4a4:	7a42                	ld	s4,48(sp)
     4a6:	7aa2                	ld	s5,40(sp)
     4a8:	6125                	addi	sp,sp,96
     4aa:	8082                	ret

00000000000004ac <copyin>:
{
     4ac:	7175                	addi	sp,sp,-144
     4ae:	e506                	sd	ra,136(sp)
     4b0:	e122                	sd	s0,128(sp)
     4b2:	fca6                	sd	s1,120(sp)
     4b4:	f8ca                	sd	s2,112(sp)
     4b6:	f4ce                	sd	s3,104(sp)
     4b8:	f0d2                	sd	s4,96(sp)
     4ba:	ecd6                	sd	s5,88(sp)
     4bc:	e8da                	sd	s6,80(sp)
     4be:	e4de                	sd	s7,72(sp)
     4c0:	e0e2                	sd	s8,64(sp)
     4c2:	fc66                	sd	s9,56(sp)
     4c4:	0900                	addi	s0,sp,144
  uint64 addrs[] = { 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
     4c6:	00007797          	auipc	a5,0x7
     4ca:	19278793          	addi	a5,a5,402 # 7658 <malloc+0x248e>
     4ce:	638c                	ld	a1,0(a5)
     4d0:	6790                	ld	a2,8(a5)
     4d2:	6b94                	ld	a3,16(a5)
     4d4:	6f98                	ld	a4,24(a5)
     4d6:	739c                	ld	a5,32(a5)
     4d8:	f6b43c23          	sd	a1,-136(s0)
     4dc:	f8c43023          	sd	a2,-128(s0)
     4e0:	f8d43423          	sd	a3,-120(s0)
     4e4:	f8e43823          	sd	a4,-112(s0)
     4e8:	f8f43c23          	sd	a5,-104(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     4ec:	f7840913          	addi	s2,s0,-136
     4f0:	fa040c93          	addi	s9,s0,-96
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     4f4:	20100b13          	li	s6,513
     4f8:	00005a97          	auipc	s5,0x5
     4fc:	f18a8a93          	addi	s5,s5,-232 # 5410 <malloc+0x246>
    int n = write(fd, (void*)addr, 8192);
     500:	6a09                	lui	s4,0x2
    n = write(1, (char*)addr, 8192);
     502:	4c05                	li	s8,1
    if(pipe(fds) < 0){
     504:	f7040b93          	addi	s7,s0,-144
    uint64 addr = addrs[ai];
     508:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     50c:	85da                	mv	a1,s6
     50e:	8556                	mv	a0,s5
     510:	039040ef          	jal	4d48 <open>
     514:	84aa                	mv	s1,a0
    if(fd < 0){
     516:	06054a63          	bltz	a0,58a <copyin+0xde>
    int n = write(fd, (void*)addr, 8192);
     51a:	8652                	mv	a2,s4
     51c:	85ce                	mv	a1,s3
     51e:	00b040ef          	jal	4d28 <write>
    if(n >= 0){
     522:	06055d63          	bgez	a0,59c <copyin+0xf0>
    close(fd);
     526:	8526                	mv	a0,s1
     528:	009040ef          	jal	4d30 <close>
    unlink("copyin1");
     52c:	8556                	mv	a0,s5
     52e:	02b040ef          	jal	4d58 <unlink>
    n = write(1, (char*)addr, 8192);
     532:	8652                	mv	a2,s4
     534:	85ce                	mv	a1,s3
     536:	8562                	mv	a0,s8
     538:	7f0040ef          	jal	4d28 <write>
    if(n > 0){
     53c:	06a04b63          	bgtz	a0,5b2 <copyin+0x106>
    if(pipe(fds) < 0){
     540:	855e                	mv	a0,s7
     542:	7d6040ef          	jal	4d18 <pipe>
     546:	08054163          	bltz	a0,5c8 <copyin+0x11c>
    n = write(fds[1], (char*)addr, 8192);
     54a:	8652                	mv	a2,s4
     54c:	85ce                	mv	a1,s3
     54e:	f7442503          	lw	a0,-140(s0)
     552:	7d6040ef          	jal	4d28 <write>
    if(n > 0){
     556:	08a04263          	bgtz	a0,5da <copyin+0x12e>
    close(fds[0]);
     55a:	f7042503          	lw	a0,-144(s0)
     55e:	7d2040ef          	jal	4d30 <close>
    close(fds[1]);
     562:	f7442503          	lw	a0,-140(s0)
     566:	7ca040ef          	jal	4d30 <close>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     56a:	0921                	addi	s2,s2,8
     56c:	f9991ee3          	bne	s2,s9,508 <copyin+0x5c>
}
     570:	60aa                	ld	ra,136(sp)
     572:	640a                	ld	s0,128(sp)
     574:	74e6                	ld	s1,120(sp)
     576:	7946                	ld	s2,112(sp)
     578:	79a6                	ld	s3,104(sp)
     57a:	7a06                	ld	s4,96(sp)
     57c:	6ae6                	ld	s5,88(sp)
     57e:	6b46                	ld	s6,80(sp)
     580:	6ba6                	ld	s7,72(sp)
     582:	6c06                	ld	s8,64(sp)
     584:	7ce2                	ld	s9,56(sp)
     586:	6149                	addi	sp,sp,144
     588:	8082                	ret
      printf("open(copyin1) failed\n");
     58a:	00005517          	auipc	a0,0x5
     58e:	e8e50513          	addi	a0,a0,-370 # 5418 <malloc+0x24e>
     592:	381040ef          	jal	5112 <printf>
      exit(1);
     596:	4505                	li	a0,1
     598:	770040ef          	jal	4d08 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", (void*)addr, n);
     59c:	862a                	mv	a2,a0
     59e:	85ce                	mv	a1,s3
     5a0:	00005517          	auipc	a0,0x5
     5a4:	e9050513          	addi	a0,a0,-368 # 5430 <malloc+0x266>
     5a8:	36b040ef          	jal	5112 <printf>
      exit(1);
     5ac:	4505                	li	a0,1
     5ae:	75a040ef          	jal	4d08 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     5b2:	862a                	mv	a2,a0
     5b4:	85ce                	mv	a1,s3
     5b6:	00005517          	auipc	a0,0x5
     5ba:	eaa50513          	addi	a0,a0,-342 # 5460 <malloc+0x296>
     5be:	355040ef          	jal	5112 <printf>
      exit(1);
     5c2:	4505                	li	a0,1
     5c4:	744040ef          	jal	4d08 <exit>
      printf("pipe() failed\n");
     5c8:	00005517          	auipc	a0,0x5
     5cc:	ec850513          	addi	a0,a0,-312 # 5490 <malloc+0x2c6>
     5d0:	343040ef          	jal	5112 <printf>
      exit(1);
     5d4:	4505                	li	a0,1
     5d6:	732040ef          	jal	4d08 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     5da:	862a                	mv	a2,a0
     5dc:	85ce                	mv	a1,s3
     5de:	00005517          	auipc	a0,0x5
     5e2:	ec250513          	addi	a0,a0,-318 # 54a0 <malloc+0x2d6>
     5e6:	32d040ef          	jal	5112 <printf>
      exit(1);
     5ea:	4505                	li	a0,1
     5ec:	71c040ef          	jal	4d08 <exit>

00000000000005f0 <copyout>:
{
     5f0:	7135                	addi	sp,sp,-160
     5f2:	ed06                	sd	ra,152(sp)
     5f4:	e922                	sd	s0,144(sp)
     5f6:	e526                	sd	s1,136(sp)
     5f8:	e14a                	sd	s2,128(sp)
     5fa:	fcce                	sd	s3,120(sp)
     5fc:	f8d2                	sd	s4,112(sp)
     5fe:	f4d6                	sd	s5,104(sp)
     600:	f0da                	sd	s6,96(sp)
     602:	ecde                	sd	s7,88(sp)
     604:	e8e2                	sd	s8,80(sp)
     606:	e4e6                	sd	s9,72(sp)
     608:	1100                	addi	s0,sp,160
  uint64 addrs[] = { 0LL, 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
     60a:	00007797          	auipc	a5,0x7
     60e:	04e78793          	addi	a5,a5,78 # 7658 <malloc+0x248e>
     612:	7788                	ld	a0,40(a5)
     614:	7b8c                	ld	a1,48(a5)
     616:	7f90                	ld	a2,56(a5)
     618:	63b4                	ld	a3,64(a5)
     61a:	67b8                	ld	a4,72(a5)
     61c:	6bbc                	ld	a5,80(a5)
     61e:	f6a43823          	sd	a0,-144(s0)
     622:	f6b43c23          	sd	a1,-136(s0)
     626:	f8c43023          	sd	a2,-128(s0)
     62a:	f8d43423          	sd	a3,-120(s0)
     62e:	f8e43823          	sd	a4,-112(s0)
     632:	f8f43c23          	sd	a5,-104(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     636:	f7040913          	addi	s2,s0,-144
     63a:	fa040c93          	addi	s9,s0,-96
    int fd = open("README", 0);
     63e:	00005b17          	auipc	s6,0x5
     642:	e92b0b13          	addi	s6,s6,-366 # 54d0 <malloc+0x306>
    int n = read(fd, (void*)addr, 8192);
     646:	6a89                	lui	s5,0x2
    if(pipe(fds) < 0){
     648:	f6840c13          	addi	s8,s0,-152
    n = write(fds[1], "x", 1);
     64c:	4a05                	li	s4,1
     64e:	00005b97          	auipc	s7,0x5
     652:	d1ab8b93          	addi	s7,s7,-742 # 5368 <malloc+0x19e>
    uint64 addr = addrs[ai];
     656:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     65a:	4581                	li	a1,0
     65c:	855a                	mv	a0,s6
     65e:	6ea040ef          	jal	4d48 <open>
     662:	84aa                	mv	s1,a0
    if(fd < 0){
     664:	06054863          	bltz	a0,6d4 <copyout+0xe4>
    int n = read(fd, (void*)addr, 8192);
     668:	8656                	mv	a2,s5
     66a:	85ce                	mv	a1,s3
     66c:	6b4040ef          	jal	4d20 <read>
    if(n > 0){
     670:	06a04b63          	bgtz	a0,6e6 <copyout+0xf6>
    close(fd);
     674:	8526                	mv	a0,s1
     676:	6ba040ef          	jal	4d30 <close>
    if(pipe(fds) < 0){
     67a:	8562                	mv	a0,s8
     67c:	69c040ef          	jal	4d18 <pipe>
     680:	06054e63          	bltz	a0,6fc <copyout+0x10c>
    n = write(fds[1], "x", 1);
     684:	8652                	mv	a2,s4
     686:	85de                	mv	a1,s7
     688:	f6c42503          	lw	a0,-148(s0)
     68c:	69c040ef          	jal	4d28 <write>
    if(n != 1){
     690:	07451f63          	bne	a0,s4,70e <copyout+0x11e>
    n = read(fds[0], (void*)addr, 8192);
     694:	8656                	mv	a2,s5
     696:	85ce                	mv	a1,s3
     698:	f6842503          	lw	a0,-152(s0)
     69c:	684040ef          	jal	4d20 <read>
    if(n > 0){
     6a0:	08a04063          	bgtz	a0,720 <copyout+0x130>
    close(fds[0]);
     6a4:	f6842503          	lw	a0,-152(s0)
     6a8:	688040ef          	jal	4d30 <close>
    close(fds[1]);
     6ac:	f6c42503          	lw	a0,-148(s0)
     6b0:	680040ef          	jal	4d30 <close>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     6b4:	0921                	addi	s2,s2,8
     6b6:	fb9910e3          	bne	s2,s9,656 <copyout+0x66>
}
     6ba:	60ea                	ld	ra,152(sp)
     6bc:	644a                	ld	s0,144(sp)
     6be:	64aa                	ld	s1,136(sp)
     6c0:	690a                	ld	s2,128(sp)
     6c2:	79e6                	ld	s3,120(sp)
     6c4:	7a46                	ld	s4,112(sp)
     6c6:	7aa6                	ld	s5,104(sp)
     6c8:	7b06                	ld	s6,96(sp)
     6ca:	6be6                	ld	s7,88(sp)
     6cc:	6c46                	ld	s8,80(sp)
     6ce:	6ca6                	ld	s9,72(sp)
     6d0:	610d                	addi	sp,sp,160
     6d2:	8082                	ret
      printf("open(README) failed\n");
     6d4:	00005517          	auipc	a0,0x5
     6d8:	e0450513          	addi	a0,a0,-508 # 54d8 <malloc+0x30e>
     6dc:	237040ef          	jal	5112 <printf>
      exit(1);
     6e0:	4505                	li	a0,1
     6e2:	626040ef          	jal	4d08 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     6e6:	862a                	mv	a2,a0
     6e8:	85ce                	mv	a1,s3
     6ea:	00005517          	auipc	a0,0x5
     6ee:	e0650513          	addi	a0,a0,-506 # 54f0 <malloc+0x326>
     6f2:	221040ef          	jal	5112 <printf>
      exit(1);
     6f6:	4505                	li	a0,1
     6f8:	610040ef          	jal	4d08 <exit>
      printf("pipe() failed\n");
     6fc:	00005517          	auipc	a0,0x5
     700:	d9450513          	addi	a0,a0,-620 # 5490 <malloc+0x2c6>
     704:	20f040ef          	jal	5112 <printf>
      exit(1);
     708:	4505                	li	a0,1
     70a:	5fe040ef          	jal	4d08 <exit>
      printf("pipe write failed\n");
     70e:	00005517          	auipc	a0,0x5
     712:	e1250513          	addi	a0,a0,-494 # 5520 <malloc+0x356>
     716:	1fd040ef          	jal	5112 <printf>
      exit(1);
     71a:	4505                	li	a0,1
     71c:	5ec040ef          	jal	4d08 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     720:	862a                	mv	a2,a0
     722:	85ce                	mv	a1,s3
     724:	00005517          	auipc	a0,0x5
     728:	e1450513          	addi	a0,a0,-492 # 5538 <malloc+0x36e>
     72c:	1e7040ef          	jal	5112 <printf>
      exit(1);
     730:	4505                	li	a0,1
     732:	5d6040ef          	jal	4d08 <exit>

0000000000000736 <truncate1>:
{
     736:	711d                	addi	sp,sp,-96
     738:	ec86                	sd	ra,88(sp)
     73a:	e8a2                	sd	s0,80(sp)
     73c:	e4a6                	sd	s1,72(sp)
     73e:	e0ca                	sd	s2,64(sp)
     740:	fc4e                	sd	s3,56(sp)
     742:	f852                	sd	s4,48(sp)
     744:	f456                	sd	s5,40(sp)
     746:	1080                	addi	s0,sp,96
     748:	8aaa                	mv	s5,a0
  unlink("truncfile");
     74a:	00005517          	auipc	a0,0x5
     74e:	c0650513          	addi	a0,a0,-1018 # 5350 <malloc+0x186>
     752:	606040ef          	jal	4d58 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     756:	60100593          	li	a1,1537
     75a:	00005517          	auipc	a0,0x5
     75e:	bf650513          	addi	a0,a0,-1034 # 5350 <malloc+0x186>
     762:	5e6040ef          	jal	4d48 <open>
     766:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     768:	4611                	li	a2,4
     76a:	00005597          	auipc	a1,0x5
     76e:	bf658593          	addi	a1,a1,-1034 # 5360 <malloc+0x196>
     772:	5b6040ef          	jal	4d28 <write>
  close(fd1);
     776:	8526                	mv	a0,s1
     778:	5b8040ef          	jal	4d30 <close>
  int fd2 = open("truncfile", O_RDONLY);
     77c:	4581                	li	a1,0
     77e:	00005517          	auipc	a0,0x5
     782:	bd250513          	addi	a0,a0,-1070 # 5350 <malloc+0x186>
     786:	5c2040ef          	jal	4d48 <open>
     78a:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     78c:	02000613          	li	a2,32
     790:	fa040593          	addi	a1,s0,-96
     794:	58c040ef          	jal	4d20 <read>
  if(n != 4){
     798:	4791                	li	a5,4
     79a:	0af51863          	bne	a0,a5,84a <truncate1+0x114>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     79e:	40100593          	li	a1,1025
     7a2:	00005517          	auipc	a0,0x5
     7a6:	bae50513          	addi	a0,a0,-1106 # 5350 <malloc+0x186>
     7aa:	59e040ef          	jal	4d48 <open>
     7ae:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     7b0:	4581                	li	a1,0
     7b2:	00005517          	auipc	a0,0x5
     7b6:	b9e50513          	addi	a0,a0,-1122 # 5350 <malloc+0x186>
     7ba:	58e040ef          	jal	4d48 <open>
     7be:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     7c0:	02000613          	li	a2,32
     7c4:	fa040593          	addi	a1,s0,-96
     7c8:	558040ef          	jal	4d20 <read>
     7cc:	8a2a                	mv	s4,a0
  if(n != 0){
     7ce:	e949                	bnez	a0,860 <truncate1+0x12a>
  n = read(fd2, buf, sizeof(buf));
     7d0:	02000613          	li	a2,32
     7d4:	fa040593          	addi	a1,s0,-96
     7d8:	8526                	mv	a0,s1
     7da:	546040ef          	jal	4d20 <read>
     7de:	8a2a                	mv	s4,a0
  if(n != 0){
     7e0:	e155                	bnez	a0,884 <truncate1+0x14e>
  write(fd1, "abcdef", 6);
     7e2:	4619                	li	a2,6
     7e4:	00005597          	auipc	a1,0x5
     7e8:	de458593          	addi	a1,a1,-540 # 55c8 <malloc+0x3fe>
     7ec:	854e                	mv	a0,s3
     7ee:	53a040ef          	jal	4d28 <write>
  n = read(fd3, buf, sizeof(buf));
     7f2:	02000613          	li	a2,32
     7f6:	fa040593          	addi	a1,s0,-96
     7fa:	854a                	mv	a0,s2
     7fc:	524040ef          	jal	4d20 <read>
  if(n != 6){
     800:	4799                	li	a5,6
     802:	0af51363          	bne	a0,a5,8a8 <truncate1+0x172>
  n = read(fd2, buf, sizeof(buf));
     806:	02000613          	li	a2,32
     80a:	fa040593          	addi	a1,s0,-96
     80e:	8526                	mv	a0,s1
     810:	510040ef          	jal	4d20 <read>
  if(n != 2){
     814:	4789                	li	a5,2
     816:	0af51463          	bne	a0,a5,8be <truncate1+0x188>
  unlink("truncfile");
     81a:	00005517          	auipc	a0,0x5
     81e:	b3650513          	addi	a0,a0,-1226 # 5350 <malloc+0x186>
     822:	536040ef          	jal	4d58 <unlink>
  close(fd1);
     826:	854e                	mv	a0,s3
     828:	508040ef          	jal	4d30 <close>
  close(fd2);
     82c:	8526                	mv	a0,s1
     82e:	502040ef          	jal	4d30 <close>
  close(fd3);
     832:	854a                	mv	a0,s2
     834:	4fc040ef          	jal	4d30 <close>
}
     838:	60e6                	ld	ra,88(sp)
     83a:	6446                	ld	s0,80(sp)
     83c:	64a6                	ld	s1,72(sp)
     83e:	6906                	ld	s2,64(sp)
     840:	79e2                	ld	s3,56(sp)
     842:	7a42                	ld	s4,48(sp)
     844:	7aa2                	ld	s5,40(sp)
     846:	6125                	addi	sp,sp,96
     848:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     84a:	862a                	mv	a2,a0
     84c:	85d6                	mv	a1,s5
     84e:	00005517          	auipc	a0,0x5
     852:	d1a50513          	addi	a0,a0,-742 # 5568 <malloc+0x39e>
     856:	0bd040ef          	jal	5112 <printf>
    exit(1);
     85a:	4505                	li	a0,1
     85c:	4ac040ef          	jal	4d08 <exit>
    printf("aaa fd3=%d\n", fd3);
     860:	85ca                	mv	a1,s2
     862:	00005517          	auipc	a0,0x5
     866:	d2650513          	addi	a0,a0,-730 # 5588 <malloc+0x3be>
     86a:	0a9040ef          	jal	5112 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     86e:	8652                	mv	a2,s4
     870:	85d6                	mv	a1,s5
     872:	00005517          	auipc	a0,0x5
     876:	d2650513          	addi	a0,a0,-730 # 5598 <malloc+0x3ce>
     87a:	099040ef          	jal	5112 <printf>
    exit(1);
     87e:	4505                	li	a0,1
     880:	488040ef          	jal	4d08 <exit>
    printf("bbb fd2=%d\n", fd2);
     884:	85a6                	mv	a1,s1
     886:	00005517          	auipc	a0,0x5
     88a:	d3250513          	addi	a0,a0,-718 # 55b8 <malloc+0x3ee>
     88e:	085040ef          	jal	5112 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     892:	8652                	mv	a2,s4
     894:	85d6                	mv	a1,s5
     896:	00005517          	auipc	a0,0x5
     89a:	d0250513          	addi	a0,a0,-766 # 5598 <malloc+0x3ce>
     89e:	075040ef          	jal	5112 <printf>
    exit(1);
     8a2:	4505                	li	a0,1
     8a4:	464040ef          	jal	4d08 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     8a8:	862a                	mv	a2,a0
     8aa:	85d6                	mv	a1,s5
     8ac:	00005517          	auipc	a0,0x5
     8b0:	d2450513          	addi	a0,a0,-732 # 55d0 <malloc+0x406>
     8b4:	05f040ef          	jal	5112 <printf>
    exit(1);
     8b8:	4505                	li	a0,1
     8ba:	44e040ef          	jal	4d08 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     8be:	862a                	mv	a2,a0
     8c0:	85d6                	mv	a1,s5
     8c2:	00005517          	auipc	a0,0x5
     8c6:	d2e50513          	addi	a0,a0,-722 # 55f0 <malloc+0x426>
     8ca:	049040ef          	jal	5112 <printf>
    exit(1);
     8ce:	4505                	li	a0,1
     8d0:	438040ef          	jal	4d08 <exit>

00000000000008d4 <writetest>:
{
     8d4:	715d                	addi	sp,sp,-80
     8d6:	e486                	sd	ra,72(sp)
     8d8:	e0a2                	sd	s0,64(sp)
     8da:	fc26                	sd	s1,56(sp)
     8dc:	f84a                	sd	s2,48(sp)
     8de:	f44e                	sd	s3,40(sp)
     8e0:	f052                	sd	s4,32(sp)
     8e2:	ec56                	sd	s5,24(sp)
     8e4:	e85a                	sd	s6,16(sp)
     8e6:	e45e                	sd	s7,8(sp)
     8e8:	0880                	addi	s0,sp,80
     8ea:	8baa                	mv	s7,a0
  fd = open("small", O_CREATE|O_RDWR);
     8ec:	20200593          	li	a1,514
     8f0:	00005517          	auipc	a0,0x5
     8f4:	d2050513          	addi	a0,a0,-736 # 5610 <malloc+0x446>
     8f8:	450040ef          	jal	4d48 <open>
  if(fd < 0){
     8fc:	08054f63          	bltz	a0,99a <writetest+0xc6>
     900:	89aa                	mv	s3,a0
     902:	4901                	li	s2,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     904:	44a9                	li	s1,10
     906:	00005a17          	auipc	s4,0x5
     90a:	d32a0a13          	addi	s4,s4,-718 # 5638 <malloc+0x46e>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     90e:	00005b17          	auipc	s6,0x5
     912:	d62b0b13          	addi	s6,s6,-670 # 5670 <malloc+0x4a6>
  for(i = 0; i < N; i++){
     916:	06400a93          	li	s5,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     91a:	8626                	mv	a2,s1
     91c:	85d2                	mv	a1,s4
     91e:	854e                	mv	a0,s3
     920:	408040ef          	jal	4d28 <write>
     924:	08951563          	bne	a0,s1,9ae <writetest+0xda>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     928:	8626                	mv	a2,s1
     92a:	85da                	mv	a1,s6
     92c:	854e                	mv	a0,s3
     92e:	3fa040ef          	jal	4d28 <write>
     932:	08951963          	bne	a0,s1,9c4 <writetest+0xf0>
  for(i = 0; i < N; i++){
     936:	2905                	addiw	s2,s2,1
     938:	ff5911e3          	bne	s2,s5,91a <writetest+0x46>
  close(fd);
     93c:	854e                	mv	a0,s3
     93e:	3f2040ef          	jal	4d30 <close>
  fd = open("small", O_RDONLY);
     942:	4581                	li	a1,0
     944:	00005517          	auipc	a0,0x5
     948:	ccc50513          	addi	a0,a0,-820 # 5610 <malloc+0x446>
     94c:	3fc040ef          	jal	4d48 <open>
     950:	84aa                	mv	s1,a0
  if(fd < 0){
     952:	08054463          	bltz	a0,9da <writetest+0x106>
  i = read(fd, buf, N*SZ*2);
     956:	7d000613          	li	a2,2000
     95a:	0000b597          	auipc	a1,0xb
     95e:	31e58593          	addi	a1,a1,798 # bc78 <buf>
     962:	3be040ef          	jal	4d20 <read>
  if(i != N*SZ*2){
     966:	7d000793          	li	a5,2000
     96a:	08f51263          	bne	a0,a5,9ee <writetest+0x11a>
  close(fd);
     96e:	8526                	mv	a0,s1
     970:	3c0040ef          	jal	4d30 <close>
  if(unlink("small") < 0){
     974:	00005517          	auipc	a0,0x5
     978:	c9c50513          	addi	a0,a0,-868 # 5610 <malloc+0x446>
     97c:	3dc040ef          	jal	4d58 <unlink>
     980:	08054163          	bltz	a0,a02 <writetest+0x12e>
}
     984:	60a6                	ld	ra,72(sp)
     986:	6406                	ld	s0,64(sp)
     988:	74e2                	ld	s1,56(sp)
     98a:	7942                	ld	s2,48(sp)
     98c:	79a2                	ld	s3,40(sp)
     98e:	7a02                	ld	s4,32(sp)
     990:	6ae2                	ld	s5,24(sp)
     992:	6b42                	ld	s6,16(sp)
     994:	6ba2                	ld	s7,8(sp)
     996:	6161                	addi	sp,sp,80
     998:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     99a:	85de                	mv	a1,s7
     99c:	00005517          	auipc	a0,0x5
     9a0:	c7c50513          	addi	a0,a0,-900 # 5618 <malloc+0x44e>
     9a4:	76e040ef          	jal	5112 <printf>
    exit(1);
     9a8:	4505                	li	a0,1
     9aa:	35e040ef          	jal	4d08 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     9ae:	864a                	mv	a2,s2
     9b0:	85de                	mv	a1,s7
     9b2:	00005517          	auipc	a0,0x5
     9b6:	c9650513          	addi	a0,a0,-874 # 5648 <malloc+0x47e>
     9ba:	758040ef          	jal	5112 <printf>
      exit(1);
     9be:	4505                	li	a0,1
     9c0:	348040ef          	jal	4d08 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     9c4:	864a                	mv	a2,s2
     9c6:	85de                	mv	a1,s7
     9c8:	00005517          	auipc	a0,0x5
     9cc:	cb850513          	addi	a0,a0,-840 # 5680 <malloc+0x4b6>
     9d0:	742040ef          	jal	5112 <printf>
      exit(1);
     9d4:	4505                	li	a0,1
     9d6:	332040ef          	jal	4d08 <exit>
    printf("%s: error: open small failed!\n", s);
     9da:	85de                	mv	a1,s7
     9dc:	00005517          	auipc	a0,0x5
     9e0:	ccc50513          	addi	a0,a0,-820 # 56a8 <malloc+0x4de>
     9e4:	72e040ef          	jal	5112 <printf>
    exit(1);
     9e8:	4505                	li	a0,1
     9ea:	31e040ef          	jal	4d08 <exit>
    printf("%s: read failed\n", s);
     9ee:	85de                	mv	a1,s7
     9f0:	00005517          	auipc	a0,0x5
     9f4:	cd850513          	addi	a0,a0,-808 # 56c8 <malloc+0x4fe>
     9f8:	71a040ef          	jal	5112 <printf>
    exit(1);
     9fc:	4505                	li	a0,1
     9fe:	30a040ef          	jal	4d08 <exit>
    printf("%s: unlink small failed\n", s);
     a02:	85de                	mv	a1,s7
     a04:	00005517          	auipc	a0,0x5
     a08:	cdc50513          	addi	a0,a0,-804 # 56e0 <malloc+0x516>
     a0c:	706040ef          	jal	5112 <printf>
    exit(1);
     a10:	4505                	li	a0,1
     a12:	2f6040ef          	jal	4d08 <exit>

0000000000000a16 <writebig>:
{
     a16:	7139                	addi	sp,sp,-64
     a18:	fc06                	sd	ra,56(sp)
     a1a:	f822                	sd	s0,48(sp)
     a1c:	f426                	sd	s1,40(sp)
     a1e:	f04a                	sd	s2,32(sp)
     a20:	ec4e                	sd	s3,24(sp)
     a22:	e852                	sd	s4,16(sp)
     a24:	e456                	sd	s5,8(sp)
     a26:	e05a                	sd	s6,0(sp)
     a28:	0080                	addi	s0,sp,64
     a2a:	8b2a                	mv	s6,a0
  fd = open("big", O_CREATE|O_RDWR);
     a2c:	20200593          	li	a1,514
     a30:	00005517          	auipc	a0,0x5
     a34:	cd050513          	addi	a0,a0,-816 # 5700 <malloc+0x536>
     a38:	310040ef          	jal	4d48 <open>
  if(fd < 0){
     a3c:	06054b63          	bltz	a0,ab2 <writebig+0x9c>
     a40:	8a2a                	mv	s4,a0
     a42:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     a44:	0000b997          	auipc	s3,0xb
     a48:	23498993          	addi	s3,s3,564 # bc78 <buf>
    if(write(fd, buf, BSIZE) != BSIZE){
     a4c:	40000913          	li	s2,1024
  for(i = 0; i < MAXFILE; i++){
     a50:	6ac1                	lui	s5,0x10
     a52:	10ba8a93          	addi	s5,s5,267 # 1010b <base+0x1493>
    ((int*)buf)[0] = i;
     a56:	0099a023          	sw	s1,0(s3)
    if(write(fd, buf, BSIZE) != BSIZE){
     a5a:	864a                	mv	a2,s2
     a5c:	85ce                	mv	a1,s3
     a5e:	8552                	mv	a0,s4
     a60:	2c8040ef          	jal	4d28 <write>
     a64:	07251163          	bne	a0,s2,ac6 <writebig+0xb0>
  for(i = 0; i < MAXFILE; i++){
     a68:	2485                	addiw	s1,s1,1
     a6a:	ff5496e3          	bne	s1,s5,a56 <writebig+0x40>
  close(fd);
     a6e:	8552                	mv	a0,s4
     a70:	2c0040ef          	jal	4d30 <close>
  fd = open("big", O_RDONLY);
     a74:	4581                	li	a1,0
     a76:	00005517          	auipc	a0,0x5
     a7a:	c8a50513          	addi	a0,a0,-886 # 5700 <malloc+0x536>
     a7e:	2ca040ef          	jal	4d48 <open>
     a82:	8a2a                	mv	s4,a0
  n = 0;
     a84:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a86:	40000993          	li	s3,1024
     a8a:	0000b917          	auipc	s2,0xb
     a8e:	1ee90913          	addi	s2,s2,494 # bc78 <buf>
  if(fd < 0){
     a92:	04054563          	bltz	a0,adc <writebig+0xc6>
    i = read(fd, buf, BSIZE);
     a96:	864e                	mv	a2,s3
     a98:	85ca                	mv	a1,s2
     a9a:	8552                	mv	a0,s4
     a9c:	284040ef          	jal	4d20 <read>
    if(i == 0){
     aa0:	c921                	beqz	a0,af0 <writebig+0xda>
    } else if(i != BSIZE){
     aa2:	09351c63          	bne	a0,s3,b3a <writebig+0x124>
    if(((int*)buf)[0] != n){
     aa6:	00092683          	lw	a3,0(s2)
     aaa:	0a969363          	bne	a3,s1,b50 <writebig+0x13a>
    n++;
     aae:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     ab0:	b7dd                	j	a96 <writebig+0x80>
    printf("%s: error: creat big failed!\n", s);
     ab2:	85da                	mv	a1,s6
     ab4:	00005517          	auipc	a0,0x5
     ab8:	c5450513          	addi	a0,a0,-940 # 5708 <malloc+0x53e>
     abc:	656040ef          	jal	5112 <printf>
    exit(1);
     ac0:	4505                	li	a0,1
     ac2:	246040ef          	jal	4d08 <exit>
      printf("%s: error: write big file failed i=%d\n", s, i);
     ac6:	8626                	mv	a2,s1
     ac8:	85da                	mv	a1,s6
     aca:	00005517          	auipc	a0,0x5
     ace:	c5e50513          	addi	a0,a0,-930 # 5728 <malloc+0x55e>
     ad2:	640040ef          	jal	5112 <printf>
      exit(1);
     ad6:	4505                	li	a0,1
     ad8:	230040ef          	jal	4d08 <exit>
    printf("%s: error: open big failed!\n", s);
     adc:	85da                	mv	a1,s6
     ade:	00005517          	auipc	a0,0x5
     ae2:	c7250513          	addi	a0,a0,-910 # 5750 <malloc+0x586>
     ae6:	62c040ef          	jal	5112 <printf>
    exit(1);
     aea:	4505                	li	a0,1
     aec:	21c040ef          	jal	4d08 <exit>
      if(n != MAXFILE){
     af0:	67c1                	lui	a5,0x10
     af2:	10b78793          	addi	a5,a5,267 # 1010b <base+0x1493>
     af6:	02f49763          	bne	s1,a5,b24 <writebig+0x10e>
  close(fd);
     afa:	8552                	mv	a0,s4
     afc:	234040ef          	jal	4d30 <close>
  if(unlink("big") < 0){
     b00:	00005517          	auipc	a0,0x5
     b04:	c0050513          	addi	a0,a0,-1024 # 5700 <malloc+0x536>
     b08:	250040ef          	jal	4d58 <unlink>
     b0c:	04054d63          	bltz	a0,b66 <writebig+0x150>
}
     b10:	70e2                	ld	ra,56(sp)
     b12:	7442                	ld	s0,48(sp)
     b14:	74a2                	ld	s1,40(sp)
     b16:	7902                	ld	s2,32(sp)
     b18:	69e2                	ld	s3,24(sp)
     b1a:	6a42                	ld	s4,16(sp)
     b1c:	6aa2                	ld	s5,8(sp)
     b1e:	6b02                	ld	s6,0(sp)
     b20:	6121                	addi	sp,sp,64
     b22:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     b24:	8626                	mv	a2,s1
     b26:	85da                	mv	a1,s6
     b28:	00005517          	auipc	a0,0x5
     b2c:	c4850513          	addi	a0,a0,-952 # 5770 <malloc+0x5a6>
     b30:	5e2040ef          	jal	5112 <printf>
        exit(1);
     b34:	4505                	li	a0,1
     b36:	1d2040ef          	jal	4d08 <exit>
      printf("%s: read failed %d\n", s, i);
     b3a:	862a                	mv	a2,a0
     b3c:	85da                	mv	a1,s6
     b3e:	00005517          	auipc	a0,0x5
     b42:	c5a50513          	addi	a0,a0,-934 # 5798 <malloc+0x5ce>
     b46:	5cc040ef          	jal	5112 <printf>
      exit(1);
     b4a:	4505                	li	a0,1
     b4c:	1bc040ef          	jal	4d08 <exit>
      printf("%s: read content of block %d is %d\n", s,
     b50:	8626                	mv	a2,s1
     b52:	85da                	mv	a1,s6
     b54:	00005517          	auipc	a0,0x5
     b58:	c5c50513          	addi	a0,a0,-932 # 57b0 <malloc+0x5e6>
     b5c:	5b6040ef          	jal	5112 <printf>
      exit(1);
     b60:	4505                	li	a0,1
     b62:	1a6040ef          	jal	4d08 <exit>
    printf("%s: unlink big failed\n", s);
     b66:	85da                	mv	a1,s6
     b68:	00005517          	auipc	a0,0x5
     b6c:	c7050513          	addi	a0,a0,-912 # 57d8 <malloc+0x60e>
     b70:	5a2040ef          	jal	5112 <printf>
    exit(1);
     b74:	4505                	li	a0,1
     b76:	192040ef          	jal	4d08 <exit>

0000000000000b7a <unlinkread>:
{
     b7a:	7179                	addi	sp,sp,-48
     b7c:	f406                	sd	ra,40(sp)
     b7e:	f022                	sd	s0,32(sp)
     b80:	ec26                	sd	s1,24(sp)
     b82:	e84a                	sd	s2,16(sp)
     b84:	e44e                	sd	s3,8(sp)
     b86:	1800                	addi	s0,sp,48
     b88:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b8a:	20200593          	li	a1,514
     b8e:	00005517          	auipc	a0,0x5
     b92:	c6250513          	addi	a0,a0,-926 # 57f0 <malloc+0x626>
     b96:	1b2040ef          	jal	4d48 <open>
  if(fd < 0){
     b9a:	0a054f63          	bltz	a0,c58 <unlinkread+0xde>
     b9e:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     ba0:	4615                	li	a2,5
     ba2:	00005597          	auipc	a1,0x5
     ba6:	c7e58593          	addi	a1,a1,-898 # 5820 <malloc+0x656>
     baa:	17e040ef          	jal	4d28 <write>
  close(fd);
     bae:	8526                	mv	a0,s1
     bb0:	180040ef          	jal	4d30 <close>
  fd = open("unlinkread", O_RDWR);
     bb4:	4589                	li	a1,2
     bb6:	00005517          	auipc	a0,0x5
     bba:	c3a50513          	addi	a0,a0,-966 # 57f0 <malloc+0x626>
     bbe:	18a040ef          	jal	4d48 <open>
     bc2:	84aa                	mv	s1,a0
  if(fd < 0){
     bc4:	0a054463          	bltz	a0,c6c <unlinkread+0xf2>
  if(unlink("unlinkread") != 0){
     bc8:	00005517          	auipc	a0,0x5
     bcc:	c2850513          	addi	a0,a0,-984 # 57f0 <malloc+0x626>
     bd0:	188040ef          	jal	4d58 <unlink>
     bd4:	e555                	bnez	a0,c80 <unlinkread+0x106>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     bd6:	20200593          	li	a1,514
     bda:	00005517          	auipc	a0,0x5
     bde:	c1650513          	addi	a0,a0,-1002 # 57f0 <malloc+0x626>
     be2:	166040ef          	jal	4d48 <open>
     be6:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     be8:	460d                	li	a2,3
     bea:	00005597          	auipc	a1,0x5
     bee:	c7e58593          	addi	a1,a1,-898 # 5868 <malloc+0x69e>
     bf2:	136040ef          	jal	4d28 <write>
  close(fd1);
     bf6:	854a                	mv	a0,s2
     bf8:	138040ef          	jal	4d30 <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     bfc:	660d                	lui	a2,0x3
     bfe:	0000b597          	auipc	a1,0xb
     c02:	07a58593          	addi	a1,a1,122 # bc78 <buf>
     c06:	8526                	mv	a0,s1
     c08:	118040ef          	jal	4d20 <read>
     c0c:	4795                	li	a5,5
     c0e:	08f51363          	bne	a0,a5,c94 <unlinkread+0x11a>
  if(buf[0] != 'h'){
     c12:	0000b717          	auipc	a4,0xb
     c16:	06674703          	lbu	a4,102(a4) # bc78 <buf>
     c1a:	06800793          	li	a5,104
     c1e:	08f71563          	bne	a4,a5,ca8 <unlinkread+0x12e>
  if(write(fd, buf, 10) != 10){
     c22:	4629                	li	a2,10
     c24:	0000b597          	auipc	a1,0xb
     c28:	05458593          	addi	a1,a1,84 # bc78 <buf>
     c2c:	8526                	mv	a0,s1
     c2e:	0fa040ef          	jal	4d28 <write>
     c32:	47a9                	li	a5,10
     c34:	08f51463          	bne	a0,a5,cbc <unlinkread+0x142>
  close(fd);
     c38:	8526                	mv	a0,s1
     c3a:	0f6040ef          	jal	4d30 <close>
  unlink("unlinkread");
     c3e:	00005517          	auipc	a0,0x5
     c42:	bb250513          	addi	a0,a0,-1102 # 57f0 <malloc+0x626>
     c46:	112040ef          	jal	4d58 <unlink>
}
     c4a:	70a2                	ld	ra,40(sp)
     c4c:	7402                	ld	s0,32(sp)
     c4e:	64e2                	ld	s1,24(sp)
     c50:	6942                	ld	s2,16(sp)
     c52:	69a2                	ld	s3,8(sp)
     c54:	6145                	addi	sp,sp,48
     c56:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     c58:	85ce                	mv	a1,s3
     c5a:	00005517          	auipc	a0,0x5
     c5e:	ba650513          	addi	a0,a0,-1114 # 5800 <malloc+0x636>
     c62:	4b0040ef          	jal	5112 <printf>
    exit(1);
     c66:	4505                	li	a0,1
     c68:	0a0040ef          	jal	4d08 <exit>
    printf("%s: open unlinkread failed\n", s);
     c6c:	85ce                	mv	a1,s3
     c6e:	00005517          	auipc	a0,0x5
     c72:	bba50513          	addi	a0,a0,-1094 # 5828 <malloc+0x65e>
     c76:	49c040ef          	jal	5112 <printf>
    exit(1);
     c7a:	4505                	li	a0,1
     c7c:	08c040ef          	jal	4d08 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     c80:	85ce                	mv	a1,s3
     c82:	00005517          	auipc	a0,0x5
     c86:	bc650513          	addi	a0,a0,-1082 # 5848 <malloc+0x67e>
     c8a:	488040ef          	jal	5112 <printf>
    exit(1);
     c8e:	4505                	li	a0,1
     c90:	078040ef          	jal	4d08 <exit>
    printf("%s: unlinkread read failed", s);
     c94:	85ce                	mv	a1,s3
     c96:	00005517          	auipc	a0,0x5
     c9a:	bda50513          	addi	a0,a0,-1062 # 5870 <malloc+0x6a6>
     c9e:	474040ef          	jal	5112 <printf>
    exit(1);
     ca2:	4505                	li	a0,1
     ca4:	064040ef          	jal	4d08 <exit>
    printf("%s: unlinkread wrong data\n", s);
     ca8:	85ce                	mv	a1,s3
     caa:	00005517          	auipc	a0,0x5
     cae:	be650513          	addi	a0,a0,-1050 # 5890 <malloc+0x6c6>
     cb2:	460040ef          	jal	5112 <printf>
    exit(1);
     cb6:	4505                	li	a0,1
     cb8:	050040ef          	jal	4d08 <exit>
    printf("%s: unlinkread write failed\n", s);
     cbc:	85ce                	mv	a1,s3
     cbe:	00005517          	auipc	a0,0x5
     cc2:	bf250513          	addi	a0,a0,-1038 # 58b0 <malloc+0x6e6>
     cc6:	44c040ef          	jal	5112 <printf>
    exit(1);
     cca:	4505                	li	a0,1
     ccc:	03c040ef          	jal	4d08 <exit>

0000000000000cd0 <linktest>:
{
     cd0:	1101                	addi	sp,sp,-32
     cd2:	ec06                	sd	ra,24(sp)
     cd4:	e822                	sd	s0,16(sp)
     cd6:	e426                	sd	s1,8(sp)
     cd8:	e04a                	sd	s2,0(sp)
     cda:	1000                	addi	s0,sp,32
     cdc:	892a                	mv	s2,a0
  unlink("lf1");
     cde:	00005517          	auipc	a0,0x5
     ce2:	bf250513          	addi	a0,a0,-1038 # 58d0 <malloc+0x706>
     ce6:	072040ef          	jal	4d58 <unlink>
  unlink("lf2");
     cea:	00005517          	auipc	a0,0x5
     cee:	bee50513          	addi	a0,a0,-1042 # 58d8 <malloc+0x70e>
     cf2:	066040ef          	jal	4d58 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     cf6:	20200593          	li	a1,514
     cfa:	00005517          	auipc	a0,0x5
     cfe:	bd650513          	addi	a0,a0,-1066 # 58d0 <malloc+0x706>
     d02:	046040ef          	jal	4d48 <open>
  if(fd < 0){
     d06:	0c054f63          	bltz	a0,de4 <linktest+0x114>
     d0a:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     d0c:	4615                	li	a2,5
     d0e:	00005597          	auipc	a1,0x5
     d12:	b1258593          	addi	a1,a1,-1262 # 5820 <malloc+0x656>
     d16:	012040ef          	jal	4d28 <write>
     d1a:	4795                	li	a5,5
     d1c:	0cf51e63          	bne	a0,a5,df8 <linktest+0x128>
  close(fd);
     d20:	8526                	mv	a0,s1
     d22:	00e040ef          	jal	4d30 <close>
  if(link("lf1", "lf2") < 0){
     d26:	00005597          	auipc	a1,0x5
     d2a:	bb258593          	addi	a1,a1,-1102 # 58d8 <malloc+0x70e>
     d2e:	00005517          	auipc	a0,0x5
     d32:	ba250513          	addi	a0,a0,-1118 # 58d0 <malloc+0x706>
     d36:	032040ef          	jal	4d68 <link>
     d3a:	0c054963          	bltz	a0,e0c <linktest+0x13c>
  unlink("lf1");
     d3e:	00005517          	auipc	a0,0x5
     d42:	b9250513          	addi	a0,a0,-1134 # 58d0 <malloc+0x706>
     d46:	012040ef          	jal	4d58 <unlink>
  if(open("lf1", 0) >= 0){
     d4a:	4581                	li	a1,0
     d4c:	00005517          	auipc	a0,0x5
     d50:	b8450513          	addi	a0,a0,-1148 # 58d0 <malloc+0x706>
     d54:	7f5030ef          	jal	4d48 <open>
     d58:	0c055463          	bgez	a0,e20 <linktest+0x150>
  fd = open("lf2", 0);
     d5c:	4581                	li	a1,0
     d5e:	00005517          	auipc	a0,0x5
     d62:	b7a50513          	addi	a0,a0,-1158 # 58d8 <malloc+0x70e>
     d66:	7e3030ef          	jal	4d48 <open>
     d6a:	84aa                	mv	s1,a0
  if(fd < 0){
     d6c:	0c054463          	bltz	a0,e34 <linktest+0x164>
  if(read(fd, buf, sizeof(buf)) != SZ){
     d70:	660d                	lui	a2,0x3
     d72:	0000b597          	auipc	a1,0xb
     d76:	f0658593          	addi	a1,a1,-250 # bc78 <buf>
     d7a:	7a7030ef          	jal	4d20 <read>
     d7e:	4795                	li	a5,5
     d80:	0cf51463          	bne	a0,a5,e48 <linktest+0x178>
  close(fd);
     d84:	8526                	mv	a0,s1
     d86:	7ab030ef          	jal	4d30 <close>
  if(link("lf2", "lf2") >= 0){
     d8a:	00005597          	auipc	a1,0x5
     d8e:	b4e58593          	addi	a1,a1,-1202 # 58d8 <malloc+0x70e>
     d92:	852e                	mv	a0,a1
     d94:	7d5030ef          	jal	4d68 <link>
     d98:	0c055263          	bgez	a0,e5c <linktest+0x18c>
  unlink("lf2");
     d9c:	00005517          	auipc	a0,0x5
     da0:	b3c50513          	addi	a0,a0,-1220 # 58d8 <malloc+0x70e>
     da4:	7b5030ef          	jal	4d58 <unlink>
  if(link("lf2", "lf1") >= 0){
     da8:	00005597          	auipc	a1,0x5
     dac:	b2858593          	addi	a1,a1,-1240 # 58d0 <malloc+0x706>
     db0:	00005517          	auipc	a0,0x5
     db4:	b2850513          	addi	a0,a0,-1240 # 58d8 <malloc+0x70e>
     db8:	7b1030ef          	jal	4d68 <link>
     dbc:	0a055a63          	bgez	a0,e70 <linktest+0x1a0>
  if(link(".", "lf1") >= 0){
     dc0:	00005597          	auipc	a1,0x5
     dc4:	b1058593          	addi	a1,a1,-1264 # 58d0 <malloc+0x706>
     dc8:	00005517          	auipc	a0,0x5
     dcc:	c1850513          	addi	a0,a0,-1000 # 59e0 <malloc+0x816>
     dd0:	799030ef          	jal	4d68 <link>
     dd4:	0a055863          	bgez	a0,e84 <linktest+0x1b4>
}
     dd8:	60e2                	ld	ra,24(sp)
     dda:	6442                	ld	s0,16(sp)
     ddc:	64a2                	ld	s1,8(sp)
     dde:	6902                	ld	s2,0(sp)
     de0:	6105                	addi	sp,sp,32
     de2:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     de4:	85ca                	mv	a1,s2
     de6:	00005517          	auipc	a0,0x5
     dea:	afa50513          	addi	a0,a0,-1286 # 58e0 <malloc+0x716>
     dee:	324040ef          	jal	5112 <printf>
    exit(1);
     df2:	4505                	li	a0,1
     df4:	715030ef          	jal	4d08 <exit>
    printf("%s: write lf1 failed\n", s);
     df8:	85ca                	mv	a1,s2
     dfa:	00005517          	auipc	a0,0x5
     dfe:	afe50513          	addi	a0,a0,-1282 # 58f8 <malloc+0x72e>
     e02:	310040ef          	jal	5112 <printf>
    exit(1);
     e06:	4505                	li	a0,1
     e08:	701030ef          	jal	4d08 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     e0c:	85ca                	mv	a1,s2
     e0e:	00005517          	auipc	a0,0x5
     e12:	b0250513          	addi	a0,a0,-1278 # 5910 <malloc+0x746>
     e16:	2fc040ef          	jal	5112 <printf>
    exit(1);
     e1a:	4505                	li	a0,1
     e1c:	6ed030ef          	jal	4d08 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     e20:	85ca                	mv	a1,s2
     e22:	00005517          	auipc	a0,0x5
     e26:	b0e50513          	addi	a0,a0,-1266 # 5930 <malloc+0x766>
     e2a:	2e8040ef          	jal	5112 <printf>
    exit(1);
     e2e:	4505                	li	a0,1
     e30:	6d9030ef          	jal	4d08 <exit>
    printf("%s: open lf2 failed\n", s);
     e34:	85ca                	mv	a1,s2
     e36:	00005517          	auipc	a0,0x5
     e3a:	b2a50513          	addi	a0,a0,-1238 # 5960 <malloc+0x796>
     e3e:	2d4040ef          	jal	5112 <printf>
    exit(1);
     e42:	4505                	li	a0,1
     e44:	6c5030ef          	jal	4d08 <exit>
    printf("%s: read lf2 failed\n", s);
     e48:	85ca                	mv	a1,s2
     e4a:	00005517          	auipc	a0,0x5
     e4e:	b2e50513          	addi	a0,a0,-1234 # 5978 <malloc+0x7ae>
     e52:	2c0040ef          	jal	5112 <printf>
    exit(1);
     e56:	4505                	li	a0,1
     e58:	6b1030ef          	jal	4d08 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     e5c:	85ca                	mv	a1,s2
     e5e:	00005517          	auipc	a0,0x5
     e62:	b3250513          	addi	a0,a0,-1230 # 5990 <malloc+0x7c6>
     e66:	2ac040ef          	jal	5112 <printf>
    exit(1);
     e6a:	4505                	li	a0,1
     e6c:	69d030ef          	jal	4d08 <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
     e70:	85ca                	mv	a1,s2
     e72:	00005517          	auipc	a0,0x5
     e76:	b4650513          	addi	a0,a0,-1210 # 59b8 <malloc+0x7ee>
     e7a:	298040ef          	jal	5112 <printf>
    exit(1);
     e7e:	4505                	li	a0,1
     e80:	689030ef          	jal	4d08 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     e84:	85ca                	mv	a1,s2
     e86:	00005517          	auipc	a0,0x5
     e8a:	b6250513          	addi	a0,a0,-1182 # 59e8 <malloc+0x81e>
     e8e:	284040ef          	jal	5112 <printf>
    exit(1);
     e92:	4505                	li	a0,1
     e94:	675030ef          	jal	4d08 <exit>

0000000000000e98 <validatetest>:
{
     e98:	7139                	addi	sp,sp,-64
     e9a:	fc06                	sd	ra,56(sp)
     e9c:	f822                	sd	s0,48(sp)
     e9e:	f426                	sd	s1,40(sp)
     ea0:	f04a                	sd	s2,32(sp)
     ea2:	ec4e                	sd	s3,24(sp)
     ea4:	e852                	sd	s4,16(sp)
     ea6:	e456                	sd	s5,8(sp)
     ea8:	e05a                	sd	s6,0(sp)
     eaa:	0080                	addi	s0,sp,64
     eac:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     eae:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
     eb0:	00005997          	auipc	s3,0x5
     eb4:	b5898993          	addi	s3,s3,-1192 # 5a08 <malloc+0x83e>
     eb8:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     eba:	6a85                	lui	s5,0x1
     ebc:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
     ec0:	85a6                	mv	a1,s1
     ec2:	854e                	mv	a0,s3
     ec4:	6a5030ef          	jal	4d68 <link>
     ec8:	01251f63          	bne	a0,s2,ee6 <validatetest+0x4e>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     ecc:	94d6                	add	s1,s1,s5
     ece:	ff4499e3          	bne	s1,s4,ec0 <validatetest+0x28>
}
     ed2:	70e2                	ld	ra,56(sp)
     ed4:	7442                	ld	s0,48(sp)
     ed6:	74a2                	ld	s1,40(sp)
     ed8:	7902                	ld	s2,32(sp)
     eda:	69e2                	ld	s3,24(sp)
     edc:	6a42                	ld	s4,16(sp)
     ede:	6aa2                	ld	s5,8(sp)
     ee0:	6b02                	ld	s6,0(sp)
     ee2:	6121                	addi	sp,sp,64
     ee4:	8082                	ret
      printf("%s: link should not succeed\n", s);
     ee6:	85da                	mv	a1,s6
     ee8:	00005517          	auipc	a0,0x5
     eec:	b3050513          	addi	a0,a0,-1232 # 5a18 <malloc+0x84e>
     ef0:	222040ef          	jal	5112 <printf>
      exit(1);
     ef4:	4505                	li	a0,1
     ef6:	613030ef          	jal	4d08 <exit>

0000000000000efa <bigdir>:
{
     efa:	711d                	addi	sp,sp,-96
     efc:	ec86                	sd	ra,88(sp)
     efe:	e8a2                	sd	s0,80(sp)
     f00:	e4a6                	sd	s1,72(sp)
     f02:	e0ca                	sd	s2,64(sp)
     f04:	fc4e                	sd	s3,56(sp)
     f06:	f852                	sd	s4,48(sp)
     f08:	f456                	sd	s5,40(sp)
     f0a:	f05a                	sd	s6,32(sp)
     f0c:	ec5e                	sd	s7,24(sp)
     f0e:	1080                	addi	s0,sp,96
     f10:	89aa                	mv	s3,a0
  unlink("bd");
     f12:	00005517          	auipc	a0,0x5
     f16:	b2650513          	addi	a0,a0,-1242 # 5a38 <malloc+0x86e>
     f1a:	63f030ef          	jal	4d58 <unlink>
  fd = open("bd", O_CREATE);
     f1e:	20000593          	li	a1,512
     f22:	00005517          	auipc	a0,0x5
     f26:	b1650513          	addi	a0,a0,-1258 # 5a38 <malloc+0x86e>
     f2a:	61f030ef          	jal	4d48 <open>
  if(fd < 0){
     f2e:	0c054463          	bltz	a0,ff6 <bigdir+0xfc>
  close(fd);
     f32:	5ff030ef          	jal	4d30 <close>
  for(i = 0; i < N; i++){
     f36:	4901                	li	s2,0
    name[0] = 'x';
     f38:	07800b13          	li	s6,120
    if(link("bd", name) != 0){
     f3c:	fa040a93          	addi	s5,s0,-96
     f40:	00005a17          	auipc	s4,0x5
     f44:	af8a0a13          	addi	s4,s4,-1288 # 5a38 <malloc+0x86e>
  for(i = 0; i < N; i++){
     f48:	1f400b93          	li	s7,500
    name[0] = 'x';
     f4c:	fb640023          	sb	s6,-96(s0)
    name[1] = '0' + (i / 64);
     f50:	41f9571b          	sraiw	a4,s2,0x1f
     f54:	01a7571b          	srliw	a4,a4,0x1a
     f58:	012707bb          	addw	a5,a4,s2
     f5c:	4067d69b          	sraiw	a3,a5,0x6
     f60:	0306869b          	addiw	a3,a3,48
     f64:	fad400a3          	sb	a3,-95(s0)
    name[2] = '0' + (i % 64);
     f68:	03f7f793          	andi	a5,a5,63
     f6c:	9f99                	subw	a5,a5,a4
     f6e:	0307879b          	addiw	a5,a5,48
     f72:	faf40123          	sb	a5,-94(s0)
    name[3] = '\0';
     f76:	fa0401a3          	sb	zero,-93(s0)
    if(link("bd", name) != 0){
     f7a:	85d6                	mv	a1,s5
     f7c:	8552                	mv	a0,s4
     f7e:	5eb030ef          	jal	4d68 <link>
     f82:	84aa                	mv	s1,a0
     f84:	e159                	bnez	a0,100a <bigdir+0x110>
  for(i = 0; i < N; i++){
     f86:	2905                	addiw	s2,s2,1
     f88:	fd7912e3          	bne	s2,s7,f4c <bigdir+0x52>
  unlink("bd");
     f8c:	00005517          	auipc	a0,0x5
     f90:	aac50513          	addi	a0,a0,-1364 # 5a38 <malloc+0x86e>
     f94:	5c5030ef          	jal	4d58 <unlink>
    name[0] = 'x';
     f98:	07800a13          	li	s4,120
    if(unlink(name) != 0){
     f9c:	fa040913          	addi	s2,s0,-96
  for(i = 0; i < N; i++){
     fa0:	1f400a93          	li	s5,500
    name[0] = 'x';
     fa4:	fb440023          	sb	s4,-96(s0)
    name[1] = '0' + (i / 64);
     fa8:	41f4d71b          	sraiw	a4,s1,0x1f
     fac:	01a7571b          	srliw	a4,a4,0x1a
     fb0:	009707bb          	addw	a5,a4,s1
     fb4:	4067d69b          	sraiw	a3,a5,0x6
     fb8:	0306869b          	addiw	a3,a3,48
     fbc:	fad400a3          	sb	a3,-95(s0)
    name[2] = '0' + (i % 64);
     fc0:	03f7f793          	andi	a5,a5,63
     fc4:	9f99                	subw	a5,a5,a4
     fc6:	0307879b          	addiw	a5,a5,48
     fca:	faf40123          	sb	a5,-94(s0)
    name[3] = '\0';
     fce:	fa0401a3          	sb	zero,-93(s0)
    if(unlink(name) != 0){
     fd2:	854a                	mv	a0,s2
     fd4:	585030ef          	jal	4d58 <unlink>
     fd8:	e531                	bnez	a0,1024 <bigdir+0x12a>
  for(i = 0; i < N; i++){
     fda:	2485                	addiw	s1,s1,1
     fdc:	fd5494e3          	bne	s1,s5,fa4 <bigdir+0xaa>
}
     fe0:	60e6                	ld	ra,88(sp)
     fe2:	6446                	ld	s0,80(sp)
     fe4:	64a6                	ld	s1,72(sp)
     fe6:	6906                	ld	s2,64(sp)
     fe8:	79e2                	ld	s3,56(sp)
     fea:	7a42                	ld	s4,48(sp)
     fec:	7aa2                	ld	s5,40(sp)
     fee:	7b02                	ld	s6,32(sp)
     ff0:	6be2                	ld	s7,24(sp)
     ff2:	6125                	addi	sp,sp,96
     ff4:	8082                	ret
    printf("%s: bigdir create failed\n", s);
     ff6:	85ce                	mv	a1,s3
     ff8:	00005517          	auipc	a0,0x5
     ffc:	a4850513          	addi	a0,a0,-1464 # 5a40 <malloc+0x876>
    1000:	112040ef          	jal	5112 <printf>
    exit(1);
    1004:	4505                	li	a0,1
    1006:	503030ef          	jal	4d08 <exit>
      printf("%s: bigdir i=%d link(bd, %s) failed\n", s, i, name);
    100a:	fa040693          	addi	a3,s0,-96
    100e:	864a                	mv	a2,s2
    1010:	85ce                	mv	a1,s3
    1012:	00005517          	auipc	a0,0x5
    1016:	a4e50513          	addi	a0,a0,-1458 # 5a60 <malloc+0x896>
    101a:	0f8040ef          	jal	5112 <printf>
      exit(1);
    101e:	4505                	li	a0,1
    1020:	4e9030ef          	jal	4d08 <exit>
      printf("%s: bigdir unlink failed", s);
    1024:	85ce                	mv	a1,s3
    1026:	00005517          	auipc	a0,0x5
    102a:	a6250513          	addi	a0,a0,-1438 # 5a88 <malloc+0x8be>
    102e:	0e4040ef          	jal	5112 <printf>
      exit(1);
    1032:	4505                	li	a0,1
    1034:	4d5030ef          	jal	4d08 <exit>

0000000000001038 <pgbug>:
{
    1038:	7179                	addi	sp,sp,-48
    103a:	f406                	sd	ra,40(sp)
    103c:	f022                	sd	s0,32(sp)
    103e:	ec26                	sd	s1,24(sp)
    1040:	1800                	addi	s0,sp,48
  argv[0] = 0;
    1042:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
    1046:	00007497          	auipc	s1,0x7
    104a:	fba48493          	addi	s1,s1,-70 # 8000 <big>
    104e:	fd840593          	addi	a1,s0,-40
    1052:	6088                	ld	a0,0(s1)
    1054:	4ed030ef          	jal	4d40 <exec>
  pipe(big);
    1058:	6088                	ld	a0,0(s1)
    105a:	4bf030ef          	jal	4d18 <pipe>
  exit(0);
    105e:	4501                	li	a0,0
    1060:	4a9030ef          	jal	4d08 <exit>

0000000000001064 <badarg>:
{
    1064:	7139                	addi	sp,sp,-64
    1066:	fc06                	sd	ra,56(sp)
    1068:	f822                	sd	s0,48(sp)
    106a:	f426                	sd	s1,40(sp)
    106c:	f04a                	sd	s2,32(sp)
    106e:	ec4e                	sd	s3,24(sp)
    1070:	e852                	sd	s4,16(sp)
    1072:	0080                	addi	s0,sp,64
    1074:	64b1                	lui	s1,0xc
    1076:	35048493          	addi	s1,s1,848 # c350 <buf+0x6d8>
    argv[0] = (char*)0xffffffff;
    107a:	597d                	li	s2,-1
    107c:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
    1080:	fc040a13          	addi	s4,s0,-64
    1084:	00004997          	auipc	s3,0x4
    1088:	27498993          	addi	s3,s3,628 # 52f8 <malloc+0x12e>
    argv[0] = (char*)0xffffffff;
    108c:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1090:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    1094:	85d2                	mv	a1,s4
    1096:	854e                	mv	a0,s3
    1098:	4a9030ef          	jal	4d40 <exec>
  for(int i = 0; i < 50000; i++){
    109c:	34fd                	addiw	s1,s1,-1
    109e:	f4fd                	bnez	s1,108c <badarg+0x28>
  exit(0);
    10a0:	4501                	li	a0,0
    10a2:	467030ef          	jal	4d08 <exit>

00000000000010a6 <copyinstr2>:
{
    10a6:	7155                	addi	sp,sp,-208
    10a8:	e586                	sd	ra,200(sp)
    10aa:	e1a2                	sd	s0,192(sp)
    10ac:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    10ae:	f6840793          	addi	a5,s0,-152
    10b2:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    10b6:	07800713          	li	a4,120
    10ba:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    10be:	0785                	addi	a5,a5,1
    10c0:	fed79de3          	bne	a5,a3,10ba <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    10c4:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    10c8:	f6840513          	addi	a0,s0,-152
    10cc:	48d030ef          	jal	4d58 <unlink>
  if(ret != -1){
    10d0:	57fd                	li	a5,-1
    10d2:	0cf51263          	bne	a0,a5,1196 <copyinstr2+0xf0>
  int fd = open(b, O_CREATE | O_WRONLY);
    10d6:	20100593          	li	a1,513
    10da:	f6840513          	addi	a0,s0,-152
    10de:	46b030ef          	jal	4d48 <open>
  if(fd != -1){
    10e2:	57fd                	li	a5,-1
    10e4:	0cf51563          	bne	a0,a5,11ae <copyinstr2+0x108>
  ret = link(b, b);
    10e8:	f6840513          	addi	a0,s0,-152
    10ec:	85aa                	mv	a1,a0
    10ee:	47b030ef          	jal	4d68 <link>
  if(ret != -1){
    10f2:	57fd                	li	a5,-1
    10f4:	0cf51963          	bne	a0,a5,11c6 <copyinstr2+0x120>
  char *args[] = { "xx", 0 };
    10f8:	00006797          	auipc	a5,0x6
    10fc:	ae078793          	addi	a5,a5,-1312 # 6bd8 <malloc+0x1a0e>
    1100:	f4f43c23          	sd	a5,-168(s0)
    1104:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1108:	f5840593          	addi	a1,s0,-168
    110c:	f6840513          	addi	a0,s0,-152
    1110:	431030ef          	jal	4d40 <exec>
  if(ret != -1){
    1114:	57fd                	li	a5,-1
    1116:	0cf51563          	bne	a0,a5,11e0 <copyinstr2+0x13a>
  int pid = fork();
    111a:	3e7030ef          	jal	4d00 <fork>
  if(pid < 0){
    111e:	0c054d63          	bltz	a0,11f8 <copyinstr2+0x152>
  if(pid == 0){
    1122:	0e051863          	bnez	a0,1212 <copyinstr2+0x16c>
    1126:	00007797          	auipc	a5,0x7
    112a:	43a78793          	addi	a5,a5,1082 # 8560 <big.0>
    112e:	00008697          	auipc	a3,0x8
    1132:	43268693          	addi	a3,a3,1074 # 9560 <big.0+0x1000>
      big[i] = 'x';
    1136:	07800713          	li	a4,120
    113a:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    113e:	0785                	addi	a5,a5,1
    1140:	fed79de3          	bne	a5,a3,113a <copyinstr2+0x94>
    big[PGSIZE] = '\0';
    1144:	00008797          	auipc	a5,0x8
    1148:	40078e23          	sb	zero,1052(a5) # 9560 <big.0+0x1000>
    char *args2[] = { big, big, big, 0 };
    114c:	00006797          	auipc	a5,0x6
    1150:	50c78793          	addi	a5,a5,1292 # 7658 <malloc+0x248e>
    1154:	6fb0                	ld	a2,88(a5)
    1156:	73b4                	ld	a3,96(a5)
    1158:	77b8                	ld	a4,104(a5)
    115a:	7bbc                	ld	a5,112(a5)
    115c:	f2c43823          	sd	a2,-208(s0)
    1160:	f2d43c23          	sd	a3,-200(s0)
    1164:	f4e43023          	sd	a4,-192(s0)
    1168:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    116c:	f3040593          	addi	a1,s0,-208
    1170:	00004517          	auipc	a0,0x4
    1174:	18850513          	addi	a0,a0,392 # 52f8 <malloc+0x12e>
    1178:	3c9030ef          	jal	4d40 <exec>
    if(ret != -1){
    117c:	57fd                	li	a5,-1
    117e:	08f50663          	beq	a0,a5,120a <copyinstr2+0x164>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    1182:	85be                	mv	a1,a5
    1184:	00005517          	auipc	a0,0x5
    1188:	9ac50513          	addi	a0,a0,-1620 # 5b30 <malloc+0x966>
    118c:	787030ef          	jal	5112 <printf>
      exit(1);
    1190:	4505                	li	a0,1
    1192:	377030ef          	jal	4d08 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    1196:	862a                	mv	a2,a0
    1198:	f6840593          	addi	a1,s0,-152
    119c:	00005517          	auipc	a0,0x5
    11a0:	90c50513          	addi	a0,a0,-1780 # 5aa8 <malloc+0x8de>
    11a4:	76f030ef          	jal	5112 <printf>
    exit(1);
    11a8:	4505                	li	a0,1
    11aa:	35f030ef          	jal	4d08 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    11ae:	862a                	mv	a2,a0
    11b0:	f6840593          	addi	a1,s0,-152
    11b4:	00005517          	auipc	a0,0x5
    11b8:	91450513          	addi	a0,a0,-1772 # 5ac8 <malloc+0x8fe>
    11bc:	757030ef          	jal	5112 <printf>
    exit(1);
    11c0:	4505                	li	a0,1
    11c2:	347030ef          	jal	4d08 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    11c6:	f6840593          	addi	a1,s0,-152
    11ca:	86aa                	mv	a3,a0
    11cc:	862e                	mv	a2,a1
    11ce:	00005517          	auipc	a0,0x5
    11d2:	91a50513          	addi	a0,a0,-1766 # 5ae8 <malloc+0x91e>
    11d6:	73d030ef          	jal	5112 <printf>
    exit(1);
    11da:	4505                	li	a0,1
    11dc:	32d030ef          	jal	4d08 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    11e0:	863e                	mv	a2,a5
    11e2:	f6840593          	addi	a1,s0,-152
    11e6:	00005517          	auipc	a0,0x5
    11ea:	92a50513          	addi	a0,a0,-1750 # 5b10 <malloc+0x946>
    11ee:	725030ef          	jal	5112 <printf>
    exit(1);
    11f2:	4505                	li	a0,1
    11f4:	315030ef          	jal	4d08 <exit>
    printf("fork failed\n");
    11f8:	00006517          	auipc	a0,0x6
    11fc:	f0050513          	addi	a0,a0,-256 # 70f8 <malloc+0x1f2e>
    1200:	713030ef          	jal	5112 <printf>
    exit(1);
    1204:	4505                	li	a0,1
    1206:	303030ef          	jal	4d08 <exit>
    exit(747); // OK
    120a:	2eb00513          	li	a0,747
    120e:	2fb030ef          	jal	4d08 <exit>
  int st = 0;
    1212:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    1216:	f5440513          	addi	a0,s0,-172
    121a:	2f7030ef          	jal	4d10 <wait>
  if(st != 747){
    121e:	f5442703          	lw	a4,-172(s0)
    1222:	2eb00793          	li	a5,747
    1226:	00f71663          	bne	a4,a5,1232 <copyinstr2+0x18c>
}
    122a:	60ae                	ld	ra,200(sp)
    122c:	640e                	ld	s0,192(sp)
    122e:	6169                	addi	sp,sp,208
    1230:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    1232:	00005517          	auipc	a0,0x5
    1236:	92650513          	addi	a0,a0,-1754 # 5b58 <malloc+0x98e>
    123a:	6d9030ef          	jal	5112 <printf>
    exit(1);
    123e:	4505                	li	a0,1
    1240:	2c9030ef          	jal	4d08 <exit>

0000000000001244 <truncate3>:
{
    1244:	7175                	addi	sp,sp,-144
    1246:	e506                	sd	ra,136(sp)
    1248:	e122                	sd	s0,128(sp)
    124a:	ecd6                	sd	s5,88(sp)
    124c:	0900                	addi	s0,sp,144
    124e:	8aaa                	mv	s5,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    1250:	60100593          	li	a1,1537
    1254:	00004517          	auipc	a0,0x4
    1258:	0fc50513          	addi	a0,a0,252 # 5350 <malloc+0x186>
    125c:	2ed030ef          	jal	4d48 <open>
    1260:	2d1030ef          	jal	4d30 <close>
  pid = fork();
    1264:	29d030ef          	jal	4d00 <fork>
  if(pid < 0){
    1268:	06054d63          	bltz	a0,12e2 <truncate3+0x9e>
  if(pid == 0){
    126c:	e171                	bnez	a0,1330 <truncate3+0xec>
    126e:	fca6                	sd	s1,120(sp)
    1270:	f8ca                	sd	s2,112(sp)
    1272:	f4ce                	sd	s3,104(sp)
    1274:	f0d2                	sd	s4,96(sp)
    1276:	e8da                	sd	s6,80(sp)
    1278:	e4de                	sd	s7,72(sp)
    127a:	e0e2                	sd	s8,64(sp)
    127c:	fc66                	sd	s9,56(sp)
    127e:	06400913          	li	s2,100
      int fd = open("truncfile", O_WRONLY);
    1282:	4b05                	li	s6,1
    1284:	00004997          	auipc	s3,0x4
    1288:	0cc98993          	addi	s3,s3,204 # 5350 <malloc+0x186>
      int n = write(fd, "1234567890", 10);
    128c:	4a29                	li	s4,10
    128e:	00005b97          	auipc	s7,0x5
    1292:	92ab8b93          	addi	s7,s7,-1750 # 5bb8 <malloc+0x9ee>
      read(fd, buf, sizeof(buf));
    1296:	f7840c93          	addi	s9,s0,-136
    129a:	02000c13          	li	s8,32
      int fd = open("truncfile", O_WRONLY);
    129e:	85da                	mv	a1,s6
    12a0:	854e                	mv	a0,s3
    12a2:	2a7030ef          	jal	4d48 <open>
    12a6:	84aa                	mv	s1,a0
      if(fd < 0){
    12a8:	04054f63          	bltz	a0,1306 <truncate3+0xc2>
      int n = write(fd, "1234567890", 10);
    12ac:	8652                	mv	a2,s4
    12ae:	85de                	mv	a1,s7
    12b0:	279030ef          	jal	4d28 <write>
      if(n != 10){
    12b4:	07451363          	bne	a0,s4,131a <truncate3+0xd6>
      close(fd);
    12b8:	8526                	mv	a0,s1
    12ba:	277030ef          	jal	4d30 <close>
      fd = open("truncfile", O_RDONLY);
    12be:	4581                	li	a1,0
    12c0:	854e                	mv	a0,s3
    12c2:	287030ef          	jal	4d48 <open>
    12c6:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    12c8:	8662                	mv	a2,s8
    12ca:	85e6                	mv	a1,s9
    12cc:	255030ef          	jal	4d20 <read>
      close(fd);
    12d0:	8526                	mv	a0,s1
    12d2:	25f030ef          	jal	4d30 <close>
    for(int i = 0; i < 100; i++){
    12d6:	397d                	addiw	s2,s2,-1
    12d8:	fc0913e3          	bnez	s2,129e <truncate3+0x5a>
    exit(0);
    12dc:	4501                	li	a0,0
    12de:	22b030ef          	jal	4d08 <exit>
    12e2:	fca6                	sd	s1,120(sp)
    12e4:	f8ca                	sd	s2,112(sp)
    12e6:	f4ce                	sd	s3,104(sp)
    12e8:	f0d2                	sd	s4,96(sp)
    12ea:	e8da                	sd	s6,80(sp)
    12ec:	e4de                	sd	s7,72(sp)
    12ee:	e0e2                	sd	s8,64(sp)
    12f0:	fc66                	sd	s9,56(sp)
    printf("%s: fork failed\n", s);
    12f2:	85d6                	mv	a1,s5
    12f4:	00005517          	auipc	a0,0x5
    12f8:	89450513          	addi	a0,a0,-1900 # 5b88 <malloc+0x9be>
    12fc:	617030ef          	jal	5112 <printf>
    exit(1);
    1300:	4505                	li	a0,1
    1302:	207030ef          	jal	4d08 <exit>
        printf("%s: open failed\n", s);
    1306:	85d6                	mv	a1,s5
    1308:	00005517          	auipc	a0,0x5
    130c:	89850513          	addi	a0,a0,-1896 # 5ba0 <malloc+0x9d6>
    1310:	603030ef          	jal	5112 <printf>
        exit(1);
    1314:	4505                	li	a0,1
    1316:	1f3030ef          	jal	4d08 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    131a:	862a                	mv	a2,a0
    131c:	85d6                	mv	a1,s5
    131e:	00005517          	auipc	a0,0x5
    1322:	8aa50513          	addi	a0,a0,-1878 # 5bc8 <malloc+0x9fe>
    1326:	5ed030ef          	jal	5112 <printf>
        exit(1);
    132a:	4505                	li	a0,1
    132c:	1dd030ef          	jal	4d08 <exit>
    1330:	fca6                	sd	s1,120(sp)
    1332:	f8ca                	sd	s2,112(sp)
    1334:	f4ce                	sd	s3,104(sp)
    1336:	f0d2                	sd	s4,96(sp)
    1338:	e8da                	sd	s6,80(sp)
    133a:	e4de                	sd	s7,72(sp)
    133c:	09600913          	li	s2,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    1340:	60100b13          	li	s6,1537
    1344:	00004a17          	auipc	s4,0x4
    1348:	00ca0a13          	addi	s4,s4,12 # 5350 <malloc+0x186>
    int n = write(fd, "xxx", 3);
    134c:	498d                	li	s3,3
    134e:	00005b97          	auipc	s7,0x5
    1352:	89ab8b93          	addi	s7,s7,-1894 # 5be8 <malloc+0xa1e>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    1356:	85da                	mv	a1,s6
    1358:	8552                	mv	a0,s4
    135a:	1ef030ef          	jal	4d48 <open>
    135e:	84aa                	mv	s1,a0
    if(fd < 0){
    1360:	02054e63          	bltz	a0,139c <truncate3+0x158>
    int n = write(fd, "xxx", 3);
    1364:	864e                	mv	a2,s3
    1366:	85de                	mv	a1,s7
    1368:	1c1030ef          	jal	4d28 <write>
    if(n != 3){
    136c:	05351463          	bne	a0,s3,13b4 <truncate3+0x170>
    close(fd);
    1370:	8526                	mv	a0,s1
    1372:	1bf030ef          	jal	4d30 <close>
  for(int i = 0; i < 150; i++){
    1376:	397d                	addiw	s2,s2,-1
    1378:	fc091fe3          	bnez	s2,1356 <truncate3+0x112>
    137c:	e0e2                	sd	s8,64(sp)
    137e:	fc66                	sd	s9,56(sp)
  wait(&xstatus);
    1380:	f9c40513          	addi	a0,s0,-100
    1384:	18d030ef          	jal	4d10 <wait>
  unlink("truncfile");
    1388:	00004517          	auipc	a0,0x4
    138c:	fc850513          	addi	a0,a0,-56 # 5350 <malloc+0x186>
    1390:	1c9030ef          	jal	4d58 <unlink>
  exit(xstatus);
    1394:	f9c42503          	lw	a0,-100(s0)
    1398:	171030ef          	jal	4d08 <exit>
    139c:	e0e2                	sd	s8,64(sp)
    139e:	fc66                	sd	s9,56(sp)
      printf("%s: open failed\n", s);
    13a0:	85d6                	mv	a1,s5
    13a2:	00004517          	auipc	a0,0x4
    13a6:	7fe50513          	addi	a0,a0,2046 # 5ba0 <malloc+0x9d6>
    13aa:	569030ef          	jal	5112 <printf>
      exit(1);
    13ae:	4505                	li	a0,1
    13b0:	159030ef          	jal	4d08 <exit>
    13b4:	e0e2                	sd	s8,64(sp)
    13b6:	fc66                	sd	s9,56(sp)
      printf("%s: write got %d, expected 3\n", s, n);
    13b8:	862a                	mv	a2,a0
    13ba:	85d6                	mv	a1,s5
    13bc:	00005517          	auipc	a0,0x5
    13c0:	83450513          	addi	a0,a0,-1996 # 5bf0 <malloc+0xa26>
    13c4:	54f030ef          	jal	5112 <printf>
      exit(1);
    13c8:	4505                	li	a0,1
    13ca:	13f030ef          	jal	4d08 <exit>

00000000000013ce <exectest>:
{
    13ce:	715d                	addi	sp,sp,-80
    13d0:	e486                	sd	ra,72(sp)
    13d2:	e0a2                	sd	s0,64(sp)
    13d4:	f84a                	sd	s2,48(sp)
    13d6:	0880                	addi	s0,sp,80
    13d8:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    13da:	00004797          	auipc	a5,0x4
    13de:	f1e78793          	addi	a5,a5,-226 # 52f8 <malloc+0x12e>
    13e2:	fcf43023          	sd	a5,-64(s0)
    13e6:	00005797          	auipc	a5,0x5
    13ea:	82a78793          	addi	a5,a5,-2006 # 5c10 <malloc+0xa46>
    13ee:	fcf43423          	sd	a5,-56(s0)
    13f2:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    13f6:	00005517          	auipc	a0,0x5
    13fa:	82250513          	addi	a0,a0,-2014 # 5c18 <malloc+0xa4e>
    13fe:	15b030ef          	jal	4d58 <unlink>
  pid = fork();
    1402:	0ff030ef          	jal	4d00 <fork>
  if(pid < 0) {
    1406:	02054f63          	bltz	a0,1444 <exectest+0x76>
    140a:	fc26                	sd	s1,56(sp)
    140c:	84aa                	mv	s1,a0
  if(pid == 0) {
    140e:	e935                	bnez	a0,1482 <exectest+0xb4>
    close(1);
    1410:	4505                	li	a0,1
    1412:	11f030ef          	jal	4d30 <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    1416:	20100593          	li	a1,513
    141a:	00004517          	auipc	a0,0x4
    141e:	7fe50513          	addi	a0,a0,2046 # 5c18 <malloc+0xa4e>
    1422:	127030ef          	jal	4d48 <open>
    if(fd < 0) {
    1426:	02054a63          	bltz	a0,145a <exectest+0x8c>
    if(fd != 1) {
    142a:	4785                	li	a5,1
    142c:	04f50163          	beq	a0,a5,146e <exectest+0xa0>
      printf("%s: wrong fd\n", s);
    1430:	85ca                	mv	a1,s2
    1432:	00005517          	auipc	a0,0x5
    1436:	80650513          	addi	a0,a0,-2042 # 5c38 <malloc+0xa6e>
    143a:	4d9030ef          	jal	5112 <printf>
      exit(1);
    143e:	4505                	li	a0,1
    1440:	0c9030ef          	jal	4d08 <exit>
    1444:	fc26                	sd	s1,56(sp)
     printf("%s: fork failed\n", s);
    1446:	85ca                	mv	a1,s2
    1448:	00004517          	auipc	a0,0x4
    144c:	74050513          	addi	a0,a0,1856 # 5b88 <malloc+0x9be>
    1450:	4c3030ef          	jal	5112 <printf>
     exit(1);
    1454:	4505                	li	a0,1
    1456:	0b3030ef          	jal	4d08 <exit>
      printf("%s: create failed\n", s);
    145a:	85ca                	mv	a1,s2
    145c:	00004517          	auipc	a0,0x4
    1460:	7c450513          	addi	a0,a0,1988 # 5c20 <malloc+0xa56>
    1464:	4af030ef          	jal	5112 <printf>
      exit(1);
    1468:	4505                	li	a0,1
    146a:	09f030ef          	jal	4d08 <exit>
    if(exec("echo", echoargv) < 0){
    146e:	fc040593          	addi	a1,s0,-64
    1472:	00004517          	auipc	a0,0x4
    1476:	e8650513          	addi	a0,a0,-378 # 52f8 <malloc+0x12e>
    147a:	0c7030ef          	jal	4d40 <exec>
    147e:	00054d63          	bltz	a0,1498 <exectest+0xca>
  if (wait(&xstatus) != pid) {
    1482:	fdc40513          	addi	a0,s0,-36
    1486:	08b030ef          	jal	4d10 <wait>
    148a:	02951163          	bne	a0,s1,14ac <exectest+0xde>
  if(xstatus != 0)
    148e:	fdc42503          	lw	a0,-36(s0)
    1492:	c50d                	beqz	a0,14bc <exectest+0xee>
    exit(xstatus);
    1494:	075030ef          	jal	4d08 <exit>
      printf("%s: exec echo failed\n", s);
    1498:	85ca                	mv	a1,s2
    149a:	00004517          	auipc	a0,0x4
    149e:	7ae50513          	addi	a0,a0,1966 # 5c48 <malloc+0xa7e>
    14a2:	471030ef          	jal	5112 <printf>
      exit(1);
    14a6:	4505                	li	a0,1
    14a8:	061030ef          	jal	4d08 <exit>
    printf("%s: wait failed!\n", s);
    14ac:	85ca                	mv	a1,s2
    14ae:	00004517          	auipc	a0,0x4
    14b2:	7b250513          	addi	a0,a0,1970 # 5c60 <malloc+0xa96>
    14b6:	45d030ef          	jal	5112 <printf>
    14ba:	bfd1                	j	148e <exectest+0xc0>
  fd = open("echo-ok", O_RDONLY);
    14bc:	4581                	li	a1,0
    14be:	00004517          	auipc	a0,0x4
    14c2:	75a50513          	addi	a0,a0,1882 # 5c18 <malloc+0xa4e>
    14c6:	083030ef          	jal	4d48 <open>
  if(fd < 0) {
    14ca:	02054463          	bltz	a0,14f2 <exectest+0x124>
  if (read(fd, buf, 2) != 2) {
    14ce:	4609                	li	a2,2
    14d0:	fb840593          	addi	a1,s0,-72
    14d4:	04d030ef          	jal	4d20 <read>
    14d8:	4789                	li	a5,2
    14da:	02f50663          	beq	a0,a5,1506 <exectest+0x138>
    printf("%s: read failed\n", s);
    14de:	85ca                	mv	a1,s2
    14e0:	00004517          	auipc	a0,0x4
    14e4:	1e850513          	addi	a0,a0,488 # 56c8 <malloc+0x4fe>
    14e8:	42b030ef          	jal	5112 <printf>
    exit(1);
    14ec:	4505                	li	a0,1
    14ee:	01b030ef          	jal	4d08 <exit>
    printf("%s: open failed\n", s);
    14f2:	85ca                	mv	a1,s2
    14f4:	00004517          	auipc	a0,0x4
    14f8:	6ac50513          	addi	a0,a0,1708 # 5ba0 <malloc+0x9d6>
    14fc:	417030ef          	jal	5112 <printf>
    exit(1);
    1500:	4505                	li	a0,1
    1502:	007030ef          	jal	4d08 <exit>
  unlink("echo-ok");
    1506:	00004517          	auipc	a0,0x4
    150a:	71250513          	addi	a0,a0,1810 # 5c18 <malloc+0xa4e>
    150e:	04b030ef          	jal	4d58 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    1512:	fb844703          	lbu	a4,-72(s0)
    1516:	04f00793          	li	a5,79
    151a:	00f71863          	bne	a4,a5,152a <exectest+0x15c>
    151e:	fb944703          	lbu	a4,-71(s0)
    1522:	04b00793          	li	a5,75
    1526:	00f70c63          	beq	a4,a5,153e <exectest+0x170>
    printf("%s: wrong output\n", s);
    152a:	85ca                	mv	a1,s2
    152c:	00004517          	auipc	a0,0x4
    1530:	74c50513          	addi	a0,a0,1868 # 5c78 <malloc+0xaae>
    1534:	3df030ef          	jal	5112 <printf>
    exit(1);
    1538:	4505                	li	a0,1
    153a:	7ce030ef          	jal	4d08 <exit>
    exit(0);
    153e:	4501                	li	a0,0
    1540:	7c8030ef          	jal	4d08 <exit>

0000000000001544 <pipe1>:
{
    1544:	711d                	addi	sp,sp,-96
    1546:	ec86                	sd	ra,88(sp)
    1548:	e8a2                	sd	s0,80(sp)
    154a:	e0ca                	sd	s2,64(sp)
    154c:	1080                	addi	s0,sp,96
    154e:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    1550:	fa840513          	addi	a0,s0,-88
    1554:	7c4030ef          	jal	4d18 <pipe>
    1558:	e53d                	bnez	a0,15c6 <pipe1+0x82>
    155a:	e4a6                	sd	s1,72(sp)
    155c:	f852                	sd	s4,48(sp)
    155e:	84aa                	mv	s1,a0
  pid = fork();
    1560:	7a0030ef          	jal	4d00 <fork>
    1564:	8a2a                	mv	s4,a0
  if(pid == 0){
    1566:	c149                	beqz	a0,15e8 <pipe1+0xa4>
  } else if(pid > 0){
    1568:	14a05f63          	blez	a0,16c6 <pipe1+0x182>
    156c:	fc4e                	sd	s3,56(sp)
    156e:	f456                	sd	s5,40(sp)
    close(fds[1]);
    1570:	fac42503          	lw	a0,-84(s0)
    1574:	7bc030ef          	jal	4d30 <close>
    total = 0;
    1578:	8a26                	mv	s4,s1
    cc = 1;
    157a:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    157c:	0000aa97          	auipc	s5,0xa
    1580:	6fca8a93          	addi	s5,s5,1788 # bc78 <buf>
    1584:	864e                	mv	a2,s3
    1586:	85d6                	mv	a1,s5
    1588:	fa842503          	lw	a0,-88(s0)
    158c:	794030ef          	jal	4d20 <read>
    1590:	0ea05963          	blez	a0,1682 <pipe1+0x13e>
    1594:	0000a717          	auipc	a4,0xa
    1598:	6e470713          	addi	a4,a4,1764 # bc78 <buf>
    159c:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    15a0:	00074683          	lbu	a3,0(a4)
    15a4:	0ff4f793          	zext.b	a5,s1
    15a8:	2485                	addiw	s1,s1,1
    15aa:	0af69c63          	bne	a3,a5,1662 <pipe1+0x11e>
      for(i = 0; i < n; i++){
    15ae:	0705                	addi	a4,a4,1
    15b0:	fec498e3          	bne	s1,a2,15a0 <pipe1+0x5c>
      total += n;
    15b4:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    15b8:	0019999b          	slliw	s3,s3,0x1
      if(cc > sizeof(buf))
    15bc:	678d                	lui	a5,0x3
    15be:	fd37f3e3          	bgeu	a5,s3,1584 <pipe1+0x40>
        cc = sizeof(buf);
    15c2:	89be                	mv	s3,a5
    15c4:	b7c1                	j	1584 <pipe1+0x40>
    15c6:	e4a6                	sd	s1,72(sp)
    15c8:	fc4e                	sd	s3,56(sp)
    15ca:	f852                	sd	s4,48(sp)
    15cc:	f456                	sd	s5,40(sp)
    15ce:	f05a                	sd	s6,32(sp)
    15d0:	ec5e                	sd	s7,24(sp)
    15d2:	e862                	sd	s8,16(sp)
    printf("%s: pipe() failed\n", s);
    15d4:	85ca                	mv	a1,s2
    15d6:	00004517          	auipc	a0,0x4
    15da:	6ba50513          	addi	a0,a0,1722 # 5c90 <malloc+0xac6>
    15de:	335030ef          	jal	5112 <printf>
    exit(1);
    15e2:	4505                	li	a0,1
    15e4:	724030ef          	jal	4d08 <exit>
    15e8:	fc4e                	sd	s3,56(sp)
    15ea:	f456                	sd	s5,40(sp)
    15ec:	f05a                	sd	s6,32(sp)
    15ee:	ec5e                	sd	s7,24(sp)
    15f0:	e862                	sd	s8,16(sp)
    close(fds[0]);
    15f2:	fa842503          	lw	a0,-88(s0)
    15f6:	73a030ef          	jal	4d30 <close>
    for(n = 0; n < N; n++){
    15fa:	0000ab97          	auipc	s7,0xa
    15fe:	67eb8b93          	addi	s7,s7,1662 # bc78 <buf>
    1602:	417004bb          	negw	s1,s7
    1606:	0ff4f493          	zext.b	s1,s1
    160a:	409b8993          	addi	s3,s7,1033
      if(write(fds[1], buf, SZ) != SZ){
    160e:	40900a93          	li	s5,1033
    1612:	8c5e                	mv	s8,s7
    for(n = 0; n < N; n++){
    1614:	6b05                	lui	s6,0x1
    1616:	42db0b13          	addi	s6,s6,1069 # 142d <exectest+0x5f>
{
    161a:	87de                	mv	a5,s7
        buf[i] = seq++;
    161c:	0097873b          	addw	a4,a5,s1
    1620:	00e78023          	sb	a4,0(a5) # 3000 <subdir+0x2fe>
      for(i = 0; i < SZ; i++)
    1624:	0785                	addi	a5,a5,1
    1626:	ff379be3          	bne	a5,s3,161c <pipe1+0xd8>
    162a:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    162e:	8656                	mv	a2,s5
    1630:	85e2                	mv	a1,s8
    1632:	fac42503          	lw	a0,-84(s0)
    1636:	6f2030ef          	jal	4d28 <write>
    163a:	01551a63          	bne	a0,s5,164e <pipe1+0x10a>
    for(n = 0; n < N; n++){
    163e:	24a5                	addiw	s1,s1,9
    1640:	0ff4f493          	zext.b	s1,s1
    1644:	fd6a1be3          	bne	s4,s6,161a <pipe1+0xd6>
    exit(0);
    1648:	4501                	li	a0,0
    164a:	6be030ef          	jal	4d08 <exit>
        printf("%s: pipe1 oops 1\n", s);
    164e:	85ca                	mv	a1,s2
    1650:	00004517          	auipc	a0,0x4
    1654:	65850513          	addi	a0,a0,1624 # 5ca8 <malloc+0xade>
    1658:	2bb030ef          	jal	5112 <printf>
        exit(1);
    165c:	4505                	li	a0,1
    165e:	6aa030ef          	jal	4d08 <exit>
          printf("%s: pipe1 oops 2\n", s);
    1662:	85ca                	mv	a1,s2
    1664:	00004517          	auipc	a0,0x4
    1668:	65c50513          	addi	a0,a0,1628 # 5cc0 <malloc+0xaf6>
    166c:	2a7030ef          	jal	5112 <printf>
          return;
    1670:	64a6                	ld	s1,72(sp)
    1672:	79e2                	ld	s3,56(sp)
    1674:	7a42                	ld	s4,48(sp)
    1676:	7aa2                	ld	s5,40(sp)
}
    1678:	60e6                	ld	ra,88(sp)
    167a:	6446                	ld	s0,80(sp)
    167c:	6906                	ld	s2,64(sp)
    167e:	6125                	addi	sp,sp,96
    1680:	8082                	ret
    if(total != N * SZ){
    1682:	6785                	lui	a5,0x1
    1684:	42d78793          	addi	a5,a5,1069 # 142d <exectest+0x5f>
    1688:	02fa0063          	beq	s4,a5,16a8 <pipe1+0x164>
    168c:	f05a                	sd	s6,32(sp)
    168e:	ec5e                	sd	s7,24(sp)
    1690:	e862                	sd	s8,16(sp)
      printf("%s: pipe1 oops 3 total %d\n", s, total);
    1692:	8652                	mv	a2,s4
    1694:	85ca                	mv	a1,s2
    1696:	00004517          	auipc	a0,0x4
    169a:	64250513          	addi	a0,a0,1602 # 5cd8 <malloc+0xb0e>
    169e:	275030ef          	jal	5112 <printf>
      exit(1);
    16a2:	4505                	li	a0,1
    16a4:	664030ef          	jal	4d08 <exit>
    16a8:	f05a                	sd	s6,32(sp)
    16aa:	ec5e                	sd	s7,24(sp)
    16ac:	e862                	sd	s8,16(sp)
    close(fds[0]);
    16ae:	fa842503          	lw	a0,-88(s0)
    16b2:	67e030ef          	jal	4d30 <close>
    wait(&xstatus);
    16b6:	fa440513          	addi	a0,s0,-92
    16ba:	656030ef          	jal	4d10 <wait>
    exit(xstatus);
    16be:	fa442503          	lw	a0,-92(s0)
    16c2:	646030ef          	jal	4d08 <exit>
    16c6:	fc4e                	sd	s3,56(sp)
    16c8:	f456                	sd	s5,40(sp)
    16ca:	f05a                	sd	s6,32(sp)
    16cc:	ec5e                	sd	s7,24(sp)
    16ce:	e862                	sd	s8,16(sp)
    printf("%s: fork() failed\n", s);
    16d0:	85ca                	mv	a1,s2
    16d2:	00004517          	auipc	a0,0x4
    16d6:	62650513          	addi	a0,a0,1574 # 5cf8 <malloc+0xb2e>
    16da:	239030ef          	jal	5112 <printf>
    exit(1);
    16de:	4505                	li	a0,1
    16e0:	628030ef          	jal	4d08 <exit>

00000000000016e4 <exitwait>:
{
    16e4:	715d                	addi	sp,sp,-80
    16e6:	e486                	sd	ra,72(sp)
    16e8:	e0a2                	sd	s0,64(sp)
    16ea:	fc26                	sd	s1,56(sp)
    16ec:	f84a                	sd	s2,48(sp)
    16ee:	f44e                	sd	s3,40(sp)
    16f0:	f052                	sd	s4,32(sp)
    16f2:	ec56                	sd	s5,24(sp)
    16f4:	0880                	addi	s0,sp,80
    16f6:	8aaa                	mv	s5,a0
  for(i = 0; i < 100; i++){
    16f8:	4901                	li	s2,0
      if(wait(&xstate) != pid){
    16fa:	fbc40993          	addi	s3,s0,-68
  for(i = 0; i < 100; i++){
    16fe:	06400a13          	li	s4,100
    pid = fork();
    1702:	5fe030ef          	jal	4d00 <fork>
    1706:	84aa                	mv	s1,a0
    if(pid < 0){
    1708:	02054863          	bltz	a0,1738 <exitwait+0x54>
    if(pid){
    170c:	c525                	beqz	a0,1774 <exitwait+0x90>
      if(wait(&xstate) != pid){
    170e:	854e                	mv	a0,s3
    1710:	600030ef          	jal	4d10 <wait>
    1714:	02951c63          	bne	a0,s1,174c <exitwait+0x68>
      if(i != xstate) {
    1718:	fbc42783          	lw	a5,-68(s0)
    171c:	05279263          	bne	a5,s2,1760 <exitwait+0x7c>
  for(i = 0; i < 100; i++){
    1720:	2905                	addiw	s2,s2,1
    1722:	ff4910e3          	bne	s2,s4,1702 <exitwait+0x1e>
}
    1726:	60a6                	ld	ra,72(sp)
    1728:	6406                	ld	s0,64(sp)
    172a:	74e2                	ld	s1,56(sp)
    172c:	7942                	ld	s2,48(sp)
    172e:	79a2                	ld	s3,40(sp)
    1730:	7a02                	ld	s4,32(sp)
    1732:	6ae2                	ld	s5,24(sp)
    1734:	6161                	addi	sp,sp,80
    1736:	8082                	ret
      printf("%s: fork failed\n", s);
    1738:	85d6                	mv	a1,s5
    173a:	00004517          	auipc	a0,0x4
    173e:	44e50513          	addi	a0,a0,1102 # 5b88 <malloc+0x9be>
    1742:	1d1030ef          	jal	5112 <printf>
      exit(1);
    1746:	4505                	li	a0,1
    1748:	5c0030ef          	jal	4d08 <exit>
        printf("%s: wait wrong pid\n", s);
    174c:	85d6                	mv	a1,s5
    174e:	00004517          	auipc	a0,0x4
    1752:	5c250513          	addi	a0,a0,1474 # 5d10 <malloc+0xb46>
    1756:	1bd030ef          	jal	5112 <printf>
        exit(1);
    175a:	4505                	li	a0,1
    175c:	5ac030ef          	jal	4d08 <exit>
        printf("%s: wait wrong exit status\n", s);
    1760:	85d6                	mv	a1,s5
    1762:	00004517          	auipc	a0,0x4
    1766:	5c650513          	addi	a0,a0,1478 # 5d28 <malloc+0xb5e>
    176a:	1a9030ef          	jal	5112 <printf>
        exit(1);
    176e:	4505                	li	a0,1
    1770:	598030ef          	jal	4d08 <exit>
      exit(i);
    1774:	854a                	mv	a0,s2
    1776:	592030ef          	jal	4d08 <exit>

000000000000177a <twochildren>:
{
    177a:	1101                	addi	sp,sp,-32
    177c:	ec06                	sd	ra,24(sp)
    177e:	e822                	sd	s0,16(sp)
    1780:	e426                	sd	s1,8(sp)
    1782:	e04a                	sd	s2,0(sp)
    1784:	1000                	addi	s0,sp,32
    1786:	892a                	mv	s2,a0
    1788:	3e800493          	li	s1,1000
    int pid1 = fork();
    178c:	574030ef          	jal	4d00 <fork>
    if(pid1 < 0){
    1790:	02054663          	bltz	a0,17bc <twochildren+0x42>
    if(pid1 == 0){
    1794:	cd15                	beqz	a0,17d0 <twochildren+0x56>
      int pid2 = fork();
    1796:	56a030ef          	jal	4d00 <fork>
      if(pid2 < 0){
    179a:	02054d63          	bltz	a0,17d4 <twochildren+0x5a>
      if(pid2 == 0){
    179e:	c529                	beqz	a0,17e8 <twochildren+0x6e>
        wait(0);
    17a0:	4501                	li	a0,0
    17a2:	56e030ef          	jal	4d10 <wait>
        wait(0);
    17a6:	4501                	li	a0,0
    17a8:	568030ef          	jal	4d10 <wait>
  for(int i = 0; i < 1000; i++){
    17ac:	34fd                	addiw	s1,s1,-1
    17ae:	fcf9                	bnez	s1,178c <twochildren+0x12>
}
    17b0:	60e2                	ld	ra,24(sp)
    17b2:	6442                	ld	s0,16(sp)
    17b4:	64a2                	ld	s1,8(sp)
    17b6:	6902                	ld	s2,0(sp)
    17b8:	6105                	addi	sp,sp,32
    17ba:	8082                	ret
      printf("%s: fork failed\n", s);
    17bc:	85ca                	mv	a1,s2
    17be:	00004517          	auipc	a0,0x4
    17c2:	3ca50513          	addi	a0,a0,970 # 5b88 <malloc+0x9be>
    17c6:	14d030ef          	jal	5112 <printf>
      exit(1);
    17ca:	4505                	li	a0,1
    17cc:	53c030ef          	jal	4d08 <exit>
      exit(0);
    17d0:	538030ef          	jal	4d08 <exit>
        printf("%s: fork failed\n", s);
    17d4:	85ca                	mv	a1,s2
    17d6:	00004517          	auipc	a0,0x4
    17da:	3b250513          	addi	a0,a0,946 # 5b88 <malloc+0x9be>
    17de:	135030ef          	jal	5112 <printf>
        exit(1);
    17e2:	4505                	li	a0,1
    17e4:	524030ef          	jal	4d08 <exit>
        exit(0);
    17e8:	520030ef          	jal	4d08 <exit>

00000000000017ec <forkfork>:
{
    17ec:	7179                	addi	sp,sp,-48
    17ee:	f406                	sd	ra,40(sp)
    17f0:	f022                	sd	s0,32(sp)
    17f2:	ec26                	sd	s1,24(sp)
    17f4:	1800                	addi	s0,sp,48
    17f6:	84aa                	mv	s1,a0
    int pid = fork();
    17f8:	508030ef          	jal	4d00 <fork>
    if(pid < 0){
    17fc:	02054b63          	bltz	a0,1832 <forkfork+0x46>
    if(pid == 0){
    1800:	c139                	beqz	a0,1846 <forkfork+0x5a>
    int pid = fork();
    1802:	4fe030ef          	jal	4d00 <fork>
    if(pid < 0){
    1806:	02054663          	bltz	a0,1832 <forkfork+0x46>
    if(pid == 0){
    180a:	cd15                	beqz	a0,1846 <forkfork+0x5a>
    wait(&xstatus);
    180c:	fdc40513          	addi	a0,s0,-36
    1810:	500030ef          	jal	4d10 <wait>
    if(xstatus != 0) {
    1814:	fdc42783          	lw	a5,-36(s0)
    1818:	ebb9                	bnez	a5,186e <forkfork+0x82>
    wait(&xstatus);
    181a:	fdc40513          	addi	a0,s0,-36
    181e:	4f2030ef          	jal	4d10 <wait>
    if(xstatus != 0) {
    1822:	fdc42783          	lw	a5,-36(s0)
    1826:	e7a1                	bnez	a5,186e <forkfork+0x82>
}
    1828:	70a2                	ld	ra,40(sp)
    182a:	7402                	ld	s0,32(sp)
    182c:	64e2                	ld	s1,24(sp)
    182e:	6145                	addi	sp,sp,48
    1830:	8082                	ret
      printf("%s: fork failed", s);
    1832:	85a6                	mv	a1,s1
    1834:	00004517          	auipc	a0,0x4
    1838:	51450513          	addi	a0,a0,1300 # 5d48 <malloc+0xb7e>
    183c:	0d7030ef          	jal	5112 <printf>
      exit(1);
    1840:	4505                	li	a0,1
    1842:	4c6030ef          	jal	4d08 <exit>
{
    1846:	0c800493          	li	s1,200
        int pid1 = fork();
    184a:	4b6030ef          	jal	4d00 <fork>
        if(pid1 < 0){
    184e:	00054b63          	bltz	a0,1864 <forkfork+0x78>
        if(pid1 == 0){
    1852:	cd01                	beqz	a0,186a <forkfork+0x7e>
        wait(0);
    1854:	4501                	li	a0,0
    1856:	4ba030ef          	jal	4d10 <wait>
      for(int j = 0; j < 200; j++){
    185a:	34fd                	addiw	s1,s1,-1
    185c:	f4fd                	bnez	s1,184a <forkfork+0x5e>
      exit(0);
    185e:	4501                	li	a0,0
    1860:	4a8030ef          	jal	4d08 <exit>
          exit(1);
    1864:	4505                	li	a0,1
    1866:	4a2030ef          	jal	4d08 <exit>
          exit(0);
    186a:	49e030ef          	jal	4d08 <exit>
      printf("%s: fork in child failed", s);
    186e:	85a6                	mv	a1,s1
    1870:	00004517          	auipc	a0,0x4
    1874:	4e850513          	addi	a0,a0,1256 # 5d58 <malloc+0xb8e>
    1878:	09b030ef          	jal	5112 <printf>
      exit(1);
    187c:	4505                	li	a0,1
    187e:	48a030ef          	jal	4d08 <exit>

0000000000001882 <reparent2>:
{
    1882:	1101                	addi	sp,sp,-32
    1884:	ec06                	sd	ra,24(sp)
    1886:	e822                	sd	s0,16(sp)
    1888:	e426                	sd	s1,8(sp)
    188a:	1000                	addi	s0,sp,32
    188c:	32000493          	li	s1,800
    int pid1 = fork();
    1890:	470030ef          	jal	4d00 <fork>
    if(pid1 < 0){
    1894:	00054b63          	bltz	a0,18aa <reparent2+0x28>
    if(pid1 == 0){
    1898:	c115                	beqz	a0,18bc <reparent2+0x3a>
    wait(0);
    189a:	4501                	li	a0,0
    189c:	474030ef          	jal	4d10 <wait>
  for(int i = 0; i < 800; i++){
    18a0:	34fd                	addiw	s1,s1,-1
    18a2:	f4fd                	bnez	s1,1890 <reparent2+0xe>
  exit(0);
    18a4:	4501                	li	a0,0
    18a6:	462030ef          	jal	4d08 <exit>
      printf("fork failed\n");
    18aa:	00006517          	auipc	a0,0x6
    18ae:	84e50513          	addi	a0,a0,-1970 # 70f8 <malloc+0x1f2e>
    18b2:	061030ef          	jal	5112 <printf>
      exit(1);
    18b6:	4505                	li	a0,1
    18b8:	450030ef          	jal	4d08 <exit>
      fork();
    18bc:	444030ef          	jal	4d00 <fork>
      fork();
    18c0:	440030ef          	jal	4d00 <fork>
      exit(0);
    18c4:	4501                	li	a0,0
    18c6:	442030ef          	jal	4d08 <exit>

00000000000018ca <createdelete>:
{
    18ca:	7175                	addi	sp,sp,-144
    18cc:	e506                	sd	ra,136(sp)
    18ce:	e122                	sd	s0,128(sp)
    18d0:	fca6                	sd	s1,120(sp)
    18d2:	f8ca                	sd	s2,112(sp)
    18d4:	f4ce                	sd	s3,104(sp)
    18d6:	f0d2                	sd	s4,96(sp)
    18d8:	ecd6                	sd	s5,88(sp)
    18da:	e8da                	sd	s6,80(sp)
    18dc:	e4de                	sd	s7,72(sp)
    18de:	e0e2                	sd	s8,64(sp)
    18e0:	fc66                	sd	s9,56(sp)
    18e2:	f86a                	sd	s10,48(sp)
    18e4:	0900                	addi	s0,sp,144
    18e6:	8d2a                	mv	s10,a0
  for(pi = 0; pi < NCHILD; pi++){
    18e8:	4901                	li	s2,0
    18ea:	4991                	li	s3,4
    pid = fork();
    18ec:	414030ef          	jal	4d00 <fork>
    18f0:	84aa                	mv	s1,a0
    if(pid < 0){
    18f2:	02054e63          	bltz	a0,192e <createdelete+0x64>
    if(pid == 0){
    18f6:	c531                	beqz	a0,1942 <createdelete+0x78>
  for(pi = 0; pi < NCHILD; pi++){
    18f8:	2905                	addiw	s2,s2,1
    18fa:	ff3919e3          	bne	s2,s3,18ec <createdelete+0x22>
    18fe:	4491                	li	s1,4
    wait(&xstatus);
    1900:	f7c40993          	addi	s3,s0,-132
    1904:	854e                	mv	a0,s3
    1906:	40a030ef          	jal	4d10 <wait>
    if(xstatus != 0)
    190a:	f7c42903          	lw	s2,-132(s0)
    190e:	0c091063          	bnez	s2,19ce <createdelete+0x104>
  for(pi = 0; pi < NCHILD; pi++){
    1912:	34fd                	addiw	s1,s1,-1
    1914:	f8e5                	bnez	s1,1904 <createdelete+0x3a>
  name[0] = name[1] = name[2] = 0;
    1916:	f8040123          	sb	zero,-126(s0)
    191a:	03000993          	li	s3,48
    191e:	5afd                	li	s5,-1
    1920:	07000c93          	li	s9,112
      if((i == 0 || i >= N/2) && fd < 0){
    1924:	4ba5                	li	s7,9
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1926:	4c21                	li	s8,8
    for(pi = 0; pi < NCHILD; pi++){
    1928:	07400b13          	li	s6,116
    192c:	a205                	j	1a4c <createdelete+0x182>
      printf("%s: fork failed\n", s);
    192e:	85ea                	mv	a1,s10
    1930:	00004517          	auipc	a0,0x4
    1934:	25850513          	addi	a0,a0,600 # 5b88 <malloc+0x9be>
    1938:	7da030ef          	jal	5112 <printf>
      exit(1);
    193c:	4505                	li	a0,1
    193e:	3ca030ef          	jal	4d08 <exit>
      name[0] = 'p' + pi;
    1942:	0709091b          	addiw	s2,s2,112
    1946:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    194a:	f8040123          	sb	zero,-126(s0)
        fd = open(name, O_CREATE | O_RDWR);
    194e:	f8040913          	addi	s2,s0,-128
    1952:	20200993          	li	s3,514
      for(i = 0; i < N; i++){
    1956:	4a51                	li	s4,20
    1958:	a815                	j	198c <createdelete+0xc2>
          printf("%s: create failed\n", s);
    195a:	85ea                	mv	a1,s10
    195c:	00004517          	auipc	a0,0x4
    1960:	2c450513          	addi	a0,a0,708 # 5c20 <malloc+0xa56>
    1964:	7ae030ef          	jal	5112 <printf>
          exit(1);
    1968:	4505                	li	a0,1
    196a:	39e030ef          	jal	4d08 <exit>
          name[1] = '0' + (i / 2);
    196e:	01f4d79b          	srliw	a5,s1,0x1f
    1972:	9fa5                	addw	a5,a5,s1
    1974:	4017d79b          	sraiw	a5,a5,0x1
    1978:	0307879b          	addiw	a5,a5,48
    197c:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1980:	854a                	mv	a0,s2
    1982:	3d6030ef          	jal	4d58 <unlink>
    1986:	02054a63          	bltz	a0,19ba <createdelete+0xf0>
      for(i = 0; i < N; i++){
    198a:	2485                	addiw	s1,s1,1
        name[1] = '0' + i;
    198c:	0304879b          	addiw	a5,s1,48
    1990:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1994:	85ce                	mv	a1,s3
    1996:	854a                	mv	a0,s2
    1998:	3b0030ef          	jal	4d48 <open>
        if(fd < 0){
    199c:	fa054fe3          	bltz	a0,195a <createdelete+0x90>
        close(fd);
    19a0:	390030ef          	jal	4d30 <close>
        if(i > 0 && (i % 2 ) == 0){
    19a4:	fe9053e3          	blez	s1,198a <createdelete+0xc0>
    19a8:	0014f793          	andi	a5,s1,1
    19ac:	d3e9                	beqz	a5,196e <createdelete+0xa4>
      for(i = 0; i < N; i++){
    19ae:	2485                	addiw	s1,s1,1
    19b0:	fd449ee3          	bne	s1,s4,198c <createdelete+0xc2>
      exit(0);
    19b4:	4501                	li	a0,0
    19b6:	352030ef          	jal	4d08 <exit>
            printf("%s: unlink failed\n", s);
    19ba:	85ea                	mv	a1,s10
    19bc:	00004517          	auipc	a0,0x4
    19c0:	3bc50513          	addi	a0,a0,956 # 5d78 <malloc+0xbae>
    19c4:	74e030ef          	jal	5112 <printf>
            exit(1);
    19c8:	4505                	li	a0,1
    19ca:	33e030ef          	jal	4d08 <exit>
      exit(1);
    19ce:	4505                	li	a0,1
    19d0:	338030ef          	jal	4d08 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    19d4:	f8040613          	addi	a2,s0,-128
    19d8:	85ea                	mv	a1,s10
    19da:	00004517          	auipc	a0,0x4
    19de:	3b650513          	addi	a0,a0,950 # 5d90 <malloc+0xbc6>
    19e2:	730030ef          	jal	5112 <printf>
        exit(1);
    19e6:	4505                	li	a0,1
    19e8:	320030ef          	jal	4d08 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    19ec:	035c7a63          	bgeu	s8,s5,1a20 <createdelete+0x156>
      if(fd >= 0)
    19f0:	02055563          	bgez	a0,1a1a <createdelete+0x150>
    for(pi = 0; pi < NCHILD; pi++){
    19f4:	2485                	addiw	s1,s1,1
    19f6:	0ff4f493          	zext.b	s1,s1
    19fa:	05648163          	beq	s1,s6,1a3c <createdelete+0x172>
      name[0] = 'p' + pi;
    19fe:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1a02:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1a06:	4581                	li	a1,0
    1a08:	8552                	mv	a0,s4
    1a0a:	33e030ef          	jal	4d48 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1a0e:	00090463          	beqz	s2,1a16 <createdelete+0x14c>
    1a12:	fd2bdde3          	bge	s7,s2,19ec <createdelete+0x122>
    1a16:	fa054fe3          	bltz	a0,19d4 <createdelete+0x10a>
        close(fd);
    1a1a:	316030ef          	jal	4d30 <close>
    1a1e:	bfd9                	j	19f4 <createdelete+0x12a>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1a20:	fc054ae3          	bltz	a0,19f4 <createdelete+0x12a>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1a24:	f8040613          	addi	a2,s0,-128
    1a28:	85ea                	mv	a1,s10
    1a2a:	00004517          	auipc	a0,0x4
    1a2e:	38e50513          	addi	a0,a0,910 # 5db8 <malloc+0xbee>
    1a32:	6e0030ef          	jal	5112 <printf>
        exit(1);
    1a36:	4505                	li	a0,1
    1a38:	2d0030ef          	jal	4d08 <exit>
  for(i = 0; i < N; i++){
    1a3c:	2905                	addiw	s2,s2,1
    1a3e:	2a85                	addiw	s5,s5,1
    1a40:	2985                	addiw	s3,s3,1
    1a42:	0ff9f993          	zext.b	s3,s3
    1a46:	47d1                	li	a5,20
    1a48:	00f90663          	beq	s2,a5,1a54 <createdelete+0x18a>
    for(pi = 0; pi < NCHILD; pi++){
    1a4c:	84e6                	mv	s1,s9
      fd = open(name, 0);
    1a4e:	f8040a13          	addi	s4,s0,-128
    1a52:	b775                	j	19fe <createdelete+0x134>
    1a54:	03000913          	li	s2,48
  name[0] = name[1] = name[2] = 0;
    1a58:	07000b13          	li	s6,112
      unlink(name);
    1a5c:	f8040a13          	addi	s4,s0,-128
    for(pi = 0; pi < NCHILD; pi++){
    1a60:	07400993          	li	s3,116
  for(i = 0; i < N; i++){
    1a64:	04400a93          	li	s5,68
  name[0] = name[1] = name[2] = 0;
    1a68:	84da                	mv	s1,s6
      name[0] = 'p' + pi;
    1a6a:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1a6e:	f92400a3          	sb	s2,-127(s0)
      unlink(name);
    1a72:	8552                	mv	a0,s4
    1a74:	2e4030ef          	jal	4d58 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1a78:	2485                	addiw	s1,s1,1
    1a7a:	0ff4f493          	zext.b	s1,s1
    1a7e:	ff3496e3          	bne	s1,s3,1a6a <createdelete+0x1a0>
  for(i = 0; i < N; i++){
    1a82:	2905                	addiw	s2,s2,1
    1a84:	0ff97913          	zext.b	s2,s2
    1a88:	ff5910e3          	bne	s2,s5,1a68 <createdelete+0x19e>
}
    1a8c:	60aa                	ld	ra,136(sp)
    1a8e:	640a                	ld	s0,128(sp)
    1a90:	74e6                	ld	s1,120(sp)
    1a92:	7946                	ld	s2,112(sp)
    1a94:	79a6                	ld	s3,104(sp)
    1a96:	7a06                	ld	s4,96(sp)
    1a98:	6ae6                	ld	s5,88(sp)
    1a9a:	6b46                	ld	s6,80(sp)
    1a9c:	6ba6                	ld	s7,72(sp)
    1a9e:	6c06                	ld	s8,64(sp)
    1aa0:	7ce2                	ld	s9,56(sp)
    1aa2:	7d42                	ld	s10,48(sp)
    1aa4:	6149                	addi	sp,sp,144
    1aa6:	8082                	ret

0000000000001aa8 <linkunlink>:
{
    1aa8:	711d                	addi	sp,sp,-96
    1aaa:	ec86                	sd	ra,88(sp)
    1aac:	e8a2                	sd	s0,80(sp)
    1aae:	e4a6                	sd	s1,72(sp)
    1ab0:	e0ca                	sd	s2,64(sp)
    1ab2:	fc4e                	sd	s3,56(sp)
    1ab4:	f852                	sd	s4,48(sp)
    1ab6:	f456                	sd	s5,40(sp)
    1ab8:	f05a                	sd	s6,32(sp)
    1aba:	ec5e                	sd	s7,24(sp)
    1abc:	e862                	sd	s8,16(sp)
    1abe:	e466                	sd	s9,8(sp)
    1ac0:	e06a                	sd	s10,0(sp)
    1ac2:	1080                	addi	s0,sp,96
    1ac4:	84aa                	mv	s1,a0
  unlink("x");
    1ac6:	00004517          	auipc	a0,0x4
    1aca:	8a250513          	addi	a0,a0,-1886 # 5368 <malloc+0x19e>
    1ace:	28a030ef          	jal	4d58 <unlink>
  pid = fork();
    1ad2:	22e030ef          	jal	4d00 <fork>
  if(pid < 0){
    1ad6:	04054363          	bltz	a0,1b1c <linkunlink+0x74>
    1ada:	8d2a                	mv	s10,a0
  unsigned int x = (pid ? 1 : 97);
    1adc:	06100913          	li	s2,97
    1ae0:	c111                	beqz	a0,1ae4 <linkunlink+0x3c>
    1ae2:	4905                	li	s2,1
    1ae4:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1ae8:	41c65ab7          	lui	s5,0x41c65
    1aec:	e6da8a9b          	addiw	s5,s5,-403 # 41c64e6d <base+0x41c561f5>
    1af0:	6a0d                	lui	s4,0x3
    1af2:	039a0a1b          	addiw	s4,s4,57 # 3039 <subdir+0x337>
    if((x % 3) == 0){
    1af6:	000ab9b7          	lui	s3,0xab
    1afa:	aab98993          	addi	s3,s3,-1365 # aaaab <base+0x9be33>
    1afe:	09b2                	slli	s3,s3,0xc
    1b00:	aab98993          	addi	s3,s3,-1365
    } else if((x % 3) == 1){
    1b04:	4b85                	li	s7,1
      unlink("x");
    1b06:	00004b17          	auipc	s6,0x4
    1b0a:	862b0b13          	addi	s6,s6,-1950 # 5368 <malloc+0x19e>
      link("cat", "x");
    1b0e:	00004c97          	auipc	s9,0x4
    1b12:	2d2c8c93          	addi	s9,s9,722 # 5de0 <malloc+0xc16>
      close(open("x", O_RDWR | O_CREATE));
    1b16:	20200c13          	li	s8,514
    1b1a:	a03d                	j	1b48 <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    1b1c:	85a6                	mv	a1,s1
    1b1e:	00004517          	auipc	a0,0x4
    1b22:	06a50513          	addi	a0,a0,106 # 5b88 <malloc+0x9be>
    1b26:	5ec030ef          	jal	5112 <printf>
    exit(1);
    1b2a:	4505                	li	a0,1
    1b2c:	1dc030ef          	jal	4d08 <exit>
      close(open("x", O_RDWR | O_CREATE));
    1b30:	85e2                	mv	a1,s8
    1b32:	855a                	mv	a0,s6
    1b34:	214030ef          	jal	4d48 <open>
    1b38:	1f8030ef          	jal	4d30 <close>
    1b3c:	a021                	j	1b44 <linkunlink+0x9c>
      unlink("x");
    1b3e:	855a                	mv	a0,s6
    1b40:	218030ef          	jal	4d58 <unlink>
  for(i = 0; i < 100; i++){
    1b44:	34fd                	addiw	s1,s1,-1
    1b46:	c885                	beqz	s1,1b76 <linkunlink+0xce>
    x = x * 1103515245 + 12345;
    1b48:	035907bb          	mulw	a5,s2,s5
    1b4c:	00fa07bb          	addw	a5,s4,a5
    1b50:	893e                	mv	s2,a5
    if((x % 3) == 0){
    1b52:	02079713          	slli	a4,a5,0x20
    1b56:	9301                	srli	a4,a4,0x20
    1b58:	03370733          	mul	a4,a4,s3
    1b5c:	9305                	srli	a4,a4,0x21
    1b5e:	0017169b          	slliw	a3,a4,0x1
    1b62:	9f35                	addw	a4,a4,a3
    1b64:	9f99                	subw	a5,a5,a4
    1b66:	d7e9                	beqz	a5,1b30 <linkunlink+0x88>
    } else if((x % 3) == 1){
    1b68:	fd779be3          	bne	a5,s7,1b3e <linkunlink+0x96>
      link("cat", "x");
    1b6c:	85da                	mv	a1,s6
    1b6e:	8566                	mv	a0,s9
    1b70:	1f8030ef          	jal	4d68 <link>
    1b74:	bfc1                	j	1b44 <linkunlink+0x9c>
  if(pid)
    1b76:	020d0363          	beqz	s10,1b9c <linkunlink+0xf4>
    wait(0);
    1b7a:	4501                	li	a0,0
    1b7c:	194030ef          	jal	4d10 <wait>
}
    1b80:	60e6                	ld	ra,88(sp)
    1b82:	6446                	ld	s0,80(sp)
    1b84:	64a6                	ld	s1,72(sp)
    1b86:	6906                	ld	s2,64(sp)
    1b88:	79e2                	ld	s3,56(sp)
    1b8a:	7a42                	ld	s4,48(sp)
    1b8c:	7aa2                	ld	s5,40(sp)
    1b8e:	7b02                	ld	s6,32(sp)
    1b90:	6be2                	ld	s7,24(sp)
    1b92:	6c42                	ld	s8,16(sp)
    1b94:	6ca2                	ld	s9,8(sp)
    1b96:	6d02                	ld	s10,0(sp)
    1b98:	6125                	addi	sp,sp,96
    1b9a:	8082                	ret
    exit(0);
    1b9c:	4501                	li	a0,0
    1b9e:	16a030ef          	jal	4d08 <exit>

0000000000001ba2 <forktest>:
{
    1ba2:	7179                	addi	sp,sp,-48
    1ba4:	f406                	sd	ra,40(sp)
    1ba6:	f022                	sd	s0,32(sp)
    1ba8:	ec26                	sd	s1,24(sp)
    1baa:	e84a                	sd	s2,16(sp)
    1bac:	e44e                	sd	s3,8(sp)
    1bae:	1800                	addi	s0,sp,48
    1bb0:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    1bb2:	4481                	li	s1,0
    1bb4:	3e800913          	li	s2,1000
    pid = fork();
    1bb8:	148030ef          	jal	4d00 <fork>
    if(pid < 0)
    1bbc:	06054063          	bltz	a0,1c1c <forktest+0x7a>
    if(pid == 0)
    1bc0:	cd11                	beqz	a0,1bdc <forktest+0x3a>
  for(n=0; n<N; n++){
    1bc2:	2485                	addiw	s1,s1,1
    1bc4:	ff249ae3          	bne	s1,s2,1bb8 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    1bc8:	85ce                	mv	a1,s3
    1bca:	00004517          	auipc	a0,0x4
    1bce:	26650513          	addi	a0,a0,614 # 5e30 <malloc+0xc66>
    1bd2:	540030ef          	jal	5112 <printf>
    exit(1);
    1bd6:	4505                	li	a0,1
    1bd8:	130030ef          	jal	4d08 <exit>
      exit(0);
    1bdc:	12c030ef          	jal	4d08 <exit>
    printf("%s: no fork at all!\n", s);
    1be0:	85ce                	mv	a1,s3
    1be2:	00004517          	auipc	a0,0x4
    1be6:	20650513          	addi	a0,a0,518 # 5de8 <malloc+0xc1e>
    1bea:	528030ef          	jal	5112 <printf>
    exit(1);
    1bee:	4505                	li	a0,1
    1bf0:	118030ef          	jal	4d08 <exit>
      printf("%s: wait stopped early\n", s);
    1bf4:	85ce                	mv	a1,s3
    1bf6:	00004517          	auipc	a0,0x4
    1bfa:	20a50513          	addi	a0,a0,522 # 5e00 <malloc+0xc36>
    1bfe:	514030ef          	jal	5112 <printf>
      exit(1);
    1c02:	4505                	li	a0,1
    1c04:	104030ef          	jal	4d08 <exit>
    printf("%s: wait got too many\n", s);
    1c08:	85ce                	mv	a1,s3
    1c0a:	00004517          	auipc	a0,0x4
    1c0e:	20e50513          	addi	a0,a0,526 # 5e18 <malloc+0xc4e>
    1c12:	500030ef          	jal	5112 <printf>
    exit(1);
    1c16:	4505                	li	a0,1
    1c18:	0f0030ef          	jal	4d08 <exit>
  if (n == 0) {
    1c1c:	d0f1                	beqz	s1,1be0 <forktest+0x3e>
    if(wait(0) < 0){
    1c1e:	4501                	li	a0,0
    1c20:	0f0030ef          	jal	4d10 <wait>
    1c24:	fc0548e3          	bltz	a0,1bf4 <forktest+0x52>
  for(; n > 0; n--){
    1c28:	34fd                	addiw	s1,s1,-1
    1c2a:	fe904ae3          	bgtz	s1,1c1e <forktest+0x7c>
  if(wait(0) != -1){
    1c2e:	4501                	li	a0,0
    1c30:	0e0030ef          	jal	4d10 <wait>
    1c34:	57fd                	li	a5,-1
    1c36:	fcf519e3          	bne	a0,a5,1c08 <forktest+0x66>
}
    1c3a:	70a2                	ld	ra,40(sp)
    1c3c:	7402                	ld	s0,32(sp)
    1c3e:	64e2                	ld	s1,24(sp)
    1c40:	6942                	ld	s2,16(sp)
    1c42:	69a2                	ld	s3,8(sp)
    1c44:	6145                	addi	sp,sp,48
    1c46:	8082                	ret

0000000000001c48 <kernmem>:
{
    1c48:	715d                	addi	sp,sp,-80
    1c4a:	e486                	sd	ra,72(sp)
    1c4c:	e0a2                	sd	s0,64(sp)
    1c4e:	fc26                	sd	s1,56(sp)
    1c50:	f84a                	sd	s2,48(sp)
    1c52:	f44e                	sd	s3,40(sp)
    1c54:	f052                	sd	s4,32(sp)
    1c56:	ec56                	sd	s5,24(sp)
    1c58:	e85a                	sd	s6,16(sp)
    1c5a:	0880                	addi	s0,sp,80
    1c5c:	8b2a                	mv	s6,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1c5e:	4485                	li	s1,1
    1c60:	04fe                	slli	s1,s1,0x1f
    wait(&xstatus);
    1c62:	fbc40a93          	addi	s5,s0,-68
    if(xstatus != -1)  // did kernel kill child?
    1c66:	5a7d                	li	s4,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1c68:	69b1                	lui	s3,0xc
    1c6a:	35098993          	addi	s3,s3,848 # c350 <buf+0x6d8>
    1c6e:	1003d937          	lui	s2,0x1003d
    1c72:	090e                	slli	s2,s2,0x3
    1c74:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002e808>
    pid = fork();
    1c78:	088030ef          	jal	4d00 <fork>
    if(pid < 0){
    1c7c:	02054763          	bltz	a0,1caa <kernmem+0x62>
    if(pid == 0){
    1c80:	cd1d                	beqz	a0,1cbe <kernmem+0x76>
    wait(&xstatus);
    1c82:	8556                	mv	a0,s5
    1c84:	08c030ef          	jal	4d10 <wait>
    if(xstatus != -1)  // did kernel kill child?
    1c88:	fbc42783          	lw	a5,-68(s0)
    1c8c:	05479663          	bne	a5,s4,1cd8 <kernmem+0x90>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1c90:	94ce                	add	s1,s1,s3
    1c92:	ff2493e3          	bne	s1,s2,1c78 <kernmem+0x30>
}
    1c96:	60a6                	ld	ra,72(sp)
    1c98:	6406                	ld	s0,64(sp)
    1c9a:	74e2                	ld	s1,56(sp)
    1c9c:	7942                	ld	s2,48(sp)
    1c9e:	79a2                	ld	s3,40(sp)
    1ca0:	7a02                	ld	s4,32(sp)
    1ca2:	6ae2                	ld	s5,24(sp)
    1ca4:	6b42                	ld	s6,16(sp)
    1ca6:	6161                	addi	sp,sp,80
    1ca8:	8082                	ret
      printf("%s: fork failed\n", s);
    1caa:	85da                	mv	a1,s6
    1cac:	00004517          	auipc	a0,0x4
    1cb0:	edc50513          	addi	a0,a0,-292 # 5b88 <malloc+0x9be>
    1cb4:	45e030ef          	jal	5112 <printf>
      exit(1);
    1cb8:	4505                	li	a0,1
    1cba:	04e030ef          	jal	4d08 <exit>
      printf("%s: oops could read %p = %x\n", s, a, *a);
    1cbe:	0004c683          	lbu	a3,0(s1)
    1cc2:	8626                	mv	a2,s1
    1cc4:	85da                	mv	a1,s6
    1cc6:	00004517          	auipc	a0,0x4
    1cca:	19250513          	addi	a0,a0,402 # 5e58 <malloc+0xc8e>
    1cce:	444030ef          	jal	5112 <printf>
      exit(1);
    1cd2:	4505                	li	a0,1
    1cd4:	034030ef          	jal	4d08 <exit>
      exit(1);
    1cd8:	4505                	li	a0,1
    1cda:	02e030ef          	jal	4d08 <exit>

0000000000001cde <MAXVAplus>:
{
    1cde:	7139                	addi	sp,sp,-64
    1ce0:	fc06                	sd	ra,56(sp)
    1ce2:	f822                	sd	s0,48(sp)
    1ce4:	0080                	addi	s0,sp,64
  volatile uint64 a = MAXVA;
    1ce6:	4785                	li	a5,1
    1ce8:	179a                	slli	a5,a5,0x26
    1cea:	fcf43423          	sd	a5,-56(s0)
  for( ; a != 0; a <<= 1){
    1cee:	fc843783          	ld	a5,-56(s0)
    1cf2:	cf9d                	beqz	a5,1d30 <MAXVAplus+0x52>
    1cf4:	f426                	sd	s1,40(sp)
    1cf6:	f04a                	sd	s2,32(sp)
    1cf8:	ec4e                	sd	s3,24(sp)
    1cfa:	89aa                	mv	s3,a0
    wait(&xstatus);
    1cfc:	fc440913          	addi	s2,s0,-60
    if(xstatus != -1)  // did kernel kill child?
    1d00:	54fd                	li	s1,-1
    pid = fork();
    1d02:	7ff020ef          	jal	4d00 <fork>
    if(pid < 0){
    1d06:	02054963          	bltz	a0,1d38 <MAXVAplus+0x5a>
    if(pid == 0){
    1d0a:	c129                	beqz	a0,1d4c <MAXVAplus+0x6e>
    wait(&xstatus);
    1d0c:	854a                	mv	a0,s2
    1d0e:	002030ef          	jal	4d10 <wait>
    if(xstatus != -1)  // did kernel kill child?
    1d12:	fc442783          	lw	a5,-60(s0)
    1d16:	04979d63          	bne	a5,s1,1d70 <MAXVAplus+0x92>
  for( ; a != 0; a <<= 1){
    1d1a:	fc843783          	ld	a5,-56(s0)
    1d1e:	0786                	slli	a5,a5,0x1
    1d20:	fcf43423          	sd	a5,-56(s0)
    1d24:	fc843783          	ld	a5,-56(s0)
    1d28:	ffe9                	bnez	a5,1d02 <MAXVAplus+0x24>
    1d2a:	74a2                	ld	s1,40(sp)
    1d2c:	7902                	ld	s2,32(sp)
    1d2e:	69e2                	ld	s3,24(sp)
}
    1d30:	70e2                	ld	ra,56(sp)
    1d32:	7442                	ld	s0,48(sp)
    1d34:	6121                	addi	sp,sp,64
    1d36:	8082                	ret
      printf("%s: fork failed\n", s);
    1d38:	85ce                	mv	a1,s3
    1d3a:	00004517          	auipc	a0,0x4
    1d3e:	e4e50513          	addi	a0,a0,-434 # 5b88 <malloc+0x9be>
    1d42:	3d0030ef          	jal	5112 <printf>
      exit(1);
    1d46:	4505                	li	a0,1
    1d48:	7c1020ef          	jal	4d08 <exit>
      *(char*)a = 99;
    1d4c:	fc843783          	ld	a5,-56(s0)
    1d50:	06300713          	li	a4,99
    1d54:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %p\n", s, (void*)a);
    1d58:	fc843603          	ld	a2,-56(s0)
    1d5c:	85ce                	mv	a1,s3
    1d5e:	00004517          	auipc	a0,0x4
    1d62:	11a50513          	addi	a0,a0,282 # 5e78 <malloc+0xcae>
    1d66:	3ac030ef          	jal	5112 <printf>
      exit(1);
    1d6a:	4505                	li	a0,1
    1d6c:	79d020ef          	jal	4d08 <exit>
      exit(1);
    1d70:	4505                	li	a0,1
    1d72:	797020ef          	jal	4d08 <exit>

0000000000001d76 <stacktest>:
{
    1d76:	7179                	addi	sp,sp,-48
    1d78:	f406                	sd	ra,40(sp)
    1d7a:	f022                	sd	s0,32(sp)
    1d7c:	ec26                	sd	s1,24(sp)
    1d7e:	1800                	addi	s0,sp,48
    1d80:	84aa                	mv	s1,a0
  pid = fork();
    1d82:	77f020ef          	jal	4d00 <fork>
  if(pid == 0) {
    1d86:	cd11                	beqz	a0,1da2 <stacktest+0x2c>
  } else if(pid < 0){
    1d88:	02054c63          	bltz	a0,1dc0 <stacktest+0x4a>
  wait(&xstatus);
    1d8c:	fdc40513          	addi	a0,s0,-36
    1d90:	781020ef          	jal	4d10 <wait>
  if(xstatus == -1)  // kernel killed child?
    1d94:	fdc42503          	lw	a0,-36(s0)
    1d98:	57fd                	li	a5,-1
    1d9a:	02f50d63          	beq	a0,a5,1dd4 <stacktest+0x5e>
    exit(xstatus);
    1d9e:	76b020ef          	jal	4d08 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    1da2:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %d\n", s, *sp);
    1da4:	77fd                	lui	a5,0xfffff
    1da6:	97ba                	add	a5,a5,a4
    1da8:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xffffffffffff0388>
    1dac:	85a6                	mv	a1,s1
    1dae:	00004517          	auipc	a0,0x4
    1db2:	0e250513          	addi	a0,a0,226 # 5e90 <malloc+0xcc6>
    1db6:	35c030ef          	jal	5112 <printf>
    exit(1);
    1dba:	4505                	li	a0,1
    1dbc:	74d020ef          	jal	4d08 <exit>
    printf("%s: fork failed\n", s);
    1dc0:	85a6                	mv	a1,s1
    1dc2:	00004517          	auipc	a0,0x4
    1dc6:	dc650513          	addi	a0,a0,-570 # 5b88 <malloc+0x9be>
    1dca:	348030ef          	jal	5112 <printf>
    exit(1);
    1dce:	4505                	li	a0,1
    1dd0:	739020ef          	jal	4d08 <exit>
    exit(0);
    1dd4:	4501                	li	a0,0
    1dd6:	733020ef          	jal	4d08 <exit>

0000000000001dda <nowrite>:
{
    1dda:	7159                	addi	sp,sp,-112
    1ddc:	f486                	sd	ra,104(sp)
    1dde:	f0a2                	sd	s0,96(sp)
    1de0:	eca6                	sd	s1,88(sp)
    1de2:	e8ca                	sd	s2,80(sp)
    1de4:	e4ce                	sd	s3,72(sp)
    1de6:	e0d2                	sd	s4,64(sp)
    1de8:	1880                	addi	s0,sp,112
    1dea:	8a2a                	mv	s4,a0
  uint64 addrs[] = { 0, 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
    1dec:	00006797          	auipc	a5,0x6
    1df0:	86c78793          	addi	a5,a5,-1940 # 7658 <malloc+0x248e>
    1df4:	7788                	ld	a0,40(a5)
    1df6:	7b8c                	ld	a1,48(a5)
    1df8:	7f90                	ld	a2,56(a5)
    1dfa:	63b4                	ld	a3,64(a5)
    1dfc:	67b8                	ld	a4,72(a5)
    1dfe:	6bbc                	ld	a5,80(a5)
    1e00:	f8a43c23          	sd	a0,-104(s0)
    1e04:	fab43023          	sd	a1,-96(s0)
    1e08:	fac43423          	sd	a2,-88(s0)
    1e0c:	fad43823          	sd	a3,-80(s0)
    1e10:	fae43c23          	sd	a4,-72(s0)
    1e14:	fcf43023          	sd	a5,-64(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    1e18:	4481                	li	s1,0
    wait(&xstatus);
    1e1a:	fcc40913          	addi	s2,s0,-52
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    1e1e:	4999                	li	s3,6
    pid = fork();
    1e20:	6e1020ef          	jal	4d00 <fork>
    if(pid == 0) {
    1e24:	cd19                	beqz	a0,1e42 <nowrite+0x68>
    } else if(pid < 0){
    1e26:	04054163          	bltz	a0,1e68 <nowrite+0x8e>
    wait(&xstatus);
    1e2a:	854a                	mv	a0,s2
    1e2c:	6e5020ef          	jal	4d10 <wait>
    if(xstatus == 0){
    1e30:	fcc42783          	lw	a5,-52(s0)
    1e34:	c7a1                	beqz	a5,1e7c <nowrite+0xa2>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    1e36:	2485                	addiw	s1,s1,1
    1e38:	ff3494e3          	bne	s1,s3,1e20 <nowrite+0x46>
  exit(0);
    1e3c:	4501                	li	a0,0
    1e3e:	6cb020ef          	jal	4d08 <exit>
      volatile int *addr = (int *) addrs[ai];
    1e42:	048e                	slli	s1,s1,0x3
    1e44:	fd048793          	addi	a5,s1,-48
    1e48:	008784b3          	add	s1,a5,s0
    1e4c:	fc84b603          	ld	a2,-56(s1)
      *addr = 10;
    1e50:	47a9                	li	a5,10
    1e52:	c21c                	sw	a5,0(a2)
      printf("%s: write to %p did not fail!\n", s, addr);
    1e54:	85d2                	mv	a1,s4
    1e56:	00004517          	auipc	a0,0x4
    1e5a:	06250513          	addi	a0,a0,98 # 5eb8 <malloc+0xcee>
    1e5e:	2b4030ef          	jal	5112 <printf>
      exit(0);
    1e62:	4501                	li	a0,0
    1e64:	6a5020ef          	jal	4d08 <exit>
      printf("%s: fork failed\n", s);
    1e68:	85d2                	mv	a1,s4
    1e6a:	00004517          	auipc	a0,0x4
    1e6e:	d1e50513          	addi	a0,a0,-738 # 5b88 <malloc+0x9be>
    1e72:	2a0030ef          	jal	5112 <printf>
      exit(1);
    1e76:	4505                	li	a0,1
    1e78:	691020ef          	jal	4d08 <exit>
      exit(1);
    1e7c:	4505                	li	a0,1
    1e7e:	68b020ef          	jal	4d08 <exit>

0000000000001e82 <manywrites>:
{
    1e82:	7159                	addi	sp,sp,-112
    1e84:	f486                	sd	ra,104(sp)
    1e86:	f0a2                	sd	s0,96(sp)
    1e88:	eca6                	sd	s1,88(sp)
    1e8a:	e8ca                	sd	s2,80(sp)
    1e8c:	e4ce                	sd	s3,72(sp)
    1e8e:	fc56                	sd	s5,56(sp)
    1e90:	1880                	addi	s0,sp,112
    1e92:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    1e94:	4901                	li	s2,0
    1e96:	4991                	li	s3,4
    int pid = fork();
    1e98:	669020ef          	jal	4d00 <fork>
    1e9c:	84aa                	mv	s1,a0
    if(pid < 0){
    1e9e:	02054d63          	bltz	a0,1ed8 <manywrites+0x56>
    if(pid == 0){
    1ea2:	c931                	beqz	a0,1ef6 <manywrites+0x74>
  for(int ci = 0; ci < nchildren; ci++){
    1ea4:	2905                	addiw	s2,s2,1
    1ea6:	ff3919e3          	bne	s2,s3,1e98 <manywrites+0x16>
    1eaa:	4491                	li	s1,4
    wait(&st);
    1eac:	f9840913          	addi	s2,s0,-104
    int st = 0;
    1eb0:	f8042c23          	sw	zero,-104(s0)
    wait(&st);
    1eb4:	854a                	mv	a0,s2
    1eb6:	65b020ef          	jal	4d10 <wait>
    if(st != 0)
    1eba:	f9842503          	lw	a0,-104(s0)
    1ebe:	0e051463          	bnez	a0,1fa6 <manywrites+0x124>
  for(int ci = 0; ci < nchildren; ci++){
    1ec2:	34fd                	addiw	s1,s1,-1
    1ec4:	f4f5                	bnez	s1,1eb0 <manywrites+0x2e>
    1ec6:	e0d2                	sd	s4,64(sp)
    1ec8:	f85a                	sd	s6,48(sp)
    1eca:	f45e                	sd	s7,40(sp)
    1ecc:	f062                	sd	s8,32(sp)
    1ece:	ec66                	sd	s9,24(sp)
    1ed0:	e86a                	sd	s10,16(sp)
  exit(0);
    1ed2:	4501                	li	a0,0
    1ed4:	635020ef          	jal	4d08 <exit>
    1ed8:	e0d2                	sd	s4,64(sp)
    1eda:	f85a                	sd	s6,48(sp)
    1edc:	f45e                	sd	s7,40(sp)
    1ede:	f062                	sd	s8,32(sp)
    1ee0:	ec66                	sd	s9,24(sp)
    1ee2:	e86a                	sd	s10,16(sp)
      printf("fork failed\n");
    1ee4:	00005517          	auipc	a0,0x5
    1ee8:	21450513          	addi	a0,a0,532 # 70f8 <malloc+0x1f2e>
    1eec:	226030ef          	jal	5112 <printf>
      exit(1);
    1ef0:	4505                	li	a0,1
    1ef2:	617020ef          	jal	4d08 <exit>
    1ef6:	e0d2                	sd	s4,64(sp)
    1ef8:	f85a                	sd	s6,48(sp)
    1efa:	f45e                	sd	s7,40(sp)
    1efc:	f062                	sd	s8,32(sp)
    1efe:	ec66                	sd	s9,24(sp)
    1f00:	e86a                	sd	s10,16(sp)
      name[0] = 'b';
    1f02:	06200793          	li	a5,98
    1f06:	f8f40c23          	sb	a5,-104(s0)
      name[1] = 'a' + ci;
    1f0a:	0619079b          	addiw	a5,s2,97
    1f0e:	f8f40ca3          	sb	a5,-103(s0)
      name[2] = '\0';
    1f12:	f8040d23          	sb	zero,-102(s0)
      unlink(name);
    1f16:	f9840513          	addi	a0,s0,-104
    1f1a:	63f020ef          	jal	4d58 <unlink>
    1f1e:	4d79                	li	s10,30
          int fd = open(name, O_CREATE | O_RDWR);
    1f20:	f9840c13          	addi	s8,s0,-104
    1f24:	20200b93          	li	s7,514
          int cc = write(fd, buf, sz);
    1f28:	6b0d                	lui	s6,0x3
    1f2a:	0000ac97          	auipc	s9,0xa
    1f2e:	d4ec8c93          	addi	s9,s9,-690 # bc78 <buf>
        for(int i = 0; i < ci+1; i++){
    1f32:	8a26                	mv	s4,s1
          int fd = open(name, O_CREATE | O_RDWR);
    1f34:	85de                	mv	a1,s7
    1f36:	8562                	mv	a0,s8
    1f38:	611020ef          	jal	4d48 <open>
    1f3c:	89aa                	mv	s3,a0
          if(fd < 0){
    1f3e:	02054c63          	bltz	a0,1f76 <manywrites+0xf4>
          int cc = write(fd, buf, sz);
    1f42:	865a                	mv	a2,s6
    1f44:	85e6                	mv	a1,s9
    1f46:	5e3020ef          	jal	4d28 <write>
          if(cc != sz){
    1f4a:	05651263          	bne	a0,s6,1f8e <manywrites+0x10c>
          close(fd);
    1f4e:	854e                	mv	a0,s3
    1f50:	5e1020ef          	jal	4d30 <close>
        for(int i = 0; i < ci+1; i++){
    1f54:	2a05                	addiw	s4,s4,1
    1f56:	fd495fe3          	bge	s2,s4,1f34 <manywrites+0xb2>
        unlink(name);
    1f5a:	f9840513          	addi	a0,s0,-104
    1f5e:	5fb020ef          	jal	4d58 <unlink>
      for(int iters = 0; iters < howmany; iters++){
    1f62:	3d7d                	addiw	s10,s10,-1
    1f64:	fc0d17e3          	bnez	s10,1f32 <manywrites+0xb0>
      unlink(name);
    1f68:	f9840513          	addi	a0,s0,-104
    1f6c:	5ed020ef          	jal	4d58 <unlink>
      exit(0);
    1f70:	4501                	li	a0,0
    1f72:	597020ef          	jal	4d08 <exit>
            printf("%s: cannot create %s\n", s, name);
    1f76:	f9840613          	addi	a2,s0,-104
    1f7a:	85d6                	mv	a1,s5
    1f7c:	00004517          	auipc	a0,0x4
    1f80:	f5c50513          	addi	a0,a0,-164 # 5ed8 <malloc+0xd0e>
    1f84:	18e030ef          	jal	5112 <printf>
            exit(1);
    1f88:	4505                	li	a0,1
    1f8a:	57f020ef          	jal	4d08 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    1f8e:	86aa                	mv	a3,a0
    1f90:	660d                	lui	a2,0x3
    1f92:	85d6                	mv	a1,s5
    1f94:	00003517          	auipc	a0,0x3
    1f98:	43450513          	addi	a0,a0,1076 # 53c8 <malloc+0x1fe>
    1f9c:	176030ef          	jal	5112 <printf>
            exit(1);
    1fa0:	4505                	li	a0,1
    1fa2:	567020ef          	jal	4d08 <exit>
    1fa6:	e0d2                	sd	s4,64(sp)
    1fa8:	f85a                	sd	s6,48(sp)
    1faa:	f45e                	sd	s7,40(sp)
    1fac:	f062                	sd	s8,32(sp)
    1fae:	ec66                	sd	s9,24(sp)
    1fb0:	e86a                	sd	s10,16(sp)
      exit(st);
    1fb2:	557020ef          	jal	4d08 <exit>

0000000000001fb6 <copyinstr3>:
{
    1fb6:	7179                	addi	sp,sp,-48
    1fb8:	f406                	sd	ra,40(sp)
    1fba:	f022                	sd	s0,32(sp)
    1fbc:	ec26                	sd	s1,24(sp)
    1fbe:	1800                	addi	s0,sp,48
  sbrk(8192);
    1fc0:	6509                	lui	a0,0x2
    1fc2:	5cf020ef          	jal	4d90 <sbrk>
  uint64 top = (uint64) sbrk(0);
    1fc6:	4501                	li	a0,0
    1fc8:	5c9020ef          	jal	4d90 <sbrk>
  if((top % PGSIZE) != 0){
    1fcc:	03451793          	slli	a5,a0,0x34
    1fd0:	e7bd                	bnez	a5,203e <copyinstr3+0x88>
  top = (uint64) sbrk(0);
    1fd2:	4501                	li	a0,0
    1fd4:	5bd020ef          	jal	4d90 <sbrk>
  if(top % PGSIZE){
    1fd8:	03451793          	slli	a5,a0,0x34
    1fdc:	ebb5                	bnez	a5,2050 <copyinstr3+0x9a>
  char *b = (char *) (top - 1);
    1fde:	fff50493          	addi	s1,a0,-1 # 1fff <copyinstr3+0x49>
  *b = 'x';
    1fe2:	07800793          	li	a5,120
    1fe6:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    1fea:	8526                	mv	a0,s1
    1fec:	56d020ef          	jal	4d58 <unlink>
  if(ret != -1){
    1ff0:	57fd                	li	a5,-1
    1ff2:	06f51863          	bne	a0,a5,2062 <copyinstr3+0xac>
  int fd = open(b, O_CREATE | O_WRONLY);
    1ff6:	20100593          	li	a1,513
    1ffa:	8526                	mv	a0,s1
    1ffc:	54d020ef          	jal	4d48 <open>
  if(fd != -1){
    2000:	57fd                	li	a5,-1
    2002:	06f51b63          	bne	a0,a5,2078 <copyinstr3+0xc2>
  ret = link(b, b);
    2006:	85a6                	mv	a1,s1
    2008:	8526                	mv	a0,s1
    200a:	55f020ef          	jal	4d68 <link>
  if(ret != -1){
    200e:	57fd                	li	a5,-1
    2010:	06f51f63          	bne	a0,a5,208e <copyinstr3+0xd8>
  char *args[] = { "xx", 0 };
    2014:	00005797          	auipc	a5,0x5
    2018:	bc478793          	addi	a5,a5,-1084 # 6bd8 <malloc+0x1a0e>
    201c:	fcf43823          	sd	a5,-48(s0)
    2020:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    2024:	fd040593          	addi	a1,s0,-48
    2028:	8526                	mv	a0,s1
    202a:	517020ef          	jal	4d40 <exec>
  if(ret != -1){
    202e:	57fd                	li	a5,-1
    2030:	06f51b63          	bne	a0,a5,20a6 <copyinstr3+0xf0>
}
    2034:	70a2                	ld	ra,40(sp)
    2036:	7402                	ld	s0,32(sp)
    2038:	64e2                	ld	s1,24(sp)
    203a:	6145                	addi	sp,sp,48
    203c:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    203e:	6785                	lui	a5,0x1
    2040:	fff78713          	addi	a4,a5,-1 # fff <bigdir+0x105>
    2044:	8d79                	and	a0,a0,a4
    2046:	40a7853b          	subw	a0,a5,a0
    204a:	547020ef          	jal	4d90 <sbrk>
    204e:	b751                	j	1fd2 <copyinstr3+0x1c>
    printf("oops\n");
    2050:	00004517          	auipc	a0,0x4
    2054:	ea050513          	addi	a0,a0,-352 # 5ef0 <malloc+0xd26>
    2058:	0ba030ef          	jal	5112 <printf>
    exit(1);
    205c:	4505                	li	a0,1
    205e:	4ab020ef          	jal	4d08 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    2062:	862a                	mv	a2,a0
    2064:	85a6                	mv	a1,s1
    2066:	00004517          	auipc	a0,0x4
    206a:	a4250513          	addi	a0,a0,-1470 # 5aa8 <malloc+0x8de>
    206e:	0a4030ef          	jal	5112 <printf>
    exit(1);
    2072:	4505                	li	a0,1
    2074:	495020ef          	jal	4d08 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    2078:	862a                	mv	a2,a0
    207a:	85a6                	mv	a1,s1
    207c:	00004517          	auipc	a0,0x4
    2080:	a4c50513          	addi	a0,a0,-1460 # 5ac8 <malloc+0x8fe>
    2084:	08e030ef          	jal	5112 <printf>
    exit(1);
    2088:	4505                	li	a0,1
    208a:	47f020ef          	jal	4d08 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    208e:	86aa                	mv	a3,a0
    2090:	8626                	mv	a2,s1
    2092:	85a6                	mv	a1,s1
    2094:	00004517          	auipc	a0,0x4
    2098:	a5450513          	addi	a0,a0,-1452 # 5ae8 <malloc+0x91e>
    209c:	076030ef          	jal	5112 <printf>
    exit(1);
    20a0:	4505                	li	a0,1
    20a2:	467020ef          	jal	4d08 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    20a6:	863e                	mv	a2,a5
    20a8:	85a6                	mv	a1,s1
    20aa:	00004517          	auipc	a0,0x4
    20ae:	a6650513          	addi	a0,a0,-1434 # 5b10 <malloc+0x946>
    20b2:	060030ef          	jal	5112 <printf>
    exit(1);
    20b6:	4505                	li	a0,1
    20b8:	451020ef          	jal	4d08 <exit>

00000000000020bc <rwsbrk>:
{
    20bc:	1101                	addi	sp,sp,-32
    20be:	ec06                	sd	ra,24(sp)
    20c0:	e822                	sd	s0,16(sp)
    20c2:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    20c4:	6509                	lui	a0,0x2
    20c6:	4cb020ef          	jal	4d90 <sbrk>
  if(a == 0xffffffffffffffffLL) {
    20ca:	57fd                	li	a5,-1
    20cc:	04f50a63          	beq	a0,a5,2120 <rwsbrk+0x64>
    20d0:	e426                	sd	s1,8(sp)
    20d2:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    20d4:	7579                	lui	a0,0xffffe
    20d6:	4bb020ef          	jal	4d90 <sbrk>
    20da:	57fd                	li	a5,-1
    20dc:	04f50d63          	beq	a0,a5,2136 <rwsbrk+0x7a>
    20e0:	e04a                	sd	s2,0(sp)
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    20e2:	20100593          	li	a1,513
    20e6:	00004517          	auipc	a0,0x4
    20ea:	e4a50513          	addi	a0,a0,-438 # 5f30 <malloc+0xd66>
    20ee:	45b020ef          	jal	4d48 <open>
    20f2:	892a                	mv	s2,a0
  if(fd < 0){
    20f4:	04054b63          	bltz	a0,214a <rwsbrk+0x8e>
  n = write(fd, (void*)(a+4096), 1024);
    20f8:	6785                	lui	a5,0x1
    20fa:	94be                	add	s1,s1,a5
    20fc:	40000613          	li	a2,1024
    2100:	85a6                	mv	a1,s1
    2102:	427020ef          	jal	4d28 <write>
    2106:	862a                	mv	a2,a0
  if(n >= 0){
    2108:	04054a63          	bltz	a0,215c <rwsbrk+0xa0>
    printf("write(fd, %p, 1024) returned %d, not -1\n", (void*)a+4096, n);
    210c:	85a6                	mv	a1,s1
    210e:	00004517          	auipc	a0,0x4
    2112:	e4250513          	addi	a0,a0,-446 # 5f50 <malloc+0xd86>
    2116:	7fd020ef          	jal	5112 <printf>
    exit(1);
    211a:	4505                	li	a0,1
    211c:	3ed020ef          	jal	4d08 <exit>
    2120:	e426                	sd	s1,8(sp)
    2122:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) failed\n");
    2124:	00004517          	auipc	a0,0x4
    2128:	dd450513          	addi	a0,a0,-556 # 5ef8 <malloc+0xd2e>
    212c:	7e7020ef          	jal	5112 <printf>
    exit(1);
    2130:	4505                	li	a0,1
    2132:	3d7020ef          	jal	4d08 <exit>
    2136:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) shrink failed\n");
    2138:	00004517          	auipc	a0,0x4
    213c:	dd850513          	addi	a0,a0,-552 # 5f10 <malloc+0xd46>
    2140:	7d3020ef          	jal	5112 <printf>
    exit(1);
    2144:	4505                	li	a0,1
    2146:	3c3020ef          	jal	4d08 <exit>
    printf("open(rwsbrk) failed\n");
    214a:	00004517          	auipc	a0,0x4
    214e:	dee50513          	addi	a0,a0,-530 # 5f38 <malloc+0xd6e>
    2152:	7c1020ef          	jal	5112 <printf>
    exit(1);
    2156:	4505                	li	a0,1
    2158:	3b1020ef          	jal	4d08 <exit>
  close(fd);
    215c:	854a                	mv	a0,s2
    215e:	3d3020ef          	jal	4d30 <close>
  unlink("rwsbrk");
    2162:	00004517          	auipc	a0,0x4
    2166:	dce50513          	addi	a0,a0,-562 # 5f30 <malloc+0xd66>
    216a:	3ef020ef          	jal	4d58 <unlink>
  fd = open("README", O_RDONLY);
    216e:	4581                	li	a1,0
    2170:	00003517          	auipc	a0,0x3
    2174:	36050513          	addi	a0,a0,864 # 54d0 <malloc+0x306>
    2178:	3d1020ef          	jal	4d48 <open>
    217c:	892a                	mv	s2,a0
  if(fd < 0){
    217e:	02054363          	bltz	a0,21a4 <rwsbrk+0xe8>
  n = read(fd, (void*)(a+4096), 10);
    2182:	4629                	li	a2,10
    2184:	85a6                	mv	a1,s1
    2186:	39b020ef          	jal	4d20 <read>
    218a:	862a                	mv	a2,a0
  if(n >= 0){
    218c:	02054563          	bltz	a0,21b6 <rwsbrk+0xfa>
    printf("read(fd, %p, 10) returned %d, not -1\n", (void*)a+4096, n);
    2190:	85a6                	mv	a1,s1
    2192:	00004517          	auipc	a0,0x4
    2196:	dee50513          	addi	a0,a0,-530 # 5f80 <malloc+0xdb6>
    219a:	779020ef          	jal	5112 <printf>
    exit(1);
    219e:	4505                	li	a0,1
    21a0:	369020ef          	jal	4d08 <exit>
    printf("open(rwsbrk) failed\n");
    21a4:	00004517          	auipc	a0,0x4
    21a8:	d9450513          	addi	a0,a0,-620 # 5f38 <malloc+0xd6e>
    21ac:	767020ef          	jal	5112 <printf>
    exit(1);
    21b0:	4505                	li	a0,1
    21b2:	357020ef          	jal	4d08 <exit>
  close(fd);
    21b6:	854a                	mv	a0,s2
    21b8:	379020ef          	jal	4d30 <close>
  exit(0);
    21bc:	4501                	li	a0,0
    21be:	34b020ef          	jal	4d08 <exit>

00000000000021c2 <sbrkbasic>:
{
    21c2:	715d                	addi	sp,sp,-80
    21c4:	e486                	sd	ra,72(sp)
    21c6:	e0a2                	sd	s0,64(sp)
    21c8:	ec56                	sd	s5,24(sp)
    21ca:	0880                	addi	s0,sp,80
    21cc:	8aaa                	mv	s5,a0
  pid = fork();
    21ce:	333020ef          	jal	4d00 <fork>
  if(pid < 0){
    21d2:	02054c63          	bltz	a0,220a <sbrkbasic+0x48>
  if(pid == 0){
    21d6:	ed31                	bnez	a0,2232 <sbrkbasic+0x70>
    a = sbrk(TOOMUCH);
    21d8:	40000537          	lui	a0,0x40000
    21dc:	3b5020ef          	jal	4d90 <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    21e0:	57fd                	li	a5,-1
    21e2:	04f50163          	beq	a0,a5,2224 <sbrkbasic+0x62>
    21e6:	fc26                	sd	s1,56(sp)
    21e8:	f84a                	sd	s2,48(sp)
    21ea:	f44e                	sd	s3,40(sp)
    21ec:	f052                	sd	s4,32(sp)
    for(b = a; b < a+TOOMUCH; b += 4096){
    21ee:	400007b7          	lui	a5,0x40000
    21f2:	97aa                	add	a5,a5,a0
      *b = 99;
    21f4:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    21f8:	6705                	lui	a4,0x1
      *b = 99;
    21fa:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3fff1388>
    for(b = a; b < a+TOOMUCH; b += 4096){
    21fe:	953a                	add	a0,a0,a4
    2200:	fef51de3          	bne	a0,a5,21fa <sbrkbasic+0x38>
    exit(1);
    2204:	4505                	li	a0,1
    2206:	303020ef          	jal	4d08 <exit>
    220a:	fc26                	sd	s1,56(sp)
    220c:	f84a                	sd	s2,48(sp)
    220e:	f44e                	sd	s3,40(sp)
    2210:	f052                	sd	s4,32(sp)
    printf("fork failed in sbrkbasic\n");
    2212:	00004517          	auipc	a0,0x4
    2216:	d9650513          	addi	a0,a0,-618 # 5fa8 <malloc+0xdde>
    221a:	6f9020ef          	jal	5112 <printf>
    exit(1);
    221e:	4505                	li	a0,1
    2220:	2e9020ef          	jal	4d08 <exit>
    2224:	fc26                	sd	s1,56(sp)
    2226:	f84a                	sd	s2,48(sp)
    2228:	f44e                	sd	s3,40(sp)
    222a:	f052                	sd	s4,32(sp)
      exit(0);
    222c:	4501                	li	a0,0
    222e:	2db020ef          	jal	4d08 <exit>
  wait(&xstatus);
    2232:	fbc40513          	addi	a0,s0,-68
    2236:	2db020ef          	jal	4d10 <wait>
  if(xstatus == 1){
    223a:	fbc42703          	lw	a4,-68(s0)
    223e:	4785                	li	a5,1
    2240:	02f70063          	beq	a4,a5,2260 <sbrkbasic+0x9e>
    2244:	fc26                	sd	s1,56(sp)
    2246:	f84a                	sd	s2,48(sp)
    2248:	f44e                	sd	s3,40(sp)
    224a:	f052                	sd	s4,32(sp)
  a = sbrk(0);
    224c:	4501                	li	a0,0
    224e:	343020ef          	jal	4d90 <sbrk>
    2252:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    2254:	4901                	li	s2,0
    b = sbrk(1);
    2256:	4985                	li	s3,1
  for(i = 0; i < 5000; i++){
    2258:	6a05                	lui	s4,0x1
    225a:	388a0a13          	addi	s4,s4,904 # 1388 <truncate3+0x144>
    225e:	a005                	j	227e <sbrkbasic+0xbc>
    2260:	fc26                	sd	s1,56(sp)
    2262:	f84a                	sd	s2,48(sp)
    2264:	f44e                	sd	s3,40(sp)
    2266:	f052                	sd	s4,32(sp)
    printf("%s: too much memory allocated!\n", s);
    2268:	85d6                	mv	a1,s5
    226a:	00004517          	auipc	a0,0x4
    226e:	d5e50513          	addi	a0,a0,-674 # 5fc8 <malloc+0xdfe>
    2272:	6a1020ef          	jal	5112 <printf>
    exit(1);
    2276:	4505                	li	a0,1
    2278:	291020ef          	jal	4d08 <exit>
    227c:	84be                	mv	s1,a5
    b = sbrk(1);
    227e:	854e                	mv	a0,s3
    2280:	311020ef          	jal	4d90 <sbrk>
    if(b != a){
    2284:	04951163          	bne	a0,s1,22c6 <sbrkbasic+0x104>
    *b = 1;
    2288:	01348023          	sb	s3,0(s1)
    a = b + 1;
    228c:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    2290:	2905                	addiw	s2,s2,1
    2292:	ff4915e3          	bne	s2,s4,227c <sbrkbasic+0xba>
  pid = fork();
    2296:	26b020ef          	jal	4d00 <fork>
    229a:	892a                	mv	s2,a0
  if(pid < 0){
    229c:	04054263          	bltz	a0,22e0 <sbrkbasic+0x11e>
  c = sbrk(1);
    22a0:	4505                	li	a0,1
    22a2:	2ef020ef          	jal	4d90 <sbrk>
  c = sbrk(1);
    22a6:	4505                	li	a0,1
    22a8:	2e9020ef          	jal	4d90 <sbrk>
  if(c != a + 1){
    22ac:	0489                	addi	s1,s1,2
    22ae:	04a48363          	beq	s1,a0,22f4 <sbrkbasic+0x132>
    printf("%s: sbrk test failed post-fork\n", s);
    22b2:	85d6                	mv	a1,s5
    22b4:	00004517          	auipc	a0,0x4
    22b8:	d7450513          	addi	a0,a0,-652 # 6028 <malloc+0xe5e>
    22bc:	657020ef          	jal	5112 <printf>
    exit(1);
    22c0:	4505                	li	a0,1
    22c2:	247020ef          	jal	4d08 <exit>
      printf("%s: sbrk test failed %d %p %p\n", s, i, a, b);
    22c6:	872a                	mv	a4,a0
    22c8:	86a6                	mv	a3,s1
    22ca:	864a                	mv	a2,s2
    22cc:	85d6                	mv	a1,s5
    22ce:	00004517          	auipc	a0,0x4
    22d2:	d1a50513          	addi	a0,a0,-742 # 5fe8 <malloc+0xe1e>
    22d6:	63d020ef          	jal	5112 <printf>
      exit(1);
    22da:	4505                	li	a0,1
    22dc:	22d020ef          	jal	4d08 <exit>
    printf("%s: sbrk test fork failed\n", s);
    22e0:	85d6                	mv	a1,s5
    22e2:	00004517          	auipc	a0,0x4
    22e6:	d2650513          	addi	a0,a0,-730 # 6008 <malloc+0xe3e>
    22ea:	629020ef          	jal	5112 <printf>
    exit(1);
    22ee:	4505                	li	a0,1
    22f0:	219020ef          	jal	4d08 <exit>
  if(pid == 0)
    22f4:	00091563          	bnez	s2,22fe <sbrkbasic+0x13c>
    exit(0);
    22f8:	4501                	li	a0,0
    22fa:	20f020ef          	jal	4d08 <exit>
  wait(&xstatus);
    22fe:	fbc40513          	addi	a0,s0,-68
    2302:	20f020ef          	jal	4d10 <wait>
  exit(xstatus);
    2306:	fbc42503          	lw	a0,-68(s0)
    230a:	1ff020ef          	jal	4d08 <exit>

000000000000230e <sbrkmuch>:
{
    230e:	7179                	addi	sp,sp,-48
    2310:	f406                	sd	ra,40(sp)
    2312:	f022                	sd	s0,32(sp)
    2314:	ec26                	sd	s1,24(sp)
    2316:	e84a                	sd	s2,16(sp)
    2318:	e44e                	sd	s3,8(sp)
    231a:	e052                	sd	s4,0(sp)
    231c:	1800                	addi	s0,sp,48
    231e:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    2320:	4501                	li	a0,0
    2322:	26f020ef          	jal	4d90 <sbrk>
    2326:	892a                	mv	s2,a0
  a = sbrk(0);
    2328:	4501                	li	a0,0
    232a:	267020ef          	jal	4d90 <sbrk>
    232e:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2330:	06400537          	lui	a0,0x6400
    2334:	9d05                	subw	a0,a0,s1
    2336:	25b020ef          	jal	4d90 <sbrk>
  if (p != a) {
    233a:	0aa49463          	bne	s1,a0,23e2 <sbrkmuch+0xd4>
  char *eee = sbrk(0);
    233e:	4501                	li	a0,0
    2340:	251020ef          	jal	4d90 <sbrk>
    2344:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    2346:	00a4f963          	bgeu	s1,a0,2358 <sbrkmuch+0x4a>
    *pp = 1;
    234a:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    234c:	6705                	lui	a4,0x1
    *pp = 1;
    234e:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    2352:	94ba                	add	s1,s1,a4
    2354:	fef4ede3          	bltu	s1,a5,234e <sbrkmuch+0x40>
  *lastaddr = 99;
    2358:	064007b7          	lui	a5,0x6400
    235c:	06300713          	li	a4,99
    2360:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63f1387>
  a = sbrk(0);
    2364:	4501                	li	a0,0
    2366:	22b020ef          	jal	4d90 <sbrk>
    236a:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    236c:	757d                	lui	a0,0xfffff
    236e:	223020ef          	jal	4d90 <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    2372:	57fd                	li	a5,-1
    2374:	08f50163          	beq	a0,a5,23f6 <sbrkmuch+0xe8>
  c = sbrk(0);
    2378:	4501                	li	a0,0
    237a:	217020ef          	jal	4d90 <sbrk>
  if(c != a - PGSIZE){
    237e:	77fd                	lui	a5,0xfffff
    2380:	97a6                	add	a5,a5,s1
    2382:	08f51463          	bne	a0,a5,240a <sbrkmuch+0xfc>
  a = sbrk(0);
    2386:	4501                	li	a0,0
    2388:	209020ef          	jal	4d90 <sbrk>
    238c:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    238e:	6505                	lui	a0,0x1
    2390:	201020ef          	jal	4d90 <sbrk>
    2394:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    2396:	08a49663          	bne	s1,a0,2422 <sbrkmuch+0x114>
    239a:	4501                	li	a0,0
    239c:	1f5020ef          	jal	4d90 <sbrk>
    23a0:	6785                	lui	a5,0x1
    23a2:	97a6                	add	a5,a5,s1
    23a4:	06f51f63          	bne	a0,a5,2422 <sbrkmuch+0x114>
  if(*lastaddr == 99){
    23a8:	064007b7          	lui	a5,0x6400
    23ac:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63f1387>
    23b0:	06300793          	li	a5,99
    23b4:	08f70363          	beq	a4,a5,243a <sbrkmuch+0x12c>
  a = sbrk(0);
    23b8:	4501                	li	a0,0
    23ba:	1d7020ef          	jal	4d90 <sbrk>
    23be:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    23c0:	4501                	li	a0,0
    23c2:	1cf020ef          	jal	4d90 <sbrk>
    23c6:	40a9053b          	subw	a0,s2,a0
    23ca:	1c7020ef          	jal	4d90 <sbrk>
  if(c != a){
    23ce:	08a49063          	bne	s1,a0,244e <sbrkmuch+0x140>
}
    23d2:	70a2                	ld	ra,40(sp)
    23d4:	7402                	ld	s0,32(sp)
    23d6:	64e2                	ld	s1,24(sp)
    23d8:	6942                	ld	s2,16(sp)
    23da:	69a2                	ld	s3,8(sp)
    23dc:	6a02                	ld	s4,0(sp)
    23de:	6145                	addi	sp,sp,48
    23e0:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    23e2:	85ce                	mv	a1,s3
    23e4:	00004517          	auipc	a0,0x4
    23e8:	c6450513          	addi	a0,a0,-924 # 6048 <malloc+0xe7e>
    23ec:	527020ef          	jal	5112 <printf>
    exit(1);
    23f0:	4505                	li	a0,1
    23f2:	117020ef          	jal	4d08 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    23f6:	85ce                	mv	a1,s3
    23f8:	00004517          	auipc	a0,0x4
    23fc:	c9850513          	addi	a0,a0,-872 # 6090 <malloc+0xec6>
    2400:	513020ef          	jal	5112 <printf>
    exit(1);
    2404:	4505                	li	a0,1
    2406:	103020ef          	jal	4d08 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %p c %p\n", s, a, c);
    240a:	86aa                	mv	a3,a0
    240c:	8626                	mv	a2,s1
    240e:	85ce                	mv	a1,s3
    2410:	00004517          	auipc	a0,0x4
    2414:	ca050513          	addi	a0,a0,-864 # 60b0 <malloc+0xee6>
    2418:	4fb020ef          	jal	5112 <printf>
    exit(1);
    241c:	4505                	li	a0,1
    241e:	0eb020ef          	jal	4d08 <exit>
    printf("%s: sbrk re-allocation failed, a %p c %p\n", s, a, c);
    2422:	86d2                	mv	a3,s4
    2424:	8626                	mv	a2,s1
    2426:	85ce                	mv	a1,s3
    2428:	00004517          	auipc	a0,0x4
    242c:	cc850513          	addi	a0,a0,-824 # 60f0 <malloc+0xf26>
    2430:	4e3020ef          	jal	5112 <printf>
    exit(1);
    2434:	4505                	li	a0,1
    2436:	0d3020ef          	jal	4d08 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    243a:	85ce                	mv	a1,s3
    243c:	00004517          	auipc	a0,0x4
    2440:	ce450513          	addi	a0,a0,-796 # 6120 <malloc+0xf56>
    2444:	4cf020ef          	jal	5112 <printf>
    exit(1);
    2448:	4505                	li	a0,1
    244a:	0bf020ef          	jal	4d08 <exit>
    printf("%s: sbrk downsize failed, a %p c %p\n", s, a, c);
    244e:	86aa                	mv	a3,a0
    2450:	8626                	mv	a2,s1
    2452:	85ce                	mv	a1,s3
    2454:	00004517          	auipc	a0,0x4
    2458:	d0450513          	addi	a0,a0,-764 # 6158 <malloc+0xf8e>
    245c:	4b7020ef          	jal	5112 <printf>
    exit(1);
    2460:	4505                	li	a0,1
    2462:	0a7020ef          	jal	4d08 <exit>

0000000000002466 <sbrkarg>:
{
    2466:	7179                	addi	sp,sp,-48
    2468:	f406                	sd	ra,40(sp)
    246a:	f022                	sd	s0,32(sp)
    246c:	ec26                	sd	s1,24(sp)
    246e:	e84a                	sd	s2,16(sp)
    2470:	e44e                	sd	s3,8(sp)
    2472:	1800                	addi	s0,sp,48
    2474:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2476:	6505                	lui	a0,0x1
    2478:	119020ef          	jal	4d90 <sbrk>
    247c:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    247e:	20100593          	li	a1,513
    2482:	00004517          	auipc	a0,0x4
    2486:	cfe50513          	addi	a0,a0,-770 # 6180 <malloc+0xfb6>
    248a:	0bf020ef          	jal	4d48 <open>
    248e:	84aa                	mv	s1,a0
  unlink("sbrk");
    2490:	00004517          	auipc	a0,0x4
    2494:	cf050513          	addi	a0,a0,-784 # 6180 <malloc+0xfb6>
    2498:	0c1020ef          	jal	4d58 <unlink>
  if(fd < 0)  {
    249c:	0204c963          	bltz	s1,24ce <sbrkarg+0x68>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    24a0:	6605                	lui	a2,0x1
    24a2:	85ca                	mv	a1,s2
    24a4:	8526                	mv	a0,s1
    24a6:	083020ef          	jal	4d28 <write>
    24aa:	02054c63          	bltz	a0,24e2 <sbrkarg+0x7c>
  close(fd);
    24ae:	8526                	mv	a0,s1
    24b0:	081020ef          	jal	4d30 <close>
  a = sbrk(PGSIZE);
    24b4:	6505                	lui	a0,0x1
    24b6:	0db020ef          	jal	4d90 <sbrk>
  if(pipe((int *) a) != 0){
    24ba:	05f020ef          	jal	4d18 <pipe>
    24be:	ed05                	bnez	a0,24f6 <sbrkarg+0x90>
}
    24c0:	70a2                	ld	ra,40(sp)
    24c2:	7402                	ld	s0,32(sp)
    24c4:	64e2                	ld	s1,24(sp)
    24c6:	6942                	ld	s2,16(sp)
    24c8:	69a2                	ld	s3,8(sp)
    24ca:	6145                	addi	sp,sp,48
    24cc:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    24ce:	85ce                	mv	a1,s3
    24d0:	00004517          	auipc	a0,0x4
    24d4:	cb850513          	addi	a0,a0,-840 # 6188 <malloc+0xfbe>
    24d8:	43b020ef          	jal	5112 <printf>
    exit(1);
    24dc:	4505                	li	a0,1
    24de:	02b020ef          	jal	4d08 <exit>
    printf("%s: write sbrk failed\n", s);
    24e2:	85ce                	mv	a1,s3
    24e4:	00004517          	auipc	a0,0x4
    24e8:	cbc50513          	addi	a0,a0,-836 # 61a0 <malloc+0xfd6>
    24ec:	427020ef          	jal	5112 <printf>
    exit(1);
    24f0:	4505                	li	a0,1
    24f2:	017020ef          	jal	4d08 <exit>
    printf("%s: pipe() failed\n", s);
    24f6:	85ce                	mv	a1,s3
    24f8:	00003517          	auipc	a0,0x3
    24fc:	79850513          	addi	a0,a0,1944 # 5c90 <malloc+0xac6>
    2500:	413020ef          	jal	5112 <printf>
    exit(1);
    2504:	4505                	li	a0,1
    2506:	003020ef          	jal	4d08 <exit>

000000000000250a <argptest>:
{
    250a:	1101                	addi	sp,sp,-32
    250c:	ec06                	sd	ra,24(sp)
    250e:	e822                	sd	s0,16(sp)
    2510:	e426                	sd	s1,8(sp)
    2512:	e04a                	sd	s2,0(sp)
    2514:	1000                	addi	s0,sp,32
    2516:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2518:	4581                	li	a1,0
    251a:	00004517          	auipc	a0,0x4
    251e:	c9e50513          	addi	a0,a0,-866 # 61b8 <malloc+0xfee>
    2522:	027020ef          	jal	4d48 <open>
  if (fd < 0) {
    2526:	02054563          	bltz	a0,2550 <argptest+0x46>
    252a:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    252c:	4501                	li	a0,0
    252e:	063020ef          	jal	4d90 <sbrk>
    2532:	567d                	li	a2,-1
    2534:	00c505b3          	add	a1,a0,a2
    2538:	8526                	mv	a0,s1
    253a:	7e6020ef          	jal	4d20 <read>
  close(fd);
    253e:	8526                	mv	a0,s1
    2540:	7f0020ef          	jal	4d30 <close>
}
    2544:	60e2                	ld	ra,24(sp)
    2546:	6442                	ld	s0,16(sp)
    2548:	64a2                	ld	s1,8(sp)
    254a:	6902                	ld	s2,0(sp)
    254c:	6105                	addi	sp,sp,32
    254e:	8082                	ret
    printf("%s: open failed\n", s);
    2550:	85ca                	mv	a1,s2
    2552:	00003517          	auipc	a0,0x3
    2556:	64e50513          	addi	a0,a0,1614 # 5ba0 <malloc+0x9d6>
    255a:	3b9020ef          	jal	5112 <printf>
    exit(1);
    255e:	4505                	li	a0,1
    2560:	7a8020ef          	jal	4d08 <exit>

0000000000002564 <sbrkbugs>:
{
    2564:	1141                	addi	sp,sp,-16
    2566:	e406                	sd	ra,8(sp)
    2568:	e022                	sd	s0,0(sp)
    256a:	0800                	addi	s0,sp,16
  int pid = fork();
    256c:	794020ef          	jal	4d00 <fork>
  if(pid < 0){
    2570:	00054c63          	bltz	a0,2588 <sbrkbugs+0x24>
  if(pid == 0){
    2574:	e11d                	bnez	a0,259a <sbrkbugs+0x36>
    int sz = (uint64) sbrk(0);
    2576:	01b020ef          	jal	4d90 <sbrk>
    sbrk(-sz);
    257a:	40a0053b          	negw	a0,a0
    257e:	013020ef          	jal	4d90 <sbrk>
    exit(0);
    2582:	4501                	li	a0,0
    2584:	784020ef          	jal	4d08 <exit>
    printf("fork failed\n");
    2588:	00005517          	auipc	a0,0x5
    258c:	b7050513          	addi	a0,a0,-1168 # 70f8 <malloc+0x1f2e>
    2590:	383020ef          	jal	5112 <printf>
    exit(1);
    2594:	4505                	li	a0,1
    2596:	772020ef          	jal	4d08 <exit>
  wait(0);
    259a:	4501                	li	a0,0
    259c:	774020ef          	jal	4d10 <wait>
  pid = fork();
    25a0:	760020ef          	jal	4d00 <fork>
  if(pid < 0){
    25a4:	00054f63          	bltz	a0,25c2 <sbrkbugs+0x5e>
  if(pid == 0){
    25a8:	e515                	bnez	a0,25d4 <sbrkbugs+0x70>
    int sz = (uint64) sbrk(0);
    25aa:	7e6020ef          	jal	4d90 <sbrk>
    sbrk(-(sz - 3500));
    25ae:	6785                	lui	a5,0x1
    25b0:	dac7879b          	addiw	a5,a5,-596 # dac <linktest+0xdc>
    25b4:	40a7853b          	subw	a0,a5,a0
    25b8:	7d8020ef          	jal	4d90 <sbrk>
    exit(0);
    25bc:	4501                	li	a0,0
    25be:	74a020ef          	jal	4d08 <exit>
    printf("fork failed\n");
    25c2:	00005517          	auipc	a0,0x5
    25c6:	b3650513          	addi	a0,a0,-1226 # 70f8 <malloc+0x1f2e>
    25ca:	349020ef          	jal	5112 <printf>
    exit(1);
    25ce:	4505                	li	a0,1
    25d0:	738020ef          	jal	4d08 <exit>
  wait(0);
    25d4:	4501                	li	a0,0
    25d6:	73a020ef          	jal	4d10 <wait>
  pid = fork();
    25da:	726020ef          	jal	4d00 <fork>
  if(pid < 0){
    25de:	02054263          	bltz	a0,2602 <sbrkbugs+0x9e>
  if(pid == 0){
    25e2:	e90d                	bnez	a0,2614 <sbrkbugs+0xb0>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    25e4:	7ac020ef          	jal	4d90 <sbrk>
    25e8:	67ad                	lui	a5,0xb
    25ea:	8007879b          	addiw	a5,a5,-2048 # a800 <uninit+0x1298>
    25ee:	40a7853b          	subw	a0,a5,a0
    25f2:	79e020ef          	jal	4d90 <sbrk>
    sbrk(-10);
    25f6:	5559                	li	a0,-10
    25f8:	798020ef          	jal	4d90 <sbrk>
    exit(0);
    25fc:	4501                	li	a0,0
    25fe:	70a020ef          	jal	4d08 <exit>
    printf("fork failed\n");
    2602:	00005517          	auipc	a0,0x5
    2606:	af650513          	addi	a0,a0,-1290 # 70f8 <malloc+0x1f2e>
    260a:	309020ef          	jal	5112 <printf>
    exit(1);
    260e:	4505                	li	a0,1
    2610:	6f8020ef          	jal	4d08 <exit>
  wait(0);
    2614:	4501                	li	a0,0
    2616:	6fa020ef          	jal	4d10 <wait>
  exit(0);
    261a:	4501                	li	a0,0
    261c:	6ec020ef          	jal	4d08 <exit>

0000000000002620 <sbrklast>:
{
    2620:	7179                	addi	sp,sp,-48
    2622:	f406                	sd	ra,40(sp)
    2624:	f022                	sd	s0,32(sp)
    2626:	ec26                	sd	s1,24(sp)
    2628:	e84a                	sd	s2,16(sp)
    262a:	e44e                	sd	s3,8(sp)
    262c:	e052                	sd	s4,0(sp)
    262e:	1800                	addi	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    2630:	4501                	li	a0,0
    2632:	75e020ef          	jal	4d90 <sbrk>
  if((top % 4096) != 0)
    2636:	03451793          	slli	a5,a0,0x34
    263a:	ebad                	bnez	a5,26ac <sbrklast+0x8c>
  sbrk(4096);
    263c:	6505                	lui	a0,0x1
    263e:	752020ef          	jal	4d90 <sbrk>
  sbrk(10);
    2642:	4529                	li	a0,10
    2644:	74c020ef          	jal	4d90 <sbrk>
  sbrk(-20);
    2648:	5531                	li	a0,-20
    264a:	746020ef          	jal	4d90 <sbrk>
  top = (uint64) sbrk(0);
    264e:	4501                	li	a0,0
    2650:	740020ef          	jal	4d90 <sbrk>
    2654:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    2656:	fc050913          	addi	s2,a0,-64 # fc0 <bigdir+0xc6>
  p[0] = 'x';
    265a:	07800a13          	li	s4,120
    265e:	fd450023          	sb	s4,-64(a0)
  p[1] = '\0';
    2662:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    2666:	20200593          	li	a1,514
    266a:	854a                	mv	a0,s2
    266c:	6dc020ef          	jal	4d48 <open>
    2670:	89aa                	mv	s3,a0
  write(fd, p, 1);
    2672:	4605                	li	a2,1
    2674:	85ca                	mv	a1,s2
    2676:	6b2020ef          	jal	4d28 <write>
  close(fd);
    267a:	854e                	mv	a0,s3
    267c:	6b4020ef          	jal	4d30 <close>
  fd = open(p, O_RDWR);
    2680:	4589                	li	a1,2
    2682:	854a                	mv	a0,s2
    2684:	6c4020ef          	jal	4d48 <open>
  p[0] = '\0';
    2688:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    268c:	4605                	li	a2,1
    268e:	85ca                	mv	a1,s2
    2690:	690020ef          	jal	4d20 <read>
  if(p[0] != 'x')
    2694:	fc04c783          	lbu	a5,-64(s1)
    2698:	03479363          	bne	a5,s4,26be <sbrklast+0x9e>
}
    269c:	70a2                	ld	ra,40(sp)
    269e:	7402                	ld	s0,32(sp)
    26a0:	64e2                	ld	s1,24(sp)
    26a2:	6942                	ld	s2,16(sp)
    26a4:	69a2                	ld	s3,8(sp)
    26a6:	6a02                	ld	s4,0(sp)
    26a8:	6145                	addi	sp,sp,48
    26aa:	8082                	ret
    sbrk(4096 - (top % 4096));
    26ac:	6785                	lui	a5,0x1
    26ae:	fff78713          	addi	a4,a5,-1 # fff <bigdir+0x105>
    26b2:	8d79                	and	a0,a0,a4
    26b4:	40a7853b          	subw	a0,a5,a0
    26b8:	6d8020ef          	jal	4d90 <sbrk>
    26bc:	b741                	j	263c <sbrklast+0x1c>
    exit(1);
    26be:	4505                	li	a0,1
    26c0:	648020ef          	jal	4d08 <exit>

00000000000026c4 <sbrk8000>:
{
    26c4:	1141                	addi	sp,sp,-16
    26c6:	e406                	sd	ra,8(sp)
    26c8:	e022                	sd	s0,0(sp)
    26ca:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    26cc:	80000537          	lui	a0,0x80000
    26d0:	0511                	addi	a0,a0,4 # ffffffff80000004 <base+0xffffffff7fff138c>
    26d2:	6be020ef          	jal	4d90 <sbrk>
  volatile char *top = sbrk(0);
    26d6:	4501                	li	a0,0
    26d8:	6b8020ef          	jal	4d90 <sbrk>
  *(top-1) = *(top-1) + 1;
    26dc:	fff54783          	lbu	a5,-1(a0)
    26e0:	0785                	addi	a5,a5,1
    26e2:	0ff7f793          	zext.b	a5,a5
    26e6:	fef50fa3          	sb	a5,-1(a0)
}
    26ea:	60a2                	ld	ra,8(sp)
    26ec:	6402                	ld	s0,0(sp)
    26ee:	0141                	addi	sp,sp,16
    26f0:	8082                	ret

00000000000026f2 <execout>:
{
    26f2:	711d                	addi	sp,sp,-96
    26f4:	ec86                	sd	ra,88(sp)
    26f6:	e8a2                	sd	s0,80(sp)
    26f8:	e4a6                	sd	s1,72(sp)
    26fa:	e0ca                	sd	s2,64(sp)
    26fc:	fc4e                	sd	s3,56(sp)
    26fe:	1080                	addi	s0,sp,96
  for(int avail = 0; avail < 15; avail++){
    2700:	4901                	li	s2,0
    2702:	49bd                	li	s3,15
    int pid = fork();
    2704:	5fc020ef          	jal	4d00 <fork>
    2708:	84aa                	mv	s1,a0
    if(pid < 0){
    270a:	00054e63          	bltz	a0,2726 <execout+0x34>
    } else if(pid == 0){
    270e:	c51d                	beqz	a0,273c <execout+0x4a>
      wait((int*)0);
    2710:	4501                	li	a0,0
    2712:	5fe020ef          	jal	4d10 <wait>
  for(int avail = 0; avail < 15; avail++){
    2716:	2905                	addiw	s2,s2,1
    2718:	ff3916e3          	bne	s2,s3,2704 <execout+0x12>
    271c:	f852                	sd	s4,48(sp)
    271e:	f456                	sd	s5,40(sp)
  exit(0);
    2720:	4501                	li	a0,0
    2722:	5e6020ef          	jal	4d08 <exit>
    2726:	f852                	sd	s4,48(sp)
    2728:	f456                	sd	s5,40(sp)
      printf("fork failed\n");
    272a:	00005517          	auipc	a0,0x5
    272e:	9ce50513          	addi	a0,a0,-1586 # 70f8 <malloc+0x1f2e>
    2732:	1e1020ef          	jal	5112 <printf>
      exit(1);
    2736:	4505                	li	a0,1
    2738:	5d0020ef          	jal	4d08 <exit>
    273c:	f852                	sd	s4,48(sp)
    273e:	f456                	sd	s5,40(sp)
        uint64 a = (uint64) sbrk(4096);
    2740:	6985                	lui	s3,0x1
        if(a == 0xffffffffffffffffLL)
    2742:	5a7d                	li	s4,-1
        *(char*)(a + 4096 - 1) = 1;
    2744:	4a85                	li	s5,1
        uint64 a = (uint64) sbrk(4096);
    2746:	854e                	mv	a0,s3
    2748:	648020ef          	jal	4d90 <sbrk>
        if(a == 0xffffffffffffffffLL)
    274c:	01450663          	beq	a0,s4,2758 <execout+0x66>
        *(char*)(a + 4096 - 1) = 1;
    2750:	954e                	add	a0,a0,s3
    2752:	ff550fa3          	sb	s5,-1(a0)
      while(1){
    2756:	bfc5                	j	2746 <execout+0x54>
        sbrk(-4096);
    2758:	79fd                	lui	s3,0xfffff
      for(int i = 0; i < avail; i++)
    275a:	01205863          	blez	s2,276a <execout+0x78>
        sbrk(-4096);
    275e:	854e                	mv	a0,s3
    2760:	630020ef          	jal	4d90 <sbrk>
      for(int i = 0; i < avail; i++)
    2764:	2485                	addiw	s1,s1,1
    2766:	ff249ce3          	bne	s1,s2,275e <execout+0x6c>
      close(1);
    276a:	4505                	li	a0,1
    276c:	5c4020ef          	jal	4d30 <close>
      char *args[] = { "echo", "x", 0 };
    2770:	00003517          	auipc	a0,0x3
    2774:	b8850513          	addi	a0,a0,-1144 # 52f8 <malloc+0x12e>
    2778:	faa43423          	sd	a0,-88(s0)
    277c:	00003797          	auipc	a5,0x3
    2780:	bec78793          	addi	a5,a5,-1044 # 5368 <malloc+0x19e>
    2784:	faf43823          	sd	a5,-80(s0)
    2788:	fa043c23          	sd	zero,-72(s0)
      exec("echo", args);
    278c:	fa840593          	addi	a1,s0,-88
    2790:	5b0020ef          	jal	4d40 <exec>
      exit(0);
    2794:	4501                	li	a0,0
    2796:	572020ef          	jal	4d08 <exit>

000000000000279a <fourteen>:
{
    279a:	1101                	addi	sp,sp,-32
    279c:	ec06                	sd	ra,24(sp)
    279e:	e822                	sd	s0,16(sp)
    27a0:	e426                	sd	s1,8(sp)
    27a2:	1000                	addi	s0,sp,32
    27a4:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    27a6:	00004517          	auipc	a0,0x4
    27aa:	bea50513          	addi	a0,a0,-1046 # 6390 <malloc+0x11c6>
    27ae:	5c2020ef          	jal	4d70 <mkdir>
    27b2:	e555                	bnez	a0,285e <fourteen+0xc4>
  if(mkdir("12345678901234/123456789012345") != 0){
    27b4:	00004517          	auipc	a0,0x4
    27b8:	a3450513          	addi	a0,a0,-1484 # 61e8 <malloc+0x101e>
    27bc:	5b4020ef          	jal	4d70 <mkdir>
    27c0:	e94d                	bnez	a0,2872 <fourteen+0xd8>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    27c2:	20000593          	li	a1,512
    27c6:	00004517          	auipc	a0,0x4
    27ca:	a7a50513          	addi	a0,a0,-1414 # 6240 <malloc+0x1076>
    27ce:	57a020ef          	jal	4d48 <open>
  if(fd < 0){
    27d2:	0a054a63          	bltz	a0,2886 <fourteen+0xec>
  close(fd);
    27d6:	55a020ef          	jal	4d30 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    27da:	4581                	li	a1,0
    27dc:	00004517          	auipc	a0,0x4
    27e0:	adc50513          	addi	a0,a0,-1316 # 62b8 <malloc+0x10ee>
    27e4:	564020ef          	jal	4d48 <open>
  if(fd < 0){
    27e8:	0a054963          	bltz	a0,289a <fourteen+0x100>
  close(fd);
    27ec:	544020ef          	jal	4d30 <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    27f0:	00004517          	auipc	a0,0x4
    27f4:	b3850513          	addi	a0,a0,-1224 # 6328 <malloc+0x115e>
    27f8:	578020ef          	jal	4d70 <mkdir>
    27fc:	c94d                	beqz	a0,28ae <fourteen+0x114>
  if(mkdir("123456789012345/12345678901234") == 0){
    27fe:	00004517          	auipc	a0,0x4
    2802:	b8250513          	addi	a0,a0,-1150 # 6380 <malloc+0x11b6>
    2806:	56a020ef          	jal	4d70 <mkdir>
    280a:	cd45                	beqz	a0,28c2 <fourteen+0x128>
  unlink("123456789012345/12345678901234");
    280c:	00004517          	auipc	a0,0x4
    2810:	b7450513          	addi	a0,a0,-1164 # 6380 <malloc+0x11b6>
    2814:	544020ef          	jal	4d58 <unlink>
  unlink("12345678901234/12345678901234");
    2818:	00004517          	auipc	a0,0x4
    281c:	b1050513          	addi	a0,a0,-1264 # 6328 <malloc+0x115e>
    2820:	538020ef          	jal	4d58 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    2824:	00004517          	auipc	a0,0x4
    2828:	a9450513          	addi	a0,a0,-1388 # 62b8 <malloc+0x10ee>
    282c:	52c020ef          	jal	4d58 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    2830:	00004517          	auipc	a0,0x4
    2834:	a1050513          	addi	a0,a0,-1520 # 6240 <malloc+0x1076>
    2838:	520020ef          	jal	4d58 <unlink>
  unlink("12345678901234/123456789012345");
    283c:	00004517          	auipc	a0,0x4
    2840:	9ac50513          	addi	a0,a0,-1620 # 61e8 <malloc+0x101e>
    2844:	514020ef          	jal	4d58 <unlink>
  unlink("12345678901234");
    2848:	00004517          	auipc	a0,0x4
    284c:	b4850513          	addi	a0,a0,-1208 # 6390 <malloc+0x11c6>
    2850:	508020ef          	jal	4d58 <unlink>
}
    2854:	60e2                	ld	ra,24(sp)
    2856:	6442                	ld	s0,16(sp)
    2858:	64a2                	ld	s1,8(sp)
    285a:	6105                	addi	sp,sp,32
    285c:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    285e:	85a6                	mv	a1,s1
    2860:	00004517          	auipc	a0,0x4
    2864:	96050513          	addi	a0,a0,-1696 # 61c0 <malloc+0xff6>
    2868:	0ab020ef          	jal	5112 <printf>
    exit(1);
    286c:	4505                	li	a0,1
    286e:	49a020ef          	jal	4d08 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    2872:	85a6                	mv	a1,s1
    2874:	00004517          	auipc	a0,0x4
    2878:	99450513          	addi	a0,a0,-1644 # 6208 <malloc+0x103e>
    287c:	097020ef          	jal	5112 <printf>
    exit(1);
    2880:	4505                	li	a0,1
    2882:	486020ef          	jal	4d08 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    2886:	85a6                	mv	a1,s1
    2888:	00004517          	auipc	a0,0x4
    288c:	9e850513          	addi	a0,a0,-1560 # 6270 <malloc+0x10a6>
    2890:	083020ef          	jal	5112 <printf>
    exit(1);
    2894:	4505                	li	a0,1
    2896:	472020ef          	jal	4d08 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    289a:	85a6                	mv	a1,s1
    289c:	00004517          	auipc	a0,0x4
    28a0:	a4c50513          	addi	a0,a0,-1460 # 62e8 <malloc+0x111e>
    28a4:	06f020ef          	jal	5112 <printf>
    exit(1);
    28a8:	4505                	li	a0,1
    28aa:	45e020ef          	jal	4d08 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    28ae:	85a6                	mv	a1,s1
    28b0:	00004517          	auipc	a0,0x4
    28b4:	a9850513          	addi	a0,a0,-1384 # 6348 <malloc+0x117e>
    28b8:	05b020ef          	jal	5112 <printf>
    exit(1);
    28bc:	4505                	li	a0,1
    28be:	44a020ef          	jal	4d08 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    28c2:	85a6                	mv	a1,s1
    28c4:	00004517          	auipc	a0,0x4
    28c8:	adc50513          	addi	a0,a0,-1316 # 63a0 <malloc+0x11d6>
    28cc:	047020ef          	jal	5112 <printf>
    exit(1);
    28d0:	4505                	li	a0,1
    28d2:	436020ef          	jal	4d08 <exit>

00000000000028d6 <diskfull>:
{
    28d6:	b6010113          	addi	sp,sp,-1184
    28da:	48113c23          	sd	ra,1176(sp)
    28de:	48813823          	sd	s0,1168(sp)
    28e2:	48913423          	sd	s1,1160(sp)
    28e6:	49213023          	sd	s2,1152(sp)
    28ea:	47313c23          	sd	s3,1144(sp)
    28ee:	47413823          	sd	s4,1136(sp)
    28f2:	47513423          	sd	s5,1128(sp)
    28f6:	47613023          	sd	s6,1120(sp)
    28fa:	45713c23          	sd	s7,1112(sp)
    28fe:	45813823          	sd	s8,1104(sp)
    2902:	45913423          	sd	s9,1096(sp)
    2906:	45a13023          	sd	s10,1088(sp)
    290a:	43b13c23          	sd	s11,1080(sp)
    290e:	4a010413          	addi	s0,sp,1184
    2912:	b6a43423          	sd	a0,-1176(s0)
  unlink("diskfulldir");
    2916:	00004517          	auipc	a0,0x4
    291a:	ac250513          	addi	a0,a0,-1342 # 63d8 <malloc+0x120e>
    291e:	43a020ef          	jal	4d58 <unlink>
    2922:	03000a93          	li	s5,48
    name[0] = 'b';
    2926:	06200d93          	li	s11,98
    name[1] = 'i';
    292a:	06900d13          	li	s10,105
    name[2] = 'g';
    292e:	06700c93          	li	s9,103
    unlink(name);
    2932:	b7040b13          	addi	s6,s0,-1168
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    2936:	60200c13          	li	s8,1538
    293a:	6bc1                	lui	s7,0x10
    293c:	10bb8b93          	addi	s7,s7,267 # 1010b <base+0x1493>
      if(write(fd, buf, BSIZE) != BSIZE){
    2940:	b9040a13          	addi	s4,s0,-1136
    2944:	aa8d                	j	2ab6 <diskfull+0x1e0>
      printf("%s: could not create file %s\n", s, name);
    2946:	b7040613          	addi	a2,s0,-1168
    294a:	b6843583          	ld	a1,-1176(s0)
    294e:	00004517          	auipc	a0,0x4
    2952:	a9a50513          	addi	a0,a0,-1382 # 63e8 <malloc+0x121e>
    2956:	7bc020ef          	jal	5112 <printf>
      break;
    295a:	a039                	j	2968 <diskfull+0x92>
        close(fd);
    295c:	854e                	mv	a0,s3
    295e:	3d2020ef          	jal	4d30 <close>
    close(fd);
    2962:	854e                	mv	a0,s3
    2964:	3cc020ef          	jal	4d30 <close>
  for(int i = 0; i < nzz; i++){
    2968:	4481                	li	s1,0
    name[0] = 'z';
    296a:	07a00993          	li	s3,122
    unlink(name);
    296e:	b9040913          	addi	s2,s0,-1136
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    2972:	60200a13          	li	s4,1538
  for(int i = 0; i < nzz; i++){
    2976:	08000a93          	li	s5,128
    name[0] = 'z';
    297a:	b9340823          	sb	s3,-1136(s0)
    name[1] = 'z';
    297e:	b93408a3          	sb	s3,-1135(s0)
    name[2] = '0' + (i / 32);
    2982:	41f4d71b          	sraiw	a4,s1,0x1f
    2986:	01b7571b          	srliw	a4,a4,0x1b
    298a:	009707bb          	addw	a5,a4,s1
    298e:	4057d69b          	sraiw	a3,a5,0x5
    2992:	0306869b          	addiw	a3,a3,48
    2996:	b8d40923          	sb	a3,-1134(s0)
    name[3] = '0' + (i % 32);
    299a:	8bfd                	andi	a5,a5,31
    299c:	9f99                	subw	a5,a5,a4
    299e:	0307879b          	addiw	a5,a5,48
    29a2:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    29a6:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    29aa:	854a                	mv	a0,s2
    29ac:	3ac020ef          	jal	4d58 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    29b0:	85d2                	mv	a1,s4
    29b2:	854a                	mv	a0,s2
    29b4:	394020ef          	jal	4d48 <open>
    if(fd < 0)
    29b8:	00054763          	bltz	a0,29c6 <diskfull+0xf0>
    close(fd);
    29bc:	374020ef          	jal	4d30 <close>
  for(int i = 0; i < nzz; i++){
    29c0:	2485                	addiw	s1,s1,1
    29c2:	fb549ce3          	bne	s1,s5,297a <diskfull+0xa4>
  if(mkdir("diskfulldir") == 0)
    29c6:	00004517          	auipc	a0,0x4
    29ca:	a1250513          	addi	a0,a0,-1518 # 63d8 <malloc+0x120e>
    29ce:	3a2020ef          	jal	4d70 <mkdir>
    29d2:	12050363          	beqz	a0,2af8 <diskfull+0x222>
  unlink("diskfulldir");
    29d6:	00004517          	auipc	a0,0x4
    29da:	a0250513          	addi	a0,a0,-1534 # 63d8 <malloc+0x120e>
    29de:	37a020ef          	jal	4d58 <unlink>
  for(int i = 0; i < nzz; i++){
    29e2:	4481                	li	s1,0
    name[0] = 'z';
    29e4:	07a00913          	li	s2,122
    unlink(name);
    29e8:	b9040a13          	addi	s4,s0,-1136
  for(int i = 0; i < nzz; i++){
    29ec:	08000993          	li	s3,128
    name[0] = 'z';
    29f0:	b9240823          	sb	s2,-1136(s0)
    name[1] = 'z';
    29f4:	b92408a3          	sb	s2,-1135(s0)
    name[2] = '0' + (i / 32);
    29f8:	41f4d71b          	sraiw	a4,s1,0x1f
    29fc:	01b7571b          	srliw	a4,a4,0x1b
    2a00:	009707bb          	addw	a5,a4,s1
    2a04:	4057d69b          	sraiw	a3,a5,0x5
    2a08:	0306869b          	addiw	a3,a3,48
    2a0c:	b8d40923          	sb	a3,-1134(s0)
    name[3] = '0' + (i % 32);
    2a10:	8bfd                	andi	a5,a5,31
    2a12:	9f99                	subw	a5,a5,a4
    2a14:	0307879b          	addiw	a5,a5,48
    2a18:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    2a1c:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    2a20:	8552                	mv	a0,s4
    2a22:	336020ef          	jal	4d58 <unlink>
  for(int i = 0; i < nzz; i++){
    2a26:	2485                	addiw	s1,s1,1
    2a28:	fd3494e3          	bne	s1,s3,29f0 <diskfull+0x11a>
    2a2c:	03000493          	li	s1,48
    name[0] = 'b';
    2a30:	06200b13          	li	s6,98
    name[1] = 'i';
    2a34:	06900a93          	li	s5,105
    name[2] = 'g';
    2a38:	06700a13          	li	s4,103
    unlink(name);
    2a3c:	b9040993          	addi	s3,s0,-1136
  for(int i = 0; '0' + i < 0177; i++){
    2a40:	07f00913          	li	s2,127
    name[0] = 'b';
    2a44:	b9640823          	sb	s6,-1136(s0)
    name[1] = 'i';
    2a48:	b95408a3          	sb	s5,-1135(s0)
    name[2] = 'g';
    2a4c:	b9440923          	sb	s4,-1134(s0)
    name[3] = '0' + i;
    2a50:	b89409a3          	sb	s1,-1133(s0)
    name[4] = '\0';
    2a54:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    2a58:	854e                	mv	a0,s3
    2a5a:	2fe020ef          	jal	4d58 <unlink>
  for(int i = 0; '0' + i < 0177; i++){
    2a5e:	2485                	addiw	s1,s1,1
    2a60:	0ff4f493          	zext.b	s1,s1
    2a64:	ff2490e3          	bne	s1,s2,2a44 <diskfull+0x16e>
}
    2a68:	49813083          	ld	ra,1176(sp)
    2a6c:	49013403          	ld	s0,1168(sp)
    2a70:	48813483          	ld	s1,1160(sp)
    2a74:	48013903          	ld	s2,1152(sp)
    2a78:	47813983          	ld	s3,1144(sp)
    2a7c:	47013a03          	ld	s4,1136(sp)
    2a80:	46813a83          	ld	s5,1128(sp)
    2a84:	46013b03          	ld	s6,1120(sp)
    2a88:	45813b83          	ld	s7,1112(sp)
    2a8c:	45013c03          	ld	s8,1104(sp)
    2a90:	44813c83          	ld	s9,1096(sp)
    2a94:	44013d03          	ld	s10,1088(sp)
    2a98:	43813d83          	ld	s11,1080(sp)
    2a9c:	4a010113          	addi	sp,sp,1184
    2aa0:	8082                	ret
    close(fd);
    2aa2:	854e                	mv	a0,s3
    2aa4:	28c020ef          	jal	4d30 <close>
  for(fi = 0; done == 0 && '0' + fi < 0177; fi++){
    2aa8:	2a85                	addiw	s5,s5,1
    2aaa:	0ffafa93          	zext.b	s5,s5
    2aae:	07f00793          	li	a5,127
    2ab2:	eafa8be3          	beq	s5,a5,2968 <diskfull+0x92>
    name[0] = 'b';
    2ab6:	b7b40823          	sb	s11,-1168(s0)
    name[1] = 'i';
    2aba:	b7a408a3          	sb	s10,-1167(s0)
    name[2] = 'g';
    2abe:	b7940923          	sb	s9,-1166(s0)
    name[3] = '0' + fi;
    2ac2:	b75409a3          	sb	s5,-1165(s0)
    name[4] = '\0';
    2ac6:	b6040a23          	sb	zero,-1164(s0)
    unlink(name);
    2aca:	855a                	mv	a0,s6
    2acc:	28c020ef          	jal	4d58 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    2ad0:	85e2                	mv	a1,s8
    2ad2:	855a                	mv	a0,s6
    2ad4:	274020ef          	jal	4d48 <open>
    2ad8:	89aa                	mv	s3,a0
    if(fd < 0){
    2ada:	e60546e3          	bltz	a0,2946 <diskfull+0x70>
    2ade:	84de                	mv	s1,s7
      if(write(fd, buf, BSIZE) != BSIZE){
    2ae0:	40000913          	li	s2,1024
    2ae4:	864a                	mv	a2,s2
    2ae6:	85d2                	mv	a1,s4
    2ae8:	854e                	mv	a0,s3
    2aea:	23e020ef          	jal	4d28 <write>
    2aee:	e72517e3          	bne	a0,s2,295c <diskfull+0x86>
    for(int i = 0; i < MAXFILE; i++){
    2af2:	34fd                	addiw	s1,s1,-1
    2af4:	f8e5                	bnez	s1,2ae4 <diskfull+0x20e>
    2af6:	b775                	j	2aa2 <diskfull+0x1cc>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n", s);
    2af8:	b6843583          	ld	a1,-1176(s0)
    2afc:	00004517          	auipc	a0,0x4
    2b00:	90c50513          	addi	a0,a0,-1780 # 6408 <malloc+0x123e>
    2b04:	60e020ef          	jal	5112 <printf>
    2b08:	b5f9                	j	29d6 <diskfull+0x100>

0000000000002b0a <iputtest>:
{
    2b0a:	1101                	addi	sp,sp,-32
    2b0c:	ec06                	sd	ra,24(sp)
    2b0e:	e822                	sd	s0,16(sp)
    2b10:	e426                	sd	s1,8(sp)
    2b12:	1000                	addi	s0,sp,32
    2b14:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    2b16:	00004517          	auipc	a0,0x4
    2b1a:	92250513          	addi	a0,a0,-1758 # 6438 <malloc+0x126e>
    2b1e:	252020ef          	jal	4d70 <mkdir>
    2b22:	02054f63          	bltz	a0,2b60 <iputtest+0x56>
  if(chdir("iputdir") < 0){
    2b26:	00004517          	auipc	a0,0x4
    2b2a:	91250513          	addi	a0,a0,-1774 # 6438 <malloc+0x126e>
    2b2e:	24a020ef          	jal	4d78 <chdir>
    2b32:	04054163          	bltz	a0,2b74 <iputtest+0x6a>
  if(unlink("../iputdir") < 0){
    2b36:	00004517          	auipc	a0,0x4
    2b3a:	94250513          	addi	a0,a0,-1726 # 6478 <malloc+0x12ae>
    2b3e:	21a020ef          	jal	4d58 <unlink>
    2b42:	04054363          	bltz	a0,2b88 <iputtest+0x7e>
  if(chdir("/") < 0){
    2b46:	00004517          	auipc	a0,0x4
    2b4a:	96250513          	addi	a0,a0,-1694 # 64a8 <malloc+0x12de>
    2b4e:	22a020ef          	jal	4d78 <chdir>
    2b52:	04054563          	bltz	a0,2b9c <iputtest+0x92>
}
    2b56:	60e2                	ld	ra,24(sp)
    2b58:	6442                	ld	s0,16(sp)
    2b5a:	64a2                	ld	s1,8(sp)
    2b5c:	6105                	addi	sp,sp,32
    2b5e:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2b60:	85a6                	mv	a1,s1
    2b62:	00004517          	auipc	a0,0x4
    2b66:	8de50513          	addi	a0,a0,-1826 # 6440 <malloc+0x1276>
    2b6a:	5a8020ef          	jal	5112 <printf>
    exit(1);
    2b6e:	4505                	li	a0,1
    2b70:	198020ef          	jal	4d08 <exit>
    printf("%s: chdir iputdir failed\n", s);
    2b74:	85a6                	mv	a1,s1
    2b76:	00004517          	auipc	a0,0x4
    2b7a:	8e250513          	addi	a0,a0,-1822 # 6458 <malloc+0x128e>
    2b7e:	594020ef          	jal	5112 <printf>
    exit(1);
    2b82:	4505                	li	a0,1
    2b84:	184020ef          	jal	4d08 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    2b88:	85a6                	mv	a1,s1
    2b8a:	00004517          	auipc	a0,0x4
    2b8e:	8fe50513          	addi	a0,a0,-1794 # 6488 <malloc+0x12be>
    2b92:	580020ef          	jal	5112 <printf>
    exit(1);
    2b96:	4505                	li	a0,1
    2b98:	170020ef          	jal	4d08 <exit>
    printf("%s: chdir / failed\n", s);
    2b9c:	85a6                	mv	a1,s1
    2b9e:	00004517          	auipc	a0,0x4
    2ba2:	91250513          	addi	a0,a0,-1774 # 64b0 <malloc+0x12e6>
    2ba6:	56c020ef          	jal	5112 <printf>
    exit(1);
    2baa:	4505                	li	a0,1
    2bac:	15c020ef          	jal	4d08 <exit>

0000000000002bb0 <exitiputtest>:
{
    2bb0:	7179                	addi	sp,sp,-48
    2bb2:	f406                	sd	ra,40(sp)
    2bb4:	f022                	sd	s0,32(sp)
    2bb6:	ec26                	sd	s1,24(sp)
    2bb8:	1800                	addi	s0,sp,48
    2bba:	84aa                	mv	s1,a0
  pid = fork();
    2bbc:	144020ef          	jal	4d00 <fork>
  if(pid < 0){
    2bc0:	02054e63          	bltz	a0,2bfc <exitiputtest+0x4c>
  if(pid == 0){
    2bc4:	e541                	bnez	a0,2c4c <exitiputtest+0x9c>
    if(mkdir("iputdir") < 0){
    2bc6:	00004517          	auipc	a0,0x4
    2bca:	87250513          	addi	a0,a0,-1934 # 6438 <malloc+0x126e>
    2bce:	1a2020ef          	jal	4d70 <mkdir>
    2bd2:	02054f63          	bltz	a0,2c10 <exitiputtest+0x60>
    if(chdir("iputdir") < 0){
    2bd6:	00004517          	auipc	a0,0x4
    2bda:	86250513          	addi	a0,a0,-1950 # 6438 <malloc+0x126e>
    2bde:	19a020ef          	jal	4d78 <chdir>
    2be2:	04054163          	bltz	a0,2c24 <exitiputtest+0x74>
    if(unlink("../iputdir") < 0){
    2be6:	00004517          	auipc	a0,0x4
    2bea:	89250513          	addi	a0,a0,-1902 # 6478 <malloc+0x12ae>
    2bee:	16a020ef          	jal	4d58 <unlink>
    2bf2:	04054363          	bltz	a0,2c38 <exitiputtest+0x88>
    exit(0);
    2bf6:	4501                	li	a0,0
    2bf8:	110020ef          	jal	4d08 <exit>
    printf("%s: fork failed\n", s);
    2bfc:	85a6                	mv	a1,s1
    2bfe:	00003517          	auipc	a0,0x3
    2c02:	f8a50513          	addi	a0,a0,-118 # 5b88 <malloc+0x9be>
    2c06:	50c020ef          	jal	5112 <printf>
    exit(1);
    2c0a:	4505                	li	a0,1
    2c0c:	0fc020ef          	jal	4d08 <exit>
      printf("%s: mkdir failed\n", s);
    2c10:	85a6                	mv	a1,s1
    2c12:	00004517          	auipc	a0,0x4
    2c16:	82e50513          	addi	a0,a0,-2002 # 6440 <malloc+0x1276>
    2c1a:	4f8020ef          	jal	5112 <printf>
      exit(1);
    2c1e:	4505                	li	a0,1
    2c20:	0e8020ef          	jal	4d08 <exit>
      printf("%s: child chdir failed\n", s);
    2c24:	85a6                	mv	a1,s1
    2c26:	00004517          	auipc	a0,0x4
    2c2a:	8a250513          	addi	a0,a0,-1886 # 64c8 <malloc+0x12fe>
    2c2e:	4e4020ef          	jal	5112 <printf>
      exit(1);
    2c32:	4505                	li	a0,1
    2c34:	0d4020ef          	jal	4d08 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2c38:	85a6                	mv	a1,s1
    2c3a:	00004517          	auipc	a0,0x4
    2c3e:	84e50513          	addi	a0,a0,-1970 # 6488 <malloc+0x12be>
    2c42:	4d0020ef          	jal	5112 <printf>
      exit(1);
    2c46:	4505                	li	a0,1
    2c48:	0c0020ef          	jal	4d08 <exit>
  wait(&xstatus);
    2c4c:	fdc40513          	addi	a0,s0,-36
    2c50:	0c0020ef          	jal	4d10 <wait>
  exit(xstatus);
    2c54:	fdc42503          	lw	a0,-36(s0)
    2c58:	0b0020ef          	jal	4d08 <exit>

0000000000002c5c <dirtest>:
{
    2c5c:	1101                	addi	sp,sp,-32
    2c5e:	ec06                	sd	ra,24(sp)
    2c60:	e822                	sd	s0,16(sp)
    2c62:	e426                	sd	s1,8(sp)
    2c64:	1000                	addi	s0,sp,32
    2c66:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    2c68:	00004517          	auipc	a0,0x4
    2c6c:	87850513          	addi	a0,a0,-1928 # 64e0 <malloc+0x1316>
    2c70:	100020ef          	jal	4d70 <mkdir>
    2c74:	02054f63          	bltz	a0,2cb2 <dirtest+0x56>
  if(chdir("dir0") < 0){
    2c78:	00004517          	auipc	a0,0x4
    2c7c:	86850513          	addi	a0,a0,-1944 # 64e0 <malloc+0x1316>
    2c80:	0f8020ef          	jal	4d78 <chdir>
    2c84:	04054163          	bltz	a0,2cc6 <dirtest+0x6a>
  if(chdir("..") < 0){
    2c88:	00004517          	auipc	a0,0x4
    2c8c:	87850513          	addi	a0,a0,-1928 # 6500 <malloc+0x1336>
    2c90:	0e8020ef          	jal	4d78 <chdir>
    2c94:	04054363          	bltz	a0,2cda <dirtest+0x7e>
  if(unlink("dir0") < 0){
    2c98:	00004517          	auipc	a0,0x4
    2c9c:	84850513          	addi	a0,a0,-1976 # 64e0 <malloc+0x1316>
    2ca0:	0b8020ef          	jal	4d58 <unlink>
    2ca4:	04054563          	bltz	a0,2cee <dirtest+0x92>
}
    2ca8:	60e2                	ld	ra,24(sp)
    2caa:	6442                	ld	s0,16(sp)
    2cac:	64a2                	ld	s1,8(sp)
    2cae:	6105                	addi	sp,sp,32
    2cb0:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2cb2:	85a6                	mv	a1,s1
    2cb4:	00003517          	auipc	a0,0x3
    2cb8:	78c50513          	addi	a0,a0,1932 # 6440 <malloc+0x1276>
    2cbc:	456020ef          	jal	5112 <printf>
    exit(1);
    2cc0:	4505                	li	a0,1
    2cc2:	046020ef          	jal	4d08 <exit>
    printf("%s: chdir dir0 failed\n", s);
    2cc6:	85a6                	mv	a1,s1
    2cc8:	00004517          	auipc	a0,0x4
    2ccc:	82050513          	addi	a0,a0,-2016 # 64e8 <malloc+0x131e>
    2cd0:	442020ef          	jal	5112 <printf>
    exit(1);
    2cd4:	4505                	li	a0,1
    2cd6:	032020ef          	jal	4d08 <exit>
    printf("%s: chdir .. failed\n", s);
    2cda:	85a6                	mv	a1,s1
    2cdc:	00004517          	auipc	a0,0x4
    2ce0:	82c50513          	addi	a0,a0,-2004 # 6508 <malloc+0x133e>
    2ce4:	42e020ef          	jal	5112 <printf>
    exit(1);
    2ce8:	4505                	li	a0,1
    2cea:	01e020ef          	jal	4d08 <exit>
    printf("%s: unlink dir0 failed\n", s);
    2cee:	85a6                	mv	a1,s1
    2cf0:	00004517          	auipc	a0,0x4
    2cf4:	83050513          	addi	a0,a0,-2000 # 6520 <malloc+0x1356>
    2cf8:	41a020ef          	jal	5112 <printf>
    exit(1);
    2cfc:	4505                	li	a0,1
    2cfe:	00a020ef          	jal	4d08 <exit>

0000000000002d02 <subdir>:
{
    2d02:	1101                	addi	sp,sp,-32
    2d04:	ec06                	sd	ra,24(sp)
    2d06:	e822                	sd	s0,16(sp)
    2d08:	e426                	sd	s1,8(sp)
    2d0a:	e04a                	sd	s2,0(sp)
    2d0c:	1000                	addi	s0,sp,32
    2d0e:	892a                	mv	s2,a0
  unlink("ff");
    2d10:	00004517          	auipc	a0,0x4
    2d14:	95850513          	addi	a0,a0,-1704 # 6668 <malloc+0x149e>
    2d18:	040020ef          	jal	4d58 <unlink>
  if(mkdir("dd") != 0){
    2d1c:	00004517          	auipc	a0,0x4
    2d20:	81c50513          	addi	a0,a0,-2020 # 6538 <malloc+0x136e>
    2d24:	04c020ef          	jal	4d70 <mkdir>
    2d28:	2e051263          	bnez	a0,300c <subdir+0x30a>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    2d2c:	20200593          	li	a1,514
    2d30:	00004517          	auipc	a0,0x4
    2d34:	82850513          	addi	a0,a0,-2008 # 6558 <malloc+0x138e>
    2d38:	010020ef          	jal	4d48 <open>
    2d3c:	84aa                	mv	s1,a0
  if(fd < 0){
    2d3e:	2e054163          	bltz	a0,3020 <subdir+0x31e>
  write(fd, "ff", 2);
    2d42:	4609                	li	a2,2
    2d44:	00004597          	auipc	a1,0x4
    2d48:	92458593          	addi	a1,a1,-1756 # 6668 <malloc+0x149e>
    2d4c:	7dd010ef          	jal	4d28 <write>
  close(fd);
    2d50:	8526                	mv	a0,s1
    2d52:	7df010ef          	jal	4d30 <close>
  if(unlink("dd") >= 0){
    2d56:	00003517          	auipc	a0,0x3
    2d5a:	7e250513          	addi	a0,a0,2018 # 6538 <malloc+0x136e>
    2d5e:	7fb010ef          	jal	4d58 <unlink>
    2d62:	2c055963          	bgez	a0,3034 <subdir+0x332>
  if(mkdir("/dd/dd") != 0){
    2d66:	00004517          	auipc	a0,0x4
    2d6a:	84a50513          	addi	a0,a0,-1974 # 65b0 <malloc+0x13e6>
    2d6e:	002020ef          	jal	4d70 <mkdir>
    2d72:	2c051b63          	bnez	a0,3048 <subdir+0x346>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2d76:	20200593          	li	a1,514
    2d7a:	00004517          	auipc	a0,0x4
    2d7e:	85e50513          	addi	a0,a0,-1954 # 65d8 <malloc+0x140e>
    2d82:	7c7010ef          	jal	4d48 <open>
    2d86:	84aa                	mv	s1,a0
  if(fd < 0){
    2d88:	2c054a63          	bltz	a0,305c <subdir+0x35a>
  write(fd, "FF", 2);
    2d8c:	4609                	li	a2,2
    2d8e:	00004597          	auipc	a1,0x4
    2d92:	87a58593          	addi	a1,a1,-1926 # 6608 <malloc+0x143e>
    2d96:	793010ef          	jal	4d28 <write>
  close(fd);
    2d9a:	8526                	mv	a0,s1
    2d9c:	795010ef          	jal	4d30 <close>
  fd = open("dd/dd/../ff", 0);
    2da0:	4581                	li	a1,0
    2da2:	00004517          	auipc	a0,0x4
    2da6:	86e50513          	addi	a0,a0,-1938 # 6610 <malloc+0x1446>
    2daa:	79f010ef          	jal	4d48 <open>
    2dae:	84aa                	mv	s1,a0
  if(fd < 0){
    2db0:	2c054063          	bltz	a0,3070 <subdir+0x36e>
  cc = read(fd, buf, sizeof(buf));
    2db4:	660d                	lui	a2,0x3
    2db6:	00009597          	auipc	a1,0x9
    2dba:	ec258593          	addi	a1,a1,-318 # bc78 <buf>
    2dbe:	763010ef          	jal	4d20 <read>
  if(cc != 2 || buf[0] != 'f'){
    2dc2:	4789                	li	a5,2
    2dc4:	2cf51063          	bne	a0,a5,3084 <subdir+0x382>
    2dc8:	00009717          	auipc	a4,0x9
    2dcc:	eb074703          	lbu	a4,-336(a4) # bc78 <buf>
    2dd0:	06600793          	li	a5,102
    2dd4:	2af71863          	bne	a4,a5,3084 <subdir+0x382>
  close(fd);
    2dd8:	8526                	mv	a0,s1
    2dda:	757010ef          	jal	4d30 <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    2dde:	00004597          	auipc	a1,0x4
    2de2:	88258593          	addi	a1,a1,-1918 # 6660 <malloc+0x1496>
    2de6:	00003517          	auipc	a0,0x3
    2dea:	7f250513          	addi	a0,a0,2034 # 65d8 <malloc+0x140e>
    2dee:	77b010ef          	jal	4d68 <link>
    2df2:	2a051363          	bnez	a0,3098 <subdir+0x396>
  if(unlink("dd/dd/ff") != 0){
    2df6:	00003517          	auipc	a0,0x3
    2dfa:	7e250513          	addi	a0,a0,2018 # 65d8 <malloc+0x140e>
    2dfe:	75b010ef          	jal	4d58 <unlink>
    2e02:	2a051563          	bnez	a0,30ac <subdir+0x3aa>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2e06:	4581                	li	a1,0
    2e08:	00003517          	auipc	a0,0x3
    2e0c:	7d050513          	addi	a0,a0,2000 # 65d8 <malloc+0x140e>
    2e10:	739010ef          	jal	4d48 <open>
    2e14:	2a055663          	bgez	a0,30c0 <subdir+0x3be>
  if(chdir("dd") != 0){
    2e18:	00003517          	auipc	a0,0x3
    2e1c:	72050513          	addi	a0,a0,1824 # 6538 <malloc+0x136e>
    2e20:	759010ef          	jal	4d78 <chdir>
    2e24:	2a051863          	bnez	a0,30d4 <subdir+0x3d2>
  if(chdir("dd/../../dd") != 0){
    2e28:	00004517          	auipc	a0,0x4
    2e2c:	8d050513          	addi	a0,a0,-1840 # 66f8 <malloc+0x152e>
    2e30:	749010ef          	jal	4d78 <chdir>
    2e34:	2a051a63          	bnez	a0,30e8 <subdir+0x3e6>
  if(chdir("dd/../../../dd") != 0){
    2e38:	00004517          	auipc	a0,0x4
    2e3c:	8f050513          	addi	a0,a0,-1808 # 6728 <malloc+0x155e>
    2e40:	739010ef          	jal	4d78 <chdir>
    2e44:	2a051c63          	bnez	a0,30fc <subdir+0x3fa>
  if(chdir("./..") != 0){
    2e48:	00004517          	auipc	a0,0x4
    2e4c:	91850513          	addi	a0,a0,-1768 # 6760 <malloc+0x1596>
    2e50:	729010ef          	jal	4d78 <chdir>
    2e54:	2a051e63          	bnez	a0,3110 <subdir+0x40e>
  fd = open("dd/dd/ffff", 0);
    2e58:	4581                	li	a1,0
    2e5a:	00004517          	auipc	a0,0x4
    2e5e:	80650513          	addi	a0,a0,-2042 # 6660 <malloc+0x1496>
    2e62:	6e7010ef          	jal	4d48 <open>
    2e66:	84aa                	mv	s1,a0
  if(fd < 0){
    2e68:	2a054e63          	bltz	a0,3124 <subdir+0x422>
  if(read(fd, buf, sizeof(buf)) != 2){
    2e6c:	660d                	lui	a2,0x3
    2e6e:	00009597          	auipc	a1,0x9
    2e72:	e0a58593          	addi	a1,a1,-502 # bc78 <buf>
    2e76:	6ab010ef          	jal	4d20 <read>
    2e7a:	4789                	li	a5,2
    2e7c:	2af51e63          	bne	a0,a5,3138 <subdir+0x436>
  close(fd);
    2e80:	8526                	mv	a0,s1
    2e82:	6af010ef          	jal	4d30 <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2e86:	4581                	li	a1,0
    2e88:	00003517          	auipc	a0,0x3
    2e8c:	75050513          	addi	a0,a0,1872 # 65d8 <malloc+0x140e>
    2e90:	6b9010ef          	jal	4d48 <open>
    2e94:	2a055c63          	bgez	a0,314c <subdir+0x44a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    2e98:	20200593          	li	a1,514
    2e9c:	00004517          	auipc	a0,0x4
    2ea0:	95450513          	addi	a0,a0,-1708 # 67f0 <malloc+0x1626>
    2ea4:	6a5010ef          	jal	4d48 <open>
    2ea8:	2a055c63          	bgez	a0,3160 <subdir+0x45e>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    2eac:	20200593          	li	a1,514
    2eb0:	00004517          	auipc	a0,0x4
    2eb4:	97050513          	addi	a0,a0,-1680 # 6820 <malloc+0x1656>
    2eb8:	691010ef          	jal	4d48 <open>
    2ebc:	2a055c63          	bgez	a0,3174 <subdir+0x472>
  if(open("dd", O_CREATE) >= 0){
    2ec0:	20000593          	li	a1,512
    2ec4:	00003517          	auipc	a0,0x3
    2ec8:	67450513          	addi	a0,a0,1652 # 6538 <malloc+0x136e>
    2ecc:	67d010ef          	jal	4d48 <open>
    2ed0:	2a055c63          	bgez	a0,3188 <subdir+0x486>
  if(open("dd", O_RDWR) >= 0){
    2ed4:	4589                	li	a1,2
    2ed6:	00003517          	auipc	a0,0x3
    2eda:	66250513          	addi	a0,a0,1634 # 6538 <malloc+0x136e>
    2ede:	66b010ef          	jal	4d48 <open>
    2ee2:	2a055d63          	bgez	a0,319c <subdir+0x49a>
  if(open("dd", O_WRONLY) >= 0){
    2ee6:	4585                	li	a1,1
    2ee8:	00003517          	auipc	a0,0x3
    2eec:	65050513          	addi	a0,a0,1616 # 6538 <malloc+0x136e>
    2ef0:	659010ef          	jal	4d48 <open>
    2ef4:	2a055e63          	bgez	a0,31b0 <subdir+0x4ae>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    2ef8:	00004597          	auipc	a1,0x4
    2efc:	9b858593          	addi	a1,a1,-1608 # 68b0 <malloc+0x16e6>
    2f00:	00004517          	auipc	a0,0x4
    2f04:	8f050513          	addi	a0,a0,-1808 # 67f0 <malloc+0x1626>
    2f08:	661010ef          	jal	4d68 <link>
    2f0c:	2a050c63          	beqz	a0,31c4 <subdir+0x4c2>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    2f10:	00004597          	auipc	a1,0x4
    2f14:	9a058593          	addi	a1,a1,-1632 # 68b0 <malloc+0x16e6>
    2f18:	00004517          	auipc	a0,0x4
    2f1c:	90850513          	addi	a0,a0,-1784 # 6820 <malloc+0x1656>
    2f20:	649010ef          	jal	4d68 <link>
    2f24:	2a050a63          	beqz	a0,31d8 <subdir+0x4d6>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2f28:	00003597          	auipc	a1,0x3
    2f2c:	73858593          	addi	a1,a1,1848 # 6660 <malloc+0x1496>
    2f30:	00003517          	auipc	a0,0x3
    2f34:	62850513          	addi	a0,a0,1576 # 6558 <malloc+0x138e>
    2f38:	631010ef          	jal	4d68 <link>
    2f3c:	2a050863          	beqz	a0,31ec <subdir+0x4ea>
  if(mkdir("dd/ff/ff") == 0){
    2f40:	00004517          	auipc	a0,0x4
    2f44:	8b050513          	addi	a0,a0,-1872 # 67f0 <malloc+0x1626>
    2f48:	629010ef          	jal	4d70 <mkdir>
    2f4c:	2a050a63          	beqz	a0,3200 <subdir+0x4fe>
  if(mkdir("dd/xx/ff") == 0){
    2f50:	00004517          	auipc	a0,0x4
    2f54:	8d050513          	addi	a0,a0,-1840 # 6820 <malloc+0x1656>
    2f58:	619010ef          	jal	4d70 <mkdir>
    2f5c:	2a050c63          	beqz	a0,3214 <subdir+0x512>
  if(mkdir("dd/dd/ffff") == 0){
    2f60:	00003517          	auipc	a0,0x3
    2f64:	70050513          	addi	a0,a0,1792 # 6660 <malloc+0x1496>
    2f68:	609010ef          	jal	4d70 <mkdir>
    2f6c:	2a050e63          	beqz	a0,3228 <subdir+0x526>
  if(unlink("dd/xx/ff") == 0){
    2f70:	00004517          	auipc	a0,0x4
    2f74:	8b050513          	addi	a0,a0,-1872 # 6820 <malloc+0x1656>
    2f78:	5e1010ef          	jal	4d58 <unlink>
    2f7c:	2c050063          	beqz	a0,323c <subdir+0x53a>
  if(unlink("dd/ff/ff") == 0){
    2f80:	00004517          	auipc	a0,0x4
    2f84:	87050513          	addi	a0,a0,-1936 # 67f0 <malloc+0x1626>
    2f88:	5d1010ef          	jal	4d58 <unlink>
    2f8c:	2c050263          	beqz	a0,3250 <subdir+0x54e>
  if(chdir("dd/ff") == 0){
    2f90:	00003517          	auipc	a0,0x3
    2f94:	5c850513          	addi	a0,a0,1480 # 6558 <malloc+0x138e>
    2f98:	5e1010ef          	jal	4d78 <chdir>
    2f9c:	2c050463          	beqz	a0,3264 <subdir+0x562>
  if(chdir("dd/xx") == 0){
    2fa0:	00004517          	auipc	a0,0x4
    2fa4:	a6050513          	addi	a0,a0,-1440 # 6a00 <malloc+0x1836>
    2fa8:	5d1010ef          	jal	4d78 <chdir>
    2fac:	2c050663          	beqz	a0,3278 <subdir+0x576>
  if(unlink("dd/dd/ffff") != 0){
    2fb0:	00003517          	auipc	a0,0x3
    2fb4:	6b050513          	addi	a0,a0,1712 # 6660 <malloc+0x1496>
    2fb8:	5a1010ef          	jal	4d58 <unlink>
    2fbc:	2c051863          	bnez	a0,328c <subdir+0x58a>
  if(unlink("dd/ff") != 0){
    2fc0:	00003517          	auipc	a0,0x3
    2fc4:	59850513          	addi	a0,a0,1432 # 6558 <malloc+0x138e>
    2fc8:	591010ef          	jal	4d58 <unlink>
    2fcc:	2c051a63          	bnez	a0,32a0 <subdir+0x59e>
  if(unlink("dd") == 0){
    2fd0:	00003517          	auipc	a0,0x3
    2fd4:	56850513          	addi	a0,a0,1384 # 6538 <malloc+0x136e>
    2fd8:	581010ef          	jal	4d58 <unlink>
    2fdc:	2c050c63          	beqz	a0,32b4 <subdir+0x5b2>
  if(unlink("dd/dd") < 0){
    2fe0:	00004517          	auipc	a0,0x4
    2fe4:	a9050513          	addi	a0,a0,-1392 # 6a70 <malloc+0x18a6>
    2fe8:	571010ef          	jal	4d58 <unlink>
    2fec:	2c054e63          	bltz	a0,32c8 <subdir+0x5c6>
  if(unlink("dd") < 0){
    2ff0:	00003517          	auipc	a0,0x3
    2ff4:	54850513          	addi	a0,a0,1352 # 6538 <malloc+0x136e>
    2ff8:	561010ef          	jal	4d58 <unlink>
    2ffc:	2e054063          	bltz	a0,32dc <subdir+0x5da>
}
    3000:	60e2                	ld	ra,24(sp)
    3002:	6442                	ld	s0,16(sp)
    3004:	64a2                	ld	s1,8(sp)
    3006:	6902                	ld	s2,0(sp)
    3008:	6105                	addi	sp,sp,32
    300a:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    300c:	85ca                	mv	a1,s2
    300e:	00003517          	auipc	a0,0x3
    3012:	53250513          	addi	a0,a0,1330 # 6540 <malloc+0x1376>
    3016:	0fc020ef          	jal	5112 <printf>
    exit(1);
    301a:	4505                	li	a0,1
    301c:	4ed010ef          	jal	4d08 <exit>
    printf("%s: create dd/ff failed\n", s);
    3020:	85ca                	mv	a1,s2
    3022:	00003517          	auipc	a0,0x3
    3026:	53e50513          	addi	a0,a0,1342 # 6560 <malloc+0x1396>
    302a:	0e8020ef          	jal	5112 <printf>
    exit(1);
    302e:	4505                	li	a0,1
    3030:	4d9010ef          	jal	4d08 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    3034:	85ca                	mv	a1,s2
    3036:	00003517          	auipc	a0,0x3
    303a:	54a50513          	addi	a0,a0,1354 # 6580 <malloc+0x13b6>
    303e:	0d4020ef          	jal	5112 <printf>
    exit(1);
    3042:	4505                	li	a0,1
    3044:	4c5010ef          	jal	4d08 <exit>
    printf("%s: subdir mkdir dd/dd failed\n", s);
    3048:	85ca                	mv	a1,s2
    304a:	00003517          	auipc	a0,0x3
    304e:	56e50513          	addi	a0,a0,1390 # 65b8 <malloc+0x13ee>
    3052:	0c0020ef          	jal	5112 <printf>
    exit(1);
    3056:	4505                	li	a0,1
    3058:	4b1010ef          	jal	4d08 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    305c:	85ca                	mv	a1,s2
    305e:	00003517          	auipc	a0,0x3
    3062:	58a50513          	addi	a0,a0,1418 # 65e8 <malloc+0x141e>
    3066:	0ac020ef          	jal	5112 <printf>
    exit(1);
    306a:	4505                	li	a0,1
    306c:	49d010ef          	jal	4d08 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    3070:	85ca                	mv	a1,s2
    3072:	00003517          	auipc	a0,0x3
    3076:	5ae50513          	addi	a0,a0,1454 # 6620 <malloc+0x1456>
    307a:	098020ef          	jal	5112 <printf>
    exit(1);
    307e:	4505                	li	a0,1
    3080:	489010ef          	jal	4d08 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    3084:	85ca                	mv	a1,s2
    3086:	00003517          	auipc	a0,0x3
    308a:	5ba50513          	addi	a0,a0,1466 # 6640 <malloc+0x1476>
    308e:	084020ef          	jal	5112 <printf>
    exit(1);
    3092:	4505                	li	a0,1
    3094:	475010ef          	jal	4d08 <exit>
    printf("%s: link dd/dd/ff dd/dd/ffff failed\n", s);
    3098:	85ca                	mv	a1,s2
    309a:	00003517          	auipc	a0,0x3
    309e:	5d650513          	addi	a0,a0,1494 # 6670 <malloc+0x14a6>
    30a2:	070020ef          	jal	5112 <printf>
    exit(1);
    30a6:	4505                	li	a0,1
    30a8:	461010ef          	jal	4d08 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    30ac:	85ca                	mv	a1,s2
    30ae:	00003517          	auipc	a0,0x3
    30b2:	5ea50513          	addi	a0,a0,1514 # 6698 <malloc+0x14ce>
    30b6:	05c020ef          	jal	5112 <printf>
    exit(1);
    30ba:	4505                	li	a0,1
    30bc:	44d010ef          	jal	4d08 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    30c0:	85ca                	mv	a1,s2
    30c2:	00003517          	auipc	a0,0x3
    30c6:	5f650513          	addi	a0,a0,1526 # 66b8 <malloc+0x14ee>
    30ca:	048020ef          	jal	5112 <printf>
    exit(1);
    30ce:	4505                	li	a0,1
    30d0:	439010ef          	jal	4d08 <exit>
    printf("%s: chdir dd failed\n", s);
    30d4:	85ca                	mv	a1,s2
    30d6:	00003517          	auipc	a0,0x3
    30da:	60a50513          	addi	a0,a0,1546 # 66e0 <malloc+0x1516>
    30de:	034020ef          	jal	5112 <printf>
    exit(1);
    30e2:	4505                	li	a0,1
    30e4:	425010ef          	jal	4d08 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    30e8:	85ca                	mv	a1,s2
    30ea:	00003517          	auipc	a0,0x3
    30ee:	61e50513          	addi	a0,a0,1566 # 6708 <malloc+0x153e>
    30f2:	020020ef          	jal	5112 <printf>
    exit(1);
    30f6:	4505                	li	a0,1
    30f8:	411010ef          	jal	4d08 <exit>
    printf("%s: chdir dd/../../../dd failed\n", s);
    30fc:	85ca                	mv	a1,s2
    30fe:	00003517          	auipc	a0,0x3
    3102:	63a50513          	addi	a0,a0,1594 # 6738 <malloc+0x156e>
    3106:	00c020ef          	jal	5112 <printf>
    exit(1);
    310a:	4505                	li	a0,1
    310c:	3fd010ef          	jal	4d08 <exit>
    printf("%s: chdir ./.. failed\n", s);
    3110:	85ca                	mv	a1,s2
    3112:	00003517          	auipc	a0,0x3
    3116:	65650513          	addi	a0,a0,1622 # 6768 <malloc+0x159e>
    311a:	7f9010ef          	jal	5112 <printf>
    exit(1);
    311e:	4505                	li	a0,1
    3120:	3e9010ef          	jal	4d08 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    3124:	85ca                	mv	a1,s2
    3126:	00003517          	auipc	a0,0x3
    312a:	65a50513          	addi	a0,a0,1626 # 6780 <malloc+0x15b6>
    312e:	7e5010ef          	jal	5112 <printf>
    exit(1);
    3132:	4505                	li	a0,1
    3134:	3d5010ef          	jal	4d08 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3138:	85ca                	mv	a1,s2
    313a:	00003517          	auipc	a0,0x3
    313e:	66650513          	addi	a0,a0,1638 # 67a0 <malloc+0x15d6>
    3142:	7d1010ef          	jal	5112 <printf>
    exit(1);
    3146:	4505                	li	a0,1
    3148:	3c1010ef          	jal	4d08 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    314c:	85ca                	mv	a1,s2
    314e:	00003517          	auipc	a0,0x3
    3152:	67250513          	addi	a0,a0,1650 # 67c0 <malloc+0x15f6>
    3156:	7bd010ef          	jal	5112 <printf>
    exit(1);
    315a:	4505                	li	a0,1
    315c:	3ad010ef          	jal	4d08 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    3160:	85ca                	mv	a1,s2
    3162:	00003517          	auipc	a0,0x3
    3166:	69e50513          	addi	a0,a0,1694 # 6800 <malloc+0x1636>
    316a:	7a9010ef          	jal	5112 <printf>
    exit(1);
    316e:	4505                	li	a0,1
    3170:	399010ef          	jal	4d08 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3174:	85ca                	mv	a1,s2
    3176:	00003517          	auipc	a0,0x3
    317a:	6ba50513          	addi	a0,a0,1722 # 6830 <malloc+0x1666>
    317e:	795010ef          	jal	5112 <printf>
    exit(1);
    3182:	4505                	li	a0,1
    3184:	385010ef          	jal	4d08 <exit>
    printf("%s: create dd succeeded!\n", s);
    3188:	85ca                	mv	a1,s2
    318a:	00003517          	auipc	a0,0x3
    318e:	6c650513          	addi	a0,a0,1734 # 6850 <malloc+0x1686>
    3192:	781010ef          	jal	5112 <printf>
    exit(1);
    3196:	4505                	li	a0,1
    3198:	371010ef          	jal	4d08 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    319c:	85ca                	mv	a1,s2
    319e:	00003517          	auipc	a0,0x3
    31a2:	6d250513          	addi	a0,a0,1746 # 6870 <malloc+0x16a6>
    31a6:	76d010ef          	jal	5112 <printf>
    exit(1);
    31aa:	4505                	li	a0,1
    31ac:	35d010ef          	jal	4d08 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    31b0:	85ca                	mv	a1,s2
    31b2:	00003517          	auipc	a0,0x3
    31b6:	6de50513          	addi	a0,a0,1758 # 6890 <malloc+0x16c6>
    31ba:	759010ef          	jal	5112 <printf>
    exit(1);
    31be:	4505                	li	a0,1
    31c0:	349010ef          	jal	4d08 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    31c4:	85ca                	mv	a1,s2
    31c6:	00003517          	auipc	a0,0x3
    31ca:	6fa50513          	addi	a0,a0,1786 # 68c0 <malloc+0x16f6>
    31ce:	745010ef          	jal	5112 <printf>
    exit(1);
    31d2:	4505                	li	a0,1
    31d4:	335010ef          	jal	4d08 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    31d8:	85ca                	mv	a1,s2
    31da:	00003517          	auipc	a0,0x3
    31de:	70e50513          	addi	a0,a0,1806 # 68e8 <malloc+0x171e>
    31e2:	731010ef          	jal	5112 <printf>
    exit(1);
    31e6:	4505                	li	a0,1
    31e8:	321010ef          	jal	4d08 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    31ec:	85ca                	mv	a1,s2
    31ee:	00003517          	auipc	a0,0x3
    31f2:	72250513          	addi	a0,a0,1826 # 6910 <malloc+0x1746>
    31f6:	71d010ef          	jal	5112 <printf>
    exit(1);
    31fa:	4505                	li	a0,1
    31fc:	30d010ef          	jal	4d08 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    3200:	85ca                	mv	a1,s2
    3202:	00003517          	auipc	a0,0x3
    3206:	73650513          	addi	a0,a0,1846 # 6938 <malloc+0x176e>
    320a:	709010ef          	jal	5112 <printf>
    exit(1);
    320e:	4505                	li	a0,1
    3210:	2f9010ef          	jal	4d08 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    3214:	85ca                	mv	a1,s2
    3216:	00003517          	auipc	a0,0x3
    321a:	74250513          	addi	a0,a0,1858 # 6958 <malloc+0x178e>
    321e:	6f5010ef          	jal	5112 <printf>
    exit(1);
    3222:	4505                	li	a0,1
    3224:	2e5010ef          	jal	4d08 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3228:	85ca                	mv	a1,s2
    322a:	00003517          	auipc	a0,0x3
    322e:	74e50513          	addi	a0,a0,1870 # 6978 <malloc+0x17ae>
    3232:	6e1010ef          	jal	5112 <printf>
    exit(1);
    3236:	4505                	li	a0,1
    3238:	2d1010ef          	jal	4d08 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    323c:	85ca                	mv	a1,s2
    323e:	00003517          	auipc	a0,0x3
    3242:	76250513          	addi	a0,a0,1890 # 69a0 <malloc+0x17d6>
    3246:	6cd010ef          	jal	5112 <printf>
    exit(1);
    324a:	4505                	li	a0,1
    324c:	2bd010ef          	jal	4d08 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    3250:	85ca                	mv	a1,s2
    3252:	00003517          	auipc	a0,0x3
    3256:	76e50513          	addi	a0,a0,1902 # 69c0 <malloc+0x17f6>
    325a:	6b9010ef          	jal	5112 <printf>
    exit(1);
    325e:	4505                	li	a0,1
    3260:	2a9010ef          	jal	4d08 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3264:	85ca                	mv	a1,s2
    3266:	00003517          	auipc	a0,0x3
    326a:	77a50513          	addi	a0,a0,1914 # 69e0 <malloc+0x1816>
    326e:	6a5010ef          	jal	5112 <printf>
    exit(1);
    3272:	4505                	li	a0,1
    3274:	295010ef          	jal	4d08 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3278:	85ca                	mv	a1,s2
    327a:	00003517          	auipc	a0,0x3
    327e:	78e50513          	addi	a0,a0,1934 # 6a08 <malloc+0x183e>
    3282:	691010ef          	jal	5112 <printf>
    exit(1);
    3286:	4505                	li	a0,1
    3288:	281010ef          	jal	4d08 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    328c:	85ca                	mv	a1,s2
    328e:	00003517          	auipc	a0,0x3
    3292:	40a50513          	addi	a0,a0,1034 # 6698 <malloc+0x14ce>
    3296:	67d010ef          	jal	5112 <printf>
    exit(1);
    329a:	4505                	li	a0,1
    329c:	26d010ef          	jal	4d08 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    32a0:	85ca                	mv	a1,s2
    32a2:	00003517          	auipc	a0,0x3
    32a6:	78650513          	addi	a0,a0,1926 # 6a28 <malloc+0x185e>
    32aa:	669010ef          	jal	5112 <printf>
    exit(1);
    32ae:	4505                	li	a0,1
    32b0:	259010ef          	jal	4d08 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    32b4:	85ca                	mv	a1,s2
    32b6:	00003517          	auipc	a0,0x3
    32ba:	79250513          	addi	a0,a0,1938 # 6a48 <malloc+0x187e>
    32be:	655010ef          	jal	5112 <printf>
    exit(1);
    32c2:	4505                	li	a0,1
    32c4:	245010ef          	jal	4d08 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    32c8:	85ca                	mv	a1,s2
    32ca:	00003517          	auipc	a0,0x3
    32ce:	7ae50513          	addi	a0,a0,1966 # 6a78 <malloc+0x18ae>
    32d2:	641010ef          	jal	5112 <printf>
    exit(1);
    32d6:	4505                	li	a0,1
    32d8:	231010ef          	jal	4d08 <exit>
    printf("%s: unlink dd failed\n", s);
    32dc:	85ca                	mv	a1,s2
    32de:	00003517          	auipc	a0,0x3
    32e2:	7ba50513          	addi	a0,a0,1978 # 6a98 <malloc+0x18ce>
    32e6:	62d010ef          	jal	5112 <printf>
    exit(1);
    32ea:	4505                	li	a0,1
    32ec:	21d010ef          	jal	4d08 <exit>

00000000000032f0 <rmdot>:
{
    32f0:	1101                	addi	sp,sp,-32
    32f2:	ec06                	sd	ra,24(sp)
    32f4:	e822                	sd	s0,16(sp)
    32f6:	e426                	sd	s1,8(sp)
    32f8:	1000                	addi	s0,sp,32
    32fa:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    32fc:	00003517          	auipc	a0,0x3
    3300:	7b450513          	addi	a0,a0,1972 # 6ab0 <malloc+0x18e6>
    3304:	26d010ef          	jal	4d70 <mkdir>
    3308:	e53d                	bnez	a0,3376 <rmdot+0x86>
  if(chdir("dots") != 0){
    330a:	00003517          	auipc	a0,0x3
    330e:	7a650513          	addi	a0,a0,1958 # 6ab0 <malloc+0x18e6>
    3312:	267010ef          	jal	4d78 <chdir>
    3316:	e935                	bnez	a0,338a <rmdot+0x9a>
  if(unlink(".") == 0){
    3318:	00002517          	auipc	a0,0x2
    331c:	6c850513          	addi	a0,a0,1736 # 59e0 <malloc+0x816>
    3320:	239010ef          	jal	4d58 <unlink>
    3324:	cd2d                	beqz	a0,339e <rmdot+0xae>
  if(unlink("..") == 0){
    3326:	00003517          	auipc	a0,0x3
    332a:	1da50513          	addi	a0,a0,474 # 6500 <malloc+0x1336>
    332e:	22b010ef          	jal	4d58 <unlink>
    3332:	c141                	beqz	a0,33b2 <rmdot+0xc2>
  if(chdir("/") != 0){
    3334:	00003517          	auipc	a0,0x3
    3338:	17450513          	addi	a0,a0,372 # 64a8 <malloc+0x12de>
    333c:	23d010ef          	jal	4d78 <chdir>
    3340:	e159                	bnez	a0,33c6 <rmdot+0xd6>
  if(unlink("dots/.") == 0){
    3342:	00003517          	auipc	a0,0x3
    3346:	7d650513          	addi	a0,a0,2006 # 6b18 <malloc+0x194e>
    334a:	20f010ef          	jal	4d58 <unlink>
    334e:	c551                	beqz	a0,33da <rmdot+0xea>
  if(unlink("dots/..") == 0){
    3350:	00003517          	auipc	a0,0x3
    3354:	7f050513          	addi	a0,a0,2032 # 6b40 <malloc+0x1976>
    3358:	201010ef          	jal	4d58 <unlink>
    335c:	c949                	beqz	a0,33ee <rmdot+0xfe>
  if(unlink("dots") != 0){
    335e:	00003517          	auipc	a0,0x3
    3362:	75250513          	addi	a0,a0,1874 # 6ab0 <malloc+0x18e6>
    3366:	1f3010ef          	jal	4d58 <unlink>
    336a:	ed41                	bnez	a0,3402 <rmdot+0x112>
}
    336c:	60e2                	ld	ra,24(sp)
    336e:	6442                	ld	s0,16(sp)
    3370:	64a2                	ld	s1,8(sp)
    3372:	6105                	addi	sp,sp,32
    3374:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    3376:	85a6                	mv	a1,s1
    3378:	00003517          	auipc	a0,0x3
    337c:	74050513          	addi	a0,a0,1856 # 6ab8 <malloc+0x18ee>
    3380:	593010ef          	jal	5112 <printf>
    exit(1);
    3384:	4505                	li	a0,1
    3386:	183010ef          	jal	4d08 <exit>
    printf("%s: chdir dots failed\n", s);
    338a:	85a6                	mv	a1,s1
    338c:	00003517          	auipc	a0,0x3
    3390:	74450513          	addi	a0,a0,1860 # 6ad0 <malloc+0x1906>
    3394:	57f010ef          	jal	5112 <printf>
    exit(1);
    3398:	4505                	li	a0,1
    339a:	16f010ef          	jal	4d08 <exit>
    printf("%s: rm . worked!\n", s);
    339e:	85a6                	mv	a1,s1
    33a0:	00003517          	auipc	a0,0x3
    33a4:	74850513          	addi	a0,a0,1864 # 6ae8 <malloc+0x191e>
    33a8:	56b010ef          	jal	5112 <printf>
    exit(1);
    33ac:	4505                	li	a0,1
    33ae:	15b010ef          	jal	4d08 <exit>
    printf("%s: rm .. worked!\n", s);
    33b2:	85a6                	mv	a1,s1
    33b4:	00003517          	auipc	a0,0x3
    33b8:	74c50513          	addi	a0,a0,1868 # 6b00 <malloc+0x1936>
    33bc:	557010ef          	jal	5112 <printf>
    exit(1);
    33c0:	4505                	li	a0,1
    33c2:	147010ef          	jal	4d08 <exit>
    printf("%s: chdir / failed\n", s);
    33c6:	85a6                	mv	a1,s1
    33c8:	00003517          	auipc	a0,0x3
    33cc:	0e850513          	addi	a0,a0,232 # 64b0 <malloc+0x12e6>
    33d0:	543010ef          	jal	5112 <printf>
    exit(1);
    33d4:	4505                	li	a0,1
    33d6:	133010ef          	jal	4d08 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    33da:	85a6                	mv	a1,s1
    33dc:	00003517          	auipc	a0,0x3
    33e0:	74450513          	addi	a0,a0,1860 # 6b20 <malloc+0x1956>
    33e4:	52f010ef          	jal	5112 <printf>
    exit(1);
    33e8:	4505                	li	a0,1
    33ea:	11f010ef          	jal	4d08 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    33ee:	85a6                	mv	a1,s1
    33f0:	00003517          	auipc	a0,0x3
    33f4:	75850513          	addi	a0,a0,1880 # 6b48 <malloc+0x197e>
    33f8:	51b010ef          	jal	5112 <printf>
    exit(1);
    33fc:	4505                	li	a0,1
    33fe:	10b010ef          	jal	4d08 <exit>
    printf("%s: unlink dots failed!\n", s);
    3402:	85a6                	mv	a1,s1
    3404:	00003517          	auipc	a0,0x3
    3408:	76450513          	addi	a0,a0,1892 # 6b68 <malloc+0x199e>
    340c:	507010ef          	jal	5112 <printf>
    exit(1);
    3410:	4505                	li	a0,1
    3412:	0f7010ef          	jal	4d08 <exit>

0000000000003416 <dirfile>:
{
    3416:	1101                	addi	sp,sp,-32
    3418:	ec06                	sd	ra,24(sp)
    341a:	e822                	sd	s0,16(sp)
    341c:	e426                	sd	s1,8(sp)
    341e:	e04a                	sd	s2,0(sp)
    3420:	1000                	addi	s0,sp,32
    3422:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    3424:	20000593          	li	a1,512
    3428:	00003517          	auipc	a0,0x3
    342c:	76050513          	addi	a0,a0,1888 # 6b88 <malloc+0x19be>
    3430:	119010ef          	jal	4d48 <open>
  if(fd < 0){
    3434:	0c054563          	bltz	a0,34fe <dirfile+0xe8>
  close(fd);
    3438:	0f9010ef          	jal	4d30 <close>
  if(chdir("dirfile") == 0){
    343c:	00003517          	auipc	a0,0x3
    3440:	74c50513          	addi	a0,a0,1868 # 6b88 <malloc+0x19be>
    3444:	135010ef          	jal	4d78 <chdir>
    3448:	c569                	beqz	a0,3512 <dirfile+0xfc>
  fd = open("dirfile/xx", 0);
    344a:	4581                	li	a1,0
    344c:	00003517          	auipc	a0,0x3
    3450:	78450513          	addi	a0,a0,1924 # 6bd0 <malloc+0x1a06>
    3454:	0f5010ef          	jal	4d48 <open>
  if(fd >= 0){
    3458:	0c055763          	bgez	a0,3526 <dirfile+0x110>
  fd = open("dirfile/xx", O_CREATE);
    345c:	20000593          	li	a1,512
    3460:	00003517          	auipc	a0,0x3
    3464:	77050513          	addi	a0,a0,1904 # 6bd0 <malloc+0x1a06>
    3468:	0e1010ef          	jal	4d48 <open>
  if(fd >= 0){
    346c:	0c055763          	bgez	a0,353a <dirfile+0x124>
  if(mkdir("dirfile/xx") == 0){
    3470:	00003517          	auipc	a0,0x3
    3474:	76050513          	addi	a0,a0,1888 # 6bd0 <malloc+0x1a06>
    3478:	0f9010ef          	jal	4d70 <mkdir>
    347c:	0c050963          	beqz	a0,354e <dirfile+0x138>
  if(unlink("dirfile/xx") == 0){
    3480:	00003517          	auipc	a0,0x3
    3484:	75050513          	addi	a0,a0,1872 # 6bd0 <malloc+0x1a06>
    3488:	0d1010ef          	jal	4d58 <unlink>
    348c:	0c050b63          	beqz	a0,3562 <dirfile+0x14c>
  if(link("README", "dirfile/xx") == 0){
    3490:	00003597          	auipc	a1,0x3
    3494:	74058593          	addi	a1,a1,1856 # 6bd0 <malloc+0x1a06>
    3498:	00002517          	auipc	a0,0x2
    349c:	03850513          	addi	a0,a0,56 # 54d0 <malloc+0x306>
    34a0:	0c9010ef          	jal	4d68 <link>
    34a4:	0c050963          	beqz	a0,3576 <dirfile+0x160>
  if(unlink("dirfile") != 0){
    34a8:	00003517          	auipc	a0,0x3
    34ac:	6e050513          	addi	a0,a0,1760 # 6b88 <malloc+0x19be>
    34b0:	0a9010ef          	jal	4d58 <unlink>
    34b4:	0c051b63          	bnez	a0,358a <dirfile+0x174>
  fd = open(".", O_RDWR);
    34b8:	4589                	li	a1,2
    34ba:	00002517          	auipc	a0,0x2
    34be:	52650513          	addi	a0,a0,1318 # 59e0 <malloc+0x816>
    34c2:	087010ef          	jal	4d48 <open>
  if(fd >= 0){
    34c6:	0c055c63          	bgez	a0,359e <dirfile+0x188>
  fd = open(".", 0);
    34ca:	4581                	li	a1,0
    34cc:	00002517          	auipc	a0,0x2
    34d0:	51450513          	addi	a0,a0,1300 # 59e0 <malloc+0x816>
    34d4:	075010ef          	jal	4d48 <open>
    34d8:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    34da:	4605                	li	a2,1
    34dc:	00002597          	auipc	a1,0x2
    34e0:	e8c58593          	addi	a1,a1,-372 # 5368 <malloc+0x19e>
    34e4:	045010ef          	jal	4d28 <write>
    34e8:	0ca04563          	bgtz	a0,35b2 <dirfile+0x19c>
  close(fd);
    34ec:	8526                	mv	a0,s1
    34ee:	043010ef          	jal	4d30 <close>
}
    34f2:	60e2                	ld	ra,24(sp)
    34f4:	6442                	ld	s0,16(sp)
    34f6:	64a2                	ld	s1,8(sp)
    34f8:	6902                	ld	s2,0(sp)
    34fa:	6105                	addi	sp,sp,32
    34fc:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    34fe:	85ca                	mv	a1,s2
    3500:	00003517          	auipc	a0,0x3
    3504:	69050513          	addi	a0,a0,1680 # 6b90 <malloc+0x19c6>
    3508:	40b010ef          	jal	5112 <printf>
    exit(1);
    350c:	4505                	li	a0,1
    350e:	7fa010ef          	jal	4d08 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    3512:	85ca                	mv	a1,s2
    3514:	00003517          	auipc	a0,0x3
    3518:	69c50513          	addi	a0,a0,1692 # 6bb0 <malloc+0x19e6>
    351c:	3f7010ef          	jal	5112 <printf>
    exit(1);
    3520:	4505                	li	a0,1
    3522:	7e6010ef          	jal	4d08 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    3526:	85ca                	mv	a1,s2
    3528:	00003517          	auipc	a0,0x3
    352c:	6b850513          	addi	a0,a0,1720 # 6be0 <malloc+0x1a16>
    3530:	3e3010ef          	jal	5112 <printf>
    exit(1);
    3534:	4505                	li	a0,1
    3536:	7d2010ef          	jal	4d08 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    353a:	85ca                	mv	a1,s2
    353c:	00003517          	auipc	a0,0x3
    3540:	6a450513          	addi	a0,a0,1700 # 6be0 <malloc+0x1a16>
    3544:	3cf010ef          	jal	5112 <printf>
    exit(1);
    3548:	4505                	li	a0,1
    354a:	7be010ef          	jal	4d08 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    354e:	85ca                	mv	a1,s2
    3550:	00003517          	auipc	a0,0x3
    3554:	6b850513          	addi	a0,a0,1720 # 6c08 <malloc+0x1a3e>
    3558:	3bb010ef          	jal	5112 <printf>
    exit(1);
    355c:	4505                	li	a0,1
    355e:	7aa010ef          	jal	4d08 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    3562:	85ca                	mv	a1,s2
    3564:	00003517          	auipc	a0,0x3
    3568:	6cc50513          	addi	a0,a0,1740 # 6c30 <malloc+0x1a66>
    356c:	3a7010ef          	jal	5112 <printf>
    exit(1);
    3570:	4505                	li	a0,1
    3572:	796010ef          	jal	4d08 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    3576:	85ca                	mv	a1,s2
    3578:	00003517          	auipc	a0,0x3
    357c:	6e050513          	addi	a0,a0,1760 # 6c58 <malloc+0x1a8e>
    3580:	393010ef          	jal	5112 <printf>
    exit(1);
    3584:	4505                	li	a0,1
    3586:	782010ef          	jal	4d08 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    358a:	85ca                	mv	a1,s2
    358c:	00003517          	auipc	a0,0x3
    3590:	6f450513          	addi	a0,a0,1780 # 6c80 <malloc+0x1ab6>
    3594:	37f010ef          	jal	5112 <printf>
    exit(1);
    3598:	4505                	li	a0,1
    359a:	76e010ef          	jal	4d08 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    359e:	85ca                	mv	a1,s2
    35a0:	00003517          	auipc	a0,0x3
    35a4:	70050513          	addi	a0,a0,1792 # 6ca0 <malloc+0x1ad6>
    35a8:	36b010ef          	jal	5112 <printf>
    exit(1);
    35ac:	4505                	li	a0,1
    35ae:	75a010ef          	jal	4d08 <exit>
    printf("%s: write . succeeded!\n", s);
    35b2:	85ca                	mv	a1,s2
    35b4:	00003517          	auipc	a0,0x3
    35b8:	71450513          	addi	a0,a0,1812 # 6cc8 <malloc+0x1afe>
    35bc:	357010ef          	jal	5112 <printf>
    exit(1);
    35c0:	4505                	li	a0,1
    35c2:	746010ef          	jal	4d08 <exit>

00000000000035c6 <iref>:
{
    35c6:	715d                	addi	sp,sp,-80
    35c8:	e486                	sd	ra,72(sp)
    35ca:	e0a2                	sd	s0,64(sp)
    35cc:	fc26                	sd	s1,56(sp)
    35ce:	f84a                	sd	s2,48(sp)
    35d0:	f44e                	sd	s3,40(sp)
    35d2:	f052                	sd	s4,32(sp)
    35d4:	ec56                	sd	s5,24(sp)
    35d6:	e85a                	sd	s6,16(sp)
    35d8:	e45e                	sd	s7,8(sp)
    35da:	0880                	addi	s0,sp,80
    35dc:	8baa                	mv	s7,a0
    35de:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    35e2:	00003a97          	auipc	s5,0x3
    35e6:	6fea8a93          	addi	s5,s5,1790 # 6ce0 <malloc+0x1b16>
    mkdir("");
    35ea:	00003497          	auipc	s1,0x3
    35ee:	1fe48493          	addi	s1,s1,510 # 67e8 <malloc+0x161e>
    link("README", "");
    35f2:	00002b17          	auipc	s6,0x2
    35f6:	edeb0b13          	addi	s6,s6,-290 # 54d0 <malloc+0x306>
    fd = open("", O_CREATE);
    35fa:	20000a13          	li	s4,512
    fd = open("xx", O_CREATE);
    35fe:	00003997          	auipc	s3,0x3
    3602:	5da98993          	addi	s3,s3,1498 # 6bd8 <malloc+0x1a0e>
    3606:	a835                	j	3642 <iref+0x7c>
      printf("%s: mkdir irefd failed\n", s);
    3608:	85de                	mv	a1,s7
    360a:	00003517          	auipc	a0,0x3
    360e:	6de50513          	addi	a0,a0,1758 # 6ce8 <malloc+0x1b1e>
    3612:	301010ef          	jal	5112 <printf>
      exit(1);
    3616:	4505                	li	a0,1
    3618:	6f0010ef          	jal	4d08 <exit>
      printf("%s: chdir irefd failed\n", s);
    361c:	85de                	mv	a1,s7
    361e:	00003517          	auipc	a0,0x3
    3622:	6e250513          	addi	a0,a0,1762 # 6d00 <malloc+0x1b36>
    3626:	2ed010ef          	jal	5112 <printf>
      exit(1);
    362a:	4505                	li	a0,1
    362c:	6dc010ef          	jal	4d08 <exit>
      close(fd);
    3630:	700010ef          	jal	4d30 <close>
    3634:	a825                	j	366c <iref+0xa6>
    unlink("xx");
    3636:	854e                	mv	a0,s3
    3638:	720010ef          	jal	4d58 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    363c:	397d                	addiw	s2,s2,-1
    363e:	04090063          	beqz	s2,367e <iref+0xb8>
    if(mkdir("irefd") != 0){
    3642:	8556                	mv	a0,s5
    3644:	72c010ef          	jal	4d70 <mkdir>
    3648:	f161                	bnez	a0,3608 <iref+0x42>
    if(chdir("irefd") != 0){
    364a:	8556                	mv	a0,s5
    364c:	72c010ef          	jal	4d78 <chdir>
    3650:	f571                	bnez	a0,361c <iref+0x56>
    mkdir("");
    3652:	8526                	mv	a0,s1
    3654:	71c010ef          	jal	4d70 <mkdir>
    link("README", "");
    3658:	85a6                	mv	a1,s1
    365a:	855a                	mv	a0,s6
    365c:	70c010ef          	jal	4d68 <link>
    fd = open("", O_CREATE);
    3660:	85d2                	mv	a1,s4
    3662:	8526                	mv	a0,s1
    3664:	6e4010ef          	jal	4d48 <open>
    if(fd >= 0)
    3668:	fc0554e3          	bgez	a0,3630 <iref+0x6a>
    fd = open("xx", O_CREATE);
    366c:	85d2                	mv	a1,s4
    366e:	854e                	mv	a0,s3
    3670:	6d8010ef          	jal	4d48 <open>
    if(fd >= 0)
    3674:	fc0541e3          	bltz	a0,3636 <iref+0x70>
      close(fd);
    3678:	6b8010ef          	jal	4d30 <close>
    367c:	bf6d                	j	3636 <iref+0x70>
    367e:	03300493          	li	s1,51
    chdir("..");
    3682:	00003997          	auipc	s3,0x3
    3686:	e7e98993          	addi	s3,s3,-386 # 6500 <malloc+0x1336>
    unlink("irefd");
    368a:	00003917          	auipc	s2,0x3
    368e:	65690913          	addi	s2,s2,1622 # 6ce0 <malloc+0x1b16>
    chdir("..");
    3692:	854e                	mv	a0,s3
    3694:	6e4010ef          	jal	4d78 <chdir>
    unlink("irefd");
    3698:	854a                	mv	a0,s2
    369a:	6be010ef          	jal	4d58 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    369e:	34fd                	addiw	s1,s1,-1
    36a0:	f8ed                	bnez	s1,3692 <iref+0xcc>
  chdir("/");
    36a2:	00003517          	auipc	a0,0x3
    36a6:	e0650513          	addi	a0,a0,-506 # 64a8 <malloc+0x12de>
    36aa:	6ce010ef          	jal	4d78 <chdir>
}
    36ae:	60a6                	ld	ra,72(sp)
    36b0:	6406                	ld	s0,64(sp)
    36b2:	74e2                	ld	s1,56(sp)
    36b4:	7942                	ld	s2,48(sp)
    36b6:	79a2                	ld	s3,40(sp)
    36b8:	7a02                	ld	s4,32(sp)
    36ba:	6ae2                	ld	s5,24(sp)
    36bc:	6b42                	ld	s6,16(sp)
    36be:	6ba2                	ld	s7,8(sp)
    36c0:	6161                	addi	sp,sp,80
    36c2:	8082                	ret

00000000000036c4 <openiputtest>:
{
    36c4:	7179                	addi	sp,sp,-48
    36c6:	f406                	sd	ra,40(sp)
    36c8:	f022                	sd	s0,32(sp)
    36ca:	ec26                	sd	s1,24(sp)
    36cc:	1800                	addi	s0,sp,48
    36ce:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    36d0:	00003517          	auipc	a0,0x3
    36d4:	64850513          	addi	a0,a0,1608 # 6d18 <malloc+0x1b4e>
    36d8:	698010ef          	jal	4d70 <mkdir>
    36dc:	02054a63          	bltz	a0,3710 <openiputtest+0x4c>
  pid = fork();
    36e0:	620010ef          	jal	4d00 <fork>
  if(pid < 0){
    36e4:	04054063          	bltz	a0,3724 <openiputtest+0x60>
  if(pid == 0){
    36e8:	e939                	bnez	a0,373e <openiputtest+0x7a>
    int fd = open("oidir", O_RDWR);
    36ea:	4589                	li	a1,2
    36ec:	00003517          	auipc	a0,0x3
    36f0:	62c50513          	addi	a0,a0,1580 # 6d18 <malloc+0x1b4e>
    36f4:	654010ef          	jal	4d48 <open>
    if(fd >= 0){
    36f8:	04054063          	bltz	a0,3738 <openiputtest+0x74>
      printf("%s: open directory for write succeeded\n", s);
    36fc:	85a6                	mv	a1,s1
    36fe:	00003517          	auipc	a0,0x3
    3702:	63a50513          	addi	a0,a0,1594 # 6d38 <malloc+0x1b6e>
    3706:	20d010ef          	jal	5112 <printf>
      exit(1);
    370a:	4505                	li	a0,1
    370c:	5fc010ef          	jal	4d08 <exit>
    printf("%s: mkdir oidir failed\n", s);
    3710:	85a6                	mv	a1,s1
    3712:	00003517          	auipc	a0,0x3
    3716:	60e50513          	addi	a0,a0,1550 # 6d20 <malloc+0x1b56>
    371a:	1f9010ef          	jal	5112 <printf>
    exit(1);
    371e:	4505                	li	a0,1
    3720:	5e8010ef          	jal	4d08 <exit>
    printf("%s: fork failed\n", s);
    3724:	85a6                	mv	a1,s1
    3726:	00002517          	auipc	a0,0x2
    372a:	46250513          	addi	a0,a0,1122 # 5b88 <malloc+0x9be>
    372e:	1e5010ef          	jal	5112 <printf>
    exit(1);
    3732:	4505                	li	a0,1
    3734:	5d4010ef          	jal	4d08 <exit>
    exit(0);
    3738:	4501                	li	a0,0
    373a:	5ce010ef          	jal	4d08 <exit>
  sleep(1);
    373e:	4505                	li	a0,1
    3740:	658010ef          	jal	4d98 <sleep>
  if(unlink("oidir") != 0){
    3744:	00003517          	auipc	a0,0x3
    3748:	5d450513          	addi	a0,a0,1492 # 6d18 <malloc+0x1b4e>
    374c:	60c010ef          	jal	4d58 <unlink>
    3750:	c919                	beqz	a0,3766 <openiputtest+0xa2>
    printf("%s: unlink failed\n", s);
    3752:	85a6                	mv	a1,s1
    3754:	00002517          	auipc	a0,0x2
    3758:	62450513          	addi	a0,a0,1572 # 5d78 <malloc+0xbae>
    375c:	1b7010ef          	jal	5112 <printf>
    exit(1);
    3760:	4505                	li	a0,1
    3762:	5a6010ef          	jal	4d08 <exit>
  wait(&xstatus);
    3766:	fdc40513          	addi	a0,s0,-36
    376a:	5a6010ef          	jal	4d10 <wait>
  exit(xstatus);
    376e:	fdc42503          	lw	a0,-36(s0)
    3772:	596010ef          	jal	4d08 <exit>

0000000000003776 <forkforkfork>:
{
    3776:	1101                	addi	sp,sp,-32
    3778:	ec06                	sd	ra,24(sp)
    377a:	e822                	sd	s0,16(sp)
    377c:	e426                	sd	s1,8(sp)
    377e:	1000                	addi	s0,sp,32
    3780:	84aa                	mv	s1,a0
  unlink("stopforking");
    3782:	00003517          	auipc	a0,0x3
    3786:	5de50513          	addi	a0,a0,1502 # 6d60 <malloc+0x1b96>
    378a:	5ce010ef          	jal	4d58 <unlink>
  int pid = fork();
    378e:	572010ef          	jal	4d00 <fork>
  if(pid < 0){
    3792:	02054b63          	bltz	a0,37c8 <forkforkfork+0x52>
  if(pid == 0){
    3796:	c139                	beqz	a0,37dc <forkforkfork+0x66>
  sleep(20); // two seconds
    3798:	4551                	li	a0,20
    379a:	5fe010ef          	jal	4d98 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    379e:	20200593          	li	a1,514
    37a2:	00003517          	auipc	a0,0x3
    37a6:	5be50513          	addi	a0,a0,1470 # 6d60 <malloc+0x1b96>
    37aa:	59e010ef          	jal	4d48 <open>
    37ae:	582010ef          	jal	4d30 <close>
  wait(0);
    37b2:	4501                	li	a0,0
    37b4:	55c010ef          	jal	4d10 <wait>
  sleep(10); // one second
    37b8:	4529                	li	a0,10
    37ba:	5de010ef          	jal	4d98 <sleep>
}
    37be:	60e2                	ld	ra,24(sp)
    37c0:	6442                	ld	s0,16(sp)
    37c2:	64a2                	ld	s1,8(sp)
    37c4:	6105                	addi	sp,sp,32
    37c6:	8082                	ret
    printf("%s: fork failed", s);
    37c8:	85a6                	mv	a1,s1
    37ca:	00002517          	auipc	a0,0x2
    37ce:	57e50513          	addi	a0,a0,1406 # 5d48 <malloc+0xb7e>
    37d2:	141010ef          	jal	5112 <printf>
    exit(1);
    37d6:	4505                	li	a0,1
    37d8:	530010ef          	jal	4d08 <exit>
      int fd = open("stopforking", 0);
    37dc:	00003497          	auipc	s1,0x3
    37e0:	58448493          	addi	s1,s1,1412 # 6d60 <malloc+0x1b96>
    37e4:	4581                	li	a1,0
    37e6:	8526                	mv	a0,s1
    37e8:	560010ef          	jal	4d48 <open>
      if(fd >= 0){
    37ec:	02055163          	bgez	a0,380e <forkforkfork+0x98>
      if(fork() < 0){
    37f0:	510010ef          	jal	4d00 <fork>
    37f4:	fe0558e3          	bgez	a0,37e4 <forkforkfork+0x6e>
        close(open("stopforking", O_CREATE|O_RDWR));
    37f8:	20200593          	li	a1,514
    37fc:	00003517          	auipc	a0,0x3
    3800:	56450513          	addi	a0,a0,1380 # 6d60 <malloc+0x1b96>
    3804:	544010ef          	jal	4d48 <open>
    3808:	528010ef          	jal	4d30 <close>
    380c:	bfe1                	j	37e4 <forkforkfork+0x6e>
        exit(0);
    380e:	4501                	li	a0,0
    3810:	4f8010ef          	jal	4d08 <exit>

0000000000003814 <killstatus>:
{
    3814:	715d                	addi	sp,sp,-80
    3816:	e486                	sd	ra,72(sp)
    3818:	e0a2                	sd	s0,64(sp)
    381a:	fc26                	sd	s1,56(sp)
    381c:	f84a                	sd	s2,48(sp)
    381e:	f44e                	sd	s3,40(sp)
    3820:	f052                	sd	s4,32(sp)
    3822:	ec56                	sd	s5,24(sp)
    3824:	e85a                	sd	s6,16(sp)
    3826:	0880                	addi	s0,sp,80
    3828:	8b2a                	mv	s6,a0
    382a:	06400913          	li	s2,100
    sleep(1);
    382e:	4a85                	li	s5,1
    wait(&xst);
    3830:	fbc40a13          	addi	s4,s0,-68
    if(xst != -1) {
    3834:	59fd                	li	s3,-1
    int pid1 = fork();
    3836:	4ca010ef          	jal	4d00 <fork>
    383a:	84aa                	mv	s1,a0
    if(pid1 < 0){
    383c:	02054663          	bltz	a0,3868 <killstatus+0x54>
    if(pid1 == 0){
    3840:	cd15                	beqz	a0,387c <killstatus+0x68>
    sleep(1);
    3842:	8556                	mv	a0,s5
    3844:	554010ef          	jal	4d98 <sleep>
    kill(pid1);
    3848:	8526                	mv	a0,s1
    384a:	4ee010ef          	jal	4d38 <kill>
    wait(&xst);
    384e:	8552                	mv	a0,s4
    3850:	4c0010ef          	jal	4d10 <wait>
    if(xst != -1) {
    3854:	fbc42783          	lw	a5,-68(s0)
    3858:	03379563          	bne	a5,s3,3882 <killstatus+0x6e>
  for(int i = 0; i < 100; i++){
    385c:	397d                	addiw	s2,s2,-1
    385e:	fc091ce3          	bnez	s2,3836 <killstatus+0x22>
  exit(0);
    3862:	4501                	li	a0,0
    3864:	4a4010ef          	jal	4d08 <exit>
      printf("%s: fork failed\n", s);
    3868:	85da                	mv	a1,s6
    386a:	00002517          	auipc	a0,0x2
    386e:	31e50513          	addi	a0,a0,798 # 5b88 <malloc+0x9be>
    3872:	0a1010ef          	jal	5112 <printf>
      exit(1);
    3876:	4505                	li	a0,1
    3878:	490010ef          	jal	4d08 <exit>
        getpid();
    387c:	50c010ef          	jal	4d88 <getpid>
      while(1) {
    3880:	bff5                	j	387c <killstatus+0x68>
       printf("%s: status should be -1\n", s);
    3882:	85da                	mv	a1,s6
    3884:	00003517          	auipc	a0,0x3
    3888:	4ec50513          	addi	a0,a0,1260 # 6d70 <malloc+0x1ba6>
    388c:	087010ef          	jal	5112 <printf>
       exit(1);
    3890:	4505                	li	a0,1
    3892:	476010ef          	jal	4d08 <exit>

0000000000003896 <preempt>:
{
    3896:	7139                	addi	sp,sp,-64
    3898:	fc06                	sd	ra,56(sp)
    389a:	f822                	sd	s0,48(sp)
    389c:	f426                	sd	s1,40(sp)
    389e:	f04a                	sd	s2,32(sp)
    38a0:	ec4e                	sd	s3,24(sp)
    38a2:	e852                	sd	s4,16(sp)
    38a4:	0080                	addi	s0,sp,64
    38a6:	892a                	mv	s2,a0
  pid1 = fork();
    38a8:	458010ef          	jal	4d00 <fork>
  if(pid1 < 0) {
    38ac:	00054563          	bltz	a0,38b6 <preempt+0x20>
    38b0:	84aa                	mv	s1,a0
  if(pid1 == 0)
    38b2:	ed01                	bnez	a0,38ca <preempt+0x34>
    for(;;)
    38b4:	a001                	j	38b4 <preempt+0x1e>
    printf("%s: fork failed", s);
    38b6:	85ca                	mv	a1,s2
    38b8:	00002517          	auipc	a0,0x2
    38bc:	49050513          	addi	a0,a0,1168 # 5d48 <malloc+0xb7e>
    38c0:	053010ef          	jal	5112 <printf>
    exit(1);
    38c4:	4505                	li	a0,1
    38c6:	442010ef          	jal	4d08 <exit>
  pid2 = fork();
    38ca:	436010ef          	jal	4d00 <fork>
    38ce:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    38d0:	00054463          	bltz	a0,38d8 <preempt+0x42>
  if(pid2 == 0)
    38d4:	ed01                	bnez	a0,38ec <preempt+0x56>
    for(;;)
    38d6:	a001                	j	38d6 <preempt+0x40>
    printf("%s: fork failed\n", s);
    38d8:	85ca                	mv	a1,s2
    38da:	00002517          	auipc	a0,0x2
    38de:	2ae50513          	addi	a0,a0,686 # 5b88 <malloc+0x9be>
    38e2:	031010ef          	jal	5112 <printf>
    exit(1);
    38e6:	4505                	li	a0,1
    38e8:	420010ef          	jal	4d08 <exit>
  pipe(pfds);
    38ec:	fc840513          	addi	a0,s0,-56
    38f0:	428010ef          	jal	4d18 <pipe>
  pid3 = fork();
    38f4:	40c010ef          	jal	4d00 <fork>
    38f8:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    38fa:	02054863          	bltz	a0,392a <preempt+0x94>
  if(pid3 == 0){
    38fe:	e921                	bnez	a0,394e <preempt+0xb8>
    close(pfds[0]);
    3900:	fc842503          	lw	a0,-56(s0)
    3904:	42c010ef          	jal	4d30 <close>
    if(write(pfds[1], "x", 1) != 1)
    3908:	4605                	li	a2,1
    390a:	00002597          	auipc	a1,0x2
    390e:	a5e58593          	addi	a1,a1,-1442 # 5368 <malloc+0x19e>
    3912:	fcc42503          	lw	a0,-52(s0)
    3916:	412010ef          	jal	4d28 <write>
    391a:	4785                	li	a5,1
    391c:	02f51163          	bne	a0,a5,393e <preempt+0xa8>
    close(pfds[1]);
    3920:	fcc42503          	lw	a0,-52(s0)
    3924:	40c010ef          	jal	4d30 <close>
    for(;;)
    3928:	a001                	j	3928 <preempt+0x92>
     printf("%s: fork failed\n", s);
    392a:	85ca                	mv	a1,s2
    392c:	00002517          	auipc	a0,0x2
    3930:	25c50513          	addi	a0,a0,604 # 5b88 <malloc+0x9be>
    3934:	7de010ef          	jal	5112 <printf>
     exit(1);
    3938:	4505                	li	a0,1
    393a:	3ce010ef          	jal	4d08 <exit>
      printf("%s: preempt write error", s);
    393e:	85ca                	mv	a1,s2
    3940:	00003517          	auipc	a0,0x3
    3944:	45050513          	addi	a0,a0,1104 # 6d90 <malloc+0x1bc6>
    3948:	7ca010ef          	jal	5112 <printf>
    394c:	bfd1                	j	3920 <preempt+0x8a>
  close(pfds[1]);
    394e:	fcc42503          	lw	a0,-52(s0)
    3952:	3de010ef          	jal	4d30 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    3956:	660d                	lui	a2,0x3
    3958:	00008597          	auipc	a1,0x8
    395c:	32058593          	addi	a1,a1,800 # bc78 <buf>
    3960:	fc842503          	lw	a0,-56(s0)
    3964:	3bc010ef          	jal	4d20 <read>
    3968:	4785                	li	a5,1
    396a:	02f50163          	beq	a0,a5,398c <preempt+0xf6>
    printf("%s: preempt read error", s);
    396e:	85ca                	mv	a1,s2
    3970:	00003517          	auipc	a0,0x3
    3974:	43850513          	addi	a0,a0,1080 # 6da8 <malloc+0x1bde>
    3978:	79a010ef          	jal	5112 <printf>
}
    397c:	70e2                	ld	ra,56(sp)
    397e:	7442                	ld	s0,48(sp)
    3980:	74a2                	ld	s1,40(sp)
    3982:	7902                	ld	s2,32(sp)
    3984:	69e2                	ld	s3,24(sp)
    3986:	6a42                	ld	s4,16(sp)
    3988:	6121                	addi	sp,sp,64
    398a:	8082                	ret
  close(pfds[0]);
    398c:	fc842503          	lw	a0,-56(s0)
    3990:	3a0010ef          	jal	4d30 <close>
  printf("kill... ");
    3994:	00003517          	auipc	a0,0x3
    3998:	42c50513          	addi	a0,a0,1068 # 6dc0 <malloc+0x1bf6>
    399c:	776010ef          	jal	5112 <printf>
  kill(pid1);
    39a0:	8526                	mv	a0,s1
    39a2:	396010ef          	jal	4d38 <kill>
  kill(pid2);
    39a6:	854e                	mv	a0,s3
    39a8:	390010ef          	jal	4d38 <kill>
  kill(pid3);
    39ac:	8552                	mv	a0,s4
    39ae:	38a010ef          	jal	4d38 <kill>
  printf("wait... ");
    39b2:	00003517          	auipc	a0,0x3
    39b6:	41e50513          	addi	a0,a0,1054 # 6dd0 <malloc+0x1c06>
    39ba:	758010ef          	jal	5112 <printf>
  wait(0);
    39be:	4501                	li	a0,0
    39c0:	350010ef          	jal	4d10 <wait>
  wait(0);
    39c4:	4501                	li	a0,0
    39c6:	34a010ef          	jal	4d10 <wait>
  wait(0);
    39ca:	4501                	li	a0,0
    39cc:	344010ef          	jal	4d10 <wait>
    39d0:	b775                	j	397c <preempt+0xe6>

00000000000039d2 <reparent>:
{
    39d2:	7179                	addi	sp,sp,-48
    39d4:	f406                	sd	ra,40(sp)
    39d6:	f022                	sd	s0,32(sp)
    39d8:	ec26                	sd	s1,24(sp)
    39da:	e84a                	sd	s2,16(sp)
    39dc:	e44e                	sd	s3,8(sp)
    39de:	e052                	sd	s4,0(sp)
    39e0:	1800                	addi	s0,sp,48
    39e2:	89aa                	mv	s3,a0
  int master_pid = getpid();
    39e4:	3a4010ef          	jal	4d88 <getpid>
    39e8:	8a2a                	mv	s4,a0
    39ea:	0c800913          	li	s2,200
    int pid = fork();
    39ee:	312010ef          	jal	4d00 <fork>
    39f2:	84aa                	mv	s1,a0
    if(pid < 0){
    39f4:	00054e63          	bltz	a0,3a10 <reparent+0x3e>
    if(pid){
    39f8:	c121                	beqz	a0,3a38 <reparent+0x66>
      if(wait(0) != pid){
    39fa:	4501                	li	a0,0
    39fc:	314010ef          	jal	4d10 <wait>
    3a00:	02951263          	bne	a0,s1,3a24 <reparent+0x52>
  for(int i = 0; i < 200; i++){
    3a04:	397d                	addiw	s2,s2,-1
    3a06:	fe0914e3          	bnez	s2,39ee <reparent+0x1c>
  exit(0);
    3a0a:	4501                	li	a0,0
    3a0c:	2fc010ef          	jal	4d08 <exit>
      printf("%s: fork failed\n", s);
    3a10:	85ce                	mv	a1,s3
    3a12:	00002517          	auipc	a0,0x2
    3a16:	17650513          	addi	a0,a0,374 # 5b88 <malloc+0x9be>
    3a1a:	6f8010ef          	jal	5112 <printf>
      exit(1);
    3a1e:	4505                	li	a0,1
    3a20:	2e8010ef          	jal	4d08 <exit>
        printf("%s: wait wrong pid\n", s);
    3a24:	85ce                	mv	a1,s3
    3a26:	00002517          	auipc	a0,0x2
    3a2a:	2ea50513          	addi	a0,a0,746 # 5d10 <malloc+0xb46>
    3a2e:	6e4010ef          	jal	5112 <printf>
        exit(1);
    3a32:	4505                	li	a0,1
    3a34:	2d4010ef          	jal	4d08 <exit>
      int pid2 = fork();
    3a38:	2c8010ef          	jal	4d00 <fork>
      if(pid2 < 0){
    3a3c:	00054563          	bltz	a0,3a46 <reparent+0x74>
      exit(0);
    3a40:	4501                	li	a0,0
    3a42:	2c6010ef          	jal	4d08 <exit>
        kill(master_pid);
    3a46:	8552                	mv	a0,s4
    3a48:	2f0010ef          	jal	4d38 <kill>
        exit(1);
    3a4c:	4505                	li	a0,1
    3a4e:	2ba010ef          	jal	4d08 <exit>

0000000000003a52 <sbrkfail>:
{
    3a52:	7175                	addi	sp,sp,-144
    3a54:	e506                	sd	ra,136(sp)
    3a56:	e122                	sd	s0,128(sp)
    3a58:	fca6                	sd	s1,120(sp)
    3a5a:	f8ca                	sd	s2,112(sp)
    3a5c:	f4ce                	sd	s3,104(sp)
    3a5e:	f0d2                	sd	s4,96(sp)
    3a60:	ecd6                	sd	s5,88(sp)
    3a62:	e8da                	sd	s6,80(sp)
    3a64:	e4de                	sd	s7,72(sp)
    3a66:	0900                	addi	s0,sp,144
    3a68:	8baa                	mv	s7,a0
  if(pipe(fds) != 0){
    3a6a:	fa040513          	addi	a0,s0,-96
    3a6e:	2aa010ef          	jal	4d18 <pipe>
    3a72:	e919                	bnez	a0,3a88 <sbrkfail+0x36>
    3a74:	f7040493          	addi	s1,s0,-144
    3a78:	f9840993          	addi	s3,s0,-104
    3a7c:	8926                	mv	s2,s1
    if(pids[i] != -1)
    3a7e:	5a7d                	li	s4,-1
      read(fds[0], &scratch, 1);
    3a80:	f9f40b13          	addi	s6,s0,-97
    3a84:	4a85                	li	s5,1
    3a86:	a0a9                	j	3ad0 <sbrkfail+0x7e>
    printf("%s: pipe() failed\n", s);
    3a88:	85de                	mv	a1,s7
    3a8a:	00002517          	auipc	a0,0x2
    3a8e:	20650513          	addi	a0,a0,518 # 5c90 <malloc+0xac6>
    3a92:	680010ef          	jal	5112 <printf>
    exit(1);
    3a96:	4505                	li	a0,1
    3a98:	270010ef          	jal	4d08 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    3a9c:	2f4010ef          	jal	4d90 <sbrk>
    3aa0:	064007b7          	lui	a5,0x6400
    3aa4:	40a7853b          	subw	a0,a5,a0
    3aa8:	2e8010ef          	jal	4d90 <sbrk>
      write(fds[1], "x", 1);
    3aac:	4605                	li	a2,1
    3aae:	00002597          	auipc	a1,0x2
    3ab2:	8ba58593          	addi	a1,a1,-1862 # 5368 <malloc+0x19e>
    3ab6:	fa442503          	lw	a0,-92(s0)
    3aba:	26e010ef          	jal	4d28 <write>
      for(;;) sleep(1000);
    3abe:	3e800493          	li	s1,1000
    3ac2:	8526                	mv	a0,s1
    3ac4:	2d4010ef          	jal	4d98 <sleep>
    3ac8:	bfed                	j	3ac2 <sbrkfail+0x70>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3aca:	0911                	addi	s2,s2,4
    3acc:	03390063          	beq	s2,s3,3aec <sbrkfail+0x9a>
    if((pids[i] = fork()) == 0){
    3ad0:	230010ef          	jal	4d00 <fork>
    3ad4:	00a92023          	sw	a0,0(s2)
    3ad8:	d171                	beqz	a0,3a9c <sbrkfail+0x4a>
    if(pids[i] != -1)
    3ada:	ff4508e3          	beq	a0,s4,3aca <sbrkfail+0x78>
      read(fds[0], &scratch, 1);
    3ade:	8656                	mv	a2,s5
    3ae0:	85da                	mv	a1,s6
    3ae2:	fa042503          	lw	a0,-96(s0)
    3ae6:	23a010ef          	jal	4d20 <read>
    3aea:	b7c5                	j	3aca <sbrkfail+0x78>
  c = sbrk(PGSIZE);
    3aec:	6505                	lui	a0,0x1
    3aee:	2a2010ef          	jal	4d90 <sbrk>
    3af2:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    3af4:	597d                	li	s2,-1
    3af6:	a021                	j	3afe <sbrkfail+0xac>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3af8:	0491                	addi	s1,s1,4
    3afa:	01348b63          	beq	s1,s3,3b10 <sbrkfail+0xbe>
    if(pids[i] == -1)
    3afe:	4088                	lw	a0,0(s1)
    3b00:	ff250ce3          	beq	a0,s2,3af8 <sbrkfail+0xa6>
    kill(pids[i]);
    3b04:	234010ef          	jal	4d38 <kill>
    wait(0);
    3b08:	4501                	li	a0,0
    3b0a:	206010ef          	jal	4d10 <wait>
    3b0e:	b7ed                	j	3af8 <sbrkfail+0xa6>
  if(c == (char*)0xffffffffffffffffL){
    3b10:	57fd                	li	a5,-1
    3b12:	02fa0f63          	beq	s4,a5,3b50 <sbrkfail+0xfe>
  pid = fork();
    3b16:	1ea010ef          	jal	4d00 <fork>
    3b1a:	84aa                	mv	s1,a0
  if(pid < 0){
    3b1c:	04054463          	bltz	a0,3b64 <sbrkfail+0x112>
  if(pid == 0){
    3b20:	cd21                	beqz	a0,3b78 <sbrkfail+0x126>
  wait(&xstatus);
    3b22:	fac40513          	addi	a0,s0,-84
    3b26:	1ea010ef          	jal	4d10 <wait>
  if(xstatus != -1 && xstatus != 2)
    3b2a:	fac42783          	lw	a5,-84(s0)
    3b2e:	577d                	li	a4,-1
    3b30:	00e78563          	beq	a5,a4,3b3a <sbrkfail+0xe8>
    3b34:	4709                	li	a4,2
    3b36:	06e79f63          	bne	a5,a4,3bb4 <sbrkfail+0x162>
}
    3b3a:	60aa                	ld	ra,136(sp)
    3b3c:	640a                	ld	s0,128(sp)
    3b3e:	74e6                	ld	s1,120(sp)
    3b40:	7946                	ld	s2,112(sp)
    3b42:	79a6                	ld	s3,104(sp)
    3b44:	7a06                	ld	s4,96(sp)
    3b46:	6ae6                	ld	s5,88(sp)
    3b48:	6b46                	ld	s6,80(sp)
    3b4a:	6ba6                	ld	s7,72(sp)
    3b4c:	6149                	addi	sp,sp,144
    3b4e:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    3b50:	85de                	mv	a1,s7
    3b52:	00003517          	auipc	a0,0x3
    3b56:	28e50513          	addi	a0,a0,654 # 6de0 <malloc+0x1c16>
    3b5a:	5b8010ef          	jal	5112 <printf>
    exit(1);
    3b5e:	4505                	li	a0,1
    3b60:	1a8010ef          	jal	4d08 <exit>
    printf("%s: fork failed\n", s);
    3b64:	85de                	mv	a1,s7
    3b66:	00002517          	auipc	a0,0x2
    3b6a:	02250513          	addi	a0,a0,34 # 5b88 <malloc+0x9be>
    3b6e:	5a4010ef          	jal	5112 <printf>
    exit(1);
    3b72:	4505                	li	a0,1
    3b74:	194010ef          	jal	4d08 <exit>
    a = sbrk(0);
    3b78:	4501                	li	a0,0
    3b7a:	216010ef          	jal	4d90 <sbrk>
    3b7e:	892a                	mv	s2,a0
    sbrk(10*BIG);
    3b80:	3e800537          	lui	a0,0x3e800
    3b84:	20c010ef          	jal	4d90 <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    3b88:	87ca                	mv	a5,s2
    3b8a:	3e800737          	lui	a4,0x3e800
    3b8e:	993a                	add	s2,s2,a4
    3b90:	6705                	lui	a4,0x1
      n += *(a+i);
    3b92:	0007c603          	lbu	a2,0(a5) # 6400000 <base+0x63f1388>
    3b96:	9e25                	addw	a2,a2,s1
    3b98:	84b2                	mv	s1,a2
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    3b9a:	97ba                	add	a5,a5,a4
    3b9c:	fef91be3          	bne	s2,a5,3b92 <sbrkfail+0x140>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    3ba0:	85de                	mv	a1,s7
    3ba2:	00003517          	auipc	a0,0x3
    3ba6:	25e50513          	addi	a0,a0,606 # 6e00 <malloc+0x1c36>
    3baa:	568010ef          	jal	5112 <printf>
    exit(1);
    3bae:	4505                	li	a0,1
    3bb0:	158010ef          	jal	4d08 <exit>
    exit(1);
    3bb4:	4505                	li	a0,1
    3bb6:	152010ef          	jal	4d08 <exit>

0000000000003bba <mem>:
{
    3bba:	7139                	addi	sp,sp,-64
    3bbc:	fc06                	sd	ra,56(sp)
    3bbe:	f822                	sd	s0,48(sp)
    3bc0:	f426                	sd	s1,40(sp)
    3bc2:	f04a                	sd	s2,32(sp)
    3bc4:	ec4e                	sd	s3,24(sp)
    3bc6:	0080                	addi	s0,sp,64
    3bc8:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    3bca:	136010ef          	jal	4d00 <fork>
    m1 = 0;
    3bce:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    3bd0:	6909                	lui	s2,0x2
    3bd2:	71190913          	addi	s2,s2,1809 # 2711 <execout+0x1f>
  if((pid = fork()) == 0){
    3bd6:	cd11                	beqz	a0,3bf2 <mem+0x38>
    wait(&xstatus);
    3bd8:	fcc40513          	addi	a0,s0,-52
    3bdc:	134010ef          	jal	4d10 <wait>
    if(xstatus == -1){
    3be0:	fcc42503          	lw	a0,-52(s0)
    3be4:	57fd                	li	a5,-1
    3be6:	04f50363          	beq	a0,a5,3c2c <mem+0x72>
    exit(xstatus);
    3bea:	11e010ef          	jal	4d08 <exit>
      *(char**)m2 = m1;
    3bee:	e104                	sd	s1,0(a0)
      m1 = m2;
    3bf0:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    3bf2:	854a                	mv	a0,s2
    3bf4:	5d6010ef          	jal	51ca <malloc>
    3bf8:	f97d                	bnez	a0,3bee <mem+0x34>
    while(m1){
    3bfa:	c491                	beqz	s1,3c06 <mem+0x4c>
      m2 = *(char**)m1;
    3bfc:	8526                	mv	a0,s1
    3bfe:	6084                	ld	s1,0(s1)
      free(m1);
    3c00:	544010ef          	jal	5144 <free>
    while(m1){
    3c04:	fce5                	bnez	s1,3bfc <mem+0x42>
    m1 = malloc(1024*20);
    3c06:	6515                	lui	a0,0x5
    3c08:	5c2010ef          	jal	51ca <malloc>
    if(m1 == 0){
    3c0c:	c511                	beqz	a0,3c18 <mem+0x5e>
    free(m1);
    3c0e:	536010ef          	jal	5144 <free>
    exit(0);
    3c12:	4501                	li	a0,0
    3c14:	0f4010ef          	jal	4d08 <exit>
      printf("%s: couldn't allocate mem?!!\n", s);
    3c18:	85ce                	mv	a1,s3
    3c1a:	00003517          	auipc	a0,0x3
    3c1e:	21650513          	addi	a0,a0,534 # 6e30 <malloc+0x1c66>
    3c22:	4f0010ef          	jal	5112 <printf>
      exit(1);
    3c26:	4505                	li	a0,1
    3c28:	0e0010ef          	jal	4d08 <exit>
      exit(0);
    3c2c:	4501                	li	a0,0
    3c2e:	0da010ef          	jal	4d08 <exit>

0000000000003c32 <sharedfd>:
{
    3c32:	7119                	addi	sp,sp,-128
    3c34:	fc86                	sd	ra,120(sp)
    3c36:	f8a2                	sd	s0,112(sp)
    3c38:	e0da                	sd	s6,64(sp)
    3c3a:	0100                	addi	s0,sp,128
    3c3c:	8b2a                	mv	s6,a0
  unlink("sharedfd");
    3c3e:	00003517          	auipc	a0,0x3
    3c42:	21250513          	addi	a0,a0,530 # 6e50 <malloc+0x1c86>
    3c46:	112010ef          	jal	4d58 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    3c4a:	20200593          	li	a1,514
    3c4e:	00003517          	auipc	a0,0x3
    3c52:	20250513          	addi	a0,a0,514 # 6e50 <malloc+0x1c86>
    3c56:	0f2010ef          	jal	4d48 <open>
  if(fd < 0){
    3c5a:	04054b63          	bltz	a0,3cb0 <sharedfd+0x7e>
    3c5e:	f4a6                	sd	s1,104(sp)
    3c60:	f0ca                	sd	s2,96(sp)
    3c62:	ecce                	sd	s3,88(sp)
    3c64:	e8d2                	sd	s4,80(sp)
    3c66:	e4d6                	sd	s5,72(sp)
    3c68:	89aa                	mv	s3,a0
  pid = fork();
    3c6a:	096010ef          	jal	4d00 <fork>
    3c6e:	8aaa                	mv	s5,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    3c70:	07000593          	li	a1,112
    3c74:	e119                	bnez	a0,3c7a <sharedfd+0x48>
    3c76:	06300593          	li	a1,99
    3c7a:	4629                	li	a2,10
    3c7c:	f9040513          	addi	a0,s0,-112
    3c80:	67b000ef          	jal	4afa <memset>
    3c84:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    3c88:	f9040a13          	addi	s4,s0,-112
    3c8c:	4929                	li	s2,10
    3c8e:	864a                	mv	a2,s2
    3c90:	85d2                	mv	a1,s4
    3c92:	854e                	mv	a0,s3
    3c94:	094010ef          	jal	4d28 <write>
    3c98:	03251e63          	bne	a0,s2,3cd4 <sharedfd+0xa2>
  for(i = 0; i < N; i++){
    3c9c:	34fd                	addiw	s1,s1,-1
    3c9e:	f8e5                	bnez	s1,3c8e <sharedfd+0x5c>
  if(pid == 0) {
    3ca0:	040a9763          	bnez	s5,3cee <sharedfd+0xbc>
    3ca4:	fc5e                	sd	s7,56(sp)
    3ca6:	f862                	sd	s8,48(sp)
    3ca8:	f466                	sd	s9,40(sp)
    exit(0);
    3caa:	4501                	li	a0,0
    3cac:	05c010ef          	jal	4d08 <exit>
    3cb0:	f4a6                	sd	s1,104(sp)
    3cb2:	f0ca                	sd	s2,96(sp)
    3cb4:	ecce                	sd	s3,88(sp)
    3cb6:	e8d2                	sd	s4,80(sp)
    3cb8:	e4d6                	sd	s5,72(sp)
    3cba:	fc5e                	sd	s7,56(sp)
    3cbc:	f862                	sd	s8,48(sp)
    3cbe:	f466                	sd	s9,40(sp)
    printf("%s: cannot open sharedfd for writing", s);
    3cc0:	85da                	mv	a1,s6
    3cc2:	00003517          	auipc	a0,0x3
    3cc6:	19e50513          	addi	a0,a0,414 # 6e60 <malloc+0x1c96>
    3cca:	448010ef          	jal	5112 <printf>
    exit(1);
    3cce:	4505                	li	a0,1
    3cd0:	038010ef          	jal	4d08 <exit>
    3cd4:	fc5e                	sd	s7,56(sp)
    3cd6:	f862                	sd	s8,48(sp)
    3cd8:	f466                	sd	s9,40(sp)
      printf("%s: write sharedfd failed\n", s);
    3cda:	85da                	mv	a1,s6
    3cdc:	00003517          	auipc	a0,0x3
    3ce0:	1ac50513          	addi	a0,a0,428 # 6e88 <malloc+0x1cbe>
    3ce4:	42e010ef          	jal	5112 <printf>
      exit(1);
    3ce8:	4505                	li	a0,1
    3cea:	01e010ef          	jal	4d08 <exit>
    wait(&xstatus);
    3cee:	f8c40513          	addi	a0,s0,-116
    3cf2:	01e010ef          	jal	4d10 <wait>
    if(xstatus != 0)
    3cf6:	f8c42a03          	lw	s4,-116(s0)
    3cfa:	000a0863          	beqz	s4,3d0a <sharedfd+0xd8>
    3cfe:	fc5e                	sd	s7,56(sp)
    3d00:	f862                	sd	s8,48(sp)
    3d02:	f466                	sd	s9,40(sp)
      exit(xstatus);
    3d04:	8552                	mv	a0,s4
    3d06:	002010ef          	jal	4d08 <exit>
    3d0a:	fc5e                	sd	s7,56(sp)
  close(fd);
    3d0c:	854e                	mv	a0,s3
    3d0e:	022010ef          	jal	4d30 <close>
  fd = open("sharedfd", 0);
    3d12:	4581                	li	a1,0
    3d14:	00003517          	auipc	a0,0x3
    3d18:	13c50513          	addi	a0,a0,316 # 6e50 <malloc+0x1c86>
    3d1c:	02c010ef          	jal	4d48 <open>
    3d20:	8baa                	mv	s7,a0
  nc = np = 0;
    3d22:	89d2                	mv	s3,s4
  if(fd < 0){
    3d24:	02054763          	bltz	a0,3d52 <sharedfd+0x120>
    3d28:	f862                	sd	s8,48(sp)
    3d2a:	f466                	sd	s9,40(sp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
    3d2c:	f9040c93          	addi	s9,s0,-112
    3d30:	4c29                	li	s8,10
    3d32:	f9a40913          	addi	s2,s0,-102
      if(buf[i] == 'c')
    3d36:	06300493          	li	s1,99
      if(buf[i] == 'p')
    3d3a:	07000a93          	li	s5,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    3d3e:	8662                	mv	a2,s8
    3d40:	85e6                	mv	a1,s9
    3d42:	855e                	mv	a0,s7
    3d44:	7dd000ef          	jal	4d20 <read>
    3d48:	02a05d63          	blez	a0,3d82 <sharedfd+0x150>
    3d4c:	f9040793          	addi	a5,s0,-112
    3d50:	a00d                	j	3d72 <sharedfd+0x140>
    3d52:	f862                	sd	s8,48(sp)
    3d54:	f466                	sd	s9,40(sp)
    printf("%s: cannot open sharedfd for reading\n", s);
    3d56:	85da                	mv	a1,s6
    3d58:	00003517          	auipc	a0,0x3
    3d5c:	15050513          	addi	a0,a0,336 # 6ea8 <malloc+0x1cde>
    3d60:	3b2010ef          	jal	5112 <printf>
    exit(1);
    3d64:	4505                	li	a0,1
    3d66:	7a3000ef          	jal	4d08 <exit>
        nc++;
    3d6a:	2a05                	addiw	s4,s4,1
    for(i = 0; i < sizeof(buf); i++){
    3d6c:	0785                	addi	a5,a5,1
    3d6e:	fd2788e3          	beq	a5,s2,3d3e <sharedfd+0x10c>
      if(buf[i] == 'c')
    3d72:	0007c703          	lbu	a4,0(a5)
    3d76:	fe970ae3          	beq	a4,s1,3d6a <sharedfd+0x138>
      if(buf[i] == 'p')
    3d7a:	ff5719e3          	bne	a4,s5,3d6c <sharedfd+0x13a>
        np++;
    3d7e:	2985                	addiw	s3,s3,1
    3d80:	b7f5                	j	3d6c <sharedfd+0x13a>
  close(fd);
    3d82:	855e                	mv	a0,s7
    3d84:	7ad000ef          	jal	4d30 <close>
  unlink("sharedfd");
    3d88:	00003517          	auipc	a0,0x3
    3d8c:	0c850513          	addi	a0,a0,200 # 6e50 <malloc+0x1c86>
    3d90:	7c9000ef          	jal	4d58 <unlink>
  if(nc == N*SZ && np == N*SZ){
    3d94:	6789                	lui	a5,0x2
    3d96:	71078793          	addi	a5,a5,1808 # 2710 <execout+0x1e>
    3d9a:	00fa1763          	bne	s4,a5,3da8 <sharedfd+0x176>
    3d9e:	6789                	lui	a5,0x2
    3da0:	71078793          	addi	a5,a5,1808 # 2710 <execout+0x1e>
    3da4:	00f98c63          	beq	s3,a5,3dbc <sharedfd+0x18a>
    printf("%s: nc/np test fails\n", s);
    3da8:	85da                	mv	a1,s6
    3daa:	00003517          	auipc	a0,0x3
    3dae:	12650513          	addi	a0,a0,294 # 6ed0 <malloc+0x1d06>
    3db2:	360010ef          	jal	5112 <printf>
    exit(1);
    3db6:	4505                	li	a0,1
    3db8:	751000ef          	jal	4d08 <exit>
    exit(0);
    3dbc:	4501                	li	a0,0
    3dbe:	74b000ef          	jal	4d08 <exit>

0000000000003dc2 <fourfiles>:
{
    3dc2:	7135                	addi	sp,sp,-160
    3dc4:	ed06                	sd	ra,152(sp)
    3dc6:	e922                	sd	s0,144(sp)
    3dc8:	e526                	sd	s1,136(sp)
    3dca:	e14a                	sd	s2,128(sp)
    3dcc:	fcce                	sd	s3,120(sp)
    3dce:	f8d2                	sd	s4,112(sp)
    3dd0:	f4d6                	sd	s5,104(sp)
    3dd2:	f0da                	sd	s6,96(sp)
    3dd4:	ecde                	sd	s7,88(sp)
    3dd6:	e8e2                	sd	s8,80(sp)
    3dd8:	e4e6                	sd	s9,72(sp)
    3dda:	e0ea                	sd	s10,64(sp)
    3ddc:	fc6e                	sd	s11,56(sp)
    3dde:	1100                	addi	s0,sp,160
    3de0:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    3de2:	00003797          	auipc	a5,0x3
    3de6:	10678793          	addi	a5,a5,262 # 6ee8 <malloc+0x1d1e>
    3dea:	f6f43823          	sd	a5,-144(s0)
    3dee:	00003797          	auipc	a5,0x3
    3df2:	10278793          	addi	a5,a5,258 # 6ef0 <malloc+0x1d26>
    3df6:	f6f43c23          	sd	a5,-136(s0)
    3dfa:	00003797          	auipc	a5,0x3
    3dfe:	0fe78793          	addi	a5,a5,254 # 6ef8 <malloc+0x1d2e>
    3e02:	f8f43023          	sd	a5,-128(s0)
    3e06:	00003797          	auipc	a5,0x3
    3e0a:	0fa78793          	addi	a5,a5,250 # 6f00 <malloc+0x1d36>
    3e0e:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    3e12:	f7040b93          	addi	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    3e16:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    3e18:	4481                	li	s1,0
    3e1a:	4a11                	li	s4,4
    fname = names[pi];
    3e1c:	00093983          	ld	s3,0(s2)
    unlink(fname);
    3e20:	854e                	mv	a0,s3
    3e22:	737000ef          	jal	4d58 <unlink>
    pid = fork();
    3e26:	6db000ef          	jal	4d00 <fork>
    if(pid < 0){
    3e2a:	04054063          	bltz	a0,3e6a <fourfiles+0xa8>
    if(pid == 0){
    3e2e:	c921                	beqz	a0,3e7e <fourfiles+0xbc>
  for(pi = 0; pi < NCHILD; pi++){
    3e30:	2485                	addiw	s1,s1,1
    3e32:	0921                	addi	s2,s2,8
    3e34:	ff4494e3          	bne	s1,s4,3e1c <fourfiles+0x5a>
    3e38:	4491                	li	s1,4
    wait(&xstatus);
    3e3a:	f6c40913          	addi	s2,s0,-148
    3e3e:	854a                	mv	a0,s2
    3e40:	6d1000ef          	jal	4d10 <wait>
    if(xstatus != 0)
    3e44:	f6c42b03          	lw	s6,-148(s0)
    3e48:	0a0b1463          	bnez	s6,3ef0 <fourfiles+0x12e>
  for(pi = 0; pi < NCHILD; pi++){
    3e4c:	34fd                	addiw	s1,s1,-1
    3e4e:	f8e5                	bnez	s1,3e3e <fourfiles+0x7c>
    3e50:	03000493          	li	s1,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3e54:	6a8d                	lui	s5,0x3
    3e56:	00008a17          	auipc	s4,0x8
    3e5a:	e22a0a13          	addi	s4,s4,-478 # bc78 <buf>
    if(total != N*SZ){
    3e5e:	6d05                	lui	s10,0x1
    3e60:	770d0d13          	addi	s10,s10,1904 # 1770 <exitwait+0x8c>
  for(i = 0; i < NCHILD; i++){
    3e64:	03400d93          	li	s11,52
    3e68:	a86d                	j	3f22 <fourfiles+0x160>
      printf("%s: fork failed\n", s);
    3e6a:	85e6                	mv	a1,s9
    3e6c:	00002517          	auipc	a0,0x2
    3e70:	d1c50513          	addi	a0,a0,-740 # 5b88 <malloc+0x9be>
    3e74:	29e010ef          	jal	5112 <printf>
      exit(1);
    3e78:	4505                	li	a0,1
    3e7a:	68f000ef          	jal	4d08 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    3e7e:	20200593          	li	a1,514
    3e82:	854e                	mv	a0,s3
    3e84:	6c5000ef          	jal	4d48 <open>
    3e88:	892a                	mv	s2,a0
      if(fd < 0){
    3e8a:	04054063          	bltz	a0,3eca <fourfiles+0x108>
      memset(buf, '0'+pi, SZ);
    3e8e:	1f400613          	li	a2,500
    3e92:	0304859b          	addiw	a1,s1,48
    3e96:	00008517          	auipc	a0,0x8
    3e9a:	de250513          	addi	a0,a0,-542 # bc78 <buf>
    3e9e:	45d000ef          	jal	4afa <memset>
    3ea2:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    3ea4:	1f400993          	li	s3,500
    3ea8:	00008a17          	auipc	s4,0x8
    3eac:	dd0a0a13          	addi	s4,s4,-560 # bc78 <buf>
    3eb0:	864e                	mv	a2,s3
    3eb2:	85d2                	mv	a1,s4
    3eb4:	854a                	mv	a0,s2
    3eb6:	673000ef          	jal	4d28 <write>
    3eba:	85aa                	mv	a1,a0
    3ebc:	03351163          	bne	a0,s3,3ede <fourfiles+0x11c>
      for(i = 0; i < N; i++){
    3ec0:	34fd                	addiw	s1,s1,-1
    3ec2:	f4fd                	bnez	s1,3eb0 <fourfiles+0xee>
      exit(0);
    3ec4:	4501                	li	a0,0
    3ec6:	643000ef          	jal	4d08 <exit>
        printf("%s: create failed\n", s);
    3eca:	85e6                	mv	a1,s9
    3ecc:	00002517          	auipc	a0,0x2
    3ed0:	d5450513          	addi	a0,a0,-684 # 5c20 <malloc+0xa56>
    3ed4:	23e010ef          	jal	5112 <printf>
        exit(1);
    3ed8:	4505                	li	a0,1
    3eda:	62f000ef          	jal	4d08 <exit>
          printf("write failed %d\n", n);
    3ede:	00003517          	auipc	a0,0x3
    3ee2:	02a50513          	addi	a0,a0,42 # 6f08 <malloc+0x1d3e>
    3ee6:	22c010ef          	jal	5112 <printf>
          exit(1);
    3eea:	4505                	li	a0,1
    3eec:	61d000ef          	jal	4d08 <exit>
      exit(xstatus);
    3ef0:	855a                	mv	a0,s6
    3ef2:	617000ef          	jal	4d08 <exit>
          printf("%s: wrong char\n", s);
    3ef6:	85e6                	mv	a1,s9
    3ef8:	00003517          	auipc	a0,0x3
    3efc:	02850513          	addi	a0,a0,40 # 6f20 <malloc+0x1d56>
    3f00:	212010ef          	jal	5112 <printf>
          exit(1);
    3f04:	4505                	li	a0,1
    3f06:	603000ef          	jal	4d08 <exit>
    close(fd);
    3f0a:	854e                	mv	a0,s3
    3f0c:	625000ef          	jal	4d30 <close>
    if(total != N*SZ){
    3f10:	05a91863          	bne	s2,s10,3f60 <fourfiles+0x19e>
    unlink(fname);
    3f14:	8562                	mv	a0,s8
    3f16:	643000ef          	jal	4d58 <unlink>
  for(i = 0; i < NCHILD; i++){
    3f1a:	0ba1                	addi	s7,s7,8
    3f1c:	2485                	addiw	s1,s1,1
    3f1e:	05b48b63          	beq	s1,s11,3f74 <fourfiles+0x1b2>
    fname = names[i];
    3f22:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    3f26:	4581                	li	a1,0
    3f28:	8562                	mv	a0,s8
    3f2a:	61f000ef          	jal	4d48 <open>
    3f2e:	89aa                	mv	s3,a0
    total = 0;
    3f30:	895a                	mv	s2,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3f32:	8656                	mv	a2,s5
    3f34:	85d2                	mv	a1,s4
    3f36:	854e                	mv	a0,s3
    3f38:	5e9000ef          	jal	4d20 <read>
    3f3c:	fca057e3          	blez	a0,3f0a <fourfiles+0x148>
    3f40:	00008797          	auipc	a5,0x8
    3f44:	d3878793          	addi	a5,a5,-712 # bc78 <buf>
    3f48:	00f506b3          	add	a3,a0,a5
        if(buf[j] != '0'+i){
    3f4c:	0007c703          	lbu	a4,0(a5)
    3f50:	fa9713e3          	bne	a4,s1,3ef6 <fourfiles+0x134>
      for(j = 0; j < n; j++){
    3f54:	0785                	addi	a5,a5,1
    3f56:	fed79be3          	bne	a5,a3,3f4c <fourfiles+0x18a>
      total += n;
    3f5a:	00a9093b          	addw	s2,s2,a0
    3f5e:	bfd1                	j	3f32 <fourfiles+0x170>
      printf("wrong length %d\n", total);
    3f60:	85ca                	mv	a1,s2
    3f62:	00003517          	auipc	a0,0x3
    3f66:	fce50513          	addi	a0,a0,-50 # 6f30 <malloc+0x1d66>
    3f6a:	1a8010ef          	jal	5112 <printf>
      exit(1);
    3f6e:	4505                	li	a0,1
    3f70:	599000ef          	jal	4d08 <exit>
}
    3f74:	60ea                	ld	ra,152(sp)
    3f76:	644a                	ld	s0,144(sp)
    3f78:	64aa                	ld	s1,136(sp)
    3f7a:	690a                	ld	s2,128(sp)
    3f7c:	79e6                	ld	s3,120(sp)
    3f7e:	7a46                	ld	s4,112(sp)
    3f80:	7aa6                	ld	s5,104(sp)
    3f82:	7b06                	ld	s6,96(sp)
    3f84:	6be6                	ld	s7,88(sp)
    3f86:	6c46                	ld	s8,80(sp)
    3f88:	6ca6                	ld	s9,72(sp)
    3f8a:	6d06                	ld	s10,64(sp)
    3f8c:	7de2                	ld	s11,56(sp)
    3f8e:	610d                	addi	sp,sp,160
    3f90:	8082                	ret

0000000000003f92 <concreate>:
{
    3f92:	7171                	addi	sp,sp,-176
    3f94:	f506                	sd	ra,168(sp)
    3f96:	f122                	sd	s0,160(sp)
    3f98:	ed26                	sd	s1,152(sp)
    3f9a:	e94a                	sd	s2,144(sp)
    3f9c:	e54e                	sd	s3,136(sp)
    3f9e:	e152                	sd	s4,128(sp)
    3fa0:	fcd6                	sd	s5,120(sp)
    3fa2:	f8da                	sd	s6,112(sp)
    3fa4:	f4de                	sd	s7,104(sp)
    3fa6:	f0e2                	sd	s8,96(sp)
    3fa8:	ece6                	sd	s9,88(sp)
    3faa:	e8ea                	sd	s10,80(sp)
    3fac:	1900                	addi	s0,sp,176
    3fae:	8baa                	mv	s7,a0
  file[0] = 'C';
    3fb0:	04300793          	li	a5,67
    3fb4:	f8f40c23          	sb	a5,-104(s0)
  file[2] = '\0';
    3fb8:	f8040d23          	sb	zero,-102(s0)
  for(i = 0; i < N; i++){
    3fbc:	4901                	li	s2,0
    unlink(file);
    3fbe:	f9840993          	addi	s3,s0,-104
    if(pid && (i % 3) == 1){
    3fc2:	55555b37          	lui	s6,0x55555
    3fc6:	556b0b13          	addi	s6,s6,1366 # 55555556 <base+0x555468de>
    3fca:	4c05                	li	s8,1
      fd = open(file, O_CREATE | O_RDWR);
    3fcc:	20200c93          	li	s9,514
      link("C0", file);
    3fd0:	00003d17          	auipc	s10,0x3
    3fd4:	f78d0d13          	addi	s10,s10,-136 # 6f48 <malloc+0x1d7e>
      wait(&xstatus);
    3fd8:	f5c40a93          	addi	s5,s0,-164
  for(i = 0; i < N; i++){
    3fdc:	02800a13          	li	s4,40
    3fe0:	ac2d                	j	421a <concreate+0x288>
      link("C0", file);
    3fe2:	85ce                	mv	a1,s3
    3fe4:	856a                	mv	a0,s10
    3fe6:	583000ef          	jal	4d68 <link>
    if(pid == 0) {
    3fea:	ac31                	j	4206 <concreate+0x274>
    } else if(pid == 0 && (i % 5) == 1){
    3fec:	666667b7          	lui	a5,0x66666
    3ff0:	66778793          	addi	a5,a5,1639 # 66666667 <base+0x666579ef>
    3ff4:	02f907b3          	mul	a5,s2,a5
    3ff8:	9785                	srai	a5,a5,0x21
    3ffa:	41f9571b          	sraiw	a4,s2,0x1f
    3ffe:	9f99                	subw	a5,a5,a4
    4000:	0027971b          	slliw	a4,a5,0x2
    4004:	9fb9                	addw	a5,a5,a4
    4006:	40f9093b          	subw	s2,s2,a5
    400a:	4785                	li	a5,1
    400c:	02f90563          	beq	s2,a5,4036 <concreate+0xa4>
      fd = open(file, O_CREATE | O_RDWR);
    4010:	20200593          	li	a1,514
    4014:	f9840513          	addi	a0,s0,-104
    4018:	531000ef          	jal	4d48 <open>
      if(fd < 0){
    401c:	1e055063          	bgez	a0,41fc <concreate+0x26a>
        printf("concreate create %s failed\n", file);
    4020:	f9840593          	addi	a1,s0,-104
    4024:	00003517          	auipc	a0,0x3
    4028:	f2c50513          	addi	a0,a0,-212 # 6f50 <malloc+0x1d86>
    402c:	0e6010ef          	jal	5112 <printf>
        exit(1);
    4030:	4505                	li	a0,1
    4032:	4d7000ef          	jal	4d08 <exit>
      link("C0", file);
    4036:	f9840593          	addi	a1,s0,-104
    403a:	00003517          	auipc	a0,0x3
    403e:	f0e50513          	addi	a0,a0,-242 # 6f48 <malloc+0x1d7e>
    4042:	527000ef          	jal	4d68 <link>
      exit(0);
    4046:	4501                	li	a0,0
    4048:	4c1000ef          	jal	4d08 <exit>
        exit(1);
    404c:	4505                	li	a0,1
    404e:	4bb000ef          	jal	4d08 <exit>
  memset(fa, 0, sizeof(fa));
    4052:	02800613          	li	a2,40
    4056:	4581                	li	a1,0
    4058:	f7040513          	addi	a0,s0,-144
    405c:	29f000ef          	jal	4afa <memset>
  fd = open(".", 0);
    4060:	4581                	li	a1,0
    4062:	00002517          	auipc	a0,0x2
    4066:	97e50513          	addi	a0,a0,-1666 # 59e0 <malloc+0x816>
    406a:	4df000ef          	jal	4d48 <open>
    406e:	892a                	mv	s2,a0
  n = 0;
    4070:	8b26                	mv	s6,s1
  while(read(fd, &de, sizeof(de)) > 0){
    4072:	f6040a13          	addi	s4,s0,-160
    4076:	49c1                	li	s3,16
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4078:	04300a93          	li	s5,67
      if(i < 0 || i >= sizeof(fa)){
    407c:	02700c13          	li	s8,39
      fa[i] = 1;
    4080:	4c85                	li	s9,1
  while(read(fd, &de, sizeof(de)) > 0){
    4082:	864e                	mv	a2,s3
    4084:	85d2                	mv	a1,s4
    4086:	854a                	mv	a0,s2
    4088:	499000ef          	jal	4d20 <read>
    408c:	06a05763          	blez	a0,40fa <concreate+0x168>
    if(de.inum == 0)
    4090:	f6045783          	lhu	a5,-160(s0)
    4094:	d7fd                	beqz	a5,4082 <concreate+0xf0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4096:	f6244783          	lbu	a5,-158(s0)
    409a:	ff5794e3          	bne	a5,s5,4082 <concreate+0xf0>
    409e:	f6444783          	lbu	a5,-156(s0)
    40a2:	f3e5                	bnez	a5,4082 <concreate+0xf0>
      i = de.name[1] - '0';
    40a4:	f6344783          	lbu	a5,-157(s0)
    40a8:	fd07879b          	addiw	a5,a5,-48
      if(i < 0 || i >= sizeof(fa)){
    40ac:	00fc6f63          	bltu	s8,a5,40ca <concreate+0x138>
      if(fa[i]){
    40b0:	fa078713          	addi	a4,a5,-96
    40b4:	9722                	add	a4,a4,s0
    40b6:	fd074703          	lbu	a4,-48(a4) # fd0 <bigdir+0xd6>
    40ba:	e705                	bnez	a4,40e2 <concreate+0x150>
      fa[i] = 1;
    40bc:	fa078793          	addi	a5,a5,-96
    40c0:	97a2                	add	a5,a5,s0
    40c2:	fd978823          	sb	s9,-48(a5)
      n++;
    40c6:	2b05                	addiw	s6,s6,1
    40c8:	bf6d                	j	4082 <concreate+0xf0>
        printf("%s: concreate weird file %s\n", s, de.name);
    40ca:	f6240613          	addi	a2,s0,-158
    40ce:	85de                	mv	a1,s7
    40d0:	00003517          	auipc	a0,0x3
    40d4:	ea050513          	addi	a0,a0,-352 # 6f70 <malloc+0x1da6>
    40d8:	03a010ef          	jal	5112 <printf>
        exit(1);
    40dc:	4505                	li	a0,1
    40de:	42b000ef          	jal	4d08 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    40e2:	f6240613          	addi	a2,s0,-158
    40e6:	85de                	mv	a1,s7
    40e8:	00003517          	auipc	a0,0x3
    40ec:	ea850513          	addi	a0,a0,-344 # 6f90 <malloc+0x1dc6>
    40f0:	022010ef          	jal	5112 <printf>
        exit(1);
    40f4:	4505                	li	a0,1
    40f6:	413000ef          	jal	4d08 <exit>
  close(fd);
    40fa:	854a                	mv	a0,s2
    40fc:	435000ef          	jal	4d30 <close>
  if(n != N){
    4100:	02800793          	li	a5,40
    4104:	00fb1b63          	bne	s6,a5,411a <concreate+0x188>
    if(((i % 3) == 0 && pid == 0) ||
    4108:	55555a37          	lui	s4,0x55555
    410c:	556a0a13          	addi	s4,s4,1366 # 55555556 <base+0x555468de>
      close(open(file, 0));
    4110:	f9840993          	addi	s3,s0,-104
    if(((i % 3) == 0 && pid == 0) ||
    4114:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    4116:	8abe                	mv	s5,a5
    4118:	a049                	j	419a <concreate+0x208>
    printf("%s: concreate not enough files in directory listing\n", s);
    411a:	85de                	mv	a1,s7
    411c:	00003517          	auipc	a0,0x3
    4120:	e9c50513          	addi	a0,a0,-356 # 6fb8 <malloc+0x1dee>
    4124:	7ef000ef          	jal	5112 <printf>
    exit(1);
    4128:	4505                	li	a0,1
    412a:	3df000ef          	jal	4d08 <exit>
      printf("%s: fork failed\n", s);
    412e:	85de                	mv	a1,s7
    4130:	00002517          	auipc	a0,0x2
    4134:	a5850513          	addi	a0,a0,-1448 # 5b88 <malloc+0x9be>
    4138:	7db000ef          	jal	5112 <printf>
      exit(1);
    413c:	4505                	li	a0,1
    413e:	3cb000ef          	jal	4d08 <exit>
      close(open(file, 0));
    4142:	4581                	li	a1,0
    4144:	854e                	mv	a0,s3
    4146:	403000ef          	jal	4d48 <open>
    414a:	3e7000ef          	jal	4d30 <close>
      close(open(file, 0));
    414e:	4581                	li	a1,0
    4150:	854e                	mv	a0,s3
    4152:	3f7000ef          	jal	4d48 <open>
    4156:	3db000ef          	jal	4d30 <close>
      close(open(file, 0));
    415a:	4581                	li	a1,0
    415c:	854e                	mv	a0,s3
    415e:	3eb000ef          	jal	4d48 <open>
    4162:	3cf000ef          	jal	4d30 <close>
      close(open(file, 0));
    4166:	4581                	li	a1,0
    4168:	854e                	mv	a0,s3
    416a:	3df000ef          	jal	4d48 <open>
    416e:	3c3000ef          	jal	4d30 <close>
      close(open(file, 0));
    4172:	4581                	li	a1,0
    4174:	854e                	mv	a0,s3
    4176:	3d3000ef          	jal	4d48 <open>
    417a:	3b7000ef          	jal	4d30 <close>
      close(open(file, 0));
    417e:	4581                	li	a1,0
    4180:	854e                	mv	a0,s3
    4182:	3c7000ef          	jal	4d48 <open>
    4186:	3ab000ef          	jal	4d30 <close>
    if(pid == 0)
    418a:	06090663          	beqz	s2,41f6 <concreate+0x264>
      wait(0);
    418e:	4501                	li	a0,0
    4190:	381000ef          	jal	4d10 <wait>
  for(i = 0; i < N; i++){
    4194:	2485                	addiw	s1,s1,1
    4196:	0d548163          	beq	s1,s5,4258 <concreate+0x2c6>
    file[1] = '0' + i;
    419a:	0304879b          	addiw	a5,s1,48
    419e:	f8f40ca3          	sb	a5,-103(s0)
    pid = fork();
    41a2:	35f000ef          	jal	4d00 <fork>
    41a6:	892a                	mv	s2,a0
    if(pid < 0){
    41a8:	f80543e3          	bltz	a0,412e <concreate+0x19c>
    if(((i % 3) == 0 && pid == 0) ||
    41ac:	03448733          	mul	a4,s1,s4
    41b0:	9301                	srli	a4,a4,0x20
    41b2:	41f4d79b          	sraiw	a5,s1,0x1f
    41b6:	9f1d                	subw	a4,a4,a5
    41b8:	0017179b          	slliw	a5,a4,0x1
    41bc:	9fb9                	addw	a5,a5,a4
    41be:	40f487bb          	subw	a5,s1,a5
    41c2:	873e                	mv	a4,a5
    41c4:	8fc9                	or	a5,a5,a0
    41c6:	2781                	sext.w	a5,a5
    41c8:	dfad                	beqz	a5,4142 <concreate+0x1b0>
    41ca:	01671363          	bne	a4,s6,41d0 <concreate+0x23e>
       ((i % 3) == 1 && pid != 0)){
    41ce:	f935                	bnez	a0,4142 <concreate+0x1b0>
      unlink(file);
    41d0:	854e                	mv	a0,s3
    41d2:	387000ef          	jal	4d58 <unlink>
      unlink(file);
    41d6:	854e                	mv	a0,s3
    41d8:	381000ef          	jal	4d58 <unlink>
      unlink(file);
    41dc:	854e                	mv	a0,s3
    41de:	37b000ef          	jal	4d58 <unlink>
      unlink(file);
    41e2:	854e                	mv	a0,s3
    41e4:	375000ef          	jal	4d58 <unlink>
      unlink(file);
    41e8:	854e                	mv	a0,s3
    41ea:	36f000ef          	jal	4d58 <unlink>
      unlink(file);
    41ee:	854e                	mv	a0,s3
    41f0:	369000ef          	jal	4d58 <unlink>
    41f4:	bf59                	j	418a <concreate+0x1f8>
      exit(0);
    41f6:	4501                	li	a0,0
    41f8:	311000ef          	jal	4d08 <exit>
      close(fd);
    41fc:	335000ef          	jal	4d30 <close>
    if(pid == 0) {
    4200:	b599                	j	4046 <concreate+0xb4>
      close(fd);
    4202:	32f000ef          	jal	4d30 <close>
      wait(&xstatus);
    4206:	8556                	mv	a0,s5
    4208:	309000ef          	jal	4d10 <wait>
      if(xstatus != 0)
    420c:	f5c42483          	lw	s1,-164(s0)
    4210:	e2049ee3          	bnez	s1,404c <concreate+0xba>
  for(i = 0; i < N; i++){
    4214:	2905                	addiw	s2,s2,1
    4216:	e3490ee3          	beq	s2,s4,4052 <concreate+0xc0>
    file[1] = '0' + i;
    421a:	0309079b          	addiw	a5,s2,48
    421e:	f8f40ca3          	sb	a5,-103(s0)
    unlink(file);
    4222:	854e                	mv	a0,s3
    4224:	335000ef          	jal	4d58 <unlink>
    pid = fork();
    4228:	2d9000ef          	jal	4d00 <fork>
    if(pid && (i % 3) == 1){
    422c:	dc0500e3          	beqz	a0,3fec <concreate+0x5a>
    4230:	036907b3          	mul	a5,s2,s6
    4234:	9381                	srli	a5,a5,0x20
    4236:	41f9571b          	sraiw	a4,s2,0x1f
    423a:	9f99                	subw	a5,a5,a4
    423c:	0017971b          	slliw	a4,a5,0x1
    4240:	9fb9                	addw	a5,a5,a4
    4242:	40f907bb          	subw	a5,s2,a5
    4246:	d9878ee3          	beq	a5,s8,3fe2 <concreate+0x50>
      fd = open(file, O_CREATE | O_RDWR);
    424a:	85e6                	mv	a1,s9
    424c:	854e                	mv	a0,s3
    424e:	2fb000ef          	jal	4d48 <open>
      if(fd < 0){
    4252:	fa0558e3          	bgez	a0,4202 <concreate+0x270>
    4256:	b3e9                	j	4020 <concreate+0x8e>
}
    4258:	70aa                	ld	ra,168(sp)
    425a:	740a                	ld	s0,160(sp)
    425c:	64ea                	ld	s1,152(sp)
    425e:	694a                	ld	s2,144(sp)
    4260:	69aa                	ld	s3,136(sp)
    4262:	6a0a                	ld	s4,128(sp)
    4264:	7ae6                	ld	s5,120(sp)
    4266:	7b46                	ld	s6,112(sp)
    4268:	7ba6                	ld	s7,104(sp)
    426a:	7c06                	ld	s8,96(sp)
    426c:	6ce6                	ld	s9,88(sp)
    426e:	6d46                	ld	s10,80(sp)
    4270:	614d                	addi	sp,sp,176
    4272:	8082                	ret

0000000000004274 <bigfile>:
{
    4274:	7139                	addi	sp,sp,-64
    4276:	fc06                	sd	ra,56(sp)
    4278:	f822                	sd	s0,48(sp)
    427a:	f426                	sd	s1,40(sp)
    427c:	f04a                	sd	s2,32(sp)
    427e:	ec4e                	sd	s3,24(sp)
    4280:	e852                	sd	s4,16(sp)
    4282:	e456                	sd	s5,8(sp)
    4284:	e05a                	sd	s6,0(sp)
    4286:	0080                	addi	s0,sp,64
    4288:	8b2a                	mv	s6,a0
  unlink("bigfile.dat");
    428a:	00003517          	auipc	a0,0x3
    428e:	d6650513          	addi	a0,a0,-666 # 6ff0 <malloc+0x1e26>
    4292:	2c7000ef          	jal	4d58 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    4296:	20200593          	li	a1,514
    429a:	00003517          	auipc	a0,0x3
    429e:	d5650513          	addi	a0,a0,-682 # 6ff0 <malloc+0x1e26>
    42a2:	2a7000ef          	jal	4d48 <open>
  if(fd < 0){
    42a6:	08054a63          	bltz	a0,433a <bigfile+0xc6>
    42aa:	8a2a                	mv	s4,a0
    42ac:	4481                	li	s1,0
    memset(buf, i, SZ);
    42ae:	25800913          	li	s2,600
    42b2:	00008997          	auipc	s3,0x8
    42b6:	9c698993          	addi	s3,s3,-1594 # bc78 <buf>
  for(i = 0; i < N; i++){
    42ba:	4ad1                	li	s5,20
    memset(buf, i, SZ);
    42bc:	864a                	mv	a2,s2
    42be:	85a6                	mv	a1,s1
    42c0:	854e                	mv	a0,s3
    42c2:	039000ef          	jal	4afa <memset>
    if(write(fd, buf, SZ) != SZ){
    42c6:	864a                	mv	a2,s2
    42c8:	85ce                	mv	a1,s3
    42ca:	8552                	mv	a0,s4
    42cc:	25d000ef          	jal	4d28 <write>
    42d0:	07251f63          	bne	a0,s2,434e <bigfile+0xda>
  for(i = 0; i < N; i++){
    42d4:	2485                	addiw	s1,s1,1
    42d6:	ff5493e3          	bne	s1,s5,42bc <bigfile+0x48>
  close(fd);
    42da:	8552                	mv	a0,s4
    42dc:	255000ef          	jal	4d30 <close>
  fd = open("bigfile.dat", 0);
    42e0:	4581                	li	a1,0
    42e2:	00003517          	auipc	a0,0x3
    42e6:	d0e50513          	addi	a0,a0,-754 # 6ff0 <malloc+0x1e26>
    42ea:	25f000ef          	jal	4d48 <open>
    42ee:	8aaa                	mv	s5,a0
  total = 0;
    42f0:	4a01                	li	s4,0
  for(i = 0; ; i++){
    42f2:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    42f4:	12c00993          	li	s3,300
    42f8:	00008917          	auipc	s2,0x8
    42fc:	98090913          	addi	s2,s2,-1664 # bc78 <buf>
  if(fd < 0){
    4300:	06054163          	bltz	a0,4362 <bigfile+0xee>
    cc = read(fd, buf, SZ/2);
    4304:	864e                	mv	a2,s3
    4306:	85ca                	mv	a1,s2
    4308:	8556                	mv	a0,s5
    430a:	217000ef          	jal	4d20 <read>
    if(cc < 0){
    430e:	06054463          	bltz	a0,4376 <bigfile+0x102>
    if(cc == 0)
    4312:	c145                	beqz	a0,43b2 <bigfile+0x13e>
    if(cc != SZ/2){
    4314:	07351b63          	bne	a0,s3,438a <bigfile+0x116>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    4318:	01f4d79b          	srliw	a5,s1,0x1f
    431c:	9fa5                	addw	a5,a5,s1
    431e:	4017d79b          	sraiw	a5,a5,0x1
    4322:	00094703          	lbu	a4,0(s2)
    4326:	06f71c63          	bne	a4,a5,439e <bigfile+0x12a>
    432a:	12b94703          	lbu	a4,299(s2)
    432e:	06f71863          	bne	a4,a5,439e <bigfile+0x12a>
    total += cc;
    4332:	12ca0a1b          	addiw	s4,s4,300
  for(i = 0; ; i++){
    4336:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    4338:	b7f1                	j	4304 <bigfile+0x90>
    printf("%s: cannot create bigfile", s);
    433a:	85da                	mv	a1,s6
    433c:	00003517          	auipc	a0,0x3
    4340:	cc450513          	addi	a0,a0,-828 # 7000 <malloc+0x1e36>
    4344:	5cf000ef          	jal	5112 <printf>
    exit(1);
    4348:	4505                	li	a0,1
    434a:	1bf000ef          	jal	4d08 <exit>
      printf("%s: write bigfile failed\n", s);
    434e:	85da                	mv	a1,s6
    4350:	00003517          	auipc	a0,0x3
    4354:	cd050513          	addi	a0,a0,-816 # 7020 <malloc+0x1e56>
    4358:	5bb000ef          	jal	5112 <printf>
      exit(1);
    435c:	4505                	li	a0,1
    435e:	1ab000ef          	jal	4d08 <exit>
    printf("%s: cannot open bigfile\n", s);
    4362:	85da                	mv	a1,s6
    4364:	00003517          	auipc	a0,0x3
    4368:	cdc50513          	addi	a0,a0,-804 # 7040 <malloc+0x1e76>
    436c:	5a7000ef          	jal	5112 <printf>
    exit(1);
    4370:	4505                	li	a0,1
    4372:	197000ef          	jal	4d08 <exit>
      printf("%s: read bigfile failed\n", s);
    4376:	85da                	mv	a1,s6
    4378:	00003517          	auipc	a0,0x3
    437c:	ce850513          	addi	a0,a0,-792 # 7060 <malloc+0x1e96>
    4380:	593000ef          	jal	5112 <printf>
      exit(1);
    4384:	4505                	li	a0,1
    4386:	183000ef          	jal	4d08 <exit>
      printf("%s: short read bigfile\n", s);
    438a:	85da                	mv	a1,s6
    438c:	00003517          	auipc	a0,0x3
    4390:	cf450513          	addi	a0,a0,-780 # 7080 <malloc+0x1eb6>
    4394:	57f000ef          	jal	5112 <printf>
      exit(1);
    4398:	4505                	li	a0,1
    439a:	16f000ef          	jal	4d08 <exit>
      printf("%s: read bigfile wrong data\n", s);
    439e:	85da                	mv	a1,s6
    43a0:	00003517          	auipc	a0,0x3
    43a4:	cf850513          	addi	a0,a0,-776 # 7098 <malloc+0x1ece>
    43a8:	56b000ef          	jal	5112 <printf>
      exit(1);
    43ac:	4505                	li	a0,1
    43ae:	15b000ef          	jal	4d08 <exit>
  close(fd);
    43b2:	8556                	mv	a0,s5
    43b4:	17d000ef          	jal	4d30 <close>
  if(total != N*SZ){
    43b8:	678d                	lui	a5,0x3
    43ba:	ee078793          	addi	a5,a5,-288 # 2ee0 <subdir+0x1de>
    43be:	02fa1263          	bne	s4,a5,43e2 <bigfile+0x16e>
  unlink("bigfile.dat");
    43c2:	00003517          	auipc	a0,0x3
    43c6:	c2e50513          	addi	a0,a0,-978 # 6ff0 <malloc+0x1e26>
    43ca:	18f000ef          	jal	4d58 <unlink>
}
    43ce:	70e2                	ld	ra,56(sp)
    43d0:	7442                	ld	s0,48(sp)
    43d2:	74a2                	ld	s1,40(sp)
    43d4:	7902                	ld	s2,32(sp)
    43d6:	69e2                	ld	s3,24(sp)
    43d8:	6a42                	ld	s4,16(sp)
    43da:	6aa2                	ld	s5,8(sp)
    43dc:	6b02                	ld	s6,0(sp)
    43de:	6121                	addi	sp,sp,64
    43e0:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    43e2:	85da                	mv	a1,s6
    43e4:	00003517          	auipc	a0,0x3
    43e8:	cd450513          	addi	a0,a0,-812 # 70b8 <malloc+0x1eee>
    43ec:	527000ef          	jal	5112 <printf>
    exit(1);
    43f0:	4505                	li	a0,1
    43f2:	117000ef          	jal	4d08 <exit>

00000000000043f6 <bigargtest>:
{
    43f6:	7121                	addi	sp,sp,-448
    43f8:	ff06                	sd	ra,440(sp)
    43fa:	fb22                	sd	s0,432(sp)
    43fc:	f726                	sd	s1,424(sp)
    43fe:	0380                	addi	s0,sp,448
    4400:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    4402:	00003517          	auipc	a0,0x3
    4406:	cd650513          	addi	a0,a0,-810 # 70d8 <malloc+0x1f0e>
    440a:	14f000ef          	jal	4d58 <unlink>
  pid = fork();
    440e:	0f3000ef          	jal	4d00 <fork>
  if(pid == 0){
    4412:	c915                	beqz	a0,4446 <bigargtest+0x50>
  } else if(pid < 0){
    4414:	08054a63          	bltz	a0,44a8 <bigargtest+0xb2>
  wait(&xstatus);
    4418:	fdc40513          	addi	a0,s0,-36
    441c:	0f5000ef          	jal	4d10 <wait>
  if(xstatus != 0)
    4420:	fdc42503          	lw	a0,-36(s0)
    4424:	ed41                	bnez	a0,44bc <bigargtest+0xc6>
  fd = open("bigarg-ok", 0);
    4426:	4581                	li	a1,0
    4428:	00003517          	auipc	a0,0x3
    442c:	cb050513          	addi	a0,a0,-848 # 70d8 <malloc+0x1f0e>
    4430:	119000ef          	jal	4d48 <open>
  if(fd < 0){
    4434:	08054663          	bltz	a0,44c0 <bigargtest+0xca>
  close(fd);
    4438:	0f9000ef          	jal	4d30 <close>
}
    443c:	70fa                	ld	ra,440(sp)
    443e:	745a                	ld	s0,432(sp)
    4440:	74ba                	ld	s1,424(sp)
    4442:	6139                	addi	sp,sp,448
    4444:	8082                	ret
    memset(big, ' ', sizeof(big));
    4446:	19000613          	li	a2,400
    444a:	02000593          	li	a1,32
    444e:	e4840513          	addi	a0,s0,-440
    4452:	6a8000ef          	jal	4afa <memset>
    big[sizeof(big)-1] = '\0';
    4456:	fc040ba3          	sb	zero,-41(s0)
    for(i = 0; i < MAXARG-1; i++)
    445a:	00004797          	auipc	a5,0x4
    445e:	00678793          	addi	a5,a5,6 # 8460 <args.1>
    4462:	00004697          	auipc	a3,0x4
    4466:	0f668693          	addi	a3,a3,246 # 8558 <args.1+0xf8>
      args[i] = big;
    446a:	e4840713          	addi	a4,s0,-440
    446e:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    4470:	07a1                	addi	a5,a5,8
    4472:	fed79ee3          	bne	a5,a3,446e <bigargtest+0x78>
    args[MAXARG-1] = 0;
    4476:	00004597          	auipc	a1,0x4
    447a:	fea58593          	addi	a1,a1,-22 # 8460 <args.1>
    447e:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    4482:	00001517          	auipc	a0,0x1
    4486:	e7650513          	addi	a0,a0,-394 # 52f8 <malloc+0x12e>
    448a:	0b7000ef          	jal	4d40 <exec>
    fd = open("bigarg-ok", O_CREATE);
    448e:	20000593          	li	a1,512
    4492:	00003517          	auipc	a0,0x3
    4496:	c4650513          	addi	a0,a0,-954 # 70d8 <malloc+0x1f0e>
    449a:	0af000ef          	jal	4d48 <open>
    close(fd);
    449e:	093000ef          	jal	4d30 <close>
    exit(0);
    44a2:	4501                	li	a0,0
    44a4:	065000ef          	jal	4d08 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    44a8:	85a6                	mv	a1,s1
    44aa:	00003517          	auipc	a0,0x3
    44ae:	c3e50513          	addi	a0,a0,-962 # 70e8 <malloc+0x1f1e>
    44b2:	461000ef          	jal	5112 <printf>
    exit(1);
    44b6:	4505                	li	a0,1
    44b8:	051000ef          	jal	4d08 <exit>
    exit(xstatus);
    44bc:	04d000ef          	jal	4d08 <exit>
    printf("%s: bigarg test failed!\n", s);
    44c0:	85a6                	mv	a1,s1
    44c2:	00003517          	auipc	a0,0x3
    44c6:	c4650513          	addi	a0,a0,-954 # 7108 <malloc+0x1f3e>
    44ca:	449000ef          	jal	5112 <printf>
    exit(1);
    44ce:	4505                	li	a0,1
    44d0:	039000ef          	jal	4d08 <exit>

00000000000044d4 <fsfull>:
{
    44d4:	7171                	addi	sp,sp,-176
    44d6:	f506                	sd	ra,168(sp)
    44d8:	f122                	sd	s0,160(sp)
    44da:	ed26                	sd	s1,152(sp)
    44dc:	e94a                	sd	s2,144(sp)
    44de:	e54e                	sd	s3,136(sp)
    44e0:	e152                	sd	s4,128(sp)
    44e2:	fcd6                	sd	s5,120(sp)
    44e4:	f8da                	sd	s6,112(sp)
    44e6:	f4de                	sd	s7,104(sp)
    44e8:	f0e2                	sd	s8,96(sp)
    44ea:	ece6                	sd	s9,88(sp)
    44ec:	e8ea                	sd	s10,80(sp)
    44ee:	e4ee                	sd	s11,72(sp)
    44f0:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    44f2:	00003517          	auipc	a0,0x3
    44f6:	c3650513          	addi	a0,a0,-970 # 7128 <malloc+0x1f5e>
    44fa:	419000ef          	jal	5112 <printf>
  for(nfiles = 0; ; nfiles++){
    44fe:	4481                	li	s1,0
    name[0] = 'f';
    4500:	06600d93          	li	s11,102
    name[1] = '0' + nfiles / 1000;
    4504:	10625cb7          	lui	s9,0x10625
    4508:	dd3c8c93          	addi	s9,s9,-557 # 10624dd3 <base+0x1061615b>
    name[2] = '0' + (nfiles % 1000) / 100;
    450c:	51eb8ab7          	lui	s5,0x51eb8
    4510:	51fa8a93          	addi	s5,s5,1311 # 51eb851f <base+0x51ea98a7>
    name[3] = '0' + (nfiles % 100) / 10;
    4514:	66666a37          	lui	s4,0x66666
    4518:	667a0a13          	addi	s4,s4,1639 # 66666667 <base+0x666579ef>
    printf("writing %s\n", name);
    451c:	f5040d13          	addi	s10,s0,-176
    name[0] = 'f';
    4520:	f5b40823          	sb	s11,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4524:	039487b3          	mul	a5,s1,s9
    4528:	9799                	srai	a5,a5,0x26
    452a:	41f4d69b          	sraiw	a3,s1,0x1f
    452e:	9f95                	subw	a5,a5,a3
    4530:	0307871b          	addiw	a4,a5,48
    4534:	f4e408a3          	sb	a4,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4538:	3e800713          	li	a4,1000
    453c:	02f707bb          	mulw	a5,a4,a5
    4540:	40f487bb          	subw	a5,s1,a5
    4544:	03578733          	mul	a4,a5,s5
    4548:	9715                	srai	a4,a4,0x25
    454a:	41f7d79b          	sraiw	a5,a5,0x1f
    454e:	40f707bb          	subw	a5,a4,a5
    4552:	0307879b          	addiw	a5,a5,48
    4556:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    455a:	035487b3          	mul	a5,s1,s5
    455e:	9795                	srai	a5,a5,0x25
    4560:	9f95                	subw	a5,a5,a3
    4562:	06400713          	li	a4,100
    4566:	02f707bb          	mulw	a5,a4,a5
    456a:	40f487bb          	subw	a5,s1,a5
    456e:	03478733          	mul	a4,a5,s4
    4572:	9709                	srai	a4,a4,0x22
    4574:	41f7d79b          	sraiw	a5,a5,0x1f
    4578:	40f707bb          	subw	a5,a4,a5
    457c:	0307879b          	addiw	a5,a5,48
    4580:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4584:	03448733          	mul	a4,s1,s4
    4588:	9709                	srai	a4,a4,0x22
    458a:	9f15                	subw	a4,a4,a3
    458c:	0027179b          	slliw	a5,a4,0x2
    4590:	9fb9                	addw	a5,a5,a4
    4592:	0017979b          	slliw	a5,a5,0x1
    4596:	40f487bb          	subw	a5,s1,a5
    459a:	0307879b          	addiw	a5,a5,48
    459e:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    45a2:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    45a6:	85ea                	mv	a1,s10
    45a8:	00003517          	auipc	a0,0x3
    45ac:	b9050513          	addi	a0,a0,-1136 # 7138 <malloc+0x1f6e>
    45b0:	363000ef          	jal	5112 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    45b4:	20200593          	li	a1,514
    45b8:	856a                	mv	a0,s10
    45ba:	78e000ef          	jal	4d48 <open>
    45be:	892a                	mv	s2,a0
    if(fd < 0){
    45c0:	0e055863          	bgez	a0,46b0 <fsfull+0x1dc>
      printf("open %s failed\n", name);
    45c4:	f5040593          	addi	a1,s0,-176
    45c8:	00003517          	auipc	a0,0x3
    45cc:	b8050513          	addi	a0,a0,-1152 # 7148 <malloc+0x1f7e>
    45d0:	343000ef          	jal	5112 <printf>
    name[0] = 'f';
    45d4:	06600c13          	li	s8,102
    name[1] = '0' + nfiles / 1000;
    45d8:	10625a37          	lui	s4,0x10625
    45dc:	dd3a0a13          	addi	s4,s4,-557 # 10624dd3 <base+0x1061615b>
    name[2] = '0' + (nfiles % 1000) / 100;
    45e0:	3e800b93          	li	s7,1000
    45e4:	51eb89b7          	lui	s3,0x51eb8
    45e8:	51f98993          	addi	s3,s3,1311 # 51eb851f <base+0x51ea98a7>
    name[3] = '0' + (nfiles % 100) / 10;
    45ec:	06400b13          	li	s6,100
    45f0:	66666937          	lui	s2,0x66666
    45f4:	66790913          	addi	s2,s2,1639 # 66666667 <base+0x666579ef>
    unlink(name);
    45f8:	f5040a93          	addi	s5,s0,-176
    name[0] = 'f';
    45fc:	f5840823          	sb	s8,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4600:	034487b3          	mul	a5,s1,s4
    4604:	9799                	srai	a5,a5,0x26
    4606:	41f4d69b          	sraiw	a3,s1,0x1f
    460a:	9f95                	subw	a5,a5,a3
    460c:	0307871b          	addiw	a4,a5,48
    4610:	f4e408a3          	sb	a4,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4614:	02fb87bb          	mulw	a5,s7,a5
    4618:	40f487bb          	subw	a5,s1,a5
    461c:	03378733          	mul	a4,a5,s3
    4620:	9715                	srai	a4,a4,0x25
    4622:	41f7d79b          	sraiw	a5,a5,0x1f
    4626:	40f707bb          	subw	a5,a4,a5
    462a:	0307879b          	addiw	a5,a5,48
    462e:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4632:	033487b3          	mul	a5,s1,s3
    4636:	9795                	srai	a5,a5,0x25
    4638:	9f95                	subw	a5,a5,a3
    463a:	02fb07bb          	mulw	a5,s6,a5
    463e:	40f487bb          	subw	a5,s1,a5
    4642:	03278733          	mul	a4,a5,s2
    4646:	9709                	srai	a4,a4,0x22
    4648:	41f7d79b          	sraiw	a5,a5,0x1f
    464c:	40f707bb          	subw	a5,a4,a5
    4650:	0307879b          	addiw	a5,a5,48
    4654:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4658:	03248733          	mul	a4,s1,s2
    465c:	9709                	srai	a4,a4,0x22
    465e:	9f15                	subw	a4,a4,a3
    4660:	0027179b          	slliw	a5,a4,0x2
    4664:	9fb9                	addw	a5,a5,a4
    4666:	0017979b          	slliw	a5,a5,0x1
    466a:	40f487bb          	subw	a5,s1,a5
    466e:	0307879b          	addiw	a5,a5,48
    4672:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4676:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    467a:	8556                	mv	a0,s5
    467c:	6dc000ef          	jal	4d58 <unlink>
    nfiles--;
    4680:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    4682:	f604dde3          	bgez	s1,45fc <fsfull+0x128>
  printf("fsfull test finished\n");
    4686:	00003517          	auipc	a0,0x3
    468a:	ae250513          	addi	a0,a0,-1310 # 7168 <malloc+0x1f9e>
    468e:	285000ef          	jal	5112 <printf>
}
    4692:	70aa                	ld	ra,168(sp)
    4694:	740a                	ld	s0,160(sp)
    4696:	64ea                	ld	s1,152(sp)
    4698:	694a                	ld	s2,144(sp)
    469a:	69aa                	ld	s3,136(sp)
    469c:	6a0a                	ld	s4,128(sp)
    469e:	7ae6                	ld	s5,120(sp)
    46a0:	7b46                	ld	s6,112(sp)
    46a2:	7ba6                	ld	s7,104(sp)
    46a4:	7c06                	ld	s8,96(sp)
    46a6:	6ce6                	ld	s9,88(sp)
    46a8:	6d46                	ld	s10,80(sp)
    46aa:	6da6                	ld	s11,72(sp)
    46ac:	614d                	addi	sp,sp,176
    46ae:	8082                	ret
    int total = 0;
    46b0:	4981                	li	s3,0
      int cc = write(fd, buf, BSIZE);
    46b2:	40000c13          	li	s8,1024
    46b6:	00007b97          	auipc	s7,0x7
    46ba:	5c2b8b93          	addi	s7,s7,1474 # bc78 <buf>
      if(cc < BSIZE)
    46be:	3ff00b13          	li	s6,1023
      int cc = write(fd, buf, BSIZE);
    46c2:	8662                	mv	a2,s8
    46c4:	85de                	mv	a1,s7
    46c6:	854a                	mv	a0,s2
    46c8:	660000ef          	jal	4d28 <write>
      if(cc < BSIZE)
    46cc:	00ab5563          	bge	s6,a0,46d6 <fsfull+0x202>
      total += cc;
    46d0:	00a989bb          	addw	s3,s3,a0
    while(1){
    46d4:	b7fd                	j	46c2 <fsfull+0x1ee>
    printf("wrote %d bytes\n", total);
    46d6:	85ce                	mv	a1,s3
    46d8:	00003517          	auipc	a0,0x3
    46dc:	a8050513          	addi	a0,a0,-1408 # 7158 <malloc+0x1f8e>
    46e0:	233000ef          	jal	5112 <printf>
    close(fd);
    46e4:	854a                	mv	a0,s2
    46e6:	64a000ef          	jal	4d30 <close>
    if(total == 0)
    46ea:	ee0985e3          	beqz	s3,45d4 <fsfull+0x100>
  for(nfiles = 0; ; nfiles++){
    46ee:	2485                	addiw	s1,s1,1
    46f0:	bd05                	j	4520 <fsfull+0x4c>

00000000000046f2 <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    46f2:	7179                	addi	sp,sp,-48
    46f4:	f406                	sd	ra,40(sp)
    46f6:	f022                	sd	s0,32(sp)
    46f8:	ec26                	sd	s1,24(sp)
    46fa:	e84a                	sd	s2,16(sp)
    46fc:	1800                	addi	s0,sp,48
    46fe:	84aa                	mv	s1,a0
    4700:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    4702:	00003517          	auipc	a0,0x3
    4706:	a7e50513          	addi	a0,a0,-1410 # 7180 <malloc+0x1fb6>
    470a:	209000ef          	jal	5112 <printf>
  if((pid = fork()) < 0) {
    470e:	5f2000ef          	jal	4d00 <fork>
    4712:	02054a63          	bltz	a0,4746 <run+0x54>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    4716:	c129                	beqz	a0,4758 <run+0x66>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    4718:	fdc40513          	addi	a0,s0,-36
    471c:	5f4000ef          	jal	4d10 <wait>
    if(xstatus != 0) 
    4720:	fdc42783          	lw	a5,-36(s0)
    4724:	cf9d                	beqz	a5,4762 <run+0x70>
      printf("FAILED\n");
    4726:	00003517          	auipc	a0,0x3
    472a:	a8250513          	addi	a0,a0,-1406 # 71a8 <malloc+0x1fde>
    472e:	1e5000ef          	jal	5112 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    4732:	fdc42503          	lw	a0,-36(s0)
  }
}
    4736:	00153513          	seqz	a0,a0
    473a:	70a2                	ld	ra,40(sp)
    473c:	7402                	ld	s0,32(sp)
    473e:	64e2                	ld	s1,24(sp)
    4740:	6942                	ld	s2,16(sp)
    4742:	6145                	addi	sp,sp,48
    4744:	8082                	ret
    printf("runtest: fork error\n");
    4746:	00003517          	auipc	a0,0x3
    474a:	a4a50513          	addi	a0,a0,-1462 # 7190 <malloc+0x1fc6>
    474e:	1c5000ef          	jal	5112 <printf>
    exit(1);
    4752:	4505                	li	a0,1
    4754:	5b4000ef          	jal	4d08 <exit>
    f(s);
    4758:	854a                	mv	a0,s2
    475a:	9482                	jalr	s1
    exit(0);
    475c:	4501                	li	a0,0
    475e:	5aa000ef          	jal	4d08 <exit>
      printf("OK\n");
    4762:	00003517          	auipc	a0,0x3
    4766:	a4e50513          	addi	a0,a0,-1458 # 71b0 <malloc+0x1fe6>
    476a:	1a9000ef          	jal	5112 <printf>
    476e:	b7d1                	j	4732 <run+0x40>

0000000000004770 <runtests>:

int
runtests(struct test *tests, char *justone, int continuous) {
    4770:	7139                	addi	sp,sp,-64
    4772:	fc06                	sd	ra,56(sp)
    4774:	f822                	sd	s0,48(sp)
    4776:	f04a                	sd	s2,32(sp)
    4778:	0080                	addi	s0,sp,64
  for (struct test *t = tests; t->s != 0; t++) {
    477a:	00853903          	ld	s2,8(a0)
    477e:	06090463          	beqz	s2,47e6 <runtests+0x76>
    4782:	f426                	sd	s1,40(sp)
    4784:	ec4e                	sd	s3,24(sp)
    4786:	e852                	sd	s4,16(sp)
    4788:	e456                	sd	s5,8(sp)
    478a:	84aa                	mv	s1,a0
    478c:	89ae                	mv	s3,a1
    478e:	8a32                	mv	s4,a2
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s)){
        if(continuous != 2){
    4790:	4a89                	li	s5,2
    4792:	a031                	j	479e <runtests+0x2e>
  for (struct test *t = tests; t->s != 0; t++) {
    4794:	04c1                	addi	s1,s1,16
    4796:	0084b903          	ld	s2,8(s1)
    479a:	02090c63          	beqz	s2,47d2 <runtests+0x62>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    479e:	00098763          	beqz	s3,47ac <runtests+0x3c>
    47a2:	85ce                	mv	a1,s3
    47a4:	854a                	mv	a0,s2
    47a6:	2f6000ef          	jal	4a9c <strcmp>
    47aa:	f56d                	bnez	a0,4794 <runtests+0x24>
      if(!run(t->f, t->s)){
    47ac:	85ca                	mv	a1,s2
    47ae:	6088                	ld	a0,0(s1)
    47b0:	f43ff0ef          	jal	46f2 <run>
    47b4:	f165                	bnez	a0,4794 <runtests+0x24>
        if(continuous != 2){
    47b6:	fd5a0fe3          	beq	s4,s5,4794 <runtests+0x24>
          printf("SOME TESTS FAILED\n");
    47ba:	00003517          	auipc	a0,0x3
    47be:	9fe50513          	addi	a0,a0,-1538 # 71b8 <malloc+0x1fee>
    47c2:	151000ef          	jal	5112 <printf>
          return 1;
    47c6:	4505                	li	a0,1
    47c8:	74a2                	ld	s1,40(sp)
    47ca:	69e2                	ld	s3,24(sp)
    47cc:	6a42                	ld	s4,16(sp)
    47ce:	6aa2                	ld	s5,8(sp)
    47d0:	a031                	j	47dc <runtests+0x6c>
        }
      }
    }
  }
  return 0;
    47d2:	4501                	li	a0,0
    47d4:	74a2                	ld	s1,40(sp)
    47d6:	69e2                	ld	s3,24(sp)
    47d8:	6a42                	ld	s4,16(sp)
    47da:	6aa2                	ld	s5,8(sp)
}
    47dc:	70e2                	ld	ra,56(sp)
    47de:	7442                	ld	s0,48(sp)
    47e0:	7902                	ld	s2,32(sp)
    47e2:	6121                	addi	sp,sp,64
    47e4:	8082                	ret
  return 0;
    47e6:	4501                	li	a0,0
    47e8:	bfd5                	j	47dc <runtests+0x6c>

00000000000047ea <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    47ea:	7139                	addi	sp,sp,-64
    47ec:	fc06                	sd	ra,56(sp)
    47ee:	f822                	sd	s0,48(sp)
    47f0:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    47f2:	fc840513          	addi	a0,s0,-56
    47f6:	522000ef          	jal	4d18 <pipe>
    47fa:	04054f63          	bltz	a0,4858 <countfree+0x6e>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    47fe:	502000ef          	jal	4d00 <fork>

  if(pid < 0){
    4802:	06054863          	bltz	a0,4872 <countfree+0x88>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    4806:	e551                	bnez	a0,4892 <countfree+0xa8>
    4808:	f426                	sd	s1,40(sp)
    480a:	f04a                	sd	s2,32(sp)
    480c:	ec4e                	sd	s3,24(sp)
    480e:	e852                	sd	s4,16(sp)
    close(fds[0]);
    4810:	fc842503          	lw	a0,-56(s0)
    4814:	51c000ef          	jal	4d30 <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
    4818:	6905                	lui	s2,0x1
      if(a == 0xffffffffffffffff){
    481a:	59fd                	li	s3,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    481c:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    481e:	00001a17          	auipc	s4,0x1
    4822:	b4aa0a13          	addi	s4,s4,-1206 # 5368 <malloc+0x19e>
      uint64 a = (uint64) sbrk(4096);
    4826:	854a                	mv	a0,s2
    4828:	568000ef          	jal	4d90 <sbrk>
      if(a == 0xffffffffffffffff){
    482c:	07350063          	beq	a0,s3,488c <countfree+0xa2>
      *(char *)(a + 4096 - 1) = 1;
    4830:	954a                	add	a0,a0,s2
    4832:	fe950fa3          	sb	s1,-1(a0)
      if(write(fds[1], "x", 1) != 1){
    4836:	8626                	mv	a2,s1
    4838:	85d2                	mv	a1,s4
    483a:	fcc42503          	lw	a0,-52(s0)
    483e:	4ea000ef          	jal	4d28 <write>
    4842:	fe9502e3          	beq	a0,s1,4826 <countfree+0x3c>
        printf("write() failed in countfree()\n");
    4846:	00003517          	auipc	a0,0x3
    484a:	9ca50513          	addi	a0,a0,-1590 # 7210 <malloc+0x2046>
    484e:	0c5000ef          	jal	5112 <printf>
        exit(1);
    4852:	4505                	li	a0,1
    4854:	4b4000ef          	jal	4d08 <exit>
    4858:	f426                	sd	s1,40(sp)
    485a:	f04a                	sd	s2,32(sp)
    485c:	ec4e                	sd	s3,24(sp)
    485e:	e852                	sd	s4,16(sp)
    printf("pipe() failed in countfree()\n");
    4860:	00003517          	auipc	a0,0x3
    4864:	97050513          	addi	a0,a0,-1680 # 71d0 <malloc+0x2006>
    4868:	0ab000ef          	jal	5112 <printf>
    exit(1);
    486c:	4505                	li	a0,1
    486e:	49a000ef          	jal	4d08 <exit>
    4872:	f426                	sd	s1,40(sp)
    4874:	f04a                	sd	s2,32(sp)
    4876:	ec4e                	sd	s3,24(sp)
    4878:	e852                	sd	s4,16(sp)
    printf("fork failed in countfree()\n");
    487a:	00003517          	auipc	a0,0x3
    487e:	97650513          	addi	a0,a0,-1674 # 71f0 <malloc+0x2026>
    4882:	091000ef          	jal	5112 <printf>
    exit(1);
    4886:	4505                	li	a0,1
    4888:	480000ef          	jal	4d08 <exit>
      }
    }

    exit(0);
    488c:	4501                	li	a0,0
    488e:	47a000ef          	jal	4d08 <exit>
    4892:	f426                	sd	s1,40(sp)
    4894:	f04a                	sd	s2,32(sp)
    4896:	ec4e                	sd	s3,24(sp)
  }

  close(fds[1]);
    4898:	fcc42503          	lw	a0,-52(s0)
    489c:	494000ef          	jal	4d30 <close>

  int n = 0;
    48a0:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    48a2:	fc740993          	addi	s3,s0,-57
    48a6:	4905                	li	s2,1
    48a8:	864a                	mv	a2,s2
    48aa:	85ce                	mv	a1,s3
    48ac:	fc842503          	lw	a0,-56(s0)
    48b0:	470000ef          	jal	4d20 <read>
    if(cc < 0){
    48b4:	00054563          	bltz	a0,48be <countfree+0xd4>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    48b8:	cd09                	beqz	a0,48d2 <countfree+0xe8>
      break;
    n += 1;
    48ba:	2485                	addiw	s1,s1,1
  while(1){
    48bc:	b7f5                	j	48a8 <countfree+0xbe>
    48be:	e852                	sd	s4,16(sp)
      printf("read() failed in countfree()\n");
    48c0:	00003517          	auipc	a0,0x3
    48c4:	97050513          	addi	a0,a0,-1680 # 7230 <malloc+0x2066>
    48c8:	04b000ef          	jal	5112 <printf>
      exit(1);
    48cc:	4505                	li	a0,1
    48ce:	43a000ef          	jal	4d08 <exit>
  }

  close(fds[0]);
    48d2:	fc842503          	lw	a0,-56(s0)
    48d6:	45a000ef          	jal	4d30 <close>
  wait((int*)0);
    48da:	4501                	li	a0,0
    48dc:	434000ef          	jal	4d10 <wait>
  
  return n;
}
    48e0:	8526                	mv	a0,s1
    48e2:	74a2                	ld	s1,40(sp)
    48e4:	7902                	ld	s2,32(sp)
    48e6:	69e2                	ld	s3,24(sp)
    48e8:	70e2                	ld	ra,56(sp)
    48ea:	7442                	ld	s0,48(sp)
    48ec:	6121                	addi	sp,sp,64
    48ee:	8082                	ret

00000000000048f0 <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
    48f0:	711d                	addi	sp,sp,-96
    48f2:	ec86                	sd	ra,88(sp)
    48f4:	e8a2                	sd	s0,80(sp)
    48f6:	e4a6                	sd	s1,72(sp)
    48f8:	e0ca                	sd	s2,64(sp)
    48fa:	fc4e                	sd	s3,56(sp)
    48fc:	f852                	sd	s4,48(sp)
    48fe:	f456                	sd	s5,40(sp)
    4900:	f05a                	sd	s6,32(sp)
    4902:	ec5e                	sd	s7,24(sp)
    4904:	e862                	sd	s8,16(sp)
    4906:	e466                	sd	s9,8(sp)
    4908:	e06a                	sd	s10,0(sp)
    490a:	1080                	addi	s0,sp,96
    490c:	8aaa                	mv	s5,a0
    490e:	892e                	mv	s2,a1
    4910:	89b2                	mv	s3,a2
  do {
    printf("usertests starting\n");
    4912:	00003b97          	auipc	s7,0x3
    4916:	93eb8b93          	addi	s7,s7,-1730 # 7250 <malloc+0x2086>
    int free0 = countfree();
    int free1 = 0;
    if (runtests(quicktests, justone, continuous)) {
    491a:	00003b17          	auipc	s6,0x3
    491e:	6f6b0b13          	addi	s6,s6,1782 # 8010 <quicktests>
      if(continuous != 2) {
    4922:	4a09                	li	s4,2
      }
    }
    if(!quick) {
      if (justone == 0)
        printf("usertests slow tests starting\n");
      if (runtests(slowtests, justone, continuous)) {
    4924:	00004c17          	auipc	s8,0x4
    4928:	abcc0c13          	addi	s8,s8,-1348 # 83e0 <slowtests>
        printf("usertests slow tests starting\n");
    492c:	00003d17          	auipc	s10,0x3
    4930:	93cd0d13          	addi	s10,s10,-1732 # 7268 <malloc+0x209e>
          return 1;
        }
      }
    }
    if((free1 = countfree()) < free0) {
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    4934:	00003c97          	auipc	s9,0x3
    4938:	954c8c93          	addi	s9,s9,-1708 # 7288 <malloc+0x20be>
    493c:	a819                	j	4952 <drivetests+0x62>
        printf("usertests slow tests starting\n");
    493e:	856a                	mv	a0,s10
    4940:	7d2000ef          	jal	5112 <printf>
    4944:	a80d                	j	4976 <drivetests+0x86>
    if((free1 = countfree()) < free0) {
    4946:	ea5ff0ef          	jal	47ea <countfree>
    494a:	04954063          	blt	a0,s1,498a <drivetests+0x9a>
      if(continuous != 2) {
        return 1;
      }
    }
  } while(continuous);
    494e:	04090963          	beqz	s2,49a0 <drivetests+0xb0>
    printf("usertests starting\n");
    4952:	855e                	mv	a0,s7
    4954:	7be000ef          	jal	5112 <printf>
    int free0 = countfree();
    4958:	e93ff0ef          	jal	47ea <countfree>
    495c:	84aa                	mv	s1,a0
    if (runtests(quicktests, justone, continuous)) {
    495e:	864a                	mv	a2,s2
    4960:	85ce                	mv	a1,s3
    4962:	855a                	mv	a0,s6
    4964:	e0dff0ef          	jal	4770 <runtests>
    4968:	c119                	beqz	a0,496e <drivetests+0x7e>
      if(continuous != 2) {
    496a:	03491963          	bne	s2,s4,499c <drivetests+0xac>
    if(!quick) {
    496e:	fc0a9ce3          	bnez	s5,4946 <drivetests+0x56>
      if (justone == 0)
    4972:	fc0986e3          	beqz	s3,493e <drivetests+0x4e>
      if (runtests(slowtests, justone, continuous)) {
    4976:	864a                	mv	a2,s2
    4978:	85ce                	mv	a1,s3
    497a:	8562                	mv	a0,s8
    497c:	df5ff0ef          	jal	4770 <runtests>
    4980:	d179                	beqz	a0,4946 <drivetests+0x56>
        if(continuous != 2) {
    4982:	fd4902e3          	beq	s2,s4,4946 <drivetests+0x56>
          return 1;
    4986:	4505                	li	a0,1
    4988:	a829                	j	49a2 <drivetests+0xb2>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    498a:	8626                	mv	a2,s1
    498c:	85aa                	mv	a1,a0
    498e:	8566                	mv	a0,s9
    4990:	782000ef          	jal	5112 <printf>
      if(continuous != 2) {
    4994:	fb490fe3          	beq	s2,s4,4952 <drivetests+0x62>
        return 1;
    4998:	4505                	li	a0,1
    499a:	a021                	j	49a2 <drivetests+0xb2>
        return 1;
    499c:	4505                	li	a0,1
    499e:	a011                	j	49a2 <drivetests+0xb2>
  return 0;
    49a0:	854a                	mv	a0,s2
}
    49a2:	60e6                	ld	ra,88(sp)
    49a4:	6446                	ld	s0,80(sp)
    49a6:	64a6                	ld	s1,72(sp)
    49a8:	6906                	ld	s2,64(sp)
    49aa:	79e2                	ld	s3,56(sp)
    49ac:	7a42                	ld	s4,48(sp)
    49ae:	7aa2                	ld	s5,40(sp)
    49b0:	7b02                	ld	s6,32(sp)
    49b2:	6be2                	ld	s7,24(sp)
    49b4:	6c42                	ld	s8,16(sp)
    49b6:	6ca2                	ld	s9,8(sp)
    49b8:	6d02                	ld	s10,0(sp)
    49ba:	6125                	addi	sp,sp,96
    49bc:	8082                	ret

00000000000049be <main>:

int
main(int argc, char *argv[])
{
    49be:	1101                	addi	sp,sp,-32
    49c0:	ec06                	sd	ra,24(sp)
    49c2:	e822                	sd	s0,16(sp)
    49c4:	e426                	sd	s1,8(sp)
    49c6:	e04a                	sd	s2,0(sp)
    49c8:	1000                	addi	s0,sp,32
    49ca:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    49cc:	4789                	li	a5,2
    49ce:	00f50f63          	beq	a0,a5,49ec <main+0x2e>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    49d2:	4785                	li	a5,1
    49d4:	06a7c063          	blt	a5,a0,4a34 <main+0x76>
  char *justone = 0;
    49d8:	4901                	li	s2,0
  int quick = 0;
    49da:	4501                	li	a0,0
  int continuous = 0;
    49dc:	4581                	li	a1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    49de:	864a                	mv	a2,s2
    49e0:	f11ff0ef          	jal	48f0 <drivetests>
    49e4:	c935                	beqz	a0,4a58 <main+0x9a>
    exit(1);
    49e6:	4505                	li	a0,1
    49e8:	320000ef          	jal	4d08 <exit>
  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    49ec:	0085b903          	ld	s2,8(a1)
    49f0:	00003597          	auipc	a1,0x3
    49f4:	8c858593          	addi	a1,a1,-1848 # 72b8 <malloc+0x20ee>
    49f8:	854a                	mv	a0,s2
    49fa:	0a2000ef          	jal	4a9c <strcmp>
    49fe:	85aa                	mv	a1,a0
    4a00:	c139                	beqz	a0,4a46 <main+0x88>
  } else if(argc == 2 && strcmp(argv[1], "-c") == 0){
    4a02:	00003597          	auipc	a1,0x3
    4a06:	8be58593          	addi	a1,a1,-1858 # 72c0 <malloc+0x20f6>
    4a0a:	854a                	mv	a0,s2
    4a0c:	090000ef          	jal	4a9c <strcmp>
    4a10:	cd15                	beqz	a0,4a4c <main+0x8e>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    4a12:	00003597          	auipc	a1,0x3
    4a16:	8b658593          	addi	a1,a1,-1866 # 72c8 <malloc+0x20fe>
    4a1a:	854a                	mv	a0,s2
    4a1c:	080000ef          	jal	4a9c <strcmp>
    4a20:	c90d                	beqz	a0,4a52 <main+0x94>
  } else if(argc == 2 && argv[1][0] != '-'){
    4a22:	00094703          	lbu	a4,0(s2) # 1000 <bigdir+0x106>
    4a26:	02d00793          	li	a5,45
    4a2a:	00f70563          	beq	a4,a5,4a34 <main+0x76>
  int quick = 0;
    4a2e:	4501                	li	a0,0
  int continuous = 0;
    4a30:	4581                	li	a1,0
    4a32:	b775                	j	49de <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    4a34:	00003517          	auipc	a0,0x3
    4a38:	89c50513          	addi	a0,a0,-1892 # 72d0 <malloc+0x2106>
    4a3c:	6d6000ef          	jal	5112 <printf>
    exit(1);
    4a40:	4505                	li	a0,1
    4a42:	2c6000ef          	jal	4d08 <exit>
  char *justone = 0;
    4a46:	4901                	li	s2,0
    quick = 1;
    4a48:	4505                	li	a0,1
    4a4a:	bf51                	j	49de <main+0x20>
  char *justone = 0;
    4a4c:	4901                	li	s2,0
    continuous = 1;
    4a4e:	4585                	li	a1,1
    4a50:	b779                	j	49de <main+0x20>
    continuous = 2;
    4a52:	85a6                	mv	a1,s1
  char *justone = 0;
    4a54:	4901                	li	s2,0
    4a56:	b761                	j	49de <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    4a58:	00003517          	auipc	a0,0x3
    4a5c:	8a850513          	addi	a0,a0,-1880 # 7300 <malloc+0x2136>
    4a60:	6b2000ef          	jal	5112 <printf>
  exit(0);
    4a64:	4501                	li	a0,0
    4a66:	2a2000ef          	jal	4d08 <exit>

0000000000004a6a <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
    4a6a:	1141                	addi	sp,sp,-16
    4a6c:	e406                	sd	ra,8(sp)
    4a6e:	e022                	sd	s0,0(sp)
    4a70:	0800                	addi	s0,sp,16
  extern int main();
  main();
    4a72:	f4dff0ef          	jal	49be <main>
  exit(0);
    4a76:	4501                	li	a0,0
    4a78:	290000ef          	jal	4d08 <exit>

0000000000004a7c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    4a7c:	1141                	addi	sp,sp,-16
    4a7e:	e406                	sd	ra,8(sp)
    4a80:	e022                	sd	s0,0(sp)
    4a82:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    4a84:	87aa                	mv	a5,a0
    4a86:	0585                	addi	a1,a1,1
    4a88:	0785                	addi	a5,a5,1
    4a8a:	fff5c703          	lbu	a4,-1(a1)
    4a8e:	fee78fa3          	sb	a4,-1(a5)
    4a92:	fb75                	bnez	a4,4a86 <strcpy+0xa>
    ;
  return os;
}
    4a94:	60a2                	ld	ra,8(sp)
    4a96:	6402                	ld	s0,0(sp)
    4a98:	0141                	addi	sp,sp,16
    4a9a:	8082                	ret

0000000000004a9c <strcmp>:

int
strcmp(const char *p, const char *q)
{
    4a9c:	1141                	addi	sp,sp,-16
    4a9e:	e406                	sd	ra,8(sp)
    4aa0:	e022                	sd	s0,0(sp)
    4aa2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    4aa4:	00054783          	lbu	a5,0(a0)
    4aa8:	cb91                	beqz	a5,4abc <strcmp+0x20>
    4aaa:	0005c703          	lbu	a4,0(a1)
    4aae:	00f71763          	bne	a4,a5,4abc <strcmp+0x20>
    p++, q++;
    4ab2:	0505                	addi	a0,a0,1
    4ab4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    4ab6:	00054783          	lbu	a5,0(a0)
    4aba:	fbe5                	bnez	a5,4aaa <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
    4abc:	0005c503          	lbu	a0,0(a1)
}
    4ac0:	40a7853b          	subw	a0,a5,a0
    4ac4:	60a2                	ld	ra,8(sp)
    4ac6:	6402                	ld	s0,0(sp)
    4ac8:	0141                	addi	sp,sp,16
    4aca:	8082                	ret

0000000000004acc <strlen>:

uint
strlen(const char *s)
{
    4acc:	1141                	addi	sp,sp,-16
    4ace:	e406                	sd	ra,8(sp)
    4ad0:	e022                	sd	s0,0(sp)
    4ad2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    4ad4:	00054783          	lbu	a5,0(a0)
    4ad8:	cf99                	beqz	a5,4af6 <strlen+0x2a>
    4ada:	0505                	addi	a0,a0,1
    4adc:	87aa                	mv	a5,a0
    4ade:	86be                	mv	a3,a5
    4ae0:	0785                	addi	a5,a5,1
    4ae2:	fff7c703          	lbu	a4,-1(a5)
    4ae6:	ff65                	bnez	a4,4ade <strlen+0x12>
    4ae8:	40a6853b          	subw	a0,a3,a0
    4aec:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    4aee:	60a2                	ld	ra,8(sp)
    4af0:	6402                	ld	s0,0(sp)
    4af2:	0141                	addi	sp,sp,16
    4af4:	8082                	ret
  for(n = 0; s[n]; n++)
    4af6:	4501                	li	a0,0
    4af8:	bfdd                	j	4aee <strlen+0x22>

0000000000004afa <memset>:

void*
memset(void *dst, int c, uint n)
{
    4afa:	1141                	addi	sp,sp,-16
    4afc:	e406                	sd	ra,8(sp)
    4afe:	e022                	sd	s0,0(sp)
    4b00:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    4b02:	ca19                	beqz	a2,4b18 <memset+0x1e>
    4b04:	87aa                	mv	a5,a0
    4b06:	1602                	slli	a2,a2,0x20
    4b08:	9201                	srli	a2,a2,0x20
    4b0a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    4b0e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    4b12:	0785                	addi	a5,a5,1
    4b14:	fee79de3          	bne	a5,a4,4b0e <memset+0x14>
  }
  return dst;
}
    4b18:	60a2                	ld	ra,8(sp)
    4b1a:	6402                	ld	s0,0(sp)
    4b1c:	0141                	addi	sp,sp,16
    4b1e:	8082                	ret

0000000000004b20 <strchr>:

char*
strchr(const char *s, char c)
{
    4b20:	1141                	addi	sp,sp,-16
    4b22:	e406                	sd	ra,8(sp)
    4b24:	e022                	sd	s0,0(sp)
    4b26:	0800                	addi	s0,sp,16
  for(; *s; s++)
    4b28:	00054783          	lbu	a5,0(a0)
    4b2c:	cf81                	beqz	a5,4b44 <strchr+0x24>
    if(*s == c)
    4b2e:	00f58763          	beq	a1,a5,4b3c <strchr+0x1c>
  for(; *s; s++)
    4b32:	0505                	addi	a0,a0,1
    4b34:	00054783          	lbu	a5,0(a0)
    4b38:	fbfd                	bnez	a5,4b2e <strchr+0xe>
      return (char*)s;
  return 0;
    4b3a:	4501                	li	a0,0
}
    4b3c:	60a2                	ld	ra,8(sp)
    4b3e:	6402                	ld	s0,0(sp)
    4b40:	0141                	addi	sp,sp,16
    4b42:	8082                	ret
  return 0;
    4b44:	4501                	li	a0,0
    4b46:	bfdd                	j	4b3c <strchr+0x1c>

0000000000004b48 <gets>:

char*
gets(char *buf, int max)
{
    4b48:	7159                	addi	sp,sp,-112
    4b4a:	f486                	sd	ra,104(sp)
    4b4c:	f0a2                	sd	s0,96(sp)
    4b4e:	eca6                	sd	s1,88(sp)
    4b50:	e8ca                	sd	s2,80(sp)
    4b52:	e4ce                	sd	s3,72(sp)
    4b54:	e0d2                	sd	s4,64(sp)
    4b56:	fc56                	sd	s5,56(sp)
    4b58:	f85a                	sd	s6,48(sp)
    4b5a:	f45e                	sd	s7,40(sp)
    4b5c:	f062                	sd	s8,32(sp)
    4b5e:	ec66                	sd	s9,24(sp)
    4b60:	e86a                	sd	s10,16(sp)
    4b62:	1880                	addi	s0,sp,112
    4b64:	8caa                	mv	s9,a0
    4b66:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    4b68:	892a                	mv	s2,a0
    4b6a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    4b6c:	f9f40b13          	addi	s6,s0,-97
    4b70:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    4b72:	4ba9                	li	s7,10
    4b74:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
    4b76:	8d26                	mv	s10,s1
    4b78:	0014899b          	addiw	s3,s1,1
    4b7c:	84ce                	mv	s1,s3
    4b7e:	0349d563          	bge	s3,s4,4ba8 <gets+0x60>
    cc = read(0, &c, 1);
    4b82:	8656                	mv	a2,s5
    4b84:	85da                	mv	a1,s6
    4b86:	4501                	li	a0,0
    4b88:	198000ef          	jal	4d20 <read>
    if(cc < 1)
    4b8c:	00a05e63          	blez	a0,4ba8 <gets+0x60>
    buf[i++] = c;
    4b90:	f9f44783          	lbu	a5,-97(s0)
    4b94:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    4b98:	01778763          	beq	a5,s7,4ba6 <gets+0x5e>
    4b9c:	0905                	addi	s2,s2,1
    4b9e:	fd879ce3          	bne	a5,s8,4b76 <gets+0x2e>
    buf[i++] = c;
    4ba2:	8d4e                	mv	s10,s3
    4ba4:	a011                	j	4ba8 <gets+0x60>
    4ba6:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
    4ba8:	9d66                	add	s10,s10,s9
    4baa:	000d0023          	sb	zero,0(s10)
  return buf;
}
    4bae:	8566                	mv	a0,s9
    4bb0:	70a6                	ld	ra,104(sp)
    4bb2:	7406                	ld	s0,96(sp)
    4bb4:	64e6                	ld	s1,88(sp)
    4bb6:	6946                	ld	s2,80(sp)
    4bb8:	69a6                	ld	s3,72(sp)
    4bba:	6a06                	ld	s4,64(sp)
    4bbc:	7ae2                	ld	s5,56(sp)
    4bbe:	7b42                	ld	s6,48(sp)
    4bc0:	7ba2                	ld	s7,40(sp)
    4bc2:	7c02                	ld	s8,32(sp)
    4bc4:	6ce2                	ld	s9,24(sp)
    4bc6:	6d42                	ld	s10,16(sp)
    4bc8:	6165                	addi	sp,sp,112
    4bca:	8082                	ret

0000000000004bcc <stat>:

int
stat(const char *n, struct stat *st)
{
    4bcc:	1101                	addi	sp,sp,-32
    4bce:	ec06                	sd	ra,24(sp)
    4bd0:	e822                	sd	s0,16(sp)
    4bd2:	e04a                	sd	s2,0(sp)
    4bd4:	1000                	addi	s0,sp,32
    4bd6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    4bd8:	4581                	li	a1,0
    4bda:	16e000ef          	jal	4d48 <open>
  if(fd < 0)
    4bde:	02054263          	bltz	a0,4c02 <stat+0x36>
    4be2:	e426                	sd	s1,8(sp)
    4be4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    4be6:	85ca                	mv	a1,s2
    4be8:	178000ef          	jal	4d60 <fstat>
    4bec:	892a                	mv	s2,a0
  close(fd);
    4bee:	8526                	mv	a0,s1
    4bf0:	140000ef          	jal	4d30 <close>
  return r;
    4bf4:	64a2                	ld	s1,8(sp)
}
    4bf6:	854a                	mv	a0,s2
    4bf8:	60e2                	ld	ra,24(sp)
    4bfa:	6442                	ld	s0,16(sp)
    4bfc:	6902                	ld	s2,0(sp)
    4bfe:	6105                	addi	sp,sp,32
    4c00:	8082                	ret
    return -1;
    4c02:	597d                	li	s2,-1
    4c04:	bfcd                	j	4bf6 <stat+0x2a>

0000000000004c06 <atoi>:

int
atoi(const char *s)
{
    4c06:	1141                	addi	sp,sp,-16
    4c08:	e406                	sd	ra,8(sp)
    4c0a:	e022                	sd	s0,0(sp)
    4c0c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    4c0e:	00054683          	lbu	a3,0(a0)
    4c12:	fd06879b          	addiw	a5,a3,-48
    4c16:	0ff7f793          	zext.b	a5,a5
    4c1a:	4625                	li	a2,9
    4c1c:	02f66963          	bltu	a2,a5,4c4e <atoi+0x48>
    4c20:	872a                	mv	a4,a0
  n = 0;
    4c22:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    4c24:	0705                	addi	a4,a4,1
    4c26:	0025179b          	slliw	a5,a0,0x2
    4c2a:	9fa9                	addw	a5,a5,a0
    4c2c:	0017979b          	slliw	a5,a5,0x1
    4c30:	9fb5                	addw	a5,a5,a3
    4c32:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    4c36:	00074683          	lbu	a3,0(a4)
    4c3a:	fd06879b          	addiw	a5,a3,-48
    4c3e:	0ff7f793          	zext.b	a5,a5
    4c42:	fef671e3          	bgeu	a2,a5,4c24 <atoi+0x1e>
  return n;
}
    4c46:	60a2                	ld	ra,8(sp)
    4c48:	6402                	ld	s0,0(sp)
    4c4a:	0141                	addi	sp,sp,16
    4c4c:	8082                	ret
  n = 0;
    4c4e:	4501                	li	a0,0
    4c50:	bfdd                	j	4c46 <atoi+0x40>

0000000000004c52 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    4c52:	1141                	addi	sp,sp,-16
    4c54:	e406                	sd	ra,8(sp)
    4c56:	e022                	sd	s0,0(sp)
    4c58:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    4c5a:	02b57563          	bgeu	a0,a1,4c84 <memmove+0x32>
    while(n-- > 0)
    4c5e:	00c05f63          	blez	a2,4c7c <memmove+0x2a>
    4c62:	1602                	slli	a2,a2,0x20
    4c64:	9201                	srli	a2,a2,0x20
    4c66:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    4c6a:	872a                	mv	a4,a0
      *dst++ = *src++;
    4c6c:	0585                	addi	a1,a1,1
    4c6e:	0705                	addi	a4,a4,1
    4c70:	fff5c683          	lbu	a3,-1(a1)
    4c74:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    4c78:	fee79ae3          	bne	a5,a4,4c6c <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    4c7c:	60a2                	ld	ra,8(sp)
    4c7e:	6402                	ld	s0,0(sp)
    4c80:	0141                	addi	sp,sp,16
    4c82:	8082                	ret
    dst += n;
    4c84:	00c50733          	add	a4,a0,a2
    src += n;
    4c88:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    4c8a:	fec059e3          	blez	a2,4c7c <memmove+0x2a>
    4c8e:	fff6079b          	addiw	a5,a2,-1 # 2fff <subdir+0x2fd>
    4c92:	1782                	slli	a5,a5,0x20
    4c94:	9381                	srli	a5,a5,0x20
    4c96:	fff7c793          	not	a5,a5
    4c9a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    4c9c:	15fd                	addi	a1,a1,-1
    4c9e:	177d                	addi	a4,a4,-1
    4ca0:	0005c683          	lbu	a3,0(a1)
    4ca4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    4ca8:	fef71ae3          	bne	a4,a5,4c9c <memmove+0x4a>
    4cac:	bfc1                	j	4c7c <memmove+0x2a>

0000000000004cae <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    4cae:	1141                	addi	sp,sp,-16
    4cb0:	e406                	sd	ra,8(sp)
    4cb2:	e022                	sd	s0,0(sp)
    4cb4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    4cb6:	ca0d                	beqz	a2,4ce8 <memcmp+0x3a>
    4cb8:	fff6069b          	addiw	a3,a2,-1
    4cbc:	1682                	slli	a3,a3,0x20
    4cbe:	9281                	srli	a3,a3,0x20
    4cc0:	0685                	addi	a3,a3,1
    4cc2:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    4cc4:	00054783          	lbu	a5,0(a0)
    4cc8:	0005c703          	lbu	a4,0(a1)
    4ccc:	00e79863          	bne	a5,a4,4cdc <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
    4cd0:	0505                	addi	a0,a0,1
    p2++;
    4cd2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    4cd4:	fed518e3          	bne	a0,a3,4cc4 <memcmp+0x16>
  }
  return 0;
    4cd8:	4501                	li	a0,0
    4cda:	a019                	j	4ce0 <memcmp+0x32>
      return *p1 - *p2;
    4cdc:	40e7853b          	subw	a0,a5,a4
}
    4ce0:	60a2                	ld	ra,8(sp)
    4ce2:	6402                	ld	s0,0(sp)
    4ce4:	0141                	addi	sp,sp,16
    4ce6:	8082                	ret
  return 0;
    4ce8:	4501                	li	a0,0
    4cea:	bfdd                	j	4ce0 <memcmp+0x32>

0000000000004cec <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    4cec:	1141                	addi	sp,sp,-16
    4cee:	e406                	sd	ra,8(sp)
    4cf0:	e022                	sd	s0,0(sp)
    4cf2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    4cf4:	f5fff0ef          	jal	4c52 <memmove>
}
    4cf8:	60a2                	ld	ra,8(sp)
    4cfa:	6402                	ld	s0,0(sp)
    4cfc:	0141                	addi	sp,sp,16
    4cfe:	8082                	ret

0000000000004d00 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    4d00:	4885                	li	a7,1
 ecall
    4d02:	00000073          	ecall
 ret
    4d06:	8082                	ret

0000000000004d08 <exit>:
.global exit
exit:
 li a7, SYS_exit
    4d08:	4889                	li	a7,2
 ecall
    4d0a:	00000073          	ecall
 ret
    4d0e:	8082                	ret

0000000000004d10 <wait>:
.global wait
wait:
 li a7, SYS_wait
    4d10:	488d                	li	a7,3
 ecall
    4d12:	00000073          	ecall
 ret
    4d16:	8082                	ret

0000000000004d18 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    4d18:	4891                	li	a7,4
 ecall
    4d1a:	00000073          	ecall
 ret
    4d1e:	8082                	ret

0000000000004d20 <read>:
.global read
read:
 li a7, SYS_read
    4d20:	4895                	li	a7,5
 ecall
    4d22:	00000073          	ecall
 ret
    4d26:	8082                	ret

0000000000004d28 <write>:
.global write
write:
 li a7, SYS_write
    4d28:	48c1                	li	a7,16
 ecall
    4d2a:	00000073          	ecall
 ret
    4d2e:	8082                	ret

0000000000004d30 <close>:
.global close
close:
 li a7, SYS_close
    4d30:	48d5                	li	a7,21
 ecall
    4d32:	00000073          	ecall
 ret
    4d36:	8082                	ret

0000000000004d38 <kill>:
.global kill
kill:
 li a7, SYS_kill
    4d38:	4899                	li	a7,6
 ecall
    4d3a:	00000073          	ecall
 ret
    4d3e:	8082                	ret

0000000000004d40 <exec>:
.global exec
exec:
 li a7, SYS_exec
    4d40:	489d                	li	a7,7
 ecall
    4d42:	00000073          	ecall
 ret
    4d46:	8082                	ret

0000000000004d48 <open>:
.global open
open:
 li a7, SYS_open
    4d48:	48bd                	li	a7,15
 ecall
    4d4a:	00000073          	ecall
 ret
    4d4e:	8082                	ret

0000000000004d50 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    4d50:	48c5                	li	a7,17
 ecall
    4d52:	00000073          	ecall
 ret
    4d56:	8082                	ret

0000000000004d58 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    4d58:	48c9                	li	a7,18
 ecall
    4d5a:	00000073          	ecall
 ret
    4d5e:	8082                	ret

0000000000004d60 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    4d60:	48a1                	li	a7,8
 ecall
    4d62:	00000073          	ecall
 ret
    4d66:	8082                	ret

0000000000004d68 <link>:
.global link
link:
 li a7, SYS_link
    4d68:	48cd                	li	a7,19
 ecall
    4d6a:	00000073          	ecall
 ret
    4d6e:	8082                	ret

0000000000004d70 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    4d70:	48d1                	li	a7,20
 ecall
    4d72:	00000073          	ecall
 ret
    4d76:	8082                	ret

0000000000004d78 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    4d78:	48a5                	li	a7,9
 ecall
    4d7a:	00000073          	ecall
 ret
    4d7e:	8082                	ret

0000000000004d80 <dup>:
.global dup
dup:
 li a7, SYS_dup
    4d80:	48a9                	li	a7,10
 ecall
    4d82:	00000073          	ecall
 ret
    4d86:	8082                	ret

0000000000004d88 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    4d88:	48ad                	li	a7,11
 ecall
    4d8a:	00000073          	ecall
 ret
    4d8e:	8082                	ret

0000000000004d90 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    4d90:	48b1                	li	a7,12
 ecall
    4d92:	00000073          	ecall
 ret
    4d96:	8082                	ret

0000000000004d98 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    4d98:	48b5                	li	a7,13
 ecall
    4d9a:	00000073          	ecall
 ret
    4d9e:	8082                	ret

0000000000004da0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    4da0:	48b9                	li	a7,14
 ecall
    4da2:	00000073          	ecall
 ret
    4da6:	8082                	ret

0000000000004da8 <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
    4da8:	48d9                	li	a7,22
 ecall
    4daa:	00000073          	ecall
 ret
    4dae:	8082                	ret

0000000000004db0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    4db0:	1101                	addi	sp,sp,-32
    4db2:	ec06                	sd	ra,24(sp)
    4db4:	e822                	sd	s0,16(sp)
    4db6:	1000                	addi	s0,sp,32
    4db8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    4dbc:	4605                	li	a2,1
    4dbe:	fef40593          	addi	a1,s0,-17
    4dc2:	f67ff0ef          	jal	4d28 <write>
}
    4dc6:	60e2                	ld	ra,24(sp)
    4dc8:	6442                	ld	s0,16(sp)
    4dca:	6105                	addi	sp,sp,32
    4dcc:	8082                	ret

0000000000004dce <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    4dce:	7139                	addi	sp,sp,-64
    4dd0:	fc06                	sd	ra,56(sp)
    4dd2:	f822                	sd	s0,48(sp)
    4dd4:	f426                	sd	s1,40(sp)
    4dd6:	f04a                	sd	s2,32(sp)
    4dd8:	ec4e                	sd	s3,24(sp)
    4dda:	0080                	addi	s0,sp,64
    4ddc:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    4dde:	c299                	beqz	a3,4de4 <printint+0x16>
    4de0:	0605ce63          	bltz	a1,4e5c <printint+0x8e>
  neg = 0;
    4de4:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
    4de6:	fc040313          	addi	t1,s0,-64
  neg = 0;
    4dea:	869a                	mv	a3,t1
  i = 0;
    4dec:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
    4dee:	00003817          	auipc	a6,0x3
    4df2:	8e280813          	addi	a6,a6,-1822 # 76d0 <digits>
    4df6:	88be                	mv	a7,a5
    4df8:	0017851b          	addiw	a0,a5,1
    4dfc:	87aa                	mv	a5,a0
    4dfe:	02c5f73b          	remuw	a4,a1,a2
    4e02:	1702                	slli	a4,a4,0x20
    4e04:	9301                	srli	a4,a4,0x20
    4e06:	9742                	add	a4,a4,a6
    4e08:	00074703          	lbu	a4,0(a4)
    4e0c:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
    4e10:	872e                	mv	a4,a1
    4e12:	02c5d5bb          	divuw	a1,a1,a2
    4e16:	0685                	addi	a3,a3,1
    4e18:	fcc77fe3          	bgeu	a4,a2,4df6 <printint+0x28>
  if(neg)
    4e1c:	000e0c63          	beqz	t3,4e34 <printint+0x66>
    buf[i++] = '-';
    4e20:	fd050793          	addi	a5,a0,-48
    4e24:	00878533          	add	a0,a5,s0
    4e28:	02d00793          	li	a5,45
    4e2c:	fef50823          	sb	a5,-16(a0)
    4e30:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
    4e34:	fff7899b          	addiw	s3,a5,-1
    4e38:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
    4e3c:	fff4c583          	lbu	a1,-1(s1)
    4e40:	854a                	mv	a0,s2
    4e42:	f6fff0ef          	jal	4db0 <putc>
  while(--i >= 0)
    4e46:	39fd                	addiw	s3,s3,-1
    4e48:	14fd                	addi	s1,s1,-1
    4e4a:	fe09d9e3          	bgez	s3,4e3c <printint+0x6e>
}
    4e4e:	70e2                	ld	ra,56(sp)
    4e50:	7442                	ld	s0,48(sp)
    4e52:	74a2                	ld	s1,40(sp)
    4e54:	7902                	ld	s2,32(sp)
    4e56:	69e2                	ld	s3,24(sp)
    4e58:	6121                	addi	sp,sp,64
    4e5a:	8082                	ret
    x = -xx;
    4e5c:	40b005bb          	negw	a1,a1
    neg = 1;
    4e60:	4e05                	li	t3,1
    x = -xx;
    4e62:	b751                	j	4de6 <printint+0x18>

0000000000004e64 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    4e64:	711d                	addi	sp,sp,-96
    4e66:	ec86                	sd	ra,88(sp)
    4e68:	e8a2                	sd	s0,80(sp)
    4e6a:	e4a6                	sd	s1,72(sp)
    4e6c:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    4e6e:	0005c483          	lbu	s1,0(a1)
    4e72:	26048663          	beqz	s1,50de <vprintf+0x27a>
    4e76:	e0ca                	sd	s2,64(sp)
    4e78:	fc4e                	sd	s3,56(sp)
    4e7a:	f852                	sd	s4,48(sp)
    4e7c:	f456                	sd	s5,40(sp)
    4e7e:	f05a                	sd	s6,32(sp)
    4e80:	ec5e                	sd	s7,24(sp)
    4e82:	e862                	sd	s8,16(sp)
    4e84:	e466                	sd	s9,8(sp)
    4e86:	8b2a                	mv	s6,a0
    4e88:	8a2e                	mv	s4,a1
    4e8a:	8bb2                	mv	s7,a2
  state = 0;
    4e8c:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
    4e8e:	4901                	li	s2,0
    4e90:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
    4e92:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
    4e96:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
    4e9a:	06c00c93          	li	s9,108
    4e9e:	a00d                	j	4ec0 <vprintf+0x5c>
        putc(fd, c0);
    4ea0:	85a6                	mv	a1,s1
    4ea2:	855a                	mv	a0,s6
    4ea4:	f0dff0ef          	jal	4db0 <putc>
    4ea8:	a019                	j	4eae <vprintf+0x4a>
    } else if(state == '%'){
    4eaa:	03598363          	beq	s3,s5,4ed0 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
    4eae:	0019079b          	addiw	a5,s2,1
    4eb2:	893e                	mv	s2,a5
    4eb4:	873e                	mv	a4,a5
    4eb6:	97d2                	add	a5,a5,s4
    4eb8:	0007c483          	lbu	s1,0(a5)
    4ebc:	20048963          	beqz	s1,50ce <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
    4ec0:	0004879b          	sext.w	a5,s1
    if(state == 0){
    4ec4:	fe0993e3          	bnez	s3,4eaa <vprintf+0x46>
      if(c0 == '%'){
    4ec8:	fd579ce3          	bne	a5,s5,4ea0 <vprintf+0x3c>
        state = '%';
    4ecc:	89be                	mv	s3,a5
    4ece:	b7c5                	j	4eae <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
    4ed0:	00ea06b3          	add	a3,s4,a4
    4ed4:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
    4ed8:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
    4eda:	c681                	beqz	a3,4ee2 <vprintf+0x7e>
    4edc:	9752                	add	a4,a4,s4
    4ede:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
    4ee2:	03878e63          	beq	a5,s8,4f1e <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
    4ee6:	05978863          	beq	a5,s9,4f36 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
    4eea:	07500713          	li	a4,117
    4eee:	0ee78263          	beq	a5,a4,4fd2 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
    4ef2:	07800713          	li	a4,120
    4ef6:	12e78463          	beq	a5,a4,501e <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
    4efa:	07000713          	li	a4,112
    4efe:	14e78963          	beq	a5,a4,5050 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
    4f02:	07300713          	li	a4,115
    4f06:	18e78863          	beq	a5,a4,5096 <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
    4f0a:	02500713          	li	a4,37
    4f0e:	04e79463          	bne	a5,a4,4f56 <vprintf+0xf2>
        putc(fd, '%');
    4f12:	85ba                	mv	a1,a4
    4f14:	855a                	mv	a0,s6
    4f16:	e9bff0ef          	jal	4db0 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
    4f1a:	4981                	li	s3,0
    4f1c:	bf49                	j	4eae <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
    4f1e:	008b8493          	addi	s1,s7,8
    4f22:	4685                	li	a3,1
    4f24:	4629                	li	a2,10
    4f26:	000ba583          	lw	a1,0(s7)
    4f2a:	855a                	mv	a0,s6
    4f2c:	ea3ff0ef          	jal	4dce <printint>
    4f30:	8ba6                	mv	s7,s1
      state = 0;
    4f32:	4981                	li	s3,0
    4f34:	bfad                	j	4eae <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
    4f36:	06400793          	li	a5,100
    4f3a:	02f68963          	beq	a3,a5,4f6c <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    4f3e:	06c00793          	li	a5,108
    4f42:	04f68263          	beq	a3,a5,4f86 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
    4f46:	07500793          	li	a5,117
    4f4a:	0af68063          	beq	a3,a5,4fea <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
    4f4e:	07800793          	li	a5,120
    4f52:	0ef68263          	beq	a3,a5,5036 <vprintf+0x1d2>
        putc(fd, '%');
    4f56:	02500593          	li	a1,37
    4f5a:	855a                	mv	a0,s6
    4f5c:	e55ff0ef          	jal	4db0 <putc>
        putc(fd, c0);
    4f60:	85a6                	mv	a1,s1
    4f62:	855a                	mv	a0,s6
    4f64:	e4dff0ef          	jal	4db0 <putc>
      state = 0;
    4f68:	4981                	li	s3,0
    4f6a:	b791                	j	4eae <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    4f6c:	008b8493          	addi	s1,s7,8
    4f70:	4685                	li	a3,1
    4f72:	4629                	li	a2,10
    4f74:	000ba583          	lw	a1,0(s7)
    4f78:	855a                	mv	a0,s6
    4f7a:	e55ff0ef          	jal	4dce <printint>
        i += 1;
    4f7e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    4f80:	8ba6                	mv	s7,s1
      state = 0;
    4f82:	4981                	li	s3,0
        i += 1;
    4f84:	b72d                	j	4eae <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    4f86:	06400793          	li	a5,100
    4f8a:	02f60763          	beq	a2,a5,4fb8 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    4f8e:	07500793          	li	a5,117
    4f92:	06f60963          	beq	a2,a5,5004 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    4f96:	07800793          	li	a5,120
    4f9a:	faf61ee3          	bne	a2,a5,4f56 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
    4f9e:	008b8493          	addi	s1,s7,8
    4fa2:	4681                	li	a3,0
    4fa4:	4641                	li	a2,16
    4fa6:	000ba583          	lw	a1,0(s7)
    4faa:	855a                	mv	a0,s6
    4fac:	e23ff0ef          	jal	4dce <printint>
        i += 2;
    4fb0:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    4fb2:	8ba6                	mv	s7,s1
      state = 0;
    4fb4:	4981                	li	s3,0
        i += 2;
    4fb6:	bde5                	j	4eae <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    4fb8:	008b8493          	addi	s1,s7,8
    4fbc:	4685                	li	a3,1
    4fbe:	4629                	li	a2,10
    4fc0:	000ba583          	lw	a1,0(s7)
    4fc4:	855a                	mv	a0,s6
    4fc6:	e09ff0ef          	jal	4dce <printint>
        i += 2;
    4fca:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    4fcc:	8ba6                	mv	s7,s1
      state = 0;
    4fce:	4981                	li	s3,0
        i += 2;
    4fd0:	bdf9                	j	4eae <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
    4fd2:	008b8493          	addi	s1,s7,8
    4fd6:	4681                	li	a3,0
    4fd8:	4629                	li	a2,10
    4fda:	000ba583          	lw	a1,0(s7)
    4fde:	855a                	mv	a0,s6
    4fe0:	defff0ef          	jal	4dce <printint>
    4fe4:	8ba6                	mv	s7,s1
      state = 0;
    4fe6:	4981                	li	s3,0
    4fe8:	b5d9                	j	4eae <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    4fea:	008b8493          	addi	s1,s7,8
    4fee:	4681                	li	a3,0
    4ff0:	4629                	li	a2,10
    4ff2:	000ba583          	lw	a1,0(s7)
    4ff6:	855a                	mv	a0,s6
    4ff8:	dd7ff0ef          	jal	4dce <printint>
        i += 1;
    4ffc:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    4ffe:	8ba6                	mv	s7,s1
      state = 0;
    5000:	4981                	li	s3,0
        i += 1;
    5002:	b575                	j	4eae <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5004:	008b8493          	addi	s1,s7,8
    5008:	4681                	li	a3,0
    500a:	4629                	li	a2,10
    500c:	000ba583          	lw	a1,0(s7)
    5010:	855a                	mv	a0,s6
    5012:	dbdff0ef          	jal	4dce <printint>
        i += 2;
    5016:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    5018:	8ba6                	mv	s7,s1
      state = 0;
    501a:	4981                	li	s3,0
        i += 2;
    501c:	bd49                	j	4eae <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
    501e:	008b8493          	addi	s1,s7,8
    5022:	4681                	li	a3,0
    5024:	4641                	li	a2,16
    5026:	000ba583          	lw	a1,0(s7)
    502a:	855a                	mv	a0,s6
    502c:	da3ff0ef          	jal	4dce <printint>
    5030:	8ba6                	mv	s7,s1
      state = 0;
    5032:	4981                	li	s3,0
    5034:	bdad                	j	4eae <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
    5036:	008b8493          	addi	s1,s7,8
    503a:	4681                	li	a3,0
    503c:	4641                	li	a2,16
    503e:	000ba583          	lw	a1,0(s7)
    5042:	855a                	mv	a0,s6
    5044:	d8bff0ef          	jal	4dce <printint>
        i += 1;
    5048:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    504a:	8ba6                	mv	s7,s1
      state = 0;
    504c:	4981                	li	s3,0
        i += 1;
    504e:	b585                	j	4eae <vprintf+0x4a>
    5050:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
    5052:	008b8d13          	addi	s10,s7,8
    5056:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    505a:	03000593          	li	a1,48
    505e:	855a                	mv	a0,s6
    5060:	d51ff0ef          	jal	4db0 <putc>
  putc(fd, 'x');
    5064:	07800593          	li	a1,120
    5068:	855a                	mv	a0,s6
    506a:	d47ff0ef          	jal	4db0 <putc>
    506e:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5070:	00002b97          	auipc	s7,0x2
    5074:	660b8b93          	addi	s7,s7,1632 # 76d0 <digits>
    5078:	03c9d793          	srli	a5,s3,0x3c
    507c:	97de                	add	a5,a5,s7
    507e:	0007c583          	lbu	a1,0(a5)
    5082:	855a                	mv	a0,s6
    5084:	d2dff0ef          	jal	4db0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5088:	0992                	slli	s3,s3,0x4
    508a:	34fd                	addiw	s1,s1,-1
    508c:	f4f5                	bnez	s1,5078 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
    508e:	8bea                	mv	s7,s10
      state = 0;
    5090:	4981                	li	s3,0
    5092:	6d02                	ld	s10,0(sp)
    5094:	bd29                	j	4eae <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
    5096:	008b8993          	addi	s3,s7,8
    509a:	000bb483          	ld	s1,0(s7)
    509e:	cc91                	beqz	s1,50ba <vprintf+0x256>
        for(; *s; s++)
    50a0:	0004c583          	lbu	a1,0(s1)
    50a4:	c195                	beqz	a1,50c8 <vprintf+0x264>
          putc(fd, *s);
    50a6:	855a                	mv	a0,s6
    50a8:	d09ff0ef          	jal	4db0 <putc>
        for(; *s; s++)
    50ac:	0485                	addi	s1,s1,1
    50ae:	0004c583          	lbu	a1,0(s1)
    50b2:	f9f5                	bnez	a1,50a6 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
    50b4:	8bce                	mv	s7,s3
      state = 0;
    50b6:	4981                	li	s3,0
    50b8:	bbdd                	j	4eae <vprintf+0x4a>
          s = "(null)";
    50ba:	00002497          	auipc	s1,0x2
    50be:	59648493          	addi	s1,s1,1430 # 7650 <malloc+0x2486>
        for(; *s; s++)
    50c2:	02800593          	li	a1,40
    50c6:	b7c5                	j	50a6 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
    50c8:	8bce                	mv	s7,s3
      state = 0;
    50ca:	4981                	li	s3,0
    50cc:	b3cd                	j	4eae <vprintf+0x4a>
    50ce:	6906                	ld	s2,64(sp)
    50d0:	79e2                	ld	s3,56(sp)
    50d2:	7a42                	ld	s4,48(sp)
    50d4:	7aa2                	ld	s5,40(sp)
    50d6:	7b02                	ld	s6,32(sp)
    50d8:	6be2                	ld	s7,24(sp)
    50da:	6c42                	ld	s8,16(sp)
    50dc:	6ca2                	ld	s9,8(sp)
    }
  }
}
    50de:	60e6                	ld	ra,88(sp)
    50e0:	6446                	ld	s0,80(sp)
    50e2:	64a6                	ld	s1,72(sp)
    50e4:	6125                	addi	sp,sp,96
    50e6:	8082                	ret

00000000000050e8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    50e8:	715d                	addi	sp,sp,-80
    50ea:	ec06                	sd	ra,24(sp)
    50ec:	e822                	sd	s0,16(sp)
    50ee:	1000                	addi	s0,sp,32
    50f0:	e010                	sd	a2,0(s0)
    50f2:	e414                	sd	a3,8(s0)
    50f4:	e818                	sd	a4,16(s0)
    50f6:	ec1c                	sd	a5,24(s0)
    50f8:	03043023          	sd	a6,32(s0)
    50fc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5100:	8622                	mv	a2,s0
    5102:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5106:	d5fff0ef          	jal	4e64 <vprintf>
}
    510a:	60e2                	ld	ra,24(sp)
    510c:	6442                	ld	s0,16(sp)
    510e:	6161                	addi	sp,sp,80
    5110:	8082                	ret

0000000000005112 <printf>:

void
printf(const char *fmt, ...)
{
    5112:	711d                	addi	sp,sp,-96
    5114:	ec06                	sd	ra,24(sp)
    5116:	e822                	sd	s0,16(sp)
    5118:	1000                	addi	s0,sp,32
    511a:	e40c                	sd	a1,8(s0)
    511c:	e810                	sd	a2,16(s0)
    511e:	ec14                	sd	a3,24(s0)
    5120:	f018                	sd	a4,32(s0)
    5122:	f41c                	sd	a5,40(s0)
    5124:	03043823          	sd	a6,48(s0)
    5128:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    512c:	00840613          	addi	a2,s0,8
    5130:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5134:	85aa                	mv	a1,a0
    5136:	4505                	li	a0,1
    5138:	d2dff0ef          	jal	4e64 <vprintf>
}
    513c:	60e2                	ld	ra,24(sp)
    513e:	6442                	ld	s0,16(sp)
    5140:	6125                	addi	sp,sp,96
    5142:	8082                	ret

0000000000005144 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5144:	1141                	addi	sp,sp,-16
    5146:	e406                	sd	ra,8(sp)
    5148:	e022                	sd	s0,0(sp)
    514a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    514c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5150:	00003797          	auipc	a5,0x3
    5154:	3007b783          	ld	a5,768(a5) # 8450 <freep>
    5158:	a02d                	j	5182 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    515a:	4618                	lw	a4,8(a2)
    515c:	9f2d                	addw	a4,a4,a1
    515e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5162:	6398                	ld	a4,0(a5)
    5164:	6310                	ld	a2,0(a4)
    5166:	a83d                	j	51a4 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    5168:	ff852703          	lw	a4,-8(a0)
    516c:	9f31                	addw	a4,a4,a2
    516e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    5170:	ff053683          	ld	a3,-16(a0)
    5174:	a091                	j	51b8 <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5176:	6398                	ld	a4,0(a5)
    5178:	00e7e463          	bltu	a5,a4,5180 <free+0x3c>
    517c:	00e6ea63          	bltu	a3,a4,5190 <free+0x4c>
{
    5180:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5182:	fed7fae3          	bgeu	a5,a3,5176 <free+0x32>
    5186:	6398                	ld	a4,0(a5)
    5188:	00e6e463          	bltu	a3,a4,5190 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    518c:	fee7eae3          	bltu	a5,a4,5180 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
    5190:	ff852583          	lw	a1,-8(a0)
    5194:	6390                	ld	a2,0(a5)
    5196:	02059813          	slli	a6,a1,0x20
    519a:	01c85713          	srli	a4,a6,0x1c
    519e:	9736                	add	a4,a4,a3
    51a0:	fae60de3          	beq	a2,a4,515a <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
    51a4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    51a8:	4790                	lw	a2,8(a5)
    51aa:	02061593          	slli	a1,a2,0x20
    51ae:	01c5d713          	srli	a4,a1,0x1c
    51b2:	973e                	add	a4,a4,a5
    51b4:	fae68ae3          	beq	a3,a4,5168 <free+0x24>
    p->s.ptr = bp->s.ptr;
    51b8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    51ba:	00003717          	auipc	a4,0x3
    51be:	28f73b23          	sd	a5,662(a4) # 8450 <freep>
}
    51c2:	60a2                	ld	ra,8(sp)
    51c4:	6402                	ld	s0,0(sp)
    51c6:	0141                	addi	sp,sp,16
    51c8:	8082                	ret

00000000000051ca <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    51ca:	7139                	addi	sp,sp,-64
    51cc:	fc06                	sd	ra,56(sp)
    51ce:	f822                	sd	s0,48(sp)
    51d0:	f04a                	sd	s2,32(sp)
    51d2:	ec4e                	sd	s3,24(sp)
    51d4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    51d6:	02051993          	slli	s3,a0,0x20
    51da:	0209d993          	srli	s3,s3,0x20
    51de:	09bd                	addi	s3,s3,15
    51e0:	0049d993          	srli	s3,s3,0x4
    51e4:	2985                	addiw	s3,s3,1
    51e6:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
    51e8:	00003517          	auipc	a0,0x3
    51ec:	26853503          	ld	a0,616(a0) # 8450 <freep>
    51f0:	c905                	beqz	a0,5220 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    51f2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    51f4:	4798                	lw	a4,8(a5)
    51f6:	09377663          	bgeu	a4,s3,5282 <malloc+0xb8>
    51fa:	f426                	sd	s1,40(sp)
    51fc:	e852                	sd	s4,16(sp)
    51fe:	e456                	sd	s5,8(sp)
    5200:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    5202:	8a4e                	mv	s4,s3
    5204:	6705                	lui	a4,0x1
    5206:	00e9f363          	bgeu	s3,a4,520c <malloc+0x42>
    520a:	6a05                	lui	s4,0x1
    520c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    5210:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    5214:	00003497          	auipc	s1,0x3
    5218:	23c48493          	addi	s1,s1,572 # 8450 <freep>
  if(p == (char*)-1)
    521c:	5afd                	li	s5,-1
    521e:	a83d                	j	525c <malloc+0x92>
    5220:	f426                	sd	s1,40(sp)
    5222:	e852                	sd	s4,16(sp)
    5224:	e456                	sd	s5,8(sp)
    5226:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    5228:	0000a797          	auipc	a5,0xa
    522c:	a5078793          	addi	a5,a5,-1456 # ec78 <base>
    5230:	00003717          	auipc	a4,0x3
    5234:	22f73023          	sd	a5,544(a4) # 8450 <freep>
    5238:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    523a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    523e:	b7d1                	j	5202 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    5240:	6398                	ld	a4,0(a5)
    5242:	e118                	sd	a4,0(a0)
    5244:	a899                	j	529a <malloc+0xd0>
  hp->s.size = nu;
    5246:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    524a:	0541                	addi	a0,a0,16
    524c:	ef9ff0ef          	jal	5144 <free>
  return freep;
    5250:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    5252:	c125                	beqz	a0,52b2 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5254:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5256:	4798                	lw	a4,8(a5)
    5258:	03277163          	bgeu	a4,s2,527a <malloc+0xb0>
    if(p == freep)
    525c:	6098                	ld	a4,0(s1)
    525e:	853e                	mv	a0,a5
    5260:	fef71ae3          	bne	a4,a5,5254 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
    5264:	8552                	mv	a0,s4
    5266:	b2bff0ef          	jal	4d90 <sbrk>
  if(p == (char*)-1)
    526a:	fd551ee3          	bne	a0,s5,5246 <malloc+0x7c>
        return 0;
    526e:	4501                	li	a0,0
    5270:	74a2                	ld	s1,40(sp)
    5272:	6a42                	ld	s4,16(sp)
    5274:	6aa2                	ld	s5,8(sp)
    5276:	6b02                	ld	s6,0(sp)
    5278:	a03d                	j	52a6 <malloc+0xdc>
    527a:	74a2                	ld	s1,40(sp)
    527c:	6a42                	ld	s4,16(sp)
    527e:	6aa2                	ld	s5,8(sp)
    5280:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    5282:	fae90fe3          	beq	s2,a4,5240 <malloc+0x76>
        p->s.size -= nunits;
    5286:	4137073b          	subw	a4,a4,s3
    528a:	c798                	sw	a4,8(a5)
        p += p->s.size;
    528c:	02071693          	slli	a3,a4,0x20
    5290:	01c6d713          	srli	a4,a3,0x1c
    5294:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    5296:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    529a:	00003717          	auipc	a4,0x3
    529e:	1aa73b23          	sd	a0,438(a4) # 8450 <freep>
      return (void*)(p + 1);
    52a2:	01078513          	addi	a0,a5,16
  }
}
    52a6:	70e2                	ld	ra,56(sp)
    52a8:	7442                	ld	s0,48(sp)
    52aa:	7902                	ld	s2,32(sp)
    52ac:	69e2                	ld	s3,24(sp)
    52ae:	6121                	addi	sp,sp,64
    52b0:	8082                	ret
    52b2:	74a2                	ld	s1,40(sp)
    52b4:	6a42                	ld	s4,16(sp)
    52b6:	6aa2                	ld	s5,8(sp)
    52b8:	6b02                	ld	s6,0(sp)
    52ba:	b7f5                	j	52a6 <malloc+0xdc>
