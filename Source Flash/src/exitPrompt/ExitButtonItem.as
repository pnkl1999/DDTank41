package exitPrompt
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.core.Component;
   import com.pickgliss.utils.ObjectUtils;
   import flash.display.Bitmap;
   
   public class ExitButtonItem extends Component
   {
       
      
      private var _bt:BaseButton;
      
      private var _bullet:Bitmap;
      
      private var _fontBg:Bitmap;
      
      public var fontBgBgUrl:String;
      
      public var coord:String;
      
      public function ExitButtonItem()
      {
         super();
      }
      
      override protected function onProppertiesUpdate() : void
      {
         super.onProppertiesUpdate();
         var _loc1_:Array = this.coord.split(/,/g);
         if(!this._bt)
         {
            this._bt = ComponentFactory.Instance.creat("ExitPromptFrame.MissionBt");
         }
         if(!this._bullet)
         {
            this._bullet = ComponentFactory.Instance.creat("asset.core.quest.QuestConditionBGHighlight");
         }
         if(!this._fontBg)
         {
            this._fontBg = ComponentFactory.Instance.creat(this.fontBgBgUrl);
         }
         addChild(this._bt);
         addChild(this._bullet);
         addChild(this._fontBg);
         this._bullet.x = _loc1_[0];
         this._bullet.y = _loc1_[1];
         this._fontBg.x = _loc1_[2];
         this._fontBg.y = _loc1_[3];
         height = this._bt.height;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         ObjectUtils.disposeObject(this._bt);
         ObjectUtils.disposeObject(this._bullet);
         ObjectUtils.disposeObject(this._fontBg);
         this._bt = null;
         this._bullet = null;
         this._fontBg = null;
      }
   }
}
