package character.action
{
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.utils.getQualifiedClassName;
   
   public class MovieClipAction extends BaseAction
   {
       
      
      public function MovieClipAction(movieclip:MovieClip, name:String = "", nextAction:String = "", priority:uint = 0, endStop:Boolean = false)
      {
         _asset = movieclip;
         _len = movieclip.totalFrames;
         super(name,nextAction,priority,endStop);
         _type = BaseAction.MOVIE_ACTION;
      }
      
      override public function get isEnd() : Boolean
      {
         return MovieClip(_asset).currentFrame >= MovieClip(_asset).totalFrames;
      }
      
      override public function reset() : void
      {
         MovieClip(_asset).gotoAndStop(1);
      }
      
      public function set asset(value:DisplayObject) : void
      {
         if(_asset.parent)
         {
            _asset.parent.removeChild(_asset);
         }
         _asset = value;
      }
      
      override public function toXml() : XML
      {
         var result:XML = super.toXml();
         result.@asset = getQualifiedClassName(_asset).replace("::",".");
         return result;
      }
   }
}
