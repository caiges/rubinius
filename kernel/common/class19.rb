# -*- encoding: us-ascii -*-

class Class

  def initialize(sclass=Object, name=nil, under=nil)
    raise TypeError, "already initialized class" if @instance_type

    set_superclass sclass

    # Things (rails) depend on the fact that a normal class is in the constant
    # table and have a name BEFORE inherited is run.
    set_name_if_necessary name, under if name and under
    under.const_set name, self if under

    if sclass
      Rubinius.privately do
        sclass.inherited self
      end
    end
    super()
  end

  ##
  # Returns the Class object that this Class inherits from. Included Modules
  # are not considered for this purpose.

  def superclass
    cls = direct_superclass
    unless cls
      return nil if self == BasicObject
      raise TypeError, "uninitialized class"
    end

    while cls and cls.kind_of? Rubinius::IncludedModule
      cls = cls.direct_superclass
    end

    return cls
  end
end
