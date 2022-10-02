package newTitle.analyzer
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import flash.utils.Dictionary;
   import newTitle.model.NewTitleModel;
   
   public class NewTitleDataAnalyz extends DataAnalyzer
   {
       
      
      public var _newTitleList:Dictionary;
      
      public function NewTitleDataAnalyz(onCompleteCall:Function)
      {
         super(onCompleteCall);
      }
      
      override public function analyze(data:*) : void
      {
         var _loc3_:* = null;
         var _loc5_:int = 0;
         var _loc4_:* = null;
         this._newTitleList = new Dictionary();
         var _loc2_:XML = new XML(data);
         if(_loc2_.@value == "true")
         {
            _loc3_ = _loc2_..Item;
            _loc5_ = 0;
            while(_loc5_ < _loc3_.length())
            {
               _loc4_ = new NewTitleModel();
               ObjectUtils.copyPorpertiesByXML(_loc4_,_loc3_[_loc5_]);
               this._newTitleList[_loc4_.id] = _loc4_;
               _loc5_++;
            }
            onAnalyzeComplete();
         }
         else
         {
            message = _loc2_.@message;
            onAnalyzeError();
            onAnalyzeError();
         }
      }
      
      public function get list() : Dictionary
      {
         return this._newTitleList;
      }
   }
}
