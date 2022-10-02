package com.wirelust.as3zlib
{
   import flash.utils.ByteArray;
   
   public final class ZStream
   {
      
      private static var MAX_WBITS:int = 15;
      
      private static var DEF_WBITS:int = MAX_WBITS;
      
      private static var Z_NO_FLUSH:int = 0;
      
      private static var Z_PARTIAL_FLUSH:int = 1;
      
      private static var Z_SYNC_FLUSH:int = 2;
      
      private static var Z_FULL_FLUSH:int = 3;
      
      private static var Z_FINISH:int = 4;
      
      private static var MAX_MEM_LEVEL:int = 9;
      
      private static var Z_OK:int = 0;
      
      private static var Z_STREAM_END:int = 1;
      
      private static var Z_NEED_DICT:int = 2;
      
      private static var Z_ERRNO:int = -1;
      
      private static var Z_STREAM_ERROR:int = -2;
      
      private static var Z_DATA_ERROR:int = -3;
      
      private static var Z_MEM_ERROR:int = -4;
      
      private static var Z_BUF_ERROR:int = -5;
      
      private static var Z_VERSION_ERROR:int = -6;
       
      
      public var next_in:ByteArray;
      
      public var next_in_index:int;
      
      public var avail_in:int;
      
      public var total_in:Number;
      
      public var next_out:ByteArray;
      
      public var next_out_index:int;
      
      public var avail_out:int;
      
      public var total_out:Number;
      
      public var msg:String;
      
      public var dstate:Deflate;
      
      public var istate:Inflate;
      
      public var data_type:int;
      
      public var adler:Number;
      
      public var _adler:Adler32;
      
      public function ZStream()
      {
         this._adler = new Adler32();
         super();
      }
      
      public function inflateInit() : int
      {
         return this.inflateInitWithWbits(DEF_WBITS);
      }
      
      public function inflateInitWithNoWrap(param1:Boolean) : int
      {
         return this.inflateInitWithWbitsNoWrap(DEF_WBITS,param1);
      }
      
      public function inflateInitWithWbits(param1:int) : int
      {
         return this.inflateInitWithWbitsNoWrap(param1,false);
      }
      
      public function inflateInitWithWbitsNoWrap(param1:int, param2:Boolean) : int
      {
         this.istate = new Inflate();
         return this.istate.inflateInit(this,!!param2 ? int(int(-param1)) : int(int(param1)));
      }
      
      public function inflate(param1:int) : int
      {
         if(this.istate == null)
         {
            return Z_STREAM_ERROR;
         }
         return this.istate.inflate(this,param1);
      }
      
      public function inflateEnd() : int
      {
         if(this.istate == null)
         {
            return Z_STREAM_ERROR;
         }
         var _loc1_:int = this.istate.inflateEnd(this);
         this.istate = null;
         return _loc1_;
      }
      
      public function inflateSync() : int
      {
         if(this.istate == null)
         {
            return Z_STREAM_ERROR;
         }
         return this.istate.inflateSync(this);
      }
      
      public function inflateSetDictionary(param1:ByteArray, param2:int) : int
      {
         if(this.istate == null)
         {
            return Z_STREAM_ERROR;
         }
         return this.istate.inflateSetDictionary(this,param1,param2);
      }
      
      public function deflateInit(param1:int) : int
      {
         return this.deflateInitWithIntInt(param1,MAX_WBITS);
      }
      
      public function deflateInitWithBoolean(param1:int, param2:Boolean) : int
      {
         return this.deflateInitWithIntIntBoolean(param1,MAX_WBITS,param2);
      }
      
      public function deflateInitWithIntInt(param1:int, param2:int) : int
      {
         return this.deflateInitWithIntIntBoolean(param1,param2,false);
      }
      
      public function deflateInitWithIntIntBoolean(param1:int, param2:int, param3:Boolean) : int
      {
         this.dstate = new Deflate();
         return this.dstate.deflateInitWithBits(this,param1,!!param3 ? int(int(-param2)) : int(int(param2)));
      }
      
      public function deflate(param1:int) : int
      {
         if(this.dstate == null)
         {
            return Z_STREAM_ERROR;
         }
         return this.dstate.deflate(this,param1);
      }
      
      public function deflateEnd() : int
      {
         if(this.dstate == null)
         {
            return Z_STREAM_ERROR;
         }
         var _loc1_:int = this.dstate.deflateEnd();
         this.dstate = null;
         return _loc1_;
      }
      
      public function deflateParams(param1:int, param2:int) : int
      {
         if(this.dstate == null)
         {
            return Z_STREAM_ERROR;
         }
         return this.dstate.deflateParams(this,param1,param2);
      }
      
      public function deflateSetDictionary(param1:ByteArray, param2:int) : int
      {
         if(this.dstate == null)
         {
            return Z_STREAM_ERROR;
         }
         return this.dstate.deflateSetDictionary(this,param1,param2);
      }
      
      public function flush_pending() : void
      {
         var _loc1_:int = this.dstate.pending;
         if(_loc1_ > this.avail_out)
         {
            _loc1_ = this.avail_out;
         }
         if(_loc1_ == 0)
         {
            return;
         }
         if(this.dstate.pending_buf.length <= this.dstate.pending_out || this.next_out.length <= this.next_out_index || this.dstate.pending_buf.length < this.dstate.pending_out + _loc1_ || this.next_out.length < this.next_out_index + _loc1_)
         {
         }
         System.byteArrayCopy(this.dstate.pending_buf,this.dstate.pending_out,this.next_out,this.next_out_index,_loc1_);
         this.next_out_index += _loc1_;
         this.dstate.pending_out += _loc1_;
         this.total_out += _loc1_;
         this.avail_out -= _loc1_;
         this.dstate.pending -= _loc1_;
         if(this.dstate.pending == 0)
         {
            this.dstate.pending_out = 0;
            this.dstate.pending_buf = new ByteArray();
         }
      }
      
      public function read_buf(param1:ByteArray, param2:int, param3:int) : int
      {
         var _loc4_:int = this.avail_in;
         if(_loc4_ > param3)
         {
            _loc4_ = param3;
         }
         if(_loc4_ == 0)
         {
            return 0;
         }
         this.avail_in -= _loc4_;
         if(this.dstate.noheader == 0)
         {
            this.adler = this._adler.adler32(this.adler,this.next_in,this.next_in_index,_loc4_);
         }
         System.byteArrayCopy(this.next_in,this.next_in_index,param1,param2,_loc4_);
         this.next_in_index += _loc4_;
         this.total_in += _loc4_;
         return _loc4_;
      }
      
      public function free() : void
      {
         this.next_in = null;
         this.next_out = null;
         this.msg = null;
         this._adler = null;
      }
   }
}
