package com.wirelust.as3zlib
{
   public final class InfCodes
   {
      
      private static const BADCODE:int = 9;
      
      private static const COPY:int = 5;
      
      private static const DIST:int = 3;
      
      private static const DISTEXT:int = 4;
      
      private static const END:int = 8;
      
      private static const LEN:int = 1;
      
      private static const LENEXT:int = 2;
      
      private static const LIT:int = 6;
      
      private static const START:int = 0;
      
      private static const WASH:int = 7;
      
      private static const Z_BUF_ERROR:int = -5;
      
      private static const Z_DATA_ERROR:int = -3;
      
      private static const Z_ERRNO:int = -1;
      
      private static const Z_MEM_ERROR:int = -4;
      
      private static const Z_NEED_DICT:int = 2;
      
      private static const Z_OK:int = 0;
      
      private static const Z_STREAM_END:int = 1;
      
      private static const Z_STREAM_ERROR:int = -2;
      
      private static const Z_VERSION_ERROR:int = -6;
      
      private static const inflate_mask:Array = new Array(0,1,3,7,15,31,63,127,255,511,1023,2047,4095,8191,16383,32767,65535);
       
      
      public var dbits:uint;
      
      public var dist:int;
      
      public var dtree:Array;
      
      public var dtree_index:int;
      
      public var getBits:int;
      
      public var lbits:uint;
      
      public var len:int;
      
      public var lit:int;
      
      public var ltree:Array;
      
      public var ltree_index:int;
      
      public var mode:int;
      
      public var need:int;
      
      public var tree:Array;
      
      public var tree_index:int = 0;
      
      function InfCodes()
      {
         super();
      }
      
      public function free(param1:ZStream) : void
      {
      }
      
      public function inflate_fast(param1:int, param2:int, param3:Array, param4:int, param5:Array, param6:int, param7:InfBlocks, param8:ZStream) : int
      {
         var _loc25_:* = undefined;
         var _loc9_:int = 0;
         var _loc10_:Array = null;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:int = 0;
         var _loc19_:int = 0;
         var _loc20_:int = 0;
         var _loc21_:int = 0;
         var _loc22_:int = 0;
         var _loc23_:int = 0;
         var _loc24_:int = 0;
         _loc15_ = param8.next_in_index;
         _loc16_ = param8.avail_in;
         _loc13_ = param7.bitb;
         _loc14_ = param7.bitk;
         _loc17_ = param7.write;
         _loc18_ = _loc17_ < param7.read ? int(int(param7.read - _loc17_ - 1)) : int(int(param7.end - _loc17_));
         _loc19_ = inflate_mask[param1];
         _loc20_ = inflate_mask[param2];
         do
         {
            while(_loc14_ < 20)
            {
               _loc16_--;
               _loc13_ |= (param8.next_in[_loc15_++] & 255) << _loc14_;
               _loc14_ += 8;
            }
            _loc9_ = _loc13_ & _loc19_;
            _loc10_ = param3;
            _loc11_ = param4;
            _loc24_ = (_loc11_ + _loc9_) * 3;
            if((_loc12_ = _loc10_[_loc24_]) == 0)
            {
               _loc13_ >>= _loc10_[_loc24_ + 1];
               _loc14_ -= _loc10_[_loc24_ + 1];
               _loc25_ = _loc17_ + 1;
               param7.window[_loc25_] = _loc10_[_loc24_ + 2];
               _loc18_--;
            }
            else
            {
               while(true)
               {
                  _loc13_ >>= _loc10_[_loc24_ + 1];
                  _loc14_ -= _loc10_[_loc24_ + 1];
                  if((_loc12_ & 16) != 0)
                  {
                     _loc12_ &= 15;
                     _loc21_ = _loc10_[_loc24_ + 2] + (int(_loc13_) & inflate_mask[_loc12_]);
                     _loc13_ >>= _loc12_;
                     _loc14_ -= _loc12_;
                     while(_loc14_ < 15)
                     {
                        _loc16_--;
                        _loc13_ |= (param8.next_in[_loc15_++] & 255) << _loc14_;
                        _loc14_ += 8;
                     }
                     _loc9_ = _loc13_ & _loc20_;
                     _loc10_ = param5;
                     _loc11_ = param6;
                     _loc24_ = (_loc11_ + _loc9_) * 3;
                     _loc12_ = _loc10_[_loc24_];
                     while(true)
                     {
                        _loc13_ >>= _loc10_[_loc24_ + 1];
                        _loc14_ -= _loc10_[_loc24_ + 1];
                        if((_loc12_ & 16) != 0)
                        {
                           break;
                        }
                        if((_loc12_ & 64) != 0)
                        {
                           param8.msg = "invalid distance code";
                           _loc21_ = param8.avail_in - _loc16_;
                           _loc21_ = _loc14_ >> 3 < _loc21_ ? int(int(_loc14_ >> 3)) : int(int(_loc21_));
                           _loc16_ += _loc21_;
                           _loc15_ -= _loc21_;
                           _loc14_ -= _loc21_ << 3;
                           param7.bitb = _loc13_;
                        }
                        continue;
                        param7.bitk = _loc14_;
                        param8.avail_in = _loc16_;
                        param8.total_in += _loc15_ - param8.next_in_index;
                        param8.next_in_index = _loc15_;
                        param7.write = _loc17_;
                        return Z_DATA_ERROR;
                     }
                     _loc12_ &= 15;
                     while(_loc14_ < _loc12_)
                     {
                        _loc16_--;
                        _loc13_ |= (param8.next_in[_loc15_++] & 255) << _loc14_;
                        _loc14_ += 8;
                     }
                     _loc22_ = _loc10_[_loc24_ + 2] + (_loc13_ & inflate_mask[_loc12_]);
                     _loc13_ >>= _loc12_;
                     _loc14_ -= _loc12_;
                     _loc18_ -= _loc21_;
                     if(_loc17_ >= _loc22_)
                     {
                        _loc23_ = _loc17_ - _loc22_;
                        if(_loc17_ - _loc23_ > 0 && 2 > _loc17_ - _loc23_)
                        {
                           var _loc26_:* = _loc17_++;
                           param7.window[_loc26_] = param7.window[_loc23_++];
                           var _loc27_:* = _loc17_++;
                           param7.window[_loc27_] = param7.window[_loc23_++];
                           _loc21_ -= 2;
                        }
                        else
                        {
                           System.byteArrayCopy(param7.window,_loc23_,param7.window,_loc17_,2);
                           _loc17_ += 2;
                           _loc23_ += 2;
                           _loc21_ -= 2;
                        }
                     }
                     else
                     {
                        _loc23_ = _loc17_ - _loc22_;
                        do
                        {
                           _loc23_ += param7.end;
                        }
                        while(_loc23_ < 0);
                        
                        _loc12_ = param7.end - _loc23_;
                        if(_loc21_ > _loc12_)
                        {
                           _loc21_ -= _loc12_;
                           if(_loc17_ - _loc23_ > 0 && _loc12_ > _loc17_ - _loc23_)
                           {
                              do
                              {
                                 _loc26_ = _loc17_++;
                                 param7.window[_loc26_] = param7.window[_loc23_++];
                              }
                              while(--_loc12_ != 0);
                              
                           }
                           else
                           {
                              System.byteArrayCopy(param7.window,_loc23_,param7.window,_loc17_,_loc12_);
                              _loc17_ += _loc12_;
                              _loc23_ += _loc12_;
                              _loc12_ = 0;
                           }
                           _loc23_ = 0;
                        }
                     }
                     if(_loc17_ - _loc23_ > 0 && _loc21_ > _loc17_ - _loc23_)
                     {
                        do
                        {
                           _loc26_ = _loc17_++;
                           param7.window[_loc26_] = param7.window[_loc23_++];
                        }
                        while(--_loc21_ != 0);
                        
                     }
                     else
                     {
                        System.byteArrayCopy(param7.window,_loc23_,param7.window,_loc17_,_loc21_);
                        _loc17_ += _loc21_;
                        _loc23_ += _loc21_;
                        _loc21_ = 0;
                     }
                     break;
                  }
                  if((_loc12_ & 64) != 0)
                  {
                     if((_loc12_ & 32) != 0)
                     {
                        _loc21_ = param8.avail_in - _loc16_;
                        _loc21_ = _loc14_ >> 3 < _loc21_ ? int(int(_loc14_ >> 3)) : int(int(_loc21_));
                        _loc16_ += _loc21_;
                        _loc15_ -= _loc21_;
                        _loc14_ -= _loc21_ << 3;
                        param7.bitb = _loc13_;
                        param7.bitk = _loc14_;
                        param8.avail_in = _loc16_;
                        param8.total_in += _loc15_ - param8.next_in_index;
                        param8.next_in_index = _loc15_;
                        param7.write = _loc17_;
                        return Z_STREAM_END;
                     }
                     param8.msg = "invalid literal/length code";
                     _loc21_ = param8.avail_in - _loc16_;
                     _loc21_ = _loc14_ >> 3 < _loc21_ ? int(int(_loc14_ >> 3)) : int(int(_loc21_));
                     _loc16_ += _loc21_;
                     _loc15_ -= _loc21_;
                     _loc14_ -= _loc21_ << 3;
                  }
                  _loc9_ += _loc10_[_loc24_ + 2];
                  _loc9_ += _loc13_ & inflate_mask[_loc12_];
                  _loc24_ = (_loc11_ + _loc9_) * 3;
                  if((_loc12_ = _loc10_[_loc24_]) == 0)
                  {
                     _loc13_ >>= _loc10_[_loc24_ + 1];
                     _loc14_ -= _loc10_[_loc24_ + 1];
                     _loc26_ = _loc17_++;
                     param7.window[_loc26_] = _loc10_[_loc24_ + 2];
                     _loc18_--;
                     break;
                  }
                  continue;
                  param7.bitb = _loc13_;
                  param7.bitk = _loc14_;
                  param8.avail_in = _loc16_;
                  param8.total_in += _loc15_ - param8.next_in_index;
                  param8.next_in_index = _loc15_;
                  param7.write = _loc17_;
                  return Z_DATA_ERROR;
               }
            }
         }
         while(_loc18_ >= 258 && _loc16_ >= 10);
         
         _loc21_ = param8.avail_in - _loc16_;
         _loc21_ = _loc14_ >> 3 < _loc21_ ? int(int(_loc14_ >> 3)) : int(int(_loc21_));
         _loc16_ += _loc21_;
         _loc15_ -= _loc21_;
         _loc14_ -= _loc21_ << 3;
         param7.bitb = _loc13_;
         param7.bitk = _loc14_;
         param8.avail_in = _loc16_;
         param8.total_in += _loc15_ - param8.next_in_index;
         param8.next_in_index = _loc15_;
         param7.write = _loc17_;
         return Z_OK;
      }
      
      public function init(param1:int, param2:int, param3:Array, param4:int, param5:Array, param6:int, param7:ZStream) : void
      {
         this.mode = START;
         this.lbits = param1;
         this.dbits = param2;
         this.ltree = param3;
         this.ltree_index = param4;
         this.dtree = param5;
         this.dtree_index = param6;
         this.tree = null;
      }
      
	  internal function proc(param1:InfBlocks, param2:ZStream, param3:int) : int
      {
         var _loc15_:* = undefined;
         var _loc4_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         _loc10_ = param2.next_in_index;
         _loc11_ = param2.avail_in;
         _loc8_ = param1.bitb;
         _loc9_ = param1.bitk;
         _loc12_ = param1.write;
         _loc13_ = _loc12_ < param1.read ? int(int(param1.read - _loc12_ - 1)) : int(int(param1.end - _loc12_));
         while(true)
         {
            switch(this.mode)
            {
               case START:
                  if(_loc13_ >= 258 && _loc11_ >= 10)
                  {
                     param1.bitb = _loc8_;
                     param1.bitk = _loc9_;
                     param2.avail_in = _loc11_;
                     param2.total_in += _loc10_ - param2.next_in_index;
                     param2.next_in_index = _loc10_;
                     param1.write = _loc12_;
                     param3 = this.inflate_fast(this.lbits,this.dbits,this.ltree,this.ltree_index,this.dtree,this.dtree_index,param1,param2);
                     _loc10_ = param2.next_in_index;
                     _loc11_ = param2.avail_in;
                     _loc8_ = param1.bitb;
                     _loc9_ = param1.bitk;
                     _loc12_ = param1.write;
                     _loc13_ = _loc12_ < param1.read ? int(int(param1.read - _loc12_ - 1)) : int(int(param1.end - _loc12_));
                     if(param3 != Z_OK)
                     {
                        this.mode = param3 == Z_STREAM_END ? int(int(WASH)) : int(int(BADCODE));
                        continue;
                     }
                  }
                  this.need = this.lbits;
                  this.tree = this.ltree;
                  this.tree_index = this.ltree_index;
                  this.mode = LEN;
               case LEN:
                  _loc4_ = this.need;
                  while(_loc9_ < _loc4_)
                  {
                     if(_loc11_ == 0)
                     {
                        param1.bitb = _loc8_;
                        param1.bitk = _loc9_;
                        param2.avail_in = _loc11_;
                        param2.total_in += _loc10_ - param2.next_in_index;
                     }
                     continue;
                     param2.next_in_index = _loc10_;
                     param1.write = _loc12_;
                     param3 = Z_OK;
                     _loc11_--;
                     _loc8_ |= (param2.next_in[_loc10_++] & 255) << _loc9_;
                     _loc9_ += 8;
                     return param1.inflate_flush(param2,param3);
                  }
                  _loc6_ = (this.tree_index + (_loc8_ & inflate_mask[_loc4_])) * 3;
                  _loc8_ >>>= this.tree[_loc6_ + 1];
                  _loc9_ -= this.tree[_loc6_ + 1];
                  _loc7_ = this.tree[_loc6_];
                  if(_loc7_ == 0)
                  {
                     this.lit = this.tree[_loc6_ + 2];
                     this.mode = LIT;
                     continue;
                     param2.total_in += _loc10_ - param2.next_in_index;
                  }
                  if((_loc7_ & 16) != 0)
                  {
                     this.getBits = _loc7_ & 15;
                     this.len = this.tree[_loc6_ + 2];
                     this.mode = LENEXT;
                     continue;
                  }
                  if((_loc7_ & 64) != 0)
                  {
                     if((_loc7_ & 32) == 0)
                     {
                        this.mode = BADCODE;
                        param2.msg = "invalid literal/length code";
                        param3 = Z_DATA_ERROR;
                        param1.bitb = _loc8_;
                        param1.bitk = _loc9_;
                     }
                     this.mode = WASH;
                     continue;
                     param2.avail_in = _loc11_;
                  }
                  this.need = _loc7_;
                  this.tree_index = _loc6_ / 3 + this.tree[_loc6_ + 2];
                  continue;
                  param2.next_in_index = _loc10_;
                  param1.write = _loc12_;
                  return param1.inflate_flush(param2,param3);
                  break;
               case LENEXT:
                  _loc4_ = this.getBits;
                  while(_loc9_ < _loc4_)
                  {
                     if(_loc11_ == 0)
                     {
                        param1.bitb = _loc8_;
                        param1.bitk = _loc9_;
                        param2.avail_in = _loc11_;
                        param2.total_in += _loc10_ - param2.next_in_index;
                     }
                     continue;
                     param2.next_in_index = _loc10_;
                     param1.write = _loc12_;
                     param3 = Z_OK;
                     _loc11_--;
                     _loc8_ |= (param2.next_in[_loc10_++] & 255) << _loc9_;
                     _loc9_ += 8;
                     return param1.inflate_flush(param2,param3);
                  }
                  this.len += _loc8_ & inflate_mask[_loc4_];
                  _loc8_ >>= _loc4_;
                  _loc9_ -= _loc4_;
                  this.need = this.dbits;
                  this.tree = this.dtree;
                  this.tree_index = this.dtree_index;
                  this.mode = DIST;
               case DIST:
                  _loc4_ = this.need;
                  while(_loc9_ < _loc4_)
                  {
                     if(_loc11_ == 0)
                     {
                        param1.bitb = _loc8_;
                        param1.bitk = _loc9_;
                        param2.avail_in = _loc11_;
                        param2.total_in += _loc10_ - param2.next_in_index;
                     }
                     continue;
                     param2.next_in_index = _loc10_;
                     param1.write = _loc12_;
                     param3 = Z_OK;
                     _loc11_--;
                     _loc8_ |= (param2.next_in[_loc10_++] & 255) << _loc9_;
                     _loc9_ += 8;
                     return param1.inflate_flush(param2,param3);
                  }
                  _loc6_ = (this.tree_index + (_loc8_ & inflate_mask[_loc4_])) * 3;
                  _loc8_ >>= this.tree[_loc6_ + 1];
                  _loc9_ -= this.tree[_loc6_ + 1];
                  _loc7_ = this.tree[_loc6_];
                  if((_loc7_ & 16) == 0)
                  {
                     if((_loc7_ & 64) != 0)
                     {
                        this.mode = BADCODE;
                        param2.msg = "invalid distance code";
                        param3 = Z_DATA_ERROR;
                        param1.bitb = _loc8_;
                        param1.bitk = _loc9_;
                     }
                     this.need = _loc7_;
                     this.tree_index = _loc6_ / 3 + this.tree[_loc6_ + 2];
                     continue;
                     param2.avail_in = _loc11_;
                  }
                  this.getBits = _loc7_ & 15;
                  this.dist = this.tree[_loc6_ + 2];
                  this.mode = DISTEXT;
                  continue;
                  param2.total_in += _loc10_ - param2.next_in_index;
                  param2.next_in_index = _loc10_;
                  param1.write = _loc12_;
                  return param1.inflate_flush(param2,param3);
                  break;
               case DISTEXT:
                  _loc4_ = this.getBits;
                  while(_loc9_ < _loc4_)
                  {
                     if(_loc11_ == 0)
                     {
                        param1.bitb = _loc8_;
                        param1.bitk = _loc9_;
                        param2.avail_in = _loc11_;
                        param2.total_in += _loc10_ - param2.next_in_index;
                     }
                     continue;
                     param2.next_in_index = _loc10_;
                     param1.write = _loc12_;
                     param3 = Z_OK;
                     _loc11_--;
                     _loc8_ |= (param2.next_in[_loc10_++] & 255) << _loc9_;
                     _loc9_ += 8;
                     return param1.inflate_flush(param2,param3);
                  }
                  this.dist += _loc8_ & inflate_mask[_loc4_];
                  _loc8_ >>= _loc4_;
                  _loc9_ -= _loc4_;
                  this.mode = COPY;
               case COPY:
                  _loc14_ = _loc12_ - this.dist;
                  while(_loc14_ < 0)
                  {
                     _loc14_ += param1.end;
                  }
                  while(this.len != 0)
                  {
                     if(_loc13_ == 0)
                     {
                        if(_loc12_ == param1.end && param1.read != 0)
                        {
                           _loc12_ = 0;
                           _loc13_ = _loc12_ < param1.read ? int(int(param1.read - _loc12_ - 1)) : int(int(param1.end - _loc12_));
                        }
                        if(_loc13_ == 0)
                        {
                           param1.write = _loc12_;
                           param3 = param1.inflate_flush(param2,param3);
                           _loc12_ = param1.write;
                           _loc13_ = _loc12_ < param1.read ? int(int(param1.read - _loc12_ - 1)) : int(int(param1.end - _loc12_));
                           if(_loc12_ == param1.end && param1.read != 0)
                           {
                              _loc12_ = 0;
                              _loc13_ = _loc12_ < param1.read ? int(int(param1.read - _loc12_ - 1)) : int(int(param1.end - _loc12_));
                           }
                           if(_loc13_ == 0)
                           {
                              param1.bitb = _loc8_;
                              param1.bitk = _loc9_;
                              param2.avail_in = _loc11_;
                              param2.total_in += _loc10_ - param2.next_in_index;
                              param2.next_in_index = _loc10_;
                              param1.write = _loc12_;
                              return param1.inflate_flush(param2,param3);
                           }
                        }
                     }
                     _loc15_ = _loc12_ + 1;
                     param1.window[_loc15_] = param1.window[_loc14_++];
                     _loc13_--;
                     if(_loc14_ == param1.end)
                     {
                        _loc14_ = 0;
                     }
                     --this.len;
                  }
                  this.mode = START;
                  continue;
               case LIT:
                  if(_loc13_ == 0)
                  {
                     if(_loc12_ == param1.end && param1.read != 0)
                     {
                        _loc12_ = 0;
                        _loc13_ = _loc12_ < param1.read ? int(int(param1.read - _loc12_ - 1)) : int(int(param1.end - _loc12_));
                     }
                     if(_loc13_ == 0)
                     {
                        param1.write = _loc12_;
                        param3 = param1.inflate_flush(param2,param3);
                        _loc12_ = param1.write;
                        _loc13_ = _loc12_ < param1.read ? int(int(param1.read - _loc12_ - 1)) : int(int(param1.end - _loc12_));
                        if(_loc12_ == param1.end && param1.read != 0)
                        {
                           _loc12_ = 0;
                           _loc13_ = _loc12_ < param1.read ? int(int(param1.read - _loc12_ - 1)) : int(int(param1.end - _loc12_));
                        }
                        if(_loc13_ == 0)
                        {
                           param1.bitb = _loc8_;
                           param1.bitk = _loc9_;
                           param2.avail_in = _loc11_;
                           param2.total_in += _loc10_ - param2.next_in_index;
                           param2.next_in_index = _loc10_;
                           param1.write = _loc12_;
                           return param1.inflate_flush(param2,param3);
                        }
                     }
                  }
                  param3 = Z_OK;
                  var _loc16_:* = _loc12_++;
                  param1.window[_loc16_] = this.lit;
                  _loc13_--;
                  this.mode = START;
                  continue;
               case WASH:
                  if(_loc9_ > 7)
                  {
                     _loc9_ -= 8;
                     _loc11_++;
                     _loc10_--;
                  }
                  param1.write = _loc12_;
                  param3 = param1.inflate_flush(param2,param3);
                  _loc12_ = param1.write;
                  _loc13_ = _loc12_ < param1.read ? int(int(param1.read - _loc12_ - 1)) : int(int(param1.end - _loc12_));
                  if(param1.read != param1.write)
                  {
                     param1.bitb = _loc8_;
                     param1.bitk = _loc9_;
                     param2.avail_in = _loc11_;
                     param2.total_in += _loc10_ - param2.next_in_index;
                     param2.next_in_index = _loc10_;
                     param1.write = _loc12_;
                     return param1.inflate_flush(param2,param3);
                  }
                  this.mode = END;
                  break;
               case END:
                  break;
               case BADCODE:
                  param3 = Z_DATA_ERROR;
                  param1.bitb = _loc8_;
                  param1.bitk = _loc9_;
                  param2.avail_in = _loc11_;
                  param2.total_in += _loc10_ - param2.next_in_index;
                  param2.next_in_index = _loc10_;
                  param1.write = _loc12_;
                  return param1.inflate_flush(param2,param3);
            }
            param3 = Z_STREAM_END;
            param1.bitb = _loc8_;
            param1.bitk = _loc9_;
            param2.avail_in = _loc11_;
            param2.total_in += _loc10_ - param2.next_in_index;
            param2.next_in_index = _loc10_;
            param1.write = _loc12_;
            return param1.inflate_flush(param2,param3);
         }
         param3 = Z_STREAM_ERROR;
         param1.bitb = _loc8_;
         param1.bitk = _loc9_;
         param2.avail_in = _loc11_;
         param2.total_in += _loc10_ - param2.next_in_index;
         param2.next_in_index = _loc10_;
         param1.write = _loc12_;
         return param1.inflate_flush(param2,param3);
      }
   }
}
