package com.pickgliss.ui.controls.alert
{
	import com.pickgliss.geom.InnerRectangle;
	import com.pickgliss.ui.AlertManager;
	import com.pickgliss.ui.ComponentFactory;
	import com.pickgliss.ui.controls.SelectedCheckButton;
	import com.pickgliss.ui.core.Component;
	import com.pickgliss.ui.vo.AlertInfo;
	import com.pickgliss.utils.ClassUtils;
	import com.pickgliss.utils.DisplayUtils;
	import com.pickgliss.utils.ObjectUtils;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	public class SimpleAlert extends BaseAlerFrame
	{
		
		public static const P_frameInnerRect:String = "frameInnerRect";
		
		public static const P_frameMiniH:String = "frameMiniH";
		
		public static const P_frameMiniW:String = "frameMiniW";
		
		public static const P_textField:String = "textFieldStyle";
		
		
		protected var _frameMiniH:int = -2.147483648E9;
		
		protected var _frameMiniW:int = -2.147483648E9;
		
		protected var _textField:TextField;
		
		protected var _textFieldStyle:String;
		
		private var _frameInnerRect:InnerRectangle;
		
		private var _frameInnerRectString:String;
		
		//private var _selectedBandBtn:SelectedCheckButton;
		
		//private var _selectedBtn:SelectedCheckButton;
		
		//private var _back:MovieClip;
		
		protected var _seleContent:Sprite;
		
		public function SimpleAlert()
		{
			super();
		}
		
		override public function dispose() : void
		{
			if(this._textField)
			{
				ObjectUtils.disposeObject(this._textField);
			}
			this._textField = null;
			this._frameInnerRect = null;
			while(numChildren)
			{
				ObjectUtils.disposeObject(getChildAt(0));
			}
			super.dispose();
		}
		
		override public function set info(param1:AlertInfo) : void
		{
			super.info = param1;
			onPropertiesChanged(P_info);
			this._seleContent = new Sprite();
			addToContent(this._seleContent);
			_isBand = false;
			this._seleContent.x = this.width / 2 - this._seleContent.width / 2 - this._seleContent.parent.x;
			if(_info.selectBtnY != 0)
			{
				this._seleContent.y = _info.selectBtnY;
			}
			else
			{
				this._seleContent.y = this._textField.height + this._textField.y - 95;
			}
		}
		
		public function set frameInnerRectString(param1:String) : void
		{
			if(this._frameInnerRectString == param1)
			{
				return;
			}
			this._frameInnerRectString = param1;
			this._frameInnerRect = ClassUtils.CreatInstance(ClassUtils.INNERRECTANGLE,ComponentFactory.parasArgs(this._frameInnerRectString));
			onPropertiesChanged(P_frameInnerRect);
		}
		
		public function set frameMiniH(param1:int) : void
		{
			if(this._frameMiniH == param1)
			{
				return;
			}
			this._frameMiniH = param1;
			onPropertiesChanged(P_frameMiniH);
		}
		
		public function set frameMiniW(param1:int) : void
		{
			if(this._frameMiniW == param1)
			{
				return;
			}
			this._frameMiniW = param1;
			onPropertiesChanged(P_frameMiniW);
		}
		
		public function set textStyle(param1:String) : void
		{
			if(this._textFieldStyle == param1)
			{
				return;
			}
			if(this._textField)
			{
				ObjectUtils.disposeObject(this._textField);
			}
			this._textFieldStyle = param1;
			this._textField = ComponentFactory.Instance.creat(this._textFieldStyle);
			onPropertiesChanged(P_textField);
		}
		
		override protected function addChildren() : void
		{
			super.addChildren();
			if(this._textField)
			{
				addChild(this._textField);
			}
		}
		
		protected function layoutFrameRect() : void
		{
			var _loc1_:Rectangle = null;
			_loc1_ = this._frameInnerRect.getInnerRect(this._textField.width,this._textField.height);
			if(_loc1_.width > this._frameMiniW)
			{
				this._textField.x = this._frameInnerRect.para1;
				_width = _loc1_.width;
			}
			else
			{
				this._textField.x = this._frameInnerRect.para1 + (this._frameMiniW - _loc1_.width) / 2;
				_width = this._frameMiniW;
			}
			if(_loc1_.height > this._frameMiniH)
			{
				this._textField.y = this._frameInnerRect.para3;
				_height = _loc1_.height;
			}
			else
			{
				this._textField.y = this._frameInnerRect.para3 + (this._frameMiniH - _loc1_.height) / 2;
				_height = this._frameMiniH;
			}
		}
		
		override protected function onProppertiesUpdate() : void
		{
			if(_changedPropeties[P_info])
			{
				this.updateMsg();
				if(this._frameInnerRect)
				{
					this.layoutFrameRect();
					_changedPropeties[Component.P_width] = true;
					_changedPropeties[Component.P_height] = true;
				}
			}
			super.onProppertiesUpdate();
		}
		
		protected function updateMsg() : void
		{
			this._textField.autoSize = TextFieldAutoSize.LEFT;
			if(_info.mutiline)
			{
				this._textField.multiline = true;
				if(!info.enableHtml)
				{
					this._textField.wordWrap = true;
				}
				if(_info.textShowWidth > 0)
				{
					this._textField.width = _info.textShowWidth;
				}
				else
				{
					this._textField.width = DisplayUtils.getTextFieldMaxLineWidth(String(_info.data),this._textField.defaultTextFormat,info.enableHtml);
				}
			}
			if(_info.enableHtml)
			{
				this._textField.htmlText = String(_info.data);
			}
			else
			{
				this._textField.text = String(_info.data);
			}
		}
	}
}
