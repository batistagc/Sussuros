final class MenuNode<Value> {
    var value: Value
    var select: Int
    var parent: MenuNode?
    private(set) var children: [MenuNode]
    
    init(_ value: Value) {
        self.value = value
        select = 0
        children = []
    }
    
    func add(child: MenuNode) {
        children.append(child)
        child.parent = self
    }
}
