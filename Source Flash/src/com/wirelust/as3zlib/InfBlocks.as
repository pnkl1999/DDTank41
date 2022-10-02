package com.wirelust.as3zlib
{
   import com.wirelust.util.Cast;
   import flash.utils.ByteArray;
   
   public final class InfBlocks
   {
      
      private static const MANY:int = 1440;
      
      private static const inflate_mask:Array = new Array(0,1,3,7,15,31,63,127,255,511,1023,2047,4095,8191,16383,32767,65535);
      
      public static const border:Array = new Array(16,17,18,0,8,7,9,6,10,5,11,4,12,3,13,2,14,1,15);
      
      private static const Z_OK:int = 0;
      
      private static const Z_STREAM_END:int = 1;
      
      private static const Z_NEED_DICT:int = 2;
      
      private static const Z_ERRNO:int = -1;
      
      private static const Z_STREAM_ERROR:int = -2;
      
      private static const Z_DATA_ERROR:int = -3;
      
      private static const Z_MEM_ERROR:int = -4;
      
      private static const Z_BUF_ERROR:int = -5;
      
      private static const Z_VERSION_ERROR:int = -6;
      
      private static const TYPE:int = 0;
      
      private static const LENS:int = 1;
      
      private static const STORED:int = 2;
      
      private static const TABLE:int = 3;
      
      private static const BTREE:int = 4;
      
      private static const DTREE:int = 5;
      
      private static const CODES:int = 6;
      
      private static const DRY:int = 7;
      
      private static const DONE:int = 8;
      
      private static const BAD:int = 9;
       
      
      public var mode:int;
      
      public var left:int;
      
      public var table:int;
      
      public var index:int;
      
      public var blens:Array;
      
      public var bb:Array;
      
      public var tb:Array;
      
      public var codes:InfCodes;
      
      public var last:int;
      
      public var bitk:int;
      
      public var bitb:int;
      
      public var hufts:Array;
      
      public var window:ByteArray;
      
      public var end:int;
      
      public var read:int;
      
      public var write:int;
      
      public var checkfn:Object;
      
      public var check:Number;
      
      public var inftree:InfTree;
      
      public function InfBlocks(param1:ZStream, param2:Object, param3:int)
      {
         this.bb = new Array();
         this.tb = new Array();
         this.codes = new InfCodes();
         this.inftree = new InfTree();
         super();
         this.hufts = new Array();
         this.window = new ByteArray();
         this.end = param3;
         this.checkfn = param2;
         this.mode = TYPE;
         this.reset(param1,null);
      }
      
      public function reset(param1:ZStream, param2:Array) : void
      {
         if(param2 != null)
         {
            param2[0] = this.check;
         }
         if(this.mode == BTREE || this.mode == DTREE)
         {
         }
         if(this.mode == CODES)
         {
            this.codes.free(param1);
         }
         this.mode = TYPE;
         this.bitk = 0;
         this.bitb = 0;
         this.read = this.write = 0;
         if(this.checkfn != null)
         {
            param1.adler = this.check = param1._adler.adler32(0,null,0,0);
         }
      }
      
      public function proc(param1:ZStream, param2:int) : int
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Array = null;
         var _loc11_:Array = null;
         var _loc12_:Array = null;
         var _loc13_:Array = null;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         _loc6_ = param1.next_in_index;
         _loc7_ = param1.avail_in;
         _loc4_ = this.bitb;
         _loc5_ = this.bitk;
         _loc8_ = this.write;
         _loc9_ = int(_loc8_ < this.read ? this.read - _loc8_ - 1 : this.end - _loc8_);
         while(true)
         {
            switch(this.mode)
            {
               case TYPE:
                  while(_loc5_ < 3)
                  {
                     if(_loc7_ == 0)
                     {
                        this.bitb = _loc4_;
                        this.bitk = _loc5_;
                        param1.avail_in = _loc7_;
                        param1.total_in += _loc6_ - param1.next_in_index;
                     }
                     continue;
                     param1.next_in_index = _loc6_;
                     this.write = _loc8_;
                     param2 = Z_OK;
                     _loc7_--;
                     param1.next_in.position = _loc6_++;
                     _loc18_ = Cast.toByte(param1.next_in.readByte());
                     _loc4_ |= (_loc18_ & 255) << _loc5_;
                     _loc5_ += 8;
                     return this.inflate_flush(param1,param2);
                  }
                  _loc3_ = int(_loc4_ & 7);
                  this.last = _loc3_ & 1;
                  switch(_loc3_ >>> 1)
                  {
                     case 0:
                        _loc4_ >>>= 3;
                        _loc5_ -= 3;
                        _loc3_ = _loc5_ & 7;
                        _loc4_ >>>= _loc3_;
                        _loc5_ -= _loc3_;
                        this.mode = LENS;
                        break;
                     case 1:
                        _loc10_ = new Array(1);
                        _loc11_ = new Array(1);
                        _loc12_ = new Array();
                        _loc12_[0] = new Array();
                        _loc13_ = new Array();
                        _loc13_[0] = new Array();
                        InfTree.inflate_trees_fixed(_loc10_,_loc11_,_loc12_,_loc13_,param1);
                        this.codes.init(_loc10_[0],_loc11_[0],_loc12_[0],0,_loc13_[0],0,param1);
                        _loc4_ >>>= 3;
                        _loc5_ -= 3;
                        this.mode = CODES;
                        break;
                     case 2:
                        _loc4_ >>>= 3;
                        _loc5_ -= 3;
                        this.mode = TABLE;
                        break;
                     case 3:
                        _loc4_ >>>= 3;
                        _loc5_ -= 3;
                        this.mode = BAD;
                        param1.msg = "invalid block type";
                        param2 = Z_DATA_ERROR;
                        this.bitb = _loc4_;
                        this.bitk = _loc5_;
                        param1.avail_in = _loc7_;
                        param1.total_in += _loc6_ - param1.next_in_index;
                        param1.next_in_index = _loc6_;
                        this.write = _loc8_;
                        return this.inflate_flush(param1,param2);
                  }
                  continue;
               case LENS:
                  while(_loc5_ < 32)
                  {
                     if(_loc7_ == 0)
                     {
                        this.bitb = _loc4_;
                        this.bitk = _loc5_;
                        param1.avail_in = _loc7_;
                        param1.total_in += _loc6_ - param1.next_in_index;
                     }
                     continue;
                     param1.next_in_index = _loc6_;
                     this.write = _loc8_;
                     param2 = Z_OK;
                     _loc7_--;
                     _loc4_ |= (param1.next_in[_loc6_++] & 255) << _loc5_;
                     _loc5_ += 8;
                     return this.inflate_flush(param1,param2);
                  }
                  if((~_loc4_ >>> 16 & 65535) != (_loc4_ & 65535))
                  {
                     this.mode = BAD;
                     param1.msg = "invalid stored block lengths";
                     param2 = Z_DATA_ERROR;
                     this.bitb = _loc4_;
                     this.bitk = _loc5_;
                     param1.avail_in = _loc7_;
                     param1.total_in += _loc6_ - param1.next_in_index;
                     param1.next_in_index = _loc6_;
                     this.write = _loc8_;
                     return this.inflate_flush(param1,param2);
                  }
                  this.left = _loc4_ & 65535;
                  _loc4_ = _loc5_ = 0;
                  this.mode = this.left != 0 ? int(int(STORED)) : (this.last != 0 ? int(int(DRY)) : int(int(TYPE)));
                  continue;
               case STORED:
                  if(_loc7_ == 0)
                  {
                     this.bitb = _loc4_;
                     this.bitk = _loc5_;
                     param1.avail_in = _loc7_;
                     param1.total_in += _loc6_ - param1.next_in_index;
                     param1.next_in_index = _loc6_;
                     this.write = _loc8_;
                     return this.inflate_flush(param1,param2);
                  }
                  if(_loc9_ == 0)
                  {
                     if(_loc8_ == this.end && this.read != 0)
                     {
                        _loc8_ = 0;
                        _loc9_ = int(_loc8_ < this.read ? this.read - _loc8_ - 1 : this.end - _loc8_);
                     }
                     if(_loc9_ == 0)
                     {
                        this.write = _loc8_;
                        param2 = this.inflate_flush(param1,param2);
                        _loc8_ = this.write;
                        _loc9_ = int(_loc8_ < this.read ? this.read - _loc8_ - 1 : this.end - _loc8_);
                        if(_loc8_ == this.end && this.read != 0)
                        {
                           _loc8_ = 0;
                           _loc9_ = int(_loc8_ < this.read ? this.read - _loc8_ - 1 : this.end - _loc8_);
                        }
                        if(_loc9_ == 0)
                        {
                           this.bitb = _loc4_;
                           this.bitk = _loc5_;
                           param1.avail_in = _loc7_;
                           param1.total_in += _loc6_ - param1.next_in_index;
                           param1.next_in_index = _loc6_;
                           this.write = _loc8_;
                           return this.inflate_flush(param1,param2);
                        }
                     }
                  }
                  param2 = Z_OK;
                  _loc3_ = this.left;
                  if(_loc3_ > _loc7_)
                  {
                     _loc3_ = _loc7_;
                  }
                  if(_loc3_ > _loc9_)
                  {
                     _loc3_ = _loc9_;
                  }
                  System.byteArrayCopy(param1.next_in,_loc6_,this.window,_loc8_,_loc3_);
                  _loc6_ += _loc3_;
                  _loc7_ -= _loc3_;
                  _loc8_ += _loc3_;
                  _loc9_ -= _loc3_;
                  if((this.left = this.left - _loc3_) == 0)
                  {
                     this.mode = this.last != 0 ? int(int(DRY)) : int(int(TYPE));
                  }
                  continue;
               case TABLE:
                  while(_loc5_ < 14)
                  {
                     if(_loc7_ == 0)
                     {
                        this.bitb = _loc4_;
                        this.bitk = _loc5_;
                        param1.avail_in = _loc7_;
                        param1.total_in += _loc6_ - param1.next_in_index;
                     }
                     continue;
                     param1.next_in_index = _loc6_;
                     this.write = _loc8_;
                     param2 = Z_OK;
                     _loc7_--;
                     _loc4_ |= (param1.next_in[_loc6_++] & 255) << _loc5_;
                     _loc5_ += 8;
                     return this.inflate_flush(param1,param2);
                  }
                  if(((this.table = int(_loc4_ & 16383)) & 31) > 29 || (_loc3_ >> 5 & 31) > 29)
                  {
                     this.mode = BAD;
                     param1.msg = "too many length or distance symbols";
                     param2 = Z_DATA_ERROR;
                     this.bitb = _loc4_;
                     this.bitk = _loc5_;
                     param1.avail_in = _loc7_;
                     param1.total_in += _loc6_ - param1.next_in_index;
                     param1.next_in_index = _loc6_;
                     this.write = _loc8_;
                     return this.inflate_flush(param1,param2);
                  }
                  _loc3_ = 258 + (_loc3_ & 31) + (_loc3_ >> 5 & 31);
                  if(this.blens == null || this.blens.length < _loc3_)
                  {
                     this.blens = new Array();
                  }
                  else
                  {
                     _loc15_ = 0;
                     while(_loc15_ < _loc3_)
                     {
                        this.blens[_loc15_] = 0;
                        _loc15_++;
                     }
                  }
                  _loc4_ >>>= 14;
                  _loc5_ -= 14;
                  this.index = 0;
                  this.mode = BTREE;
               case BTREE:
                  while(this.index < 4 + (this.table >>> 10))
                  {
                     while(_loc5_ < 3)
                     {
                        if(_loc7_ == 0)
                        {
                           this.bitb = _loc4_;
                           this.bitk = _loc5_;
                           param1.avail_in = _loc7_;
                           param1.total_in += _loc6_ - param1.next_in_index;
                        }
                        continue;
                        param1.next_in_index = _loc6_;
                        this.write = _loc8_;
                        param2 = Z_OK;
                        _loc7_--;
                        _loc4_ |= (param1.next_in[_loc6_++] & 255) << _loc5_;
                        _loc5_ += 8;
                        return this.inflate_flush(param1,param2);
                     }
                     this.blens[border[this.index++]] = _loc4_ & 7;
                     _loc4_ >>>= 3;
                     _loc5_ -= 3;
                  }
                  while(this.index < 19)
                  {
                     this.blens[border[this.index++]] = 0;
                  }
                  this.bb[0] = 7;
                  _loc3_ = this.inftree.inflate_trees_bits(this.blens,this.bb,this.tb,this.hufts,param1);
                  if(_loc3_ != Z_OK)
                  {
                     param2 = _loc3_;
                     if(param2 == Z_DATA_ERROR)
                     {
                        this.blens = null;
                        this.mode = BAD;
                     }
                     this.bitb = _loc4_;
                     this.bitk = _loc5_;
                     param1.avail_in = _loc7_;
                     param1.total_in += _loc6_ - param1.next_in_index;
                     param1.next_in_index = _loc6_;
                     this.write = _loc8_;
                     return this.inflate_flush(param1,param2);
                  }
                  this.index = 0;
                  this.mode = DTREE;
               case DTREE:
                  while(true)
                  {
                     _loc3_ = this.table;
                     if(this.index >= 258 + (_loc3_ & 31) + (_loc3_ >> 5 & 31))
                     {
                        break;
                     }
                     _loc3_ = this.bb[0];
                     while(_loc5_ < _loc3_)
                     {
                        if(_loc7_ == 0)
                        {
                           this.bitb = _loc4_;
                           this.bitk = _loc5_;
                           param1.avail_in = _loc7_;
                           param1.total_in += _loc6_ - param1.next_in_index;
                        }
                        continue;
                        param1.next_in_index = _loc6_;
                        this.write = _loc8_;
                        param2 = Z_OK;
                        _loc7_--;
                        _loc4_ |= (param1.next_in[_loc6_++] & 255) << _loc5_;
                        _loc5_ += 8;
                        return this.inflate_flush(param1,param2);
                     }
                     if(this.tb[0] == -1)
                     {
                     }
                     _loc3_ = this.hufts[(this.tb[0] + (_loc4_ & inflate_mask[_loc3_])) * 3 + 1];
                     _loc17_ = this.hufts[(this.tb[0] + (_loc4_ & inflate_mask[_loc3_])) * 3 + 2];
                     if(_loc17_ < 16)
                     {
                        _loc4_ >>>= _loc3_;
                        _loc5_ -= _loc3_;
                        var _loc19_:* = this.index++;
                        this.blens[_loc19_] = _loc17_;
                     }
                     else
                     {
                        _loc15_ = _loc17_ == 18 ? int(int(7)) : int(int(_loc17_ - 14));
                        _loc16_ = _loc17_ == 18 ? int(int(11)) : int(int(3));
                        while(_loc5_ < _loc3_ + _loc15_)
                        {
                           if(_loc7_ == 0)
                           {
                              this.bitb = _loc4_;
                              this.bitk = _loc5_;
                              param1.avail_in = _loc7_;
                              param1.total_in += _loc6_ - param1.next_in_index;
                           }
                           continue;
                           param1.next_in_index = _loc6_;
                           this.write = _loc8_;
                           param2 = Z_OK;
                           _loc7_--;
                           _loc4_ |= (param1.next_in[_loc6_++] & 255) << _loc5_;
                           _loc5_ += 8;
                           return this.inflate_flush(param1,param2);
                        }
                        _loc4_ >>>= _loc3_;
                        _loc5_ -= _loc3_;
                        _loc16_ += _loc4_ & inflate_mask[_loc15_];
                        _loc4_ >>>= _loc15_;
                        _loc5_ -= _loc15_;
                        _loc15_ = this.index;
                        _loc3_ = this.table;
                        if(_loc15_ + _loc16_ > 258 + (_loc3_ & 31) + (_loc3_ >> 5 & 31) || _loc17_ == 16 && _loc15_ < 1)
                        {
                           this.blens = null;
                           this.mode = BAD;
                           param1.msg = "invalid bit length repeat";
                           param2 = Z_DATA_ERROR;
                           this.bitb = _loc4_;
                           this.bitk = _loc5_;
                           param1.avail_in = _loc7_;
                           param1.total_in += _loc6_ - param1.next_in_index;
                           param1.next_in_index = _loc6_;
                           this.write = _loc8_;
                           return this.inflate_flush(param1,param2);
                        }
                        _loc17_ = _loc17_ == 16 ? int(int(this.blens[_loc15_ - 1])) : int(int(0));
                        do
                        {
                           _loc19_ = _loc15_++;
                           this.blens[_loc19_] = _loc17_;
                        }
                        while(--_loc16_ != 0);
                        
                        this.index = _loc15_;
                     }
                  }
                  this.tb[0] = -1;
                  _loc10_ = new Array();
                  _loc11_ = new Array();
                  _loc12_ = new Array();
                  _loc13_ = new Array();
                  _loc10_[0] = 9;
                  _loc11_[0] = 6;
                  _loc3_ = this.table;
                  _loc3_ = this.inftree.inflate_trees_dynamic(257 + (_loc3_ & 31),1 + (_loc3_ >> 5 & 31),this.blens,_loc10_,_loc11_,_loc12_,_loc13_,this.hufts,param1);
                  if(_loc3_ != Z_OK)
                  {
                     if(_loc3_ == Z_DATA_ERROR)
                     {
                        this.blens = null;
                        this.mode = BAD;
                     }
                     param2 = _loc3_;
                     this.bitb = _loc4_;
                     this.bitk = _loc5_;
                     param1.avail_in = _loc7_;
                     param1.total_in += _loc6_ - param1.next_in_index;
                     param1.next_in_index = _loc6_;
                     this.write = _loc8_;
                     return this.inflate_flush(param1,param2);
                  }
                  this.codes.init(_loc10_[0],_loc11_[0],this.hufts,_loc12_[0],this.hufts,_loc13_[0],param1);
                  this.mode = CODES;
               case CODES:
                  this.bitb = _loc4_;
                  this.bitk = _loc5_;
                  param1.avail_in = _loc7_;
                  param1.total_in += _loc6_ - param1.next_in_index;
                  param1.next_in_index = _loc6_;
                  this.write = _loc8_;
                  if((param2 = this.codes.proc(this,param1,param2)) != Z_STREAM_END)
                  {
                     return this.inflate_flush(param1,param2);
                  }
                  param2 = Z_OK;
                  this.codes.free(param1);
                  _loc6_ = param1.next_in_index;
                  _loc7_ = param1.avail_in;
                  _loc4_ = this.bitb;
                  _loc5_ = this.bitk;
                  _loc8_ = this.write;
                  _loc9_ = int(_loc8_ < this.read ? this.read - _loc8_ - 1 : this.end - _loc8_);
                  if(this.last == 0)
                  {
                     this.mode = TYPE;
                     continue;
                  }
                  this.mode = DRY;
               case DRY:
                  this.write = _loc8_;
                  param2 = this.inflate_flush(param1,param2);
                  _loc8_ = this.write;
                  _loc9_ = int(_loc8_ < this.read ? this.read - _loc8_ - 1 : this.end - _loc8_);
                  if(this.read != this.write)
                  {
                     this.bitb = _loc4_;
                     this.bitk = _loc5_;
                     param1.avail_in = _loc7_;
                     param1.total_in += _loc6_ - param1.next_in_index;
                     param1.next_in_index = _loc6_;
                     this.write = _loc8_;
                     return this.inflate_flush(param1,param2);
                  }
                  this.mode = DONE;
                  break;
               case DONE:
                  break;
               case BAD:
                  param2 = Z_DATA_ERROR;
                  this.bitb = _loc4_;
                  this.bitk = _loc5_;
                  param1.avail_in = _loc7_;
                  param1.total_in += _loc6_ - param1.next_in_index;
                  param1.next_in_index = _loc6_;
                  this.write = _loc8_;
                  return this.inflate_flush(param1,param2);
            }
            param2 = Z_STREAM_END;
            this.bitb = _loc4_;
            this.bitk = _loc5_;
            param1.avail_in = _loc7_;
            param1.total_in += _loc6_ - param1.next_in_index;
            param1.next_in_index = _loc6_;
            this.write = _loc8_;
            return this.inflate_flush(param1,param2);
         }
         param2 = Z_STREAM_ERROR;
         this.bitb = _loc4_;
         this.bitk = _loc5_;
         param1.avail_in = _loc7_;
         param1.total_in += _loc6_ - param1.next_in_index;
         param1.next_in_index = _loc6_;
         this.write = _loc8_;
         return this.inflate_flush(param1,param2);
      }
      
      public function free(param1:ZStream) : void
      {
         this.reset(param1,null);
         this.window = null;
         this.hufts = null;
      }
      
      public function set_dictionary(param1:ByteArray, param2:int, param3:int) : void
      {
         System.byteArrayCopy(param1,param2,this.window,0,param3);
         this.read = this.write = param3;
      }
      
      public function sync_point() : int
      {
         return this.mode == LENS ? int(int(1)) : int(int(0));
      }
      
      public function inflate_flush(param1:ZStream, param2:int) : int
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         _loc4_ = param1.next_out_index;
         _loc5_ = this.read;
         _loc3_ = int((_loc5_ <= this.write ? this.write : this.end) - _loc5_);
         if(_loc3_ > param1.avail_out)
         {
            _loc3_ = param1.avail_out;
         }
         if(_loc3_ != 0 && param2 == Z_BUF_ERROR)
         {
            param2 = Z_OK;
         }
         param1.avail_out -= _loc3_;
         param1.total_out += _loc3_;
         if(this.checkfn != null)
         {
            param1.adler = this.check = param1._adler.adler32(this.check,this.window,_loc5_,_loc3_);
         }
         System.byteArrayCopy(this.window,_loc5_,param1.next_out,_loc4_,_loc3_);
         _loc4_ += _loc3_;
         _loc5_ += _loc3_;
         if(_loc5_ == this.end)
         {
            _loc5_ = 0;
            if(this.write == this.end)
            {
               this.write = 0;
            }
            _loc3_ = this.write - _loc5_;
            if(_loc3_ > param1.avail_out)
            {
               _loc3_ = param1.avail_out;
            }
            if(_loc3_ != 0 && param2 == Z_BUF_ERROR)
            {
               param2 = Z_OK;
            }
            param1.avail_out -= _loc3_;
            param1.total_out += _loc3_;
            if(this.checkfn != null)
            {
               param1.adler = this.check = param1._adler.adler32(this.check,this.window,_loc5_,_loc3_);
            }
            System.byteArrayCopy(this.window,_loc5_,param1.next_out,_loc4_,_loc3_);
            _loc4_ += _loc3_;
            _loc5_ += _loc3_;
         }
         param1.next_out_index = _loc4_;
         this.read = _loc5_;
         return param2;
      }
   }
}
