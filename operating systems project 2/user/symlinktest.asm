
user/_symlinktest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <stat_slink>:
}

// stat a symbolic link using O_NOFOLLOW
static int
stat_slink(char *pn, struct stat *st)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	1000                	addi	s0,sp,32
       a:	84ae                	mv	s1,a1
  int fd = open(pn, O_RDONLY | O_NOFOLLOW);
       c:	6585                	lui	a1,0x1
       e:	80058593          	addi	a1,a1,-2048 # 800 <main+0x7ca>
      12:	349000ef          	jal	b5a <open>
  if(fd < 0)
      16:	00054e63          	bltz	a0,32 <stat_slink+0x32>
    return -1;
  if(fstat(fd, st) != 0)
      1a:	85a6                	mv	a1,s1
      1c:	357000ef          	jal	b72 <fstat>
      20:	00a03533          	snez	a0,a0
      24:	40a0053b          	negw	a0,a0
    return -1;
  return 0;
}
      28:	60e2                	ld	ra,24(sp)
      2a:	6442                	ld	s0,16(sp)
      2c:	64a2                	ld	s1,8(sp)
      2e:	6105                	addi	sp,sp,32
      30:	8082                	ret
    return -1;
      32:	557d                	li	a0,-1
      34:	bfd5                	j	28 <stat_slink+0x28>

0000000000000036 <main>:
{
      36:	7131                	addi	sp,sp,-192
      38:	fd06                	sd	ra,184(sp)
      3a:	f922                	sd	s0,176(sp)
      3c:	f526                	sd	s1,168(sp)
      3e:	f14a                	sd	s2,160(sp)
      40:	ed4e                	sd	s3,152(sp)
      42:	e952                	sd	s4,144(sp)
      44:	e556                	sd	s5,136(sp)
      46:	e15a                	sd	s6,128(sp)
      48:	fcde                	sd	s7,120(sp)
      4a:	f8e2                	sd	s8,112(sp)
      4c:	0180                	addi	s0,sp,192
  unlink("/testsymlink/a");
      4e:	00001517          	auipc	a0,0x1
      52:	08250513          	addi	a0,a0,130 # 10d0 <malloc+0xf4>
      56:	315000ef          	jal	b6a <unlink>
  unlink("/testsymlink/b");
      5a:	00001517          	auipc	a0,0x1
      5e:	08e50513          	addi	a0,a0,142 # 10e8 <malloc+0x10c>
      62:	309000ef          	jal	b6a <unlink>
  unlink("/testsymlink/c");
      66:	00001517          	auipc	a0,0x1
      6a:	09250513          	addi	a0,a0,146 # 10f8 <malloc+0x11c>
      6e:	2fd000ef          	jal	b6a <unlink>
  unlink("/testsymlink/1");
      72:	00001517          	auipc	a0,0x1
      76:	09650513          	addi	a0,a0,150 # 1108 <malloc+0x12c>
      7a:	2f1000ef          	jal	b6a <unlink>
  unlink("/testsymlink/2");
      7e:	00001517          	auipc	a0,0x1
      82:	09a50513          	addi	a0,a0,154 # 1118 <malloc+0x13c>
      86:	2e5000ef          	jal	b6a <unlink>
  unlink("/testsymlink/3");
      8a:	00001517          	auipc	a0,0x1
      8e:	09e50513          	addi	a0,a0,158 # 1128 <malloc+0x14c>
      92:	2d9000ef          	jal	b6a <unlink>
  unlink("/testsymlink/4");
      96:	00001517          	auipc	a0,0x1
      9a:	0a250513          	addi	a0,a0,162 # 1138 <malloc+0x15c>
      9e:	2cd000ef          	jal	b6a <unlink>
  unlink("/testsymlink/z");
      a2:	00001517          	auipc	a0,0x1
      a6:	0a650513          	addi	a0,a0,166 # 1148 <malloc+0x16c>
      aa:	2c1000ef          	jal	b6a <unlink>
  unlink("/testsymlink/y");
      ae:	00001517          	auipc	a0,0x1
      b2:	0aa50513          	addi	a0,a0,170 # 1158 <malloc+0x17c>
      b6:	2b5000ef          	jal	b6a <unlink>
  for(int i = 0; i < NINODE+2; i++){
      ba:	4901                	li	s2,0
    memset(name, 0, sizeof(name));
      bc:	f8040a13          	addi	s4,s0,-128
      c0:	02000c13          	li	s8,32
    strcpy(name, base);
      c4:	00001997          	auipc	s3,0x1
      c8:	0a498993          	addi	s3,s3,164 # 1168 <malloc+0x18c>
    name[strlen(base)+0] = 'a' + (i / 26);
      cc:	4ec4fab7          	lui	s5,0x4ec4f
      d0:	c4fa8a93          	addi	s5,s5,-945 # 4ec4ec4f <base+0x4ec4cc3f>
    name[strlen(base)+1] = 'a' + (i % 26);
      d4:	4be9                	li	s7,26
  for(int i = 0; i < NINODE+2; i++){
      d6:	03400b13          	li	s6,52
    memset(name, 0, sizeof(name));
      da:	8662                	mv	a2,s8
      dc:	4581                	li	a1,0
      de:	8552                	mv	a0,s4
      e0:	02d000ef          	jal	90c <memset>
    strcpy(name, base);
      e4:	0009b783          	ld	a5,0(s3)
      e8:	00fa3023          	sd	a5,0(s4)
      ec:	0089a783          	lw	a5,8(s3)
      f0:	00fa2423          	sw	a5,8(s4)
      f4:	00c9d783          	lhu	a5,12(s3)
      f8:	00fa1623          	sh	a5,12(s4)
    name[strlen(base)+0] = 'a' + (i / 26);
      fc:	854e                	mv	a0,s3
      fe:	7e0000ef          	jal	8de <strlen>
     102:	1502                	slli	a0,a0,0x20
     104:	9101                	srli	a0,a0,0x20
     106:	fa050793          	addi	a5,a0,-96
     10a:	00878533          	add	a0,a5,s0
     10e:	035904b3          	mul	s1,s2,s5
     112:	948d                	srai	s1,s1,0x23
     114:	41f9579b          	sraiw	a5,s2,0x1f
     118:	9c9d                	subw	s1,s1,a5
     11a:	0614879b          	addiw	a5,s1,97
     11e:	fef50023          	sb	a5,-32(a0)
    name[strlen(base)+1] = 'a' + (i % 26);
     122:	854e                	mv	a0,s3
     124:	7ba000ef          	jal	8de <strlen>
     128:	2505                	addiw	a0,a0,1
     12a:	1502                	slli	a0,a0,0x20
     12c:	9101                	srli	a0,a0,0x20
     12e:	fa050793          	addi	a5,a0,-96
     132:	00878533          	add	a0,a5,s0
     136:	029b84bb          	mulw	s1,s7,s1
     13a:	409904bb          	subw	s1,s2,s1
     13e:	0614849b          	addiw	s1,s1,97
     142:	fe950023          	sb	s1,-32(a0)
    unlink(name);
     146:	8552                	mv	a0,s4
     148:	223000ef          	jal	b6a <unlink>
  for(int i = 0; i < NINODE+2; i++){
     14c:	2905                	addiw	s2,s2,1
     14e:	f96916e3          	bne	s2,s6,da <main+0xa4>
  unlink("/testsymlink");
     152:	00001517          	auipc	a0,0x1
     156:	02650513          	addi	a0,a0,38 # 1178 <malloc+0x19c>
     15a:	211000ef          	jal	b6a <unlink>

static void
testsymlink(void)
{
  int r, fd1 = -1, fd2 = -1;
  char buf[4] = {'a', 'b', 'c', 'd'};
     15e:	646367b7          	lui	a5,0x64636
     162:	26178793          	addi	a5,a5,609 # 64636261 <base+0x64634251>
     166:	f4f42823          	sw	a5,-176(s0)
  char c = 0, c2 = 0;
     16a:	f4040723          	sb	zero,-178(s0)
     16e:	f40407a3          	sb	zero,-177(s0)
  struct stat st;
    
  printf("Start: test symlinks\n");
     172:	00001517          	auipc	a0,0x1
     176:	01650513          	addi	a0,a0,22 # 1188 <malloc+0x1ac>
     17a:	5ab000ef          	jal	f24 <printf>

  mkdir("/testsymlink");
     17e:	00001517          	auipc	a0,0x1
     182:	ffa50513          	addi	a0,a0,-6 # 1178 <malloc+0x19c>
     186:	1fd000ef          	jal	b82 <mkdir>

  fd1 = open("/testsymlink/a", O_CREATE | O_RDWR);
     18a:	20200593          	li	a1,514
     18e:	00001517          	auipc	a0,0x1
     192:	f4250513          	addi	a0,a0,-190 # 10d0 <malloc+0xf4>
     196:	1c5000ef          	jal	b5a <open>
     19a:	84aa                	mv	s1,a0
  if(fd1 < 0) fail("failed to open a");
     19c:	0c054463          	bltz	a0,264 <main+0x22e>

  r = symlink("/testsymlink/a", "/testsymlink/b");
     1a0:	00001597          	auipc	a1,0x1
     1a4:	f4858593          	addi	a1,a1,-184 # 10e8 <malloc+0x10c>
     1a8:	00001517          	auipc	a0,0x1
     1ac:	f2850513          	addi	a0,a0,-216 # 10d0 <malloc+0xf4>
     1b0:	20b000ef          	jal	bba <symlink>
  if(r < 0)
     1b4:	0c054563          	bltz	a0,27e <main+0x248>
    fail("symlink b -> a failed");

  if(write(fd1, buf, sizeof(buf)) != 4)
     1b8:	4611                	li	a2,4
     1ba:	f5040593          	addi	a1,s0,-176
     1be:	8526                	mv	a0,s1
     1c0:	17b000ef          	jal	b3a <write>
     1c4:	4791                	li	a5,4
     1c6:	0cf50963          	beq	a0,a5,298 <main+0x262>
    fail("failed to write to a");
     1ca:	00001517          	auipc	a0,0x1
     1ce:	01650513          	addi	a0,a0,22 # 11e0 <malloc+0x204>
     1d2:	553000ef          	jal	f24 <printf>
     1d6:	4785                	li	a5,1
     1d8:	00002717          	auipc	a4,0x2
     1dc:	e2f72423          	sw	a5,-472(a4) # 2000 <failed>
  int r, fd1 = -1, fd2 = -1;
     1e0:	597d                	li	s2,-1
  close(fd1);
  fd1 = -1;

  printf("test symlinks: ok\n");
done:
  close(fd1);
     1e2:	8526                	mv	a0,s1
     1e4:	15f000ef          	jal	b42 <close>
  close(fd2);
     1e8:	854a                	mv	a0,s2
     1ea:	159000ef          	jal	b42 <close>
  int pid, i;
  int fd;
  struct stat st;
  int nchild = 2;

  printf("Start: test concurrent symlinks\n");
     1ee:	00001517          	auipc	a0,0x1
     1f2:	3da50513          	addi	a0,a0,986 # 15c8 <malloc+0x5ec>
     1f6:	52f000ef          	jal	f24 <printf>
    
  fd = open("/testsymlink/z", O_CREATE | O_RDWR);
     1fa:	20200593          	li	a1,514
     1fe:	00001517          	auipc	a0,0x1
     202:	f4a50513          	addi	a0,a0,-182 # 1148 <malloc+0x16c>
     206:	155000ef          	jal	b5a <open>
  if(fd < 0) {
     20a:	58054e63          	bltz	a0,7a6 <main+0x770>
    printf("FAILED: open failed");
    exit(1);
  }
  close(fd);
     20e:	135000ef          	jal	b42 <close>

  for(int j = 0; j < nchild; j++) {
    pid = fork();
     212:	101000ef          	jal	b12 <fork>
    if(pid < 0){
     216:	5a054263          	bltz	a0,7ba <main+0x784>
      printf("FAILED: fork failed\n");
      exit(1);
    }
    if(pid == 0) {
     21a:	5a050a63          	beqz	a0,7ce <main+0x798>
    pid = fork();
     21e:	0f5000ef          	jal	b12 <fork>
    if(pid < 0){
     222:	58054c63          	bltz	a0,7ba <main+0x784>
    if(pid == 0) {
     226:	5a050463          	beqz	a0,7ce <main+0x798>
    }
  }

  int r;
  for(int j = 0; j < nchild; j++) {
    wait(&r);
     22a:	f8040513          	addi	a0,s0,-128
     22e:	0f5000ef          	jal	b22 <wait>
    if(r != 0) {
     232:	f8042783          	lw	a5,-128(s0)
     236:	62079963          	bnez	a5,868 <main+0x832>
    wait(&r);
     23a:	f8040513          	addi	a0,s0,-128
     23e:	0e5000ef          	jal	b22 <wait>
    if(r != 0) {
     242:	f8042783          	lw	a5,-128(s0)
     246:	62079163          	bnez	a5,868 <main+0x832>
     24a:	f4e6                	sd	s9,104(sp)
      printf("test concurrent symlinks: failed\n");
      exit(1);
    }
  }
  printf("test concurrent symlinks: ok\n");
     24c:	00001517          	auipc	a0,0x1
     250:	42450513          	addi	a0,a0,1060 # 1670 <malloc+0x694>
     254:	4d1000ef          	jal	f24 <printf>
  exit(failed);
     258:	00002517          	auipc	a0,0x2
     25c:	da852503          	lw	a0,-600(a0) # 2000 <failed>
     260:	0bb000ef          	jal	b1a <exit>
  if(fd1 < 0) fail("failed to open a");
     264:	00001517          	auipc	a0,0x1
     268:	f3c50513          	addi	a0,a0,-196 # 11a0 <malloc+0x1c4>
     26c:	4b9000ef          	jal	f24 <printf>
     270:	4785                	li	a5,1
     272:	00002717          	auipc	a4,0x2
     276:	d8f72723          	sw	a5,-626(a4) # 2000 <failed>
  int r, fd1 = -1, fd2 = -1;
     27a:	597d                	li	s2,-1
  if(fd1 < 0) fail("failed to open a");
     27c:	b79d                	j	1e2 <main+0x1ac>
    fail("symlink b -> a failed");
     27e:	00001517          	auipc	a0,0x1
     282:	f4250513          	addi	a0,a0,-190 # 11c0 <malloc+0x1e4>
     286:	49f000ef          	jal	f24 <printf>
     28a:	4785                	li	a5,1
     28c:	00002717          	auipc	a4,0x2
     290:	d6f72a23          	sw	a5,-652(a4) # 2000 <failed>
  int r, fd1 = -1, fd2 = -1;
     294:	597d                	li	s2,-1
    fail("symlink b -> a failed");
     296:	b7b1                	j	1e2 <main+0x1ac>
  if (stat_slink("/testsymlink/b", &st) != 0)
     298:	f6840593          	addi	a1,s0,-152
     29c:	00001517          	auipc	a0,0x1
     2a0:	e4c50513          	addi	a0,a0,-436 # 10e8 <malloc+0x10c>
     2a4:	d5dff0ef          	jal	0 <stat_slink>
     2a8:	e11d                	bnez	a0,2ce <main+0x298>
  if(st.type != T_SYMLINK)
     2aa:	f7041703          	lh	a4,-144(s0)
     2ae:	4791                	li	a5,4
     2b0:	02f70c63          	beq	a4,a5,2e8 <main+0x2b2>
    fail("b isn't a symlink");
     2b4:	00001517          	auipc	a0,0x1
     2b8:	f6c50513          	addi	a0,a0,-148 # 1220 <malloc+0x244>
     2bc:	469000ef          	jal	f24 <printf>
     2c0:	4785                	li	a5,1
     2c2:	00002717          	auipc	a4,0x2
     2c6:	d2f72f23          	sw	a5,-706(a4) # 2000 <failed>
  int r, fd1 = -1, fd2 = -1;
     2ca:	597d                	li	s2,-1
    fail("b isn't a symlink");
     2cc:	bf19                	j	1e2 <main+0x1ac>
    fail("failed to stat b");
     2ce:	00001517          	auipc	a0,0x1
     2d2:	f3250513          	addi	a0,a0,-206 # 1200 <malloc+0x224>
     2d6:	44f000ef          	jal	f24 <printf>
     2da:	4785                	li	a5,1
     2dc:	00002717          	auipc	a4,0x2
     2e0:	d2f72223          	sw	a5,-732(a4) # 2000 <failed>
  int r, fd1 = -1, fd2 = -1;
     2e4:	597d                	li	s2,-1
    fail("failed to stat b");
     2e6:	bdf5                	j	1e2 <main+0x1ac>
  fd2 = open("/testsymlink/b", O_RDWR);
     2e8:	4589                	li	a1,2
     2ea:	00001517          	auipc	a0,0x1
     2ee:	dfe50513          	addi	a0,a0,-514 # 10e8 <malloc+0x10c>
     2f2:	069000ef          	jal	b5a <open>
     2f6:	892a                	mv	s2,a0
  if(fd2 < 0)
     2f8:	02054963          	bltz	a0,32a <main+0x2f4>
  read(fd2, &c, 1);
     2fc:	4605                	li	a2,1
     2fe:	f4e40593          	addi	a1,s0,-178
     302:	031000ef          	jal	b32 <read>
  if (c != 'a')
     306:	f4e44703          	lbu	a4,-178(s0)
     30a:	06100793          	li	a5,97
     30e:	02f70a63          	beq	a4,a5,342 <main+0x30c>
    fail("failed to read bytes from b");
     312:	00001517          	auipc	a0,0x1
     316:	f4e50513          	addi	a0,a0,-178 # 1260 <malloc+0x284>
     31a:	40b000ef          	jal	f24 <printf>
     31e:	4785                	li	a5,1
     320:	00002717          	auipc	a4,0x2
     324:	cef72023          	sw	a5,-800(a4) # 2000 <failed>
     328:	bd6d                	j	1e2 <main+0x1ac>
    fail("failed to open b");
     32a:	00001517          	auipc	a0,0x1
     32e:	f1650513          	addi	a0,a0,-234 # 1240 <malloc+0x264>
     332:	3f3000ef          	jal	f24 <printf>
     336:	4785                	li	a5,1
     338:	00002717          	auipc	a4,0x2
     33c:	ccf72423          	sw	a5,-824(a4) # 2000 <failed>
     340:	b54d                	j	1e2 <main+0x1ac>
  unlink("/testsymlink/a");
     342:	00001517          	auipc	a0,0x1
     346:	d8e50513          	addi	a0,a0,-626 # 10d0 <malloc+0xf4>
     34a:	021000ef          	jal	b6a <unlink>
  if(open("/testsymlink/b", O_RDWR) >= 0)
     34e:	4589                	li	a1,2
     350:	00001517          	auipc	a0,0x1
     354:	d9850513          	addi	a0,a0,-616 # 10e8 <malloc+0x10c>
     358:	003000ef          	jal	b5a <open>
     35c:	0e055b63          	bgez	a0,452 <main+0x41c>
  r = symlink("/testsymlink/b", "/testsymlink/a");
     360:	00001597          	auipc	a1,0x1
     364:	d7058593          	addi	a1,a1,-656 # 10d0 <malloc+0xf4>
     368:	00001517          	auipc	a0,0x1
     36c:	d8050513          	addi	a0,a0,-640 # 10e8 <malloc+0x10c>
     370:	04b000ef          	jal	bba <symlink>
  if(r < 0)
     374:	0e054b63          	bltz	a0,46a <main+0x434>
  r = open("/testsymlink/b", O_RDWR);
     378:	4589                	li	a1,2
     37a:	00001517          	auipc	a0,0x1
     37e:	d6e50513          	addi	a0,a0,-658 # 10e8 <malloc+0x10c>
     382:	7d8000ef          	jal	b5a <open>
  if(r >= 0)
     386:	0e055e63          	bgez	a0,482 <main+0x44c>
  r = symlink("/testsymlink/nonexistent", "/testsymlink/c");
     38a:	00001597          	auipc	a1,0x1
     38e:	d6e58593          	addi	a1,a1,-658 # 10f8 <malloc+0x11c>
     392:	00001517          	auipc	a0,0x1
     396:	f8e50513          	addi	a0,a0,-114 # 1320 <malloc+0x344>
     39a:	021000ef          	jal	bba <symlink>
  if(r != 0)
     39e:	0e051e63          	bnez	a0,49a <main+0x464>
  r = symlink("/testsymlink/2", "/testsymlink/1");
     3a2:	00001597          	auipc	a1,0x1
     3a6:	d6658593          	addi	a1,a1,-666 # 1108 <malloc+0x12c>
     3aa:	00001517          	auipc	a0,0x1
     3ae:	d6e50513          	addi	a0,a0,-658 # 1118 <malloc+0x13c>
     3b2:	009000ef          	jal	bba <symlink>
  if(r) fail("Failed to link 1->2");
     3b6:	0e051e63          	bnez	a0,4b2 <main+0x47c>
  r = symlink("/testsymlink/3", "/testsymlink/2");
     3ba:	00001597          	auipc	a1,0x1
     3be:	d5e58593          	addi	a1,a1,-674 # 1118 <malloc+0x13c>
     3c2:	00001517          	auipc	a0,0x1
     3c6:	d6650513          	addi	a0,a0,-666 # 1128 <malloc+0x14c>
     3ca:	7f0000ef          	jal	bba <symlink>
  if(r) fail("Failed to link 2->3");
     3ce:	0e051e63          	bnez	a0,4ca <main+0x494>
  r = symlink("/testsymlink/4", "/testsymlink/3");
     3d2:	00001597          	auipc	a1,0x1
     3d6:	d5658593          	addi	a1,a1,-682 # 1128 <malloc+0x14c>
     3da:	00001517          	auipc	a0,0x1
     3de:	d5e50513          	addi	a0,a0,-674 # 1138 <malloc+0x15c>
     3e2:	7d8000ef          	jal	bba <symlink>
     3e6:	89aa                	mv	s3,a0
  if(r) fail("Failed to link 3->4");
     3e8:	0e051d63          	bnez	a0,4e2 <main+0x4ac>
  close(fd1);
     3ec:	8526                	mv	a0,s1
     3ee:	754000ef          	jal	b42 <close>
  close(fd2);
     3f2:	854a                	mv	a0,s2
     3f4:	74e000ef          	jal	b42 <close>
  fd1 = open("/testsymlink/4", O_CREATE | O_RDWR);
     3f8:	20200593          	li	a1,514
     3fc:	00001517          	auipc	a0,0x1
     400:	d3c50513          	addi	a0,a0,-708 # 1138 <malloc+0x15c>
     404:	756000ef          	jal	b5a <open>
     408:	84aa                	mv	s1,a0
  if(fd1<0) fail("Failed to create 4\n");
     40a:	0e054863          	bltz	a0,4fa <main+0x4c4>
  fd2 = open("/testsymlink/1", O_RDWR);
     40e:	4589                	li	a1,2
     410:	00001517          	auipc	a0,0x1
     414:	cf850513          	addi	a0,a0,-776 # 1108 <malloc+0x12c>
     418:	742000ef          	jal	b5a <open>
     41c:	892a                	mv	s2,a0
  if(fd2<0) fail("Failed to open 1\n");
     41e:	0e054b63          	bltz	a0,514 <main+0x4de>
  c = '#';
     422:	02300793          	li	a5,35
     426:	f4f40723          	sb	a5,-178(s0)
  r = write(fd2, &c, 1);
     42a:	4605                	li	a2,1
     42c:	f4e40593          	addi	a1,s0,-178
     430:	70a000ef          	jal	b3a <write>
  if(r!=1) fail("Failed to write to 1\n");
     434:	4785                	li	a5,1
     436:	0ef50b63          	beq	a0,a5,52c <main+0x4f6>
     43a:	00001517          	auipc	a0,0x1
     43e:	fe650513          	addi	a0,a0,-26 # 1420 <malloc+0x444>
     442:	2e3000ef          	jal	f24 <printf>
     446:	4785                	li	a5,1
     448:	00002717          	auipc	a4,0x2
     44c:	baf72c23          	sw	a5,-1096(a4) # 2000 <failed>
     450:	bb49                	j	1e2 <main+0x1ac>
    fail("Should not be able to open b after deleting a");
     452:	00001517          	auipc	a0,0x1
     456:	e3650513          	addi	a0,a0,-458 # 1288 <malloc+0x2ac>
     45a:	2cb000ef          	jal	f24 <printf>
     45e:	4785                	li	a5,1
     460:	00002717          	auipc	a4,0x2
     464:	baf72023          	sw	a5,-1120(a4) # 2000 <failed>
     468:	bbad                	j	1e2 <main+0x1ac>
    fail("symlink a -> b failed");
     46a:	00001517          	auipc	a0,0x1
     46e:	e5650513          	addi	a0,a0,-426 # 12c0 <malloc+0x2e4>
     472:	2b3000ef          	jal	f24 <printf>
     476:	4785                	li	a5,1
     478:	00002717          	auipc	a4,0x2
     47c:	b8f72423          	sw	a5,-1144(a4) # 2000 <failed>
     480:	b38d                	j	1e2 <main+0x1ac>
    fail("Should not be able to open b (cycle b->a->b->..)\n");
     482:	00001517          	auipc	a0,0x1
     486:	e5e50513          	addi	a0,a0,-418 # 12e0 <malloc+0x304>
     48a:	29b000ef          	jal	f24 <printf>
     48e:	4785                	li	a5,1
     490:	00002717          	auipc	a4,0x2
     494:	b6f72823          	sw	a5,-1168(a4) # 2000 <failed>
     498:	b3a9                	j	1e2 <main+0x1ac>
    fail("Symlinking to nonexistent file should succeed\n");
     49a:	00001517          	auipc	a0,0x1
     49e:	ea650513          	addi	a0,a0,-346 # 1340 <malloc+0x364>
     4a2:	283000ef          	jal	f24 <printf>
     4a6:	4785                	li	a5,1
     4a8:	00002717          	auipc	a4,0x2
     4ac:	b4f72c23          	sw	a5,-1192(a4) # 2000 <failed>
     4b0:	bb0d                	j	1e2 <main+0x1ac>
  if(r) fail("Failed to link 1->2");
     4b2:	00001517          	auipc	a0,0x1
     4b6:	ece50513          	addi	a0,a0,-306 # 1380 <malloc+0x3a4>
     4ba:	26b000ef          	jal	f24 <printf>
     4be:	4785                	li	a5,1
     4c0:	00002717          	auipc	a4,0x2
     4c4:	b4f72023          	sw	a5,-1216(a4) # 2000 <failed>
     4c8:	bb29                	j	1e2 <main+0x1ac>
  if(r) fail("Failed to link 2->3");
     4ca:	00001517          	auipc	a0,0x1
     4ce:	ed650513          	addi	a0,a0,-298 # 13a0 <malloc+0x3c4>
     4d2:	253000ef          	jal	f24 <printf>
     4d6:	4785                	li	a5,1
     4d8:	00002717          	auipc	a4,0x2
     4dc:	b2f72423          	sw	a5,-1240(a4) # 2000 <failed>
     4e0:	b309                	j	1e2 <main+0x1ac>
  if(r) fail("Failed to link 3->4");
     4e2:	00001517          	auipc	a0,0x1
     4e6:	ede50513          	addi	a0,a0,-290 # 13c0 <malloc+0x3e4>
     4ea:	23b000ef          	jal	f24 <printf>
     4ee:	4785                	li	a5,1
     4f0:	00002717          	auipc	a4,0x2
     4f4:	b0f72823          	sw	a5,-1264(a4) # 2000 <failed>
     4f8:	b1ed                	j	1e2 <main+0x1ac>
  if(fd1<0) fail("Failed to create 4\n");
     4fa:	00001517          	auipc	a0,0x1
     4fe:	ee650513          	addi	a0,a0,-282 # 13e0 <malloc+0x404>
     502:	223000ef          	jal	f24 <printf>
     506:	4785                	li	a5,1
     508:	00002717          	auipc	a4,0x2
     50c:	aef72c23          	sw	a5,-1288(a4) # 2000 <failed>
  fd1 = fd2 = -1;
     510:	597d                	li	s2,-1
  if(fd1<0) fail("Failed to create 4\n");
     512:	b9c1                	j	1e2 <main+0x1ac>
  if(fd2<0) fail("Failed to open 1\n");
     514:	00001517          	auipc	a0,0x1
     518:	eec50513          	addi	a0,a0,-276 # 1400 <malloc+0x424>
     51c:	209000ef          	jal	f24 <printf>
     520:	4785                	li	a5,1
     522:	00002717          	auipc	a4,0x2
     526:	acf72f23          	sw	a5,-1314(a4) # 2000 <failed>
     52a:	b965                	j	1e2 <main+0x1ac>
  r = read(fd1, &c2, 1);
     52c:	4605                	li	a2,1
     52e:	f4f40593          	addi	a1,s0,-177
     532:	8526                	mv	a0,s1
     534:	5fe000ef          	jal	b32 <read>
  if(r!=1) fail("Failed to read from 4\n");
     538:	4785                	li	a5,1
     53a:	02f51463          	bne	a0,a5,562 <main+0x52c>
  if(c!=c2)
     53e:	f4e44703          	lbu	a4,-178(s0)
     542:	f4f44783          	lbu	a5,-177(s0)
     546:	02f70a63          	beq	a4,a5,57a <main+0x544>
    fail("Value read from 4 differed from value written to 1\n");
     54a:	00001517          	auipc	a0,0x1
     54e:	f1e50513          	addi	a0,a0,-226 # 1468 <malloc+0x48c>
     552:	1d3000ef          	jal	f24 <printf>
     556:	4785                	li	a5,1
     558:	00002717          	auipc	a4,0x2
     55c:	aaf72423          	sw	a5,-1368(a4) # 2000 <failed>
     560:	b149                	j	1e2 <main+0x1ac>
  if(r!=1) fail("Failed to read from 4\n");
     562:	00001517          	auipc	a0,0x1
     566:	ede50513          	addi	a0,a0,-290 # 1440 <malloc+0x464>
     56a:	1bb000ef          	jal	f24 <printf>
     56e:	4785                	li	a5,1
     570:	00002717          	auipc	a4,0x2
     574:	a8f72823          	sw	a5,-1392(a4) # 2000 <failed>
     578:	b1ad                	j	1e2 <main+0x1ac>
  close(fd1);
     57a:	8526                	mv	a0,s1
     57c:	5c6000ef          	jal	b42 <close>
  close(fd2);
     580:	854a                	mv	a0,s2
     582:	5c0000ef          	jal	b42 <close>
    memset(name, 0, sizeof(name));
     586:	f8040a13          	addi	s4,s0,-128
     58a:	02000c13          	li	s8,32
    strcpy(name, base);
     58e:	00001497          	auipc	s1,0x1
     592:	bda48493          	addi	s1,s1,-1062 # 1168 <malloc+0x18c>
    name[strlen(base)+0] = 'a' + (i / 26);
     596:	4ae9                	li	s5,26
    r = symlink("/testsymlink/4", name);
     598:	00001b97          	auipc	s7,0x1
     59c:	ba0b8b93          	addi	s7,s7,-1120 # 1138 <malloc+0x15c>
  for(int i = 0; i < NINODE+2; i++){
     5a0:	03400b13          	li	s6,52
    memset(name, 0, sizeof(name));
     5a4:	8662                	mv	a2,s8
     5a6:	4581                	li	a1,0
     5a8:	8552                	mv	a0,s4
     5aa:	362000ef          	jal	90c <memset>
    strcpy(name, base);
     5ae:	609c                	ld	a5,0(s1)
     5b0:	00fa3023          	sd	a5,0(s4)
     5b4:	449c                	lw	a5,8(s1)
     5b6:	00fa2423          	sw	a5,8(s4)
     5ba:	00c4d783          	lhu	a5,12(s1)
     5be:	00fa1623          	sh	a5,12(s4)
    name[strlen(base)+0] = 'a' + (i / 26);
     5c2:	8526                	mv	a0,s1
     5c4:	31a000ef          	jal	8de <strlen>
     5c8:	02051793          	slli	a5,a0,0x20
     5cc:	9381                	srli	a5,a5,0x20
     5ce:	fa078793          	addi	a5,a5,-96
     5d2:	97a2                	add	a5,a5,s0
     5d4:	0359c73b          	divw	a4,s3,s5
     5d8:	0617071b          	addiw	a4,a4,97
     5dc:	fee78023          	sb	a4,-32(a5)
    name[strlen(base)+1] = 'a' + (i % 26);
     5e0:	8526                	mv	a0,s1
     5e2:	2fc000ef          	jal	8de <strlen>
     5e6:	0015079b          	addiw	a5,a0,1
     5ea:	1782                	slli	a5,a5,0x20
     5ec:	9381                	srli	a5,a5,0x20
     5ee:	fa078793          	addi	a5,a5,-96
     5f2:	97a2                	add	a5,a5,s0
     5f4:	0359e73b          	remw	a4,s3,s5
     5f8:	0617071b          	addiw	a4,a4,97
     5fc:	fee78023          	sb	a4,-32(a5)
    r = symlink("/testsymlink/4", name);
     600:	85d2                	mv	a1,s4
     602:	855e                	mv	a0,s7
     604:	5b6000ef          	jal	bba <symlink>
     608:	892a                	mv	s2,a0
    if(r) fail("symlink() failed in many test");
     60a:	10051763          	bnez	a0,718 <main+0x6e2>
  for(int i = 0; i < NINODE+2; i++){
     60e:	2985                	addiw	s3,s3,1
     610:	f9699ae3          	bne	s3,s6,5a4 <main+0x56e>
     614:	f4e6                	sd	s9,104(sp)
    memset(name, 0, sizeof(name));
     616:	f8040a13          	addi	s4,s0,-128
     61a:	02000c93          	li	s9,32
    strcpy(name, base);
     61e:	00001997          	auipc	s3,0x1
     622:	b4a98993          	addi	s3,s3,-1206 # 1168 <malloc+0x18c>
    name[strlen(base)+0] = 'a' + (i / 26);
     626:	4ae9                	li	s5,26
    if(read(fd1, buf, sizeof(buf)) != 1)
     628:	f5840c13          	addi	s8,s0,-168
     62c:	4bc1                	li	s7,16
     62e:	4b05                	li	s6,1
    memset(name, 0, sizeof(name));
     630:	8666                	mv	a2,s9
     632:	4581                	li	a1,0
     634:	8552                	mv	a0,s4
     636:	2d6000ef          	jal	90c <memset>
    strcpy(name, base);
     63a:	0009b783          	ld	a5,0(s3)
     63e:	00fa3023          	sd	a5,0(s4)
     642:	0089a783          	lw	a5,8(s3)
     646:	00fa2423          	sw	a5,8(s4)
     64a:	00c9d783          	lhu	a5,12(s3)
     64e:	00fa1623          	sh	a5,12(s4)
    name[strlen(base)+0] = 'a' + (i / 26);
     652:	854e                	mv	a0,s3
     654:	28a000ef          	jal	8de <strlen>
     658:	02051793          	slli	a5,a0,0x20
     65c:	9381                	srli	a5,a5,0x20
     65e:	fa078793          	addi	a5,a5,-96
     662:	97a2                	add	a5,a5,s0
     664:	0359473b          	divw	a4,s2,s5
     668:	0617071b          	addiw	a4,a4,97
     66c:	fee78023          	sb	a4,-32(a5)
    name[strlen(base)+1] = 'a' + (i % 26);
     670:	854e                	mv	a0,s3
     672:	26c000ef          	jal	8de <strlen>
     676:	0015079b          	addiw	a5,a0,1
     67a:	1782                	slli	a5,a5,0x20
     67c:	9381                	srli	a5,a5,0x20
     67e:	fa078793          	addi	a5,a5,-96
     682:	97a2                	add	a5,a5,s0
     684:	0359673b          	remw	a4,s2,s5
     688:	0617071b          	addiw	a4,a4,97
     68c:	fee78023          	sb	a4,-32(a5)
    fd1 = open(name, O_RDONLY);
     690:	4581                	li	a1,0
     692:	8552                	mv	a0,s4
     694:	4c6000ef          	jal	b5a <open>
     698:	84aa                	mv	s1,a0
    if(fd1 < 0)
     69a:	08054d63          	bltz	a0,734 <main+0x6fe>
    buf[0] = '\0';
     69e:	f4040c23          	sb	zero,-168(s0)
    if(read(fd1, buf, sizeof(buf)) != 1)
     6a2:	865e                	mv	a2,s7
     6a4:	85e2                	mv	a1,s8
     6a6:	48c000ef          	jal	b32 <read>
     6aa:	0b651363          	bne	a0,s6,750 <main+0x71a>
    if(buf[0] != '#')
     6ae:	f5844703          	lbu	a4,-168(s0)
     6b2:	02300793          	li	a5,35
     6b6:	0af71463          	bne	a4,a5,75e <main+0x728>
    close(fd1);
     6ba:	8526                	mv	a0,s1
     6bc:	486000ef          	jal	b42 <close>
  for(int i = 0; i < NINODE+2; i++){
     6c0:	2905                	addiw	s2,s2,1
     6c2:	03400793          	li	a5,52
     6c6:	f6f915e3          	bne	s2,a5,630 <main+0x5fa>
  unlink("/testsymlink/a");
     6ca:	00001517          	auipc	a0,0x1
     6ce:	a0650513          	addi	a0,a0,-1530 # 10d0 <malloc+0xf4>
     6d2:	498000ef          	jal	b6a <unlink>
  if(symlink("/README", "/testsymlink/a") != 0)
     6d6:	00001597          	auipc	a1,0x1
     6da:	9fa58593          	addi	a1,a1,-1542 # 10d0 <malloc+0xf4>
     6de:	00001517          	auipc	a0,0x1
     6e2:	e6a50513          	addi	a0,a0,-406 # 1548 <malloc+0x56c>
     6e6:	4d4000ef          	jal	bba <symlink>
     6ea:	e149                	bnez	a0,76c <main+0x736>
  fd1 = open("/testsymlink/a", O_RDONLY);
     6ec:	4581                	li	a1,0
     6ee:	00001517          	auipc	a0,0x1
     6f2:	9e250513          	addi	a0,a0,-1566 # 10d0 <malloc+0xf4>
     6f6:	464000ef          	jal	b5a <open>
     6fa:	84aa                	mv	s1,a0
  if(fd1 < 0)
     6fc:	08054763          	bltz	a0,78a <main+0x754>
  close(fd1);
     700:	442000ef          	jal	b42 <close>
  printf("test symlinks: ok\n");
     704:	00001517          	auipc	a0,0x1
     708:	eac50513          	addi	a0,a0,-340 # 15b0 <malloc+0x5d4>
     70c:	019000ef          	jal	f24 <printf>
  fd1 = fd2 = -1;
     710:	54fd                	li	s1,-1
  fd1 = -1;
     712:	8926                	mv	s2,s1
     714:	7ca6                	ld	s9,104(sp)
     716:	b4f1                	j	1e2 <main+0x1ac>
    if(r) fail("symlink() failed in many test");
     718:	00001517          	auipc	a0,0x1
     71c:	d9050513          	addi	a0,a0,-624 # 14a8 <malloc+0x4cc>
     720:	005000ef          	jal	f24 <printf>
     724:	4785                	li	a5,1
     726:	00002717          	auipc	a4,0x2
     72a:	8cf72d23          	sw	a5,-1830(a4) # 2000 <failed>
  fd1 = fd2 = -1;
     72e:	597d                	li	s2,-1
     730:	84ca                	mv	s1,s2
     732:	bc45                	j	1e2 <main+0x1ac>
      fail("open() failed in many test");
     734:	00001517          	auipc	a0,0x1
     738:	d9c50513          	addi	a0,a0,-612 # 14d0 <malloc+0x4f4>
     73c:	7e8000ef          	jal	f24 <printf>
     740:	4785                	li	a5,1
     742:	00002717          	auipc	a4,0x2
     746:	8af72f23          	sw	a5,-1858(a4) # 2000 <failed>
  fd1 = fd2 = -1;
     74a:	597d                	li	s2,-1
     74c:	7ca6                	ld	s9,104(sp)
     74e:	bc51                	j	1e2 <main+0x1ac>
      fail("read() failed in many test");
     750:	00001517          	auipc	a0,0x1
     754:	da850513          	addi	a0,a0,-600 # 14f8 <malloc+0x51c>
     758:	7cc000ef          	jal	f24 <printf>
     75c:	b7d5                	j	740 <main+0x70a>
      fail("wrong content in many test");
     75e:	00001517          	auipc	a0,0x1
     762:	dc250513          	addi	a0,a0,-574 # 1520 <malloc+0x544>
     766:	7be000ef          	jal	f24 <printf>
     76a:	bfd9                	j	740 <main+0x70a>
    fail("could not link to /README");
     76c:	00001517          	auipc	a0,0x1
     770:	de450513          	addi	a0,a0,-540 # 1550 <malloc+0x574>
     774:	7b0000ef          	jal	f24 <printf>
     778:	4785                	li	a5,1
     77a:	00002717          	auipc	a4,0x2
     77e:	88f72323          	sw	a5,-1914(a4) # 2000 <failed>
  fd1 = fd2 = -1;
     782:	597d                	li	s2,-1
    fail("could not link to /README");
     784:	84ca                	mv	s1,s2
     786:	7ca6                	ld	s9,104(sp)
     788:	bca9                	j	1e2 <main+0x1ac>
    fail("could not open symlink pointing to /README");
     78a:	00001517          	auipc	a0,0x1
     78e:	dee50513          	addi	a0,a0,-530 # 1578 <malloc+0x59c>
     792:	792000ef          	jal	f24 <printf>
     796:	4785                	li	a5,1
     798:	00002717          	auipc	a4,0x2
     79c:	86f72423          	sw	a5,-1944(a4) # 2000 <failed>
  fd1 = fd2 = -1;
     7a0:	597d                	li	s2,-1
    fail("could not open symlink pointing to /README");
     7a2:	7ca6                	ld	s9,104(sp)
     7a4:	bc3d                	j	1e2 <main+0x1ac>
     7a6:	f4e6                	sd	s9,104(sp)
    printf("FAILED: open failed");
     7a8:	00001517          	auipc	a0,0x1
     7ac:	e4850513          	addi	a0,a0,-440 # 15f0 <malloc+0x614>
     7b0:	774000ef          	jal	f24 <printf>
    exit(1);
     7b4:	4505                	li	a0,1
     7b6:	364000ef          	jal	b1a <exit>
     7ba:	f4e6                	sd	s9,104(sp)
      printf("FAILED: fork failed\n");
     7bc:	00001517          	auipc	a0,0x1
     7c0:	e4c50513          	addi	a0,a0,-436 # 1608 <malloc+0x62c>
     7c4:	760000ef          	jal	f24 <printf>
      exit(1);
     7c8:	4505                	li	a0,1
     7ca:	350000ef          	jal	b1a <exit>
     7ce:	f4e6                	sd	s9,104(sp)
  fd1 = -1;
     7d0:	06400493          	li	s1,100
      unsigned int x = (pid ? 1 : 97);
     7d4:	06100c93          	li	s9,97
        x = x * 1103515245 + 12345;
     7d8:	41c65ab7          	lui	s5,0x41c65
     7dc:	e6da8a9b          	addiw	s5,s5,-403 # 41c64e6d <base+0x41c62e5d>
     7e0:	6a0d                	lui	s4,0x3
     7e2:	039a0a1b          	addiw	s4,s4,57 # 3039 <base+0x1029>
        if((x % 3) == 0) {
     7e6:	000ab9b7          	lui	s3,0xab
     7ea:	aab98993          	addi	s3,s3,-1365 # aaaab <base+0xa8a9b>
     7ee:	09b2                	slli	s3,s3,0xc
     7f0:	aab98993          	addi	s3,s3,-1365
          unlink("/testsymlink/y");
     7f4:	00001917          	auipc	s2,0x1
     7f8:	96490913          	addi	s2,s2,-1692 # 1158 <malloc+0x17c>
          symlink("/testsymlink/z", "/testsymlink/y");
     7fc:	00001b97          	auipc	s7,0x1
     800:	94cb8b93          	addi	s7,s7,-1716 # 1148 <malloc+0x16c>
          if (stat_slink("/testsymlink/y", &st) == 0) {
     804:	f8040b13          	addi	s6,s0,-128
            if(st.type != T_SYMLINK) {
     808:	4c11                	li	s8,4
     80a:	a031                	j	816 <main+0x7e0>
          unlink("/testsymlink/y");
     80c:	854a                	mv	a0,s2
     80e:	35c000ef          	jal	b6a <unlink>
      for(i = 0; i < 100; i++){
     812:	34fd                	addiw	s1,s1,-1
     814:	c4b9                	beqz	s1,862 <main+0x82c>
        x = x * 1103515245 + 12345;
     816:	035c87bb          	mulw	a5,s9,s5
     81a:	00fa07bb          	addw	a5,s4,a5
     81e:	8cbe                	mv	s9,a5
        if((x % 3) == 0) {
     820:	02079713          	slli	a4,a5,0x20
     824:	9301                	srli	a4,a4,0x20
     826:	03370733          	mul	a4,a4,s3
     82a:	9305                	srli	a4,a4,0x21
     82c:	0017169b          	slliw	a3,a4,0x1
     830:	9f35                	addw	a4,a4,a3
     832:	9f99                	subw	a5,a5,a4
     834:	ffe1                	bnez	a5,80c <main+0x7d6>
          symlink("/testsymlink/z", "/testsymlink/y");
     836:	85ca                	mv	a1,s2
     838:	855e                	mv	a0,s7
     83a:	380000ef          	jal	bba <symlink>
          if (stat_slink("/testsymlink/y", &st) == 0) {
     83e:	85da                	mv	a1,s6
     840:	854a                	mv	a0,s2
     842:	fbeff0ef          	jal	0 <stat_slink>
     846:	f571                	bnez	a0,812 <main+0x7dc>
            if(st.type != T_SYMLINK) {
     848:	f8841583          	lh	a1,-120(s0)
     84c:	fd8583e3          	beq	a1,s8,812 <main+0x7dc>
              printf("FAILED: type %d not a symbolic link\n", st.type);
     850:	00001517          	auipc	a0,0x1
     854:	dd050513          	addi	a0,a0,-560 # 1620 <malloc+0x644>
     858:	6cc000ef          	jal	f24 <printf>
              exit(1);
     85c:	4505                	li	a0,1
     85e:	2bc000ef          	jal	b1a <exit>
      exit(0);
     862:	4501                	li	a0,0
     864:	2b6000ef          	jal	b1a <exit>
     868:	f4e6                	sd	s9,104(sp)
      printf("test concurrent symlinks: failed\n");
     86a:	00001517          	auipc	a0,0x1
     86e:	dde50513          	addi	a0,a0,-546 # 1648 <malloc+0x66c>
     872:	6b2000ef          	jal	f24 <printf>
      exit(1);
     876:	4505                	li	a0,1
     878:	2a2000ef          	jal	b1a <exit>

000000000000087c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
     87c:	1141                	addi	sp,sp,-16
     87e:	e406                	sd	ra,8(sp)
     880:	e022                	sd	s0,0(sp)
     882:	0800                	addi	s0,sp,16
  extern int main();
  main();
     884:	fb2ff0ef          	jal	36 <main>
  exit(0);
     888:	4501                	li	a0,0
     88a:	290000ef          	jal	b1a <exit>

000000000000088e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     88e:	1141                	addi	sp,sp,-16
     890:	e406                	sd	ra,8(sp)
     892:	e022                	sd	s0,0(sp)
     894:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     896:	87aa                	mv	a5,a0
     898:	0585                	addi	a1,a1,1
     89a:	0785                	addi	a5,a5,1
     89c:	fff5c703          	lbu	a4,-1(a1)
     8a0:	fee78fa3          	sb	a4,-1(a5)
     8a4:	fb75                	bnez	a4,898 <strcpy+0xa>
    ;
  return os;
}
     8a6:	60a2                	ld	ra,8(sp)
     8a8:	6402                	ld	s0,0(sp)
     8aa:	0141                	addi	sp,sp,16
     8ac:	8082                	ret

00000000000008ae <strcmp>:

int
strcmp(const char *p, const char *q)
{
     8ae:	1141                	addi	sp,sp,-16
     8b0:	e406                	sd	ra,8(sp)
     8b2:	e022                	sd	s0,0(sp)
     8b4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     8b6:	00054783          	lbu	a5,0(a0)
     8ba:	cb91                	beqz	a5,8ce <strcmp+0x20>
     8bc:	0005c703          	lbu	a4,0(a1)
     8c0:	00f71763          	bne	a4,a5,8ce <strcmp+0x20>
    p++, q++;
     8c4:	0505                	addi	a0,a0,1
     8c6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     8c8:	00054783          	lbu	a5,0(a0)
     8cc:	fbe5                	bnez	a5,8bc <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
     8ce:	0005c503          	lbu	a0,0(a1)
}
     8d2:	40a7853b          	subw	a0,a5,a0
     8d6:	60a2                	ld	ra,8(sp)
     8d8:	6402                	ld	s0,0(sp)
     8da:	0141                	addi	sp,sp,16
     8dc:	8082                	ret

00000000000008de <strlen>:

uint
strlen(const char *s)
{
     8de:	1141                	addi	sp,sp,-16
     8e0:	e406                	sd	ra,8(sp)
     8e2:	e022                	sd	s0,0(sp)
     8e4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     8e6:	00054783          	lbu	a5,0(a0)
     8ea:	cf99                	beqz	a5,908 <strlen+0x2a>
     8ec:	0505                	addi	a0,a0,1
     8ee:	87aa                	mv	a5,a0
     8f0:	86be                	mv	a3,a5
     8f2:	0785                	addi	a5,a5,1
     8f4:	fff7c703          	lbu	a4,-1(a5)
     8f8:	ff65                	bnez	a4,8f0 <strlen+0x12>
     8fa:	40a6853b          	subw	a0,a3,a0
     8fe:	2505                	addiw	a0,a0,1
    ;
  return n;
}
     900:	60a2                	ld	ra,8(sp)
     902:	6402                	ld	s0,0(sp)
     904:	0141                	addi	sp,sp,16
     906:	8082                	ret
  for(n = 0; s[n]; n++)
     908:	4501                	li	a0,0
     90a:	bfdd                	j	900 <strlen+0x22>

000000000000090c <memset>:

void*
memset(void *dst, int c, uint n)
{
     90c:	1141                	addi	sp,sp,-16
     90e:	e406                	sd	ra,8(sp)
     910:	e022                	sd	s0,0(sp)
     912:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     914:	ca19                	beqz	a2,92a <memset+0x1e>
     916:	87aa                	mv	a5,a0
     918:	1602                	slli	a2,a2,0x20
     91a:	9201                	srli	a2,a2,0x20
     91c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     920:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     924:	0785                	addi	a5,a5,1
     926:	fee79de3          	bne	a5,a4,920 <memset+0x14>
  }
  return dst;
}
     92a:	60a2                	ld	ra,8(sp)
     92c:	6402                	ld	s0,0(sp)
     92e:	0141                	addi	sp,sp,16
     930:	8082                	ret

0000000000000932 <strchr>:

char*
strchr(const char *s, char c)
{
     932:	1141                	addi	sp,sp,-16
     934:	e406                	sd	ra,8(sp)
     936:	e022                	sd	s0,0(sp)
     938:	0800                	addi	s0,sp,16
  for(; *s; s++)
     93a:	00054783          	lbu	a5,0(a0)
     93e:	cf81                	beqz	a5,956 <strchr+0x24>
    if(*s == c)
     940:	00f58763          	beq	a1,a5,94e <strchr+0x1c>
  for(; *s; s++)
     944:	0505                	addi	a0,a0,1
     946:	00054783          	lbu	a5,0(a0)
     94a:	fbfd                	bnez	a5,940 <strchr+0xe>
      return (char*)s;
  return 0;
     94c:	4501                	li	a0,0
}
     94e:	60a2                	ld	ra,8(sp)
     950:	6402                	ld	s0,0(sp)
     952:	0141                	addi	sp,sp,16
     954:	8082                	ret
  return 0;
     956:	4501                	li	a0,0
     958:	bfdd                	j	94e <strchr+0x1c>

000000000000095a <gets>:

char*
gets(char *buf, int max)
{
     95a:	7159                	addi	sp,sp,-112
     95c:	f486                	sd	ra,104(sp)
     95e:	f0a2                	sd	s0,96(sp)
     960:	eca6                	sd	s1,88(sp)
     962:	e8ca                	sd	s2,80(sp)
     964:	e4ce                	sd	s3,72(sp)
     966:	e0d2                	sd	s4,64(sp)
     968:	fc56                	sd	s5,56(sp)
     96a:	f85a                	sd	s6,48(sp)
     96c:	f45e                	sd	s7,40(sp)
     96e:	f062                	sd	s8,32(sp)
     970:	ec66                	sd	s9,24(sp)
     972:	e86a                	sd	s10,16(sp)
     974:	1880                	addi	s0,sp,112
     976:	8caa                	mv	s9,a0
     978:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     97a:	892a                	mv	s2,a0
     97c:	4481                	li	s1,0
    cc = read(0, &c, 1);
     97e:	f9f40b13          	addi	s6,s0,-97
     982:	4a85                	li	s5,1
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     984:	4ba9                	li	s7,10
     986:	4c35                	li	s8,13
  for(i=0; i+1 < max; ){
     988:	8d26                	mv	s10,s1
     98a:	0014899b          	addiw	s3,s1,1
     98e:	84ce                	mv	s1,s3
     990:	0349d563          	bge	s3,s4,9ba <gets+0x60>
    cc = read(0, &c, 1);
     994:	8656                	mv	a2,s5
     996:	85da                	mv	a1,s6
     998:	4501                	li	a0,0
     99a:	198000ef          	jal	b32 <read>
    if(cc < 1)
     99e:	00a05e63          	blez	a0,9ba <gets+0x60>
    buf[i++] = c;
     9a2:	f9f44783          	lbu	a5,-97(s0)
     9a6:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     9aa:	01778763          	beq	a5,s7,9b8 <gets+0x5e>
     9ae:	0905                	addi	s2,s2,1
     9b0:	fd879ce3          	bne	a5,s8,988 <gets+0x2e>
    buf[i++] = c;
     9b4:	8d4e                	mv	s10,s3
     9b6:	a011                	j	9ba <gets+0x60>
     9b8:	8d4e                	mv	s10,s3
      break;
  }
  buf[i] = '\0';
     9ba:	9d66                	add	s10,s10,s9
     9bc:	000d0023          	sb	zero,0(s10)
  return buf;
}
     9c0:	8566                	mv	a0,s9
     9c2:	70a6                	ld	ra,104(sp)
     9c4:	7406                	ld	s0,96(sp)
     9c6:	64e6                	ld	s1,88(sp)
     9c8:	6946                	ld	s2,80(sp)
     9ca:	69a6                	ld	s3,72(sp)
     9cc:	6a06                	ld	s4,64(sp)
     9ce:	7ae2                	ld	s5,56(sp)
     9d0:	7b42                	ld	s6,48(sp)
     9d2:	7ba2                	ld	s7,40(sp)
     9d4:	7c02                	ld	s8,32(sp)
     9d6:	6ce2                	ld	s9,24(sp)
     9d8:	6d42                	ld	s10,16(sp)
     9da:	6165                	addi	sp,sp,112
     9dc:	8082                	ret

00000000000009de <stat>:

int
stat(const char *n, struct stat *st)
{
     9de:	1101                	addi	sp,sp,-32
     9e0:	ec06                	sd	ra,24(sp)
     9e2:	e822                	sd	s0,16(sp)
     9e4:	e04a                	sd	s2,0(sp)
     9e6:	1000                	addi	s0,sp,32
     9e8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     9ea:	4581                	li	a1,0
     9ec:	16e000ef          	jal	b5a <open>
  if(fd < 0)
     9f0:	02054263          	bltz	a0,a14 <stat+0x36>
     9f4:	e426                	sd	s1,8(sp)
     9f6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     9f8:	85ca                	mv	a1,s2
     9fa:	178000ef          	jal	b72 <fstat>
     9fe:	892a                	mv	s2,a0
  close(fd);
     a00:	8526                	mv	a0,s1
     a02:	140000ef          	jal	b42 <close>
  return r;
     a06:	64a2                	ld	s1,8(sp)
}
     a08:	854a                	mv	a0,s2
     a0a:	60e2                	ld	ra,24(sp)
     a0c:	6442                	ld	s0,16(sp)
     a0e:	6902                	ld	s2,0(sp)
     a10:	6105                	addi	sp,sp,32
     a12:	8082                	ret
    return -1;
     a14:	597d                	li	s2,-1
     a16:	bfcd                	j	a08 <stat+0x2a>

0000000000000a18 <atoi>:

int
atoi(const char *s)
{
     a18:	1141                	addi	sp,sp,-16
     a1a:	e406                	sd	ra,8(sp)
     a1c:	e022                	sd	s0,0(sp)
     a1e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     a20:	00054683          	lbu	a3,0(a0)
     a24:	fd06879b          	addiw	a5,a3,-48
     a28:	0ff7f793          	zext.b	a5,a5
     a2c:	4625                	li	a2,9
     a2e:	02f66963          	bltu	a2,a5,a60 <atoi+0x48>
     a32:	872a                	mv	a4,a0
  n = 0;
     a34:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     a36:	0705                	addi	a4,a4,1
     a38:	0025179b          	slliw	a5,a0,0x2
     a3c:	9fa9                	addw	a5,a5,a0
     a3e:	0017979b          	slliw	a5,a5,0x1
     a42:	9fb5                	addw	a5,a5,a3
     a44:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     a48:	00074683          	lbu	a3,0(a4)
     a4c:	fd06879b          	addiw	a5,a3,-48
     a50:	0ff7f793          	zext.b	a5,a5
     a54:	fef671e3          	bgeu	a2,a5,a36 <atoi+0x1e>
  return n;
}
     a58:	60a2                	ld	ra,8(sp)
     a5a:	6402                	ld	s0,0(sp)
     a5c:	0141                	addi	sp,sp,16
     a5e:	8082                	ret
  n = 0;
     a60:	4501                	li	a0,0
     a62:	bfdd                	j	a58 <atoi+0x40>

0000000000000a64 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     a64:	1141                	addi	sp,sp,-16
     a66:	e406                	sd	ra,8(sp)
     a68:	e022                	sd	s0,0(sp)
     a6a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     a6c:	02b57563          	bgeu	a0,a1,a96 <memmove+0x32>
    while(n-- > 0)
     a70:	00c05f63          	blez	a2,a8e <memmove+0x2a>
     a74:	1602                	slli	a2,a2,0x20
     a76:	9201                	srli	a2,a2,0x20
     a78:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     a7c:	872a                	mv	a4,a0
      *dst++ = *src++;
     a7e:	0585                	addi	a1,a1,1
     a80:	0705                	addi	a4,a4,1
     a82:	fff5c683          	lbu	a3,-1(a1)
     a86:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     a8a:	fee79ae3          	bne	a5,a4,a7e <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     a8e:	60a2                	ld	ra,8(sp)
     a90:	6402                	ld	s0,0(sp)
     a92:	0141                	addi	sp,sp,16
     a94:	8082                	ret
    dst += n;
     a96:	00c50733          	add	a4,a0,a2
    src += n;
     a9a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     a9c:	fec059e3          	blez	a2,a8e <memmove+0x2a>
     aa0:	fff6079b          	addiw	a5,a2,-1
     aa4:	1782                	slli	a5,a5,0x20
     aa6:	9381                	srli	a5,a5,0x20
     aa8:	fff7c793          	not	a5,a5
     aac:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     aae:	15fd                	addi	a1,a1,-1
     ab0:	177d                	addi	a4,a4,-1
     ab2:	0005c683          	lbu	a3,0(a1)
     ab6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     aba:	fef71ae3          	bne	a4,a5,aae <memmove+0x4a>
     abe:	bfc1                	j	a8e <memmove+0x2a>

0000000000000ac0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     ac0:	1141                	addi	sp,sp,-16
     ac2:	e406                	sd	ra,8(sp)
     ac4:	e022                	sd	s0,0(sp)
     ac6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     ac8:	ca0d                	beqz	a2,afa <memcmp+0x3a>
     aca:	fff6069b          	addiw	a3,a2,-1
     ace:	1682                	slli	a3,a3,0x20
     ad0:	9281                	srli	a3,a3,0x20
     ad2:	0685                	addi	a3,a3,1
     ad4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     ad6:	00054783          	lbu	a5,0(a0)
     ada:	0005c703          	lbu	a4,0(a1)
     ade:	00e79863          	bne	a5,a4,aee <memcmp+0x2e>
      return *p1 - *p2;
    }
    p1++;
     ae2:	0505                	addi	a0,a0,1
    p2++;
     ae4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     ae6:	fed518e3          	bne	a0,a3,ad6 <memcmp+0x16>
  }
  return 0;
     aea:	4501                	li	a0,0
     aec:	a019                	j	af2 <memcmp+0x32>
      return *p1 - *p2;
     aee:	40e7853b          	subw	a0,a5,a4
}
     af2:	60a2                	ld	ra,8(sp)
     af4:	6402                	ld	s0,0(sp)
     af6:	0141                	addi	sp,sp,16
     af8:	8082                	ret
  return 0;
     afa:	4501                	li	a0,0
     afc:	bfdd                	j	af2 <memcmp+0x32>

0000000000000afe <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     afe:	1141                	addi	sp,sp,-16
     b00:	e406                	sd	ra,8(sp)
     b02:	e022                	sd	s0,0(sp)
     b04:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     b06:	f5fff0ef          	jal	a64 <memmove>
}
     b0a:	60a2                	ld	ra,8(sp)
     b0c:	6402                	ld	s0,0(sp)
     b0e:	0141                	addi	sp,sp,16
     b10:	8082                	ret

0000000000000b12 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     b12:	4885                	li	a7,1
 ecall
     b14:	00000073          	ecall
 ret
     b18:	8082                	ret

0000000000000b1a <exit>:
.global exit
exit:
 li a7, SYS_exit
     b1a:	4889                	li	a7,2
 ecall
     b1c:	00000073          	ecall
 ret
     b20:	8082                	ret

0000000000000b22 <wait>:
.global wait
wait:
 li a7, SYS_wait
     b22:	488d                	li	a7,3
 ecall
     b24:	00000073          	ecall
 ret
     b28:	8082                	ret

0000000000000b2a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     b2a:	4891                	li	a7,4
 ecall
     b2c:	00000073          	ecall
 ret
     b30:	8082                	ret

0000000000000b32 <read>:
.global read
read:
 li a7, SYS_read
     b32:	4895                	li	a7,5
 ecall
     b34:	00000073          	ecall
 ret
     b38:	8082                	ret

0000000000000b3a <write>:
.global write
write:
 li a7, SYS_write
     b3a:	48c1                	li	a7,16
 ecall
     b3c:	00000073          	ecall
 ret
     b40:	8082                	ret

0000000000000b42 <close>:
.global close
close:
 li a7, SYS_close
     b42:	48d5                	li	a7,21
 ecall
     b44:	00000073          	ecall
 ret
     b48:	8082                	ret

0000000000000b4a <kill>:
.global kill
kill:
 li a7, SYS_kill
     b4a:	4899                	li	a7,6
 ecall
     b4c:	00000073          	ecall
 ret
     b50:	8082                	ret

0000000000000b52 <exec>:
.global exec
exec:
 li a7, SYS_exec
     b52:	489d                	li	a7,7
 ecall
     b54:	00000073          	ecall
 ret
     b58:	8082                	ret

0000000000000b5a <open>:
.global open
open:
 li a7, SYS_open
     b5a:	48bd                	li	a7,15
 ecall
     b5c:	00000073          	ecall
 ret
     b60:	8082                	ret

0000000000000b62 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     b62:	48c5                	li	a7,17
 ecall
     b64:	00000073          	ecall
 ret
     b68:	8082                	ret

0000000000000b6a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     b6a:	48c9                	li	a7,18
 ecall
     b6c:	00000073          	ecall
 ret
     b70:	8082                	ret

0000000000000b72 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     b72:	48a1                	li	a7,8
 ecall
     b74:	00000073          	ecall
 ret
     b78:	8082                	ret

0000000000000b7a <link>:
.global link
link:
 li a7, SYS_link
     b7a:	48cd                	li	a7,19
 ecall
     b7c:	00000073          	ecall
 ret
     b80:	8082                	ret

0000000000000b82 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     b82:	48d1                	li	a7,20
 ecall
     b84:	00000073          	ecall
 ret
     b88:	8082                	ret

0000000000000b8a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     b8a:	48a5                	li	a7,9
 ecall
     b8c:	00000073          	ecall
 ret
     b90:	8082                	ret

0000000000000b92 <dup>:
.global dup
dup:
 li a7, SYS_dup
     b92:	48a9                	li	a7,10
 ecall
     b94:	00000073          	ecall
 ret
     b98:	8082                	ret

0000000000000b9a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     b9a:	48ad                	li	a7,11
 ecall
     b9c:	00000073          	ecall
 ret
     ba0:	8082                	ret

0000000000000ba2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     ba2:	48b1                	li	a7,12
 ecall
     ba4:	00000073          	ecall
 ret
     ba8:	8082                	ret

0000000000000baa <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     baa:	48b5                	li	a7,13
 ecall
     bac:	00000073          	ecall
 ret
     bb0:	8082                	ret

0000000000000bb2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     bb2:	48b9                	li	a7,14
 ecall
     bb4:	00000073          	ecall
 ret
     bb8:	8082                	ret

0000000000000bba <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
     bba:	48d9                	li	a7,22
 ecall
     bbc:	00000073          	ecall
 ret
     bc0:	8082                	ret

0000000000000bc2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     bc2:	1101                	addi	sp,sp,-32
     bc4:	ec06                	sd	ra,24(sp)
     bc6:	e822                	sd	s0,16(sp)
     bc8:	1000                	addi	s0,sp,32
     bca:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     bce:	4605                	li	a2,1
     bd0:	fef40593          	addi	a1,s0,-17
     bd4:	f67ff0ef          	jal	b3a <write>
}
     bd8:	60e2                	ld	ra,24(sp)
     bda:	6442                	ld	s0,16(sp)
     bdc:	6105                	addi	sp,sp,32
     bde:	8082                	ret

0000000000000be0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     be0:	7139                	addi	sp,sp,-64
     be2:	fc06                	sd	ra,56(sp)
     be4:	f822                	sd	s0,48(sp)
     be6:	f426                	sd	s1,40(sp)
     be8:	f04a                	sd	s2,32(sp)
     bea:	ec4e                	sd	s3,24(sp)
     bec:	0080                	addi	s0,sp,64
     bee:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     bf0:	c299                	beqz	a3,bf6 <printint+0x16>
     bf2:	0605ce63          	bltz	a1,c6e <printint+0x8e>
  neg = 0;
     bf6:	4e01                	li	t3,0
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
     bf8:	fc040313          	addi	t1,s0,-64
  neg = 0;
     bfc:	869a                	mv	a3,t1
  i = 0;
     bfe:	4781                	li	a5,0
  do{
    buf[i++] = digits[x % base];
     c00:	00001817          	auipc	a6,0x1
     c04:	a9880813          	addi	a6,a6,-1384 # 1698 <digits>
     c08:	88be                	mv	a7,a5
     c0a:	0017851b          	addiw	a0,a5,1
     c0e:	87aa                	mv	a5,a0
     c10:	02c5f73b          	remuw	a4,a1,a2
     c14:	1702                	slli	a4,a4,0x20
     c16:	9301                	srli	a4,a4,0x20
     c18:	9742                	add	a4,a4,a6
     c1a:	00074703          	lbu	a4,0(a4)
     c1e:	00e68023          	sb	a4,0(a3)
  }while((x /= base) != 0);
     c22:	872e                	mv	a4,a1
     c24:	02c5d5bb          	divuw	a1,a1,a2
     c28:	0685                	addi	a3,a3,1
     c2a:	fcc77fe3          	bgeu	a4,a2,c08 <printint+0x28>
  if(neg)
     c2e:	000e0c63          	beqz	t3,c46 <printint+0x66>
    buf[i++] = '-';
     c32:	fd050793          	addi	a5,a0,-48
     c36:	00878533          	add	a0,a5,s0
     c3a:	02d00793          	li	a5,45
     c3e:	fef50823          	sb	a5,-16(a0)
     c42:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
     c46:	fff7899b          	addiw	s3,a5,-1
     c4a:	006784b3          	add	s1,a5,t1
    putc(fd, buf[i]);
     c4e:	fff4c583          	lbu	a1,-1(s1)
     c52:	854a                	mv	a0,s2
     c54:	f6fff0ef          	jal	bc2 <putc>
  while(--i >= 0)
     c58:	39fd                	addiw	s3,s3,-1
     c5a:	14fd                	addi	s1,s1,-1
     c5c:	fe09d9e3          	bgez	s3,c4e <printint+0x6e>
}
     c60:	70e2                	ld	ra,56(sp)
     c62:	7442                	ld	s0,48(sp)
     c64:	74a2                	ld	s1,40(sp)
     c66:	7902                	ld	s2,32(sp)
     c68:	69e2                	ld	s3,24(sp)
     c6a:	6121                	addi	sp,sp,64
     c6c:	8082                	ret
    x = -xx;
     c6e:	40b005bb          	negw	a1,a1
    neg = 1;
     c72:	4e05                	li	t3,1
    x = -xx;
     c74:	b751                	j	bf8 <printint+0x18>

0000000000000c76 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     c76:	711d                	addi	sp,sp,-96
     c78:	ec86                	sd	ra,88(sp)
     c7a:	e8a2                	sd	s0,80(sp)
     c7c:	e4a6                	sd	s1,72(sp)
     c7e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     c80:	0005c483          	lbu	s1,0(a1)
     c84:	26048663          	beqz	s1,ef0 <vprintf+0x27a>
     c88:	e0ca                	sd	s2,64(sp)
     c8a:	fc4e                	sd	s3,56(sp)
     c8c:	f852                	sd	s4,48(sp)
     c8e:	f456                	sd	s5,40(sp)
     c90:	f05a                	sd	s6,32(sp)
     c92:	ec5e                	sd	s7,24(sp)
     c94:	e862                	sd	s8,16(sp)
     c96:	e466                	sd	s9,8(sp)
     c98:	8b2a                	mv	s6,a0
     c9a:	8a2e                	mv	s4,a1
     c9c:	8bb2                	mv	s7,a2
  state = 0;
     c9e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
     ca0:	4901                	li	s2,0
     ca2:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
     ca4:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
     ca8:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
     cac:	06c00c93          	li	s9,108
     cb0:	a00d                	j	cd2 <vprintf+0x5c>
        putc(fd, c0);
     cb2:	85a6                	mv	a1,s1
     cb4:	855a                	mv	a0,s6
     cb6:	f0dff0ef          	jal	bc2 <putc>
     cba:	a019                	j	cc0 <vprintf+0x4a>
    } else if(state == '%'){
     cbc:	03598363          	beq	s3,s5,ce2 <vprintf+0x6c>
  for(i = 0; fmt[i]; i++){
     cc0:	0019079b          	addiw	a5,s2,1
     cc4:	893e                	mv	s2,a5
     cc6:	873e                	mv	a4,a5
     cc8:	97d2                	add	a5,a5,s4
     cca:	0007c483          	lbu	s1,0(a5)
     cce:	20048963          	beqz	s1,ee0 <vprintf+0x26a>
    c0 = fmt[i] & 0xff;
     cd2:	0004879b          	sext.w	a5,s1
    if(state == 0){
     cd6:	fe0993e3          	bnez	s3,cbc <vprintf+0x46>
      if(c0 == '%'){
     cda:	fd579ce3          	bne	a5,s5,cb2 <vprintf+0x3c>
        state = '%';
     cde:	89be                	mv	s3,a5
     ce0:	b7c5                	j	cc0 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
     ce2:	00ea06b3          	add	a3,s4,a4
     ce6:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
     cea:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
     cec:	c681                	beqz	a3,cf4 <vprintf+0x7e>
     cee:	9752                	add	a4,a4,s4
     cf0:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
     cf4:	03878e63          	beq	a5,s8,d30 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
     cf8:	05978863          	beq	a5,s9,d48 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
     cfc:	07500713          	li	a4,117
     d00:	0ee78263          	beq	a5,a4,de4 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
     d04:	07800713          	li	a4,120
     d08:	12e78463          	beq	a5,a4,e30 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
     d0c:	07000713          	li	a4,112
     d10:	14e78963          	beq	a5,a4,e62 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
     d14:	07300713          	li	a4,115
     d18:	18e78863          	beq	a5,a4,ea8 <vprintf+0x232>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
     d1c:	02500713          	li	a4,37
     d20:	04e79463          	bne	a5,a4,d68 <vprintf+0xf2>
        putc(fd, '%');
     d24:	85ba                	mv	a1,a4
     d26:	855a                	mv	a0,s6
     d28:	e9bff0ef          	jal	bc2 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
     d2c:	4981                	li	s3,0
     d2e:	bf49                	j	cc0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
     d30:	008b8493          	addi	s1,s7,8
     d34:	4685                	li	a3,1
     d36:	4629                	li	a2,10
     d38:	000ba583          	lw	a1,0(s7)
     d3c:	855a                	mv	a0,s6
     d3e:	ea3ff0ef          	jal	be0 <printint>
     d42:	8ba6                	mv	s7,s1
      state = 0;
     d44:	4981                	li	s3,0
     d46:	bfad                	j	cc0 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
     d48:	06400793          	li	a5,100
     d4c:	02f68963          	beq	a3,a5,d7e <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     d50:	06c00793          	li	a5,108
     d54:	04f68263          	beq	a3,a5,d98 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
     d58:	07500793          	li	a5,117
     d5c:	0af68063          	beq	a3,a5,dfc <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
     d60:	07800793          	li	a5,120
     d64:	0ef68263          	beq	a3,a5,e48 <vprintf+0x1d2>
        putc(fd, '%');
     d68:	02500593          	li	a1,37
     d6c:	855a                	mv	a0,s6
     d6e:	e55ff0ef          	jal	bc2 <putc>
        putc(fd, c0);
     d72:	85a6                	mv	a1,s1
     d74:	855a                	mv	a0,s6
     d76:	e4dff0ef          	jal	bc2 <putc>
      state = 0;
     d7a:	4981                	li	s3,0
     d7c:	b791                	j	cc0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     d7e:	008b8493          	addi	s1,s7,8
     d82:	4685                	li	a3,1
     d84:	4629                	li	a2,10
     d86:	000ba583          	lw	a1,0(s7)
     d8a:	855a                	mv	a0,s6
     d8c:	e55ff0ef          	jal	be0 <printint>
        i += 1;
     d90:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
     d92:	8ba6                	mv	s7,s1
      state = 0;
     d94:	4981                	li	s3,0
        i += 1;
     d96:	b72d                	j	cc0 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     d98:	06400793          	li	a5,100
     d9c:	02f60763          	beq	a2,a5,dca <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
     da0:	07500793          	li	a5,117
     da4:	06f60963          	beq	a2,a5,e16 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
     da8:	07800793          	li	a5,120
     dac:	faf61ee3          	bne	a2,a5,d68 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
     db0:	008b8493          	addi	s1,s7,8
     db4:	4681                	li	a3,0
     db6:	4641                	li	a2,16
     db8:	000ba583          	lw	a1,0(s7)
     dbc:	855a                	mv	a0,s6
     dbe:	e23ff0ef          	jal	be0 <printint>
        i += 2;
     dc2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
     dc4:	8ba6                	mv	s7,s1
      state = 0;
     dc6:	4981                	li	s3,0
        i += 2;
     dc8:	bde5                	j	cc0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
     dca:	008b8493          	addi	s1,s7,8
     dce:	4685                	li	a3,1
     dd0:	4629                	li	a2,10
     dd2:	000ba583          	lw	a1,0(s7)
     dd6:	855a                	mv	a0,s6
     dd8:	e09ff0ef          	jal	be0 <printint>
        i += 2;
     ddc:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
     dde:	8ba6                	mv	s7,s1
      state = 0;
     de0:	4981                	li	s3,0
        i += 2;
     de2:	bdf9                	j	cc0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
     de4:	008b8493          	addi	s1,s7,8
     de8:	4681                	li	a3,0
     dea:	4629                	li	a2,10
     dec:	000ba583          	lw	a1,0(s7)
     df0:	855a                	mv	a0,s6
     df2:	defff0ef          	jal	be0 <printint>
     df6:	8ba6                	mv	s7,s1
      state = 0;
     df8:	4981                	li	s3,0
     dfa:	b5d9                	j	cc0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     dfc:	008b8493          	addi	s1,s7,8
     e00:	4681                	li	a3,0
     e02:	4629                	li	a2,10
     e04:	000ba583          	lw	a1,0(s7)
     e08:	855a                	mv	a0,s6
     e0a:	dd7ff0ef          	jal	be0 <printint>
        i += 1;
     e0e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
     e10:	8ba6                	mv	s7,s1
      state = 0;
     e12:	4981                	li	s3,0
        i += 1;
     e14:	b575                	j	cc0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
     e16:	008b8493          	addi	s1,s7,8
     e1a:	4681                	li	a3,0
     e1c:	4629                	li	a2,10
     e1e:	000ba583          	lw	a1,0(s7)
     e22:	855a                	mv	a0,s6
     e24:	dbdff0ef          	jal	be0 <printint>
        i += 2;
     e28:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
     e2a:	8ba6                	mv	s7,s1
      state = 0;
     e2c:	4981                	li	s3,0
        i += 2;
     e2e:	bd49                	j	cc0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
     e30:	008b8493          	addi	s1,s7,8
     e34:	4681                	li	a3,0
     e36:	4641                	li	a2,16
     e38:	000ba583          	lw	a1,0(s7)
     e3c:	855a                	mv	a0,s6
     e3e:	da3ff0ef          	jal	be0 <printint>
     e42:	8ba6                	mv	s7,s1
      state = 0;
     e44:	4981                	li	s3,0
     e46:	bdad                	j	cc0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
     e48:	008b8493          	addi	s1,s7,8
     e4c:	4681                	li	a3,0
     e4e:	4641                	li	a2,16
     e50:	000ba583          	lw	a1,0(s7)
     e54:	855a                	mv	a0,s6
     e56:	d8bff0ef          	jal	be0 <printint>
        i += 1;
     e5a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
     e5c:	8ba6                	mv	s7,s1
      state = 0;
     e5e:	4981                	li	s3,0
        i += 1;
     e60:	b585                	j	cc0 <vprintf+0x4a>
     e62:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
     e64:	008b8d13          	addi	s10,s7,8
     e68:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     e6c:	03000593          	li	a1,48
     e70:	855a                	mv	a0,s6
     e72:	d51ff0ef          	jal	bc2 <putc>
  putc(fd, 'x');
     e76:	07800593          	li	a1,120
     e7a:	855a                	mv	a0,s6
     e7c:	d47ff0ef          	jal	bc2 <putc>
     e80:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     e82:	00001b97          	auipc	s7,0x1
     e86:	816b8b93          	addi	s7,s7,-2026 # 1698 <digits>
     e8a:	03c9d793          	srli	a5,s3,0x3c
     e8e:	97de                	add	a5,a5,s7
     e90:	0007c583          	lbu	a1,0(a5)
     e94:	855a                	mv	a0,s6
     e96:	d2dff0ef          	jal	bc2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     e9a:	0992                	slli	s3,s3,0x4
     e9c:	34fd                	addiw	s1,s1,-1
     e9e:	f4f5                	bnez	s1,e8a <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
     ea0:	8bea                	mv	s7,s10
      state = 0;
     ea2:	4981                	li	s3,0
     ea4:	6d02                	ld	s10,0(sp)
     ea6:	bd29                	j	cc0 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
     ea8:	008b8993          	addi	s3,s7,8
     eac:	000bb483          	ld	s1,0(s7)
     eb0:	cc91                	beqz	s1,ecc <vprintf+0x256>
        for(; *s; s++)
     eb2:	0004c583          	lbu	a1,0(s1)
     eb6:	c195                	beqz	a1,eda <vprintf+0x264>
          putc(fd, *s);
     eb8:	855a                	mv	a0,s6
     eba:	d09ff0ef          	jal	bc2 <putc>
        for(; *s; s++)
     ebe:	0485                	addi	s1,s1,1
     ec0:	0004c583          	lbu	a1,0(s1)
     ec4:	f9f5                	bnez	a1,eb8 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
     ec6:	8bce                	mv	s7,s3
      state = 0;
     ec8:	4981                	li	s3,0
     eca:	bbdd                	j	cc0 <vprintf+0x4a>
          s = "(null)";
     ecc:	00000497          	auipc	s1,0x0
     ed0:	7c448493          	addi	s1,s1,1988 # 1690 <malloc+0x6b4>
        for(; *s; s++)
     ed4:	02800593          	li	a1,40
     ed8:	b7c5                	j	eb8 <vprintf+0x242>
        if((s = va_arg(ap, char*)) == 0)
     eda:	8bce                	mv	s7,s3
      state = 0;
     edc:	4981                	li	s3,0
     ede:	b3cd                	j	cc0 <vprintf+0x4a>
     ee0:	6906                	ld	s2,64(sp)
     ee2:	79e2                	ld	s3,56(sp)
     ee4:	7a42                	ld	s4,48(sp)
     ee6:	7aa2                	ld	s5,40(sp)
     ee8:	7b02                	ld	s6,32(sp)
     eea:	6be2                	ld	s7,24(sp)
     eec:	6c42                	ld	s8,16(sp)
     eee:	6ca2                	ld	s9,8(sp)
    }
  }
}
     ef0:	60e6                	ld	ra,88(sp)
     ef2:	6446                	ld	s0,80(sp)
     ef4:	64a6                	ld	s1,72(sp)
     ef6:	6125                	addi	sp,sp,96
     ef8:	8082                	ret

0000000000000efa <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     efa:	715d                	addi	sp,sp,-80
     efc:	ec06                	sd	ra,24(sp)
     efe:	e822                	sd	s0,16(sp)
     f00:	1000                	addi	s0,sp,32
     f02:	e010                	sd	a2,0(s0)
     f04:	e414                	sd	a3,8(s0)
     f06:	e818                	sd	a4,16(s0)
     f08:	ec1c                	sd	a5,24(s0)
     f0a:	03043023          	sd	a6,32(s0)
     f0e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     f12:	8622                	mv	a2,s0
     f14:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     f18:	d5fff0ef          	jal	c76 <vprintf>
}
     f1c:	60e2                	ld	ra,24(sp)
     f1e:	6442                	ld	s0,16(sp)
     f20:	6161                	addi	sp,sp,80
     f22:	8082                	ret

0000000000000f24 <printf>:

void
printf(const char *fmt, ...)
{
     f24:	711d                	addi	sp,sp,-96
     f26:	ec06                	sd	ra,24(sp)
     f28:	e822                	sd	s0,16(sp)
     f2a:	1000                	addi	s0,sp,32
     f2c:	e40c                	sd	a1,8(s0)
     f2e:	e810                	sd	a2,16(s0)
     f30:	ec14                	sd	a3,24(s0)
     f32:	f018                	sd	a4,32(s0)
     f34:	f41c                	sd	a5,40(s0)
     f36:	03043823          	sd	a6,48(s0)
     f3a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     f3e:	00840613          	addi	a2,s0,8
     f42:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
     f46:	85aa                	mv	a1,a0
     f48:	4505                	li	a0,1
     f4a:	d2dff0ef          	jal	c76 <vprintf>
}
     f4e:	60e2                	ld	ra,24(sp)
     f50:	6442                	ld	s0,16(sp)
     f52:	6125                	addi	sp,sp,96
     f54:	8082                	ret

0000000000000f56 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     f56:	1141                	addi	sp,sp,-16
     f58:	e406                	sd	ra,8(sp)
     f5a:	e022                	sd	s0,0(sp)
     f5c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
     f5e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     f62:	00001797          	auipc	a5,0x1
     f66:	0a67b783          	ld	a5,166(a5) # 2008 <freep>
     f6a:	a02d                	j	f94 <free+0x3e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
     f6c:	4618                	lw	a4,8(a2)
     f6e:	9f2d                	addw	a4,a4,a1
     f70:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
     f74:	6398                	ld	a4,0(a5)
     f76:	6310                	ld	a2,0(a4)
     f78:	a83d                	j	fb6 <free+0x60>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
     f7a:	ff852703          	lw	a4,-8(a0)
     f7e:	9f31                	addw	a4,a4,a2
     f80:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
     f82:	ff053683          	ld	a3,-16(a0)
     f86:	a091                	j	fca <free+0x74>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     f88:	6398                	ld	a4,0(a5)
     f8a:	00e7e463          	bltu	a5,a4,f92 <free+0x3c>
     f8e:	00e6ea63          	bltu	a3,a4,fa2 <free+0x4c>
{
     f92:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     f94:	fed7fae3          	bgeu	a5,a3,f88 <free+0x32>
     f98:	6398                	ld	a4,0(a5)
     f9a:	00e6e463          	bltu	a3,a4,fa2 <free+0x4c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     f9e:	fee7eae3          	bltu	a5,a4,f92 <free+0x3c>
  if(bp + bp->s.size == p->s.ptr){
     fa2:	ff852583          	lw	a1,-8(a0)
     fa6:	6390                	ld	a2,0(a5)
     fa8:	02059813          	slli	a6,a1,0x20
     fac:	01c85713          	srli	a4,a6,0x1c
     fb0:	9736                	add	a4,a4,a3
     fb2:	fae60de3          	beq	a2,a4,f6c <free+0x16>
    bp->s.ptr = p->s.ptr->s.ptr;
     fb6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
     fba:	4790                	lw	a2,8(a5)
     fbc:	02061593          	slli	a1,a2,0x20
     fc0:	01c5d713          	srli	a4,a1,0x1c
     fc4:	973e                	add	a4,a4,a5
     fc6:	fae68ae3          	beq	a3,a4,f7a <free+0x24>
    p->s.ptr = bp->s.ptr;
     fca:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
     fcc:	00001717          	auipc	a4,0x1
     fd0:	02f73e23          	sd	a5,60(a4) # 2008 <freep>
}
     fd4:	60a2                	ld	ra,8(sp)
     fd6:	6402                	ld	s0,0(sp)
     fd8:	0141                	addi	sp,sp,16
     fda:	8082                	ret

0000000000000fdc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
     fdc:	7139                	addi	sp,sp,-64
     fde:	fc06                	sd	ra,56(sp)
     fe0:	f822                	sd	s0,48(sp)
     fe2:	f04a                	sd	s2,32(sp)
     fe4:	ec4e                	sd	s3,24(sp)
     fe6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
     fe8:	02051993          	slli	s3,a0,0x20
     fec:	0209d993          	srli	s3,s3,0x20
     ff0:	09bd                	addi	s3,s3,15
     ff2:	0049d993          	srli	s3,s3,0x4
     ff6:	2985                	addiw	s3,s3,1
     ff8:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
     ffa:	00001517          	auipc	a0,0x1
     ffe:	00e53503          	ld	a0,14(a0) # 2008 <freep>
    1002:	c905                	beqz	a0,1032 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1004:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1006:	4798                	lw	a4,8(a5)
    1008:	09377663          	bgeu	a4,s3,1094 <malloc+0xb8>
    100c:	f426                	sd	s1,40(sp)
    100e:	e852                	sd	s4,16(sp)
    1010:	e456                	sd	s5,8(sp)
    1012:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    1014:	8a4e                	mv	s4,s3
    1016:	6705                	lui	a4,0x1
    1018:	00e9f363          	bgeu	s3,a4,101e <malloc+0x42>
    101c:	6a05                	lui	s4,0x1
    101e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1022:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1026:	00001497          	auipc	s1,0x1
    102a:	fe248493          	addi	s1,s1,-30 # 2008 <freep>
  if(p == (char*)-1)
    102e:	5afd                	li	s5,-1
    1030:	a83d                	j	106e <malloc+0x92>
    1032:	f426                	sd	s1,40(sp)
    1034:	e852                	sd	s4,16(sp)
    1036:	e456                	sd	s5,8(sp)
    1038:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    103a:	00001797          	auipc	a5,0x1
    103e:	fd678793          	addi	a5,a5,-42 # 2010 <base>
    1042:	00001717          	auipc	a4,0x1
    1046:	fcf73323          	sd	a5,-58(a4) # 2008 <freep>
    104a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    104c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1050:	b7d1                	j	1014 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    1052:	6398                	ld	a4,0(a5)
    1054:	e118                	sd	a4,0(a0)
    1056:	a899                	j	10ac <malloc+0xd0>
  hp->s.size = nu;
    1058:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    105c:	0541                	addi	a0,a0,16
    105e:	ef9ff0ef          	jal	f56 <free>
  return freep;
    1062:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    1064:	c125                	beqz	a0,10c4 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1066:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1068:	4798                	lw	a4,8(a5)
    106a:	03277163          	bgeu	a4,s2,108c <malloc+0xb0>
    if(p == freep)
    106e:	6098                	ld	a4,0(s1)
    1070:	853e                	mv	a0,a5
    1072:	fef71ae3          	bne	a4,a5,1066 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
    1076:	8552                	mv	a0,s4
    1078:	b2bff0ef          	jal	ba2 <sbrk>
  if(p == (char*)-1)
    107c:	fd551ee3          	bne	a0,s5,1058 <malloc+0x7c>
        return 0;
    1080:	4501                	li	a0,0
    1082:	74a2                	ld	s1,40(sp)
    1084:	6a42                	ld	s4,16(sp)
    1086:	6aa2                	ld	s5,8(sp)
    1088:	6b02                	ld	s6,0(sp)
    108a:	a03d                	j	10b8 <malloc+0xdc>
    108c:	74a2                	ld	s1,40(sp)
    108e:	6a42                	ld	s4,16(sp)
    1090:	6aa2                	ld	s5,8(sp)
    1092:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    1094:	fae90fe3          	beq	s2,a4,1052 <malloc+0x76>
        p->s.size -= nunits;
    1098:	4137073b          	subw	a4,a4,s3
    109c:	c798                	sw	a4,8(a5)
        p += p->s.size;
    109e:	02071693          	slli	a3,a4,0x20
    10a2:	01c6d713          	srli	a4,a3,0x1c
    10a6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    10a8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    10ac:	00001717          	auipc	a4,0x1
    10b0:	f4a73e23          	sd	a0,-164(a4) # 2008 <freep>
      return (void*)(p + 1);
    10b4:	01078513          	addi	a0,a5,16
  }
}
    10b8:	70e2                	ld	ra,56(sp)
    10ba:	7442                	ld	s0,48(sp)
    10bc:	7902                	ld	s2,32(sp)
    10be:	69e2                	ld	s3,24(sp)
    10c0:	6121                	addi	sp,sp,64
    10c2:	8082                	ret
    10c4:	74a2                	ld	s1,40(sp)
    10c6:	6a42                	ld	s4,16(sp)
    10c8:	6aa2                	ld	s5,8(sp)
    10ca:	6b02                	ld	s6,0(sp)
    10cc:	b7f5                	j	10b8 <malloc+0xdc>
