package com.hurlant.math
{
   use namespace bi_internal;
   
   internal class MontgomeryReduction implements IReduction
   {
       
      
      private var um:int;
      
      private var mp:int;
      
      private var mph:int;
      
      private var mpl:int;
      
      private var mt2:int;
      
      private var m:BigInteger;
      
      function MontgomeryReduction(m:BigInteger)
      {
         super();
         this.m = m;
         this.mp = m.invDigit();
         this.mpl = this.mp & 32767;
         this.mph = this.mp >> 15;
         this.um = (1 << BigInteger.DB - 15) - 1;
         this.mt2 = 2 * m.t;
      }
      
      public function mulTo(x:BigInteger, y:BigInteger, r:BigInteger) : void
      {
         x.multiplyTo(y,r);
         this.reduce(r);
      }
      
      public function revert(x:BigInteger) : BigInteger
      {
         var r:BigInteger = null;
         r = new BigInteger();
         x.copyTo(r);
         this.reduce(r);
         return r;
      }
      
      public function convert(x:BigInteger) : BigInteger
      {
         var r:BigInteger = null;
         r = new BigInteger();
         x.abs().dlShiftTo(this.m.t,r);
         r.divRemTo(this.m,null,r);
         if(x.s < 0 && r.compareTo(BigInteger.ZERO) > 0)
         {
            this.m.subTo(r,r);
         }
         return r;
      }
      
      public function reduce(x:BigInteger) : void
      {
         var i:int = 0;
         var j:int = 0;
         var u0:int = 0;
         while(x.t <= this.mt2)
         {
            var _loc5_:* = x.t++;
            x.a[_loc5_] = 0;
         }
         for(i = 0; i < this.m.t; i++)
         {
            j = x.a[i] & 32767;
            u0 = j * this.mpl + ((j * this.mph + (x.a[i] >> 15) * this.mpl & this.um) << 15) & BigInteger.DM;
            j = i + this.m.t;
            x.a[j] += this.m.am(0,u0,x,i,0,this.m.t);
            while(x.a[j] >= BigInteger.DV)
            {
               x.a[j] -= BigInteger.DV;
               ++x.a[++j];
            }
         }
         x.clamp();
         x.drShiftTo(this.m.t,x);
         if(x.compareTo(this.m) >= 0)
         {
            x.subTo(this.m,x);
         }
      }
      
      public function sqrTo(x:BigInteger, r:BigInteger) : void
      {
         x.squareTo(r);
         this.reduce(r);
      }
   }
}
