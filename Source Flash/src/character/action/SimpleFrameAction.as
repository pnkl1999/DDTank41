package character.action
{
   public class SimpleFrameAction extends BaseAction
   {
       
      
      private var _frames:Vector.<int>;
      
      public function SimpleFrameAction(frames:Vector.<int>, name:String = "", nextAction:String = "", priority:uint = 0, endStop:Boolean = false)
      {
         this._frames = frames;
         _len = this._frames.length;
         super(name,nextAction,priority,endStop);
         _type = BaseAction.SIMPLE_ACTION;
      }
      
      public function set frames(value:Vector.<int>) : void
      {
         this._frames = value;
      }
      
      public function get frames() : Vector.<int>
      {
         return this._frames.concat();
      }
      
      override public function toXml() : XML
      {
         var result:XML = super.toXml();
         result.@frames = this._frames.toString();
         return result;
      }
   }
}
