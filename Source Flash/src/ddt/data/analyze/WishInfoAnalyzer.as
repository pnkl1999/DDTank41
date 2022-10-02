package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import store.forge.wishBead.WishChangeInfo;
   
   public class WishInfoAnalyzer extends DataAnalyzer
   {
       
      
      public var _wishChangeInfo:Vector.<WishChangeInfo>;
      
      public function WishInfoAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc4_:int = 0;
         var _loc5_:WishChangeInfo = null;
         var _loc2_:XML = new XML(param1);
         var _loc3_:XMLList = _loc2_..item;
         this._wishChangeInfo = new Vector.<WishChangeInfo>();
         if(_loc2_.@value == "true")
         {
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length())
            {
               _loc5_ = new WishChangeInfo();
               ObjectUtils.copyPorpertiesByXML(_loc5_,_loc3_[_loc4_]);
               this._wishChangeInfo.push(_loc5_);
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
