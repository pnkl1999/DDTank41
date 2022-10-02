package petsBag.petsAdvanced
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class PetsPropItem extends Sprite implements Disposeable
   {
       
      
      private var _propNameArr:Array;
      
      private var _propNameTxt:FilterFrameText;
      
      private var _propValueTxt:FilterFrameText;
      
      private var _risingStarAddedPropValueTxt:FilterFrameText;
      
      private var _evolutionAddedPropValueTxt:FilterFrameText;
      
      private var _viewType:int;
      
      private var _numMc:MovieClip;
      
      private var _isPlayComplete:Boolean = true;
      
      private var _propValue:int;
      
      private var _addedProValue:Number;
      
      private var _index:int;
      
      public function PetsPropItem(param1:int)
      {
         this._propNameArr = ["MaxHp","attack","defence","agility","luck"];
         super();
         this._viewType = param1;
         this.initView();
      }
      
      private function initView() : void
      {
         this._propNameTxt = ComponentFactory.Instance.creatComponentByStylename("petsBag.advanced.propNameTxt");
         addChild(this._propNameTxt);
         this._propValueTxt = ComponentFactory.Instance.creatComponentByStylename("petsBag.advanced.propValueTxt");
         addChild(this._propValueTxt);
         if(this._viewType == 1)
         {
            this._risingStarAddedPropValueTxt = ComponentFactory.Instance.creatComponentByStylename("petsBag.risingStar.addedPropValueTxt");
            addChild(this._risingStarAddedPropValueTxt);
         }
         else
         {
            this._evolutionAddedPropValueTxt = ComponentFactory.Instance.creatComponentByStylename("petsBag.evolution.addedPropValueTxt");
            addChild(this._evolutionAddedPropValueTxt);
         }
      }
      
      public function setData(param1:int, param2:int, param3:Number) : void
      {
         this._index = param1;
         this._propValue = param2;
         this._addedProValue = param3;
         if(!this._isPlayComplete)
         {
            return;
         }
         this._propNameTxt.text = LanguageMgr.GetTranslation(this._propNameArr[param1]);
         if(this._viewType == 1)
         {
            this._propValueTxt.text = "+" + param2;
            this._risingStarAddedPropValueTxt.text = "（+" + param3.toFixed(1) + "）";
         }
         else
         {
            this._propValueTxt.text = "" + param2;
            this._evolutionAddedPropValueTxt.text = "+" + int(param3);
         }
      }
      
      public function playNumMc() : void
      {
         var _loc1_:int = 0;
         if(this._viewType == 1)
         {
            _loc1_ = this._propValueTxt.text.length - 1;
         }
         else
         {
            _loc1_ = this._propValueTxt.text.length;
         }
         this._numMc = ComponentFactory.Instance.creat("petsBag.advanced.numMc" + _loc1_);
         this._numMc.x = this._propValueTxt.x + 13 + 4.5 * (5 - _loc1_);
         this._numMc.y = this._propValueTxt.y + 2;
         addChild(this._numMc);
         this._isPlayComplete = false;
         addEventListener(Event.ENTER_FRAME,this.__enterHandler);
      }
      
      protected function __enterHandler(param1:Event) : void
      {
         if(this._numMc.currentFrame >= 23)
         {
            this._isPlayComplete = true;
            this.setData(this._index,this._propValue,this._addedProValue);
            removeChild(this._numMc);
            this._numMc = null;
            removeEventListener(Event.ENTER_FRAME,this.__enterHandler);
         }
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeObject(this._propNameTxt);
         this._propNameTxt = null;
         ObjectUtils.disposeObject(this._propValueTxt);
         this._propValueTxt = null;
         ObjectUtils.disposeObject(this._risingStarAddedPropValueTxt);
         this._risingStarAddedPropValueTxt = null;
         ObjectUtils.disposeObject(this._evolutionAddedPropValueTxt);
         this._evolutionAddedPropValueTxt = null;
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
