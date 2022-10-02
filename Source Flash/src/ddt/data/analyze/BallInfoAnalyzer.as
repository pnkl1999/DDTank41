package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BallInfo;
   
   public class BallInfoAnalyzer extends DataAnalyzer
   {
       
      
      public var list:Vector.<BallInfo>;
      
      public function BallInfoAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:XMLList = null;
         var _loc4_:int = 0;
         var _loc5_:BallInfo = null;
         var _loc2_:XML = new XML(param1);
         this.list = new Vector.<BallInfo>();
         if(_loc2_.@value == "true")
         {
            _loc3_ = _loc2_..Item;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length())
            {
               _loc5_ = new BallInfo();
               ObjectUtils.copyPorpertiesByXML(_loc5_,_loc3_[_loc4_]);
               _loc5_.blastOutID = _loc3_[_loc4_].@BombPartical;
               _loc5_.craterID = _loc3_[_loc4_].@Crater;
               _loc5_.FlyingPartical = _loc3_[_loc4_].@FlyingPartical;
               this.list.push(_loc5_);
               _loc4_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc2_.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
   }
}
