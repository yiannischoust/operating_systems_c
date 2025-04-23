
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00014117          	auipc	sp,0x14
    80000004:	f6010113          	addi	sp,sp,-160 # 80013f60 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	757040ef          	jal	80004f6c <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	e7a9                	bnez	a5,80000076 <kfree+0x5a>
    8000002e:	84aa                	mv	s1,a0
    80000030:	0001c797          	auipc	a5,0x1c
    80000034:	03078793          	addi	a5,a5,48 # 8001c060 <end>
    80000038:	02f56f63          	bltu	a0,a5,80000076 <kfree+0x5a>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	02f57b63          	bgeu	a0,a5,80000076 <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	106000ef          	jal	8000014e <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    8000004c:	00008917          	auipc	s2,0x8
    80000050:	8d490913          	addi	s2,s2,-1836 # 80007920 <kmem>
    80000054:	854a                	mv	a0,s2
    80000056:	17f050ef          	jal	800059d4 <acquire>
  r->next = kmem.freelist;
    8000005a:	01893783          	ld	a5,24(s2)
    8000005e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000060:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000064:	854a                	mv	a0,s2
    80000066:	203050ef          	jal	80005a68 <release>
}
    8000006a:	60e2                	ld	ra,24(sp)
    8000006c:	6442                	ld	s0,16(sp)
    8000006e:	64a2                	ld	s1,8(sp)
    80000070:	6902                	ld	s2,0(sp)
    80000072:	6105                	addi	sp,sp,32
    80000074:	8082                	ret
    panic("kfree");
    80000076:	00007517          	auipc	a0,0x7
    8000007a:	f8a50513          	addi	a0,a0,-118 # 80007000 <etext>
    8000007e:	628050ef          	jal	800056a6 <panic>

0000000080000082 <freerange>:
{
    80000082:	7179                	addi	sp,sp,-48
    80000084:	f406                	sd	ra,40(sp)
    80000086:	f022                	sd	s0,32(sp)
    80000088:	ec26                	sd	s1,24(sp)
    8000008a:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    8000008c:	6785                	lui	a5,0x1
    8000008e:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000092:	00e504b3          	add	s1,a0,a4
    80000096:	777d                	lui	a4,0xfffff
    80000098:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000009a:	94be                	add	s1,s1,a5
    8000009c:	0295e263          	bltu	a1,s1,800000c0 <freerange+0x3e>
    800000a0:	e84a                	sd	s2,16(sp)
    800000a2:	e44e                	sd	s3,8(sp)
    800000a4:	e052                	sd	s4,0(sp)
    800000a6:	892e                	mv	s2,a1
    kfree(p);
    800000a8:	8a3a                	mv	s4,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000aa:	89be                	mv	s3,a5
    kfree(p);
    800000ac:	01448533          	add	a0,s1,s4
    800000b0:	f6dff0ef          	jal	8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b4:	94ce                	add	s1,s1,s3
    800000b6:	fe997be3          	bgeu	s2,s1,800000ac <freerange+0x2a>
    800000ba:	6942                	ld	s2,16(sp)
    800000bc:	69a2                	ld	s3,8(sp)
    800000be:	6a02                	ld	s4,0(sp)
}
    800000c0:	70a2                	ld	ra,40(sp)
    800000c2:	7402                	ld	s0,32(sp)
    800000c4:	64e2                	ld	s1,24(sp)
    800000c6:	6145                	addi	sp,sp,48
    800000c8:	8082                	ret

00000000800000ca <kinit>:
{
    800000ca:	1141                	addi	sp,sp,-16
    800000cc:	e406                	sd	ra,8(sp)
    800000ce:	e022                	sd	s0,0(sp)
    800000d0:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000d2:	00007597          	auipc	a1,0x7
    800000d6:	f3e58593          	addi	a1,a1,-194 # 80007010 <etext+0x10>
    800000da:	00008517          	auipc	a0,0x8
    800000de:	84650513          	addi	a0,a0,-1978 # 80007920 <kmem>
    800000e2:	06f050ef          	jal	80005950 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000e6:	45c5                	li	a1,17
    800000e8:	05ee                	slli	a1,a1,0x1b
    800000ea:	0001c517          	auipc	a0,0x1c
    800000ee:	f7650513          	addi	a0,a0,-138 # 8001c060 <end>
    800000f2:	f91ff0ef          	jal	80000082 <freerange>
}
    800000f6:	60a2                	ld	ra,8(sp)
    800000f8:	6402                	ld	s0,0(sp)
    800000fa:	0141                	addi	sp,sp,16
    800000fc:	8082                	ret

00000000800000fe <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    800000fe:	1101                	addi	sp,sp,-32
    80000100:	ec06                	sd	ra,24(sp)
    80000102:	e822                	sd	s0,16(sp)
    80000104:	e426                	sd	s1,8(sp)
    80000106:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000108:	00008497          	auipc	s1,0x8
    8000010c:	81848493          	addi	s1,s1,-2024 # 80007920 <kmem>
    80000110:	8526                	mv	a0,s1
    80000112:	0c3050ef          	jal	800059d4 <acquire>
  r = kmem.freelist;
    80000116:	6c84                	ld	s1,24(s1)
  if(r)
    80000118:	c485                	beqz	s1,80000140 <kalloc+0x42>
    kmem.freelist = r->next;
    8000011a:	609c                	ld	a5,0(s1)
    8000011c:	00008517          	auipc	a0,0x8
    80000120:	80450513          	addi	a0,a0,-2044 # 80007920 <kmem>
    80000124:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000126:	143050ef          	jal	80005a68 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000012a:	6605                	lui	a2,0x1
    8000012c:	4595                	li	a1,5
    8000012e:	8526                	mv	a0,s1
    80000130:	01e000ef          	jal	8000014e <memset>
  return (void*)r;
}
    80000134:	8526                	mv	a0,s1
    80000136:	60e2                	ld	ra,24(sp)
    80000138:	6442                	ld	s0,16(sp)
    8000013a:	64a2                	ld	s1,8(sp)
    8000013c:	6105                	addi	sp,sp,32
    8000013e:	8082                	ret
  release(&kmem.lock);
    80000140:	00007517          	auipc	a0,0x7
    80000144:	7e050513          	addi	a0,a0,2016 # 80007920 <kmem>
    80000148:	121050ef          	jal	80005a68 <release>
  if(r)
    8000014c:	b7e5                	j	80000134 <kalloc+0x36>

000000008000014e <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000014e:	1141                	addi	sp,sp,-16
    80000150:	e406                	sd	ra,8(sp)
    80000152:	e022                	sd	s0,0(sp)
    80000154:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000156:	ca19                	beqz	a2,8000016c <memset+0x1e>
    80000158:	87aa                	mv	a5,a0
    8000015a:	1602                	slli	a2,a2,0x20
    8000015c:	9201                	srli	a2,a2,0x20
    8000015e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000162:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000166:	0785                	addi	a5,a5,1
    80000168:	fee79de3          	bne	a5,a4,80000162 <memset+0x14>
  }
  return dst;
}
    8000016c:	60a2                	ld	ra,8(sp)
    8000016e:	6402                	ld	s0,0(sp)
    80000170:	0141                	addi	sp,sp,16
    80000172:	8082                	ret

0000000080000174 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000174:	1141                	addi	sp,sp,-16
    80000176:	e406                	sd	ra,8(sp)
    80000178:	e022                	sd	s0,0(sp)
    8000017a:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    8000017c:	ca0d                	beqz	a2,800001ae <memcmp+0x3a>
    8000017e:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000182:	1682                	slli	a3,a3,0x20
    80000184:	9281                	srli	a3,a3,0x20
    80000186:	0685                	addi	a3,a3,1
    80000188:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    8000018a:	00054783          	lbu	a5,0(a0)
    8000018e:	0005c703          	lbu	a4,0(a1)
    80000192:	00e79863          	bne	a5,a4,800001a2 <memcmp+0x2e>
      return *s1 - *s2;
    s1++, s2++;
    80000196:	0505                	addi	a0,a0,1
    80000198:	0585                	addi	a1,a1,1
  while(n-- > 0){
    8000019a:	fed518e3          	bne	a0,a3,8000018a <memcmp+0x16>
  }

  return 0;
    8000019e:	4501                	li	a0,0
    800001a0:	a019                	j	800001a6 <memcmp+0x32>
      return *s1 - *s2;
    800001a2:	40e7853b          	subw	a0,a5,a4
}
    800001a6:	60a2                	ld	ra,8(sp)
    800001a8:	6402                	ld	s0,0(sp)
    800001aa:	0141                	addi	sp,sp,16
    800001ac:	8082                	ret
  return 0;
    800001ae:	4501                	li	a0,0
    800001b0:	bfdd                	j	800001a6 <memcmp+0x32>

00000000800001b2 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001b2:	1141                	addi	sp,sp,-16
    800001b4:	e406                	sd	ra,8(sp)
    800001b6:	e022                	sd	s0,0(sp)
    800001b8:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001ba:	c205                	beqz	a2,800001da <memmove+0x28>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001bc:	02a5e363          	bltu	a1,a0,800001e2 <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001c0:	1602                	slli	a2,a2,0x20
    800001c2:	9201                	srli	a2,a2,0x20
    800001c4:	00c587b3          	add	a5,a1,a2
{
    800001c8:	872a                	mv	a4,a0
      *d++ = *s++;
    800001ca:	0585                	addi	a1,a1,1
    800001cc:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffe2fa1>
    800001ce:	fff5c683          	lbu	a3,-1(a1)
    800001d2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001d6:	feb79ae3          	bne	a5,a1,800001ca <memmove+0x18>

  return dst;
}
    800001da:	60a2                	ld	ra,8(sp)
    800001dc:	6402                	ld	s0,0(sp)
    800001de:	0141                	addi	sp,sp,16
    800001e0:	8082                	ret
  if(s < d && s + n > d){
    800001e2:	02061693          	slli	a3,a2,0x20
    800001e6:	9281                	srli	a3,a3,0x20
    800001e8:	00d58733          	add	a4,a1,a3
    800001ec:	fce57ae3          	bgeu	a0,a4,800001c0 <memmove+0xe>
    d += n;
    800001f0:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    800001f2:	fff6079b          	addiw	a5,a2,-1
    800001f6:	1782                	slli	a5,a5,0x20
    800001f8:	9381                	srli	a5,a5,0x20
    800001fa:	fff7c793          	not	a5,a5
    800001fe:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000200:	177d                	addi	a4,a4,-1
    80000202:	16fd                	addi	a3,a3,-1
    80000204:	00074603          	lbu	a2,0(a4)
    80000208:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000020c:	fee79ae3          	bne	a5,a4,80000200 <memmove+0x4e>
    80000210:	b7e9                	j	800001da <memmove+0x28>

0000000080000212 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000212:	1141                	addi	sp,sp,-16
    80000214:	e406                	sd	ra,8(sp)
    80000216:	e022                	sd	s0,0(sp)
    80000218:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000021a:	f99ff0ef          	jal	800001b2 <memmove>
}
    8000021e:	60a2                	ld	ra,8(sp)
    80000220:	6402                	ld	s0,0(sp)
    80000222:	0141                	addi	sp,sp,16
    80000224:	8082                	ret

0000000080000226 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000226:	1141                	addi	sp,sp,-16
    80000228:	e406                	sd	ra,8(sp)
    8000022a:	e022                	sd	s0,0(sp)
    8000022c:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000022e:	ce11                	beqz	a2,8000024a <strncmp+0x24>
    80000230:	00054783          	lbu	a5,0(a0)
    80000234:	cf89                	beqz	a5,8000024e <strncmp+0x28>
    80000236:	0005c703          	lbu	a4,0(a1)
    8000023a:	00f71a63          	bne	a4,a5,8000024e <strncmp+0x28>
    n--, p++, q++;
    8000023e:	367d                	addiw	a2,a2,-1
    80000240:	0505                	addi	a0,a0,1
    80000242:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000244:	f675                	bnez	a2,80000230 <strncmp+0xa>
  if(n == 0)
    return 0;
    80000246:	4501                	li	a0,0
    80000248:	a801                	j	80000258 <strncmp+0x32>
    8000024a:	4501                	li	a0,0
    8000024c:	a031                	j	80000258 <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    8000024e:	00054503          	lbu	a0,0(a0)
    80000252:	0005c783          	lbu	a5,0(a1)
    80000256:	9d1d                	subw	a0,a0,a5
}
    80000258:	60a2                	ld	ra,8(sp)
    8000025a:	6402                	ld	s0,0(sp)
    8000025c:	0141                	addi	sp,sp,16
    8000025e:	8082                	ret

0000000080000260 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000260:	1141                	addi	sp,sp,-16
    80000262:	e406                	sd	ra,8(sp)
    80000264:	e022                	sd	s0,0(sp)
    80000266:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000268:	87aa                	mv	a5,a0
    8000026a:	86b2                	mv	a3,a2
    8000026c:	367d                	addiw	a2,a2,-1
    8000026e:	02d05563          	blez	a3,80000298 <strncpy+0x38>
    80000272:	0785                	addi	a5,a5,1
    80000274:	0005c703          	lbu	a4,0(a1)
    80000278:	fee78fa3          	sb	a4,-1(a5)
    8000027c:	0585                	addi	a1,a1,1
    8000027e:	f775                	bnez	a4,8000026a <strncpy+0xa>
    ;
  while(n-- > 0)
    80000280:	873e                	mv	a4,a5
    80000282:	00c05b63          	blez	a2,80000298 <strncpy+0x38>
    80000286:	9fb5                	addw	a5,a5,a3
    80000288:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    8000028a:	0705                	addi	a4,a4,1
    8000028c:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000290:	40e786bb          	subw	a3,a5,a4
    80000294:	fed04be3          	bgtz	a3,8000028a <strncpy+0x2a>
  return os;
}
    80000298:	60a2                	ld	ra,8(sp)
    8000029a:	6402                	ld	s0,0(sp)
    8000029c:	0141                	addi	sp,sp,16
    8000029e:	8082                	ret

00000000800002a0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002a0:	1141                	addi	sp,sp,-16
    800002a2:	e406                	sd	ra,8(sp)
    800002a4:	e022                	sd	s0,0(sp)
    800002a6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002a8:	02c05363          	blez	a2,800002ce <safestrcpy+0x2e>
    800002ac:	fff6069b          	addiw	a3,a2,-1
    800002b0:	1682                	slli	a3,a3,0x20
    800002b2:	9281                	srli	a3,a3,0x20
    800002b4:	96ae                	add	a3,a3,a1
    800002b6:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002b8:	00d58963          	beq	a1,a3,800002ca <safestrcpy+0x2a>
    800002bc:	0585                	addi	a1,a1,1
    800002be:	0785                	addi	a5,a5,1
    800002c0:	fff5c703          	lbu	a4,-1(a1)
    800002c4:	fee78fa3          	sb	a4,-1(a5)
    800002c8:	fb65                	bnez	a4,800002b8 <safestrcpy+0x18>
    ;
  *s = 0;
    800002ca:	00078023          	sb	zero,0(a5)
  return os;
}
    800002ce:	60a2                	ld	ra,8(sp)
    800002d0:	6402                	ld	s0,0(sp)
    800002d2:	0141                	addi	sp,sp,16
    800002d4:	8082                	ret

00000000800002d6 <strlen>:

int
strlen(const char *s)
{
    800002d6:	1141                	addi	sp,sp,-16
    800002d8:	e406                	sd	ra,8(sp)
    800002da:	e022                	sd	s0,0(sp)
    800002dc:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002de:	00054783          	lbu	a5,0(a0)
    800002e2:	cf99                	beqz	a5,80000300 <strlen+0x2a>
    800002e4:	0505                	addi	a0,a0,1
    800002e6:	87aa                	mv	a5,a0
    800002e8:	86be                	mv	a3,a5
    800002ea:	0785                	addi	a5,a5,1
    800002ec:	fff7c703          	lbu	a4,-1(a5)
    800002f0:	ff65                	bnez	a4,800002e8 <strlen+0x12>
    800002f2:	40a6853b          	subw	a0,a3,a0
    800002f6:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    800002f8:	60a2                	ld	ra,8(sp)
    800002fa:	6402                	ld	s0,0(sp)
    800002fc:	0141                	addi	sp,sp,16
    800002fe:	8082                	ret
  for(n = 0; s[n]; n++)
    80000300:	4501                	li	a0,0
    80000302:	bfdd                	j	800002f8 <strlen+0x22>

0000000080000304 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000304:	1141                	addi	sp,sp,-16
    80000306:	e406                	sd	ra,8(sp)
    80000308:	e022                	sd	s0,0(sp)
    8000030a:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000030c:	21d000ef          	jal	80000d28 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000310:	00007717          	auipc	a4,0x7
    80000314:	5e070713          	addi	a4,a4,1504 # 800078f0 <started>
  if(cpuid() == 0){
    80000318:	c51d                	beqz	a0,80000346 <main+0x42>
    while(started == 0)
    8000031a:	431c                	lw	a5,0(a4)
    8000031c:	2781                	sext.w	a5,a5
    8000031e:	dff5                	beqz	a5,8000031a <main+0x16>
      ;
    __sync_synchronize();
    80000320:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000324:	205000ef          	jal	80000d28 <cpuid>
    80000328:	85aa                	mv	a1,a0
    8000032a:	00007517          	auipc	a0,0x7
    8000032e:	d0e50513          	addi	a0,a0,-754 # 80007038 <etext+0x38>
    80000332:	0a4050ef          	jal	800053d6 <printf>
    kvminithart();    // turn on paging
    80000336:	080000ef          	jal	800003b6 <kvminithart>
    trapinithart();   // install kernel trap vector
    8000033a:	502010ef          	jal	8000183c <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000033e:	67a040ef          	jal	800049b8 <plicinithart>
  }

  scheduler();        
    80000342:	64f000ef          	jal	80001190 <scheduler>
    consoleinit();
    80000346:	7c3040ef          	jal	80005308 <consoleinit>
    printfinit();
    8000034a:	396050ef          	jal	800056e0 <printfinit>
    printf("\n");
    8000034e:	00007517          	auipc	a0,0x7
    80000352:	cca50513          	addi	a0,a0,-822 # 80007018 <etext+0x18>
    80000356:	080050ef          	jal	800053d6 <printf>
    printf("xv6 kernel is booting\n");
    8000035a:	00007517          	auipc	a0,0x7
    8000035e:	cc650513          	addi	a0,a0,-826 # 80007020 <etext+0x20>
    80000362:	074050ef          	jal	800053d6 <printf>
    printf("\n");
    80000366:	00007517          	auipc	a0,0x7
    8000036a:	cb250513          	addi	a0,a0,-846 # 80007018 <etext+0x18>
    8000036e:	068050ef          	jal	800053d6 <printf>
    kinit();         // physical page allocator
    80000372:	d59ff0ef          	jal	800000ca <kinit>
    kvminit();       // create kernel page table
    80000376:	2ce000ef          	jal	80000644 <kvminit>
    kvminithart();   // turn on paging
    8000037a:	03c000ef          	jal	800003b6 <kvminithart>
    procinit();      // process table
    8000037e:	0fb000ef          	jal	80000c78 <procinit>
    trapinit();      // trap vectors
    80000382:	496010ef          	jal	80001818 <trapinit>
    trapinithart();  // install kernel trap vector
    80000386:	4b6010ef          	jal	8000183c <trapinithart>
    plicinit();      // set up interrupt controller
    8000038a:	614040ef          	jal	8000499e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000038e:	62a040ef          	jal	800049b8 <plicinithart>
    binit();         // buffer cache
    80000392:	2d9010ef          	jal	80001e6a <binit>
    iinit();         // inode table
    80000396:	152020ef          	jal	800024e8 <iinit>
    fileinit();      // file table
    8000039a:	7af020ef          	jal	80003348 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000039e:	70a040ef          	jal	80004aa8 <virtio_disk_init>
    userinit();      // first user process
    800003a2:	423000ef          	jal	80000fc4 <userinit>
    __sync_synchronize();
    800003a6:	0330000f          	fence	rw,rw
    started = 1;
    800003aa:	4785                	li	a5,1
    800003ac:	00007717          	auipc	a4,0x7
    800003b0:	54f72223          	sw	a5,1348(a4) # 800078f0 <started>
    800003b4:	b779                	j	80000342 <main+0x3e>

00000000800003b6 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    800003b6:	1141                	addi	sp,sp,-16
    800003b8:	e406                	sd	ra,8(sp)
    800003ba:	e022                	sd	s0,0(sp)
    800003bc:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800003be:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800003c2:	00007797          	auipc	a5,0x7
    800003c6:	5367b783          	ld	a5,1334(a5) # 800078f8 <kernel_pagetable>
    800003ca:	83b1                	srli	a5,a5,0xc
    800003cc:	577d                	li	a4,-1
    800003ce:	177e                	slli	a4,a4,0x3f
    800003d0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800003d2:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800003d6:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800003da:	60a2                	ld	ra,8(sp)
    800003dc:	6402                	ld	s0,0(sp)
    800003de:	0141                	addi	sp,sp,16
    800003e0:	8082                	ret

00000000800003e2 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800003e2:	7139                	addi	sp,sp,-64
    800003e4:	fc06                	sd	ra,56(sp)
    800003e6:	f822                	sd	s0,48(sp)
    800003e8:	f426                	sd	s1,40(sp)
    800003ea:	f04a                	sd	s2,32(sp)
    800003ec:	ec4e                	sd	s3,24(sp)
    800003ee:	e852                	sd	s4,16(sp)
    800003f0:	e456                	sd	s5,8(sp)
    800003f2:	e05a                	sd	s6,0(sp)
    800003f4:	0080                	addi	s0,sp,64
    800003f6:	84aa                	mv	s1,a0
    800003f8:	89ae                	mv	s3,a1
    800003fa:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800003fc:	57fd                	li	a5,-1
    800003fe:	83e9                	srli	a5,a5,0x1a
    80000400:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000402:	4b31                	li	s6,12
  if(va >= MAXVA)
    80000404:	04b7e263          	bltu	a5,a1,80000448 <walk+0x66>
    pte_t *pte = &pagetable[PX(level, va)];
    80000408:	0149d933          	srl	s2,s3,s4
    8000040c:	1ff97913          	andi	s2,s2,511
    80000410:	090e                	slli	s2,s2,0x3
    80000412:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000414:	00093483          	ld	s1,0(s2)
    80000418:	0014f793          	andi	a5,s1,1
    8000041c:	cf85                	beqz	a5,80000454 <walk+0x72>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000041e:	80a9                	srli	s1,s1,0xa
    80000420:	04b2                	slli	s1,s1,0xc
  for(int level = 2; level > 0; level--) {
    80000422:	3a5d                	addiw	s4,s4,-9
    80000424:	ff6a12e3          	bne	s4,s6,80000408 <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    80000428:	00c9d513          	srli	a0,s3,0xc
    8000042c:	1ff57513          	andi	a0,a0,511
    80000430:	050e                	slli	a0,a0,0x3
    80000432:	9526                	add	a0,a0,s1
}
    80000434:	70e2                	ld	ra,56(sp)
    80000436:	7442                	ld	s0,48(sp)
    80000438:	74a2                	ld	s1,40(sp)
    8000043a:	7902                	ld	s2,32(sp)
    8000043c:	69e2                	ld	s3,24(sp)
    8000043e:	6a42                	ld	s4,16(sp)
    80000440:	6aa2                	ld	s5,8(sp)
    80000442:	6b02                	ld	s6,0(sp)
    80000444:	6121                	addi	sp,sp,64
    80000446:	8082                	ret
    panic("walk");
    80000448:	00007517          	auipc	a0,0x7
    8000044c:	c0850513          	addi	a0,a0,-1016 # 80007050 <etext+0x50>
    80000450:	256050ef          	jal	800056a6 <panic>
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000454:	020a8263          	beqz	s5,80000478 <walk+0x96>
    80000458:	ca7ff0ef          	jal	800000fe <kalloc>
    8000045c:	84aa                	mv	s1,a0
    8000045e:	d979                	beqz	a0,80000434 <walk+0x52>
      memset(pagetable, 0, PGSIZE);
    80000460:	6605                	lui	a2,0x1
    80000462:	4581                	li	a1,0
    80000464:	cebff0ef          	jal	8000014e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000468:	00c4d793          	srli	a5,s1,0xc
    8000046c:	07aa                	slli	a5,a5,0xa
    8000046e:	0017e793          	ori	a5,a5,1
    80000472:	00f93023          	sd	a5,0(s2)
    80000476:	b775                	j	80000422 <walk+0x40>
        return 0;
    80000478:	4501                	li	a0,0
    8000047a:	bf6d                	j	80000434 <walk+0x52>

000000008000047c <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000047c:	57fd                	li	a5,-1
    8000047e:	83e9                	srli	a5,a5,0x1a
    80000480:	00b7f463          	bgeu	a5,a1,80000488 <walkaddr+0xc>
    return 0;
    80000484:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000486:	8082                	ret
{
    80000488:	1141                	addi	sp,sp,-16
    8000048a:	e406                	sd	ra,8(sp)
    8000048c:	e022                	sd	s0,0(sp)
    8000048e:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000490:	4601                	li	a2,0
    80000492:	f51ff0ef          	jal	800003e2 <walk>
  if(pte == 0)
    80000496:	c105                	beqz	a0,800004b6 <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    80000498:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000049a:	0117f693          	andi	a3,a5,17
    8000049e:	4745                	li	a4,17
    return 0;
    800004a0:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800004a2:	00e68663          	beq	a3,a4,800004ae <walkaddr+0x32>
}
    800004a6:	60a2                	ld	ra,8(sp)
    800004a8:	6402                	ld	s0,0(sp)
    800004aa:	0141                	addi	sp,sp,16
    800004ac:	8082                	ret
  pa = PTE2PA(*pte);
    800004ae:	83a9                	srli	a5,a5,0xa
    800004b0:	00c79513          	slli	a0,a5,0xc
  return pa;
    800004b4:	bfcd                	j	800004a6 <walkaddr+0x2a>
    return 0;
    800004b6:	4501                	li	a0,0
    800004b8:	b7fd                	j	800004a6 <walkaddr+0x2a>

00000000800004ba <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800004ba:	715d                	addi	sp,sp,-80
    800004bc:	e486                	sd	ra,72(sp)
    800004be:	e0a2                	sd	s0,64(sp)
    800004c0:	fc26                	sd	s1,56(sp)
    800004c2:	f84a                	sd	s2,48(sp)
    800004c4:	f44e                	sd	s3,40(sp)
    800004c6:	f052                	sd	s4,32(sp)
    800004c8:	ec56                	sd	s5,24(sp)
    800004ca:	e85a                	sd	s6,16(sp)
    800004cc:	e45e                	sd	s7,8(sp)
    800004ce:	e062                	sd	s8,0(sp)
    800004d0:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800004d2:	03459793          	slli	a5,a1,0x34
    800004d6:	e7b1                	bnez	a5,80000522 <mappages+0x68>
    800004d8:	8aaa                	mv	s5,a0
    800004da:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    800004dc:	03461793          	slli	a5,a2,0x34
    800004e0:	e7b9                	bnez	a5,8000052e <mappages+0x74>
    panic("mappages: size not aligned");

  if(size == 0)
    800004e2:	ce21                	beqz	a2,8000053a <mappages+0x80>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    800004e4:	77fd                	lui	a5,0xfffff
    800004e6:	963e                	add	a2,a2,a5
    800004e8:	00b609b3          	add	s3,a2,a1
  a = va;
    800004ec:	892e                	mv	s2,a1
    800004ee:	40b68a33          	sub	s4,a3,a1
  for(;;){
    if((pte = walk(pagetable, a, 1)) == 0)
    800004f2:	4b85                	li	s7,1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800004f4:	6c05                	lui	s8,0x1
    800004f6:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    800004fa:	865e                	mv	a2,s7
    800004fc:	85ca                	mv	a1,s2
    800004fe:	8556                	mv	a0,s5
    80000500:	ee3ff0ef          	jal	800003e2 <walk>
    80000504:	c539                	beqz	a0,80000552 <mappages+0x98>
    if(*pte & PTE_V)
    80000506:	611c                	ld	a5,0(a0)
    80000508:	8b85                	andi	a5,a5,1
    8000050a:	ef95                	bnez	a5,80000546 <mappages+0x8c>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000050c:	80b1                	srli	s1,s1,0xc
    8000050e:	04aa                	slli	s1,s1,0xa
    80000510:	0164e4b3          	or	s1,s1,s6
    80000514:	0014e493          	ori	s1,s1,1
    80000518:	e104                	sd	s1,0(a0)
    if(a == last)
    8000051a:	05390963          	beq	s2,s3,8000056c <mappages+0xb2>
    a += PGSIZE;
    8000051e:	9962                	add	s2,s2,s8
    if((pte = walk(pagetable, a, 1)) == 0)
    80000520:	bfd9                	j	800004f6 <mappages+0x3c>
    panic("mappages: va not aligned");
    80000522:	00007517          	auipc	a0,0x7
    80000526:	b3650513          	addi	a0,a0,-1226 # 80007058 <etext+0x58>
    8000052a:	17c050ef          	jal	800056a6 <panic>
    panic("mappages: size not aligned");
    8000052e:	00007517          	auipc	a0,0x7
    80000532:	b4a50513          	addi	a0,a0,-1206 # 80007078 <etext+0x78>
    80000536:	170050ef          	jal	800056a6 <panic>
    panic("mappages: size");
    8000053a:	00007517          	auipc	a0,0x7
    8000053e:	b5e50513          	addi	a0,a0,-1186 # 80007098 <etext+0x98>
    80000542:	164050ef          	jal	800056a6 <panic>
      panic("mappages: remap");
    80000546:	00007517          	auipc	a0,0x7
    8000054a:	b6250513          	addi	a0,a0,-1182 # 800070a8 <etext+0xa8>
    8000054e:	158050ef          	jal	800056a6 <panic>
      return -1;
    80000552:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000554:	60a6                	ld	ra,72(sp)
    80000556:	6406                	ld	s0,64(sp)
    80000558:	74e2                	ld	s1,56(sp)
    8000055a:	7942                	ld	s2,48(sp)
    8000055c:	79a2                	ld	s3,40(sp)
    8000055e:	7a02                	ld	s4,32(sp)
    80000560:	6ae2                	ld	s5,24(sp)
    80000562:	6b42                	ld	s6,16(sp)
    80000564:	6ba2                	ld	s7,8(sp)
    80000566:	6c02                	ld	s8,0(sp)
    80000568:	6161                	addi	sp,sp,80
    8000056a:	8082                	ret
  return 0;
    8000056c:	4501                	li	a0,0
    8000056e:	b7dd                	j	80000554 <mappages+0x9a>

0000000080000570 <kvmmap>:
{
    80000570:	1141                	addi	sp,sp,-16
    80000572:	e406                	sd	ra,8(sp)
    80000574:	e022                	sd	s0,0(sp)
    80000576:	0800                	addi	s0,sp,16
    80000578:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000057a:	86b2                	mv	a3,a2
    8000057c:	863e                	mv	a2,a5
    8000057e:	f3dff0ef          	jal	800004ba <mappages>
    80000582:	e509                	bnez	a0,8000058c <kvmmap+0x1c>
}
    80000584:	60a2                	ld	ra,8(sp)
    80000586:	6402                	ld	s0,0(sp)
    80000588:	0141                	addi	sp,sp,16
    8000058a:	8082                	ret
    panic("kvmmap");
    8000058c:	00007517          	auipc	a0,0x7
    80000590:	b2c50513          	addi	a0,a0,-1236 # 800070b8 <etext+0xb8>
    80000594:	112050ef          	jal	800056a6 <panic>

0000000080000598 <kvmmake>:
{
    80000598:	1101                	addi	sp,sp,-32
    8000059a:	ec06                	sd	ra,24(sp)
    8000059c:	e822                	sd	s0,16(sp)
    8000059e:	e426                	sd	s1,8(sp)
    800005a0:	e04a                	sd	s2,0(sp)
    800005a2:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800005a4:	b5bff0ef          	jal	800000fe <kalloc>
    800005a8:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800005aa:	6605                	lui	a2,0x1
    800005ac:	4581                	li	a1,0
    800005ae:	ba1ff0ef          	jal	8000014e <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800005b2:	4719                	li	a4,6
    800005b4:	6685                	lui	a3,0x1
    800005b6:	10000637          	lui	a2,0x10000
    800005ba:	85b2                	mv	a1,a2
    800005bc:	8526                	mv	a0,s1
    800005be:	fb3ff0ef          	jal	80000570 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800005c2:	4719                	li	a4,6
    800005c4:	6685                	lui	a3,0x1
    800005c6:	10001637          	lui	a2,0x10001
    800005ca:	85b2                	mv	a1,a2
    800005cc:	8526                	mv	a0,s1
    800005ce:	fa3ff0ef          	jal	80000570 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    800005d2:	4719                	li	a4,6
    800005d4:	040006b7          	lui	a3,0x4000
    800005d8:	0c000637          	lui	a2,0xc000
    800005dc:	85b2                	mv	a1,a2
    800005de:	8526                	mv	a0,s1
    800005e0:	f91ff0ef          	jal	80000570 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800005e4:	00007917          	auipc	s2,0x7
    800005e8:	a1c90913          	addi	s2,s2,-1508 # 80007000 <etext>
    800005ec:	4729                	li	a4,10
    800005ee:	80007697          	auipc	a3,0x80007
    800005f2:	a1268693          	addi	a3,a3,-1518 # 7000 <_entry-0x7fff9000>
    800005f6:	4605                	li	a2,1
    800005f8:	067e                	slli	a2,a2,0x1f
    800005fa:	85b2                	mv	a1,a2
    800005fc:	8526                	mv	a0,s1
    800005fe:	f73ff0ef          	jal	80000570 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80000602:	4719                	li	a4,6
    80000604:	46c5                	li	a3,17
    80000606:	06ee                	slli	a3,a3,0x1b
    80000608:	412686b3          	sub	a3,a3,s2
    8000060c:	864a                	mv	a2,s2
    8000060e:	85ca                	mv	a1,s2
    80000610:	8526                	mv	a0,s1
    80000612:	f5fff0ef          	jal	80000570 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80000616:	4729                	li	a4,10
    80000618:	6685                	lui	a3,0x1
    8000061a:	00006617          	auipc	a2,0x6
    8000061e:	9e660613          	addi	a2,a2,-1562 # 80006000 <_trampoline>
    80000622:	040005b7          	lui	a1,0x4000
    80000626:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000628:	05b2                	slli	a1,a1,0xc
    8000062a:	8526                	mv	a0,s1
    8000062c:	f45ff0ef          	jal	80000570 <kvmmap>
  proc_mapstacks(kpgtbl);
    80000630:	8526                	mv	a0,s1
    80000632:	5a8000ef          	jal	80000bda <proc_mapstacks>
}
    80000636:	8526                	mv	a0,s1
    80000638:	60e2                	ld	ra,24(sp)
    8000063a:	6442                	ld	s0,16(sp)
    8000063c:	64a2                	ld	s1,8(sp)
    8000063e:	6902                	ld	s2,0(sp)
    80000640:	6105                	addi	sp,sp,32
    80000642:	8082                	ret

0000000080000644 <kvminit>:
{
    80000644:	1141                	addi	sp,sp,-16
    80000646:	e406                	sd	ra,8(sp)
    80000648:	e022                	sd	s0,0(sp)
    8000064a:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000064c:	f4dff0ef          	jal	80000598 <kvmmake>
    80000650:	00007797          	auipc	a5,0x7
    80000654:	2aa7b423          	sd	a0,680(a5) # 800078f8 <kernel_pagetable>
}
    80000658:	60a2                	ld	ra,8(sp)
    8000065a:	6402                	ld	s0,0(sp)
    8000065c:	0141                	addi	sp,sp,16
    8000065e:	8082                	ret

0000000080000660 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000660:	715d                	addi	sp,sp,-80
    80000662:	e486                	sd	ra,72(sp)
    80000664:	e0a2                	sd	s0,64(sp)
    80000666:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000668:	03459793          	slli	a5,a1,0x34
    8000066c:	e39d                	bnez	a5,80000692 <uvmunmap+0x32>
    8000066e:	f84a                	sd	s2,48(sp)
    80000670:	f44e                	sd	s3,40(sp)
    80000672:	f052                	sd	s4,32(sp)
    80000674:	ec56                	sd	s5,24(sp)
    80000676:	e85a                	sd	s6,16(sp)
    80000678:	e45e                	sd	s7,8(sp)
    8000067a:	8a2a                	mv	s4,a0
    8000067c:	892e                	mv	s2,a1
    8000067e:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000680:	0632                	slli	a2,a2,0xc
    80000682:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80000686:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000688:	6b05                	lui	s6,0x1
    8000068a:	0735ff63          	bgeu	a1,s3,80000708 <uvmunmap+0xa8>
    8000068e:	fc26                	sd	s1,56(sp)
    80000690:	a0a9                	j	800006da <uvmunmap+0x7a>
    80000692:	fc26                	sd	s1,56(sp)
    80000694:	f84a                	sd	s2,48(sp)
    80000696:	f44e                	sd	s3,40(sp)
    80000698:	f052                	sd	s4,32(sp)
    8000069a:	ec56                	sd	s5,24(sp)
    8000069c:	e85a                	sd	s6,16(sp)
    8000069e:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    800006a0:	00007517          	auipc	a0,0x7
    800006a4:	a2050513          	addi	a0,a0,-1504 # 800070c0 <etext+0xc0>
    800006a8:	7ff040ef          	jal	800056a6 <panic>
      panic("uvmunmap: walk");
    800006ac:	00007517          	auipc	a0,0x7
    800006b0:	a2c50513          	addi	a0,a0,-1492 # 800070d8 <etext+0xd8>
    800006b4:	7f3040ef          	jal	800056a6 <panic>
      panic("uvmunmap: not mapped");
    800006b8:	00007517          	auipc	a0,0x7
    800006bc:	a3050513          	addi	a0,a0,-1488 # 800070e8 <etext+0xe8>
    800006c0:	7e7040ef          	jal	800056a6 <panic>
      panic("uvmunmap: not a leaf");
    800006c4:	00007517          	auipc	a0,0x7
    800006c8:	a3c50513          	addi	a0,a0,-1476 # 80007100 <etext+0x100>
    800006cc:	7db040ef          	jal	800056a6 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    800006d0:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800006d4:	995a                	add	s2,s2,s6
    800006d6:	03397863          	bgeu	s2,s3,80000706 <uvmunmap+0xa6>
    if((pte = walk(pagetable, a, 0)) == 0)
    800006da:	4601                	li	a2,0
    800006dc:	85ca                	mv	a1,s2
    800006de:	8552                	mv	a0,s4
    800006e0:	d03ff0ef          	jal	800003e2 <walk>
    800006e4:	84aa                	mv	s1,a0
    800006e6:	d179                	beqz	a0,800006ac <uvmunmap+0x4c>
    if((*pte & PTE_V) == 0)
    800006e8:	6108                	ld	a0,0(a0)
    800006ea:	00157793          	andi	a5,a0,1
    800006ee:	d7e9                	beqz	a5,800006b8 <uvmunmap+0x58>
    if(PTE_FLAGS(*pte) == PTE_V)
    800006f0:	3ff57793          	andi	a5,a0,1023
    800006f4:	fd7788e3          	beq	a5,s7,800006c4 <uvmunmap+0x64>
    if(do_free){
    800006f8:	fc0a8ce3          	beqz	s5,800006d0 <uvmunmap+0x70>
      uint64 pa = PTE2PA(*pte);
    800006fc:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800006fe:	0532                	slli	a0,a0,0xc
    80000700:	91dff0ef          	jal	8000001c <kfree>
    80000704:	b7f1                	j	800006d0 <uvmunmap+0x70>
    80000706:	74e2                	ld	s1,56(sp)
    80000708:	7942                	ld	s2,48(sp)
    8000070a:	79a2                	ld	s3,40(sp)
    8000070c:	7a02                	ld	s4,32(sp)
    8000070e:	6ae2                	ld	s5,24(sp)
    80000710:	6b42                	ld	s6,16(sp)
    80000712:	6ba2                	ld	s7,8(sp)
  }
}
    80000714:	60a6                	ld	ra,72(sp)
    80000716:	6406                	ld	s0,64(sp)
    80000718:	6161                	addi	sp,sp,80
    8000071a:	8082                	ret

000000008000071c <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000071c:	1101                	addi	sp,sp,-32
    8000071e:	ec06                	sd	ra,24(sp)
    80000720:	e822                	sd	s0,16(sp)
    80000722:	e426                	sd	s1,8(sp)
    80000724:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000726:	9d9ff0ef          	jal	800000fe <kalloc>
    8000072a:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000072c:	c509                	beqz	a0,80000736 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000072e:	6605                	lui	a2,0x1
    80000730:	4581                	li	a1,0
    80000732:	a1dff0ef          	jal	8000014e <memset>
  return pagetable;
}
    80000736:	8526                	mv	a0,s1
    80000738:	60e2                	ld	ra,24(sp)
    8000073a:	6442                	ld	s0,16(sp)
    8000073c:	64a2                	ld	s1,8(sp)
    8000073e:	6105                	addi	sp,sp,32
    80000740:	8082                	ret

0000000080000742 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80000742:	7179                	addi	sp,sp,-48
    80000744:	f406                	sd	ra,40(sp)
    80000746:	f022                	sd	s0,32(sp)
    80000748:	ec26                	sd	s1,24(sp)
    8000074a:	e84a                	sd	s2,16(sp)
    8000074c:	e44e                	sd	s3,8(sp)
    8000074e:	e052                	sd	s4,0(sp)
    80000750:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80000752:	6785                	lui	a5,0x1
    80000754:	04f67063          	bgeu	a2,a5,80000794 <uvmfirst+0x52>
    80000758:	8a2a                	mv	s4,a0
    8000075a:	89ae                	mv	s3,a1
    8000075c:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    8000075e:	9a1ff0ef          	jal	800000fe <kalloc>
    80000762:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80000764:	6605                	lui	a2,0x1
    80000766:	4581                	li	a1,0
    80000768:	9e7ff0ef          	jal	8000014e <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000076c:	4779                	li	a4,30
    8000076e:	86ca                	mv	a3,s2
    80000770:	6605                	lui	a2,0x1
    80000772:	4581                	li	a1,0
    80000774:	8552                	mv	a0,s4
    80000776:	d45ff0ef          	jal	800004ba <mappages>
  memmove(mem, src, sz);
    8000077a:	8626                	mv	a2,s1
    8000077c:	85ce                	mv	a1,s3
    8000077e:	854a                	mv	a0,s2
    80000780:	a33ff0ef          	jal	800001b2 <memmove>
}
    80000784:	70a2                	ld	ra,40(sp)
    80000786:	7402                	ld	s0,32(sp)
    80000788:	64e2                	ld	s1,24(sp)
    8000078a:	6942                	ld	s2,16(sp)
    8000078c:	69a2                	ld	s3,8(sp)
    8000078e:	6a02                	ld	s4,0(sp)
    80000790:	6145                	addi	sp,sp,48
    80000792:	8082                	ret
    panic("uvmfirst: more than a page");
    80000794:	00007517          	auipc	a0,0x7
    80000798:	98450513          	addi	a0,a0,-1660 # 80007118 <etext+0x118>
    8000079c:	70b040ef          	jal	800056a6 <panic>

00000000800007a0 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800007a0:	1101                	addi	sp,sp,-32
    800007a2:	ec06                	sd	ra,24(sp)
    800007a4:	e822                	sd	s0,16(sp)
    800007a6:	e426                	sd	s1,8(sp)
    800007a8:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800007aa:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800007ac:	00b67d63          	bgeu	a2,a1,800007c6 <uvmdealloc+0x26>
    800007b0:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800007b2:	6785                	lui	a5,0x1
    800007b4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800007b6:	00f60733          	add	a4,a2,a5
    800007ba:	76fd                	lui	a3,0xfffff
    800007bc:	8f75                	and	a4,a4,a3
    800007be:	97ae                	add	a5,a5,a1
    800007c0:	8ff5                	and	a5,a5,a3
    800007c2:	00f76863          	bltu	a4,a5,800007d2 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800007c6:	8526                	mv	a0,s1
    800007c8:	60e2                	ld	ra,24(sp)
    800007ca:	6442                	ld	s0,16(sp)
    800007cc:	64a2                	ld	s1,8(sp)
    800007ce:	6105                	addi	sp,sp,32
    800007d0:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800007d2:	8f99                	sub	a5,a5,a4
    800007d4:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800007d6:	4685                	li	a3,1
    800007d8:	0007861b          	sext.w	a2,a5
    800007dc:	85ba                	mv	a1,a4
    800007de:	e83ff0ef          	jal	80000660 <uvmunmap>
    800007e2:	b7d5                	j	800007c6 <uvmdealloc+0x26>

00000000800007e4 <uvmalloc>:
  if(newsz < oldsz)
    800007e4:	0ab66363          	bltu	a2,a1,8000088a <uvmalloc+0xa6>
{
    800007e8:	715d                	addi	sp,sp,-80
    800007ea:	e486                	sd	ra,72(sp)
    800007ec:	e0a2                	sd	s0,64(sp)
    800007ee:	f052                	sd	s4,32(sp)
    800007f0:	ec56                	sd	s5,24(sp)
    800007f2:	e85a                	sd	s6,16(sp)
    800007f4:	0880                	addi	s0,sp,80
    800007f6:	8b2a                	mv	s6,a0
    800007f8:	8ab2                	mv	s5,a2
  oldsz = PGROUNDUP(oldsz);
    800007fa:	6785                	lui	a5,0x1
    800007fc:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800007fe:	95be                	add	a1,a1,a5
    80000800:	77fd                	lui	a5,0xfffff
    80000802:	00f5fa33          	and	s4,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000806:	08ca7463          	bgeu	s4,a2,8000088e <uvmalloc+0xaa>
    8000080a:	fc26                	sd	s1,56(sp)
    8000080c:	f84a                	sd	s2,48(sp)
    8000080e:	f44e                	sd	s3,40(sp)
    80000810:	e45e                	sd	s7,8(sp)
    80000812:	8952                	mv	s2,s4
    memset(mem, 0, PGSIZE);
    80000814:	6985                	lui	s3,0x1
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000816:	0126eb93          	ori	s7,a3,18
    mem = kalloc();
    8000081a:	8e5ff0ef          	jal	800000fe <kalloc>
    8000081e:	84aa                	mv	s1,a0
    if(mem == 0){
    80000820:	c515                	beqz	a0,8000084c <uvmalloc+0x68>
    memset(mem, 0, PGSIZE);
    80000822:	864e                	mv	a2,s3
    80000824:	4581                	li	a1,0
    80000826:	929ff0ef          	jal	8000014e <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000082a:	875e                	mv	a4,s7
    8000082c:	86a6                	mv	a3,s1
    8000082e:	864e                	mv	a2,s3
    80000830:	85ca                	mv	a1,s2
    80000832:	855a                	mv	a0,s6
    80000834:	c87ff0ef          	jal	800004ba <mappages>
    80000838:	e91d                	bnez	a0,8000086e <uvmalloc+0x8a>
  for(a = oldsz; a < newsz; a += PGSIZE){
    8000083a:	994e                	add	s2,s2,s3
    8000083c:	fd596fe3          	bltu	s2,s5,8000081a <uvmalloc+0x36>
  return newsz;
    80000840:	8556                	mv	a0,s5
    80000842:	74e2                	ld	s1,56(sp)
    80000844:	7942                	ld	s2,48(sp)
    80000846:	79a2                	ld	s3,40(sp)
    80000848:	6ba2                	ld	s7,8(sp)
    8000084a:	a819                	j	80000860 <uvmalloc+0x7c>
      uvmdealloc(pagetable, a, oldsz);
    8000084c:	8652                	mv	a2,s4
    8000084e:	85ca                	mv	a1,s2
    80000850:	855a                	mv	a0,s6
    80000852:	f4fff0ef          	jal	800007a0 <uvmdealloc>
      return 0;
    80000856:	4501                	li	a0,0
    80000858:	74e2                	ld	s1,56(sp)
    8000085a:	7942                	ld	s2,48(sp)
    8000085c:	79a2                	ld	s3,40(sp)
    8000085e:	6ba2                	ld	s7,8(sp)
}
    80000860:	60a6                	ld	ra,72(sp)
    80000862:	6406                	ld	s0,64(sp)
    80000864:	7a02                	ld	s4,32(sp)
    80000866:	6ae2                	ld	s5,24(sp)
    80000868:	6b42                	ld	s6,16(sp)
    8000086a:	6161                	addi	sp,sp,80
    8000086c:	8082                	ret
      kfree(mem);
    8000086e:	8526                	mv	a0,s1
    80000870:	facff0ef          	jal	8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000874:	8652                	mv	a2,s4
    80000876:	85ca                	mv	a1,s2
    80000878:	855a                	mv	a0,s6
    8000087a:	f27ff0ef          	jal	800007a0 <uvmdealloc>
      return 0;
    8000087e:	4501                	li	a0,0
    80000880:	74e2                	ld	s1,56(sp)
    80000882:	7942                	ld	s2,48(sp)
    80000884:	79a2                	ld	s3,40(sp)
    80000886:	6ba2                	ld	s7,8(sp)
    80000888:	bfe1                	j	80000860 <uvmalloc+0x7c>
    return oldsz;
    8000088a:	852e                	mv	a0,a1
}
    8000088c:	8082                	ret
  return newsz;
    8000088e:	8532                	mv	a0,a2
    80000890:	bfc1                	j	80000860 <uvmalloc+0x7c>

0000000080000892 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000892:	7179                	addi	sp,sp,-48
    80000894:	f406                	sd	ra,40(sp)
    80000896:	f022                	sd	s0,32(sp)
    80000898:	ec26                	sd	s1,24(sp)
    8000089a:	e84a                	sd	s2,16(sp)
    8000089c:	e44e                	sd	s3,8(sp)
    8000089e:	e052                	sd	s4,0(sp)
    800008a0:	1800                	addi	s0,sp,48
    800008a2:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800008a4:	84aa                	mv	s1,a0
    800008a6:	6905                	lui	s2,0x1
    800008a8:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800008aa:	4985                	li	s3,1
    800008ac:	a819                	j	800008c2 <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    800008ae:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800008b0:	00c79513          	slli	a0,a5,0xc
    800008b4:	fdfff0ef          	jal	80000892 <freewalk>
      pagetable[i] = 0;
    800008b8:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    800008bc:	04a1                	addi	s1,s1,8
    800008be:	01248f63          	beq	s1,s2,800008dc <freewalk+0x4a>
    pte_t pte = pagetable[i];
    800008c2:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800008c4:	00f7f713          	andi	a4,a5,15
    800008c8:	ff3703e3          	beq	a4,s3,800008ae <freewalk+0x1c>
    } else if(pte & PTE_V){
    800008cc:	8b85                	andi	a5,a5,1
    800008ce:	d7fd                	beqz	a5,800008bc <freewalk+0x2a>
      panic("freewalk: leaf");
    800008d0:	00007517          	auipc	a0,0x7
    800008d4:	86850513          	addi	a0,a0,-1944 # 80007138 <etext+0x138>
    800008d8:	5cf040ef          	jal	800056a6 <panic>
    }
  }
  kfree((void*)pagetable);
    800008dc:	8552                	mv	a0,s4
    800008de:	f3eff0ef          	jal	8000001c <kfree>
}
    800008e2:	70a2                	ld	ra,40(sp)
    800008e4:	7402                	ld	s0,32(sp)
    800008e6:	64e2                	ld	s1,24(sp)
    800008e8:	6942                	ld	s2,16(sp)
    800008ea:	69a2                	ld	s3,8(sp)
    800008ec:	6a02                	ld	s4,0(sp)
    800008ee:	6145                	addi	sp,sp,48
    800008f0:	8082                	ret

00000000800008f2 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800008f2:	1101                	addi	sp,sp,-32
    800008f4:	ec06                	sd	ra,24(sp)
    800008f6:	e822                	sd	s0,16(sp)
    800008f8:	e426                	sd	s1,8(sp)
    800008fa:	1000                	addi	s0,sp,32
    800008fc:	84aa                	mv	s1,a0
  if(sz > 0)
    800008fe:	e989                	bnez	a1,80000910 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000900:	8526                	mv	a0,s1
    80000902:	f91ff0ef          	jal	80000892 <freewalk>
}
    80000906:	60e2                	ld	ra,24(sp)
    80000908:	6442                	ld	s0,16(sp)
    8000090a:	64a2                	ld	s1,8(sp)
    8000090c:	6105                	addi	sp,sp,32
    8000090e:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000910:	6785                	lui	a5,0x1
    80000912:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000914:	95be                	add	a1,a1,a5
    80000916:	4685                	li	a3,1
    80000918:	00c5d613          	srli	a2,a1,0xc
    8000091c:	4581                	li	a1,0
    8000091e:	d43ff0ef          	jal	80000660 <uvmunmap>
    80000922:	bff9                	j	80000900 <uvmfree+0xe>

0000000080000924 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000924:	ca4d                	beqz	a2,800009d6 <uvmcopy+0xb2>
{
    80000926:	715d                	addi	sp,sp,-80
    80000928:	e486                	sd	ra,72(sp)
    8000092a:	e0a2                	sd	s0,64(sp)
    8000092c:	fc26                	sd	s1,56(sp)
    8000092e:	f84a                	sd	s2,48(sp)
    80000930:	f44e                	sd	s3,40(sp)
    80000932:	f052                	sd	s4,32(sp)
    80000934:	ec56                	sd	s5,24(sp)
    80000936:	e85a                	sd	s6,16(sp)
    80000938:	e45e                	sd	s7,8(sp)
    8000093a:	e062                	sd	s8,0(sp)
    8000093c:	0880                	addi	s0,sp,80
    8000093e:	8baa                	mv	s7,a0
    80000940:	8b2e                	mv	s6,a1
    80000942:	8ab2                	mv	s5,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000944:	4981                	li	s3,0
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000946:	6a05                	lui	s4,0x1
    if((pte = walk(old, i, 0)) == 0)
    80000948:	4601                	li	a2,0
    8000094a:	85ce                	mv	a1,s3
    8000094c:	855e                	mv	a0,s7
    8000094e:	a95ff0ef          	jal	800003e2 <walk>
    80000952:	cd1d                	beqz	a0,80000990 <uvmcopy+0x6c>
    if((*pte & PTE_V) == 0)
    80000954:	6118                	ld	a4,0(a0)
    80000956:	00177793          	andi	a5,a4,1
    8000095a:	c3a9                	beqz	a5,8000099c <uvmcopy+0x78>
    pa = PTE2PA(*pte);
    8000095c:	00a75593          	srli	a1,a4,0xa
    80000960:	00c59c13          	slli	s8,a1,0xc
    flags = PTE_FLAGS(*pte);
    80000964:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80000968:	f96ff0ef          	jal	800000fe <kalloc>
    8000096c:	892a                	mv	s2,a0
    8000096e:	c121                	beqz	a0,800009ae <uvmcopy+0x8a>
    memmove(mem, (char*)pa, PGSIZE);
    80000970:	8652                	mv	a2,s4
    80000972:	85e2                	mv	a1,s8
    80000974:	83fff0ef          	jal	800001b2 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000978:	8726                	mv	a4,s1
    8000097a:	86ca                	mv	a3,s2
    8000097c:	8652                	mv	a2,s4
    8000097e:	85ce                	mv	a1,s3
    80000980:	855a                	mv	a0,s6
    80000982:	b39ff0ef          	jal	800004ba <mappages>
    80000986:	e10d                	bnez	a0,800009a8 <uvmcopy+0x84>
  for(i = 0; i < sz; i += PGSIZE){
    80000988:	99d2                	add	s3,s3,s4
    8000098a:	fb59efe3          	bltu	s3,s5,80000948 <uvmcopy+0x24>
    8000098e:	a805                	j	800009be <uvmcopy+0x9a>
      panic("uvmcopy: pte should exist");
    80000990:	00006517          	auipc	a0,0x6
    80000994:	7b850513          	addi	a0,a0,1976 # 80007148 <etext+0x148>
    80000998:	50f040ef          	jal	800056a6 <panic>
      panic("uvmcopy: page not present");
    8000099c:	00006517          	auipc	a0,0x6
    800009a0:	7cc50513          	addi	a0,a0,1996 # 80007168 <etext+0x168>
    800009a4:	503040ef          	jal	800056a6 <panic>
      kfree(mem);
    800009a8:	854a                	mv	a0,s2
    800009aa:	e72ff0ef          	jal	8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800009ae:	4685                	li	a3,1
    800009b0:	00c9d613          	srli	a2,s3,0xc
    800009b4:	4581                	li	a1,0
    800009b6:	855a                	mv	a0,s6
    800009b8:	ca9ff0ef          	jal	80000660 <uvmunmap>
  return -1;
    800009bc:	557d                	li	a0,-1
}
    800009be:	60a6                	ld	ra,72(sp)
    800009c0:	6406                	ld	s0,64(sp)
    800009c2:	74e2                	ld	s1,56(sp)
    800009c4:	7942                	ld	s2,48(sp)
    800009c6:	79a2                	ld	s3,40(sp)
    800009c8:	7a02                	ld	s4,32(sp)
    800009ca:	6ae2                	ld	s5,24(sp)
    800009cc:	6b42                	ld	s6,16(sp)
    800009ce:	6ba2                	ld	s7,8(sp)
    800009d0:	6c02                	ld	s8,0(sp)
    800009d2:	6161                	addi	sp,sp,80
    800009d4:	8082                	ret
  return 0;
    800009d6:	4501                	li	a0,0
}
    800009d8:	8082                	ret

00000000800009da <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800009da:	1141                	addi	sp,sp,-16
    800009dc:	e406                	sd	ra,8(sp)
    800009de:	e022                	sd	s0,0(sp)
    800009e0:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800009e2:	4601                	li	a2,0
    800009e4:	9ffff0ef          	jal	800003e2 <walk>
  if(pte == 0)
    800009e8:	c901                	beqz	a0,800009f8 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800009ea:	611c                	ld	a5,0(a0)
    800009ec:	9bbd                	andi	a5,a5,-17
    800009ee:	e11c                	sd	a5,0(a0)
}
    800009f0:	60a2                	ld	ra,8(sp)
    800009f2:	6402                	ld	s0,0(sp)
    800009f4:	0141                	addi	sp,sp,16
    800009f6:	8082                	ret
    panic("uvmclear");
    800009f8:	00006517          	auipc	a0,0x6
    800009fc:	79050513          	addi	a0,a0,1936 # 80007188 <etext+0x188>
    80000a00:	4a7040ef          	jal	800056a6 <panic>

0000000080000a04 <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80000a04:	c2d9                	beqz	a3,80000a8a <copyout+0x86>
{
    80000a06:	711d                	addi	sp,sp,-96
    80000a08:	ec86                	sd	ra,88(sp)
    80000a0a:	e8a2                	sd	s0,80(sp)
    80000a0c:	e4a6                	sd	s1,72(sp)
    80000a0e:	e0ca                	sd	s2,64(sp)
    80000a10:	fc4e                	sd	s3,56(sp)
    80000a12:	f852                	sd	s4,48(sp)
    80000a14:	f456                	sd	s5,40(sp)
    80000a16:	f05a                	sd	s6,32(sp)
    80000a18:	ec5e                	sd	s7,24(sp)
    80000a1a:	e862                	sd	s8,16(sp)
    80000a1c:	e466                	sd	s9,8(sp)
    80000a1e:	e06a                	sd	s10,0(sp)
    80000a20:	1080                	addi	s0,sp,96
    80000a22:	8c2a                	mv	s8,a0
    80000a24:	892e                	mv	s2,a1
    80000a26:	8ab2                	mv	s5,a2
    80000a28:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(dstva);
    80000a2a:	7cfd                	lui	s9,0xfffff
    if(va0 >= MAXVA)
    80000a2c:	5bfd                	li	s7,-1
    80000a2e:	01abdb93          	srli	s7,s7,0x1a
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000a32:	4d55                	li	s10,21
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    n = PGSIZE - (dstva - va0);
    80000a34:	6b05                	lui	s6,0x1
    80000a36:	a015                	j	80000a5a <copyout+0x56>
    pa0 = PTE2PA(*pte);
    80000a38:	83a9                	srli	a5,a5,0xa
    80000a3a:	07b2                	slli	a5,a5,0xc
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000a3c:	41390533          	sub	a0,s2,s3
    80000a40:	0004861b          	sext.w	a2,s1
    80000a44:	85d6                	mv	a1,s5
    80000a46:	953e                	add	a0,a0,a5
    80000a48:	f6aff0ef          	jal	800001b2 <memmove>

    len -= n;
    80000a4c:	409a0a33          	sub	s4,s4,s1
    src += n;
    80000a50:	9aa6                	add	s5,s5,s1
    dstva = va0 + PGSIZE;
    80000a52:	01698933          	add	s2,s3,s6
  while(len > 0){
    80000a56:	020a0863          	beqz	s4,80000a86 <copyout+0x82>
    va0 = PGROUNDDOWN(dstva);
    80000a5a:	019979b3          	and	s3,s2,s9
    if(va0 >= MAXVA)
    80000a5e:	033be863          	bltu	s7,s3,80000a8e <copyout+0x8a>
    pte = walk(pagetable, va0, 0);
    80000a62:	4601                	li	a2,0
    80000a64:	85ce                	mv	a1,s3
    80000a66:	8562                	mv	a0,s8
    80000a68:	97bff0ef          	jal	800003e2 <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80000a6c:	c121                	beqz	a0,80000aac <copyout+0xa8>
    80000a6e:	611c                	ld	a5,0(a0)
    80000a70:	0157f713          	andi	a4,a5,21
    80000a74:	03a71e63          	bne	a4,s10,80000ab0 <copyout+0xac>
    n = PGSIZE - (dstva - va0);
    80000a78:	412984b3          	sub	s1,s3,s2
    80000a7c:	94da                	add	s1,s1,s6
    if(n > len)
    80000a7e:	fa9a7de3          	bgeu	s4,s1,80000a38 <copyout+0x34>
    80000a82:	84d2                	mv	s1,s4
    80000a84:	bf55                	j	80000a38 <copyout+0x34>
  }
  return 0;
    80000a86:	4501                	li	a0,0
    80000a88:	a021                	j	80000a90 <copyout+0x8c>
    80000a8a:	4501                	li	a0,0
}
    80000a8c:	8082                	ret
      return -1;
    80000a8e:	557d                	li	a0,-1
}
    80000a90:	60e6                	ld	ra,88(sp)
    80000a92:	6446                	ld	s0,80(sp)
    80000a94:	64a6                	ld	s1,72(sp)
    80000a96:	6906                	ld	s2,64(sp)
    80000a98:	79e2                	ld	s3,56(sp)
    80000a9a:	7a42                	ld	s4,48(sp)
    80000a9c:	7aa2                	ld	s5,40(sp)
    80000a9e:	7b02                	ld	s6,32(sp)
    80000aa0:	6be2                	ld	s7,24(sp)
    80000aa2:	6c42                	ld	s8,16(sp)
    80000aa4:	6ca2                	ld	s9,8(sp)
    80000aa6:	6d02                	ld	s10,0(sp)
    80000aa8:	6125                	addi	sp,sp,96
    80000aaa:	8082                	ret
      return -1;
    80000aac:	557d                	li	a0,-1
    80000aae:	b7cd                	j	80000a90 <copyout+0x8c>
    80000ab0:	557d                	li	a0,-1
    80000ab2:	bff9                	j	80000a90 <copyout+0x8c>

0000000080000ab4 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80000ab4:	c6a5                	beqz	a3,80000b1c <copyin+0x68>
{
    80000ab6:	715d                	addi	sp,sp,-80
    80000ab8:	e486                	sd	ra,72(sp)
    80000aba:	e0a2                	sd	s0,64(sp)
    80000abc:	fc26                	sd	s1,56(sp)
    80000abe:	f84a                	sd	s2,48(sp)
    80000ac0:	f44e                	sd	s3,40(sp)
    80000ac2:	f052                	sd	s4,32(sp)
    80000ac4:	ec56                	sd	s5,24(sp)
    80000ac6:	e85a                	sd	s6,16(sp)
    80000ac8:	e45e                	sd	s7,8(sp)
    80000aca:	e062                	sd	s8,0(sp)
    80000acc:	0880                	addi	s0,sp,80
    80000ace:	8b2a                	mv	s6,a0
    80000ad0:	8a2e                	mv	s4,a1
    80000ad2:	8c32                	mv	s8,a2
    80000ad4:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000ad6:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000ad8:	6a85                	lui	s5,0x1
    80000ada:	a00d                	j	80000afc <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000adc:	018505b3          	add	a1,a0,s8
    80000ae0:	0004861b          	sext.w	a2,s1
    80000ae4:	412585b3          	sub	a1,a1,s2
    80000ae8:	8552                	mv	a0,s4
    80000aea:	ec8ff0ef          	jal	800001b2 <memmove>

    len -= n;
    80000aee:	409989b3          	sub	s3,s3,s1
    dst += n;
    80000af2:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80000af4:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80000af8:	02098063          	beqz	s3,80000b18 <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    80000afc:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80000b00:	85ca                	mv	a1,s2
    80000b02:	855a                	mv	a0,s6
    80000b04:	979ff0ef          	jal	8000047c <walkaddr>
    if(pa0 == 0)
    80000b08:	cd01                	beqz	a0,80000b20 <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    80000b0a:	418904b3          	sub	s1,s2,s8
    80000b0e:	94d6                	add	s1,s1,s5
    if(n > len)
    80000b10:	fc99f6e3          	bgeu	s3,s1,80000adc <copyin+0x28>
    80000b14:	84ce                	mv	s1,s3
    80000b16:	b7d9                	j	80000adc <copyin+0x28>
  }
  return 0;
    80000b18:	4501                	li	a0,0
    80000b1a:	a021                	j	80000b22 <copyin+0x6e>
    80000b1c:	4501                	li	a0,0
}
    80000b1e:	8082                	ret
      return -1;
    80000b20:	557d                	li	a0,-1
}
    80000b22:	60a6                	ld	ra,72(sp)
    80000b24:	6406                	ld	s0,64(sp)
    80000b26:	74e2                	ld	s1,56(sp)
    80000b28:	7942                	ld	s2,48(sp)
    80000b2a:	79a2                	ld	s3,40(sp)
    80000b2c:	7a02                	ld	s4,32(sp)
    80000b2e:	6ae2                	ld	s5,24(sp)
    80000b30:	6b42                	ld	s6,16(sp)
    80000b32:	6ba2                	ld	s7,8(sp)
    80000b34:	6c02                	ld	s8,0(sp)
    80000b36:	6161                	addi	sp,sp,80
    80000b38:	8082                	ret

0000000080000b3a <copyinstr>:
// Copy bytes to dst from virtual address srcva in a given page table,
// until a '\0', or max.
// Return 0 on success, -1 on error.
int
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
    80000b3a:	715d                	addi	sp,sp,-80
    80000b3c:	e486                	sd	ra,72(sp)
    80000b3e:	e0a2                	sd	s0,64(sp)
    80000b40:	fc26                	sd	s1,56(sp)
    80000b42:	f84a                	sd	s2,48(sp)
    80000b44:	f44e                	sd	s3,40(sp)
    80000b46:	f052                	sd	s4,32(sp)
    80000b48:	ec56                	sd	s5,24(sp)
    80000b4a:	e85a                	sd	s6,16(sp)
    80000b4c:	e45e                	sd	s7,8(sp)
    80000b4e:	0880                	addi	s0,sp,80
    80000b50:	8aaa                	mv	s5,a0
    80000b52:	89ae                	mv	s3,a1
    80000b54:	8bb2                	mv	s7,a2
    80000b56:	84b6                	mv	s1,a3
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    va0 = PGROUNDDOWN(srcva);
    80000b58:	7b7d                	lui	s6,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000b5a:	6a05                	lui	s4,0x1
    80000b5c:	a02d                	j	80000b86 <copyinstr+0x4c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000b5e:	00078023          	sb	zero,0(a5)
    80000b62:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000b64:	0017c793          	xori	a5,a5,1
    80000b68:	40f0053b          	negw	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000b6c:	60a6                	ld	ra,72(sp)
    80000b6e:	6406                	ld	s0,64(sp)
    80000b70:	74e2                	ld	s1,56(sp)
    80000b72:	7942                	ld	s2,48(sp)
    80000b74:	79a2                	ld	s3,40(sp)
    80000b76:	7a02                	ld	s4,32(sp)
    80000b78:	6ae2                	ld	s5,24(sp)
    80000b7a:	6b42                	ld	s6,16(sp)
    80000b7c:	6ba2                	ld	s7,8(sp)
    80000b7e:	6161                	addi	sp,sp,80
    80000b80:	8082                	ret
    srcva = va0 + PGSIZE;
    80000b82:	01490bb3          	add	s7,s2,s4
  while(got_null == 0 && max > 0){
    80000b86:	c4b1                	beqz	s1,80000bd2 <copyinstr+0x98>
    va0 = PGROUNDDOWN(srcva);
    80000b88:	016bf933          	and	s2,s7,s6
    pa0 = walkaddr(pagetable, va0);
    80000b8c:	85ca                	mv	a1,s2
    80000b8e:	8556                	mv	a0,s5
    80000b90:	8edff0ef          	jal	8000047c <walkaddr>
    if(pa0 == 0)
    80000b94:	c129                	beqz	a0,80000bd6 <copyinstr+0x9c>
    n = PGSIZE - (srcva - va0);
    80000b96:	41790633          	sub	a2,s2,s7
    80000b9a:	9652                	add	a2,a2,s4
    if(n > max)
    80000b9c:	00c4f363          	bgeu	s1,a2,80000ba2 <copyinstr+0x68>
    80000ba0:	8626                	mv	a2,s1
    char *p = (char *) (pa0 + (srcva - va0));
    80000ba2:	412b8bb3          	sub	s7,s7,s2
    80000ba6:	9baa                	add	s7,s7,a0
    while(n > 0){
    80000ba8:	de69                	beqz	a2,80000b82 <copyinstr+0x48>
    80000baa:	87ce                	mv	a5,s3
      if(*p == '\0'){
    80000bac:	413b86b3          	sub	a3,s7,s3
    while(n > 0){
    80000bb0:	964e                	add	a2,a2,s3
    80000bb2:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000bb4:	00f68733          	add	a4,a3,a5
    80000bb8:	00074703          	lbu	a4,0(a4)
    80000bbc:	d34d                	beqz	a4,80000b5e <copyinstr+0x24>
        *dst = *p;
    80000bbe:	00e78023          	sb	a4,0(a5)
      dst++;
    80000bc2:	0785                	addi	a5,a5,1
    while(n > 0){
    80000bc4:	fec797e3          	bne	a5,a2,80000bb2 <copyinstr+0x78>
    80000bc8:	14fd                	addi	s1,s1,-1
    80000bca:	94ce                	add	s1,s1,s3
      --max;
    80000bcc:	8c8d                	sub	s1,s1,a1
    80000bce:	89be                	mv	s3,a5
    80000bd0:	bf4d                	j	80000b82 <copyinstr+0x48>
    80000bd2:	4781                	li	a5,0
    80000bd4:	bf41                	j	80000b64 <copyinstr+0x2a>
      return -1;
    80000bd6:	557d                	li	a0,-1
    80000bd8:	bf51                	j	80000b6c <copyinstr+0x32>

0000000080000bda <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000bda:	715d                	addi	sp,sp,-80
    80000bdc:	e486                	sd	ra,72(sp)
    80000bde:	e0a2                	sd	s0,64(sp)
    80000be0:	fc26                	sd	s1,56(sp)
    80000be2:	f84a                	sd	s2,48(sp)
    80000be4:	f44e                	sd	s3,40(sp)
    80000be6:	f052                	sd	s4,32(sp)
    80000be8:	ec56                	sd	s5,24(sp)
    80000bea:	e85a                	sd	s6,16(sp)
    80000bec:	e45e                	sd	s7,8(sp)
    80000bee:	e062                	sd	s8,0(sp)
    80000bf0:	0880                	addi	s0,sp,80
    80000bf2:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000bf4:	00007497          	auipc	s1,0x7
    80000bf8:	17c48493          	addi	s1,s1,380 # 80007d70 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000bfc:	8c26                	mv	s8,s1
    80000bfe:	a4fa57b7          	lui	a5,0xa4fa5
    80000c02:	fa578793          	addi	a5,a5,-91 # ffffffffa4fa4fa5 <end+0xffffffff24f88f45>
    80000c06:	4fa50937          	lui	s2,0x4fa50
    80000c0a:	a5090913          	addi	s2,s2,-1456 # 4fa4fa50 <_entry-0x305b05b0>
    80000c0e:	1902                	slli	s2,s2,0x20
    80000c10:	993e                	add	s2,s2,a5
    80000c12:	040009b7          	lui	s3,0x4000
    80000c16:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000c18:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000c1a:	4b99                	li	s7,6
    80000c1c:	6b05                	lui	s6,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c1e:	00008a97          	auipc	s5,0x8
    80000c22:	f62a8a93          	addi	s5,s5,-158 # 80008b80 <tickslock>
    char *pa = kalloc();
    80000c26:	cd8ff0ef          	jal	800000fe <kalloc>
    80000c2a:	862a                	mv	a2,a0
    if(pa == 0)
    80000c2c:	c121                	beqz	a0,80000c6c <proc_mapstacks+0x92>
    uint64 va = KSTACK((int) (p - proc));
    80000c2e:	418485b3          	sub	a1,s1,s8
    80000c32:	858d                	srai	a1,a1,0x3
    80000c34:	032585b3          	mul	a1,a1,s2
    80000c38:	2585                	addiw	a1,a1,1
    80000c3a:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000c3e:	875e                	mv	a4,s7
    80000c40:	86da                	mv	a3,s6
    80000c42:	40b985b3          	sub	a1,s3,a1
    80000c46:	8552                	mv	a0,s4
    80000c48:	929ff0ef          	jal	80000570 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c4c:	16848493          	addi	s1,s1,360
    80000c50:	fd549be3          	bne	s1,s5,80000c26 <proc_mapstacks+0x4c>
  }
}
    80000c54:	60a6                	ld	ra,72(sp)
    80000c56:	6406                	ld	s0,64(sp)
    80000c58:	74e2                	ld	s1,56(sp)
    80000c5a:	7942                	ld	s2,48(sp)
    80000c5c:	79a2                	ld	s3,40(sp)
    80000c5e:	7a02                	ld	s4,32(sp)
    80000c60:	6ae2                	ld	s5,24(sp)
    80000c62:	6b42                	ld	s6,16(sp)
    80000c64:	6ba2                	ld	s7,8(sp)
    80000c66:	6c02                	ld	s8,0(sp)
    80000c68:	6161                	addi	sp,sp,80
    80000c6a:	8082                	ret
      panic("kalloc");
    80000c6c:	00006517          	auipc	a0,0x6
    80000c70:	52c50513          	addi	a0,a0,1324 # 80007198 <etext+0x198>
    80000c74:	233040ef          	jal	800056a6 <panic>

0000000080000c78 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000c78:	7139                	addi	sp,sp,-64
    80000c7a:	fc06                	sd	ra,56(sp)
    80000c7c:	f822                	sd	s0,48(sp)
    80000c7e:	f426                	sd	s1,40(sp)
    80000c80:	f04a                	sd	s2,32(sp)
    80000c82:	ec4e                	sd	s3,24(sp)
    80000c84:	e852                	sd	s4,16(sp)
    80000c86:	e456                	sd	s5,8(sp)
    80000c88:	e05a                	sd	s6,0(sp)
    80000c8a:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000c8c:	00006597          	auipc	a1,0x6
    80000c90:	51458593          	addi	a1,a1,1300 # 800071a0 <etext+0x1a0>
    80000c94:	00007517          	auipc	a0,0x7
    80000c98:	cac50513          	addi	a0,a0,-852 # 80007940 <pid_lock>
    80000c9c:	4b5040ef          	jal	80005950 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000ca0:	00006597          	auipc	a1,0x6
    80000ca4:	50858593          	addi	a1,a1,1288 # 800071a8 <etext+0x1a8>
    80000ca8:	00007517          	auipc	a0,0x7
    80000cac:	cb050513          	addi	a0,a0,-848 # 80007958 <wait_lock>
    80000cb0:	4a1040ef          	jal	80005950 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cb4:	00007497          	auipc	s1,0x7
    80000cb8:	0bc48493          	addi	s1,s1,188 # 80007d70 <proc>
      initlock(&p->lock, "proc");
    80000cbc:	00006b17          	auipc	s6,0x6
    80000cc0:	4fcb0b13          	addi	s6,s6,1276 # 800071b8 <etext+0x1b8>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000cc4:	8aa6                	mv	s5,s1
    80000cc6:	a4fa57b7          	lui	a5,0xa4fa5
    80000cca:	fa578793          	addi	a5,a5,-91 # ffffffffa4fa4fa5 <end+0xffffffff24f88f45>
    80000cce:	4fa50937          	lui	s2,0x4fa50
    80000cd2:	a5090913          	addi	s2,s2,-1456 # 4fa4fa50 <_entry-0x305b05b0>
    80000cd6:	1902                	slli	s2,s2,0x20
    80000cd8:	993e                	add	s2,s2,a5
    80000cda:	040009b7          	lui	s3,0x4000
    80000cde:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000ce0:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ce2:	00008a17          	auipc	s4,0x8
    80000ce6:	e9ea0a13          	addi	s4,s4,-354 # 80008b80 <tickslock>
      initlock(&p->lock, "proc");
    80000cea:	85da                	mv	a1,s6
    80000cec:	8526                	mv	a0,s1
    80000cee:	463040ef          	jal	80005950 <initlock>
      p->state = UNUSED;
    80000cf2:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000cf6:	415487b3          	sub	a5,s1,s5
    80000cfa:	878d                	srai	a5,a5,0x3
    80000cfc:	032787b3          	mul	a5,a5,s2
    80000d00:	2785                	addiw	a5,a5,1
    80000d02:	00d7979b          	slliw	a5,a5,0xd
    80000d06:	40f987b3          	sub	a5,s3,a5
    80000d0a:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d0c:	16848493          	addi	s1,s1,360
    80000d10:	fd449de3          	bne	s1,s4,80000cea <procinit+0x72>
  }
}
    80000d14:	70e2                	ld	ra,56(sp)
    80000d16:	7442                	ld	s0,48(sp)
    80000d18:	74a2                	ld	s1,40(sp)
    80000d1a:	7902                	ld	s2,32(sp)
    80000d1c:	69e2                	ld	s3,24(sp)
    80000d1e:	6a42                	ld	s4,16(sp)
    80000d20:	6aa2                	ld	s5,8(sp)
    80000d22:	6b02                	ld	s6,0(sp)
    80000d24:	6121                	addi	sp,sp,64
    80000d26:	8082                	ret

0000000080000d28 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000d28:	1141                	addi	sp,sp,-16
    80000d2a:	e406                	sd	ra,8(sp)
    80000d2c:	e022                	sd	s0,0(sp)
    80000d2e:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000d30:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000d32:	2501                	sext.w	a0,a0
    80000d34:	60a2                	ld	ra,8(sp)
    80000d36:	6402                	ld	s0,0(sp)
    80000d38:	0141                	addi	sp,sp,16
    80000d3a:	8082                	ret

0000000080000d3c <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000d3c:	1141                	addi	sp,sp,-16
    80000d3e:	e406                	sd	ra,8(sp)
    80000d40:	e022                	sd	s0,0(sp)
    80000d42:	0800                	addi	s0,sp,16
    80000d44:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000d46:	2781                	sext.w	a5,a5
    80000d48:	079e                	slli	a5,a5,0x7
  return c;
}
    80000d4a:	00007517          	auipc	a0,0x7
    80000d4e:	c2650513          	addi	a0,a0,-986 # 80007970 <cpus>
    80000d52:	953e                	add	a0,a0,a5
    80000d54:	60a2                	ld	ra,8(sp)
    80000d56:	6402                	ld	s0,0(sp)
    80000d58:	0141                	addi	sp,sp,16
    80000d5a:	8082                	ret

0000000080000d5c <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000d5c:	1101                	addi	sp,sp,-32
    80000d5e:	ec06                	sd	ra,24(sp)
    80000d60:	e822                	sd	s0,16(sp)
    80000d62:	e426                	sd	s1,8(sp)
    80000d64:	1000                	addi	s0,sp,32
  push_off();
    80000d66:	42f040ef          	jal	80005994 <push_off>
    80000d6a:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000d6c:	2781                	sext.w	a5,a5
    80000d6e:	079e                	slli	a5,a5,0x7
    80000d70:	00007717          	auipc	a4,0x7
    80000d74:	bd070713          	addi	a4,a4,-1072 # 80007940 <pid_lock>
    80000d78:	97ba                	add	a5,a5,a4
    80000d7a:	7b84                	ld	s1,48(a5)
  pop_off();
    80000d7c:	49d040ef          	jal	80005a18 <pop_off>
  return p;
}
    80000d80:	8526                	mv	a0,s1
    80000d82:	60e2                	ld	ra,24(sp)
    80000d84:	6442                	ld	s0,16(sp)
    80000d86:	64a2                	ld	s1,8(sp)
    80000d88:	6105                	addi	sp,sp,32
    80000d8a:	8082                	ret

0000000080000d8c <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000d8c:	1141                	addi	sp,sp,-16
    80000d8e:	e406                	sd	ra,8(sp)
    80000d90:	e022                	sd	s0,0(sp)
    80000d92:	0800                	addi	s0,sp,16
  static int first = 1;
  
  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80000d94:	fc9ff0ef          	jal	80000d5c <myproc>
    80000d98:	4d1040ef          	jal	80005a68 <release>

  if (first) {
    80000d9c:	00007797          	auipc	a5,0x7
    80000da0:	b047a783          	lw	a5,-1276(a5) # 800078a0 <first.1>
    80000da4:	e799                	bnez	a5,80000db2 <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80000da6:	2b3000ef          	jal	80001858 <usertrapret>
}
    80000daa:	60a2                	ld	ra,8(sp)
    80000dac:	6402                	ld	s0,0(sp)
    80000dae:	0141                	addi	sp,sp,16
    80000db0:	8082                	ret
    fsinit(ROOTDEV);
    80000db2:	4505                	li	a0,1
    80000db4:	6c8010ef          	jal	8000247c <fsinit>
    first = 0;
    80000db8:	00007797          	auipc	a5,0x7
    80000dbc:	ae07a423          	sw	zero,-1304(a5) # 800078a0 <first.1>
    __sync_synchronize();
    80000dc0:	0330000f          	fence	rw,rw
    80000dc4:	b7cd                	j	80000da6 <forkret+0x1a>

0000000080000dc6 <allocpid>:
{
    80000dc6:	1101                	addi	sp,sp,-32
    80000dc8:	ec06                	sd	ra,24(sp)
    80000dca:	e822                	sd	s0,16(sp)
    80000dcc:	e426                	sd	s1,8(sp)
    80000dce:	e04a                	sd	s2,0(sp)
    80000dd0:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000dd2:	00007917          	auipc	s2,0x7
    80000dd6:	b6e90913          	addi	s2,s2,-1170 # 80007940 <pid_lock>
    80000dda:	854a                	mv	a0,s2
    80000ddc:	3f9040ef          	jal	800059d4 <acquire>
  pid = nextpid;
    80000de0:	00007797          	auipc	a5,0x7
    80000de4:	ac478793          	addi	a5,a5,-1340 # 800078a4 <nextpid>
    80000de8:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000dea:	0014871b          	addiw	a4,s1,1
    80000dee:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000df0:	854a                	mv	a0,s2
    80000df2:	477040ef          	jal	80005a68 <release>
}
    80000df6:	8526                	mv	a0,s1
    80000df8:	60e2                	ld	ra,24(sp)
    80000dfa:	6442                	ld	s0,16(sp)
    80000dfc:	64a2                	ld	s1,8(sp)
    80000dfe:	6902                	ld	s2,0(sp)
    80000e00:	6105                	addi	sp,sp,32
    80000e02:	8082                	ret

0000000080000e04 <proc_pagetable>:
{
    80000e04:	1101                	addi	sp,sp,-32
    80000e06:	ec06                	sd	ra,24(sp)
    80000e08:	e822                	sd	s0,16(sp)
    80000e0a:	e426                	sd	s1,8(sp)
    80000e0c:	e04a                	sd	s2,0(sp)
    80000e0e:	1000                	addi	s0,sp,32
    80000e10:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000e12:	90bff0ef          	jal	8000071c <uvmcreate>
    80000e16:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000e18:	cd05                	beqz	a0,80000e50 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000e1a:	4729                	li	a4,10
    80000e1c:	00005697          	auipc	a3,0x5
    80000e20:	1e468693          	addi	a3,a3,484 # 80006000 <_trampoline>
    80000e24:	6605                	lui	a2,0x1
    80000e26:	040005b7          	lui	a1,0x4000
    80000e2a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000e2c:	05b2                	slli	a1,a1,0xc
    80000e2e:	e8cff0ef          	jal	800004ba <mappages>
    80000e32:	02054663          	bltz	a0,80000e5e <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000e36:	4719                	li	a4,6
    80000e38:	05893683          	ld	a3,88(s2)
    80000e3c:	6605                	lui	a2,0x1
    80000e3e:	020005b7          	lui	a1,0x2000
    80000e42:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000e44:	05b6                	slli	a1,a1,0xd
    80000e46:	8526                	mv	a0,s1
    80000e48:	e72ff0ef          	jal	800004ba <mappages>
    80000e4c:	00054f63          	bltz	a0,80000e6a <proc_pagetable+0x66>
}
    80000e50:	8526                	mv	a0,s1
    80000e52:	60e2                	ld	ra,24(sp)
    80000e54:	6442                	ld	s0,16(sp)
    80000e56:	64a2                	ld	s1,8(sp)
    80000e58:	6902                	ld	s2,0(sp)
    80000e5a:	6105                	addi	sp,sp,32
    80000e5c:	8082                	ret
    uvmfree(pagetable, 0);
    80000e5e:	4581                	li	a1,0
    80000e60:	8526                	mv	a0,s1
    80000e62:	a91ff0ef          	jal	800008f2 <uvmfree>
    return 0;
    80000e66:	4481                	li	s1,0
    80000e68:	b7e5                	j	80000e50 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000e6a:	4681                	li	a3,0
    80000e6c:	4605                	li	a2,1
    80000e6e:	040005b7          	lui	a1,0x4000
    80000e72:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000e74:	05b2                	slli	a1,a1,0xc
    80000e76:	8526                	mv	a0,s1
    80000e78:	fe8ff0ef          	jal	80000660 <uvmunmap>
    uvmfree(pagetable, 0);
    80000e7c:	4581                	li	a1,0
    80000e7e:	8526                	mv	a0,s1
    80000e80:	a73ff0ef          	jal	800008f2 <uvmfree>
    return 0;
    80000e84:	4481                	li	s1,0
    80000e86:	b7e9                	j	80000e50 <proc_pagetable+0x4c>

0000000080000e88 <proc_freepagetable>:
{
    80000e88:	1101                	addi	sp,sp,-32
    80000e8a:	ec06                	sd	ra,24(sp)
    80000e8c:	e822                	sd	s0,16(sp)
    80000e8e:	e426                	sd	s1,8(sp)
    80000e90:	e04a                	sd	s2,0(sp)
    80000e92:	1000                	addi	s0,sp,32
    80000e94:	84aa                	mv	s1,a0
    80000e96:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000e98:	4681                	li	a3,0
    80000e9a:	4605                	li	a2,1
    80000e9c:	040005b7          	lui	a1,0x4000
    80000ea0:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000ea2:	05b2                	slli	a1,a1,0xc
    80000ea4:	fbcff0ef          	jal	80000660 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000ea8:	4681                	li	a3,0
    80000eaa:	4605                	li	a2,1
    80000eac:	020005b7          	lui	a1,0x2000
    80000eb0:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000eb2:	05b6                	slli	a1,a1,0xd
    80000eb4:	8526                	mv	a0,s1
    80000eb6:	faaff0ef          	jal	80000660 <uvmunmap>
  uvmfree(pagetable, sz);
    80000eba:	85ca                	mv	a1,s2
    80000ebc:	8526                	mv	a0,s1
    80000ebe:	a35ff0ef          	jal	800008f2 <uvmfree>
}
    80000ec2:	60e2                	ld	ra,24(sp)
    80000ec4:	6442                	ld	s0,16(sp)
    80000ec6:	64a2                	ld	s1,8(sp)
    80000ec8:	6902                	ld	s2,0(sp)
    80000eca:	6105                	addi	sp,sp,32
    80000ecc:	8082                	ret

0000000080000ece <freeproc>:
{
    80000ece:	1101                	addi	sp,sp,-32
    80000ed0:	ec06                	sd	ra,24(sp)
    80000ed2:	e822                	sd	s0,16(sp)
    80000ed4:	e426                	sd	s1,8(sp)
    80000ed6:	1000                	addi	s0,sp,32
    80000ed8:	84aa                	mv	s1,a0
  if(p->trapframe)
    80000eda:	6d28                	ld	a0,88(a0)
    80000edc:	c119                	beqz	a0,80000ee2 <freeproc+0x14>
    kfree((void*)p->trapframe);
    80000ede:	93eff0ef          	jal	8000001c <kfree>
  p->trapframe = 0;
    80000ee2:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80000ee6:	68a8                	ld	a0,80(s1)
    80000ee8:	c501                	beqz	a0,80000ef0 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80000eea:	64ac                	ld	a1,72(s1)
    80000eec:	f9dff0ef          	jal	80000e88 <proc_freepagetable>
  p->pagetable = 0;
    80000ef0:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80000ef4:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80000ef8:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80000efc:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80000f00:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80000f04:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80000f08:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80000f0c:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80000f10:	0004ac23          	sw	zero,24(s1)
}
    80000f14:	60e2                	ld	ra,24(sp)
    80000f16:	6442                	ld	s0,16(sp)
    80000f18:	64a2                	ld	s1,8(sp)
    80000f1a:	6105                	addi	sp,sp,32
    80000f1c:	8082                	ret

0000000080000f1e <allocproc>:
{
    80000f1e:	1101                	addi	sp,sp,-32
    80000f20:	ec06                	sd	ra,24(sp)
    80000f22:	e822                	sd	s0,16(sp)
    80000f24:	e426                	sd	s1,8(sp)
    80000f26:	e04a                	sd	s2,0(sp)
    80000f28:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f2a:	00007497          	auipc	s1,0x7
    80000f2e:	e4648493          	addi	s1,s1,-442 # 80007d70 <proc>
    80000f32:	00008917          	auipc	s2,0x8
    80000f36:	c4e90913          	addi	s2,s2,-946 # 80008b80 <tickslock>
    acquire(&p->lock);
    80000f3a:	8526                	mv	a0,s1
    80000f3c:	299040ef          	jal	800059d4 <acquire>
    if(p->state == UNUSED) {
    80000f40:	4c9c                	lw	a5,24(s1)
    80000f42:	c385                	beqz	a5,80000f62 <allocproc+0x44>
      release(&p->lock);
    80000f44:	8526                	mv	a0,s1
    80000f46:	323040ef          	jal	80005a68 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f4a:	16848493          	addi	s1,s1,360
    80000f4e:	ff2496e3          	bne	s1,s2,80000f3a <allocproc+0x1c>
  return 0;
    80000f52:	4481                	li	s1,0
}
    80000f54:	8526                	mv	a0,s1
    80000f56:	60e2                	ld	ra,24(sp)
    80000f58:	6442                	ld	s0,16(sp)
    80000f5a:	64a2                	ld	s1,8(sp)
    80000f5c:	6902                	ld	s2,0(sp)
    80000f5e:	6105                	addi	sp,sp,32
    80000f60:	8082                	ret
  p->pid = allocpid();
    80000f62:	e65ff0ef          	jal	80000dc6 <allocpid>
    80000f66:	d888                	sw	a0,48(s1)
  p->state = USED;
    80000f68:	4785                	li	a5,1
    80000f6a:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80000f6c:	992ff0ef          	jal	800000fe <kalloc>
    80000f70:	892a                	mv	s2,a0
    80000f72:	eca8                	sd	a0,88(s1)
    80000f74:	c905                	beqz	a0,80000fa4 <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80000f76:	8526                	mv	a0,s1
    80000f78:	e8dff0ef          	jal	80000e04 <proc_pagetable>
    80000f7c:	892a                	mv	s2,a0
    80000f7e:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80000f80:	c915                	beqz	a0,80000fb4 <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80000f82:	07000613          	li	a2,112
    80000f86:	4581                	li	a1,0
    80000f88:	06048513          	addi	a0,s1,96
    80000f8c:	9c2ff0ef          	jal	8000014e <memset>
  p->context.ra = (uint64)forkret;
    80000f90:	00000797          	auipc	a5,0x0
    80000f94:	dfc78793          	addi	a5,a5,-516 # 80000d8c <forkret>
    80000f98:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80000f9a:	60bc                	ld	a5,64(s1)
    80000f9c:	6705                	lui	a4,0x1
    80000f9e:	97ba                	add	a5,a5,a4
    80000fa0:	f4bc                	sd	a5,104(s1)
  return p;
    80000fa2:	bf4d                	j	80000f54 <allocproc+0x36>
    freeproc(p);
    80000fa4:	8526                	mv	a0,s1
    80000fa6:	f29ff0ef          	jal	80000ece <freeproc>
    release(&p->lock);
    80000faa:	8526                	mv	a0,s1
    80000fac:	2bd040ef          	jal	80005a68 <release>
    return 0;
    80000fb0:	84ca                	mv	s1,s2
    80000fb2:	b74d                	j	80000f54 <allocproc+0x36>
    freeproc(p);
    80000fb4:	8526                	mv	a0,s1
    80000fb6:	f19ff0ef          	jal	80000ece <freeproc>
    release(&p->lock);
    80000fba:	8526                	mv	a0,s1
    80000fbc:	2ad040ef          	jal	80005a68 <release>
    return 0;
    80000fc0:	84ca                	mv	s1,s2
    80000fc2:	bf49                	j	80000f54 <allocproc+0x36>

0000000080000fc4 <userinit>:
{
    80000fc4:	1101                	addi	sp,sp,-32
    80000fc6:	ec06                	sd	ra,24(sp)
    80000fc8:	e822                	sd	s0,16(sp)
    80000fca:	e426                	sd	s1,8(sp)
    80000fcc:	1000                	addi	s0,sp,32
  p = allocproc();
    80000fce:	f51ff0ef          	jal	80000f1e <allocproc>
    80000fd2:	84aa                	mv	s1,a0
  initproc = p;
    80000fd4:	00007797          	auipc	a5,0x7
    80000fd8:	92a7b623          	sd	a0,-1748(a5) # 80007900 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80000fdc:	03400613          	li	a2,52
    80000fe0:	00007597          	auipc	a1,0x7
    80000fe4:	8d058593          	addi	a1,a1,-1840 # 800078b0 <initcode>
    80000fe8:	6928                	ld	a0,80(a0)
    80000fea:	f58ff0ef          	jal	80000742 <uvmfirst>
  p->sz = PGSIZE;
    80000fee:	6785                	lui	a5,0x1
    80000ff0:	e4bc                	sd	a5,72(s1)
  p->trapframe->epc = 0;      // user program counter
    80000ff2:	6cb8                	ld	a4,88(s1)
    80000ff4:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80000ff8:	6cb8                	ld	a4,88(s1)
    80000ffa:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80000ffc:	4641                	li	a2,16
    80000ffe:	00006597          	auipc	a1,0x6
    80001002:	1c258593          	addi	a1,a1,450 # 800071c0 <etext+0x1c0>
    80001006:	15848513          	addi	a0,s1,344
    8000100a:	a96ff0ef          	jal	800002a0 <safestrcpy>
  p->cwd = namei("/");
    8000100e:	00006517          	auipc	a0,0x6
    80001012:	1c250513          	addi	a0,a0,450 # 800071d0 <etext+0x1d0>
    80001016:	619010ef          	jal	80002e2e <namei>
    8000101a:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000101e:	478d                	li	a5,3
    80001020:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001022:	8526                	mv	a0,s1
    80001024:	245040ef          	jal	80005a68 <release>
}
    80001028:	60e2                	ld	ra,24(sp)
    8000102a:	6442                	ld	s0,16(sp)
    8000102c:	64a2                	ld	s1,8(sp)
    8000102e:	6105                	addi	sp,sp,32
    80001030:	8082                	ret

0000000080001032 <growproc>:
{
    80001032:	1101                	addi	sp,sp,-32
    80001034:	ec06                	sd	ra,24(sp)
    80001036:	e822                	sd	s0,16(sp)
    80001038:	e426                	sd	s1,8(sp)
    8000103a:	e04a                	sd	s2,0(sp)
    8000103c:	1000                	addi	s0,sp,32
    8000103e:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001040:	d1dff0ef          	jal	80000d5c <myproc>
    80001044:	84aa                	mv	s1,a0
  sz = p->sz;
    80001046:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001048:	01204c63          	bgtz	s2,80001060 <growproc+0x2e>
  } else if(n < 0){
    8000104c:	02094463          	bltz	s2,80001074 <growproc+0x42>
  p->sz = sz;
    80001050:	e4ac                	sd	a1,72(s1)
  return 0;
    80001052:	4501                	li	a0,0
}
    80001054:	60e2                	ld	ra,24(sp)
    80001056:	6442                	ld	s0,16(sp)
    80001058:	64a2                	ld	s1,8(sp)
    8000105a:	6902                	ld	s2,0(sp)
    8000105c:	6105                	addi	sp,sp,32
    8000105e:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001060:	4691                	li	a3,4
    80001062:	00b90633          	add	a2,s2,a1
    80001066:	6928                	ld	a0,80(a0)
    80001068:	f7cff0ef          	jal	800007e4 <uvmalloc>
    8000106c:	85aa                	mv	a1,a0
    8000106e:	f16d                	bnez	a0,80001050 <growproc+0x1e>
      return -1;
    80001070:	557d                	li	a0,-1
    80001072:	b7cd                	j	80001054 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001074:	00b90633          	add	a2,s2,a1
    80001078:	6928                	ld	a0,80(a0)
    8000107a:	f26ff0ef          	jal	800007a0 <uvmdealloc>
    8000107e:	85aa                	mv	a1,a0
    80001080:	bfc1                	j	80001050 <growproc+0x1e>

0000000080001082 <fork>:
{
    80001082:	7139                	addi	sp,sp,-64
    80001084:	fc06                	sd	ra,56(sp)
    80001086:	f822                	sd	s0,48(sp)
    80001088:	f04a                	sd	s2,32(sp)
    8000108a:	e456                	sd	s5,8(sp)
    8000108c:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000108e:	ccfff0ef          	jal	80000d5c <myproc>
    80001092:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001094:	e8bff0ef          	jal	80000f1e <allocproc>
    80001098:	0e050a63          	beqz	a0,8000118c <fork+0x10a>
    8000109c:	e852                	sd	s4,16(sp)
    8000109e:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800010a0:	048ab603          	ld	a2,72(s5)
    800010a4:	692c                	ld	a1,80(a0)
    800010a6:	050ab503          	ld	a0,80(s5)
    800010aa:	87bff0ef          	jal	80000924 <uvmcopy>
    800010ae:	04054a63          	bltz	a0,80001102 <fork+0x80>
    800010b2:	f426                	sd	s1,40(sp)
    800010b4:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    800010b6:	048ab783          	ld	a5,72(s5)
    800010ba:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800010be:	058ab683          	ld	a3,88(s5)
    800010c2:	87b6                	mv	a5,a3
    800010c4:	058a3703          	ld	a4,88(s4)
    800010c8:	12068693          	addi	a3,a3,288
    800010cc:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800010d0:	6788                	ld	a0,8(a5)
    800010d2:	6b8c                	ld	a1,16(a5)
    800010d4:	6f90                	ld	a2,24(a5)
    800010d6:	01073023          	sd	a6,0(a4)
    800010da:	e708                	sd	a0,8(a4)
    800010dc:	eb0c                	sd	a1,16(a4)
    800010de:	ef10                	sd	a2,24(a4)
    800010e0:	02078793          	addi	a5,a5,32
    800010e4:	02070713          	addi	a4,a4,32
    800010e8:	fed792e3          	bne	a5,a3,800010cc <fork+0x4a>
  np->trapframe->a0 = 0;
    800010ec:	058a3783          	ld	a5,88(s4)
    800010f0:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800010f4:	0d0a8493          	addi	s1,s5,208
    800010f8:	0d0a0913          	addi	s2,s4,208
    800010fc:	150a8993          	addi	s3,s5,336
    80001100:	a831                	j	8000111c <fork+0x9a>
    freeproc(np);
    80001102:	8552                	mv	a0,s4
    80001104:	dcbff0ef          	jal	80000ece <freeproc>
    release(&np->lock);
    80001108:	8552                	mv	a0,s4
    8000110a:	15f040ef          	jal	80005a68 <release>
    return -1;
    8000110e:	597d                	li	s2,-1
    80001110:	6a42                	ld	s4,16(sp)
    80001112:	a0b5                	j	8000117e <fork+0xfc>
  for(i = 0; i < NOFILE; i++)
    80001114:	04a1                	addi	s1,s1,8
    80001116:	0921                	addi	s2,s2,8
    80001118:	01348963          	beq	s1,s3,8000112a <fork+0xa8>
    if(p->ofile[i])
    8000111c:	6088                	ld	a0,0(s1)
    8000111e:	d97d                	beqz	a0,80001114 <fork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    80001120:	2aa020ef          	jal	800033ca <filedup>
    80001124:	00a93023          	sd	a0,0(s2)
    80001128:	b7f5                	j	80001114 <fork+0x92>
  np->cwd = idup(p->cwd);
    8000112a:	150ab503          	ld	a0,336(s5)
    8000112e:	54c010ef          	jal	8000267a <idup>
    80001132:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001136:	4641                	li	a2,16
    80001138:	158a8593          	addi	a1,s5,344
    8000113c:	158a0513          	addi	a0,s4,344
    80001140:	960ff0ef          	jal	800002a0 <safestrcpy>
  pid = np->pid;
    80001144:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80001148:	8552                	mv	a0,s4
    8000114a:	11f040ef          	jal	80005a68 <release>
  acquire(&wait_lock);
    8000114e:	00007497          	auipc	s1,0x7
    80001152:	80a48493          	addi	s1,s1,-2038 # 80007958 <wait_lock>
    80001156:	8526                	mv	a0,s1
    80001158:	07d040ef          	jal	800059d4 <acquire>
  np->parent = p;
    8000115c:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001160:	8526                	mv	a0,s1
    80001162:	107040ef          	jal	80005a68 <release>
  acquire(&np->lock);
    80001166:	8552                	mv	a0,s4
    80001168:	06d040ef          	jal	800059d4 <acquire>
  np->state = RUNNABLE;
    8000116c:	478d                	li	a5,3
    8000116e:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001172:	8552                	mv	a0,s4
    80001174:	0f5040ef          	jal	80005a68 <release>
  return pid;
    80001178:	74a2                	ld	s1,40(sp)
    8000117a:	69e2                	ld	s3,24(sp)
    8000117c:	6a42                	ld	s4,16(sp)
}
    8000117e:	854a                	mv	a0,s2
    80001180:	70e2                	ld	ra,56(sp)
    80001182:	7442                	ld	s0,48(sp)
    80001184:	7902                	ld	s2,32(sp)
    80001186:	6aa2                	ld	s5,8(sp)
    80001188:	6121                	addi	sp,sp,64
    8000118a:	8082                	ret
    return -1;
    8000118c:	597d                	li	s2,-1
    8000118e:	bfc5                	j	8000117e <fork+0xfc>

0000000080001190 <scheduler>:
{
    80001190:	715d                	addi	sp,sp,-80
    80001192:	e486                	sd	ra,72(sp)
    80001194:	e0a2                	sd	s0,64(sp)
    80001196:	fc26                	sd	s1,56(sp)
    80001198:	f84a                	sd	s2,48(sp)
    8000119a:	f44e                	sd	s3,40(sp)
    8000119c:	f052                	sd	s4,32(sp)
    8000119e:	ec56                	sd	s5,24(sp)
    800011a0:	e85a                	sd	s6,16(sp)
    800011a2:	e45e                	sd	s7,8(sp)
    800011a4:	0880                	addi	s0,sp,80
    800011a6:	8792                	mv	a5,tp
  int id = r_tp();
    800011a8:	2781                	sext.w	a5,a5
  c->proc = 0;
    800011aa:	00779b13          	slli	s6,a5,0x7
    800011ae:	00006717          	auipc	a4,0x6
    800011b2:	79270713          	addi	a4,a4,1938 # 80007940 <pid_lock>
    800011b6:	975a                	add	a4,a4,s6
    800011b8:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800011bc:	00006717          	auipc	a4,0x6
    800011c0:	7bc70713          	addi	a4,a4,1980 # 80007978 <cpus+0x8>
    800011c4:	9b3a                	add	s6,s6,a4
      if(p->state == RUNNABLE) {
    800011c6:	4a0d                	li	s4,3
        p->state = RUNNING;
    800011c8:	4b91                	li	s7,4
        c->proc = p;
    800011ca:	079e                	slli	a5,a5,0x7
    800011cc:	00006a97          	auipc	s5,0x6
    800011d0:	774a8a93          	addi	s5,s5,1908 # 80007940 <pid_lock>
    800011d4:	9abe                	add	s5,s5,a5
    800011d6:	a0a9                	j	80001220 <scheduler+0x90>
      release(&p->lock);
    800011d8:	8526                	mv	a0,s1
    800011da:	08f040ef          	jal	80005a68 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800011de:	16848493          	addi	s1,s1,360
    800011e2:	03348663          	beq	s1,s3,8000120e <scheduler+0x7e>
      acquire(&p->lock);
    800011e6:	8526                	mv	a0,s1
    800011e8:	7ec040ef          	jal	800059d4 <acquire>
      if(p->state != UNUSED) {
    800011ec:	4c9c                	lw	a5,24(s1)
    800011ee:	d7ed                	beqz	a5,800011d8 <scheduler+0x48>
        nproc++;
    800011f0:	2905                	addiw	s2,s2,1
      if(p->state == RUNNABLE) {
    800011f2:	ff4793e3          	bne	a5,s4,800011d8 <scheduler+0x48>
        p->state = RUNNING;
    800011f6:	0174ac23          	sw	s7,24(s1)
        c->proc = p;
    800011fa:	029ab823          	sd	s1,48(s5)
        swtch(&c->context, &p->context);
    800011fe:	06048593          	addi	a1,s1,96
    80001202:	855a                	mv	a0,s6
    80001204:	5aa000ef          	jal	800017ae <swtch>
        c->proc = 0;
    80001208:	020ab823          	sd	zero,48(s5)
    8000120c:	b7f1                	j	800011d8 <scheduler+0x48>
    if(nproc <= 2) {   // only init and sh exist
    8000120e:	4789                	li	a5,2
    80001210:	0127c863          	blt	a5,s2,80001220 <scheduler+0x90>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001214:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001218:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000121c:	10079073          	csrw	sstatus,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001220:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001224:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001228:	10079073          	csrw	sstatus,a5
    int nproc = 0;
    8000122c:	4901                	li	s2,0
    for(p = proc; p < &proc[NPROC]; p++) {
    8000122e:	00007497          	auipc	s1,0x7
    80001232:	b4248493          	addi	s1,s1,-1214 # 80007d70 <proc>
    80001236:	00008997          	auipc	s3,0x8
    8000123a:	94a98993          	addi	s3,s3,-1718 # 80008b80 <tickslock>
    8000123e:	b765                	j	800011e6 <scheduler+0x56>

0000000080001240 <sched>:
{
    80001240:	7179                	addi	sp,sp,-48
    80001242:	f406                	sd	ra,40(sp)
    80001244:	f022                	sd	s0,32(sp)
    80001246:	ec26                	sd	s1,24(sp)
    80001248:	e84a                	sd	s2,16(sp)
    8000124a:	e44e                	sd	s3,8(sp)
    8000124c:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000124e:	b0fff0ef          	jal	80000d5c <myproc>
    80001252:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001254:	716040ef          	jal	8000596a <holding>
    80001258:	c92d                	beqz	a0,800012ca <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000125a:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000125c:	2781                	sext.w	a5,a5
    8000125e:	079e                	slli	a5,a5,0x7
    80001260:	00006717          	auipc	a4,0x6
    80001264:	6e070713          	addi	a4,a4,1760 # 80007940 <pid_lock>
    80001268:	97ba                	add	a5,a5,a4
    8000126a:	0a87a703          	lw	a4,168(a5)
    8000126e:	4785                	li	a5,1
    80001270:	06f71363          	bne	a4,a5,800012d6 <sched+0x96>
  if(p->state == RUNNING)
    80001274:	4c98                	lw	a4,24(s1)
    80001276:	4791                	li	a5,4
    80001278:	06f70563          	beq	a4,a5,800012e2 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000127c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001280:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001282:	e7b5                	bnez	a5,800012ee <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001284:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001286:	00006917          	auipc	s2,0x6
    8000128a:	6ba90913          	addi	s2,s2,1722 # 80007940 <pid_lock>
    8000128e:	2781                	sext.w	a5,a5
    80001290:	079e                	slli	a5,a5,0x7
    80001292:	97ca                	add	a5,a5,s2
    80001294:	0ac7a983          	lw	s3,172(a5)
    80001298:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000129a:	2781                	sext.w	a5,a5
    8000129c:	079e                	slli	a5,a5,0x7
    8000129e:	00006597          	auipc	a1,0x6
    800012a2:	6da58593          	addi	a1,a1,1754 # 80007978 <cpus+0x8>
    800012a6:	95be                	add	a1,a1,a5
    800012a8:	06048513          	addi	a0,s1,96
    800012ac:	502000ef          	jal	800017ae <swtch>
    800012b0:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800012b2:	2781                	sext.w	a5,a5
    800012b4:	079e                	slli	a5,a5,0x7
    800012b6:	993e                	add	s2,s2,a5
    800012b8:	0b392623          	sw	s3,172(s2)
}
    800012bc:	70a2                	ld	ra,40(sp)
    800012be:	7402                	ld	s0,32(sp)
    800012c0:	64e2                	ld	s1,24(sp)
    800012c2:	6942                	ld	s2,16(sp)
    800012c4:	69a2                	ld	s3,8(sp)
    800012c6:	6145                	addi	sp,sp,48
    800012c8:	8082                	ret
    panic("sched p->lock");
    800012ca:	00006517          	auipc	a0,0x6
    800012ce:	f0e50513          	addi	a0,a0,-242 # 800071d8 <etext+0x1d8>
    800012d2:	3d4040ef          	jal	800056a6 <panic>
    panic("sched locks");
    800012d6:	00006517          	auipc	a0,0x6
    800012da:	f1250513          	addi	a0,a0,-238 # 800071e8 <etext+0x1e8>
    800012de:	3c8040ef          	jal	800056a6 <panic>
    panic("sched running");
    800012e2:	00006517          	auipc	a0,0x6
    800012e6:	f1650513          	addi	a0,a0,-234 # 800071f8 <etext+0x1f8>
    800012ea:	3bc040ef          	jal	800056a6 <panic>
    panic("sched interruptible");
    800012ee:	00006517          	auipc	a0,0x6
    800012f2:	f1a50513          	addi	a0,a0,-230 # 80007208 <etext+0x208>
    800012f6:	3b0040ef          	jal	800056a6 <panic>

00000000800012fa <yield>:
{
    800012fa:	1101                	addi	sp,sp,-32
    800012fc:	ec06                	sd	ra,24(sp)
    800012fe:	e822                	sd	s0,16(sp)
    80001300:	e426                	sd	s1,8(sp)
    80001302:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001304:	a59ff0ef          	jal	80000d5c <myproc>
    80001308:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000130a:	6ca040ef          	jal	800059d4 <acquire>
  p->state = RUNNABLE;
    8000130e:	478d                	li	a5,3
    80001310:	cc9c                	sw	a5,24(s1)
  sched();
    80001312:	f2fff0ef          	jal	80001240 <sched>
  release(&p->lock);
    80001316:	8526                	mv	a0,s1
    80001318:	750040ef          	jal	80005a68 <release>
}
    8000131c:	60e2                	ld	ra,24(sp)
    8000131e:	6442                	ld	s0,16(sp)
    80001320:	64a2                	ld	s1,8(sp)
    80001322:	6105                	addi	sp,sp,32
    80001324:	8082                	ret

0000000080001326 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001326:	7179                	addi	sp,sp,-48
    80001328:	f406                	sd	ra,40(sp)
    8000132a:	f022                	sd	s0,32(sp)
    8000132c:	ec26                	sd	s1,24(sp)
    8000132e:	e84a                	sd	s2,16(sp)
    80001330:	e44e                	sd	s3,8(sp)
    80001332:	1800                	addi	s0,sp,48
    80001334:	89aa                	mv	s3,a0
    80001336:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001338:	a25ff0ef          	jal	80000d5c <myproc>
    8000133c:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000133e:	696040ef          	jal	800059d4 <acquire>
  release(lk);
    80001342:	854a                	mv	a0,s2
    80001344:	724040ef          	jal	80005a68 <release>

  // Go to sleep.
  p->chan = chan;
    80001348:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000134c:	4789                	li	a5,2
    8000134e:	cc9c                	sw	a5,24(s1)

  sched();
    80001350:	ef1ff0ef          	jal	80001240 <sched>

  // Tidy up.
  p->chan = 0;
    80001354:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001358:	8526                	mv	a0,s1
    8000135a:	70e040ef          	jal	80005a68 <release>
  acquire(lk);
    8000135e:	854a                	mv	a0,s2
    80001360:	674040ef          	jal	800059d4 <acquire>
}
    80001364:	70a2                	ld	ra,40(sp)
    80001366:	7402                	ld	s0,32(sp)
    80001368:	64e2                	ld	s1,24(sp)
    8000136a:	6942                	ld	s2,16(sp)
    8000136c:	69a2                	ld	s3,8(sp)
    8000136e:	6145                	addi	sp,sp,48
    80001370:	8082                	ret

0000000080001372 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80001372:	7179                	addi	sp,sp,-48
    80001374:	f406                	sd	ra,40(sp)
    80001376:	f022                	sd	s0,32(sp)
    80001378:	ec26                	sd	s1,24(sp)
    8000137a:	e84a                	sd	s2,16(sp)
    8000137c:	e44e                	sd	s3,8(sp)
    8000137e:	e052                	sd	s4,0(sp)
    80001380:	1800                	addi	s0,sp,48
    80001382:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001384:	00007497          	auipc	s1,0x7
    80001388:	9ec48493          	addi	s1,s1,-1556 # 80007d70 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    8000138c:	4989                	li	s3,2
  for(p = proc; p < &proc[NPROC]; p++) {
    8000138e:	00007917          	auipc	s2,0x7
    80001392:	7f290913          	addi	s2,s2,2034 # 80008b80 <tickslock>
    80001396:	a801                	j	800013a6 <wakeup+0x34>
        p->state = RUNNABLE;
      }
      release(&p->lock);
    80001398:	8526                	mv	a0,s1
    8000139a:	6ce040ef          	jal	80005a68 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000139e:	16848493          	addi	s1,s1,360
    800013a2:	03248263          	beq	s1,s2,800013c6 <wakeup+0x54>
    if(p != myproc()){
    800013a6:	9b7ff0ef          	jal	80000d5c <myproc>
    800013aa:	fea48ae3          	beq	s1,a0,8000139e <wakeup+0x2c>
      acquire(&p->lock);
    800013ae:	8526                	mv	a0,s1
    800013b0:	624040ef          	jal	800059d4 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800013b4:	4c9c                	lw	a5,24(s1)
    800013b6:	ff3791e3          	bne	a5,s3,80001398 <wakeup+0x26>
    800013ba:	709c                	ld	a5,32(s1)
    800013bc:	fd479ee3          	bne	a5,s4,80001398 <wakeup+0x26>
        p->state = RUNNABLE;
    800013c0:	478d                	li	a5,3
    800013c2:	cc9c                	sw	a5,24(s1)
    800013c4:	bfd1                	j	80001398 <wakeup+0x26>
    }
  }
}
    800013c6:	70a2                	ld	ra,40(sp)
    800013c8:	7402                	ld	s0,32(sp)
    800013ca:	64e2                	ld	s1,24(sp)
    800013cc:	6942                	ld	s2,16(sp)
    800013ce:	69a2                	ld	s3,8(sp)
    800013d0:	6a02                	ld	s4,0(sp)
    800013d2:	6145                	addi	sp,sp,48
    800013d4:	8082                	ret

00000000800013d6 <reparent>:
{
    800013d6:	7179                	addi	sp,sp,-48
    800013d8:	f406                	sd	ra,40(sp)
    800013da:	f022                	sd	s0,32(sp)
    800013dc:	ec26                	sd	s1,24(sp)
    800013de:	e84a                	sd	s2,16(sp)
    800013e0:	e44e                	sd	s3,8(sp)
    800013e2:	e052                	sd	s4,0(sp)
    800013e4:	1800                	addi	s0,sp,48
    800013e6:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800013e8:	00007497          	auipc	s1,0x7
    800013ec:	98848493          	addi	s1,s1,-1656 # 80007d70 <proc>
      pp->parent = initproc;
    800013f0:	00006a17          	auipc	s4,0x6
    800013f4:	510a0a13          	addi	s4,s4,1296 # 80007900 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800013f8:	00007997          	auipc	s3,0x7
    800013fc:	78898993          	addi	s3,s3,1928 # 80008b80 <tickslock>
    80001400:	a029                	j	8000140a <reparent+0x34>
    80001402:	16848493          	addi	s1,s1,360
    80001406:	01348b63          	beq	s1,s3,8000141c <reparent+0x46>
    if(pp->parent == p){
    8000140a:	7c9c                	ld	a5,56(s1)
    8000140c:	ff279be3          	bne	a5,s2,80001402 <reparent+0x2c>
      pp->parent = initproc;
    80001410:	000a3503          	ld	a0,0(s4)
    80001414:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001416:	f5dff0ef          	jal	80001372 <wakeup>
    8000141a:	b7e5                	j	80001402 <reparent+0x2c>
}
    8000141c:	70a2                	ld	ra,40(sp)
    8000141e:	7402                	ld	s0,32(sp)
    80001420:	64e2                	ld	s1,24(sp)
    80001422:	6942                	ld	s2,16(sp)
    80001424:	69a2                	ld	s3,8(sp)
    80001426:	6a02                	ld	s4,0(sp)
    80001428:	6145                	addi	sp,sp,48
    8000142a:	8082                	ret

000000008000142c <exit>:
{
    8000142c:	7179                	addi	sp,sp,-48
    8000142e:	f406                	sd	ra,40(sp)
    80001430:	f022                	sd	s0,32(sp)
    80001432:	ec26                	sd	s1,24(sp)
    80001434:	e84a                	sd	s2,16(sp)
    80001436:	e44e                	sd	s3,8(sp)
    80001438:	e052                	sd	s4,0(sp)
    8000143a:	1800                	addi	s0,sp,48
    8000143c:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000143e:	91fff0ef          	jal	80000d5c <myproc>
    80001442:	89aa                	mv	s3,a0
  if(p == initproc)
    80001444:	00006797          	auipc	a5,0x6
    80001448:	4bc7b783          	ld	a5,1212(a5) # 80007900 <initproc>
    8000144c:	0d050493          	addi	s1,a0,208
    80001450:	15050913          	addi	s2,a0,336
    80001454:	00a79b63          	bne	a5,a0,8000146a <exit+0x3e>
    panic("init exiting");
    80001458:	00006517          	auipc	a0,0x6
    8000145c:	dc850513          	addi	a0,a0,-568 # 80007220 <etext+0x220>
    80001460:	246040ef          	jal	800056a6 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    80001464:	04a1                	addi	s1,s1,8
    80001466:	01248963          	beq	s1,s2,80001478 <exit+0x4c>
    if(p->ofile[fd]){
    8000146a:	6088                	ld	a0,0(s1)
    8000146c:	dd65                	beqz	a0,80001464 <exit+0x38>
      fileclose(f);
    8000146e:	7a3010ef          	jal	80003410 <fileclose>
      p->ofile[fd] = 0;
    80001472:	0004b023          	sd	zero,0(s1)
    80001476:	b7fd                	j	80001464 <exit+0x38>
  begin_op();
    80001478:	379010ef          	jal	80002ff0 <begin_op>
  iput(p->cwd);
    8000147c:	1509b503          	ld	a0,336(s3)
    80001480:	43e010ef          	jal	800028be <iput>
  end_op();
    80001484:	3d7010ef          	jal	8000305a <end_op>
  p->cwd = 0;
    80001488:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000148c:	00006497          	auipc	s1,0x6
    80001490:	4cc48493          	addi	s1,s1,1228 # 80007958 <wait_lock>
    80001494:	8526                	mv	a0,s1
    80001496:	53e040ef          	jal	800059d4 <acquire>
  reparent(p);
    8000149a:	854e                	mv	a0,s3
    8000149c:	f3bff0ef          	jal	800013d6 <reparent>
  wakeup(p->parent);
    800014a0:	0389b503          	ld	a0,56(s3)
    800014a4:	ecfff0ef          	jal	80001372 <wakeup>
  acquire(&p->lock);
    800014a8:	854e                	mv	a0,s3
    800014aa:	52a040ef          	jal	800059d4 <acquire>
  p->xstate = status;
    800014ae:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800014b2:	4795                	li	a5,5
    800014b4:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800014b8:	8526                	mv	a0,s1
    800014ba:	5ae040ef          	jal	80005a68 <release>
  sched();
    800014be:	d83ff0ef          	jal	80001240 <sched>
  panic("zombie exit");
    800014c2:	00006517          	auipc	a0,0x6
    800014c6:	d6e50513          	addi	a0,a0,-658 # 80007230 <etext+0x230>
    800014ca:	1dc040ef          	jal	800056a6 <panic>

00000000800014ce <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800014ce:	7179                	addi	sp,sp,-48
    800014d0:	f406                	sd	ra,40(sp)
    800014d2:	f022                	sd	s0,32(sp)
    800014d4:	ec26                	sd	s1,24(sp)
    800014d6:	e84a                	sd	s2,16(sp)
    800014d8:	e44e                	sd	s3,8(sp)
    800014da:	1800                	addi	s0,sp,48
    800014dc:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800014de:	00007497          	auipc	s1,0x7
    800014e2:	89248493          	addi	s1,s1,-1902 # 80007d70 <proc>
    800014e6:	00007997          	auipc	s3,0x7
    800014ea:	69a98993          	addi	s3,s3,1690 # 80008b80 <tickslock>
    acquire(&p->lock);
    800014ee:	8526                	mv	a0,s1
    800014f0:	4e4040ef          	jal	800059d4 <acquire>
    if(p->pid == pid){
    800014f4:	589c                	lw	a5,48(s1)
    800014f6:	03278163          	beq	a5,s2,80001518 <kill+0x4a>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800014fa:	8526                	mv	a0,s1
    800014fc:	56c040ef          	jal	80005a68 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001500:	16848493          	addi	s1,s1,360
    80001504:	ff3495e3          	bne	s1,s3,800014ee <kill+0x20>
  }
  return -1;
    80001508:	557d                	li	a0,-1
}
    8000150a:	70a2                	ld	ra,40(sp)
    8000150c:	7402                	ld	s0,32(sp)
    8000150e:	64e2                	ld	s1,24(sp)
    80001510:	6942                	ld	s2,16(sp)
    80001512:	69a2                	ld	s3,8(sp)
    80001514:	6145                	addi	sp,sp,48
    80001516:	8082                	ret
      p->killed = 1;
    80001518:	4785                	li	a5,1
    8000151a:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000151c:	4c98                	lw	a4,24(s1)
    8000151e:	4789                	li	a5,2
    80001520:	00f70763          	beq	a4,a5,8000152e <kill+0x60>
      release(&p->lock);
    80001524:	8526                	mv	a0,s1
    80001526:	542040ef          	jal	80005a68 <release>
      return 0;
    8000152a:	4501                	li	a0,0
    8000152c:	bff9                	j	8000150a <kill+0x3c>
        p->state = RUNNABLE;
    8000152e:	478d                	li	a5,3
    80001530:	cc9c                	sw	a5,24(s1)
    80001532:	bfcd                	j	80001524 <kill+0x56>

0000000080001534 <setkilled>:

void
setkilled(struct proc *p)
{
    80001534:	1101                	addi	sp,sp,-32
    80001536:	ec06                	sd	ra,24(sp)
    80001538:	e822                	sd	s0,16(sp)
    8000153a:	e426                	sd	s1,8(sp)
    8000153c:	1000                	addi	s0,sp,32
    8000153e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001540:	494040ef          	jal	800059d4 <acquire>
  p->killed = 1;
    80001544:	4785                	li	a5,1
    80001546:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001548:	8526                	mv	a0,s1
    8000154a:	51e040ef          	jal	80005a68 <release>
}
    8000154e:	60e2                	ld	ra,24(sp)
    80001550:	6442                	ld	s0,16(sp)
    80001552:	64a2                	ld	s1,8(sp)
    80001554:	6105                	addi	sp,sp,32
    80001556:	8082                	ret

0000000080001558 <killed>:

int
killed(struct proc *p)
{
    80001558:	1101                	addi	sp,sp,-32
    8000155a:	ec06                	sd	ra,24(sp)
    8000155c:	e822                	sd	s0,16(sp)
    8000155e:	e426                	sd	s1,8(sp)
    80001560:	e04a                	sd	s2,0(sp)
    80001562:	1000                	addi	s0,sp,32
    80001564:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80001566:	46e040ef          	jal	800059d4 <acquire>
  k = p->killed;
    8000156a:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    8000156e:	8526                	mv	a0,s1
    80001570:	4f8040ef          	jal	80005a68 <release>
  return k;
}
    80001574:	854a                	mv	a0,s2
    80001576:	60e2                	ld	ra,24(sp)
    80001578:	6442                	ld	s0,16(sp)
    8000157a:	64a2                	ld	s1,8(sp)
    8000157c:	6902                	ld	s2,0(sp)
    8000157e:	6105                	addi	sp,sp,32
    80001580:	8082                	ret

0000000080001582 <wait>:
{
    80001582:	715d                	addi	sp,sp,-80
    80001584:	e486                	sd	ra,72(sp)
    80001586:	e0a2                	sd	s0,64(sp)
    80001588:	fc26                	sd	s1,56(sp)
    8000158a:	f84a                	sd	s2,48(sp)
    8000158c:	f44e                	sd	s3,40(sp)
    8000158e:	f052                	sd	s4,32(sp)
    80001590:	ec56                	sd	s5,24(sp)
    80001592:	e85a                	sd	s6,16(sp)
    80001594:	e45e                	sd	s7,8(sp)
    80001596:	0880                	addi	s0,sp,80
    80001598:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    8000159a:	fc2ff0ef          	jal	80000d5c <myproc>
    8000159e:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800015a0:	00006517          	auipc	a0,0x6
    800015a4:	3b850513          	addi	a0,a0,952 # 80007958 <wait_lock>
    800015a8:	42c040ef          	jal	800059d4 <acquire>
        if(pp->state == ZOMBIE){
    800015ac:	4a15                	li	s4,5
        havekids = 1;
    800015ae:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800015b0:	00007997          	auipc	s3,0x7
    800015b4:	5d098993          	addi	s3,s3,1488 # 80008b80 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800015b8:	00006b17          	auipc	s6,0x6
    800015bc:	3a0b0b13          	addi	s6,s6,928 # 80007958 <wait_lock>
    800015c0:	a869                	j	8000165a <wait+0xd8>
          pid = pp->pid;
    800015c2:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800015c6:	000b8c63          	beqz	s7,800015de <wait+0x5c>
    800015ca:	4691                	li	a3,4
    800015cc:	02c48613          	addi	a2,s1,44
    800015d0:	85de                	mv	a1,s7
    800015d2:	05093503          	ld	a0,80(s2)
    800015d6:	c2eff0ef          	jal	80000a04 <copyout>
    800015da:	02054a63          	bltz	a0,8000160e <wait+0x8c>
          freeproc(pp);
    800015de:	8526                	mv	a0,s1
    800015e0:	8efff0ef          	jal	80000ece <freeproc>
          release(&pp->lock);
    800015e4:	8526                	mv	a0,s1
    800015e6:	482040ef          	jal	80005a68 <release>
          release(&wait_lock);
    800015ea:	00006517          	auipc	a0,0x6
    800015ee:	36e50513          	addi	a0,a0,878 # 80007958 <wait_lock>
    800015f2:	476040ef          	jal	80005a68 <release>
}
    800015f6:	854e                	mv	a0,s3
    800015f8:	60a6                	ld	ra,72(sp)
    800015fa:	6406                	ld	s0,64(sp)
    800015fc:	74e2                	ld	s1,56(sp)
    800015fe:	7942                	ld	s2,48(sp)
    80001600:	79a2                	ld	s3,40(sp)
    80001602:	7a02                	ld	s4,32(sp)
    80001604:	6ae2                	ld	s5,24(sp)
    80001606:	6b42                	ld	s6,16(sp)
    80001608:	6ba2                	ld	s7,8(sp)
    8000160a:	6161                	addi	sp,sp,80
    8000160c:	8082                	ret
            release(&pp->lock);
    8000160e:	8526                	mv	a0,s1
    80001610:	458040ef          	jal	80005a68 <release>
            release(&wait_lock);
    80001614:	00006517          	auipc	a0,0x6
    80001618:	34450513          	addi	a0,a0,836 # 80007958 <wait_lock>
    8000161c:	44c040ef          	jal	80005a68 <release>
            return -1;
    80001620:	59fd                	li	s3,-1
    80001622:	bfd1                	j	800015f6 <wait+0x74>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001624:	16848493          	addi	s1,s1,360
    80001628:	03348063          	beq	s1,s3,80001648 <wait+0xc6>
      if(pp->parent == p){
    8000162c:	7c9c                	ld	a5,56(s1)
    8000162e:	ff279be3          	bne	a5,s2,80001624 <wait+0xa2>
        acquire(&pp->lock);
    80001632:	8526                	mv	a0,s1
    80001634:	3a0040ef          	jal	800059d4 <acquire>
        if(pp->state == ZOMBIE){
    80001638:	4c9c                	lw	a5,24(s1)
    8000163a:	f94784e3          	beq	a5,s4,800015c2 <wait+0x40>
        release(&pp->lock);
    8000163e:	8526                	mv	a0,s1
    80001640:	428040ef          	jal	80005a68 <release>
        havekids = 1;
    80001644:	8756                	mv	a4,s5
    80001646:	bff9                	j	80001624 <wait+0xa2>
    if(!havekids || killed(p)){
    80001648:	cf19                	beqz	a4,80001666 <wait+0xe4>
    8000164a:	854a                	mv	a0,s2
    8000164c:	f0dff0ef          	jal	80001558 <killed>
    80001650:	e919                	bnez	a0,80001666 <wait+0xe4>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001652:	85da                	mv	a1,s6
    80001654:	854a                	mv	a0,s2
    80001656:	cd1ff0ef          	jal	80001326 <sleep>
    havekids = 0;
    8000165a:	4701                	li	a4,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000165c:	00006497          	auipc	s1,0x6
    80001660:	71448493          	addi	s1,s1,1812 # 80007d70 <proc>
    80001664:	b7e1                	j	8000162c <wait+0xaa>
      release(&wait_lock);
    80001666:	00006517          	auipc	a0,0x6
    8000166a:	2f250513          	addi	a0,a0,754 # 80007958 <wait_lock>
    8000166e:	3fa040ef          	jal	80005a68 <release>
      return -1;
    80001672:	59fd                	li	s3,-1
    80001674:	b749                	j	800015f6 <wait+0x74>

0000000080001676 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001676:	7179                	addi	sp,sp,-48
    80001678:	f406                	sd	ra,40(sp)
    8000167a:	f022                	sd	s0,32(sp)
    8000167c:	ec26                	sd	s1,24(sp)
    8000167e:	e84a                	sd	s2,16(sp)
    80001680:	e44e                	sd	s3,8(sp)
    80001682:	e052                	sd	s4,0(sp)
    80001684:	1800                	addi	s0,sp,48
    80001686:	84aa                	mv	s1,a0
    80001688:	892e                	mv	s2,a1
    8000168a:	89b2                	mv	s3,a2
    8000168c:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000168e:	eceff0ef          	jal	80000d5c <myproc>
  if(user_dst){
    80001692:	cc99                	beqz	s1,800016b0 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    80001694:	86d2                	mv	a3,s4
    80001696:	864e                	mv	a2,s3
    80001698:	85ca                	mv	a1,s2
    8000169a:	6928                	ld	a0,80(a0)
    8000169c:	b68ff0ef          	jal	80000a04 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800016a0:	70a2                	ld	ra,40(sp)
    800016a2:	7402                	ld	s0,32(sp)
    800016a4:	64e2                	ld	s1,24(sp)
    800016a6:	6942                	ld	s2,16(sp)
    800016a8:	69a2                	ld	s3,8(sp)
    800016aa:	6a02                	ld	s4,0(sp)
    800016ac:	6145                	addi	sp,sp,48
    800016ae:	8082                	ret
    memmove((char *)dst, src, len);
    800016b0:	000a061b          	sext.w	a2,s4
    800016b4:	85ce                	mv	a1,s3
    800016b6:	854a                	mv	a0,s2
    800016b8:	afbfe0ef          	jal	800001b2 <memmove>
    return 0;
    800016bc:	8526                	mv	a0,s1
    800016be:	b7cd                	j	800016a0 <either_copyout+0x2a>

00000000800016c0 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800016c0:	7179                	addi	sp,sp,-48
    800016c2:	f406                	sd	ra,40(sp)
    800016c4:	f022                	sd	s0,32(sp)
    800016c6:	ec26                	sd	s1,24(sp)
    800016c8:	e84a                	sd	s2,16(sp)
    800016ca:	e44e                	sd	s3,8(sp)
    800016cc:	e052                	sd	s4,0(sp)
    800016ce:	1800                	addi	s0,sp,48
    800016d0:	892a                	mv	s2,a0
    800016d2:	84ae                	mv	s1,a1
    800016d4:	89b2                	mv	s3,a2
    800016d6:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800016d8:	e84ff0ef          	jal	80000d5c <myproc>
  if(user_src){
    800016dc:	cc99                	beqz	s1,800016fa <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    800016de:	86d2                	mv	a3,s4
    800016e0:	864e                	mv	a2,s3
    800016e2:	85ca                	mv	a1,s2
    800016e4:	6928                	ld	a0,80(a0)
    800016e6:	bceff0ef          	jal	80000ab4 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800016ea:	70a2                	ld	ra,40(sp)
    800016ec:	7402                	ld	s0,32(sp)
    800016ee:	64e2                	ld	s1,24(sp)
    800016f0:	6942                	ld	s2,16(sp)
    800016f2:	69a2                	ld	s3,8(sp)
    800016f4:	6a02                	ld	s4,0(sp)
    800016f6:	6145                	addi	sp,sp,48
    800016f8:	8082                	ret
    memmove(dst, (char*)src, len);
    800016fa:	000a061b          	sext.w	a2,s4
    800016fe:	85ce                	mv	a1,s3
    80001700:	854a                	mv	a0,s2
    80001702:	ab1fe0ef          	jal	800001b2 <memmove>
    return 0;
    80001706:	8526                	mv	a0,s1
    80001708:	b7cd                	j	800016ea <either_copyin+0x2a>

000000008000170a <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    8000170a:	715d                	addi	sp,sp,-80
    8000170c:	e486                	sd	ra,72(sp)
    8000170e:	e0a2                	sd	s0,64(sp)
    80001710:	fc26                	sd	s1,56(sp)
    80001712:	f84a                	sd	s2,48(sp)
    80001714:	f44e                	sd	s3,40(sp)
    80001716:	f052                	sd	s4,32(sp)
    80001718:	ec56                	sd	s5,24(sp)
    8000171a:	e85a                	sd	s6,16(sp)
    8000171c:	e45e                	sd	s7,8(sp)
    8000171e:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001720:	00006517          	auipc	a0,0x6
    80001724:	8f850513          	addi	a0,a0,-1800 # 80007018 <etext+0x18>
    80001728:	4af030ef          	jal	800053d6 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000172c:	00006497          	auipc	s1,0x6
    80001730:	79c48493          	addi	s1,s1,1948 # 80007ec8 <proc+0x158>
    80001734:	00007917          	auipc	s2,0x7
    80001738:	5a490913          	addi	s2,s2,1444 # 80008cd8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000173c:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000173e:	00006997          	auipc	s3,0x6
    80001742:	b0298993          	addi	s3,s3,-1278 # 80007240 <etext+0x240>
    printf("%d %s %s", p->pid, state, p->name);
    80001746:	00006a97          	auipc	s5,0x6
    8000174a:	b02a8a93          	addi	s5,s5,-1278 # 80007248 <etext+0x248>
    printf("\n");
    8000174e:	00006a17          	auipc	s4,0x6
    80001752:	8caa0a13          	addi	s4,s4,-1846 # 80007018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001756:	00006b97          	auipc	s7,0x6
    8000175a:	032b8b93          	addi	s7,s7,50 # 80007788 <states.0>
    8000175e:	a829                	j	80001778 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    80001760:	ed86a583          	lw	a1,-296(a3)
    80001764:	8556                	mv	a0,s5
    80001766:	471030ef          	jal	800053d6 <printf>
    printf("\n");
    8000176a:	8552                	mv	a0,s4
    8000176c:	46b030ef          	jal	800053d6 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001770:	16848493          	addi	s1,s1,360
    80001774:	03248263          	beq	s1,s2,80001798 <procdump+0x8e>
    if(p->state == UNUSED)
    80001778:	86a6                	mv	a3,s1
    8000177a:	ec04a783          	lw	a5,-320(s1)
    8000177e:	dbed                	beqz	a5,80001770 <procdump+0x66>
      state = "???";
    80001780:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001782:	fcfb6fe3          	bltu	s6,a5,80001760 <procdump+0x56>
    80001786:	02079713          	slli	a4,a5,0x20
    8000178a:	01d75793          	srli	a5,a4,0x1d
    8000178e:	97de                	add	a5,a5,s7
    80001790:	6390                	ld	a2,0(a5)
    80001792:	f679                	bnez	a2,80001760 <procdump+0x56>
      state = "???";
    80001794:	864e                	mv	a2,s3
    80001796:	b7e9                	j	80001760 <procdump+0x56>
  }
}
    80001798:	60a6                	ld	ra,72(sp)
    8000179a:	6406                	ld	s0,64(sp)
    8000179c:	74e2                	ld	s1,56(sp)
    8000179e:	7942                	ld	s2,48(sp)
    800017a0:	79a2                	ld	s3,40(sp)
    800017a2:	7a02                	ld	s4,32(sp)
    800017a4:	6ae2                	ld	s5,24(sp)
    800017a6:	6b42                	ld	s6,16(sp)
    800017a8:	6ba2                	ld	s7,8(sp)
    800017aa:	6161                	addi	sp,sp,80
    800017ac:	8082                	ret

00000000800017ae <swtch>:
    800017ae:	00153023          	sd	ra,0(a0)
    800017b2:	00253423          	sd	sp,8(a0)
    800017b6:	e900                	sd	s0,16(a0)
    800017b8:	ed04                	sd	s1,24(a0)
    800017ba:	03253023          	sd	s2,32(a0)
    800017be:	03353423          	sd	s3,40(a0)
    800017c2:	03453823          	sd	s4,48(a0)
    800017c6:	03553c23          	sd	s5,56(a0)
    800017ca:	05653023          	sd	s6,64(a0)
    800017ce:	05753423          	sd	s7,72(a0)
    800017d2:	05853823          	sd	s8,80(a0)
    800017d6:	05953c23          	sd	s9,88(a0)
    800017da:	07a53023          	sd	s10,96(a0)
    800017de:	07b53423          	sd	s11,104(a0)
    800017e2:	0005b083          	ld	ra,0(a1)
    800017e6:	0085b103          	ld	sp,8(a1)
    800017ea:	6980                	ld	s0,16(a1)
    800017ec:	6d84                	ld	s1,24(a1)
    800017ee:	0205b903          	ld	s2,32(a1)
    800017f2:	0285b983          	ld	s3,40(a1)
    800017f6:	0305ba03          	ld	s4,48(a1)
    800017fa:	0385ba83          	ld	s5,56(a1)
    800017fe:	0405bb03          	ld	s6,64(a1)
    80001802:	0485bb83          	ld	s7,72(a1)
    80001806:	0505bc03          	ld	s8,80(a1)
    8000180a:	0585bc83          	ld	s9,88(a1)
    8000180e:	0605bd03          	ld	s10,96(a1)
    80001812:	0685bd83          	ld	s11,104(a1)
    80001816:	8082                	ret

0000000080001818 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001818:	1141                	addi	sp,sp,-16
    8000181a:	e406                	sd	ra,8(sp)
    8000181c:	e022                	sd	s0,0(sp)
    8000181e:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001820:	00006597          	auipc	a1,0x6
    80001824:	a6858593          	addi	a1,a1,-1432 # 80007288 <etext+0x288>
    80001828:	00007517          	auipc	a0,0x7
    8000182c:	35850513          	addi	a0,a0,856 # 80008b80 <tickslock>
    80001830:	120040ef          	jal	80005950 <initlock>
}
    80001834:	60a2                	ld	ra,8(sp)
    80001836:	6402                	ld	s0,0(sp)
    80001838:	0141                	addi	sp,sp,16
    8000183a:	8082                	ret

000000008000183c <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    8000183c:	1141                	addi	sp,sp,-16
    8000183e:	e406                	sd	ra,8(sp)
    80001840:	e022                	sd	s0,0(sp)
    80001842:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001844:	00003797          	auipc	a5,0x3
    80001848:	0fc78793          	addi	a5,a5,252 # 80004940 <kernelvec>
    8000184c:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001850:	60a2                	ld	ra,8(sp)
    80001852:	6402                	ld	s0,0(sp)
    80001854:	0141                	addi	sp,sp,16
    80001856:	8082                	ret

0000000080001858 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80001858:	1141                	addi	sp,sp,-16
    8000185a:	e406                	sd	ra,8(sp)
    8000185c:	e022                	sd	s0,0(sp)
    8000185e:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001860:	cfcff0ef          	jal	80000d5c <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001864:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001868:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000186a:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    8000186e:	00004697          	auipc	a3,0x4
    80001872:	79268693          	addi	a3,a3,1938 # 80006000 <_trampoline>
    80001876:	00004717          	auipc	a4,0x4
    8000187a:	78a70713          	addi	a4,a4,1930 # 80006000 <_trampoline>
    8000187e:	8f15                	sub	a4,a4,a3
    80001880:	040007b7          	lui	a5,0x4000
    80001884:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80001886:	07b2                	slli	a5,a5,0xc
    80001888:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000188a:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    8000188e:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001890:	18002673          	csrr	a2,satp
    80001894:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001896:	6d30                	ld	a2,88(a0)
    80001898:	6138                	ld	a4,64(a0)
    8000189a:	6585                	lui	a1,0x1
    8000189c:	972e                	add	a4,a4,a1
    8000189e:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800018a0:	6d38                	ld	a4,88(a0)
    800018a2:	00000617          	auipc	a2,0x0
    800018a6:	11060613          	addi	a2,a2,272 # 800019b2 <usertrap>
    800018aa:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    800018ac:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    800018ae:	8612                	mv	a2,tp
    800018b0:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800018b2:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800018b6:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800018ba:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800018be:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800018c2:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800018c4:	6f18                	ld	a4,24(a4)
    800018c6:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    800018ca:	6928                	ld	a0,80(a0)
    800018cc:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800018ce:	00004717          	auipc	a4,0x4
    800018d2:	7ce70713          	addi	a4,a4,1998 # 8000609c <userret>
    800018d6:	8f15                	sub	a4,a4,a3
    800018d8:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800018da:	577d                	li	a4,-1
    800018dc:	177e                	slli	a4,a4,0x3f
    800018de:	8d59                	or	a0,a0,a4
    800018e0:	9782                	jalr	a5
}
    800018e2:	60a2                	ld	ra,8(sp)
    800018e4:	6402                	ld	s0,0(sp)
    800018e6:	0141                	addi	sp,sp,16
    800018e8:	8082                	ret

00000000800018ea <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800018ea:	1101                	addi	sp,sp,-32
    800018ec:	ec06                	sd	ra,24(sp)
    800018ee:	e822                	sd	s0,16(sp)
    800018f0:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    800018f2:	c36ff0ef          	jal	80000d28 <cpuid>
    800018f6:	cd11                	beqz	a0,80001912 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    800018f8:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    800018fc:	000f4737          	lui	a4,0xf4
    80001900:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80001904:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80001906:	14d79073          	csrw	stimecmp,a5
}
    8000190a:	60e2                	ld	ra,24(sp)
    8000190c:	6442                	ld	s0,16(sp)
    8000190e:	6105                	addi	sp,sp,32
    80001910:	8082                	ret
    80001912:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    80001914:	00007497          	auipc	s1,0x7
    80001918:	26c48493          	addi	s1,s1,620 # 80008b80 <tickslock>
    8000191c:	8526                	mv	a0,s1
    8000191e:	0b6040ef          	jal	800059d4 <acquire>
    ticks++;
    80001922:	00006517          	auipc	a0,0x6
    80001926:	fe650513          	addi	a0,a0,-26 # 80007908 <ticks>
    8000192a:	411c                	lw	a5,0(a0)
    8000192c:	2785                	addiw	a5,a5,1
    8000192e:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80001930:	a43ff0ef          	jal	80001372 <wakeup>
    release(&tickslock);
    80001934:	8526                	mv	a0,s1
    80001936:	132040ef          	jal	80005a68 <release>
    8000193a:	64a2                	ld	s1,8(sp)
    8000193c:	bf75                	j	800018f8 <clockintr+0xe>

000000008000193e <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    8000193e:	1101                	addi	sp,sp,-32
    80001940:	ec06                	sd	ra,24(sp)
    80001942:	e822                	sd	s0,16(sp)
    80001944:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001946:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    8000194a:	57fd                	li	a5,-1
    8000194c:	17fe                	slli	a5,a5,0x3f
    8000194e:	07a5                	addi	a5,a5,9
    80001950:	00f70c63          	beq	a4,a5,80001968 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80001954:	57fd                	li	a5,-1
    80001956:	17fe                	slli	a5,a5,0x3f
    80001958:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    8000195a:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    8000195c:	04f70763          	beq	a4,a5,800019aa <devintr+0x6c>
  }
}
    80001960:	60e2                	ld	ra,24(sp)
    80001962:	6442                	ld	s0,16(sp)
    80001964:	6105                	addi	sp,sp,32
    80001966:	8082                	ret
    80001968:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    8000196a:	082030ef          	jal	800049ec <plic_claim>
    8000196e:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001970:	47a9                	li	a5,10
    80001972:	00f50963          	beq	a0,a5,80001984 <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    80001976:	4785                	li	a5,1
    80001978:	00f50963          	beq	a0,a5,8000198a <devintr+0x4c>
    return 1;
    8000197c:	4505                	li	a0,1
    } else if(irq){
    8000197e:	e889                	bnez	s1,80001990 <devintr+0x52>
    80001980:	64a2                	ld	s1,8(sp)
    80001982:	bff9                	j	80001960 <devintr+0x22>
      uartintr();
    80001984:	791030ef          	jal	80005914 <uartintr>
    if(irq)
    80001988:	a819                	j	8000199e <devintr+0x60>
      virtio_disk_intr();
    8000198a:	4f2030ef          	jal	80004e7c <virtio_disk_intr>
    if(irq)
    8000198e:	a801                	j	8000199e <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    80001990:	85a6                	mv	a1,s1
    80001992:	00006517          	auipc	a0,0x6
    80001996:	8fe50513          	addi	a0,a0,-1794 # 80007290 <etext+0x290>
    8000199a:	23d030ef          	jal	800053d6 <printf>
      plic_complete(irq);
    8000199e:	8526                	mv	a0,s1
    800019a0:	06c030ef          	jal	80004a0c <plic_complete>
    return 1;
    800019a4:	4505                	li	a0,1
    800019a6:	64a2                	ld	s1,8(sp)
    800019a8:	bf65                	j	80001960 <devintr+0x22>
    clockintr();
    800019aa:	f41ff0ef          	jal	800018ea <clockintr>
    return 2;
    800019ae:	4509                	li	a0,2
    800019b0:	bf45                	j	80001960 <devintr+0x22>

00000000800019b2 <usertrap>:
{
    800019b2:	1101                	addi	sp,sp,-32
    800019b4:	ec06                	sd	ra,24(sp)
    800019b6:	e822                	sd	s0,16(sp)
    800019b8:	e426                	sd	s1,8(sp)
    800019ba:	e04a                	sd	s2,0(sp)
    800019bc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800019be:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    800019c2:	1007f793          	andi	a5,a5,256
    800019c6:	ef85                	bnez	a5,800019fe <usertrap+0x4c>
  asm volatile("csrw stvec, %0" : : "r" (x));
    800019c8:	00003797          	auipc	a5,0x3
    800019cc:	f7878793          	addi	a5,a5,-136 # 80004940 <kernelvec>
    800019d0:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800019d4:	b88ff0ef          	jal	80000d5c <myproc>
    800019d8:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800019da:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800019dc:	14102773          	csrr	a4,sepc
    800019e0:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800019e2:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    800019e6:	47a1                	li	a5,8
    800019e8:	02f70163          	beq	a4,a5,80001a0a <usertrap+0x58>
  } else if((which_dev = devintr()) != 0){
    800019ec:	f53ff0ef          	jal	8000193e <devintr>
    800019f0:	892a                	mv	s2,a0
    800019f2:	c135                	beqz	a0,80001a56 <usertrap+0xa4>
  if(killed(p))
    800019f4:	8526                	mv	a0,s1
    800019f6:	b63ff0ef          	jal	80001558 <killed>
    800019fa:	cd1d                	beqz	a0,80001a38 <usertrap+0x86>
    800019fc:	a81d                	j	80001a32 <usertrap+0x80>
    panic("usertrap: not from user mode");
    800019fe:	00006517          	auipc	a0,0x6
    80001a02:	8b250513          	addi	a0,a0,-1870 # 800072b0 <etext+0x2b0>
    80001a06:	4a1030ef          	jal	800056a6 <panic>
    if(killed(p))
    80001a0a:	b4fff0ef          	jal	80001558 <killed>
    80001a0e:	e121                	bnez	a0,80001a4e <usertrap+0x9c>
    p->trapframe->epc += 4;
    80001a10:	6cb8                	ld	a4,88(s1)
    80001a12:	6f1c                	ld	a5,24(a4)
    80001a14:	0791                	addi	a5,a5,4
    80001a16:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a18:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001a1c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001a20:	10079073          	csrw	sstatus,a5
    syscall();
    80001a24:	240000ef          	jal	80001c64 <syscall>
  if(killed(p))
    80001a28:	8526                	mv	a0,s1
    80001a2a:	b2fff0ef          	jal	80001558 <killed>
    80001a2e:	c901                	beqz	a0,80001a3e <usertrap+0x8c>
    80001a30:	4901                	li	s2,0
    exit(-1);
    80001a32:	557d                	li	a0,-1
    80001a34:	9f9ff0ef          	jal	8000142c <exit>
  if(which_dev == 2)
    80001a38:	4789                	li	a5,2
    80001a3a:	04f90563          	beq	s2,a5,80001a84 <usertrap+0xd2>
  usertrapret();
    80001a3e:	e1bff0ef          	jal	80001858 <usertrapret>
}
    80001a42:	60e2                	ld	ra,24(sp)
    80001a44:	6442                	ld	s0,16(sp)
    80001a46:	64a2                	ld	s1,8(sp)
    80001a48:	6902                	ld	s2,0(sp)
    80001a4a:	6105                	addi	sp,sp,32
    80001a4c:	8082                	ret
      exit(-1);
    80001a4e:	557d                	li	a0,-1
    80001a50:	9ddff0ef          	jal	8000142c <exit>
    80001a54:	bf75                	j	80001a10 <usertrap+0x5e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001a56:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001a5a:	5890                	lw	a2,48(s1)
    80001a5c:	00006517          	auipc	a0,0x6
    80001a60:	87450513          	addi	a0,a0,-1932 # 800072d0 <etext+0x2d0>
    80001a64:	173030ef          	jal	800053d6 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a68:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001a6c:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001a70:	00006517          	auipc	a0,0x6
    80001a74:	89050513          	addi	a0,a0,-1904 # 80007300 <etext+0x300>
    80001a78:	15f030ef          	jal	800053d6 <printf>
    setkilled(p);
    80001a7c:	8526                	mv	a0,s1
    80001a7e:	ab7ff0ef          	jal	80001534 <setkilled>
    80001a82:	b75d                	j	80001a28 <usertrap+0x76>
    yield();
    80001a84:	877ff0ef          	jal	800012fa <yield>
    80001a88:	bf5d                	j	80001a3e <usertrap+0x8c>

0000000080001a8a <kerneltrap>:
{
    80001a8a:	7179                	addi	sp,sp,-48
    80001a8c:	f406                	sd	ra,40(sp)
    80001a8e:	f022                	sd	s0,32(sp)
    80001a90:	ec26                	sd	s1,24(sp)
    80001a92:	e84a                	sd	s2,16(sp)
    80001a94:	e44e                	sd	s3,8(sp)
    80001a96:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a98:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a9c:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001aa0:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80001aa4:	1004f793          	andi	a5,s1,256
    80001aa8:	c795                	beqz	a5,80001ad4 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001aaa:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001aae:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001ab0:	eb85                	bnez	a5,80001ae0 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80001ab2:	e8dff0ef          	jal	8000193e <devintr>
    80001ab6:	c91d                	beqz	a0,80001aec <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80001ab8:	4789                	li	a5,2
    80001aba:	04f50a63          	beq	a0,a5,80001b0e <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001abe:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ac2:	10049073          	csrw	sstatus,s1
}
    80001ac6:	70a2                	ld	ra,40(sp)
    80001ac8:	7402                	ld	s0,32(sp)
    80001aca:	64e2                	ld	s1,24(sp)
    80001acc:	6942                	ld	s2,16(sp)
    80001ace:	69a2                	ld	s3,8(sp)
    80001ad0:	6145                	addi	sp,sp,48
    80001ad2:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001ad4:	00006517          	auipc	a0,0x6
    80001ad8:	85450513          	addi	a0,a0,-1964 # 80007328 <etext+0x328>
    80001adc:	3cb030ef          	jal	800056a6 <panic>
    panic("kerneltrap: interrupts enabled");
    80001ae0:	00006517          	auipc	a0,0x6
    80001ae4:	87050513          	addi	a0,a0,-1936 # 80007350 <etext+0x350>
    80001ae8:	3bf030ef          	jal	800056a6 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001aec:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001af0:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001af4:	85ce                	mv	a1,s3
    80001af6:	00006517          	auipc	a0,0x6
    80001afa:	87a50513          	addi	a0,a0,-1926 # 80007370 <etext+0x370>
    80001afe:	0d9030ef          	jal	800053d6 <printf>
    panic("kerneltrap");
    80001b02:	00006517          	auipc	a0,0x6
    80001b06:	89650513          	addi	a0,a0,-1898 # 80007398 <etext+0x398>
    80001b0a:	39d030ef          	jal	800056a6 <panic>
  if(which_dev == 2 && myproc() != 0)
    80001b0e:	a4eff0ef          	jal	80000d5c <myproc>
    80001b12:	d555                	beqz	a0,80001abe <kerneltrap+0x34>
    yield();
    80001b14:	fe6ff0ef          	jal	800012fa <yield>
    80001b18:	b75d                	j	80001abe <kerneltrap+0x34>

0000000080001b1a <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001b1a:	1101                	addi	sp,sp,-32
    80001b1c:	ec06                	sd	ra,24(sp)
    80001b1e:	e822                	sd	s0,16(sp)
    80001b20:	e426                	sd	s1,8(sp)
    80001b22:	1000                	addi	s0,sp,32
    80001b24:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001b26:	a36ff0ef          	jal	80000d5c <myproc>
  switch (n) {
    80001b2a:	4795                	li	a5,5
    80001b2c:	0497e163          	bltu	a5,s1,80001b6e <argraw+0x54>
    80001b30:	048a                	slli	s1,s1,0x2
    80001b32:	00006717          	auipc	a4,0x6
    80001b36:	c8670713          	addi	a4,a4,-890 # 800077b8 <states.0+0x30>
    80001b3a:	94ba                	add	s1,s1,a4
    80001b3c:	409c                	lw	a5,0(s1)
    80001b3e:	97ba                	add	a5,a5,a4
    80001b40:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001b42:	6d3c                	ld	a5,88(a0)
    80001b44:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001b46:	60e2                	ld	ra,24(sp)
    80001b48:	6442                	ld	s0,16(sp)
    80001b4a:	64a2                	ld	s1,8(sp)
    80001b4c:	6105                	addi	sp,sp,32
    80001b4e:	8082                	ret
    return p->trapframe->a1;
    80001b50:	6d3c                	ld	a5,88(a0)
    80001b52:	7fa8                	ld	a0,120(a5)
    80001b54:	bfcd                	j	80001b46 <argraw+0x2c>
    return p->trapframe->a2;
    80001b56:	6d3c                	ld	a5,88(a0)
    80001b58:	63c8                	ld	a0,128(a5)
    80001b5a:	b7f5                	j	80001b46 <argraw+0x2c>
    return p->trapframe->a3;
    80001b5c:	6d3c                	ld	a5,88(a0)
    80001b5e:	67c8                	ld	a0,136(a5)
    80001b60:	b7dd                	j	80001b46 <argraw+0x2c>
    return p->trapframe->a4;
    80001b62:	6d3c                	ld	a5,88(a0)
    80001b64:	6bc8                	ld	a0,144(a5)
    80001b66:	b7c5                	j	80001b46 <argraw+0x2c>
    return p->trapframe->a5;
    80001b68:	6d3c                	ld	a5,88(a0)
    80001b6a:	6fc8                	ld	a0,152(a5)
    80001b6c:	bfe9                	j	80001b46 <argraw+0x2c>
  panic("argraw");
    80001b6e:	00006517          	auipc	a0,0x6
    80001b72:	83a50513          	addi	a0,a0,-1990 # 800073a8 <etext+0x3a8>
    80001b76:	331030ef          	jal	800056a6 <panic>

0000000080001b7a <fetchaddr>:
{
    80001b7a:	1101                	addi	sp,sp,-32
    80001b7c:	ec06                	sd	ra,24(sp)
    80001b7e:	e822                	sd	s0,16(sp)
    80001b80:	e426                	sd	s1,8(sp)
    80001b82:	e04a                	sd	s2,0(sp)
    80001b84:	1000                	addi	s0,sp,32
    80001b86:	84aa                	mv	s1,a0
    80001b88:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001b8a:	9d2ff0ef          	jal	80000d5c <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001b8e:	653c                	ld	a5,72(a0)
    80001b90:	02f4f663          	bgeu	s1,a5,80001bbc <fetchaddr+0x42>
    80001b94:	00848713          	addi	a4,s1,8
    80001b98:	02e7e463          	bltu	a5,a4,80001bc0 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001b9c:	46a1                	li	a3,8
    80001b9e:	8626                	mv	a2,s1
    80001ba0:	85ca                	mv	a1,s2
    80001ba2:	6928                	ld	a0,80(a0)
    80001ba4:	f11fe0ef          	jal	80000ab4 <copyin>
    80001ba8:	00a03533          	snez	a0,a0
    80001bac:	40a0053b          	negw	a0,a0
}
    80001bb0:	60e2                	ld	ra,24(sp)
    80001bb2:	6442                	ld	s0,16(sp)
    80001bb4:	64a2                	ld	s1,8(sp)
    80001bb6:	6902                	ld	s2,0(sp)
    80001bb8:	6105                	addi	sp,sp,32
    80001bba:	8082                	ret
    return -1;
    80001bbc:	557d                	li	a0,-1
    80001bbe:	bfcd                	j	80001bb0 <fetchaddr+0x36>
    80001bc0:	557d                	li	a0,-1
    80001bc2:	b7fd                	j	80001bb0 <fetchaddr+0x36>

0000000080001bc4 <fetchstr>:
{
    80001bc4:	7179                	addi	sp,sp,-48
    80001bc6:	f406                	sd	ra,40(sp)
    80001bc8:	f022                	sd	s0,32(sp)
    80001bca:	ec26                	sd	s1,24(sp)
    80001bcc:	e84a                	sd	s2,16(sp)
    80001bce:	e44e                	sd	s3,8(sp)
    80001bd0:	1800                	addi	s0,sp,48
    80001bd2:	892a                	mv	s2,a0
    80001bd4:	84ae                	mv	s1,a1
    80001bd6:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80001bd8:	984ff0ef          	jal	80000d5c <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001bdc:	86ce                	mv	a3,s3
    80001bde:	864a                	mv	a2,s2
    80001be0:	85a6                	mv	a1,s1
    80001be2:	6928                	ld	a0,80(a0)
    80001be4:	f57fe0ef          	jal	80000b3a <copyinstr>
    80001be8:	00054c63          	bltz	a0,80001c00 <fetchstr+0x3c>
  return strlen(buf);
    80001bec:	8526                	mv	a0,s1
    80001bee:	ee8fe0ef          	jal	800002d6 <strlen>
}
    80001bf2:	70a2                	ld	ra,40(sp)
    80001bf4:	7402                	ld	s0,32(sp)
    80001bf6:	64e2                	ld	s1,24(sp)
    80001bf8:	6942                	ld	s2,16(sp)
    80001bfa:	69a2                	ld	s3,8(sp)
    80001bfc:	6145                	addi	sp,sp,48
    80001bfe:	8082                	ret
    return -1;
    80001c00:	557d                	li	a0,-1
    80001c02:	bfc5                	j	80001bf2 <fetchstr+0x2e>

0000000080001c04 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001c04:	1101                	addi	sp,sp,-32
    80001c06:	ec06                	sd	ra,24(sp)
    80001c08:	e822                	sd	s0,16(sp)
    80001c0a:	e426                	sd	s1,8(sp)
    80001c0c:	1000                	addi	s0,sp,32
    80001c0e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001c10:	f0bff0ef          	jal	80001b1a <argraw>
    80001c14:	c088                	sw	a0,0(s1)
}
    80001c16:	60e2                	ld	ra,24(sp)
    80001c18:	6442                	ld	s0,16(sp)
    80001c1a:	64a2                	ld	s1,8(sp)
    80001c1c:	6105                	addi	sp,sp,32
    80001c1e:	8082                	ret

0000000080001c20 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001c20:	1101                	addi	sp,sp,-32
    80001c22:	ec06                	sd	ra,24(sp)
    80001c24:	e822                	sd	s0,16(sp)
    80001c26:	e426                	sd	s1,8(sp)
    80001c28:	1000                	addi	s0,sp,32
    80001c2a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001c2c:	eefff0ef          	jal	80001b1a <argraw>
    80001c30:	e088                	sd	a0,0(s1)
}
    80001c32:	60e2                	ld	ra,24(sp)
    80001c34:	6442                	ld	s0,16(sp)
    80001c36:	64a2                	ld	s1,8(sp)
    80001c38:	6105                	addi	sp,sp,32
    80001c3a:	8082                	ret

0000000080001c3c <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001c3c:	1101                	addi	sp,sp,-32
    80001c3e:	ec06                	sd	ra,24(sp)
    80001c40:	e822                	sd	s0,16(sp)
    80001c42:	e426                	sd	s1,8(sp)
    80001c44:	e04a                	sd	s2,0(sp)
    80001c46:	1000                	addi	s0,sp,32
    80001c48:	84ae                	mv	s1,a1
    80001c4a:	8932                	mv	s2,a2
  *ip = argraw(n);
    80001c4c:	ecfff0ef          	jal	80001b1a <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    80001c50:	864a                	mv	a2,s2
    80001c52:	85a6                	mv	a1,s1
    80001c54:	f71ff0ef          	jal	80001bc4 <fetchstr>
}
    80001c58:	60e2                	ld	ra,24(sp)
    80001c5a:	6442                	ld	s0,16(sp)
    80001c5c:	64a2                	ld	s1,8(sp)
    80001c5e:	6902                	ld	s2,0(sp)
    80001c60:	6105                	addi	sp,sp,32
    80001c62:	8082                	ret

0000000080001c64 <syscall>:
[SYS_symlink]   sys_symlink,
};

void
syscall(void)
{
    80001c64:	1101                	addi	sp,sp,-32
    80001c66:	ec06                	sd	ra,24(sp)
    80001c68:	e822                	sd	s0,16(sp)
    80001c6a:	e426                	sd	s1,8(sp)
    80001c6c:	e04a                	sd	s2,0(sp)
    80001c6e:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001c70:	8ecff0ef          	jal	80000d5c <myproc>
    80001c74:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001c76:	05853903          	ld	s2,88(a0)
    80001c7a:	0a893783          	ld	a5,168(s2)
    80001c7e:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001c82:	37fd                	addiw	a5,a5,-1
    80001c84:	4755                	li	a4,21
    80001c86:	00f76f63          	bltu	a4,a5,80001ca4 <syscall+0x40>
    80001c8a:	00369713          	slli	a4,a3,0x3
    80001c8e:	00006797          	auipc	a5,0x6
    80001c92:	b4278793          	addi	a5,a5,-1214 # 800077d0 <syscalls>
    80001c96:	97ba                	add	a5,a5,a4
    80001c98:	639c                	ld	a5,0(a5)
    80001c9a:	c789                	beqz	a5,80001ca4 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80001c9c:	9782                	jalr	a5
    80001c9e:	06a93823          	sd	a0,112(s2)
    80001ca2:	a829                	j	80001cbc <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001ca4:	15848613          	addi	a2,s1,344
    80001ca8:	588c                	lw	a1,48(s1)
    80001caa:	00005517          	auipc	a0,0x5
    80001cae:	70650513          	addi	a0,a0,1798 # 800073b0 <etext+0x3b0>
    80001cb2:	724030ef          	jal	800053d6 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001cb6:	6cbc                	ld	a5,88(s1)
    80001cb8:	577d                	li	a4,-1
    80001cba:	fbb8                	sd	a4,112(a5)
  }
}
    80001cbc:	60e2                	ld	ra,24(sp)
    80001cbe:	6442                	ld	s0,16(sp)
    80001cc0:	64a2                	ld	s1,8(sp)
    80001cc2:	6902                	ld	s2,0(sp)
    80001cc4:	6105                	addi	sp,sp,32
    80001cc6:	8082                	ret

0000000080001cc8 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80001cc8:	1101                	addi	sp,sp,-32
    80001cca:	ec06                	sd	ra,24(sp)
    80001ccc:	e822                	sd	s0,16(sp)
    80001cce:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80001cd0:	fec40593          	addi	a1,s0,-20
    80001cd4:	4501                	li	a0,0
    80001cd6:	f2fff0ef          	jal	80001c04 <argint>
  exit(n);
    80001cda:	fec42503          	lw	a0,-20(s0)
    80001cde:	f4eff0ef          	jal	8000142c <exit>
  return 0;  // not reached
}
    80001ce2:	4501                	li	a0,0
    80001ce4:	60e2                	ld	ra,24(sp)
    80001ce6:	6442                	ld	s0,16(sp)
    80001ce8:	6105                	addi	sp,sp,32
    80001cea:	8082                	ret

0000000080001cec <sys_getpid>:

uint64
sys_getpid(void)
{
    80001cec:	1141                	addi	sp,sp,-16
    80001cee:	e406                	sd	ra,8(sp)
    80001cf0:	e022                	sd	s0,0(sp)
    80001cf2:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80001cf4:	868ff0ef          	jal	80000d5c <myproc>
}
    80001cf8:	5908                	lw	a0,48(a0)
    80001cfa:	60a2                	ld	ra,8(sp)
    80001cfc:	6402                	ld	s0,0(sp)
    80001cfe:	0141                	addi	sp,sp,16
    80001d00:	8082                	ret

0000000080001d02 <sys_fork>:

uint64
sys_fork(void)
{
    80001d02:	1141                	addi	sp,sp,-16
    80001d04:	e406                	sd	ra,8(sp)
    80001d06:	e022                	sd	s0,0(sp)
    80001d08:	0800                	addi	s0,sp,16
  return fork();
    80001d0a:	b78ff0ef          	jal	80001082 <fork>
}
    80001d0e:	60a2                	ld	ra,8(sp)
    80001d10:	6402                	ld	s0,0(sp)
    80001d12:	0141                	addi	sp,sp,16
    80001d14:	8082                	ret

0000000080001d16 <sys_wait>:

uint64
sys_wait(void)
{
    80001d16:	1101                	addi	sp,sp,-32
    80001d18:	ec06                	sd	ra,24(sp)
    80001d1a:	e822                	sd	s0,16(sp)
    80001d1c:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80001d1e:	fe840593          	addi	a1,s0,-24
    80001d22:	4501                	li	a0,0
    80001d24:	efdff0ef          	jal	80001c20 <argaddr>
  return wait(p);
    80001d28:	fe843503          	ld	a0,-24(s0)
    80001d2c:	857ff0ef          	jal	80001582 <wait>
}
    80001d30:	60e2                	ld	ra,24(sp)
    80001d32:	6442                	ld	s0,16(sp)
    80001d34:	6105                	addi	sp,sp,32
    80001d36:	8082                	ret

0000000080001d38 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80001d38:	7179                	addi	sp,sp,-48
    80001d3a:	f406                	sd	ra,40(sp)
    80001d3c:	f022                	sd	s0,32(sp)
    80001d3e:	ec26                	sd	s1,24(sp)
    80001d40:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80001d42:	fdc40593          	addi	a1,s0,-36
    80001d46:	4501                	li	a0,0
    80001d48:	ebdff0ef          	jal	80001c04 <argint>
  addr = myproc()->sz;
    80001d4c:	810ff0ef          	jal	80000d5c <myproc>
    80001d50:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80001d52:	fdc42503          	lw	a0,-36(s0)
    80001d56:	adcff0ef          	jal	80001032 <growproc>
    80001d5a:	00054863          	bltz	a0,80001d6a <sys_sbrk+0x32>
    return -1;
  return addr;
}
    80001d5e:	8526                	mv	a0,s1
    80001d60:	70a2                	ld	ra,40(sp)
    80001d62:	7402                	ld	s0,32(sp)
    80001d64:	64e2                	ld	s1,24(sp)
    80001d66:	6145                	addi	sp,sp,48
    80001d68:	8082                	ret
    return -1;
    80001d6a:	54fd                	li	s1,-1
    80001d6c:	bfcd                	j	80001d5e <sys_sbrk+0x26>

0000000080001d6e <sys_sleep>:

uint64
sys_sleep(void)
{
    80001d6e:	7139                	addi	sp,sp,-64
    80001d70:	fc06                	sd	ra,56(sp)
    80001d72:	f822                	sd	s0,48(sp)
    80001d74:	f04a                	sd	s2,32(sp)
    80001d76:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80001d78:	fcc40593          	addi	a1,s0,-52
    80001d7c:	4501                	li	a0,0
    80001d7e:	e87ff0ef          	jal	80001c04 <argint>
  if(n < 0)
    80001d82:	fcc42783          	lw	a5,-52(s0)
    80001d86:	0607c763          	bltz	a5,80001df4 <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80001d8a:	00007517          	auipc	a0,0x7
    80001d8e:	df650513          	addi	a0,a0,-522 # 80008b80 <tickslock>
    80001d92:	443030ef          	jal	800059d4 <acquire>
  ticks0 = ticks;
    80001d96:	00006917          	auipc	s2,0x6
    80001d9a:	b7292903          	lw	s2,-1166(s2) # 80007908 <ticks>
  while(ticks - ticks0 < n){
    80001d9e:	fcc42783          	lw	a5,-52(s0)
    80001da2:	cf8d                	beqz	a5,80001ddc <sys_sleep+0x6e>
    80001da4:	f426                	sd	s1,40(sp)
    80001da6:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80001da8:	00007997          	auipc	s3,0x7
    80001dac:	dd898993          	addi	s3,s3,-552 # 80008b80 <tickslock>
    80001db0:	00006497          	auipc	s1,0x6
    80001db4:	b5848493          	addi	s1,s1,-1192 # 80007908 <ticks>
    if(killed(myproc())){
    80001db8:	fa5fe0ef          	jal	80000d5c <myproc>
    80001dbc:	f9cff0ef          	jal	80001558 <killed>
    80001dc0:	ed0d                	bnez	a0,80001dfa <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    80001dc2:	85ce                	mv	a1,s3
    80001dc4:	8526                	mv	a0,s1
    80001dc6:	d60ff0ef          	jal	80001326 <sleep>
  while(ticks - ticks0 < n){
    80001dca:	409c                	lw	a5,0(s1)
    80001dcc:	412787bb          	subw	a5,a5,s2
    80001dd0:	fcc42703          	lw	a4,-52(s0)
    80001dd4:	fee7e2e3          	bltu	a5,a4,80001db8 <sys_sleep+0x4a>
    80001dd8:	74a2                	ld	s1,40(sp)
    80001dda:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80001ddc:	00007517          	auipc	a0,0x7
    80001de0:	da450513          	addi	a0,a0,-604 # 80008b80 <tickslock>
    80001de4:	485030ef          	jal	80005a68 <release>
  return 0;
    80001de8:	4501                	li	a0,0
}
    80001dea:	70e2                	ld	ra,56(sp)
    80001dec:	7442                	ld	s0,48(sp)
    80001dee:	7902                	ld	s2,32(sp)
    80001df0:	6121                	addi	sp,sp,64
    80001df2:	8082                	ret
    n = 0;
    80001df4:	fc042623          	sw	zero,-52(s0)
    80001df8:	bf49                	j	80001d8a <sys_sleep+0x1c>
      release(&tickslock);
    80001dfa:	00007517          	auipc	a0,0x7
    80001dfe:	d8650513          	addi	a0,a0,-634 # 80008b80 <tickslock>
    80001e02:	467030ef          	jal	80005a68 <release>
      return -1;
    80001e06:	557d                	li	a0,-1
    80001e08:	74a2                	ld	s1,40(sp)
    80001e0a:	69e2                	ld	s3,24(sp)
    80001e0c:	bff9                	j	80001dea <sys_sleep+0x7c>

0000000080001e0e <sys_kill>:

uint64
sys_kill(void)
{
    80001e0e:	1101                	addi	sp,sp,-32
    80001e10:	ec06                	sd	ra,24(sp)
    80001e12:	e822                	sd	s0,16(sp)
    80001e14:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80001e16:	fec40593          	addi	a1,s0,-20
    80001e1a:	4501                	li	a0,0
    80001e1c:	de9ff0ef          	jal	80001c04 <argint>
  return kill(pid);
    80001e20:	fec42503          	lw	a0,-20(s0)
    80001e24:	eaaff0ef          	jal	800014ce <kill>
}
    80001e28:	60e2                	ld	ra,24(sp)
    80001e2a:	6442                	ld	s0,16(sp)
    80001e2c:	6105                	addi	sp,sp,32
    80001e2e:	8082                	ret

0000000080001e30 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80001e30:	1101                	addi	sp,sp,-32
    80001e32:	ec06                	sd	ra,24(sp)
    80001e34:	e822                	sd	s0,16(sp)
    80001e36:	e426                	sd	s1,8(sp)
    80001e38:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80001e3a:	00007517          	auipc	a0,0x7
    80001e3e:	d4650513          	addi	a0,a0,-698 # 80008b80 <tickslock>
    80001e42:	393030ef          	jal	800059d4 <acquire>
  xticks = ticks;
    80001e46:	00006497          	auipc	s1,0x6
    80001e4a:	ac24a483          	lw	s1,-1342(s1) # 80007908 <ticks>
  release(&tickslock);
    80001e4e:	00007517          	auipc	a0,0x7
    80001e52:	d3250513          	addi	a0,a0,-718 # 80008b80 <tickslock>
    80001e56:	413030ef          	jal	80005a68 <release>
  return xticks;
}
    80001e5a:	02049513          	slli	a0,s1,0x20
    80001e5e:	9101                	srli	a0,a0,0x20
    80001e60:	60e2                	ld	ra,24(sp)
    80001e62:	6442                	ld	s0,16(sp)
    80001e64:	64a2                	ld	s1,8(sp)
    80001e66:	6105                	addi	sp,sp,32
    80001e68:	8082                	ret

0000000080001e6a <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80001e6a:	7179                	addi	sp,sp,-48
    80001e6c:	f406                	sd	ra,40(sp)
    80001e6e:	f022                	sd	s0,32(sp)
    80001e70:	ec26                	sd	s1,24(sp)
    80001e72:	e84a                	sd	s2,16(sp)
    80001e74:	e44e                	sd	s3,8(sp)
    80001e76:	e052                	sd	s4,0(sp)
    80001e78:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80001e7a:	00005597          	auipc	a1,0x5
    80001e7e:	55658593          	addi	a1,a1,1366 # 800073d0 <etext+0x3d0>
    80001e82:	00007517          	auipc	a0,0x7
    80001e86:	d1650513          	addi	a0,a0,-746 # 80008b98 <bcache>
    80001e8a:	2c7030ef          	jal	80005950 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80001e8e:	0000f797          	auipc	a5,0xf
    80001e92:	d0a78793          	addi	a5,a5,-758 # 80010b98 <bcache+0x8000>
    80001e96:	0000f717          	auipc	a4,0xf
    80001e9a:	f6a70713          	addi	a4,a4,-150 # 80010e00 <bcache+0x8268>
    80001e9e:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80001ea2:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001ea6:	00007497          	auipc	s1,0x7
    80001eaa:	d0a48493          	addi	s1,s1,-758 # 80008bb0 <bcache+0x18>
    b->next = bcache.head.next;
    80001eae:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80001eb0:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80001eb2:	00005a17          	auipc	s4,0x5
    80001eb6:	526a0a13          	addi	s4,s4,1318 # 800073d8 <etext+0x3d8>
    b->next = bcache.head.next;
    80001eba:	2b893783          	ld	a5,696(s2)
    80001ebe:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80001ec0:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80001ec4:	85d2                	mv	a1,s4
    80001ec6:	01048513          	addi	a0,s1,16
    80001eca:	380010ef          	jal	8000324a <initsleeplock>
    bcache.head.next->prev = b;
    80001ece:	2b893783          	ld	a5,696(s2)
    80001ed2:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80001ed4:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001ed8:	45848493          	addi	s1,s1,1112
    80001edc:	fd349fe3          	bne	s1,s3,80001eba <binit+0x50>
  }
}
    80001ee0:	70a2                	ld	ra,40(sp)
    80001ee2:	7402                	ld	s0,32(sp)
    80001ee4:	64e2                	ld	s1,24(sp)
    80001ee6:	6942                	ld	s2,16(sp)
    80001ee8:	69a2                	ld	s3,8(sp)
    80001eea:	6a02                	ld	s4,0(sp)
    80001eec:	6145                	addi	sp,sp,48
    80001eee:	8082                	ret

0000000080001ef0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80001ef0:	7179                	addi	sp,sp,-48
    80001ef2:	f406                	sd	ra,40(sp)
    80001ef4:	f022                	sd	s0,32(sp)
    80001ef6:	ec26                	sd	s1,24(sp)
    80001ef8:	e84a                	sd	s2,16(sp)
    80001efa:	e44e                	sd	s3,8(sp)
    80001efc:	1800                	addi	s0,sp,48
    80001efe:	892a                	mv	s2,a0
    80001f00:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80001f02:	00007517          	auipc	a0,0x7
    80001f06:	c9650513          	addi	a0,a0,-874 # 80008b98 <bcache>
    80001f0a:	2cb030ef          	jal	800059d4 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80001f0e:	0000f497          	auipc	s1,0xf
    80001f12:	f424b483          	ld	s1,-190(s1) # 80010e50 <bcache+0x82b8>
    80001f16:	0000f797          	auipc	a5,0xf
    80001f1a:	eea78793          	addi	a5,a5,-278 # 80010e00 <bcache+0x8268>
    80001f1e:	02f48b63          	beq	s1,a5,80001f54 <bread+0x64>
    80001f22:	873e                	mv	a4,a5
    80001f24:	a021                	j	80001f2c <bread+0x3c>
    80001f26:	68a4                	ld	s1,80(s1)
    80001f28:	02e48663          	beq	s1,a4,80001f54 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80001f2c:	449c                	lw	a5,8(s1)
    80001f2e:	ff279ce3          	bne	a5,s2,80001f26 <bread+0x36>
    80001f32:	44dc                	lw	a5,12(s1)
    80001f34:	ff3799e3          	bne	a5,s3,80001f26 <bread+0x36>
      b->refcnt++;
    80001f38:	40bc                	lw	a5,64(s1)
    80001f3a:	2785                	addiw	a5,a5,1
    80001f3c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80001f3e:	00007517          	auipc	a0,0x7
    80001f42:	c5a50513          	addi	a0,a0,-934 # 80008b98 <bcache>
    80001f46:	323030ef          	jal	80005a68 <release>
      acquiresleep(&b->lock);
    80001f4a:	01048513          	addi	a0,s1,16
    80001f4e:	332010ef          	jal	80003280 <acquiresleep>
      return b;
    80001f52:	a889                	j	80001fa4 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80001f54:	0000f497          	auipc	s1,0xf
    80001f58:	ef44b483          	ld	s1,-268(s1) # 80010e48 <bcache+0x82b0>
    80001f5c:	0000f797          	auipc	a5,0xf
    80001f60:	ea478793          	addi	a5,a5,-348 # 80010e00 <bcache+0x8268>
    80001f64:	00f48863          	beq	s1,a5,80001f74 <bread+0x84>
    80001f68:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80001f6a:	40bc                	lw	a5,64(s1)
    80001f6c:	cb91                	beqz	a5,80001f80 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80001f6e:	64a4                	ld	s1,72(s1)
    80001f70:	fee49de3          	bne	s1,a4,80001f6a <bread+0x7a>
  panic("bget: no buffers");
    80001f74:	00005517          	auipc	a0,0x5
    80001f78:	46c50513          	addi	a0,a0,1132 # 800073e0 <etext+0x3e0>
    80001f7c:	72a030ef          	jal	800056a6 <panic>
      b->dev = dev;
    80001f80:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80001f84:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80001f88:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80001f8c:	4785                	li	a5,1
    80001f8e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80001f90:	00007517          	auipc	a0,0x7
    80001f94:	c0850513          	addi	a0,a0,-1016 # 80008b98 <bcache>
    80001f98:	2d1030ef          	jal	80005a68 <release>
      acquiresleep(&b->lock);
    80001f9c:	01048513          	addi	a0,s1,16
    80001fa0:	2e0010ef          	jal	80003280 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80001fa4:	409c                	lw	a5,0(s1)
    80001fa6:	cb89                	beqz	a5,80001fb8 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80001fa8:	8526                	mv	a0,s1
    80001faa:	70a2                	ld	ra,40(sp)
    80001fac:	7402                	ld	s0,32(sp)
    80001fae:	64e2                	ld	s1,24(sp)
    80001fb0:	6942                	ld	s2,16(sp)
    80001fb2:	69a2                	ld	s3,8(sp)
    80001fb4:	6145                	addi	sp,sp,48
    80001fb6:	8082                	ret
    virtio_disk_rw(b, 0);
    80001fb8:	4581                	li	a1,0
    80001fba:	8526                	mv	a0,s1
    80001fbc:	4b5020ef          	jal	80004c70 <virtio_disk_rw>
    b->valid = 1;
    80001fc0:	4785                	li	a5,1
    80001fc2:	c09c                	sw	a5,0(s1)
  return b;
    80001fc4:	b7d5                	j	80001fa8 <bread+0xb8>

0000000080001fc6 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80001fc6:	1101                	addi	sp,sp,-32
    80001fc8:	ec06                	sd	ra,24(sp)
    80001fca:	e822                	sd	s0,16(sp)
    80001fcc:	e426                	sd	s1,8(sp)
    80001fce:	1000                	addi	s0,sp,32
    80001fd0:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80001fd2:	0541                	addi	a0,a0,16
    80001fd4:	32a010ef          	jal	800032fe <holdingsleep>
    80001fd8:	c911                	beqz	a0,80001fec <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80001fda:	4585                	li	a1,1
    80001fdc:	8526                	mv	a0,s1
    80001fde:	493020ef          	jal	80004c70 <virtio_disk_rw>
}
    80001fe2:	60e2                	ld	ra,24(sp)
    80001fe4:	6442                	ld	s0,16(sp)
    80001fe6:	64a2                	ld	s1,8(sp)
    80001fe8:	6105                	addi	sp,sp,32
    80001fea:	8082                	ret
    panic("bwrite");
    80001fec:	00005517          	auipc	a0,0x5
    80001ff0:	40c50513          	addi	a0,a0,1036 # 800073f8 <etext+0x3f8>
    80001ff4:	6b2030ef          	jal	800056a6 <panic>

0000000080001ff8 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80001ff8:	1101                	addi	sp,sp,-32
    80001ffa:	ec06                	sd	ra,24(sp)
    80001ffc:	e822                	sd	s0,16(sp)
    80001ffe:	e426                	sd	s1,8(sp)
    80002000:	e04a                	sd	s2,0(sp)
    80002002:	1000                	addi	s0,sp,32
    80002004:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002006:	01050913          	addi	s2,a0,16
    8000200a:	854a                	mv	a0,s2
    8000200c:	2f2010ef          	jal	800032fe <holdingsleep>
    80002010:	c125                	beqz	a0,80002070 <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    80002012:	854a                	mv	a0,s2
    80002014:	2b2010ef          	jal	800032c6 <releasesleep>

  acquire(&bcache.lock);
    80002018:	00007517          	auipc	a0,0x7
    8000201c:	b8050513          	addi	a0,a0,-1152 # 80008b98 <bcache>
    80002020:	1b5030ef          	jal	800059d4 <acquire>
  b->refcnt--;
    80002024:	40bc                	lw	a5,64(s1)
    80002026:	37fd                	addiw	a5,a5,-1
    80002028:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000202a:	e79d                	bnez	a5,80002058 <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000202c:	68b8                	ld	a4,80(s1)
    8000202e:	64bc                	ld	a5,72(s1)
    80002030:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002032:	68b8                	ld	a4,80(s1)
    80002034:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002036:	0000f797          	auipc	a5,0xf
    8000203a:	b6278793          	addi	a5,a5,-1182 # 80010b98 <bcache+0x8000>
    8000203e:	2b87b703          	ld	a4,696(a5)
    80002042:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002044:	0000f717          	auipc	a4,0xf
    80002048:	dbc70713          	addi	a4,a4,-580 # 80010e00 <bcache+0x8268>
    8000204c:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000204e:	2b87b703          	ld	a4,696(a5)
    80002052:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002054:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002058:	00007517          	auipc	a0,0x7
    8000205c:	b4050513          	addi	a0,a0,-1216 # 80008b98 <bcache>
    80002060:	209030ef          	jal	80005a68 <release>
}
    80002064:	60e2                	ld	ra,24(sp)
    80002066:	6442                	ld	s0,16(sp)
    80002068:	64a2                	ld	s1,8(sp)
    8000206a:	6902                	ld	s2,0(sp)
    8000206c:	6105                	addi	sp,sp,32
    8000206e:	8082                	ret
    panic("brelse");
    80002070:	00005517          	auipc	a0,0x5
    80002074:	39050513          	addi	a0,a0,912 # 80007400 <etext+0x400>
    80002078:	62e030ef          	jal	800056a6 <panic>

000000008000207c <bpin>:

void
bpin(struct buf *b) {
    8000207c:	1101                	addi	sp,sp,-32
    8000207e:	ec06                	sd	ra,24(sp)
    80002080:	e822                	sd	s0,16(sp)
    80002082:	e426                	sd	s1,8(sp)
    80002084:	1000                	addi	s0,sp,32
    80002086:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002088:	00007517          	auipc	a0,0x7
    8000208c:	b1050513          	addi	a0,a0,-1264 # 80008b98 <bcache>
    80002090:	145030ef          	jal	800059d4 <acquire>
  b->refcnt++;
    80002094:	40bc                	lw	a5,64(s1)
    80002096:	2785                	addiw	a5,a5,1
    80002098:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000209a:	00007517          	auipc	a0,0x7
    8000209e:	afe50513          	addi	a0,a0,-1282 # 80008b98 <bcache>
    800020a2:	1c7030ef          	jal	80005a68 <release>
}
    800020a6:	60e2                	ld	ra,24(sp)
    800020a8:	6442                	ld	s0,16(sp)
    800020aa:	64a2                	ld	s1,8(sp)
    800020ac:	6105                	addi	sp,sp,32
    800020ae:	8082                	ret

00000000800020b0 <bunpin>:

void
bunpin(struct buf *b) {
    800020b0:	1101                	addi	sp,sp,-32
    800020b2:	ec06                	sd	ra,24(sp)
    800020b4:	e822                	sd	s0,16(sp)
    800020b6:	e426                	sd	s1,8(sp)
    800020b8:	1000                	addi	s0,sp,32
    800020ba:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800020bc:	00007517          	auipc	a0,0x7
    800020c0:	adc50513          	addi	a0,a0,-1316 # 80008b98 <bcache>
    800020c4:	111030ef          	jal	800059d4 <acquire>
  b->refcnt--;
    800020c8:	40bc                	lw	a5,64(s1)
    800020ca:	37fd                	addiw	a5,a5,-1
    800020cc:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800020ce:	00007517          	auipc	a0,0x7
    800020d2:	aca50513          	addi	a0,a0,-1334 # 80008b98 <bcache>
    800020d6:	193030ef          	jal	80005a68 <release>
}
    800020da:	60e2                	ld	ra,24(sp)
    800020dc:	6442                	ld	s0,16(sp)
    800020de:	64a2                	ld	s1,8(sp)
    800020e0:	6105                	addi	sp,sp,32
    800020e2:	8082                	ret

00000000800020e4 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800020e4:	1101                	addi	sp,sp,-32
    800020e6:	ec06                	sd	ra,24(sp)
    800020e8:	e822                	sd	s0,16(sp)
    800020ea:	e426                	sd	s1,8(sp)
    800020ec:	e04a                	sd	s2,0(sp)
    800020ee:	1000                	addi	s0,sp,32
    800020f0:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800020f2:	00d5d79b          	srliw	a5,a1,0xd
    800020f6:	0000f597          	auipc	a1,0xf
    800020fa:	17e5a583          	lw	a1,382(a1) # 80011274 <sb+0x1c>
    800020fe:	9dbd                	addw	a1,a1,a5
    80002100:	df1ff0ef          	jal	80001ef0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002104:	0074f713          	andi	a4,s1,7
    80002108:	4785                	li	a5,1
    8000210a:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    8000210e:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    80002110:	90d9                	srli	s1,s1,0x36
    80002112:	00950733          	add	a4,a0,s1
    80002116:	05874703          	lbu	a4,88(a4)
    8000211a:	00e7f6b3          	and	a3,a5,a4
    8000211e:	c29d                	beqz	a3,80002144 <bfree+0x60>
    80002120:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002122:	94aa                	add	s1,s1,a0
    80002124:	fff7c793          	not	a5,a5
    80002128:	8f7d                	and	a4,a4,a5
    8000212a:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000212e:	04c010ef          	jal	8000317a <log_write>
  brelse(bp);
    80002132:	854a                	mv	a0,s2
    80002134:	ec5ff0ef          	jal	80001ff8 <brelse>
}
    80002138:	60e2                	ld	ra,24(sp)
    8000213a:	6442                	ld	s0,16(sp)
    8000213c:	64a2                	ld	s1,8(sp)
    8000213e:	6902                	ld	s2,0(sp)
    80002140:	6105                	addi	sp,sp,32
    80002142:	8082                	ret
    panic("freeing free block");
    80002144:	00005517          	auipc	a0,0x5
    80002148:	2c450513          	addi	a0,a0,708 # 80007408 <etext+0x408>
    8000214c:	55a030ef          	jal	800056a6 <panic>

0000000080002150 <balloc>:
{
    80002150:	715d                	addi	sp,sp,-80
    80002152:	e486                	sd	ra,72(sp)
    80002154:	e0a2                	sd	s0,64(sp)
    80002156:	fc26                	sd	s1,56(sp)
    80002158:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    8000215a:	0000f797          	auipc	a5,0xf
    8000215e:	1027a783          	lw	a5,258(a5) # 8001125c <sb+0x4>
    80002162:	0e078863          	beqz	a5,80002252 <balloc+0x102>
    80002166:	f84a                	sd	s2,48(sp)
    80002168:	f44e                	sd	s3,40(sp)
    8000216a:	f052                	sd	s4,32(sp)
    8000216c:	ec56                	sd	s5,24(sp)
    8000216e:	e85a                	sd	s6,16(sp)
    80002170:	e45e                	sd	s7,8(sp)
    80002172:	e062                	sd	s8,0(sp)
    80002174:	8baa                	mv	s7,a0
    80002176:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002178:	0000fb17          	auipc	s6,0xf
    8000217c:	0e0b0b13          	addi	s6,s6,224 # 80011258 <sb>
      m = 1 << (bi % 8);
    80002180:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002182:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002184:	6c09                	lui	s8,0x2
    80002186:	a09d                	j	800021ec <balloc+0x9c>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002188:	97ca                	add	a5,a5,s2
    8000218a:	8e55                	or	a2,a2,a3
    8000218c:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002190:	854a                	mv	a0,s2
    80002192:	7e9000ef          	jal	8000317a <log_write>
        brelse(bp);
    80002196:	854a                	mv	a0,s2
    80002198:	e61ff0ef          	jal	80001ff8 <brelse>
  bp = bread(dev, bno);
    8000219c:	85a6                	mv	a1,s1
    8000219e:	855e                	mv	a0,s7
    800021a0:	d51ff0ef          	jal	80001ef0 <bread>
    800021a4:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800021a6:	40000613          	li	a2,1024
    800021aa:	4581                	li	a1,0
    800021ac:	05850513          	addi	a0,a0,88
    800021b0:	f9ffd0ef          	jal	8000014e <memset>
  log_write(bp);
    800021b4:	854a                	mv	a0,s2
    800021b6:	7c5000ef          	jal	8000317a <log_write>
  brelse(bp);
    800021ba:	854a                	mv	a0,s2
    800021bc:	e3dff0ef          	jal	80001ff8 <brelse>
}
    800021c0:	7942                	ld	s2,48(sp)
    800021c2:	79a2                	ld	s3,40(sp)
    800021c4:	7a02                	ld	s4,32(sp)
    800021c6:	6ae2                	ld	s5,24(sp)
    800021c8:	6b42                	ld	s6,16(sp)
    800021ca:	6ba2                	ld	s7,8(sp)
    800021cc:	6c02                	ld	s8,0(sp)
}
    800021ce:	8526                	mv	a0,s1
    800021d0:	60a6                	ld	ra,72(sp)
    800021d2:	6406                	ld	s0,64(sp)
    800021d4:	74e2                	ld	s1,56(sp)
    800021d6:	6161                	addi	sp,sp,80
    800021d8:	8082                	ret
    brelse(bp);
    800021da:	854a                	mv	a0,s2
    800021dc:	e1dff0ef          	jal	80001ff8 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800021e0:	015c0abb          	addw	s5,s8,s5
    800021e4:	004b2783          	lw	a5,4(s6)
    800021e8:	04fafe63          	bgeu	s5,a5,80002244 <balloc+0xf4>
    bp = bread(dev, BBLOCK(b, sb));
    800021ec:	41fad79b          	sraiw	a5,s5,0x1f
    800021f0:	0137d79b          	srliw	a5,a5,0x13
    800021f4:	015787bb          	addw	a5,a5,s5
    800021f8:	40d7d79b          	sraiw	a5,a5,0xd
    800021fc:	01cb2583          	lw	a1,28(s6)
    80002200:	9dbd                	addw	a1,a1,a5
    80002202:	855e                	mv	a0,s7
    80002204:	cedff0ef          	jal	80001ef0 <bread>
    80002208:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000220a:	004b2503          	lw	a0,4(s6)
    8000220e:	84d6                	mv	s1,s5
    80002210:	4701                	li	a4,0
    80002212:	fca4f4e3          	bgeu	s1,a0,800021da <balloc+0x8a>
      m = 1 << (bi % 8);
    80002216:	00777693          	andi	a3,a4,7
    8000221a:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000221e:	41f7579b          	sraiw	a5,a4,0x1f
    80002222:	01d7d79b          	srliw	a5,a5,0x1d
    80002226:	9fb9                	addw	a5,a5,a4
    80002228:	4037d79b          	sraiw	a5,a5,0x3
    8000222c:	00f90633          	add	a2,s2,a5
    80002230:	05864603          	lbu	a2,88(a2)
    80002234:	00c6f5b3          	and	a1,a3,a2
    80002238:	d9a1                	beqz	a1,80002188 <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000223a:	2705                	addiw	a4,a4,1
    8000223c:	2485                	addiw	s1,s1,1
    8000223e:	fd471ae3          	bne	a4,s4,80002212 <balloc+0xc2>
    80002242:	bf61                	j	800021da <balloc+0x8a>
    80002244:	7942                	ld	s2,48(sp)
    80002246:	79a2                	ld	s3,40(sp)
    80002248:	7a02                	ld	s4,32(sp)
    8000224a:	6ae2                	ld	s5,24(sp)
    8000224c:	6b42                	ld	s6,16(sp)
    8000224e:	6ba2                	ld	s7,8(sp)
    80002250:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    80002252:	00005517          	auipc	a0,0x5
    80002256:	1ce50513          	addi	a0,a0,462 # 80007420 <etext+0x420>
    8000225a:	17c030ef          	jal	800053d6 <printf>
  return 0;
    8000225e:	4481                	li	s1,0
    80002260:	b7bd                	j	800021ce <balloc+0x7e>

0000000080002262 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002262:	7139                	addi	sp,sp,-64
    80002264:	fc06                	sd	ra,56(sp)
    80002266:	f822                	sd	s0,48(sp)
    80002268:	f426                	sd	s1,40(sp)
    8000226a:	f04a                	sd	s2,32(sp)
    8000226c:	ec4e                	sd	s3,24(sp)
    8000226e:	0080                	addi	s0,sp,64
    80002270:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002272:	47a9                	li	a5,10
    80002274:	02b7eb63          	bltu	a5,a1,800022aa <bmap+0x48>
    if((addr = ip->addrs[bn]) == 0){
    80002278:	02059793          	slli	a5,a1,0x20
    8000227c:	01e7d593          	srli	a1,a5,0x1e
    80002280:	00b504b3          	add	s1,a0,a1
    80002284:	0504a903          	lw	s2,80(s1)
    80002288:	00090a63          	beqz	s2,8000229c <bmap+0x3a>
//     return addr;
//   }   


  panic("bmap: out of range");
}
    8000228c:	854a                	mv	a0,s2
    8000228e:	70e2                	ld	ra,56(sp)
    80002290:	7442                	ld	s0,48(sp)
    80002292:	74a2                	ld	s1,40(sp)
    80002294:	7902                	ld	s2,32(sp)
    80002296:	69e2                	ld	s3,24(sp)
    80002298:	6121                	addi	sp,sp,64
    8000229a:	8082                	ret
      addr = balloc(ip->dev);
    8000229c:	4108                	lw	a0,0(a0)
    8000229e:	eb3ff0ef          	jal	80002150 <balloc>
    800022a2:	892a                	mv	s2,a0
      if(addr == 0)
    800022a4:	d565                	beqz	a0,8000228c <bmap+0x2a>
      ip->addrs[bn] = addr;
    800022a6:	c8a8                	sw	a0,80(s1)
    800022a8:	b7d5                	j	8000228c <bmap+0x2a>
  bn -= NDIRECT;
    800022aa:	ff55849b          	addiw	s1,a1,-11
  if(bn < NINDIRECT){
    800022ae:	0ff00793          	li	a5,255
    800022b2:	0697e163          	bltu	a5,s1,80002314 <bmap+0xb2>
    if((addr = ip->addrs[NDIRECT]) == 0){
    800022b6:	07c52903          	lw	s2,124(a0)
    800022ba:	00091b63          	bnez	s2,800022d0 <bmap+0x6e>
      addr = balloc(ip->dev);
    800022be:	4108                	lw	a0,0(a0)
    800022c0:	e91ff0ef          	jal	80002150 <balloc>
    800022c4:	892a                	mv	s2,a0
      if(addr == 0)
    800022c6:	d179                	beqz	a0,8000228c <bmap+0x2a>
    800022c8:	e852                	sd	s4,16(sp)
      ip->addrs[NDIRECT] = addr;
    800022ca:	06a9ae23          	sw	a0,124(s3)
    800022ce:	a011                	j	800022d2 <bmap+0x70>
    800022d0:	e852                	sd	s4,16(sp)
    bp = bread(ip->dev, addr);
    800022d2:	85ca                	mv	a1,s2
    800022d4:	0009a503          	lw	a0,0(s3)
    800022d8:	c19ff0ef          	jal	80001ef0 <bread>
    800022dc:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800022de:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800022e2:	02049713          	slli	a4,s1,0x20
    800022e6:	01e75493          	srli	s1,a4,0x1e
    800022ea:	94be                	add	s1,s1,a5
    800022ec:	0004a903          	lw	s2,0(s1)
    800022f0:	00090763          	beqz	s2,800022fe <bmap+0x9c>
    brelse(bp);
    800022f4:	8552                	mv	a0,s4
    800022f6:	d03ff0ef          	jal	80001ff8 <brelse>
    return addr;
    800022fa:	6a42                	ld	s4,16(sp)
    800022fc:	bf41                	j	8000228c <bmap+0x2a>
      addr = balloc(ip->dev);
    800022fe:	0009a503          	lw	a0,0(s3)
    80002302:	e4fff0ef          	jal	80002150 <balloc>
    80002306:	892a                	mv	s2,a0
      if(addr){
    80002308:	d575                	beqz	a0,800022f4 <bmap+0x92>
        a[bn] = addr;
    8000230a:	c088                	sw	a0,0(s1)
        log_write(bp);
    8000230c:	8552                	mv	a0,s4
    8000230e:	66d000ef          	jal	8000317a <log_write>
    80002312:	b7cd                	j	800022f4 <bmap+0x92>
  bn -= NINDIRECT;
    80002314:	ef55849b          	addiw	s1,a1,-267
  if(bn < DOUBLEINDIRECT){
    80002318:	67c1                	lui	a5,0x10
    8000231a:	0af4f363          	bgeu	s1,a5,800023c0 <bmap+0x15e>
    if((addr = ip->addrs[NDIRECT+1]) == 0){
    8000231e:	08052903          	lw	s2,128(a0)
    80002322:	00091c63          	bnez	s2,8000233a <bmap+0xd8>
      addr = balloc(ip->dev);
    80002326:	4108                	lw	a0,0(a0)
    80002328:	e29ff0ef          	jal	80002150 <balloc>
    8000232c:	892a                	mv	s2,a0
      if(addr == 0)
    8000232e:	dd39                	beqz	a0,8000228c <bmap+0x2a>
    80002330:	e852                	sd	s4,16(sp)
    80002332:	e456                	sd	s5,8(sp)
      ip->addrs[NDIRECT+1] = addr;
    80002334:	08a9a023          	sw	a0,128(s3)
    80002338:	a019                	j	8000233e <bmap+0xdc>
    8000233a:	e852                	sd	s4,16(sp)
    8000233c:	e456                	sd	s5,8(sp)
    bp = bread(ip->dev, addr);
    8000233e:	85ca                	mv	a1,s2
    80002340:	0009a503          	lw	a0,0(s3)
    80002344:	badff0ef          	jal	80001ef0 <bread>
    80002348:	892a                	mv	s2,a0
    a = (uint*)bp->data;
    8000234a:	05850a93          	addi	s5,a0,88
    if((addr = a[bn/NINDIRECT]) == 0){
    8000234e:	0084d79b          	srliw	a5,s1,0x8
    80002352:	078a                	slli	a5,a5,0x2
    80002354:	9abe                	add	s5,s5,a5
    80002356:	000aaa03          	lw	s4,0(s5)
    8000235a:	020a0c63          	beqz	s4,80002392 <bmap+0x130>
    brelse(bp);
    8000235e:	854a                	mv	a0,s2
    80002360:	c99ff0ef          	jal	80001ff8 <brelse>
    bp = bread(ip->dev, addr);
    80002364:	85d2                	mv	a1,s4
    80002366:	0009a503          	lw	a0,0(s3)
    8000236a:	b87ff0ef          	jal	80001ef0 <bread>
    8000236e:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002370:	05850793          	addi	a5,a0,88
    if((addr = a[bn%NINDIRECT]) == 0){
    80002374:	0ff4f593          	zext.b	a1,s1
    80002378:	058a                	slli	a1,a1,0x2
    8000237a:	00b784b3          	add	s1,a5,a1
    8000237e:	0004a903          	lw	s2,0(s1)
    80002382:	02090463          	beqz	s2,800023aa <bmap+0x148>
    brelse(bp);
    80002386:	8552                	mv	a0,s4
    80002388:	c71ff0ef          	jal	80001ff8 <brelse>
    return addr;
    8000238c:	6a42                	ld	s4,16(sp)
    8000238e:	6aa2                	ld	s5,8(sp)
    80002390:	bdf5                	j	8000228c <bmap+0x2a>
      addr = balloc(ip->dev);
    80002392:	0009a503          	lw	a0,0(s3)
    80002396:	dbbff0ef          	jal	80002150 <balloc>
    8000239a:	8a2a                	mv	s4,a0
      if(addr){
    8000239c:	d169                	beqz	a0,8000235e <bmap+0xfc>
        a[bn/NINDIRECT] = addr;
    8000239e:	00aaa023          	sw	a0,0(s5)
        log_write(bp);
    800023a2:	854a                	mv	a0,s2
    800023a4:	5d7000ef          	jal	8000317a <log_write>
    800023a8:	bf5d                	j	8000235e <bmap+0xfc>
      addr = balloc(ip->dev);
    800023aa:	0009a503          	lw	a0,0(s3)
    800023ae:	da3ff0ef          	jal	80002150 <balloc>
    800023b2:	892a                	mv	s2,a0
      if(addr){
    800023b4:	d969                	beqz	a0,80002386 <bmap+0x124>
        a[bn%NINDIRECT] = addr;
    800023b6:	c088                	sw	a0,0(s1)
        log_write(bp);
    800023b8:	8552                	mv	a0,s4
    800023ba:	5c1000ef          	jal	8000317a <log_write>
    800023be:	b7e1                	j	80002386 <bmap+0x124>
    800023c0:	e852                	sd	s4,16(sp)
    800023c2:	e456                	sd	s5,8(sp)
  panic("bmap: out of range");
    800023c4:	00005517          	auipc	a0,0x5
    800023c8:	07450513          	addi	a0,a0,116 # 80007438 <etext+0x438>
    800023cc:	2da030ef          	jal	800056a6 <panic>

00000000800023d0 <iget>:
{
    800023d0:	7179                	addi	sp,sp,-48
    800023d2:	f406                	sd	ra,40(sp)
    800023d4:	f022                	sd	s0,32(sp)
    800023d6:	ec26                	sd	s1,24(sp)
    800023d8:	e84a                	sd	s2,16(sp)
    800023da:	e44e                	sd	s3,8(sp)
    800023dc:	e052                	sd	s4,0(sp)
    800023de:	1800                	addi	s0,sp,48
    800023e0:	89aa                	mv	s3,a0
    800023e2:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800023e4:	0000f517          	auipc	a0,0xf
    800023e8:	e9450513          	addi	a0,a0,-364 # 80011278 <itable>
    800023ec:	5e8030ef          	jal	800059d4 <acquire>
  empty = 0;
    800023f0:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800023f2:	0000f497          	auipc	s1,0xf
    800023f6:	e9e48493          	addi	s1,s1,-354 # 80011290 <itable+0x18>
    800023fa:	00011697          	auipc	a3,0x11
    800023fe:	92668693          	addi	a3,a3,-1754 # 80012d20 <log>
    80002402:	a039                	j	80002410 <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002404:	02090963          	beqz	s2,80002436 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002408:	08848493          	addi	s1,s1,136
    8000240c:	02d48863          	beq	s1,a3,8000243c <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002410:	449c                	lw	a5,8(s1)
    80002412:	fef059e3          	blez	a5,80002404 <iget+0x34>
    80002416:	4098                	lw	a4,0(s1)
    80002418:	ff3716e3          	bne	a4,s3,80002404 <iget+0x34>
    8000241c:	40d8                	lw	a4,4(s1)
    8000241e:	ff4713e3          	bne	a4,s4,80002404 <iget+0x34>
      ip->ref++;
    80002422:	2785                	addiw	a5,a5,1 # 10001 <_entry-0x7ffeffff>
    80002424:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002426:	0000f517          	auipc	a0,0xf
    8000242a:	e5250513          	addi	a0,a0,-430 # 80011278 <itable>
    8000242e:	63a030ef          	jal	80005a68 <release>
      return ip;
    80002432:	8926                	mv	s2,s1
    80002434:	a02d                	j	8000245e <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002436:	fbe9                	bnez	a5,80002408 <iget+0x38>
      empty = ip;
    80002438:	8926                	mv	s2,s1
    8000243a:	b7f9                	j	80002408 <iget+0x38>
  if(empty == 0)
    8000243c:	02090a63          	beqz	s2,80002470 <iget+0xa0>
  ip->dev = dev;
    80002440:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002444:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002448:	4785                	li	a5,1
    8000244a:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000244e:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80002452:	0000f517          	auipc	a0,0xf
    80002456:	e2650513          	addi	a0,a0,-474 # 80011278 <itable>
    8000245a:	60e030ef          	jal	80005a68 <release>
}
    8000245e:	854a                	mv	a0,s2
    80002460:	70a2                	ld	ra,40(sp)
    80002462:	7402                	ld	s0,32(sp)
    80002464:	64e2                	ld	s1,24(sp)
    80002466:	6942                	ld	s2,16(sp)
    80002468:	69a2                	ld	s3,8(sp)
    8000246a:	6a02                	ld	s4,0(sp)
    8000246c:	6145                	addi	sp,sp,48
    8000246e:	8082                	ret
    panic("iget: no inodes");
    80002470:	00005517          	auipc	a0,0x5
    80002474:	fe050513          	addi	a0,a0,-32 # 80007450 <etext+0x450>
    80002478:	22e030ef          	jal	800056a6 <panic>

000000008000247c <fsinit>:
fsinit(int dev) {
    8000247c:	7179                	addi	sp,sp,-48
    8000247e:	f406                	sd	ra,40(sp)
    80002480:	f022                	sd	s0,32(sp)
    80002482:	ec26                	sd	s1,24(sp)
    80002484:	e84a                	sd	s2,16(sp)
    80002486:	e44e                	sd	s3,8(sp)
    80002488:	1800                	addi	s0,sp,48
    8000248a:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000248c:	4585                	li	a1,1
    8000248e:	a63ff0ef          	jal	80001ef0 <bread>
    80002492:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002494:	0000f997          	auipc	s3,0xf
    80002498:	dc498993          	addi	s3,s3,-572 # 80011258 <sb>
    8000249c:	02000613          	li	a2,32
    800024a0:	05850593          	addi	a1,a0,88
    800024a4:	854e                	mv	a0,s3
    800024a6:	d0dfd0ef          	jal	800001b2 <memmove>
  brelse(bp);
    800024aa:	8526                	mv	a0,s1
    800024ac:	b4dff0ef          	jal	80001ff8 <brelse>
  if(sb.magic != FSMAGIC)
    800024b0:	0009a703          	lw	a4,0(s3)
    800024b4:	102037b7          	lui	a5,0x10203
    800024b8:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800024bc:	02f71063          	bne	a4,a5,800024dc <fsinit+0x60>
  initlog(dev, &sb);
    800024c0:	0000f597          	auipc	a1,0xf
    800024c4:	d9858593          	addi	a1,a1,-616 # 80011258 <sb>
    800024c8:	854a                	mv	a0,s2
    800024ca:	2a3000ef          	jal	80002f6c <initlog>
}
    800024ce:	70a2                	ld	ra,40(sp)
    800024d0:	7402                	ld	s0,32(sp)
    800024d2:	64e2                	ld	s1,24(sp)
    800024d4:	6942                	ld	s2,16(sp)
    800024d6:	69a2                	ld	s3,8(sp)
    800024d8:	6145                	addi	sp,sp,48
    800024da:	8082                	ret
    panic("invalid file system");
    800024dc:	00005517          	auipc	a0,0x5
    800024e0:	f8450513          	addi	a0,a0,-124 # 80007460 <etext+0x460>
    800024e4:	1c2030ef          	jal	800056a6 <panic>

00000000800024e8 <iinit>:
{
    800024e8:	7179                	addi	sp,sp,-48
    800024ea:	f406                	sd	ra,40(sp)
    800024ec:	f022                	sd	s0,32(sp)
    800024ee:	ec26                	sd	s1,24(sp)
    800024f0:	e84a                	sd	s2,16(sp)
    800024f2:	e44e                	sd	s3,8(sp)
    800024f4:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800024f6:	00005597          	auipc	a1,0x5
    800024fa:	f8258593          	addi	a1,a1,-126 # 80007478 <etext+0x478>
    800024fe:	0000f517          	auipc	a0,0xf
    80002502:	d7a50513          	addi	a0,a0,-646 # 80011278 <itable>
    80002506:	44a030ef          	jal	80005950 <initlock>
  for(i = 0; i < NINODE; i++) {
    8000250a:	0000f497          	auipc	s1,0xf
    8000250e:	d9648493          	addi	s1,s1,-618 # 800112a0 <itable+0x28>
    80002512:	00011997          	auipc	s3,0x11
    80002516:	81e98993          	addi	s3,s3,-2018 # 80012d30 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    8000251a:	00005917          	auipc	s2,0x5
    8000251e:	f6690913          	addi	s2,s2,-154 # 80007480 <etext+0x480>
    80002522:	85ca                	mv	a1,s2
    80002524:	8526                	mv	a0,s1
    80002526:	525000ef          	jal	8000324a <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    8000252a:	08848493          	addi	s1,s1,136
    8000252e:	ff349ae3          	bne	s1,s3,80002522 <iinit+0x3a>
}
    80002532:	70a2                	ld	ra,40(sp)
    80002534:	7402                	ld	s0,32(sp)
    80002536:	64e2                	ld	s1,24(sp)
    80002538:	6942                	ld	s2,16(sp)
    8000253a:	69a2                	ld	s3,8(sp)
    8000253c:	6145                	addi	sp,sp,48
    8000253e:	8082                	ret

0000000080002540 <ialloc>:
{
    80002540:	7139                	addi	sp,sp,-64
    80002542:	fc06                	sd	ra,56(sp)
    80002544:	f822                	sd	s0,48(sp)
    80002546:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002548:	0000f717          	auipc	a4,0xf
    8000254c:	d1c72703          	lw	a4,-740(a4) # 80011264 <sb+0xc>
    80002550:	4785                	li	a5,1
    80002552:	06e7f063          	bgeu	a5,a4,800025b2 <ialloc+0x72>
    80002556:	f426                	sd	s1,40(sp)
    80002558:	f04a                	sd	s2,32(sp)
    8000255a:	ec4e                	sd	s3,24(sp)
    8000255c:	e852                	sd	s4,16(sp)
    8000255e:	e456                	sd	s5,8(sp)
    80002560:	e05a                	sd	s6,0(sp)
    80002562:	8aaa                	mv	s5,a0
    80002564:	8b2e                	mv	s6,a1
    80002566:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    80002568:	0000fa17          	auipc	s4,0xf
    8000256c:	cf0a0a13          	addi	s4,s4,-784 # 80011258 <sb>
    80002570:	00495593          	srli	a1,s2,0x4
    80002574:	018a2783          	lw	a5,24(s4)
    80002578:	9dbd                	addw	a1,a1,a5
    8000257a:	8556                	mv	a0,s5
    8000257c:	975ff0ef          	jal	80001ef0 <bread>
    80002580:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002582:	05850993          	addi	s3,a0,88
    80002586:	00f97793          	andi	a5,s2,15
    8000258a:	079a                	slli	a5,a5,0x6
    8000258c:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    8000258e:	00099783          	lh	a5,0(s3)
    80002592:	cb9d                	beqz	a5,800025c8 <ialloc+0x88>
    brelse(bp);
    80002594:	a65ff0ef          	jal	80001ff8 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002598:	0905                	addi	s2,s2,1
    8000259a:	00ca2703          	lw	a4,12(s4)
    8000259e:	0009079b          	sext.w	a5,s2
    800025a2:	fce7e7e3          	bltu	a5,a4,80002570 <ialloc+0x30>
    800025a6:	74a2                	ld	s1,40(sp)
    800025a8:	7902                	ld	s2,32(sp)
    800025aa:	69e2                	ld	s3,24(sp)
    800025ac:	6a42                	ld	s4,16(sp)
    800025ae:	6aa2                	ld	s5,8(sp)
    800025b0:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    800025b2:	00005517          	auipc	a0,0x5
    800025b6:	ed650513          	addi	a0,a0,-298 # 80007488 <etext+0x488>
    800025ba:	61d020ef          	jal	800053d6 <printf>
  return 0;
    800025be:	4501                	li	a0,0
}
    800025c0:	70e2                	ld	ra,56(sp)
    800025c2:	7442                	ld	s0,48(sp)
    800025c4:	6121                	addi	sp,sp,64
    800025c6:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800025c8:	04000613          	li	a2,64
    800025cc:	4581                	li	a1,0
    800025ce:	854e                	mv	a0,s3
    800025d0:	b7ffd0ef          	jal	8000014e <memset>
      dip->type = type;
    800025d4:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800025d8:	8526                	mv	a0,s1
    800025da:	3a1000ef          	jal	8000317a <log_write>
      brelse(bp);
    800025de:	8526                	mv	a0,s1
    800025e0:	a19ff0ef          	jal	80001ff8 <brelse>
      return iget(dev, inum);
    800025e4:	0009059b          	sext.w	a1,s2
    800025e8:	8556                	mv	a0,s5
    800025ea:	de7ff0ef          	jal	800023d0 <iget>
    800025ee:	74a2                	ld	s1,40(sp)
    800025f0:	7902                	ld	s2,32(sp)
    800025f2:	69e2                	ld	s3,24(sp)
    800025f4:	6a42                	ld	s4,16(sp)
    800025f6:	6aa2                	ld	s5,8(sp)
    800025f8:	6b02                	ld	s6,0(sp)
    800025fa:	b7d9                	j	800025c0 <ialloc+0x80>

00000000800025fc <iupdate>:
{
    800025fc:	1101                	addi	sp,sp,-32
    800025fe:	ec06                	sd	ra,24(sp)
    80002600:	e822                	sd	s0,16(sp)
    80002602:	e426                	sd	s1,8(sp)
    80002604:	e04a                	sd	s2,0(sp)
    80002606:	1000                	addi	s0,sp,32
    80002608:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000260a:	415c                	lw	a5,4(a0)
    8000260c:	0047d79b          	srliw	a5,a5,0x4
    80002610:	0000f597          	auipc	a1,0xf
    80002614:	c605a583          	lw	a1,-928(a1) # 80011270 <sb+0x18>
    80002618:	9dbd                	addw	a1,a1,a5
    8000261a:	4108                	lw	a0,0(a0)
    8000261c:	8d5ff0ef          	jal	80001ef0 <bread>
    80002620:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002622:	05850793          	addi	a5,a0,88
    80002626:	40d8                	lw	a4,4(s1)
    80002628:	8b3d                	andi	a4,a4,15
    8000262a:	071a                	slli	a4,a4,0x6
    8000262c:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    8000262e:	04449703          	lh	a4,68(s1)
    80002632:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002636:	04649703          	lh	a4,70(s1)
    8000263a:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    8000263e:	04849703          	lh	a4,72(s1)
    80002642:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002646:	04a49703          	lh	a4,74(s1)
    8000264a:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    8000264e:	44f8                	lw	a4,76(s1)
    80002650:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002652:	03400613          	li	a2,52
    80002656:	05048593          	addi	a1,s1,80
    8000265a:	00c78513          	addi	a0,a5,12
    8000265e:	b55fd0ef          	jal	800001b2 <memmove>
  log_write(bp);
    80002662:	854a                	mv	a0,s2
    80002664:	317000ef          	jal	8000317a <log_write>
  brelse(bp);
    80002668:	854a                	mv	a0,s2
    8000266a:	98fff0ef          	jal	80001ff8 <brelse>
}
    8000266e:	60e2                	ld	ra,24(sp)
    80002670:	6442                	ld	s0,16(sp)
    80002672:	64a2                	ld	s1,8(sp)
    80002674:	6902                	ld	s2,0(sp)
    80002676:	6105                	addi	sp,sp,32
    80002678:	8082                	ret

000000008000267a <idup>:
{
    8000267a:	1101                	addi	sp,sp,-32
    8000267c:	ec06                	sd	ra,24(sp)
    8000267e:	e822                	sd	s0,16(sp)
    80002680:	e426                	sd	s1,8(sp)
    80002682:	1000                	addi	s0,sp,32
    80002684:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002686:	0000f517          	auipc	a0,0xf
    8000268a:	bf250513          	addi	a0,a0,-1038 # 80011278 <itable>
    8000268e:	346030ef          	jal	800059d4 <acquire>
  ip->ref++;
    80002692:	449c                	lw	a5,8(s1)
    80002694:	2785                	addiw	a5,a5,1
    80002696:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002698:	0000f517          	auipc	a0,0xf
    8000269c:	be050513          	addi	a0,a0,-1056 # 80011278 <itable>
    800026a0:	3c8030ef          	jal	80005a68 <release>
}
    800026a4:	8526                	mv	a0,s1
    800026a6:	60e2                	ld	ra,24(sp)
    800026a8:	6442                	ld	s0,16(sp)
    800026aa:	64a2                	ld	s1,8(sp)
    800026ac:	6105                	addi	sp,sp,32
    800026ae:	8082                	ret

00000000800026b0 <ilock>:
{
    800026b0:	1101                	addi	sp,sp,-32
    800026b2:	ec06                	sd	ra,24(sp)
    800026b4:	e822                	sd	s0,16(sp)
    800026b6:	e426                	sd	s1,8(sp)
    800026b8:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800026ba:	cd19                	beqz	a0,800026d8 <ilock+0x28>
    800026bc:	84aa                	mv	s1,a0
    800026be:	451c                	lw	a5,8(a0)
    800026c0:	00f05c63          	blez	a5,800026d8 <ilock+0x28>
  acquiresleep(&ip->lock);
    800026c4:	0541                	addi	a0,a0,16
    800026c6:	3bb000ef          	jal	80003280 <acquiresleep>
  if(ip->valid == 0){
    800026ca:	40bc                	lw	a5,64(s1)
    800026cc:	cf89                	beqz	a5,800026e6 <ilock+0x36>
}
    800026ce:	60e2                	ld	ra,24(sp)
    800026d0:	6442                	ld	s0,16(sp)
    800026d2:	64a2                	ld	s1,8(sp)
    800026d4:	6105                	addi	sp,sp,32
    800026d6:	8082                	ret
    800026d8:	e04a                	sd	s2,0(sp)
    panic("ilock");
    800026da:	00005517          	auipc	a0,0x5
    800026de:	dc650513          	addi	a0,a0,-570 # 800074a0 <etext+0x4a0>
    800026e2:	7c5020ef          	jal	800056a6 <panic>
    800026e6:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800026e8:	40dc                	lw	a5,4(s1)
    800026ea:	0047d79b          	srliw	a5,a5,0x4
    800026ee:	0000f597          	auipc	a1,0xf
    800026f2:	b825a583          	lw	a1,-1150(a1) # 80011270 <sb+0x18>
    800026f6:	9dbd                	addw	a1,a1,a5
    800026f8:	4088                	lw	a0,0(s1)
    800026fa:	ff6ff0ef          	jal	80001ef0 <bread>
    800026fe:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002700:	05850593          	addi	a1,a0,88
    80002704:	40dc                	lw	a5,4(s1)
    80002706:	8bbd                	andi	a5,a5,15
    80002708:	079a                	slli	a5,a5,0x6
    8000270a:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    8000270c:	00059783          	lh	a5,0(a1)
    80002710:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002714:	00259783          	lh	a5,2(a1)
    80002718:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    8000271c:	00459783          	lh	a5,4(a1)
    80002720:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002724:	00659783          	lh	a5,6(a1)
    80002728:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    8000272c:	459c                	lw	a5,8(a1)
    8000272e:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002730:	03400613          	li	a2,52
    80002734:	05b1                	addi	a1,a1,12
    80002736:	05048513          	addi	a0,s1,80
    8000273a:	a79fd0ef          	jal	800001b2 <memmove>
    brelse(bp);
    8000273e:	854a                	mv	a0,s2
    80002740:	8b9ff0ef          	jal	80001ff8 <brelse>
    ip->valid = 1;
    80002744:	4785                	li	a5,1
    80002746:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002748:	04449783          	lh	a5,68(s1)
    8000274c:	c399                	beqz	a5,80002752 <ilock+0xa2>
    8000274e:	6902                	ld	s2,0(sp)
    80002750:	bfbd                	j	800026ce <ilock+0x1e>
      panic("ilock: no type");
    80002752:	00005517          	auipc	a0,0x5
    80002756:	d5650513          	addi	a0,a0,-682 # 800074a8 <etext+0x4a8>
    8000275a:	74d020ef          	jal	800056a6 <panic>

000000008000275e <iunlock>:
{
    8000275e:	1101                	addi	sp,sp,-32
    80002760:	ec06                	sd	ra,24(sp)
    80002762:	e822                	sd	s0,16(sp)
    80002764:	e426                	sd	s1,8(sp)
    80002766:	e04a                	sd	s2,0(sp)
    80002768:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    8000276a:	c505                	beqz	a0,80002792 <iunlock+0x34>
    8000276c:	84aa                	mv	s1,a0
    8000276e:	01050913          	addi	s2,a0,16
    80002772:	854a                	mv	a0,s2
    80002774:	38b000ef          	jal	800032fe <holdingsleep>
    80002778:	cd09                	beqz	a0,80002792 <iunlock+0x34>
    8000277a:	449c                	lw	a5,8(s1)
    8000277c:	00f05b63          	blez	a5,80002792 <iunlock+0x34>
  releasesleep(&ip->lock);
    80002780:	854a                	mv	a0,s2
    80002782:	345000ef          	jal	800032c6 <releasesleep>
}
    80002786:	60e2                	ld	ra,24(sp)
    80002788:	6442                	ld	s0,16(sp)
    8000278a:	64a2                	ld	s1,8(sp)
    8000278c:	6902                	ld	s2,0(sp)
    8000278e:	6105                	addi	sp,sp,32
    80002790:	8082                	ret
    panic("iunlock");
    80002792:	00005517          	auipc	a0,0x5
    80002796:	d2650513          	addi	a0,a0,-730 # 800074b8 <etext+0x4b8>
    8000279a:	70d020ef          	jal	800056a6 <panic>

000000008000279e <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    8000279e:	715d                	addi	sp,sp,-80
    800027a0:	e486                	sd	ra,72(sp)
    800027a2:	e0a2                	sd	s0,64(sp)
    800027a4:	fc26                	sd	s1,56(sp)
    800027a6:	f84a                	sd	s2,48(sp)
    800027a8:	f44e                	sd	s3,40(sp)
    800027aa:	0880                	addi	s0,sp,80
    800027ac:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp,*bpj;
  uint *a;
  uint *aj;
  for(i = 0; i < NDIRECT; i++){
    800027ae:	05050493          	addi	s1,a0,80
    800027b2:	07c50913          	addi	s2,a0,124
    800027b6:	a021                	j	800027be <itrunc+0x20>
    800027b8:	0491                	addi	s1,s1,4
    800027ba:	01248b63          	beq	s1,s2,800027d0 <itrunc+0x32>
    if(ip->addrs[i]){
    800027be:	408c                	lw	a1,0(s1)
    800027c0:	dde5                	beqz	a1,800027b8 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    800027c2:	0009a503          	lw	a0,0(s3)
    800027c6:	91fff0ef          	jal	800020e4 <bfree>
      ip->addrs[i] = 0;
    800027ca:	0004a023          	sw	zero,0(s1)
    800027ce:	b7ed                	j	800027b8 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    800027d0:	07c9a583          	lw	a1,124(s3)
    800027d4:	e185                	bnez	a1,800027f4 <itrunc+0x56>
    }
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }
  if(ip->addrs[NDIRECT+1]){
    800027d6:	0809a583          	lw	a1,128(s3)
    800027da:	edb9                	bnez	a1,80002838 <itrunc+0x9a>
    ip->addrs[NDIRECT+1] = 0;
  }

   

  ip->size = 0;
    800027dc:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    800027e0:	854e                	mv	a0,s3
    800027e2:	e1bff0ef          	jal	800025fc <iupdate>
}
    800027e6:	60a6                	ld	ra,72(sp)
    800027e8:	6406                	ld	s0,64(sp)
    800027ea:	74e2                	ld	s1,56(sp)
    800027ec:	7942                	ld	s2,48(sp)
    800027ee:	79a2                	ld	s3,40(sp)
    800027f0:	6161                	addi	sp,sp,80
    800027f2:	8082                	ret
    800027f4:	f052                	sd	s4,32(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800027f6:	0009a503          	lw	a0,0(s3)
    800027fa:	ef6ff0ef          	jal	80001ef0 <bread>
    800027fe:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002800:	05850493          	addi	s1,a0,88
    80002804:	45850913          	addi	s2,a0,1112
    80002808:	a021                	j	80002810 <itrunc+0x72>
    8000280a:	0491                	addi	s1,s1,4
    8000280c:	01248963          	beq	s1,s2,8000281e <itrunc+0x80>
      if(a[j])
    80002810:	408c                	lw	a1,0(s1)
    80002812:	dde5                	beqz	a1,8000280a <itrunc+0x6c>
        bfree(ip->dev, a[j]);
    80002814:	0009a503          	lw	a0,0(s3)
    80002818:	8cdff0ef          	jal	800020e4 <bfree>
    8000281c:	b7fd                	j	8000280a <itrunc+0x6c>
    brelse(bp);
    8000281e:	8552                	mv	a0,s4
    80002820:	fd8ff0ef          	jal	80001ff8 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002824:	07c9a583          	lw	a1,124(s3)
    80002828:	0009a503          	lw	a0,0(s3)
    8000282c:	8b9ff0ef          	jal	800020e4 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002830:	0609ae23          	sw	zero,124(s3)
    80002834:	7a02                	ld	s4,32(sp)
    80002836:	b745                	j	800027d6 <itrunc+0x38>
    80002838:	f052                	sd	s4,32(sp)
    8000283a:	ec56                	sd	s5,24(sp)
    8000283c:	e85a                	sd	s6,16(sp)
    8000283e:	e45e                	sd	s7,8(sp)
    80002840:	e062                	sd	s8,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT+1]);
    80002842:	0009a503          	lw	a0,0(s3)
    80002846:	eaaff0ef          	jal	80001ef0 <bread>
    8000284a:	8c2a                	mv	s8,a0
    for(j = 0; j < NINDIRECT; j++){
    8000284c:	05850a93          	addi	s5,a0,88
    80002850:	45850b93          	addi	s7,a0,1112
    80002854:	a03d                	j	80002882 <itrunc+0xe4>
      for(int k = 0; k < NINDIRECT; k++){
    80002856:	0491                	addi	s1,s1,4
    80002858:	01248963          	beq	s1,s2,8000286a <itrunc+0xcc>
        if(aj[k])
    8000285c:	408c                	lw	a1,0(s1)
    8000285e:	dde5                	beqz	a1,80002856 <itrunc+0xb8>
          bfree(ip->dev, aj[k]);
    80002860:	0009a503          	lw	a0,0(s3)
    80002864:	881ff0ef          	jal	800020e4 <bfree>
    80002868:	b7fd                	j	80002856 <itrunc+0xb8>
      brelse(bpj);
    8000286a:	8552                	mv	a0,s4
    8000286c:	f8cff0ef          	jal	80001ff8 <brelse>
      bfree(ip->dev, a[j]);
    80002870:	000b2583          	lw	a1,0(s6)
    80002874:	0009a503          	lw	a0,0(s3)
    80002878:	86dff0ef          	jal	800020e4 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    8000287c:	0a91                	addi	s5,s5,4
    8000287e:	017a8f63          	beq	s5,s7,8000289c <itrunc+0xfe>
      bpj = bread(ip->dev, a[j]);
    80002882:	8b56                	mv	s6,s5
    80002884:	000aa583          	lw	a1,0(s5)
    80002888:	0009a503          	lw	a0,0(s3)
    8000288c:	e64ff0ef          	jal	80001ef0 <bread>
    80002890:	8a2a                	mv	s4,a0
      for(int k = 0; k < NINDIRECT; k++){
    80002892:	05850493          	addi	s1,a0,88
    80002896:	45850913          	addi	s2,a0,1112
    8000289a:	b7c9                	j	8000285c <itrunc+0xbe>
    brelse(bp);
    8000289c:	8562                	mv	a0,s8
    8000289e:	f5aff0ef          	jal	80001ff8 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT+1]);
    800028a2:	0809a583          	lw	a1,128(s3)
    800028a6:	0009a503          	lw	a0,0(s3)
    800028aa:	83bff0ef          	jal	800020e4 <bfree>
    ip->addrs[NDIRECT+1] = 0;
    800028ae:	0809a023          	sw	zero,128(s3)
    800028b2:	7a02                	ld	s4,32(sp)
    800028b4:	6ae2                	ld	s5,24(sp)
    800028b6:	6b42                	ld	s6,16(sp)
    800028b8:	6ba2                	ld	s7,8(sp)
    800028ba:	6c02                	ld	s8,0(sp)
    800028bc:	b705                	j	800027dc <itrunc+0x3e>

00000000800028be <iput>:
{
    800028be:	1101                	addi	sp,sp,-32
    800028c0:	ec06                	sd	ra,24(sp)
    800028c2:	e822                	sd	s0,16(sp)
    800028c4:	e426                	sd	s1,8(sp)
    800028c6:	1000                	addi	s0,sp,32
    800028c8:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800028ca:	0000f517          	auipc	a0,0xf
    800028ce:	9ae50513          	addi	a0,a0,-1618 # 80011278 <itable>
    800028d2:	102030ef          	jal	800059d4 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800028d6:	4498                	lw	a4,8(s1)
    800028d8:	4785                	li	a5,1
    800028da:	02f70063          	beq	a4,a5,800028fa <iput+0x3c>
  ip->ref--;
    800028de:	449c                	lw	a5,8(s1)
    800028e0:	37fd                	addiw	a5,a5,-1
    800028e2:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800028e4:	0000f517          	auipc	a0,0xf
    800028e8:	99450513          	addi	a0,a0,-1644 # 80011278 <itable>
    800028ec:	17c030ef          	jal	80005a68 <release>
}
    800028f0:	60e2                	ld	ra,24(sp)
    800028f2:	6442                	ld	s0,16(sp)
    800028f4:	64a2                	ld	s1,8(sp)
    800028f6:	6105                	addi	sp,sp,32
    800028f8:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800028fa:	40bc                	lw	a5,64(s1)
    800028fc:	d3ed                	beqz	a5,800028de <iput+0x20>
    800028fe:	04a49783          	lh	a5,74(s1)
    80002902:	fff1                	bnez	a5,800028de <iput+0x20>
    80002904:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002906:	01048913          	addi	s2,s1,16
    8000290a:	854a                	mv	a0,s2
    8000290c:	175000ef          	jal	80003280 <acquiresleep>
    release(&itable.lock);
    80002910:	0000f517          	auipc	a0,0xf
    80002914:	96850513          	addi	a0,a0,-1688 # 80011278 <itable>
    80002918:	150030ef          	jal	80005a68 <release>
    itrunc(ip);
    8000291c:	8526                	mv	a0,s1
    8000291e:	e81ff0ef          	jal	8000279e <itrunc>
    ip->type = 0;
    80002922:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002926:	8526                	mv	a0,s1
    80002928:	cd5ff0ef          	jal	800025fc <iupdate>
    ip->valid = 0;
    8000292c:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002930:	854a                	mv	a0,s2
    80002932:	195000ef          	jal	800032c6 <releasesleep>
    acquire(&itable.lock);
    80002936:	0000f517          	auipc	a0,0xf
    8000293a:	94250513          	addi	a0,a0,-1726 # 80011278 <itable>
    8000293e:	096030ef          	jal	800059d4 <acquire>
    80002942:	6902                	ld	s2,0(sp)
    80002944:	bf69                	j	800028de <iput+0x20>

0000000080002946 <iunlockput>:
{
    80002946:	1101                	addi	sp,sp,-32
    80002948:	ec06                	sd	ra,24(sp)
    8000294a:	e822                	sd	s0,16(sp)
    8000294c:	e426                	sd	s1,8(sp)
    8000294e:	1000                	addi	s0,sp,32
    80002950:	84aa                	mv	s1,a0
  iunlock(ip);
    80002952:	e0dff0ef          	jal	8000275e <iunlock>
  iput(ip);
    80002956:	8526                	mv	a0,s1
    80002958:	f67ff0ef          	jal	800028be <iput>
}
    8000295c:	60e2                	ld	ra,24(sp)
    8000295e:	6442                	ld	s0,16(sp)
    80002960:	64a2                	ld	s1,8(sp)
    80002962:	6105                	addi	sp,sp,32
    80002964:	8082                	ret

0000000080002966 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002966:	1141                	addi	sp,sp,-16
    80002968:	e406                	sd	ra,8(sp)
    8000296a:	e022                	sd	s0,0(sp)
    8000296c:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    8000296e:	411c                	lw	a5,0(a0)
    80002970:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002972:	415c                	lw	a5,4(a0)
    80002974:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002976:	04451783          	lh	a5,68(a0)
    8000297a:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    8000297e:	04a51783          	lh	a5,74(a0)
    80002982:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002986:	04c56783          	lwu	a5,76(a0)
    8000298a:	e99c                	sd	a5,16(a1)
}
    8000298c:	60a2                	ld	ra,8(sp)
    8000298e:	6402                	ld	s0,0(sp)
    80002990:	0141                	addi	sp,sp,16
    80002992:	8082                	ret

0000000080002994 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002994:	457c                	lw	a5,76(a0)
    80002996:	0ed7e663          	bltu	a5,a3,80002a82 <readi+0xee>
{
    8000299a:	7159                	addi	sp,sp,-112
    8000299c:	f486                	sd	ra,104(sp)
    8000299e:	f0a2                	sd	s0,96(sp)
    800029a0:	eca6                	sd	s1,88(sp)
    800029a2:	e0d2                	sd	s4,64(sp)
    800029a4:	fc56                	sd	s5,56(sp)
    800029a6:	f85a                	sd	s6,48(sp)
    800029a8:	f45e                	sd	s7,40(sp)
    800029aa:	1880                	addi	s0,sp,112
    800029ac:	8b2a                	mv	s6,a0
    800029ae:	8bae                	mv	s7,a1
    800029b0:	8a32                	mv	s4,a2
    800029b2:	84b6                	mv	s1,a3
    800029b4:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    800029b6:	9f35                	addw	a4,a4,a3
    return 0;
    800029b8:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800029ba:	0ad76b63          	bltu	a4,a3,80002a70 <readi+0xdc>
    800029be:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    800029c0:	00e7f463          	bgeu	a5,a4,800029c8 <readi+0x34>
    n = ip->size - off;
    800029c4:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800029c8:	080a8b63          	beqz	s5,80002a5e <readi+0xca>
    800029cc:	e8ca                	sd	s2,80(sp)
    800029ce:	f062                	sd	s8,32(sp)
    800029d0:	ec66                	sd	s9,24(sp)
    800029d2:	e86a                	sd	s10,16(sp)
    800029d4:	e46e                	sd	s11,8(sp)
    800029d6:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800029d8:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800029dc:	5c7d                	li	s8,-1
    800029de:	a80d                	j	80002a10 <readi+0x7c>
    800029e0:	020d1d93          	slli	s11,s10,0x20
    800029e4:	020ddd93          	srli	s11,s11,0x20
    800029e8:	05890613          	addi	a2,s2,88
    800029ec:	86ee                	mv	a3,s11
    800029ee:	963e                	add	a2,a2,a5
    800029f0:	85d2                	mv	a1,s4
    800029f2:	855e                	mv	a0,s7
    800029f4:	c83fe0ef          	jal	80001676 <either_copyout>
    800029f8:	05850363          	beq	a0,s8,80002a3e <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800029fc:	854a                	mv	a0,s2
    800029fe:	dfaff0ef          	jal	80001ff8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002a02:	013d09bb          	addw	s3,s10,s3
    80002a06:	009d04bb          	addw	s1,s10,s1
    80002a0a:	9a6e                	add	s4,s4,s11
    80002a0c:	0559f363          	bgeu	s3,s5,80002a52 <readi+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002a10:	00a4d59b          	srliw	a1,s1,0xa
    80002a14:	855a                	mv	a0,s6
    80002a16:	84dff0ef          	jal	80002262 <bmap>
    80002a1a:	85aa                	mv	a1,a0
    if(addr == 0)
    80002a1c:	c139                	beqz	a0,80002a62 <readi+0xce>
    bp = bread(ip->dev, addr);
    80002a1e:	000b2503          	lw	a0,0(s6)
    80002a22:	cceff0ef          	jal	80001ef0 <bread>
    80002a26:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002a28:	3ff4f793          	andi	a5,s1,1023
    80002a2c:	40fc873b          	subw	a4,s9,a5
    80002a30:	413a86bb          	subw	a3,s5,s3
    80002a34:	8d3a                	mv	s10,a4
    80002a36:	fae6f5e3          	bgeu	a3,a4,800029e0 <readi+0x4c>
    80002a3a:	8d36                	mv	s10,a3
    80002a3c:	b755                	j	800029e0 <readi+0x4c>
      brelse(bp);
    80002a3e:	854a                	mv	a0,s2
    80002a40:	db8ff0ef          	jal	80001ff8 <brelse>
      tot = -1;
    80002a44:	59fd                	li	s3,-1
      break;
    80002a46:	6946                	ld	s2,80(sp)
    80002a48:	7c02                	ld	s8,32(sp)
    80002a4a:	6ce2                	ld	s9,24(sp)
    80002a4c:	6d42                	ld	s10,16(sp)
    80002a4e:	6da2                	ld	s11,8(sp)
    80002a50:	a831                	j	80002a6c <readi+0xd8>
    80002a52:	6946                	ld	s2,80(sp)
    80002a54:	7c02                	ld	s8,32(sp)
    80002a56:	6ce2                	ld	s9,24(sp)
    80002a58:	6d42                	ld	s10,16(sp)
    80002a5a:	6da2                	ld	s11,8(sp)
    80002a5c:	a801                	j	80002a6c <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002a5e:	89d6                	mv	s3,s5
    80002a60:	a031                	j	80002a6c <readi+0xd8>
    80002a62:	6946                	ld	s2,80(sp)
    80002a64:	7c02                	ld	s8,32(sp)
    80002a66:	6ce2                	ld	s9,24(sp)
    80002a68:	6d42                	ld	s10,16(sp)
    80002a6a:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002a6c:	854e                	mv	a0,s3
    80002a6e:	69a6                	ld	s3,72(sp)
}
    80002a70:	70a6                	ld	ra,104(sp)
    80002a72:	7406                	ld	s0,96(sp)
    80002a74:	64e6                	ld	s1,88(sp)
    80002a76:	6a06                	ld	s4,64(sp)
    80002a78:	7ae2                	ld	s5,56(sp)
    80002a7a:	7b42                	ld	s6,48(sp)
    80002a7c:	7ba2                	ld	s7,40(sp)
    80002a7e:	6165                	addi	sp,sp,112
    80002a80:	8082                	ret
    return 0;
    80002a82:	4501                	li	a0,0
}
    80002a84:	8082                	ret

0000000080002a86 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002a86:	457c                	lw	a5,76(a0)
    80002a88:	0ed7ec63          	bltu	a5,a3,80002b80 <writei+0xfa>
{
    80002a8c:	7159                	addi	sp,sp,-112
    80002a8e:	f486                	sd	ra,104(sp)
    80002a90:	f0a2                	sd	s0,96(sp)
    80002a92:	e8ca                	sd	s2,80(sp)
    80002a94:	e0d2                	sd	s4,64(sp)
    80002a96:	fc56                	sd	s5,56(sp)
    80002a98:	f85a                	sd	s6,48(sp)
    80002a9a:	f45e                	sd	s7,40(sp)
    80002a9c:	1880                	addi	s0,sp,112
    80002a9e:	8aaa                	mv	s5,a0
    80002aa0:	8bae                	mv	s7,a1
    80002aa2:	8a32                	mv	s4,a2
    80002aa4:	8936                	mv	s2,a3
    80002aa6:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002aa8:	9f35                	addw	a4,a4,a3
    80002aaa:	0cd76d63          	bltu	a4,a3,80002b84 <writei+0xfe>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002aae:	040437b7          	lui	a5,0x4043
    80002ab2:	c0078793          	addi	a5,a5,-1024 # 4042c00 <_entry-0x7bfbd400>
    80002ab6:	0ce7e963          	bltu	a5,a4,80002b88 <writei+0x102>
    80002aba:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002abc:	0a0b0a63          	beqz	s6,80002b70 <writei+0xea>
    80002ac0:	eca6                	sd	s1,88(sp)
    80002ac2:	f062                	sd	s8,32(sp)
    80002ac4:	ec66                	sd	s9,24(sp)
    80002ac6:	e86a                	sd	s10,16(sp)
    80002ac8:	e46e                	sd	s11,8(sp)
    80002aca:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002acc:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002ad0:	5c7d                	li	s8,-1
    80002ad2:	a825                	j	80002b0a <writei+0x84>
    80002ad4:	020d1d93          	slli	s11,s10,0x20
    80002ad8:	020ddd93          	srli	s11,s11,0x20
    80002adc:	05848513          	addi	a0,s1,88
    80002ae0:	86ee                	mv	a3,s11
    80002ae2:	8652                	mv	a2,s4
    80002ae4:	85de                	mv	a1,s7
    80002ae6:	953e                	add	a0,a0,a5
    80002ae8:	bd9fe0ef          	jal	800016c0 <either_copyin>
    80002aec:	05850663          	beq	a0,s8,80002b38 <writei+0xb2>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002af0:	8526                	mv	a0,s1
    80002af2:	688000ef          	jal	8000317a <log_write>
    brelse(bp);
    80002af6:	8526                	mv	a0,s1
    80002af8:	d00ff0ef          	jal	80001ff8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002afc:	013d09bb          	addw	s3,s10,s3
    80002b00:	012d093b          	addw	s2,s10,s2
    80002b04:	9a6e                	add	s4,s4,s11
    80002b06:	0369fc63          	bgeu	s3,s6,80002b3e <writei+0xb8>
    uint addr = bmap(ip, off/BSIZE);
    80002b0a:	00a9559b          	srliw	a1,s2,0xa
    80002b0e:	8556                	mv	a0,s5
    80002b10:	f52ff0ef          	jal	80002262 <bmap>
    80002b14:	85aa                	mv	a1,a0
    if(addr == 0)
    80002b16:	c505                	beqz	a0,80002b3e <writei+0xb8>
    bp = bread(ip->dev, addr);
    80002b18:	000aa503          	lw	a0,0(s5)
    80002b1c:	bd4ff0ef          	jal	80001ef0 <bread>
    80002b20:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002b22:	3ff97793          	andi	a5,s2,1023
    80002b26:	40fc873b          	subw	a4,s9,a5
    80002b2a:	413b06bb          	subw	a3,s6,s3
    80002b2e:	8d3a                	mv	s10,a4
    80002b30:	fae6f2e3          	bgeu	a3,a4,80002ad4 <writei+0x4e>
    80002b34:	8d36                	mv	s10,a3
    80002b36:	bf79                	j	80002ad4 <writei+0x4e>
      brelse(bp);
    80002b38:	8526                	mv	a0,s1
    80002b3a:	cbeff0ef          	jal	80001ff8 <brelse>
  }

  if(off > ip->size)
    80002b3e:	04caa783          	lw	a5,76(s5)
    80002b42:	0327f963          	bgeu	a5,s2,80002b74 <writei+0xee>
    ip->size = off;
    80002b46:	052aa623          	sw	s2,76(s5)
    80002b4a:	64e6                	ld	s1,88(sp)
    80002b4c:	7c02                	ld	s8,32(sp)
    80002b4e:	6ce2                	ld	s9,24(sp)
    80002b50:	6d42                	ld	s10,16(sp)
    80002b52:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002b54:	8556                	mv	a0,s5
    80002b56:	aa7ff0ef          	jal	800025fc <iupdate>

  return tot;
    80002b5a:	854e                	mv	a0,s3
    80002b5c:	69a6                	ld	s3,72(sp)
}
    80002b5e:	70a6                	ld	ra,104(sp)
    80002b60:	7406                	ld	s0,96(sp)
    80002b62:	6946                	ld	s2,80(sp)
    80002b64:	6a06                	ld	s4,64(sp)
    80002b66:	7ae2                	ld	s5,56(sp)
    80002b68:	7b42                	ld	s6,48(sp)
    80002b6a:	7ba2                	ld	s7,40(sp)
    80002b6c:	6165                	addi	sp,sp,112
    80002b6e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002b70:	89da                	mv	s3,s6
    80002b72:	b7cd                	j	80002b54 <writei+0xce>
    80002b74:	64e6                	ld	s1,88(sp)
    80002b76:	7c02                	ld	s8,32(sp)
    80002b78:	6ce2                	ld	s9,24(sp)
    80002b7a:	6d42                	ld	s10,16(sp)
    80002b7c:	6da2                	ld	s11,8(sp)
    80002b7e:	bfd9                	j	80002b54 <writei+0xce>
    return -1;
    80002b80:	557d                	li	a0,-1
}
    80002b82:	8082                	ret
    return -1;
    80002b84:	557d                	li	a0,-1
    80002b86:	bfe1                	j	80002b5e <writei+0xd8>
    return -1;
    80002b88:	557d                	li	a0,-1
    80002b8a:	bfd1                	j	80002b5e <writei+0xd8>

0000000080002b8c <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002b8c:	1141                	addi	sp,sp,-16
    80002b8e:	e406                	sd	ra,8(sp)
    80002b90:	e022                	sd	s0,0(sp)
    80002b92:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002b94:	4639                	li	a2,14
    80002b96:	e90fd0ef          	jal	80000226 <strncmp>
}
    80002b9a:	60a2                	ld	ra,8(sp)
    80002b9c:	6402                	ld	s0,0(sp)
    80002b9e:	0141                	addi	sp,sp,16
    80002ba0:	8082                	ret

0000000080002ba2 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002ba2:	711d                	addi	sp,sp,-96
    80002ba4:	ec86                	sd	ra,88(sp)
    80002ba6:	e8a2                	sd	s0,80(sp)
    80002ba8:	e4a6                	sd	s1,72(sp)
    80002baa:	e0ca                	sd	s2,64(sp)
    80002bac:	fc4e                	sd	s3,56(sp)
    80002bae:	f852                	sd	s4,48(sp)
    80002bb0:	f456                	sd	s5,40(sp)
    80002bb2:	f05a                	sd	s6,32(sp)
    80002bb4:	ec5e                	sd	s7,24(sp)
    80002bb6:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002bb8:	04451703          	lh	a4,68(a0)
    80002bbc:	4785                	li	a5,1
    80002bbe:	00f71f63          	bne	a4,a5,80002bdc <dirlookup+0x3a>
    80002bc2:	892a                	mv	s2,a0
    80002bc4:	8aae                	mv	s5,a1
    80002bc6:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002bc8:	457c                	lw	a5,76(a0)
    80002bca:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002bcc:	fa040a13          	addi	s4,s0,-96
    80002bd0:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    80002bd2:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002bd6:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002bd8:	e39d                	bnez	a5,80002bfe <dirlookup+0x5c>
    80002bda:	a8b9                	j	80002c38 <dirlookup+0x96>
    panic("dirlookup not DIR");
    80002bdc:	00005517          	auipc	a0,0x5
    80002be0:	8e450513          	addi	a0,a0,-1820 # 800074c0 <etext+0x4c0>
    80002be4:	2c3020ef          	jal	800056a6 <panic>
      panic("dirlookup read");
    80002be8:	00005517          	auipc	a0,0x5
    80002bec:	8f050513          	addi	a0,a0,-1808 # 800074d8 <etext+0x4d8>
    80002bf0:	2b7020ef          	jal	800056a6 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002bf4:	24c1                	addiw	s1,s1,16
    80002bf6:	04c92783          	lw	a5,76(s2)
    80002bfa:	02f4fe63          	bgeu	s1,a5,80002c36 <dirlookup+0x94>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002bfe:	874e                	mv	a4,s3
    80002c00:	86a6                	mv	a3,s1
    80002c02:	8652                	mv	a2,s4
    80002c04:	4581                	li	a1,0
    80002c06:	854a                	mv	a0,s2
    80002c08:	d8dff0ef          	jal	80002994 <readi>
    80002c0c:	fd351ee3          	bne	a0,s3,80002be8 <dirlookup+0x46>
    if(de.inum == 0)
    80002c10:	fa045783          	lhu	a5,-96(s0)
    80002c14:	d3e5                	beqz	a5,80002bf4 <dirlookup+0x52>
    if(namecmp(name, de.name) == 0){
    80002c16:	85da                	mv	a1,s6
    80002c18:	8556                	mv	a0,s5
    80002c1a:	f73ff0ef          	jal	80002b8c <namecmp>
    80002c1e:	f979                	bnez	a0,80002bf4 <dirlookup+0x52>
      if(poff)
    80002c20:	000b8463          	beqz	s7,80002c28 <dirlookup+0x86>
        *poff = off;
    80002c24:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    80002c28:	fa045583          	lhu	a1,-96(s0)
    80002c2c:	00092503          	lw	a0,0(s2)
    80002c30:	fa0ff0ef          	jal	800023d0 <iget>
    80002c34:	a011                	j	80002c38 <dirlookup+0x96>
  return 0;
    80002c36:	4501                	li	a0,0
}
    80002c38:	60e6                	ld	ra,88(sp)
    80002c3a:	6446                	ld	s0,80(sp)
    80002c3c:	64a6                	ld	s1,72(sp)
    80002c3e:	6906                	ld	s2,64(sp)
    80002c40:	79e2                	ld	s3,56(sp)
    80002c42:	7a42                	ld	s4,48(sp)
    80002c44:	7aa2                	ld	s5,40(sp)
    80002c46:	7b02                	ld	s6,32(sp)
    80002c48:	6be2                	ld	s7,24(sp)
    80002c4a:	6125                	addi	sp,sp,96
    80002c4c:	8082                	ret

0000000080002c4e <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002c4e:	711d                	addi	sp,sp,-96
    80002c50:	ec86                	sd	ra,88(sp)
    80002c52:	e8a2                	sd	s0,80(sp)
    80002c54:	e4a6                	sd	s1,72(sp)
    80002c56:	e0ca                	sd	s2,64(sp)
    80002c58:	fc4e                	sd	s3,56(sp)
    80002c5a:	f852                	sd	s4,48(sp)
    80002c5c:	f456                	sd	s5,40(sp)
    80002c5e:	f05a                	sd	s6,32(sp)
    80002c60:	ec5e                	sd	s7,24(sp)
    80002c62:	e862                	sd	s8,16(sp)
    80002c64:	e466                	sd	s9,8(sp)
    80002c66:	e06a                	sd	s10,0(sp)
    80002c68:	1080                	addi	s0,sp,96
    80002c6a:	84aa                	mv	s1,a0
    80002c6c:	8b2e                	mv	s6,a1
    80002c6e:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002c70:	00054703          	lbu	a4,0(a0)
    80002c74:	02f00793          	li	a5,47
    80002c78:	00f70f63          	beq	a4,a5,80002c96 <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002c7c:	8e0fe0ef          	jal	80000d5c <myproc>
    80002c80:	15053503          	ld	a0,336(a0)
    80002c84:	9f7ff0ef          	jal	8000267a <idup>
    80002c88:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002c8a:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    80002c8e:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80002c90:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002c92:	4b85                	li	s7,1
    80002c94:	a879                	j	80002d32 <namex+0xe4>
    ip = iget(ROOTDEV, ROOTINO);
    80002c96:	4585                	li	a1,1
    80002c98:	852e                	mv	a0,a1
    80002c9a:	f36ff0ef          	jal	800023d0 <iget>
    80002c9e:	8a2a                	mv	s4,a0
    80002ca0:	b7ed                	j	80002c8a <namex+0x3c>
      iunlockput(ip);
    80002ca2:	8552                	mv	a0,s4
    80002ca4:	ca3ff0ef          	jal	80002946 <iunlockput>
      return 0;
    80002ca8:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002caa:	8552                	mv	a0,s4
    80002cac:	60e6                	ld	ra,88(sp)
    80002cae:	6446                	ld	s0,80(sp)
    80002cb0:	64a6                	ld	s1,72(sp)
    80002cb2:	6906                	ld	s2,64(sp)
    80002cb4:	79e2                	ld	s3,56(sp)
    80002cb6:	7a42                	ld	s4,48(sp)
    80002cb8:	7aa2                	ld	s5,40(sp)
    80002cba:	7b02                	ld	s6,32(sp)
    80002cbc:	6be2                	ld	s7,24(sp)
    80002cbe:	6c42                	ld	s8,16(sp)
    80002cc0:	6ca2                	ld	s9,8(sp)
    80002cc2:	6d02                	ld	s10,0(sp)
    80002cc4:	6125                	addi	sp,sp,96
    80002cc6:	8082                	ret
      iunlock(ip);
    80002cc8:	8552                	mv	a0,s4
    80002cca:	a95ff0ef          	jal	8000275e <iunlock>
      return ip;
    80002cce:	bff1                	j	80002caa <namex+0x5c>
      iunlockput(ip);
    80002cd0:	8552                	mv	a0,s4
    80002cd2:	c75ff0ef          	jal	80002946 <iunlockput>
      return 0;
    80002cd6:	8a4e                	mv	s4,s3
    80002cd8:	bfc9                	j	80002caa <namex+0x5c>
  len = path - s;
    80002cda:	40998633          	sub	a2,s3,s1
    80002cde:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80002ce2:	09ac5063          	bge	s8,s10,80002d62 <namex+0x114>
    memmove(name, s, DIRSIZ);
    80002ce6:	8666                	mv	a2,s9
    80002ce8:	85a6                	mv	a1,s1
    80002cea:	8556                	mv	a0,s5
    80002cec:	cc6fd0ef          	jal	800001b2 <memmove>
    80002cf0:	84ce                	mv	s1,s3
  while(*path == '/')
    80002cf2:	0004c783          	lbu	a5,0(s1)
    80002cf6:	01279763          	bne	a5,s2,80002d04 <namex+0xb6>
    path++;
    80002cfa:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002cfc:	0004c783          	lbu	a5,0(s1)
    80002d00:	ff278de3          	beq	a5,s2,80002cfa <namex+0xac>
    ilock(ip);
    80002d04:	8552                	mv	a0,s4
    80002d06:	9abff0ef          	jal	800026b0 <ilock>
    if(ip->type != T_DIR){
    80002d0a:	044a1783          	lh	a5,68(s4)
    80002d0e:	f9779ae3          	bne	a5,s7,80002ca2 <namex+0x54>
    if(nameiparent && *path == '\0'){
    80002d12:	000b0563          	beqz	s6,80002d1c <namex+0xce>
    80002d16:	0004c783          	lbu	a5,0(s1)
    80002d1a:	d7dd                	beqz	a5,80002cc8 <namex+0x7a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002d1c:	4601                	li	a2,0
    80002d1e:	85d6                	mv	a1,s5
    80002d20:	8552                	mv	a0,s4
    80002d22:	e81ff0ef          	jal	80002ba2 <dirlookup>
    80002d26:	89aa                	mv	s3,a0
    80002d28:	d545                	beqz	a0,80002cd0 <namex+0x82>
    iunlockput(ip);
    80002d2a:	8552                	mv	a0,s4
    80002d2c:	c1bff0ef          	jal	80002946 <iunlockput>
    ip = next;
    80002d30:	8a4e                	mv	s4,s3
  while(*path == '/')
    80002d32:	0004c783          	lbu	a5,0(s1)
    80002d36:	01279763          	bne	a5,s2,80002d44 <namex+0xf6>
    path++;
    80002d3a:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002d3c:	0004c783          	lbu	a5,0(s1)
    80002d40:	ff278de3          	beq	a5,s2,80002d3a <namex+0xec>
  if(*path == 0)
    80002d44:	cb8d                	beqz	a5,80002d76 <namex+0x128>
  while(*path != '/' && *path != 0)
    80002d46:	0004c783          	lbu	a5,0(s1)
    80002d4a:	89a6                	mv	s3,s1
  len = path - s;
    80002d4c:	4d01                	li	s10,0
    80002d4e:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    80002d50:	01278963          	beq	a5,s2,80002d62 <namex+0x114>
    80002d54:	d3d9                	beqz	a5,80002cda <namex+0x8c>
    path++;
    80002d56:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80002d58:	0009c783          	lbu	a5,0(s3)
    80002d5c:	ff279ce3          	bne	a5,s2,80002d54 <namex+0x106>
    80002d60:	bfad                	j	80002cda <namex+0x8c>
    memmove(name, s, len);
    80002d62:	2601                	sext.w	a2,a2
    80002d64:	85a6                	mv	a1,s1
    80002d66:	8556                	mv	a0,s5
    80002d68:	c4afd0ef          	jal	800001b2 <memmove>
    name[len] = 0;
    80002d6c:	9d56                	add	s10,s10,s5
    80002d6e:	000d0023          	sb	zero,0(s10)
    80002d72:	84ce                	mv	s1,s3
    80002d74:	bfbd                	j	80002cf2 <namex+0xa4>
  if(nameiparent){
    80002d76:	f20b0ae3          	beqz	s6,80002caa <namex+0x5c>
    iput(ip);
    80002d7a:	8552                	mv	a0,s4
    80002d7c:	b43ff0ef          	jal	800028be <iput>
    return 0;
    80002d80:	4a01                	li	s4,0
    80002d82:	b725                	j	80002caa <namex+0x5c>

0000000080002d84 <dirlink>:
{
    80002d84:	715d                	addi	sp,sp,-80
    80002d86:	e486                	sd	ra,72(sp)
    80002d88:	e0a2                	sd	s0,64(sp)
    80002d8a:	f84a                	sd	s2,48(sp)
    80002d8c:	ec56                	sd	s5,24(sp)
    80002d8e:	e85a                	sd	s6,16(sp)
    80002d90:	0880                	addi	s0,sp,80
    80002d92:	892a                	mv	s2,a0
    80002d94:	8aae                	mv	s5,a1
    80002d96:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80002d98:	4601                	li	a2,0
    80002d9a:	e09ff0ef          	jal	80002ba2 <dirlookup>
    80002d9e:	ed1d                	bnez	a0,80002ddc <dirlink+0x58>
    80002da0:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002da2:	04c92483          	lw	s1,76(s2)
    80002da6:	c4b9                	beqz	s1,80002df4 <dirlink+0x70>
    80002da8:	f44e                	sd	s3,40(sp)
    80002daa:	f052                	sd	s4,32(sp)
    80002dac:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002dae:	fb040a13          	addi	s4,s0,-80
    80002db2:	49c1                	li	s3,16
    80002db4:	874e                	mv	a4,s3
    80002db6:	86a6                	mv	a3,s1
    80002db8:	8652                	mv	a2,s4
    80002dba:	4581                	li	a1,0
    80002dbc:	854a                	mv	a0,s2
    80002dbe:	bd7ff0ef          	jal	80002994 <readi>
    80002dc2:	03351163          	bne	a0,s3,80002de4 <dirlink+0x60>
    if(de.inum == 0)
    80002dc6:	fb045783          	lhu	a5,-80(s0)
    80002dca:	c39d                	beqz	a5,80002df0 <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002dcc:	24c1                	addiw	s1,s1,16
    80002dce:	04c92783          	lw	a5,76(s2)
    80002dd2:	fef4e1e3          	bltu	s1,a5,80002db4 <dirlink+0x30>
    80002dd6:	79a2                	ld	s3,40(sp)
    80002dd8:	7a02                	ld	s4,32(sp)
    80002dda:	a829                	j	80002df4 <dirlink+0x70>
    iput(ip);
    80002ddc:	ae3ff0ef          	jal	800028be <iput>
    return -1;
    80002de0:	557d                	li	a0,-1
    80002de2:	a83d                	j	80002e20 <dirlink+0x9c>
      panic("dirlink read");
    80002de4:	00004517          	auipc	a0,0x4
    80002de8:	70450513          	addi	a0,a0,1796 # 800074e8 <etext+0x4e8>
    80002dec:	0bb020ef          	jal	800056a6 <panic>
    80002df0:	79a2                	ld	s3,40(sp)
    80002df2:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80002df4:	4639                	li	a2,14
    80002df6:	85d6                	mv	a1,s5
    80002df8:	fb240513          	addi	a0,s0,-78
    80002dfc:	c64fd0ef          	jal	80000260 <strncpy>
  de.inum = inum;
    80002e00:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002e04:	4741                	li	a4,16
    80002e06:	86a6                	mv	a3,s1
    80002e08:	fb040613          	addi	a2,s0,-80
    80002e0c:	4581                	li	a1,0
    80002e0e:	854a                	mv	a0,s2
    80002e10:	c77ff0ef          	jal	80002a86 <writei>
    80002e14:	1541                	addi	a0,a0,-16
    80002e16:	00a03533          	snez	a0,a0
    80002e1a:	40a0053b          	negw	a0,a0
    80002e1e:	74e2                	ld	s1,56(sp)
}
    80002e20:	60a6                	ld	ra,72(sp)
    80002e22:	6406                	ld	s0,64(sp)
    80002e24:	7942                	ld	s2,48(sp)
    80002e26:	6ae2                	ld	s5,24(sp)
    80002e28:	6b42                	ld	s6,16(sp)
    80002e2a:	6161                	addi	sp,sp,80
    80002e2c:	8082                	ret

0000000080002e2e <namei>:

struct inode*
namei(char *path)
{
    80002e2e:	1101                	addi	sp,sp,-32
    80002e30:	ec06                	sd	ra,24(sp)
    80002e32:	e822                	sd	s0,16(sp)
    80002e34:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80002e36:	fe040613          	addi	a2,s0,-32
    80002e3a:	4581                	li	a1,0
    80002e3c:	e13ff0ef          	jal	80002c4e <namex>
}
    80002e40:	60e2                	ld	ra,24(sp)
    80002e42:	6442                	ld	s0,16(sp)
    80002e44:	6105                	addi	sp,sp,32
    80002e46:	8082                	ret

0000000080002e48 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80002e48:	1141                	addi	sp,sp,-16
    80002e4a:	e406                	sd	ra,8(sp)
    80002e4c:	e022                	sd	s0,0(sp)
    80002e4e:	0800                	addi	s0,sp,16
    80002e50:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80002e52:	4585                	li	a1,1
    80002e54:	dfbff0ef          	jal	80002c4e <namex>
}
    80002e58:	60a2                	ld	ra,8(sp)
    80002e5a:	6402                	ld	s0,0(sp)
    80002e5c:	0141                	addi	sp,sp,16
    80002e5e:	8082                	ret

0000000080002e60 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80002e60:	1101                	addi	sp,sp,-32
    80002e62:	ec06                	sd	ra,24(sp)
    80002e64:	e822                	sd	s0,16(sp)
    80002e66:	e426                	sd	s1,8(sp)
    80002e68:	e04a                	sd	s2,0(sp)
    80002e6a:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80002e6c:	00010917          	auipc	s2,0x10
    80002e70:	eb490913          	addi	s2,s2,-332 # 80012d20 <log>
    80002e74:	01892583          	lw	a1,24(s2)
    80002e78:	02892503          	lw	a0,40(s2)
    80002e7c:	874ff0ef          	jal	80001ef0 <bread>
    80002e80:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80002e82:	02c92603          	lw	a2,44(s2)
    80002e86:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80002e88:	00c05f63          	blez	a2,80002ea6 <write_head+0x46>
    80002e8c:	00010717          	auipc	a4,0x10
    80002e90:	ec470713          	addi	a4,a4,-316 # 80012d50 <log+0x30>
    80002e94:	87aa                	mv	a5,a0
    80002e96:	060a                	slli	a2,a2,0x2
    80002e98:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80002e9a:	4314                	lw	a3,0(a4)
    80002e9c:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80002e9e:	0711                	addi	a4,a4,4
    80002ea0:	0791                	addi	a5,a5,4
    80002ea2:	fec79ce3          	bne	a5,a2,80002e9a <write_head+0x3a>
  }
  bwrite(buf);
    80002ea6:	8526                	mv	a0,s1
    80002ea8:	91eff0ef          	jal	80001fc6 <bwrite>
  brelse(buf);
    80002eac:	8526                	mv	a0,s1
    80002eae:	94aff0ef          	jal	80001ff8 <brelse>
}
    80002eb2:	60e2                	ld	ra,24(sp)
    80002eb4:	6442                	ld	s0,16(sp)
    80002eb6:	64a2                	ld	s1,8(sp)
    80002eb8:	6902                	ld	s2,0(sp)
    80002eba:	6105                	addi	sp,sp,32
    80002ebc:	8082                	ret

0000000080002ebe <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80002ebe:	00010797          	auipc	a5,0x10
    80002ec2:	e8e7a783          	lw	a5,-370(a5) # 80012d4c <log+0x2c>
    80002ec6:	0af05263          	blez	a5,80002f6a <install_trans+0xac>
{
    80002eca:	715d                	addi	sp,sp,-80
    80002ecc:	e486                	sd	ra,72(sp)
    80002ece:	e0a2                	sd	s0,64(sp)
    80002ed0:	fc26                	sd	s1,56(sp)
    80002ed2:	f84a                	sd	s2,48(sp)
    80002ed4:	f44e                	sd	s3,40(sp)
    80002ed6:	f052                	sd	s4,32(sp)
    80002ed8:	ec56                	sd	s5,24(sp)
    80002eda:	e85a                	sd	s6,16(sp)
    80002edc:	e45e                	sd	s7,8(sp)
    80002ede:	0880                	addi	s0,sp,80
    80002ee0:	8b2a                	mv	s6,a0
    80002ee2:	00010a97          	auipc	s5,0x10
    80002ee6:	e6ea8a93          	addi	s5,s5,-402 # 80012d50 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002eea:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002eec:	00010997          	auipc	s3,0x10
    80002ef0:	e3498993          	addi	s3,s3,-460 # 80012d20 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80002ef4:	40000b93          	li	s7,1024
    80002ef8:	a829                	j	80002f12 <install_trans+0x54>
    brelse(lbuf);
    80002efa:	854a                	mv	a0,s2
    80002efc:	8fcff0ef          	jal	80001ff8 <brelse>
    brelse(dbuf);
    80002f00:	8526                	mv	a0,s1
    80002f02:	8f6ff0ef          	jal	80001ff8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002f06:	2a05                	addiw	s4,s4,1
    80002f08:	0a91                	addi	s5,s5,4
    80002f0a:	02c9a783          	lw	a5,44(s3)
    80002f0e:	04fa5363          	bge	s4,a5,80002f54 <install_trans+0x96>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002f12:	0189a583          	lw	a1,24(s3)
    80002f16:	014585bb          	addw	a1,a1,s4
    80002f1a:	2585                	addiw	a1,a1,1
    80002f1c:	0289a503          	lw	a0,40(s3)
    80002f20:	fd1fe0ef          	jal	80001ef0 <bread>
    80002f24:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80002f26:	000aa583          	lw	a1,0(s5)
    80002f2a:	0289a503          	lw	a0,40(s3)
    80002f2e:	fc3fe0ef          	jal	80001ef0 <bread>
    80002f32:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80002f34:	865e                	mv	a2,s7
    80002f36:	05890593          	addi	a1,s2,88
    80002f3a:	05850513          	addi	a0,a0,88
    80002f3e:	a74fd0ef          	jal	800001b2 <memmove>
    bwrite(dbuf);  // write dst to disk
    80002f42:	8526                	mv	a0,s1
    80002f44:	882ff0ef          	jal	80001fc6 <bwrite>
    if(recovering == 0)
    80002f48:	fa0b19e3          	bnez	s6,80002efa <install_trans+0x3c>
      bunpin(dbuf);
    80002f4c:	8526                	mv	a0,s1
    80002f4e:	962ff0ef          	jal	800020b0 <bunpin>
    80002f52:	b765                	j	80002efa <install_trans+0x3c>
}
    80002f54:	60a6                	ld	ra,72(sp)
    80002f56:	6406                	ld	s0,64(sp)
    80002f58:	74e2                	ld	s1,56(sp)
    80002f5a:	7942                	ld	s2,48(sp)
    80002f5c:	79a2                	ld	s3,40(sp)
    80002f5e:	7a02                	ld	s4,32(sp)
    80002f60:	6ae2                	ld	s5,24(sp)
    80002f62:	6b42                	ld	s6,16(sp)
    80002f64:	6ba2                	ld	s7,8(sp)
    80002f66:	6161                	addi	sp,sp,80
    80002f68:	8082                	ret
    80002f6a:	8082                	ret

0000000080002f6c <initlog>:
{
    80002f6c:	7179                	addi	sp,sp,-48
    80002f6e:	f406                	sd	ra,40(sp)
    80002f70:	f022                	sd	s0,32(sp)
    80002f72:	ec26                	sd	s1,24(sp)
    80002f74:	e84a                	sd	s2,16(sp)
    80002f76:	e44e                	sd	s3,8(sp)
    80002f78:	1800                	addi	s0,sp,48
    80002f7a:	892a                	mv	s2,a0
    80002f7c:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80002f7e:	00010497          	auipc	s1,0x10
    80002f82:	da248493          	addi	s1,s1,-606 # 80012d20 <log>
    80002f86:	00004597          	auipc	a1,0x4
    80002f8a:	57258593          	addi	a1,a1,1394 # 800074f8 <etext+0x4f8>
    80002f8e:	8526                	mv	a0,s1
    80002f90:	1c1020ef          	jal	80005950 <initlock>
  log.start = sb->logstart;
    80002f94:	0149a583          	lw	a1,20(s3)
    80002f98:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80002f9a:	0109a783          	lw	a5,16(s3)
    80002f9e:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80002fa0:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80002fa4:	854a                	mv	a0,s2
    80002fa6:	f4bfe0ef          	jal	80001ef0 <bread>
  log.lh.n = lh->n;
    80002faa:	4d30                	lw	a2,88(a0)
    80002fac:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80002fae:	00c05f63          	blez	a2,80002fcc <initlog+0x60>
    80002fb2:	87aa                	mv	a5,a0
    80002fb4:	00010717          	auipc	a4,0x10
    80002fb8:	d9c70713          	addi	a4,a4,-612 # 80012d50 <log+0x30>
    80002fbc:	060a                	slli	a2,a2,0x2
    80002fbe:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80002fc0:	4ff4                	lw	a3,92(a5)
    80002fc2:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80002fc4:	0791                	addi	a5,a5,4
    80002fc6:	0711                	addi	a4,a4,4
    80002fc8:	fec79ce3          	bne	a5,a2,80002fc0 <initlog+0x54>
  brelse(buf);
    80002fcc:	82cff0ef          	jal	80001ff8 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80002fd0:	4505                	li	a0,1
    80002fd2:	eedff0ef          	jal	80002ebe <install_trans>
  log.lh.n = 0;
    80002fd6:	00010797          	auipc	a5,0x10
    80002fda:	d607ab23          	sw	zero,-650(a5) # 80012d4c <log+0x2c>
  write_head(); // clear the log
    80002fde:	e83ff0ef          	jal	80002e60 <write_head>
}
    80002fe2:	70a2                	ld	ra,40(sp)
    80002fe4:	7402                	ld	s0,32(sp)
    80002fe6:	64e2                	ld	s1,24(sp)
    80002fe8:	6942                	ld	s2,16(sp)
    80002fea:	69a2                	ld	s3,8(sp)
    80002fec:	6145                	addi	sp,sp,48
    80002fee:	8082                	ret

0000000080002ff0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80002ff0:	1101                	addi	sp,sp,-32
    80002ff2:	ec06                	sd	ra,24(sp)
    80002ff4:	e822                	sd	s0,16(sp)
    80002ff6:	e426                	sd	s1,8(sp)
    80002ff8:	e04a                	sd	s2,0(sp)
    80002ffa:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80002ffc:	00010517          	auipc	a0,0x10
    80003000:	d2450513          	addi	a0,a0,-732 # 80012d20 <log>
    80003004:	1d1020ef          	jal	800059d4 <acquire>
  while(1){
    if(log.committing){
    80003008:	00010497          	auipc	s1,0x10
    8000300c:	d1848493          	addi	s1,s1,-744 # 80012d20 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003010:	4979                	li	s2,30
    80003012:	a029                	j	8000301c <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003014:	85a6                	mv	a1,s1
    80003016:	8526                	mv	a0,s1
    80003018:	b0efe0ef          	jal	80001326 <sleep>
    if(log.committing){
    8000301c:	50dc                	lw	a5,36(s1)
    8000301e:	fbfd                	bnez	a5,80003014 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003020:	5098                	lw	a4,32(s1)
    80003022:	2705                	addiw	a4,a4,1
    80003024:	0027179b          	slliw	a5,a4,0x2
    80003028:	9fb9                	addw	a5,a5,a4
    8000302a:	0017979b          	slliw	a5,a5,0x1
    8000302e:	54d4                	lw	a3,44(s1)
    80003030:	9fb5                	addw	a5,a5,a3
    80003032:	00f95763          	bge	s2,a5,80003040 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003036:	85a6                	mv	a1,s1
    80003038:	8526                	mv	a0,s1
    8000303a:	aecfe0ef          	jal	80001326 <sleep>
    8000303e:	bff9                	j	8000301c <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003040:	00010517          	auipc	a0,0x10
    80003044:	ce050513          	addi	a0,a0,-800 # 80012d20 <log>
    80003048:	d118                	sw	a4,32(a0)
      release(&log.lock);
    8000304a:	21f020ef          	jal	80005a68 <release>
      break;
    }
  }
}
    8000304e:	60e2                	ld	ra,24(sp)
    80003050:	6442                	ld	s0,16(sp)
    80003052:	64a2                	ld	s1,8(sp)
    80003054:	6902                	ld	s2,0(sp)
    80003056:	6105                	addi	sp,sp,32
    80003058:	8082                	ret

000000008000305a <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000305a:	7139                	addi	sp,sp,-64
    8000305c:	fc06                	sd	ra,56(sp)
    8000305e:	f822                	sd	s0,48(sp)
    80003060:	f426                	sd	s1,40(sp)
    80003062:	f04a                	sd	s2,32(sp)
    80003064:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003066:	00010497          	auipc	s1,0x10
    8000306a:	cba48493          	addi	s1,s1,-838 # 80012d20 <log>
    8000306e:	8526                	mv	a0,s1
    80003070:	165020ef          	jal	800059d4 <acquire>
  log.outstanding -= 1;
    80003074:	509c                	lw	a5,32(s1)
    80003076:	37fd                	addiw	a5,a5,-1
    80003078:	893e                	mv	s2,a5
    8000307a:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000307c:	50dc                	lw	a5,36(s1)
    8000307e:	ef9d                	bnez	a5,800030bc <end_op+0x62>
    panic("log.committing");
  if(log.outstanding == 0){
    80003080:	04091863          	bnez	s2,800030d0 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    80003084:	00010497          	auipc	s1,0x10
    80003088:	c9c48493          	addi	s1,s1,-868 # 80012d20 <log>
    8000308c:	4785                	li	a5,1
    8000308e:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003090:	8526                	mv	a0,s1
    80003092:	1d7020ef          	jal	80005a68 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003096:	54dc                	lw	a5,44(s1)
    80003098:	04f04c63          	bgtz	a5,800030f0 <end_op+0x96>
    acquire(&log.lock);
    8000309c:	00010497          	auipc	s1,0x10
    800030a0:	c8448493          	addi	s1,s1,-892 # 80012d20 <log>
    800030a4:	8526                	mv	a0,s1
    800030a6:	12f020ef          	jal	800059d4 <acquire>
    log.committing = 0;
    800030aa:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800030ae:	8526                	mv	a0,s1
    800030b0:	ac2fe0ef          	jal	80001372 <wakeup>
    release(&log.lock);
    800030b4:	8526                	mv	a0,s1
    800030b6:	1b3020ef          	jal	80005a68 <release>
}
    800030ba:	a02d                	j	800030e4 <end_op+0x8a>
    800030bc:	ec4e                	sd	s3,24(sp)
    800030be:	e852                	sd	s4,16(sp)
    800030c0:	e456                	sd	s5,8(sp)
    800030c2:	e05a                	sd	s6,0(sp)
    panic("log.committing");
    800030c4:	00004517          	auipc	a0,0x4
    800030c8:	43c50513          	addi	a0,a0,1084 # 80007500 <etext+0x500>
    800030cc:	5da020ef          	jal	800056a6 <panic>
    wakeup(&log);
    800030d0:	00010497          	auipc	s1,0x10
    800030d4:	c5048493          	addi	s1,s1,-944 # 80012d20 <log>
    800030d8:	8526                	mv	a0,s1
    800030da:	a98fe0ef          	jal	80001372 <wakeup>
  release(&log.lock);
    800030de:	8526                	mv	a0,s1
    800030e0:	189020ef          	jal	80005a68 <release>
}
    800030e4:	70e2                	ld	ra,56(sp)
    800030e6:	7442                	ld	s0,48(sp)
    800030e8:	74a2                	ld	s1,40(sp)
    800030ea:	7902                	ld	s2,32(sp)
    800030ec:	6121                	addi	sp,sp,64
    800030ee:	8082                	ret
    800030f0:	ec4e                	sd	s3,24(sp)
    800030f2:	e852                	sd	s4,16(sp)
    800030f4:	e456                	sd	s5,8(sp)
    800030f6:	e05a                	sd	s6,0(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800030f8:	00010a97          	auipc	s5,0x10
    800030fc:	c58a8a93          	addi	s5,s5,-936 # 80012d50 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003100:	00010a17          	auipc	s4,0x10
    80003104:	c20a0a13          	addi	s4,s4,-992 # 80012d20 <log>
    memmove(to->data, from->data, BSIZE);
    80003108:	40000b13          	li	s6,1024
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000310c:	018a2583          	lw	a1,24(s4)
    80003110:	012585bb          	addw	a1,a1,s2
    80003114:	2585                	addiw	a1,a1,1
    80003116:	028a2503          	lw	a0,40(s4)
    8000311a:	dd7fe0ef          	jal	80001ef0 <bread>
    8000311e:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003120:	000aa583          	lw	a1,0(s5)
    80003124:	028a2503          	lw	a0,40(s4)
    80003128:	dc9fe0ef          	jal	80001ef0 <bread>
    8000312c:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000312e:	865a                	mv	a2,s6
    80003130:	05850593          	addi	a1,a0,88
    80003134:	05848513          	addi	a0,s1,88
    80003138:	87afd0ef          	jal	800001b2 <memmove>
    bwrite(to);  // write the log
    8000313c:	8526                	mv	a0,s1
    8000313e:	e89fe0ef          	jal	80001fc6 <bwrite>
    brelse(from);
    80003142:	854e                	mv	a0,s3
    80003144:	eb5fe0ef          	jal	80001ff8 <brelse>
    brelse(to);
    80003148:	8526                	mv	a0,s1
    8000314a:	eaffe0ef          	jal	80001ff8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000314e:	2905                	addiw	s2,s2,1
    80003150:	0a91                	addi	s5,s5,4
    80003152:	02ca2783          	lw	a5,44(s4)
    80003156:	faf94be3          	blt	s2,a5,8000310c <end_op+0xb2>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000315a:	d07ff0ef          	jal	80002e60 <write_head>
    install_trans(0); // Now install writes to home locations
    8000315e:	4501                	li	a0,0
    80003160:	d5fff0ef          	jal	80002ebe <install_trans>
    log.lh.n = 0;
    80003164:	00010797          	auipc	a5,0x10
    80003168:	be07a423          	sw	zero,-1048(a5) # 80012d4c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000316c:	cf5ff0ef          	jal	80002e60 <write_head>
    80003170:	69e2                	ld	s3,24(sp)
    80003172:	6a42                	ld	s4,16(sp)
    80003174:	6aa2                	ld	s5,8(sp)
    80003176:	6b02                	ld	s6,0(sp)
    80003178:	b715                	j	8000309c <end_op+0x42>

000000008000317a <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000317a:	1101                	addi	sp,sp,-32
    8000317c:	ec06                	sd	ra,24(sp)
    8000317e:	e822                	sd	s0,16(sp)
    80003180:	e426                	sd	s1,8(sp)
    80003182:	e04a                	sd	s2,0(sp)
    80003184:	1000                	addi	s0,sp,32
    80003186:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003188:	00010917          	auipc	s2,0x10
    8000318c:	b9890913          	addi	s2,s2,-1128 # 80012d20 <log>
    80003190:	854a                	mv	a0,s2
    80003192:	043020ef          	jal	800059d4 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003196:	02c92603          	lw	a2,44(s2)
    8000319a:	47f5                	li	a5,29
    8000319c:	06c7c363          	blt	a5,a2,80003202 <log_write+0x88>
    800031a0:	00010797          	auipc	a5,0x10
    800031a4:	b9c7a783          	lw	a5,-1124(a5) # 80012d3c <log+0x1c>
    800031a8:	37fd                	addiw	a5,a5,-1
    800031aa:	04f65c63          	bge	a2,a5,80003202 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800031ae:	00010797          	auipc	a5,0x10
    800031b2:	b927a783          	lw	a5,-1134(a5) # 80012d40 <log+0x20>
    800031b6:	04f05c63          	blez	a5,8000320e <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800031ba:	4781                	li	a5,0
    800031bc:	04c05f63          	blez	a2,8000321a <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800031c0:	44cc                	lw	a1,12(s1)
    800031c2:	00010717          	auipc	a4,0x10
    800031c6:	b8e70713          	addi	a4,a4,-1138 # 80012d50 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800031ca:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800031cc:	4314                	lw	a3,0(a4)
    800031ce:	04b68663          	beq	a3,a1,8000321a <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    800031d2:	2785                	addiw	a5,a5,1
    800031d4:	0711                	addi	a4,a4,4
    800031d6:	fef61be3          	bne	a2,a5,800031cc <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    800031da:	0621                	addi	a2,a2,8
    800031dc:	060a                	slli	a2,a2,0x2
    800031de:	00010797          	auipc	a5,0x10
    800031e2:	b4278793          	addi	a5,a5,-1214 # 80012d20 <log>
    800031e6:	97b2                	add	a5,a5,a2
    800031e8:	44d8                	lw	a4,12(s1)
    800031ea:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800031ec:	8526                	mv	a0,s1
    800031ee:	e8ffe0ef          	jal	8000207c <bpin>
    log.lh.n++;
    800031f2:	00010717          	auipc	a4,0x10
    800031f6:	b2e70713          	addi	a4,a4,-1234 # 80012d20 <log>
    800031fa:	575c                	lw	a5,44(a4)
    800031fc:	2785                	addiw	a5,a5,1
    800031fe:	d75c                	sw	a5,44(a4)
    80003200:	a80d                	j	80003232 <log_write+0xb8>
    panic("too big a transaction");
    80003202:	00004517          	auipc	a0,0x4
    80003206:	30e50513          	addi	a0,a0,782 # 80007510 <etext+0x510>
    8000320a:	49c020ef          	jal	800056a6 <panic>
    panic("log_write outside of trans");
    8000320e:	00004517          	auipc	a0,0x4
    80003212:	31a50513          	addi	a0,a0,794 # 80007528 <etext+0x528>
    80003216:	490020ef          	jal	800056a6 <panic>
  log.lh.block[i] = b->blockno;
    8000321a:	00878693          	addi	a3,a5,8
    8000321e:	068a                	slli	a3,a3,0x2
    80003220:	00010717          	auipc	a4,0x10
    80003224:	b0070713          	addi	a4,a4,-1280 # 80012d20 <log>
    80003228:	9736                	add	a4,a4,a3
    8000322a:	44d4                	lw	a3,12(s1)
    8000322c:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000322e:	faf60fe3          	beq	a2,a5,800031ec <log_write+0x72>
  }
  release(&log.lock);
    80003232:	00010517          	auipc	a0,0x10
    80003236:	aee50513          	addi	a0,a0,-1298 # 80012d20 <log>
    8000323a:	02f020ef          	jal	80005a68 <release>
}
    8000323e:	60e2                	ld	ra,24(sp)
    80003240:	6442                	ld	s0,16(sp)
    80003242:	64a2                	ld	s1,8(sp)
    80003244:	6902                	ld	s2,0(sp)
    80003246:	6105                	addi	sp,sp,32
    80003248:	8082                	ret

000000008000324a <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000324a:	1101                	addi	sp,sp,-32
    8000324c:	ec06                	sd	ra,24(sp)
    8000324e:	e822                	sd	s0,16(sp)
    80003250:	e426                	sd	s1,8(sp)
    80003252:	e04a                	sd	s2,0(sp)
    80003254:	1000                	addi	s0,sp,32
    80003256:	84aa                	mv	s1,a0
    80003258:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000325a:	00004597          	auipc	a1,0x4
    8000325e:	2ee58593          	addi	a1,a1,750 # 80007548 <etext+0x548>
    80003262:	0521                	addi	a0,a0,8
    80003264:	6ec020ef          	jal	80005950 <initlock>
  lk->name = name;
    80003268:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000326c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003270:	0204a423          	sw	zero,40(s1)
}
    80003274:	60e2                	ld	ra,24(sp)
    80003276:	6442                	ld	s0,16(sp)
    80003278:	64a2                	ld	s1,8(sp)
    8000327a:	6902                	ld	s2,0(sp)
    8000327c:	6105                	addi	sp,sp,32
    8000327e:	8082                	ret

0000000080003280 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003280:	1101                	addi	sp,sp,-32
    80003282:	ec06                	sd	ra,24(sp)
    80003284:	e822                	sd	s0,16(sp)
    80003286:	e426                	sd	s1,8(sp)
    80003288:	e04a                	sd	s2,0(sp)
    8000328a:	1000                	addi	s0,sp,32
    8000328c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000328e:	00850913          	addi	s2,a0,8
    80003292:	854a                	mv	a0,s2
    80003294:	740020ef          	jal	800059d4 <acquire>
  while (lk->locked) {
    80003298:	409c                	lw	a5,0(s1)
    8000329a:	c799                	beqz	a5,800032a8 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    8000329c:	85ca                	mv	a1,s2
    8000329e:	8526                	mv	a0,s1
    800032a0:	886fe0ef          	jal	80001326 <sleep>
  while (lk->locked) {
    800032a4:	409c                	lw	a5,0(s1)
    800032a6:	fbfd                	bnez	a5,8000329c <acquiresleep+0x1c>
  }
  lk->locked = 1;
    800032a8:	4785                	li	a5,1
    800032aa:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800032ac:	ab1fd0ef          	jal	80000d5c <myproc>
    800032b0:	591c                	lw	a5,48(a0)
    800032b2:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800032b4:	854a                	mv	a0,s2
    800032b6:	7b2020ef          	jal	80005a68 <release>
}
    800032ba:	60e2                	ld	ra,24(sp)
    800032bc:	6442                	ld	s0,16(sp)
    800032be:	64a2                	ld	s1,8(sp)
    800032c0:	6902                	ld	s2,0(sp)
    800032c2:	6105                	addi	sp,sp,32
    800032c4:	8082                	ret

00000000800032c6 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800032c6:	1101                	addi	sp,sp,-32
    800032c8:	ec06                	sd	ra,24(sp)
    800032ca:	e822                	sd	s0,16(sp)
    800032cc:	e426                	sd	s1,8(sp)
    800032ce:	e04a                	sd	s2,0(sp)
    800032d0:	1000                	addi	s0,sp,32
    800032d2:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800032d4:	00850913          	addi	s2,a0,8
    800032d8:	854a                	mv	a0,s2
    800032da:	6fa020ef          	jal	800059d4 <acquire>
  lk->locked = 0;
    800032de:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800032e2:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800032e6:	8526                	mv	a0,s1
    800032e8:	88afe0ef          	jal	80001372 <wakeup>
  release(&lk->lk);
    800032ec:	854a                	mv	a0,s2
    800032ee:	77a020ef          	jal	80005a68 <release>
}
    800032f2:	60e2                	ld	ra,24(sp)
    800032f4:	6442                	ld	s0,16(sp)
    800032f6:	64a2                	ld	s1,8(sp)
    800032f8:	6902                	ld	s2,0(sp)
    800032fa:	6105                	addi	sp,sp,32
    800032fc:	8082                	ret

00000000800032fe <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800032fe:	7179                	addi	sp,sp,-48
    80003300:	f406                	sd	ra,40(sp)
    80003302:	f022                	sd	s0,32(sp)
    80003304:	ec26                	sd	s1,24(sp)
    80003306:	e84a                	sd	s2,16(sp)
    80003308:	1800                	addi	s0,sp,48
    8000330a:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000330c:	00850913          	addi	s2,a0,8
    80003310:	854a                	mv	a0,s2
    80003312:	6c2020ef          	jal	800059d4 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003316:	409c                	lw	a5,0(s1)
    80003318:	ef81                	bnez	a5,80003330 <holdingsleep+0x32>
    8000331a:	4481                	li	s1,0
  release(&lk->lk);
    8000331c:	854a                	mv	a0,s2
    8000331e:	74a020ef          	jal	80005a68 <release>
  return r;
}
    80003322:	8526                	mv	a0,s1
    80003324:	70a2                	ld	ra,40(sp)
    80003326:	7402                	ld	s0,32(sp)
    80003328:	64e2                	ld	s1,24(sp)
    8000332a:	6942                	ld	s2,16(sp)
    8000332c:	6145                	addi	sp,sp,48
    8000332e:	8082                	ret
    80003330:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003332:	0284a983          	lw	s3,40(s1)
    80003336:	a27fd0ef          	jal	80000d5c <myproc>
    8000333a:	5904                	lw	s1,48(a0)
    8000333c:	413484b3          	sub	s1,s1,s3
    80003340:	0014b493          	seqz	s1,s1
    80003344:	69a2                	ld	s3,8(sp)
    80003346:	bfd9                	j	8000331c <holdingsleep+0x1e>

0000000080003348 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003348:	1141                	addi	sp,sp,-16
    8000334a:	e406                	sd	ra,8(sp)
    8000334c:	e022                	sd	s0,0(sp)
    8000334e:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003350:	00004597          	auipc	a1,0x4
    80003354:	20858593          	addi	a1,a1,520 # 80007558 <etext+0x558>
    80003358:	00010517          	auipc	a0,0x10
    8000335c:	b1050513          	addi	a0,a0,-1264 # 80012e68 <ftable>
    80003360:	5f0020ef          	jal	80005950 <initlock>
}
    80003364:	60a2                	ld	ra,8(sp)
    80003366:	6402                	ld	s0,0(sp)
    80003368:	0141                	addi	sp,sp,16
    8000336a:	8082                	ret

000000008000336c <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000336c:	1101                	addi	sp,sp,-32
    8000336e:	ec06                	sd	ra,24(sp)
    80003370:	e822                	sd	s0,16(sp)
    80003372:	e426                	sd	s1,8(sp)
    80003374:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003376:	00010517          	auipc	a0,0x10
    8000337a:	af250513          	addi	a0,a0,-1294 # 80012e68 <ftable>
    8000337e:	656020ef          	jal	800059d4 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003382:	00010497          	auipc	s1,0x10
    80003386:	afe48493          	addi	s1,s1,-1282 # 80012e80 <ftable+0x18>
    8000338a:	00011717          	auipc	a4,0x11
    8000338e:	a9670713          	addi	a4,a4,-1386 # 80013e20 <disk>
    if(f->ref == 0){
    80003392:	40dc                	lw	a5,4(s1)
    80003394:	cf89                	beqz	a5,800033ae <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003396:	02848493          	addi	s1,s1,40
    8000339a:	fee49ce3          	bne	s1,a4,80003392 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000339e:	00010517          	auipc	a0,0x10
    800033a2:	aca50513          	addi	a0,a0,-1334 # 80012e68 <ftable>
    800033a6:	6c2020ef          	jal	80005a68 <release>
  return 0;
    800033aa:	4481                	li	s1,0
    800033ac:	a809                	j	800033be <filealloc+0x52>
      f->ref = 1;
    800033ae:	4785                	li	a5,1
    800033b0:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800033b2:	00010517          	auipc	a0,0x10
    800033b6:	ab650513          	addi	a0,a0,-1354 # 80012e68 <ftable>
    800033ba:	6ae020ef          	jal	80005a68 <release>
}
    800033be:	8526                	mv	a0,s1
    800033c0:	60e2                	ld	ra,24(sp)
    800033c2:	6442                	ld	s0,16(sp)
    800033c4:	64a2                	ld	s1,8(sp)
    800033c6:	6105                	addi	sp,sp,32
    800033c8:	8082                	ret

00000000800033ca <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800033ca:	1101                	addi	sp,sp,-32
    800033cc:	ec06                	sd	ra,24(sp)
    800033ce:	e822                	sd	s0,16(sp)
    800033d0:	e426                	sd	s1,8(sp)
    800033d2:	1000                	addi	s0,sp,32
    800033d4:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800033d6:	00010517          	auipc	a0,0x10
    800033da:	a9250513          	addi	a0,a0,-1390 # 80012e68 <ftable>
    800033de:	5f6020ef          	jal	800059d4 <acquire>
  if(f->ref < 1)
    800033e2:	40dc                	lw	a5,4(s1)
    800033e4:	02f05063          	blez	a5,80003404 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    800033e8:	2785                	addiw	a5,a5,1
    800033ea:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800033ec:	00010517          	auipc	a0,0x10
    800033f0:	a7c50513          	addi	a0,a0,-1412 # 80012e68 <ftable>
    800033f4:	674020ef          	jal	80005a68 <release>
  return f;
}
    800033f8:	8526                	mv	a0,s1
    800033fa:	60e2                	ld	ra,24(sp)
    800033fc:	6442                	ld	s0,16(sp)
    800033fe:	64a2                	ld	s1,8(sp)
    80003400:	6105                	addi	sp,sp,32
    80003402:	8082                	ret
    panic("filedup");
    80003404:	00004517          	auipc	a0,0x4
    80003408:	15c50513          	addi	a0,a0,348 # 80007560 <etext+0x560>
    8000340c:	29a020ef          	jal	800056a6 <panic>

0000000080003410 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003410:	7139                	addi	sp,sp,-64
    80003412:	fc06                	sd	ra,56(sp)
    80003414:	f822                	sd	s0,48(sp)
    80003416:	f426                	sd	s1,40(sp)
    80003418:	0080                	addi	s0,sp,64
    8000341a:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    8000341c:	00010517          	auipc	a0,0x10
    80003420:	a4c50513          	addi	a0,a0,-1460 # 80012e68 <ftable>
    80003424:	5b0020ef          	jal	800059d4 <acquire>
  if(f->ref < 1)
    80003428:	40dc                	lw	a5,4(s1)
    8000342a:	04f05863          	blez	a5,8000347a <fileclose+0x6a>
    panic("fileclose");
  if(--f->ref > 0){
    8000342e:	37fd                	addiw	a5,a5,-1
    80003430:	c0dc                	sw	a5,4(s1)
    80003432:	04f04e63          	bgtz	a5,8000348e <fileclose+0x7e>
    80003436:	f04a                	sd	s2,32(sp)
    80003438:	ec4e                	sd	s3,24(sp)
    8000343a:	e852                	sd	s4,16(sp)
    8000343c:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    8000343e:	0004a903          	lw	s2,0(s1)
    80003442:	0094ca83          	lbu	s5,9(s1)
    80003446:	0104ba03          	ld	s4,16(s1)
    8000344a:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    8000344e:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003452:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003456:	00010517          	auipc	a0,0x10
    8000345a:	a1250513          	addi	a0,a0,-1518 # 80012e68 <ftable>
    8000345e:	60a020ef          	jal	80005a68 <release>

  if(ff.type == FD_PIPE){
    80003462:	4785                	li	a5,1
    80003464:	04f90063          	beq	s2,a5,800034a4 <fileclose+0x94>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003468:	3979                	addiw	s2,s2,-2
    8000346a:	4785                	li	a5,1
    8000346c:	0527f563          	bgeu	a5,s2,800034b6 <fileclose+0xa6>
    80003470:	7902                	ld	s2,32(sp)
    80003472:	69e2                	ld	s3,24(sp)
    80003474:	6a42                	ld	s4,16(sp)
    80003476:	6aa2                	ld	s5,8(sp)
    80003478:	a00d                	j	8000349a <fileclose+0x8a>
    8000347a:	f04a                	sd	s2,32(sp)
    8000347c:	ec4e                	sd	s3,24(sp)
    8000347e:	e852                	sd	s4,16(sp)
    80003480:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003482:	00004517          	auipc	a0,0x4
    80003486:	0e650513          	addi	a0,a0,230 # 80007568 <etext+0x568>
    8000348a:	21c020ef          	jal	800056a6 <panic>
    release(&ftable.lock);
    8000348e:	00010517          	auipc	a0,0x10
    80003492:	9da50513          	addi	a0,a0,-1574 # 80012e68 <ftable>
    80003496:	5d2020ef          	jal	80005a68 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    8000349a:	70e2                	ld	ra,56(sp)
    8000349c:	7442                	ld	s0,48(sp)
    8000349e:	74a2                	ld	s1,40(sp)
    800034a0:	6121                	addi	sp,sp,64
    800034a2:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800034a4:	85d6                	mv	a1,s5
    800034a6:	8552                	mv	a0,s4
    800034a8:	340000ef          	jal	800037e8 <pipeclose>
    800034ac:	7902                	ld	s2,32(sp)
    800034ae:	69e2                	ld	s3,24(sp)
    800034b0:	6a42                	ld	s4,16(sp)
    800034b2:	6aa2                	ld	s5,8(sp)
    800034b4:	b7dd                	j	8000349a <fileclose+0x8a>
    begin_op();
    800034b6:	b3bff0ef          	jal	80002ff0 <begin_op>
    iput(ff.ip);
    800034ba:	854e                	mv	a0,s3
    800034bc:	c02ff0ef          	jal	800028be <iput>
    end_op();
    800034c0:	b9bff0ef          	jal	8000305a <end_op>
    800034c4:	7902                	ld	s2,32(sp)
    800034c6:	69e2                	ld	s3,24(sp)
    800034c8:	6a42                	ld	s4,16(sp)
    800034ca:	6aa2                	ld	s5,8(sp)
    800034cc:	b7f9                	j	8000349a <fileclose+0x8a>

00000000800034ce <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800034ce:	715d                	addi	sp,sp,-80
    800034d0:	e486                	sd	ra,72(sp)
    800034d2:	e0a2                	sd	s0,64(sp)
    800034d4:	fc26                	sd	s1,56(sp)
    800034d6:	f44e                	sd	s3,40(sp)
    800034d8:	0880                	addi	s0,sp,80
    800034da:	84aa                	mv	s1,a0
    800034dc:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800034de:	87ffd0ef          	jal	80000d5c <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800034e2:	409c                	lw	a5,0(s1)
    800034e4:	37f9                	addiw	a5,a5,-2
    800034e6:	4705                	li	a4,1
    800034e8:	04f76263          	bltu	a4,a5,8000352c <filestat+0x5e>
    800034ec:	f84a                	sd	s2,48(sp)
    800034ee:	f052                	sd	s4,32(sp)
    800034f0:	892a                	mv	s2,a0
    ilock(f->ip);
    800034f2:	6c88                	ld	a0,24(s1)
    800034f4:	9bcff0ef          	jal	800026b0 <ilock>
    stati(f->ip, &st);
    800034f8:	fb840a13          	addi	s4,s0,-72
    800034fc:	85d2                	mv	a1,s4
    800034fe:	6c88                	ld	a0,24(s1)
    80003500:	c66ff0ef          	jal	80002966 <stati>
    iunlock(f->ip);
    80003504:	6c88                	ld	a0,24(s1)
    80003506:	a58ff0ef          	jal	8000275e <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8000350a:	46e1                	li	a3,24
    8000350c:	8652                	mv	a2,s4
    8000350e:	85ce                	mv	a1,s3
    80003510:	05093503          	ld	a0,80(s2)
    80003514:	cf0fd0ef          	jal	80000a04 <copyout>
    80003518:	41f5551b          	sraiw	a0,a0,0x1f
    8000351c:	7942                	ld	s2,48(sp)
    8000351e:	7a02                	ld	s4,32(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003520:	60a6                	ld	ra,72(sp)
    80003522:	6406                	ld	s0,64(sp)
    80003524:	74e2                	ld	s1,56(sp)
    80003526:	79a2                	ld	s3,40(sp)
    80003528:	6161                	addi	sp,sp,80
    8000352a:	8082                	ret
  return -1;
    8000352c:	557d                	li	a0,-1
    8000352e:	bfcd                	j	80003520 <filestat+0x52>

0000000080003530 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003530:	7179                	addi	sp,sp,-48
    80003532:	f406                	sd	ra,40(sp)
    80003534:	f022                	sd	s0,32(sp)
    80003536:	e84a                	sd	s2,16(sp)
    80003538:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    8000353a:	00854783          	lbu	a5,8(a0)
    8000353e:	cfd1                	beqz	a5,800035da <fileread+0xaa>
    80003540:	ec26                	sd	s1,24(sp)
    80003542:	e44e                	sd	s3,8(sp)
    80003544:	84aa                	mv	s1,a0
    80003546:	89ae                	mv	s3,a1
    80003548:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    8000354a:	411c                	lw	a5,0(a0)
    8000354c:	4705                	li	a4,1
    8000354e:	04e78363          	beq	a5,a4,80003594 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003552:	470d                	li	a4,3
    80003554:	04e78763          	beq	a5,a4,800035a2 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003558:	4709                	li	a4,2
    8000355a:	06e79a63          	bne	a5,a4,800035ce <fileread+0x9e>
    ilock(f->ip);
    8000355e:	6d08                	ld	a0,24(a0)
    80003560:	950ff0ef          	jal	800026b0 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003564:	874a                	mv	a4,s2
    80003566:	5094                	lw	a3,32(s1)
    80003568:	864e                	mv	a2,s3
    8000356a:	4585                	li	a1,1
    8000356c:	6c88                	ld	a0,24(s1)
    8000356e:	c26ff0ef          	jal	80002994 <readi>
    80003572:	892a                	mv	s2,a0
    80003574:	00a05563          	blez	a0,8000357e <fileread+0x4e>
      f->off += r;
    80003578:	509c                	lw	a5,32(s1)
    8000357a:	9fa9                	addw	a5,a5,a0
    8000357c:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    8000357e:	6c88                	ld	a0,24(s1)
    80003580:	9deff0ef          	jal	8000275e <iunlock>
    80003584:	64e2                	ld	s1,24(sp)
    80003586:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003588:	854a                	mv	a0,s2
    8000358a:	70a2                	ld	ra,40(sp)
    8000358c:	7402                	ld	s0,32(sp)
    8000358e:	6942                	ld	s2,16(sp)
    80003590:	6145                	addi	sp,sp,48
    80003592:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003594:	6908                	ld	a0,16(a0)
    80003596:	3a2000ef          	jal	80003938 <piperead>
    8000359a:	892a                	mv	s2,a0
    8000359c:	64e2                	ld	s1,24(sp)
    8000359e:	69a2                	ld	s3,8(sp)
    800035a0:	b7e5                	j	80003588 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800035a2:	02451783          	lh	a5,36(a0)
    800035a6:	03079693          	slli	a3,a5,0x30
    800035aa:	92c1                	srli	a3,a3,0x30
    800035ac:	4725                	li	a4,9
    800035ae:	02d76863          	bltu	a4,a3,800035de <fileread+0xae>
    800035b2:	0792                	slli	a5,a5,0x4
    800035b4:	00010717          	auipc	a4,0x10
    800035b8:	81470713          	addi	a4,a4,-2028 # 80012dc8 <devsw>
    800035bc:	97ba                	add	a5,a5,a4
    800035be:	639c                	ld	a5,0(a5)
    800035c0:	c39d                	beqz	a5,800035e6 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    800035c2:	4505                	li	a0,1
    800035c4:	9782                	jalr	a5
    800035c6:	892a                	mv	s2,a0
    800035c8:	64e2                	ld	s1,24(sp)
    800035ca:	69a2                	ld	s3,8(sp)
    800035cc:	bf75                	j	80003588 <fileread+0x58>
    panic("fileread");
    800035ce:	00004517          	auipc	a0,0x4
    800035d2:	faa50513          	addi	a0,a0,-86 # 80007578 <etext+0x578>
    800035d6:	0d0020ef          	jal	800056a6 <panic>
    return -1;
    800035da:	597d                	li	s2,-1
    800035dc:	b775                	j	80003588 <fileread+0x58>
      return -1;
    800035de:	597d                	li	s2,-1
    800035e0:	64e2                	ld	s1,24(sp)
    800035e2:	69a2                	ld	s3,8(sp)
    800035e4:	b755                	j	80003588 <fileread+0x58>
    800035e6:	597d                	li	s2,-1
    800035e8:	64e2                	ld	s1,24(sp)
    800035ea:	69a2                	ld	s3,8(sp)
    800035ec:	bf71                	j	80003588 <fileread+0x58>

00000000800035ee <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800035ee:	00954783          	lbu	a5,9(a0)
    800035f2:	10078e63          	beqz	a5,8000370e <filewrite+0x120>
{
    800035f6:	711d                	addi	sp,sp,-96
    800035f8:	ec86                	sd	ra,88(sp)
    800035fa:	e8a2                	sd	s0,80(sp)
    800035fc:	e0ca                	sd	s2,64(sp)
    800035fe:	f456                	sd	s5,40(sp)
    80003600:	f05a                	sd	s6,32(sp)
    80003602:	1080                	addi	s0,sp,96
    80003604:	892a                	mv	s2,a0
    80003606:	8b2e                	mv	s6,a1
    80003608:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    8000360a:	411c                	lw	a5,0(a0)
    8000360c:	4705                	li	a4,1
    8000360e:	02e78963          	beq	a5,a4,80003640 <filewrite+0x52>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003612:	470d                	li	a4,3
    80003614:	02e78a63          	beq	a5,a4,80003648 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003618:	4709                	li	a4,2
    8000361a:	0ce79e63          	bne	a5,a4,800036f6 <filewrite+0x108>
    8000361e:	f852                	sd	s4,48(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003620:	0ac05963          	blez	a2,800036d2 <filewrite+0xe4>
    80003624:	e4a6                	sd	s1,72(sp)
    80003626:	fc4e                	sd	s3,56(sp)
    80003628:	ec5e                	sd	s7,24(sp)
    8000362a:	e862                	sd	s8,16(sp)
    8000362c:	e466                	sd	s9,8(sp)
    int i = 0;
    8000362e:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    80003630:	6b85                	lui	s7,0x1
    80003632:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003636:	6c85                	lui	s9,0x1
    80003638:	c00c8c9b          	addiw	s9,s9,-1024 # c00 <_entry-0x7ffff400>
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000363c:	4c05                	li	s8,1
    8000363e:	a8ad                	j	800036b8 <filewrite+0xca>
    ret = pipewrite(f->pipe, addr, n);
    80003640:	6908                	ld	a0,16(a0)
    80003642:	1fe000ef          	jal	80003840 <pipewrite>
    80003646:	a04d                	j	800036e8 <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003648:	02451783          	lh	a5,36(a0)
    8000364c:	03079693          	slli	a3,a5,0x30
    80003650:	92c1                	srli	a3,a3,0x30
    80003652:	4725                	li	a4,9
    80003654:	0ad76f63          	bltu	a4,a3,80003712 <filewrite+0x124>
    80003658:	0792                	slli	a5,a5,0x4
    8000365a:	0000f717          	auipc	a4,0xf
    8000365e:	76e70713          	addi	a4,a4,1902 # 80012dc8 <devsw>
    80003662:	97ba                	add	a5,a5,a4
    80003664:	679c                	ld	a5,8(a5)
    80003666:	cbc5                	beqz	a5,80003716 <filewrite+0x128>
    ret = devsw[f->major].write(1, addr, n);
    80003668:	4505                	li	a0,1
    8000366a:	9782                	jalr	a5
    8000366c:	a8b5                	j	800036e8 <filewrite+0xfa>
      if(n1 > max)
    8000366e:	2981                	sext.w	s3,s3
      begin_op();
    80003670:	981ff0ef          	jal	80002ff0 <begin_op>
      ilock(f->ip);
    80003674:	01893503          	ld	a0,24(s2)
    80003678:	838ff0ef          	jal	800026b0 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000367c:	874e                	mv	a4,s3
    8000367e:	02092683          	lw	a3,32(s2)
    80003682:	016a0633          	add	a2,s4,s6
    80003686:	85e2                	mv	a1,s8
    80003688:	01893503          	ld	a0,24(s2)
    8000368c:	bfaff0ef          	jal	80002a86 <writei>
    80003690:	84aa                	mv	s1,a0
    80003692:	00a05763          	blez	a0,800036a0 <filewrite+0xb2>
        f->off += r;
    80003696:	02092783          	lw	a5,32(s2)
    8000369a:	9fa9                	addw	a5,a5,a0
    8000369c:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800036a0:	01893503          	ld	a0,24(s2)
    800036a4:	8baff0ef          	jal	8000275e <iunlock>
      end_op();
    800036a8:	9b3ff0ef          	jal	8000305a <end_op>

      if(r != n1){
    800036ac:	02999563          	bne	s3,s1,800036d6 <filewrite+0xe8>
        // error from writei
        break;
      }
      i += r;
    800036b0:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    800036b4:	015a5963          	bge	s4,s5,800036c6 <filewrite+0xd8>
      int n1 = n - i;
    800036b8:	414a87bb          	subw	a5,s5,s4
    800036bc:	89be                	mv	s3,a5
      if(n1 > max)
    800036be:	fafbd8e3          	bge	s7,a5,8000366e <filewrite+0x80>
    800036c2:	89e6                	mv	s3,s9
    800036c4:	b76d                	j	8000366e <filewrite+0x80>
    800036c6:	64a6                	ld	s1,72(sp)
    800036c8:	79e2                	ld	s3,56(sp)
    800036ca:	6be2                	ld	s7,24(sp)
    800036cc:	6c42                	ld	s8,16(sp)
    800036ce:	6ca2                	ld	s9,8(sp)
    800036d0:	a801                	j	800036e0 <filewrite+0xf2>
    int i = 0;
    800036d2:	4a01                	li	s4,0
    800036d4:	a031                	j	800036e0 <filewrite+0xf2>
    800036d6:	64a6                	ld	s1,72(sp)
    800036d8:	79e2                	ld	s3,56(sp)
    800036da:	6be2                	ld	s7,24(sp)
    800036dc:	6c42                	ld	s8,16(sp)
    800036de:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    800036e0:	034a9d63          	bne	s5,s4,8000371a <filewrite+0x12c>
    800036e4:	8556                	mv	a0,s5
    800036e6:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    800036e8:	60e6                	ld	ra,88(sp)
    800036ea:	6446                	ld	s0,80(sp)
    800036ec:	6906                	ld	s2,64(sp)
    800036ee:	7aa2                	ld	s5,40(sp)
    800036f0:	7b02                	ld	s6,32(sp)
    800036f2:	6125                	addi	sp,sp,96
    800036f4:	8082                	ret
    800036f6:	e4a6                	sd	s1,72(sp)
    800036f8:	fc4e                	sd	s3,56(sp)
    800036fa:	f852                	sd	s4,48(sp)
    800036fc:	ec5e                	sd	s7,24(sp)
    800036fe:	e862                	sd	s8,16(sp)
    80003700:	e466                	sd	s9,8(sp)
    panic("filewrite");
    80003702:	00004517          	auipc	a0,0x4
    80003706:	e8650513          	addi	a0,a0,-378 # 80007588 <etext+0x588>
    8000370a:	79d010ef          	jal	800056a6 <panic>
    return -1;
    8000370e:	557d                	li	a0,-1
}
    80003710:	8082                	ret
      return -1;
    80003712:	557d                	li	a0,-1
    80003714:	bfd1                	j	800036e8 <filewrite+0xfa>
    80003716:	557d                	li	a0,-1
    80003718:	bfc1                	j	800036e8 <filewrite+0xfa>
    ret = (i == n ? n : -1);
    8000371a:	557d                	li	a0,-1
    8000371c:	7a42                	ld	s4,48(sp)
    8000371e:	b7e9                	j	800036e8 <filewrite+0xfa>

0000000080003720 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003720:	7179                	addi	sp,sp,-48
    80003722:	f406                	sd	ra,40(sp)
    80003724:	f022                	sd	s0,32(sp)
    80003726:	ec26                	sd	s1,24(sp)
    80003728:	e052                	sd	s4,0(sp)
    8000372a:	1800                	addi	s0,sp,48
    8000372c:	84aa                	mv	s1,a0
    8000372e:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003730:	0005b023          	sd	zero,0(a1)
    80003734:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003738:	c35ff0ef          	jal	8000336c <filealloc>
    8000373c:	e088                	sd	a0,0(s1)
    8000373e:	c549                	beqz	a0,800037c8 <pipealloc+0xa8>
    80003740:	c2dff0ef          	jal	8000336c <filealloc>
    80003744:	00aa3023          	sd	a0,0(s4)
    80003748:	cd25                	beqz	a0,800037c0 <pipealloc+0xa0>
    8000374a:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    8000374c:	9b3fc0ef          	jal	800000fe <kalloc>
    80003750:	892a                	mv	s2,a0
    80003752:	c12d                	beqz	a0,800037b4 <pipealloc+0x94>
    80003754:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003756:	4985                	li	s3,1
    80003758:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    8000375c:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003760:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003764:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003768:	00004597          	auipc	a1,0x4
    8000376c:	e3058593          	addi	a1,a1,-464 # 80007598 <etext+0x598>
    80003770:	1e0020ef          	jal	80005950 <initlock>
  (*f0)->type = FD_PIPE;
    80003774:	609c                	ld	a5,0(s1)
    80003776:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000377a:	609c                	ld	a5,0(s1)
    8000377c:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003780:	609c                	ld	a5,0(s1)
    80003782:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003786:	609c                	ld	a5,0(s1)
    80003788:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    8000378c:	000a3783          	ld	a5,0(s4)
    80003790:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003794:	000a3783          	ld	a5,0(s4)
    80003798:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000379c:	000a3783          	ld	a5,0(s4)
    800037a0:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800037a4:	000a3783          	ld	a5,0(s4)
    800037a8:	0127b823          	sd	s2,16(a5)
  return 0;
    800037ac:	4501                	li	a0,0
    800037ae:	6942                	ld	s2,16(sp)
    800037b0:	69a2                	ld	s3,8(sp)
    800037b2:	a01d                	j	800037d8 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800037b4:	6088                	ld	a0,0(s1)
    800037b6:	c119                	beqz	a0,800037bc <pipealloc+0x9c>
    800037b8:	6942                	ld	s2,16(sp)
    800037ba:	a029                	j	800037c4 <pipealloc+0xa4>
    800037bc:	6942                	ld	s2,16(sp)
    800037be:	a029                	j	800037c8 <pipealloc+0xa8>
    800037c0:	6088                	ld	a0,0(s1)
    800037c2:	c10d                	beqz	a0,800037e4 <pipealloc+0xc4>
    fileclose(*f0);
    800037c4:	c4dff0ef          	jal	80003410 <fileclose>
  if(*f1)
    800037c8:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800037cc:	557d                	li	a0,-1
  if(*f1)
    800037ce:	c789                	beqz	a5,800037d8 <pipealloc+0xb8>
    fileclose(*f1);
    800037d0:	853e                	mv	a0,a5
    800037d2:	c3fff0ef          	jal	80003410 <fileclose>
  return -1;
    800037d6:	557d                	li	a0,-1
}
    800037d8:	70a2                	ld	ra,40(sp)
    800037da:	7402                	ld	s0,32(sp)
    800037dc:	64e2                	ld	s1,24(sp)
    800037de:	6a02                	ld	s4,0(sp)
    800037e0:	6145                	addi	sp,sp,48
    800037e2:	8082                	ret
  return -1;
    800037e4:	557d                	li	a0,-1
    800037e6:	bfcd                	j	800037d8 <pipealloc+0xb8>

00000000800037e8 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800037e8:	1101                	addi	sp,sp,-32
    800037ea:	ec06                	sd	ra,24(sp)
    800037ec:	e822                	sd	s0,16(sp)
    800037ee:	e426                	sd	s1,8(sp)
    800037f0:	e04a                	sd	s2,0(sp)
    800037f2:	1000                	addi	s0,sp,32
    800037f4:	84aa                	mv	s1,a0
    800037f6:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800037f8:	1dc020ef          	jal	800059d4 <acquire>
  if(writable){
    800037fc:	02090763          	beqz	s2,8000382a <pipeclose+0x42>
    pi->writeopen = 0;
    80003800:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003804:	21848513          	addi	a0,s1,536
    80003808:	b6bfd0ef          	jal	80001372 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000380c:	2204b783          	ld	a5,544(s1)
    80003810:	e785                	bnez	a5,80003838 <pipeclose+0x50>
    release(&pi->lock);
    80003812:	8526                	mv	a0,s1
    80003814:	254020ef          	jal	80005a68 <release>
    kfree((char*)pi);
    80003818:	8526                	mv	a0,s1
    8000381a:	803fc0ef          	jal	8000001c <kfree>
  } else
    release(&pi->lock);
}
    8000381e:	60e2                	ld	ra,24(sp)
    80003820:	6442                	ld	s0,16(sp)
    80003822:	64a2                	ld	s1,8(sp)
    80003824:	6902                	ld	s2,0(sp)
    80003826:	6105                	addi	sp,sp,32
    80003828:	8082                	ret
    pi->readopen = 0;
    8000382a:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    8000382e:	21c48513          	addi	a0,s1,540
    80003832:	b41fd0ef          	jal	80001372 <wakeup>
    80003836:	bfd9                	j	8000380c <pipeclose+0x24>
    release(&pi->lock);
    80003838:	8526                	mv	a0,s1
    8000383a:	22e020ef          	jal	80005a68 <release>
}
    8000383e:	b7c5                	j	8000381e <pipeclose+0x36>

0000000080003840 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003840:	7159                	addi	sp,sp,-112
    80003842:	f486                	sd	ra,104(sp)
    80003844:	f0a2                	sd	s0,96(sp)
    80003846:	eca6                	sd	s1,88(sp)
    80003848:	e8ca                	sd	s2,80(sp)
    8000384a:	e4ce                	sd	s3,72(sp)
    8000384c:	e0d2                	sd	s4,64(sp)
    8000384e:	fc56                	sd	s5,56(sp)
    80003850:	1880                	addi	s0,sp,112
    80003852:	84aa                	mv	s1,a0
    80003854:	8aae                	mv	s5,a1
    80003856:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003858:	d04fd0ef          	jal	80000d5c <myproc>
    8000385c:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000385e:	8526                	mv	a0,s1
    80003860:	174020ef          	jal	800059d4 <acquire>
  while(i < n){
    80003864:	0d405263          	blez	s4,80003928 <pipewrite+0xe8>
    80003868:	f85a                	sd	s6,48(sp)
    8000386a:	f45e                	sd	s7,40(sp)
    8000386c:	f062                	sd	s8,32(sp)
    8000386e:	ec66                	sd	s9,24(sp)
    80003870:	e86a                	sd	s10,16(sp)
  int i = 0;
    80003872:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003874:	f9f40c13          	addi	s8,s0,-97
    80003878:	4b85                	li	s7,1
    8000387a:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000387c:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003880:	21c48c93          	addi	s9,s1,540
    80003884:	a82d                	j	800038be <pipewrite+0x7e>
      release(&pi->lock);
    80003886:	8526                	mv	a0,s1
    80003888:	1e0020ef          	jal	80005a68 <release>
      return -1;
    8000388c:	597d                	li	s2,-1
    8000388e:	7b42                	ld	s6,48(sp)
    80003890:	7ba2                	ld	s7,40(sp)
    80003892:	7c02                	ld	s8,32(sp)
    80003894:	6ce2                	ld	s9,24(sp)
    80003896:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003898:	854a                	mv	a0,s2
    8000389a:	70a6                	ld	ra,104(sp)
    8000389c:	7406                	ld	s0,96(sp)
    8000389e:	64e6                	ld	s1,88(sp)
    800038a0:	6946                	ld	s2,80(sp)
    800038a2:	69a6                	ld	s3,72(sp)
    800038a4:	6a06                	ld	s4,64(sp)
    800038a6:	7ae2                	ld	s5,56(sp)
    800038a8:	6165                	addi	sp,sp,112
    800038aa:	8082                	ret
      wakeup(&pi->nread);
    800038ac:	856a                	mv	a0,s10
    800038ae:	ac5fd0ef          	jal	80001372 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800038b2:	85a6                	mv	a1,s1
    800038b4:	8566                	mv	a0,s9
    800038b6:	a71fd0ef          	jal	80001326 <sleep>
  while(i < n){
    800038ba:	05495a63          	bge	s2,s4,8000390e <pipewrite+0xce>
    if(pi->readopen == 0 || killed(pr)){
    800038be:	2204a783          	lw	a5,544(s1)
    800038c2:	d3f1                	beqz	a5,80003886 <pipewrite+0x46>
    800038c4:	854e                	mv	a0,s3
    800038c6:	c93fd0ef          	jal	80001558 <killed>
    800038ca:	fd55                	bnez	a0,80003886 <pipewrite+0x46>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800038cc:	2184a783          	lw	a5,536(s1)
    800038d0:	21c4a703          	lw	a4,540(s1)
    800038d4:	2007879b          	addiw	a5,a5,512
    800038d8:	fcf70ae3          	beq	a4,a5,800038ac <pipewrite+0x6c>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800038dc:	86de                	mv	a3,s7
    800038de:	01590633          	add	a2,s2,s5
    800038e2:	85e2                	mv	a1,s8
    800038e4:	0509b503          	ld	a0,80(s3)
    800038e8:	9ccfd0ef          	jal	80000ab4 <copyin>
    800038ec:	05650063          	beq	a0,s6,8000392c <pipewrite+0xec>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800038f0:	21c4a783          	lw	a5,540(s1)
    800038f4:	0017871b          	addiw	a4,a5,1
    800038f8:	20e4ae23          	sw	a4,540(s1)
    800038fc:	1ff7f793          	andi	a5,a5,511
    80003900:	97a6                	add	a5,a5,s1
    80003902:	f9f44703          	lbu	a4,-97(s0)
    80003906:	00e78c23          	sb	a4,24(a5)
      i++;
    8000390a:	2905                	addiw	s2,s2,1
    8000390c:	b77d                	j	800038ba <pipewrite+0x7a>
    8000390e:	7b42                	ld	s6,48(sp)
    80003910:	7ba2                	ld	s7,40(sp)
    80003912:	7c02                	ld	s8,32(sp)
    80003914:	6ce2                	ld	s9,24(sp)
    80003916:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    80003918:	21848513          	addi	a0,s1,536
    8000391c:	a57fd0ef          	jal	80001372 <wakeup>
  release(&pi->lock);
    80003920:	8526                	mv	a0,s1
    80003922:	146020ef          	jal	80005a68 <release>
  return i;
    80003926:	bf8d                	j	80003898 <pipewrite+0x58>
  int i = 0;
    80003928:	4901                	li	s2,0
    8000392a:	b7fd                	j	80003918 <pipewrite+0xd8>
    8000392c:	7b42                	ld	s6,48(sp)
    8000392e:	7ba2                	ld	s7,40(sp)
    80003930:	7c02                	ld	s8,32(sp)
    80003932:	6ce2                	ld	s9,24(sp)
    80003934:	6d42                	ld	s10,16(sp)
    80003936:	b7cd                	j	80003918 <pipewrite+0xd8>

0000000080003938 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003938:	711d                	addi	sp,sp,-96
    8000393a:	ec86                	sd	ra,88(sp)
    8000393c:	e8a2                	sd	s0,80(sp)
    8000393e:	e4a6                	sd	s1,72(sp)
    80003940:	e0ca                	sd	s2,64(sp)
    80003942:	fc4e                	sd	s3,56(sp)
    80003944:	f852                	sd	s4,48(sp)
    80003946:	f456                	sd	s5,40(sp)
    80003948:	1080                	addi	s0,sp,96
    8000394a:	84aa                	mv	s1,a0
    8000394c:	892e                	mv	s2,a1
    8000394e:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003950:	c0cfd0ef          	jal	80000d5c <myproc>
    80003954:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003956:	8526                	mv	a0,s1
    80003958:	07c020ef          	jal	800059d4 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000395c:	2184a703          	lw	a4,536(s1)
    80003960:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003964:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003968:	02f71763          	bne	a4,a5,80003996 <piperead+0x5e>
    8000396c:	2244a783          	lw	a5,548(s1)
    80003970:	cf85                	beqz	a5,800039a8 <piperead+0x70>
    if(killed(pr)){
    80003972:	8552                	mv	a0,s4
    80003974:	be5fd0ef          	jal	80001558 <killed>
    80003978:	e11d                	bnez	a0,8000399e <piperead+0x66>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000397a:	85a6                	mv	a1,s1
    8000397c:	854e                	mv	a0,s3
    8000397e:	9a9fd0ef          	jal	80001326 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003982:	2184a703          	lw	a4,536(s1)
    80003986:	21c4a783          	lw	a5,540(s1)
    8000398a:	fef701e3          	beq	a4,a5,8000396c <piperead+0x34>
    8000398e:	f05a                	sd	s6,32(sp)
    80003990:	ec5e                	sd	s7,24(sp)
    80003992:	e862                	sd	s8,16(sp)
    80003994:	a829                	j	800039ae <piperead+0x76>
    80003996:	f05a                	sd	s6,32(sp)
    80003998:	ec5e                	sd	s7,24(sp)
    8000399a:	e862                	sd	s8,16(sp)
    8000399c:	a809                	j	800039ae <piperead+0x76>
      release(&pi->lock);
    8000399e:	8526                	mv	a0,s1
    800039a0:	0c8020ef          	jal	80005a68 <release>
      return -1;
    800039a4:	59fd                	li	s3,-1
    800039a6:	a0a5                	j	80003a0e <piperead+0xd6>
    800039a8:	f05a                	sd	s6,32(sp)
    800039aa:	ec5e                	sd	s7,24(sp)
    800039ac:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800039ae:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800039b0:	faf40c13          	addi	s8,s0,-81
    800039b4:	4b85                	li	s7,1
    800039b6:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800039b8:	05505163          	blez	s5,800039fa <piperead+0xc2>
    if(pi->nread == pi->nwrite)
    800039bc:	2184a783          	lw	a5,536(s1)
    800039c0:	21c4a703          	lw	a4,540(s1)
    800039c4:	02f70b63          	beq	a4,a5,800039fa <piperead+0xc2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800039c8:	0017871b          	addiw	a4,a5,1
    800039cc:	20e4ac23          	sw	a4,536(s1)
    800039d0:	1ff7f793          	andi	a5,a5,511
    800039d4:	97a6                	add	a5,a5,s1
    800039d6:	0187c783          	lbu	a5,24(a5)
    800039da:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800039de:	86de                	mv	a3,s7
    800039e0:	8662                	mv	a2,s8
    800039e2:	85ca                	mv	a1,s2
    800039e4:	050a3503          	ld	a0,80(s4)
    800039e8:	81cfd0ef          	jal	80000a04 <copyout>
    800039ec:	01650763          	beq	a0,s6,800039fa <piperead+0xc2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800039f0:	2985                	addiw	s3,s3,1
    800039f2:	0905                	addi	s2,s2,1
    800039f4:	fd3a94e3          	bne	s5,s3,800039bc <piperead+0x84>
    800039f8:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800039fa:	21c48513          	addi	a0,s1,540
    800039fe:	975fd0ef          	jal	80001372 <wakeup>
  release(&pi->lock);
    80003a02:	8526                	mv	a0,s1
    80003a04:	064020ef          	jal	80005a68 <release>
    80003a08:	7b02                	ld	s6,32(sp)
    80003a0a:	6be2                	ld	s7,24(sp)
    80003a0c:	6c42                	ld	s8,16(sp)
  return i;
}
    80003a0e:	854e                	mv	a0,s3
    80003a10:	60e6                	ld	ra,88(sp)
    80003a12:	6446                	ld	s0,80(sp)
    80003a14:	64a6                	ld	s1,72(sp)
    80003a16:	6906                	ld	s2,64(sp)
    80003a18:	79e2                	ld	s3,56(sp)
    80003a1a:	7a42                	ld	s4,48(sp)
    80003a1c:	7aa2                	ld	s5,40(sp)
    80003a1e:	6125                	addi	sp,sp,96
    80003a20:	8082                	ret

0000000080003a22 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80003a22:	1141                	addi	sp,sp,-16
    80003a24:	e406                	sd	ra,8(sp)
    80003a26:	e022                	sd	s0,0(sp)
    80003a28:	0800                	addi	s0,sp,16
    80003a2a:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003a2c:	0035151b          	slliw	a0,a0,0x3
    80003a30:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    80003a32:	8b89                	andi	a5,a5,2
    80003a34:	c399                	beqz	a5,80003a3a <flags2perm+0x18>
      perm |= PTE_W;
    80003a36:	00456513          	ori	a0,a0,4
    return perm;
}
    80003a3a:	60a2                	ld	ra,8(sp)
    80003a3c:	6402                	ld	s0,0(sp)
    80003a3e:	0141                	addi	sp,sp,16
    80003a40:	8082                	ret

0000000080003a42 <exec>:

int
exec(char *path, char **argv)
{
    80003a42:	de010113          	addi	sp,sp,-544
    80003a46:	20113c23          	sd	ra,536(sp)
    80003a4a:	20813823          	sd	s0,528(sp)
    80003a4e:	20913423          	sd	s1,520(sp)
    80003a52:	21213023          	sd	s2,512(sp)
    80003a56:	1400                	addi	s0,sp,544
    80003a58:	892a                	mv	s2,a0
    80003a5a:	dea43823          	sd	a0,-528(s0)
    80003a5e:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003a62:	afafd0ef          	jal	80000d5c <myproc>
    80003a66:	84aa                	mv	s1,a0

  begin_op();
    80003a68:	d88ff0ef          	jal	80002ff0 <begin_op>

  if((ip = namei(path)) == 0){
    80003a6c:	854a                	mv	a0,s2
    80003a6e:	bc0ff0ef          	jal	80002e2e <namei>
    80003a72:	cd21                	beqz	a0,80003aca <exec+0x88>
    80003a74:	fbd2                	sd	s4,496(sp)
    80003a76:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003a78:	c39fe0ef          	jal	800026b0 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003a7c:	04000713          	li	a4,64
    80003a80:	4681                	li	a3,0
    80003a82:	e5040613          	addi	a2,s0,-432
    80003a86:	4581                	li	a1,0
    80003a88:	8552                	mv	a0,s4
    80003a8a:	f0bfe0ef          	jal	80002994 <readi>
    80003a8e:	04000793          	li	a5,64
    80003a92:	00f51a63          	bne	a0,a5,80003aa6 <exec+0x64>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80003a96:	e5042703          	lw	a4,-432(s0)
    80003a9a:	464c47b7          	lui	a5,0x464c4
    80003a9e:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003aa2:	02f70863          	beq	a4,a5,80003ad2 <exec+0x90>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003aa6:	8552                	mv	a0,s4
    80003aa8:	e9ffe0ef          	jal	80002946 <iunlockput>
    end_op();
    80003aac:	daeff0ef          	jal	8000305a <end_op>
  }
  return -1;
    80003ab0:	557d                	li	a0,-1
    80003ab2:	7a5e                	ld	s4,496(sp)
}
    80003ab4:	21813083          	ld	ra,536(sp)
    80003ab8:	21013403          	ld	s0,528(sp)
    80003abc:	20813483          	ld	s1,520(sp)
    80003ac0:	20013903          	ld	s2,512(sp)
    80003ac4:	22010113          	addi	sp,sp,544
    80003ac8:	8082                	ret
    end_op();
    80003aca:	d90ff0ef          	jal	8000305a <end_op>
    return -1;
    80003ace:	557d                	li	a0,-1
    80003ad0:	b7d5                	j	80003ab4 <exec+0x72>
    80003ad2:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003ad4:	8526                	mv	a0,s1
    80003ad6:	b2efd0ef          	jal	80000e04 <proc_pagetable>
    80003ada:	8b2a                	mv	s6,a0
    80003adc:	26050d63          	beqz	a0,80003d56 <exec+0x314>
    80003ae0:	ffce                	sd	s3,504(sp)
    80003ae2:	f7d6                	sd	s5,488(sp)
    80003ae4:	efde                	sd	s7,472(sp)
    80003ae6:	ebe2                	sd	s8,464(sp)
    80003ae8:	e7e6                	sd	s9,456(sp)
    80003aea:	e3ea                	sd	s10,448(sp)
    80003aec:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003aee:	e7042683          	lw	a3,-400(s0)
    80003af2:	e8845783          	lhu	a5,-376(s0)
    80003af6:	0e078763          	beqz	a5,80003be4 <exec+0x1a2>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003afa:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003afc:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003afe:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    80003b02:	6c85                	lui	s9,0x1
    80003b04:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80003b08:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80003b0c:	6a85                	lui	s5,0x1
    80003b0e:	a085                	j	80003b6e <exec+0x12c>
      panic("loadseg: address should exist");
    80003b10:	00004517          	auipc	a0,0x4
    80003b14:	a9050513          	addi	a0,a0,-1392 # 800075a0 <etext+0x5a0>
    80003b18:	38f010ef          	jal	800056a6 <panic>
    if(sz - i < PGSIZE)
    80003b1c:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003b1e:	874a                	mv	a4,s2
    80003b20:	009c06bb          	addw	a3,s8,s1
    80003b24:	4581                	li	a1,0
    80003b26:	8552                	mv	a0,s4
    80003b28:	e6dfe0ef          	jal	80002994 <readi>
    80003b2c:	22a91963          	bne	s2,a0,80003d5e <exec+0x31c>
  for(i = 0; i < sz; i += PGSIZE){
    80003b30:	009a84bb          	addw	s1,s5,s1
    80003b34:	0334f263          	bgeu	s1,s3,80003b58 <exec+0x116>
    pa = walkaddr(pagetable, va + i);
    80003b38:	02049593          	slli	a1,s1,0x20
    80003b3c:	9181                	srli	a1,a1,0x20
    80003b3e:	95de                	add	a1,a1,s7
    80003b40:	855a                	mv	a0,s6
    80003b42:	93bfc0ef          	jal	8000047c <walkaddr>
    80003b46:	862a                	mv	a2,a0
    if(pa == 0)
    80003b48:	d561                	beqz	a0,80003b10 <exec+0xce>
    if(sz - i < PGSIZE)
    80003b4a:	409987bb          	subw	a5,s3,s1
    80003b4e:	893e                	mv	s2,a5
    80003b50:	fcfcf6e3          	bgeu	s9,a5,80003b1c <exec+0xda>
    80003b54:	8956                	mv	s2,s5
    80003b56:	b7d9                	j	80003b1c <exec+0xda>
    sz = sz1;
    80003b58:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003b5c:	2d05                	addiw	s10,s10,1
    80003b5e:	e0843783          	ld	a5,-504(s0)
    80003b62:	0387869b          	addiw	a3,a5,56
    80003b66:	e8845783          	lhu	a5,-376(s0)
    80003b6a:	06fd5e63          	bge	s10,a5,80003be6 <exec+0x1a4>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003b6e:	e0d43423          	sd	a3,-504(s0)
    80003b72:	876e                	mv	a4,s11
    80003b74:	e1840613          	addi	a2,s0,-488
    80003b78:	4581                	li	a1,0
    80003b7a:	8552                	mv	a0,s4
    80003b7c:	e19fe0ef          	jal	80002994 <readi>
    80003b80:	1db51d63          	bne	a0,s11,80003d5a <exec+0x318>
    if(ph.type != ELF_PROG_LOAD)
    80003b84:	e1842783          	lw	a5,-488(s0)
    80003b88:	4705                	li	a4,1
    80003b8a:	fce799e3          	bne	a5,a4,80003b5c <exec+0x11a>
    if(ph.memsz < ph.filesz)
    80003b8e:	e4043483          	ld	s1,-448(s0)
    80003b92:	e3843783          	ld	a5,-456(s0)
    80003b96:	1ef4e263          	bltu	s1,a5,80003d7a <exec+0x338>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003b9a:	e2843783          	ld	a5,-472(s0)
    80003b9e:	94be                	add	s1,s1,a5
    80003ba0:	1ef4e063          	bltu	s1,a5,80003d80 <exec+0x33e>
    if(ph.vaddr % PGSIZE != 0)
    80003ba4:	de843703          	ld	a4,-536(s0)
    80003ba8:	8ff9                	and	a5,a5,a4
    80003baa:	1c079e63          	bnez	a5,80003d86 <exec+0x344>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003bae:	e1c42503          	lw	a0,-484(s0)
    80003bb2:	e71ff0ef          	jal	80003a22 <flags2perm>
    80003bb6:	86aa                	mv	a3,a0
    80003bb8:	8626                	mv	a2,s1
    80003bba:	85ca                	mv	a1,s2
    80003bbc:	855a                	mv	a0,s6
    80003bbe:	c27fc0ef          	jal	800007e4 <uvmalloc>
    80003bc2:	dea43c23          	sd	a0,-520(s0)
    80003bc6:	1c050363          	beqz	a0,80003d8c <exec+0x34a>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003bca:	e2843b83          	ld	s7,-472(s0)
    80003bce:	e2042c03          	lw	s8,-480(s0)
    80003bd2:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003bd6:	00098463          	beqz	s3,80003bde <exec+0x19c>
    80003bda:	4481                	li	s1,0
    80003bdc:	bfb1                	j	80003b38 <exec+0xf6>
    sz = sz1;
    80003bde:	df843903          	ld	s2,-520(s0)
    80003be2:	bfad                	j	80003b5c <exec+0x11a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003be4:	4901                	li	s2,0
  iunlockput(ip);
    80003be6:	8552                	mv	a0,s4
    80003be8:	d5ffe0ef          	jal	80002946 <iunlockput>
  end_op();
    80003bec:	c6eff0ef          	jal	8000305a <end_op>
  p = myproc();
    80003bf0:	96cfd0ef          	jal	80000d5c <myproc>
    80003bf4:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003bf6:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80003bfa:	6985                	lui	s3,0x1
    80003bfc:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003bfe:	99ca                	add	s3,s3,s2
    80003c00:	77fd                	lui	a5,0xfffff
    80003c02:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003c06:	4691                	li	a3,4
    80003c08:	6609                	lui	a2,0x2
    80003c0a:	964e                	add	a2,a2,s3
    80003c0c:	85ce                	mv	a1,s3
    80003c0e:	855a                	mv	a0,s6
    80003c10:	bd5fc0ef          	jal	800007e4 <uvmalloc>
    80003c14:	8a2a                	mv	s4,a0
    80003c16:	e105                	bnez	a0,80003c36 <exec+0x1f4>
    proc_freepagetable(pagetable, sz);
    80003c18:	85ce                	mv	a1,s3
    80003c1a:	855a                	mv	a0,s6
    80003c1c:	a6cfd0ef          	jal	80000e88 <proc_freepagetable>
  return -1;
    80003c20:	557d                	li	a0,-1
    80003c22:	79fe                	ld	s3,504(sp)
    80003c24:	7a5e                	ld	s4,496(sp)
    80003c26:	7abe                	ld	s5,488(sp)
    80003c28:	7b1e                	ld	s6,480(sp)
    80003c2a:	6bfe                	ld	s7,472(sp)
    80003c2c:	6c5e                	ld	s8,464(sp)
    80003c2e:	6cbe                	ld	s9,456(sp)
    80003c30:	6d1e                	ld	s10,448(sp)
    80003c32:	7dfa                	ld	s11,440(sp)
    80003c34:	b541                	j	80003ab4 <exec+0x72>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003c36:	75f9                	lui	a1,0xffffe
    80003c38:	95aa                	add	a1,a1,a0
    80003c3a:	855a                	mv	a0,s6
    80003c3c:	d9ffc0ef          	jal	800009da <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003c40:	7bfd                	lui	s7,0xfffff
    80003c42:	9bd2                	add	s7,s7,s4
  for(argc = 0; argv[argc]; argc++) {
    80003c44:	e0043783          	ld	a5,-512(s0)
    80003c48:	6388                	ld	a0,0(a5)
  sp = sz;
    80003c4a:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    80003c4c:	4481                	li	s1,0
    ustack[argc] = sp;
    80003c4e:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    80003c52:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    80003c56:	cd21                	beqz	a0,80003cae <exec+0x26c>
    sp -= strlen(argv[argc]) + 1;
    80003c58:	e7efc0ef          	jal	800002d6 <strlen>
    80003c5c:	0015079b          	addiw	a5,a0,1
    80003c60:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003c64:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003c68:	13796563          	bltu	s2,s7,80003d92 <exec+0x350>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003c6c:	e0043d83          	ld	s11,-512(s0)
    80003c70:	000db983          	ld	s3,0(s11)
    80003c74:	854e                	mv	a0,s3
    80003c76:	e60fc0ef          	jal	800002d6 <strlen>
    80003c7a:	0015069b          	addiw	a3,a0,1
    80003c7e:	864e                	mv	a2,s3
    80003c80:	85ca                	mv	a1,s2
    80003c82:	855a                	mv	a0,s6
    80003c84:	d81fc0ef          	jal	80000a04 <copyout>
    80003c88:	10054763          	bltz	a0,80003d96 <exec+0x354>
    ustack[argc] = sp;
    80003c8c:	00349793          	slli	a5,s1,0x3
    80003c90:	97e6                	add	a5,a5,s9
    80003c92:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffe2fa0>
  for(argc = 0; argv[argc]; argc++) {
    80003c96:	0485                	addi	s1,s1,1
    80003c98:	008d8793          	addi	a5,s11,8
    80003c9c:	e0f43023          	sd	a5,-512(s0)
    80003ca0:	008db503          	ld	a0,8(s11)
    80003ca4:	c509                	beqz	a0,80003cae <exec+0x26c>
    if(argc >= MAXARG)
    80003ca6:	fb8499e3          	bne	s1,s8,80003c58 <exec+0x216>
  sz = sz1;
    80003caa:	89d2                	mv	s3,s4
    80003cac:	b7b5                	j	80003c18 <exec+0x1d6>
  ustack[argc] = 0;
    80003cae:	00349793          	slli	a5,s1,0x3
    80003cb2:	f9078793          	addi	a5,a5,-112
    80003cb6:	97a2                	add	a5,a5,s0
    80003cb8:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003cbc:	00148693          	addi	a3,s1,1
    80003cc0:	068e                	slli	a3,a3,0x3
    80003cc2:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003cc6:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80003cca:	89d2                	mv	s3,s4
  if(sp < stackbase)
    80003ccc:	f57966e3          	bltu	s2,s7,80003c18 <exec+0x1d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003cd0:	e9040613          	addi	a2,s0,-368
    80003cd4:	85ca                	mv	a1,s2
    80003cd6:	855a                	mv	a0,s6
    80003cd8:	d2dfc0ef          	jal	80000a04 <copyout>
    80003cdc:	f2054ee3          	bltz	a0,80003c18 <exec+0x1d6>
  p->trapframe->a1 = sp;
    80003ce0:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80003ce4:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003ce8:	df043783          	ld	a5,-528(s0)
    80003cec:	0007c703          	lbu	a4,0(a5)
    80003cf0:	cf11                	beqz	a4,80003d0c <exec+0x2ca>
    80003cf2:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003cf4:	02f00693          	li	a3,47
    80003cf8:	a029                	j	80003d02 <exec+0x2c0>
  for(last=s=path; *s; s++)
    80003cfa:	0785                	addi	a5,a5,1
    80003cfc:	fff7c703          	lbu	a4,-1(a5)
    80003d00:	c711                	beqz	a4,80003d0c <exec+0x2ca>
    if(*s == '/')
    80003d02:	fed71ce3          	bne	a4,a3,80003cfa <exec+0x2b8>
      last = s+1;
    80003d06:	def43823          	sd	a5,-528(s0)
    80003d0a:	bfc5                	j	80003cfa <exec+0x2b8>
  safestrcpy(p->name, last, sizeof(p->name));
    80003d0c:	4641                	li	a2,16
    80003d0e:	df043583          	ld	a1,-528(s0)
    80003d12:	158a8513          	addi	a0,s5,344
    80003d16:	d8afc0ef          	jal	800002a0 <safestrcpy>
  oldpagetable = p->pagetable;
    80003d1a:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80003d1e:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80003d22:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80003d26:	058ab783          	ld	a5,88(s5)
    80003d2a:	e6843703          	ld	a4,-408(s0)
    80003d2e:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003d30:	058ab783          	ld	a5,88(s5)
    80003d34:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003d38:	85ea                	mv	a1,s10
    80003d3a:	94efd0ef          	jal	80000e88 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003d3e:	0004851b          	sext.w	a0,s1
    80003d42:	79fe                	ld	s3,504(sp)
    80003d44:	7a5e                	ld	s4,496(sp)
    80003d46:	7abe                	ld	s5,488(sp)
    80003d48:	7b1e                	ld	s6,480(sp)
    80003d4a:	6bfe                	ld	s7,472(sp)
    80003d4c:	6c5e                	ld	s8,464(sp)
    80003d4e:	6cbe                	ld	s9,456(sp)
    80003d50:	6d1e                	ld	s10,448(sp)
    80003d52:	7dfa                	ld	s11,440(sp)
    80003d54:	b385                	j	80003ab4 <exec+0x72>
    80003d56:	7b1e                	ld	s6,480(sp)
    80003d58:	b3b9                	j	80003aa6 <exec+0x64>
    80003d5a:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80003d5e:	df843583          	ld	a1,-520(s0)
    80003d62:	855a                	mv	a0,s6
    80003d64:	924fd0ef          	jal	80000e88 <proc_freepagetable>
  if(ip){
    80003d68:	79fe                	ld	s3,504(sp)
    80003d6a:	7abe                	ld	s5,488(sp)
    80003d6c:	7b1e                	ld	s6,480(sp)
    80003d6e:	6bfe                	ld	s7,472(sp)
    80003d70:	6c5e                	ld	s8,464(sp)
    80003d72:	6cbe                	ld	s9,456(sp)
    80003d74:	6d1e                	ld	s10,448(sp)
    80003d76:	7dfa                	ld	s11,440(sp)
    80003d78:	b33d                	j	80003aa6 <exec+0x64>
    80003d7a:	df243c23          	sd	s2,-520(s0)
    80003d7e:	b7c5                	j	80003d5e <exec+0x31c>
    80003d80:	df243c23          	sd	s2,-520(s0)
    80003d84:	bfe9                	j	80003d5e <exec+0x31c>
    80003d86:	df243c23          	sd	s2,-520(s0)
    80003d8a:	bfd1                	j	80003d5e <exec+0x31c>
    80003d8c:	df243c23          	sd	s2,-520(s0)
    80003d90:	b7f9                	j	80003d5e <exec+0x31c>
  sz = sz1;
    80003d92:	89d2                	mv	s3,s4
    80003d94:	b551                	j	80003c18 <exec+0x1d6>
    80003d96:	89d2                	mv	s3,s4
    80003d98:	b541                	j	80003c18 <exec+0x1d6>

0000000080003d9a <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003d9a:	7179                	addi	sp,sp,-48
    80003d9c:	f406                	sd	ra,40(sp)
    80003d9e:	f022                	sd	s0,32(sp)
    80003da0:	ec26                	sd	s1,24(sp)
    80003da2:	e84a                	sd	s2,16(sp)
    80003da4:	1800                	addi	s0,sp,48
    80003da6:	892e                	mv	s2,a1
    80003da8:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003daa:	fdc40593          	addi	a1,s0,-36
    80003dae:	e57fd0ef          	jal	80001c04 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003db2:	fdc42703          	lw	a4,-36(s0)
    80003db6:	47bd                	li	a5,15
    80003db8:	02e7e963          	bltu	a5,a4,80003dea <argfd+0x50>
    80003dbc:	fa1fc0ef          	jal	80000d5c <myproc>
    80003dc0:	fdc42703          	lw	a4,-36(s0)
    80003dc4:	01a70793          	addi	a5,a4,26
    80003dc8:	078e                	slli	a5,a5,0x3
    80003dca:	953e                	add	a0,a0,a5
    80003dcc:	611c                	ld	a5,0(a0)
    80003dce:	c385                	beqz	a5,80003dee <argfd+0x54>
    return -1;
  if(pfd)
    80003dd0:	00090463          	beqz	s2,80003dd8 <argfd+0x3e>
    *pfd = fd;
    80003dd4:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80003dd8:	4501                	li	a0,0
  if(pf)
    80003dda:	c091                	beqz	s1,80003dde <argfd+0x44>
    *pf = f;
    80003ddc:	e09c                	sd	a5,0(s1)
}
    80003dde:	70a2                	ld	ra,40(sp)
    80003de0:	7402                	ld	s0,32(sp)
    80003de2:	64e2                	ld	s1,24(sp)
    80003de4:	6942                	ld	s2,16(sp)
    80003de6:	6145                	addi	sp,sp,48
    80003de8:	8082                	ret
    return -1;
    80003dea:	557d                	li	a0,-1
    80003dec:	bfcd                	j	80003dde <argfd+0x44>
    80003dee:	557d                	li	a0,-1
    80003df0:	b7fd                	j	80003dde <argfd+0x44>

0000000080003df2 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003df2:	1101                	addi	sp,sp,-32
    80003df4:	ec06                	sd	ra,24(sp)
    80003df6:	e822                	sd	s0,16(sp)
    80003df8:	e426                	sd	s1,8(sp)
    80003dfa:	1000                	addi	s0,sp,32
    80003dfc:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003dfe:	f5ffc0ef          	jal	80000d5c <myproc>
    80003e02:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80003e04:	0d050793          	addi	a5,a0,208
    80003e08:	4501                	li	a0,0
    80003e0a:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80003e0c:	6398                	ld	a4,0(a5)
    80003e0e:	cb19                	beqz	a4,80003e24 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80003e10:	2505                	addiw	a0,a0,1
    80003e12:	07a1                	addi	a5,a5,8
    80003e14:	fed51ce3          	bne	a0,a3,80003e0c <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80003e18:	557d                	li	a0,-1
}
    80003e1a:	60e2                	ld	ra,24(sp)
    80003e1c:	6442                	ld	s0,16(sp)
    80003e1e:	64a2                	ld	s1,8(sp)
    80003e20:	6105                	addi	sp,sp,32
    80003e22:	8082                	ret
      p->ofile[fd] = f;
    80003e24:	01a50793          	addi	a5,a0,26
    80003e28:	078e                	slli	a5,a5,0x3
    80003e2a:	963e                	add	a2,a2,a5
    80003e2c:	e204                	sd	s1,0(a2)
      return fd;
    80003e2e:	b7f5                	j	80003e1a <fdalloc+0x28>

0000000080003e30 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80003e30:	715d                	addi	sp,sp,-80
    80003e32:	e486                	sd	ra,72(sp)
    80003e34:	e0a2                	sd	s0,64(sp)
    80003e36:	fc26                	sd	s1,56(sp)
    80003e38:	f84a                	sd	s2,48(sp)
    80003e3a:	f44e                	sd	s3,40(sp)
    80003e3c:	ec56                	sd	s5,24(sp)
    80003e3e:	e85a                	sd	s6,16(sp)
    80003e40:	0880                	addi	s0,sp,80
    80003e42:	8b2e                	mv	s6,a1
    80003e44:	89b2                	mv	s3,a2
    80003e46:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80003e48:	fb040593          	addi	a1,s0,-80
    80003e4c:	ffdfe0ef          	jal	80002e48 <nameiparent>
    80003e50:	84aa                	mv	s1,a0
    80003e52:	10050d63          	beqz	a0,80003f6c <create+0x13c>
    return 0;

  ilock(dp);
    80003e56:	85bfe0ef          	jal	800026b0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80003e5a:	4601                	li	a2,0
    80003e5c:	fb040593          	addi	a1,s0,-80
    80003e60:	8526                	mv	a0,s1
    80003e62:	d41fe0ef          	jal	80002ba2 <dirlookup>
    80003e66:	8aaa                	mv	s5,a0
    80003e68:	c521                	beqz	a0,80003eb0 <create+0x80>
    iunlockput(dp);
    80003e6a:	8526                	mv	a0,s1
    80003e6c:	adbfe0ef          	jal	80002946 <iunlockput>
    ilock(ip);
    80003e70:	8556                	mv	a0,s5
    80003e72:	83ffe0ef          	jal	800026b0 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80003e76:	4789                	li	a5,2
    80003e78:	00fb0f63          	beq	s6,a5,80003e96 <create+0x66>
      return ip;
    if(type == T_SYMLINK){
    80003e7c:	4791                	li	a5,4
    80003e7e:	02fb1463          	bne	s6,a5,80003ea6 <create+0x76>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80003e82:	8556                	mv	a0,s5
    80003e84:	60a6                	ld	ra,72(sp)
    80003e86:	6406                	ld	s0,64(sp)
    80003e88:	74e2                	ld	s1,56(sp)
    80003e8a:	7942                	ld	s2,48(sp)
    80003e8c:	79a2                	ld	s3,40(sp)
    80003e8e:	6ae2                	ld	s5,24(sp)
    80003e90:	6b42                	ld	s6,16(sp)
    80003e92:	6161                	addi	sp,sp,80
    80003e94:	8082                	ret
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80003e96:	044ad783          	lhu	a5,68(s5)
    80003e9a:	37f9                	addiw	a5,a5,-2
    80003e9c:	17c2                	slli	a5,a5,0x30
    80003e9e:	93c1                	srli	a5,a5,0x30
    80003ea0:	4705                	li	a4,1
    80003ea2:	fef770e3          	bgeu	a4,a5,80003e82 <create+0x52>
    iunlockput(ip);
    80003ea6:	8556                	mv	a0,s5
    80003ea8:	a9ffe0ef          	jal	80002946 <iunlockput>
    return 0;
    80003eac:	4a81                	li	s5,0
    80003eae:	bfd1                	j	80003e82 <create+0x52>
    80003eb0:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    80003eb2:	85da                	mv	a1,s6
    80003eb4:	4088                	lw	a0,0(s1)
    80003eb6:	e8afe0ef          	jal	80002540 <ialloc>
    80003eba:	8a2a                	mv	s4,a0
    80003ebc:	cd15                	beqz	a0,80003ef8 <create+0xc8>
  ilock(ip);
    80003ebe:	ff2fe0ef          	jal	800026b0 <ilock>
  ip->major = major;
    80003ec2:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    80003ec6:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    80003eca:	4905                	li	s2,1
    80003ecc:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    80003ed0:	8552                	mv	a0,s4
    80003ed2:	f2afe0ef          	jal	800025fc <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80003ed6:	032b0763          	beq	s6,s2,80003f04 <create+0xd4>
  if(dirlink(dp, name, ip->inum) < 0)
    80003eda:	004a2603          	lw	a2,4(s4)
    80003ede:	fb040593          	addi	a1,s0,-80
    80003ee2:	8526                	mv	a0,s1
    80003ee4:	ea1fe0ef          	jal	80002d84 <dirlink>
    80003ee8:	06054563          	bltz	a0,80003f52 <create+0x122>
  iunlockput(dp);
    80003eec:	8526                	mv	a0,s1
    80003eee:	a59fe0ef          	jal	80002946 <iunlockput>
  return ip;
    80003ef2:	8ad2                	mv	s5,s4
    80003ef4:	7a02                	ld	s4,32(sp)
    80003ef6:	b771                	j	80003e82 <create+0x52>
    iunlockput(dp);
    80003ef8:	8526                	mv	a0,s1
    80003efa:	a4dfe0ef          	jal	80002946 <iunlockput>
    return 0;
    80003efe:	8ad2                	mv	s5,s4
    80003f00:	7a02                	ld	s4,32(sp)
    80003f02:	b741                	j	80003e82 <create+0x52>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80003f04:	004a2603          	lw	a2,4(s4)
    80003f08:	00003597          	auipc	a1,0x3
    80003f0c:	6b858593          	addi	a1,a1,1720 # 800075c0 <etext+0x5c0>
    80003f10:	8552                	mv	a0,s4
    80003f12:	e73fe0ef          	jal	80002d84 <dirlink>
    80003f16:	02054e63          	bltz	a0,80003f52 <create+0x122>
    80003f1a:	40d0                	lw	a2,4(s1)
    80003f1c:	00003597          	auipc	a1,0x3
    80003f20:	6ac58593          	addi	a1,a1,1708 # 800075c8 <etext+0x5c8>
    80003f24:	8552                	mv	a0,s4
    80003f26:	e5ffe0ef          	jal	80002d84 <dirlink>
    80003f2a:	02054463          	bltz	a0,80003f52 <create+0x122>
  if(dirlink(dp, name, ip->inum) < 0)
    80003f2e:	004a2603          	lw	a2,4(s4)
    80003f32:	fb040593          	addi	a1,s0,-80
    80003f36:	8526                	mv	a0,s1
    80003f38:	e4dfe0ef          	jal	80002d84 <dirlink>
    80003f3c:	00054b63          	bltz	a0,80003f52 <create+0x122>
    dp->nlink++;  // for ".."
    80003f40:	04a4d783          	lhu	a5,74(s1)
    80003f44:	2785                	addiw	a5,a5,1
    80003f46:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80003f4a:	8526                	mv	a0,s1
    80003f4c:	eb0fe0ef          	jal	800025fc <iupdate>
    80003f50:	bf71                	j	80003eec <create+0xbc>
  ip->nlink = 0;
    80003f52:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80003f56:	8552                	mv	a0,s4
    80003f58:	ea4fe0ef          	jal	800025fc <iupdate>
  iunlockput(ip);
    80003f5c:	8552                	mv	a0,s4
    80003f5e:	9e9fe0ef          	jal	80002946 <iunlockput>
  iunlockput(dp);
    80003f62:	8526                	mv	a0,s1
    80003f64:	9e3fe0ef          	jal	80002946 <iunlockput>
  return 0;
    80003f68:	7a02                	ld	s4,32(sp)
    80003f6a:	bf21                	j	80003e82 <create+0x52>
    return 0;
    80003f6c:	8aaa                	mv	s5,a0
    80003f6e:	bf11                	j	80003e82 <create+0x52>

0000000080003f70 <sys_dup>:
{
    80003f70:	7179                	addi	sp,sp,-48
    80003f72:	f406                	sd	ra,40(sp)
    80003f74:	f022                	sd	s0,32(sp)
    80003f76:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80003f78:	fd840613          	addi	a2,s0,-40
    80003f7c:	4581                	li	a1,0
    80003f7e:	4501                	li	a0,0
    80003f80:	e1bff0ef          	jal	80003d9a <argfd>
    return -1;
    80003f84:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80003f86:	02054363          	bltz	a0,80003fac <sys_dup+0x3c>
    80003f8a:	ec26                	sd	s1,24(sp)
    80003f8c:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80003f8e:	fd843903          	ld	s2,-40(s0)
    80003f92:	854a                	mv	a0,s2
    80003f94:	e5fff0ef          	jal	80003df2 <fdalloc>
    80003f98:	84aa                	mv	s1,a0
    return -1;
    80003f9a:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80003f9c:	00054d63          	bltz	a0,80003fb6 <sys_dup+0x46>
  filedup(f);
    80003fa0:	854a                	mv	a0,s2
    80003fa2:	c28ff0ef          	jal	800033ca <filedup>
  return fd;
    80003fa6:	87a6                	mv	a5,s1
    80003fa8:	64e2                	ld	s1,24(sp)
    80003faa:	6942                	ld	s2,16(sp)
}
    80003fac:	853e                	mv	a0,a5
    80003fae:	70a2                	ld	ra,40(sp)
    80003fb0:	7402                	ld	s0,32(sp)
    80003fb2:	6145                	addi	sp,sp,48
    80003fb4:	8082                	ret
    80003fb6:	64e2                	ld	s1,24(sp)
    80003fb8:	6942                	ld	s2,16(sp)
    80003fba:	bfcd                	j	80003fac <sys_dup+0x3c>

0000000080003fbc <sys_read>:
{
    80003fbc:	7179                	addi	sp,sp,-48
    80003fbe:	f406                	sd	ra,40(sp)
    80003fc0:	f022                	sd	s0,32(sp)
    80003fc2:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80003fc4:	fd840593          	addi	a1,s0,-40
    80003fc8:	4505                	li	a0,1
    80003fca:	c57fd0ef          	jal	80001c20 <argaddr>
  argint(2, &n);
    80003fce:	fe440593          	addi	a1,s0,-28
    80003fd2:	4509                	li	a0,2
    80003fd4:	c31fd0ef          	jal	80001c04 <argint>
  if(argfd(0, 0, &f) < 0)
    80003fd8:	fe840613          	addi	a2,s0,-24
    80003fdc:	4581                	li	a1,0
    80003fde:	4501                	li	a0,0
    80003fe0:	dbbff0ef          	jal	80003d9a <argfd>
    80003fe4:	87aa                	mv	a5,a0
    return -1;
    80003fe6:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80003fe8:	0007ca63          	bltz	a5,80003ffc <sys_read+0x40>
  return fileread(f, p, n);
    80003fec:	fe442603          	lw	a2,-28(s0)
    80003ff0:	fd843583          	ld	a1,-40(s0)
    80003ff4:	fe843503          	ld	a0,-24(s0)
    80003ff8:	d38ff0ef          	jal	80003530 <fileread>
}
    80003ffc:	70a2                	ld	ra,40(sp)
    80003ffe:	7402                	ld	s0,32(sp)
    80004000:	6145                	addi	sp,sp,48
    80004002:	8082                	ret

0000000080004004 <sys_write>:
{
    80004004:	7179                	addi	sp,sp,-48
    80004006:	f406                	sd	ra,40(sp)
    80004008:	f022                	sd	s0,32(sp)
    8000400a:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000400c:	fd840593          	addi	a1,s0,-40
    80004010:	4505                	li	a0,1
    80004012:	c0ffd0ef          	jal	80001c20 <argaddr>
  argint(2, &n);
    80004016:	fe440593          	addi	a1,s0,-28
    8000401a:	4509                	li	a0,2
    8000401c:	be9fd0ef          	jal	80001c04 <argint>
  if(argfd(0, 0, &f) < 0)
    80004020:	fe840613          	addi	a2,s0,-24
    80004024:	4581                	li	a1,0
    80004026:	4501                	li	a0,0
    80004028:	d73ff0ef          	jal	80003d9a <argfd>
    8000402c:	87aa                	mv	a5,a0
    return -1;
    8000402e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004030:	0007ca63          	bltz	a5,80004044 <sys_write+0x40>
  return filewrite(f, p, n);
    80004034:	fe442603          	lw	a2,-28(s0)
    80004038:	fd843583          	ld	a1,-40(s0)
    8000403c:	fe843503          	ld	a0,-24(s0)
    80004040:	daeff0ef          	jal	800035ee <filewrite>
}
    80004044:	70a2                	ld	ra,40(sp)
    80004046:	7402                	ld	s0,32(sp)
    80004048:	6145                	addi	sp,sp,48
    8000404a:	8082                	ret

000000008000404c <sys_close>:
{
    8000404c:	1101                	addi	sp,sp,-32
    8000404e:	ec06                	sd	ra,24(sp)
    80004050:	e822                	sd	s0,16(sp)
    80004052:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004054:	fe040613          	addi	a2,s0,-32
    80004058:	fec40593          	addi	a1,s0,-20
    8000405c:	4501                	li	a0,0
    8000405e:	d3dff0ef          	jal	80003d9a <argfd>
    return -1;
    80004062:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004064:	02054063          	bltz	a0,80004084 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004068:	cf5fc0ef          	jal	80000d5c <myproc>
    8000406c:	fec42783          	lw	a5,-20(s0)
    80004070:	07e9                	addi	a5,a5,26
    80004072:	078e                	slli	a5,a5,0x3
    80004074:	953e                	add	a0,a0,a5
    80004076:	00053023          	sd	zero,0(a0)
  fileclose(f);
    8000407a:	fe043503          	ld	a0,-32(s0)
    8000407e:	b92ff0ef          	jal	80003410 <fileclose>
  return 0;
    80004082:	4781                	li	a5,0
}
    80004084:	853e                	mv	a0,a5
    80004086:	60e2                	ld	ra,24(sp)
    80004088:	6442                	ld	s0,16(sp)
    8000408a:	6105                	addi	sp,sp,32
    8000408c:	8082                	ret

000000008000408e <sys_fstat>:
{
    8000408e:	1101                	addi	sp,sp,-32
    80004090:	ec06                	sd	ra,24(sp)
    80004092:	e822                	sd	s0,16(sp)
    80004094:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004096:	fe040593          	addi	a1,s0,-32
    8000409a:	4505                	li	a0,1
    8000409c:	b85fd0ef          	jal	80001c20 <argaddr>
  if(argfd(0, 0, &f) < 0)
    800040a0:	fe840613          	addi	a2,s0,-24
    800040a4:	4581                	li	a1,0
    800040a6:	4501                	li	a0,0
    800040a8:	cf3ff0ef          	jal	80003d9a <argfd>
    800040ac:	87aa                	mv	a5,a0
    return -1;
    800040ae:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800040b0:	0007c863          	bltz	a5,800040c0 <sys_fstat+0x32>
  return filestat(f, st);
    800040b4:	fe043583          	ld	a1,-32(s0)
    800040b8:	fe843503          	ld	a0,-24(s0)
    800040bc:	c12ff0ef          	jal	800034ce <filestat>
}
    800040c0:	60e2                	ld	ra,24(sp)
    800040c2:	6442                	ld	s0,16(sp)
    800040c4:	6105                	addi	sp,sp,32
    800040c6:	8082                	ret

00000000800040c8 <sys_link>:
{
    800040c8:	7169                	addi	sp,sp,-304
    800040ca:	f606                	sd	ra,296(sp)
    800040cc:	f222                	sd	s0,288(sp)
    800040ce:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800040d0:	08000613          	li	a2,128
    800040d4:	ed040593          	addi	a1,s0,-304
    800040d8:	4501                	li	a0,0
    800040da:	b63fd0ef          	jal	80001c3c <argstr>
    return -1;
    800040de:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800040e0:	0c054e63          	bltz	a0,800041bc <sys_link+0xf4>
    800040e4:	08000613          	li	a2,128
    800040e8:	f5040593          	addi	a1,s0,-176
    800040ec:	4505                	li	a0,1
    800040ee:	b4ffd0ef          	jal	80001c3c <argstr>
    return -1;
    800040f2:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800040f4:	0c054463          	bltz	a0,800041bc <sys_link+0xf4>
    800040f8:	ee26                	sd	s1,280(sp)
  begin_op();
    800040fa:	ef7fe0ef          	jal	80002ff0 <begin_op>
  if((ip = namei(old)) == 0){
    800040fe:	ed040513          	addi	a0,s0,-304
    80004102:	d2dfe0ef          	jal	80002e2e <namei>
    80004106:	84aa                	mv	s1,a0
    80004108:	c53d                	beqz	a0,80004176 <sys_link+0xae>
  ilock(ip);
    8000410a:	da6fe0ef          	jal	800026b0 <ilock>
  if(ip->type == T_DIR){
    8000410e:	04449703          	lh	a4,68(s1)
    80004112:	4785                	li	a5,1
    80004114:	06f70663          	beq	a4,a5,80004180 <sys_link+0xb8>
    80004118:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    8000411a:	04a4d783          	lhu	a5,74(s1)
    8000411e:	2785                	addiw	a5,a5,1
    80004120:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004124:	8526                	mv	a0,s1
    80004126:	cd6fe0ef          	jal	800025fc <iupdate>
  iunlock(ip);
    8000412a:	8526                	mv	a0,s1
    8000412c:	e32fe0ef          	jal	8000275e <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004130:	fd040593          	addi	a1,s0,-48
    80004134:	f5040513          	addi	a0,s0,-176
    80004138:	d11fe0ef          	jal	80002e48 <nameiparent>
    8000413c:	892a                	mv	s2,a0
    8000413e:	cd21                	beqz	a0,80004196 <sys_link+0xce>
  ilock(dp);
    80004140:	d70fe0ef          	jal	800026b0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004144:	00092703          	lw	a4,0(s2)
    80004148:	409c                	lw	a5,0(s1)
    8000414a:	04f71363          	bne	a4,a5,80004190 <sys_link+0xc8>
    8000414e:	40d0                	lw	a2,4(s1)
    80004150:	fd040593          	addi	a1,s0,-48
    80004154:	854a                	mv	a0,s2
    80004156:	c2ffe0ef          	jal	80002d84 <dirlink>
    8000415a:	02054b63          	bltz	a0,80004190 <sys_link+0xc8>
  iunlockput(dp);
    8000415e:	854a                	mv	a0,s2
    80004160:	fe6fe0ef          	jal	80002946 <iunlockput>
  iput(ip);
    80004164:	8526                	mv	a0,s1
    80004166:	f58fe0ef          	jal	800028be <iput>
  end_op();
    8000416a:	ef1fe0ef          	jal	8000305a <end_op>
  return 0;
    8000416e:	4781                	li	a5,0
    80004170:	64f2                	ld	s1,280(sp)
    80004172:	6952                	ld	s2,272(sp)
    80004174:	a0a1                	j	800041bc <sys_link+0xf4>
    end_op();
    80004176:	ee5fe0ef          	jal	8000305a <end_op>
    return -1;
    8000417a:	57fd                	li	a5,-1
    8000417c:	64f2                	ld	s1,280(sp)
    8000417e:	a83d                	j	800041bc <sys_link+0xf4>
    iunlockput(ip);
    80004180:	8526                	mv	a0,s1
    80004182:	fc4fe0ef          	jal	80002946 <iunlockput>
    end_op();
    80004186:	ed5fe0ef          	jal	8000305a <end_op>
    return -1;
    8000418a:	57fd                	li	a5,-1
    8000418c:	64f2                	ld	s1,280(sp)
    8000418e:	a03d                	j	800041bc <sys_link+0xf4>
    iunlockput(dp);
    80004190:	854a                	mv	a0,s2
    80004192:	fb4fe0ef          	jal	80002946 <iunlockput>
  ilock(ip);
    80004196:	8526                	mv	a0,s1
    80004198:	d18fe0ef          	jal	800026b0 <ilock>
  ip->nlink--;
    8000419c:	04a4d783          	lhu	a5,74(s1)
    800041a0:	37fd                	addiw	a5,a5,-1
    800041a2:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800041a6:	8526                	mv	a0,s1
    800041a8:	c54fe0ef          	jal	800025fc <iupdate>
  iunlockput(ip);
    800041ac:	8526                	mv	a0,s1
    800041ae:	f98fe0ef          	jal	80002946 <iunlockput>
  end_op();
    800041b2:	ea9fe0ef          	jal	8000305a <end_op>
  return -1;
    800041b6:	57fd                	li	a5,-1
    800041b8:	64f2                	ld	s1,280(sp)
    800041ba:	6952                	ld	s2,272(sp)
}
    800041bc:	853e                	mv	a0,a5
    800041be:	70b2                	ld	ra,296(sp)
    800041c0:	7412                	ld	s0,288(sp)
    800041c2:	6155                	addi	sp,sp,304
    800041c4:	8082                	ret

00000000800041c6 <sys_unlink>:
{
    800041c6:	7111                	addi	sp,sp,-256
    800041c8:	fd86                	sd	ra,248(sp)
    800041ca:	f9a2                	sd	s0,240(sp)
    800041cc:	0200                	addi	s0,sp,256
  if(argstr(0, path, MAXPATH) < 0)
    800041ce:	08000613          	li	a2,128
    800041d2:	f2040593          	addi	a1,s0,-224
    800041d6:	4501                	li	a0,0
    800041d8:	a65fd0ef          	jal	80001c3c <argstr>
    800041dc:	16054663          	bltz	a0,80004348 <sys_unlink+0x182>
    800041e0:	f5a6                	sd	s1,232(sp)
  begin_op();
    800041e2:	e0ffe0ef          	jal	80002ff0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800041e6:	fa040593          	addi	a1,s0,-96
    800041ea:	f2040513          	addi	a0,s0,-224
    800041ee:	c5bfe0ef          	jal	80002e48 <nameiparent>
    800041f2:	84aa                	mv	s1,a0
    800041f4:	c955                	beqz	a0,800042a8 <sys_unlink+0xe2>
  ilock(dp);
    800041f6:	cbafe0ef          	jal	800026b0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800041fa:	00003597          	auipc	a1,0x3
    800041fe:	3c658593          	addi	a1,a1,966 # 800075c0 <etext+0x5c0>
    80004202:	fa040513          	addi	a0,s0,-96
    80004206:	987fe0ef          	jal	80002b8c <namecmp>
    8000420a:	12050463          	beqz	a0,80004332 <sys_unlink+0x16c>
    8000420e:	00003597          	auipc	a1,0x3
    80004212:	3ba58593          	addi	a1,a1,954 # 800075c8 <etext+0x5c8>
    80004216:	fa040513          	addi	a0,s0,-96
    8000421a:	973fe0ef          	jal	80002b8c <namecmp>
    8000421e:	10050a63          	beqz	a0,80004332 <sys_unlink+0x16c>
    80004222:	f1ca                	sd	s2,224(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004224:	f1c40613          	addi	a2,s0,-228
    80004228:	fa040593          	addi	a1,s0,-96
    8000422c:	8526                	mv	a0,s1
    8000422e:	975fe0ef          	jal	80002ba2 <dirlookup>
    80004232:	892a                	mv	s2,a0
    80004234:	0e050e63          	beqz	a0,80004330 <sys_unlink+0x16a>
    80004238:	edce                	sd	s3,216(sp)
  ilock(ip);
    8000423a:	c76fe0ef          	jal	800026b0 <ilock>
  if(ip->nlink < 1)
    8000423e:	04a91783          	lh	a5,74(s2)
    80004242:	06f05863          	blez	a5,800042b2 <sys_unlink+0xec>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004246:	04491703          	lh	a4,68(s2)
    8000424a:	4785                	li	a5,1
    8000424c:	06f70b63          	beq	a4,a5,800042c2 <sys_unlink+0xfc>
  memset(&de, 0, sizeof(de));
    80004250:	fb040993          	addi	s3,s0,-80
    80004254:	4641                	li	a2,16
    80004256:	4581                	li	a1,0
    80004258:	854e                	mv	a0,s3
    8000425a:	ef5fb0ef          	jal	8000014e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000425e:	4741                	li	a4,16
    80004260:	f1c42683          	lw	a3,-228(s0)
    80004264:	864e                	mv	a2,s3
    80004266:	4581                	li	a1,0
    80004268:	8526                	mv	a0,s1
    8000426a:	81dfe0ef          	jal	80002a86 <writei>
    8000426e:	47c1                	li	a5,16
    80004270:	08f51f63          	bne	a0,a5,8000430e <sys_unlink+0x148>
  if(ip->type == T_DIR){
    80004274:	04491703          	lh	a4,68(s2)
    80004278:	4785                	li	a5,1
    8000427a:	0af70263          	beq	a4,a5,8000431e <sys_unlink+0x158>
  iunlockput(dp);
    8000427e:	8526                	mv	a0,s1
    80004280:	ec6fe0ef          	jal	80002946 <iunlockput>
  ip->nlink--;
    80004284:	04a95783          	lhu	a5,74(s2)
    80004288:	37fd                	addiw	a5,a5,-1
    8000428a:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    8000428e:	854a                	mv	a0,s2
    80004290:	b6cfe0ef          	jal	800025fc <iupdate>
  iunlockput(ip);
    80004294:	854a                	mv	a0,s2
    80004296:	eb0fe0ef          	jal	80002946 <iunlockput>
  end_op();
    8000429a:	dc1fe0ef          	jal	8000305a <end_op>
  return 0;
    8000429e:	4501                	li	a0,0
    800042a0:	74ae                	ld	s1,232(sp)
    800042a2:	790e                	ld	s2,224(sp)
    800042a4:	69ee                	ld	s3,216(sp)
    800042a6:	a869                	j	80004340 <sys_unlink+0x17a>
    end_op();
    800042a8:	db3fe0ef          	jal	8000305a <end_op>
    return -1;
    800042ac:	557d                	li	a0,-1
    800042ae:	74ae                	ld	s1,232(sp)
    800042b0:	a841                	j	80004340 <sys_unlink+0x17a>
    800042b2:	e9d2                	sd	s4,208(sp)
    800042b4:	e5d6                	sd	s5,200(sp)
    panic("unlink: nlink < 1");
    800042b6:	00003517          	auipc	a0,0x3
    800042ba:	31a50513          	addi	a0,a0,794 # 800075d0 <etext+0x5d0>
    800042be:	3e8010ef          	jal	800056a6 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800042c2:	04c92703          	lw	a4,76(s2)
    800042c6:	02000793          	li	a5,32
    800042ca:	f8e7f3e3          	bgeu	a5,a4,80004250 <sys_unlink+0x8a>
    800042ce:	e9d2                	sd	s4,208(sp)
    800042d0:	e5d6                	sd	s5,200(sp)
    800042d2:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800042d4:	f0840a93          	addi	s5,s0,-248
    800042d8:	4a41                	li	s4,16
    800042da:	8752                	mv	a4,s4
    800042dc:	86ce                	mv	a3,s3
    800042de:	8656                	mv	a2,s5
    800042e0:	4581                	li	a1,0
    800042e2:	854a                	mv	a0,s2
    800042e4:	eb0fe0ef          	jal	80002994 <readi>
    800042e8:	01451d63          	bne	a0,s4,80004302 <sys_unlink+0x13c>
    if(de.inum != 0)
    800042ec:	f0845783          	lhu	a5,-248(s0)
    800042f0:	efb1                	bnez	a5,8000434c <sys_unlink+0x186>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800042f2:	29c1                	addiw	s3,s3,16
    800042f4:	04c92783          	lw	a5,76(s2)
    800042f8:	fef9e1e3          	bltu	s3,a5,800042da <sys_unlink+0x114>
    800042fc:	6a4e                	ld	s4,208(sp)
    800042fe:	6aae                	ld	s5,200(sp)
    80004300:	bf81                	j	80004250 <sys_unlink+0x8a>
      panic("isdirempty: readi");
    80004302:	00003517          	auipc	a0,0x3
    80004306:	2e650513          	addi	a0,a0,742 # 800075e8 <etext+0x5e8>
    8000430a:	39c010ef          	jal	800056a6 <panic>
    8000430e:	e9d2                	sd	s4,208(sp)
    80004310:	e5d6                	sd	s5,200(sp)
    panic("unlink: writei");
    80004312:	00003517          	auipc	a0,0x3
    80004316:	2ee50513          	addi	a0,a0,750 # 80007600 <etext+0x600>
    8000431a:	38c010ef          	jal	800056a6 <panic>
    dp->nlink--;
    8000431e:	04a4d783          	lhu	a5,74(s1)
    80004322:	37fd                	addiw	a5,a5,-1
    80004324:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004328:	8526                	mv	a0,s1
    8000432a:	ad2fe0ef          	jal	800025fc <iupdate>
    8000432e:	bf81                	j	8000427e <sys_unlink+0xb8>
    80004330:	790e                	ld	s2,224(sp)
  iunlockput(dp);
    80004332:	8526                	mv	a0,s1
    80004334:	e12fe0ef          	jal	80002946 <iunlockput>
  end_op();
    80004338:	d23fe0ef          	jal	8000305a <end_op>
  return -1;
    8000433c:	557d                	li	a0,-1
    8000433e:	74ae                	ld	s1,232(sp)
}
    80004340:	70ee                	ld	ra,248(sp)
    80004342:	744e                	ld	s0,240(sp)
    80004344:	6111                	addi	sp,sp,256
    80004346:	8082                	ret
    return -1;
    80004348:	557d                	li	a0,-1
    8000434a:	bfdd                	j	80004340 <sys_unlink+0x17a>
    iunlockput(ip);
    8000434c:	854a                	mv	a0,s2
    8000434e:	df8fe0ef          	jal	80002946 <iunlockput>
    goto bad;
    80004352:	790e                	ld	s2,224(sp)
    80004354:	69ee                	ld	s3,216(sp)
    80004356:	6a4e                	ld	s4,208(sp)
    80004358:	6aae                	ld	s5,200(sp)
    8000435a:	bfe1                	j	80004332 <sys_unlink+0x16c>

000000008000435c <sys_open>:

uint64
sys_open(void)
{
    8000435c:	7155                	addi	sp,sp,-208
    8000435e:	e586                	sd	ra,200(sp)
    80004360:	e1a2                	sd	s0,192(sp)
    80004362:	fd26                	sd	s1,184(sp)
    80004364:	f94a                	sd	s2,176(sp)
    80004366:	f54e                	sd	s3,168(sp)
    80004368:	f152                	sd	s4,160(sp)
    8000436a:	ed56                	sd	s5,152(sp)
    8000436c:	e95a                	sd	s6,144(sp)
    8000436e:	0980                	addi	s0,sp,208
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004370:	f3c40593          	addi	a1,s0,-196
    80004374:	4505                	li	a0,1
    80004376:	88ffd0ef          	jal	80001c04 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    8000437a:	08000613          	li	a2,128
    8000437e:	f4040593          	addi	a1,s0,-192
    80004382:	4501                	li	a0,0
    80004384:	8b9fd0ef          	jal	80001c3c <argstr>
    80004388:	87aa                	mv	a5,a0
    return -1;
    8000438a:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    8000438c:	0a07c863          	bltz	a5,8000443c <sys_open+0xe0>

  begin_op();
    80004390:	c61fe0ef          	jal	80002ff0 <begin_op>
  if(omode & O_CREATE){
    80004394:	f3c42783          	lw	a5,-196(s0)
    80004398:	2007f793          	andi	a5,a5,512
    8000439c:	c3e1                	beqz	a5,8000445c <sys_open+0x100>
  ip = create(path, T_FILE, 0, 0);
    8000439e:	4681                	li	a3,0
    800043a0:	4601                	li	a2,0
    800043a2:	4589                	li	a1,2
    800043a4:	f4040513          	addi	a0,s0,-192
    800043a8:	a89ff0ef          	jal	80003e30 <create>
    800043ac:	84aa                	mv	s1,a0
  if(ip == 0){
    800043ae:	c15d                	beqz	a0,80004454 <sys_open+0xf8>
    end_op();
    return -1;
  }
}
  int symlink_depth=0;
  while(ip->type == T_SYMLINK){ //ergasia
    800043b0:	04449783          	lh	a5,68(s1)
    800043b4:	4711                	li	a4,4
    800043b6:	49a5                	li	s3,9
    800043b8:	14e79463          	bne	a5,a4,80004500 <sys_open+0x1a4>
        printf("symbolic link is a loop");
        iunlockput(ip);
        end_op();
        return -1;
      };
      if(omode & O_NOFOLLOW){
    800043bc:	6a05                	lui	s4,0x1
    800043be:	800a0a13          	addi	s4,s4,-2048 # 800 <_entry-0x7ffff800>

      else{
            
        int length;

        readi(ip,0,(uint64) &length,0,sizeof(int));
    800043c2:	f3840a93          	addi	s5,s0,-200
    800043c6:	893a                	mv	s2,a4
      if(omode & O_NOFOLLOW){
    800043c8:	f3c42783          	lw	a5,-196(s0)
    800043cc:	0147f7b3          	and	a5,a5,s4
    800043d0:	e7d5                	bnez	a5,8000447c <sys_open+0x120>
      else{
    800043d2:	8b0a                	mv	s6,sp
        readi(ip,0,(uint64) &length,0,sizeof(int));
    800043d4:	874a                	mv	a4,s2
    800043d6:	4681                	li	a3,0
    800043d8:	8656                	mv	a2,s5
    800043da:	4581                	li	a1,0
    800043dc:	8526                	mv	a0,s1
    800043de:	db6fe0ef          	jal	80002994 <readi>
        char target[length+1];
    800043e2:	f3842703          	lw	a4,-200(s0)
    800043e6:	2705                	addiw	a4,a4,1
    800043e8:	00f70793          	addi	a5,a4,15
    800043ec:	9bc1                	andi	a5,a5,-16
    800043ee:	40f10133          	sub	sp,sp,a5
        readi(ip,0,(uint64) target,sizeof(int),length+1);
    800043f2:	86ca                	mv	a3,s2
    800043f4:	860a                	mv	a2,sp
    800043f6:	4581                	li	a1,0
    800043f8:	8526                	mv	a0,s1
    800043fa:	d9afe0ef          	jal	80002994 <readi>
        iunlockput(ip);
    800043fe:	8526                	mv	a0,s1
    80004400:	d46fe0ef          	jal	80002946 <iunlockput>
        if ((ip = namei(target))==0){
    80004404:	850a                	mv	a0,sp
    80004406:	a29fe0ef          	jal	80002e2e <namei>
    8000440a:	84aa                	mv	s1,a0
    8000440c:	0e050563          	beqz	a0,800044f6 <sys_open+0x19a>
          end_op();
          return -1;
        }
        ilock(ip);
    80004410:	aa0fe0ef          	jal	800026b0 <ilock>
        symlink_depth++;
    80004414:	815a                	mv	sp,s6
  while(ip->type == T_SYMLINK){ //ergasia
    80004416:	04449783          	lh	a5,68(s1)
    8000441a:	0f279363          	bne	a5,s2,80004500 <sys_open+0x1a4>
      if (symlink_depth>=9){
    8000441e:	39fd                	addiw	s3,s3,-1
    80004420:	fa0994e3          	bnez	s3,800043c8 <sys_open+0x6c>
        printf("symbolic link is a loop");
    80004424:	00003517          	auipc	a0,0x3
    80004428:	1ec50513          	addi	a0,a0,492 # 80007610 <etext+0x610>
    8000442c:	7ab000ef          	jal	800053d6 <printf>
        iunlockput(ip);
    80004430:	8526                	mv	a0,s1
    80004432:	d14fe0ef          	jal	80002946 <iunlockput>
        end_op();
    80004436:	c25fe0ef          	jal	8000305a <end_op>
        return -1;
    8000443a:	557d                	li	a0,-1

  iunlock(ip);
  end_op();

  return fd;
}
    8000443c:	f3040113          	addi	sp,s0,-208
    80004440:	60ae                	ld	ra,200(sp)
    80004442:	640e                	ld	s0,192(sp)
    80004444:	74ea                	ld	s1,184(sp)
    80004446:	794a                	ld	s2,176(sp)
    80004448:	79aa                	ld	s3,168(sp)
    8000444a:	7a0a                	ld	s4,160(sp)
    8000444c:	6aea                	ld	s5,152(sp)
    8000444e:	6b4a                	ld	s6,144(sp)
    80004450:	6169                	addi	sp,sp,208
    80004452:	8082                	ret
    end_op();
    80004454:	c07fe0ef          	jal	8000305a <end_op>
    return -1;
    80004458:	557d                	li	a0,-1
    8000445a:	b7cd                	j	8000443c <sys_open+0xe0>
  if((ip = namei(path)) == 0){
    8000445c:	f4040513          	addi	a0,s0,-192
    80004460:	9cffe0ef          	jal	80002e2e <namei>
    80004464:	84aa                	mv	s1,a0
    80004466:	cd2d                	beqz	a0,800044e0 <sys_open+0x184>
  ilock(ip);
    80004468:	a48fe0ef          	jal	800026b0 <ilock>
  if(ip->type == T_DIR && omode != O_RDONLY){
    8000446c:	04449703          	lh	a4,68(s1)
    80004470:	4785                	li	a5,1
    80004472:	f2f71fe3          	bne	a4,a5,800043b0 <sys_open+0x54>
    80004476:	f3c42783          	lw	a5,-196(s0)
    8000447a:	e7bd                	bnez	a5,800044e8 <sys_open+0x18c>
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    8000447c:	ef1fe0ef          	jal	8000336c <filealloc>
    80004480:	89aa                	mv	s3,a0
    80004482:	c14d                	beqz	a0,80004524 <sys_open+0x1c8>
    80004484:	96fff0ef          	jal	80003df2 <fdalloc>
    80004488:	892a                	mv	s2,a0
    8000448a:	08054a63          	bltz	a0,8000451e <sys_open+0x1c2>
  if(ip->type == T_DEVICE){
    8000448e:	04449703          	lh	a4,68(s1)
    80004492:	478d                	li	a5,3
    80004494:	08f70f63          	beq	a4,a5,80004532 <sys_open+0x1d6>
    f->type = FD_INODE;
    80004498:	4789                	li	a5,2
    8000449a:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    8000449e:	0209a023          	sw	zero,32(s3)
  f->ip = ip;
    800044a2:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    800044a6:	f3c42783          	lw	a5,-196(s0)
    800044aa:	0017f713          	andi	a4,a5,1
    800044ae:	00174713          	xori	a4,a4,1
    800044b2:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800044b6:	0037f713          	andi	a4,a5,3
    800044ba:	00e03733          	snez	a4,a4
    800044be:	00e984a3          	sb	a4,9(s3)
  if((omode & O_TRUNC) && ip->type == T_FILE){
    800044c2:	4007f793          	andi	a5,a5,1024
    800044c6:	c791                	beqz	a5,800044d2 <sys_open+0x176>
    800044c8:	04449703          	lh	a4,68(s1)
    800044cc:	4789                	li	a5,2
    800044ce:	06f70963          	beq	a4,a5,80004540 <sys_open+0x1e4>
  iunlock(ip);
    800044d2:	8526                	mv	a0,s1
    800044d4:	a8afe0ef          	jal	8000275e <iunlock>
  end_op();
    800044d8:	b83fe0ef          	jal	8000305a <end_op>
  return fd;
    800044dc:	854a                	mv	a0,s2
    800044de:	bfb9                	j	8000443c <sys_open+0xe0>
    end_op();
    800044e0:	b7bfe0ef          	jal	8000305a <end_op>
    return -1;
    800044e4:	557d                	li	a0,-1
    800044e6:	bf99                	j	8000443c <sys_open+0xe0>
    iunlockput(ip);
    800044e8:	8526                	mv	a0,s1
    800044ea:	c5cfe0ef          	jal	80002946 <iunlockput>
    end_op();
    800044ee:	b6dfe0ef          	jal	8000305a <end_op>
    return -1;
    800044f2:	557d                	li	a0,-1
    800044f4:	b7a1                	j	8000443c <sys_open+0xe0>
          end_op();
    800044f6:	b65fe0ef          	jal	8000305a <end_op>
          return -1;
    800044fa:	815a                	mv	sp,s6
    800044fc:	557d                	li	a0,-1
    800044fe:	bf3d                	j	8000443c <sys_open+0xe0>
  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004500:	470d                	li	a4,3
    80004502:	f6e79de3          	bne	a5,a4,8000447c <sys_open+0x120>
    80004506:	0464d703          	lhu	a4,70(s1)
    8000450a:	47a5                	li	a5,9
    8000450c:	f6e7f8e3          	bgeu	a5,a4,8000447c <sys_open+0x120>
    iunlockput(ip);
    80004510:	8526                	mv	a0,s1
    80004512:	c34fe0ef          	jal	80002946 <iunlockput>
    end_op();
    80004516:	b45fe0ef          	jal	8000305a <end_op>
    return -1;
    8000451a:	557d                	li	a0,-1
    8000451c:	b705                	j	8000443c <sys_open+0xe0>
      fileclose(f);
    8000451e:	854e                	mv	a0,s3
    80004520:	ef1fe0ef          	jal	80003410 <fileclose>
    iunlockput(ip);
    80004524:	8526                	mv	a0,s1
    80004526:	c20fe0ef          	jal	80002946 <iunlockput>
    end_op();
    8000452a:	b31fe0ef          	jal	8000305a <end_op>
    return -1;
    8000452e:	557d                	li	a0,-1
    80004530:	b731                	j	8000443c <sys_open+0xe0>
    f->type = FD_DEVICE;
    80004532:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80004536:	04649783          	lh	a5,70(s1)
    8000453a:	02f99223          	sh	a5,36(s3)
    8000453e:	b795                	j	800044a2 <sys_open+0x146>
    itrunc(ip);
    80004540:	8526                	mv	a0,s1
    80004542:	a5cfe0ef          	jal	8000279e <itrunc>
    80004546:	b771                	j	800044d2 <sys_open+0x176>

0000000080004548 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004548:	7175                	addi	sp,sp,-144
    8000454a:	e506                	sd	ra,136(sp)
    8000454c:	e122                	sd	s0,128(sp)
    8000454e:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004550:	aa1fe0ef          	jal	80002ff0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004554:	08000613          	li	a2,128
    80004558:	f7040593          	addi	a1,s0,-144
    8000455c:	4501                	li	a0,0
    8000455e:	edefd0ef          	jal	80001c3c <argstr>
    80004562:	02054363          	bltz	a0,80004588 <sys_mkdir+0x40>
    80004566:	4681                	li	a3,0
    80004568:	4601                	li	a2,0
    8000456a:	4585                	li	a1,1
    8000456c:	f7040513          	addi	a0,s0,-144
    80004570:	8c1ff0ef          	jal	80003e30 <create>
    80004574:	c911                	beqz	a0,80004588 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004576:	bd0fe0ef          	jal	80002946 <iunlockput>
  end_op();
    8000457a:	ae1fe0ef          	jal	8000305a <end_op>
  return 0;
    8000457e:	4501                	li	a0,0
}
    80004580:	60aa                	ld	ra,136(sp)
    80004582:	640a                	ld	s0,128(sp)
    80004584:	6149                	addi	sp,sp,144
    80004586:	8082                	ret
    end_op();
    80004588:	ad3fe0ef          	jal	8000305a <end_op>
    return -1;
    8000458c:	557d                	li	a0,-1
    8000458e:	bfcd                	j	80004580 <sys_mkdir+0x38>

0000000080004590 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004590:	7135                	addi	sp,sp,-160
    80004592:	ed06                	sd	ra,152(sp)
    80004594:	e922                	sd	s0,144(sp)
    80004596:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004598:	a59fe0ef          	jal	80002ff0 <begin_op>
  argint(1, &major);
    8000459c:	f6c40593          	addi	a1,s0,-148
    800045a0:	4505                	li	a0,1
    800045a2:	e62fd0ef          	jal	80001c04 <argint>
  argint(2, &minor);
    800045a6:	f6840593          	addi	a1,s0,-152
    800045aa:	4509                	li	a0,2
    800045ac:	e58fd0ef          	jal	80001c04 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800045b0:	08000613          	li	a2,128
    800045b4:	f7040593          	addi	a1,s0,-144
    800045b8:	4501                	li	a0,0
    800045ba:	e82fd0ef          	jal	80001c3c <argstr>
    800045be:	02054563          	bltz	a0,800045e8 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800045c2:	f6841683          	lh	a3,-152(s0)
    800045c6:	f6c41603          	lh	a2,-148(s0)
    800045ca:	458d                	li	a1,3
    800045cc:	f7040513          	addi	a0,s0,-144
    800045d0:	861ff0ef          	jal	80003e30 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800045d4:	c911                	beqz	a0,800045e8 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800045d6:	b70fe0ef          	jal	80002946 <iunlockput>
  end_op();
    800045da:	a81fe0ef          	jal	8000305a <end_op>
  return 0;
    800045de:	4501                	li	a0,0
}
    800045e0:	60ea                	ld	ra,152(sp)
    800045e2:	644a                	ld	s0,144(sp)
    800045e4:	610d                	addi	sp,sp,160
    800045e6:	8082                	ret
    end_op();
    800045e8:	a73fe0ef          	jal	8000305a <end_op>
    return -1;
    800045ec:	557d                	li	a0,-1
    800045ee:	bfcd                	j	800045e0 <sys_mknod+0x50>

00000000800045f0 <sys_chdir>:

uint64
sys_chdir(void)
{
    800045f0:	7135                	addi	sp,sp,-160
    800045f2:	ed06                	sd	ra,152(sp)
    800045f4:	e922                	sd	s0,144(sp)
    800045f6:	e14a                	sd	s2,128(sp)
    800045f8:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800045fa:	f62fc0ef          	jal	80000d5c <myproc>
    800045fe:	892a                	mv	s2,a0
  
  begin_op();
    80004600:	9f1fe0ef          	jal	80002ff0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004604:	08000613          	li	a2,128
    80004608:	f6040593          	addi	a1,s0,-160
    8000460c:	4501                	li	a0,0
    8000460e:	e2efd0ef          	jal	80001c3c <argstr>
    80004612:	04054363          	bltz	a0,80004658 <sys_chdir+0x68>
    80004616:	e526                	sd	s1,136(sp)
    80004618:	f6040513          	addi	a0,s0,-160
    8000461c:	813fe0ef          	jal	80002e2e <namei>
    80004620:	84aa                	mv	s1,a0
    80004622:	c915                	beqz	a0,80004656 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80004624:	88cfe0ef          	jal	800026b0 <ilock>
  if(ip->type != T_DIR){
    80004628:	04449703          	lh	a4,68(s1)
    8000462c:	4785                	li	a5,1
    8000462e:	02f71963          	bne	a4,a5,80004660 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004632:	8526                	mv	a0,s1
    80004634:	92afe0ef          	jal	8000275e <iunlock>
  iput(p->cwd);
    80004638:	15093503          	ld	a0,336(s2)
    8000463c:	a82fe0ef          	jal	800028be <iput>
  end_op();
    80004640:	a1bfe0ef          	jal	8000305a <end_op>
  p->cwd = ip;
    80004644:	14993823          	sd	s1,336(s2)
  return 0;
    80004648:	4501                	li	a0,0
    8000464a:	64aa                	ld	s1,136(sp)
}
    8000464c:	60ea                	ld	ra,152(sp)
    8000464e:	644a                	ld	s0,144(sp)
    80004650:	690a                	ld	s2,128(sp)
    80004652:	610d                	addi	sp,sp,160
    80004654:	8082                	ret
    80004656:	64aa                	ld	s1,136(sp)
    end_op();
    80004658:	a03fe0ef          	jal	8000305a <end_op>
    return -1;
    8000465c:	557d                	li	a0,-1
    8000465e:	b7fd                	j	8000464c <sys_chdir+0x5c>
    iunlockput(ip);
    80004660:	8526                	mv	a0,s1
    80004662:	ae4fe0ef          	jal	80002946 <iunlockput>
    end_op();
    80004666:	9f5fe0ef          	jal	8000305a <end_op>
    return -1;
    8000466a:	557d                	li	a0,-1
    8000466c:	64aa                	ld	s1,136(sp)
    8000466e:	bff9                	j	8000464c <sys_chdir+0x5c>

0000000080004670 <sys_exec>:

uint64
sys_exec(void)
{
    80004670:	7105                	addi	sp,sp,-480
    80004672:	ef86                	sd	ra,472(sp)
    80004674:	eba2                	sd	s0,464(sp)
    80004676:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004678:	e2840593          	addi	a1,s0,-472
    8000467c:	4505                	li	a0,1
    8000467e:	da2fd0ef          	jal	80001c20 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004682:	08000613          	li	a2,128
    80004686:	f3040593          	addi	a1,s0,-208
    8000468a:	4501                	li	a0,0
    8000468c:	db0fd0ef          	jal	80001c3c <argstr>
    80004690:	87aa                	mv	a5,a0
    return -1;
    80004692:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004694:	0e07c063          	bltz	a5,80004774 <sys_exec+0x104>
    80004698:	e7a6                	sd	s1,456(sp)
    8000469a:	e3ca                	sd	s2,448(sp)
    8000469c:	ff4e                	sd	s3,440(sp)
    8000469e:	fb52                	sd	s4,432(sp)
    800046a0:	f756                	sd	s5,424(sp)
    800046a2:	f35a                	sd	s6,416(sp)
    800046a4:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    800046a6:	e3040a13          	addi	s4,s0,-464
    800046aa:	10000613          	li	a2,256
    800046ae:	4581                	li	a1,0
    800046b0:	8552                	mv	a0,s4
    800046b2:	a9dfb0ef          	jal	8000014e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800046b6:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    800046b8:	89d2                	mv	s3,s4
    800046ba:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800046bc:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800046c0:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    800046c2:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800046c6:	00391513          	slli	a0,s2,0x3
    800046ca:	85d6                	mv	a1,s5
    800046cc:	e2843783          	ld	a5,-472(s0)
    800046d0:	953e                	add	a0,a0,a5
    800046d2:	ca8fd0ef          	jal	80001b7a <fetchaddr>
    800046d6:	02054663          	bltz	a0,80004702 <sys_exec+0x92>
    if(uarg == 0){
    800046da:	e2043783          	ld	a5,-480(s0)
    800046de:	c7a1                	beqz	a5,80004726 <sys_exec+0xb6>
    argv[i] = kalloc();
    800046e0:	a1ffb0ef          	jal	800000fe <kalloc>
    800046e4:	85aa                	mv	a1,a0
    800046e6:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800046ea:	cd01                	beqz	a0,80004702 <sys_exec+0x92>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800046ec:	865a                	mv	a2,s6
    800046ee:	e2043503          	ld	a0,-480(s0)
    800046f2:	cd2fd0ef          	jal	80001bc4 <fetchstr>
    800046f6:	00054663          	bltz	a0,80004702 <sys_exec+0x92>
    if(i >= NELEM(argv)){
    800046fa:	0905                	addi	s2,s2,1
    800046fc:	09a1                	addi	s3,s3,8
    800046fe:	fd7914e3          	bne	s2,s7,800046c6 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004702:	100a0a13          	addi	s4,s4,256
    80004706:	6088                	ld	a0,0(s1)
    80004708:	cd31                	beqz	a0,80004764 <sys_exec+0xf4>
    kfree(argv[i]);
    8000470a:	913fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000470e:	04a1                	addi	s1,s1,8
    80004710:	ff449be3          	bne	s1,s4,80004706 <sys_exec+0x96>
  return -1;
    80004714:	557d                	li	a0,-1
    80004716:	64be                	ld	s1,456(sp)
    80004718:	691e                	ld	s2,448(sp)
    8000471a:	79fa                	ld	s3,440(sp)
    8000471c:	7a5a                	ld	s4,432(sp)
    8000471e:	7aba                	ld	s5,424(sp)
    80004720:	7b1a                	ld	s6,416(sp)
    80004722:	6bfa                	ld	s7,408(sp)
    80004724:	a881                	j	80004774 <sys_exec+0x104>
      argv[i] = 0;
    80004726:	0009079b          	sext.w	a5,s2
    8000472a:	e3040593          	addi	a1,s0,-464
    8000472e:	078e                	slli	a5,a5,0x3
    80004730:	97ae                	add	a5,a5,a1
    80004732:	0007b023          	sd	zero,0(a5)
  int ret = exec(path, argv);
    80004736:	f3040513          	addi	a0,s0,-208
    8000473a:	b08ff0ef          	jal	80003a42 <exec>
    8000473e:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004740:	100a0a13          	addi	s4,s4,256
    80004744:	6088                	ld	a0,0(s1)
    80004746:	c511                	beqz	a0,80004752 <sys_exec+0xe2>
    kfree(argv[i]);
    80004748:	8d5fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000474c:	04a1                	addi	s1,s1,8
    8000474e:	ff449be3          	bne	s1,s4,80004744 <sys_exec+0xd4>
  return ret;
    80004752:	854a                	mv	a0,s2
    80004754:	64be                	ld	s1,456(sp)
    80004756:	691e                	ld	s2,448(sp)
    80004758:	79fa                	ld	s3,440(sp)
    8000475a:	7a5a                	ld	s4,432(sp)
    8000475c:	7aba                	ld	s5,424(sp)
    8000475e:	7b1a                	ld	s6,416(sp)
    80004760:	6bfa                	ld	s7,408(sp)
    80004762:	a809                	j	80004774 <sys_exec+0x104>
  return -1;
    80004764:	557d                	li	a0,-1
    80004766:	64be                	ld	s1,456(sp)
    80004768:	691e                	ld	s2,448(sp)
    8000476a:	79fa                	ld	s3,440(sp)
    8000476c:	7a5a                	ld	s4,432(sp)
    8000476e:	7aba                	ld	s5,424(sp)
    80004770:	7b1a                	ld	s6,416(sp)
    80004772:	6bfa                	ld	s7,408(sp)
}
    80004774:	60fe                	ld	ra,472(sp)
    80004776:	645e                	ld	s0,464(sp)
    80004778:	613d                	addi	sp,sp,480
    8000477a:	8082                	ret

000000008000477c <sys_pipe>:

uint64
sys_pipe(void)
{
    8000477c:	7139                	addi	sp,sp,-64
    8000477e:	fc06                	sd	ra,56(sp)
    80004780:	f822                	sd	s0,48(sp)
    80004782:	f426                	sd	s1,40(sp)
    80004784:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004786:	dd6fc0ef          	jal	80000d5c <myproc>
    8000478a:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000478c:	fd840593          	addi	a1,s0,-40
    80004790:	4501                	li	a0,0
    80004792:	c8efd0ef          	jal	80001c20 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004796:	fc840593          	addi	a1,s0,-56
    8000479a:	fd040513          	addi	a0,s0,-48
    8000479e:	f83fe0ef          	jal	80003720 <pipealloc>
    return -1;
    800047a2:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800047a4:	0a054463          	bltz	a0,8000484c <sys_pipe+0xd0>
  fd0 = -1;
    800047a8:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800047ac:	fd043503          	ld	a0,-48(s0)
    800047b0:	e42ff0ef          	jal	80003df2 <fdalloc>
    800047b4:	fca42223          	sw	a0,-60(s0)
    800047b8:	08054163          	bltz	a0,8000483a <sys_pipe+0xbe>
    800047bc:	fc843503          	ld	a0,-56(s0)
    800047c0:	e32ff0ef          	jal	80003df2 <fdalloc>
    800047c4:	fca42023          	sw	a0,-64(s0)
    800047c8:	06054063          	bltz	a0,80004828 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800047cc:	4691                	li	a3,4
    800047ce:	fc440613          	addi	a2,s0,-60
    800047d2:	fd843583          	ld	a1,-40(s0)
    800047d6:	68a8                	ld	a0,80(s1)
    800047d8:	a2cfc0ef          	jal	80000a04 <copyout>
    800047dc:	00054e63          	bltz	a0,800047f8 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800047e0:	4691                	li	a3,4
    800047e2:	fc040613          	addi	a2,s0,-64
    800047e6:	fd843583          	ld	a1,-40(s0)
    800047ea:	95b6                	add	a1,a1,a3
    800047ec:	68a8                	ld	a0,80(s1)
    800047ee:	a16fc0ef          	jal	80000a04 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800047f2:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800047f4:	04055c63          	bgez	a0,8000484c <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    800047f8:	fc442783          	lw	a5,-60(s0)
    800047fc:	07e9                	addi	a5,a5,26
    800047fe:	078e                	slli	a5,a5,0x3
    80004800:	97a6                	add	a5,a5,s1
    80004802:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004806:	fc042783          	lw	a5,-64(s0)
    8000480a:	07e9                	addi	a5,a5,26
    8000480c:	078e                	slli	a5,a5,0x3
    8000480e:	94be                	add	s1,s1,a5
    80004810:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80004814:	fd043503          	ld	a0,-48(s0)
    80004818:	bf9fe0ef          	jal	80003410 <fileclose>
    fileclose(wf);
    8000481c:	fc843503          	ld	a0,-56(s0)
    80004820:	bf1fe0ef          	jal	80003410 <fileclose>
    return -1;
    80004824:	57fd                	li	a5,-1
    80004826:	a01d                	j	8000484c <sys_pipe+0xd0>
    if(fd0 >= 0)
    80004828:	fc442783          	lw	a5,-60(s0)
    8000482c:	0007c763          	bltz	a5,8000483a <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80004830:	07e9                	addi	a5,a5,26
    80004832:	078e                	slli	a5,a5,0x3
    80004834:	97a6                	add	a5,a5,s1
    80004836:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000483a:	fd043503          	ld	a0,-48(s0)
    8000483e:	bd3fe0ef          	jal	80003410 <fileclose>
    fileclose(wf);
    80004842:	fc843503          	ld	a0,-56(s0)
    80004846:	bcbfe0ef          	jal	80003410 <fileclose>
    return -1;
    8000484a:	57fd                	li	a5,-1
}
    8000484c:	853e                	mv	a0,a5
    8000484e:	70e2                	ld	ra,56(sp)
    80004850:	7442                	ld	s0,48(sp)
    80004852:	74a2                	ld	s1,40(sp)
    80004854:	6121                	addi	sp,sp,64
    80004856:	8082                	ret

0000000080004858 <sys_symlink>:

uint64
sys_symlink(void)
{
    80004858:	7129                	addi	sp,sp,-320
    8000485a:	fe06                	sd	ra,312(sp)
    8000485c:	fa22                	sd	s0,304(sp)
    8000485e:	0280                	addi	s0,sp,320
char target[MAXPATH];
char path[MAXPATH];
if(argstr(0, target, MAXPATH) < 0 || argstr(1, path, MAXPATH) < 0) //input function arguments and check for errors
    80004860:	08000613          	li	a2,128
    80004864:	f5040593          	addi	a1,s0,-176
    80004868:	4501                	li	a0,0
    8000486a:	bd2fd0ef          	jal	80001c3c <argstr>
  return -1;
    8000486e:	57fd                	li	a5,-1
if(argstr(0, target, MAXPATH) < 0 || argstr(1, path, MAXPATH) < 0) //input function arguments and check for errors
    80004870:	08054b63          	bltz	a0,80004906 <sys_symlink+0xae>
    80004874:	08000613          	li	a2,128
    80004878:	ed040593          	addi	a1,s0,-304
    8000487c:	4505                	li	a0,1
    8000487e:	bbefd0ef          	jal	80001c3c <argstr>
  return -1;
    80004882:	57fd                	li	a5,-1
if(argstr(0, target, MAXPATH) < 0 || argstr(1, path, MAXPATH) < 0) //input function arguments and check for errors
    80004884:	08054163          	bltz	a0,80004906 <sys_symlink+0xae>
    80004888:	f626                	sd	s1,296(sp)
begin_op(); //begin logging from the system
    8000488a:	f66fe0ef          	jal	80002ff0 <begin_op>
struct inode* ip;
ip = create(path, T_SYMLINK, 0, 0);
    8000488e:	4681                	li	a3,0
    80004890:	4601                	li	a2,0
    80004892:	4591                	li	a1,4
    80004894:	ed040513          	addi	a0,s0,-304
    80004898:	d98ff0ef          	jal	80003e30 <create>
    8000489c:	84aa                	mv	s1,a0
//ilock(ip);
if (ip==0){
    8000489e:	c92d                	beqz	a0,80004910 <sys_symlink+0xb8>
  //iunlockput(ip);
  end_op();
  return -1;
}
int length =  strlen(target);
    800048a0:	f5040513          	addi	a0,s0,-176
    800048a4:	a33fb0ef          	jal	800002d6 <strlen>
    800048a8:	eca42623          	sw	a0,-308(s0)

if(writei(ip, 0, (uint64) &length, 0, sizeof(int)) != sizeof(int)){
    800048ac:	4711                	li	a4,4
    800048ae:	4681                	li	a3,0
    800048b0:	ecc40613          	addi	a2,s0,-308
    800048b4:	4581                	li	a1,0
    800048b6:	8526                	mv	a0,s1
    800048b8:	9cefe0ef          	jal	80002a86 <writei>
    800048bc:	4791                	li	a5,4
    800048be:	04f51e63          	bne	a0,a5,8000491a <sys_symlink+0xc2>
    800048c2:	f24a                	sd	s2,288(sp)
    800048c4:	ee4e                	sd	s3,280(sp)
  iunlockput(ip);
  end_op();
  return -1;
  }
if(writei(ip, 0, (uint64) target, sizeof(int), (strlen(target)+1)) != (strlen(target)+1)){ //sizeof(int) is offset 
    800048c6:	f5040993          	addi	s3,s0,-176
    800048ca:	854e                	mv	a0,s3
    800048cc:	a0bfb0ef          	jal	800002d6 <strlen>
    800048d0:	0015071b          	addiw	a4,a0,1
    800048d4:	4691                	li	a3,4
    800048d6:	864e                	mv	a2,s3
    800048d8:	4581                	li	a1,0
    800048da:	8526                	mv	a0,s1
    800048dc:	9aafe0ef          	jal	80002a86 <writei>
    800048e0:	892a                	mv	s2,a0
    800048e2:	854e                	mv	a0,s3
    800048e4:	9f3fb0ef          	jal	800002d6 <strlen>
    800048e8:	2505                	addiw	a0,a0,1
    800048ea:	05251063          	bne	a0,s2,8000492a <sys_symlink+0xd2>
  iunlockput(ip);
  end_op();
  return -1;
  }
iupdate(ip);
    800048ee:	8526                	mv	a0,s1
    800048f0:	d0dfd0ef          	jal	800025fc <iupdate>
iunlockput(ip);
    800048f4:	8526                	mv	a0,s1
    800048f6:	850fe0ef          	jal	80002946 <iunlockput>
end_op();
    800048fa:	f60fe0ef          	jal	8000305a <end_op>
return 0;
    800048fe:	4781                	li	a5,0
    80004900:	74b2                	ld	s1,296(sp)
    80004902:	7912                	ld	s2,288(sp)
    80004904:	69f2                	ld	s3,280(sp)
    80004906:	853e                	mv	a0,a5
    80004908:	70f2                	ld	ra,312(sp)
    8000490a:	7452                	ld	s0,304(sp)
    8000490c:	6131                	addi	sp,sp,320
    8000490e:	8082                	ret
  end_op();
    80004910:	f4afe0ef          	jal	8000305a <end_op>
  return -1;
    80004914:	57fd                	li	a5,-1
    80004916:	74b2                	ld	s1,296(sp)
    80004918:	b7fd                	j	80004906 <sys_symlink+0xae>
  iunlockput(ip);
    8000491a:	8526                	mv	a0,s1
    8000491c:	82afe0ef          	jal	80002946 <iunlockput>
  end_op();
    80004920:	f3afe0ef          	jal	8000305a <end_op>
  return -1;
    80004924:	57fd                	li	a5,-1
    80004926:	74b2                	ld	s1,296(sp)
    80004928:	bff9                	j	80004906 <sys_symlink+0xae>
  iunlockput(ip);
    8000492a:	8526                	mv	a0,s1
    8000492c:	81afe0ef          	jal	80002946 <iunlockput>
  end_op();
    80004930:	f2afe0ef          	jal	8000305a <end_op>
  return -1;
    80004934:	57fd                	li	a5,-1
    80004936:	74b2                	ld	s1,296(sp)
    80004938:	7912                	ld	s2,288(sp)
    8000493a:	69f2                	ld	s3,280(sp)
    8000493c:	b7e9                	j	80004906 <sys_symlink+0xae>
	...

0000000080004940 <kernelvec>:
    80004940:	7111                	addi	sp,sp,-256
    80004942:	e006                	sd	ra,0(sp)
    80004944:	e40a                	sd	sp,8(sp)
    80004946:	e80e                	sd	gp,16(sp)
    80004948:	ec12                	sd	tp,24(sp)
    8000494a:	f016                	sd	t0,32(sp)
    8000494c:	f41a                	sd	t1,40(sp)
    8000494e:	f81e                	sd	t2,48(sp)
    80004950:	e4aa                	sd	a0,72(sp)
    80004952:	e8ae                	sd	a1,80(sp)
    80004954:	ecb2                	sd	a2,88(sp)
    80004956:	f0b6                	sd	a3,96(sp)
    80004958:	f4ba                	sd	a4,104(sp)
    8000495a:	f8be                	sd	a5,112(sp)
    8000495c:	fcc2                	sd	a6,120(sp)
    8000495e:	e146                	sd	a7,128(sp)
    80004960:	edf2                	sd	t3,216(sp)
    80004962:	f1f6                	sd	t4,224(sp)
    80004964:	f5fa                	sd	t5,232(sp)
    80004966:	f9fe                	sd	t6,240(sp)
    80004968:	922fd0ef          	jal	80001a8a <kerneltrap>
    8000496c:	6082                	ld	ra,0(sp)
    8000496e:	6122                	ld	sp,8(sp)
    80004970:	61c2                	ld	gp,16(sp)
    80004972:	7282                	ld	t0,32(sp)
    80004974:	7322                	ld	t1,40(sp)
    80004976:	73c2                	ld	t2,48(sp)
    80004978:	6526                	ld	a0,72(sp)
    8000497a:	65c6                	ld	a1,80(sp)
    8000497c:	6666                	ld	a2,88(sp)
    8000497e:	7686                	ld	a3,96(sp)
    80004980:	7726                	ld	a4,104(sp)
    80004982:	77c6                	ld	a5,112(sp)
    80004984:	7866                	ld	a6,120(sp)
    80004986:	688a                	ld	a7,128(sp)
    80004988:	6e6e                	ld	t3,216(sp)
    8000498a:	7e8e                	ld	t4,224(sp)
    8000498c:	7f2e                	ld	t5,232(sp)
    8000498e:	7fce                	ld	t6,240(sp)
    80004990:	6111                	addi	sp,sp,256
    80004992:	10200073          	sret
	...

000000008000499e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000499e:	1141                	addi	sp,sp,-16
    800049a0:	e406                	sd	ra,8(sp)
    800049a2:	e022                	sd	s0,0(sp)
    800049a4:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800049a6:	0c000737          	lui	a4,0xc000
    800049aa:	4785                	li	a5,1
    800049ac:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800049ae:	c35c                	sw	a5,4(a4)
}
    800049b0:	60a2                	ld	ra,8(sp)
    800049b2:	6402                	ld	s0,0(sp)
    800049b4:	0141                	addi	sp,sp,16
    800049b6:	8082                	ret

00000000800049b8 <plicinithart>:

void
plicinithart(void)
{
    800049b8:	1141                	addi	sp,sp,-16
    800049ba:	e406                	sd	ra,8(sp)
    800049bc:	e022                	sd	s0,0(sp)
    800049be:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800049c0:	b68fc0ef          	jal	80000d28 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800049c4:	0085171b          	slliw	a4,a0,0x8
    800049c8:	0c0027b7          	lui	a5,0xc002
    800049cc:	97ba                	add	a5,a5,a4
    800049ce:	40200713          	li	a4,1026
    800049d2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800049d6:	00d5151b          	slliw	a0,a0,0xd
    800049da:	0c2017b7          	lui	a5,0xc201
    800049de:	97aa                	add	a5,a5,a0
    800049e0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800049e4:	60a2                	ld	ra,8(sp)
    800049e6:	6402                	ld	s0,0(sp)
    800049e8:	0141                	addi	sp,sp,16
    800049ea:	8082                	ret

00000000800049ec <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800049ec:	1141                	addi	sp,sp,-16
    800049ee:	e406                	sd	ra,8(sp)
    800049f0:	e022                	sd	s0,0(sp)
    800049f2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800049f4:	b34fc0ef          	jal	80000d28 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800049f8:	00d5151b          	slliw	a0,a0,0xd
    800049fc:	0c2017b7          	lui	a5,0xc201
    80004a00:	97aa                	add	a5,a5,a0
  return irq;
}
    80004a02:	43c8                	lw	a0,4(a5)
    80004a04:	60a2                	ld	ra,8(sp)
    80004a06:	6402                	ld	s0,0(sp)
    80004a08:	0141                	addi	sp,sp,16
    80004a0a:	8082                	ret

0000000080004a0c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80004a0c:	1101                	addi	sp,sp,-32
    80004a0e:	ec06                	sd	ra,24(sp)
    80004a10:	e822                	sd	s0,16(sp)
    80004a12:	e426                	sd	s1,8(sp)
    80004a14:	1000                	addi	s0,sp,32
    80004a16:	84aa                	mv	s1,a0
  int hart = cpuid();
    80004a18:	b10fc0ef          	jal	80000d28 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80004a1c:	00d5179b          	slliw	a5,a0,0xd
    80004a20:	0c201737          	lui	a4,0xc201
    80004a24:	97ba                	add	a5,a5,a4
    80004a26:	c3c4                	sw	s1,4(a5)
}
    80004a28:	60e2                	ld	ra,24(sp)
    80004a2a:	6442                	ld	s0,16(sp)
    80004a2c:	64a2                	ld	s1,8(sp)
    80004a2e:	6105                	addi	sp,sp,32
    80004a30:	8082                	ret

0000000080004a32 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80004a32:	1141                	addi	sp,sp,-16
    80004a34:	e406                	sd	ra,8(sp)
    80004a36:	e022                	sd	s0,0(sp)
    80004a38:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80004a3a:	479d                	li	a5,7
    80004a3c:	04a7ca63          	blt	a5,a0,80004a90 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80004a40:	0000f797          	auipc	a5,0xf
    80004a44:	3e078793          	addi	a5,a5,992 # 80013e20 <disk>
    80004a48:	97aa                	add	a5,a5,a0
    80004a4a:	0187c783          	lbu	a5,24(a5)
    80004a4e:	e7b9                	bnez	a5,80004a9c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80004a50:	00451693          	slli	a3,a0,0x4
    80004a54:	0000f797          	auipc	a5,0xf
    80004a58:	3cc78793          	addi	a5,a5,972 # 80013e20 <disk>
    80004a5c:	6398                	ld	a4,0(a5)
    80004a5e:	9736                	add	a4,a4,a3
    80004a60:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    80004a64:	6398                	ld	a4,0(a5)
    80004a66:	9736                	add	a4,a4,a3
    80004a68:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80004a6c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80004a70:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80004a74:	97aa                	add	a5,a5,a0
    80004a76:	4705                	li	a4,1
    80004a78:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80004a7c:	0000f517          	auipc	a0,0xf
    80004a80:	3bc50513          	addi	a0,a0,956 # 80013e38 <disk+0x18>
    80004a84:	8effc0ef          	jal	80001372 <wakeup>
}
    80004a88:	60a2                	ld	ra,8(sp)
    80004a8a:	6402                	ld	s0,0(sp)
    80004a8c:	0141                	addi	sp,sp,16
    80004a8e:	8082                	ret
    panic("free_desc 1");
    80004a90:	00003517          	auipc	a0,0x3
    80004a94:	b9850513          	addi	a0,a0,-1128 # 80007628 <etext+0x628>
    80004a98:	40f000ef          	jal	800056a6 <panic>
    panic("free_desc 2");
    80004a9c:	00003517          	auipc	a0,0x3
    80004aa0:	b9c50513          	addi	a0,a0,-1124 # 80007638 <etext+0x638>
    80004aa4:	403000ef          	jal	800056a6 <panic>

0000000080004aa8 <virtio_disk_init>:
{
    80004aa8:	1101                	addi	sp,sp,-32
    80004aaa:	ec06                	sd	ra,24(sp)
    80004aac:	e822                	sd	s0,16(sp)
    80004aae:	e426                	sd	s1,8(sp)
    80004ab0:	e04a                	sd	s2,0(sp)
    80004ab2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80004ab4:	00003597          	auipc	a1,0x3
    80004ab8:	b9458593          	addi	a1,a1,-1132 # 80007648 <etext+0x648>
    80004abc:	0000f517          	auipc	a0,0xf
    80004ac0:	48c50513          	addi	a0,a0,1164 # 80013f48 <disk+0x128>
    80004ac4:	68d000ef          	jal	80005950 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004ac8:	100017b7          	lui	a5,0x10001
    80004acc:	4398                	lw	a4,0(a5)
    80004ace:	2701                	sext.w	a4,a4
    80004ad0:	747277b7          	lui	a5,0x74727
    80004ad4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80004ad8:	14f71863          	bne	a4,a5,80004c28 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004adc:	100017b7          	lui	a5,0x10001
    80004ae0:	43dc                	lw	a5,4(a5)
    80004ae2:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004ae4:	4709                	li	a4,2
    80004ae6:	14e79163          	bne	a5,a4,80004c28 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004aea:	100017b7          	lui	a5,0x10001
    80004aee:	479c                	lw	a5,8(a5)
    80004af0:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004af2:	12e79b63          	bne	a5,a4,80004c28 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80004af6:	100017b7          	lui	a5,0x10001
    80004afa:	47d8                	lw	a4,12(a5)
    80004afc:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004afe:	554d47b7          	lui	a5,0x554d4
    80004b02:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80004b06:	12f71163          	bne	a4,a5,80004c28 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b0a:	100017b7          	lui	a5,0x10001
    80004b0e:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b12:	4705                	li	a4,1
    80004b14:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b16:	470d                	li	a4,3
    80004b18:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80004b1a:	10001737          	lui	a4,0x10001
    80004b1e:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80004b20:	c7ffe6b7          	lui	a3,0xc7ffe
    80004b24:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fe26ff>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80004b28:	8f75                	and	a4,a4,a3
    80004b2a:	100016b7          	lui	a3,0x10001
    80004b2e:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b30:	472d                	li	a4,11
    80004b32:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b34:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80004b38:	439c                	lw	a5,0(a5)
    80004b3a:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80004b3e:	8ba1                	andi	a5,a5,8
    80004b40:	0e078a63          	beqz	a5,80004c34 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80004b44:	100017b7          	lui	a5,0x10001
    80004b48:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80004b4c:	43fc                	lw	a5,68(a5)
    80004b4e:	2781                	sext.w	a5,a5
    80004b50:	0e079863          	bnez	a5,80004c40 <virtio_disk_init+0x198>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80004b54:	100017b7          	lui	a5,0x10001
    80004b58:	5bdc                	lw	a5,52(a5)
    80004b5a:	2781                	sext.w	a5,a5
  if(max == 0)
    80004b5c:	0e078863          	beqz	a5,80004c4c <virtio_disk_init+0x1a4>
  if(max < NUM)
    80004b60:	471d                	li	a4,7
    80004b62:	0ef77b63          	bgeu	a4,a5,80004c58 <virtio_disk_init+0x1b0>
  disk.desc = kalloc();
    80004b66:	d98fb0ef          	jal	800000fe <kalloc>
    80004b6a:	0000f497          	auipc	s1,0xf
    80004b6e:	2b648493          	addi	s1,s1,694 # 80013e20 <disk>
    80004b72:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80004b74:	d8afb0ef          	jal	800000fe <kalloc>
    80004b78:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80004b7a:	d84fb0ef          	jal	800000fe <kalloc>
    80004b7e:	87aa                	mv	a5,a0
    80004b80:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80004b82:	6088                	ld	a0,0(s1)
    80004b84:	0e050063          	beqz	a0,80004c64 <virtio_disk_init+0x1bc>
    80004b88:	0000f717          	auipc	a4,0xf
    80004b8c:	2a073703          	ld	a4,672(a4) # 80013e28 <disk+0x8>
    80004b90:	cb71                	beqz	a4,80004c64 <virtio_disk_init+0x1bc>
    80004b92:	cbe9                	beqz	a5,80004c64 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    80004b94:	6605                	lui	a2,0x1
    80004b96:	4581                	li	a1,0
    80004b98:	db6fb0ef          	jal	8000014e <memset>
  memset(disk.avail, 0, PGSIZE);
    80004b9c:	0000f497          	auipc	s1,0xf
    80004ba0:	28448493          	addi	s1,s1,644 # 80013e20 <disk>
    80004ba4:	6605                	lui	a2,0x1
    80004ba6:	4581                	li	a1,0
    80004ba8:	6488                	ld	a0,8(s1)
    80004baa:	da4fb0ef          	jal	8000014e <memset>
  memset(disk.used, 0, PGSIZE);
    80004bae:	6605                	lui	a2,0x1
    80004bb0:	4581                	li	a1,0
    80004bb2:	6888                	ld	a0,16(s1)
    80004bb4:	d9afb0ef          	jal	8000014e <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80004bb8:	100017b7          	lui	a5,0x10001
    80004bbc:	4721                	li	a4,8
    80004bbe:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80004bc0:	4098                	lw	a4,0(s1)
    80004bc2:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80004bc6:	40d8                	lw	a4,4(s1)
    80004bc8:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80004bcc:	649c                	ld	a5,8(s1)
    80004bce:	0007869b          	sext.w	a3,a5
    80004bd2:	10001737          	lui	a4,0x10001
    80004bd6:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80004bda:	9781                	srai	a5,a5,0x20
    80004bdc:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80004be0:	689c                	ld	a5,16(s1)
    80004be2:	0007869b          	sext.w	a3,a5
    80004be6:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80004bea:	9781                	srai	a5,a5,0x20
    80004bec:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80004bf0:	4785                	li	a5,1
    80004bf2:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80004bf4:	00f48c23          	sb	a5,24(s1)
    80004bf8:	00f48ca3          	sb	a5,25(s1)
    80004bfc:	00f48d23          	sb	a5,26(s1)
    80004c00:	00f48da3          	sb	a5,27(s1)
    80004c04:	00f48e23          	sb	a5,28(s1)
    80004c08:	00f48ea3          	sb	a5,29(s1)
    80004c0c:	00f48f23          	sb	a5,30(s1)
    80004c10:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80004c14:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80004c18:	07272823          	sw	s2,112(a4)
}
    80004c1c:	60e2                	ld	ra,24(sp)
    80004c1e:	6442                	ld	s0,16(sp)
    80004c20:	64a2                	ld	s1,8(sp)
    80004c22:	6902                	ld	s2,0(sp)
    80004c24:	6105                	addi	sp,sp,32
    80004c26:	8082                	ret
    panic("could not find virtio disk");
    80004c28:	00003517          	auipc	a0,0x3
    80004c2c:	a3050513          	addi	a0,a0,-1488 # 80007658 <etext+0x658>
    80004c30:	277000ef          	jal	800056a6 <panic>
    panic("virtio disk FEATURES_OK unset");
    80004c34:	00003517          	auipc	a0,0x3
    80004c38:	a4450513          	addi	a0,a0,-1468 # 80007678 <etext+0x678>
    80004c3c:	26b000ef          	jal	800056a6 <panic>
    panic("virtio disk should not be ready");
    80004c40:	00003517          	auipc	a0,0x3
    80004c44:	a5850513          	addi	a0,a0,-1448 # 80007698 <etext+0x698>
    80004c48:	25f000ef          	jal	800056a6 <panic>
    panic("virtio disk has no queue 0");
    80004c4c:	00003517          	auipc	a0,0x3
    80004c50:	a6c50513          	addi	a0,a0,-1428 # 800076b8 <etext+0x6b8>
    80004c54:	253000ef          	jal	800056a6 <panic>
    panic("virtio disk max queue too short");
    80004c58:	00003517          	auipc	a0,0x3
    80004c5c:	a8050513          	addi	a0,a0,-1408 # 800076d8 <etext+0x6d8>
    80004c60:	247000ef          	jal	800056a6 <panic>
    panic("virtio disk kalloc");
    80004c64:	00003517          	auipc	a0,0x3
    80004c68:	a9450513          	addi	a0,a0,-1388 # 800076f8 <etext+0x6f8>
    80004c6c:	23b000ef          	jal	800056a6 <panic>

0000000080004c70 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80004c70:	711d                	addi	sp,sp,-96
    80004c72:	ec86                	sd	ra,88(sp)
    80004c74:	e8a2                	sd	s0,80(sp)
    80004c76:	e4a6                	sd	s1,72(sp)
    80004c78:	e0ca                	sd	s2,64(sp)
    80004c7a:	fc4e                	sd	s3,56(sp)
    80004c7c:	f852                	sd	s4,48(sp)
    80004c7e:	f456                	sd	s5,40(sp)
    80004c80:	f05a                	sd	s6,32(sp)
    80004c82:	ec5e                	sd	s7,24(sp)
    80004c84:	e862                	sd	s8,16(sp)
    80004c86:	1080                	addi	s0,sp,96
    80004c88:	89aa                	mv	s3,a0
    80004c8a:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80004c8c:	00c52b83          	lw	s7,12(a0)
    80004c90:	001b9b9b          	slliw	s7,s7,0x1
    80004c94:	1b82                	slli	s7,s7,0x20
    80004c96:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    80004c9a:	0000f517          	auipc	a0,0xf
    80004c9e:	2ae50513          	addi	a0,a0,686 # 80013f48 <disk+0x128>
    80004ca2:	533000ef          	jal	800059d4 <acquire>
  for(int i = 0; i < NUM; i++){
    80004ca6:	44a1                	li	s1,8
      disk.free[i] = 0;
    80004ca8:	0000fa97          	auipc	s5,0xf
    80004cac:	178a8a93          	addi	s5,s5,376 # 80013e20 <disk>
  for(int i = 0; i < 3; i++){
    80004cb0:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80004cb2:	5c7d                	li	s8,-1
    80004cb4:	a095                	j	80004d18 <virtio_disk_rw+0xa8>
      disk.free[i] = 0;
    80004cb6:	00fa8733          	add	a4,s5,a5
    80004cba:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80004cbe:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80004cc0:	0207c563          	bltz	a5,80004cea <virtio_disk_rw+0x7a>
  for(int i = 0; i < 3; i++){
    80004cc4:	2905                	addiw	s2,s2,1
    80004cc6:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80004cc8:	05490c63          	beq	s2,s4,80004d20 <virtio_disk_rw+0xb0>
    idx[i] = alloc_desc();
    80004ccc:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80004cce:	0000f717          	auipc	a4,0xf
    80004cd2:	15270713          	addi	a4,a4,338 # 80013e20 <disk>
    80004cd6:	4781                	li	a5,0
    if(disk.free[i]){
    80004cd8:	01874683          	lbu	a3,24(a4)
    80004cdc:	fee9                	bnez	a3,80004cb6 <virtio_disk_rw+0x46>
  for(int i = 0; i < NUM; i++){
    80004cde:	2785                	addiw	a5,a5,1
    80004ce0:	0705                	addi	a4,a4,1
    80004ce2:	fe979be3          	bne	a5,s1,80004cd8 <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    80004ce6:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    80004cea:	01205d63          	blez	s2,80004d04 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80004cee:	fa042503          	lw	a0,-96(s0)
    80004cf2:	d41ff0ef          	jal	80004a32 <free_desc>
      for(int j = 0; j < i; j++)
    80004cf6:	4785                	li	a5,1
    80004cf8:	0127d663          	bge	a5,s2,80004d04 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80004cfc:	fa442503          	lw	a0,-92(s0)
    80004d00:	d33ff0ef          	jal	80004a32 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004d04:	0000f597          	auipc	a1,0xf
    80004d08:	24458593          	addi	a1,a1,580 # 80013f48 <disk+0x128>
    80004d0c:	0000f517          	auipc	a0,0xf
    80004d10:	12c50513          	addi	a0,a0,300 # 80013e38 <disk+0x18>
    80004d14:	e12fc0ef          	jal	80001326 <sleep>
  for(int i = 0; i < 3; i++){
    80004d18:	fa040613          	addi	a2,s0,-96
    80004d1c:	4901                	li	s2,0
    80004d1e:	b77d                	j	80004ccc <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004d20:	fa042503          	lw	a0,-96(s0)
    80004d24:	00451693          	slli	a3,a0,0x4

  if(write)
    80004d28:	0000f797          	auipc	a5,0xf
    80004d2c:	0f878793          	addi	a5,a5,248 # 80013e20 <disk>
    80004d30:	00a50713          	addi	a4,a0,10
    80004d34:	0712                	slli	a4,a4,0x4
    80004d36:	973e                	add	a4,a4,a5
    80004d38:	01603633          	snez	a2,s6
    80004d3c:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004d3e:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80004d42:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004d46:	6398                	ld	a4,0(a5)
    80004d48:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004d4a:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80004d4e:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80004d50:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004d52:	6390                	ld	a2,0(a5)
    80004d54:	00d605b3          	add	a1,a2,a3
    80004d58:	4741                	li	a4,16
    80004d5a:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004d5c:	4805                	li	a6,1
    80004d5e:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80004d62:	fa442703          	lw	a4,-92(s0)
    80004d66:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004d6a:	0712                	slli	a4,a4,0x4
    80004d6c:	963a                	add	a2,a2,a4
    80004d6e:	05898593          	addi	a1,s3,88
    80004d72:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80004d74:	0007b883          	ld	a7,0(a5)
    80004d78:	9746                	add	a4,a4,a7
    80004d7a:	40000613          	li	a2,1024
    80004d7e:	c710                	sw	a2,8(a4)
  if(write)
    80004d80:	001b3613          	seqz	a2,s6
    80004d84:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004d88:	01066633          	or	a2,a2,a6
    80004d8c:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80004d90:	fa842583          	lw	a1,-88(s0)
    80004d94:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004d98:	00250613          	addi	a2,a0,2
    80004d9c:	0612                	slli	a2,a2,0x4
    80004d9e:	963e                	add	a2,a2,a5
    80004da0:	577d                	li	a4,-1
    80004da2:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004da6:	0592                	slli	a1,a1,0x4
    80004da8:	98ae                	add	a7,a7,a1
    80004daa:	03068713          	addi	a4,a3,48
    80004dae:	973e                	add	a4,a4,a5
    80004db0:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80004db4:	6398                	ld	a4,0(a5)
    80004db6:	972e                	add	a4,a4,a1
    80004db8:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004dbc:	4689                	li	a3,2
    80004dbe:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80004dc2:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004dc6:	0109a223          	sw	a6,4(s3)
  disk.info[idx[0]].b = b;
    80004dca:	01363423          	sd	s3,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004dce:	6794                	ld	a3,8(a5)
    80004dd0:	0026d703          	lhu	a4,2(a3)
    80004dd4:	8b1d                	andi	a4,a4,7
    80004dd6:	0706                	slli	a4,a4,0x1
    80004dd8:	96ba                	add	a3,a3,a4
    80004dda:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80004dde:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004de2:	6798                	ld	a4,8(a5)
    80004de4:	00275783          	lhu	a5,2(a4)
    80004de8:	2785                	addiw	a5,a5,1
    80004dea:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004dee:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004df2:	100017b7          	lui	a5,0x10001
    80004df6:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004dfa:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    80004dfe:	0000f917          	auipc	s2,0xf
    80004e02:	14a90913          	addi	s2,s2,330 # 80013f48 <disk+0x128>
  while(b->disk == 1) {
    80004e06:	84c2                	mv	s1,a6
    80004e08:	01079a63          	bne	a5,a6,80004e1c <virtio_disk_rw+0x1ac>
    sleep(b, &disk.vdisk_lock);
    80004e0c:	85ca                	mv	a1,s2
    80004e0e:	854e                	mv	a0,s3
    80004e10:	d16fc0ef          	jal	80001326 <sleep>
  while(b->disk == 1) {
    80004e14:	0049a783          	lw	a5,4(s3)
    80004e18:	fe978ae3          	beq	a5,s1,80004e0c <virtio_disk_rw+0x19c>
  }

  disk.info[idx[0]].b = 0;
    80004e1c:	fa042903          	lw	s2,-96(s0)
    80004e20:	00290713          	addi	a4,s2,2
    80004e24:	0712                	slli	a4,a4,0x4
    80004e26:	0000f797          	auipc	a5,0xf
    80004e2a:	ffa78793          	addi	a5,a5,-6 # 80013e20 <disk>
    80004e2e:	97ba                	add	a5,a5,a4
    80004e30:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004e34:	0000f997          	auipc	s3,0xf
    80004e38:	fec98993          	addi	s3,s3,-20 # 80013e20 <disk>
    80004e3c:	00491713          	slli	a4,s2,0x4
    80004e40:	0009b783          	ld	a5,0(s3)
    80004e44:	97ba                	add	a5,a5,a4
    80004e46:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004e4a:	854a                	mv	a0,s2
    80004e4c:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80004e50:	be3ff0ef          	jal	80004a32 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80004e54:	8885                	andi	s1,s1,1
    80004e56:	f0fd                	bnez	s1,80004e3c <virtio_disk_rw+0x1cc>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80004e58:	0000f517          	auipc	a0,0xf
    80004e5c:	0f050513          	addi	a0,a0,240 # 80013f48 <disk+0x128>
    80004e60:	409000ef          	jal	80005a68 <release>
}
    80004e64:	60e6                	ld	ra,88(sp)
    80004e66:	6446                	ld	s0,80(sp)
    80004e68:	64a6                	ld	s1,72(sp)
    80004e6a:	6906                	ld	s2,64(sp)
    80004e6c:	79e2                	ld	s3,56(sp)
    80004e6e:	7a42                	ld	s4,48(sp)
    80004e70:	7aa2                	ld	s5,40(sp)
    80004e72:	7b02                	ld	s6,32(sp)
    80004e74:	6be2                	ld	s7,24(sp)
    80004e76:	6c42                	ld	s8,16(sp)
    80004e78:	6125                	addi	sp,sp,96
    80004e7a:	8082                	ret

0000000080004e7c <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80004e7c:	1101                	addi	sp,sp,-32
    80004e7e:	ec06                	sd	ra,24(sp)
    80004e80:	e822                	sd	s0,16(sp)
    80004e82:	e426                	sd	s1,8(sp)
    80004e84:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80004e86:	0000f497          	auipc	s1,0xf
    80004e8a:	f9a48493          	addi	s1,s1,-102 # 80013e20 <disk>
    80004e8e:	0000f517          	auipc	a0,0xf
    80004e92:	0ba50513          	addi	a0,a0,186 # 80013f48 <disk+0x128>
    80004e96:	33f000ef          	jal	800059d4 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80004e9a:	100017b7          	lui	a5,0x10001
    80004e9e:	53bc                	lw	a5,96(a5)
    80004ea0:	8b8d                	andi	a5,a5,3
    80004ea2:	10001737          	lui	a4,0x10001
    80004ea6:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80004ea8:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80004eac:	689c                	ld	a5,16(s1)
    80004eae:	0204d703          	lhu	a4,32(s1)
    80004eb2:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80004eb6:	04f70663          	beq	a4,a5,80004f02 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80004eba:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80004ebe:	6898                	ld	a4,16(s1)
    80004ec0:	0204d783          	lhu	a5,32(s1)
    80004ec4:	8b9d                	andi	a5,a5,7
    80004ec6:	078e                	slli	a5,a5,0x3
    80004ec8:	97ba                	add	a5,a5,a4
    80004eca:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80004ecc:	00278713          	addi	a4,a5,2
    80004ed0:	0712                	slli	a4,a4,0x4
    80004ed2:	9726                	add	a4,a4,s1
    80004ed4:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80004ed8:	e321                	bnez	a4,80004f18 <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80004eda:	0789                	addi	a5,a5,2
    80004edc:	0792                	slli	a5,a5,0x4
    80004ede:	97a6                	add	a5,a5,s1
    80004ee0:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80004ee2:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80004ee6:	c8cfc0ef          	jal	80001372 <wakeup>

    disk.used_idx += 1;
    80004eea:	0204d783          	lhu	a5,32(s1)
    80004eee:	2785                	addiw	a5,a5,1
    80004ef0:	17c2                	slli	a5,a5,0x30
    80004ef2:	93c1                	srli	a5,a5,0x30
    80004ef4:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80004ef8:	6898                	ld	a4,16(s1)
    80004efa:	00275703          	lhu	a4,2(a4)
    80004efe:	faf71ee3          	bne	a4,a5,80004eba <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80004f02:	0000f517          	auipc	a0,0xf
    80004f06:	04650513          	addi	a0,a0,70 # 80013f48 <disk+0x128>
    80004f0a:	35f000ef          	jal	80005a68 <release>
}
    80004f0e:	60e2                	ld	ra,24(sp)
    80004f10:	6442                	ld	s0,16(sp)
    80004f12:	64a2                	ld	s1,8(sp)
    80004f14:	6105                	addi	sp,sp,32
    80004f16:	8082                	ret
      panic("virtio_disk_intr status");
    80004f18:	00002517          	auipc	a0,0x2
    80004f1c:	7f850513          	addi	a0,a0,2040 # 80007710 <etext+0x710>
    80004f20:	786000ef          	jal	800056a6 <panic>

0000000080004f24 <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    80004f24:	1141                	addi	sp,sp,-16
    80004f26:	e406                	sd	ra,8(sp)
    80004f28:	e022                	sd	s0,0(sp)
    80004f2a:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    80004f2c:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80004f30:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    80004f34:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80004f38:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80004f3c:	577d                	li	a4,-1
    80004f3e:	177e                	slli	a4,a4,0x3f
    80004f40:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80004f42:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80004f46:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80004f4a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80004f4e:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    80004f52:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80004f56:	000f4737          	lui	a4,0xf4
    80004f5a:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80004f5e:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80004f60:	14d79073          	csrw	stimecmp,a5
}
    80004f64:	60a2                	ld	ra,8(sp)
    80004f66:	6402                	ld	s0,0(sp)
    80004f68:	0141                	addi	sp,sp,16
    80004f6a:	8082                	ret

0000000080004f6c <start>:
{
    80004f6c:	1141                	addi	sp,sp,-16
    80004f6e:	e406                	sd	ra,8(sp)
    80004f70:	e022                	sd	s0,0(sp)
    80004f72:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80004f74:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80004f78:	7779                	lui	a4,0xffffe
    80004f7a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffe279f>
    80004f7e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80004f80:	6705                	lui	a4,0x1
    80004f82:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80004f86:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80004f88:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80004f8c:	ffffb797          	auipc	a5,0xffffb
    80004f90:	37878793          	addi	a5,a5,888 # 80000304 <main>
    80004f94:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80004f98:	4781                	li	a5,0
    80004f9a:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80004f9e:	67c1                	lui	a5,0x10
    80004fa0:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80004fa2:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80004fa6:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80004faa:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80004fae:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80004fb2:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80004fb6:	57fd                	li	a5,-1
    80004fb8:	83a9                	srli	a5,a5,0xa
    80004fba:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80004fbe:	47bd                	li	a5,15
    80004fc0:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80004fc4:	f61ff0ef          	jal	80004f24 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80004fc8:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80004fcc:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80004fce:	823e                	mv	tp,a5
  asm volatile("mret");
    80004fd0:	30200073          	mret
}
    80004fd4:	60a2                	ld	ra,8(sp)
    80004fd6:	6402                	ld	s0,0(sp)
    80004fd8:	0141                	addi	sp,sp,16
    80004fda:	8082                	ret

0000000080004fdc <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80004fdc:	711d                	addi	sp,sp,-96
    80004fde:	ec86                	sd	ra,88(sp)
    80004fe0:	e8a2                	sd	s0,80(sp)
    80004fe2:	e0ca                	sd	s2,64(sp)
    80004fe4:	1080                	addi	s0,sp,96
  int i;

  for(i = 0; i < n; i++){
    80004fe6:	04c05863          	blez	a2,80005036 <consolewrite+0x5a>
    80004fea:	e4a6                	sd	s1,72(sp)
    80004fec:	fc4e                	sd	s3,56(sp)
    80004fee:	f852                	sd	s4,48(sp)
    80004ff0:	f456                	sd	s5,40(sp)
    80004ff2:	f05a                	sd	s6,32(sp)
    80004ff4:	ec5e                	sd	s7,24(sp)
    80004ff6:	8a2a                	mv	s4,a0
    80004ff8:	84ae                	mv	s1,a1
    80004ffa:	89b2                	mv	s3,a2
    80004ffc:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80004ffe:	faf40b93          	addi	s7,s0,-81
    80005002:	4b05                	li	s6,1
    80005004:	5afd                	li	s5,-1
    80005006:	86da                	mv	a3,s6
    80005008:	8626                	mv	a2,s1
    8000500a:	85d2                	mv	a1,s4
    8000500c:	855e                	mv	a0,s7
    8000500e:	eb2fc0ef          	jal	800016c0 <either_copyin>
    80005012:	03550463          	beq	a0,s5,8000503a <consolewrite+0x5e>
      break;
    uartputc(c);
    80005016:	faf44503          	lbu	a0,-81(s0)
    8000501a:	02d000ef          	jal	80005846 <uartputc>
  for(i = 0; i < n; i++){
    8000501e:	2905                	addiw	s2,s2,1
    80005020:	0485                	addi	s1,s1,1
    80005022:	ff2992e3          	bne	s3,s2,80005006 <consolewrite+0x2a>
    80005026:	894e                	mv	s2,s3
    80005028:	64a6                	ld	s1,72(sp)
    8000502a:	79e2                	ld	s3,56(sp)
    8000502c:	7a42                	ld	s4,48(sp)
    8000502e:	7aa2                	ld	s5,40(sp)
    80005030:	7b02                	ld	s6,32(sp)
    80005032:	6be2                	ld	s7,24(sp)
    80005034:	a809                	j	80005046 <consolewrite+0x6a>
    80005036:	4901                	li	s2,0
    80005038:	a039                	j	80005046 <consolewrite+0x6a>
    8000503a:	64a6                	ld	s1,72(sp)
    8000503c:	79e2                	ld	s3,56(sp)
    8000503e:	7a42                	ld	s4,48(sp)
    80005040:	7aa2                	ld	s5,40(sp)
    80005042:	7b02                	ld	s6,32(sp)
    80005044:	6be2                	ld	s7,24(sp)
  }

  return i;
}
    80005046:	854a                	mv	a0,s2
    80005048:	60e6                	ld	ra,88(sp)
    8000504a:	6446                	ld	s0,80(sp)
    8000504c:	6906                	ld	s2,64(sp)
    8000504e:	6125                	addi	sp,sp,96
    80005050:	8082                	ret

0000000080005052 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005052:	711d                	addi	sp,sp,-96
    80005054:	ec86                	sd	ra,88(sp)
    80005056:	e8a2                	sd	s0,80(sp)
    80005058:	e4a6                	sd	s1,72(sp)
    8000505a:	e0ca                	sd	s2,64(sp)
    8000505c:	fc4e                	sd	s3,56(sp)
    8000505e:	f852                	sd	s4,48(sp)
    80005060:	f456                	sd	s5,40(sp)
    80005062:	f05a                	sd	s6,32(sp)
    80005064:	1080                	addi	s0,sp,96
    80005066:	8aaa                	mv	s5,a0
    80005068:	8a2e                	mv	s4,a1
    8000506a:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    8000506c:	8b32                	mv	s6,a2
  acquire(&cons.lock);
    8000506e:	00017517          	auipc	a0,0x17
    80005072:	ef250513          	addi	a0,a0,-270 # 8001bf60 <cons>
    80005076:	15f000ef          	jal	800059d4 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000507a:	00017497          	auipc	s1,0x17
    8000507e:	ee648493          	addi	s1,s1,-282 # 8001bf60 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005082:	00017917          	auipc	s2,0x17
    80005086:	f7690913          	addi	s2,s2,-138 # 8001bff8 <cons+0x98>
  while(n > 0){
    8000508a:	0b305b63          	blez	s3,80005140 <consoleread+0xee>
    while(cons.r == cons.w){
    8000508e:	0984a783          	lw	a5,152(s1)
    80005092:	09c4a703          	lw	a4,156(s1)
    80005096:	0af71063          	bne	a4,a5,80005136 <consoleread+0xe4>
      if(killed(myproc())){
    8000509a:	cc3fb0ef          	jal	80000d5c <myproc>
    8000509e:	cbafc0ef          	jal	80001558 <killed>
    800050a2:	e12d                	bnez	a0,80005104 <consoleread+0xb2>
      sleep(&cons.r, &cons.lock);
    800050a4:	85a6                	mv	a1,s1
    800050a6:	854a                	mv	a0,s2
    800050a8:	a7efc0ef          	jal	80001326 <sleep>
    while(cons.r == cons.w){
    800050ac:	0984a783          	lw	a5,152(s1)
    800050b0:	09c4a703          	lw	a4,156(s1)
    800050b4:	fef703e3          	beq	a4,a5,8000509a <consoleread+0x48>
    800050b8:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800050ba:	00017717          	auipc	a4,0x17
    800050be:	ea670713          	addi	a4,a4,-346 # 8001bf60 <cons>
    800050c2:	0017869b          	addiw	a3,a5,1
    800050c6:	08d72c23          	sw	a3,152(a4)
    800050ca:	07f7f693          	andi	a3,a5,127
    800050ce:	9736                	add	a4,a4,a3
    800050d0:	01874703          	lbu	a4,24(a4)
    800050d4:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    800050d8:	4691                	li	a3,4
    800050da:	04db8663          	beq	s7,a3,80005126 <consoleread+0xd4>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    800050de:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800050e2:	4685                	li	a3,1
    800050e4:	faf40613          	addi	a2,s0,-81
    800050e8:	85d2                	mv	a1,s4
    800050ea:	8556                	mv	a0,s5
    800050ec:	d8afc0ef          	jal	80001676 <either_copyout>
    800050f0:	57fd                	li	a5,-1
    800050f2:	04f50663          	beq	a0,a5,8000513e <consoleread+0xec>
      break;

    dst++;
    800050f6:	0a05                	addi	s4,s4,1
    --n;
    800050f8:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    800050fa:	47a9                	li	a5,10
    800050fc:	04fb8b63          	beq	s7,a5,80005152 <consoleread+0x100>
    80005100:	6be2                	ld	s7,24(sp)
    80005102:	b761                	j	8000508a <consoleread+0x38>
        release(&cons.lock);
    80005104:	00017517          	auipc	a0,0x17
    80005108:	e5c50513          	addi	a0,a0,-420 # 8001bf60 <cons>
    8000510c:	15d000ef          	jal	80005a68 <release>
        return -1;
    80005110:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005112:	60e6                	ld	ra,88(sp)
    80005114:	6446                	ld	s0,80(sp)
    80005116:	64a6                	ld	s1,72(sp)
    80005118:	6906                	ld	s2,64(sp)
    8000511a:	79e2                	ld	s3,56(sp)
    8000511c:	7a42                	ld	s4,48(sp)
    8000511e:	7aa2                	ld	s5,40(sp)
    80005120:	7b02                	ld	s6,32(sp)
    80005122:	6125                	addi	sp,sp,96
    80005124:	8082                	ret
      if(n < target){
    80005126:	0169fa63          	bgeu	s3,s6,8000513a <consoleread+0xe8>
        cons.r--;
    8000512a:	00017717          	auipc	a4,0x17
    8000512e:	ecf72723          	sw	a5,-306(a4) # 8001bff8 <cons+0x98>
    80005132:	6be2                	ld	s7,24(sp)
    80005134:	a031                	j	80005140 <consoleread+0xee>
    80005136:	ec5e                	sd	s7,24(sp)
    80005138:	b749                	j	800050ba <consoleread+0x68>
    8000513a:	6be2                	ld	s7,24(sp)
    8000513c:	a011                	j	80005140 <consoleread+0xee>
    8000513e:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    80005140:	00017517          	auipc	a0,0x17
    80005144:	e2050513          	addi	a0,a0,-480 # 8001bf60 <cons>
    80005148:	121000ef          	jal	80005a68 <release>
  return target - n;
    8000514c:	413b053b          	subw	a0,s6,s3
    80005150:	b7c9                	j	80005112 <consoleread+0xc0>
    80005152:	6be2                	ld	s7,24(sp)
    80005154:	b7f5                	j	80005140 <consoleread+0xee>

0000000080005156 <consputc>:
{
    80005156:	1141                	addi	sp,sp,-16
    80005158:	e406                	sd	ra,8(sp)
    8000515a:	e022                	sd	s0,0(sp)
    8000515c:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    8000515e:	10000793          	li	a5,256
    80005162:	00f50863          	beq	a0,a5,80005172 <consputc+0x1c>
    uartputc_sync(c);
    80005166:	5fe000ef          	jal	80005764 <uartputc_sync>
}
    8000516a:	60a2                	ld	ra,8(sp)
    8000516c:	6402                	ld	s0,0(sp)
    8000516e:	0141                	addi	sp,sp,16
    80005170:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005172:	4521                	li	a0,8
    80005174:	5f0000ef          	jal	80005764 <uartputc_sync>
    80005178:	02000513          	li	a0,32
    8000517c:	5e8000ef          	jal	80005764 <uartputc_sync>
    80005180:	4521                	li	a0,8
    80005182:	5e2000ef          	jal	80005764 <uartputc_sync>
    80005186:	b7d5                	j	8000516a <consputc+0x14>

0000000080005188 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005188:	7179                	addi	sp,sp,-48
    8000518a:	f406                	sd	ra,40(sp)
    8000518c:	f022                	sd	s0,32(sp)
    8000518e:	ec26                	sd	s1,24(sp)
    80005190:	1800                	addi	s0,sp,48
    80005192:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005194:	00017517          	auipc	a0,0x17
    80005198:	dcc50513          	addi	a0,a0,-564 # 8001bf60 <cons>
    8000519c:	039000ef          	jal	800059d4 <acquire>

  switch(c){
    800051a0:	47d5                	li	a5,21
    800051a2:	08f48e63          	beq	s1,a5,8000523e <consoleintr+0xb6>
    800051a6:	0297c563          	blt	a5,s1,800051d0 <consoleintr+0x48>
    800051aa:	47a1                	li	a5,8
    800051ac:	0ef48863          	beq	s1,a5,8000529c <consoleintr+0x114>
    800051b0:	47c1                	li	a5,16
    800051b2:	10f49963          	bne	s1,a5,800052c4 <consoleintr+0x13c>
  case C('P'):  // Print process list.
    procdump();
    800051b6:	d54fc0ef          	jal	8000170a <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800051ba:	00017517          	auipc	a0,0x17
    800051be:	da650513          	addi	a0,a0,-602 # 8001bf60 <cons>
    800051c2:	0a7000ef          	jal	80005a68 <release>
}
    800051c6:	70a2                	ld	ra,40(sp)
    800051c8:	7402                	ld	s0,32(sp)
    800051ca:	64e2                	ld	s1,24(sp)
    800051cc:	6145                	addi	sp,sp,48
    800051ce:	8082                	ret
  switch(c){
    800051d0:	07f00793          	li	a5,127
    800051d4:	0cf48463          	beq	s1,a5,8000529c <consoleintr+0x114>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800051d8:	00017717          	auipc	a4,0x17
    800051dc:	d8870713          	addi	a4,a4,-632 # 8001bf60 <cons>
    800051e0:	0a072783          	lw	a5,160(a4)
    800051e4:	09872703          	lw	a4,152(a4)
    800051e8:	9f99                	subw	a5,a5,a4
    800051ea:	07f00713          	li	a4,127
    800051ee:	fcf766e3          	bltu	a4,a5,800051ba <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    800051f2:	47b5                	li	a5,13
    800051f4:	0cf48b63          	beq	s1,a5,800052ca <consoleintr+0x142>
      consputc(c);
    800051f8:	8526                	mv	a0,s1
    800051fa:	f5dff0ef          	jal	80005156 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800051fe:	00017797          	auipc	a5,0x17
    80005202:	d6278793          	addi	a5,a5,-670 # 8001bf60 <cons>
    80005206:	0a07a683          	lw	a3,160(a5)
    8000520a:	0016871b          	addiw	a4,a3,1
    8000520e:	863a                	mv	a2,a4
    80005210:	0ae7a023          	sw	a4,160(a5)
    80005214:	07f6f693          	andi	a3,a3,127
    80005218:	97b6                	add	a5,a5,a3
    8000521a:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    8000521e:	47a9                	li	a5,10
    80005220:	0cf48963          	beq	s1,a5,800052f2 <consoleintr+0x16a>
    80005224:	4791                	li	a5,4
    80005226:	0cf48663          	beq	s1,a5,800052f2 <consoleintr+0x16a>
    8000522a:	00017797          	auipc	a5,0x17
    8000522e:	dce7a783          	lw	a5,-562(a5) # 8001bff8 <cons+0x98>
    80005232:	9f1d                	subw	a4,a4,a5
    80005234:	08000793          	li	a5,128
    80005238:	f8f711e3          	bne	a4,a5,800051ba <consoleintr+0x32>
    8000523c:	a85d                	j	800052f2 <consoleintr+0x16a>
    8000523e:	e84a                	sd	s2,16(sp)
    80005240:	e44e                	sd	s3,8(sp)
    while(cons.e != cons.w &&
    80005242:	00017717          	auipc	a4,0x17
    80005246:	d1e70713          	addi	a4,a4,-738 # 8001bf60 <cons>
    8000524a:	0a072783          	lw	a5,160(a4)
    8000524e:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005252:	00017497          	auipc	s1,0x17
    80005256:	d0e48493          	addi	s1,s1,-754 # 8001bf60 <cons>
    while(cons.e != cons.w &&
    8000525a:	4929                	li	s2,10
      consputc(BACKSPACE);
    8000525c:	10000993          	li	s3,256
    while(cons.e != cons.w &&
    80005260:	02f70863          	beq	a4,a5,80005290 <consoleintr+0x108>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005264:	37fd                	addiw	a5,a5,-1
    80005266:	07f7f713          	andi	a4,a5,127
    8000526a:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    8000526c:	01874703          	lbu	a4,24(a4)
    80005270:	03270363          	beq	a4,s2,80005296 <consoleintr+0x10e>
      cons.e--;
    80005274:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005278:	854e                	mv	a0,s3
    8000527a:	eddff0ef          	jal	80005156 <consputc>
    while(cons.e != cons.w &&
    8000527e:	0a04a783          	lw	a5,160(s1)
    80005282:	09c4a703          	lw	a4,156(s1)
    80005286:	fcf71fe3          	bne	a4,a5,80005264 <consoleintr+0xdc>
    8000528a:	6942                	ld	s2,16(sp)
    8000528c:	69a2                	ld	s3,8(sp)
    8000528e:	b735                	j	800051ba <consoleintr+0x32>
    80005290:	6942                	ld	s2,16(sp)
    80005292:	69a2                	ld	s3,8(sp)
    80005294:	b71d                	j	800051ba <consoleintr+0x32>
    80005296:	6942                	ld	s2,16(sp)
    80005298:	69a2                	ld	s3,8(sp)
    8000529a:	b705                	j	800051ba <consoleintr+0x32>
    if(cons.e != cons.w){
    8000529c:	00017717          	auipc	a4,0x17
    800052a0:	cc470713          	addi	a4,a4,-828 # 8001bf60 <cons>
    800052a4:	0a072783          	lw	a5,160(a4)
    800052a8:	09c72703          	lw	a4,156(a4)
    800052ac:	f0f707e3          	beq	a4,a5,800051ba <consoleintr+0x32>
      cons.e--;
    800052b0:	37fd                	addiw	a5,a5,-1
    800052b2:	00017717          	auipc	a4,0x17
    800052b6:	d4f72723          	sw	a5,-690(a4) # 8001c000 <cons+0xa0>
      consputc(BACKSPACE);
    800052ba:	10000513          	li	a0,256
    800052be:	e99ff0ef          	jal	80005156 <consputc>
    800052c2:	bde5                	j	800051ba <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800052c4:	ee048be3          	beqz	s1,800051ba <consoleintr+0x32>
    800052c8:	bf01                	j	800051d8 <consoleintr+0x50>
      consputc(c);
    800052ca:	4529                	li	a0,10
    800052cc:	e8bff0ef          	jal	80005156 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800052d0:	00017797          	auipc	a5,0x17
    800052d4:	c9078793          	addi	a5,a5,-880 # 8001bf60 <cons>
    800052d8:	0a07a703          	lw	a4,160(a5)
    800052dc:	0017069b          	addiw	a3,a4,1
    800052e0:	8636                	mv	a2,a3
    800052e2:	0ad7a023          	sw	a3,160(a5)
    800052e6:	07f77713          	andi	a4,a4,127
    800052ea:	97ba                	add	a5,a5,a4
    800052ec:	4729                	li	a4,10
    800052ee:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    800052f2:	00017797          	auipc	a5,0x17
    800052f6:	d0c7a523          	sw	a2,-758(a5) # 8001bffc <cons+0x9c>
        wakeup(&cons.r);
    800052fa:	00017517          	auipc	a0,0x17
    800052fe:	cfe50513          	addi	a0,a0,-770 # 8001bff8 <cons+0x98>
    80005302:	870fc0ef          	jal	80001372 <wakeup>
    80005306:	bd55                	j	800051ba <consoleintr+0x32>

0000000080005308 <consoleinit>:

void
consoleinit(void)
{
    80005308:	1141                	addi	sp,sp,-16
    8000530a:	e406                	sd	ra,8(sp)
    8000530c:	e022                	sd	s0,0(sp)
    8000530e:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005310:	00002597          	auipc	a1,0x2
    80005314:	41858593          	addi	a1,a1,1048 # 80007728 <etext+0x728>
    80005318:	00017517          	auipc	a0,0x17
    8000531c:	c4850513          	addi	a0,a0,-952 # 8001bf60 <cons>
    80005320:	630000ef          	jal	80005950 <initlock>

  uartinit();
    80005324:	3ea000ef          	jal	8000570e <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005328:	0000e797          	auipc	a5,0xe
    8000532c:	aa078793          	addi	a5,a5,-1376 # 80012dc8 <devsw>
    80005330:	00000717          	auipc	a4,0x0
    80005334:	d2270713          	addi	a4,a4,-734 # 80005052 <consoleread>
    80005338:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000533a:	00000717          	auipc	a4,0x0
    8000533e:	ca270713          	addi	a4,a4,-862 # 80004fdc <consolewrite>
    80005342:	ef98                	sd	a4,24(a5)
}
    80005344:	60a2                	ld	ra,8(sp)
    80005346:	6402                	ld	s0,0(sp)
    80005348:	0141                	addi	sp,sp,16
    8000534a:	8082                	ret

000000008000534c <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    8000534c:	7179                	addi	sp,sp,-48
    8000534e:	f406                	sd	ra,40(sp)
    80005350:	f022                	sd	s0,32(sp)
    80005352:	ec26                	sd	s1,24(sp)
    80005354:	e84a                	sd	s2,16(sp)
    80005356:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80005358:	c219                	beqz	a2,8000535e <printint+0x12>
    8000535a:	06054a63          	bltz	a0,800053ce <printint+0x82>
    x = -xx;
  else
    x = xx;
    8000535e:	4e01                	li	t3,0

  i = 0;
    80005360:	fd040313          	addi	t1,s0,-48
    x = xx;
    80005364:	869a                	mv	a3,t1
  i = 0;
    80005366:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    80005368:	00002817          	auipc	a6,0x2
    8000536c:	52080813          	addi	a6,a6,1312 # 80007888 <digits>
    80005370:	88be                	mv	a7,a5
    80005372:	0017861b          	addiw	a2,a5,1
    80005376:	87b2                	mv	a5,a2
    80005378:	02b57733          	remu	a4,a0,a1
    8000537c:	9742                	add	a4,a4,a6
    8000537e:	00074703          	lbu	a4,0(a4)
    80005382:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    80005386:	872a                	mv	a4,a0
    80005388:	02b55533          	divu	a0,a0,a1
    8000538c:	0685                	addi	a3,a3,1
    8000538e:	feb771e3          	bgeu	a4,a1,80005370 <printint+0x24>

  if(sign)
    80005392:	000e0c63          	beqz	t3,800053aa <printint+0x5e>
    buf[i++] = '-';
    80005396:	fe060793          	addi	a5,a2,-32
    8000539a:	00878633          	add	a2,a5,s0
    8000539e:	02d00793          	li	a5,45
    800053a2:	fef60823          	sb	a5,-16(a2)
    800053a6:	0028879b          	addiw	a5,a7,2

  while(--i >= 0)
    800053aa:	fff7891b          	addiw	s2,a5,-1
    800053ae:	006784b3          	add	s1,a5,t1
    consputc(buf[i]);
    800053b2:	fff4c503          	lbu	a0,-1(s1)
    800053b6:	da1ff0ef          	jal	80005156 <consputc>
  while(--i >= 0)
    800053ba:	397d                	addiw	s2,s2,-1
    800053bc:	14fd                	addi	s1,s1,-1
    800053be:	fe095ae3          	bgez	s2,800053b2 <printint+0x66>
}
    800053c2:	70a2                	ld	ra,40(sp)
    800053c4:	7402                	ld	s0,32(sp)
    800053c6:	64e2                	ld	s1,24(sp)
    800053c8:	6942                	ld	s2,16(sp)
    800053ca:	6145                	addi	sp,sp,48
    800053cc:	8082                	ret
    x = -xx;
    800053ce:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    800053d2:	4e05                	li	t3,1
    x = -xx;
    800053d4:	b771                	j	80005360 <printint+0x14>

00000000800053d6 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    800053d6:	7155                	addi	sp,sp,-208
    800053d8:	e506                	sd	ra,136(sp)
    800053da:	e122                	sd	s0,128(sp)
    800053dc:	f0d2                	sd	s4,96(sp)
    800053de:	0900                	addi	s0,sp,144
    800053e0:	8a2a                	mv	s4,a0
    800053e2:	e40c                	sd	a1,8(s0)
    800053e4:	e810                	sd	a2,16(s0)
    800053e6:	ec14                	sd	a3,24(s0)
    800053e8:	f018                	sd	a4,32(s0)
    800053ea:	f41c                	sd	a5,40(s0)
    800053ec:	03043823          	sd	a6,48(s0)
    800053f0:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    800053f4:	00017797          	auipc	a5,0x17
    800053f8:	c2c7a783          	lw	a5,-980(a5) # 8001c020 <pr+0x18>
    800053fc:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    80005400:	e3a1                	bnez	a5,80005440 <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80005402:	00840793          	addi	a5,s0,8
    80005406:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000540a:	00054503          	lbu	a0,0(a0)
    8000540e:	26050663          	beqz	a0,8000567a <printf+0x2a4>
    80005412:	fca6                	sd	s1,120(sp)
    80005414:	f8ca                	sd	s2,112(sp)
    80005416:	f4ce                	sd	s3,104(sp)
    80005418:	ecd6                	sd	s5,88(sp)
    8000541a:	e8da                	sd	s6,80(sp)
    8000541c:	e0e2                	sd	s8,64(sp)
    8000541e:	fc66                	sd	s9,56(sp)
    80005420:	f86a                	sd	s10,48(sp)
    80005422:	f46e                	sd	s11,40(sp)
    80005424:	4981                	li	s3,0
    if(cx != '%'){
    80005426:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    8000542a:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    8000542e:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    80005432:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80005436:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    8000543a:	07000d93          	li	s11,112
    8000543e:	a80d                	j	80005470 <printf+0x9a>
    acquire(&pr.lock);
    80005440:	00017517          	auipc	a0,0x17
    80005444:	bc850513          	addi	a0,a0,-1080 # 8001c008 <pr>
    80005448:	58c000ef          	jal	800059d4 <acquire>
  va_start(ap, fmt);
    8000544c:	00840793          	addi	a5,s0,8
    80005450:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005454:	000a4503          	lbu	a0,0(s4)
    80005458:	fd4d                	bnez	a0,80005412 <printf+0x3c>
    8000545a:	ac3d                	j	80005698 <printf+0x2c2>
      consputc(cx);
    8000545c:	cfbff0ef          	jal	80005156 <consputc>
      continue;
    80005460:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005462:	2485                	addiw	s1,s1,1
    80005464:	89a6                	mv	s3,s1
    80005466:	94d2                	add	s1,s1,s4
    80005468:	0004c503          	lbu	a0,0(s1)
    8000546c:	1e050b63          	beqz	a0,80005662 <printf+0x28c>
    if(cx != '%'){
    80005470:	ff5516e3          	bne	a0,s5,8000545c <printf+0x86>
    i++;
    80005474:	0019879b          	addiw	a5,s3,1
    80005478:	84be                	mv	s1,a5
    c0 = fmt[i+0] & 0xff;
    8000547a:	00fa0733          	add	a4,s4,a5
    8000547e:	00074903          	lbu	s2,0(a4)
    if(c0) c1 = fmt[i+1] & 0xff;
    80005482:	1e090063          	beqz	s2,80005662 <printf+0x28c>
    80005486:	00174703          	lbu	a4,1(a4)
    c1 = c2 = 0;
    8000548a:	86ba                	mv	a3,a4
    if(c1) c2 = fmt[i+2] & 0xff;
    8000548c:	c701                	beqz	a4,80005494 <printf+0xbe>
    8000548e:	97d2                	add	a5,a5,s4
    80005490:	0027c683          	lbu	a3,2(a5)
    if(c0 == 'd'){
    80005494:	03690763          	beq	s2,s6,800054c2 <printf+0xec>
    } else if(c0 == 'l' && c1 == 'd'){
    80005498:	05890163          	beq	s2,s8,800054da <printf+0x104>
    } else if(c0 == 'u'){
    8000549c:	0d990b63          	beq	s2,s9,80005572 <printf+0x19c>
    } else if(c0 == 'x'){
    800054a0:	13a90163          	beq	s2,s10,800055c2 <printf+0x1ec>
    } else if(c0 == 'p'){
    800054a4:	13b90b63          	beq	s2,s11,800055da <printf+0x204>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    800054a8:	07300793          	li	a5,115
    800054ac:	16f90a63          	beq	s2,a5,80005620 <printf+0x24a>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    800054b0:	1b590463          	beq	s2,s5,80005658 <printf+0x282>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    800054b4:	8556                	mv	a0,s5
    800054b6:	ca1ff0ef          	jal	80005156 <consputc>
      consputc(c0);
    800054ba:	854a                	mv	a0,s2
    800054bc:	c9bff0ef          	jal	80005156 <consputc>
    800054c0:	b74d                	j	80005462 <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    800054c2:	f8843783          	ld	a5,-120(s0)
    800054c6:	00878713          	addi	a4,a5,8
    800054ca:	f8e43423          	sd	a4,-120(s0)
    800054ce:	4605                	li	a2,1
    800054d0:	45a9                	li	a1,10
    800054d2:	4388                	lw	a0,0(a5)
    800054d4:	e79ff0ef          	jal	8000534c <printint>
    800054d8:	b769                	j	80005462 <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    800054da:	03670663          	beq	a4,s6,80005506 <printf+0x130>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800054de:	05870263          	beq	a4,s8,80005522 <printf+0x14c>
    } else if(c0 == 'l' && c1 == 'u'){
    800054e2:	0b970463          	beq	a4,s9,8000558a <printf+0x1b4>
    } else if(c0 == 'l' && c1 == 'x'){
    800054e6:	fda717e3          	bne	a4,s10,800054b4 <printf+0xde>
      printint(va_arg(ap, uint64), 16, 0);
    800054ea:	f8843783          	ld	a5,-120(s0)
    800054ee:	00878713          	addi	a4,a5,8
    800054f2:	f8e43423          	sd	a4,-120(s0)
    800054f6:	4601                	li	a2,0
    800054f8:	45c1                	li	a1,16
    800054fa:	6388                	ld	a0,0(a5)
    800054fc:	e51ff0ef          	jal	8000534c <printint>
      i += 1;
    80005500:	0029849b          	addiw	s1,s3,2
    80005504:	bfb9                	j	80005462 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80005506:	f8843783          	ld	a5,-120(s0)
    8000550a:	00878713          	addi	a4,a5,8
    8000550e:	f8e43423          	sd	a4,-120(s0)
    80005512:	4605                	li	a2,1
    80005514:	45a9                	li	a1,10
    80005516:	6388                	ld	a0,0(a5)
    80005518:	e35ff0ef          	jal	8000534c <printint>
      i += 1;
    8000551c:	0029849b          	addiw	s1,s3,2
    80005520:	b789                	j	80005462 <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80005522:	06400793          	li	a5,100
    80005526:	02f68863          	beq	a3,a5,80005556 <printf+0x180>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    8000552a:	07500793          	li	a5,117
    8000552e:	06f68c63          	beq	a3,a5,800055a6 <printf+0x1d0>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    80005532:	07800793          	li	a5,120
    80005536:	f6f69fe3          	bne	a3,a5,800054b4 <printf+0xde>
      printint(va_arg(ap, uint64), 16, 0);
    8000553a:	f8843783          	ld	a5,-120(s0)
    8000553e:	00878713          	addi	a4,a5,8
    80005542:	f8e43423          	sd	a4,-120(s0)
    80005546:	4601                	li	a2,0
    80005548:	45c1                	li	a1,16
    8000554a:	6388                	ld	a0,0(a5)
    8000554c:	e01ff0ef          	jal	8000534c <printint>
      i += 2;
    80005550:	0039849b          	addiw	s1,s3,3
    80005554:	b739                	j	80005462 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80005556:	f8843783          	ld	a5,-120(s0)
    8000555a:	00878713          	addi	a4,a5,8
    8000555e:	f8e43423          	sd	a4,-120(s0)
    80005562:	4605                	li	a2,1
    80005564:	45a9                	li	a1,10
    80005566:	6388                	ld	a0,0(a5)
    80005568:	de5ff0ef          	jal	8000534c <printint>
      i += 2;
    8000556c:	0039849b          	addiw	s1,s3,3
    80005570:	bdcd                	j	80005462 <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    80005572:	f8843783          	ld	a5,-120(s0)
    80005576:	00878713          	addi	a4,a5,8
    8000557a:	f8e43423          	sd	a4,-120(s0)
    8000557e:	4601                	li	a2,0
    80005580:	45a9                	li	a1,10
    80005582:	4388                	lw	a0,0(a5)
    80005584:	dc9ff0ef          	jal	8000534c <printint>
    80005588:	bde9                	j	80005462 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    8000558a:	f8843783          	ld	a5,-120(s0)
    8000558e:	00878713          	addi	a4,a5,8
    80005592:	f8e43423          	sd	a4,-120(s0)
    80005596:	4601                	li	a2,0
    80005598:	45a9                	li	a1,10
    8000559a:	6388                	ld	a0,0(a5)
    8000559c:	db1ff0ef          	jal	8000534c <printint>
      i += 1;
    800055a0:	0029849b          	addiw	s1,s3,2
    800055a4:	bd7d                	j	80005462 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    800055a6:	f8843783          	ld	a5,-120(s0)
    800055aa:	00878713          	addi	a4,a5,8
    800055ae:	f8e43423          	sd	a4,-120(s0)
    800055b2:	4601                	li	a2,0
    800055b4:	45a9                	li	a1,10
    800055b6:	6388                	ld	a0,0(a5)
    800055b8:	d95ff0ef          	jal	8000534c <printint>
      i += 2;
    800055bc:	0039849b          	addiw	s1,s3,3
    800055c0:	b54d                	j	80005462 <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    800055c2:	f8843783          	ld	a5,-120(s0)
    800055c6:	00878713          	addi	a4,a5,8
    800055ca:	f8e43423          	sd	a4,-120(s0)
    800055ce:	4601                	li	a2,0
    800055d0:	45c1                	li	a1,16
    800055d2:	4388                	lw	a0,0(a5)
    800055d4:	d79ff0ef          	jal	8000534c <printint>
    800055d8:	b569                	j	80005462 <printf+0x8c>
    800055da:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    800055dc:	f8843783          	ld	a5,-120(s0)
    800055e0:	00878713          	addi	a4,a5,8
    800055e4:	f8e43423          	sd	a4,-120(s0)
    800055e8:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800055ec:	03000513          	li	a0,48
    800055f0:	b67ff0ef          	jal	80005156 <consputc>
  consputc('x');
    800055f4:	07800513          	li	a0,120
    800055f8:	b5fff0ef          	jal	80005156 <consputc>
    800055fc:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800055fe:	00002b97          	auipc	s7,0x2
    80005602:	28ab8b93          	addi	s7,s7,650 # 80007888 <digits>
    80005606:	03c9d793          	srli	a5,s3,0x3c
    8000560a:	97de                	add	a5,a5,s7
    8000560c:	0007c503          	lbu	a0,0(a5)
    80005610:	b47ff0ef          	jal	80005156 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005614:	0992                	slli	s3,s3,0x4
    80005616:	397d                	addiw	s2,s2,-1
    80005618:	fe0917e3          	bnez	s2,80005606 <printf+0x230>
    8000561c:	6ba6                	ld	s7,72(sp)
    8000561e:	b591                	j	80005462 <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    80005620:	f8843783          	ld	a5,-120(s0)
    80005624:	00878713          	addi	a4,a5,8
    80005628:	f8e43423          	sd	a4,-120(s0)
    8000562c:	0007b903          	ld	s2,0(a5)
    80005630:	00090d63          	beqz	s2,8000564a <printf+0x274>
      for(; *s; s++)
    80005634:	00094503          	lbu	a0,0(s2)
    80005638:	e20505e3          	beqz	a0,80005462 <printf+0x8c>
        consputc(*s);
    8000563c:	b1bff0ef          	jal	80005156 <consputc>
      for(; *s; s++)
    80005640:	0905                	addi	s2,s2,1
    80005642:	00094503          	lbu	a0,0(s2)
    80005646:	f97d                	bnez	a0,8000563c <printf+0x266>
    80005648:	bd29                	j	80005462 <printf+0x8c>
        s = "(null)";
    8000564a:	00002917          	auipc	s2,0x2
    8000564e:	0e690913          	addi	s2,s2,230 # 80007730 <etext+0x730>
      for(; *s; s++)
    80005652:	02800513          	li	a0,40
    80005656:	b7dd                	j	8000563c <printf+0x266>
      consputc('%');
    80005658:	02500513          	li	a0,37
    8000565c:	afbff0ef          	jal	80005156 <consputc>
    80005660:	b509                	j	80005462 <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    80005662:	f7843783          	ld	a5,-136(s0)
    80005666:	e385                	bnez	a5,80005686 <printf+0x2b0>
    80005668:	74e6                	ld	s1,120(sp)
    8000566a:	7946                	ld	s2,112(sp)
    8000566c:	79a6                	ld	s3,104(sp)
    8000566e:	6ae6                	ld	s5,88(sp)
    80005670:	6b46                	ld	s6,80(sp)
    80005672:	6c06                	ld	s8,64(sp)
    80005674:	7ce2                	ld	s9,56(sp)
    80005676:	7d42                	ld	s10,48(sp)
    80005678:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    8000567a:	4501                	li	a0,0
    8000567c:	60aa                	ld	ra,136(sp)
    8000567e:	640a                	ld	s0,128(sp)
    80005680:	7a06                	ld	s4,96(sp)
    80005682:	6169                	addi	sp,sp,208
    80005684:	8082                	ret
    80005686:	74e6                	ld	s1,120(sp)
    80005688:	7946                	ld	s2,112(sp)
    8000568a:	79a6                	ld	s3,104(sp)
    8000568c:	6ae6                	ld	s5,88(sp)
    8000568e:	6b46                	ld	s6,80(sp)
    80005690:	6c06                	ld	s8,64(sp)
    80005692:	7ce2                	ld	s9,56(sp)
    80005694:	7d42                	ld	s10,48(sp)
    80005696:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    80005698:	00017517          	auipc	a0,0x17
    8000569c:	97050513          	addi	a0,a0,-1680 # 8001c008 <pr>
    800056a0:	3c8000ef          	jal	80005a68 <release>
    800056a4:	bfd9                	j	8000567a <printf+0x2a4>

00000000800056a6 <panic>:

void
panic(char *s)
{
    800056a6:	1101                	addi	sp,sp,-32
    800056a8:	ec06                	sd	ra,24(sp)
    800056aa:	e822                	sd	s0,16(sp)
    800056ac:	e426                	sd	s1,8(sp)
    800056ae:	1000                	addi	s0,sp,32
    800056b0:	84aa                	mv	s1,a0
  pr.locking = 0;
    800056b2:	00017797          	auipc	a5,0x17
    800056b6:	9607a723          	sw	zero,-1682(a5) # 8001c020 <pr+0x18>
  printf("panic: ");
    800056ba:	00002517          	auipc	a0,0x2
    800056be:	07e50513          	addi	a0,a0,126 # 80007738 <etext+0x738>
    800056c2:	d15ff0ef          	jal	800053d6 <printf>
  printf("%s\n", s);
    800056c6:	85a6                	mv	a1,s1
    800056c8:	00002517          	auipc	a0,0x2
    800056cc:	07850513          	addi	a0,a0,120 # 80007740 <etext+0x740>
    800056d0:	d07ff0ef          	jal	800053d6 <printf>
  panicked = 1; // freeze uart output from other CPUs
    800056d4:	4785                	li	a5,1
    800056d6:	00002717          	auipc	a4,0x2
    800056da:	22f72b23          	sw	a5,566(a4) # 8000790c <panicked>
  for(;;)
    800056de:	a001                	j	800056de <panic+0x38>

00000000800056e0 <printfinit>:
    ;
}

void
printfinit(void)
{
    800056e0:	1101                	addi	sp,sp,-32
    800056e2:	ec06                	sd	ra,24(sp)
    800056e4:	e822                	sd	s0,16(sp)
    800056e6:	e426                	sd	s1,8(sp)
    800056e8:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800056ea:	00017497          	auipc	s1,0x17
    800056ee:	91e48493          	addi	s1,s1,-1762 # 8001c008 <pr>
    800056f2:	00002597          	auipc	a1,0x2
    800056f6:	05658593          	addi	a1,a1,86 # 80007748 <etext+0x748>
    800056fa:	8526                	mv	a0,s1
    800056fc:	254000ef          	jal	80005950 <initlock>
  pr.locking = 1;
    80005700:	4785                	li	a5,1
    80005702:	cc9c                	sw	a5,24(s1)
}
    80005704:	60e2                	ld	ra,24(sp)
    80005706:	6442                	ld	s0,16(sp)
    80005708:	64a2                	ld	s1,8(sp)
    8000570a:	6105                	addi	sp,sp,32
    8000570c:	8082                	ret

000000008000570e <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000570e:	1141                	addi	sp,sp,-16
    80005710:	e406                	sd	ra,8(sp)
    80005712:	e022                	sd	s0,0(sp)
    80005714:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005716:	100007b7          	lui	a5,0x10000
    8000571a:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000571e:	10000737          	lui	a4,0x10000
    80005722:	f8000693          	li	a3,-128
    80005726:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000572a:	468d                	li	a3,3
    8000572c:	10000637          	lui	a2,0x10000
    80005730:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005734:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005738:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000573c:	8732                	mv	a4,a2
    8000573e:	461d                	li	a2,7
    80005740:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005744:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80005748:	00002597          	auipc	a1,0x2
    8000574c:	00858593          	addi	a1,a1,8 # 80007750 <etext+0x750>
    80005750:	00017517          	auipc	a0,0x17
    80005754:	8d850513          	addi	a0,a0,-1832 # 8001c028 <uart_tx_lock>
    80005758:	1f8000ef          	jal	80005950 <initlock>
}
    8000575c:	60a2                	ld	ra,8(sp)
    8000575e:	6402                	ld	s0,0(sp)
    80005760:	0141                	addi	sp,sp,16
    80005762:	8082                	ret

0000000080005764 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005764:	1101                	addi	sp,sp,-32
    80005766:	ec06                	sd	ra,24(sp)
    80005768:	e822                	sd	s0,16(sp)
    8000576a:	e426                	sd	s1,8(sp)
    8000576c:	1000                	addi	s0,sp,32
    8000576e:	84aa                	mv	s1,a0
  push_off();
    80005770:	224000ef          	jal	80005994 <push_off>

  if(panicked){
    80005774:	00002797          	auipc	a5,0x2
    80005778:	1987a783          	lw	a5,408(a5) # 8000790c <panicked>
    8000577c:	e795                	bnez	a5,800057a8 <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000577e:	10000737          	lui	a4,0x10000
    80005782:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80005784:	00074783          	lbu	a5,0(a4)
    80005788:	0207f793          	andi	a5,a5,32
    8000578c:	dfe5                	beqz	a5,80005784 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    8000578e:	0ff4f513          	zext.b	a0,s1
    80005792:	100007b7          	lui	a5,0x10000
    80005796:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    8000579a:	27e000ef          	jal	80005a18 <pop_off>
}
    8000579e:	60e2                	ld	ra,24(sp)
    800057a0:	6442                	ld	s0,16(sp)
    800057a2:	64a2                	ld	s1,8(sp)
    800057a4:	6105                	addi	sp,sp,32
    800057a6:	8082                	ret
    for(;;)
    800057a8:	a001                	j	800057a8 <uartputc_sync+0x44>

00000000800057aa <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800057aa:	00002797          	auipc	a5,0x2
    800057ae:	1667b783          	ld	a5,358(a5) # 80007910 <uart_tx_r>
    800057b2:	00002717          	auipc	a4,0x2
    800057b6:	16673703          	ld	a4,358(a4) # 80007918 <uart_tx_w>
    800057ba:	08f70163          	beq	a4,a5,8000583c <uartstart+0x92>
{
    800057be:	7139                	addi	sp,sp,-64
    800057c0:	fc06                	sd	ra,56(sp)
    800057c2:	f822                	sd	s0,48(sp)
    800057c4:	f426                	sd	s1,40(sp)
    800057c6:	f04a                	sd	s2,32(sp)
    800057c8:	ec4e                	sd	s3,24(sp)
    800057ca:	e852                	sd	s4,16(sp)
    800057cc:	e456                	sd	s5,8(sp)
    800057ce:	e05a                	sd	s6,0(sp)
    800057d0:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800057d2:	10000937          	lui	s2,0x10000
    800057d6:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800057d8:	00017a97          	auipc	s5,0x17
    800057dc:	850a8a93          	addi	s5,s5,-1968 # 8001c028 <uart_tx_lock>
    uart_tx_r += 1;
    800057e0:	00002497          	auipc	s1,0x2
    800057e4:	13048493          	addi	s1,s1,304 # 80007910 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800057e8:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800057ec:	00002997          	auipc	s3,0x2
    800057f0:	12c98993          	addi	s3,s3,300 # 80007918 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800057f4:	00094703          	lbu	a4,0(s2)
    800057f8:	02077713          	andi	a4,a4,32
    800057fc:	c715                	beqz	a4,80005828 <uartstart+0x7e>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800057fe:	01f7f713          	andi	a4,a5,31
    80005802:	9756                	add	a4,a4,s5
    80005804:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80005808:	0785                	addi	a5,a5,1
    8000580a:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    8000580c:	8526                	mv	a0,s1
    8000580e:	b65fb0ef          	jal	80001372 <wakeup>
    WriteReg(THR, c);
    80005812:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80005816:	609c                	ld	a5,0(s1)
    80005818:	0009b703          	ld	a4,0(s3)
    8000581c:	fcf71ce3          	bne	a4,a5,800057f4 <uartstart+0x4a>
      ReadReg(ISR);
    80005820:	100007b7          	lui	a5,0x10000
    80005824:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
  }
}
    80005828:	70e2                	ld	ra,56(sp)
    8000582a:	7442                	ld	s0,48(sp)
    8000582c:	74a2                	ld	s1,40(sp)
    8000582e:	7902                	ld	s2,32(sp)
    80005830:	69e2                	ld	s3,24(sp)
    80005832:	6a42                	ld	s4,16(sp)
    80005834:	6aa2                	ld	s5,8(sp)
    80005836:	6b02                	ld	s6,0(sp)
    80005838:	6121                	addi	sp,sp,64
    8000583a:	8082                	ret
      ReadReg(ISR);
    8000583c:	100007b7          	lui	a5,0x10000
    80005840:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>
      return;
    80005844:	8082                	ret

0000000080005846 <uartputc>:
{
    80005846:	7179                	addi	sp,sp,-48
    80005848:	f406                	sd	ra,40(sp)
    8000584a:	f022                	sd	s0,32(sp)
    8000584c:	ec26                	sd	s1,24(sp)
    8000584e:	e84a                	sd	s2,16(sp)
    80005850:	e44e                	sd	s3,8(sp)
    80005852:	e052                	sd	s4,0(sp)
    80005854:	1800                	addi	s0,sp,48
    80005856:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80005858:	00016517          	auipc	a0,0x16
    8000585c:	7d050513          	addi	a0,a0,2000 # 8001c028 <uart_tx_lock>
    80005860:	174000ef          	jal	800059d4 <acquire>
  if(panicked){
    80005864:	00002797          	auipc	a5,0x2
    80005868:	0a87a783          	lw	a5,168(a5) # 8000790c <panicked>
    8000586c:	efbd                	bnez	a5,800058ea <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000586e:	00002717          	auipc	a4,0x2
    80005872:	0aa73703          	ld	a4,170(a4) # 80007918 <uart_tx_w>
    80005876:	00002797          	auipc	a5,0x2
    8000587a:	09a7b783          	ld	a5,154(a5) # 80007910 <uart_tx_r>
    8000587e:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80005882:	00016997          	auipc	s3,0x16
    80005886:	7a698993          	addi	s3,s3,1958 # 8001c028 <uart_tx_lock>
    8000588a:	00002497          	auipc	s1,0x2
    8000588e:	08648493          	addi	s1,s1,134 # 80007910 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80005892:	00002917          	auipc	s2,0x2
    80005896:	08690913          	addi	s2,s2,134 # 80007918 <uart_tx_w>
    8000589a:	00e79d63          	bne	a5,a4,800058b4 <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000589e:	85ce                	mv	a1,s3
    800058a0:	8526                	mv	a0,s1
    800058a2:	a85fb0ef          	jal	80001326 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800058a6:	00093703          	ld	a4,0(s2)
    800058aa:	609c                	ld	a5,0(s1)
    800058ac:	02078793          	addi	a5,a5,32
    800058b0:	fee787e3          	beq	a5,a4,8000589e <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800058b4:	00016497          	auipc	s1,0x16
    800058b8:	77448493          	addi	s1,s1,1908 # 8001c028 <uart_tx_lock>
    800058bc:	01f77793          	andi	a5,a4,31
    800058c0:	97a6                	add	a5,a5,s1
    800058c2:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800058c6:	0705                	addi	a4,a4,1
    800058c8:	00002797          	auipc	a5,0x2
    800058cc:	04e7b823          	sd	a4,80(a5) # 80007918 <uart_tx_w>
  uartstart();
    800058d0:	edbff0ef          	jal	800057aa <uartstart>
  release(&uart_tx_lock);
    800058d4:	8526                	mv	a0,s1
    800058d6:	192000ef          	jal	80005a68 <release>
}
    800058da:	70a2                	ld	ra,40(sp)
    800058dc:	7402                	ld	s0,32(sp)
    800058de:	64e2                	ld	s1,24(sp)
    800058e0:	6942                	ld	s2,16(sp)
    800058e2:	69a2                	ld	s3,8(sp)
    800058e4:	6a02                	ld	s4,0(sp)
    800058e6:	6145                	addi	sp,sp,48
    800058e8:	8082                	ret
    for(;;)
    800058ea:	a001                	j	800058ea <uartputc+0xa4>

00000000800058ec <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800058ec:	1141                	addi	sp,sp,-16
    800058ee:	e406                	sd	ra,8(sp)
    800058f0:	e022                	sd	s0,0(sp)
    800058f2:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800058f4:	100007b7          	lui	a5,0x10000
    800058f8:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800058fc:	8b85                	andi	a5,a5,1
    800058fe:	cb89                	beqz	a5,80005910 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80005900:	100007b7          	lui	a5,0x10000
    80005904:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80005908:	60a2                	ld	ra,8(sp)
    8000590a:	6402                	ld	s0,0(sp)
    8000590c:	0141                	addi	sp,sp,16
    8000590e:	8082                	ret
    return -1;
    80005910:	557d                	li	a0,-1
    80005912:	bfdd                	j	80005908 <uartgetc+0x1c>

0000000080005914 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005914:	1101                	addi	sp,sp,-32
    80005916:	ec06                	sd	ra,24(sp)
    80005918:	e822                	sd	s0,16(sp)
    8000591a:	e426                	sd	s1,8(sp)
    8000591c:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000591e:	54fd                	li	s1,-1
    int c = uartgetc();
    80005920:	fcdff0ef          	jal	800058ec <uartgetc>
    if(c == -1)
    80005924:	00950563          	beq	a0,s1,8000592e <uartintr+0x1a>
      break;
    consoleintr(c);
    80005928:	861ff0ef          	jal	80005188 <consoleintr>
  while(1){
    8000592c:	bfd5                	j	80005920 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000592e:	00016497          	auipc	s1,0x16
    80005932:	6fa48493          	addi	s1,s1,1786 # 8001c028 <uart_tx_lock>
    80005936:	8526                	mv	a0,s1
    80005938:	09c000ef          	jal	800059d4 <acquire>
  uartstart();
    8000593c:	e6fff0ef          	jal	800057aa <uartstart>
  release(&uart_tx_lock);
    80005940:	8526                	mv	a0,s1
    80005942:	126000ef          	jal	80005a68 <release>
}
    80005946:	60e2                	ld	ra,24(sp)
    80005948:	6442                	ld	s0,16(sp)
    8000594a:	64a2                	ld	s1,8(sp)
    8000594c:	6105                	addi	sp,sp,32
    8000594e:	8082                	ret

0000000080005950 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80005950:	1141                	addi	sp,sp,-16
    80005952:	e406                	sd	ra,8(sp)
    80005954:	e022                	sd	s0,0(sp)
    80005956:	0800                	addi	s0,sp,16
  lk->name = name;
    80005958:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000595a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000595e:	00053823          	sd	zero,16(a0)
}
    80005962:	60a2                	ld	ra,8(sp)
    80005964:	6402                	ld	s0,0(sp)
    80005966:	0141                	addi	sp,sp,16
    80005968:	8082                	ret

000000008000596a <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000596a:	411c                	lw	a5,0(a0)
    8000596c:	e399                	bnez	a5,80005972 <holding+0x8>
    8000596e:	4501                	li	a0,0
  return r;
}
    80005970:	8082                	ret
{
    80005972:	1101                	addi	sp,sp,-32
    80005974:	ec06                	sd	ra,24(sp)
    80005976:	e822                	sd	s0,16(sp)
    80005978:	e426                	sd	s1,8(sp)
    8000597a:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000597c:	6904                	ld	s1,16(a0)
    8000597e:	bbefb0ef          	jal	80000d3c <mycpu>
    80005982:	40a48533          	sub	a0,s1,a0
    80005986:	00153513          	seqz	a0,a0
}
    8000598a:	60e2                	ld	ra,24(sp)
    8000598c:	6442                	ld	s0,16(sp)
    8000598e:	64a2                	ld	s1,8(sp)
    80005990:	6105                	addi	sp,sp,32
    80005992:	8082                	ret

0000000080005994 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80005994:	1101                	addi	sp,sp,-32
    80005996:	ec06                	sd	ra,24(sp)
    80005998:	e822                	sd	s0,16(sp)
    8000599a:	e426                	sd	s1,8(sp)
    8000599c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000599e:	100024f3          	csrr	s1,sstatus
    800059a2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800059a6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800059a8:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800059ac:	b90fb0ef          	jal	80000d3c <mycpu>
    800059b0:	5d3c                	lw	a5,120(a0)
    800059b2:	cb99                	beqz	a5,800059c8 <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800059b4:	b88fb0ef          	jal	80000d3c <mycpu>
    800059b8:	5d3c                	lw	a5,120(a0)
    800059ba:	2785                	addiw	a5,a5,1
    800059bc:	dd3c                	sw	a5,120(a0)
}
    800059be:	60e2                	ld	ra,24(sp)
    800059c0:	6442                	ld	s0,16(sp)
    800059c2:	64a2                	ld	s1,8(sp)
    800059c4:	6105                	addi	sp,sp,32
    800059c6:	8082                	ret
    mycpu()->intena = old;
    800059c8:	b74fb0ef          	jal	80000d3c <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800059cc:	8085                	srli	s1,s1,0x1
    800059ce:	8885                	andi	s1,s1,1
    800059d0:	dd64                	sw	s1,124(a0)
    800059d2:	b7cd                	j	800059b4 <push_off+0x20>

00000000800059d4 <acquire>:
{
    800059d4:	1101                	addi	sp,sp,-32
    800059d6:	ec06                	sd	ra,24(sp)
    800059d8:	e822                	sd	s0,16(sp)
    800059da:	e426                	sd	s1,8(sp)
    800059dc:	1000                	addi	s0,sp,32
    800059de:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800059e0:	fb5ff0ef          	jal	80005994 <push_off>
  if(holding(lk))
    800059e4:	8526                	mv	a0,s1
    800059e6:	f85ff0ef          	jal	8000596a <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800059ea:	4705                	li	a4,1
  if(holding(lk))
    800059ec:	e105                	bnez	a0,80005a0c <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800059ee:	87ba                	mv	a5,a4
    800059f0:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800059f4:	2781                	sext.w	a5,a5
    800059f6:	ffe5                	bnez	a5,800059ee <acquire+0x1a>
  __sync_synchronize();
    800059f8:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    800059fc:	b40fb0ef          	jal	80000d3c <mycpu>
    80005a00:	e888                	sd	a0,16(s1)
}
    80005a02:	60e2                	ld	ra,24(sp)
    80005a04:	6442                	ld	s0,16(sp)
    80005a06:	64a2                	ld	s1,8(sp)
    80005a08:	6105                	addi	sp,sp,32
    80005a0a:	8082                	ret
    panic("acquire");
    80005a0c:	00002517          	auipc	a0,0x2
    80005a10:	d4c50513          	addi	a0,a0,-692 # 80007758 <etext+0x758>
    80005a14:	c93ff0ef          	jal	800056a6 <panic>

0000000080005a18 <pop_off>:

void
pop_off(void)
{
    80005a18:	1141                	addi	sp,sp,-16
    80005a1a:	e406                	sd	ra,8(sp)
    80005a1c:	e022                	sd	s0,0(sp)
    80005a1e:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80005a20:	b1cfb0ef          	jal	80000d3c <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005a24:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80005a28:	8b89                	andi	a5,a5,2
  if(intr_get())
    80005a2a:	e39d                	bnez	a5,80005a50 <pop_off+0x38>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80005a2c:	5d3c                	lw	a5,120(a0)
    80005a2e:	02f05763          	blez	a5,80005a5c <pop_off+0x44>
    panic("pop_off");
  c->noff -= 1;
    80005a32:	37fd                	addiw	a5,a5,-1
    80005a34:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80005a36:	eb89                	bnez	a5,80005a48 <pop_off+0x30>
    80005a38:	5d7c                	lw	a5,124(a0)
    80005a3a:	c799                	beqz	a5,80005a48 <pop_off+0x30>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005a3c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80005a40:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005a44:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80005a48:	60a2                	ld	ra,8(sp)
    80005a4a:	6402                	ld	s0,0(sp)
    80005a4c:	0141                	addi	sp,sp,16
    80005a4e:	8082                	ret
    panic("pop_off - interruptible");
    80005a50:	00002517          	auipc	a0,0x2
    80005a54:	d1050513          	addi	a0,a0,-752 # 80007760 <etext+0x760>
    80005a58:	c4fff0ef          	jal	800056a6 <panic>
    panic("pop_off");
    80005a5c:	00002517          	auipc	a0,0x2
    80005a60:	d1c50513          	addi	a0,a0,-740 # 80007778 <etext+0x778>
    80005a64:	c43ff0ef          	jal	800056a6 <panic>

0000000080005a68 <release>:
{
    80005a68:	1101                	addi	sp,sp,-32
    80005a6a:	ec06                	sd	ra,24(sp)
    80005a6c:	e822                	sd	s0,16(sp)
    80005a6e:	e426                	sd	s1,8(sp)
    80005a70:	1000                	addi	s0,sp,32
    80005a72:	84aa                	mv	s1,a0
  if(!holding(lk))
    80005a74:	ef7ff0ef          	jal	8000596a <holding>
    80005a78:	c105                	beqz	a0,80005a98 <release+0x30>
  lk->cpu = 0;
    80005a7a:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80005a7e:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80005a82:	0310000f          	fence	rw,w
    80005a86:	0004a023          	sw	zero,0(s1)
  pop_off();
    80005a8a:	f8fff0ef          	jal	80005a18 <pop_off>
}
    80005a8e:	60e2                	ld	ra,24(sp)
    80005a90:	6442                	ld	s0,16(sp)
    80005a92:	64a2                	ld	s1,8(sp)
    80005a94:	6105                	addi	sp,sp,32
    80005a96:	8082                	ret
    panic("release");
    80005a98:	00002517          	auipc	a0,0x2
    80005a9c:	ce850513          	addi	a0,a0,-792 # 80007780 <etext+0x780>
    80005aa0:	c07ff0ef          	jal	800056a6 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	8282                	jr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
