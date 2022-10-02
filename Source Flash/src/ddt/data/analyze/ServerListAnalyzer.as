package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.ServerInfo;
   //import flash.external.ExternalInterface;
   
   public class ServerListAnalyzer extends DataAnalyzer
   {
       
      
      public var list:Vector.<ServerInfo>;
      
      public var agentId:int;
      
      public var zoneName:String;
      
      public function ServerListAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:XMLList = null;
         var _loc4_:int = 0;
         var _loc5_:ServerInfo = null;
         var _loc2_:XML = new XML(param1);
         if(_loc2_.@value == "true")
         {
            this.agentId = _loc2_.@agentId;
            this.zoneName = _loc2_.@AreaName;
            message = _loc2_.@message;
            _loc3_ = _loc2_..Item;
            this.list = new Vector.<ServerInfo>();
            if(_loc3_.length() > 0)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc3_.length())
               {
                  _loc5_ = new ServerInfo();
				  
                  ObjectUtils.copyPorpertiesByXML(_loc5_,_loc3_[_loc4_]);
				  _loc5_.Port = _loc5_.Port + 69;
                  this.list.push(_loc5_);
				  //ExternalInterface.call("console.log", "Port", _loc5_.Port);
                  _loc4_++;
               }
               onAnalyzeComplete();
            }
         }
         else
         {
            message = _loc2_.@message;
            onAnalyzeError();
         }
      }
   }
}
