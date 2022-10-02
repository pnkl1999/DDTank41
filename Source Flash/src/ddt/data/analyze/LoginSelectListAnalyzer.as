package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.Role;
   import road7th.utils.DateUtils;
   
   public class LoginSelectListAnalyzer extends DataAnalyzer
   {
       
      
      public var list:Vector.<Role>;
      
      public var totalCount:int;
      
      public function LoginSelectListAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc3_:XMLList = null;
         var _loc4_:int = 0;
         var _loc5_:Role = null;
         var _loc2_:XML = new XML(param1);
         if(_loc2_.@value == "true")
         {
            this.list = new Vector.<Role>();
            this.totalCount = int(_loc2_.@total);
            _loc3_ = XML(_loc2_)..Item;
            _loc4_ = 0;
            while(_loc4_ < _loc3_.length())
            {
               _loc5_ = new Role();
               _loc5_.LastDate = DateUtils.decodeDated(_loc3_[_loc4_].@LastDate);
               ObjectUtils.copyPorpertiesByXML(_loc5_,_loc3_[_loc4_]);
               this.list.push(_loc5_);
               _loc4_++;
            }
            this.list.sort(this.sortLastDate);
            onAnalyzeComplete();
         }
         else
         {
            message = _loc2_.@message;
            onAnalyzeError();
         }
      }
      
      private function sortLastDate(param1:Role, param2:Role) : int
      {
         var _loc3_:int = 0;
         if(param1.LastDate.time < param2.LastDate.time)
         {
            _loc3_ = 1;
         }
         else
         {
            _loc3_ = -1;
         }
         return _loc3_;
      }
   }
}
