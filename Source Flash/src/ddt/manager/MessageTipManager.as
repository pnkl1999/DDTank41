package ddt.manager
{
   import com.greensock.TweenMax;
   import com.greensock.easing.Quint;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.UICreatShortcut;
   import com.pickgliss.ui.text.FilterFrameText;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.text.AntiAliasType;
   
   public class MessageTipManager
   {
      
      private static var instance:MessageTipManager;
       
      
      private var _messageTip:Sprite;
      
      private var _tipString:String;
      
      private var _tipText:FilterFrameText;
      
      private var _tipBg:DisplayObject;
      
      private var _isPlaying:Boolean;
      
      private var _currentType:int;
      
      private var _ghostPropContent:PropMessageHolder;
      
      private var _emptyGridContent:EmptyGridMsgHolder;
      
      private var _autoUsePropContent:AutoUsePropMessage;
      
      private var _tipContainer:Sprite;
      
      private var _duration:Number;
      
      public function MessageTipManager()
      {
         super();
         this._tipContainer = new Sprite();
         this._tipContainer.mouseChildren = this._tipContainer.mouseEnabled = false;
         this._tipContainer.y = StageReferance.stageHeight >> 1;
         this._messageTip = new Sprite();
         this._tipBg = UICreatShortcut.creatAndAdd("core.Scale9CornerImage23",this._tipContainer);
         this._tipText = UICreatShortcut.creatAndAdd("core.messageTip.TipText",this._messageTip);
         this._tipText.filters = ComponentFactory.Instance.creatFilters("core.messageTip.TipTextFilter_1");
         this._tipText.antiAliasType = AntiAliasType.ADVANCED;
         this._tipText.mouseEnabled = this._messageTip.mouseEnabled = false;
         this._messageTip.mouseChildren = false;
         this._ghostPropContent = new PropMessageHolder();
         this._ghostPropContent.x = 130;
         this._ghostPropContent.y = 10;
         this._emptyGridContent = new EmptyGridMsgHolder();
         this._emptyGridContent.x = 130;
         this._emptyGridContent.y = 10;
         this._autoUsePropContent = new AutoUsePropMessage();
         this._autoUsePropContent.x = 130;
         this._autoUsePropContent.y = 10;
      }
      
      public static function getInstance() : MessageTipManager
      {
         if(instance == null)
         {
            instance = new MessageTipManager();
         }
         return instance;
      }
      
      public function get currentType() : int
      {
         return this._currentType;
      }
      
      public function get isPlaying() : Boolean
      {
         return this._isPlaying;
      }
      
      private function setContent(param1:String) : DisplayObject
      {
         this.cleanContent();
         this._tipString = param1;
         this._tipText.autoSize = "center";
         this._tipText.text = this._tipString;
         this._tipBg.width = this._tipText.textWidth + 260;
         this._tipBg.height = this._tipText.textHeight + 20;
         this._tipBg.x = StageReferance.stageWidth - this._tipBg.width >> 1;
         this._tipContainer.addChild(this._tipBg);
         this._tipContainer.addChild(this._messageTip);
         return this._tipContainer;
      }
      
      private function setGhostPropContent(param1:String) : DisplayObject
      {
         this.cleanContent();
         this._ghostPropContent.setContent(param1);
         this._tipBg.width = this._ghostPropContent.width + 260;
         this._tipBg.height = this._ghostPropContent.height + 20;
         this._tipBg.x = StageReferance.stageWidth - this._tipBg.width >> 1;
         this._ghostPropContent.x = this._tipBg.x + 130;
         this._tipContainer.addChild(this._tipBg);
         this._tipContainer.addChild(this._ghostPropContent);
         return this._tipContainer;
      }
      
      private function setFullPropContent(param1:String) : DisplayObject
      {
         this.cleanContent();
         this._emptyGridContent.setContent(param1);
         this._tipBg.width = this._emptyGridContent.width + 260;
         this._tipBg.height = this._emptyGridContent.height + 20;
         this._tipBg.x = StageReferance.stageWidth - this._tipBg.width >> 1;
         this._emptyGridContent.x = this._tipBg.x + 130;
         this._tipContainer.addChild(this._tipBg);
         this._tipContainer.addChild(this._emptyGridContent);
         return this._tipContainer;
      }
      
      private function setAutoUsePropContent(param1:String) : DisplayObject
      {
         this.cleanContent();
         this._autoUsePropContent.setContent(param1);
         this._tipBg.width = this._autoUsePropContent.width + 260;
         this._tipBg.height = this._autoUsePropContent.height + 20;
         this._tipBg.x = StageReferance.stageWidth - this._tipBg.width >> 1;
         this._autoUsePropContent.x = this._tipBg.x + 130;
         this._tipContainer.addChild(this._tipBg);
         this._tipContainer.addChild(this._autoUsePropContent);
         return this._tipContainer;
      }
      
      private function cleanContent() : void
      {
         while(this._tipContainer.numChildren > 0)
         {
            this._tipContainer.removeChildAt(0);
         }
      }
      
      private function showTip(param1:DisplayObject, param2:Boolean = false, param3:Number = 0.3) : void
      {
         if(!param2 && this._isPlaying)
         {
            return;
         }
         if(this._tipContainer.parent && this._isPlaying)
         {
            TweenMax.killChildTweensOf(this._tipContainer.parent);
         }
         this._isPlaying = true;
         this._duration = param3;
         var _loc4_:int = (StageReferance.stageHeight - param1.height) / 2 - 10;
         TweenMax.fromTo(param1,0.3,{
            "y":StageReferance.stageHeight / 2 + 20,
            "alpha":0,
            "ease":Quint.easeIn,
            "onComplete":this.onTipToCenter,
            "onCompleteParams":[param1]
         },{
            "y":_loc4_,
            "alpha":1
         });
         LayerManager.Instance.addToLayer(param1,LayerManager.STAGE_DYANMIC_LAYER,false,0,false);
      }
      
      public function show(param1:String, param2:int = 0, param3:Boolean = false, param4:Number = 0.3) : void
      {
         var _loc5_:DisplayObject = null;
         if(!param3 && this._isPlaying)
         {
            return;
         }
         this._tipString = param1;
         switch(param2)
         {
            case 1:
               _loc5_ = this.setGhostPropContent(param1);
               break;
            case 2:
               _loc5_ = this.setFullPropContent(param1);
               break;
            case 3:
               _loc5_ = this.setAutoUsePropContent(param1);
               break;
            default:
               _loc5_ = this.setContent(param1);
         }
         this._currentType = param2;
         this.showTip(_loc5_,param3,param4);
      }
      
      private function onTipToCenter(param1:DisplayObject) : void
      {
         TweenMax.to(param1,this._duration,{
            "alpha":0,
            "ease":Quint.easeOut,
            "onComplete":this.hide,
            "onCompleteParams":[param1],
            "delay":1.2
         });
      }
      
      public function kill() : void
      {
         this._isPlaying = false;
         if(this._tipContainer.parent)
         {
            this._tipContainer.parent.removeChild(this._tipContainer);
         }
         TweenMax.killTweensOf(this._tipContainer);
      }
      
      public function hide(param1:DisplayObject) : void
      {
         this._isPlaying = false;
         this._tipString = null;
         if(param1.parent)
         {
            param1.parent.removeChild(param1);
         }
         TweenMax.killTweensOf(param1);
      }
   }
}

import com.pickgliss.ui.ComponentFactory;
import com.pickgliss.ui.text.FilterFrameText;
import ddt.data.goods.ItemTemplateInfo;
import ddt.manager.ItemManager;
import ddt.manager.LanguageMgr;
import flash.display.Sprite;

class EmptyGridMsgHolder extends Sprite
{
    
   
   private var _textField:FilterFrameText;
   
   private var _item:PropHolder;
   
   function EmptyGridMsgHolder()
   {
      super();
      mouseEnabled = false;
      mouseChildren = false;
      this._textField = ComponentFactory.Instance.creatComponentByStylename("MessageTip.TextField");
      this._textField.x = 0;
      this._textField.text = LanguageMgr.GetTranslation("tank.MessageTip.EmptyGrid");
      addChild(this._textField);
      this._item = new PropHolder();
      addChild(this._item);
   }
   
   public function setContent(param1:String) : void
   {
      var _loc2_:ItemTemplateInfo = ItemManager.Instance.getTemplateById(int(param1));
      this._item.setInfo(_loc2_);
      this._item.x = this._textField.x + this._textField.width - 4;
   }
}

import com.pickgliss.ui.ComponentFactory;
import com.pickgliss.ui.text.FilterFrameText;
import ddt.data.goods.ItemTemplateInfo;
import ddt.manager.ItemManager;
import ddt.manager.LanguageMgr;
import flash.display.Sprite;
import game.GameManager;
import game.model.Living;

class PropMessageHolder extends Sprite
{
    
   
   private var _head:HeadHolder;
   
   private var _textField:FilterFrameText;
   
   private var _item:PropHolder;
   
   function PropMessageHolder()
   {
      super();
      mouseEnabled = false;
      mouseChildren = false;
      this._head = new HeadHolder();
      addChild(this._head);
      this._textField = ComponentFactory.Instance.creatComponentByStylename("MessageTip.TextField");
      this._textField.text = LanguageMgr.GetTranslation("tank.MessageTip.GhostProp");
      addChild(this._textField);
      this._item = new PropHolder();
      addChild(this._item);
   }
   
   public function setContent(param1:String) : void
   {
      var _loc2_:Array = param1.split("|");
      var _loc3_:Living = GameManager.Instance.Current.findLiving(_loc2_[0]);
      this._head.setInfo(_loc3_);
      var _loc4_:ItemTemplateInfo = ItemManager.Instance.getTemplateById(_loc2_[1]);
      this._item.setInfo(_loc4_);
      this._textField.x = this._head.width - 3;
      this._item.x = this._textField.x + this._textField.width - 4;
   }
}

import com.pickgliss.ui.ComponentFactory;
import com.pickgliss.ui.text.FilterFrameText;
import ddt.data.goods.ItemTemplateInfo;
import ddt.manager.ItemManager;
import ddt.manager.LanguageMgr;
import flash.display.Sprite;
import game.GameManager;
import game.model.Living;

class AutoUsePropMessage extends Sprite
{
    
   
   private var _head:HeadHolder;
   
   private var _textField:FilterFrameText;
   
   private var _item:PropHolder;
   
   function AutoUsePropMessage()
   {
      super();
      mouseEnabled = false;
      mouseChildren = false;
      this._head = new HeadHolder(false);
      addChild(this._head);
      this._textField = ComponentFactory.Instance.creatComponentByStylename("MessageTip.TextField");
      addChild(this._textField);
      this._item = new PropHolder();
      addChild(this._item);
   }
   
   public function setContent(param1:String) : void
   {
      var _loc2_:Living = null;
      _loc2_ = GameManager.Instance.Current.findLiving(int(param1));
      this._head.setInfo(_loc2_);
      var _loc3_:ItemTemplateInfo = ItemManager.Instance.getTemplateById(10029);
      this._item.setInfo(_loc3_);
      this._textField.x = this._head.width - 3;
      this._textField.text = _loc2_.name + LanguageMgr.GetTranslation("tank.MessageTip.AutoGuide");
      this._item.x = this._textField.x + this._textField.width - 4;
   }
}

import bagAndInfo.cell.BaseCell;
import com.pickgliss.ui.ComponentFactory;
import com.pickgliss.ui.text.FilterFrameText;
import ddt.data.goods.ItemTemplateInfo;
import flash.display.DisplayObject;
import flash.display.Sprite;

class PropHolder extends Sprite
{
    
   
   private var _itemCell:BaseCell;
   
   private var _fore:DisplayObject;
   
   private var _nameField:FilterFrameText;
   
   function PropHolder()
   {
      super();
      this._itemCell = new BaseCell(ComponentFactory.Instance.creatBitmap("asset.game.smallplayer.back"),null,false,false);
      addChild(this._itemCell);
      this._fore = ComponentFactory.Instance.creatBitmap("asset.game.smallplayer.fore");
      this._fore.y = 1;
      this._fore.x = 1;
      addChild(this._fore);
      this._nameField = ComponentFactory.Instance.creatComponentByStylename("MessageTip.Prop.TextField");
      addChild(this._nameField);
   }
   
   public function setInfo(param1:ItemTemplateInfo) : void
   {
      this._nameField.text = param1.Name;
      this._itemCell.x = this._nameField.x + this._nameField.textWidth + 4;
      this._fore.x = this._itemCell.x + 1;
      this._itemCell.info = param1;
   }
}

import com.pickgliss.ui.ComponentFactory;
import com.pickgliss.ui.core.Disposeable;
import com.pickgliss.ui.text.FilterFrameText;
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Shape;
import flash.display.Sprite;
import flash.filters.ColorMatrixFilter;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import game.model.Living;

class HeadHolder extends Sprite implements Disposeable
{
    
   
   private var _back:DisplayObject;
   
   private var _fore:DisplayObject;
   
   private var _headShape:Shape;
   
   private var _buff:BitmapData;
   
   private var _drawRect:Rectangle;
   
   private var _drawMatrix:Matrix;
   
   private var _nameField:FilterFrameText;
   
   function HeadHolder(param1:Boolean = true)
   {
      this._drawRect = new Rectangle(0,0,36,36);
      this._drawMatrix = new Matrix();
      super();
      this._back = ComponentFactory.Instance.creatBitmap("asset.game.smallplayer.back");
      addChild(this._back);
      this._buff = new BitmapData(36,36,true,0);
      this._headShape = new Shape();
      var _loc2_:Graphics = this._headShape.graphics;
      _loc2_.beginBitmapFill(this._buff);
      _loc2_.drawRect(0,0,36,36);
      _loc2_.endFill();
      if(param1)
      {
         this._headShape.filters = [new ColorMatrixFilter([0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0.3086,0.6094,0.082,0,0,0,0,0,1,0])];
      }
      addChild(this._headShape);
      this._fore = ComponentFactory.Instance.creatBitmap("asset.game.smallplayer.fore");
      this._fore.y = 1;
      this._fore.x = 1;
      addChild(this._fore);
      this._nameField = ComponentFactory.Instance.creatComponentByStylename("MessageTip.GhostProp.NameField");
      addChild(this._nameField);
   }
   
   public function setInfo(param1:Living) : void
   {
      this._buff.fillRect(this._drawRect,0);
      var _loc2_:Rectangle = this.getHeadRect(param1);
      this._drawMatrix.identity();
      this._drawMatrix.scale(this._buff.width / _loc2_.width,this._buff.height / _loc2_.height);
      this._drawMatrix.translate(-_loc2_.x * this._drawMatrix.a + 4,-_loc2_.y * this._drawMatrix.d + 6);
      this._buff.draw(param1.character.characterBitmapdata,this._drawMatrix);
      if(param1.playerInfo != null)
      {
         this._nameField.text = param1.playerInfo.NickName;
      }
      else
      {
         this._nameField.text = param1.name;
      }
      this._nameField.setFrame(param1.team);
   }
   
   private function getHeadRect(param1:Living) : Rectangle
   {
      if(param1.playerInfo.getShowSuits() && param1.playerInfo.getSuitsType() == 1)
      {
         return new Rectangle(21,12,167,165);
      }
      return new Rectangle(16,58,170,170);
   }
   
   public function hide() : void
   {
   }
   
   public function dispose() : void
   {
   }
}
