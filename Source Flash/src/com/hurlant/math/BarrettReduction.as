package com.hurlant.math
{
   use namespace bi_internal;
   
   public class BarrettReduction implements IReduction
   {
       
      
      private var r2:BigInteger;
      
      private var q3:BigInteger;
      
      private var mu:BigInteger;
      
      private var m:BigInteger;
      
      function BarrettReduction(m:BigInteger)
      {
         super();
         this.r2 = new BigInteger();
         this.q3 = new BigInteger();
         BigInteger.ONE.dlShiftTo(2 * m.t,this.r2);
         this.mu = this.r2.divide(m);
         this.m = m;
      }
      
      public function reduce(lx:BigInteger) : void
      {
         var x:BigInteger = null;
         x = lx as BigInteger;
         x.drShiftTo(this.m.t - 1,this.r2);
         if(x.t > this.m.t + 1)
         {
            x.t = this.m.t + 1;
            x.clamp();
         }
         this.mu.multiplyUpperTo(this.r2,this.m.t + 1,this.q3);
         this.m.multiplyLowerTo(this.q3,this.m.t + 1,this.r2);
         while(x.compareTo(this.r2) < 0)
         {
            x.dAddOffset(1,this.m.t + 1);
         }
         x.subTo(this.r2,x);
         while(x.compareTo(this.m) >= 0)
         {
            x.subTo(this.m,x);
         }
      }
      
      public function revert(x:BigInteger) : BigInteger
      {
         return x;
      }
      
      public function convert(x:BigInteger) : BigInteger
      {
         var r:BigInteger = null;
         if(x.s < 0 || x.t > 2 * this.m.t)
         {
            return x.mod(this.m);
         }
         if(x.compareTo(this.m) < 0)
         {
            return x;
         }
         r = new BigInteger();
         x.copyTo(r);
         this.reduce(r);
         return r;
      }
      
      public function sqrTo(x:BigInteger, r:BigInteger) : void
      {
         x.squareTo(r);
         this.reduce(r);
      }
      
      public function mulTo(x:BigInteger, y:BigInteger, r:BigInteger) : void
      {
         x.multiplyTo(y,r);
         this.reduce(r);
      }
   }
}
