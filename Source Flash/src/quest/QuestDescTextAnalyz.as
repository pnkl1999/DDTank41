package quest
{
   public class QuestDescTextAnalyz
   {
       
      
      public function QuestDescTextAnalyz()
      {
         super();
      }
      
      public static function start(param1:String) : String
      {
         var _loc2_:String = param1;
         var _loc3_:Array = new Array(/cr>|cg>|cb>/gi,/<cr/gi,/<cg/gi,/<cb/gi,/【/gi,/】/gi);
         var _loc4_:Array = new Array("</font><font>","</font><font COLOR=\'#FF0000\'>","</font><font COLOR=\'#00FF00\'>","</font><font COLOR=\'#0000FF\'>","</font><a href=\'http://blog.163.com/redirect.html\'><font COLOR=\'#00FF00\'><u>","</u></font></a><font>");
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_.length)
         {
            _loc2_ = _loc2_.replace(_loc3_[_loc5_],_loc4_[_loc5_]);
            _loc5_++;
         }
         return "<font>" + _loc2_ + "</font>";
      }
   }
}
