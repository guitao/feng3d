package me.feng3d.fagal.vertex.particle
{
	import me.feng3d.core.register.Register;
	import me.feng3d.fagal.methods.FagalVertexMethod;

	/**
	 * 粒子颜色节点顶点渲染程序
	 * @author warden_feng 2015-1-20
	 */
	public class V_ParticleColorGlobal extends FagalVertexMethod
	{
		[Register(regName = "particleStartColorMultiplier_vc_vector", regType = "in", description = "粒子颜色乘数因子起始值，用于计算粒子颜色乘数因子")]
		public var startMultiplierValue:Register;

		[Register(regName = "particleDeltaColorMultiplier_vc_vector", regType = "in", description = "粒子颜色乘数因子增量值，用于计算粒子颜色乘数因子")]
		public var deltaMultiplierValue:Register;

		[Register(regName = "particleStartColorOffset_vc_vector", regType = "in", description = "粒子颜色偏移起始值，用于计算粒子颜色偏移值")]
		public var startOffsetValue:Register;

		[Register(regName = "particleDeltaColorOffset_vc_vector", regType = "in", description = "粒子颜色偏移增量值，用于计算粒子颜色偏移值")]
		public var deltaOffsetValue:Register;

		[Register(regName = "inCycleTime_vt_4", regType = "in", description = "粒子周期内时间临时寄存器")]
		public var inCycleTimeTemp:Register;

		[Register(regName = "particleColorMultiplier_vt_4", regType = "in", description = "粒子颜色乘数因子，用于乘以纹理上的颜色值")]
		public var colorMulTarget:Register;

		[Register(regName = "particleColorOffset_vt_4", regType = "in", description = "粒子颜色偏移值，在片段渲染的最终颜色值上偏移")]
		public var colorAddTarget:Register;

		override public function runFunc():void
		{
			var temp:Register = getFreeTemp();

//			if (animationRegisterCache.needFragmentAnimation) {
//				var temp:ShaderRegisterElement = animationRegisterCache.getFreeVertexVectorTemp();

//				if (_usesCycle) {
//					var cycleConst:ShaderRegisterElement = animationRegisterCache.getFreeVertexConstant();
//					animationRegisterCache.setRegisterIndex(this, CYCLE_INDEX, cycleConst.index);
//					
//					animationRegisterCache.addVertexTempUsages(temp, 1);
//					var sin:ShaderRegisterElement = animationRegisterCache.getFreeVertexSingleTemp();
//					animationRegisterCache.removeVertexTempUsage(temp);
//					
//					code += "mul " + sin + "," + animationRegisterCache.vertexTime + "," + cycleConst + ".x\n";
//					
//					if (_usesPhase)
//						code += "add " + sin + "," + sin + "," + cycleConst + ".y\n";
//					
//					code += "sin " + sin + "," + sin + "\n";
//				}

//				if (_usesMultiplier) {
//					var startMultiplierValue:ShaderRegisterElement = (_mode == ParticlePropertiesMode.GLOBAL)? animationRegisterCache.getFreeVertexConstant() : animationRegisterCache.getFreeVertexAttribute();
//					var deltaMultiplierValue:ShaderRegisterElement = (_mode == ParticlePropertiesMode.GLOBAL)? animationRegisterCache.getFreeVertexConstant() : animationRegisterCache.getFreeVertexAttribute();
//					
//					animationRegisterCache.setRegisterIndex(this, START_MULTIPLIER_INDEX, startMultiplierValue.index);
//					animationRegisterCache.setRegisterIndex(this, DELTA_MULTIPLIER_INDEX, deltaMultiplierValue.index);

			mul(temp, deltaMultiplierValue, inCycleTimeTemp.y);
			add(temp, temp, startMultiplierValue);
			mul(colorMulTarget, temp, colorMulTarget);
//				}

//				if (_usesOffset) {
//					var startOffsetValue:ShaderRegisterElement = (_mode == ParticlePropertiesMode.LOCAL_STATIC)? animationRegisterCache.getFreeVertexAttribute() : animationRegisterCache.getFreeVertexConstant();
//					var deltaOffsetValue:ShaderRegisterElement = (_mode == ParticlePropertiesMode.LOCAL_STATIC)? animationRegisterCache.getFreeVertexAttribute() : animationRegisterCache.getFreeVertexConstant();
//					
//					animationRegisterCache.setRegisterIndex(this, START_OFFSET_INDEX, startOffsetValue.index);
//					animationRegisterCache.setRegisterIndex(this, DELTA_OFFSET_INDEX, deltaOffsetValue.index);

			mul(temp, deltaOffsetValue, inCycleTimeTemp.y);
			add(temp, temp, startOffsetValue);
			add(colorAddTarget, temp, colorAddTarget);
//				}
//			}
		}
	}
}