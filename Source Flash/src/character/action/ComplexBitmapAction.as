package character.action
{
   public class ComplexBitmapAction extends BaseAction
   {
       
      
      private var _assets:Vector.<FrameByFrameItem>;
      
      private var _index:int;
      
      public function ComplexBitmapAction(assets:Vector.<FrameByFrameItem>, name:String = "", nextAction:String = "", priority:uint = 0, endStop:Boolean = false)
      {
         var item:FrameByFrameItem = null;
         super(name,nextAction,priority,endStop);
         _type = BaseAction.COMPLEX_ACTION;
         this._assets = assets;
         for each(item in this._assets)
         {
            _len = Math.max(_len,item.totalFrames);
         }
         this._index = 0;
      }
      
      override public function get len() : int
      {
         return _len;
      }
      
      override public function reset() : void
      {
         var item:FrameByFrameItem = null;
         for each(item in this._assets)
         {
            item.reset();
         }
         this._index = 0;
      }
      
      public function update() : void
      {
         ++this._index;
      }
      
      override public function dispose() : void
      {
         this._assets = null;
         super.dispose();
      }
      
      override public function get isEnd() : Boolean
      {
         return this._index >= _len - 1;
      }
      
      public function get assets() : Vector.<FrameByFrameItem>
      {
         return this._assets;
      }
      
      override public function toXml() : XML
      {
         var item:FrameByFrameItem = null;
         var result:XML = super.toXml();
         for(var i:int = 0; i < this._assets.length; i++)
         {
            item = this._assets[i];
            result.appendChild(item.toXml());
         }
         return result;
      }
   }
}
