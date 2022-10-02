package com.wirelust.as3zlib
{
   import com.wirelust.util.Cast;
   
   public final class Tree
   {
      
      private static const MAX_BITS:int = 15;
      
      private static const BL_CODES:int = 19;
      
      private static const D_CODES:int = 30;
      
      private static const LITERALS:int = 256;
      
      private static const LENGTH_CODES:int = 29;
      
      private static const L_CODES:int = LITERALS + 1 + LENGTH_CODES;
      
      private static const HEAP_SIZE:int = 2 * L_CODES + 1;
      
      public static const MAX_BL_BITS:int = 7;
      
      public static const END_BLOCK:int = 256;
      
      public static const REP_3_6:int = 16;
      
      public static const REPZ_3_10:int = 17;
      
      public static const REPZ_11_138:int = 18;
      
      public static const extra_lbits:Array = new Array(0,0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,0);
      
      public static const extra_dbits:Array = new Array(0,0,0,0,1,1,2,2,3,3,4,4,5,5,6,6,7,7,8,8,9,9,10,10,11,11,12,12,13,13);
      
      public static const extra_blbits:Array = new Array(0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,3,7);
      
      public static const bl_order:Array = new Array(16,17,18,0,8,7,9,6,10,5,11,4,12,3,13,2,14,1,15);
      
      public static const Buf_size:int = 8 * 2;
      
      public static const DIST_CODE_LEN:int = 512;
      
      public static const _dist_code:Array = new Array(0,1,2,3,4,4,5,5,6,6,6,6,7,7,7,7,8,8,8,8,8,8,8,8,9,9,9,9,9,9,9,9,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,10,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,11,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,12,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,13,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,14,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,15,0,0,16,17,18,18,19,19,20,20,20,20,21,21,21,21,22,22,22,22,22,22,22,22,23,23,23,23,23,23,23,23,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,28,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29,29);
      
      public static const _length_code:Array = new Array(0,1,2,3,4,5,6,7,8,8,9,9,10,10,11,11,12,12,12,12,13,13,13,13,14,14,14,14,15,15,15,15,16,16,16,16,16,16,16,16,17,17,17,17,17,17,17,17,18,18,18,18,18,18,18,18,19,19,19,19,19,19,19,19,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,22,22,22,22,22,22,22,22,22,22,22,22,22,22,22,22,23,23,23,23,23,23,23,23,23,23,23,23,23,23,23,23,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,24,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,25,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,26,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,27,28);
      
      public static const base_length:Array = new Array(0,1,2,3,4,5,6,7,8,10,12,14,16,20,24,28,32,40,48,56,64,80,96,112,128,160,192,224,0);
      
      public static const base_dist:Array = new Array(0,1,2,3,4,6,8,12,16,24,32,48,64,96,128,192,256,384,512,768,1024,1536,2048,3072,4096,6144,8192,12288,16384,24576);
       
      
      public var dyn_tree:Array;
      
      public var max_code:int;
      
      public var stat_desc:StaticTree;
      
      public function Tree()
      {
         super();
      }
      
      public static function d_code(param1:int) : int
      {
         return param1 < 256 ? int(int(_dist_code[param1])) : int(int(_dist_code[256 + (param1 >>> 7)]));
      }
      
      public static function gen_codes(param1:Array, param2:int, param3:Array) : void
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc4_:Array = new Array();
         var _loc5_:Number = 0;
         _loc6_ = 1;
         while(_loc6_ <= MAX_BITS)
         {
            _loc4_[_loc6_] = _loc5_ = _loc5_ + param3[_loc6_ - 1] << 1;
            _loc6_++;
         }
         _loc7_ = 0;
         while(_loc7_ <= param2)
         {
            _loc8_ = param1[_loc7_ * 2 + 1];
            if(_loc8_ != 0)
            {
               param1[_loc7_ * 2] = bi_reverse(int(_loc4_[_loc8_]++),_loc8_);
            }
            _loc7_++;
         }
      }
      
      public static function bi_reverse(param1:int, param2:int) : int
      {
         var _loc3_:int = 0;
         do
         {
            _loc3_ |= param1 & 1;
            param1 >>>= 1;
            _loc3_ <<= 1;
         }
         while(--param2 > 0);
         
         return _loc3_ >>> 1;
      }
      
      public function gen_bitlen(param1:Deflate) : void
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:Number = NaN;
         var _loc2_:Array = this.dyn_tree;
         var _loc3_:Array = this.stat_desc.static_tree;
         var _loc4_:Array = this.stat_desc.extra_bits;
         var _loc5_:int = this.stat_desc.extra_base;
         var _loc6_:int = this.stat_desc.max_length;
         var _loc13_:int = 0;
         _loc10_ = 0;
         while(_loc10_ <= MAX_BITS)
         {
            param1.bl_count[_loc10_] = 0;
            _loc10_++;
         }
         _loc2_[param1.heap[param1.heap_max] * 2 + 1] = 0;
         _loc7_ = param1.heap_max + 1;
         while(_loc7_ < HEAP_SIZE)
         {
            _loc8_ = param1.heap[_loc7_];
            _loc10_ = _loc2_[_loc2_[_loc8_ * 2 + 1] * 2 + 1] + 1;
            if(_loc10_ > _loc6_)
            {
               _loc10_ = _loc6_;
               _loc13_++;
            }
            _loc2_[_loc8_ * 2 + 1] = Cast.toShort(_loc10_);
            if(_loc8_ <= this.max_code)
            {
               ++param1.bl_count[_loc10_];
               _loc11_ = 0;
               if(_loc8_ >= _loc5_)
               {
                  _loc11_ = _loc4_[_loc8_ - _loc5_];
               }
               _loc12_ = _loc2_[_loc8_ * 2];
               param1.opt_len += _loc12_ * (_loc10_ + _loc11_);
               if(_loc3_ != null)
               {
                  param1.static_len += _loc12_ * (_loc3_[_loc8_ * 2 + 1] + _loc11_);
               }
            }
            _loc7_++;
         }
         if(_loc13_ == 0)
         {
            return;
         }
         do
         {
            _loc10_ = _loc6_ - 1;
            while(param1.bl_count[_loc10_] == 0)
            {
               _loc10_--;
            }
            --param1.bl_count[_loc10_];
            param1.bl_count[_loc10_ + 1] += 2;
            --param1.bl_count[_loc6_];
            _loc13_ -= 2;
         }
         while(_loc13_ > 0);
         
         _loc10_ = _loc6_;
         while(_loc10_ != 0)
         {
            _loc8_ = param1.bl_count[_loc10_];
            while(_loc8_ != 0)
            {
               _loc9_ = param1.heap[--_loc7_];
               if(_loc9_ <= this.max_code)
               {
                  if(_loc2_[_loc9_ * 2 + 1] != _loc10_)
                  {
                     param1.opt_len += (_loc10_ - _loc2_[_loc9_ * 2 + 1]) * _loc2_[_loc9_ * 2];
                     _loc2_[_loc9_ * 2 + 1] = Cast.toShort(_loc10_);
                  }
                  _loc8_--;
               }
            }
            _loc10_--;
         }
      }
      
      public function build_tree(param1:Deflate) : void
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc8_:int = 0;
         var _loc2_:Array = this.dyn_tree;
         var _loc3_:Array = this.stat_desc.static_tree;
         var _loc4_:int = this.stat_desc.elems;
         var _loc7_:int = -1;
         param1.heap_len = 0;
         param1.heap_max = HEAP_SIZE;
         _loc5_ = 0;
         while(_loc5_ < _loc4_)
         {
            if(_loc2_[_loc5_ * 2] != 0)
            {
               var _loc9_:* = ++param1.heap_len;
               param1.heap[_loc9_] = _loc7_ = _loc5_;
               param1.depth[_loc5_] = 0;
            }
            else
            {
               _loc2_[_loc5_ * 2 + 1] = 0;
            }
            _loc5_++;
         }
         while(param1.heap_len < 2)
         {
            _loc9_ = ++param1.heap_len;
            _loc8_ = param1.heap[_loc9_] = _loc7_ < 2 ? ++_loc7_ : 0;
            _loc2_[_loc8_ * 2] = 1;
            param1.depth[_loc8_] = 0;
            --param1.opt_len;
            if(_loc3_ != null)
            {
               param1.static_len -= _loc3_[_loc8_ * 2 + 1];
            }
         }
         this.max_code = _loc7_;
         _loc5_ = param1.heap_len / 2;
         while(_loc5_ >= 1)
         {
            param1.pqdownheap(_loc2_,_loc5_);
            _loc5_--;
         }
         _loc8_ = _loc4_;
         do
         {
            _loc5_ = param1.heap[1];
            param1.heap[1] = param1.heap[param1.heap_len--];
            param1.pqdownheap(_loc2_,1);
            _loc6_ = param1.heap[1];
            _loc9_ = --param1.heap_max;
            param1.heap[_loc9_] = _loc5_;
            var _loc10_:* = --param1.heap_max;
            param1.heap[_loc10_] = _loc6_;
            _loc2_[_loc8_ * 2] = _loc2_[_loc5_ * 2] + _loc2_[_loc6_ * 2];
            param1.depth[_loc8_] = Math.max(param1.depth[_loc5_],param1.depth[_loc6_]) + 1;
            _loc2_[_loc5_ * 2 + 1] = _loc2_[_loc6_ * 2 + 1] = _loc8_;
            param1.heap[1] = _loc8_++;
            param1.pqdownheap(_loc2_,1);
         }
         while(param1.heap_len >= 2);
         
         _loc9_ = ++param1.heap_len;
         param1.heap[_loc9_] = param1.heap[1];
         this.gen_bitlen(param1);
         gen_codes(_loc2_,_loc7_,param1.bl_count);
      }
   }
}
