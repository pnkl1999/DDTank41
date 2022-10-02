package com.wirelust.as3zlib
{
   import flash.utils.ByteArray;
   
   public final class Inflate
   {
      
      private static const MAX_WBITS:int = 15;
      
      private static const PRESET_DICT:int = 32;
      
      public static const Z_NO_FLUSH:int = 0;
      
      public static const Z_PARTIAL_FLUSH:int = 1;
      
      public static const Z_SYNC_FLUSH:int = 2;
      
      public static const Z_FULL_FLUSH:int = 3;
      
      public static const Z_FINISH:int = 4;
      
      private static const Z_DEFLATED:int = 8;
      
      private static const Z_OK:int = 0;
      
      private static const Z_STREAM_END:int = 1;
      
      private static const Z_NEED_DICT:int = 2;
      
      private static const Z_ERRNO:int = -1;
      
      private static const Z_STREAM_ERROR:int = -2;
      
      private static const Z_DATA_ERROR:int = -3;
      
      private static const Z_MEM_ERROR:int = -4;
      
      private static const Z_BUF_ERROR:int = -5;
      
      private static const Z_VERSION_ERROR:int = -6;
      
      public static const METHOD:int = 0;
      
      public static const FLAG:int = 1;
      
      public static const DICT4:int = 2;
      
      public static const DICT3:int = 3;
      
      public static const DICT2:int = 4;
      
      public static const DICT1:int = 5;
      
      public static const DICT0:int = 6;
      
      public static const BLOCKS:int = 7;
      
      public static const CHECK4:int = 8;
      
      public static const CHECK3:int = 9;
      
      public static const CHECK2:int = 10;
      
      public static const CHECK1:int = 11;
      
      public static const DONE:int = 12;
      
      public static const BAD:int = 13;
      
      private static var mark:Array = new Array(0,0,255,255);
       
      
      public var mode:int;
      
      public var method:int;
      
      public var was:Array;
      
      public var need:Number;
      
      public var marker:int;
      
      public var nowrap:int;
      
      public var wbits:int;
      
      public var blocks:InfBlocks;
      
      public function Inflate()
      {
         this.was = new Array();
         super();
      }
      
      public function inflateReset(param1:ZStream) : int
      {
         if(param1 == null || param1.istate == null)
         {
            return Z_STREAM_ERROR;
         }
         param1.total_out = 0;
         param1.total_in = 0;
         param1.msg = null;
         param1.istate.mode = param1.istate.nowrap != 0 ? int(int(BLOCKS)) : int(int(METHOD));
         param1.istate.blocks.reset(param1,null);
         return Z_OK;
      }
      
      public function inflateEnd(param1:ZStream) : int
      {
         if(this.blocks != null)
         {
            this.blocks.free(param1);
         }
         this.blocks = null;
         return Z_OK;
      }
      
      public function inflateInit(param1:ZStream, param2:int) : int
      {
         param1.msg = null;
         this.blocks = null;
         this.nowrap = 0;
         if(param2 < 0)
         {
            param2 = -param2;
            this.nowrap = 1;
         }
         if(param2 < 8 || param2 > 15)
         {
            this.inflateEnd(param1);
            return Z_STREAM_ERROR;
         }
         this.wbits = param2;
         param1.istate.blocks = new InfBlocks(param1,param1.istate.nowrap != 0 ? null : this,1 << param2);
         this.inflateReset(param1);
         return Z_OK;
      }
      
      public function inflate(param1:ZStream, param2:int) : int
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(param1 == null || param1.istate == null || param1.next_in == null)
         {
            return Z_STREAM_ERROR;
         }
         param2 = param2 == Z_FINISH?int(int(Z_BUF_ERROR)):int(int(Z_OK));
         _loc3_ = Z_BUF_ERROR;
         loop0:
         while(true)
         {
            if(true)
            {
               switch(param1.istate.mode)
               {
                  case METHOD:
                     if(param1.avail_in == 0)
                     {
                        return _loc3_;
                     }
                     _loc3_ = param2;
                     param1.avail_in--;
                     param1.total_in++;
                     if(((param1.istate.method = param1.next_in[param1.next_in_index++]) & 15) != Z_DEFLATED)
                     {
                        param1.istate.mode = BAD;
                        param1.msg = "unknown compression method";
                        param1.istate.marker = 5;
                        continue;
                     }
                     if((param1.istate.method >> 4) + 8 > param1.istate.wbits)
                     {
                        param1.istate.mode = BAD;
                        param1.msg = "invalid window size";
                        param1.istate.marker = 5;
                        continue;
                     }
                     param1.istate.mode = FLAG;
                  case FLAG:
                     if(param1.avail_in == 0)
                     {
                        return _loc3_;
                     }
                     _loc3_ = param2;
                     param1.avail_in--;
                     param1.total_in++;
                     _loc4_ = param1.next_in[param1.next_in_index++] & 255;
                     _loc5_ = ((param1.istate.method << 8) + _loc4_) % 31;
                     if(_loc5_ != 0)
                     {
                        param1.istate.mode = BAD;
                        param1.msg = "incorrect header check";
                        param1.istate.marker = 5;
                        continue;
                     }
                     if((_loc4_ & PRESET_DICT) == 0)
                     {
                        param1.istate.mode = BLOCKS;
                        continue;
                     }
                     param1.istate.mode = DICT4;
                  case DICT4:
                     if(param1.avail_in == 0)
                     {
                        return _loc3_;
                     }
                     _loc3_ = param2;
                     param1.avail_in--;
                     param1.total_in++;
                     param1.istate.need = (param1.next_in[param1.next_in_index++] & 255) << 24 & 4278190080;
                     param1.istate.mode = DICT3;
                  case DICT3:
                     if(param1.avail_in == 0)
                     {
                        return _loc3_;
                     }
                     _loc3_ = param2;
                     param1.avail_in--;
                     param1.total_in++;
                     param1.istate.need = param1.istate.need + ((param1.next_in[param1.next_in_index++] & 255) << 16 & 16711680);
                     param1.istate.mode = DICT2;
                  case DICT2:
                     if(param1.avail_in == 0)
                     {
                        return _loc3_;
                     }
                     _loc3_ = param2;
                     param1.avail_in--;
                     param1.total_in++;
                     param1.istate.need = param1.istate.need + ((param1.next_in[param1.next_in_index++] & 255) << 8 & 65280);
                     param1.istate.mode = DICT1;
                  case DICT1:
                     if(param1.avail_in == 0)
                     {
                        return _loc3_;
                     }
                     _loc3_ = param2;
                     param1.avail_in--;
                     param1.total_in++;
                     param1.istate.need = param1.istate.need + (param1.next_in[param1.next_in_index++] & 255);
                     param1.adler = param1.istate.need;
                     param1.istate.mode = DICT0;
                     return Z_NEED_DICT;
                  case DICT0:
                     break loop0;
                  case BLOCKS:
                     _loc3_ = param1.istate.blocks.proc(param1,_loc3_);
                     if(_loc3_ == Z_DATA_ERROR)
                     {
                        param1.istate.mode = BAD;
                        param1.istate.marker = 0;
                        continue;
                     }
                     if(_loc3_ == Z_OK)
                     {
                        _loc3_ = param2;
                     }
                     if(_loc3_ != Z_STREAM_END)
                     {
                        return _loc3_;
                     }
                     _loc3_ = param2;
                     param1.istate.blocks.reset(param1,param1.istate.was);
                     if(param1.istate.nowrap != 0)
                     {
                        param1.istate.mode = DONE;
                        continue;
                     }
                     param1.istate.mode = CHECK4;
                  case CHECK4:
                     if(param1.avail_in == 0)
                     {
                        return _loc3_;
                     }
                     _loc3_ = param2;
                     param1.avail_in--;
                     param1.total_in++;
                     param1.istate.need = (param1.next_in[param1.next_in_index++] & 255) << 24 & 4278190080;
                     param1.istate.mode = CHECK3;
                  case CHECK3:
                     if(param1.avail_in == 0)
                     {
                        return _loc3_;
                     }
                     _loc3_ = param2;
                     param1.avail_in--;
                     param1.total_in++;
                     param1.istate.need = param1.istate.need + ((param1.next_in[param1.next_in_index++] & 255) << 16 & 16711680);
                     param1.istate.mode = CHECK2;
                  case CHECK2:
                     if(param1.avail_in == 0)
                     {
                        return _loc3_;
                     }
                     _loc3_ = param2;
                     param1.avail_in--;
                     param1.total_in++;
                     param1.istate.need = param1.istate.need + ((param1.next_in[param1.next_in_index++] & 255) << 8 & 65280);
                     param1.istate.mode = CHECK1;
                  case CHECK1:
                     if(param1.avail_in == 0)
                     {
                        return _loc3_;
                     }
                     _loc3_ = param2;
                     param1.avail_in--;
                     param1.total_in++;
                     param1.istate.need = param1.istate.need + (param1.next_in[param1.next_in_index++] & 255);
                     if(int(param1.istate.was[0]) != int(param1.istate.need))
                     {
                        param1.istate.mode = BAD;
                        param1.msg = "incorrect data check";
                        param1.istate.marker = 5;
                        continue;
                     }
                     param1.istate.mode = DONE;
                  case DONE:
                     return Z_STREAM_END;
                  case BAD:
                     return Z_DATA_ERROR;
               }
            }
            return Z_STREAM_ERROR;
         }
         param1.istate.mode = BAD;
         param1.msg = "need dictionary";
         param1.istate.marker = 0;
         return Z_STREAM_ERROR;
      }
      
      public function inflateSetDictionary(param1:ZStream, param2:ByteArray, param3:int) : int
      {
         var _loc4_:int = 0;
         var _loc5_:int = param3;
         if(param1 == null || param1.istate == null || param1.istate.mode != DICT0)
         {
            return Z_STREAM_ERROR;
         }
         if(param1._adler.adler32(1,param2,0,param3) != param1.adler)
         {
            return Z_DATA_ERROR;
         }
         param1.adler = param1._adler.adler32(0,null,0,0);
         if(_loc5_ >= 1 << param1.istate.wbits)
         {
            _loc5_ = (1 << param1.istate.wbits) - 1;
            _loc4_ = param3 - _loc5_;
         }
         param1.istate.blocks.set_dictionary(param2,_loc4_,_loc5_);
         param1.istate.mode = BLOCKS;
         return Z_OK;
      }
      
      public function inflateSync(param1:ZStream) : int
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         if(param1 == null || param1.istate == null)
         {
            return Z_STREAM_ERROR;
         }
         if(param1.istate.mode != BAD)
         {
            param1.istate.mode = BAD;
            param1.istate.marker = 0;
         }
         if((_loc2_ = param1.avail_in) == 0)
         {
            return Z_BUF_ERROR;
         }
         _loc3_ = param1.next_in_index;
         _loc4_ = param1.istate.marker;
         while(_loc2_ != 0 && _loc4_ < 4)
         {
            if(param1.next_in[_loc3_] == mark[_loc4_])
            {
               _loc4_++;
            }
            else if(param1.next_in[_loc3_] != 0)
            {
               _loc4_ = 0;
            }
            else
            {
               _loc4_ = 4 - _loc4_;
            }
            _loc3_++;
            _loc2_--;
         }
         param1.total_in += _loc3_ - param1.next_in_index;
         param1.next_in_index = _loc3_;
         param1.avail_in = _loc2_;
         param1.istate.marker = _loc4_;
         if(_loc4_ != 4)
         {
            return Z_DATA_ERROR;
         }
         _loc5_ = param1.total_in;
         _loc6_ = param1.total_out;
         this.inflateReset(param1);
         param1.total_in = _loc5_;
         param1.total_out = _loc6_;
         param1.istate.mode = BLOCKS;
         return Z_OK;
      }
      
      public function inflateSyncPoint(param1:ZStream) : int
      {
         if(param1 == null || param1.istate == null || param1.istate.blocks == null)
         {
            return Z_STREAM_ERROR;
         }
         return param1.istate.blocks.sync_point();
      }
   }
}
