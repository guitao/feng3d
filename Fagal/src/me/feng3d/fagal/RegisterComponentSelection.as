package me.feng3d.fagal
{
	import me.feng3d.core.register.Register;

	/**
	 * 寄存器单元组合
	 * @author warden_feng 2014-10-22
	 */
	public class RegisterComponentSelection implements IField
	{
		private var _register:String;
		private var _regType:String;

		/**
		 * 创建一个寄存器单元组合
		 * @param register 		寄存器类型
		 * @param prop 			组合名称
		 */
		public function RegisterComponentSelection(register:Register, prop:String)
		{
			_register = register + ((prop.length > 0) ? ("." + prop) : "");
			_regType = register.regType;

			// Validate components
			if (prop.length > 4)
				throw new Error("无效寄存器分量: " + _register);
			for (var i:int = 0; i < prop.length; i++)
			{
				if (!RegisterComponent.valid(prop.substr(i, 1)))
					throw new Error("无效寄存器分量: " + _register);
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get regType():String
		{
			return _regType;
		}

		/**
		 * @inheritDoc
		 */
		public function toString():String
		{
			return _register;
		}

		/**
		 * @inheritDoc
		 */
		public function get desc():String
		{
			return toString();
		}
	}
}
