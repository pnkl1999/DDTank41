package littleGame.view
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.text.GradientText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.player.PlayerInfo;
   import ddt.view.common.VipLevelIcon;
   import flash.display.Graphics;
   import flash.display.Sprite;
   
   public final class PlayerNameField extends Sprite implements Disposeable
   {
       
      
      private var _player:PlayerInfo;
      
      private var _vipIcon:VipLevelIcon;
      
      private var _vipNameField:GradientText;
      
      private var _nameField:FilterFrameText;
      
      public function PlayerNameField(player:PlayerInfo)
      {
         this._player = player;
         super();
         this.configUI();
         cacheAsBitmap = true;
      }
      
      private function configUI() : void
      {
         if(this._player.IsVIP)
         {
         }
         this._nameField = ComponentFactory.Instance.creatComponentByStylename("littleGame.LivingNameField");
         addChild(this._nameField);
         this._nameField.text = this._player.NickName;
         this.drawBackground();
      }
      
      private function drawBackground() : void
      {
         var g:Graphics = graphics;
         g.clear();
         g.beginFill(0,0.6);
         g.drawRoundRect(this._nameField.width - this._nameField.textWidth - this._nameField.x >> 1,0,this._nameField.textWidth + this._nameField.x * 2,this._nameField.textHeight + this._nameField.y * 2,4);
         if(this._player.IsVIP)
         {
         }
         g.endFill();
      }
      
      public function dispose() : void
      {
         if(parent)
         {
            parent.removeChild(this);
         }
         this._player = null;
         ObjectUtils.disposeObject(this._vipIcon);
         this._vipIcon = null;
         ObjectUtils.disposeObject(this._vipNameField);
         this._vipNameField = null;
         ObjectUtils.disposeObject(this._nameField);
         this._nameField = null;
      }
   }
}
