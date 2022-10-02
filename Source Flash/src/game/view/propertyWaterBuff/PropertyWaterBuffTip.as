package game.view.propertyWaterBuff
{
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.Image;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.tip.ITip;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.BuffInfo;
   import ddt.manager.LanguageMgr;
   import ddt.manager.TimeManager;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class PropertyWaterBuffTip extends Sprite implements Disposeable, ITip
   {
       
      
      private var _buffInfo:BuffInfo;
      
      private var _bg:Image;
      
      private var _name:FilterFrameText;
      
      private var _explication:FilterFrameText;
      
      private var _timer:FilterFrameText;
      
      public function PropertyWaterBuffTip()
      {
         super();
         this.init();
      }
      
      private function init() : void
      {
         this._bg = UICreatShortcut.creatAndAdd("game.view.propertyWaterBuffTip.bg",this);
         this._name = UICreatShortcut.creatTextAndAdd("game.view.propertyWaterBuffTip.nameTxt","1级防御药水",this);
         this._explication = UICreatShortcut.creatTextAndAdd("game.view.propertyWaterBuffTip.explicationTxt","防御提升70点",this);
         this._timer = UICreatShortcut.creatTextAndAdd("game.view.propertyWaterBuffTip.timerTxt","还剩50分钟",this);
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._name);
         this._name = null;
         ObjectUtils.disposeObject(this._explication);
         this._explication = null;
         ObjectUtils.disposeObject(this._timer);
         this._timer = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      public function get tipData() : Object
      {
         return this._buffInfo;
      }
      
      public function set tipData(param1:Object) : void
      {
         this._buffInfo = param1 as BuffInfo;
         this.update();
      }
      
      private function update() : void
      {
         var _loc1_:int = this._buffInfo.getLeftTimeByUnit(TimeManager.DAY_TICKS);
         var _loc2_:int = this._buffInfo.getLeftTimeByUnit(TimeManager.HOUR_TICKS);
         var _loc3_:int = this._buffInfo.getLeftTimeByUnit(TimeManager.Minute_TICKS);
         this._name.text = this._buffInfo.buffName;
         this._explication.text = this._buffInfo.buffItemInfo.Description;
         if(_loc1_ > 0)
         {
            this._timer.text = LanguageMgr.GetTranslation("game.view.propertyWaterBuff.timer",_loc1_);
         }
         else if(_loc2_ > 0)
         {
            this._timer.text = LanguageMgr.GetTranslation("game.view.propertyWaterBuff.timerI",_loc2_);
         }
         else if(_loc3_ > 0)
         {
            this._timer.text = LanguageMgr.GetTranslation("game.view.propertyWaterBuff.timerII",_loc3_);
         }
         else
         {
            this._timer.text = LanguageMgr.GetTranslation("game.view.propertyWaterBuff.timerIII");
            this._timer.textColor = 16711680;
         }
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
   }
}
