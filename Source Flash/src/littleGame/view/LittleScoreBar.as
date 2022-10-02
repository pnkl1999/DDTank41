package littleGame.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.SelfInfo;
   import ddt.events.PlayerPropertyEvent;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class LittleScoreBar extends Sprite implements Disposeable
   {
       
      
      private var _self:SelfInfo;
      
      private var _back:DisplayObject;
      
      private var _scoreField:GradientText;
      
      public function LittleScoreBar(self:SelfInfo)
      {
         this._self = self;
         super();
         this.configUI();
         this.addEvent();
      }
      
      private function configUI() : void
      {
         this._back = ComponentFactory.Instance.creatBitmap("asset.littleGame.ScoreBack");
         addChild(this._back);
         this._scoreField = ComponentFactory.Instance.creatComponentByStylename("littleGame.ScoreField");
         addChild(this._scoreField);
         this._scoreField.text = String(this._self.Score);
         this._scoreField.x = this._back.width - this._scoreField.width - 6;
      }
      
      private function addEvent() : void
      {
         this._self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__selfPropertyChanged);
      }
      
      private function removeEvent() : void
      {
         this._self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE,this.__selfPropertyChanged);
      }
      
      private function __selfPropertyChanged(event:PlayerPropertyEvent) : void
      {
         if(event.changedProperties["Score"])
         {
            this._scoreField.text = String(this._self.Score);
            this._scoreField.x = this._back.width - this._scoreField.width - 6;
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         this._self = null;
         ObjectUtils.disposeObject(this._scoreField);
         this._scoreField = null;
         ObjectUtils.disposeObject(this._back);
         this._back = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
