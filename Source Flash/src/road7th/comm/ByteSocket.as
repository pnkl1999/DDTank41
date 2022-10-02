package road7th.comm
{
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.net.Socket;
   import flash.utils.ByteArray;
   
   [Event(name="connect",type="flash.events.Event")]
   [Event(name="close",type="flash.events.Event")]
   [Event(name="error",type="flash.events.ErrorEvent")]
   [Event(name="data",type="SocketEvent")]
   public class ByteSocket extends EventDispatcher
   {
      
      private static var KEY:Array = [174,191,86,120,171,205,239,241];
      
      public static var RECEIVE_KEY:ByteArray;
      
      public static var SEND_KEY:ByteArray;
       
      
      private var _debug:Boolean;
      
      private var _socket:Socket;
      
      private var _ip:String;
      
      private var _port:Number;
      
      private var _send_fsm:FSM;
      
      private var _receive_fsm:FSM;
      
      private var _encrypted:Boolean;
      
      private var _readBuffer:ByteArray;
      
      private var _readOffset:int;
      
      private var _writeOffset:int;
      
      private var _headerTemp:ByteArray;
      
      private var pkgNumber:int = 0;
      
      public function ByteSocket(param1:Boolean = true, param2:Boolean = false)
      {
         super();
         this._readBuffer = new ByteArray();
         this._send_fsm = new FSM(2059198199,1501);
         this._receive_fsm = new FSM(2059198199,1501);
         this._headerTemp = new ByteArray();
         this._encrypted = param1;
         this._debug = param2;
         this.setKey(KEY);
      }
      
      public function setKey(param1:Array) : void
      {
         RECEIVE_KEY = new ByteArray();
         SEND_KEY = new ByteArray();
         var _loc2_:int = 0;
         while(_loc2_ < 8)
         {
            RECEIVE_KEY.writeByte(param1[_loc2_]);
            SEND_KEY.writeByte(param1[_loc2_]);
            _loc2_++;
         }
      }
      
      public function resetKey() : void
      {
         this.setKey(KEY);
      }
      
      public function setFsm(param1:int, param2:int) : void
      {
         this._send_fsm.setup(param1,param2);
         this._receive_fsm.setup(param1,param2);
      }
      
      public function connect(param1:String, param2:Number) : void
      {
         var ip:String = param1;
         var port:Number = param2;
         try
         {
            if(this._socket)
            {
               this.close();
            }
            this._socket = new Socket();
            this.addEvent(this._socket);
            this._ip = ip;
            this._port = port;
            this._readBuffer.position = 0;
            this._readOffset = 0;
            this._writeOffset = 0;
            this._socket.connect(ip,port);
            return;
         }
         catch(err:Error)
         {
            dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,err.message));
            return;
         }
      }
      
      private function addEvent(param1:Socket) : void
      {
         param1.addEventListener(Event.CONNECT,this.handleConnect);
         param1.addEventListener(Event.CLOSE,this.handleClose);
         param1.addEventListener(ProgressEvent.SOCKET_DATA,this.handleIncoming);
         param1.addEventListener(IOErrorEvent.IO_ERROR,this.handleIoError);
         param1.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.handleIoError);
      }
      
      private function removeEvent(param1:Socket) : void
      {
         param1.removeEventListener(Event.CONNECT,this.handleConnect);
         param1.removeEventListener(Event.CLOSE,this.handleClose);
         param1.removeEventListener(ProgressEvent.SOCKET_DATA,this.handleIncoming);
         param1.removeEventListener(IOErrorEvent.IO_ERROR,this.handleIoError);
         param1.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.handleIoError);
      }
      
      public function get connected() : Boolean
      {
         return this._socket && this._socket.connected;
      }
      
      public function isSame(param1:String, param2:int) : Boolean
      {
         return this._ip == param1 && param2 == this._port;
      }
      
      public function send(param1:PackageOut) : void
      {
         var _loc2_:int = 0;
         if(this._socket && this._socket.connected)
         {
            param1.pack();
            if(this._debug)
            {
            }
            if(this._encrypted)
            {
               _loc2_ = 0;
               while(_loc2_ < param1.length)
               {
                  if(_loc2_ > 0)
                  {
                     SEND_KEY[_loc2_ % 8] = SEND_KEY[_loc2_ % 8] + param1[_loc2_ - 1] ^ _loc2_;
                     param1[_loc2_] = (param1[_loc2_] ^ SEND_KEY[_loc2_ % 8]) + param1[_loc2_ - 1];
                  }
                  else
                  {
                     param1[0] ^= SEND_KEY[0];
                  }
                  _loc2_++;
               }
            }
            this._socket.writeBytes(param1,0,param1.length);
            this._socket.flush();
         }
      }
      
      public function sendString(param1:String) : void
      {
         if(this._socket.connected)
         {
            this._socket.writeUTF(param1);
            this._socket.flush();
         }
      }
      
      public function close() : void
      {
         this.removeEvent(this._socket);
         if(this._socket.connected)
         {
            this._socket.close();
         }
      }
      
      private function handleConnect(param1:Event) : void
      {
         try
         {
            this._send_fsm.reset();
            this._receive_fsm.reset();
            this._send_fsm.setup(2059198199,1501);
            this._receive_fsm.setup(2059198199,1501);
            dispatchEvent(new Event(Event.CONNECT));
            return;
         }
         catch(e:Error)
         {
            return;
         }
      }
      
      private function handleClose(param1:Event) : void
      {
         try
         {
            this.removeEvent(this._socket);
            dispatchEvent(new Event(Event.CLOSE));
            return;
         }
         catch(e:Error)
         {
            return;
         }
      }
      
      private function handleIoError(param1:ErrorEvent) : void
      {
         try
         {
            dispatchEvent(new ErrorEvent(ErrorEvent.ERROR,false,false,param1.text));
            return;
         }
         catch(e:Error)
         {
            return;
         }
      }
      
      private function handleIncoming(param1:ProgressEvent) : void
      {
         var _loc2_:int = 0;
         if(this._socket.bytesAvailable > 0)
         {
            _loc2_ = this._socket.bytesAvailable;
            this._socket.readBytes(this._readBuffer,this._writeOffset,this._socket.bytesAvailable);
            this._writeOffset += _loc2_;
            if(this._writeOffset > 1)
            {
               this._readBuffer.position = 0;
               this._readOffset = 0;
               if(this._readBuffer.bytesAvailable >= PackageIn.HEADER_SIZE)
               {
                  this.readPackage();
               }
            }
         }
      }
      
      private function readPackage() : void
      {
         var _loc2_:int = 0;
         var _loc3_:PackageIn = null;
         var _loc1_:int = this._writeOffset - this._readOffset;
         do
         {
            _loc2_ = 0;
            while(this._readOffset + 4 < this._writeOffset)
            {
               this._headerTemp.position = 0;
               this._headerTemp.writeByte(this._readBuffer[this._readOffset]);
               this._headerTemp.writeByte(this._readBuffer[this._readOffset + 1]);
               this._headerTemp.writeByte(this._readBuffer[this._readOffset + 2]);
               this._headerTemp.writeByte(this._readBuffer[this._readOffset + 3]);
               if(this._encrypted)
               {
                  this._headerTemp = this.decrptBytes(this._headerTemp,4,this.copyByteArray(RECEIVE_KEY));
               }
               this._headerTemp.position = 0;
               if(this._headerTemp.readShort() == PackageOut.HEADER)
               {
                  _loc2_ = this._headerTemp.readUnsignedShort();
                  break;
               }
               ++this._readOffset;
            }
            _loc1_ = this._writeOffset - this._readOffset;
            if(!(_loc1_ >= _loc2_ && _loc2_ != 0))
            {
               break;
            }
            this._readBuffer.position = this._readOffset;
            _loc3_ = new PackageIn();
            if(this._encrypted)
            {
               _loc3_.loadE(this._readBuffer,_loc2_,RECEIVE_KEY);
            }
            else
            {
               _loc3_.load(this._readBuffer,_loc2_);
            }
            this._readOffset += _loc2_;
            _loc1_ = this._writeOffset - this._readOffset;
            this.handlePackage(_loc3_);
         }
         while(_loc1_ >= PackageIn.HEADER_SIZE);
         
         this._readBuffer.position = 0;
         if(_loc1_ > 0)
         {
            this._readBuffer.writeBytes(this._readBuffer,this._readOffset,_loc1_);
         }
         this._readOffset = 0;
         this._writeOffset = _loc1_;
      }
      
      private function copyByteArray(param1:ByteArray) : ByteArray
      {
         var _loc2_:ByteArray = new ByteArray();
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.writeByte(param1[_loc3_]);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function decrptBytes(param1:ByteArray, param2:int, param3:ByteArray) : ByteArray
      {
         var _loc4_:int = 0;
         var _loc5_:ByteArray = new ByteArray();
         _loc4_ = 0;
         while(_loc4_ < param2)
         {
            _loc5_.writeByte(param1[_loc4_]);
            _loc4_++;
         }
         _loc4_ = 0;
         while(_loc4_ < param2)
         {
            if(_loc4_ > 0)
            {
               param3[_loc4_ % 8] = param3[_loc4_ % 8] + param1[_loc4_ - 1] ^ _loc4_;
               _loc5_[_loc4_] = param1[_loc4_] - param1[_loc4_ - 1] ^ param3[_loc4_ % 8];
            }
            else
            {
               _loc5_[0] = param1[0] ^ param3[0];
            }
            _loc4_++;
         }
         return _loc5_;
      }
      
      private function tracePkg(param1:ByteArray, param2:String, param3:int = -1) : void
      {
         var _loc4_:String = param2;
         var _loc5_:int = param3 < 0 ? int(int(param1.length)) : int(int(param3));
         var _loc6_:int = 0;
         while(_loc6_ < _loc5_)
         {
            _loc4_ += String(param1[_loc6_]) + ", ";
            _loc6_++;
         }
      }
      
      private function traceArr(param1:ByteArray) : void
      {
         var _loc2_:String = "[";
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_ += param1[_loc3_] + " ";
            _loc3_++;
         }
         _loc2_ += "]";
      }
      
      private function handlePackage(param1:PackageIn) : void
      {
         if(this._debug)
         {
         }
         try
         {
            if(param1.checkSum == param1.calculateCheckSum())
            {
               param1.position = PackageIn.HEADER_SIZE;
               dispatchEvent(new SocketEvent(SocketEvent.DATA,param1));
            }
            return;
         }
         catch(err:Error)
         {
            return;
         }
      }
      
      public function dispose() : void
      {
         if(this._socket.connected)
         {
            this._socket.close();
         }
         this._socket = null;
      }
   }
}

class FSM
{
    
   
   private var _state:int;
   
   private var _adder:int;
   
   private var _multiper:int;
   
   function FSM(param1:int, param2:int)
   {
      super();
      this.setup(param1,param2);
   }
   
   public function getState() : int
   {
      return this._state;
   }
   
   public function reset() : void
   {
      this._state = 0;
   }
   
   public function setup(param1:int, param2:int) : void
   {
      this._adder = param1;
      this._multiper = param2;
      this.updateState();
   }
   
   public function updateState() : int
   {
      this._state = (~this._state + this._adder) * this._multiper;
      this._state ^= this._state >> 16;
      return this._state;
   }
}
