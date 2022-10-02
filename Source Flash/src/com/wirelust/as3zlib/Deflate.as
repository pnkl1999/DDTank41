package com.wirelust.as3zlib
{
   import com.wirelust.util.Cast;
   import flash.utils.ByteArray;
   
   public class Deflate
   {
      
      private static var MAX_MEM_LEVEL:int = 9;
      
      private static var Z_DEFAULT_COMPRESSION:int = -1;
      
      private static var MAX_WBITS:int = 15;
      
      private static var DEF_MEM_LEVEL:int = 8;
      
      private static var STORED:int = 0;
      
      private static var FAST:int = 1;
      
      private static var SLOW:int = 2;
      
      private static var config_table:Array = new Array(new DeflateConfig(0,0,0,0,STORED),new DeflateConfig(4,4,8,4,FAST),new DeflateConfig(4,5,16,8,FAST),new DeflateConfig(4,6,32,32,FAST),new DeflateConfig(4,4,16,16,SLOW),new DeflateConfig(8,16,32,32,SLOW),new DeflateConfig(8,16,128,128,SLOW),new DeflateConfig(8,32,128,256,SLOW),new DeflateConfig(32,128,258,1024,SLOW),new DeflateConfig(32,258,258,4096,SLOW));
      
      private static var NeedMore:int = 0;
      
      private static var BlockDone:int = 1;
      
      private static const FinishStarted:int = 2;
      
      private static const FinishDone:int = 3;
      
      private static const PRESET_DICT:int = 32;
      
      private static const Z_FILTERED:int = 1;
      
      private static const Z_HUFFMAN_ONLY:int = 2;
      
      private static const Z_DEFAULT_STRATEGY:int = 0;
      
      private static const Z_NO_FLUSH:int = 0;
      
      private static const Z_PARTIAL_FLUSH:int = 1;
      
      private static const Z_SYNC_FLUSH:int = 2;
      
      private static const Z_FULL_FLUSH:int = 3;
      
      private static const Z_FINISH:int = 4;
      
      private static const Z_OK:int = 0;
      
      private static const Z_STREAM_END:int = 1;
      
      private static const Z_NEED_DICT:int = 2;
      
      private static const Z_ERRNO:int = -1;
      
      private static const Z_STREAM_ERROR:int = -2;
      
      private static const Z_DATA_ERROR:int = -3;
      
      private static const Z_MEM_ERROR:int = -4;
      
      private static const Z_BUF_ERROR:int = -5;
      
      private static const Z_VERSION_ERROR:int = -6;
      
      private static const INIT_STATE:int = 42;
      
      private static const BUSY_STATE:int = 113;
      
      private static const FINISH_STATE:int = 666;
      
      private static var Z_DEFLATED:int = 8;
      
      private static const STORED_BLOCK:int = 0;
      
      private static const STATIC_TREES:int = 1;
      
      private static const DYN_TREES:int = 2;
      
      private static const Z_BINARY:int = 0;
      
      private static const Z_ASCII:int = 1;
      
      private static const Z_UNKNOWN:int = 2;
      
      private static const Buf_size:int = 8 * 2;
      
      private static const REP_3_6:int = 16;
      
      private static const REPZ_3_10:int = 17;
      
      private static const REPZ_11_138:int = 18;
      
      private static const MIN_MATCH:int = 3;
      
      private static const MAX_MATCH:int = 258;
      
      private static const MIN_LOOKAHEAD:int = MAX_MATCH + MIN_MATCH + 1;
      
      private static const MAX_BITS:int = 15;
      
      private static const D_CODES:int = 30;
      
      private static const BL_CODES:int = 19;
      
      private static const LENGTH_CODES:int = 29;
      
      private static const LITERALS:int = 256;
      
      private static const L_CODES:int = LITERALS + 1 + LENGTH_CODES;
      
      private static const HEAP_SIZE:int = 2 * L_CODES + 1;
      
      private static const END_BLOCK:int = 256;
       
      
      private var z_errmsg:Array;
      
      public var strm:ZStream;
      
      public var status:int;
      
      public var pending_buf:ByteArray;
      
      public var pending_buf_size:int;
      
      public var pending_out:int;
      
      public var pending:int;
      
      public var noheader:int;
      
      public var data_type:uint;
      
      public var method:uint;
      
      public var last_flush:int;
      
      public var w_size:int;
      
      public var w_bits:int;
      
      public var w_mask:int;
      
      public var window:ByteArray;
      
      public var window_size:int;
      
      public var prev:Array;
      
      public var head:Array;
      
      public var ins_h:int;
      
      public var hash_size:int;
      
      public var hash_bits:int;
      
      public var hash_mask:int;
      
      public var hash_shift:int;
      
      public var block_start:int;
      
      public var match_length:int;
      
      public var prev_match:int;
      
      public var match_available:int;
      
      public var strstart:int;
      
      public var match_start:int;
      
      public var lookahead:int;
      
      public var prev_length:int;
      
      public var max_chain_length:int;
      
      public var max_lazy_match:int;
      
      public var level:int;
      
      public var strategy:int;
      
      public var good_match:int;
      
      public var nice_match:int;
      
	  internal var dyn_ltree:Array;
      
	  internal var dyn_dtree:Array;
      
	  internal var bl_tree:Array;
      
	  internal var l_desc:Tree;
      
	  internal var d_desc:Tree;
      
	  internal var bl_desc:Tree;
      
	  internal var bl_count:Array;
      
	  internal var heap:Array;
      
	  internal var heap_len:int;
      
	  internal var heap_max:int;
      
	  internal var depth:Array;
      
	  internal var l_buf:int;
      
	  internal var lit_bufsize:int;
      
	  internal var last_lit:int;
      
	  internal var d_buf:int;
      
	  internal var opt_len:int;
      
	  internal var static_len:int;
      
	  internal var matches:int;
      
	  internal var last_eob_len:int;
      
	  internal var bi_buf:Number;
      
	  internal var bi_valid:int;
      
      public function Deflate()
      {
         this.z_errmsg = new Array("need dictionary","stream end","","file error","stream error","data error","insufficient memory","buffer error","incompatible version","");
         this.l_desc = new Tree();
         this.d_desc = new Tree();
         this.bl_desc = new Tree();
         this.bl_count = new Array();
         this.heap = new Array();
         this.depth = new Array();
         super();
         this.dyn_ltree = new Array();
         this.dyn_dtree = new Array();
         this.bl_tree = new Array();
      }
      
	  internal static function smaller(param1:Array, param2:int, param3:int, param4:Array) : Boolean
      {
         var _loc5_:Number = param1[param2 * 2];
         var _loc6_:Number = param1[param3 * 2];
         return _loc5_ < _loc6_ || _loc5_ == _loc6_ && param4[param2] <= param4[param3];
      }
      
	  internal function lm_init() : void
      {
         this.window_size = 2 * this.w_size;
         this.head[this.hash_size - 1] = 0;
         var _loc1_:int = 0;
         while(_loc1_ < this.hash_size - 1)
         {
            this.head[_loc1_] = 0;
            _loc1_++;
         }
         this.max_lazy_match = Deflate.config_table[this.level].max_lazy;
         this.good_match = Deflate.config_table[this.level].good_length;
         this.nice_match = Deflate.config_table[this.level].nice_length;
         this.max_chain_length = Deflate.config_table[this.level].max_chain;
         this.strstart = 0;
         this.block_start = 0;
         this.lookahead = 0;
         this.match_length = this.prev_length = MIN_MATCH - 1;
         this.match_available = 0;
         this.ins_h = 0;
      }
      
	  internal function tr_init() : void
      {
         this.l_desc.dyn_tree = this.dyn_ltree;
         this.l_desc.stat_desc = StaticTree.static_l_desc;
         this.d_desc.dyn_tree = this.dyn_dtree;
         this.d_desc.stat_desc = StaticTree.static_d_desc;
         this.bl_desc.dyn_tree = this.bl_tree;
         this.bl_desc.stat_desc = StaticTree.static_bl_desc;
         this.bi_buf = 0;
         this.bi_valid = 0;
         this.last_eob_len = 8;
         this.init_block();
      }
      
	  internal function init_block() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 0;
         while(_loc1_ < L_CODES)
         {
            this.dyn_ltree[_loc1_ * 2] = 0;
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < D_CODES)
         {
            this.dyn_dtree[_loc1_ * 2] = 0;
            _loc1_++;
         }
         _loc1_ = 0;
         while(_loc1_ < BL_CODES)
         {
            this.bl_tree[_loc1_ * 2] = 0;
            _loc1_++;
         }
         this.dyn_ltree[END_BLOCK * 2] = 1;
         this.opt_len = this.static_len = 0;
         this.last_lit = this.matches = 0;
      }
      
	  internal function pqdownheap(param1:Array, param2:int) : void
      {
         var _loc3_:int = this.heap[param2];
         var _loc4_:int = param2 << 1;
         while(_loc4_ <= this.heap_len)
         {
            if(_loc4_ < this.heap_len && smaller(param1,this.heap[_loc4_ + 1],this.heap[_loc4_],this.depth))
            {
               _loc4_++;
            }
            if(smaller(param1,_loc3_,this.heap[_loc4_],this.depth))
            {
               break;
            }
            this.heap[param2] = this.heap[_loc4_];
            param2 = _loc4_;
            _loc4_ <<= 1;
         }
         this.heap[param2] = _loc3_;
      }
      
	  internal function scan_tree(param1:Array, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc5_:int = 0;
         var _loc4_:int = -1;
         var _loc6_:int = param1[0 * 2 + 1];
         var _loc7_:int = 0;
         var _loc8_:int = 7;
         var _loc9_:int = 4;
         if(_loc6_ == 0)
         {
            _loc8_ = 138;
            _loc9_ = 3;
         }
         param1[(param2 + 1) * 2 + 1] = 65535;
         _loc3_ = 0;
         while(_loc3_ <= param2)
         {
            _loc5_ = _loc6_;
            _loc6_ = param1[(_loc3_ + 1) * 2 + 1];
            if(!(++_loc7_ < _loc8_ && _loc5_ == _loc6_))
            {
               if(_loc7_ < _loc9_)
               {
                  this.bl_tree[_loc5_ * 2] += _loc7_;
               }
               else if(_loc5_ != 0)
               {
                  if(_loc5_ != _loc4_)
                  {
                     ++this.bl_tree[_loc5_ * 2];
                  }
                  ++this.bl_tree[REP_3_6 * 2];
               }
               else if(_loc7_ <= 10)
               {
                  ++this.bl_tree[REPZ_3_10 * 2];
               }
               else
               {
                  ++this.bl_tree[REPZ_11_138 * 2];
               }
               _loc7_ = 0;
               _loc4_ = _loc5_;
               if(_loc6_ == 0)
               {
                  _loc8_ = 138;
                  _loc9_ = 3;
               }
               else if(_loc5_ == _loc6_)
               {
                  _loc8_ = 6;
                  _loc9_ = 3;
               }
               else
               {
                  _loc8_ = 7;
                  _loc9_ = 4;
               }
            }
            _loc3_++;
         }
      }
      
      public function build_bl_tree() : int
      {
         var _loc1_:int = 0;
         this.scan_tree(this.dyn_ltree,this.l_desc.max_code);
         this.scan_tree(this.dyn_dtree,this.d_desc.max_code);
         this.bl_desc.build_tree(this);
         _loc1_ = BL_CODES - 1;
         while(_loc1_ >= 3)
         {
            if(this.bl_tree[Tree.bl_order[_loc1_] * 2 + 1] != 0)
            {
               break;
            }
            _loc1_--;
         }
         this.opt_len += 3 * (_loc1_ + 1) + 5 + 5 + 4;
         return _loc1_;
      }
      
      public function send_all_trees(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:int = 0;
         this.send_bits(param1 - 257,5);
         this.send_bits(param2 - 1,5);
         this.send_bits(param3 - 4,4);
         _loc4_ = 0;
         while(_loc4_ < param3)
         {
            this.send_bits(this.bl_tree[Tree.bl_order[_loc4_] * 2 + 1],3);
            _loc4_++;
         }
         this.send_tree(this.dyn_ltree,param1 - 1);
         this.send_tree(this.dyn_dtree,param2 - 1);
      }
      
      public function send_tree(param1:Array, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc5_:int = 0;
         var _loc4_:int = -1;
         var _loc6_:int = param1[0 * 2 + 1];
         var _loc7_:int = 0;
         var _loc8_:int = 7;
         var _loc9_:int = 4;
         if(_loc6_ == 0)
         {
            _loc8_ = 138;
            _loc9_ = 3;
         }
         _loc3_ = 0;
         while(_loc3_ <= param2)
         {
            _loc5_ = _loc6_;
            _loc6_ = param1[(_loc3_ + 1) * 2 + 1];
            if(!(++_loc7_ < _loc8_ && _loc5_ == _loc6_))
            {
               if(_loc7_ < _loc9_)
               {
                  do
                  {
                     this.send_code(_loc5_,this.bl_tree);
                  }
                  while(--_loc7_ != 0);
                  
               }
               else if(_loc5_ != 0)
               {
                  if(_loc5_ != _loc4_)
                  {
                     this.send_code(_loc5_,this.bl_tree);
                     _loc7_--;
                  }
                  this.send_code(REP_3_6,this.bl_tree);
                  this.send_bits(_loc7_ - 3,2);
               }
               else if(_loc7_ <= 10)
               {
                  this.send_code(REPZ_3_10,this.bl_tree);
                  this.send_bits(_loc7_ - 3,3);
               }
               else
               {
                  this.send_code(REPZ_11_138,this.bl_tree);
                  this.send_bits(_loc7_ - 11,7);
               }
               _loc7_ = 0;
               _loc4_ = _loc5_;
               if(_loc6_ == 0)
               {
                  _loc8_ = 138;
                  _loc9_ = 3;
               }
               else if(_loc5_ == _loc6_)
               {
                  _loc8_ = 6;
                  _loc9_ = 3;
               }
               else
               {
                  _loc8_ = 7;
                  _loc9_ = 4;
               }
            }
            _loc3_++;
         }
      }
      
      public final function put_byte(param1:ByteArray, param2:int, param3:int) : void
      {
         System.byteArrayCopy(param1,param2,this.pending_buf,this.pending,param3);
         this.pending += param3;
      }
      
      public function put_byte_withInt(param1:int) : void
      {
         this.pending_buf.writeByte(param1);
         ++this.pending;
      }
      
      public function put_short(param1:int) : void
      {
         this.put_byte_withInt(param1);
         this.put_byte_withInt(param1 >>> 8);
      }
      
      public final function putShortMSB(param1:int) : void
      {
         this.put_byte_withInt(param1 >> 8);
         this.put_byte_withInt(param1 & 255);
      }
      
      public final function send_code(param1:int, param2:Array) : void
      {
         var _loc3_:int = param1 * 2;
         this.send_bits(param2[_loc3_] & 65535,param2[_loc3_ + 1] & 65535);
      }
      
      public function send_bits(param1:int, param2:int) : void
      {
         var _loc4_:int = 0;
         var _loc3_:int = param2;
         if(this.bi_valid > int(Buf_size) - _loc3_)
         {
            _loc4_ = param1;
            this.bi_buf |= _loc4_ << this.bi_valid & 65535;
            this.put_short(this.bi_buf);
            this.bi_buf = _loc4_ >>> Buf_size - this.bi_valid;
            this.bi_buf = Cast.toShort(_loc4_ >>> Buf_size - this.bi_valid);
            this.bi_valid += _loc3_ - Buf_size;
         }
         else
         {
            this.bi_buf |= param1 << this.bi_valid & 65535;
            this.bi_valid += _loc3_;
         }
      }
      
      public function _tr_align() : void
      {
         this.send_bits(STATIC_TREES << 1,3);
         this.send_code(END_BLOCK,StaticTree.static_ltree);
         this.bi_flush();
         if(1 + this.last_eob_len + 10 - this.bi_valid < 9)
         {
            this.send_bits(STATIC_TREES << 1,3);
            this.send_code(END_BLOCK,StaticTree.static_ltree);
            this.bi_flush();
         }
         this.last_eob_len = 7;
      }
      
      public function _tr_tally(param1:int, param2:int) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         this.pending_buf[this.d_buf + this.last_lit * 2] = Cast.toByte(param1 >>> 8);
         this.pending_buf[this.d_buf + this.last_lit * 2 + 1] = Cast.toByte(param1);
         this.pending_buf[this.l_buf + this.last_lit] = param2;
         ++this.last_lit;
         if(param1 == 0)
         {
            ++this.dyn_ltree[param2 * 2];
         }
         else
         {
            ++this.matches;
            param1--;
            ++this.dyn_ltree[(Tree._length_code[param2] + LITERALS + 1) * 2];
            ++this.dyn_dtree[Tree.d_code(param1) * 2];
         }
         if((this.last_lit & 1) == 0 && this.level > 2)
         {
            _loc3_ = this.last_lit * 8;
            _loc4_ = this.strstart - this.block_start;
            _loc5_ = 0;
            while(_loc5_ < D_CODES)
            {
               _loc3_ += int(this.dyn_dtree[_loc5_ * 2]) * (5 + Tree.extra_dbits[_loc5_]);
               _loc5_++;
            }
            _loc3_ >>>= 3;
            if(this.matches < this.last_lit / 2 && _loc3_ < _loc4_ / 2)
            {
               return true;
            }
         }
         return this.last_lit == this.lit_bufsize - 1;
      }
      
      public function compress_block(param1:Array, param2:Array) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc5_:int = 0;
         if(this.last_lit != 0)
         {
            do
            {
               _loc3_ = this.pending_buf[this.d_buf + _loc5_ * 2] << 8 & 65280 | this.pending_buf[this.d_buf + _loc5_ * 2 + 1] & 255;
               _loc4_ = this.pending_buf[this.l_buf + _loc5_] & 255;
               _loc5_++;
               if(_loc3_ == 0)
               {
                  this.send_code(_loc4_,param1);
               }
               else
               {
                  _loc6_ = Tree._length_code[_loc4_];
                  this.send_code(_loc6_ + LITERALS + 1,param1);
                  _loc7_ = Tree.extra_lbits[_loc6_];
                  if(_loc7_ != 0)
                  {
                     _loc4_ -= Tree.base_length[_loc6_];
                     this.send_bits(_loc4_,_loc7_);
                  }
                  _loc3_--;
                  _loc6_ = Tree.d_code(_loc3_);
                  this.send_code(_loc6_,param2);
                  _loc7_ = Tree.extra_dbits[_loc6_];
                  if(_loc7_ != 0)
                  {
                     _loc3_ -= Tree.base_dist[_loc6_];
                     this.send_bits(_loc3_,_loc7_);
                  }
               }
            }
            while(_loc5_ < this.last_lit);
            
         }
         this.send_code(END_BLOCK,param1);
         this.last_eob_len = param1[END_BLOCK * 2 + 1];
      }
      
	  internal function set_data_type() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(_loc1_ < 7)
         {
            _loc3_ += this.dyn_ltree[_loc1_ * 2];
            _loc1_++;
         }
         while(_loc1_ < 128)
         {
            _loc2_ += this.dyn_ltree[_loc1_ * 2];
            _loc1_++;
         }
         while(_loc1_ < LITERALS)
         {
            _loc3_ += this.dyn_ltree[_loc1_ * 2];
            _loc1_++;
         }
         this.data_type = _loc3_ > _loc2_ >>> 2 ? uint(uint(Z_BINARY)) : uint(uint(Z_ASCII));
      }
      
      public function bi_flush() : void
      {
         if(this.bi_valid == 16)
         {
            this.put_short(this.bi_buf);
            this.bi_buf = 0;
            this.bi_valid = 0;
         }
         else if(this.bi_valid >= 8)
         {
            this.put_byte_withInt(this.bi_buf);
            this.bi_buf >>>= 8;
            this.bi_valid -= 8;
         }
      }
      
      public function bi_windup() : void
      {
         if(this.bi_valid > 8)
         {
            this.put_short(this.bi_buf);
         }
         else if(this.bi_valid > 0)
         {
            this.put_byte_withInt(this.bi_buf);
         }
         this.bi_buf = 0;
         this.bi_valid = 0;
      }
      
	  internal function copy_block(param1:int, param2:int, param3:Boolean) : void
      {
         this.bi_windup();
         this.last_eob_len = 8;
         if(param3)
         {
            this.put_short(param2);
            this.put_short(~param2 & 65535);
         }
         this.put_byte(this.window,param1,param2);
      }
      
	  internal function flush_block_only(param1:Boolean) : void
      {
         this._tr_flush_block(this.block_start >= 0 ? int(int(this.block_start)) : int(int(-1)),this.strstart - this.block_start,param1);
         this.block_start = this.strstart;
         this.strm.flush_pending();
      }
      
      public function deflate_stored(param1:int) : int
      {
         var _loc3_:int = 0;
         var _loc2_:int = 0;
         if(_loc2_ > this.pending_buf_size - 5)
         {
            _loc2_ = this.pending_buf_size - 5;
         }
         while(true)
         {
            if(this.lookahead <= 1)
            {
               this.fill_window();
               if(this.lookahead == 0 && param1 == Z_NO_FLUSH)
               {
                  break;
               }
               if(this.lookahead == 0)
               {
               }
            }
            this.strstart += this.lookahead;
            this.lookahead = 0;
            _loc3_ = this.block_start + _loc2_;
            if(this.strstart == 0 || this.strstart >= _loc3_)
            {
               this.lookahead = int(this.strstart - _loc3_);
               this.strstart = int(_loc3_);
               this.flush_block_only(false);
               if(this.strm.avail_out == 0)
               {
                  return NeedMore;
               }
            }
            if(this.strstart - this.block_start >= this.w_size - MIN_LOOKAHEAD)
            {
               this.flush_block_only(false);
               if(this.strm.avail_out == 0)
               {
                  return NeedMore;
               }
            }
         }
         return NeedMore;
      }
      
      public function _tr_stored_block(param1:int, param2:int, param3:Boolean) : void
      {
         this.send_bits((STORED_BLOCK << 1) + (!!param3 ? 1 : 0),3);
         this.copy_block(param1,param2,true);
      }
      
	  internal function _tr_flush_block(param1:int, param2:int, param3:Boolean) : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(this.level > 0)
         {
            if(this.data_type == Z_UNKNOWN)
            {
               this.set_data_type();
            }
            this.l_desc.build_tree(this);
            this.d_desc.build_tree(this);
            _loc6_ = this.build_bl_tree();
            _loc4_ = this.opt_len + 3 + 7 >>> 3;
            _loc5_ = this.static_len + 3 + 7 >>> 3;
            if(_loc5_ <= _loc4_)
            {
               _loc4_ = _loc5_;
            }
         }
         else
         {
            _loc4_ = _loc5_ = param2 + 5;
         }
         if(param2 + 4 <= _loc4_ && param1 != -1)
         {
            this._tr_stored_block(param1,param2,param3);
         }
         else if(_loc5_ == _loc4_)
         {
            this.send_bits((STATIC_TREES << 1) + (!!param3 ? 1 : 0),3);
            this.compress_block(StaticTree.static_ltree,StaticTree.static_dtree);
         }
         else
         {
            this.send_bits((DYN_TREES << 1) + (!!param3 ? 1 : 0),3);
            this.send_all_trees(this.l_desc.max_code + 1,this.d_desc.max_code + 1,_loc6_ + 1);
            this.compress_block(this.dyn_ltree,this.dyn_dtree);
         }
         this.init_block();
         if(param3)
         {
            this.bi_windup();
         }
      }
      
	  internal function fill_window() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         while(true)
         {
            _loc4_ = this.window_size - this.lookahead - this.strstart;
            if(_loc4_ == 0 && this.strstart == 0 && this.lookahead == 0)
            {
               _loc4_ = this.w_size;
            }
            else if(_loc4_ == -1)
            {
               _loc4_--;
            }
            else if(this.strstart >= this.w_size + this.w_size - MIN_LOOKAHEAD)
            {
               System.byteArrayCopy(this.window,this.w_size,this.window,0,this.w_size);
               this.match_start -= this.w_size;
               this.strstart -= this.w_size;
               this.block_start -= this.w_size;
               _loc1_ = this.hash_size;
               _loc3_ = _loc1_;
               do
               {
                  _loc2_ = this.head[--_loc3_] & 65535;
                  this.head[_loc3_] = _loc2_ >= this.w_size ? Cast.toShort(_loc2_ - this.w_size) : 0;
               }
               while(--_loc1_ != 0);
               
               _loc1_ = this.w_size;
               _loc3_ = _loc1_;
               do
               {
                  _loc2_ = this.prev[--_loc3_] & 65535;
                  this.prev[_loc3_] = _loc2_ >= this.w_size ? Cast.toShort(_loc2_ - this.w_size) : 0;
               }
               while(--_loc1_ != 0);
               
               _loc4_ += this.w_size;
            }
            if(this.strm.avail_in == 0)
            {
               break;
            }
            _loc1_ = this.strm.read_buf(this.window,this.strstart + this.lookahead,_loc4_);
            this.lookahead += _loc1_;
            if(this.lookahead >= MIN_MATCH)
            {
               this.ins_h = this.window[this.strstart] & 255;
               this.ins_h = (this.ins_h << this.hash_shift ^ this.window[this.strstart + 1] & 255) & this.hash_mask;
            }
            if(!(this.lookahead < MIN_LOOKAHEAD && this.strm.avail_in != 0))
            {
               return;
            }
         }
      }
      
      public function deflate_fast(param1:int) : int
      {
         var _loc3_:Boolean = false;
         var _loc2_:int = 0;
         while(true)
         {
            if(this.lookahead < MIN_LOOKAHEAD)
            {
               this.fill_window();
               if(this.lookahead < MIN_LOOKAHEAD && param1 == Z_NO_FLUSH)
               {
                  break;
               }
               if(this.lookahead == 0)
               {
               }
            }
            if(this.lookahead >= MIN_MATCH)
            {
               this.ins_h = (this.ins_h << this.hash_shift ^ this.window[this.strstart + (MIN_MATCH - 1)] & 255) & this.hash_mask;
               _loc2_ = this.head[this.ins_h];
               this.prev[this.strstart & this.w_mask] = this.head[this.ins_h];
               this.head[this.ins_h] = Cast.toShort(this.strstart);
            }
            if(_loc2_ != 0 && this.strstart - _loc2_ <= this.w_size - MIN_LOOKAHEAD)
            {
               if(this.strategy != Z_HUFFMAN_ONLY)
               {
                  this.match_length = this.longest_match(_loc2_);
               }
            }
            if(this.match_length >= MIN_MATCH)
            {
               _loc3_ = this._tr_tally(this.strstart - this.match_start,this.match_length - MIN_MATCH);
               this.lookahead -= this.match_length;
               if(this.match_length <= this.max_lazy_match && this.lookahead >= MIN_MATCH)
               {
                  --this.match_length;
                  do
                  {
                     ++this.strstart;
                     this.ins_h = (this.ins_h << this.hash_shift ^ this.window[this.strstart + (MIN_MATCH - 1)] & 255) & this.hash_mask;
                     _loc2_ = this.head[this.ins_h] & 65535;
                     this.prev[this.strstart & this.w_mask] = this.head[this.ins_h];
                     this.head[this.ins_h] = Cast.toShort(this.strstart);
                  }
                  while(--this.match_length != 0);
                  
                  ++this.strstart;
               }
               else
               {
                  this.strstart += this.match_length;
                  this.match_length = 0;
                  this.ins_h = this.window[this.strstart];
                  this.ins_h = (this.ins_h << this.hash_shift ^ this.window[this.strstart + 1] & 255) & this.hash_mask;
               }
            }
            else
            {
               _loc3_ = this._tr_tally(0,this.window[this.strstart] & 255);
               --this.lookahead;
               ++this.strstart;
            }
            if(_loc3_)
            {
               this.flush_block_only(false);
               if(this.strm.avail_out == 0)
               {
                  return NeedMore;
               }
            }
         }
         return NeedMore;
      }
      
      public function deflate_slow(param1:int) : int
      {
         var _loc3_:Boolean = false;
         var _loc4_:int = 0;
         var _loc2_:int = 0;
         while(true)
         {
            if(this.lookahead < MIN_LOOKAHEAD)
            {
               this.fill_window();
               if(this.lookahead < MIN_LOOKAHEAD && param1 == Z_NO_FLUSH)
               {
                  break;
               }
               if(this.lookahead == 0)
               {
               }
            }
            if(this.lookahead >= MIN_MATCH)
            {
               this.ins_h = (this.ins_h << this.hash_shift ^ this.window[this.strstart + (MIN_MATCH - 1)] & 255) & this.hash_mask;
               _loc2_ = this.head[this.ins_h] & 65535;
               this.prev[this.strstart & this.w_mask] = this.head[this.ins_h];
               this.head[this.ins_h] = Cast.toShort(this.strstart);
            }
            this.prev_length = this.match_length;
            this.prev_match = this.match_start;
            this.match_length = MIN_MATCH - 1;
            if(_loc2_ != 0 && this.prev_length < this.max_lazy_match && (this.strstart - _loc2_ & 65535) <= this.w_size - MIN_LOOKAHEAD)
            {
               if(this.strategy != Z_HUFFMAN_ONLY)
               {
                  this.match_length = this.longest_match(_loc2_);
               }
               if(this.match_length <= 5 && (this.strategy == Z_FILTERED || this.match_length == MIN_MATCH && this.strstart - this.match_start > 4096))
               {
                  this.match_length = MIN_MATCH - 1;
               }
            }
            if(this.prev_length >= MIN_MATCH && this.match_length <= this.prev_length)
            {
               _loc4_ = this.strstart + this.lookahead - MIN_MATCH;
               _loc3_ = this._tr_tally(this.strstart - 1 - this.prev_match,this.prev_length - MIN_MATCH);
               this.lookahead -= this.prev_length - 1;
               this.prev_length -= 2;
               do
               {
                  if(++this.strstart <= _loc4_)
                  {
                     this.ins_h = (this.ins_h << this.hash_shift ^ this.window[this.strstart + (MIN_MATCH - 1)] & 255) & this.hash_mask;
                     _loc2_ = this.head[this.ins_h] & 65535;
                     this.prev[this.strstart & this.w_mask] = this.head[this.ins_h];
                     this.head[this.ins_h] = Cast.toShort(this.strstart);
                  }
               }
               while(--this.prev_length != 0);
               
               this.match_available = 0;
               this.match_length = MIN_MATCH - 1;
               ++this.strstart;
               if(_loc3_)
               {
                  this.flush_block_only(false);
                  if(this.strm.avail_out == 0)
                  {
                     return NeedMore;
                  }
               }
            }
            else if(this.match_available != 0)
            {
               _loc3_ = this._tr_tally(0,this.window[this.strstart - 1] & 255);
               if(_loc3_)
               {
                  this.flush_block_only(false);
               }
               ++this.strstart;
               --this.lookahead;
               if(this.strm.avail_out == 0)
               {
                  return NeedMore;
               }
            }
            else
            {
               this.match_available = 1;
               ++this.strstart;
               --this.lookahead;
            }
         }
         return NeedMore;
      }
      
	  internal function longest_match(param1:int) : int
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc2_:int = this.max_chain_length;
         var _loc3_:int = this.strstart;
         var _loc6_:int = this.prev_length;
         var _loc7_:int = this.strstart > this.w_size - MIN_LOOKAHEAD ? int(int(this.strstart - (this.w_size - MIN_LOOKAHEAD))) : int(int(0));
         var _loc8_:int = this.nice_match;
         var _loc9_:int = this.w_mask;
         var _loc10_:int = this.strstart + MAX_MATCH;
         var _loc11_:uint = this.window[_loc3_ + _loc6_ - 1];
         var _loc12_:uint = this.window[_loc3_ + _loc6_];
         if(this.prev_length >= this.good_match)
         {
            _loc2_ >>= 2;
         }
         if(_loc8_ > this.lookahead)
         {
            _loc8_ = this.lookahead;
         }
         do
         {
            _loc4_ = param1;
            if(!(this.window[_loc4_ + _loc6_] != _loc12_ || this.window[_loc4_ + _loc6_ - 1] != _loc11_ || this.window[_loc4_] != this.window[_loc3_] || this.window[++_loc4_] != this.window[_loc3_ + 1]))
            {
               _loc3_ += 2;
               _loc4_++;
               while(this.window[++_loc3_] == this.window[++_loc4_] && this.window[++_loc3_] == this.window[++_loc4_] && this.window[++_loc3_] == this.window[++_loc4_] && this.window[++_loc3_] == this.window[++_loc4_] && this.window[++_loc3_] == this.window[++_loc4_] && this.window[++_loc3_] == this.window[++_loc4_] && this.window[++_loc3_] == this.window[++_loc4_] && this.window[++_loc3_] == this.window[++_loc4_] && _loc3_ < _loc10_)
               {
               }
               _loc5_ = MAX_MATCH - int(_loc10_ - _loc3_);
               _loc3_ = _loc10_ - MAX_MATCH;
               if(_loc5_ > _loc6_)
               {
                  this.match_start = param1;
                  _loc6_ = _loc5_;
                  if(_loc5_ >= _loc8_)
                  {
                     break;
                  }
                  _loc11_ = this.window[_loc3_ + _loc6_ - 1];
                  _loc12_ = this.window[_loc3_ + _loc6_];
               }
            }
         }
         while((param1 = this.prev[param1 & _loc9_] & 65535) > _loc7_ && --_loc2_ != 0);
         
         if(_loc6_ <= this.lookahead)
         {
            return _loc6_;
         }
         return this.lookahead;
      }
      
      public function deflateInitWithBits(param1:ZStream, param2:int, param3:int) : int
      {
         return this.deflateInit2(param1,param2,Z_DEFLATED,param3,DEF_MEM_LEVEL,Z_DEFAULT_STRATEGY);
      }
      
      public function deflateInit(param1:ZStream, param2:int) : int
      {
         return this.deflateInitWithBits(param1,param2,MAX_WBITS);
      }
      
      public function deflateInit2(param1:ZStream, param2:int, param3:int, param4:int, param5:int, param6:int) : int
      {
         var _loc7_:int = 0;
         param1.msg = null;
         if(param2 == Z_DEFAULT_COMPRESSION)
         {
            param2 = 6;
         }
         if(param4 < 0)
         {
            _loc7_ = 1;
            param4 = -param4;
         }
         if(param5 < 1 || param5 > MAX_MEM_LEVEL || param3 != Z_DEFLATED || param4 < 9 || param4 > 15 || param2 < 0 || param2 > 9 || param6 < 0 || param6 > Z_HUFFMAN_ONLY)
         {
            return Z_STREAM_ERROR;
         }
         param1.dstate = Deflate(this);
         this.noheader = _loc7_;
         this.w_bits = param4;
         this.w_size = 1 << this.w_bits;
         this.w_mask = this.w_size - 1;
         this.hash_bits = param5 + 7;
         this.hash_size = 1 << this.hash_bits;
         this.hash_mask = this.hash_size - 1;
         this.hash_shift = (this.hash_bits + MIN_MATCH - 1) / MIN_MATCH;
         this.window = new ByteArray();
         this.prev = new Array();
         this.head = new Array();
         this.lit_bufsize = 1 << param5 + 6;
         this.pending_buf = new ByteArray();
         this.pending_buf_size = this.lit_bufsize * 4;
         this.d_buf = this.lit_bufsize / 2;
         this.l_buf = (1 + 2) * this.lit_bufsize;
         this.level = param2;
         this.strategy = param6;
         this.method = param3;
         return this.deflateReset(param1);
      }
      
	  internal function deflateReset(param1:ZStream) : int
      {
         param1.total_out = 0;
         param1.total_in = 0;
         param1.msg = null;
         param1.data_type = Z_UNKNOWN;
         this.pending = 0;
         this.pending_out = 0;
         this.pending_buf = new ByteArray();
         if(this.noheader < 0)
         {
            this.noheader = 0;
         }
         this.status = this.noheader != 0 ? int(int(BUSY_STATE)) : int(int(INIT_STATE));
         param1.adler = param1._adler.adler32(0,null,0,0);
         this.last_flush = Z_NO_FLUSH;
         this.tr_init();
         this.lm_init();
         return Z_OK;
      }
      
	  internal function deflateEnd() : int
      {
         if(this.status != INIT_STATE && this.status != BUSY_STATE && this.status != FINISH_STATE)
         {
            return Z_STREAM_ERROR;
         }
         this.pending_buf = null;
         this.head = null;
         this.prev = null;
         this.window = null;
         return this.status == BUSY_STATE ? int(int(Z_DATA_ERROR)) : int(int(Z_OK));
      }
      
	  internal function deflateParams(param1:ZStream, param2:int, param3:int) : int
      {
         var _loc4_:int = Z_OK;
         if(param2 == Z_DEFAULT_COMPRESSION)
         {
            param2 = 6;
         }
         if(param2 < 0 || param2 > 9 || param3 < 0 || param3 > Z_HUFFMAN_ONLY)
         {
            return Z_STREAM_ERROR;
         }
         if(config_table[this.level].func != config_table[param2].func && param1.total_in != 0)
         {
            _loc4_ = param1.deflate(Z_PARTIAL_FLUSH);
         }
         if(this.level != param2)
         {
            this.level = param2;
            this.max_lazy_match = config_table[this.level].max_lazy;
            this.good_match = config_table[this.level].good_length;
            this.nice_match = config_table[this.level].nice_length;
            this.max_chain_length = config_table[this.level].max_chain;
         }
         this.strategy = param3;
         return _loc4_;
      }
      
	  internal function deflateSetDictionary(param1:ZStream, param2:ByteArray, param3:int) : int
      {
         var _loc4_:int = param3;
         var _loc5_:int = 0;
         if(param2 == null || this.status != INIT_STATE)
         {
            return Z_STREAM_ERROR;
         }
         param1.adler = param1._adler.adler32(param1.adler,param2,0,param3);
         if(_loc4_ < MIN_MATCH)
         {
            return Z_OK;
         }
         if(_loc4_ > this.w_size - MIN_LOOKAHEAD)
         {
            _loc4_ = this.w_size - MIN_LOOKAHEAD;
            _loc5_ = param3 - _loc4_;
         }
         System.byteArrayCopy(param2,_loc5_,this.window,0,_loc4_);
         this.strstart = _loc4_;
         this.block_start = _loc4_;
         this.ins_h = this.window[0] & 255;
         this.ins_h = (this.ins_h << this.hash_shift ^ this.window[1] & 255) & this.hash_mask;
         var _loc6_:int = 0;
         while(_loc6_ <= _loc4_ - MIN_MATCH)
         {
            this.ins_h = (this.ins_h << this.hash_shift ^ this.window[_loc6_ + (MIN_MATCH - 1)] & 255) & this.hash_mask;
            this.prev[_loc6_ & this.w_mask] = this.head[this.ins_h];
            this.head[this.ins_h] = Cast.toShort(_loc6_);
            _loc6_++;
         }
         return Z_OK;
      }
      
      public function deflate(param1:ZStream, param2:int) : int
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         if(param2 > Z_FINISH || param2 < 0)
         {
            return Z_STREAM_ERROR;
         }
         if(param1.next_out == null || param1.next_in == null && param1.avail_in != 0 || this.status == FINISH_STATE && param2 != Z_FINISH)
         {
            param1.msg = this.z_errmsg[Z_NEED_DICT - Z_STREAM_ERROR];
            return Z_STREAM_ERROR;
         }
         if(param1.avail_out == 0)
         {
            param1.msg = this.z_errmsg[Z_NEED_DICT - Z_BUF_ERROR];
            return Z_BUF_ERROR;
         }
         this.strm = param1;
         _loc3_ = this.last_flush;
         this.last_flush = param2;
         if(this.status == INIT_STATE)
         {
            _loc4_ = Z_DEFLATED + (this.w_bits - 8 << 4) << 8;
            _loc5_ = (this.level - 1 & 255) >> 1;
            if(_loc5_ > 3)
            {
               _loc5_ = 3;
            }
            _loc4_ |= _loc5_ << 6;
            if(this.strstart != 0)
            {
               _loc4_ |= PRESET_DICT;
            }
            _loc4_ += 31 - _loc4_ % 31;
            this.status = BUSY_STATE;
            this.putShortMSB(_loc4_);
            if(this.strstart != 0)
            {
               this.putShortMSB(int(param1.adler >>> 16));
               this.putShortMSB(int(param1.adler & 65535));
            }
            param1.adler = param1._adler.adler32(0,null,0,0);
         }
         if(this.pending != 0)
         {
            param1.flush_pending();
            if(param1.avail_out == 0)
            {
               this.last_flush = -1;
               return Z_OK;
            }
         }
         else if(param1.avail_in == 0 && param2 <= _loc3_ && param2 != Z_FINISH)
         {
            param1.msg = this.z_errmsg[Z_NEED_DICT - Z_BUF_ERROR];
            return Z_BUF_ERROR;
         }
         if(this.status == FINISH_STATE && param1.avail_in != 0)
         {
            param1.msg = this.z_errmsg[Z_NEED_DICT - Z_BUF_ERROR];
            return Z_BUF_ERROR;
         }
         if(param1.avail_in != 0 || this.lookahead != 0 || param2 != Z_NO_FLUSH && this.status != FINISH_STATE)
         {
            _loc6_ = -1;
            switch(config_table[this.level].func)
            {
               case STORED:
                  _loc6_ = this.deflate_stored(param2);
                  break;
               case FAST:
                  _loc6_ = this.deflate_fast(param2);
                  break;
               case SLOW:
                  _loc6_ = this.deflate_slow(param2);
            }
            if(_loc6_ == FinishStarted || _loc6_ == FinishDone)
            {
               this.status = FINISH_STATE;
            }
            if(_loc6_ == NeedMore || _loc6_ == FinishStarted)
            {
               if(param1.avail_out == 0)
               {
                  this.last_flush = -1;
               }
               return Z_OK;
            }
            if(_loc6_ == BlockDone)
            {
               if(param2 == Z_PARTIAL_FLUSH)
               {
                  this._tr_align();
               }
               else
               {
                  this._tr_stored_block(0,0,false);
                  if(param2 == Z_FULL_FLUSH)
                  {
                     _loc7_ = 0;
                     while(_loc7_ < this.hash_size)
                     {
                        this.head[_loc7_] = 0;
                        _loc7_++;
                     }
                  }
               }
               param1.flush_pending();
               if(param1.avail_out == 0)
               {
                  this.last_flush = -1;
                  return Z_OK;
               }
            }
         }
         if(param2 != Z_FINISH)
         {
            return Z_OK;
         }
         if(this.noheader != 0)
         {
            return Z_STREAM_END;
         }
         this.putShortMSB(int(param1.adler >>> 16));
         this.putShortMSB(int(param1.adler & 65535));
         param1.flush_pending();
         this.noheader = -1;
         return this.pending != 0 ? int(int(Z_OK)) : int(int(Z_STREAM_END));
      }
   }
}
