package com.hurlant.math
{
   import com.hurlant.crypto.prng.Random;
   import com.hurlant.util.Hex;
   import com.hurlant.util.Memory;
   import flash.utils.ByteArray;
   
   use namespace bi_internal;
   
   public class BigInteger
   {
      
      public static const DB:int = 30;
      
      public static const DV:int = 1 << DB;
      
      public static const DM:int = DV - 1;
      
      public static const BI_FP:int = 52;
      
      public static const FV:Number = Math.pow(2,BI_FP);
      
      public static const F1:int = BI_FP - DB;
      
      public static const F2:int = 2 * DB - BI_FP;
      
      public static const ZERO:BigInteger = nbv(0);
      
      public static const ONE:BigInteger = nbv(1);
      
      public static const lowprimes:Array = [2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97,101,103,107,109,113,127,131,137,139,149,151,157,163,167,173,179,181,191,193,197,199,211,223,227,229,233,239,241,251,257,263,269,271,277,281,283,293,307,311,313,317,331,337,347,349,353,359,367,373,379,383,389,397,401,409,419,421,431,433,439,443,449,457,461,463,467,479,487,491,499,503,509];
      
      public static const lplim:int = (1 << 26) / lowprimes[lowprimes.length - 1];
       
      
      public var t:int;
      
      bi_internal var s:int;
      
      bi_internal var a:Array;
      
      public function BigInteger(value:* = null, radix:int = 0, unsigned:Boolean = false)
      {
         var array:ByteArray = null;
         var length:int = 0;
         super();
         this.a = new Array();
         if(value is String)
         {
            if(radix && radix != 16)
            {
               this.fromRadix(value as String,radix);
            }
            else
            {
               value = Hex.toArray(value);
               radix = 0;
            }
         }
         if(value is ByteArray)
         {
            array = value as ByteArray;
            length = int(radix) || int(array.length - array.position);
            this.fromArray(array,length,unsigned);
         }
      }
      
      public static function nbv(value:int) : BigInteger
      {
         var bn:BigInteger = new BigInteger();
         bn.fromInt(value);
         return bn;
      }
      
      public function dispose() : void
      {
         var r:Random = new Random();
         for(var i:uint = 0; i < this.a.length; i++)
         {
            this.a[i] = r.nextByte();
            delete this.a[i];
         }
         this.a = null;
         this.t = 0;
         this.s = 0;
         Memory.gc();
      }
      
      public function toString(radix:Number = 16) : String
      {
         var k:int = 0;
         if(this.s < 0)
         {
            return "-" + this.negate().toString(radix);
         }
         switch(radix)
         {
            case 2:
               k = 1;
               break;
            case 4:
               k = 2;
               break;
            case 8:
               k = 3;
               break;
            case 16:
               k = 4;
               break;
            case 32:
               k = 5;
               break;
            default:
               return this.toRadix(radix);
         }
         var km:int = (1 << k) - 1;
         var d:int = 0;
         var m:Boolean = false;
         var r:String = "";
         var i:int = this.t;
         var p:int = DB - i * DB % k;
         if(i-- > 0)
         {
            if(p < DB && (d = this.a[i] >> p) > 0)
            {
               m = true;
               r = d.toString(36);
            }
            while(i >= 0)
            {
               if(p < k)
               {
                  d = (this.a[i] & (1 << p) - 1) << k - p;
                  d |= this.a[--i] >> (p = p + (DB - k));
               }
               else
               {
                  d = this.a[i] >> (p = p - k) & km;
                  if(p <= 0)
                  {
                     p += DB;
                     i--;
                  }
               }
               if(d > 0)
               {
                  m = true;
               }
               if(m)
               {
                  r += d.toString(36);
               }
            }
         }
         return !!m ? r : "0";
      }
      
      public function toArray(array:ByteArray) : uint
      {
         var k:int = 0;
         k = 8;
         var km:int = (1 << k) - 1;
         var d:int = 0;
         var i:int = this.t;
         var p:int = DB - i * DB % k;
         var m:Boolean = false;
         var c:int = 0;
         if(i-- > 0)
         {
            if(p < DB && (d = this.a[i] >> p) > 0)
            {
               m = true;
               array.writeByte(d);
               c++;
            }
            while(i >= 0)
            {
               if(p < k)
               {
                  d = (this.a[i] & (1 << p) - 1) << k - p;
                  d |= this.a[--i] >> (p = p + (DB - k));
               }
               else
               {
                  d = this.a[i] >> (p = p - k) & km;
                  if(p <= 0)
                  {
                     p += DB;
                     i--;
                  }
               }
               if(d > 0)
               {
                  m = true;
               }
               if(m)
               {
                  array.writeByte(d);
                  c++;
               }
            }
         }
         return c;
      }
      
      public function valueOf() : Number
      {
         if(this.s == -1)
         {
            return -this.negate().valueOf();
         }
         var coef:Number = 1;
         var value:Number = 0;
         for(var i:uint = 0; i < this.t; i++)
         {
            value += this.a[i] * coef;
            coef *= DV;
         }
         return value;
      }
      
      public function negate() : BigInteger
      {
         var r:BigInteger = this.nbi();
         ZERO.subTo(this,r);
         return r;
      }
      
      public function abs() : BigInteger
      {
         return this.s < 0 ? this.negate() : this;
      }
      
      public function compareTo(v:BigInteger) : int
      {
         var r:int = this.s - v.s;
         if(r != 0)
         {
            return r;
         }
         var i:int = this.t;
         r = i - v.t;
         if(r != 0)
         {
            return this.s < 0 ? int(r * -1) : int(r);
         }
         while(--i >= 0)
         {
            r = this.a[i] - v.a[i];
            if(r != 0)
            {
               return r;
            }
         }
         return 0;
      }
      
      bi_internal function nbits(x:int) : int
      {
         var t:int = 0;
         var r:int = 1;
         if((t = x >>> 16) != 0)
         {
            x = t;
            r += 16;
         }
         if((t = x >> 8) != 0)
         {
            x = t;
            r += 8;
         }
         if((t = x >> 4) != 0)
         {
            x = t;
            r += 4;
         }
         if((t = x >> 2) != 0)
         {
            x = t;
            r += 2;
         }
         if((t = x >> 1) != 0)
         {
            x = t;
            r += 1;
         }
         return r;
      }
      
      public function bitLength() : int
      {
         if(this.t <= 0)
         {
            return 0;
         }
         return DB * (this.t - 1) + this.nbits(this.a[this.t - 1] ^ this.s & DM);
      }
      
      public function mod(v:BigInteger) : BigInteger
      {
         var r:BigInteger = this.nbi();
         this.abs().divRemTo(v,null,r);
         if(this.s < 0 && r.compareTo(ZERO) > 0)
         {
            v.subTo(r,r);
         }
         return r;
      }
      
      public function modPowInt(e:int, m:BigInteger) : BigInteger
      {
         var z:IReduction = null;
         if(e < 256 || m.isEven())
         {
            z = new ClassicReduction(m);
         }
         else
         {
            z = new MontgomeryReduction(m);
         }
         return this.exp(e,z);
      }
      
      bi_internal function copyTo(r:BigInteger) : void
      {
         for(var i:int = this.t - 1; i >= 0; i--)
         {
            r.a[i] = this.a[i];
         }
         r.t = this.t;
         r.s = this.s;
      }
      
      bi_internal function fromInt(value:int) : void
      {
         this.t = 1;
         this.s = value < 0 ? int(-1) : int(0);
         if(value > 0)
         {
            this.a[0] = value;
         }
         else if(value < -1)
         {
            this.a[0] = value + DV;
         }
         else
         {
            this.t = 0;
         }
      }
      
      bi_internal function fromArray(value:ByteArray, length:int, unsigned:Boolean = false) : void
      {
         var p:int = 0;
         var i:int = 0;
         var sh:int = 0;
         var k:int = 0;
         var x:int = 0;
         p = value.position;
         i = p + length;
         sh = 0;
         k = 8;
         this.t = 0;
         this.s = 0;
         while(--i >= p)
         {
            x = i < value.length ? int(int(value[i])) : int(int(0));
            if(sh == 0)
            {
               var _loc9_:* = this.t++;
               this.a[_loc9_] = x;
            }
            else if(sh + k > DB)
            {
               this.a[this.t - 1] |= (x & (1 << DB - sh) - 1) << sh;
               _loc9_ = this.t++;
               this.a[_loc9_] = x >> DB - sh;
            }
            else
            {
               this.a[this.t - 1] |= x << sh;
            }
            sh += k;
            if(sh >= DB)
            {
               sh -= DB;
            }
         }
         this.clamp();
         value.position = Math.min(p + length,value.length);
      }
      
      bi_internal function clamp() : void
      {
         var c:int = this.s & DM;
         while(this.t > 0 && this.a[this.t - 1] == c)
         {
            --this.t;
         }
      }
      
      bi_internal function dlShiftTo(n:int, r:BigInteger) : void
      {
         var i:int = 0;
         for(i = this.t - 1; i >= 0; i--)
         {
            r.a[i + n] = this.a[i];
         }
         for(i = n - 1; i >= 0; i--)
         {
            r.a[i] = 0;
         }
         r.t = this.t + n;
         r.s = this.s;
      }
      
      bi_internal function drShiftTo(n:int, r:BigInteger) : void
      {
         var i:int = 0;
         for(i = n; i < this.t; i++)
         {
            r.a[i - n] = this.a[i];
         }
         r.t = Math.max(this.t - n,0);
         r.s = this.s;
      }
      
      bi_internal function lShiftTo(n:int, r:BigInteger) : void
      {
         var i:int = 0;
         var bs:int = n % DB;
         var cbs:int = DB - bs;
         var bm:int = (1 << cbs) - 1;
         var ds:int = n / DB;
         var c:int = this.s << bs & DM;
         for(i = this.t - 1; i >= 0; i--)
         {
            r.a[i + ds + 1] = this.a[i] >> cbs | c;
            c = (this.a[i] & bm) << bs;
         }
         for(i = ds - 1; i >= 0; i--)
         {
            r.a[i] = 0;
         }
         r.a[ds] = c;
         r.t = this.t + ds + 1;
         r.s = this.s;
         r.clamp();
      }
      
      bi_internal function rShiftTo(n:int, r:BigInteger) : void
      {
         var i:int = 0;
         r.s = this.s;
         var ds:int = n / DB;
         if(ds >= this.t)
         {
            r.t = 0;
            return;
         }
         var bs:int = n % DB;
         var cbs:int = DB - bs;
         var bm:int = (1 << bs) - 1;
         r.a[0] = this.a[ds] >> bs;
         for(i = ds + 1; i < this.t; i++)
         {
            r.a[i - ds - 1] |= (this.a[i] & bm) << cbs;
            r.a[i - ds] = this.a[i] >> bs;
         }
         if(bs > 0)
         {
            r.a[this.t - ds - 1] |= (this.s & bm) << cbs;
         }
         r.t = this.t - ds;
         r.clamp();
      }
      
      bi_internal function subTo(v:BigInteger, r:BigInteger) : void
      {
         var i:int = 0;
         var c:int = 0;
         var m:int = Math.min(v.t,this.t);
         while(i < m)
         {
            c += this.a[i] - v.a[i];
            var _loc6_:* = i++;
            r.a[_loc6_] = c & DM;
            c >>= DB;
         }
         if(v.t < this.t)
         {
            c -= v.s;
            while(i < this.t)
            {
               c += this.a[i];
               _loc6_ = i++;
               r.a[_loc6_] = c & DM;
               c >>= DB;
            }
            c += this.s;
         }
         else
         {
            c += this.s;
            while(i < v.t)
            {
               c -= v.a[i];
               _loc6_ = i++;
               r.a[_loc6_] = c & DM;
               c >>= DB;
            }
            c -= v.s;
         }
         r.s = c < 0 ? int(-1) : int(0);
         if(c < -1)
         {
            _loc6_ = i++;
            r.a[_loc6_] = DV + c;
         }
         else if(c > 0)
         {
            _loc6_ = i++;
            r.a[_loc6_] = c;
         }
         r.t = i;
         r.clamp();
      }
      
      bi_internal function am(i:int, x:int, w:BigInteger, j:int, c:int, n:int) : int
      {
         var l:int = 0;
         var h:int = 0;
         var m:int = 0;
         var xl:int = x & 32767;
         var xh:int = x >> 15;
         while(--n >= 0)
         {
            l = this.a[i] & 32767;
            h = this.a[i++] >> 15;
            m = xh * l + h * xl;
            l = xl * l + ((m & 32767) << 15) + w.a[j] + (c & 1073741823);
            c = (l >>> 30) + (m >>> 15) + xh * h + (c >>> 30);
            var _loc12_:* = j++;
            w.a[_loc12_] = l & 1073741823;
         }
         return c;
      }
      
      bi_internal function multiplyTo(v:BigInteger, r:BigInteger) : void
      {
         var x:BigInteger = this.abs();
         var y:BigInteger = v.abs();
         var i:int = x.t;
         r.t = i + y.t;
         while(--i >= 0)
         {
            r.a[i] = 0;
         }
         for(i = 0; i < y.t; i++)
         {
            r.a[i + x.t] = x.am(0,y.a[i],r,i,0,x.t);
         }
         r.s = 0;
         r.clamp();
         if(this.s != v.s)
         {
            ZERO.subTo(r,r);
         }
      }
      
      bi_internal function squareTo(r:BigInteger) : void
      {
         var c:int = 0;
         var x:BigInteger = this.abs();
         for(var i:int = r.t = 2 * x.t; --i >= 0; )
         {
            r.a[i] = 0;
         }
         for(i = 0; i < x.t - 1; i++)
         {
            c = x.am(i,x.a[i],r,2 * i,0,1);
            if((r.a[i + x.t] = r.a[i + x.t] + x.am(i + 1,2 * x.a[i],r,2 * i + 1,c,x.t - i - 1)) >= DV)
            {
               r.a[i + x.t] -= DV;
               r.a[i + x.t + 1] = 1;
            }
         }
         if(r.t > 0)
         {
            r.a[r.t - 1] += x.am(i,x.a[i],r,2 * i,0,1);
         }
         r.s = 0;
         r.clamp();
      }
      
      bi_internal function divRemTo(m:BigInteger, q:BigInteger = null, r:BigInteger = null) : void
      {
         var qd:int = 0;
         var pm:BigInteger = m.abs();
         if(pm.t <= 0)
         {
            return;
         }
         var pt:BigInteger = this.abs();
         if(pt.t < pm.t)
         {
            if(q != null)
            {
               q.fromInt(0);
            }
            if(r != null)
            {
               this.copyTo(r);
            }
            return;
         }
         if(r == null)
         {
            var r:BigInteger = this.nbi();
         }
         var y:BigInteger = this.nbi();
         var ts:int = this.s;
         var ms:int = m.s;
         var nsh:int = DB - this.nbits(pm.a[pm.t - 1]);
         if(nsh > 0)
         {
            pm.lShiftTo(nsh,y);
            pt.lShiftTo(nsh,r);
         }
         else
         {
            pm.copyTo(y);
            pt.copyTo(r);
         }
         var ys:int = y.t;
         var y0:int = y.a[ys - 1];
         if(y0 == 0)
         {
            return;
         }
         var yt:Number = y0 * (1 << F1) + (ys > 1 ? y.a[ys - 2] >> F2 : 0);
         var d1:Number = FV / yt;
         var d2:Number = (1 << F1) / yt;
         var e:Number = 1 << F2;
         var i:int = r.t;
         var j:int = i - ys;
         var t:BigInteger = q == null ? this.nbi() : q;
         y.dlShiftTo(j,t);
         if(r.compareTo(t) >= 0)
         {
            var _loc5_:* = r.t++;
            r.a[_loc5_] = 1;
            r.subTo(t,r);
         }
         ONE.dlShiftTo(ys,t);
         for(t.subTo(y,y); y.t < ys; )
         {
            y.(++y.t, false);
         }
         while(--j >= 0)
         {
            qd = r.a[--i] == y0 ? int(DM) : int(Number(r.a[i]) * d1 + (Number(r.a[i - 1]) + e) * d2);
            if((r.a[i] = r.a[i] + y.am(0,qd,r,j,0,ys)) < qd)
            {
               y.dlShiftTo(j,t);
               r.subTo(t,r);
               while(r.a[i] < --qd)
               {
                  r.subTo(t,r);
               }
            }
         }
         if(q != null)
         {
            r.drShiftTo(ys,q);
            if(ts != ms)
            {
               ZERO.subTo(q,q);
            }
         }
         r.t = ys;
         r.clamp();
         if(nsh > 0)
         {
            r.rShiftTo(nsh,r);
         }
         if(ts < 0)
         {
            ZERO.subTo(r,r);
         }
      }
      
      bi_internal function invDigit() : int
      {
         if(this.t < 1)
         {
            return 0;
         }
         var x:int = this.a[0];
         if((x & 1) == 0)
         {
            return 0;
         }
         var y:int = x & 3;
         y = y * (2 - (x & 15) * y) & 15;
         y = y * (2 - (x & 255) * y) & 255;
         y = y * (2 - ((x & 65535) * y & 65535)) & 65535;
         y = y * (2 - x * y % DV) % DV;
         return y > 0 ? int(DV - y) : int(-y);
      }
      
      bi_internal function isEven() : Boolean
      {
         return (this.t > 0 ? this.a[0] & 1 : this.s) == 0;
      }
      
      bi_internal function exp(e:int, z:IReduction) : BigInteger
      {
         var t:BigInteger = null;
         if(e > 4294967295 || e < 1)
         {
            return ONE;
         }
         var r:BigInteger = this.nbi();
         var r2:BigInteger = this.nbi();
         var g:BigInteger = z.convert(this);
         var i:int = this.nbits(e) - 1;
         g.copyTo(r);
         while(--i >= 0)
         {
            z.sqrTo(r,r2);
            if((e & 1 << i) > 0)
            {
               z.mulTo(r2,g,r);
            }
            else
            {
               t = r;
               r = r2;
               r2 = t;
            }
         }
         return z.revert(r);
      }
      
      bi_internal function intAt(str:String, index:int) : int
      {
         var i:Number = parseInt(str.charAt(index),36);
         return !!isNaN(i) ? int(-1) : int(i);
      }
      
      protected function nbi() : *
      {
         return new BigInteger();
      }
      
      public function clone() : BigInteger
      {
         var r:BigInteger = new BigInteger();
         this.copyTo(r);
         return r;
      }
      
      public function intValue() : int
      {
         if(this.s < 0)
         {
            if(this.t == 1)
            {
               return this.a[0] - DV;
            }
            if(this.t == 0)
            {
               return -1;
            }
         }
         else
         {
            if(this.t == 1)
            {
               return this.a[0];
            }
            if(this.t == 0)
            {
               return 0;
            }
         }
         return (this.a[1] & (1 << 32 - DB) - 1) << DB | this.a[0];
      }
      
      public function byteValue() : int
      {
         return this.t == 0 ? int(this.s) : int(this.a[0] << 24 >> 24);
      }
      
      public function shortValue() : int
      {
         return this.t == 0 ? int(this.s) : int(this.a[0] << 16 >> 16);
      }
      
      protected function chunkSize(r:Number) : int
      {
         return Math.floor(Math.LN2 * DB / Math.log(r));
      }
      
      public function sigNum() : int
      {
         if(this.s < 0)
         {
            return -1;
         }
         if(this.t <= 0 || this.t == 1 && this.a[0] <= 0)
         {
            return 0;
         }
         return 1;
      }
      
      protected function toRadix(b:uint = 10) : String
      {
         if(this.sigNum() == 0 || b < 2 || b > 32)
         {
            return "0";
         }
         var cs:int = this.chunkSize(b);
         var a:Number = Math.pow(b,cs);
         var d:BigInteger = nbv(a);
         var y:BigInteger = this.nbi();
         var z:BigInteger = this.nbi();
         var r:String = "";
         this.divRemTo(d,y,z);
         while(y.sigNum() > 0)
         {
            r = (a + z.intValue()).toString(b).substr(1) + r;
            y.divRemTo(d,y,z);
         }
         return z.intValue().toString(b) + r;
      }
      
      protected function fromRadix(s:String, b:int = 10) : void
      {
         var x:int = 0;
         this.fromInt(0);
         var cs:int = this.chunkSize(b);
         var d:Number = Math.pow(b,cs);
         var mi:Boolean = false;
         var j:int = 0;
         var w:int = 0;
         for(var i:int = 0; i < s.length; i++)
         {
            x = this.intAt(s,i);
            if(x < 0)
            {
               if(s.charAt(i) == "-" && this.sigNum() == 0)
               {
                  mi = true;
               }
            }
            else
            {
               w = b * w + x;
               if(++j >= cs)
               {
                  this.dMultiply(d);
                  this.dAddOffset(w,0);
                  j = 0;
                  w = 0;
               }
            }
         }
         if(j > 0)
         {
            this.dMultiply(Math.pow(b,j));
            this.dAddOffset(w,0);
         }
         if(mi)
         {
            BigInteger.ZERO.subTo(this,this);
         }
      }
      
      public function toByteArray() : ByteArray
      {
         var d:int = 0;
         var i:int = this.t;
         var r:ByteArray = new ByteArray();
         r[0] = this.s;
         var p:int = DB - i * DB % 8;
         var k:int = 0;
         if(i-- > 0)
         {
            if(p < DB && (d = this.a[i] >> p) != (this.s & DM) >> p)
            {
               var _loc6_:* = k++;
               r[_loc6_] = d | this.s << DB - p;
            }
            while(i >= 0)
            {
               if(p < 8)
               {
                  d = (this.a[i] & (1 << p) - 1) << 8 - p;
                  d |= this.a[--i] >> (p = p + (DB - 8));
               }
               else
               {
                  d = this.a[i] >> (p = p - 8) & 255;
                  if(p <= 0)
                  {
                     p += DB;
                     i--;
                  }
               }
               if((d & 128) != 0)
               {
                  d |= -256;
               }
               if(k == 0 && (this.s & 128) != (d & 128))
               {
                  k++;
               }
               if(k > 0 || d != this.s)
               {
                  _loc6_ = k++;
                  r[_loc6_] = d;
               }
            }
         }
         return r;
      }
      
      public function equals(a:BigInteger) : Boolean
      {
         return this.compareTo(a) == 0;
      }
      
      public function min(a:BigInteger) : BigInteger
      {
         return this.compareTo(a) < 0 ? this : a;
      }
      
      public function max(a:BigInteger) : BigInteger
      {
         return this.compareTo(a) > 0 ? this : a;
      }
      
      protected function bitwiseTo(a:BigInteger, op:Function, r:BigInteger) : void
      {
         var i:int = 0;
         var f:int = 0;
         var m:int = Math.min(a.t,this.t);
         for(i = 0; i < m; i++)
         {
            r.a[i] = op(this.a[i],a.a[i]);
         }
         if(a.t < this.t)
         {
            f = a.s & DM;
            for(i = m; i < this.t; i++)
            {
               r.a[i] = op(this.a[i],f);
            }
            r.t = this.t;
         }
         else
         {
            f = this.s & DM;
            for(i = m; i < a.t; i++)
            {
               r.a[i] = op(f,a.a[i]);
            }
            r.t = a.t;
         }
         r.s = op(this.s,a.s);
         r.clamp();
      }
      
      private function op_and(x:int, y:int) : int
      {
         return x & y;
      }
      
      public function and(a:BigInteger) : BigInteger
      {
         var r:BigInteger = new BigInteger();
         this.bitwiseTo(a,this.op_and,r);
         return r;
      }
      
      private function op_or(x:int, y:int) : int
      {
         return x | y;
      }
      
      public function or(a:BigInteger) : BigInteger
      {
         var r:BigInteger = new BigInteger();
         this.bitwiseTo(a,this.op_or,r);
         return r;
      }
      
      private function op_xor(x:int, y:int) : int
      {
         return x ^ y;
      }
      
      public function xor(a:BigInteger) : BigInteger
      {
         var r:BigInteger = new BigInteger();
         this.bitwiseTo(a,this.op_xor,r);
         return r;
      }
      
      private function op_andnot(x:int, y:int) : int
      {
         return x & ~y;
      }
      
      public function andNot(a:BigInteger) : BigInteger
      {
         var r:BigInteger = new BigInteger();
         this.bitwiseTo(a,this.op_andnot,r);
         return r;
      }
      
      public function not() : BigInteger
      {
         var r:BigInteger = new BigInteger();
         for(var i:int = 0; i < this.t; i++)
         {
            r[i] = DM & ~this.a[i];
         }
         r.t = this.t;
         r.s = ~this.s;
         return r;
      }
      
      public function shiftLeft(n:int) : BigInteger
      {
         var r:BigInteger = new BigInteger();
         if(n < 0)
         {
            this.rShiftTo(-n,r);
         }
         else
         {
            this.lShiftTo(n,r);
         }
         return r;
      }
      
      public function shiftRight(n:int) : BigInteger
      {
         var r:BigInteger = new BigInteger();
         if(n < 0)
         {
            this.lShiftTo(-n,r);
         }
         else
         {
            this.rShiftTo(n,r);
         }
         return r;
      }
      
      private function lbit(x:int) : int
      {
         if(x == 0)
         {
            return -1;
         }
         var r:int = 0;
         if((x & 65535) == 0)
         {
            x >>= 16;
            r += 16;
         }
         if((x & 255) == 0)
         {
            x >>= 8;
            r += 8;
         }
         if((x & 15) == 0)
         {
            x >>= 4;
            r += 4;
         }
         if((x & 3) == 0)
         {
            x >>= 2;
            r += 2;
         }
         if((x & 1) == 0)
         {
            r++;
         }
         return r;
      }
      
      public function getLowestSetBit() : int
      {
         for(var i:int = 0; i < this.t; i++)
         {
            if(this.a[i] != 0)
            {
               return i * DB + this.lbit(this.a[i]);
            }
         }
         if(this.s < 0)
         {
            return this.t * DB;
         }
         return -1;
      }
      
      private function cbit(x:int) : int
      {
         for(var r:uint = 0; x != 0; )
         {
            x &= x - 1;
            r++;
         }
         return r;
      }
      
      public function bitCount() : int
      {
         var r:int = 0;
         var x:int = this.s & DM;
         for(var i:int = 0; i < this.t; i++)
         {
            r += this.cbit(this.a[i] ^ x);
         }
         return r;
      }
      
      public function testBit(n:int) : Boolean
      {
         var j:int = Math.floor(n / DB);
         if(j >= this.t)
         {
            return this.s != 0;
         }
         return (this.a[j] & 1 << n % DB) != 0;
      }
      
      protected function changeBit(n:int, op:Function) : BigInteger
      {
         var r:BigInteger = BigInteger.ONE.shiftLeft(n);
         this.bitwiseTo(r,op,r);
         return r;
      }
      
      public function setBit(n:int) : BigInteger
      {
         return this.changeBit(n,this.op_or);
      }
      
      public function clearBit(n:int) : BigInteger
      {
         return this.changeBit(n,this.op_andnot);
      }
      
      public function flipBit(n:int) : BigInteger
      {
         return this.changeBit(n,this.op_xor);
      }
      
      protected function addTo(a:BigInteger, r:BigInteger) : void
      {
         var i:int = 0;
         var c:int = 0;
         var m:int = Math.min(a.t,this.t);
         while(i < m)
         {
            c += this.a[i] + a.a[i];
            var _loc6_:* = i++;
            r.a[_loc6_] = c & DM;
            c >>= DB;
         }
         if(a.t < this.t)
         {
            c += a.s;
            while(i < this.t)
            {
               c += this.a[i];
               _loc6_ = i++;
               r.a[_loc6_] = c & DM;
               c >>= DB;
            }
            c += this.s;
         }
         else
         {
            c += this.s;
            while(i < a.t)
            {
               c += a.a[i];
               _loc6_ = i++;
               r.a[_loc6_] = c & DM;
               c >>= DB;
            }
            c += a.s;
         }
         r.s = c < 0 ? int(-1) : int(0);
         if(c > 0)
         {
            _loc6_ = i++;
            r.a[_loc6_] = c;
         }
         else if(c < -1)
         {
            _loc6_ = i++;
            r.a[_loc6_] = DV + c;
         }
         r.t = i;
         r.clamp();
      }
      
      public function add(a:BigInteger) : BigInteger
      {
         var r:BigInteger = new BigInteger();
         this.addTo(a,r);
         return r;
      }
      
      public function subtract(a:BigInteger) : BigInteger
      {
         var r:BigInteger = new BigInteger();
         this.subTo(a,r);
         return r;
      }
      
      public function multiply(a:BigInteger) : BigInteger
      {
         var r:BigInteger = new BigInteger();
         this.multiplyTo(a,r);
         return r;
      }
      
      public function divide(a:BigInteger) : BigInteger
      {
         var r:BigInteger = new BigInteger();
         this.divRemTo(a,r,null);
         return r;
      }
      
      public function remainder(a:BigInteger) : BigInteger
      {
         var r:BigInteger = new BigInteger();
         this.divRemTo(a,null,r);
         return r;
      }
      
      public function divideAndRemainder(a:BigInteger) : Array
      {
         var q:BigInteger = new BigInteger();
         var r:BigInteger = new BigInteger();
         this.divRemTo(a,q,r);
         return [q,r];
      }
      
      bi_internal function dMultiply(n:int) : void
      {
         this.a[this.t] = this.am(0,n - 1,this,0,0,this.t);
         ++this.t;
         this.clamp();
      }
      
      bi_internal function dAddOffset(n:int, w:int) : void
      {
         while(this.t <= w)
         {
            var _loc3_:* = this.t++;
            this.a[_loc3_] = 0;
         }
         this.a[w] += n;
         while(this.a[w] >= DV)
         {
            this.a[w] -= DV;
            if(++w >= this.t)
            {
               _loc3_ = this.t++;
               this.a[_loc3_] = 0;
            }
            ++this.a[w];
         }
      }
      
      public function pow(e:int) : BigInteger
      {
         return this.exp(e,new NullReduction());
      }
      
      bi_internal function multiplyLowerTo(a:BigInteger, n:int, r:BigInteger) : void
      {
         var j:int = 0;
         var i:int = Math.min(this.t + a.t,n);
         r.s = 0;
         r.t = i;
         while(i > 0)
         {
            var _loc6_:* = --i;
            r.a[_loc6_] = 0;
         }
         for(j = r.t - this.t; i < j; i++)
         {
            r.a[i + this.t] = this.am(0,a.a[i],r,i,0,this.t);
         }
         for(j = Math.min(a.t,n); i < j; i++)
         {
            this.am(0,a.a[i],r,i,0,n - i);
         }
         r.clamp();
      }
      
      bi_internal function multiplyUpperTo(a:BigInteger, n:int, r:BigInteger) : void
      {
         n--;
         var i:int = r.t = this.t + a.t - n;
         r.s = 0;
         while(--i >= 0)
         {
            r.a[i] = 0;
         }
         for(i = Math.max(n - this.t,0); i < a.t; i++)
         {
            r.a[this.t + i - n] = this.am(n - i,a.a[i],r,0,0,this.t + i - n);
         }
         r.clamp();
         r.drShiftTo(1,r);
      }
      
      public function modPow(e:BigInteger, m:BigInteger) : BigInteger
      {
         var k:int = 0;
         var z:IReduction = null;
         var w:int = 0;
         var t:BigInteger = null;
         var g2:BigInteger = null;
         var i:int = e.bitLength();
         var r:BigInteger = nbv(1);
         if(i <= 0)
         {
            return r;
         }
         if(i < 18)
         {
            k = 1;
         }
         else if(i < 48)
         {
            k = 3;
         }
         else if(i < 144)
         {
            k = 4;
         }
         else if(i < 768)
         {
            k = 5;
         }
         else
         {
            k = 6;
         }
         if(i < 8)
         {
            z = new ClassicReduction(m);
         }
         else if(m.isEven())
         {
            z = new BarrettReduction(m);
         }
         else
         {
            z = new MontgomeryReduction(m);
         }
         var g:Array = [];
         var n:int = 3;
         var k1:int = k - 1;
         var km:int = (1 << k) - 1;
         g[1] = z.convert(this);
         if(k > 1)
         {
            g2 = new BigInteger();
            z.sqrTo(g[1],g2);
            while(n <= km)
            {
               g[n] = new BigInteger();
               z.mulTo(g2,g[n - 2],g[n]);
               n += 2;
            }
         }
         var j:int = e.t - 1;
         var is1:Boolean = true;
         var r2:BigInteger = new BigInteger();
         i = this.nbits(e.a[j]) - 1;
         while(j >= 0)
         {
            if(i >= k1)
            {
               w = e.a[j] >> i - k1 & km;
            }
            else
            {
               w = (e.a[j] & (1 << i + 1) - 1) << k1 - i;
               if(j > 0)
               {
                  w |= e.a[j - 1] >> DB + i - k1;
               }
            }
            n = k;
            while((w & 1) == 0)
            {
               w >>= 1;
               n--;
            }
            if((i = i - n) < 0)
            {
               i += DB;
               j--;
            }
            if(is1)
            {
               g[w].copyTo(r);
               is1 = false;
            }
            else
            {
               while(n > 1)
               {
                  z.sqrTo(r,r2);
                  z.sqrTo(r2,r);
                  n -= 2;
               }
               if(n > 0)
               {
                  z.sqrTo(r,r2);
               }
               else
               {
                  t = r;
                  r = r2;
                  r2 = t;
               }
               z.mulTo(r2,g[w],r);
            }
            while(j >= 0 && (e.a[j] & 1 << i) == 0)
            {
               z.sqrTo(r,r2);
               t = r;
               r = r2;
               r2 = t;
               if(--i < 0)
               {
                  i = DB - 1;
                  j--;
               }
            }
         }
         return z.revert(r);
      }
      
      public function gcd(a:BigInteger) : BigInteger
      {
         var t:BigInteger = null;
         var x:BigInteger = this.s < 0 ? this.negate() : this.clone();
         var y:BigInteger = a.s < 0 ? a.negate() : a.clone();
         if(x.compareTo(y) < 0)
         {
            t = x;
            x = y;
            y = t;
         }
         var i:int = x.getLowestSetBit();
         var g:int = y.getLowestSetBit();
         if(g < 0)
         {
            return x;
         }
         if(i < g)
         {
            g = i;
         }
         if(g > 0)
         {
            x.rShiftTo(g,x);
            y.rShiftTo(g,y);
         }
         while(x.sigNum() > 0)
         {
            if((i = x.getLowestSetBit()) > 0)
            {
               x.rShiftTo(i,x);
            }
            if((i = y.getLowestSetBit()) > 0)
            {
               y.rShiftTo(i,y);
            }
            if(x.compareTo(y) >= 0)
            {
               x.subTo(y,x);
               x.rShiftTo(1,x);
            }
            else
            {
               y.subTo(x,y);
               y.rShiftTo(1,y);
            }
         }
         if(g > 0)
         {
            y.lShiftTo(g,y);
         }
         return y;
      }
      
      protected function modInt(n:int) : int
      {
         var i:int = 0;
         if(n <= 0)
         {
            return 0;
         }
         var d:int = DV % n;
         var r:int = this.s < 0 ? int(n - 1) : int(0);
         if(this.t > 0)
         {
            if(d == 0)
            {
               r = this.a[0] % n;
            }
            else
            {
               for(i = this.t - 1; i >= 0; i--)
               {
                  r = (d * r + this.a[i]) % n;
               }
            }
         }
         return r;
      }
      
      public function modInverse(m:BigInteger) : BigInteger
      {
         var ac:Boolean = m.isEven();
         if(this.isEven() && ac || m.sigNum() == 0)
         {
            return BigInteger.ZERO;
         }
         var u:BigInteger = m.clone();
         var v:BigInteger = this.clone();
         var a:BigInteger = nbv(1);
         var b:BigInteger = nbv(0);
         var c:BigInteger = nbv(0);
         var d:BigInteger = nbv(1);
         while(u.sigNum() != 0)
         {
            while(u.isEven())
            {
               u.rShiftTo(1,u);
               if(ac)
               {
                  if(!a.isEven() || !b.isEven())
                  {
                     a.addTo(this,a);
                     b.subTo(m,b);
                  }
                  a.rShiftTo(1,a);
               }
               else if(!b.isEven())
               {
                  b.subTo(m,b);
               }
               b.rShiftTo(1,b);
            }
            while(v.isEven())
            {
               v.rShiftTo(1,v);
               if(ac)
               {
                  if(!c.isEven() || !d.isEven())
                  {
                     c.addTo(this,c);
                     d.subTo(m,d);
                  }
                  c.rShiftTo(1,c);
               }
               else if(!d.isEven())
               {
                  d.subTo(m,d);
               }
               d.rShiftTo(1,d);
            }
            if(u.compareTo(v) >= 0)
            {
               u.subTo(v,u);
               if(ac)
               {
                  a.subTo(c,a);
               }
               b.subTo(d,b);
            }
            else
            {
               v.subTo(u,v);
               if(ac)
               {
                  c.subTo(a,c);
               }
               d.subTo(b,d);
            }
         }
         if(v.compareTo(BigInteger.ONE) != 0)
         {
            return BigInteger.ZERO;
         }
         if(d.compareTo(m) >= 0)
         {
            return d.subtract(m);
         }
         if(d.sigNum() < 0)
         {
            d.addTo(m,d);
            if(d.sigNum() < 0)
            {
               return d.add(m);
            }
            return d;
         }
         return d;
      }
      
      public function isProbablePrime(t:int) : Boolean
      {
         var i:int = 0;
         var m:int = 0;
         var j:int = 0;
         var x:BigInteger = this.abs();
         if(x.t == 1 && x.a[0] <= lowprimes[lowprimes.length - 1])
         {
            for(i = 0; i < lowprimes.length; i++)
            {
               if(x[0] == lowprimes[i])
               {
                  return true;
               }
            }
            return false;
         }
         if(x.isEven())
         {
            return false;
         }
         i = 1;
         while(i < lowprimes.length)
         {
            m = lowprimes[i];
            j = i + 1;
            while(j < lowprimes.length && m < lplim)
            {
               m *= lowprimes[j++];
            }
            m = x.modInt(m);
            while(i < j)
            {
               if(m % lowprimes[i++] == 0)
               {
                  return false;
               }
            }
         }
         return x.millerRabin(t);
      }
      
      protected function millerRabin(t:int) : Boolean
      {
         var y:BigInteger = null;
         var j:int = 0;
         var n1:BigInteger = this.subtract(BigInteger.ONE);
         var k:int = n1.getLowestSetBit();
         if(k <= 0)
         {
            return false;
         }
         var r:BigInteger = n1.shiftRight(k);
         t = t + 1 >> 1;
         if(t > lowprimes.length)
         {
            t = lowprimes.length;
         }
         var a:BigInteger = new BigInteger();
         for(var i:int = 0; i < t; i++)
         {
            a.fromInt(lowprimes[i]);
            y = a.modPow(r,this);
            if(y.compareTo(BigInteger.ONE) != 0 && y.compareTo(n1) != 0)
            {
               j = 1;
               while(j++ < k && y.compareTo(n1) != 0)
               {
                  y = y.modPowInt(2,this);
                  if(y.compareTo(BigInteger.ONE) == 0)
                  {
                     return false;
                  }
               }
               if(y.compareTo(n1) != 0)
               {
                  return false;
               }
            }
         }
         return true;
      }
      
      public function primify(bits:int, t:int) : void
      {
         if(!this.testBit(bits - 1))
         {
            this.bitwiseTo(BigInteger.ONE.shiftLeft(bits - 1),this.op_or,this);
         }
         if(this.isEven())
         {
            this.dAddOffset(1,0);
         }
         while(!this.isProbablePrime(t))
         {
            for(this.dAddOffset(2,0); this.bitLength() > bits; )
            {
               this.subTo(BigInteger.ONE.shiftLeft(bits - 1),this);
            }
         }
      }
   }
}
