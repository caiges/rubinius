class Module
  
  def self.new(&prc)
    mod = allocate
    mod.module_eval(&prc) if block_given?
    mod
  end

  def to_s
    if name
      name.to_s
    else
      super()
    end
  end

  def module_exec(*args, &prc)
    instance_exec(*args, &prc)
  end
  alias_method :class_exec, :module_exec

  def module_eval(string = nil, filename = "(eval)", lineno = 1, &prc)
    instance_eval(string, filename, lineno, &prc)
  end
  alias_method :class_eval, :module_eval

  def instance_method(name)
    name = name.to_sym
    cur  = self
    while cur
      cm = cur.methods[name]
      return UnboundMethod.new(cur, cm) if cm
      cur = cur.direct_superclass
    end
    thing = self.kind_of?(Class) ? "class" : "module"
    raise NameError, "undefined method `#{name}' for #{thing} #{self}"
  end

  def const_defined?(name)
    name = name.to_s
    hierarchy = name.split('::')
    hierarchy.shift if hierarchy.first == ""
    hierarchy.shift if hierarchy.first == "Object"
    const = self
    until hierarchy.empty?
      const = const.constants[hierarchy.shift.to_sym]
      return false unless const
    end
    return true
  end
end
