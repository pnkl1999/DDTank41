package game.view.tool
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.ShowTipManager;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.core.ITipedDisplay;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.events.LivingEvent;
   import ddt.manager.LanguageMgr;
   import ddt.view.tips.ChangeNumToolTipInfo;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import game.model.Pet;
   
   public class PetEnergyStrip extends Sprite implements Disposeable, ITipedDisplay
   {
       
      
      private var _pet:Pet;
      
      private var _text:FilterFrameText;
      
      private var _bg:MovieClip;
      
      private var _mp:int;
      
      private var _maxMp:int = 100;
      
      private var _TipInfo:ChangeNumToolTipInfo;
      
      public function PetEnergyStrip(param1:Pet)
      {
         super();
         this._pet = param1;
         this._mp = this._pet.MP;
         this._maxMp = this._pet.MaxMP;
         this._TipInfo = new ChangeNumToolTipInfo();
         this._TipInfo.currentTxt = ComponentFactory.Instance.creatComponentByStylename("game.DanderStrip.currentTxt");
         this._TipInfo.title = LanguageMgr.GetTranslation("tank.game.petmp.mp") + ":";
         this._TipInfo.current = 0;
         this._TipInfo.total = this._maxMp;
         this._TipInfo.content = LanguageMgr.GetTranslation("core.petMptip.description");
         this.initView();
         this.initEvents();
      }
      
      private function initEvents() : void
      {
         this._pet.addEventListener(LivingEvent.PET_MP_CHANGE,this.onChange);
      }
      
      private function removeEvents() : void
      {
         this._pet.removeEventListener(LivingEvent.PET_MP_CHANGE,this.onChange);
      }
      
      private function onChange(param1:LivingEvent) : void
      {
         this._mp = this._pet.MP;
         this._maxMp = this._pet.MaxMP;
         this._text.text = [this._mp,this._maxMp].join("/");
         this._bg.gotoAndStop(this._mp * 100 / this._maxMp);
      }
      
      private function initView() : void
      {
         this._text = ComponentFactory.Instance.creatComponentByStylename("game.petEnergyStrip.PowerTxtII");
         this._text.text = [this._mp,this._maxMp].join("/");
         this._bg = ComponentFactory.Instance.creat("asset.game.petEnergyBar");
         addChild(this._bg);
         addChild(this._text);
         this._bg.gotoAndStop(this._mp * 100 / this._maxMp);
         ShowTipManager.Instance.addTip(this);
      }
      
      public function get tipData() : Object
      {
         this._TipInfo.current = this._mp;
         this._TipInfo.total = this._maxMp;
         return this._TipInfo;
      }
      
      public function set tipData(param1:Object) : void
      {
      }
      
      public function get tipDirctions() : String
      {
         return "0";
      }
      
      public function set tipDirctions(param1:String) : void
      {
      }
      
      public function get tipGapH() : int
      {
         return 0;
      }
      
      public function set tipGapH(param1:int) : void
      {
      }
      
      public function get tipGapV() : int
      {
         return 20;
      }
      
      public function set tipGapV(param1:int) : void
      {
      }
      
      public function get tipStyle() : String
      {
         return "ddt.view.tips.ChangeNumToolTip";
      }
      
      public function set tipStyle(param1:String) : void
      {
      }
      
      public function asDisplayObject() : DisplayObject
      {
         return this;
      }
      
      public function dispose() : void
      {
         this.removeEvents();
         ShowTipManager.Instance.removeTip(this);
         ObjectUtils.disposeObject(this._text);
         this._text = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         this._pet = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
