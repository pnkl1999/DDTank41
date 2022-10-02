package road7th.comm
{
   import flash.utils.ByteArray;
   
   public class PackageIn extends ByteArray
   {
      
      public static const HEADER_SIZE:Number = 20;
       
      
      private var _len:int;
      
      private var _checksum:int;
      
      private var _clientId:int;
      
      private var _code:int;
      
      private var _extend1:int;
      
      private var _extend2:int;
      
      public function PackageIn()
      {
         super();
      }
      
      public function load(param1:ByteArray, param2:int) : void
      {
         writeByte(param1.readByte());
         this.readHeader();
      }
      
      public function loadE(param1:ByteArray, param2:int, param3:ByteArray) : void
      {
         var _loc4_:int = 0;
         var _loc5_:ByteArray = new ByteArray();
         var _loc6_:ByteArray = new ByteArray();
         _loc4_ = 0;
         while(_loc4_ < param2)
         {
            _loc5_.writeByte(param1.readByte());
            _loc6_.writeByte(_loc5_[_loc4_]);
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < param2)
         {
            if(_loc4_ > 0)
            {
               param3[_loc4_ % 8] = param3[_loc4_ % 8] + _loc5_[_loc4_ - 1] ^ _loc4_;
               _loc6_[_loc4_] = _loc5_[_loc4_] - _loc5_[_loc4_ - 1] ^ param3[_loc4_ % 8];
            }
            else
            {
               _loc6_[_loc4_] = _loc5_[_loc4_] ^ param3[0];
            }
            _loc4_++;
         }
         _loc6_.position = 0;
         _loc4_ = 0;
         while(_loc4_ < param2)
         {
            writeByte(_loc6_.readByte());
            _loc4_++;
         }
         position = 0;
         this.readHeader();
      }
      
      public function readHeader() : void
      {
         readShort();
         this._len = readShort();
         this._checksum = readShort();
         this._code = readShort();
         this._clientId = readInt();
         this._extend1 = readInt();
         this._extend2 = readInt();
      }
      
      public function get checkSum() : int
      {
         return this._checksum;
      }
      
      public function get code() : int
      {
         return this._code;
      }
      
      public function get clientId() : int
      {
         return this._clientId;
      }
      
      public function get extend1() : int
      {
         return this._extend1;
      }
      
      public function get extend2() : int
      {
         return this._extend2;
      }
      
      public function get Len() : int
      {
         return this._len;
      }
      
      public function calculateCheckSum() : int
      {
         var _loc1_:int = 119;
         var _loc2_:int = 6;
         while(_loc2_ < length)
         {
            _loc1_ += this[_loc2_++];
         }
         return _loc1_ & 32639;
      }
      
      public function readXml() : XML
      {
         return new XML(readUTF());
      }
      
      public function readDateString() : String
      {
         return readShort() + "-" + readByte() + "-" + readByte() + " " + readByte() + ":" + readByte() + ":" + readByte();
      }
      
      public function readDate() : Date
      {
         var _loc1_:int = readShort();
         var _loc2_:int = readByte() - 1;
         var _loc3_:int = readByte();
         var _loc4_:int = readByte();
         var _loc5_:int = readByte();
         var _loc6_:int = readByte();
         return new Date(_loc1_,_loc2_,_loc3_,_loc4_,_loc5_,_loc6_);
      }
      
      public function readByteArray() : ByteArray
      {
         var _loc1_:ByteArray = new ByteArray();
         readBytes(_loc1_,0,this._len - position);
         _loc1_.position = 0;
         return _loc1_;
      }
      
      public function deCompress() : void
      {
         position = HEADER_SIZE;
         var _loc1_:ByteArray = new ByteArray();
         readBytes(_loc1_,0,this._len - HEADER_SIZE);
         _loc1_.uncompress();
         position = HEADER_SIZE;
         writeBytes(_loc1_,0,_loc1_.length);
         this._len = HEADER_SIZE + _loc1_.length;
         position = HEADER_SIZE;
      }
   }
}
